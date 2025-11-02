#include "df.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

typedef struct {
    int rows;
    int cols;
    char** col_names;
    char*** data;
} DataFrame;

static void* xmalloc(size_t n) {
    return n ? malloc(n) : NULL;
}

static void* xrealloc(void* p, size_t n) {
    return n ? realloc(p, n) : NULL;
}

static char* xstrdup_n(const char* s, size_t n) {
    char* d = (char*)xmalloc(n + 1);
    if (!d) return NULL;
    if (n) memcpy(d, s, n);
    d[n] = '\0';
    return d;
}

static char* xstrdup0(const char* s) {
    size_t n = s ? strlen(s) : 0;
    return xstrdup_n(s ? s : "", n);
}

static void free_row(char** row, int n) {
    if (!row) return;
    int i;
    for (i = 0; i < n; ++i) {
        free(row[i]);
    }
    free(row);
}

static void free_rows(char*** rows, int r, int c) {
    if (!rows) return;
    int i;
    for (i = 0; i < r; ++i) {
        free_row(rows[i], c);
    }
    free(rows);
}

static void df_free_internal(DataFrame* df) {
    if (!df) return;
    if (df->col_names) {
        int i;
        for (i = 0; i < df->cols; ++i) free(df->col_names[i]);
        free(df->col_names);
    }
    if (df->data) {
        free_rows(df->data, df->rows, df->cols);
    }
    free(df);
}

static void trim_inplace(char* s) {
    if (!s) return;
    size_t len = strlen(s);
    size_t start = 0;
    while (start < len && (unsigned char)s[start] <= ' ') start++;
    size_t end = len;
    while (end > start && (unsigned char)s[end - 1] <= ' ') end--;
    if (start > 0) memmove(s, s + start, end - start);
    s[end - start] = '\0';
}

static int read_file_all(const char* path, char** out_buf, size_t* out_len) {
    FILE* f = fopen(path, "rb");
    if (!f) return 5;
    if (fseek(f, 0, SEEK_END) != 0) { fclose(f); return 5; }
    long sz = ftell(f);
    if (sz < 0) { fclose(f); return 5; }
    if (fseek(f, 0, SEEK_SET) != 0) { fclose(f); return 5; }
    size_t n = (size_t)sz;
    char* buf = (char*)xmalloc(n + 1);
    if (!buf) { fclose(f); return 4; }
    size_t rd = fread(buf, 1, n, f);
    fclose(f);
    if (rd != n) { free(buf); return 5; }
    buf[n] = '\0';
    *out_buf = buf;
    *out_len = n;
    return 0;
}

typedef struct {
    char** data;
    int size;
    int cap;
} StrVec;

typedef struct {
    char*** data;
    int size;
    int cap;
} RowVec;

static int strvec_init(StrVec* v) {
    v->data = NULL;
    v->size = 0;
    v->cap = 0;
    return 0;
}

static void strvec_free(StrVec* v) {
    int i;
    for (i = 0; i < v->size; ++i) free(v->data[i]);
    free(v->data);
    v->data = NULL;
    v->size = v->cap = 0;
}

static int strvec_push(StrVec* v, char* s) {
    if (v->size == v->cap) {
        int ncap = v->cap ? v->cap * 2 : 8;
        char** nd = (char**)xrealloc(v->data, (size_t)ncap * sizeof(char*));
        if (!nd) return 4;
        v->data = nd;
        v->cap = ncap;
    }
    v->data[v->size++] = s;
    return 0;
}

static int strvec_detach_to_fixed(StrVec* v, char*** out_arr, int* out_n) {
    int i;
    char** arr = NULL;
    if (v->size > 0) {
        arr = (char**)xmalloc((size_t)v->size * sizeof(char*));
        if (!arr) return 4;
        for (i = 0; i < v->size; ++i) arr[i] = v->data[i];
    }
    free(v->data);
    *out_arr = arr;
    *out_n = v->size;
    v->data = NULL;
    v->size = v->cap = 0;
    return 0;
}

static int rowvec_init(RowVec* v) {
    v->data = NULL;
    v->size = 0;
    v->cap = 0;
    return 0;
}

static void rowvec_free_shallow(RowVec* v) {
    free(v->data);
    v->data = NULL;
    v->size = v->cap = 0;
}

