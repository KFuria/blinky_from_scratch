# Makefile for STM32F446

######################################
SRC_DIR = src
INC_DIR = inc

TARGET = blinky


######################################
# Device setup

FP_FLAGS	?= -mfloat-abi=hard -mfpu=fpv4-sp-d16
ARCH_FLAGS	= -mthumb -mcpu=cortex-m4


######################################
# Linkerscript

LD_SCRIPT 	= linkerscript.ld


######################################
# Includes

DEPS 	+= -I./
DEPS 	+= -I$(INC_DIR)


######################################
# Executables and TOOLCHAIN setup

PREFIX	?= arm-none-eabi-

CC			:= $(PREFIX)gcc
CXX			:= $(PREFIX)g++
LD			:= $(PREFIX)gcc
AR			:= $(PREFIX)ar
AS			:= $(PREFIX)as
OBJCOPY		:= $(PREFIX)objcopy
OBJDUMP		:= $(PREFIX)objdump
GDB			:= $(PREFIX)gdb
OS 			:= $(PREFIX)size

OPT 		:= -O0
DEBUG		:= -ggdb3
CSTD		?= -std=c99

######################################
 # Source Files

AS_SRC 		+= $(SRC_DIR)/startup.s
C_SRC		+= $(SRC_DIR)/main.c

OBJS 		+= $(AS_SRC:.s=.o)
OBJS 		+= $(C_SRC:.c=.o)  

#####################################
# Assembly Flags

ASFLAGS 	+= $(OPT) $(CSTD) $(DEBUG)
ASFLAGS 	+= $(ARCH_FLAGS)
ASFLAGS 	+= -Wall -Wextra -Wshadow -Wimplicit-function-declaration
ASFLAGS 	+= -fmessage-length=0 -fno-common -ffunction-sections -fdata-sections


####################################
# C Flags

CFLAGS		+= $(OPT) $(CSTD) $(DEBUG)
CFLAGS		+= $(ARCH_FLAGS)
CFLAGS		+= -Wall -Wextra -Wshadow -Wimplicit-function-declaration
CFLAGS		+= -fmessage-length=0 -fno-common -ffunction-sections -fdata-sections
CFLAGS		+= $(DEPS)


###################################
# Linker Flags

LFLAGS		+= -T./$(LD_SCRIPT)
LFLAGS		+= $(ARCH_FLAGS) $(DEBUG)
LFLAGS		+= -Wl,-Map=$(*).map
LFLAGS		+= --static -nostartfiles --specs=nosys.specs -nostdlib -lgcc -Wall
LFLAGS		+= -Wl,--gc-sections

###################################

.SUFFIXES: .elf .bin .hex .srec .list .map .images
.SECONDEXPANSION:
.SECONDARY:

all: elf images bin

elf: $(TARGET).elf
bin: $(TARGET).bin
hex: $(TARGET).hex
srec: $(TARGET).srec
list: $(TARGET).list
GENERATED_BINARIES=$(TARGET).elf $(TARGET).bin $(TARGET).hex $(TARGET).srec $(TARGET).list $(TARGET).map

images: $(TARGET).images

print-%:
	@echo $*=$($*)

%.images: %.elf %.hex %.srec %.list %.map
	@printf "*** $* images generated ***\n"

%.bin: %.elf
	@printf "  OBJCOPY $(*).bin\n"
	@$(OBJCOPY) -Obinary $(*).elf $(*).bin
	@$(OS) $<

%.hex: %.elf
	@printf "  OBJCOPY $(*).hex\n"
	@$(OBJCOPY) -Oihex $(*).elf $(*).hex

%.srec: %.elf
	@printf "  OBJCOPY $(*).srec\n"
	@$(OBJCOPY) -Osrec $(*).elf $(*).srec

%.list: %.elf
	@printf "  OBJDUMP $(*).list\n"
	@$(OBJDUMP) -S $(*).elf > $(*).list

%.elf %.map: $(OBJS) $(LDSCRIPT) makefile
	@printf "  LD      $(*).elf\n"
	@$(LD) $(LFLAGS) $(OBJS) -o $(*).elf

%.o: %.c
	@printf "  CC      $(*).c\n"
	@$(CC) $(CFLAGS) -o $(*).o -c $(*).c

%.o: %.s
	@printf "  CC      $(*).s\n"
	@$(CC) $(ASFLAGS) -o $(*).o -c $(*).s

clean:
	@printf "  CLEAN\n"
	$(RM) $(GENERATED_BINARIES) generated.* $(OBJS) $(OBJS:%.o=%.d)


.PHONY: images clean elf bin hex srec list

-include $(OBJS:.o=.d)
