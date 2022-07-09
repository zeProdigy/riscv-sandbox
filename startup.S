.section .text.init

.globl _start
.globl _sp
.globl __global_pointer$

_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop;
    la    sp, _sp
    jal   zero, _main

_main:
    jal main
    wfi
