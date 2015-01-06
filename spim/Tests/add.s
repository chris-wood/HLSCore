	.data
val1:	.word	1
val2:	.word	2
res1:	.word	0
	.text
	.globl main
main:

	lw $t0, val1
	lw $t1, val2
	add $t2,$t0,$t1
	sw $t2, res1

        jr $ra

