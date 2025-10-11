	.file	"bsmily.c"
	.intel_syntax noprefix
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.def	drawCircle;	.scl	3;	.type	32;	.endef
	.seh_proc	drawCircle
drawCircle:
	push	r12	 #
	.seh_pushreg	r12
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 160	 #,
	.seh_stackalloc	160
	movups	XMMWORD PTR 64[rsp], xmm6	 #,
	.seh_savexmm	xmm6, 64
	movups	XMMWORD PTR 80[rsp], xmm7	 #,
	.seh_savexmm	xmm7, 80
	movups	XMMWORD PTR 96[rsp], xmm8	 #,
	.seh_savexmm	xmm8, 96
	movups	XMMWORD PTR 112[rsp], xmm9	 #,
	.seh_savexmm	xmm9, 112
	movups	XMMWORD PTR 128[rsp], xmm10	 #,
	.seh_savexmm	xmm10, 128
	movups	XMMWORD PTR 144[rsp], xmm11	 #,
	.seh_savexmm	xmm11, 144
	.seh_endprologue
 # bsmily.c:10:     float step = 2.0f * (float)PI / (float)segments;
	pxor	xmm0, xmm0	 # _1
 # bsmily.c:13:     for (int i = 1; i <= segments; ++i) {
	mov	ebx, 1	 # i,
 # bsmily.c:10:     float step = 2.0f * (float)PI / (float)segments;
	movss	xmm11, DWORD PTR .LC0[rip]	 # tmp126,
 # bsmily.c:9: static void drawCircle(SDL_Renderer* r, float cx, float cy, float radius, int segments) {
	mov	esi, DWORD PTR 240[rsp]	 # segments, segments
 # bsmily.c:10:     float step = 2.0f * (float)PI / (float)segments;
	cvtsi2ss	xmm0, esi	 # _1, segments
	add	esi, 1	 # _38,
 # bsmily.c:11:     float prevX = cx + radius;
	movaps	xmm7, xmm1	 # x, cx
 # bsmily.c:9: static void drawCircle(SDL_Renderer* r, float cx, float cy, float radius, int segments) {
	movaps	xmm10, xmm1	 # cx, cx
	movaps	xmm9, xmm2	 # cy, cy
	mov	rdi, rcx	 # r, r
 # bsmily.c:11:     float prevX = cx + radius;
	addss	xmm7, xmm3	 # x, radius
 # bsmily.c:9: static void drawCircle(SDL_Renderer* r, float cx, float cy, float radius, int segments) {
	movaps	xmm8, xmm3	 # radius, radius
 # bsmily.c:12:     float prevY = cy;
	movaps	xmm6, xmm2	 # y, cy
 # bsmily.c:10:     float step = 2.0f * (float)PI / (float)segments;
	divss	xmm11, xmm0	 # step, _1
	lea	rbp, 56[rsp]	 # tmp138,
	.p2align 4
	.p2align 3
