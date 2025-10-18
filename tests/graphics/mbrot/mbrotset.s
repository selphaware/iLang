	.file	"mbrotset.c"
	.text
	.local	orig_termios
	.comm	orig_termios,60,32
	.local	term_inited
	.comm	term_inited,4,4
	.section	.rodata
.LC0:
	.string	"\033[?25h"
	.text
	.type	restore_terminal, @function
restore_terminal:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	term_inited(%rip), %eax
	testl	%eax, %eax
	je	.L4
	leaq	orig_termios(%rip), %rax
	movq	%rax, %rdx
	movl	$2, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	movl	$0, %edx
	movl	$3, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	fcntl@PLT
	movl	%eax, -4(%rbp)
	cmpl	$-1, -4(%rbp)
	je	.L3
	movl	-4(%rbp), %eax
	andb	$-9, %ah
	movl	%eax, %edx
	movl	$4, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	fcntl@PLT
.L3:
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
.L4:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	restore_terminal, .-restore_terminal
	.type	setup_terminal, @function
setup_terminal:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	orig_termios(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	tcgetattr@PLT
	movq	orig_termios(%rip), %rax
	movq	8+orig_termios(%rip), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	16+orig_termios(%rip), %rax
	movq	24+orig_termios(%rip), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	32+orig_termios(%rip), %rax
	movq	40+orig_termios(%rip), %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	44+orig_termios(%rip), %rax
	movq	52+orig_termios(%rip), %rdx
	movq	%rax, -36(%rbp)
	movq	%rdx, -28(%rbp)
	movl	-68(%rbp), %eax
	andl	$-11, %eax
	movl	%eax, -68(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, %rdx
	movl	$2, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	movl	$0, %edx
	movl	$3, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	fcntl@PLT
	movl	%eax, -84(%rbp)
	cmpl	$-1, -84(%rbp)
	je	.L6
	movl	-84(%rbp), %eax
	orb	$8, %ah
	movl	%eax, %edx
	movl	$4, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	fcntl@PLT
.L6:
	movl	$1, term_inited(%rip)
	leaq	restore_terminal(%rip), %rax
	movq	%rax, %rdi
	call	atexit@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L7
	call	__stack_chk_fail@PLT
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	setup_terminal, .-setup_terminal
	.type	key_pressed, @function
key_pressed:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-17(%rbp), %rax
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	read@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	setg	%al
	movzbl	%al, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	key_pressed, .-key_pressed
	.type	sleep_ms, @function
sleep_ms:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	imull	$1000, %eax, %eax
	movl	%eax, %edi
	call	usleep@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	sleep_ms, .-sleep_ms
	.section	.rodata
.LC1:
	.string	" .:-=+*#%@"
.LC6:
	.base64	"G1syShtbSBtbPzI1bAA="
.LC7:
	.string	"\033[H"
.LC16:
	.string	"\033[?25h\033[0m"
	.text
	.globl	main
	.type	main, @function
main:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	call	setup_terminal
	movl	$100, -152(%rbp)
	movl	$40, -148(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -144(%rbp)
	movsd	.LC2(%rip), %xmm0
	movsd	%xmm0, -136(%rbp)
	movsd	.LC3(%rip), %xmm0
	movsd	%xmm0, -128(%rbp)
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, -120(%rbp)
	movsd	.LC5(%rip), %xmm0
	movsd	%xmm0, -64(%rbp)
	movl	$0, -172(%rbp)
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	jmp	.L13
.L33:
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movsd	-120(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	addsd	%xmm0, %xmm1
	movq	%xmm1, %rax
	movq	%rax, %xmm0
	call	log@PLT
	movsd	.LC8(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %eax
	addl	$80, %eax
	movl	%eax, -168(%rbp)
	cmpl	$79, -168(%rbp)
	jg	.L14
	movl	$80, -168(%rbp)
.L14:
	movl	$0, -164(%rbp)
	jmp	.L15
.L30:
	movl	$0, -160(%rbp)
	jmp	.L16
.L29:
	movsd	.LC4(%rip), %xmm0
	divsd	-120(%rbp), %xmm0
	movsd	%xmm0, -56(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-160(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-152(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm3
	movapd	%xmm1, %xmm2
	divsd	%xmm3, %xmm2
	movapd	%xmm0, %xmm1
	subsd	%xmm2, %xmm1
	pxor	%xmm2, %xmm2
	cvtsi2sdl	-152(%rbp), %xmm2
	movsd	.LC10(%rip), %xmm0
	divsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	mulsd	-56(%rbp), %xmm0
	movsd	-136(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-164(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-148(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm3
	movapd	%xmm1, %xmm2
	divsd	%xmm3, %xmm2
	movapd	%xmm0, %xmm1
	subsd	%xmm2, %xmm1
	pxor	%xmm2, %xmm2
	cvtsi2sdl	-148(%rbp), %xmm2
	movsd	.LC9(%rip), %xmm0
	divsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	mulsd	-56(%rbp), %xmm0
	movsd	-128(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -112(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -88(%rbp)
	movl	$0, -156(%rbp)
	jmp	.L17
.L20:
	movsd	-112(%rbp), %xmm0
	addsd	%xmm0, %xmm0
	mulsd	-104(%rbp), %xmm0
	movsd	-40(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -104(%rbp)
	movsd	-96(%rbp), %xmm0
	subsd	-88(%rbp), %xmm0
	movsd	-48(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -112(%rbp)
	movsd	-112(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
	movsd	-104(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	movsd	%xmm0, -88(%rbp)
	addl	$1, -156(%rbp)
.L17:
	movsd	-96(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	addsd	-88(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	comisd	%xmm1, %xmm0
	jb	.L18
	movl	-156(%rbp), %eax
	cmpl	-168(%rbp), %eax
	jl	.L20
.L18:
	movl	-156(%rbp), %eax
	cmpl	-168(%rbp), %eax
	jl	.L21
	movb	$32, -173(%rbp)
	jmp	.L22
.L21:
	movsd	-96(%rbp), %xmm0
	addsd	-88(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
	movsd	-32(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L40
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	log@PLT
	movq	%xmm0, %rax
	movsd	.LC9(%rip), %xmm1
	movq	%rax, %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm0
	movsd	.LC13(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	log@PLT
	movq	%xmm0, %rax
	movsd	.LC13(%rip), %xmm1
	movq	%rax, %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	-156(%rbp), %eax
	addl	$1, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	subsd	-16(%rbp), %xmm0
	movsd	%xmm0, -8(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-168(%rbp), %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -80(%rbp)
	pxor	%xmm0, %xmm0
	comisd	-80(%rbp), %xmm0
	jbe	.L25
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -80(%rbp)
.L25:
	movsd	-80(%rbp), %xmm0
	movsd	.LC4(%rip), %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L27
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, -80(%rbp)
	jmp	.L27
.L40:
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-156(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-168(%rbp), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -80(%rbp)
.L27:
	movl	-144(%rbp), %eax
	subl	$1, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	mulsd	-80(%rbp), %xmm0
	cvttsd2sil	%xmm0, %eax
	movl	%eax, -140(%rbp)
	movl	-172(%rbp), %eax
	cltd
	idivl	-144(%rbp)
	movl	-140(%rbp), %eax
	addl	%edx, %eax
	cltd
	idivl	-144(%rbp)
	movl	%edx, -140(%rbp)
	movl	-140(%rbp), %eax
	movslq	%eax, %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -173(%rbp)
.L22:
	movsbl	-173(%rbp), %eax
	movl	%eax, %edi
	call	putchar@PLT
	addl	$1, -160(%rbp)
.L16:
	movl	-160(%rbp), %eax
	cmpl	-152(%rbp), %eax
	jl	.L29
	movl	$10, %edi
	call	putchar@PLT
	addl	$1, -164(%rbp)
.L15:
	movl	-164(%rbp), %eax
	cmpl	-148(%rbp), %eax
	jl	.L30
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movsd	-120(%rbp), %xmm0
	mulsd	-64(%rbp), %xmm0
	movsd	%xmm0, -120(%rbp)
	movsd	-120(%rbp), %xmm0
	comisd	.LC14(%rip), %xmm0
	jbe	.L31
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, -120(%rbp)
	movl	$0, -172(%rbp)
	movsd	.LC15(%rip), %xmm0
	movsd	%xmm0, -136(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -128(%rbp)
.L31:
	addl	$1, -172(%rbp)
	movl	$30, %edi
	call	sleep_ms
.L13:
	call	key_pressed
	testl	%eax, %eax
	je	.L33
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC2:
	.long	1138113657
	.long	-1075328018
	.align 8
.LC3:
	.long	-710284233
	.long	1069604779
	.align 8
.LC4:
	.long	0
	.long	1072693248
	.align 8
.LC5:
	.long	1202590843
	.long	1072724705
	.align 8
.LC8:
	.long	0
	.long	1077149696
	.align 8
.LC9:
	.long	0
	.long	1073741824
	.align 8
.LC10:
	.long	0
	.long	1074528256
	.align 8
.LC12:
	.long	0
	.long	1074790400
	.align 8
.LC13:
	.long	-17155601
	.long	1072049730
	.align 8
.LC14:
	.long	0
	.long	1085227008
	.align 8
.LC15:
	.long	0
	.long	-1075314688
	.ident	"GCC: (GNU) 15.2.1 20250813"
	.section	.note.GNU-stack,"",@progbits
