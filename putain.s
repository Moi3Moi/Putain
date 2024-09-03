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

.section	.text



.globl		_start

_start:
	popq	%rax
	cmpq	$2, %rax
	jne	.print_usage
	# Initializating the stack frame --------*
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
