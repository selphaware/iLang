#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#ifdef _WIN32
#include <windows.h>
static void sleep_ms(int ms){ Sleep(ms); }
#else
#include <unistd.h>
static void sleep_ms(int ms){ usleep(ms*1000); }
#endif

#define WIDTH  80
#define HEIGHT 30

static char canvas[HEIGHT][WIDTH];
static int  colorf[HEIGHT][WIDTH];

static const float ASPECT = 2.0f; // character width/height aspect compensation

static void term_write(const char *s){ fputs(s, stdout); }
static void term_clear_screen(void){ term_write("\x1b[2J\x1b[H"); }
static void term_hide_cursor(void){ term_write("\x1b[?25l"); }
static void term_show_cursor(void){ term_write("\x1b[?25h"); }

static void clear_canvas(void){
    for(int y=0;y<HEIGHT;y++){
        for(int x=0;x<WIDTH;x++){
            canvas[y][x] = ' ';
            colorf[y][x] = -1;
        }
    }
}

static void putpx(int x,int y,char ch,int col){
    if(x<0||x>=WIDTH||y<0||y>=HEIGHT) return;
    canvas[y][x]=ch;
    colorf[y][x]=col;
}

static void render_canvas(void){
    // Move home once, then draw line by line without clearing
    term_write("\x1b[H");
    for(int y=0;y<HEIGHT;y++){
        int cur = -2;
        for(int x=0;x<WIDTH;x++){
            int c = colorf[y][x];
            if(c!=cur){
                if(c<0) term_write("\x1b[0m");
                else {
                    char esc[32];
                    snprintf(esc, sizeof(esc), "\x1b[38;5;%dm", c);
                    term_write(esc);
                }
                cur=c;
            }
            fputc(canvas[y][x], stdout);
        }
        term_write("\x1b[0m");
        if(y<HEIGHT-1) fputc('\n', stdout);
    }
    fflush(stdout);
}

static int clampi(int v,int a,int b){ return v<a?a:(v>b?b:v); }
static float clampf(float v,float a,float b){ return v<a?a:(v>b?b:v); }

static int fire_color_from_t(float t){
    // t in [0,1] center->1
    if(t>0.92f) return 231;   // white
    if(t>0.80f) return 229;   // light yellow
    if(t>0.65f) return 226;   // yellow
    if(t>0.50f) return 220;   // gold
    if(t>0.35f) return 214;   // orange
    if(t>0.20f) return 208;   // dark orange
    if(t>0.08f) return 202;   // orange-red
    return 196;               // red
}

static char fire_char_from_t(float t){
    if(t>0.85f) return '@';
    if(t>0.65f) return 'O';
    if(t>0.45f) return 'o';
    if(t>0.25f) return '*';
    if(t>0.10f) return '+';
    return '.';
}

static void draw_ground(int gy){
    int col = 130; // brown
    for(int x=0;x<WIDTH;x++){
        putpx(x, gy, '=', col);
        if(gy+1<HEIGHT) putpx(x, gy+1, '=', 94);
    }
}

static void draw_fireball(float cx,float cy,float r){
    int x0 = clampi((int)(cx - r*ASPECT - 2), 0, WIDTH-1);
    int x1 = clampi((int)(cx + r*ASPECT + 2), 0, WIDTH-1);
    int y0 = clampi((int)(cy - r - 2), 0, HEIGHT-1);
    int y1 = clampi((int)(cy + r + 2), 0, HEIGHT-1);
    for(int y=y0; y<=y1; y++){
        for(int x=x0; x<=x1; x++){
            float dx = (x - cx)/ASPECT;
            float dy = (y - cy);
            float d = sqrtf(dx*dx + dy*dy);
            if(d <= r){
                float t = 1.0f - d/r;
                // slight flicker
                float flicker = (rand()%100 < 3) ? 0.08f : 0.0f;
                t = clampf(t + flicker, 0.0f, 1.0f);
                int col = fire_color_from_t(t);
                char ch = fire_char_from_t(t);
                putpx(x,y,ch,col);
            }
        }
    }
}

static void draw_ring(float cx,float cy,float rr,float thick){
    float t2 = thick*thick;
    int x0 = clampi((int)(cx - (rr+thick)*ASPECT - 2), 0, WIDTH-1);
    int x1 = clampi((int)(cx + (rr+thick)*ASPECT + 2), 0, WIDTH-1);
    int y0 = clampi((int)(cy - (rr+thick) - 2), 0, HEIGHT-1);
    int y1 = clampi((int)(cy + (rr+thick) + 2), 0, HEIGHT-1);
    for(int y=y0; y<=y1; y++){
        for(int x=x0; x<=x1; x++){
            float dx=(x-cx)/ASPECT, dy=(y-cy);
            float d = sqrtf(dx*dx+dy*dy);
            float dd = d-rr;
            if(fabsf(dd) <= thick){
                int col = (fabsf(dd) < thick*0.5f) ? 231 : 250;
                char ch = (fabsf(dd) < thick*0.5f) ? 'o' : '.';
                putpx(x,y,ch,col);
            }
        }
    }
}

