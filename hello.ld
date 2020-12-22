OUTPUT_ARCH( "riscv" )
OUTPUT_FORMAT("elf64-littleriscv")
ENTRY( _start )
SECTIONS
{
  /* RAM_START defaults to beginning of DRAM memory on `sifive_u` machine.
     Use "-Wl,--defsym,ROM_START=0x20400000 -Wl,--defsym,RAM_START=0x80000000" GCC command line arguments
     to specify different ROM and RAM address for other machines.
  */
  RAM_START = DEFINED(RAM_START) ? RAM_START : 0x80000000;

  /* text: code section.
     If ROM_START symbol is specified as command line argument, put code in the ROM.
  */
  . = DEFINED(ROM_START) ? ROM_START : RAM_START;
  .text : { *(.text) }
  /* gnu_build_id: optional read-only build identifier, must be located after the code section */
  .gnu_build_id : { *(.note.gnu.build-id) }
  /* rodata: read-only data segment */
  .rodata : { *(.rodata) }

  /* data: initialized read/write data segment, must be located in the RAM.
     If ROM_START was specified, then code is in ROM and we have to switch to RAM for the rest of the data.
  */
  . = DEFINED(ROM_START) ? RAM_START : .;
  .data : { *(.data) }
  .sdata : { *(.sdata) }
  .debug : { *(.debug) }
  . += DEFINED(STACK_SIZE) ? STACK_SIZE : 0x1000;
  stack_top = .;

  /* End of uninitalized data segement */
  _end = .;
}
