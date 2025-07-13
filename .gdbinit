set architecture i386:x86-64
target remote localhost:26000
layout asm
layout reg
b *0x7c00
c
