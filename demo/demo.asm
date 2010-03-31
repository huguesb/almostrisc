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

.equ	hello_str		0x16C0

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
	bspl	r2, r1, 3
	bailne	r2, r6, int_kbd
	
	; handle first timer interrupt
	bspl	r2, r1, 0
	bailne	r2, r6, int_tmr
	
	; acknowledge all interrupts
	li	r1, -1
	sw	r1, r0
	
	; resume normal execution (and switch back register bank)
	reti

.org	0x0080
int_tmr:
	; simple visual test for timer
	not r3, r3
	out	r3
	
	ba	-, r6

.org	0x0090
int_kbd:
	; simple visual test for kbd
	; display scan code value on 7segments
	
	liw	r2, PS2_rx
	lw	r3, r2
	
	; ...
	
	ba	-, r6

.org	0x0100
os_init:
	; higher level init here
	
	liw	r0, IRQ_mask	; r0 = 0x2000 : interrupt masking
	
	li	r1, 0x0F		; unmask only first timer and PS2 input
	sw	r1, r0
	
	inc	r0, r0		; r0 = 0x2001 : interrupt sensibility
	
	li	r1, -1		; all interrupts sensible to rising edge
	sw	r1, r0
	
	li	r2, 7
	add	r0, r0, r2	; r0 = 0x2008 : timers control
	
	li	r2, 0x1D 	; enable first timer, loop, speed = 1MHz / 10**1 = 100kHz
	sw	r2, r0
	
	inc	r0, r0		; r0 = 0x2009 : first timer, base count
	
	li	r2, 2		; fire every 2 timer period (so every 0.00002s in this case)
	sw	r2, r0
	
; 	inc	r0, r0		; r0 = 0x200A : second timer, frequency
; 	
; 	li	r2, 0x1B 	; enable second timer, loop, speed = 1MHz / 10**3 = 1kHz
; 	sw	r2, r0
; 	
; 	inc	r0, r0		; r0 = 0x200B : second timer, base count
; 	
; 	li	r2, 3		; fire every 3 timer period (so every 0.003s in this case)
; 	sw	r2, r0
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
	
	
start:
	; "userspace" starts here
	
test.extra:
	; test imm16 loading
	liw	r0, 0x8421
	liw	r1, 0x1234
	
	out	r1
	
	; test reg-mem swap instruction
	exw	r0, r1
	exw	r0, r1
	
	; test mixing instructions
	mixhh	r2, r0, r1
	mixhl	r3, r0, r1
	mixlh	r4, r0, r1
	mixll	r5, r0, r1
	
; 	; test register-indexed shift/rotates
; 	li	r6, 3
; 	
; 	rrr	r5, r0, r6
; 	rrl	r5, r1, r6
; 	rsr	r5, r2, r6
; 	rsl	r5, r3, r6
	
	; test hw multiplication
	mul	r6, r1, r0 ; r1:r6 = r1 * r0
	
test.puts:
	li	r0, 5
	li	r1, 42
	liw	r2, font_map + 4 * 0x23
	li	r3, 8
	bail	-, r6, put_sprite_8_aligned
	
	li	r0, 0
	li	r1, 20
	liw	r2, hello_str
	
	bail	-, r6, puts
	
	; stop there
	bri	-, $
	
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
	
	; push	r0
	dec	r7, r7
	sw	r0, r7
	; push	r1
	dec	r7, r7
	sw	r1, r7
	; push	r2
	dec	r7, r7
	sw	r2, r7
	
	; find proper sprite for char
	liw	r4, font_map
	shl	r3, r3, 1
	add	r2, r3, r4
	
	; sprite height
	li	r3, 8
	
	; draw sprite at proper position
	bail	-, r6, put_sprite_8_aligned
	
	; pop	r2
	lw	r2, r7
	inc	r7, r7
	; pop	r1
	lw	r1, r7
	inc	r7, r7
	; pop	r0
	lw	r0, r7
	inc	r7, r7
	
	; next column
	inc	r0, r0
	
	; todo : newline if needed...
	
	; fetch char
	lw	r3, r2
	shl	r3, r3, 7
	shr	r3, r3, 5
	
	; check for null
	brieq	r3, puts.end
	
	; push	r0
	dec	r7, r7
	sw	r0, r7
	; push	r1
	dec	r7, r7
	sw	r1, r7
	; push	r2
	dec	r7, r7
	sw	r2, r7
	
	; find proper sprite for char
	liw	r4, font_map
	add	r2, r3, r4
	
	; sprite height
	li	r3, 8
	
	; draw sprite at proper position
	bail	-, r6, put_sprite_8_aligned
	
	; pop	r2
	lw	r2, r7
	inc	r7, r7
	; pop	r1
	lw	r1, r7
	inc	r7, r7
	; pop	r0
	lw	r0, r7
	inc	r7, r7
	
	; next column
	inc	r0, r0
	
	; next char
	inc	r2, r2
	
	bri	-, puts.loop
	
puts.end:
	; pop	r6
	lw	r6, r7
	inc	r7, r7
	
	; exit routine
	ba	-, r6

	
	; inputs : 
	;	* (r0, r1) = (x / 16, y)
	;	* r2 = sprite data
	;	* r3 = sprite height
	;	
	;	* r6 = return address 
	;
	; destroys : r0, r1, r2, r3, r4, r5
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
	
put_sprite_16_aligned.loop:
	lw	r1, r2
	sw	r1, r4
	
	inc	r2, r2
	inc	r4, r4
	
	dec	r3, r3
	brine	r3, put_sprite_16_aligned.loop
	
put_sprite_16_aligned.end:
	
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
