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

.equ	paper_keys		0x16C0
.equ	paper_sprites	0x16F0
.equ	paper_hud		0x1720
.equ	paper_tiles		0x1730
.equ	paper_dir		0x173C
.equ	paper_pos		0x173D
.equ	paper_speed		0x1740
.equ	paper_title		0x1744
.equ	paper_unit		0x174A
.equ	paper_tilemap	0x1780

.equ	key_press_map	0x1800

.equ	rand_seed		0x1808

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
	
	; mark
	li	r3, 30
	li	r2, -1
	sw	r2, r3
	
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
	
	li	r1, 5
	sw	r1, r0
	inc	r0, r0
	
	li	r1, 2
	sw	r1, r0
	inc	r0, r0
	
	; init random seed
	liw	r0, TMR_cur1
	lw	r0, r0
	bail	-, r6, rand16_init
	
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
	
	; forward arrow
	li	r0, 239
	li	r1, 1
	liw	r2, paper_hud
	li	r3, 8
	bail	-, r6, put_sprite_8
	
	; speed (itoa...)
	li	r0, 31
	li	r1, 1
	liw	r2, paper_speed + 1
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
	liw	r2, paper_hud + 4
	li	r3, 8
	bail	-, r6, put_sprite_8
	
	; speed
	li	r0, 31
	li	r1, 10
	liw	r2, paper_speed + 2
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
	shl	r1, r1, 2
	li	r2, 27
	add	r1, r1, r2
	
	liw	r2, paper_pos + 1
	lw	r2, r2
	shr	r2, r2, 2
	li	r3, 7
	and	r2, r2, r3
	
	sub	r1, r1, r2
	
	shl	r4, r4, 7
	shr	r4, r4, 7
	
	li	r3, 1
	bailne	r0, r6, put_tile
	
	li	r3, 2
	
PaperGameSegmentLoop:
	bail	-, r6, put_tile
	dec	r4, r4
	brine	r4, PaperGameSegmentLoop
	
	li	r3, 0
	li	r4, 40
	sub	r4, r0, r4
	baillt	r4, r6, put_tile
	
	lw	r5, r7
	inc	r7, r7
	
PaperGameTileSkip:
	liw r4, paper_tilemap + 125
	sub	r4, r5, r4
	
	brilt	r4, PaperGameTileLoop
	
	; check for collision
	
	
	; draw plane
	liw	r3, paper_speed
	lw	r4, r3
	bspl	r5, r4, 15
	xor	r4, r4, r5
	shr	r4, r4, 2
	xor	r4, r4, r5
	liw	r3, paper_pos
	lw	r0, r3
	shr	r0, r0, 2
	
	liw	r2, paper_sprites
	shl	r4, r4, 3
	add	r2, r2, r4
	
	li	r1, 44
	li	r3, 16
	bail	-, r6, put_sprite_16
	
	; delay
	li	r0, 5
	
	li	r1, 0
	bri	-, $+1
	bri	-, $+1
	dec	r1, r1
	brine	r1, $-3
	dec	r0, r0
	brine	r0, $-6
	
PaperGameLoop:
	
; update position and velocity
	
	; move direction : less straight => bigger forward speed loss
	; speed up : decreases with gravity, decrease can be mitigated by steering up
	; or worsened by steering down. Positive up speed decreases forward speed, negative
	; up speed increases forward speed
	
	
	liw	r2, paper_pos
	liw	r3, paper_speed
	
; 	lw	r0, r2
; 	lw	r1, r3
; 	add	r0, r0, r1
; 	brilt	r0, PaperGameQuit
; 	li	r4, 300
; 	sub	r4, r0, r4
; 	brige	r4, PaperGameQuit
; 	sw	r0, r2
	
	inc	r2, r2
	inc	r3, r3
	
	lw	r0, r2
	lw	r1, r3
	li	r4, 0x3F
	add	r0, r0, r1
	and	r1, r0, r4
	not	r4, r4
	and	r0, r0, r4
	sw	r1, r2
	
	; scroll tilemap on boundary...
	brieq	r0, PaperGameSkipScroll
	
	liw	r0, paper_tilemap
	li	r1, 4
	add	r1, r0, r1
	li	r2, 24*4
	
