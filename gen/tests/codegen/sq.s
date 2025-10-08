	.file	"sq.c"
	.intel_syntax noprefix
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.globl	square_and_round
	.def	square_and_round;	.scl	2;	.type	32;	.endef
	.seh_proc	square_and_round
square_and_round:
	.seh_endprologue
 # sq.c:6:     double y = (double)x * (double)x;
	cvtss2sd	xmm0, xmm0	 # _1, x
 # sq.c:6:     double y = (double)x * (double)x;
	mulsd	xmm0, xmm0	 # y, _1
 # sq.c:7:     if (y >= (double)INT_MAX - 0.5) return INT_MAX;  // avoid overflow after rounding
	comisd	xmm0, QWORD PTR .LC0[rip]	 # y,
	jnb	.L2	 #,
 # sq.c:9: }
 # sq.c:8:     return (int)lround(y);
	jmp	lround	 #
	.p2align 4,,10
	.p2align 3
.L2:
 # sq.c:9: }
	mov	eax, 2147483647	 #,
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "%f squared is (rounded) %d\12\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # sq.c:12: int main() {
	call	__main	 #
 # sq.c:15:     printf("%f squared is (rounded) %d\n", x, y);
	mov	r8d, 62	 #,
	movabs	rdx, 4620566402330263552	 # tmp99,
	lea	rcx, .LC1[rip]	 #,
	movq	xmm1, rdx	 #, tmp100
	call	printf	 #
 # sq.c:17: }
	xor	eax, eax	 #
	add	rsp, 40	 #,
	ret	
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC0:
	.long	-6291456
	.long	1105199103
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	lround;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
