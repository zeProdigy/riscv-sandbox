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

SRC_ASM = startup.S memset.S

SRC_C = main.c

LDSCRIPT = riscv.ld

CFLAGS = -mcmodel=medany -ffunction-sections -fdata-sections -ggdb -O0 -march=rv32imac -mabi=ilp32

LDFLAGS = -melf32lriscv -nostartfiles -nostdlib -nostdinc -static

SRC_ASM_OBJ = $(SRC_ASM:.S=.o)
SRC_C_OBJ = $(SRC_C:.c=.o)

OBJS = $(SRC_ASM_OBJ) $(SRC_C_OBJ)

%.o: %.c
	@echo "     CC $(notdir $<)"
	$(Q)$(GCC) -c $(CFLAGS) -o $@ $<

%.o: %.S
	@echo "     AS $(notdir $<)"
	$(Q)$(GCC) -c $(CFLAGS) -o $@ $<

all: $(PROGNAME).bin $(PROGNAME).dump

$(PROGNAME).elf: $(OBJS)
	@echo "     LD $(notdir $@)"
	$(Q)$(LD) $(LDFLAGS) -o $@ --start-group $(OBJS) --end-group -T $(LDSCRIPT) -Map $(PROGNAME).map

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
