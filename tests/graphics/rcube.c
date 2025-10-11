#include <stdlib.h>
#include <GL/glut.h>

static float angle = 0.0f;
static int lastTime = 0;

void display(void) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(0.0, 0.0, 5.0,
              0.0, 0.0, 0.0,
              0.0, 1.0, 0.0);

    glRotatef(angle, 1.0f, 1.0f, 0.5f);

    glColor3f(0.0f, 1.0f, 0.0f);  // neon green
    glLineWidth(2.0f);
    glutWireCube(2.0);

    glutSwapBuffers();
}

void reshape(int w, int h) {
    if (h == 0) h = 1;
    float aspect = (float)w / (float)h;

    glViewport(0, 0, w, h);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0, aspect, 0.1, 100.0);
}

void idle(void) {
    int t = glutGet(GLUT_ELAPSED_TIME);
    if (lastTime == 0) lastTime = t;
    float dt = (t - lastTime) / 1000.0f;
    lastTime = t;

    angle += 60.0f * dt;  // 60 degrees per second
    if (angle >= 360.0f) angle -= 360.0f;

    glutPostRedisplay();
}

void onKey(unsigned char key, int x, int y) {
    (void)key; (void)x; (void)y;
    exit(0);
}

void onSpecial(int key, int x, int y) {
    (void)key; (void)x; (void)y;
    exit(0);
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Rotating Wireframe Cube");

    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);  // black background
    glEnable(GL_DEPTH_TEST);

    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);
    glutKeyboardFunc(onKey);
    glutSpecialFunc(onSpecial);

    glutMainLoop();
    return 0;
}