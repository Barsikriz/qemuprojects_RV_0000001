# Префикс инструментов для RISC-V 32-bit bare metal
CROSS_COMPILE ?= riscv32-unknown-elf-

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy

# Флаги компиляции
CFLAGS = -march=rv32ima -mabi=ilp32 -nostdlib -ffreestanding \
         -Wall -Wextra -O0 -g -Iinclude

# Флаги ассемблера (препроцессор C используется для .S)
ASFLAGS = -march=rv32ima -mabi=ilp32 -Iinclude

LDFLAGS = -T ../ld/link.ld

SRC_DIR = src
BUILD_DIR = build

# Исходники
C_SRCS = $(wildcard $(SRC_DIR)/*.c)
A_SRCS = $(wildcard $(SRC_DIR)/*.S)
C_OBJS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRCS))
A_OBJS = $(patsubst $(SRC_DIR)/%.S, $(BUILD_DIR)/%.o, $(A_SRCS))
OBJS = $(C_OBJS) $(A_OBJS)

# Цели
all: $(BUILD_DIR)/kernel.elf

# Компоновка ELF
$(BUILD_DIR)/kernel.elf: $(OBJS) $(LD_SCRIPT)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) -Map $(BUILD_DIR)/kernel.map

# Сборка C файлов
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Сборка ассемблерных файлов (.S)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	@mkdir -p $(BUILD_DIR)
	$(CC) $(ASFLAGS) -c $< -o $@

# Запуск в QEMU (без графики, -nographic)
run: $(BUILD_DIR)/kernel.elf
	qemu-system-riscv32 -M virt -cpu rv32 -nographic -bios none -kernel $(BUILD_DIR)/kernel.elf

# Очистка
clean:
	rm -rf $(BUILD_DIR)
