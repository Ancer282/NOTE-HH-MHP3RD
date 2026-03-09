.macro lib, dest, address
    .if (address & 0xFFFF) > 0xFFFF/2
        lui     at, address / 0x10000 + 0x1
    .else
        lui     at, address / 0x10000
    .endif
        lb      dest, address & 0xFFFF(at)
.endmacro

.macro sib, source, address
    .if (address & 0xFFFF) > 0xFFFF/2
        lui     at, address / 0x10000 + 0x1
    .else
        lui     at, address / 0x10000
    .endif
        sb      source, address & 0xFFFF(at)
.endmacro

.macro liw, dest, address
    .if (address & 0xFFFF) > 0xFFFF/2
        lui     at, address / 0x10000 + 0x1
    .else
        lui     at, address / 0x10000
    .endif
        lw      dest, address & 0xFFFF(at)
.endmacro

.macro siw, source, address
    .if (address & 0xFFFF) > 0xFFFF/2
        lui     at, address / 0x10000 + 0x1
    .else
        lui     at, address / 0x10000
    .endif
        sw      source, address & 0xFFFF(at)
.endmacro 