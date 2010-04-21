;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Copyright 2010 Hugues Bruant. All rights reserved.
;;
;; <hugues.bruant@ensimag.imag.fr>
;;
;; This file is part of a school project and licensed under the terms of FreeBSD
;; license (2-clause BSD also refered to as Simplified BSD License)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; memory addresses
.equ	VGA_buff		0x0000

.equ	font_map		0x12C0

.equ	key_press_map	0x16C0
.equ	rand_seed		0x16C8

.equ	paper_score		0x16C9
.equ	paper_keys		0x16D0
.equ	paper_sprites	0x1720
.equ	paper_hud		0x1780
.equ	paper_tiles		0x1790
.equ	paper_dir		0x179C
.equ	paper_pos		0x179D
.equ	paper_speed		0x17A0
.equ	paper_title		0x17A4
.equ	paper_unit		0x17AA
.equ	paper_tilemap	0x17B0


.equ	IRQ_mask		0x2000
.equ	IRQ_sens		0x2001
.equ	IRQ_ack 		0x2002 ; Write : ack, Read : triggered
.equ	IRQ_stat		0x2003 ; instant status

.equ	PS2_rx		0x2004
.equ	PS2_tx		0x2005
.equ	PS2_stat		0x2006
.equ	PS2_ctrl		0x2007

.equ	TMR_ctrl		0x2008
.equ	TMR_base0		0x2009
.equ	TMR_base1		0x200A
.equ	TMR_base2		0x200B
.equ	TMR_cur0		0x200C
.equ	TMR_cur1		0x200D
.equ	TMR_cur2		0x200E
.equ	TMR_unused		0x200F

.equ	RS232_rx		0x2010
.equ	RS232_tx		0x2011
.equ	RS232_stat		0x2012
.equ	RS232_ctrl		0x2013

; interrupts mask identifiers
.equ	IRQ_tmr0		0x0001
.equ	IRQ_tmr1		0x0002
.equ	IRQ_tmr2		0x0004
.equ	IRQ_ps2in		0x0008
.equ	IRQ_ps2out		0x0010
.equ	IRQ_ps2err		0x0020


.org	0x0000
int_reset:
	; do some low level init here
	
	; reset stack pointer (grows downward from end of available RAM)
	liw	r7, IRQ_mask
	
	; continue init
	bai	-, os_init

.org	0x0010
int_isr:
	; handle interrupts here
	
	; in this context we are using a different register bank
	; so there is no need to manually save register values
	
	; check which interrupt(s) fired
	liw	r0, IRQ_ack
	lw	r1, r0
	
	; handle kbd interrupt
	bspl	r2, r1, 5
	bailne	r2, r6, int_error
	
	; handle kbd interrupt
	bspl	r2, r1, 3
	bailne	r2, r6, int_kbd
	
	; handle first timer interrupt
	bspl	r2, r1, 0
	bailne	r2, r6, int_tmr
	
	; acknowledge all interrupts
	;li	r1, -1
	sw	r1, r0
	
	; resume normal execution (and switch back register bank)
	reti

.org	0x0040
int_tmr:
	;simple visual test for timer
	not r7, r7
	out	r7
	
	ba	-, r6

.org	0x0050
int_error:
	; simple visual test for kbd error
	
	xor	r7, r7, r7
	out	r7
	
	ba	-, r6

.org	0x0060
int_kbd:
	; simple visual test for kbd
	; display scan code value on 7segments
	
	; r0, r1, r6 : reserved for IRQ dispatcher
	; r2 : last byte from PS2 peripheral
	; r3 : status = {0 | nothing, 1 | release, 2 | extended, 3 | both} 
	
	liw	r2, PS2_rx
	lw	r2, r2
	
	liw	r3, key_press_map + 8
	lw	r3, r3
	
	mixll	r7, r7, r2
; 	li	r4, 9
; 	sw	r7, r4
	
	li	r4, 0xF0
	sub	r4, r2, r4
	brieq	r4, int_kbd.release
	
	li	r4, 0xE0
	sub	r4, r2, r4
	brieq	r4, int_kbd.extended
	
int_kbd.process:
	
	; search keymap of the form :
	; scan code : bit position
	
	; add a wee bit of randomness into prng via entropy...
	liw	r5, rand_seed
	lw	r4, r5
	xor	r4, r4, r2
	sw	r4, r5
	
	liw	r5, paper_keys - 1
	bspl	r4, r3, 1
	brieq	r4, $+3
	liw	r5, paper_keys + 11 - 1
	
scan_code_loop:
	inc	r5, r5
	lw	r4, r5
	brieq	r4, scan_code_mismatch
	shr	r4, r4, 7
	sub	r4, r2, r4
	brine	r4, scan_code_loop
	
scan_code_match:
	lw	r2, r5
	
	bspl	r4, r3, 0
	
	; compute keybit offset
	shl	r3, r2, 7
	shr	r3, r3, 10
	
	; compute keybit mask
	li	r5, 1
	dec	r2, r2
	rrl	r2, r5, r2
	
	; compute keybit address
	liw	r5, key_press_map
	add	r5, r5, r3
	
	; updare keybit accordding to press/release
	lw	r3, r5
	
	brine	r4, scan_code_release
