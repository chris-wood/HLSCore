	.text
	addi $t0,$0,1
	addi $t1,$0,2
	add $t2,$t0,$t1
	sw $t2, 0x10000000

        jr $ra