.L2:
 # bsmily.c:14:         float a = i * step;
	pxor	xmm0, xmm0	 # _2
	mov	r8, rbp	 #, tmp138
	lea	rdx, 60[rsp]	 #,
	cvtsi2ss	xmm0, ebx	 # _2, i
 # bsmily.c:13:     for (int i = 1; i <= segments; ++i) {
	add	ebx, 1	 # i,
 # bsmily.c:14:         float a = i * step;
	mulss	xmm0, xmm11	 # a_22, step
	call	sincosf	 #
	movaps	xmm0, xmm6	 # prevY, y
	movaps	xmm1, xmm7	 # prevX, x
 # bsmily.c:17:         SDL_RenderDrawLine(r, (int)prevX, (int)prevY, (int)x, (int)y);
	mov	rcx, rdi	 #, r
 # bsmily.c:16:         float y = cy + radius * sinf(a);
	movss	xmm6, DWORD PTR 60[rsp]	 # _6,
 # bsmily.c:15:         float x = cx + radius * cosf(a);
	movss	xmm7, DWORD PTR 56[rsp]	 # _4,
 # bsmily.c:17:         SDL_RenderDrawLine(r, (int)prevX, (int)prevY, (int)x, (int)y);
	cvttss2si	edx, xmm1	 # _10, prevX
	cvttss2si	r8d, xmm0	 #, prevY
 # bsmily.c:16:         float y = cy + radius * sinf(a);
	mulss	xmm6, xmm8	 # _6, radius
 # bsmily.c:15:         float x = cx + radius * cosf(a);
	mulss	xmm7, xmm8	 # _4, radius
 # bsmily.c:16:         float y = cy + radius * sinf(a);
	addss	xmm6, xmm9	 # y, cy
 # bsmily.c:15:         float x = cx + radius * cosf(a);
	addss	xmm7, xmm10	 # x, cx
 # bsmily.c:17:         SDL_RenderDrawLine(r, (int)prevX, (int)prevY, (int)x, (int)y);
	cvttss2si	eax, xmm6	 # _7, y
	cvttss2si	r9d, xmm7	 #, x
	mov	DWORD PTR 32[rsp], eax	 #, _7
	call	SDL_RenderDrawLine	 #
 # bsmily.c:13:     for (int i = 1; i <= segments; ++i) {
	cmp	ebx, esi	 # i, _38
	jne	.L2	 #,
 # bsmily.c:21: }
	movups	xmm6, XMMWORD PTR 64[rsp]	 #,
	movups	xmm7, XMMWORD PTR 80[rsp]	 #,
	movups	xmm8, XMMWORD PTR 96[rsp]	 #,
	movups	xmm9, XMMWORD PTR 112[rsp]	 #,
	movups	xmm10, XMMWORD PTR 128[rsp]	 #,
	movups	xmm11, XMMWORD PTR 144[rsp]	 #,
	add	rsp, 160	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	pop	r12	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC10:
	.ascii "Bouncing Smiley\0"
	.text
	.p2align 4
	.globl	SDL_main
	.def	SDL_main;	.scl	2;	.type	32;	.endef
	.seh_proc	SDL_main
SDL_main:
	push	r15	 #
	.seh_pushreg	r15
	push	r14	 #
	.seh_pushreg	r14
	push	r13	 #
	.seh_pushreg	r13
	push	r12	 #
	.seh_pushreg	r12
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 296	 #,
	.seh_stackalloc	296
	movups	XMMWORD PTR 128[rsp], xmm6	 #,
	.seh_savexmm	xmm6, 128
	movups	XMMWORD PTR 144[rsp], xmm7	 #,
	.seh_savexmm	xmm7, 144
	movups	XMMWORD PTR 160[rsp], xmm8	 #,
	.seh_savexmm	xmm8, 160
	movups	XMMWORD PTR 176[rsp], xmm9	 #,
	.seh_savexmm	xmm9, 176
	movups	XMMWORD PTR 192[rsp], xmm10	 #,
	.seh_savexmm	xmm10, 192
	movups	XMMWORD PTR 208[rsp], xmm11	 #,
	.seh_savexmm	xmm11, 208
	movups	XMMWORD PTR 224[rsp], xmm12	 #,
	.seh_savexmm	xmm12, 224
	movups	XMMWORD PTR 240[rsp], xmm13	 #,
	.seh_savexmm	xmm13, 240
	movups	XMMWORD PTR 256[rsp], xmm14	 #,
	.seh_savexmm	xmm14, 256
	movups	XMMWORD PTR 272[rsp], xmm15	 #,
	.seh_savexmm	xmm15, 272
	.seh_endprologue
 # bsmily.c:56:     if (SDL_Init(SDL_INIT_VIDEO) != 0) return 1;
	mov	ecx, 32	 #,
	call	SDL_Init	 #
 # bsmily.c:56:     if (SDL_Init(SDL_INIT_VIDEO) != 0) return 1;
	test	eax, eax	 # _1
	je	.L32	 #,
.L6:
 # bsmily.c:56:     if (SDL_Init(SDL_INIT_VIDEO) != 0) return 1;
	mov	r14d, 1	 # <retval>,
