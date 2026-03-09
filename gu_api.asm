add_hook equ 0x880388c
; a0: address
remove_hook equ 0x8803860
; a0: address
draw_rect equ 0x88034f4
; a0: x1, a1: y1, a2: x2, a3: y2, t0: color
draw_rect_b equ 0x88034e8
; a0: x1, a1: y1, a2: width, a3: height, t0: color
draw_tri equ 0x88035b4
; a0: x1, a1: y1, a2: x2, a3: y2, t0: x3, t1: y3, t2: color
print equ 0x8803684
; a0: format, a1: value / ptr to str, a2: x, a3: y, t0: size, t1: color
sp_print equ 0x88036b8
; unimplemented
draw_sprite equ 0x88036b8
; a0: x1, a1: y1, a2: x2, a3: y2, t0: u1, t1: v1, t2: u2, t3: v2
draw_pixel_sprite equ 0x88036d4
; a0: x1, a1: y1, a2: x2, a3: y2, t0: u1, t1: v1, t2: u2, t3: v2
load_texture equ 0x8803450
; a0: tex address