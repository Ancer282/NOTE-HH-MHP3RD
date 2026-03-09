; Text Colors
TEXT_WHITE equ 0
TEXT_BLACK equ 1
TEXT_RED equ 2
TEXT_GREEN equ 3
TEXT_CYAN equ 4
TEXT_YELLOW equ 5
TEXT_ORANGE equ 6
TEXT_FUCHSIA equ 7
TEXT_BURGUNDY equ 8
TEXT_GREY equ 9
TEXT_DARK_GREY equ 10
TEXT_GOLD equ 11
TEXT_BROWN equ 12
TEXT_CRIMSON equ 13
TEXT_SKY_BLUE equ 14
TEXT_PINK equ 15
TEXT_PURPLE equ 16
TEXT_BLUE equ 17
TEXT_BRIGHT_YELLOW equ 18
TEXT_BRIHGT_RED equ 19
TEXT_BRIGHT_GREEN equ 20
TEXT_BRIGHT_ORANGE equ 21

; Vertex Colors (RGB565)

.macro loadcolor, dest, red, green, blue
    li      dest, red/(255/31) | green/(255/63) << 5 | blue/(255/31) << 11
.endmacro

.macro defcolor, name, red, green, blue
    .definelabel name, red/(255/31) | green/(255/63) << 5 | blue/(255/31) << 11
.endmacro

.sym off

defcolor VERTEX_RED, 255, 0, 0
defcolor VERTEX_GREEN, 0, 255, 0
defcolor VERTEX_BLUE, 0, 0, 255
defcolor VERTEX_YELLOW, 255, 255, 0
defcolor VERTEX_PURPLE, 255, 0, 255
defcolor VERTEX_CYAN, 0, 255, 255
defcolor VERTEX_WHITE, 255, 255, 255
defcolor VERTEX_BLACK, 0, 0, 0
defcolor VERTEX_GREY, 127, 127, 127

.sym on
