OUTPUT_ARCH( "riscv" )

ENTRY( _start )

MEMORY
{
  ram (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 128M
}

PHDRS
{
  text 1;
  data 1;
  bss 1;
  ram 1;
}

SECTIONS
{
	__stack_size = DEFINED(__stack_size) ? __stack_size : 4096;
    PROVIDE(__stack_size = __stack_size);

	.text : ALIGN(4) {
		PROVIDE(_text_start = .);
		*(.text.init) *(.text .text.*)
		PROVIDE(_text_end = .);
	} >ram AT>ram :text

	.rodata : ALIGN(4) {
		PROVIDE(_rodata_start = .);
		*(.rodata .rodata.*)
		PROVIDE(_rodata_end = .);
	} >ram AT>ram :text

	.data : ALIGN(4) {
		PROVIDE(_data_start = .);
		PROVIDE( __global_pointer$ = . + 0x800 );
		*(.sdata .sdata.*) *(.data .data.*)
		PROVIDE(_data_end = .);
	} >ram AT>ram :data

	.bss : ALIGN(4) {
		PROVIDE(_bss_start = .);
		*(.sbss .sbss.*) *(.bss .bss.*)
		PROVIDE(_bss_end = .);
	} >ram AT>ram :bss

	.stack (NOLOAD) : ALIGN(16) {
        PROVIDE(_stack_begin = .);
        . += __stack_size;
        PROVIDE( _sp = . );
        PROVIDE(_stack_end = .);
    } >ram :ram

	PROVIDE(_memory_start = ORIGIN(ram));
	PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));
}