scan_code_press:
	or	r3, r3, r2
	bri	-, scan_code_notify
scan_code_release:
	not	r2, r2
	and	r3, r3, r2
	
scan_code_notify:
	sw	r3, r5
	
scan_code_mismatch:
	
	; clear status
	li	r3, 0
	liw	r4, key_press_map + 8
	sw	r3, r4
	ba	-, r6
	
int_kbd.extended:
	li	r4, 2
	or	r3, r3, r4
	liw	r4, key_press_map + 8
	sw	r3, r4
	ba	-, r6
	
int_kbd.release:
	li	r4, 1
	or	r3, r3, r4
	liw	r4, key_press_map + 8
	sw	r3, r4
	ba	-, r6


.org	0x0100
os_init:
	; higher level init here
	
	liw	r0, IRQ_mask	; r0 = 0x2000 : interrupt masking
	
	li	r1, 0x19		; unmask only first timer and PS2 input
	sw	r1, r0
	
	inc	r0, r0		; r0 = 0x2001 : interrupt sensibility
	
	li	r1, -1		; all interrupts sensible to rising edge
	sw	r1, r0
	
	li	r2, 7
	add	r0, r0, r2	; r0 = 0x2008 : timers control
	
	li	r2, 0x1D 	; enable first timer, loop, speed = 1MHz / 10**5 = 10Hz
	sw	r2, r0
	
	inc	r0, r0		; r0 = 0x2009 : first timer, base count
	
	li	r2, 15		; fire every 15 timer period (so every 1.5s in this case)
	sw	r2, r0
	
	inc	r0, r0		; r0 = 0x200A : second timer, frequency
	
	li	r2, 0x1B 	; enable second timer, loop, speed = 1MHz / 10**3 = 1kHz
	sw	r2, r0
	
	inc	r0, r0		; r0 = 0x200B : second timer, base count
	
	liw	r2, 817		; fire every 817 timer period
	sw	r2, r0
; 	
; 	inc	r0, r0		; r0 = 0x200C : third timer, frequency
; 	
; 	li	r2, 0x1D 	; enable second timer, loop, speed = 1MHz / 10**5 = 10Hz
; 	sw	r2, r0
; 	
; 	inc	r0, r0		; r0 = 0x200D : third timer, base count
; 	
; 	li	r2, 5		; fire every 5 timer period (so every 0.5s in this case)
; 	sw	r2, r0
	
	; clear kbd memory
	liw	r0, key_press_map
	li	r1, 0
	li	r2, 8
	
	sw	r1, r0
	inc	r0, r0
	dec	r2, r2
	brine	r2, $-3
	
start:
	; "userspace" starts here
	
	
;------------------------------------------------------------
; Paper Plane init
;------------------------------------------------------------
	
; no menu as of yet...
	bri	-, PaperGameStart
	
;------------------------------------------------------------
; paper plane menu
;------------------------------------------------------------
PaperMemu:
	
; paper plane menu loop
PaperMenuLoop:
	
	
	bri	-, PaperMenuLoop
	
	
;------------------------------------------------------------
; paper plane game
;------------------------------------------------------------
PaperGameStart:
	; init score
	liw	r0, paper_score
	li	r1, 0
	sw	r1, r0
	
	liw	r0, paper_dir
	
	; init direction
	li	r1, 0
	sw	r1, r0
	inc	r0, r0
	
	; init position
	liw	r1, 152 * 8
	sw	r1, r0
	inc	r0, r0
	
	li	r1, 0
	sw	r1, r0
	inc	r0, r0
	
	liw	r1, 128 * 8
	sw	r1, r0
	inc	r0, r0
	
	; init speed
	li	r1, 0
	sw	r1, r0
	inc	r0, r0
	
	li	r1, 13
	sw	r1, r0
	inc	r0, r0
	
	li	r1, 2
	sw	r1, r0
	inc	r0, r0
	
	; clear tilemap
	liw	r0, paper_tilemap
	li	r1, 0
	li	r2, 6*4
	
	sw	r1, r0
	inc	r0, r0
	dec	r2, r2
	brine	r2, $-3
	
	
; paper plane game loop

