#include <stdint.h>
#include <stdlib.h>

void *memset(void *mem, int pattern, size_t size);

int main(void)
{
    uint8_t arr[8];
    void *p;

    p = memset(arr, 0x55, sizeof(arr));

    return 0;
}
