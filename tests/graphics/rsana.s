	.file	"rsana.c"
	.intel_syntax noprefix
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.def	timer;	.scl	3;	.type	32;	.endef
	.seh_proc	timer
timer:
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # rsana.c:97:     angleDeg += 0.5f; // rotation speed (deg per frame tick)
	movss	xmm0, DWORD PTR .LC0[rip]	 # tmp102,
	addss	xmm0, DWORD PTR angleDeg[rip]	 # _2, angleDeg
 # rsana.c:98:     if (angleDeg >= 360.0f) angleDeg -= 360.0f;
	comiss	xmm0, DWORD PTR .LC1[rip]	 # _2,
	jb	.L2	 #,
 # rsana.c:98:     if (angleDeg >= 360.0f) angleDeg -= 360.0f;
	subss	xmm0, DWORD PTR .LC1[rip]	 # _2,
.L2:
 # rsana.c:97:     angleDeg += 0.5f; // rotation speed (deg per frame tick)
	movss	DWORD PTR angleDeg[rip], xmm0	 # angleDeg, _2
 # rsana.c:99:     glutPostRedisplay();
	call	[QWORD PTR __imp_glutPostRedisplay[rip]]	 #
 # rsana.c:100:     glutTimerFunc(16, timer, 0); // ~60 FPS
	xor	r8d, r8d	 #
	mov	ecx, 16	 #,
	lea	rdx, timer[rip]	 #,
 # rsana.c:101: }
	add	rsp, 40	 #,
 # rsana.c:100:     glutTimerFunc(16, timer, 0); // ~60 FPS
	rex.W jmp	[QWORD PTR __imp_glutTimerFunc[rip]]	 #
	.seh_endproc
	.p2align 4
	.def	reshape;	.scl	3;	.type	32;	.endef
	.seh_proc	reshape
reshape:
	.seh_endprologue
 # rsana.c:90:     winW = (w > 1) ? w : 1;
	mov	eax, 1	 # tmp105,
	test	ecx, ecx	 # w
	cmovg	eax, ecx	 # w,, tmp105
 # rsana.c:91:     winH = (h > 1) ? h : 1;
	test	edx, edx	 # h
 # rsana.c:90:     winW = (w > 1) ? w : 1;
	mov	DWORD PTR winW[rip], eax	 # winW, _1
 # rsana.c:90:     winW = (w > 1) ? w : 1;
	mov	r8d, eax	 # _1, tmp105
 # rsana.c:91:     winH = (h > 1) ? h : 1;
	mov	eax, 1	 # tmp106,
	cmovg	eax, edx	 # h,, tmp106
 # rsana.c:92:     glViewport(0, 0, winW, winH);
	xor	edx, edx	 #
	xor	ecx, ecx	 #
 # rsana.c:91:     winH = (h > 1) ? h : 1;
	mov	r9d, eax	 # _2, tmp106
 # rsana.c:91:     winH = (h > 1) ? h : 1;
	mov	DWORD PTR winH[rip], eax	 # winH, _2
 # rsana.c:93: }
 # rsana.c:92:     glViewport(0, 0, winW, winH);
	rex.W jmp	[QWORD PTR __imp_glViewport[rip]]	 #
	.seh_endproc
	.p2align 4
	.def	draw_stroke_text_centered;	.scl	3;	.type	32;	.endef
	.seh_proc	draw_stroke_text_centered
draw_stroke_text_centered:
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 64	 #,
	.seh_stackalloc	64
	movups	XMMWORD PTR 32[rsp], xmm6	 #,
	.seh_savexmm	xmm6, 32
	movups	XMMWORD PTR 48[rsp], xmm7	 #,
	.seh_savexmm	xmm7, 48
	.seh_endprologue
 # rsana.c:17:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p)
	movzx	edx, BYTE PTR [rcx]	 #, MEM[(const unsigned char *)s_8(D)]
 # rsana.c:28: static void draw_stroke_text_centered(const char* s, float scale) {
	mov	rbx, rcx	 # s, s
	movaps	xmm7, xmm1	 # scale, scale
 # rsana.c:17:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p)
	test	dl, dl	 # _18
	je	.L12	 #,
	mov	rdi, QWORD PTR __imp_glutStrokeWidth[rip]	 # tmp122,
 # rsana.c:17:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p)
	mov	rsi, rcx	 # p, s
 # rsana.c:16:     float w = 0.0f;
	pxor	xmm6, xmm6	 # w
	.p2align 4
	.p2align 3