.L5:
 # bsmily.c:107: }
	movups	xmm6, XMMWORD PTR 128[rsp]	 #,
	mov	eax, r14d	 #, <retval>
	movups	xmm7, XMMWORD PTR 144[rsp]	 #,
	movups	xmm8, XMMWORD PTR 160[rsp]	 #,
	movups	xmm9, XMMWORD PTR 176[rsp]	 #,
	movups	xmm10, XMMWORD PTR 192[rsp]	 #,
	movups	xmm11, XMMWORD PTR 208[rsp]	 #,
	movups	xmm12, XMMWORD PTR 224[rsp]	 #,
	movups	xmm13, XMMWORD PTR 240[rsp]	 #,
	movups	xmm14, XMMWORD PTR 256[rsp]	 #,
	movups	xmm15, XMMWORD PTR 272[rsp]	 #,
	add	rsp, 296	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	pop	r12	 #
	pop	r13	 #
	pop	r14	 #
	pop	r15	 #
	ret	
	.p2align 4,,10
	.p2align 3
.L32:
 # bsmily.c:58:     SDL_Window* win = SDL_CreateWindow("Bouncing Smiley",
	mov	DWORD PTR 40[rsp], 4	 #,
	mov	r9d, 800	 #,
	mov	r8d, 805240832	 #,
	mov	edx, 805240832	 #,
	mov	DWORD PTR 32[rsp], 600	 #,
	lea	rcx, .LC10[rip]	 #,
	call	SDL_CreateWindow	 #
	mov	rbx, rax	 # win,
 # bsmily.c:61:     if (!win) { SDL_Quit(); return 1; }
	test	rax, rax	 # win
	je	.L33	 #,
 # bsmily.c:63:     SDL_Renderer* ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
	mov	r8d, 6	 #,
	mov	edx, -1	 #,
	mov	rcx, rax	 #, win
	call	SDL_CreateRenderer	 #
	mov	rdi, rax	 # ren,
 # bsmily.c:64:     if (!ren) { SDL_DestroyWindow(win); SDL_Quit(); return 1; }
	test	rax, rax	 # ren
	je	.L34	 #,
 # bsmily.c:70:     Uint32 last = SDL_GetTicks();
	call	SDL_GetTicks	 #
 # bsmily.c:67:     float x = WIDTH * 0.5f, y = HEIGHT * 0.5f;
	movss	xmm7, DWORD PTR .LC9[rip]	 # x,
	lea	rbp, 64[rsp]	 # tmp214,
	mov	r15, rbx	 # win, win
 # bsmily.c:68:     float vx = 220.0f, vy = 180.0f;
	movss	xmm13, DWORD PTR .LC7[rip]	 # vx,
 # bsmily.c:70:     Uint32 last = SDL_GetTicks();
	mov	r12d, eax	 # last, last
 # bsmily.c:68:     float vx = 220.0f, vy = 180.0f;
	movss	xmm14, DWORD PTR .LC6[rip]	 # vy,
 # bsmily.c:67:     float x = WIDTH * 0.5f, y = HEIGHT * 0.5f;
	movss	xmm9, DWORD PTR .LC8[rip]	 # y,
	movss	xmm15, DWORD PTR .LC12[rip]	 # tmp217,
	movss	xmm12, DWORD PTR .LC2[rip]	 # tmp220,
	movss	DWORD PTR 48[rsp], xmm13	 # %sfp, vx
	movss	xmm8, DWORD PTR .LC22[rip]	 # tmp215,
 # bsmily.c:31:         float a = start + i * step;
	movss	xmm11, DWORD PTR .LC23[rip]	 # tmp224,
	.p2align 4
	.p2align 3
.L10:
 # bsmily.c:54: int main(int argc, char** argv) {
	mov	esi, 1	 # running,
	jmp	.L25	 #
	.p2align 4,,10
	.p2align 3
.L11:
 # bsmily.c:75:             if (e.type == SDL_QUIT) running = false;
	mov	eax, DWORD PTR 64[rsp]	 # _106, e.type
	and	ah, -3	 # _106,
 # bsmily.c:76:             if (e.type == SDL_KEYDOWN) running = false;
	cmp	eax, 256	 # _106,
	setne	al	 #, _36
	and	esi, eax	 # running, _36
