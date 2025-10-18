#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

static void strip_newline(char *s) {
    if (!s) return;
    size_t n = strcspn(s, "\r\n");
    s[n] = '\0';
}

int main(void) {
    char pwd[128];

    printf("Enter password: ");
    fflush(stdout);
    if (!fgets(pwd, sizeof pwd, stdin)) return 0;
    strip_newline(pwd);

    if (strcmp(pwd, "hello123") != 0) {
        return 0;
    }

    setvbuf(stdout, NULL, _IONBF, 0);
    srand((unsigned)time(NULL));

    // Clear screen, move home, hide cursor
    printf("\x1b[2J\x1b[H\x1b[?25l");

    // Funky welcome header
    printf("\x1b[1;96m============================================\x1b[0m\n");
    printf("\x1b[1;95m   W E L C O M E   T O   T H E   + O R T 1   \x1b[0m\n");
    printf("\x1b[1;96m============================================\x1b[0m\n");

    // Reserve a line for the flashing credit
    printf("\n");

    const char *msg = "by Selphaware";
    const char *prefix = "               "; // indentation
    int msg_len = (int)strlen(msg);
    int cycles = 20;

    for (int i = 0; i < cycles; ++i) {
        int show = rand() % 2;
        int color = 90 + (rand() % 8); // bright colors 90-97
        int delay_us = 120000 + (rand() % 480000);

        // Clear the line area
        printf("\r%s%*s", prefix, msg_len, "");
        fflush(stdout);

        if (show) {
            // Blink attribute + random bright color
            printf("\r%s\x1b[1;%dm\x1b[5m%s\x1b[0m", prefix, color, msg);
        } else {
            // Hidden phase (nothing printed)
            // Keep the prefix so it doesn't jump
            printf("\r%s", prefix);
        }
        fflush(stdout);
        usleep(delay_us);
    }

    // Final stable display (no blink)
    printf("\r%s\x1b[1;92m%s\x1b[0m\n", prefix, msg);

    // Show cursor again
    printf("\x1b[?25h");
    return 0;
}
