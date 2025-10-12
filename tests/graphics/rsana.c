#include <stdlib.h>
#include <string.h>
#include <math.h>

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

static int winW = 800, winH = 600;
static float angleDeg = 0.0f;
static const char* text = "SANA";

static float stroke_string_width(void* font, const char* s) {
    float w = 0.0f;
    for (const unsigned char* p = (const unsigned char*)s; *p; ++p)
        w += glutStrokeWidth(font, *p);
    return w;
}

// Approximate height for GLUT_STROKE_ROMAN (works across GLUT/freeglut)
static float stroke_font_height(void* font) {
    (void)font; // unused, kept for symmetry
    return 119.05f; // empirically known constant for GLUT_STROKE_ROMAN
}

static void draw_stroke_text_centered(const char* s, float scale) {
    void* font = GLUT_STROKE_ROMAN;
    float w = stroke_string_width(font, s);
    float h = stroke_font_height(font);

    glPushMatrix();
    glScalef(scale, scale, 1.0f);
    glTranslatef(-w * 0.5f, -h * 0.5f, 0.0f); // center the string

    for (const unsigned char* p = (const unsigned char*)s; *p; ++p) {
        glutStrokeCharacter(font, *p);
    }
    glPopMatrix();
}

static void display(void) {
    glClear(GL_COLOR_BUFFER_BIT);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    // Smooth neon lines
    glEnable(GL_LINE_SMOOTH);
    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE); // additive for glow

    // Center and rotate the word
    glTranslatef(0.0f, 0.0f, 0.0f);
    glRotatef(angleDeg, 0.0f, 0.0f, 1.0f);

    // Scale text to fit window height
    float targetHeight = winH * 0.35f; // 35% of window height
    float baseHeight = stroke_font_height(GLUT_STROKE_ROMAN);
    float scale = targetHeight / baseHeight;

    // Neon glow layers (from wide faint to narrow brighter)
    const float neonR = 0.10f, neonG = 1.00f, neonB = 0.90f; // cyan-neon
    int layers = 8;
    for (int i = layers; i >= 1; --i) {
        float t = (float)i / (float)layers;          // 1..0
        float alpha = 0.06f + 0.08f * t;             // faint to stronger
        float lw = 2.0f + 3.0f * i;                  // thicker outer glow
        glLineWidth(lw);
        glColor4f(neonR, neonG, neonB, alpha);
        draw_stroke_text_centered(text, scale);
    }

    // Core bright stroke
    glLineWidth(2.5f);
    glColor4f(neonR, neonG, neonB, 1.0f);
    draw_stroke_text_centered(text, scale);

    glutSwapBuffers();
}

static void reshape(int w, int h) {
    winW = (w > 1) ? w : 1;
    winH = (h > 1) ? h : 1;
    glViewport(0, 0, winW, winH);
}

static void timer(int value) {
    (void)value;
    angleDeg += 0.5f; // rotation speed (deg per frame tick)
    if (angleDeg >= 360.0f) angleDeg -= 360.0f;
    glutPostRedisplay();
    glutTimerFunc(16, timer, 0); // ~60 FPS
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_MULTISAMPLE);
    glutInitWindowSize(winW, winH);
    glutCreateWindow("SANA Neon Rotation");

    // Black background
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

#ifdef GL_MULTISAMPLE
    glEnable(GL_MULTISAMPLE);
#endif

    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutTimerFunc(0, timer, 0);

    glutMainLoop();
    return 0;
}