PaperGameRedraw:
	
	; draw HUD
	
	; top line of hud
	li	r0, 0
	li	r1, -1
	li	r2, 20
	
	sw	r1, r0
	inc	r0, r0
	dec	r2, r2
	brine	r2, $-3
	
	; clear hud area
	li	r1, 0
	liw	r2, 18*20
	
	sw	r1, r0
	inc	r0, r0
	dec	r2, r2
	brine	r2, $-3
	
	; bottom line of hud
	li	r1, -1
	li	r2, 20
	
	sw	r1, r0
	inc	r0, r0
	dec	r2, r2
	brine	r2, $-3
	
	; Title text
	li	r0, 4
	li	r1, 5
	liw	r2, paper_title
	bail	-, r6, puts
	
	; score
	li	r0, 18
	li	r1, 5
	liw	r2, paper_score
	lw	r2, r2
	bail	-, r6, printnum
	
	; forward arrow
	li	r0, 239
	li	r1, 1
	liw	r2, paper_hud
	li	r3, 8
	bail	-, r6, put_sprite_8
	
	; speed (itoa...)
	li	r0, 31
	li	r1, 1
	liw	r2, paper_speed
	lw	r2, r2
	bail	-, r6, printnum
	
	; "m/s"
	li	r0, 36
	li	r1, 1
	liw	r2, paper_unit
	bail	-, r6, puts 
	
	; up (or down) arrow
	li	r0, 239
	li	r1, 10
	liw	r2, paper_hud + 8
	li	r3, 8
	bail	-, r6, put_sprite_8
	
	; speed
	li	r0, 31
	li	r1, 10
	liw	r2, paper_speed + 1
	lw	r2, r2
	bail	-, r6, printnum
	
	; "m/s"
	li	r0, 36
	li	r1, 10
	liw	r2, paper_unit
	bail	-, r6, puts 
	
PaperGameRedrawContent:
	
	; clear content area (not hud)
	liw	r0, 20*20
	li	r1, 0
	liw	r2, 220*20
	
	sw	r1, r0
	inc	r0, r0
	dec	r2, r2
	brine	r2, $-3
	
	; draw game area : y in 24..240
	
	liw	r5, paper_tilemap
	
PaperGameTileLoop:
	lw	r4, r5
	inc	r5, r5
	
	brieq	r4, PaperGameTileSkip
	
	dec	r7, r7
	sw	r5, r7
	
	liw	r3, paper_tilemap
	sub	r3, r5, r3
	
	; compute coordinates
	shr	r0, r4, 7
	
	shr	r1, r3, 1
	shl	r1, r1, 4
	li	r2, 51
	add	r1, r1, r2
	
	liw	r2, paper_pos + 1
	lw	r2, r2
	shr	r2, r2, 2
	li	r3, 31
	and	r2, r2, r3
	
	sub	r1, r1, r2
	
	shl	r4, r4, 7
	shr	r4, r4, 7
	
	; draw left tile
	li	r3, 1
	bailne	r0, r6, put_tile
	
	; draw middle tiles
	brieq	r4, PaperGameSegmentSkip
	li	r3, 2
PaperGameSegmentLoop:
	bail	-, r6, put_tile
	dec	r4, r4
	brine	r4, PaperGameSegmentLoop
PaperGameSegmentSkip:
	
	; draw right tile
	li	r3, 0
	li	r4, 40
	sub	r4, r0, r4
	baillt	r4, r6, put_tile
	
	lw	r5, r7
	inc	r7, r7
	
PaperGameTileSkip:
	liw r4, paper_tilemap + 24
	sub	r4, r5, r4
	
	brilt	r4, PaperGameTileLoop
	
	; draw plane
	liw	r3, paper_speed
	lw	r3, r3
	li	r4, 0x1E0
	and	r4, r3, r4
	
	liw	r3, paper_pos
	lw	r0, r3
	shr	r0, r0, 2
	
	liw	r2, paper_sprites
	add	r2, r2, r4
	
	li	r1, 44
	li	r3, 16
	bail	-, r6, put_sprite_16_masked
	
	; collision check
	brine	r5, PaperGameFail
	
	; delay
	li	r0, 5
	
	li	r1, 0
	bri	-, $+1
	dec	r1, r1
	brine	r1, $-2
	dec	r0, r0
	brine	r0, $-5
	
PaperGameLoop:
	
; update position and velocity
	
	; move direction : less straight => bigger forward speed loss
	; speed up : decreases with gravity, decrease can be mitigated by steering up
	; or worsened by steering down. Positive up speed decreases forward speed, negative
	; up speed increases forward speed
	
	
	liw	r2, paper_pos
	liw	r3, paper_speed
	
	; update x coordinate (left/right)
	lw	r0, r2
	lw	r1, r3
	
	add	r0, r0, r1
	brilt	r0, PaperGameFail
	liw	r4, 304*8
	sub	r4, r0, r4
	brige	r4, PaperGameFail
	sw	r0, r2
	
	inc	r2, r2
	inc	r3, r3
	
	; update y coordinate (scroll...)
	lw	r0, r2
	lw	r1, r3
	li	r4, 0xFF
	shr	r1, r1, 1
	add	r0, r0, r1
	and	r1, r0, r4
	sw	r1, r2
	not	r4, r4
	and	r0, r0, r4
	
; 	; push r0
; 	dec	r7, r7
; 	sw	r0, r7
; 	
; 	inc	r2, r2
; 	inc	r3, r3
; 	
; 	; update z coordinate (unused as of yet...)
; 	lw	r0, r2
; 	lw	r1, r3
; 	add	r0, r0, r1
; 	sw	r0, r2
; 	
; 	; pop	r0
; 	lw	r0, r7
; 	inc	r7, r7
	
	; scroll tilemap on boundary...
	bailne	r0, r6, PaperMapScroll
	