static int rowvec_push(RowVec* v, char** rowptr) {
    if (v->size == v->cap) {
        int ncap = v->cap ? v->cap * 2 : 8;
        char*** nd = (char***)xrealloc(v->data, (size_t)ncap * sizeof(char**));
        if (!nd) return 4;
        v->data = nd;
        v->cap = ncap;
    }
    v->data[v->size++] = rowptr;
    return 0;
}

static int parse_csv_buffer(const char* buf, size_t len, char delimiter, RowVec* out_rows) {
    StrVec fields;
    int rc = strvec_init(&fields);
    if (rc) return rc;
    RowVec rows;
    rowvec_init(&rows);

    size_t i = 0;
    int in_quotes = 0;
    char* field = NULL;
    size_t fsize = 0, fcap = 0;

    #define APPEND_CH(ch) do { \
        if (fsize + 1 > fcap) { \
            size_t ncap = fcap ? fcap * 2 : 32; \
            char* nt = (char*)xrealloc(field, ncap); \
            if (!nt) { rc = 4; goto done; } \
            field = nt; fcap = ncap; \
        } \
        field[fsize++] = (char)(ch); \
    } while(0)

    while (i <= len) {
        int at_end = (i == len);
        char c = at_end ? '\0' : buf[i];
        int is_delim = (!at_end && c == delimiter);
        int is_cr = (!at_end && c == '\r');
        int is_lf = (!at_end && c == '\n');
        if (in_quotes) {
            if (!at_end && c == '"') {
                if (i + 1 < len && buf[i + 1] == '"') {
                    APPEND_CH('"');
                    i += 2;
                    continue;
                } else {
                    in_quotes = 0;
                    i++;
                    continue;
                }
            } else {
                if (!at_end) {
                    APPEND_CH(c);
                    i++;
                    continue;
                } else {
                    /* end of buffer inside quotes: close field */
                }
            }
        } else {
            if (!at_end && c == '"') {
                in_quotes = 1;
                i++;
                continue;
            }
            if (is_delim || is_cr || is_lf || at_end) {
                char* s = xstrdup_n(field ? field : "", fsize);
                if (!s) { rc = 4; goto done; }
                rc = strvec_push(&fields, s);
                if (rc) { free(s); goto done; }
                if (is_cr || is_lf || at_end) {
                    char** rowptr = NULL;
                    int nf = 0;
                    rc = strvec_detach_to_fixed(&fields, &rowptr, &nf);
                    if (rc) goto done;
                    rc = rowvec_push(&rows, rowptr);
                    if (rc) {
                        int k;
                        for (k = 0; k < nf; ++k) free(rowptr[k]);
                        free(rowptr);
                        goto done;
                    }
                }
                fsize = 0;
                i++;
                if (is_cr && i < len && buf[i] == '\n') i++;
                continue;
            } else {
                APPEND_CH(c);
                i++;
                continue;
            }
        }
    }

done:
    free(field);
    strvec_free(&fields);
    if (rc) {
        int r;
        for (r = 0; r < rows.size; ++r) {
            char** row = rows.data[r];
            int j = 0;
            if (row) {
                while (row[j]) { j++; }
                free_row(row, j);
            }
        }
        rowvec_free_shallow(&rows);
        return rc;
    }
    *out_rows = rows;
    return 0;
}

