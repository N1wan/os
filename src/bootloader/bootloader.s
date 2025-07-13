# set .code16 so that the assembly is encoded for 16-bit real mode
.code16
.section .bootstrap16.text
.global _start

# *******************************************************************
# * this is the start of everything,                                *
# * the linker file makes sure that the .bootstrap16.text section   *
# * is located at 0x7c00 which is where the BIOS will go after POST *
# * (note that the BIOS will only recognize the storage device      *
# *  as bootable if the signature is found at the last two bytes    *
# *  of the first sector, the signature is 0x55, 0xAA.              *
# *  this is also done in the linker file)                          *
# *******************************************************************
_start:
	jmp boot

boot:
	cli        # clear interrupts
	cld        # clear direction flag
	hlt        # halt system
