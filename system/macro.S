.macro __reset_context trap_hander
mv x1, zero
mv x2, zero
mv x3, zero
mv x4, zero
mv x5, zero
mv x6, zero
mv x7, zero
mv x8, zero
mv x9, zero
mv x10, zero
mv x11, zero
mv x12, zero
mv x13, zero
mv x14, zero
mv x15, zero
mv x16, zero
mv x17, zero
mv x18, zero
mv x19, zero
mv x20, zero
mv x21, zero
mv x22, zero
mv x23, zero
mv x24, zero
mv x25, zero
mv x26, zero
mv x27, zero
mv x28, zero
mv x29, zero
mv x30, zero
mv x31, zero

.option push
.option norelax

# init Global Pointer reg
la gp, __global_pointer$

# set Return Address reg
la ra, _start

# set Stack Pointer
la sp, _sp

# set MTVEC csr with Trap addr
la t0, \trap_hander
csrw mtvec, t0

.option pop
.endm

.macro push reg, offset
    sw \reg, (\offset * 4)(sp)
.endm

.macro pop reg, offset
    lw \reg, (\offset * 4)(sp)
.endm

.macro __save_context
    addi sp, sp, -32 * 4
    push x1, 0
    push x1, 1
    push x2, 2
    push x3, 3
    push x4, 4
    push x5, 5
    push x6, 6
    push x7, 7
    push x8, 8
    push x9, 9
    push x10, 10
    push x11, 11
    push x12, 12
    push x13, 13
    push x14, 14
    push x15, 15
    push x16, 16
    push x17, 17
    push x18, 18
    push x19, 19
    push x20, 20
    push x21, 21
    push x22, 22
    push x23, 23
    push x24, 24
    push x25, 25
    push x26, 26
    push x27, 27
    push x28, 28
    push x29, 29
    push x30, 30
    push x31, 31
.endm

.macro __restore_context
    pop x1, 0
    pop x1, 1
    pop x2, 2
    pop x3, 3
    pop x4, 4
    pop x5, 5
    pop x6, 6
    pop x7, 7
    pop x8, 8
    pop x9, 9
    pop x10, 10
    pop x11, 11
    pop x12, 12
    pop x13, 13
    pop x14, 14
    pop x15, 15
    pop x16, 16
    pop x17, 17
    pop x18, 18
    pop x19, 19
    pop x20, 20
    pop x21, 21
    pop x22, 22
    pop x23, 23
    pop x24, 24
    pop x25, 25
    pop x26, 26
    pop x27, 27
    pop x28, 28
    pop x29, 29
    pop x30, 30
    pop x31, 31
    addi sp, sp, 32 * 4
.endm