PaperGameScrollLoop:
	lw	r3, r1
	sw	r3, r0
	inc	r0, r0
	inc	r1, r1
	dec	r2, r2
	brine	r2, PaperGameScrollLoop
	
	; generate new tilemap line
	
	bail	-, r6, rand16
	
	liw	r2, 0x0507
	and	r1, r1, r2
	mixhh	r2, r1, r1
	add	r2, r2, r2
	add	r2, r2, r2
	mixll	r1, r2, r1
	
	sw	r1, r0
	inc	r0, r0
	li	r5, 0
	sw	r5, r0
	inc	r0, r0
	sw	r5, r0
	inc	r0, r0
	sw	r5, r0
	
PaperGameSkipScroll:
	
; check for keyboard action
	liw	r3, key_press_map
	lw	r3, r3
	brieq	r3, PaperGameRedrawContent
	
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
	dec	r0, r0
	sw	r0, r2
PaperNoMoveLEFT:
	; RIGHT
	bspl	r4, r3, 3
	brieq	r4, PaperNoMoveRIGHT
	liw	r2, paper_speed
	lw	r0, r2
	inc	r0, r0
	sw	r0, r2
PaperNoMoveRIGHT:
	
	bri	-, PaperGameRedrawContent
	
	
PaperGameQuit:
	reset
	
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
; destroys : r2, r3, r4, r5
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
	
