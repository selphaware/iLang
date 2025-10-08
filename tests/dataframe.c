#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  size_t n_rows, n_cols;
  char **col_names;      // [n_cols]
  char ***data;          // [n_rows][n_cols], each cell heap-allocated
} DataFrame;

static char *xstrdup(const char *s) {
  size_t len = strlen(s);
  char *p = (char *)malloc(len + 1);
  if (!p) return NULL;
  memcpy(p, s, len + 1);
  return p;
}

static void free_fields(char **fields, size_t count) {
  if (!fields) return;
  for (size_t i = 0; i < count; i++) {
    free(fields[i]);
  }
  free(fields);
}

static int append_char(char **buf, size_t *len, size_t *cap, char ch) {
  if (*len + 1 >= *cap) {
    size_t ncap = (*cap == 0) ? 16 : (*cap * 2);
    char *nbuf = (char *)realloc(*buf, ncap);
    if (!nbuf) return 0;
    *buf = nbuf;
    *cap = ncap;
  }
  (*buf)[(*len)++] = ch;
  return 1;
}

static int push_field(char ***fields, size_t *flen, size_t *fcap,
                      char **buf, size_t *blen, size_t *bcap) {
  if (!append_char(buf, blen, bcap, '\0')) return 0;
  char *s = (char *)malloc(*blen);
  if (!s) return 0;
  memcpy(s, *buf, *blen);
  *blen = 0;

  if (*flen >= *fcap) {
    size_t ncap = (*fcap == 0) ? 8 : (*fcap * 2);
    char **nf = (char **)realloc(*fields, ncap * sizeof(char *));
    if (!nf) {
      free(s);
      return 0;
    }
    *fields = nf;
    *fcap = ncap;
  }
  (*fields)[(*flen)++] = s;
  return 1;
}

// 1=ok,0=eof,-1=err
static int parse_record(FILE *f, char delimiter, char ***out_fields, size_t *out_count) {
  if (!out_fields || !out_count) return -1;

  // Skip blank lines (\n, \r, \r\n)
  for (;;) {
    int c = fgetc(f);
    if (c == EOF) return 0;
    if (c == '\r') {
      int d = fgetc(f);
      if (d != '\n' && d != EOF) ungetc(d, f);
      continue;
    }
    if (c == '\n') continue;
    ungetc(c, f);
    break;
  }

  char **fields = NULL;
  size_t fields_len = 0, fields_cap = 0;

  char *buf = NULL;
  size_t buf_len = 0, buf_cap = 0;

  int in_quotes = 0;
  int start_of_field = 1;

  for (;;) {
    int c = fgetc(f);
    if (c == EOF) {
      if (in_quotes) {
        free_fields(fields, fields_len);
        free(buf);
        return -1;
      }
      if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
        free_fields(fields, fields_len);
        free(buf);
        return -1;
      }
      free(buf);
      *out_fields = fields;
      *out_count = fields_len;
      return 1;
    }

    if (in_quotes) {
      if (c == '"') {
        int next = fgetc(f);
        if (next == '"') {
          if (!append_char(&buf, &buf_len, &buf_cap, '"')) {
            free_fields(fields, fields_len);
            free(buf);
            return -1;
          }
        } else {
          // End of quoted field
          // Allow spaces after closing quote before delimiter/EOL
          while (next == ' ') {
            next = fgetc(f);
          }
          if (next == (unsigned char)delimiter) {
            if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
              free_fields(fields, fields_len);
              free(buf);
              return -1;
            }
            start_of_field = 1;
            in_quotes = 0;
            continue;
          } else if (next == '\r' || next == '\n' || next == EOF) {
            if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
              free_fields(fields, fields_len);
              free(buf);
              return -1;
            }
            if (next == '\r') {
              int nn = fgetc(f);
              if (nn != '\n' && nn != EOF) ungetc(nn, f);
            }
            if (next == EOF) {
              free(buf);
              *out_fields = fields;
              *out_count = fields_len;
              return 1;
            }
            free(buf);
            *out_fields = fields;
            *out_count = fields_len;
            return 1;
          } else {
            // Invalid character after closing quote
            free_fields(fields, fields_len);
            free(buf);
            return -1;
          }
        }
      } else {
        if (!append_char(&buf, &buf_len, &buf_cap, (char)c)) {
          free_fields(fields, fields_len);
          free(buf);
          return -1;
        }
      }
      continue;
    } else {
      // Not in quotes
      if (start_of_field && c == '"') {
        in_quotes = 1;
        start_of_field = 0;
        continue;
      }
      if (c == (unsigned char)delimiter) {
        if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
          free_fields(fields, fields_len);
          free(buf);
          return -1;
        }
        start_of_field = 1;
        continue;
      }
      if (c == '\r' || c == '\n') {
        if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
          free_fields(fields, fields_len);
          free(buf);
          return -1;
        }
        if (c == '\r') {
          int d = fgetc(f);
          if (d != '\n' && d != EOF) ungetc(d, f);
        }
        free(buf);
        *out_fields = fields;
        *out_count = fields_len;
        return 1;
      }
      if (!append_char(&buf, &buf_len, &buf_cap, (char)c)) {
        free_fields(fields, fields_len);
        free(buf);
        return -1;
      }
      start_of_field = 0;
    }
  }
}

