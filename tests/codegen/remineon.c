/*
 remineon.c
 SDL2 + SDL2_ttf program that displays text from "showme.txt" with a neon glow,
 pulsing alpha, and periodic spin. One line per minute, with file reload detection.

 Build (Linux):
   gcc -std=c99 -O2 -Wall -Wextra remineon.c -o remineon `sdl2-config --cflags --libs` -lSDL2_ttf
 Build (MSYS2/MinGW):
   gcc -std=c99 -O2 -Wall -Wextra remineon.c -o remineon.exe -lmingw32 -lSDL2main -lSDL2 -lSDL2_ttf
*/

#include <SDL.h>
#include <SDL_ttf.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/stat.h>

static int running = 1;

/* Small helpers */

static char *xstrdup(const char *s) {
    if (!s) return NULL;
    size_t n = strlen(s) + 1;
    char *p = (char *)malloc(n);
    if (p) memcpy(p, s, n);
    return p;
}

__attribute__((unused))
static void trim_crlf(char *s) {
    if (!s) return;
    size_t n = strlen(s);
    while (n > 0) {
        char c = s[n - 1];
        if (c == '\n' || c == '\r') {
            s[n - 1] = '\0';
            n--;
        } else {
            break;
        }
    }
}

static int64_t file_mtime(const char *path) {
    struct stat st;
    if (stat(path, &st) != 0) return 0;
    return (int64_t)st.st_mtime;
}

static float randf01(void) {
    return (float)rand() / (float)RAND_MAX;
}

/* Fast sine approximation to avoid linking with -lm.
   Range reduction to [-pi, pi], then parabolic + correction approximation. */
static float fast_sin(float x) {
    const float PI = 3.14159265358979323846f;
    const float TWO_PI = 6.28318530717958647692f;
    while (x > PI) x -= TWO_PI;
    while (x < -PI) x += TWO_PI;
    float y = (4.0f / PI) * x - (4.0f / (PI * PI)) * x * (x < 0.0f ? -x : x);
    float yabs = y < 0.0f ? -y : y;
    float sin_approx = 0.225f * (y * yabs - y) + y;
    return sin_approx;
}

static void hsv_to_rgb(float h, float s, float v, Uint8 *r, Uint8 *g, Uint8 *b) {
    float rr = v, gg = v, bb = v;
    if (s <= 0.0f) {
        rr = gg = bb = v;
    } else {
        float hh = h * 6.0f;
        if (hh >= 6.0f) hh = 5.0f;
        int i = (int)hh;
        float f = hh - (float)i;
        float p = v * (1.0f - s);
        float q = v * (1.0f - s * f);
        float t = v * (1.0f - s * (1.0f - f));
        switch (i) {
            case 0: rr = v; gg = t; bb = p; break;
            case 1: rr = q; gg = v; bb = p; break;
            case 2: rr = p; gg = v; bb = t; break;
            case 3: rr = p; gg = q; bb = v; break;
            case 4: rr = t; gg = p; bb = v; break;
            case 5: rr = v; gg = p; bb = q; break;
            default: rr = v; gg = t; bb = p; break;
        }
    }
    int R = (int)(rr * 255.0f + 0.5f);
    int G = (int)(gg * 255.0f + 0.5f);
    int B = (int)(bb * 255.0f + 0.5f);
    if (R < 0) R = 0;
    if (R > 255) R = 255;

    if (G < 0) G = 0;
    if (G > 255) G = 255;

    if (B < 0) B = 0;
    if (B > 255) B = 255;

    *r = (Uint8)R; *g = (Uint8)G; *b = (Uint8)B;
}

/* Text rendering structures */

typedef struct {
    SDL_Texture *tex;
    int w;
    int h;
    Uint8 base_alpha;
} TexPass;

typedef struct {
    char *text;
    int font_size;
    TTF_Font *font;
    TexPass outlines[3];
    TexPass mainpass;
    int outline_px[3];
} LineSpec;

/* Destroy textures for a line (keeps text and font if keep_font != 0) */
static void destroy_line_textures(LineSpec *ln) {
    if (!ln) return;
    for (int i = 0; i < 3; i++) {
        if (ln->outlines[i].tex) {
            SDL_DestroyTexture(ln->outlines[i].tex);
            ln->outlines[i].tex = NULL;
        }
        ln->outlines[i].w = ln->outlines[i].h = 0;
    }
    if (ln->mainpass.tex) {
        SDL_DestroyTexture(ln->mainpass.tex);
        ln->mainpass.tex = NULL;
    }
    ln->mainpass.w = ln->mainpass.h = 0;
}

