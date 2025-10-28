.data
.word 3

.text

LOOP:	lw t0, 0(gp)
	addi t0, t0, 1
	addi t1, zero, 0x00400000
	jalr t0, t1, 4
