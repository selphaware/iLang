#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    size_t n_rows;
    size_t n_cols;
    char **col_names;   // [n_cols] column headers
    char ***data;       // [n_rows][n_cols] cells as heap-allocated strings
} DataFrame;

static void free_dataframe(DataFrame *df) {
    if (!df) return;
    if (df->col_names) {
        for (size_t j = 0; j < df->n_cols; ++j) free(df->col_names[j]);
        free(df->col_names);
    }
    if (df->data) {
        for (size_t i = 0; i < df->n_rows; ++i) {
            if (df->data[i]) {
                for (size_t j = 0; j < df->n_cols; ++j) free(df->data[i][j]);
                free(df->data[i]);
            }
        }
        free(df->data);
    }
    free(df);
}

static char *xstrdup(const char *s) {
    if (!s) return NULL;
    size_t n = strlen(s) + 1;
    char *p = (char *)malloc(n);
    if (p) memcpy(p, s, n);
    return p;
}

static int append_char(char **buf, size_t *len, size_t *cap, char c) {
    if (*len + 1 >= *cap) {
        size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
        char *nbuf = (char *)realloc(*buf, ncap);
        if (!nbuf) return 0;
        *buf = nbuf;
        *cap = ncap;
    }
    (*buf)[(*len)++] = c;
    return 1;
}

static int push_field(char ****fields, size_t *count, size_t *cap, char *buf, size_t len) {
    if (*count + 1 > *cap) {
        size_t ncap = (*cap == 0 ? 8 : (*cap * 2));
        char ***narr = (char ***)realloc(*fields, ncap * sizeof(char **));
        if (!narr) return 0;
        *fields = narr;
        *cap = ncap;
    }
    char *s = (char *)malloc(len + 1);
    if (!s) return 0;
    if (len) memcpy(s, buf, len);
    s[len] = '\0';
    (*fields)[(*count)++] = (char **)s; // temporarily store as char**-typed slot; cast back later
    return 1;
}

// Reads one CSV record (RFC4180-ish), returns 1 if a record was read, 0 on EOF, -1 on error.
// out_fields will be an array of char* of length out_count. Caller must free each string and the array.
static int parse_record(FILE *f, char delimiter, char ***out_fields, size_t *out_count) {
    char *buf = NULL;
    size_t blen = 0, bcap = 0;

    char ***fields_tmp = NULL; // store strings in this array, but typed as char***
    size_t fcount = 0, fcap = 0;

    int in_quotes = 0;
    int started = 0;

    for (;;) {
        int ch = fgetc(f);
        if (ch == EOF) {
            if (!started && blen == 0 && fcount == 0) {
                // true EOF, no data
                free(buf);
                free(fields_tmp);
                return 0;
            }
            // finalize last field and record at EOF
            if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
            break;
        }

        if (!in_quotes) {
            if (ch == delimiter) {
                if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
                blen = 0;
                started = 1;
                continue;
            }
            if (ch == '\r' || ch == '\n') {
                // end of record
                if (ch == '\r') {
                    int c2 = fgetc(f);
                    if (c2 != '\n' && c2 != EOF) ungetc(c2, f);
                }
                // handle blank line: if nothing read and no fields, skip and continue reading
                if (!started && blen == 0 && fcount == 0) {
                    continue;
                }
                if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
                break;
            }
            if (ch == '"' && blen == 0 && !started) {
                // starting a quoted field at the beginning of field
                in_quotes = 1;
                started = 1;
                continue;
            }
            // regular character
            if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
            started = 1;
        } else {
            // inside quotes
            if (ch == '"') {
                int c2 = fgetc(f);
                if (c2 == '"') {
                    // escaped quote
                    if (!append_char(&buf, &blen, &bcap, '"')) { free(buf); free(fields_tmp); return -1; }
                } else {
                    // end of quoted field
                    in_quotes = 0;
                    if (c2 != EOF) {
                        // treat next char under non-quoted rules
                        if (c2 == delimiter) {
                            if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
                            blen = 0;
                            started = 1;
                            continue;
                        } else if (c2 == '\r' || c2 == '\n') {
                            if (c2 == '\r') {
                                int c3 = fgetc(f);
                                if (c3 != '\n' && c3 != EOF) ungetc(c3, f);
                            }
                            if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
                            break;
                        } else {
                            // According to RFC, spaces may follow closing quote before delimiter/EOL; accept any chars
                            if (!append_char(&buf, &blen, &bcap, (char)c2)) { free(buf); free(fields_tmp); return -1; }
                            started = 1;
                        }
                    } else {
                        // EOF after closing quote: finalize field
                        if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
                        break;
                    }
                }
            } else {
                // regular char inside quotes (including newlines)
                if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
            }
        }
    }

    free(buf);

    // Convert fields_tmp (char*** with char* payload) into char** array
    char **fields = (char **)malloc(fcount * sizeof(char *));
    if (!fields) { // free all strings
        for (size_t i = 0; i < fcount; ++i) free((char *)fields_tmp[i]);
        free(fields_tmp);
        return -1;
    }
    for (size_t i = 0; i < fcount; ++i) {
        fields[i] = (char *)fields_tmp[i];
    }
    free(fields_tmp);

    *out_fields = fields;
    *out_count = fcount;
    return 1;
}

