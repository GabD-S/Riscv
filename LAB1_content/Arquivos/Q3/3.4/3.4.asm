.data
    N:      .word 8

x1_arr: .float 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
x2_arr: .float 1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071, 0.0, 0.7071
x3_arr: .float 0.0, 0.7071, 1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071
x4_arr: .float 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0

Xr: .float 0,0,0,0,0,0,0,0
Xi: .float 0,0,0,0,0,0,0,0

hdr:  .asciz "x[n]    X[k]\n"
sep:  .asciz "    "
plus: .asciz " + "
ci:   .asciz "i\n"
lab1: .asciz "\n=== x1 ===\n"
lab2: .asciz "\n=== x2 ===\n"
lab3: .asciz "\n=== x3 ===\n"
lab4: .asciz "\n=== x4 ===\n"

.text
.globl main
main:
    la a0, lab1
    li a7, 4
    ecall
    la a0, x1_arr
    la a1, Xr
    la a2, Xi
    la t0, N
    lw a3, 0(t0)
    jal ra, DFT
    la t2, x1_arr
    jal ra, PRINT_BLOCK

    la a0, lab2
    li a7, 4
    ecall
    la a0, x2_arr
    la a1, Xr
    la a2, Xi
    la t0, N
    lw a3, 0(t0)
    jal ra, DFT
    la t2, x2_arr
    jal ra, PRINT_BLOCK

    la a0, lab3
    li a7, 4
    ecall
    la a0, x3_arr
    la a1, Xr
    la a2, Xi
    la t0, N
    lw a3, 0(t0)
    jal ra, DFT
    la t2, x3_arr
    jal ra, PRINT_BLOCK

    la a0, lab4
    li a7, 4
    ecall
    la a0, x4_arr
    la a1, Xr
    la a2, Xi
    la t0, N
    lw a3, 0(t0)
    jal ra, DFT
    la t2, x4_arr
    jal ra, PRINT_BLOCK

    li a7, 10
    ecall

PRINT_BLOCK:
    la a0, hdr
    li a7, 4
    ecall

    li t0, 0
    la t1, N
    lw t1, 0(t1)
    la t3, Xr
    la t4, Xi

P_LOOP:
    bge t0, t1, P_DONE

    flw fa0, 0(t2)
    li a7, 2
    ecall

    la a0, sep
    li a7, 4
    ecall

    flw fa0, 0(t3)
    li a7, 2
    ecall

    la a0, plus
    li a7, 4
    ecall

    flw fa0, 0(t4)
    li a7, 2
    ecall

    la a0, ci
    li a7, 4
    ecall

    addi t0, t0, 1
    addi t2, t2, 4
    addi t3, t3, 4
    addi t4, t4, 4
    j P_LOOP

P_DONE:
    ret

.data
    .align 2
TWO_PI:    .float 6.28318530717958647692
ONE:       .float 1.0
NEG_ONE:   .float -1.0

INV_F2: .float 0.5
INV_F3: .float 0.1666666716337204
INV_F4: .float 0.0416666679084301
INV_F5: .float 0.0083333337679505
INV_F6: .float 0.0013888889225192
INV_F7: .float 0.0001984127011141
INV_F8: .float 0.0000248015871480
INV_F9: .float 0.0000027557318840

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

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    ble s3, zero, DFT_DONE

    li s4, 0
K_LOOP:
    bge s4, s3, DFT_DONE
    fcvt.s.w fs0, zero
    fcvt.s.w fs1, zero

    la t0, TWO_PI
    flw ft0, 0(t0)
    fcvt.s.w ft1, s4
    fmul.s ft2, ft0, ft1
    fcvt.s.w ft1, s3
    fdiv.s fa0, ft2, ft1
    jal ra, SINCOSF

    fmv.s fs4, fa0
    la t1, NEG_ONE
    flw ft0, 0(t1)
    fmul.s fs5, fa1, ft0

    la t2, ONE
    flw fs2, 0(t2)
    fcvt.s.w fs3, zero

    li s5, 0
N_LOOP:
    bge s5, s3, STORE_K

    slli t3, s5, 2
    add t4, s0, t3
    flw ft0, 0(t4)

    fmul.s ft1, ft0, fs2
    fadd.s fs0, fs0, ft1
    fmul.s ft1, ft0, fs3
    fadd.s fs1, fs1, ft1
    fmul.s ft1, fs2, fs4
    fmul.s ft2, fs3, fs5
    fsub.s ft3, ft1, ft2
    fmul.s ft1, fs2, fs5
    fmul.s ft2, fs3, fs4
    fadd.s ft2, ft1, ft2
    fmv.s fs2, ft3
    fmv.s fs3, ft2

    addi s5, s5, 1
    j N_LOOP

STORE_K:
    slli t5, s4, 2
    add t6, s1, t5
    fsw fs0, 0(t6)
    add t6, s2, t5
    fsw fs1, 0(t6)

    addi s4, s4, 1
    j K_LOOP

DFT_DONE:
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
    fmv.s fs6, fa0
    fmul.s fs4, fs6, fs6

    la t0, INV_F8
    flw ft0, 0(t0)
    la t1, INV_F6
    flw ft1, 0(t1)
    fmul.s ft2, fs4, ft0
    fsub.s ft2, ft1, ft2
    la t2, INV_F4
    flw ft0, 0(t2)
    fmul.s ft2, fs4, ft2
    fsub.s ft2, ft0, ft2
    la t3, INV_F2
    flw ft1, 0(t3)
    fmul.s ft2, fs4, ft2
    fsub.s ft2, ft1, ft2
    la t4, ONE
    flw ft0, 0(t4)
    fmul.s ft2, fs4, ft2
    fsub.s fa0, ft0, ft2
    la t5, INV_F9
    flw ft0, 0(t5)
    la t6, INV_F7
    flw ft1, 0(t6)
    fmul.s ft2, fs4, ft0
    fsub.s ft2, ft1, ft2
    la t0, INV_F5
    flw ft0, 0(t0)
    fmul.s ft2, fs4, ft2
    fsub.s ft2, ft0, ft2
    la t1, INV_F3
    flw ft1, 0(t1)
    fmul.s ft2, fs4, ft2
    fsub.s ft2, ft1, ft2
    la t2, ONE
    flw ft0, 0(t2)
    fmul.s ft2, fs4, ft2
    fsub.s ft2, ft0, ft2
    fmul.s fa1, fs6, ft2
    ret
