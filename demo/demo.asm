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

.org	0x0000
int_reset:
	; do some low level init here
	
	; reset stack pointer
	xor	r7, r7, r7
	
	; go to program itself
	bai	-, os_init

.org	0x0010
int_isr:
	; handle interrupts here
	
	; in this context we are using a different register bank
	; so there is no need to manually save register values
	
	; set r0 to base pointer of device mappings (IRQ comes first)
	li	r0, 0x20
	shl	r0, r0, 7
	
	; base + 2 : ACK
	li	r2, 2
	add	r0, r0, r2
	
	; acknowledge all
	li	r1, -1
	sw	r1, r0
	
	; visual test
	not r3, r3
	out	r3
	
	; resume normal execution (and switch back register bank)
	reti

.org	0x0020


.org	0x0100
os_init:
	; higher level init here
	
	liw	r0, 0x2000	; r0 = 0x2000 : interrupt masking
	
	li	r1, 1		; unmask only first timer
	sw	r1, r0
	
	inc	r0, r0		; r0 = 0x2001 : interrupt sensibility
	
	li	r1, -1		; all interrupts sensible to rising edge
	sw	r1, r0
	
	li	r2, 7
	add	r0, r0, r2	; r0 = 0x2008 : timers control
	
	li	r2, 0x18 	; 0x1E ; enable first timer, loop, speed = 1MHz / 10**6 = 1Hz
	sw	r2, r0
	
	inc	r0, r0		; r0 = 0x2009 : first timer, base count
	
	li	r2, 2		; fire every 2 timer period (so every 2s in this case)
	sw	r2, r0
	
	
start:
	; "userspace" starts here
	
test.extra:
	liw	r0, 0x8421
	liw	r1, 0x1234
	
	exw	r0, r1
	exw	r0, r1
	
	mixhh	r2, r0, r1
	mixhl	r3, r0, r1
	mixlh	r4, r0, r1
	mixll	r5, r0, r1
	
test.div:
	li	r0, 234
	li	r2, 56
	bail	-, r6, div_16_16
	reset
	
test.mult:
	li	r0, 137
	li	r2, 142
	bail	-, r6, mult_16_16
	reset
	
test.factorial:
	li r2, 7
	bail	-, r6, fact_16
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

	
	; inputs : 
	;	* (r0, r1) = (x / 16, y)
	;	* r2 = sprite data
	;	* r3 = sprite height
	;	
	;	* r6 = return address 
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
	shl	r1, r0, 0
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
	
	dec	r3, r3
	brieq	r3, put_sprite_8_aligned.end
	
	; move to next buffer line
	add	r4, r4, r5
	
	; load buffer value
	lw	r1, r4
	; compose data
	mixll	r1, r0, r1
	; write it to buffer
	sw	r1, r4
	
	; move to next sprite word
	inc	r2, r2
	
	; loop...
	dec	r3, r3
	brine	r3, put_sprite_8_aligned.loop0
	
put_sprite_8_aligned.end:
	; return to caller
	ba	-, r6

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
	
	dec	r3, r3
	brieq	r3, put_sprite_8_aligned.end
	
	; move to next buffer line
	add	r4, r4, r5
	
	; load buffer value
	lw	r1, r4
	; compose data
	mixhl	r1, r1, r0
	; write it to buffer
	sw	r1, r4
	
	; move to next sprite word
	inc	r2, r2
	
	; loop...
	dec	r3, r3
	brine	r3, put_sprite_8_aligned.loop1
	
	; return to caller
	ba	-, r6
