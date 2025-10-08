	.file	"solarsystem.c"
	.intel_syntax noprefix
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=nocona -O2
	.text
	.section .rdata,"dr"
.LC0:
	.ascii "       Sun\0"
.LC1:
	.ascii "        *\0"
.LC2:
	.ascii "       ***\0"
.LC3:
	.ascii "      *****\0"
.LC4:
	.ascii "Mercury\0"
.LC5:
	.ascii "   *\0"
.LC6:
	.ascii "Venus\0"
.LC7:
	.ascii "    *\0"
.LC8:
	.ascii "Earth\0"
.LC9:
	.ascii "     *\0"
.LC10:
	.ascii "Mars\0"
.LC11:
	.ascii "      *\0"
.LC12:
	.ascii "Jupiter\0"
.LC13:
	.ascii "       *\0"
.LC14:
	.ascii "Saturn\0"
.LC15:
	.ascii "Uranus\0"
.LC16:
	.ascii "         *\0"
.LC17:
	.ascii "Neptune\0"
.LC18:
	.ascii "          *\0"
	.text
	.p2align 4
	.globl	drawSolarSystem
	.def	drawSolarSystem;	.scl	2;	.type	32;	.endef
	.seh_proc	drawSolarSystem
drawSolarSystem:
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # solarsystem.c:4:     printf("       Sun\n");
	lea	rcx, .LC0[rip]	 #,
	call	puts	 #
 # solarsystem.c:5:     printf("        *\n");
	lea	rcx, .LC1[rip]	 #,
	call	puts	 #
 # solarsystem.c:6:     printf("       ***\n");
	lea	rcx, .LC2[rip]	 #,
	call	puts	 #
 # solarsystem.c:7:     printf("      *****\n");
	lea	rcx, .LC3[rip]	 #,
	call	puts	 #
 # solarsystem.c:8:     printf("       ***\n");
	lea	rcx, .LC2[rip]	 #,
	call	puts	 #
 # solarsystem.c:9:     printf("        *\n");
	lea	rcx, .LC1[rip]	 #,
	call	puts	 #
 # solarsystem.c:10:     printf("\n");
	mov	ecx, 10	 #,
	call	putchar	 #
 # solarsystem.c:11:     printf("Mercury\n");
	lea	rcx, .LC4[rip]	 #,
	call	puts	 #
 # solarsystem.c:12:     printf("   *\n");
	lea	rcx, .LC5[rip]	 #,
	call	puts	 #
 # solarsystem.c:13:     printf("\n");
	mov	ecx, 10	 #,
	call	putchar	 #
 # solarsystem.c:14:     printf("Venus\n");
	lea	rcx, .LC6[rip]	 #,
	call	puts	 #
 # solarsystem.c:15:     printf("    *\n");
	lea	rcx, .LC7[rip]	 #,
	call	puts	 #
 # solarsystem.c:16:     printf("\n");
	mov	ecx, 10	 #,
	call	putchar	 #
 # solarsystem.c:17:     printf("Earth\n");
	lea	rcx, .LC8[rip]	 #,
	call	puts	 #
 # solarsystem.c:18:     printf("     *\n");
	lea	rcx, .LC9[rip]	 #,
	call	puts	 #
 # solarsystem.c:19:     printf("\n");
	mov	ecx, 10	 #,
	call	putchar	 #
 # solarsystem.c:20:     printf("Mars\n");
	lea	rcx, .LC10[rip]	 #,
	call	puts	 #
 # solarsystem.c:21:     printf("      *\n");
	lea	rcx, .LC11[rip]	 #,
	call	puts	 #
 # solarsystem.c:22:     printf("\n");
	mov	ecx, 10	 #,
	call	putchar	 #
 # solarsystem.c:23:     printf("Jupiter\n");
	lea	rcx, .LC12[rip]	 #,
	call	puts	 #
 # solarsystem.c:24:     printf("       *\n");
	lea	rcx, .LC13[rip]	 #,
	call	puts	 #
 # solarsystem.c:25:     printf("\n");
	mov	ecx, 10	 #,
	call	putchar	 #
 # solarsystem.c:26:     printf("Saturn\n");
	lea	rcx, .LC14[rip]	 #,
	call	puts	 #
 # solarsystem.c:27:     printf("        *\n");
	lea	rcx, .LC1[rip]	 #,
	call	puts	 #
 # solarsystem.c:28:     printf("\n");
	mov	ecx, 10	 #,
	call	putchar	 #
 # solarsystem.c:29:     printf("Uranus\n");
	lea	rcx, .LC15[rip]	 #,
	call	puts	 #
 # solarsystem.c:30:     printf("         *\n");
	lea	rcx, .LC16[rip]	 #,
	call	puts	 #
 # solarsystem.c:31:     printf("\n");
	mov	ecx, 10	 #,
	call	putchar	 #
 # solarsystem.c:32:     printf("Neptune\n");
	lea	rcx, .LC17[rip]	 #,
	call	puts	 #
 # solarsystem.c:33:     printf("          *\n");
	lea	rcx, .LC18[rip]	 #,
 # solarsystem.c:34: }
	add	rsp, 40	 #,
 # solarsystem.c:33:     printf("          *\n");
	jmp	puts	 #
	.seh_endproc
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # solarsystem.c:36: int main() {
	call	__main	 #
 # solarsystem.c:37:     drawSolarSystem();
	call	drawSolarSystem	 #
 # solarsystem.c:39: }
	xor	eax, eax	 #
	add	rsp, 40	 #,
	ret	
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
