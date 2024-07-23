TARGET = main

LD_SCRIPT = linkerscript.ld
AS_SRC += ./core.S

MCU_SPEC = cortex-m4

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy
OD = arm-none-eabi-objdump
OS = arm-none-eabi-size

# Assembly directives.
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall
# (Set error messages to appear on a single line.)
ASFLAGS += -fmessage-length=0

# Linker directives.
LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += --specs=nosys.specs
LFLAGS += -nostdlib
LFLAGS += -lgcc
#LFLAGS += -nostartfiles
#LFLAGS += -static
LFLAGS += -T$(LSCRIPT)

OBJS =  $(AS_SRC:.S=.o)

.PHONY: all
all: $(TARGET).elf

%.o: %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf