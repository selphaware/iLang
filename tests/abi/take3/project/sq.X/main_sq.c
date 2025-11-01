#include <stdio.h>
#include "sq.h"

int main(void) {
    unsigned int v = sq_get_abi_version();
    (void)v;  // normally you'd assert or print
    return 0;

}
