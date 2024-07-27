PROJECT?=main

SRCDIRECTORY=src
PREFIX = arm-none-eabi

LIBOPENCM3_PATH := ./deps/libopencm3
BUILD_DIR ?= build


SOURCE_FILES := $(wildcard $(SRCDIRECTORY)/*.c)
OBJFILES = $(patsubst $(SRCDIRECTORY)/%.c, $(BUILD_DIR)/%.o, $(SOURCE_FILES))
GENRATED_FILES += $(OBJFILES) $(patsubst $(BUILD_DIR)/%.o, $(BUILD_DIR)/%.d, $(OBJFILES)) $(SEGGER_SYSVIEW_OBJS)

# FREERTOS stuff
FREERTOS_PATH := ./deps/FreeRTOS/FreeRTOS-Kernel/Source
FREERTOS_PORT_PATH := $(FREERTOS_PATH)/portable/GCC/ARM_CM4F
FREERTOS_SOURCES :=  $(FREERTOS_PATH)/tasks.c \
					$(FREERTOS_PATH)/queue.c \
					$(FREERTOS_PATH)/list.c \
					$(FREERTOS_PATH)/timers.c \
					$(FREERTOS_PATH)/event_groups.c \
					$(FREERTOS_PATH)/portable/MemMang/heap_4.c \
					$(FREERTOS_PORT_PATH)/port.c

FREERTOS_OBJS :=  $(BUILD_DIR)/tasks.o \
					$(BUILD_DIR)/queue.o \
					$(BUILD_DIR)/list.o \
					$(BUILD_DIR)/timers.o \
					$(BUILD_DIR)/event_groups.o \
					$(BUILD_DIR)/heap_4.o \
					$(BUILD_DIR)/port.o
					

FREERTOS_INCLUDE := -I$(FREERTOS_PATH)/include -I$(FREERTOS_PORT_PATH) -I./config

SEGGER_SYSVIEW_DIR = ./deps/SEGGER/SystemView
SEGGER_SYSVIEW_SRCS = $(wildcard $(SEGGER_SYSVIEW_DIR)/SEGGER/*.c)
SEGGER_SYSVIEW_SRCS += $(wildcard $(SEGGER_SYSVIEW_DIR)/Sample/FreeRTOS/*.c)
SEGGER_SYSVIEW_SRCS += $(wildcard $(SEGGER_SYSVIEW_DIR)/Sample/FreeRTOS/Config/*.c)

SEGGER_SYSVIEW_OBJS = $(patsubst %.c, $(BUILD_DIR)/%.o, $(notdir $(SEGGER_SYSVIEW_SRCS)))


SEGGER_SYSVIEW_INCLUDES = -I$(SEGGER_SYSVIEW_DIR)/Config -I$(SEGGER_SYSVIEW_DIR)/SEGGER -I$(SEGGER_SYSVIEW_DIR)/Sample/FreeRTOS #-I$(SEGGER_SYSVIEW_DIR)/Custom

SEGGER_RTT_DIR = ./deps/RTT
SEGGER_RTT_SRCS = $(wildcard $(SEGGER_RTT_DIR)/*.c)
SEGGER_RTT_OBJS = $(patsubst $(SEGGER_RTT_DIR)/%.c, $(BUILD_DIR)/%.o, $(SEGGER_RTT_SRCS))
SEGGER_RTT_INCLUDE = -I$(SEGGER_RTT_DIR)


all: $(BUILD_DIR)/$(PROJECT).elf


freertos_objs: $(FREERTOS_SOURCES)
	$(PREFIX)-gcc -Os -ggdb3 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
	-fno-common -ffunction-sections -fdata-sections -Wextra -Wshadow -Wno-unused-variable \
	-Wimplicit-function-declaration -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes \
	-MD -Wall -Wundef $(FREERTOS_INCLUDE) -c $(FREERTOS_SOURCES) $(SEGGER_SYSVIEW_INCLUDES) $(SEGGER_RTT_INCLUDE)
	mv *.o *.d $(BUILD_DIR)



# building all the object files
$(BUILD_DIR)/%.o: $(SRCDIRECTORY)/%.c 
	$(PREFIX)-gcc -Os -ggdb3 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
	-fno-common -ffunction-sections -fdata-sections -Wextra -Wshadow -Wno-unused-variable \
	-Wimplicit-function-declaration -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes \
	-MD -Wall -Wundef -I$(LIBOPENCM3_PATH)/include $(FREERTOS_INCLUDE) $(SEGGER_SYSVIEW_INCLUDES) $(SEGGER_RTT_INCLUDE) -DSTM32F4 -DSTM32F446RE -o $@ -c $<

# building segger system view stuff
$(BUILD_DIR)/%.o: $(SEGGER_SYSVIEW_DIR)/SEGGER/%.c
	$(PREFIX)-gcc -Os -ggdb3 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
	-fno-common -ffunction-sections -fdata-sections -Wextra -Wshadow -Wno-unused-variable \
	-Wimplicit-function-declaration -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes \
	-MD -Wall -Wundef -I$(LIBOPENCM3_PATH)/include $(FREERTOS_INCLUDE) $(SEGGER_SYSVIEW_INCLUDES) $(SEGGER_RTT_INCLUDE) -DSTM32F4 -DSTM32F446RE -o $@ -c $<

$(BUILD_DIR)/%.o: $(SEGGER_SYSVIEW_DIR)/Sample/FreeRTOS/%.c
	$(PREFIX)-gcc -Os -ggdb3 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
	-fno-common -ffunction-sections -fdata-sections -Wextra -Wshadow -Wno-unused-variable \
	-Wimplicit-function-declaration -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes \
	-MD -Wall -Wundef -I$(LIBOPENCM3_PATH)/include $(FREERTOS_INCLUDE) $(SEGGER_SYSVIEW_INCLUDES) $(SEGGER_RTT_INCLUDE) -DSTM32F4 -DSTM32F446RE -o $@ -c $<

$(BUILD_DIR)/%.o: $(SEGGER_SYSVIEW_DIR)/Sample/FreeRTOS/Config/%.c
	$(PREFIX)-gcc -Os -ggdb3 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
	-fno-common -ffunction-sections -fdata-sections -Wextra -Wshadow -Wno-unused-variable \
	-Wimplicit-function-declaration -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes \
	-MD -Wall -Wundef -I$(LIBOPENCM3_PATH)/include $(FREERTOS_INCLUDE) $(SEGGER_SYSVIEW_INCLUDES) $(SEGGER_RTT_INCLUDE) -DSTM32F4 -DSTM32F446RE -o $@ -c $<

./build/SEGGER_RTT_ASM_ARMv7M.S.o: $(SEGGER_SYSVIEW_DIR)/SEGGER/SEGGER_RTT_ASM_ARMv7M.S
	$(PREFIX)-gcc -Os -ggdb3 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
	-fno-common -ffunction-sections -fdata-sections -Wextra -Wshadow -Wno-unused-variable \
	-Wimplicit-function-declaration -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes \
	-MD -Wall -Wundef -I$(LIBOPENCM3_PATH)/include $(FREERTOS_INCLUDE) $(SEGGER_SYSVIEW_INCLUDES) $(SEGGER_RTT_INCLUDE) -DSTM32F4 -DSTM32F446RE -o $@ -c $<

# building segger rtt stuff
$(BUILD_DIR)/%.o: $(SEGGER_RTT_DIR)/%.c
	$(PREFIX)-gcc -Os -ggdb3 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
	-fno-common -ffunction-sections -fdata-sections -Wextra -Wshadow -Wno-unused-variable \
	-Wimplicit-function-declaration -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes \
	-MD -Wall -Wundef -I$(LIBOPENCM3_PATH)/include $(FREERTOS_INCLUDE) $(SEGGER_SYSVIEW_INCLUDES) $(SEGGER_RTT_INCLUDE) -DSTM32F4 -DSTM32F446RE -o $@ -c $<


# linking with libopencm3
$(BUILD_DIR)/$(PROJECT).elf: $(OBJFILES) freertos_objs $(SEGGER_SYSVIEW_OBJS) ./build/SEGGER_RTT_ASM_ARMv7M.S.o
	$(PREFIX)-gcc -Tstm32f446re.ld -L$(LIBOPENCM3_PATH)/lib -nostartfiles -mcpu=cortex-m4 \
	-mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -specs=nano.specs -Wl,--gc-sections -Wl,--cref \
	-Wl,-Map=$(BUILD_DIR)/$(PROJECT).map -L../libopencm3/lib $(FREERTOS_OBJS) $(OBJFILES) $(SEGGER_SYSVIEW_OBJS) $(SEGGER_RTT_OBJS) ./build/SEGGER_RTT_ASM_ARMv7M.S.o \
	-lopencm3_stm32f4 -Wl,--start-group \
	-lc -lgcc -lnosys -Wl,--end-group -o $@
	$(PREFIX)-objcopy -Obinary $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)/$(PROJECT).bin

GENRATED_FILES += $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)/$(PROJECT).map $(FREERTOS_OBJS) $(patsubst $(BUILD_DIR)/%.o, $(BUILD_DIR)/%.d, $(FREERTOS_OBJS)) $(SEGGER_SYSVIEW_OBJS) $(SEGGER_RTT_OBJS) $(BUILD_DIR)/$(PROJECT).bin

test:
	@echo $(GENRATED_FILES)

clean:
	rm -f $(GENRATED_FILES)
	rm -f $(BUILD_DIR)/*.d