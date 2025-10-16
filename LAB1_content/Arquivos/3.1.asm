.text

MAIN:
	li a7, 7
	ecall
	
	j SINCOS
	
SINCOS:
	fmv.d fs0, fa0
	fcvt.d.w ft4, zero
	li t6, -1
	fcvt.d.w ft6, t6
	li t1, 1
	li s1, 5
	fcvt.d.w ft5, t1
	fcvt.d.w ft1, t1
	jal SINPREP
	li s1, 4
	li t1, 1
	fcvt.d.w ft5, t6
	fcvt.d.w fs1, t1
	li t1, 2
	jal COSPREP
	j END

SINPREP:
	mv s2, ra
SIN:
	addi s1, s1, -1
	jal SINI
	jal SUM
	addi t1, t1, 2
	bgt s1, zero, SIN
	fmv.d fa0, fs1
	mv ra, s2
	ret

COSPREP:
	mv s7, ra
COS:
	addi s1, s1, -1
	jal SINI
	jal SUM
	addi t1, t1, 2
	bgt s1, zero, COS
	fmv.d fa1, fs1
	mv ra, s7
	ret
	
END:
	li a7, 10
	ecall
	
SINI:
	mv s3, ra
	mv t2, t1
	li s0, 1
	fmv.d fs2, fs0
	jal FATPREP
	mv t2, t1
	addi t2, t2, -1
	beq t2, zero, CONTINUE
	jal POWPREP
	
CONTINUE:
	fcvt.d.w fs3, s0
	fdiv.d fs2, fs2, fs3
	mv ra, s3
	ret

FATPREP:
	mv s4, ra
FAT:
	fcvt.d.w ft2, t2
	fdiv.d fs2, fs2, ft2
	addi t2, t2, -1
	bgt t2, zero, FAT
	mv ra, s4
	ret
	
POWPREP:
	mv s5, ra
POW:
	fmul.d fs2, fs2, fs0
	addi t2, t2, -1
	bgt t2, zero, POW
	mv ra, s5
	ret
	
	
SUM:
	mv s6, ra
	fmul.d fs2, fs2, ft5
	fadd.d fs1, fs1, fs2
	fmul.d ft5, ft5, ft6
	mv ra, s6
	ret
	
	