.section .text.init

.globl _start
.globl _sp
.globl __global_pointer$

.macro _reset
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
la    sp, _sp

.option pop
.endm

_start:
    _reset
    jal ra, _main

_main:
    jal ra, main
endless_loop:
    nop
    j endless_loop
