#include <stdio.h>

int main(void) {
    fputs("\x1b[5;1;38;5;46m", stdout);   // Blink, bold, neon green
    puts("NEON BLINKING MESSAGE");
    fflush(stdout);                         // Do not reset; blinking persists after exit
    return 0;
}