PaperGameSkipScroll:
	
; check for keyboard action
	liw	r3, key_press_map
	lw	r3, r3
	baieq	r3, PaperGameRedraw
	
	; check for ESC
	bspl	r4, r3, 15
	brine	r4, PaperGameQuit
	
	; check for movement
	
	; UP
	bspl	r4, r3, 0
	brieq	r4, PaperNoMoveUp
	
PaperNoMoveUp:
	; DOWN
	bspl	r4, r3, 2
	brieq	r4, PaperNoMoveDOWN
	
PaperNoMoveDOWN:
	
	; LEFT
	bspl	r4, r3, 1
	brieq	r4, PaperNoMoveLEFT
	liw	r2, paper_speed
	lw	r0, r2
	li	r4, 5
	sub	r0, r0, r4
	sw	r0, r2
PaperNoMoveLEFT:
	; RIGHT
	bspl	r4, r3, 3
	brieq	r4, PaperNoMoveRIGHT
	liw	r2, paper_speed
	lw	r0, r2
	li	r4, 5
	add	r0, r0, r4
	sw	r0, r2
PaperNoMoveRIGHT:
	
	bai	-, PaperGameRedraw
	
	
PaperGameFail:
	; invert screen
	; TODO : add color mode(s) to VGA driver???
	
	li	r0, 0
	liw	r2, 240*20
	
	lw	r1, r0
	not	r1, r1
	sw	r1, r0
	inc	r0, r0
	dec	r2, r2
	brine	r2, $-5
	
	; wait for keypress
	liw	r3, key_press_map
	
	lw	r2, r3
	brieq	r2, $-1
	
PaperGameQuit:
	reset
	
	
PaperMapScroll:
	; scroll tilemap up
	
	liw	r0, paper_tilemap
	li	r1, 4
	add	r1, r0, r1
	li	r2, 5*4
	
PaperGameScrollLoop:
	lw	r3, r1
	sw	r3, r0
	inc	r0, r0
	inc	r1, r1
	dec	r2, r2
	brine	r2, PaperGameScrollLoop
	
	; generate new tilemap line
	
	dec	r7, r7
	sw	r6, r7
	
	bail	-, r6, rand16
	
	li	r2, 0x05
	
	and	r3, r1, r2
	shr	r1, r1, 2
	and	r4, r1, r2
	shr	r1, r1, 2
	
	mixll	r1, r3, r4
	sw	r1, r0
	inc	r0, r0
	
	li	r2, 0x07
	
	add r4, r3, r4
	and	r3, r1, r2
	add r4, r3, r4
	li	r3, 3
	add	r4, r4, r3
	shr	r1, r1, 1
	
	and	r3, r1, r2
	add r3, r3, r4
	shr	r1, r1, 2
	and	r4, r1, r2
	shr	r1, r1, 2
	
	mixll	r1, r3, r4
	sw	r1, r0
	inc	r0, r0
	
	li	r2, 0x05
	
	add r4, r3, r4
	and	r3, r1, r2
	add r4, r3, r4
	li	r3, 3
	add	r4, r4, r3
	shr	r1, r1, 1
	
	and	r3, r1, r2
	add r3, r3, r4
	shr	r1, r1, 2
	and	r4, r1, r2
	shr	r1, r1, 2
	
	mixll	r1, r3, r4
	sw	r1, r0
	inc	r0, r0
	
	; increase falling speed
	; TODO : better physics...
	
	liw	r2, paper_speed + 1
	lw	r1, r2
	inc	r1, r1
	sw	r1, r2
	
	; update score
	liw	r2, paper_score
	lw	r1, r2
	inc	r1, r1
	sw	r1, r2
	
	lw	r6, r7
	inc	r7, r7
	
	ba	-, r6
	
	
; brief : init random seed
; input : r0 = base value
; destroys : r0, r1, r2
rand16_init:
; 	mul	r1, r0, r6
; 	xor	r0, r1, r0
	liw	r2, rand_seed
	sw	r0, r2
	ba	-, r6

; brief : pseudo random number generator
; output : r1 = prn
; destroys : r2, r3, r4
rand16:
	liw	r2, rand_seed
	lw	r3, r2
	li	r4, 253
	mixll	r1, r3, r4
	mixhh	r4, r4, r3
	li	r2, 0
	sub	r1, r1, r3
	sbc	r4, r4, r2
	sbc	r1, r1, r3
	sbc	r4, r4, r2
	mixhl	r3, r2, r4
	sbc	r1, r1, r3
	adc	r1, r1, r2
	liw	r2, rand_seed
	sw	r1, r2
	
	ba	-, r6

