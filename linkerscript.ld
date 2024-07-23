/* stack starting address*/
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* Memories definition */
MEMORY
{
  FLASH (rx)     : ORIGIN = 0x8000000,   LENGTH = 512K
  RAM (xrw)      : ORIGIN = 0x20000000,   LENGTH = 128K
}