.L25:
 # bsmily.c:74:         while (SDL_PollEvent(&e)) {
	mov	rcx, rbp	 #, tmp214
	call	SDL_PollEvent	 #
	mov	r14d, eax	 # <retval>, <retval>
 # bsmily.c:74:         while (SDL_PollEvent(&e)) {
	test	eax, eax	 # <retval>
	jne	.L11	 #,
 # bsmily.c:79:         Uint32 now = SDL_GetTicks();
	call	SDL_GetTicks	 #
 # bsmily.c:80:         float dt = (now - last) / 1000.0f;
	pxor	xmm1, xmm1	 # _5
	movaps	xmm0, xmm15	 # tmp162, tmp217
 # bsmily.c:84:         x += vx * dt;
	movss	xmm4, DWORD PTR 48[rsp]	 # vx, %sfp
 # bsmily.c:79:         Uint32 now = SDL_GetTicks();
	mov	r13d, eax	 # now,
 # bsmily.c:80:         float dt = (now - last) / 1000.0f;
	sub	eax, r12d	 # _4, last
	movaps	xmm2, xmm15	 # tmp163, tmp217
	cvtsi2ss	xmm1, rax	 # _5, _4
 # bsmily.c:80:         float dt = (now - last) / 1000.0f;
	divss	xmm1, DWORD PTR .LC11[rip]	 # dt,
	cmpltss	xmm0, xmm1	 #, tmp162, dt
	andps	xmm2, xmm0	 # tmp163, tmp162
	andnps	xmm0, xmm1	 # tmp164, dt
 # bsmily.c:84:         x += vx * dt;
	movaps	xmm1, xmm4	 # _6, vx
	orps	xmm0, xmm2	 # _19, tmp163
	mulss	xmm1, xmm0	 # _6, _19
 # bsmily.c:85:         y += vy * dt;
	mulss	xmm0, xmm14	 # _7, vy
 # bsmily.c:84:         x += vx * dt;
	addss	xmm7, xmm1	 # x, _6
 # bsmily.c:87:         if (x - R < 0.0f) { x = R; vx = -vx; }
	pxor	xmm1, xmm1	 # tmp169
 # bsmily.c:85:         y += vy * dt;
	addss	xmm9, xmm0	 # y, _7
 # bsmily.c:87:         if (x - R < 0.0f) { x = R; vx = -vx; }
	movaps	xmm0, xmm7	 # _8, x
	subss	xmm0, xmm12	 # _8, tmp220
 # bsmily.c:87:         if (x - R < 0.0f) { x = R; vx = -vx; }
	comiss	xmm1, xmm0	 # tmp169, _8
	ja	.L35	 #,
 # bsmily.c:88:         if (x + R > WIDTH) { x = WIDTH - R; vx = -vx; }
	movaps	xmm0, xmm7	 # _9, x
	addss	xmm0, xmm12	 # _9, tmp220
 # bsmily.c:88:         if (x + R > WIDTH) { x = WIDTH - R; vx = -vx; }
	comiss	xmm0, DWORD PTR .LC15[rip]	 # _9,
	jbe	.L16	 #,
 # bsmily.c:88:         if (x + R > WIDTH) { x = WIDTH - R; vx = -vx; }
	movss	xmm5, DWORD PTR 48[rsp]	 # vx, %sfp
	xorps	xmm5, XMMWORD PTR .LC14[rip]	 # vx,
 # bsmily.c:88:         if (x + R > WIDTH) { x = WIDTH - R; vx = -vx; }
	movss	xmm7, DWORD PTR .LC1[rip]	 # x,
 # bsmily.c:88:         if (x + R > WIDTH) { x = WIDTH - R; vx = -vx; }
	movss	DWORD PTR 48[rsp], xmm5	 # %sfp, vx