; 	; old tests
; 	
; test.extra:
; 	; test imm16 loading
; 	liw	r0, 0x8421
; 	liw	r1, 0x1234
; 	
; 	out	r1
; 	
; 	; test reg-mem swap instruction
; 	exw	r0, r1
; 	exw	r0, r1
; 	
; 	; test mixing instructions
; 	mixhh	r2, r0, r1
; 	mixhl	r3, r0, r1
; 	mixlh	r4, r0, r1
; 	mixll	r5, r0, r1
; 	
; 	; test register-indexed shift/rotates
; 	li	r6, 3
; 	
; 	rrr	r5, r0, r6
; 	rrl	r5, r1, r6
; 	rsr	r5, r2, r6
; 	rsl	r5, r3, r6
; 	
; 	; test hw multiplication
; 	mul	r6, r1, r0 ; r1:r6 = r1 * r0
; 	
; test.puts:
; 	li	r0, 39
; 	li	r1, 0
; 	liw	r2, font_map + 4 * 0x23
; 	li	r3, 8
; 	bail	-, r6, put_sprite_8_aligned
; 	
; 	li	r0, 4
; 	li	r1, 0
; 	liw	r2, hello_str
; 	
; 	bail	-, r6, puts
; 	
; 	
; 	xor	r0, r0, r0
; 	li	r1, 20
; 	
; 	liw	r2, 0x2020
; 	sw	r2, r0
; 	add	r0, r0, r1
; 	liw	r2, 0x7070
; 	sw	r2, r0
; 	add	r0, r0, r1
; 	liw	r2, 0xF8F8 ; 
; 	sw	r2, r0
; 	add	r0, r0, r1
; 	liw	r2, 0xF8F8 ; 
; 	sw	r2, r0
; 	add	r0, r0, r1
; 	liw	r2, 0xF870 ; 
; 	sw	r2, r0
; 	add	r0, r0, r1
; 	liw	r2, 0x7020 ; 
; 	sw	r2, r0
; 	add	r0, r0, r1
; 	liw	r2, 0x2070 ; 
; 	sw	r2, r0
; 	add	r0, r0, r1
; 	liw	r2, 0x0000 ; 
; 	sw	r2, r0
; 	add	r0, r0, r1
; 	
; 	; stop there
; 	;bri	-, $
; 	
; 	li	r0, 8
; 	li	r1, 8
; 	
; redraw:
; 	dec	r7, r7
; 	sw	r1, r7
; 	dec	r7, r7
; 	sw	r0, r7
; 	
; 	; display char
; 	liw	r2, font_map + 4 * 0x23
; 	li	r3, 8
; 	bail	-, r6, put_sprite_8
; 	
; 	lw	r0, r7
; 	inc	r7, r7
; 	lw	r1, r7
; 	inc	r7, r7
; 	
; 	
; 	; small delay
; 	li	r2, 20
; 	li	r3, 0
; 	dec	r3, r3
; 	brine	r3, $-1
; 	dec	r2, r2
; 	brine	r2, $-4
; 	
; event_loop:
; 	
; event_kbd:
; 	
; 	; keyboard polling...
; 	
; ; 	liw	r3, PS2_stat
; ; 	lw	r3, r3
; ; 	
; ; 	bspl	r4, r3, 0
; ; 	brine	r4, event_not_kbd
; ; 	
; ; 	dec	r7, r7
; ; 	sw	r2, r7
; ; 	dec	r7, r7
; ; 	sw	r0, r7
; ; 	dec	r7, r7
; ; 	sw	r1, r7
; ; 	
; ; 	liw	r3, PS2_rx
; ; 	lw	r3, r3
; ; 	
; ; 	shl	r3, r3, 1
; ; 	add	r2, r2, r3
; ; 	
; ; 	li	r3, 8
; ; 	bail	-, r6, put_sprite_8_aligned
; ; 	
; ; 	lw	r1, r7
; ; 	inc	r7, r7
; ; 	lw	r0, r7
; ; 	inc	r7, r7
; ; 	
; ; 	inc	r0, r0
; ; 	li	r2, 40
; ; 	sub	r2, r0, r2
; ; 	brilt	r2, event_kbd_end
; ; 	shr	r0, r1, 2
; ; 	li	r2, 8
; ; 	add	r1, r1, r2
; ; 	li	r2, 233
; ; 	sub	r2, r1, r2
; ; 	brilt	r2, event_kbd_end
; ; 	li	r1, 8
; ; 	li	r0, 0
; ; event_kbd_end:
; ; 	lw	r2, r7
; ; 	inc	r7, r7
; 	
; 	; interrupt-based conversion, only use key codes
; 	
; 	liw	r2, key_press_map
; 	lw	r2, r2
; 	brieq	r2, event_not_kbd
; 	
; 	dec	r7, r7
; 	sw	r2, r7
; 	
; 	
; 	dec	r7, r7
; 	sw	r1, r7
; 	dec	r7, r7
; 	sw	r0, r7
; 	
; 	; clear char
; 	liw	r2, font_map
; 	li	r3, 8
; 	bail	-, r6, put_sprite_8
; 	
; 	lw	r0, r7
; 	inc	r7, r7
; 	lw	r1, r7
; 	inc	r7, r7
; 	
; 	
; 	lw	r2, r7
; 	inc	r7, r7
; 	
; 	; up
; 	bspl	r3, r2, 0
; 	brieq	r3, event_kbd_no_up
; 	
; 	li	r3, 8
; 	sub	r3, r1, r3
; 	brine	r3, event_kbd_no_clip_up
; 	li	r1, 240
; event_kbd_no_clip_up:
; 	li	r3, 8
; 	sub	r1, r1, r3
; 	
; event_kbd_no_up:
; 	; left
; 	bspl	r3, r2, 1
; 	brieq	r3, event_kbd_no_left
; 	
; 	brine	r0, event_kbd_no_clip_left
; 	li	r0, 39*8 ; 40
; event_kbd_no_clip_left:
; 	dec	r0, r0
; 	
; event_kbd_no_left:
; 	; down
; 	bspl	r3, r2, 2
; 	brieq	r3, event_kbd_no_down
; 	li	r3, 232
; 	sub	r3, r1, r3
; 	brilt	r3, event_kbd_no_clip_down
; 	li	r1, 0
; event_kbd_no_clip_down:
; 	li	r3, 8
; 	add	r1, r1, r3
; 	
; event_kbd_no_down:
; 	; right
; 	bspl	r3, r2, 3
; 	brieq	r3, event_kbd_no_right
; 	li	r3, 39*8
; 	sub	r3, r0, r3
; 	brilt	r3, event_kbd_no_clip_right
; 	li	r0, -1
; event_kbd_no_clip_right:
; 	inc	r0, r0
; 	
; event_kbd_no_right:
; 	bri	-, redraw
; 	
; event_not_kbd:
; 	
; 	bri	-, event_loop
	
	
	; test division
