	.file	"rcube.c"
	.intel_syntax noprefix
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.globl	display
	.def	display;	.scl	2;	.type	32;	.endef
	.seh_proc	display
display:
	sub	rsp, 88	 #,
	.seh_stackalloc	88
	.seh_endprologue
 # rcube.c:8:     glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	mov	ecx, 16640	 #,
	call	[QWORD PTR __imp_glClear[rip]]	 #
 # rcube.c:10:     glMatrixMode(GL_MODELVIEW);
	mov	ecx, 5888	 #,
	call	[QWORD PTR __imp_glMatrixMode[rip]]	 #
 # rcube.c:11:     glLoadIdentity();
	call	[QWORD PTR __imp_glLoadIdentity[rip]]	 #
 # rcube.c:12:     gluLookAt(0.0, 0.0, 5.0,
	mov	rax, QWORD PTR .LC2[rip]	 # tmp119,
	pxor	xmm3, xmm3	 #
	movsd	xmm2, QWORD PTR .LC0[rip]	 #,
	movapd	xmm1, xmm3	 #,
	movapd	xmm0, xmm3	 #, tmp21
	mov	QWORD PTR 56[rsp], rax	 #, tmp119
	mov	QWORD PTR 64[rsp], 0x000000000	 #,
	mov	QWORD PTR 48[rsp], 0x000000000	 #,
	mov	QWORD PTR 40[rsp], 0x000000000	 #,
	mov	QWORD PTR 32[rsp], 0x000000000	 #,
	call	gluLookAt	 #
 # rcube.c:16:     glRotatef(angle, 1.0f, 1.0f, 0.5f);
	movss	xmm2, DWORD PTR .LC4[rip]	 #,
	movss	xmm3, DWORD PTR .LC3[rip]	 #,
	movss	xmm0, DWORD PTR angle[rip]	 #, angle
	movaps	xmm1, xmm2	 #,
	call	[QWORD PTR __imp_glRotatef[rip]]	 #
 # rcube.c:18:     glColor3f(0.0f, 1.0f, 0.0f);  // neon green
	pxor	xmm2, xmm2	 #
	movss	xmm1, DWORD PTR .LC4[rip]	 #,
	movaps	xmm0, xmm2	 #,
	call	[QWORD PTR __imp_glColor3f[rip]]	 #
 # rcube.c:19:     glLineWidth(2.0f);
	movss	xmm0, DWORD PTR .LC6[rip]	 #,
	call	[QWORD PTR __imp_glLineWidth[rip]]	 #
 # rcube.c:20:     glutWireCube(2.0);
	movsd	xmm0, QWORD PTR .LC7[rip]	 #,
	call	[QWORD PTR __imp_glutWireCube[rip]]	 #
	nop	
 # rcube.c:23: }
	add	rsp, 88	 #,
 # rcube.c:22:     glutSwapBuffers();
	rex.W jmp	[QWORD PTR __imp_glutSwapBuffers[rip]]	 #
	.seh_endproc
	.p2align 4
	.globl	reshape
	.def	reshape;	.scl	2;	.type	32;	.endef
	.seh_proc	reshape
reshape:
	sub	rsp, 56	 #,
	.seh_stackalloc	56
	.seh_endprologue
 # rcube.c:25: void reshape(int w, int h) {
	mov	r8d, ecx	 # w, w
	mov	r9d, edx	 # h, h
 # rcube.c:26:     if (h == 0) h = 1;
	test	edx, edx	 # h
	je	.L5	 #,
 # rcube.c:27:     float aspect = (float)w / (float)h;
	pxor	xmm0, xmm0	 # _15
	cvtsi2ss	xmm0, edx	 # _15, h
.L4:
 # rcube.c:27:     float aspect = (float)w / (float)h;
	pxor	xmm1, xmm1	 # _1
 # rcube.c:29:     glViewport(0, 0, w, h);
	xor	edx, edx	 #
	xor	ecx, ecx	 #
 # rcube.c:27:     float aspect = (float)w / (float)h;
	cvtsi2ss	xmm1, r8d	 # _1, w
 # rcube.c:27:     float aspect = (float)w / (float)h;
	divss	xmm1, xmm0	 # aspect, _15
	movss	DWORD PTR 44[rsp], xmm1	 # %sfp, aspect
 # rcube.c:29:     glViewport(0, 0, w, h);
	call	[QWORD PTR __imp_glViewport[rip]]	 #
 # rcube.c:31:     glMatrixMode(GL_PROJECTION);
	mov	ecx, 5889	 #,
	call	[QWORD PTR __imp_glMatrixMode[rip]]	 #
 # rcube.c:32:     glLoadIdentity();
	call	[QWORD PTR __imp_glLoadIdentity[rip]]	 #
 # rcube.c:33:     gluPerspective(60.0, aspect, 0.1, 100.0);
	movsd	xmm3, QWORD PTR .LC8[rip]	 #,
	pxor	xmm1, xmm1	 #
	movsd	xmm2, QWORD PTR .LC9[rip]	 #,
	movsd	xmm0, QWORD PTR .LC10[rip]	 #,
	cvtss2sd	xmm1, DWORD PTR 44[rsp]	 #, %sfp
 # rcube.c:34: }
	add	rsp, 56	 #,
 # rcube.c:33:     gluPerspective(60.0, aspect, 0.1, 100.0);
	jmp	gluPerspective	 #
	.p2align 4,,10
	.p2align 3