.L9:
 # rsana.c:18:         w += glutStrokeWidth(font, *p);
	xor	ecx, ecx	 #
 # rsana.c:17:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p)
	add	rsi, 1	 # p,
 # rsana.c:18:         w += glutStrokeWidth(font, *p);
	call	rdi	 # tmp122
 # rsana.c:18:         w += glutStrokeWidth(font, *p);
	pxor	xmm0, xmm0	 # _21
 # rsana.c:17:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p)
	movzx	edx, BYTE PTR [rsi]	 #, MEM[(const unsigned char *)p_25]
 # rsana.c:18:         w += glutStrokeWidth(font, *p);
	cvtsi2ss	xmm0, eax	 # _21, _20
	addss	xmm6, xmm0	 # w, _21
 # rsana.c:17:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p)
	test	dl, dl	 # _18
	jne	.L9	 #,
 # rsana.c:35:     glTranslatef(-w * 0.5f, -h * 0.5f, 0.0f); // center the string
	xorps	xmm6, XMMWORD PTR .LC4[rip]	 # prephitmp_5,
.L8:
 # rsana.c:33:     glPushMatrix();
	call	[QWORD PTR __imp_glPushMatrix[rip]]	 #
 # rsana.c:34:     glScalef(scale, scale, 1.0f);
	movss	xmm2, DWORD PTR .LC5[rip]	 #,
	movaps	xmm1, xmm7	 #, scale
	movaps	xmm0, xmm7	 #, scale
	call	[QWORD PTR __imp_glScalef[rip]]	 #
 # rsana.c:35:     glTranslatef(-w * 0.5f, -h * 0.5f, 0.0f); // center the string
	mulss	xmm6, DWORD PTR .LC0[rip]	 # prephitmp_5,
 # rsana.c:35:     glTranslatef(-w * 0.5f, -h * 0.5f, 0.0f); // center the string
	pxor	xmm2, xmm2	 #
	movss	xmm1, DWORD PTR .LC6[rip]	 #,
 # rsana.c:35:     glTranslatef(-w * 0.5f, -h * 0.5f, 0.0f); // center the string
	movaps	xmm0, xmm6	 # _2, prephitmp_5
 # rsana.c:35:     glTranslatef(-w * 0.5f, -h * 0.5f, 0.0f); // center the string
	call	[QWORD PTR __imp_glTranslatef[rip]]	 #
 # rsana.c:37:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p) {
	movzx	edx, BYTE PTR [rbx]	 #, MEM[(const unsigned char *)s_8(D)]
	mov	rsi, QWORD PTR __imp_glutStrokeCharacter[rip]	 # tmp123,
	test	dl, dl	 # _4
	je	.L11	 #,
	.p2align 4
	.p2align 3
.L10:
 # rsana.c:37:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p) {
	add	rbx, 1	 # s,
 # rsana.c:38:         glutStrokeCharacter(font, *p);
	xor	ecx, ecx	 #
	call	rsi	 # tmp123
 # rsana.c:37:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p) {
	movzx	edx, BYTE PTR [rbx]	 #, MEM[(const unsigned char *)p_17]
	test	dl, dl	 # _4
	jne	.L10	 #,
.L11:
 # rsana.c:41: }
	movups	xmm6, XMMWORD PTR 32[rsp]	 #,
	movups	xmm7, XMMWORD PTR 48[rsp]	 #,
	add	rsp, 64	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
 # rsana.c:40:     glPopMatrix();
	rex.W jmp	[QWORD PTR __imp_glPopMatrix[rip]]	 #
	.p2align 4,,10
	.p2align 3
.L12:
 # rsana.c:17:     for (const unsigned char* p = (const unsigned char*)s; *p; ++p)
	movss	xmm6, DWORD PTR .LC3[rip]	 # prephitmp_5,
	jmp	.L8	 #
	.seh_endproc
	.section .rdata,"dr"
.LC19:
	.ascii "SANA\0"
	.text
	.p2align 4
	.def	display;	.scl	3;	.type	32;	.endef
	.seh_proc	display
