.data
PIK: .double -0.785398163397448309

.text

DFT: 	
	mv s8, ra
	mv s2, a0
	mv s3, a1
	mv s4, a2
	mv s7, a3
	mv s0, zero
	fcvt.d.w fs0, s7
	jal PREPFORK
	mv ra, s8
	ret
	

THETA:
	la t0, PIK
	fld ft0, 0(t0)
	mul t0, s0, s1
	rem t0, t0, s7
	fcvt.d.w ft1, t0
	fmul.d ft1, ft1, ft0
	fmv.d fa0, ft1
	ret
	
PREPFORK:
	mv s6, ra
FORK:	
	fcvt.d.w fs3, zero
	fcvt.d.w fs4, zero
	jal PREPSUM
	addi s0, s0, 1
	blt s0, s7, FORK
	mv ra, s6
	ret

PREPSUM:
	mv s5, ra
	mv s1, zero
SUMDFT:
	slli t0, s1, 3
	add t0, t0, s2
	fld fs1, 0(t0)
	jal THETA
	jal SINCOS
	li t0, -1
	fcvt.d.w ft2, t0
	fmul.d ft0, fs1, fa0
	fmul.d ft1, fs1, fa1
	fadd.d fs3, fs3, ft0
	fmul.d ft1, ft1, ft2
	fadd.d fs4, fs4, ft1
	jal ALLOC
	addi s1, s1, 1
	blt s1, s7, SUMDFT
	mv ra, s5
	ret

ALLOC:
	slli t0, s0, 3
	add t0, t0, s3
	fsd fs3, 0(t0)
	slli t0, s0, 3
	add t0, t0, s4
	fsd fs4, 0(t0)
	ret

.include "3.1.asm"
