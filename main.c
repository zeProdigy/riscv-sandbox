#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>

#include <drivers/ns16550a.h>

void *memset(void *mem, int pattern, size_t size);

int main(void)
{
    uint8_t arr[8];
    char ch;
    void *p;
    int val = 0x12345678;

    p = memset(arr, 0x55, sizeof(arr));

    printf("Hello, QEMU! 0x%lx\n", val);

    while(true)
        ns16650_putchar(ns16650_getchar());

    return 0;
}