display:
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 208	 #,
	.seh_stackalloc	208
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
	movups	XMMWORD PTR 160[rsp], xmm12	 #,
	.seh_savexmm	xmm12, 160
	movups	XMMWORD PTR 176[rsp], xmm13	 #,
	.seh_savexmm	xmm13, 176
	movups	XMMWORD PTR 192[rsp], xmm14	 #,
	.seh_savexmm	xmm14, 192
	.seh_endprologue
 # rsana.c:44:     glClear(GL_COLOR_BUFFER_BIT);
	mov	ecx, 16384	 #,
 # rsana.c:65:     float targetHeight = winH * 0.35f; // 35% of window height
	pxor	xmm14, xmm14	 # _15
 # rsana.c:44:     glClear(GL_COLOR_BUFFER_BIT);
	call	[QWORD PTR __imp_glClear[rip]]	 #
 # rsana.c:46:     glMatrixMode(GL_PROJECTION);
	mov	ecx, 5889	 #,
	mov	rsi, QWORD PTR __imp_glMatrixMode[rip]	 # tmp123,
	call	rsi	 # tmp123
 # rsana.c:47:     glLoadIdentity();
	mov	rbx, QWORD PTR __imp_glLoadIdentity[rip]	 # tmp124,
	call	rbx	 # tmp124
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	mov	eax, DWORD PTR winW[rip]	 # winW.9_7, winW
	pxor	xmm4, xmm4	 # _8
	pxor	xmm0, xmm0	 # _11
	mov	edx, DWORD PTR winH[rip]	 # winH.7_1, winH
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	movsd	xmm1, QWORD PTR .LC7[rip]	 # tmp127,
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	pxor	xmm3, xmm3	 # _2
	pxor	xmm2, xmm2	 # _5
	cvtsi2sd	xmm4, eax	 # _8, winW.9_7
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	neg	eax	 # _10
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	cvtsi2sd	xmm0, eax	 # _11, _10
	mov	rax, QWORD PTR .LC8[rip]	 # tmp187,
	cvtsi2sd	xmm3, edx	 # _2, winH.7_1
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	neg	edx	 # _4
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	mulsd	xmm3, xmm1	 #, tmp127
	cvtsi2sd	xmm2, edx	 # _5, _4
	mov	QWORD PTR 40[rsp], rax	 #, tmp187
	mov	rax, QWORD PTR .LC9[rip]	 # tmp188,
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	mulsd	xmm0, xmm1	 # _12, tmp127
 # rsana.c:48:     glOrtho(-winW * 0.5, winW * 0.5, -winH * 0.5, winH * 0.5, -1.0, 1.0);
	mulsd	xmm2, xmm1	 #, tmp127
	mulsd	xmm1, xmm4	 #, _8
	mov	QWORD PTR 32[rsp], rax	 #, tmp188
	call	[QWORD PTR __imp_glOrtho[rip]]	 #
 # rsana.c:50:     glMatrixMode(GL_MODELVIEW);
	mov	ecx, 5888	 #,
	call	rsi	 # tmp123
 # rsana.c:51:     glLoadIdentity();
	call	rbx	 # tmp124
 # rsana.c:54:     glEnable(GL_LINE_SMOOTH);
	mov	rbx, QWORD PTR __imp_glEnable[rip]	 # tmp144,
	mov	ecx, 2848	 #,
	call	rbx	 # tmp144
 # rsana.c:55:     glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
	mov	edx, 4354	 #,
	mov	ecx, 3154	 #,
	call	[QWORD PTR __imp_glHint[rip]]	 #
 # rsana.c:57:     glEnable(GL_BLEND);
	mov	ecx, 3042	 #,
	call	rbx	 # tmp144
 # rsana.c:58:     glBlendFunc(GL_SRC_ALPHA, GL_ONE); // additive for glow
	mov	edx, 1	 #,
	mov	ecx, 770	 #,
 # rsana.c:72:     for (int i = layers; i >= 1; --i) {
	mov	ebx, 8	 # i,
 # rsana.c:58:     glBlendFunc(GL_SRC_ALPHA, GL_ONE); // additive for glow
	call	[QWORD PTR __imp_glBlendFunc[rip]]	 #
 # rsana.c:61:     glTranslatef(0.0f, 0.0f, 0.0f);
	pxor	xmm2, xmm2	 #
	movaps	xmm1, xmm2	 #,
	movaps	xmm0, xmm2	 #, tmp21
	call	[QWORD PTR __imp_glTranslatef[rip]]	 #
 # rsana.c:62:     glRotatef(angleDeg, 0.0f, 0.0f, 1.0f);
	pxor	xmm2, xmm2	 #
	movss	xmm3, DWORD PTR .LC5[rip]	 #,
	movss	xmm0, DWORD PTR angleDeg[rip]	 #, angleDeg
	movaps	xmm1, xmm2	 #,
	call	[QWORD PTR __imp_glRotatef[rip]]	 #
	mov	rdi, QWORD PTR __imp_glLineWidth[rip]	 # tmp179,
	movss	xmm13, DWORD PTR .LC12[rip]	 # tmp180,
 # rsana.c:65:     float targetHeight = winH * 0.35f; // 35% of window height
	cvtsi2ss	xmm14, DWORD PTR winH[rip]	 # _15, winH
	movss	xmm12, DWORD PTR .LC13[rip]	 # tmp181,
	mov	rsi, QWORD PTR __imp_glColor4f[rip]	 # tmp177,
	movss	xmm6, DWORD PTR .LC18[rip]	 # tmp176,
 # rsana.c:77:         glColor4f(neonR, neonG, neonB, alpha);
	movss	xmm7, DWORD PTR .LC5[rip]	 # tmp185,
	movss	xmm11, DWORD PTR .LC14[rip]	 # tmp182,
	movss	xmm10, DWORD PTR .LC15[rip]	 # tmp183,
	movss	xmm9, DWORD PTR .LC16[rip]	 # tmp175,
	movss	xmm8, DWORD PTR .LC17[rip]	 # tmp184,
 # rsana.c:65:     float targetHeight = winH * 0.35f; // 35% of window height
	mulss	xmm14, DWORD PTR .LC10[rip]	 # targetHeight_36,
 # rsana.c:67:     float scale = targetHeight / baseHeight;
	divss	xmm14, DWORD PTR .LC11[rip]	 # scale,
	.p2align 4
	.p2align 3
