#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "df.h"

#define DIE(...) do { fprintf(stderr, __VA_ARGS__); fputc('\n', stderr); exit(EXIT_FAILURE); } while(0)

typedef struct {
    const char* file;
    char delim;
    int list_cols;
    char* select_csv;     // column names, comma-separated
    char* filter_query;   // passed through to df_format_table
    char* sort_spec;      // name[:asc|:desc],name2[:asc|:desc],...
    int page_size;        // lines per page for console pagination; 0 = no paging
} Args;

static void print_usage(const char* prog) {
    fprintf(stderr,
        "Usage: %s --file <path.csv> [--delim <char>] [--list-cols]\n"
        "           [--select name1,name2,...] [--filter <expr>]\n"
        "           [--sort name[:asc|:desc][,name2[:asc|:desc]...]] [--page-size N]\n"
        "\n"
        "Examples:\n"
        "  %s --file data.csv --list-cols\n"
        "  %s --file data.csv --select price,category --filter \"price>10 AND category==\\\"A\\\"\"\n"
        "  %s --file data.csv --sort price:desc,category:asc --page-size 40\n",
        prog, prog, prog, prog
    );
}

static int starts_with(const char* s, const char* pref) {
    return strncmp(s, pref, strlen(pref)) == 0;
}

static char* dupstr(const char* s) {
    if (!s) return NULL;
    size_t n = strlen(s);
    char* out = (char*)malloc(n + 1);
    if (!out) return NULL;
    memcpy(out, s, n + 1);
    return out;
}

static void parse_args(int argc, char** argv, Args* a) {
    memset(a, 0, sizeof(*a));
    a->delim = ',';       // default
    a->page_size = 0;     // default: no pagination

    for (int i = 1; i < argc; ++i) {
        const char* arg = argv[i];

        if (strcmp(arg, "--help") == 0 || strcmp(arg, "-h") == 0) {
            print_usage(argv[0]);
            exit(EXIT_SUCCESS);
        } else if (strcmp(arg, "--file") == 0) {
            if (i + 1 >= argc) DIE("Missing value for --file");
            a->file = argv[++i];
        } else if (strcmp(arg, "--delim") == 0) {
            if (i + 1 >= argc) DIE("Missing value for --delim");
            const char* d = argv[++i];
            if (d[0] == '\\' && d[1] != '\0') {
                // Allow escapes like '\t'
                if (d[1] == 't') a->delim = '\t';
                else if (d[1] == 'n') a->delim = '\n';
                else a->delim = d[1];
            } else {
                a->delim = d[0];
            }
        } else if (strcmp(arg, "--list-cols") == 0) {
            a->list_cols = 1;
        } else if (strcmp(arg, "--select") == 0) {
            if (i + 1 >= argc) DIE("Missing value for --select");
            a->select_csv = dupstr(argv[++i]);
        } else if (strcmp(arg, "--filter") == 0) {
            if (i + 1 >= argc) DIE("Missing value for --filter");
            a->filter_query = dupstr(argv[++i]);
        } else if (strcmp(arg, "--sort") == 0) {
            if (i + 1 >= argc) DIE("Missing value for --sort");
            a->sort_spec = dupstr(argv[++i]);
        } else if (strcmp(arg, "--page-size") == 0) {
            if (i + 1 >= argc) DIE("Missing value for --page-size");
            a->page_size = atoi(argv[++i]);
            if (a->page_size < 0) a->page_size = 0;
        } else if (starts_with(arg, "--file=")) {
            a->file = arg + 7;
        } else if (starts_with(arg, "--delim=")) {
            const char* d = arg + 8;
            a->delim = (d[0] == '\\' && d[1] == 't') ? '\t' : d[0];
        } else if (starts_with(arg, "--select=")) {
            a->select_csv = dupstr(arg + 9);
        } else if (starts_with(arg, "--filter=")) {
            a->filter_query = dupstr(arg + 9);
        } else if (starts_with(arg, "--sort=")) {
            a->sort_spec = dupstr(arg + 7);
        } else if (starts_with(arg, "--page-size=")) {
            a->page_size = atoi(arg + 12);
            if (a->page_size < 0) a->page_size = 0;
        } else {
            fprintf(stderr, "Unknown argument: %s\n", arg);
            print_usage(argv[0]);
            exit(EXIT_FAILURE);
        }
    }

    if (!a->file) {
        print_usage(argv[0]);
        DIE("Missing required --file");
    }
}