static void draw_smoke_disc(float cx,float cy,float r, int cmin, int cmax, char ch){
    int x0 = clampi((int)(cx - r*ASPECT - 2), 0, WIDTH-1);
    int x1 = clampi((int)(cx + r*ASPECT + 2), 0, WIDTH-1);
    int y0 = clampi((int)(cy - r - 2), 0, HEIGHT-1);
    int y1 = clampi((int)(cy + r + 2), 0, HEIGHT-1);
    for(int y=y0; y<=y1; y++){
        for(int x=x0; x<=x1; x++){
            float dx=(x-cx)/ASPECT, dy=(y-cy);
            float d = sqrtf(dx*dx+dy*dy);
            if(d <= r){
                float t = 1.0f - d/r;
                int col = cmin + (int)((cmax - cmin)*t);
                col = clampi(col, cmin, cmax);
                putpx(x,y,ch,col);
            }
        }
    }
}

static void draw_mushroom(float cx, float ycap, float rcap, float heat, int groundY){
    // Cap using superellipse
    float ry = rcap * 0.60f;
    int x0 = clampi((int)(cx - rcap*ASPECT - 2), 0, WIDTH-1);
    int x1 = clampi((int)(cx + rcap*ASPECT + 2), 0, WIDTH-1);
    int y0 = clampi((int)(ycap - ry - 2), 0, HEIGHT-1);
    int y1 = clampi((int)(ycap + ry + 2), 0, HEIGHT-1);
    for(int y=y0; y<=y1; y++){
        for(int x=x0; x<=x1; x++){
            float dx = fabsf((x - cx)/ASPECT)/rcap;
            float dy = fabsf((y - ycap))/ry;
            float s = powf(dx, 2.3f) + powf(dy, 2.3f);
            if(s <= 1.0f){
                float t = 1.0f - s;
                int grey = 244 + (int)(t*6.0f); // 244..250
                grey = clampi(grey, 238, 251);
                int col = grey;
                // underside glow
                if((y - ycap) > 0.0f && heat > 0.0f){
                    float ug = clampf(((y - ycap)/ry)*0.9f, 0.0f, 1.0f) * heat;
                    int warm = (ug>0.6f)?214: (ug>0.35f?208:202);
                    // pick warmer of the two visually by index
                    col = (ug>0.05f) ? warm : col;
                }
                char ch = (t>0.65f)? '#': (t>0.35f? 'O': (t>0.15f? 'o' : '+'));
                putpx(x,y,ch,col);
            }
        }
    }
    // Stem
    float stemW = fmaxf(2.0f, rcap*0.28f);
    for(int y=(int)ycap; y<groundY; y++){
        for(int x=0; x<WIDTH; x++){
            float dx = fabsf((x - cx)/ASPECT);
            float wobble = ((rand()%100)<3)? 0.6f: 0.0f;
            if(dx <= stemW + wobble){
                int col = 244 + (rand()%3); // grey
                char ch = (rand()%100<20)? '#':'#';
                putpx(x,y,ch,col);
            }
        }
        stemW *= 0.97f; // taper
        if(stemW < 1.2f) stemW = 1.2f;
    }
}

typedef struct {
    float x,y,vx,vy;
    int life, maxlife;
    int color;
    char ch;
    int alive;
} Particle;

#define MAXP 220
static Particle P[MAXP];

static void init_particles(float cx, float cy){
    for(int i=0;i<MAXP;i++){
        float ang = ((float)rand()/RAND_MAX) * (3.1415926f*1.2f) - 3.1415926f*0.1f; // mostly upward
        float spd = 0.6f + ((float)rand()/RAND_MAX)*1.6f;
        P[i].x = cx;
        P[i].y = cy;
        P[i].vx = cosf(ang)*spd*1.0f;
        P[i].vy = sinf(ang)*spd*1.0f - 0.2f;
        P[i].life = P[i].maxlife = 40 + rand()%90;
        P[i].color = (rand()%2)? 226: 214;
        P[i].ch = (rand()%2)? '*': '+';
        P[i].alive = 1;
    }
}

