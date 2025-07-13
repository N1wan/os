
.PHONY: clean qemu

BINPATH=/usr/bin

CC = $(BINPATH)/gcc
AS = $(BINPATH)/as
LD = $(BINPATH)/ld

# start VM (without debugger)
# qemu-system-x86_64 -machine q35 -fda out/disk.img
# start VM (with debugger)
# qemu-system-x86_64 -machine q35 -fda out/disk.img -gdb tcp::26000 -S
qemu: all
	qemu-system-x86_64 -machine q35 -fda out/disk.img

all: out/bootloader # out/kernel

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

# to run the debugger, do this
# make sure in make qemu the line with debugger is used
# first run:
#     gdb
# then in gdb run:
#     set architecture i386:x86-64
#     target remote localhost:26000
#     layout asm
#     layout reg
# optionally:
#     b *0x7c00
#     c