static int normalize_rows(RowVec* parsed, DataFrame** out_df) {
    if (parsed->size <= 0) return 3;
    char** header = parsed->data[0];
    int ncols = 0;
    while (header && header[ncols]) ncols++;
    if (ncols <= 0) return 3;

    int i;
    for (i = 0; i < ncols; ++i) {
        if (header[i]) trim_inplace(header[i]);
    }

    char** colnames = (char**)xmalloc((size_t)ncols * sizeof(char*));
    if (!colnames) return 4;
    for (i = 0; i < ncols; ++i) {
        colnames[i] = xstrdup0(header[i] ? header[i] : "");
        if (!colnames[i]) {
            int k;
            for (k = 0; k <= i; ++k) free(colnames[k]);
            free(colnames);
            return 4;
        }
    }

    int nrows = parsed->size - 1;
    char*** data = NULL;
    if (nrows > 0) {
        data = (char***)xmalloc((size_t)nrows * sizeof(char**));
        if (!data) {
            for (i = 0; i < ncols; ++i) free(colnames[i]);
            free(colnames);
            return 4;
        }
    }

    int r;
    for (r = 0; r < nrows; ++r) {
        char** prow = parsed->data[r + 1];
        int nf = 0;
        while (prow && prow[nf]) nf++;
        char** row = (char**)xmalloc((size_t)ncols * sizeof(char*));
        if (!row) {
            int rr;
            for (rr = 0; rr < r; ++rr) free_row(data[rr], ncols);
            free(data);
            for (i = 0; i < ncols; ++i) free(colnames[i]);
            free(colnames);
            return 4;
        }
        int c;
        for (c = 0; c < ncols; ++c) {
            if (c < nf) {
                if (prow[c]) trim_inplace(prow[c]);
                row[c] = prow[c] ? prow[c] : xstrdup0("");
                if (!row[c] && prow[c] == NULL) {
                    int rr;
                    for (rr = 0; rr <= c; ++rr) free(row[rr]);
                    free(row);
                    int k;
                    for (k = 0; k < r; ++k) free_row(data[k], ncols);
                    free(data);
                    for (k = 0; k < ncols; ++k) free(colnames[k]);
                    free(colnames);
                    return 4;
                }
            } else {
                row[c] = xstrdup0("");
                if (!row[c]) {
                    int rr;
                    for (rr = 0; rr < c; ++rr) free(row[rr]);
                    free(row);
                    int k;
                    for (k = 0; k < r; ++k) free_row(data[k], ncols);
                    free(data);
                    for (k = 0; k < ncols; ++k) free(colnames[k]);
                    free(colnames);
                    return 4;
                }
            }
        }
        int j;
        for (j = 0; j < nf; ++j) {
            if (j >= ncols) free(prow[j]);
        }
        free(prow);
        data[r] = row;
    }

    free(header);
    DataFrame* df = (DataFrame*)xmalloc(sizeof(DataFrame));
    if (!df) {
        int rr;
        for (rr = 0; rr < nrows; ++rr) free_row(data[rr], ncols);
        free(data);
        for (i = 0; i < ncols; ++i) free(colnames[i]);
        free(colnames);
        return 4;
    }
    df->rows = nrows;
    df->cols = ncols;
    df->col_names = colnames;
    df->data = data;
    *out_df = df;
    return 0;
}

/* Load CSV at 'path' with delimiter into an opaque dataframe handle stored in *out_df; return 0 on success, nonzero on error; on error sets *out_df = NULL. */
int df_read_csv(const char* path, char delimiter, void** out_df) {
    if (!out_df || !path) return 2;
    *out_df = NULL;
    if (delimiter == '\0') delimiter = ',';
    char* buf = NULL;
    size_t len = 0;
    int rc = read_file_all(path, &buf, &len);
    if (rc) return rc;
    RowVec parsed;
    rc = parse_csv_buffer(buf, len, delimiter, &parsed);
    free(buf);
    if (rc) return rc;
    DataFrame* df = NULL;
    rc = normalize_rows(&parsed, &df);
    rowvec_free_shallow(&parsed);
    if (rc) {
        if (df) df_free_internal(df);
        return rc;
    }
    *out_df = (void*)df;
    return 0;
}

/* Return row and column counts for the dataframe. */
int df_shape(void* df, int* out_rows, int* out_cols) {
    if (!df || !out_rows || !out_cols) return 2;
    DataFrame* d = (DataFrame*)df;
    *out_rows = d->rows;
    *out_cols = d->cols;
    return 0;
}

/* Lookup a column index by name; return 0 on success, nonzero if not found. */
int df_col_index(void* df, const char* name, int* out_idx) {
    if (!df || !name || !out_idx) return 2;
    DataFrame* d = (DataFrame*)df;
    int i;
    for (i = 0; i < d->cols; ++i) {
        if (strcmp(d->col_names[i], name) == 0) {
            *out_idx = i;
            return 0;
        }
    }
    return 1;
}

