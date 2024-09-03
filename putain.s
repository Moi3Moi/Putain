# [PUTAIN - main file]
# juan diego pmz (Moi3Moi)
# Mon Sep 2 2024

.include	"macros.inc"

.section	.rodata
	.msg_usage:	.string "[usage]: % puta [filename]\n"
	.len_usage:	.quad	27

	.msg_filep:	.string "[error]: file doesn't work\n"
	.len_filep:	.quad	27

	.msg_cnnto:	.string "[error]: cannot open file\n"
	.len_cnnto:	.quad	26

	.msg_cnnta:	.string "[error]: can't allocate memory\n"
	.len_cnnta:	.quad	31

.section	.text
.globl		_start

_start:
	popq	%rax
	cmpq	$2, %rax
	jne	.print_usage
	# Initializating the stack frame --------*
	#  -8(%rbp): ptr to file's content	 *
	popq	%rax
	popq	%r15
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	# R15 contains the filename -------------*
	movq	%r15, %rdi
	xorq	%rsi, %rsi
	movq	$21, %rax
	syscall
	testl	%eax, %eax
	jnz	.fatal_file
	# Opening the file (R15D <- fd) ---------*
	movq	$2, %rax
	syscall
	cmpl	$-1, %eax
	je	.fatal_cannot_open
	movl	%eax, %r15d
	# Getting file's len (R14 <- len) ------*
	movl	%r15d, %edi
	movq	$2, %rdx
	movq	$8, %rax
	syscall
	movq	%rax, %r14
	# Setting file's cur to the beginning --*
	xorq	%rdx, %rdx
	movq	$8, %rax
	syscall
	# Allocating space for file's content --*
	# RAX = mmap(0 [RDI], [RSI], 3 [RDX], 34 [R10], -1 [R8], 0 [R9]);
	xorq	%rdi, %rdi
	movq	%r14, %rsi
	movl	$3, %edx
	movl	$34, %r10d
	movl	$-1, %r8d
	xorl	%r9d, %r9d
	movq	$9, %rax
	syscall
	cmpq	$-1, %rax
	je	.fatal_cannot_alloc
	movq	%rax, -8(%rbp)
	# Reading & closing file ---------------*
	movl	%r15d, %edi
	movq	-8(%rbp), %rsi
	movq	%r14, %rdx
	movq	$0, %rax
	syscall
	movq	$3, %rax
	syscall
	# Setting '\0' ------------------------*
	movq	-8(%rbp) , %rax
	addq	%r14, %rax
	movb	$0, (%rax)

	movq	-8(%rbp), %rsi
	movq	%r14, %rdx
	incq	%rdx
	movq	$1, %rax
	movq	$1, %rdi
	syscall

.cest_fini:
	FINI	$0

# Errors are handled from here -----------------*
# These labels only call 'PRINTERR' macro	*
# with an specific error.			*
.print_usage:
	PRINTERR	.msg_usage(%rip), .len_usage(%rip)

.fatal_file:
	PRINTERR	.msg_filep(%rip), .len_filep(%rip)

.fatal_cannot_open:
	PRINTERR	.msg_cnnto(%rip), .len_cnnto(%rip)

.fatal_cannot_alloc:
	PRINTERR	.msg_cnnta(%rip), .len_cnnta(%rip)
