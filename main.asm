.psp

.relativeinclude on

.include "colors.asm"
.include "macros.asm"
.include "gu_api.asm"

.createfile "note_hh.bin", 0x8802140

.word   0x08802148
.word   end - init | 0x80000000

init:
    la      a0, main
    j       add_hook
    nop

main:
    addiu   sp, sp, -4
    sw      ra, 0x0(sp)

    ; Validaciones básicas
    li          a0, GAME_TASK;COMPRUEBA GAME_TASK
    lw          a0, 0x0(a0)
    li          a1, 0x656D6167
    bne         a0, a1, @ret
	nop

    li          a0, MISSION_STATUS ;COMPRUEBA LA MISIÓN SE COMPLIO
    lb          a0, 0x0(a0)
    slti        at, a0, 0x3
    beq         at, zero, @final_mision
	nop
    
    li          a0, LOADING_SCREEN;COMPRUEBA PANTALLA DE CARGA
    lb          a0, 0x0(a0)
    bne         a0, zero, @ret
	nop

    la      	a0, compat_flag ;Comprobar si ya calculamos
    lb      	a0, 0x0(a0)
    bnez    	a0, ya_calculado
    nop

    ;Revisa si el arma que tiene cornamusa
    li      	t0, TYPE_WPM      ; dirección donde está el tipo de arma
    lb      	t2, 0x0(t0)
    li      	t3, 0x11
    bne     	t2, t3, @ret ; si no es una HH, va a @ret
    nop
	
	la			t1, buffer_resultados
	li			t2, 0x30
	li			t3, 0x0

clear_loop:
	sb			t3, 0(t1)
	addiu		t1, t1, 1
	addiu		t2, t2, -1
	bgtz		t2, clear_loop
	nop

    lh      	t4, 0x1(t0) ; id de la cornamusa, 0x09B49236

    li      	t5, ID_NOTE      ; base id notas
    sll    		t6, t4, 0x5
    sll     	t7, t4, 0x2
    subu    	t4, t6, t7          ; t4 = index * 28
    addu    	t4, t4, t5          ; t4 = base + offset
	lb			t4, 0x13(t4)

    ; lee las 3 o 4 notas del arma
	li			t5, NOTES
	sll			t6, t4, 0x1
	addu    	t4, t4, t6
	addu		t4,	t4, t5
	
	lb			a0, -0x1(t4)
	sb			a0, nota4	
    
	lb      	a1, 0x0(t4)         ; nota1
    lb      	a2, 0x1(t4)         ; nota2
    lb      	a3, 0x2(t4)         ; nota3

    ; loop canciones
    li      	t0, 0x0               ; index = 0  
    li      	t1, NOTE_LIST      ; base canciones
    la      	t2, buffer_resultados
    li      	t3, 0x0               ; contador resultados
    li      	t4, 0x4B           ; numero melodias (120). 

loop_canciones:
    ; direccion = base + index*4
    sll     	t5, t0, 0x2
    addu    	t6, t1, t5        ; t1 = dirección de la cancion actual
    move    	t7, t6			  ; t4 mantendrá inicio de la canción

    ; comprobar las 4 notas
    li      	t8, 0x0             ; contador notas leídas
    li      	t9, 0x1             ; flag compatible = 1

fourth_note:
	li          a0, NOTE_4;COMPRUEBA SI SON 4 NOTAS
    lb          a0, 0x0(a0)
    bne    		a0, 0x4, check_notas ; si no es 4, pasa a chequear 3 notas nada mas
	lb      	v0, 0x0(t7)
	
    li          a0, nota4
    lb          a0, 0x0(a0)         ; leer nota actual
	beq     	v0, a0, nota_ok
    nop
	
check_notas:
    
    beq     	v0, zero, nota_ok
    nop
	beq     	v0, a1, nota_ok
    nop
    beq     	v0, a2, nota_ok
    nop
    beq     	v0, a3, nota_ok
    nop

    ; ninguna coincidió -> no compatible
    li      	t9, 0x0
    j       	next_song
    nop

nota_ok:
    addiu   	t7, t7, 1         ; siguiente byte nota
    addiu   	t8, t8, 1
	blt     	t8, 0x4, fourth_note
    nop

next_song:
    beqz    	t9, cont_loop     ; si no compatible saltar incremento index
    nop

    ; Si compatible -> copiar las 4 notas al buffer destino
    sll     	v1, t3, 2         ; offset = contador * 4
    addu    	v1, t2, v1        ; t1 es el destino escritura

    
    lb      	v0, 0x0(t6)
    sb      	v0, 0x0(v1)
    lb      	v0, 0x1(t6)
    sb      	v0, 0x1(v1)
    lb      	v0, 0x2(t6)
    sb      	v0, 0x2(v1)
    lb      	v0, 0x3(t6)
    sb      	v0, 0x3(v1)

    addiu   	t3, t3, 0x1         ; contador resultados++

