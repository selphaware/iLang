#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>

static volatile sig_atomic_t running = 1;

static void handle_sig(int sig) {
    (void)sig;
    running = 0;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s NAME\n", argv[0]);
        return 1;
    }

    char msg[1024];
    snprintf(msg, sizeof(msg), "Hello %s", argv[1]);

    signal(SIGINT, handle_sig);
    signal(SIGTERM, handle_sig);

    srand((unsigned)time(NULL) ^ (unsigned)(uintptr_t)&argc);

    // Vibrant "neon-ish" 256-color palette
    int neon[] = {46, 48, 51, 82, 118, 119, 129, 198, 199, 201, 207, 208, 214, 220, 226};
    int ncolors = (int)(sizeof(neon) / sizeof(neon[0]));

    // Hide cursor
    printf("\033[?25l");
    fflush(stdout);

    while (running) {
        int color = neon[rand() % ncolors];
        int blink = rand() % 2;       // 0 or 1
        int show = rand() % 3 != 0;   // 2/3 chance to show, 1/3 to blank (flash)

        if (show) {
            if (blink) {
                printf("\r\033[K\033[5;1;38;5;%dm%s\033[0m", color, msg);
            } else {
                printf("\r\033[K\033[1;38;5;%dm%s\033[0m", color, msg);
            }
        } else {
            // Blank the line for a flash effect even if blink isn't supported
            printf("\r\033[K");
        }

        fflush(stdout);
        usleep(120000); // ~120ms between flashes
    }

    // Cleanup: reset, show cursor, clear line and newline
    printf("\r\033[K\033[0m\033[?25h\n");
    fflush(stdout);
    return 0;
}