/* Write comma-separated column names into out_buf; set out_written to required length (including NUL); return nonzero if out_buf_len is too small. */
int df_columns_csv(void* df, char* out_buf, int out_buf_len, int* out_written) {
    if (!df || !out_written) return 2;
    DataFrame* d = (DataFrame*)df;
    size_t total = 1;
    int i;
    for (i = 0; i < d->cols; ++i) {
        total += strlen(d->col_names[i]);
        if (i + 1 < d->cols) total += 1;
    }
    *out_written = (int)((total <= INT_MAX) ? total : INT_MAX);
    if (!out_buf || out_buf_len <= 0 || (size_t)out_buf_len < total) return 1;
    char* p = out_buf;
    for (i = 0; i < d->cols; ++i) {
        size_t n = strlen(d->col_names[i]);
        if (n) { memcpy(p, d->col_names[i], n); p += n; }
        if (i + 1 < d->cols) { *p++ = ','; }
    }
    *p = '\0';
    return 0;
}

static int validate_col_indices(DataFrame* d, const int* idxs, int n) {
    if (!idxs) return 0;
    int i;
    for (i = 0; i < n; ++i) {
        if (idxs[i] < 0 || idxs[i] >= d->cols) return 2;
    }
    return 0;
}

typedef enum { FOP_NONE = 0, FOP_EQ = 1, FOP_NEQ = 2 } FilterOp;

static int parse_filter(const char* s, char** out_col, FilterOp* out_op, char** out_val) {
    *out_col = NULL;
    *out_val = NULL;
    *out_op = FOP_NONE;
    if (!s || !*s) return 0;
    const char* p = s;
    while (*p && (unsigned char)*p <= ' ') p++;
    const char* col_start = p;
    while (*p && *p != '=' && !(*p == '!' && p[1] == '=')) p++;
    const char* col_end = p;
    FilterOp op = FOP_NONE;
    if (*p == '=' && p[1] == '=') { op = FOP_EQ; p += 2; }
    else if (*p == '!' && p[1] == '=') { op = FOP_NEQ; p += 2; }
    else if (*p == '=') { op = FOP_EQ; p += 1; }
    else {
        return 3;
    }
    while (col_end > col_start && (unsigned char)col_end[-1] <= ' ') col_end--;
    while (*p && (unsigned char)*p <= ' ') p++;
    const char* val_start = p;
    const char* val_end = s + strlen(s);
    while (val_end > val_start && (unsigned char)val_end[-1] <= ' ') val_end--;
    char* col = xstrdup_n(col_start, (size_t)(col_end - col_start));
    if (!col) return 4;
    char* val = xstrdup_n(val_start, (size_t)(val_end - val_start));
    if (!val) { free(col); return 4; }
    *out_col = col;
    *out_val = val;
    *out_op = op;
    return 0;
}

__attribute__((unused))
static int cmp_strings(const char* a, const char* b) {
    if (!a && !b) return 0;
    if (!a) return -1;
    if (!b) return 1;
    return strcmp(a, b);
}

typedef struct {
    DataFrame* d;
    const int* sort_cols;
    const int* sort_dir;
    int n_sort;
} SortCtx;

static int compare_rows(const void* aa, const void* bb, void* ctxp) {
    const int ia = *(const int*)aa;
    const int ib = *(const int*)bb;
    SortCtx* ctx = (SortCtx*)ctxp;
    int k;
    for (k = 0; k < ctx->n_sort; ++k) {
        int col = ctx->sort_cols[k];
        int desc = ctx->sort_dir ? (ctx->sort_dir[k] != 0) : 0;
        const char* sa = ctx->d->data[ia][col];
        const char* sb = ctx->d->data[ib][col];
        int c = strcmp(sa ? sa : "", sb ? sb : "");
        if (c != 0) {
            return desc ? -c : c;
        }
    }
    if (ia < ib) return -1;
    if (ia > ib) return 1;
    return 0;
}

static size_t table_border_len(const int* widths, int ncols) {
    size_t sum = 0;
    int i;
    for (i = 0; i < ncols; ++i) sum += (size_t)widths[i] + 2;
    return (size_t)(ncols + 1) + sum + 1;
}

static size_t table_row_len(const int* widths, int ncols) {
    size_t sum = 0;
    int i;
    for (i = 0; i < ncols; ++i) sum += (size_t)widths[i] + 2;
    return (size_t)(ncols + 1) + sum + 1;
}

