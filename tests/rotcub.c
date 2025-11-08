#include <windows.h>
#include <math.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#pragma comment(lib, "user32.lib")
#pragma comment(lib, "gdi32.lib")
#pragma comment(lib, "winmm.lib")

#define WND_CLASS_NAME L"NeonCubeLayered"
#define WIN_W 640
#define WIN_H 640

typedef struct { float x,y,z; } Vec3;
typedef struct { float w,x,y,z; } Quat;

static HWND g_hwnd = NULL;
static HBITMAP g_dib = NULL;
static HDC g_memdc = NULL;
static uint8_t* g_bits = NULL;
static int g_stride = 0;
static LARGE_INTEGER g_freq;
static LARGE_INTEGER g_prev;
static float g_time = 0.0f;

// Rotation state
static Quat g_q = {1,0,0,0};
static Vec3 g_axis = {0.0f, 1.0f, 0.0f};
static float g_speed = 1.0f; // radians/sec
static float g_nextAxisChange = 2.0f;

// Color state
static uint8_t g_colR = 0, g_colG = 255, g_colB = 255;
static float g_nextColorChange = 1.0f;

// Cube geometry
static const Vec3 CUBE_VERTS[8] = {
    {-1,-1,-1}, { 1,-1,-1}, { 1, 1,-1}, {-1, 1,-1},
    {-1,-1, 1}, { 1,-1, 1}, { 1, 1, 1}, {-1, 1, 1}
};
static const int CUBE_EDGES[12][2] = {
    {0,1},{1,2},{2,3},{3,0},
    {4,5},{5,6},{6,7},{7,4},
    {0,4},{1,5},{2,6},{3,7}
};

// Utility RNG
static float frand01(void) {
    return (float)rand() / (float)RAND_MAX;
}

// HSV to RGB, h in [0,360), s,v in [0,1]
static void hsv2rgb(float h, float s, float v, uint8_t* r, uint8_t* g, uint8_t* b) {
    float c = v * s;
    float x = c * (1.0f - fabsf(fmodf(h / 60.0f, 2.0f) - 1.0f));
    float m = v - c;
    float rr=0, gg=0, bb=0;
    if (h < 60)      { rr=c; gg=x; bb=0; }
    else if (h < 120){ rr=x; gg=c; bb=0; }
    else if (h < 180){ rr=0; gg=c; bb=x; }
    else if (h < 240){ rr=0; gg=x; bb=c; }
    else if (h < 300){ rr=x; gg=0; bb=c; }
    else             { rr=c; gg=0; bb=x; }
    rr += m; gg += m; bb += m;
    *r = (uint8_t)(fminf(fmaxf(rr,0.0f),1.0f)*255.0f + 0.5f);
    *g = (uint8_t)(fminf(fmaxf(gg,0.0f),1.0f)*255.0f + 0.5f);
    *b = (uint8_t)(fminf(fmaxf(bb,0.0f),1.0f)*255.0f + 0.5f);
}

// Quaternion helpers
static Quat qmul(Quat a, Quat b) {
    Quat r;
    r.w = a.w*b.w - a.x*b.x - a.y*b.y - a.z*b.z;
    r.x = a.w*b.x + a.x*b.w + a.y*b.z - a.z*b.y;
    r.y = a.w*b.y - a.x*b.z + a.y*b.w + a.z*b.x;
    r.z = a.w*b.z + a.x*b.y - a.y*b.x + a.z*b.w;
    return r;
}
static Quat qnormalize(Quat q) {
    float n = sqrtf(q.w*q.w + q.x*q.x + q.y*q.y + q.z*q.z);
    if (n > 0.0f) {
        q.w/=n; q.x/=n; q.y/=n; q.z/=n;
    }
    return q;
}
static Vec3 qrotate(Quat q, Vec3 v) {
    // q * (0,v) * conj(q)
    Quat p = {0, v.x, v.y, v.z};
    Quat qc = {q.w, -q.x, -q.y, -q.z};
    Quat r = qmul(qmul(q, p), qc);
    Vec3 out = { r.x, r.y, r.z };
    return out;
}

