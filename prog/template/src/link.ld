OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
    . = 0x80000000;
    .text : { *(.text) }
    .text.startup : { *(.text.startup) }
    . = ALIGN(0x1000);
    _end = .;
}
