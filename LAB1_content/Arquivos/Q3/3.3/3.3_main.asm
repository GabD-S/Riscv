.data
PRECISION: .double 0.0001
TEXT: .string "x[n] X[k]\n"
I: .string "i"
PLUS: .string "+"
SPACE: .string " "
ENDL: .string "\n"
N: .word 8
X: .double 0.0, 0.7071, 1.0,  0.7071, 0.0, -0.7071, -1.0, -0.7071 
X_REAL: .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
X_IMAG: .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

.text

MAIN:
	la a0, X
	la a1, X_REAL
	la a2, X_IMAG
	la t0, N
	lw a3, 0(t0)
	jal DFT

PRINT:
	la a0, TEXT
	li a7, 4
	ecall
	mv s0, zero
	la t1, PRECISION
	fld ft1, 0(t1)
PRINTREP:
	slli t0, s0, 3
	add t0, t0, s2
	fld fa0, 0(t0)
	li a7, 3
	ecall
	la a0, SPACE
	li a7, 4
	ecall
	slli t0, s0, 3
	add t0, t0, s3
	fld fa0, 0(t0)
	
	fabs.d ft0, fa0
	flt.d t2, ft0, ft1
	beq t2, zero, SKIP_ATTR_REAL
	fcvt.d.w fa0, zero
SKIP_ATTR_REAL:
	li a7, 3
	ecall
	slli t0, s0, 3
	add t0, t0, s4
	fld fa0, 0(t0)
	
	fabs.d ft0, fa0
	flt.d t2, ft0, ft1
	beq t2, zero, SKIP_ATTR_IMAG
	fcvt.d.w fa0, zero
SKIP_ATTR_IMAG:
	fcvt.d.w ft4, zero
	flt.d t1, fa0, ft4
	beq t1, zero, LOAD_PLUS
PRINT_FINAL:
	li a7, 3
	ecall
	la a0, I
	li a7, 4
	ecall
	la a0, ENDL
	ecall
	addi s0, s0, 1
	blt s0, s7, PRINTREP
	li a7, 10
	ecall
	
LOAD_PLUS:
	la a0, PLUS
	li a7, 4
	ecall
	j PRINT_FINAL
	
	
	
.include "3.2.asm"