static void strip_bom(char *s) {
  if (!s) return;
  if ((unsigned char)s[0] == 0xEF &&
      (unsigned char)s[1] == 0xBB &&
      (unsigned char)s[2] == 0xBF) {
    size_t len = strlen(s);
    memmove(s, s + 3, len - 2);
  }
}

DataFrame *read_csv(const char *filename, char delimiter) {
  FILE *f = fopen(filename, "rb");
  if (!f) return NULL;

  char **headers = NULL;
  size_t hcount = 0;
  int pr = parse_record(f, delimiter, &headers, &hcount);
  if (pr != 1) {
    fclose(f);
    if (headers) free_fields(headers, hcount);
    return NULL;
  }

  if (hcount > 0) {
    strip_bom(headers[0]);
  }

  char ***rows = NULL;
  size_t rows_len = 0, rows_cap = 0;

  for (;;) {
    char **fields = NULL;
    size_t count = 0;
    pr = parse_record(f, delimiter, &fields, &count);
    if (pr == 0) break;         // EOF
    if (pr == -1) {             // parse error
      free_fields(headers, hcount);
      for (size_t r = 0; r < rows_len; r++) {
        free_fields(rows[r], hcount);
      }
      free(rows);
      fclose(f);
      return NULL;
    }

    if (count < hcount) {
      char **nf = (char **)realloc(fields, hcount * sizeof(char *));
      if (!nf) {
        free_fields(fields, count);
        free_fields(headers, hcount);
        for (size_t r = 0; r < rows_len; r++) {
          free_fields(rows[r], hcount);
        }
        free(rows);
        fclose(f);
        return NULL;
      }
      fields = nf;
      for (size_t j = count; j < hcount; j++) {
        fields[j] = xstrdup("");
        if (!fields[j]) {
          for (size_t k = count; k < j; k++) free(fields[k]);
          free_fields(fields, count);
          free_fields(headers, hcount);
          for (size_t r = 0; r < rows_len; r++) {
            free_fields(rows[r], hcount);
          }
          free(rows);
          fclose(f);
          return NULL;
        }
      }
      count = hcount;
    } else if (count > hcount) {
      for (size_t j = hcount; j < count; j++) free(fields[j]);
      char **shrunk = (char **)realloc(fields, hcount * sizeof(char *));
      if (shrunk) fields = shrunk;
      count = hcount;
    }

    if (rows_len == rows_cap) {
      size_t ncap = rows_cap ? (rows_cap * 2) : 8;
      char ***nr = (char ***)realloc(rows, ncap * sizeof(char **));
      if (!nr) {
        free_fields(fields, count);
        free_fields(headers, hcount);
        for (size_t r = 0; r < rows_len; r++) {
          free_fields(rows[r], hcount);
        }
        free(rows);
        fclose(f);
        return NULL;
      }
      rows = nr;
      rows_cap = ncap;
    }
    rows[rows_len++] = fields;
  }

  fclose(f);

  DataFrame *df = (DataFrame *)malloc(sizeof(DataFrame));
  if (!df) {
    free_fields(headers, hcount);
    for (size_t r = 0; r < rows_len; r++) {
      free_fields(rows[r], hcount);
    }
    free(rows);
    return NULL;
  }

  df->n_rows = rows_len;
  df->n_cols = hcount;
  df->col_names = headers;
  df->data = rows;
  return df;
}

static void free_dataframe(DataFrame *df) {
  if (!df) return;
  if (df->col_names) {
    free_fields(df->col_names, df->n_cols);
  }
  if (df->data) {
    for (size_t r = 0; r < df->n_rows; r++) {
      if (df->data[r]) {
        free_fields(df->data[r], df->n_cols);
      }
    }
    free(df->data);
  }
  free(df);
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Usage: %s <csv_filename>\n", argc > 0 ? argv[0] : "prog");
    return 1;
  }

  DataFrame *df = read_csv(argv[1], ',');
  if (!df) {
    printf("Failed to read CSV\n");
    return 1;
  }

  printf("File: %s\n", argv[1]);
  printf("Rows: %zu, Cols: %zu\n", df->n_rows, df->n_cols);

  printf("Headers:\n");
  for (size_t i = 0; i < df->n_cols; i++) {
    printf("  [%zu] %s\n", i, df->col_names[i] ? df->col_names[i] : "");
  }

  printf("Data:\n");
  for (size_t r = 0; r < df->n_rows; r++) {
    for (size_t c = 0; c < df->n_cols; c++) {
      printf("%s", df->data[r][c] ? df->data[r][c] : "");
      if (c + 1 < df->n_cols) printf(", ");
    }
    printf("\n");
  }

  free_dataframe(df);
  return 0;
}
