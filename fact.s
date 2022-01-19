# Enrique Tapia
# CMPS 3240
# This program returns the value of the 10th fibonacci sequence
# using a while loop.


	.file	"fact.c"
	.text
	.section	.rodata
.LC0:
	.string	"fib 10 is: %d\n"
	.text
	.globl	main
	.type	main, @function

main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$24, %rsp
	movl	$0, -4(%rbp)
	movl	$1, -8(%rbp)	
	movl	$0, -12(%rbp)	
	movl	$10, -16(%rbp)	

.L2:
	# result = a + b
	movl	$0,	%eax		#clear out register eax
	movl	$0,	%ecx		#clear out register ecx
	movl	-4(%rbp), %eax	
	movl	-8(%rbp), %ecx	
	addl	%ecx, %eax		
	movl	%eax, -12(%rbp)	

	#a = b
	movl	%ecx, -4(%rbp)
	#register ecx still holds the value of b from our previous opperation (line 35)

	#b = result
	movl	%eax, -8(%rbp)
	#register eax has the same value as result. (lines 36 & 37)

	#decrease counter
	subl	$1, -16(%rbp)
	cmpl	$1, -16(%rbp)
	jg	.L2

	#print result
	movl	-12(%rbp), %eax	
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
