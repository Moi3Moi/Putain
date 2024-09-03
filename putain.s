# [PUTAIN - main file]
# juan diego pmz (Moi3Moi)
# Mon Sep 2 2024

.include	"macros.inc"

.section	.rodata
	.msg_usage:	.string "[usage]: % puta [filename]\n"
	.len_usage:	.quad	27

	.msg_filep:	.string "[error]: file doesn't work\n"
	.len_filep:	.quad	27


.section	.text



.globl		_start

_start:
	popq	%rax
	cmpq	$2, %rax
	jne	.print_usage
	# Initializating the stack frame --------*
	popq	%rax
	popq	%rax
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	# R15 contains the filename -------------*
	movq	%rax, %r15
	movq	%r15, %rdi
	xorl	%esi, %esi
	movq	$21, %rax
	syscall
	testl	%eax, %eax
	jnz	.fatal_file



.cest_fini:
	FINI	$0

# Errors are handled from here -----------------*
# These labels only call 'PRINTERR' macro	*
# with an specific error.			*
.print_usage:
	PRINTERR	.msg_usage(%rip), .len_usage(%rip)

.fatal_file:
	PRINTERR	.msg_filep(%rip), .len_filep(%rip)
