/* Label for the program's entry point */
ENTRY(Reset_Handler)

/* stack starting address*/
_estack = ORIGIN(RAM) + LENGTH(RAM);

_Min_Heap_Size = 0x200; /* required amount of heap */
_Min_Stack_Size = 0x400; /* required amount of stack */

/* Memories definitions specific to CORTEX-M4*/
MEMORY
{
  FLASH (rx)     : ORIGIN = 0x8000000,   LENGTH = 512K
  RAM (xrw)      : ORIGIN = 0x20000000,   LENGTH = 128K
}


/* The linker takes a set of input files (object files) containing the 
"input sections" such as ".text" and ".rodata" and uses 
this to map them to "output sections" which are placed 
in the output ELF file. 

A compiler will split a C program into different memory 'sections'
Typical sections are
1. text: contains the main program
2. data: contains initialized global and static variables
    a. rodata: (read-only data) contains static constants
3. bss: uninitialized global and static variables 
4. heap: contains dynamically allocated memory and grows to larger address
5. stack: contains the call stack, located at the top of memory and grows to smaller address
*/


SECTIONS
{
  /* FLASH  */
  .vector_table :
  {
    . = ALIGN(4); 
    KEEP (*(.vector_table)) /*place .vector_table section from input files here */
    . = ALIGN(4);
  } >FLASH

  /* The 'text' section contains the main program code. */
  .text :
  {
    . = ALIGN(4); 
    *(.text)       /*place all .text section from input files here */
    *(.text*)      /*place all .text* sections from input files (* is wildcard) */
    . = ALIGN(4);
  } >FLASH

  /* The 'rodata' goes in FLASH since it is read-only data. */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)
    *(.rodata*)
    . = ALIGN(4);
  } >FLASH


  /* RAM */

  /* RAM is volatile memory, hence loses contents at power loss. 
  The .data section is required by our program everytime the MCU is powered on. 
  so we tell the linker to make all references to .data as though it is stored in RAM, 
  BUT
  instead store the real content/values in FLASH, and just reserve space in RAM
  
  This is what AT directive does.
  Checkout https://sourceware.org/binutils/docs/ld/Output-Section-LMA.html#Output-Section-LMA
  */
  _sidata = LOADADDR(.data); /*start address for the initialization values of the .data section */
  .data : 
  {
    . = ALIGN(4);
    _sdata = .;   /* start location of .data section */
    *(.data)
    *(.data*)
    _edata = .;   /* end location of .data section */
    . = ALIGN(4);
  } >RAM AT> FLASH

  . = ALIGN(4);
  .bss :
  {
    . = ALIGN(4);
    _sbss = .;    /* start location of .bss section */
    *(.bss)
    *(.bss*)
    *(COMMON)     /* COMMON section goes in bss */
    . = ALIGN(4);
    _ebss = .;    /* end location of .bss section */
  } >RAM

  /* Rest of the space is left for heap/stack. */
  /* linker will generate an error if there isn't enough space for a section*/
  ._user_heap_stack :
  {
    . = ALIGN(4);
    _ssystem_ram = .;
    . = . + _Min_Heap_Size; /* making sure that there is enough space for heap and stack */
    . = . + _Min_Stack_Size;
    . = ALIGN(4);
    _esystem_ram = .;
  } >RAM
}