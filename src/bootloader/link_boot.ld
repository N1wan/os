
/* output raw binary */
OUTPUT_FORMAT("binary", "binary", "binary")

SECTIONS {
    /* start at 0x7C00 which is where the bios will set the instruction pointer after POST */
    . = 0x7C00;
    .bootloader : {
        /* the code in this section will be the first code that is called */
        *(.bootstrap16.text);
        *(.bootstrap16.data);
        /* this is where the signature is set so that the BIOS will find the bootloader */
        . = 0x1fe;
        BYTE(0x55);
        BYTE(0xaa);
        /* this variable is set for the asserts a few lines down */
        _bootstrap_end = .;
        /* the rest of the sections will be put here */

        /* this variable is set for the asserts a few lines down */
        _bootloader_end = .;
    }

    . = ASSERT(_bootstrap_end <= 0x7E00,"Bootstrap section too big! (>510 bytes)");
    . = ASSERT(_bootloader_end <= 0x9FFF,"Bootloader section too big! (>8.5 kilobytes)");
    . = ASSERT(_bootloader_end <= 0x8600,"Load more boot pages from disk (and then change this error)");

    /DISCARD/ : {
        *(.comment)
        *(.debug_*)
        *(.eh_frame)
        *(.eh_frame_hdr)
        *(.indent)
        *(.note*)
        *(.stab)
        *(.stabstr)
    }
}
