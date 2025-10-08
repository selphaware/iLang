#include <math.h>
#include <limits.h>
#include <stdio.h>

int square_and_round(float x) {
    double y = (double)x * (double)x;
    if (y >= (double)INT_MAX - 0.5) return INT_MAX;  // avoid overflow after rounding
    return (int)lround(y);
}

// code below added by human for testing
int main() {
    float x = 7.887365298357;
    int y = square_and_round(x);
    printf("%f squared is (rounded) %d\n", x, y);
    return 0;
}
