#ifndef SQ_H
#define SQ_H

#ifdef __cplusplus
extern "C" {
#endif

/* Compute a + b into *out; return 0 on success, nonzero on error. */
int sq_add(int a, int b, int* out);

/* Return ABI version 0x00010000. */
unsigned int sq_get_abi_version(void);

#ifdef __cplusplus
}
#endif

#endif /* SQ_H */