// Create ARGB32 top-down DIB
static void create_dib(int w, int h) {
    if (g_memdc) { DeleteDC(g_memdc); g_memdc = NULL; }
    if (g_dib)   { DeleteObject(g_dib); g_dib = NULL; }
    g_bits = NULL;
    HDC screen = GetDC(NULL);
    g_memdc = CreateCompatibleDC(screen);
    ReleaseDC(NULL, screen);
    BITMAPINFO bi;
    ZeroMemory(&bi, sizeof(bi));
    bi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bi.bmiHeader.biWidth = w;
    bi.bmiHeader.biHeight = -h; // top-down
    bi.bmiHeader.biPlanes = 1;
    bi.bmiHeader.biBitCount = 32;
    bi.bmiHeader.biCompression = BI_RGB;
    g_dib = CreateDIBSection(g_memdc, &bi, DIB_RGB_COLORS, (void**)&g_bits, NULL, 0);
    SelectObject(g_memdc, g_dib);
    g_stride = w * 4;
}

// Premultiplied alpha "over" blend: dst = src over dst
static inline void blend_over(uint8_t* px, float sr, float sg, float sb, float sa) {
    // Read dest as premultiplied floats [0,1]
    float db = px[0] / 255.0f;
    float dg = px[1] / 255.0f;
    float dr = px[2] / 255.0f;
    float da = px[3] / 255.0f;
    float out_a = sa + da * (1.0f - sa);
    float out_r, out_g, out_b;
    if (out_a < 1e-6f) {
        out_r = out_g = out_b = out_a = 0.0f;
    } else {
        out_r = sr + dr * (1.0f - sa);
        out_g = sg + dg * (1.0f - sa);
        out_b = sb + db * (1.0f - sa);
    }
    px[0] = (uint8_t)(fminf(fmaxf(out_b,0.0f),1.0f)*255.0f + 0.5f);
    px[1] = (uint8_t)(fminf(fmaxf(out_g,0.0f),1.0f)*255.0f + 0.5f);
    px[2] = (uint8_t)(fminf(fmaxf(out_r,0.0f),1.0f)*255.0f + 0.5f);
    px[3] = (uint8_t)(fminf(fmaxf(out_a,0.0f),1.0f)*255.0f + 0.5f);
}