; brief : display the 8*8 tile in r3 at pos (r0, r1)
; destroys : none (updates r0)
put_tile:
	; push	r0-r6
	dec	r7, r7
	sw	r0, r7
	dec	r7, r7
	sw	r1, r7
	dec	r7, r7
	sw	r2, r7
	dec	r7, r7
	sw	r3, r7
	dec	r7, r7
	sw	r4, r7
	dec	r7, r7
	sw	r5, r7
	dec	r7, r7
	sw	r6, r7
	
	liw	r2, paper_tiles
	shl	r3, r3, 1
	add	r2, r2, r3
	
	li	r3, 8
	bail	-, r6, put_sprite_8_aligned
	
	; push	r6-r0
	lw	r6, r7
	inc	r7, r7
	lw	r5, r7
	inc	r7, r7
	lw	r4, r7
	inc	r7, r7
	lw	r3, r7
	inc	r7, r7
	lw	r2, r7
	inc	r7, r7
	lw	r1, r7
	inc	r7, r7
	lw	r0, r7
	inc	r7, r7
	
	inc	r0, r0
	
	ba	-, r6
	

	; r0 = r0 / r2
	; r1 = r0 % r2
	; destroys : r3, r4
div_16_16:
	xor	r1, r1, r1
	li	r4, 16
	
div_16_16.loop:
	
	add	r0, r0, r0
	adc	r1, r1, r1
	sub	r3, r1, r2
	brilt	r3, div_16_16.skip
	sub	r1, r1, r2
	inc	r0, r0
div_16_16.skip:
	dec	r4, r4
	brine	r4, div_16_16.loop
	
div_16_16.end:
	ba	-, r6

	; write a zero-terminated string to screen
	; inputs :
	;	* (r0, r1) = (x / 8, y)
	;	* r2 = text
	;	* r6 = return address 
puts:
	; push	r6
	dec	r7, r7
	sw	r6, r7
	
puts.loop:
	; fetch char
	lw	r3, r2
	shr	r3, r3, 7
	
	; check for null
	brieq	r3, puts.end
	
	; push	r2
	dec	r7, r7
	sw	r2, r7
	
	bail	-, r6, putchar
	
	; pop	r2
	lw	r2, r7
	inc	r7, r7
	
	; todo : newline if needed...
	
	; fetch char
	lw	r3, r2
	shl	r3, r3, 7
	shr	r3, r3, 7
	
	; check for null
	brieq	r3, puts.end
	
	; push	r2
	dec	r7, r7
	sw	r2, r7
	
	; draw sprite at proper position
	bail	-, r6, putchar
	
	; pop	r2
	lw	r2, r7
	inc	r7, r7
	
	; next char
	inc	r2, r2
	
	bri	-, puts.loop
	
puts.end:
	; pop	r6
	lw	r6, r7
	inc	r7, r7
	
	; exit routine
	ba	-, r6
	
; brief : display the 8*8 char in r3 at pos (r0, r1)
; destroys r2, r3, r4
putchar:
	; push	r6
	dec	r7, r7
	sw	r6, r7
	
	dec	r7, r7
	sw	r0, r7
	dec	r7, r7
	sw	r1, r7
	
	liw	r2, font_map ; + 4 * 0x23
	shl	r3, r3, 1
	add	r2, r2, r3
	
	li	r3, 8
	bail	-, r6, put_sprite_8_aligned
	
	lw	r1, r7
	inc	r7, r7
	lw	r0, r7
	inc	r7, r7
	
	inc	r0, r0
	
	; pop	r6
	lw	r6, r7
	inc	r7, r7
	
	ba	-, r6
	
	; input : (r0, r1) = (x, y), r2 = number
	; output : string representation of number (in base 10) written at given coords
	; destroys : r2, r3, r4, r5
printnum:
	dec	r7, r7
	sw	r6, r7
	
	liw	r4, 10000
	bail	-, r6, printnum.sub
	liw	r4, 1000
	bail	-, r6, printnum.sub
	li	r4, 100
	bail	-, r6, printnum.sub
	li	r4, 10
	bail	-, r6, printnum.sub
	
	lw	r6, r7
	inc	r7, r7
	
	li	r4, 1
	
printnum.sub:
	li	r3, 0x2F
printnum.loop:
	inc	r3, r3
	sub	r2, r2, r4
	brige	r2, printnum.loop
	add	r2, r2, r4
	
	dec	r7, r7
	sw	r6, r7
	dec	r7, r7
	sw	r2, r7
	bail	-, r6, putchar
	lw	r2, r7
	inc	r7, r7
	lw	r6, r7
	inc	r7, r7
	
	ba	-, r6
	
	; inputs : 
	;	* (r0, r1) = (x / 16, y)
	;	* r2 = sprite data
	;	* r3 = sprite height
	;	
	;	* r6 = return address 
	;
	; destroys : r0, r1, r2, r3, r4
put_sprite_16_aligned:
	; r4 will be address in VGA buffer : base at 0x0000
	; buffer is 320*240pix, 16pix per word
	; => one buffer line is 20 words
	
	; r4 = 16*y
	shl r4, r1, 3
	; r1 = 4*y
	shl	r1, r1, 1
	; r4 = 20*y
	add	r4, r4, r1
	; r4 = 20*y + x/16 : first word for sprite
	add	r4, r4, r0
	
	li	r0, 20
	