static void append_repeat(char** p, char ch, int count) {
    int i;
    for (i = 0; i < count; ++i) { **p = ch; (*p)++; }
}

static void append_border(char** p, const int* widths, int ncols) {
    int i;
    **p = '+'; (*p)++;
    for (i = 0; i < ncols; ++i) {
        append_repeat(p, '-', widths[i] + 2);
        **p = '+'; (*p)++;
    }
    **p = '\n'; (*p)++;
}

static void append_row_cells(char** p, const char* const* cells, const int* widths, int ncols) {
    **p = '|'; (*p)++;
    for (int i = 0; i < ncols; ++i) {
        int w = widths[i];
        const char* s = cells[i] ? cells[i] : "";
        size_t sl = strlen(s);                  // use size_t for lengths
        **p = ' '; (*p)++;
        if (sl <= (size_t)w) {
            if (sl) { memcpy(*p, s, sl); *p += (ptrdiff_t)sl; }
            if (w > (int)sl) append_repeat(p, ' ', w - (int)sl);
        } else {
            memcpy(*p, s, (size_t)w);
            *p += w;
        }
        **p = ' '; (*p)++;
        **p = '|'; (*p)++;
    }
    **p = '\n'; (*p)++;
}

/* Render a monospace table with optional selection/filtering/sorting/row cap into out_buf; set out_written to required length (including NUL); return nonzero if out_buf_len is too small. */
int df_format_table(void* df, const int* sel_cols, int n_sel_cols, const char* filter_query, const int* sort_cols, const int* sort_dir_flags, int n_sort, int max_rows, char* out_buf, int out_buf_len, int* out_written) {
    if (!df || !out_written) return 2;
    DataFrame* d = (DataFrame*)df;
    if (n_sel_cols < 0 || n_sort < 0) return 2;
    if (n_sel_cols > 0 && !sel_cols) return 2;
    if (n_sort > 0 && !sort_cols) return 2;
    int rc = validate_col_indices(d, sel_cols, n_sel_cols);
    if (rc) return rc;
    rc = validate_col_indices(d, sort_cols, n_sort);
    if (rc) return rc;

    int ncols_out = n_sel_cols > 0 ? n_sel_cols : d->cols;
    int* cols_out = NULL;
    if (ncols_out > 0) {
        cols_out = (int*)xmalloc((size_t)ncols_out * sizeof(int));
        if (!cols_out) return 4;
        int i;
        if (n_sel_cols > 0) {
            for (i = 0; i < n_sel_cols; ++i) cols_out[i] = sel_cols[i];
        } else {
            for (i = 0; i < d->cols; ++i) cols_out[i] = i;
        }
    }

    char* fcol = NULL;
    char* fval = NULL;
    FilterOp fop = FOP_NONE;
    rc = parse_filter(filter_query, &fcol, &fop, &fval);
    if (rc == 3) { free(cols_out); return 3; }
    if (rc == 4) { free(cols_out); return 4; }
    int fcol_idx = -1;
    if (fop != FOP_NONE) {
        rc = df_col_index(d, fcol, &fcol_idx);
        if (rc) { free(cols_out); free(fcol); free(fval); return 3; }
    }

    int nidx = d->rows;
    int* idx = NULL;
    if (nidx > 0) {
        idx = (int*)xmalloc((size_t)nidx * sizeof(int));
        if (!idx) { free(cols_out); free(fcol); free(fval); return 4; }
    }
    int irow, m = 0;
    for (irow = 0; irow < d->rows; ++irow) {
        int keep = 1;
        if (fop != FOP_NONE) {
            const char* s = d->data[irow][fcol_idx];
            int cmp = strcmp(s ? s : "", fval ? fval : "");
            if (fop == FOP_EQ) keep = (cmp == 0);
            else if (fop == FOP_NEQ) keep = (cmp != 0);
        }
        if (keep) idx[m++] = irow;
    }
    free(fcol);
    free(fval);
    int nfiltered = m;

    if (n_sort > 0 && nfiltered > 1) {
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
        SortCtx ctx;
        ctx.d = d; ctx.sort_cols = sort_cols; ctx.sort_dir = sort_dir_flags; ctx.n_sort = n_sort;
        qsort_r(idx, (size_t)nfiltered, sizeof(int), compare_rows, &ctx);
#else
        int (*cmp_bridge)(const void*, const void*) = NULL;
        SortCtx* ctx = (SortCtx*)xmalloc(sizeof(SortCtx));
        if (!ctx) { free(cols_out); free(idx); return 4; }
        ctx->d = d; ctx->sort_cols = sort_cols; ctx->sort_dir = sort_dir_flags; ctx->n_sort = n_sort;
        struct Wrap {
            SortCtx* c;
        } w;
        w.c = ctx;
        int compare_adapter(const void* a, const void* b) {
            return compare_rows(a, b, w.c);
        }
        cmp_bridge = compare_adapter;
        qsort(idx, (size_t)nfiltered, sizeof(int), cmp_bridge);
        free(ctx);
#endif
    }

    int to_print = nfiltered;
    if (max_rows > 0 && max_rows < to_print) to_print = max_rows;

    int* widths = NULL;
    if (ncols_out > 0) {
        widths = (int*)xmalloc((size_t)ncols_out * sizeof(int));
        if (!widths) { free(cols_out); free(idx); return 4; }
        int c;
        for (c = 0; c < ncols_out; ++c) {
            int w = (int)strlen(d->col_names[cols_out[c]]);
            int r;
            for (r = 0; r < to_print; ++r) {
                const char* s = d->data[idx[r]][cols_out[c]];
                int sl = (int)strlen(s ? s : "");
                if (sl > w) w = sl;
            }
            widths[c] = w;
        }
    }

    size_t border_len = table_border_len(widths ? widths : (int[]){0}, ncols_out);
    size_t row_len = table_row_len(widths ? widths : (int[]){0}, ncols_out);
    size_t total = border_len + row_len + border_len + (size_t)to_print * row_len + border_len + 1;
    *out_written = (int)((total <= INT_MAX) ? total : INT_MAX);
    if (!out_buf || out_buf_len <= 0 || (size_t)out_buf_len < total) {
        free(cols_out);
        free(idx);
        free(widths);
        return 1;
    }

    char* p = out_buf;
    int c;
    append_border(&p, widths, ncols_out);
    {
        if (ncols_out > 0) {
            const char** hdr_cells = (const char**)xmalloc((size_t)ncols_out * sizeof(char*));
            if (!hdr_cells) { free(cols_out); free(idx); free(widths); return 4; }

            /* Explicitly initialize so GCC knows every entry is defined */
            memset(hdr_cells, 0, (size_t)ncols_out * sizeof(char*));

            for (c = 0; c < ncols_out; ++c) {
                int col = cols_out[c];
                const char* nm = (d->col_names && col >= 0) ? d->col_names[col] : NULL;
                hdr_cells[c] = nm ? nm : "";  /* safe fallback */
            }

            append_row_cells(&p, hdr_cells, widths, ncols_out);
            free(hdr_cells);
        } else {
            /* No columns: still emit an empty header line to keep borders consistent */
            append_row_cells(&p, NULL, widths, 0);
        }
    }
    append_border(&p, widths, ncols_out);
    for (irow = 0; irow < to_print; ++irow) {
        if (ncols_out > 0) {
            const char** cells = (const char**)xmalloc((size_t)ncols_out * sizeof(char*));
            if (!cells) { free(cols_out); free(idx); free(widths); return 4; }

            /* Explicitly initialize */
            memset(cells, 0, (size_t)ncols_out * sizeof(char*));

            for (c = 0; c < ncols_out; ++c) {
                int col = cols_out[c];
                const char* v = (d->data && idx[irow] >= 0 && col >= 0)
                                ? d->data[idx[irow]][col]
                                : NULL;
                cells[c] = v ? v : "";  /* safe fallback */
            }

            append_row_cells(&p, cells, widths, ncols_out);
            free((void*)cells);
        } else {
            append_row_cells(&p, NULL, widths, 0);
        }
    }
    append_border(&p, widths, ncols_out);
    *p = '\0';

    free(cols_out);
    free(idx);
    free(widths);
    return 0;
}

/* Free the dataframe and all owned resources; safe to call with NULL. */
void df_free(void* df) {
    df_free_internal((DataFrame*)df);
}

/* Return ABI version 0x00010000 (1.0.0). */
unsigned int df_get_abi_version(void) {
    return 0x00010000u;
}