// Draw a neon glowing thick line from (x0,y0) to (x1,y1)
static void draw_neon_line(uint8_t* buf, int w, int h, float x0, float y0, float x1, float y1,
                           uint8_t r, uint8_t g, uint8_t b,
                           float coreRadius, float glowRadius, float glowMaxAlpha) {
    float minx = fminf(x0, x1) - glowRadius;
    float maxx = fmaxf(x0, x1) + glowRadius;
    float miny = fminf(y0, y1) - glowRadius;
    float maxy = fmaxf(y0, y1) + glowRadius;
    int ix0 = (int)floorf(fmaxf(0.0f, minx));
    int iy0 = (int)floorf(fmaxf(0.0f, miny));
    int ix1 = (int)ceilf(fminf((float)w - 1.0f, maxx));
    int iy1 = (int)ceilf(fminf((float)h - 1.0f, maxy));

    float vx = x1 - x0;
    float vy = y1 - y0;
    float vlen2 = vx*vx + vy*vy;
    if (vlen2 < 1e-6f) {
        // Degenerate: draw a disc
        int R = (int)ceilf(glowRadius);
        int cx = (int)roundf(x0);
        int cy = (int)roundf(y0);
        int sx = (cx - R < 0) ? 0 : cx - R;
        int ex = (cx + R >= w) ? w-1 : cx + R;
        int sy = (cy - R < 0) ? 0 : cy - R;
        int ey = (cy + R >= h) ? h-1 : cy + R;
        float rr = glowRadius;
        for (int y = sy; y <= ey; ++y) {
            for (int x = sx; x <= ex; ++x) {
                float dx = (x + 0.5f) - x0;
                float dy = (y + 0.5f) - y0;
                float d = sqrtf(dx*dx + dy*dy);
                if (d > glowRadius) continue;
                float a;
                if (d <= coreRadius) a = 1.0f;
                else {
                    float t = (d - coreRadius) / (glowRadius - coreRadius);
                    // Gaussian-ish falloff
                    a = glowMaxAlpha * expf(-(t*t)*9.0f);
                }
                float sa = fminf(fmaxf(a,0.0f),1.0f);
                float sr = (r/255.0f) * sa;
                float sg = (g/255.0f) * sa;
                float sb = (b/255.0f) * sa;
                blend_over(&buf[y*w*4 + x*4], sr, sg, sb, sa);
            }
        }
        return;
    }
    // Pre-multiply color factor per pixel later using alpha
    for (int iy = iy0; iy <= iy1; ++iy) {
        uint8_t* row = &buf[iy * w * 4];
        for (int ix = ix0; ix <= ix1; ++ix) {
            float px = ix + 0.5f;
            float py = iy + 0.5f;
            float wx = px - x0;
            float wy = py - y0;
            float t = (wx*vx + wy*vy) / vlen2;
            if (t < 0.0f) t = 0.0f;
            else if (t > 1.0f) t = 1.0f;
            float nx = x0 + t*vx;
            float ny = y0 + t*vy;
            float dx = px - nx;
            float dy = py - ny;
            float d = sqrtf(dx*dx + dy*dy);
            if (d > glowRadius) continue;
            float a;
            if (d <= coreRadius) a = 1.0f;
            else {
                float tt = (d - coreRadius) / (glowRadius - coreRadius);
                a = glowMaxAlpha * expf(-(tt*tt)*9.0f);
            }
            float sa = fminf(fmaxf(a,0.0f),1.0f);
            float sr = (r/255.0f) * sa;
            float sg = (g/255.0f) * sa;
            float sb = (b/255.0f) * sa;
            blend_over(&row[ix*4], sr, sg, sb, sa);
        }
    }
}

static void clear_buffer(uint8_t* buf, int w, int h) {
    size_t total = (size_t)w * (size_t)h * 4;
    memset(buf, 0, total);
}

static void present_layered(HWND hwnd, HDC srcdc, int w, int h) {
    SIZE sizeWindow = { w, h };
    POINT ptSrc = { 0, 0 };
    RECT rc;
    GetWindowRect(hwnd, &rc);
    POINT ptDst = { rc.left, rc.top };
    BLENDFUNCTION bf;
    bf.BlendOp = AC_SRC_OVER;
    bf.BlendFlags = 0;
    bf.SourceConstantAlpha = 255;
    bf.AlphaFormat = AC_SRC_ALPHA;
    UpdateLayeredWindow(hwnd, NULL, &ptDst, &sizeWindow, srcdc, &ptSrc, 0, &bf, ULW_ALPHA);
}

static void randomize_axis_speed(void) {
    float u = frand01();
    float v = frand01();
    float z = 2.0f * u - 1.0f;
    float theta = 2.0f * 3.1415926535f * v;
    float r = sqrtf(fmaxf(0.0f, 1.0f - z*z));
    g_axis.x = r * cosf(theta);
    g_axis.y = r * sinf(theta);
    g_axis.z = z;
    // Speed between 0.4 and 2.0 rad/s
    g_speed = 0.4f + frand01() * 1.6f;
    // Next change in 1.5 to 4.0 s
    g_nextAxisChange = g_time + 1.5f + frand01() * 2.5f;
}

static void randomize_color(void) {
    float hue = frand01() * 360.0f;
    // Neon-like: full saturation, full value
    uint8_t r,g,b;
    hsv2rgb(hue, 1.0f, 1.0f, &r, &g, &b);
    // Nudge towards higher brightness (already V=1, so fine)
    g_colR = r; g_colG = g; g_colB = b;
    g_nextColorChange = g_time + 0.8f + frand01() * 1.2f;
}

