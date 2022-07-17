PROGNAME = baremetal

ifeq ("$(origin V)", "command line")
	Q =
else
	Q = @
endif

GCC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld
OBJDUMP := $(CROSS_COMPILE)objdump
OBJCOPY := $(CROSS_COMPILE)objcopy

LIBC_PATH = $(dir $(GCC))../riscv64-unknown-elf/lib/rv32imac/ilp32
LIBC_INC_PATH = $(dir $(GCC))../riscv64-unknown-elf/include

SRC_ASM = \
	system/startup.S \
	system/memset.S \
	system/macro.S

SRC_C = \
	main.c \
	system/syscalls.c \
	drivers/ns16550a.c

INC = \
	-Iinclude \
	-I${LIBC_INC_PATH}

LDSCRIPT = riscv.ld

CFLAGS = -mcmodel=medany -ffunction-sections -fdata-sections -ggdb -O0 -march=rv32imac -mabi=ilp32 -specs=nano.specs

LDFLAGS = -melf32lriscv -nostartfiles -nostdlib -nostdinc -static -L ${LIBC_PATH}

SRC_ASM_OBJ = $(SRC_ASM:.S=.o)
SRC_C_OBJ = $(SRC_C:.c=.o)

OBJS = $(SRC_ASM_OBJ) $(SRC_C_OBJ)

%.o: %.c
	@echo "     CC $(notdir $<)"
	$(Q)$(GCC) $(INC) -c $(CFLAGS) -o $@ $<

%.o: %.S
	@echo "     AS $(notdir $<)"
	$(Q)$(GCC) $(INC) -c $(CFLAGS) -o $@ $<

all: $(PROGNAME).bin $(PROGNAME).dump

$(PROGNAME).elf: $(OBJS)
	@echo "     LD $(notdir $@)"
	$(Q)$(LD) $(INC) $(LDFLAGS) -o $@ --start-group -lc_nano $(OBJS) --end-group -T $(LDSCRIPT) -Map $(PROGNAME).map

$(PROGNAME).bin: $(PROGNAME).elf
	@echo "OBJCOPY $(notdir $@)"
	$(Q)$(OBJCOPY) -O binary $^ $@

$(PROGNAME).dump: $(PROGNAME).elf
	@echo "OBJDUMP $(notdir $@)"
	$(Q)$(OBJDUMP) -dlS $^ > $@

clean:
	$(Q)rm -f $(OBJS)
	$(Q)rm -f $(PROGNAME).elf
	$(Q)rm -f $(PROGNAME).bin
	$(Q)rm -f $(PROGNAME).map
	$(Q)rm -f $(PROGNAME).dump
