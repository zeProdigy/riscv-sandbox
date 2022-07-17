#include "macro.S"

.section .text.init

.globl _start
.globl _sp
.globl __global_pointer$

.equ UART_BAUDRATE, 115200
.equ U32_CONST, 0x12345678

_start:
    __reset_context m_trap

    /* init console */
    li a0, UART_BAUDRATE
    jal ra, ns16650_setup

    ecall

    jal ra, _main

_main:
    jal ra, main
endless_loop:
    nop
    j endless_loop

/*
 * Exceptions in RISC-V
 *
 * When an exception happens, the hardware sets the mcause register with the
 * corresponding exception code. The pc is set to the trap handler base
 * address. To return from Trap using mret command that set pc = mepc addr
 *
 * CSRs
 *  mtvec: адрес Trap handler
 *  mcause: код причины exception
 *  mepc: адрес команды, на которой случился exception
 *
 */
.align 8
m_trap:
    __save_context

    la a0, __trap_msg
    csrr a1, mepc
    csrr a2, mcause
    csrr a3, mstatus
    jal ra, printf

    __restore_context

    /* mepc = mepc + 4 */
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

    mret

__trap_msg: .string "Trapped! mepc: 0x%08lx; mcause: 0x%08lx; mstatus 0x%08lx\n"