.L5:
	movss	xmm0, DWORD PTR .LC4[rip]	 # _15,
 # rcube.c:26:     if (h == 0) h = 1;
	mov	r9d, 1	 # h,
	jmp	.L4	 #
	.seh_endproc
	.p2align 4
	.globl	idle
	.def	idle;	.scl	2;	.type	32;	.endef
	.seh_proc	idle
idle:
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # rcube.c:37:     int t = glutGet(GLUT_ELAPSED_TIME);
	mov	ecx, 700	 #,
	call	[QWORD PTR __imp_glutGet[rip]]	 #
 # rcube.c:38:     if (lastTime == 0) lastTime = t;
	mov	edx, DWORD PTR lastTime[rip]	 # lastTime.1_1, lastTime
	pxor	xmm0, xmm0	 # _32
 # rcube.c:38:     if (lastTime == 0) lastTime = t;
	test	edx, edx	 # lastTime.1_1
	je	.L7	 #,
 # rcube.c:39:     float dt = (t - lastTime) / 1000.0f;
	mov	ecx, eax	 # _26, t
 # rcube.c:39:     float dt = (t - lastTime) / 1000.0f;
	pxor	xmm0, xmm0	 # _28
 # rcube.c:39:     float dt = (t - lastTime) / 1000.0f;
	sub	ecx, edx	 # _26, lastTime.1_1
 # rcube.c:39:     float dt = (t - lastTime) / 1000.0f;
	cvtsi2ss	xmm0, ecx	 # _28, _26
 # rcube.c:39:     float dt = (t - lastTime) / 1000.0f;
	divss	xmm0, DWORD PTR .LC11[rip]	 # _30,
 # rcube.c:42:     angle += 60.0f * dt;  // 60 degrees per second
	mulss	xmm0, DWORD PTR .LC12[rip]	 # _32,
.L7:
 # rcube.c:42:     angle += 60.0f * dt;  // 60 degrees per second
	addss	xmm0, DWORD PTR angle[rip]	 # _7, angle
 # rcube.c:43:     if (angle >= 360.0f) angle -= 360.0f;
	comiss	xmm0, DWORD PTR .LC13[rip]	 # _7,
 # rcube.c:40:     lastTime = t;
	mov	DWORD PTR lastTime[rip], eax	 # lastTime, t
 # rcube.c:43:     if (angle >= 360.0f) angle -= 360.0f;
	jb	.L8	 #,
 # rcube.c:43:     if (angle >= 360.0f) angle -= 360.0f;
	subss	xmm0, DWORD PTR .LC13[rip]	 # _7,
.L8:
 # rcube.c:42:     angle += 60.0f * dt;  // 60 degrees per second
	movss	DWORD PTR angle[rip], xmm0	 # angle, _7
 # rcube.c:46: }
	add	rsp, 40	 #,
 # rcube.c:45:     glutPostRedisplay();
	rex.W jmp	[QWORD PTR __imp_glutPostRedisplay[rip]]	 #
	.seh_endproc
	.p2align 4
	.globl	onKey
	.def	onKey;	.scl	2;	.type	32;	.endef
	.seh_proc	onKey
onKey:
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # rcube.c:50:     exit(0);
	xor	ecx, ecx	 #
	call	exit	 #
	nop	
	.seh_endproc
	.p2align 4
	.globl	onSpecial
	.def	onSpecial;	.scl	2;	.type	32;	.endef
	.seh_proc	onSpecial
onSpecial:
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # rcube.c:55:     exit(0);
	xor	ecx, ecx	 #
	call	exit	 #
	nop	
	.seh_endproc
	.section .rdata,"dr"