/* Free all resources for a line */
static void free_line(LineSpec *ln) {
    if (!ln) return;
    destroy_line_textures(ln);
    if (ln->font) {
        TTF_CloseFont(ln->font);
        ln->font = NULL;
    }
    if (ln->text) {
        free(ln->text);
        ln->text = NULL;
    }
}

/* Fit font size to renderer output with 5% margins */
static int fit_font_size(const char *font_path, const char *text, int out_w, int out_h) {
    int avail_w = (int)(out_w * 0.90f);
    int avail_h = (int)(out_h * 0.90f);
    if (avail_w < 10) avail_w = 10;
    if (avail_h < 10) avail_h = 10;

    int lo = 8, hi = 512, best = 8;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        TTF_Font *f = TTF_OpenFont(font_path, mid);
        if (!f) {
            // If font fails to open at this size, treat as failure to fit by shrinking.
            hi = mid - 1;
            continue;
        }
        int w = 0, h = 0;
        if (TTF_SizeUTF8(f, text, &w, &h) != 0) {
            TTF_CloseFont(f);
            hi = mid - 1;
            continue;
        }
        TTF_CloseFont(f);
        if (w <= avail_w && h <= avail_h) {
            best = mid;
            lo = mid + 1;
        } else {
            hi = mid - 1;
        }
    }
    if (best < 8) best = 8;
    return best;
}

/* Prepare textures for a line for given RGB color */
static int prepare_line_textures(SDL_Renderer *renderer, LineSpec *ln, Uint8 r, Uint8 g, Uint8 b) {
    if (!ln || !ln->font || !ln->text) return -1;

    destroy_line_textures(ln);

    int base_outline = ln->font_size / 12;
    if (base_outline < 1) base_outline = 1;
    ln->outline_px[0] = base_outline * 3;
    ln->outline_px[1] = base_outline * 2;
    ln->outline_px[2] = base_outline * 1;

    Uint8 outline_alphas[3];
    outline_alphas[0] = 110;
    outline_alphas[1] = 70;
    outline_alphas[2] = 40;

    SDL_Color col = { r, g, b, 255 };

    for (int i = 0; i < 3; i++) {
        TTF_SetFontOutline(ln->font, ln->outline_px[i]);
        SDL_Surface *surf = TTF_RenderUTF8_Blended(ln->font, ln->text, col);
        if (!surf) {
            fprintf(stderr, "TTF_RenderUTF8_Blended (outline %d) failed: %s\n", ln->outline_px[i], TTF_GetError());
            return -1;
        }
        SDL_Texture *tx = SDL_CreateTextureFromSurface(renderer, surf);
        if (!tx) {
            fprintf(stderr, "SDL_CreateTextureFromSurface failed: %s\n", SDL_GetError());
            SDL_FreeSurface(surf);
            return -1;
        }
        SDL_SetTextureBlendMode(tx, SDL_BLENDMODE_BLEND);
        ln->outlines[i].tex = tx;
        ln->outlines[i].w = surf->w;
        ln->outlines[i].h = surf->h;
        ln->outlines[i].base_alpha = outline_alphas[i];
        SDL_FreeSurface(surf);
    }

    TTF_SetFontOutline(ln->font, 0);
    SDL_Surface *surf = TTF_RenderUTF8_Blended(ln->font, ln->text, col);
    if (!surf) {
        fprintf(stderr, "TTF_RenderUTF8_Blended (main) failed: %s\n", TTF_GetError());
        return -1;
    }
    SDL_Texture *tx = SDL_CreateTextureFromSurface(renderer, surf);
    if (!tx) {
        fprintf(stderr, "SDL_CreateTextureFromSurface (main) failed: %s\n", SDL_GetError());
        SDL_FreeSurface(surf);
        return -1;
    }
    SDL_SetTextureBlendMode(tx, SDL_BLENDMODE_BLEND);
    ln->mainpass.tex = tx;
    ln->mainpass.w = surf->w;
    ln->mainpass.h = surf->h;
    ln->mainpass.base_alpha = 255;
    SDL_FreeSurface(surf);

    return 0;
}