put_sprite_16_aligned.loop:
	inc	r2, r2
	
	lw	r1, r2
	exw	r1, r4
	
	inc	r2, r2
	add	r4, r4, r0
	
	dec	r3, r3
	brine	r3, put_sprite_16_aligned.loop
	
put_sprite_16_aligned.end:
	
	li	r5, 0
	ba	-, r6


	; inputs : 
	;	* (r0, r1) = (x, y)
	;	* r2 = sprite data
	;	* r3 = sprite height
	;	
	;	* r6 = return address 
	;
	; destroys : r0, r1, r2, r3, r4, r5
put_sprite_16:
	; r4 will be address in VGA buffer : base at 0x0000
	; buffer is 320*240pix, 16pix per word
	; => one buffer line is 20 words
	
	li	r5, 15
	and	r5, r0, r5
	shr	r0, r0, 3
	
	brieq	r5, put_sprite_16_aligned
	dec	r5, r5
	
	; r4 = 16*y
	shl r4, r1, 3
	; r1 = 4*y
	shl	r1, r1, 1
	; r4 = 20*y
	add	r4, r4, r1
	; r4 = 20*y + x/16 : first word for sprite
	add	r4, r4, r0
	
put_sprite_16.loop:
	; push r3
	dec	r7, r7
	sw	r3, r7
	
	inc	r2, r2
	
	lw	r1, r2
	
	li	r0, -1
	rsr	r0, r0, r5
	rrr	r1, r1, r5
	and	r1, r1, r0
	
	lw	r3, r4
	not	r0, r0
	and	r3, r3, r0
	or	r1, r1, r3
	exw	r1, r4
	
	inc	r4, r4
	
	lw	r1, r2
	
	rrr	r1, r1, r5
	and	r1, r1, r0
	
	lw	r3, r4
	not	r0, r0
	and	r3, r3, r0
	or	r1, r1, r3
	exw	r1, r4
	
	; move to next sprite line
	inc	r2, r2
	
	; move to next buffer line
	li	r0, 19
	add	r4, r4, r0
	
	; pop	r3
	lw	r3, r7
	inc	r7, r7
	
	dec	r3, r3
	brine	r3, put_sprite_16.loop
	
put_sprite_16.end:
	
	li	r5, 0
	ba	-, r6

	; inputs : 
	;	* (r0, r1) = (x / 16, y)
	;	* r2 = sprite data (mask interlaced)
	;	* r3 = sprite height
	;	
	;	* r6 = return address 
	;	
	; output : 
	;	* r5 = 0 if no collision
	;
	; destroys : r0, r1, r2, r3, r4
put_sprite_16_masked_aligned:
	; r4 will be address in VGA buffer : base at 0x0000
	; buffer is 320*240pix, 16pix per word
	; => one buffer line is 20 words
	
	; r4 = 16*y
	shl r4, r1, 3
	; r1 = 4*y
	shl	r1, r1, 1
	; r4 = 20*y
	add	r4, r4, r1
	; r4 = 20*y + x/16 : first word for sprite
	add	r4, r4, r0
	
	li	r5, 0
	
put_sprite_16_masked_aligned.loop:
	; load buffer value
	lw	r0, r4
	
	; load mask line
	lw	r1, r2
	inc	r2, r2
	
	; mask buffer
	and	r0, r0, r1
	
	; load sprite line
	lw	r1, r2
	
	; compose
	or	r0, r0, r1
	
	; store new value and keep old for collision check
	exw	r0, r4
	
	; collision check
	dec	r2, r2
	lw	r1, r2
	not	r1, r1
	inc	r2, r2
	and	r0, r0, r1
	or	r5, r5, r0
	
	inc	r2, r2
	
	; next buffer line
	li	r0, 20
	add	r4, r4, r0
	
	dec	r3, r3
	brine	r3, put_sprite_16_aligned.loop
	
put_sprite_16_masked_aligned.end:
	
	ba	-, r6


	; inputs : 
	;	* (r0, r1) = (x, y)
	;	* r2 = sprite data (mask interlaced)
	;	* r3 = sprite height
	;	
	;	* r6 = return address 
	;
	; output : 
	;	* r5 = 0 if no collision
	;
	; destroys : r0, r1, r2, r3, r4
put_sprite_16_masked:
	; r4 will be address in VGA buffer : base at 0x0000
	; buffer is 320*240pix, 16pix per word
	; => one buffer line is 20 words
	
	li	r5, 15
	and	r5, r0, r5
	shr	r0, r0, 3
	
	brieq	r5, put_sprite_16_masked_aligned
	dec	r5, r5
	
	; r4 = 16*y
	shl r4, r1, 3
	; r1 = 4*y
	shl	r1, r1, 1
	; r4 = 20*y
	add	r4, r4, r1
	; r4 = 20*y + x/16 : first word for sprite
	add	r4, r4, r0
	
	; push r6
	dec	r7, r7
	sw	r6, r7
	
	mova	r6, r5
	li	r5, 0
	
