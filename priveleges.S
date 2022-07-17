#include "macro.S"

.section .text.init

.globl _start
.globl _sp
.globl __global_pointer$

.equ UART_BAUDRATE, 115200

_start:
    __reset_context m_trap

    /* init console */
    li a0, UART_BAUDRATE
    jal ra, ns16650_setup

    la t0, s_trap
    csrw mepc, t0

    li      t2, 0x1800
    csrc    mstatus, t2
    li      t3, 0x800
    csrs    mstatus, t3
    li      t4, 0x100
    csrs    medeleg, t4

    mret

endless_loop:
    j endless_loop

.align 8
m_trap:
    __save_context

    la a0, __m_trap_msg
    csrr a1, mepc
    csrr a2, mcause
    csrr a3, mstatus
    jal ra, printf

    __restore_context

    /* mepc = mepc + 4 */
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

    ecall

.align 8
s_trap:
    __save_context

    la a0, __s_trap_msg
    csrr a1, sepc
    csrr a2, scause
    csrr a3, sstatus
    jal ra, printf

    __restore_context

    /* mepc = mepc + 4 */
    csrr t0, sepc
    addi t0, t0, 4
    csrw sepc, t0

    wfi

_supervisor:
    wfi


__m_trap_msg: .string "m_trap! mepc: 0x%08lx; mcause: 0x%08lx; mstatus 0x%08lx\n"
__s_trap_msg: .string "s_trap! sepc: 0x%08lx; scause: 0x%08lx; sstatus 0x%08lx\n"
__u_trap_msg: .string "u_trap! uepc: 0x%08lx; ucause: 0x%08lx; ustatus 0x%08lx\n"