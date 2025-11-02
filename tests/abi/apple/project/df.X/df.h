#ifndef DF_H
#define DF_H

#ifdef __cplusplus
extern "C" {
#endif

/* Load CSV at 'path' with delimiter into an opaque dataframe handle stored in *out_df; return 0 on success, nonzero on error; on error sets *out_df = NULL. */
int df_read_csv(const char* path, char delimiter, void** out_df);

/* Return row and column counts for the dataframe. */
int df_shape(void* df, int* out_rows, int* out_cols);

/* Lookup a column index by name; return 0 on success, nonzero if not found. */
int df_col_index(void* df, const char* name, int* out_idx);

/* Write comma-separated column names into out_buf; set out_written to required length (including NUL); return nonzero if out_buf_len is too small. */
int df_columns_csv(void* df, char* out_buf, int out_buf_len, int* out_written);

/* Render a monospace table with optional selection/filtering/sorting/row cap into out_buf; set out_written to required length (including NUL); return nonzero if out_buf_len is too small. */
int df_format_table(void* df, const int* sel_cols, int n_sel_cols, const char* filter_query, const int* sort_cols, const int* sort_dir_flags, int n_sort, int max_rows, char* out_buf, int out_buf_len, int* out_written);

/* Free the dataframe and all owned resources; safe to call with NULL. */
void df_free(void* df);

/* Return ABI version 0x00010000 (1.0.0). */
unsigned int df_get_abi_version(void);

#ifdef __cplusplus
}
#endif

#endif /* DF_H */