.L16:
 # bsmily.c:89:         if (y - R < 0.0f) { y = R; vy = -vy; }
	movaps	xmm0, xmm9	 # _10, y
 # bsmily.c:89:         if (y - R < 0.0f) { y = R; vy = -vy; }
	pxor	xmm1, xmm1	 # tmp180
 # bsmily.c:89:         if (y - R < 0.0f) { y = R; vy = -vy; }
	subss	xmm0, xmm12	 # _10, tmp220
 # bsmily.c:89:         if (y - R < 0.0f) { y = R; vy = -vy; }
	comiss	xmm1, xmm0	 # tmp180, _10
	ja	.L36	 #,
 # bsmily.c:90:         if (y + R > HEIGHT) { y = HEIGHT - R; vy = -vy; }
	movaps	xmm0, xmm9	 # _11, y
	addss	xmm0, xmm12	 # _11, tmp220
 # bsmily.c:90:         if (y + R > HEIGHT) { y = HEIGHT - R; vy = -vy; }
	comiss	xmm0, DWORD PTR .LC16[rip]	 # _11,
	jbe	.L20	 #,
 # bsmily.c:90:         if (y + R > HEIGHT) { y = HEIGHT - R; vy = -vy; }
	xorps	xmm14, XMMWORD PTR .LC14[rip]	 # vy,
 # bsmily.c:90:         if (y + R > HEIGHT) { y = HEIGHT - R; vy = -vy; }
	movss	xmm9, DWORD PTR .LC3[rip]	 # y,
.L20:
 # bsmily.c:93:         SDL_SetRenderDrawColor(ren, 0, 0, 0, 255);
	mov	DWORD PTR 32[rsp], 255	 #,
	xor	r9d, r9d	 #
	xor	r8d, r8d	 #
	xor	edx, edx	 #
	mov	rcx, rdi	 #, ren
 # bsmily.c:30:     for (int i = 1; i <= segments; ++i) {
	mov	ebx, 1	 # i,
 # bsmily.c:93:         SDL_SetRenderDrawColor(ren, 0, 0, 0, 255);
	call	SDL_SetRenderDrawColor	 #
 # bsmily.c:94:         SDL_RenderClear(ren);
	mov	rcx, rdi	 #, ren
	call	SDL_RenderClear	 #
 # bsmily.c:97:         SDL_SetRenderDrawColor(ren, 255, 20, 147, 255);
	mov	DWORD PTR 32[rsp], 255	 #,
	mov	r9d, 147	 #,
	mov	rcx, rdi	 #, ren
	mov	r8d, 20	 #,
	mov	edx, 255	 #,
	call	SDL_SetRenderDrawColor	 #
 # bsmily.c:42:     drawCircle(r, cx, cy, R, 160);
	movaps	xmm2, xmm9	 #, y
	movaps	xmm1, xmm7	 #, x
	mov	rcx, rdi	 #, ren
	mov	DWORD PTR 32[rsp], 160	 #,
	movss	xmm3, DWORD PTR .LC2[rip]	 #,
	call	drawCircle	 #
 # bsmily.c:47:     drawCircle(r, cx - eyeOffsetX, cy + eyeOffsetY, eyeR, 40);
	movaps	xmm2, xmm9	 # _65, y
	movaps	xmm1, xmm7	 # tmp262, x
	mov	rcx, rdi	 #, ren
	subss	xmm2, DWORD PTR .LC17[rip]	 # _65,
	subss	xmm1, DWORD PTR .LC18[rip]	 # tmp262,
	mov	DWORD PTR 32[rsp], 40	 #,
	movss	xmm3, DWORD PTR .LC19[rip]	 #,
	movss	DWORD PTR 52[rsp], xmm2	 # %sfp, _65
	call	drawCircle	 #
 # bsmily.c:48:     drawCircle(r, cx + eyeOffsetX, cy + eyeOffsetY, eyeR, 40);
	movss	xmm1, DWORD PTR .LC18[rip]	 # tmp263,
	mov	rcx, rdi	 #, ren
	mov	DWORD PTR 32[rsp], 40	 #,
	movss	xmm3, DWORD PTR .LC19[rip]	 #,
	movss	xmm2, DWORD PTR 52[rsp]	 # _65, %sfp
	addss	xmm1, xmm7	 # tmp263, x
	call	drawCircle	 #
 # bsmily.c:28:     float prevX = cx + radius * cosf(start);
	movaps	xmm3, xmm7	 # prevX, x
 # bsmily.c:29:     float prevY = cy + radius * sinf(start);
	movaps	xmm2, xmm9	 # prevY, y
 # bsmily.c:28:     float prevX = cx + radius * cosf(start);
	subss	xmm3, DWORD PTR .LC20[rip]	 # prevX,
 # bsmily.c:29:     float prevY = cy + radius * sinf(start);
	subss	xmm2, DWORD PTR .LC21[rip]	 # prevY,
	movss	xmm1, DWORD PTR .LC4[rip]	 # prephitmp_71,
	movss	xmm0, DWORD PTR .LC5[rip]	 # prephitmp_70,
 # bsmily.c:31:         float a = start + i * step;
	movss	xmm10, DWORD PTR .LC24[rip]	 # tmp225,
	jmp	.L23	 #
	.p2align 4,,10
	.p2align 3