.L18:
 # rsana.c:73:         float t = (float)i / (float)layers;          // 1..0
	pxor	xmm0, xmm0	 # _16
	cvtsi2ss	xmm0, ebx	 # _16, i
 # rsana.c:73:         float t = (float)i / (float)layers;          // 1..0
	movaps	xmm3, xmm0	 # t_42, _16
	mulss	xmm3, xmm13	 # t_42, tmp180
 # rsana.c:75:         float lw = 2.0f + 3.0f * i;                  // thicker outer glow
	mulss	xmm0, xmm10	 # _18, tmp183
 # rsana.c:74:         float alpha = 0.06f + 0.08f * t;             // faint to stronger
	mulss	xmm3, xmm12	 # _17, tmp181
 # rsana.c:75:         float lw = 2.0f + 3.0f * i;                  // thicker outer glow
	addss	xmm0, xmm9	 # lw_44, tmp175
 # rsana.c:74:         float alpha = 0.06f + 0.08f * t;             // faint to stronger
	addss	xmm3, xmm11	 # alpha, tmp182
	movss	DWORD PTR 60[rsp], xmm3	 # %sfp, alpha
 # rsana.c:76:         glLineWidth(lw);
	call	rdi	 # tmp179
 # rsana.c:77:         glColor4f(neonR, neonG, neonB, alpha);
	movaps	xmm1, xmm7	 #, tmp185
	movss	xmm3, DWORD PTR 60[rsp]	 # alpha, %sfp
	movaps	xmm2, xmm8	 #, tmp184
	movaps	xmm0, xmm6	 #, tmp176
	call	rsi	 # tmp177
 # rsana.c:78:         draw_stroke_text_centered(text, scale);
	movaps	xmm1, xmm14	 #, scale
	lea	rcx, .LC19[rip]	 #,
	call	draw_stroke_text_centered	 #
 # rsana.c:72:     for (int i = layers; i >= 1; --i) {
	sub	ebx, 1	 # i,
	jne	.L18	 #,
 # rsana.c:82:     glLineWidth(2.5f);
	movss	xmm0, DWORD PTR .LC20[rip]	 #,
	call	rdi	 # tmp179
 # rsana.c:83:     glColor4f(neonR, neonG, neonB, 1.0f);
	movss	xmm3, DWORD PTR .LC5[rip]	 #,
	movaps	xmm0, xmm6	 #, tmp176
	movss	xmm2, DWORD PTR .LC17[rip]	 #,
	movaps	xmm1, xmm3	 #,
	call	rsi	 # tmp177
 # rsana.c:84:     draw_stroke_text_centered(text, scale);
	movaps	xmm1, xmm14	 #, scale
	lea	rcx, .LC19[rip]	 #,
	call	draw_stroke_text_centered	 #
	nop	
 # rsana.c:87: }
	movups	xmm6, XMMWORD PTR 64[rsp]	 #,
	movups	xmm7, XMMWORD PTR 80[rsp]	 #,
	movups	xmm8, XMMWORD PTR 96[rsp]	 #,
	movups	xmm9, XMMWORD PTR 112[rsp]	 #,
	movups	xmm10, XMMWORD PTR 128[rsp]	 #,
	movups	xmm11, XMMWORD PTR 144[rsp]	 #,
	movups	xmm12, XMMWORD PTR 160[rsp]	 #,
	movups	xmm13, XMMWORD PTR 176[rsp]	 #,
	movups	xmm14, XMMWORD PTR 192[rsp]	 #,
	add	rsp, 208	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
 # rsana.c:86:     glutSwapBuffers();
	rex.W jmp	[QWORD PTR __imp_glutSwapBuffers[rip]]	 #
	.seh_endproc
	.section .rdata,"dr"