/* Build LineSpec array from an array of strings (adopt ownership of strings) */
static LineSpec *build_lines(char **lines, int count, const char *font_path, int out_w, int out_h) {
    if (count <= 0) return NULL;
    LineSpec *arr = (LineSpec *)calloc((size_t)count, sizeof(LineSpec));
    if (!arr) return NULL;
    for (int i = 0; i < count; i++) {
        arr[i].text = lines[i]; /* takes ownership */
        arr[i].font_size = fit_font_size(font_path, arr[i].text, out_w, out_h);
        arr[i].font = TTF_OpenFont(font_path, arr[i].font_size);
        if (!arr[i].font) {
            fprintf(stderr, "TTF_OpenFont failed at size %d: %s\n", arr[i].font_size, TTF_GetError());
            /* Free already created ones */
            for (int j = 0; j <= i; j++) free_line(&arr[j]);
            free(arr);
            return NULL;
        }
    }
    return arr;
}

/* Free lines array */
static void free_lines(LineSpec *arr, int count) {
    if (!arr) return;
    for (int i = 0; i < count; i++) free_line(&arr[i]);
    free(arr);
}

/* Load lines from showme.txt into array of strings; returns count, sets mtime */
static char **load_showme_lines(const char *path, int *out_count, int64_t *out_mtime) {
    *out_count = 0;
    if (out_mtime) *out_mtime = file_mtime(path);

    FILE *f = fopen(path, "rb");
    if (!f) {
        /* No file: return NO TEXT FOUND */
        char **arr = (char **)malloc(sizeof(char *));
        if (!arr) return NULL;
        arr[0] = xstrdup("NO TEXT FOUND");
        *out_count = 1;
        return arr;
    }
    if (fseek(f, 0, SEEK_END) != 0) {
        fclose(f);
        return NULL;
    }
    long sz = ftell(f);
    if (sz < 0) { fclose(f); return NULL; }
    if (fseek(f, 0, SEEK_SET) != 0) {
        fclose(f);
        return NULL;
    }
    char *buf = (char *)malloc((size_t)sz + 1);
    if (!buf) { fclose(f); return NULL; }
    size_t rd = fread(buf, 1, (size_t)sz, f);
    fclose(f);
    buf[rd] = '\0';

    int cap = 16;
    int cnt = 0;
    char **arr = (char **)malloc((size_t)cap * sizeof(char *));
    if (!arr) { free(buf); return NULL; }

    size_t i = 0;
    while (i < rd) {
        size_t start = i;
        while (i < rd && buf[i] != '\n') i++;
        size_t end = i;
        /* trim trailing CR or LF */
        while (end > start && (buf[end - 1] == '\r' || buf[end - 1] == '\n')) end--;
        size_t len = end > start ? (end - start) : 0;
        if (len > 0) {
            char *line = (char *)malloc(len + 1);
            if (!line) { /* OOM cleanup */
                for (int k = 0; k < cnt; k++) free(arr[k]);
                free(arr);
                free(buf);
                return NULL;
            }
            memcpy(line, buf + start, len);
            line[len] = '\0';
            if (cnt >= cap) {
                cap *= 2;
                char **tmp = (char **)realloc(arr, (size_t)cap * sizeof(char *));
                if (!tmp) {
                    for (int k = 0; k < cnt; k++) free(arr[k]);
                    free(arr);
                    free(buf);
                    free(line);
                    return NULL;
                }
                arr = tmp;
            }
            arr[cnt++] = line;
        }
        if (i < rd && buf[i] == '\n') i++;
    }
    free(buf);

    if (cnt == 0) {
        char **fallback = (char **)malloc(sizeof(char *));
        if (!fallback) {
            return NULL;
        }
        fallback[0] = xstrdup("NO TEXT FOUND");
        *out_count = 1;
        return fallback;
    }

    *out_count = cnt;
    return arr;
}

/* Choose a new random neon color (HSV with S>=0.9, V=1.0) */
static void choose_neon_rgb(Uint8 *r, Uint8 *g, Uint8 *b) {
    float h = randf01();
    float s = 0.9f + 0.1f * randf01();
    float v = 1.0f;
    hsv_to_rgb(h, s, v, r, g, b);
}

