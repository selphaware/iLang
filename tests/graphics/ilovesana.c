#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <signal.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#include <sys/ioctl.h>
#endif

#define MAX_W 240
#define MAX_H 80
#define PARTICLES 250

typedef struct { float x, y; } Particle;

static int W = 100, H = 30;
static int running = 1;
static Particle ps[PARTICLES];

static void restore_terminal(void) {
    printf("\x1b[0m\x1b[?25h"); // reset, show cursor
    fflush(stdout);
}

#ifdef _WIN32
static BOOL WINAPI console_handler(DWORD dwType) {
    (void)dwType;
    running = 0;
    restore_terminal();
    return TRUE;
}
#else
static void sigint_handler(int sig) {
    (void)sig;
    running = 0;
    restore_terminal();
}
#endif

static void sleep_ms(int ms) {
#ifdef _WIN32
    Sleep(ms);
#else
    usleep(ms * 1000);
#endif
}

static void enable_ansi(void) {
#ifdef _WIN32
    HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
    if (hOut != INVALID_HANDLE_VALUE) {
        DWORD mode = 0;
        if (GetConsoleMode(hOut, &mode)) {
            mode |= 0x0004; // ENABLE_VIRTUAL_TERMINAL_PROCESSING
            SetConsoleMode(hOut, mode);
        }
    }
    SetConsoleOutputCP(65001); // UTF-8 (we only use ASCII, but safe)
#endif
}

static void get_term_size(void) {
#ifdef _WIN32
    CONSOLE_SCREEN_BUFFER_INFO info;
    HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
    if (GetConsoleScreenBufferInfo(hOut, &info)) {
        int w = info.srWindow.Right - info.srWindow.Left + 1;
        int h = info.srWindow.Bottom - info.srWindow.Top + 1;
        if (w > 0 && h > 0) { W = w; H = h; }
    }
#else
    struct winsize ws;
    if (ioctl(1, TIOCGWINSZ, &ws) == 0) {
        if (ws.ws_col > 0 && ws.ws_row > 0) { W = ws.ws_col; H = ws.ws_row; }
    }
#endif
    if (W > MAX_W) W = MAX_W;
    if (H > MAX_H) H = MAX_H;
    if (W < 60) W = 60;
    if (H < 24) H = 24;
}

static void hsv2rgb(float h, float s, float v, int *r, int *g, int *b) {
    while (h < 0) h += 360.0f;
    while (h >= 360.0f) h -= 360.0f;
    float c = v * s;
    float x = c * (1.0f - fabsf(fmodf(h / 60.0f, 2.0f) - 1.0f));
    float m = v - c;
    float rf=0, gf=0, bf=0;
    if (h < 60)      { rf = c; gf = x; bf = 0; }
    else if (h < 120){ rf = x; gf = c; bf = 0; }
    else if (h < 180){ rf = 0; gf = c; bf = x; }
    else if (h < 240){ rf = 0; gf = x; bf = c; }
    else if (h < 300){ rf = x; gf = 0; bf = c; }
    else             { rf = c; gf = 0; bf = x; }
    *r = (int)((rf + m) * 255.0f + 0.5f);
    *g = (int)((gf + m) * 255.0f + 0.5f);
    *b = (int)((bf + m) * 255.0f + 0.5f);
    if (*r < 0) *r = 0; if (*r > 255) *r = 255;
    if (*g < 0) *g = 0; if (*g > 255) *g = 255;
    if (*b < 0) *b = 0; if (*b > 255) *b = 255;
}

static void init_particles(void) {
    for (int i = 0; i < PARTICLES; ++i) {
        ps[i].x = (float)(rand() % W);
        ps[i].y = (float)(rand() % H);
    }
}

static void update_particles(float t) {
    for (int i = 0; i < PARTICLES; ++i) {
        float x = ps[i].x, y = ps[i].y;
        float vx = 0.40f + 0.35f * sinf((y * 0.11f) + t * 0.045f);
        float vy = 0.50f * sinf((x * 0.07f) + t * 0.060f);
        ps[i].x += vx;
        ps[i].y += vy;
        if (ps[i].x >= W) ps[i].x -= W;
        if (ps[i].x < 0) ps[i].x += W;
        if (ps[i].y >= H) ps[i].y -= H;
        if (ps[i].y < 0) ps[i].y += H;
    }
}

