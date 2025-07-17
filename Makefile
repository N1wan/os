
.PHONY: clean qemu

BINPATH=/usr/bin

CC = $(BINPATH)/gcc
AS = $(BINPATH)/as
LD = $(BINPATH)/ld

all: out/bootloader # out/kernel

qemu: all
	qemu-system-x86_64 -machine q35 -fda out/disk.img

qemu-gdb: all
	qemu-system-x86_64 -machine q35 -fda out/disk.img -gdb tcp::26000 -S

out/bootloader: out/bootloader.o src/bootloader/link_boot.ld | out/disk.img
	$(LD) -nostdlib -T src/bootloader/link_boot.ld -o $@ out/bootloader.o
	dd if=out/bootloader of=out/disk.img conv=notrunc

# out/kernel: out/kernel.o src/kernel/link_kernel.ld | out/disk.img
# 	$(LD) -nostdlib -T src/kernel/link_kernel.ld -o $@ out/kernel.o
# 	dd if=out/kernel of=out/disk.img bs=512 seek=17 conv=notrunc

out/bootloader.o: src/bootloader/*.s | out
	$(AS) src/bootloader/*.s -o $@

# out/kernel.o: src/kernel/*.s | out
# 	$(AS) src/kernel/*.s -o $@

out/disk.img: out
	dd if=/dev/zero of=$@ bs=512 count=2880

out:
	mkdir -p out

clean:
	rm -rf out
