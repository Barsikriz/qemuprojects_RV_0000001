OUTPUT_ARCH("riscv")

ENTRY(_start)

MEMORY
{
  ram(rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
  .text : {
    *(.text.init)
    *(.text*)
    *(.rodata*)
} > ram
  .data : {
    *(.data*)
} > ram
.bss : {
  _bss_start = .;
  *(.bss*)
  *(COMMON)
  _bss_end = .;
} > ram
_stack_top = ORIGIN(ram) + 0x10000;
_end = .;
}

