#include <stdio.h>
#include "df.h"

int main(void) {
    unsigned int v = df_get_abi_version();
    (void)v;  // normally you'd assert or print
    return 0;

}