put_sprite_16_masked.loop:
	; push r3
	dec	r7, r7
	sw	r3, r7
	
	; push r5
	dec	r7, r7
	sw	r5, r7
	
	; load mask line
	lw	r0, r2
	rrr	r0, r0, r6
	inc	r2, r2
	; load sprite line
	lw	r1, r2
	rrr	r1, r1, r6
	
	li	r5, -1
	rsr	r5, r5, r6
	
	and	r1, r1, r5
	
	; compose start of sprite line with first buffer word
	lw	r3, r4
	not	r5, r5
	or	r5, r5, r0
	and	r3, r3, r5
	or	r3, r3, r1
	; write new value to buffer but preserve old for collision check
	exw	r3, r4
	
	; collision check
	not	r5, r5
	and	r3, r3, r5
	
	; pop	r5
	lw	r5, r7
	inc	r7, r7
	
	or	r5, r5, r3
	
	; move to next buffer word
	inc	r4, r4
	
	; push r5
	dec	r7, r7
	sw	r5, r7
	
	; reload sprite line
	lw	r1, r2
	rrr	r1, r1, r6
	
	li	r5, -1
	rsr	r5, r5, r6
	not	r5, r5
	
	and	r1, r1, r5
	
	; compose start of sprite line with first buffer word
	lw	r3, r4
	not	r5, r5
	or	r5, r5, r0
	and	r3, r3, r5
	or	r3, r3, r1
	; write new value to buffer but preserve old for collision check
	exw	r3, r4
	
	; collision check
	not	r5, r5
	and	r3, r3, r5
	
	; pop	r5
	lw	r5, r7
	inc	r7, r7
	
	or	r5, r5, r3
	
	; move to next sprite line
	inc	r2, r2
	
	; move to next buffer line
	li	r0, 19
	add	r4, r4, r0
	
	; pop	r3
	lw	r3, r7
	inc	r7, r7
	
	dec	r3, r3
	brine	r3, put_sprite_16_masked.loop
	
put_sprite_16_masked.end:
	
	;pop r6
	lw	r6, r7
	inc	r7, r7
	
	ba	-, r6


	; inputs : 
	;	* (r0, r1) = (x / 8, y)
	;	* r2 = sprite data
	;	* r3 = sprite height
	;	
	;	* r6 = return address 
put_sprite_8_aligned:
	; r4 will be address in VGA buffer : base at 0x0000
	; buffer is 320*240pix, 16pix per word
	; => one buffer line is 20 words
	
	; r4 = 16*y
	shl r4, r1, 3
	; r1 = 4*y
	shl	r1, r1, 1
	; r4 = 20*y
	add	r4, r4, r1
	; r1 = x/16
	shr	r1, r0, 0
	; r0 = c ? 0xffff : 0
	sbc	r0, r0, r0
	; r4 = 20*y + x/16 : first word for sprite
	add	r4, r4, r1
	
	li	r5, 20
	
	brine	r0, put_sprite_8_aligned.loop1
	
put_sprite_8_aligned.loop0:
	; smask = 0xff00, inmask = 0x00ff
	
	; load sprite data
	lw	r0, r2
	
	; load buffer value
	lw	r1, r4
	; compose data
	mixhl	r1, r0, r1
	; write it to buffer
	sw	r1, r4
	
	; move to next buffer line
	add	r4, r4, r5
	
	dec	r3, r3
	baeq	r3, r6
	
	; load buffer value
	lw	r1, r4
	; compose data
	mixll	r1, r0, r1
	; write it to buffer
	sw	r1, r4
	
	; move to next buffer line
	add	r4, r4, r5
	
	; move to next sprite word
	inc	r2, r2
	
	; loop...
	dec	r3, r3
	baeq	r3, r6
	bri	-, put_sprite_8_aligned.loop0
	
put_sprite_8_aligned.loop1:
	; sshift = 8, inmask = 0xff00
	
	; load sprite data
	lw	r0, r2
	
	; load buffer value
	lw	r1, r4
	; compose data
	mixhh	r1, r1, r0
	; write it to buffer
	sw	r1, r4
	
	; move to next buffer line
	add	r4, r4, r5
	
	dec	r3, r3
	baeq	r3, r6
	
	; load buffer value
	lw	r1, r4
	; compose data
	mixhl	r1, r1, r0
	; write it to buffer
	sw	r1, r4
	
	; move to next buffer line
	add	r4, r4, r5
	
	; move to next sprite word
	inc	r2, r2
	
	; loop...
	dec	r3, r3
	baeq	r3, r6
	
	bri	-, put_sprite_8_aligned.loop1

	; inputs : 
	;	* (r0, r1) = (x, y)
	;	* r2 = sprite data
	;	* r3 = sprite height
	;	
	;	* r6 = return address 
put_sprite_8:
	; r4 will be address in VGA buffer : base at 0x0000
	; buffer is 320*240pix, 16pix per word
	; => one buffer line is 20 words
	
	li	r5, 7
	and	r5, r0, r5
	shr	r0, r0, 2
	
	; go  aligned
	brieq	r5, put_sprite_8_aligned
	dec	r5, r5
	
	; r4 = 16*y
	shl r4, r1, 3
	; r1 = 4*y
	shl	r1, r1, 1
	; r4 = 20*y
	add	r4, r4, r1
	; r1 = x/16
	shr	r1, r0, 0
	; r0 = c ? 0xffff : 0
	sbc	r0, r0, r0
	; r4 = 20*y + x/16 : first word for sprite
	add	r4, r4, r1
	
	brine	r0, put_sprite_8.loop1
	