int main(void) {
    srand((unsigned)time(NULL));
    enable_ansi();
#ifdef _WIN32
    SetConsoleCtrlHandler(console_handler, TRUE);
#else
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = sigint_handler;
    sigaction(SIGINT, &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
#endif
    atexit(restore_terminal);
    get_term_size();
    init_particles();

    static char ch[MAX_H][MAX_W];
    static unsigned char cr[MAX_H][MAX_W], cg[MAX_H][MAX_W], cb[MAX_H][MAX_W];

    const char *msg = "I Love Sana";
    int msgLen = (int)strlen(msg);

    printf("\x1b[2J\x1b[?25l"); // clear, hide cursor
    fflush(stdout);

    long frame = 0;
    while (running) {
        get_term_size(); // handle resize
        float t = (float)frame;

        // Clear buffers
        for (int y = 0; y < H; ++y) {
            for (int x = 0; x < W; ++x) {
                ch[y][x] = ' ';
                cr[y][x] = cg[y][x] = cb[y][x] = 0;
            }
        }

        // Background particles
        update_particles(t);
        for (int i = 0; i < PARTICLES; ++i) {
            int x = (int)ps[i].x;
            int y = (int)ps[i].y;
            if (x < 0 || x >= W || y < 0 || y >= H) continue;
            float hue = fmodf(ps[i].x * 0.9f + ps[i].y * 0.5f + t * 2.5f, 360.0f);
            int r, g, b;
            hsv2rgb(hue, 0.8f, 0.65f, &r, &g, &b);
            ch[y][x] = (i % 5 == 0) ? '*' : '.';
            cr[y][x] = (unsigned char)r;
            cg[y][x] = (unsigned char)g;
            cb[y][x] = (unsigned char)b;
        }

        // Heart (pulsing, swirling colors)
        float baseS = (float)((W < H ? W : H)) * 0.18f; // base scale
        float s = baseS * (1.0f + 0.08f * sinf(t * 0.12f));
        float cx = W * 0.25f; // left side
        float cy = H * 0.45f;

        for (int yy = 0; yy < H; ++yy) {
            for (int xx = 0; xx < W; ++xx) {
                // normalized heart coords, note y inverted for screen
                float x = (xx - cx) / s;
                float y = (cy - yy) / s;
                float a = x*x + y*y - 1.0f;
                float f = a*a*a - x*x*y*y*y;
                if (f <= 0.0f) {
                    // color flow around angle and time
                    float ang = atan2f(y, x); // [-pi, pi]
                    float rad = sqrtf(x*x + y*y);
                    float hue = fmodf((ang * 180.0f / (float)M_PI) * 2.0f + t * 3.0f + rad * 120.0f, 360.0f);
                    int r, g, b;
                    hsv2rgb(hue, 0.9f, 1.0f, &r, &g, &b);
                    ch[yy][xx] = '#';
                    cr[yy][xx] = (unsigned char)r;
                    cg[yy][xx] = (unsigned char)g;
                    cb[yy][xx] = (unsigned char)b;
                }
            }
        }

        // Text "I Love Sana" with wave and rainbow flow
        int startX = (W - msgLen) / 2;
        int baseY = (int)(H * 0.78f);
        for (int i = 0; i < msgLen; ++i) {
            char c = msg[i];
            if (c == '\0') break;
            int x = startX + i;
            int dy = (int)lrintf(2.0f * sinf(i * 0.60f + t * 0.20f));
            int y = baseY + dy;
            if (x < 0 || x >= W || y < 0 || y >= H) continue;
            ch[y][x] = c;
            float hue = fmodf(i * 28.0f + t * 4.0f, 360.0f);
            int r, g, b;
            hsv2rgb(hue, 1.0f, 1.0f, &r, &g, &b);
            cr[y][x] = (unsigned char)r;
            cg[y][x] = (unsigned char)g;
            cb[y][x] = (unsigned char)b;
        }

        // Subtle flowing underline beneath text
        for (int i = 0; i < msgLen + 4; ++i) {
            int x = startX - 2 + i;
            float phase = i * 0.45f + t * 0.25f;
            int y = baseY + 2 + (int)lrintf(sinf(phase));
            if (x < 0 || x >= W || y < 0 || y >= H) continue;
            float hue = fmodf(200.0f + i * 10.0f + t * 3.0f, 360.0f);
            int r, g, b;
            hsv2rgb(hue, 0.8f, 0.8f, &r, &g, &b);
            ch[y][x] = '~';
            cr[y][x] = (unsigned char)r;
            cg[y][x] = (unsigned char)g;
            cb[y][x] = (unsigned char)b;
        }

        // Render
        printf("\x1b[H"); // move cursor to home
        int lastR = -1, lastG = -1, lastB = -1;
        for (int y = 0; y < H; ++y) {
            // Reset color at row start to prevent bleed
            if (lastR != -1) { printf("\x1b[0m"); lastR = lastG = lastB = -1; }
            for (int x = 0; x < W; ++x) {
                if (ch[y][x] == ' ') {
                    // Space, just print space (no color change)
                    putchar(' ');
                } else {
                    int r = cr[y][x], g = cg[y][x], b = cb[y][x];
                    if (r != lastR || g != lastG || b != lastB) {
                        printf("\x1b[38;2;%d;%d;%dm", r, g, b);
                        lastR = r; lastG = g; lastB = b;
                    }
                    putchar(ch[y][x]);
                }
            }
            if (y != H - 1) putchar('\n');
        }
        fflush(stdout);

        frame++;
        sleep_ms(33); // ~30 FPS
    }

    return 0;
}