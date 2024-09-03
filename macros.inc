# [PUTAIN - macros]
# juan diego pmz (Moi3Moi)
# Mon Sep 3 2024


.macro	FINI, a
	movq	$60, %rax
	movq	\a, %rdi
	syscall
.endm

.macro	PRINTERR, msg, len
	leaq	\msg, %rsi
	movq	\len, %rdx
	movq	$1, %rax
	movq	$2, %rdi
	syscall
	FINI	$1
.endm