cont_loop:
    addiu   	t0, t0, 0x1
	blt    		t0, t4, loop_canciones
    nop

    la      	t5, compat_flag
    li      	t6, 0x1
    sb      	t6, 0x0(t5)

ya_calculado:
    ; cargar cuántas melodías compatibles hay
    li      t9, 0xc                 ; t9 = 12 melodias, normalmente basta con 6

   ; preparaciones y constantes
    la      t3, buffer_resultados   ; t3 = base del buffer 
    li      t6, 0                   ; t6 = index (i)

loop_print_melodia:
	slt		a0, t6, t9
    beqz    a0, @ret            ; si index == 12 -> @ref
    nop

    ; addres = buffer + index * 4
    sll     t7, t6, 2               ; t7 = index * 4
    addu    t7, t3, t7              ; t7 = direccion inicio melodía
	
	li      t8, 0x0

loop_notas_print:
	slti	a0, t8, 0x4
    beqz    a0, siguiente_melodia ; si es 0 pasa a la siguiente
    nop
	
	addu    a0, t8, t7 
    lb      a0, 0x0(a0)                ; a0 = nota actual
	beqz    a0, saltar_nota ; si es 0 pasa a la siguiente
    nop
	
	j	bl_print
	nop

colort:
	slti	a0, t8, 0x4
    ; addr = addr + i
    addu    a0, t8, t7 
    lb      a0, 0x0(a0)                ; a0 = nota actual
	
    ; seleccionar color en t1_color_reg (usamos t8 para temporal, t1 para color)
    li      t1, TEXT_WHITE

    beq     a0, 2, col_purple
    nop
    beq     a0, 3, col_red
    nop
    beq     a0, 4, col_blue
    nop
    beq     a0, 5, col_green
    nop
    beq     a0, 6, col_yellow
    nop
    beq     a0, 7, col_sky
    nop
    beq     a0, 8, col_orange
    nop
    j       do_print
    nop

col_purple:
    li      t1, TEXT_PURPLE
    j       do_print
    nop
col_red:
    li      t1, TEXT_RED
    j       do_print
    nop
col_blue:
    li      t1, TEXT_BLUE
    j       do_print
    nop
col_green:
    li      t1, TEXT_GREEN
    j       do_print
    nop
col_yellow:
    li      t1, TEXT_YELLOW
    j       do_print
    nop
col_sky:
    li      t1, TEXT_SKY_BLUE
    j       do_print
    nop
col_orange:
    li      t1, TEXT_ORANGE
    j       do_print
    nop

bl_print:
	; preparar y llamar a print
    la      a0, format
    la      a1, sym_square
    la      a2, x ;= X ya calculada
	lh		a2, 0x0(a2)
    la      a3, Y ;= Y ya calculada
	lh		a3, 0x0(a3)
    li      t0, 14           ; tamaño
    jal     print
	li		t1, TEXT_BLACK
	
	j		colort
	nop

do_print:
    ; preparar y llamar a print
    la      a0, format
    la      a1, sym_square
    la      a2, x ;= X ya calculada
	lh		a2, 0x0(a2)
    la      a3, Y ;= Y ya calculada
	lh		a3, 0x0(a3)
    li      t0, 13           ; tamaño
    jal     print
    nop

saltar_nota:
    addiu   t8, t8, 1        ; j--
	la      a2, x ;= X ya calculada
	lh		a3, 0x0(a2)
	addiu   a3, a3, -0x9
	sh      a3, 0x0(a2)
    j       loop_notas_print
    nop

siguiente_melodia:
    addiu   t6, t6, 1         ; index++
	la      a2, X ;= X ya calculada
	lh		a3, 0x0(a2)
	addiu   a3, a3, 0x24
	sh      a3, 0x0(a2)
	
	la      a2, Y ;= y ya calculada
	lh		a3, 0x0(a2)
	addiu   a3, a3, 0x11
	sh      a3, 0x0(a2)
	
    j       loop_print_melodia
    nop
	
@final_mision:
	la      	t5, compat_flag
    li      	t6, 0x0
    sb      	t6, 0x0(t5)
	
@ret:
	la      a2, X ;= X ya calculada
	li		a3, 0xc5
	sh      a3, 0x0(a2)
	
	la      a2, Y ;= y ya calculada
	li		a3, 0x25
	sh      a3, 0x0(a2)
	
	lw      	ra, 0x0(sp)
    jr      	ra
    addiu   	sp, sp, 4

format:
    .asciiz "%s"
sym_square:
    .byte 0xE2,0x99,0xAA

; datos en memoria
.align 4
buffer_resultados:
    .byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	.byte 0x0,0x0,0x0,0x0
	
compat_flag:
    .byte   0x0
nota4:
    .byte   0x0
X:
    .byte   0x00, 0x65
Y:
    .byte   0x00, 0x30
	
end:
    .word -1
    .word 0

.close