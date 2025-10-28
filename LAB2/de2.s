.data
.word 1

.text
	li t0, 1
	addi t1, zero, 1
LOOP:	addi t0, t0, 2
	and t0, t0, t1
	j LOOP