int main(int argc, char **argv) {
    srand((unsigned int)time(NULL));

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) != 0) {
        fprintf(stderr, "SDL_Init failed: %s\n", SDL_GetError());
        return 1;
    }
    if (TTF_Init() != 0) {
        fprintf(stderr, "TTF_Init failed: %s\n", TTF_GetError());
        SDL_Quit();
        return 1;
    }

    const char *font_path = NULL;
    if (argc >= 2) {
        font_path = argv[1];
    } else {
        font_path = "./font.ttf";
    }

    /* Verify font path; if provided and fails, fallback to ./font.ttf */
    TTF_Font *probe = TTF_OpenFont(font_path, 32);
    if (!probe) {
        if (strcmp(font_path, "./font.ttf") != 0) {
            probe = TTF_OpenFont("./font.ttf", 32);
            if (!probe) {
                fprintf(stderr, "Failed to open font '%s' and fallback './font.ttf': %s\n", font_path, TTF_GetError());
                TTF_Quit();
                SDL_Quit();
                return 1;
            } else {
                font_path = "./font.ttf";
            }
        } else {
            fprintf(stderr, "Failed to open font './font.ttf': %s\n", TTF_GetError());
            TTF_Quit();
            SDL_Quit();
            return 1;
        }
    }
    if (probe) TTF_CloseFont(probe);

    Uint32 win_flags = SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI;
    SDL_Window *win = SDL_CreateWindow("remineon", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1280, 720, win_flags);
    if (!win) {
        fprintf(stderr, "SDL_CreateWindow failed: %s\n", SDL_GetError());
        TTF_Quit();
        SDL_Quit();
        return 1;
    }

    Uint32 renderer_flags = SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC;
    SDL_Renderer *ren = SDL_CreateRenderer(win, -1, renderer_flags);
    if (!ren) {
        renderer_flags = SDL_RENDERER_ACCELERATED;
        ren = SDL_CreateRenderer(win, -1, renderer_flags);
        if (!ren) {
            fprintf(stderr, "SDL_CreateRenderer failed: %s\n", SDL_GetError());
            SDL_DestroyWindow(win);
            TTF_Quit();
            SDL_Quit();
            return 1;
        }
    }

    int out_w = 0, out_h = 0;
    if (SDL_GetRendererOutputSize(ren, &out_w, &out_h) != 0 || out_w <= 0 || out_h <= 0) {
        SDL_GetWindowSize(win, &out_w, &out_h);
    }
    if (out_w <= 0) out_w = 1280;
    if (out_h <= 0) out_h = 720;

    const char *txt_path = "showme.txt";
    int line_count = 0;
    int64_t last_mtime = 0;
    char **raw_lines = load_showme_lines(txt_path, &line_count, &last_mtime);
    if (!raw_lines) {
        fprintf(stderr, "Failed to load lines from '%s'\n", txt_path);
        SDL_DestroyRenderer(ren);
        SDL_DestroyWindow(win);
        TTF_Quit();
        SDL_Quit();
        return 1;
    }

    LineSpec *lines = build_lines(raw_lines, line_count, font_path, out_w, out_h);
    /* raw_lines' strings were adopted by build_lines; free only the container */
    free(raw_lines);
    if (!lines) {
        fprintf(stderr, "Failed to prepare lines (fonts)\n");
        SDL_DestroyRenderer(ren);
        SDL_DestroyWindow(win);
        TTF_Quit();
        SDL_Quit();
        return 1;
    }

    int current_idx = 0;
    Uint8 base_r = 255, base_g = 0, base_b = 255;
    choose_neon_rgb(&base_r, &base_g, &base_b);
    if (prepare_line_textures(ren, &lines[current_idx], base_r, base_g, base_b) != 0) {
        fprintf(stderr, "Failed to build textures for line %d\n", current_idx);
        free_lines(lines, line_count);
        SDL_DestroyRenderer(ren);
        SDL_DestroyWindow(win);
        TTF_Quit();
        SDL_Quit();
        return 1;
    }

    Uint32 cycle_start = SDL_GetTicks();
    Uint32 start_ticks = cycle_start;
    Uint32 last_reload_check = start_ticks;

    while (running) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) {
                running = 0;
            } else if (e.type == SDL_KEYDOWN) {
                if (e.key.keysym.sym == SDLK_ESCAPE) {
                    running = 0;
                }
            } else {
                /* ignore other events */
            }
        }

        Uint32 now = SDL_GetTicks();
        /* File reload check every 10 seconds */
        if (now - last_reload_check >= 10000u) {
            last_reload_check = now;
            int64_t mt = file_mtime(txt_path);
            if (mt != 0 && mt != last_mtime) {
                int new_count = 0;
                int64_t tmp_mt = 0;
                char **new_raw = load_showme_lines(txt_path, &new_count, &tmp_mt);
                if (new_raw) {
                    LineSpec *new_lines = build_lines(new_raw, new_count, font_path, out_w, out_h);
                    free(new_raw);
                    if (new_lines) {
                        /* preserve index if valid, else clamp */
                        int new_idx = current_idx;
                        if (new_idx >= new_count) new_idx = new_count - 1;
                        if (new_idx < 0) new_idx = 0;
                        /* free old */
                        free_lines(lines, line_count);
                        lines = new_lines;
                        line_count = new_count;
                        last_mtime = mt;
                        current_idx = new_idx;
                        /* Rebuild textures for current line with current color */
                        if (prepare_line_textures(ren, &lines[current_idx], base_r, base_g, base_b) != 0) {
                            fprintf(stderr, "Failed to rebuild textures after reload\n");
                            free_lines(lines, line_count);
                            SDL_DestroyRenderer(ren);
                            SDL_DestroyWindow(win);
                            TTF_Quit();
                            SDL_Quit();
                            return 1;
                        }
                    }
                }
            }
        }

        /* Minute cycle handling */
        Uint32 elapsed = now - cycle_start;
        if (elapsed >= 60000u) {
            current_idx = (current_idx + 1) % line_count;
            cycle_start = now;
            choose_neon_rgb(&base_r, &base_g, &base_b);
            if (prepare_line_textures(ren, &lines[current_idx], base_r, base_g, base_b) != 0) {
                fprintf(stderr, "Failed to build textures for new line %d\n", current_idx);
                free_lines(lines, line_count);
                SDL_DestroyRenderer(ren);
                SDL_DestroyWindow(win);
                TTF_Quit();
                SDL_Quit();
                return 1;
            }
        }

        /* Background black */
        SDL_SetRenderDrawColor(ren, 0, 0, 0, 255);
        SDL_RenderClear(ren);

        /* Pulsing alpha */
        float tsec = (now - start_ticks) / 1000.0f;
        const float F = 2.0f;
        const float PI = 3.14159265358979323846f;
        float s = fast_sin(2.0f * PI * F * tsec);
        int alphaPulse = (int)(160.0f + 95.0f * s);
        if (alphaPulse < 0) alphaPulse = 0;
        if (alphaPulse > 255) alphaPulse = 255;
        Uint8 pulse = (Uint8)alphaPulse;

        /* Spin at cycle start for 0.6s */
        float angle = 0.0f;
        Uint32 spin_ms = now - cycle_start;
        if (spin_ms < 600u) {
            angle = (spin_ms / 600.0f) * 360.0f;
        } else {
            angle = 0.0f;
        }

        /* Draw current line centered */
        LineSpec *ln = &lines[current_idx];
        int cx = out_w / 2;
        int cy = out_h / 2;

        for (int i = 0; i < 3; i++) {
            if (ln->outlines[i].tex) {
                Uint8 mod = (Uint8)((ln->outlines[i].base_alpha * pulse) / 255);
                SDL_SetTextureAlphaMod(ln->outlines[i].tex, mod);
                SDL_Rect dst;
                dst.w = ln->outlines[i].w;
                dst.h = ln->outlines[i].h;
                dst.x = cx - dst.w / 2;
                dst.y = cy - dst.h / 2;
                SDL_Point center = { dst.w / 2, dst.h / 2 };
                SDL_RenderCopyEx(ren, ln->outlines[i].tex, NULL, &dst, angle, &center, SDL_FLIP_NONE);
            }
        }
        if (ln->mainpass.tex) {
            Uint8 mod = pulse;
            SDL_SetTextureAlphaMod(ln->mainpass.tex, mod);
            SDL_Rect dst;
            dst.w = ln->mainpass.w;
            dst.h = ln->mainpass.h;
            dst.x = cx - dst.w / 2;
            dst.y = cy - dst.h / 2;
            SDL_Point center = { dst.w / 2, dst.h / 2 };
            SDL_RenderCopyEx(ren, ln->mainpass.tex, NULL, &dst, angle, &center, SDL_FLIP_NONE);
        }

        SDL_RenderPresent(ren);

        /* ~60 FPS frame cap */
        SDL_Delay(16);
    }

    free_lines(lines, line_count);
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    TTF_Quit();
    SDL_Quit();
    return 0;
}