test.div:
	li	r0, 234
	li	r2, 56
	bail	-, r6, div_16_16
	
	; test multiplication
test.mult:
	li	r0, 137
	li	r2, 142
	bail	-, r6, mult_16_16
	
	; test factorial
test.factorial:
	li r2, 7
	bail	-, r6, fact_16
	
	; go back to start
	reset
	
	; r0 : r1 = r0 * r2
	; destroys : r3, r4, r5
mult_16_16:
	xor	r1, r1, r1
	xor	r4, r4, r4
	li	r5, 16
	
mult_16_16.loop:
	add	r1, r1, r1	; r1 = r1 * 2
	adc	r0, r0, r0	; C = msb(r0)
	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
	add	r1, r1, r3	; r1 = r1 + r3
	adc	r0, r0, r4	; carry propagation into r0
	
	dec	r5, r5
	brine	r5, mult_16_16.loop
	
mult_16_16.end:
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


	; r0 : r1 = r2 !
	;
fact_16:
	xor	r0, r0, r0
	xor	r1, r1, r1
	brieq	r2, fact_16.end
	inc	r1, r1
fact_16.loop:
	mova	r0, r1
	bail	-, r6, mult_16_16
	
	brine	r0, fact_16.overflow
	dec	r2, r2
	brine	r2, fact_16.loop
	
fact_16.overflow:
	
fact_16.end:
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
	lw	r1, r2
	sw	r1, r4
	
	inc	r2, r2
	add	r4, r4, r0
	
	dec	r3, r3
	brine	r3, put_sprite_16_aligned.loop
	
put_sprite_16_aligned.end:
	
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
	
	lw	r1, r2
	
	li	r0, -1
	rsr	r0, r0, r5
	rrr	r1, r1, r5
	and	r1, r1, r0
	
	lw	r3, r4
	not	r0, r0
	and	r3, r3, r0
	or	r1, r1, r3
	sw	r1, r4
	
	inc	r4, r4
	
	lw	r1, r2
	
	rrr	r1, r1, r5
	and	r1, r1, r0
	
	lw	r3, r4
	not	r0, r0
	and	r3, r3, r0
	or	r1, r1, r3
	sw	r1, r4
	
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
	
; 	li	r2, 0
; 	mixll	r3, r2, r0
; 	li	r2, 0xFF
; 	rsl	r2, r2, r5
; 	rsl	r3, r3, r5
; 	
; 	; load buffer value
; 	lw	r1, r4
; 	
; 	; compose data
; 	and	r3, r2, r3
; 	not	r2, r2
; 	and	r1, r1, r2
; 	or	r1, r1, r3
; 	
; 	; write it to buffer
; 	sw	r1, r4
; 	
; 	inc	r4, r4
; 	
; 	li	r2, 0
; 	mixll	r3, r0, r2
; 	li	r2, -1
; 	rsl	r2, r2, r5
; 	rsl	r3, r3, r5
; 	
; 	; load buffer value
; 	lw	r1, r4
; 	
; 	; compose data
; 	and	r3, r2, r3
; 	not	r2, r2
; 	and	r1, r1, r2
; 	or	r1, r1, r3
; 	
; 	; write it to buffer
; 	sw	r1, r4
; 	
	
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
