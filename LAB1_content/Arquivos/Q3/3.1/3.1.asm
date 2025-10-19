.text

SINCOS:
	addi sp, sp, -80
	fsd fs0, 72(sp)
	fsd fs1, 64(sp)
	fsd fs2, 56(sp)
	fsd fs3, 48(sp)
	fsd fs4, 40(sp)
	sw s0, 36(sp)
	sw s1, 32(sp)
	sw s2, 28(sp)
	sw s3, 24(sp)
	sw s4, 20(sp)
	sw s5, 16(sp)
	sw s6, 12(sp)
	sw s7, 8(sp)
	sw s8, 4(sp)
	sw s9, 0(sp)
	
	mv s10, ra
	fmv.d fs0, fa0
	fcvt.d.w ft4, zero
	li t6, -1
	fcvt.d.w ft6, t6
	li t1, 3
	li s1, 10
	fcvt.d.w ft5, t6
	fcvt.d.w ft1, t1
	fmv.d fs1, fs0
	jal SINPREP
	li s1, 10
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
	jal FUNCI
	jal SUM
	addi t1, t1, 2
	bgt s1, zero, SIN
	li t0, -1
	fcvt.d.w ft1, t0
	fmul.d fs1, fs1, ft1
	fmv.d fa1, fs1
	mv ra, s2
	ret

COSPREP:
	mv s2, ra
COS:
	addi s1, s1, -1
	jal FUNCI
	jal SUM
	addi t1, t1, 2
	bgt s1, zero, COS
	fmv.d fa0, fs1
	mv ra, s2
	ret
	
FUNCI:
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
	fmul.d fs2, fs2, ft5
	fadd.d fs1, fs1, fs2
	fmul.d ft5, ft5, ft6
	ret
	
END:
	lw s9, 0(sp)
    lw s8, 4(sp)
	lw s7, 8(sp)
	lw s6, 12(sp)
	lw s5, 16(sp)
	lw s4, 20(sp)
	lw s3, 24(sp)
	lw s2, 28(sp)
 	lw s1, 32(sp)
	lw s0, 36(sp)
	fld fs4, 40(sp)
	fld fs3, 48(sp)
	fld fs2, 56(sp)
	fld fs1, 64(sp)
	fld fs0, 72(sp)
	addi sp, sp, 80
	
	mv ra, s10
	ret