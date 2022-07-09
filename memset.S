.global memset

/*
 * void *memset(void *mem, int pattern, size_t size)
 *
 * abi:
 *  a0 = mem
 *  a1 = pattern
 *  a2 = size
 *
 *  saved regs: s0, s1
 *  return value: a0
 */
memset:
    # move SP on 16 byte down (SP must be aligned to 16 byte boundary)
    addi sp, sp, -16

    # store RA to current SP+12
    sw ra, 12(sp)

    # memset use s0, s1 for calculation, save prev value on stack
    sw s0, 8(sp)
    sw s1, 4(sp)

    # copy input regs with arguments
    mv s0, a0
    mv s1, a2

_loop:
    # fill mem pointed by s0 with pattern byte
    sb a1, 0(s0)

    # increase mem pointer by 1
    addi s0, s0, 1

    # decrease len by 1
    addi s1, s1, -1

    # len != 0 then repeat
    bne zero, s1, _loop

    # restore saved regs from stack
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)

    # restore SP
    addi sp, sp, 16

    # return
    ret