static void update_rotation(float dt) {
    float angle = g_speed * dt;
    float half = 0.5f * angle;
    float s = sinf(half);
    Quat dq = { cosf(half), g_axis.x * s, g_axis.y * s, g_axis.z * s };
    g_q = qnormalize(qmul(dq, g_q));
}

static void render_frame(void) {
    int w = WIN_W, h = WIN_H;
    clear_buffer(g_bits, w, h);

    // Perspective projection parameters
    float cx = w * 0.5f;
    float cy = h * 0.5f;
    float d = 3.0f; // camera distance
    float scale = fminf(w, h) * 0.7f; // overall size

    // Rotate and project vertices
    float sx[8], sy[8];
    for (int i = 0; i < 8; ++i) {
        Vec3 p = CUBE_VERTS[i];
        Vec3 r = qrotate(g_q, p);
        float z = r.z + d;
        float invz = 1.0f / z;
        sx[i] = cx + r.x * scale * invz;
        sy[i] = cy - r.y * scale * invz;
    }

    // Draw edges
    float coreR = 4.5f;
    float glowR = 22.0f;
    float glowA = 0.55f; // max alpha outside core
    for (int e = 0; e < 12; ++e) {
        int a = CUBE_EDGES[e][0];
        int b = CUBE_EDGES[e][1];
        draw_neon_line(g_bits, w, h, sx[a], sy[a], sx[b], sy[b],
                       g_colR, g_colG, g_colB, coreR, glowR, glowA);
    }
    present_layered(g_hwnd, g_memdc, w, h);
}

static LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_CREATE:
        return 0;
    case WM_KEYDOWN:
        if (wParam == VK_ESCAPE) {
            PostQuitMessage(0);
        }
        return 0;
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    default:
        return DefWindowProc(hwnd, msg, wParam, lParam);
    }
}

int APIENTRY wWinMain(HINSTANCE hInst, HINSTANCE hPrev, LPWSTR lpCmdLine, int nShow) {
    srand((unsigned int)time(NULL));
    timeBeginPeriod(1);

    WNDCLASSEXW wc = {0};
    wc.cbSize = sizeof(wc);
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInst;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.lpszClassName = WND_CLASS_NAME;
    if (!RegisterClassExW(&wc)) return 0;

    DWORD ex = WS_EX_LAYERED | WS_EX_TOPMOST;
    DWORD style = WS_POPUP;

    int sw = GetSystemMetrics(SM_CXSCREEN);
    int sh = GetSystemMetrics(SM_CYSCREEN);
    int x = (sw - WIN_W) / 2;
    int y = (sh - WIN_H) / 2;

    g_hwnd = CreateWindowExW(ex, WND_CLASS_NAME, L"Neon Cube",
                             style, x, y, WIN_W, WIN_H,
                             NULL, NULL, hInst, NULL);
    if (!g_hwnd) return 0;

    create_dib(WIN_W, WIN_H);

    ShowWindow(g_hwnd, SW_SHOW);
    UpdateWindow(g_hwnd);

    QueryPerformanceFrequency(&g_freq);
    QueryPerformanceCounter(&g_prev);
    g_time = 0.0f;
    g_q = (Quat){1,0,0,0};
    randomize_axis_speed();
    randomize_color();

    MSG msg;
    BOOL running = TRUE;
    while (running) {
        while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) {
            if (msg.message == WM_QUIT) { running = FALSE; break; }
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
        LARGE_INTEGER now;
        QueryPerformanceCounter(&now);
        float dt = (float)((now.QuadPart - g_prev.QuadPart) / (double)g_freq.QuadPart);
        if (dt > 0.1f) dt = 0.1f; // clamp
        g_prev = now;
        g_time += dt;

        // Update state
        update_rotation(dt);
        if (g_time >= g_nextAxisChange) randomize_axis_speed();
        if (g_time >= g_nextColorChange) randomize_color();

        // Render
        render_frame();

        Sleep(16);
    }

    if (g_memdc) DeleteDC(g_memdc);
    if (g_dib) DeleteObject(g_dib);
    timeEndPeriod(1);
    return 0;
}