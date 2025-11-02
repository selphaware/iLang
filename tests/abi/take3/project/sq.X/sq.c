#include "sq.h"
#include <limits.h>

/* Compute a + b into *out; return 0 on success, nonzero on error. */
int sq_add(int a, int b, int* out) {
    if (out == 0) {
        return 1;
    }
    if ((b > 0 && a > INT_MAX - b) || (b < 0 && a < INT_MIN - b)) {
        return 2;
    }
    *out = a + b;
    return 0;
}

/* Return ABI version 0x00010000. */
unsigned int sq_get_abi_version(void) {
    return 0x00010000u;
}