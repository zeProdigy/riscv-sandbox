#pragma once

#include <stdint.h>

int ns16650_setup(uint32_t baudrate);
char ns16650_getchar(void);
void ns16650_putchar(char ch);