.L37:
 # bsmily.c:31:         float a = start + i * step;
	pxor	xmm0, xmm0	 # _101
	lea	r8, 56[rsp]	 #,
	lea	rdx, 60[rsp]	 #,
	cvtsi2ss	xmm0, ebx	 # _101, i
	mulss	xmm0, xmm11	 # _84, tmp224
 # bsmily.c:31:         float a = start + i * step;
	addss	xmm0, xmm10	 # _96, tmp225
	call	sincosf	 #
 # bsmily.c:32:         float x = cx + radius * cosf(a);
	movss	xmm0, DWORD PTR 56[rsp]	 # prephitmp_70,
 # bsmily.c:33:         float y = cy + radius * sinf(a);
	movaps	xmm3, xmm13	 # prevX, x
	movaps	xmm2, xmm6	 # prevY, y
	movss	xmm1, DWORD PTR 60[rsp]	 # prephitmp_71,
.L23:
 # bsmily.c:33:         float y = cy + radius * sinf(a);
	mulss	xmm1, xmm8	 # prephitmp_71, tmp215
 # bsmily.c:34:         SDL_RenderDrawLine(r, (int)prevX, (int)prevY, (int)x, (int)y);
	cvttss2si	edx, xmm3	 # _99, prevX
	mov	rcx, rdi	 #, ren
 # bsmily.c:30:     for (int i = 1; i <= segments; ++i) {
	add	ebx, 1	 # i,
 # bsmily.c:32:         float x = cx + radius * cosf(a);
	mulss	xmm0, xmm8	 # prephitmp_70, tmp215
 # bsmily.c:34:         SDL_RenderDrawLine(r, (int)prevX, (int)prevY, (int)x, (int)y);
	cvttss2si	r8d, xmm2	 #, prevY
 # bsmily.c:33:         float y = cy + radius * sinf(a);
	movaps	xmm6, xmm1	 # _92, prephitmp_71
 # bsmily.c:33:         float y = cy + radius * sinf(a);
	addss	xmm6, xmm9	 # y, y
 # bsmily.c:32:         float x = cx + radius * cosf(a);
	movaps	xmm13, xmm0	 # _89, prephitmp_70
 # bsmily.c:32:         float x = cx + radius * cosf(a);
	addss	xmm13, xmm7	 # x, x
 # bsmily.c:34:         SDL_RenderDrawLine(r, (int)prevX, (int)prevY, (int)x, (int)y);
	cvttss2si	eax, xmm6	 # _94, y
	cvttss2si	r9d, xmm13	 #, x
	mov	DWORD PTR 32[rsp], eax	 #, _94
	call	SDL_RenderDrawLine	 #
 # bsmily.c:30:     for (int i = 1; i <= segments; ++i) {
	cmp	ebx, 81	 # i,
	jne	.L37	 #,
 # bsmily.c:100:         SDL_RenderPresent(ren);
	mov	rcx, rdi	 #, ren
	call	SDL_RenderPresent	 #
 # bsmily.c:72:     while (running) {
	test	sil, sil	 # running
	je	.L24	 #,
	mov	r12d, r13d	 # last, now
	jmp	.L10	 #
	.p2align 4,,10
	.p2align 3
.L36:
 # bsmily.c:89:         if (y - R < 0.0f) { y = R; vy = -vy; }
	xorps	xmm14, XMMWORD PTR .LC14[rip]	 # vy,
 # bsmily.c:89:         if (y - R < 0.0f) { y = R; vy = -vy; }
	movaps	xmm9, xmm12	 # y, tmp220
	jmp	.L20	 #
	.p2align 4,,10
	.p2align 3
