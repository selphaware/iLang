#include <stdio.h>
#include "sq.h"

int main(void) {
    unsigned int v = sq_get_abi_version();
    (void)v;  // normally you'd assert or print
    printf("Enter Numero: ");
    int inpy;
    scanf("%d", &inpy);
    int rc, out;
    rc = sq_add(inpy, inpy, &out);
    printf("\n\nError = %d, Result = %d\n", rc, out);
    return 0;

}