static void free_args(Args* a) {
    free(a->select_csv);
    free(a->filter_query);
    free(a->sort_spec);
}

// Split comma-separated names into NULL-terminated array; returns count. Modifies buffer in-place.
static int split_csv_inplace(char* csv, char*** out_vec) {
    if (!csv || !*csv) { *out_vec = NULL; return 0; }
    int count = 1;
    for (char* p = csv; *p; ++p) if (*p == ',') ++count;
    char** vec = (char**)malloc((count + 1) * sizeof(char*));
    if (!vec) return -1;

    int idx = 0;
    char* s = csv;
    while (1) {
        char* comma = strchr(s, ',');
        if (comma) { *comma = '\0'; vec[idx++] = s; s = comma + 1; }
        else { vec[idx++] = s; break; }
    }
    vec[idx] = NULL;
    *out_vec = vec;
    return idx;
}

// Trim trailing/leading spaces in place
static char* trim(char* s) {
    if (!s) return s;
    while (isspace((unsigned char)*s)) ++s;
    if (*s == 0) return s;
    char* end = s + strlen(s) - 1;
    while (end > s && isspace((unsigned char)*end)) *end-- = '\0';
    return s;
}

// Parse --sort spec into arrays of column indices + dir flags (1=ASC, 0=DESC)
static int parse_sort(void* df, char* sort_spec, int** out_cols, int** out_dirs, int* out_n) {
    *out_cols = NULL; *out_dirs = NULL; *out_n = 0;
    if (!sort_spec || !*sort_spec) return 0;

    char** items = NULL;
    int n = split_csv_inplace(sort_spec, &items);
    if (n < 0) return -1;
    int* cols = (int*)malloc(n * sizeof(int));
    int* dirs = (int*)malloc(n * sizeof(int));
    if (!cols || !dirs) { free(items); free(cols); free(dirs); return -1; }

    for (int i = 0; i < n; ++i) {
        char* tok = trim(items[i]);
        char* name = tok;
        int asc = 1; // default asc

        char* colon = strchr(tok, ':');
        if (colon) {
            *colon = '\0';
            char* dir = trim(colon + 1);
            if (*dir) {
                if (strcasecmp(dir, "desc") == 0) asc = 0;
                else if (strcasecmp(dir, "asc") == 0) asc = 1;
                else { fprintf(stderr, "Unknown sort direction '%s' (use asc|desc)\n", dir); free(items); free(cols); free(dirs); return -1; }
            }
        }
        int idx = -1;
        if (df_col_index(df, name, &idx) != 0 || idx < 0) {
            fprintf(stderr, "Sort column not found: %s\n", name);
            free(items); free(cols); free(dirs); return -1;
        }
        cols[i] = idx;
        dirs[i] = asc ? 1 : 0;
    }

    free(items);
    *out_cols = cols;
    *out_dirs = dirs;
    *out_n = n;
    return 0;
}

// Resolve --select names to indices array
static int parse_select(void* df, char* select_csv, int** out_sel, int* out_nsel) {
    *out_sel = NULL; *out_nsel = 0;
    if (!select_csv || !*select_csv) return 0;

    char** names = NULL;
    int n = split_csv_inplace(select_csv, &names);
    if (n < 0) return -1;
    int* sel = (int*)malloc(n * sizeof(int));
    if (!sel) { free(names); return -1; }

    for (int i = 0; i < n; ++i) {
        char* nm = trim(names[i]);
        int idx = -1;
        if (df_col_index(df, nm, &idx) != 0 || idx < 0) {
            fprintf(stderr, "Selected column not found: %s\n", nm);
            free(names); free(sel); return -1;
        }
        sel[i] = idx;
    }
    free(names);
    *out_sel = sel;
    *out_nsel = n;
    return 0;
}

