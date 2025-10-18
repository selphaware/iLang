#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#ifdef _WIN32
#include <windows.h>
#include <conio.h>
static DWORD orig_mode_out;
static int console_inited = 0;
static void restore_console(void) {
    if (console_inited) {
        HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
        SetConsoleMode(hOut, orig_mode_out);
        printf("\x1b[?25h");
        fflush(stdout);
    }
}
static void setup_console(void) {
    HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
    GetConsoleMode(hOut, &orig_mode_out);
    DWORD mode = orig_mode_out | ENABLE_VIRTUAL_TERMINAL_PROCESSING;
    SetConsoleMode(hOut, mode);
    console_inited = 1;
    atexit(restore_console);
}
static int key_pressed(void) {
    return _kbhit();
}
static void sleep_ms(int ms) { Sleep(ms); }
#else
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>
static struct termios orig_termios;
static int term_inited = 0;
static void restore_terminal(void) {
    if (term_inited) {
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
        int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
        if (flags != -1) fcntl(STDIN_FILENO, F_SETFL, flags & ~O_NONBLOCK);
        printf("\x1b[?25h");
        fflush(stdout);
    }
}
static void setup_terminal(void) {
    tcgetattr(STDIN_FILENO, &orig_termios);
    struct termios raw = orig_termios;
    raw.c_lflag &= ~(ECHO | ICANON);
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
    int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    if (flags != -1) fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK);
    term_inited = 1;
    atexit(restore_terminal);
}
static int key_pressed(void) {
    unsigned char c;
    ssize_t n = read(STDIN_FILENO, &c, 1);
    return n > 0;
}
static void sleep_ms(int ms) { usleep(ms * 1000); }
#endif

int main(void) {
#ifdef _WIN32
    setup_console();
#else
    setup_terminal();
#endif

    const int WIDTH = 100;
    const int HEIGHT = 40;
    const char *palette = " .:-=+*#%@";
    const int plen = (int)strlen(palette);

    double cx = -0.743643887037151; 
    double cy =  0.131825904205330;
    double zoom = 1.0;
    double zrate = 1.03;
    int frame = 0;

    printf("\x1b[2J\x1b[H\x1b[?25l");
    fflush(stdout);

    while (!key_pressed()) {
        printf("\x1b[H");
        int max_iter = 80 + (int)(20.0 * log(zoom + 1.0));
        if (max_iter < 80) max_iter = 80;
        for (int y = 0; y < HEIGHT; y++) {
            for (int x = 0; x < WIDTH; x++) {
                double scale = 1.0 / zoom;
                double rx = (x - WIDTH / 2.0) * (3.5 / WIDTH) * scale + cx;
                double ry = (y - HEIGHT / 2.0) * (2.0 / HEIGHT) * scale + cy;

                double zr = 0.0, zi = 0.0;
                double zr2 = 0.0, zi2 = 0.0;
                int i = 0;
                while (zr2 + zi2 <= 4.0 && i < max_iter) {
                    zi = 2.0 * zr * zi + ry;
                    zr = zr2 - zi2 + rx;
                    zr2 = zr * zr;
                    zi2 = zi * zi;
                    i++;
                }

                char ch;
                if (i >= max_iter) {
                    ch = ' ';
                } else {
                    double t;
                    double r2 = zr2 + zi2;
                    if (r2 > 0.0) {
                        double log_zn = log(r2) / 2.0;
                        double nu = log(log_zn / log(2.0)) / log(2.0);
                        double iter = i + 1 - nu;
                        t = iter / max_iter;
                        if (t < 0) t = 0;
                        if (t > 1) t = 1;
                    } else {
                        t = (double)i / max_iter;
                    }
                    int idx = (int)(t * (plen - 1));
                    idx = (idx + (frame % plen)) % plen;
                    ch = palette[idx];
                }
                putchar(ch);
            }
            putchar('\n');
        }
        fflush(stdout);

        zoom *= zrate;
        if (zoom > 4000.0) {
            zoom = 1.0;
            frame = 0;
            cx = -0.75;
            cy = 0.0;
        }
        frame++;
        sleep_ms(30);
    }

    printf("\x1b[?25h\x1b[0m\n");
    fflush(stdout);
    return 0;
}