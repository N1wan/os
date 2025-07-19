
.PHONY: clean qemu

BINPATH=/usr/bin
SRC_DIR=src
BUILD_DIR=out
HD_IMG=disk.img

CC = $(BINPATH)/gcc
AS = $(BINPATH)/as
LD = $(BINPATH)/ld

CFLAGS=-ffreestanding -nostdlib -Wall -Wextra -g -O3

all: $(BUILD_DIR)/bootloader # $(BUILD_DIR)/kernel

qemu: all
	qemu-system-x86_64 -machine q35 -drive file=$(BUILD_DIR)/$(HD_IMG),format=raw

qemu-gdb: all
	qemu-system-x86_64 -machine q35 -drive file=$(BUILD_DIR)/$(HD_IMG),format=raw -gdb tcp::26000 -S

$(BUILD_DIR)/bootloader: $(BUILD_DIR)/bootloader.o $(SRC_DIR)/bootloader/link_boot.ld | $(BUILD_DIR)/$(HD_IMG)
	$(LD) -nostdlib -T $(SRC_DIR)/bootloader/link_boot.ld -o $@ $(BUILD_DIR)/bootloader.o
	dd if=$(BUILD_DIR)/bootloader of=$(BUILD_DIR)/$(HD_IMG) conv=notrunc

# $(BUILD_DIR)/kernel: $(BUILD_DIR)/kernel.o $(SRC_DIR)/kernel/link_kernel.ld | $(BUILD_DIR)/$(HD_IMG)
# 	$(LD) -nostdlib -T $(SRC_DIR)/kernel/link_kernel.ld -o $@ $(BUILD_DIR)/kernel.o
# 	dd if=$(BUILD_DIR)/kernel of=$(BUILD_DIR)/$(HD_IMG) bs=512 seek=17 conv=notrunc

$(BUILD_DIR)/bootloader.o: $(SRC_DIR)/bootloader/*.s | $(BUILD_DIR)
	$(AS) $(SRC_DIR)/bootloader/*.s -o $@

# $(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel/*.s | $(BUILD_DIR)
# 	$(AS) $(SRC_DIR)/kernel/*.s -o $@

$(BUILD_DIR)/$(HD_IMG): $(BUILD_DIR)
	dd if=/dev/zero of=$@ bs=512 count=2880

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