// Fetch column names as CSV and print
static void print_columns(void* df) {
    int need = 0;
    int rc = df_columns_csv(df, NULL, 0, &need);
    if (rc == 0 && need <= 1) { puts("(no columns)"); return; }

    char* buf = (char*)malloc(need);
    if (!buf) DIE("OOM");
    rc = df_columns_csv(df, buf, need, &need);
    if (rc != 0) { free(buf); DIE("df_columns_csv failed"); }

    printf("Columns: %s\n", buf);
    free(buf);
}

// Render full table into dynamically grown buffer (max_rows can be 0 for ‘no cap’)
static char* render_table(void* df,
                          const int* sel_cols, int n_sel_cols,
                          const char* filter_query,
                          const int* sort_cols, const int* sort_dirs, int n_sort,
                          int max_rows)
{
    int cap = 4096;                  // start with 4 KiB
    char* buf = (char*)malloc((size_t)cap);
    if (!buf) DIE("OOM");

    while (1) {
        int need = 0;
        int rc = df_format_table(df, sel_cols, n_sel_cols, filter_query,
                                 sort_cols, sort_dirs, n_sort,
                                 max_rows, buf, cap, &need);

        if (rc == 0) {
            // success (buf contains NUL-terminated text)
            return buf;
        }

        // If need <= cap, treat as error (implementation-specific), but try to grow anyway
        if (need <= cap) {
            // grow geometrically as a fallback
            need = cap * 2;
        }

        char* bigger = (char*)realloc(buf, (size_t)need);
        if (!bigger) { free(buf); DIE("OOM"); }
        buf = bigger;
        cap = need;
        // loop and retry
    }
}

// Simple console pager: prints `page_lines` lines at a time. Enter=continue, 'q'+Enter=quit.
static void page_print(const char* s, int page_lines) {
    if (page_lines <= 0) {
        fputs(s, stdout);
        return;
    }
    int lines = 0;
    const char* p = s;
    const char* chunk_start = p;

    while (*p) {
        if (*p == '\n') {
            ++lines;
            if (lines >= page_lines) {
                fwrite(chunk_start, 1, (size_t)((p + 1) - chunk_start), stdout);
                fputs("-- More -- (Enter to continue, q to quit) ", stdout);
                fflush(stdout);
                int c = getchar();
                if (c == 'q' || c == 'Q') {
                    fputc('\n', stdout);
                    return;
                }
                // Consume the rest of the line (e.g., if user typed extra chars)
                while (c != '\n' && c != EOF) c = getchar();
                lines = 0;
                chunk_start = p + 1;
            }
        }
        ++p;
    }
    if (p != chunk_start) {
        fwrite(chunk_start, 1, (size_t)(p - chunk_start), stdout);
    }
}

int main(int argc, char** argv) {
    unsigned int v = df_get_abi_version();
    (void)v; // Could assert 0x00010000

    Args a;
    parse_args(argc, argv, &a);

    void* df = NULL;
    if (df_read_csv(a.file, a.delim, &df) != 0 || !df) {
        free_args(&a);
        DIE("Failed to read CSV: %s", a.file);
    }

    if (a.list_cols) {
        print_columns(df);
        df_free(df);
        free_args(&a);
        return 0;
    }

    // Resolve selections
    int* sel_cols = NULL; int n_sel = 0;
    if (parse_select(df, a.select_csv, &sel_cols, &n_sel) != 0) {
        df_free(df); free_args(&a); DIE("Invalid --select");
    }

    // Resolve sorts
    int* sort_cols = NULL; int* sort_dirs = NULL; int n_sort = 0;
    if (parse_sort(df, a.sort_spec, &sort_cols, &sort_dirs, &n_sort) != 0) {
        free(sel_cols); df_free(df); free_args(&a); DIE("Invalid --sort");
    }

    // Render full table (max_rows = 0 => no cap), then paginate on console lines
    char* table = render_table(df,
                               sel_cols, n_sel,
                               a.filter_query,
                               sort_cols, sort_dirs, n_sort,
                               0 /* no row cap */);

    page_print(table, a.page_size);

    free(table);
    free(sel_cols);
    free(sort_cols);
    free(sort_dirs);
    df_free(df);
    free_args(&a);
    return 0;
}
