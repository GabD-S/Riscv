.data
	.align 2
TWO_PI:    .float 6.28318530717958647692
ONE:       .float 1.0
NEG_ONE:   .float -1.0

INV_F2: .float 0.5                 # 1/2!
INV_F3: .float 0.1666666716337204  # 1/3!
INV_F4: .float 0.0416666679084301  # 1/4!
INV_F5: .float 0.0083333337679505  # 1/5!
INV_F6: .float 0.0013888889225192  # 1/6!
INV_F7: .float 0.0001984127011141  # 1/7!
INV_F8: .float 0.0000248015871480  # 1/8!
INV_F9: .float 0.0000027557318840  # 1/9!

.text
.globl DFT
DFT:
	addi sp, sp, -64
	sw ra, 60(sp)
	sw s0, 56(sp)
	sw s1, 52(sp)
	sw s2, 48(sp)
	sw s3, 44(sp)
	sw s4, 40(sp)
	sw s5, 36(sp)
	sw s6, 32(sp)
	sw s7, 28(sp)

	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3, a3

	blez s3, DFT_DONE

	li s4, 0

K_LOOP:
	bge s4, s3, DFT_DONE

	fcvt.s.w fs0, zero
	fcvt.s.w fs1, zero

	# step_angle = 2*pi * k / N (e^{-jθ})
	la t0, TWO_PI
	flw ft0, 0(t0)
	fcvt.s.w ft1, s4
	fmul.s ft2, ft0, ft1
	fcvt.s.w ft3, s3
	fdiv.s fa0, ft2, ft3
	jal ra, SINCOSF

	# c0 = cos(step), s0 = -sin(step)
	fmv.s ft4, fa0
	la t1, NEG_ONE
	flw ft5, 0(t1)
	fmul.s ft6, fa1, ft5

	la t2, ONE
	flw fs2, 0(t2)
	fcvt.s.w fs3, zero

	li s5, 0

N_LOOP:
	bge s5, s3, STORE_K

	slli t3, s5, 2
	add t4, s0, t3
	flw ft7, 0(t4)

	# sumR += x[n]*c ; sumI += x[n]*s
	fmul.s ft8, ft7, fs2
	fadd.s fs0, fs0, ft8
	fmul.s ft9, ft7, fs3
	fadd.s fs1, fs1, ft9

	# Atualiza (c,s) *= (c0 + j*s0); tmp_c = c*c0 - s*s0 ; tmp_s = c*s0 + s*c0
	fmul.s ft10, fs2, ft4
	fmul.s ft11, fs3, ft6
	fsub.s ft12, ft10, ft11
	fmul.s ft13, fs2, ft6
	fmul.s ft14, fs3, ft4
	fadd.s ft15, ft13, ft14
	fmv.s fs2, ft12
	fmv.s fs3, ft15

	addi s5, s5, 1
	j N_LOOP

STORE_K:
	# X_real[k] = sumR ; X_imag[k] = sumI
	slli t5, s4, 2
	add t6, s1, t5
	fsw fs0, 0(t6)
	add t7, s2, t5
	fsw fs1, 0(t7)

	addi s4, s4, 1
	j K_LOOP

DFT_DONE:
	lw s7, 28(sp)
	lw s6, 32(sp)
	lw s5, 36(sp)
	lw s4, 40(sp)
	lw s3, 44(sp)
	lw s2, 48(sp)
	lw s1, 52(sp)
	lw s0, 56(sp)
	lw ra, 60(sp)
	addi sp, sp, 64
	ret

 
SINCOSF:
	# x2 = x^2
	fmul.s ft0, fa0, fa0

	# cos(x) ≈ 1 - x^2*(1/2! - x^2*(1/4! - x^2*(1/6! - x^2*(1/8!))))
	la t0, INV_F8
	flw ft1, 0(t0)          # 1/8!
	la t1, INV_F6
	flw ft2, 0(t1)          # 1/6!
	fmul.s ft3, ft0, ft1
	fsub.s ft4, ft2, ft3
	la t2, INV_F4
	flw ft5, 0(t2)          # 1/4!
	fmul.s ft6, ft0, ft4
	fsub.s ft7, ft5, ft6
	la t3, INV_F2
	flw ft8, 0(t3)          # 1/2!
	fmul.s ft9, ft0, ft7
	fsub.s ft10, ft8, ft9
	la t4, ONE
	flw ft11, 0(t4)
	fmul.s ft12, ft0, ft10
	fsub.s fa0, ft11, ft12

	# sin(x) ≈ x*(1 - x^2*(1/3! - x^2*(1/5! - x^2*(1/7! - x^2*(1/9!)))))
	la t5, INV_F9
	flw ft13, 0(t5)         # 1/9!
	la t6, INV_F7
	flw ft14, 0(t6)         # 1/7!
	fmul.s ft15, ft0, ft13
	fsub.s ft16, ft14, ft15
	la t7, INV_F5
	flw ft17, 0(t7)         # 1/5!
	fmul.s ft18, ft0, ft16
	fsub.s ft19, ft17, ft18
	la t8, INV_F3
	flw ft20, 0(t8)         # 1/3!
	fmul.s ft21, ft0, ft19
	fsub.s ft22, ft20, ft21
	la t9, ONE
	flw ft23, 0(t9)
	fmul.s ft24, ft0, ft22
	fsub.s ft25, ft23, ft24
	fmul.s fa1, fa0, ft25

	ret