.LC21:
	.ascii "SANA Neon Rotation\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
 # rsana.c:103: int main(int argc, char** argv) {
	mov	rbx, rdx	 # argv, argv
	mov	DWORD PTR 48[rsp], ecx	 # argc, argc
	call	__main	 #
 # C:/msys64/ucrt64/include/GL/freeglut_std.h:641: static void FGAPIENTRY FGUNUSED glutInit_ATEXIT_HACK(int *argcp, char **argv) { __glutInitWithExit(argcp, argv, exit); }
	lea	r8, exit[rip]	 #,
	mov	rdx, rbx	 #, argv
	lea	rcx, 48[rsp]	 #,
	call	[QWORD PTR __imp___glutInitWithExit[rip]]	 #
 # rsana.c:105:     glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_MULTISAMPLE);
	mov	ecx, 130	 #,
	call	[QWORD PTR __imp_glutInitDisplayMode[rip]]	 #
 # rsana.c:106:     glutInitWindowSize(winW, winH);
	mov	edx, DWORD PTR winH[rip]	 #, winH
	mov	ecx, DWORD PTR winW[rip]	 #, winW
	call	[QWORD PTR __imp_glutInitWindowSize[rip]]	 #
 # C:/msys64/ucrt64/include/GL/freeglut_std.h:643: static int FGAPIENTRY FGUNUSED glutCreateWindow_ATEXIT_HACK(const char *title) { return __glutCreateWindowWithExit(title, exit); }
	lea	rdx, exit[rip]	 #,
	lea	rcx, .LC21[rip]	 #,
	call	[QWORD PTR __imp___glutCreateWindowWithExit[rip]]	 #
 # rsana.c:110:     glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	pxor	xmm2, xmm2	 #
	movss	xmm3, DWORD PTR .LC5[rip]	 #,
	movaps	xmm1, xmm2	 #,
	movaps	xmm0, xmm2	 #, tmp21
	call	[QWORD PTR __imp_glClearColor[rip]]	 #
 # rsana.c:116:     glutDisplayFunc(display);
	lea	rcx, display[rip]	 #,
	call	[QWORD PTR __imp_glutDisplayFunc[rip]]	 #
 # rsana.c:117:     glutReshapeFunc(reshape);
	lea	rcx, reshape[rip]	 #,
	call	[QWORD PTR __imp_glutReshapeFunc[rip]]	 #
 # rsana.c:118:     glutTimerFunc(0, timer, 0);
	xor	r8d, r8d	 #
	lea	rdx, timer[rip]	 #,
	xor	ecx, ecx	 #
	call	[QWORD PTR __imp_glutTimerFunc[rip]]	 #
 # rsana.c:120:     glutMainLoop();
	call	[QWORD PTR __imp_glutMainLoop[rip]]	 #
 # rsana.c:122: }
	xor	eax, eax	 #
	add	rsp, 32	 #,
	pop	rbx	 #
	ret	
	.seh_endproc
.lcomm angleDeg,4,4
	.data
	.align 4
winH:
	.long	600
	.align 4
winW:
	.long	800
	.section .rdata,"dr"
	.align 4
.LC0:
	.long	1056964608
	.align 4
.LC1:
	.long	1135869952
	.set	.LC3,.LC4
	.align 16
.LC4:
	.long	-2147483648
	.long	0
	.long	0
	.long	0
	.align 4
.LC5:
	.long	1065353216
	.align 4
.LC6:
	.long	-1032971878
	.align 8
.LC7:
	.long	0
	.long	1071644672
	.align 8
.LC8:
	.long	0
	.long	1072693248
	.align 8
.LC9:
	.long	0
	.long	-1074790400
	.align 4
.LC10:
	.long	1051931443
	.align 4
.LC11:
	.long	1122900378
	.align 4
.LC12:
	.long	1040187392
	.align 4
.LC13:
	.long	1034147594
	.align 4
.LC14:
	.long	1031127695
	.align 4
.LC15:
	.long	1077936128
	.align 4
.LC16:
	.long	1073741824
	.align 4
.LC17:
	.long	1063675494
	.align 4
.LC18:
	.long	1036831949
	.align 4
.LC20:
	.long	1075838976
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	exit;	.scl	2;	.type	32;	.endef
	.section	.rdata$.refptr.exit, "dr"
	.p2align	3, 0
	.globl	.refptr.exit
	.linkonce	discard
.refptr.exit:
	.quad	exit
