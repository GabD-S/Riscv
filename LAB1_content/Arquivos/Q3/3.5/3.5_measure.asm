.data
    Ns:        .word 8,12,16,20,24,28,32,36,40,44,0
    M_calls:   .word 100

    ONE:       .float 1.0
    ZERO:      .float 0.0
    THOUSAND:  .float 1000.0

    header: .asciz "N,M,cycles_total,ms_total,freq_Hz,cycles_per_call,ms_per_call\n"
    comma:  .asciz ","
    newline:.asciz "\n"

    x:   .float 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0
    Xr:  .float 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0
    Xi:  .float 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0

.text
.globl main
main:
    la a0, header
    li a7, 4
    ecall

    la s0, Ns
N_LOOP_SETUP:
    lw s1, 0(s0)
    beq s1, zero, END

    la s2, x
    la s3, Xr
    la s4, Xi

    mv t0, zero
    slli t1, s1, 2
    la t2, ONE
    flw ft0, 0(t2)
    la t3, ZERO
    flw ft1, 0(t3)
FILL_LOOP:
    bge t0, t1, FILL_DONE
    flw ft2, 0(t2)
    fsw ft2, 0(s2)
    fsw ft1, 0(s3)
    fsw ft1, 0(s4)
    addi s2, s2, 4
    addi s3, s3, 4
    addi s4, s4, 4
    addi t0, t0, 4
    j FILL_LOOP
FILL_DONE:

    la s2, x
    la s3, Xr
    la s4, Xi

    la t0, M_calls
    lw s5, 0(t0)

    csrr s6, 3072
    csrr s7, 3073

    mv t2, zero
CALL_LOOP:
    bge t2, s5, CALLS_DONE
    mv a0, s2
    mv a1, s3
    mv a2, s4
    mv a3, s1
    jal ra, DFT
    addi t2, t2, 1
    j CALL_LOOP

CALLS_DONE:
    csrr t3, 3073
    csrr t4, 3072

    sub t5, t3, s7
    sub t6, t4, s6

    mv a4, t5
    bne a4, zero, DT_OK
    li a4, 1
DT_OK:

    fcvt.s.w fa0, t6
    la t0, THOUSAND
    flw ft0, 0(t0)
    fmul.s fa0, fa0, ft0
    fcvt.s.w fa1, a4
    fdiv.s fa0, fa0, fa1
    fmv.s fs0, fa0

    fcvt.s.w ft1, t6
    fcvt.s.w ft2, s5
    fdiv.s ft3, ft1, ft2

    fcvt.s.w ft4, t5
    fdiv.s ft5, ft4, ft2

    mv a0, s1
    li a7, 1
    ecall
    la a0, comma
    li a7, 4
    ecall
    mv a0, s5
    li a7, 1
    ecall
    la a0, comma
    li a7, 4
    ecall
    mv a0, t6
    li a7, 1
    ecall
    la a0, comma
    li a7, 4
    ecall
    mv a0, t5
    li a7, 1
    ecall
    la a0, comma
    li a7, 4
    ecall
    fmv.s fa0, fs0
    li a7, 2
    ecall
    la a0, comma
    li a7, 4
    ecall
    fmv.s fa0, ft3
    li a7, 2
    ecall
    la a0, comma
    li a7, 4
    ecall
    fmv.s fa0, ft5
    li a7, 2
    ecall
    la a0, newline
    li a7, 4
    ecall

    addi s0, s0, 4
    j N_LOOP_SETUP

END:
    li a7, 10
    ecall

.data
    .align 2
TWO_PI:    .float 6.28318530717958647692
ONE_f:     .float 1.0
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

    la t2, ONE_f
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
    la t4, ONE_f
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
    la t2, ONE_f
    flw ft0, 0(t2)
    fmul.s ft2, fs4, ft2
    fsub.s ft2, ft0, ft2
    fmul.s fa1, fs6, ft2
    ret