.LC14:
	.ascii "Rotating Wireframe Cube\0"
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
 # rcube.c:58: int main(int argc, char** argv) {
	mov	rbx, rdx	 # argv, argv
	mov	DWORD PTR 48[rsp], ecx	 # argc, argc
	call	__main	 #
 # C:/msys64/ucrt64/include/GL/freeglut_std.h:641: static void FGAPIENTRY FGUNUSED glutInit_ATEXIT_HACK(int *argcp, char **argv) { __glutInitWithExit(argcp, argv, exit); }
	lea	r8, exit[rip]	 #,
	mov	rdx, rbx	 #, argv
	lea	rcx, 48[rsp]	 #,
	call	[QWORD PTR __imp___glutInitWithExit[rip]]	 #
 # rcube.c:60:     glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
	mov	ecx, 18	 #,
	call	[QWORD PTR __imp_glutInitDisplayMode[rip]]	 #
 # rcube.c:61:     glutInitWindowSize(800, 600);
	mov	edx, 600	 #,
	mov	ecx, 800	 #,
	call	[QWORD PTR __imp_glutInitWindowSize[rip]]	 #
 # C:/msys64/ucrt64/include/GL/freeglut_std.h:643: static int FGAPIENTRY FGUNUSED glutCreateWindow_ATEXIT_HACK(const char *title) { return __glutCreateWindowWithExit(title, exit); }
	lea	rdx, exit[rip]	 #,
	lea	rcx, .LC14[rip]	 #,
	call	[QWORD PTR __imp___glutCreateWindowWithExit[rip]]	 #
 # rcube.c:64:     glClearColor(0.0f, 0.0f, 0.0f, 1.0f);  // black background
	pxor	xmm2, xmm2	 #
	movss	xmm3, DWORD PTR .LC4[rip]	 #,
	movaps	xmm1, xmm2	 #,
	movaps	xmm0, xmm2	 #, tmp21
	call	[QWORD PTR __imp_glClearColor[rip]]	 #
 # rcube.c:65:     glEnable(GL_DEPTH_TEST);
	mov	ecx, 2929	 #,
	call	[QWORD PTR __imp_glEnable[rip]]	 #
 # rcube.c:67:     glutDisplayFunc(display);
	lea	rcx, display[rip]	 #,
	call	[QWORD PTR __imp_glutDisplayFunc[rip]]	 #
 # rcube.c:68:     glutReshapeFunc(reshape);
	lea	rcx, reshape[rip]	 #,
	call	[QWORD PTR __imp_glutReshapeFunc[rip]]	 #
 # rcube.c:69:     glutIdleFunc(idle);
	lea	rcx, idle[rip]	 #,
	call	[QWORD PTR __imp_glutIdleFunc[rip]]	 #
 # rcube.c:70:     glutKeyboardFunc(onKey);
	lea	rcx, onKey[rip]	 #,
	call	[QWORD PTR __imp_glutKeyboardFunc[rip]]	 #
 # rcube.c:71:     glutSpecialFunc(onSpecial);
	lea	rcx, onSpecial[rip]	 #,
	call	[QWORD PTR __imp_glutSpecialFunc[rip]]	 #
 # rcube.c:73:     glutMainLoop();
	call	[QWORD PTR __imp_glutMainLoop[rip]]	 #
 # rcube.c:75: }
	xor	eax, eax	 #
	add	rsp, 32	 #,
	pop	rbx	 #
	ret	
	.seh_endproc
.lcomm lastTime,4,4
.lcomm angle,4,4
	.section .rdata,"dr"
	.align 8
.LC0:
	.long	0
	.long	1075052544
	.align 8
.LC2:
	.long	0
	.long	1072693248
	.align 4
.LC3:
	.long	1056964608
	.align 4
.LC4:
	.long	1065353216
	.set	.LC6,.LC7+4
	.align 8
.LC7:
	.long	0
	.long	1073741824
	.align 8
.LC8:
	.long	0
	.long	1079574528
	.align 8
.LC9:
	.long	-1717986918
	.long	1069128089
	.align 8
.LC10:
	.long	0
	.long	1078853632
	.align 4
.LC11:
	.long	1148846080
	.align 4
.LC12:
	.long	1114636288
	.align 4
.LC13:
	.long	1135869952
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	gluLookAt;	.scl	2;	.type	32;	.endef
	.def	gluPerspective;	.scl	2;	.type	32;	.endef
	.def	exit;	.scl	2;	.type	32;	.endef
	.section	.rdata$.refptr.exit, "dr"
	.p2align	3, 0
	.globl	.refptr.exit
	.linkonce	discard
.refptr.exit:
	.quad	exit