static void update_particles(void){
    for(int i=0;i<MAXP;i++){
        if(!P[i].alive) continue;
        P[i].x += P[i].vx;
        P[i].y += P[i].vy;
        // drag and gravity
        P[i].vx *= 0.99f;
        P[i].vy *= 0.99f;
        P[i].vy += 0.03f;
        P[i].life--;
        if(P[i].life<=0) P[i].alive=0;
    }
}

static void draw_particles(void){
    for(int i=0;i<MAXP;i++){
        if(!P[i].alive) continue;
        int x = (int)(P[i].x);
        int y = (int)(P[i].y);
        int col = P[i].color;
        // fade to dark
        float t = (float)P[i].life / (float)P[i].maxlife;
        if(t < 0.35f) col = 202;
        if(t < 0.20f) col = 196;
        if(t < 0.10f) col = 94;
        putpx(x,y,P[i].ch,col);
    }
}

int main(void){
    srand((unsigned)time(NULL));
    term_hide_cursor();
    term_clear_screen();

    const int groundY = HEIGHT - 4;
    const float cx = WIDTH/2.0f;
    float cy = groundY - 2.0f;

    int total_frames = 220;
    int delay_ms = 35;

    init_particles(cx, cy);

    for(int f=0; f<total_frames; f++){
        clear_canvas();

        // Phase selection
        int phase = 0;
        if(f < 12) phase = 0;            // blinding flash
        else if(f < 80) phase = 1;       // fireball growth + shockwave
        else if(f < 160) phase = 2;      // mushroom cloud rising
        else phase = 3;                  // dissipating smoke

        // Background faint haze
        if(phase!=0){
            // subtle sky haze
            for(int i=0;i<WIDTH/3;i++){
                int x = rand()%WIDTH;
                int y = rand()%(groundY-6);
                putpx(x,y,'.', 245 + rand()%3);
            }
        }

        draw_ground(groundY);

        if(phase==0){
            // Flash
            int col = (f%2==0)? 231 : 230;
            for(int y=0;y<HEIGHT;y++){
                for(int x=0;x<WIDTH;x++){
                    putpx(x,y,'#',col);
                }
            }
            // Keep ground silhouette darker
            for(int x=0;x<WIDTH;x++){
                putpx(x, groundY, '=', 130);
                if(groundY+1<HEIGHT) putpx(x, groundY+1, '=', 94);
            }
        } else if(phase==1){
            int t = f - 12;
            float r = 1.0f + 0.35f * t;      // up to ~22
            float lift = 0.06f * t;
            float lcx = cx;
            float lcy = cy - lift;
            draw_fireball(lcx, lcy, r);

            // Shockwave ring (expands faster than fireball)
            float rr = 2.0f + 0.70f * t;
            draw_ring(lcx, lcy, rr, 0.6f);

            // Early smoke
            draw_smoke_disc(cx, groundY-1.5f, r*0.85f, 240, 247, '#');
        } else if(phase==2){
            int t = f - 80;
            // Residual core heat shrinking
            int tcore = (t<30)? (30 - t) : 0;
            if(tcore>0){
                float r = 6.0f + 0.12f * tcore;
                draw_fireball(cx, cy - 4.0f, r);
            }
            // Mushroom cap + stem
            float prog = clampf((f - 80)/80.0f, 0.0f, 1.0f);
            float rcap = 12.0f + sinf(prog*1.5708f)*6.0f;
            float ycap = groundY - 8.0f - prog*8.0f;
            float heat = 1.0f - prog*0.9f;
            draw_mushroom(cx, ycap, rcap, heat, groundY);

            // Outward shockwave continues to propagate faintly
            float rr = 2.0f + 0.70f * (80-12) + 0.40f * (f-80);
            draw_ring(cx, cy-2.0f, rr, 0.4f);

            // Base rolling cloud
            draw_smoke_disc(cx, groundY-1.0f, rcap*0.9f + prog*6.0f, 238, 246, 'O');
        } else {
            int t = f - 160;
            float spread = 16.0f + t*0.8f;
            float rise = t*0.12f;
            // Large dissipating grey cloud
            draw_smoke_disc(cx, (groundY - 10.0f - rise), spread*0.5f, 243, 250, '#');
            draw_smoke_disc(cx-10, (groundY - 9.0f - rise*0.9f), spread*0.4f, 242, 248, 'O');
            draw_smoke_disc(cx+11, (groundY - 9.5f - rise*0.8f), spread*0.45f, 242, 248, 'O');
            // Ground dust
            draw_smoke_disc(cx, groundY-1.0f, spread*0.6f, 238, 244, '+');
        }

        // Sparks/embers
        update_particles();
        draw_particles();

        render_canvas();
        sleep_ms(delay_ms);
    }

    term_write("\x1b[0m");
    term_show_cursor();
    term_write("\n");
    return 0;
}