#include <drivers/ns16550a.h>

#define BASE_ADDR 0x10000000
#define CLK_FREQ 1843200

#define LCR_DLAB 0x80 /* Divisor Latch Bit */
#define LCR_8BIT 0x03 /* 8-bit */
#define LCR_PODD 0x08 /* Parity Odd */

#define LSR_DA 0x01 /* Data Available */
#define LSR_OE 0x02 /* Overrun Error */
#define LSR_PE 0x04 /* Parity Error */
#define LSR_FE 0x08 /* Framing Error */
#define LSR_BI 0x10 /* Break indicator */
#define LSR_RE 0x20 /* THR is empty */
#define LSR_RI 0x40 /* THR is empty and line is idle */
#define LSR_EF 0x80 /* Erroneous data in FIFO */

typedef struct {
    union {
        volatile uint8_t rbr; /* Receive Buffer Register */
        volatile uint8_t thr; /* Transmit Hold Register */
        volatile uint8_t dll; /* Divisor LSB (LCR_DLAB) */
    };
    union {
        volatile uint8_t ier; /* Interrupt Enable Register */
        volatile uint8_t dlm; /* Divisor MSB (LCR_DLAB) */
    };
    volatile uint8_t fcr; /* FIFO Control Register */
    volatile uint8_t lcr; /* Line Control Register */
    volatile uint8_t mcr; /* Modem Control Register */
    volatile uint8_t lsr; /* Line Status Register */
    volatile uint8_t msr; /* Modem Status Register */
    volatile uint8_t scr; /* Scratch Register */
} ns16550_regs_t;


ns16550_regs_t *get_uart(void)
{
    return (ns16550_regs_t *)BASE_ADDR;
}


int ns16650_setup(uint32_t baudrate)
{
    ns16550_regs_t *uart = get_uart();
    uint32_t freq = CLK_FREQ;
    uint32_t div = freq / (16 * baudrate);

    uart->lcr = LCR_DLAB;
    uart->dll = div & 0xff;
    uart->dlm = (div >> 8) & 0xff;
    uart->lcr = LCR_PODD | LCR_8BIT;

    return 0;
}


char ns16650_getchar(void)
{
    ns16550_regs_t *uart = get_uart();
    while(!(uart->lsr & LSR_DA));
    return uart->rbr;
}


void ns16650_putchar(char ch)
{
    ns16550_regs_t *uart = get_uart();
    while(!(uart->lsr & LSR_RI));
    uart->thr = ch;
}
