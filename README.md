# RISC-V Sandbox

## Toolchain

https://github.com/sifive/freedom-tools/releases

## Debug

Launch Qemu and wait to GDB connection

```
~> qemu-system-riscv32 -nographic -machine virt -gdb tcp::3333 -S -kernel baremetal.elf -bios none
```

To stop Qemu use ctrl-a x

GDB

```
~> riscv64-unknown-elf-gdb baremetal.elf
~> target extended-remote :3333
```