static void strip_utf8_bom(char *s) {
    if (!s) return;
    unsigned char *u = (unsigned char *)s;
    if (u[0] == 0xEF && u[1] == 0xBB && u[2] == 0xBF) {
        size_t n = strlen(s + 3);
        memmove(s, s + 3, n + 1);
    }
}

static char *empty_strdup(void) {
    char *p = (char *)malloc(1);
    if (p) p[0] = '\0';
    return p;
}

DataFrame *read_csv(const char *filename, char delimiter) {
    FILE *f = fopen(filename, "rb");
    if (!f) return NULL;

    // Read header
    char **header = NULL;
    size_t n_cols = 0;
    int rc = parse_record(f, delimiter, &header, &n_cols);
    if (rc <= 0 || n_cols == 0) { // no header or error
        if (rc > 0) {
            for (size_t i = 0; i < n_cols; ++i) free(header[i]);
            free(header);
        }
        fclose(f);
        return NULL;
    }
    // Strip BOM from first header if present
    if (n_cols > 0) strip_utf8_bom(header[0]);

    // Prepare DataFrame
    DataFrame *df = (DataFrame *)calloc(1, sizeof(DataFrame));
    if (!df) { for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
    df->n_cols = n_cols;
    df->col_names = (char **)malloc(n_cols * sizeof(char *));
    if (!df->col_names) { free_dataframe(df); for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
    for (size_t j = 0; j < n_cols; ++j) {
        df->col_names[j] = header[j]; // take ownership
    }
    free(header);

    // Read rows
    size_t rows_cap = 0;
    df->data = NULL;
    df->n_rows = 0;

    for (;;) {
        char **fields = NULL;
        size_t fcount = 0;
        int rr = parse_record(f, delimiter, &fields, &fcount);
        if (rr == 0) break;          // EOF
        if (rr < 0) { free_dataframe(df); fclose(f); return NULL; }

        // Skip completely empty records (e.g., blank lines)
        int all_empty = 1;
        for (size_t i = 0; i < fcount; ++i) {
            if (fields[i][0] != '\0') { all_empty = 0; break; }
        }
        if (fcount == 0 || all_empty) {
            for (size_t i = 0; i < fcount; ++i) free(fields[i]);
            free(fields);
            continue;
        }

        if (df->n_rows + 1 > rows_cap) {
            size_t ncap = (rows_cap == 0 ? 64 : rows_cap * 2);
            char ***ndata = (char ***)realloc(df->data, ncap * sizeof(char **));
            if (!ndata) {
                for (size_t i = 0; i < fcount; ++i) free(fields[i]);
                free(fields);
                free_dataframe(df);
                fclose(f);
                return NULL;
            }
            df->data = ndata;
            rows_cap = ncap;
        }

        char **row = (char **)malloc(df->n_cols * sizeof(char *));
        if (!row) {
            for (size_t i = 0; i < fcount; ++i) free(fields[i]);
            free(fields);
            free_dataframe(df);
            fclose(f);
            return NULL;
        }

        // Fill row cells, pad or truncate to n_cols
        for (size_t j = 0; j < df->n_cols; ++j) {
            if (j < fcount) {
                row[j] = fields[j]; // take ownership
            } else {
                row[j] = empty_strdup();
                if (!row[j]) {
                    for (size_t k = 0; k < j; ++k) free(row[k]);
                    free(row);
                    for (size_t i = 0; i < fcount; ++i) free(fields[i]);
                    free(fields);
                    free_dataframe(df);
                    fclose(f);
                    return NULL;
                }
            }
        }
        // Free any extra fields beyond n_cols
        for (size_t j = df->n_cols; j < fcount; ++j) free(fields[j]);
        free(fields);

        df->data[df->n_rows++] = row;
    }

    fclose(f);
    return df;
}

/* Example usage:*/

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <csv_filename>\n", argv[0]);
        return 1;
    }

    const char *filename = argv[1];
    DataFrame *df = read_csv(filename, ',');
    if (!df) {
        fprintf(stderr, "Failed to read CSV: %s\n", filename);
        return 1;
    }

    printf("File: %s\n", filename);
    printf("Rows: %zu, Cols: %zu\n", df->n_rows, df->n_cols);

    // Print headers
    printf("Headers:\n");
    for (size_t j = 0; j < df->n_cols; ++j)
        printf("  [%zu] %s\n", j, df->col_names[j]);
    printf("\n");

    // Print all rows
    printf("Data:\n");
    for (size_t i = 0; i < df->n_rows; ++i) {
        printf("Row %zu: ", i);
        for (size_t j = 0; j < df->n_cols; ++j) {
            printf("%s", df->data[i][j]);
            if (j < df->n_cols - 1) printf(", ");
        }
        printf("\n");
    }

    free_dataframe(df);
    return 0;
}