put_sprite_8.loop0:
	; smask = 0xff00, inmask = 0x00ff
	
	; load sprite data
	lw	r0, r2
	
	; push r2
	dec	r7, r7
	sw	r2, r7
	
	; shift sprite and mask appropriately
	li	r2, 0x100
	rrr	r2, r2, r5
	rrr	r0, r0, r5
	
	; load buffer value
	lw	r1, r4
	
	; compose data
	and	r0, r2, r0
	not	r2, r2
	and	r1, r1, r2
	or	r1, r1, r0
	
	; write it to buffer
	sw	r1, r4
	
	; move to next buffer line
	li	r1, 20
	add	r4, r4, r1
	
	; pop r2
	lw	r2, r7
	inc	r7, r7
	
	dec	r3, r3
	baeq	r3, r6
	
	; load sprite data
	lw	r0, r2
	
	; push r2
	dec	r7, r7
	sw	r2, r7
	
	; select proper byte of sprite data
	;shl	r0, r0, 7
	mixll	r0, r0, r0
	
	; shift mask and sprite appropriately
	li	r2, 0x100
	rrr	r2, r2, r5
	rrr	r0, r0, r5
	
	; load buffer value
	lw	r1, r4
	
	; compose data
	and	r0, r2, r0
	not	r2, r2
	and	r1, r1, r2
	or	r1, r1, r0
	
	; write it to buffer
	sw	r1, r4
	
	; move to next buffer line
	li	r1, 20
	add	r4, r4, r1
	
	; pop r2
	lw	r2, r7
	inc	r7, r7
	
	; move to next sprite word
	inc	r2, r2
	
	; loop...
	dec	r3, r3
	baeq	r3, r6
	bri	-, put_sprite_8.loop0
	
put_sprite_8.loop1:
	; sshift = 8, inmask = 0xff00
	
	; load sprite data
	lw	r0, r2
	
	; push r2 / push r3
	dec	r7, r7
	sw	r2, r7
	dec	r7, r7
	sw	r3, r7
	
	li	r2, 0x100
	rrr	r2, r2, r5
	rrr	r0, r0, r5
	
	; mask out irrelevant part
	and	r0, r0, r2
	
	; load buffer value
	lw	r1, r4
	
	; mask out sprite "spot"
	shr	r3, r2, 7
	not	r3, r3
	and	r1, r1, r3
	
	; compose sprite data
	shr	r3, r0, 7
	or	r1, r1, r3
	
	; write it to buffer
	sw	r1, r4
	
	; next word (unaligned sprite can cross word boundaries)
	inc	r4, r4
	
	; load buffer value
	lw	r1, r4
	
	; mask out sprite "spot"
	shl	r3, r2, 7
	not	r3, r3
	and	r1, r1, r3
	
	; compose sprite data
	shl	r3, r0, 7
	or	r1, r1, r3
	
	; write it to buffer
	sw	r1, r4
	
	; move to next buffer line
	li	r1, 19
	add	r4, r4, r1
	
	; pop r3 / pop r2
	lw	r3, r7
	inc	r7, r7
	lw	r2, r7
	inc	r7, r7
	
	dec	r3, r3
	baeq	r3, r6
	
	; load sprite data
	lw	r0, r2
	shl	r0, r0, 7
	
	; push r2 / push r3
	dec	r7, r7
	sw	r2, r7
	dec	r7, r7
	sw	r3, r7
	
	li	r2, 0x100
	rrr	r2, r2, r5
	rrr	r0, r0, r5
	
	; mask out irrelevant part
	and	r0, r0, r2
	
	; load buffer value
	lw	r1, r4
	
	; mask out sprite "spot"
	shr	r3, r2, 7
	not	r3, r3
	and	r1, r1, r3
	
	; compose sprite data
	shr	r3, r0, 7
	or	r1, r1, r3
	
	; write it to buffer
	sw	r1, r4
	
	; next word (unaligned sprite can cross word boundaries)
	inc	r4, r4
	
	; load buffer value
	lw	r1, r4
	
	; mask out sprite "spot"
	shl	r3, r2, 7
	not	r3, r3
	and	r1, r1, r3
	
	; compose sprite data
	shl	r3, r0, 7
	or	r1, r1, r3
	
	; write it to buffer
	sw	r1, r4
	
	; move to next buffer line
	li	r1, 19
	add	r4, r4, r1
	
	; pop r3 / pop r2
	lw	r3, r7
	inc	r7, r7
	lw	r2, r7
	inc	r7, r7
	
	; move to next sprite word
	inc	r2, r2
	
	; loop...
	dec	r3, r3
	baeq	r3, r6
	
	bri	-, put_sprite_8.loop1
