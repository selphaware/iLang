#include <SDL2/SDL.h>
#include <math.h>
#include <stdbool.h>

#define WIDTH 800
#define HEIGHT 600
#define PI 3.14159265358979323846

static void drawCircle(SDL_Renderer* r, float cx, float cy, float radius, int segments) {
    float step = 2.0f * (float)PI / (float)segments;
    float prevX = cx + radius;
    float prevY = cy;
    for (int i = 1; i <= segments; ++i) {
        float a = i * step;
        float x = cx + radius * cosf(a);
        float y = cy + radius * sinf(a);
        SDL_RenderDrawLine(r, (int)prevX, (int)prevY, (int)x, (int)y);
        prevX = x;
        prevY = y;
    }
}

static void drawArc(SDL_Renderer* r, float cx, float cy, float radius, float startDeg, float endDeg, int segments) {
    float start = startDeg * (float)PI / 180.0f;
    float end   = endDeg   * (float)PI / 180.0f;
    if (end < start) { float t = start; start = end; end = t; }
    float step = (end - start) / (float)segments;
    float prevX = cx + radius * cosf(start);
    float prevY = cy + radius * sinf(start);
    for (int i = 1; i <= segments; ++i) {
        float a = start + i * step;
        float x = cx + radius * cosf(a);
        float y = cy + radius * sinf(a);
        SDL_RenderDrawLine(r, (int)prevX, (int)prevY, (int)x, (int)y);
        prevX = x;
        prevY = y;
    }
}

static void drawSmiley(SDL_Renderer* r, float cx, float cy, float R) {
    // Face outline
    drawCircle(r, cx, cy, R, 160);
    // Eyes
    float eyeOffsetX = 0.4f * R;
    float eyeOffsetY = -0.25f * R;
    float eyeR = 0.09f * R;
    drawCircle(r, cx - eyeOffsetX, cy + eyeOffsetY, eyeR, 40);
    drawCircle(r, cx + eyeOffsetX, cy + eyeOffsetY, eyeR, 40);
    // Smile (arc)
    float mouthR = 0.6f * R;
    drawArc(r, cx, cy, mouthR, 200.0f, 340.0f, 80);
}

int main(int argc, char** argv) {
    (void)argc; (void)argv;
    if (SDL_Init(SDL_INIT_VIDEO) != 0) return 1;

    SDL_Window* win = SDL_CreateWindow("Bouncing Smiley",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WIDTH, HEIGHT, SDL_WINDOW_SHOWN);
    if (!win) { SDL_Quit(); return 1; }

    SDL_Renderer* ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!ren) { SDL_DestroyWindow(win); SDL_Quit(); return 1; }

    float R = 70.0f;
    float x = WIDTH * 0.5f, y = HEIGHT * 0.5f;
    float vx = 220.0f, vy = 180.0f;

    Uint32 last = SDL_GetTicks();
    bool running = true;
    while (running) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) running = false;
            if (e.type == SDL_KEYDOWN) running = false;
        }

        Uint32 now = SDL_GetTicks();
        float dt = (now - last) / 1000.0f;
        if (dt > 0.05f) dt = 0.05f; // Clamp in case of stalls
        last = now;

        x += vx * dt;
        y += vy * dt;

        if (x - R < 0.0f) { x = R; vx = -vx; }
        if (x + R > WIDTH) { x = WIDTH - R; vx = -vx; }
        if (y - R < 0.0f) { y = R; vy = -vy; }
        if (y + R > HEIGHT) { y = HEIGHT - R; vy = -vy; }

        // Clear black background
        SDL_SetRenderDrawColor(ren, 0, 0, 0, 255);
        SDL_RenderClear(ren);

        // Neon pink edges
        SDL_SetRenderDrawColor(ren, 255, 20, 147, 255);
        drawSmiley(ren, x, y, R);

        SDL_RenderPresent(ren);
    }

    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
}