.L35:
 # bsmily.c:87:         if (x - R < 0.0f) { x = R; vx = -vx; }
	xorps	xmm4, XMMWORD PTR .LC14[rip]	 # vx,
 # bsmily.c:87:         if (x - R < 0.0f) { x = R; vx = -vx; }
	movaps	xmm7, xmm12	 # x, tmp220
 # bsmily.c:87:         if (x - R < 0.0f) { x = R; vx = -vx; }
	movss	DWORD PTR 48[rsp], xmm4	 # %sfp, vx
	jmp	.L16	 #
	.p2align 4,,10
	.p2align 3
.L24:
 # bsmily.c:103:     SDL_DestroyRenderer(ren);
	mov	rcx, rdi	 #, ren
	call	SDL_DestroyRenderer	 #
 # bsmily.c:104:     SDL_DestroyWindow(win);
	mov	rcx, r15	 #, win
	call	SDL_DestroyWindow	 #
 # bsmily.c:105:     SDL_Quit();
	call	SDL_Quit	 #
 # bsmily.c:106:     return 0;
	jmp	.L5	 #
.L33:
 # bsmily.c:61:     if (!win) { SDL_Quit(); return 1; }
	call	SDL_Quit	 #
 # bsmily.c:61:     if (!win) { SDL_Quit(); return 1; }
	jmp	.L6	 #
.L34:
 # bsmily.c:64:     if (!ren) { SDL_DestroyWindow(win); SDL_Quit(); return 1; }
	mov	rcx, rbx	 #, win
	call	SDL_DestroyWindow	 #
 # bsmily.c:64:     if (!ren) { SDL_DestroyWindow(win); SDL_Quit(); return 1; }
	call	SDL_Quit	 #
 # bsmily.c:64:     if (!ren) { SDL_DestroyWindow(win); SDL_Quit(); return 1; }
	jmp	.L6	 #
	.seh_endproc
	.section .rdata,"dr"
	.align 4
.LC0:
	.long	1086918619
	.align 4
.LC1:
	.long	1144422400
	.align 4
.LC2:
	.long	1116471296
	.align 4
.LC3:
	.long	1141145600
	.align 4
.LC4:
	.long	-1094862409
	.align 4
.LC5:
	.long	-1083324810
	.align 4
.LC6:
	.long	1127481344
	.align 4
.LC7:
	.long	1130102784
	.align 4
.LC8:
	.long	1133903872
	.align 4
.LC9:
	.long	1137180672
	.align 4
.LC11:
	.long	1148846080
	.align 4
.LC12:
	.long	1028443341
	.align 16
.LC14:
	.long	-2147483648
	.long	0
	.long	0
	.long	0
	.align 4
.LC15:
	.long	1145569280
	.align 4
.LC16:
	.long	1142292480
	.align 4
.LC17:
	.long	1099694080
	.align 4
.LC18:
	.long	1105199104
	.align 4
.LC19:
	.long	1086953882
	.align 4
.LC20:
	.long	1109253709
	.align 4
.LC21:
	.long	1097193065
	.align 4
.LC22:
	.long	1109917696
	.align 4
.LC23:
	.long	1023030747
	.align 4
.LC24:
	.long	1079994099
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	sincosf;	.scl	2;	.type	32;	.endef
	.def	SDL_RenderDrawLine;	.scl	2;	.type	32;	.endef
	.def	SDL_Init;	.scl	2;	.type	32;	.endef
	.def	SDL_CreateWindow;	.scl	2;	.type	32;	.endef
	.def	SDL_CreateRenderer;	.scl	2;	.type	32;	.endef
	.def	SDL_GetTicks;	.scl	2;	.type	32;	.endef
	.def	SDL_PollEvent;	.scl	2;	.type	32;	.endef
	.def	SDL_SetRenderDrawColor;	.scl	2;	.type	32;	.endef
	.def	SDL_RenderClear;	.scl	2;	.type	32;	.endef
	.def	SDL_RenderPresent;	.scl	2;	.type	32;	.endef
	.def	SDL_DestroyRenderer;	.scl	2;	.type	32;	.endef
	.def	SDL_DestroyWindow;	.scl	2;	.type	32;	.endef
	.def	SDL_Quit;	.scl	2;	.type	32;	.endef
