# [PUTAIN - main file]
# juan diego pmz (Moi3Moi)
# Mon Sep 2 2024

.section	.text
.globl		_start

_start:
	movq	$60, %rax
	movq	$60, %rdi
	syscall
