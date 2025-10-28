.eqv N 30

.data
.word 0xFFFFFF0F

.text	
	#lui gp,0x10010   # descomentar para rodar no Rars
	li gp, 0x10010000
MAIN:	lw t1,0(gp)		
	addi t2,zero,0x777
	and t0,t1,t2
	or t0,t1,t2
	add t0,t2,t1
	sub t0,t2,t1
	slt t0,t1,t2
	slt t0,t2,t1
	beq t0,zero, PULA
	addi t0,zero,0xFFFFFEEE
	j FIM
PULA:	jal PROC
	addi t0,zero,0xFFFFFCCC
FIM:	j FIM

PROC:	li t0,127
	sw t0,4(gp)
	lw t0,0(gp)
	lw t0,4(gp)
	ret

			

