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
	; do some init here...
	
	li	r0, 0x20
	shl	r0, r0, 7	; r0 = 0x2000 : interrupt masking
	li	r1, 1	; unmask only first timer
	sw	r1, r0
	inc	r0, r0	; r0 = 0x2001 : interrupt sensibility
	li	r1, -1	; all interrupts sensible to rising edge
	sw	r1, r0
	li	r2, 7
	add	r0, r0, r2	; r0 = 0x2008 : timers control
	li	r2, 0x18 ; enable first timer, loop, max speed (1MHz)
	sw	r2, r0
	inc	r0, r0	; r0 = 0x2009 : first timer, base count
	li	r2, 2	; fire every 2+1=3 ms
	sw	r2, r0
	
	; go to program itself
	li	r0, start - ($+1)
	br	-, r0

.org	0x0010
int_isr:
	; handle interrupts here
	
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
	
	; resume normal execution
	reti

.org	0x0100
start:
	
test.factorial:
; 	li r0, 7
; 	
; 	; r0 = {
; 	;	i! if i in [1, 8]
; 	;	0 otherwise
; 	; }
; 	; recursive impl for the fun of it (and to test cpu of course)
; fact_16:
; 	
; 	
; fact16.end:
; 
; 	reset

test.div:
	li	r0, 234
	li	r2, 56
	li	r3, div_16_16 - ($+1)
	brl	r6, r3
	bri	-, test.div
	
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

test.mult:
	li	r0, 137
	li	r2, 142
	li	r3, mult_16_16 - ($+1)
	brl	r6, r3
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
	
	
	
	; display a 8*8 sprite to VGA buffer
	; in : r0, r1 => x, y; r2 => sprite data 
sprite_aligned_8:
	; r3 will be address in VGA buffer : base at 0x0000
	; buffer is 320*240pix, 16pix per word
	; => one buffer line is 20 words
	
	; r3 = 16*y
	shl r3, r1, 3
	; r1 = 4*y
	shl	r1, r1, 1
	; r3 = 20*y
	add	r3, r3, r1
	; r1 = x / 16
	shr	r1, r0, 3
	; r0 = c ? 0xffff : 0x0000  (shifting requirement)
	sbc	r0, r0, r0
	; r3 = 20*y + x/16 : first word for sprite
	add	r3, r3, r1
	
	li	r4, 4
	
sprite_aligned_8.loop:
	; load first sprite word
	lw	r1, r2
	
	
	dec	r4, r4
	brine	r4, sprite_aligned_8.loop
	
	ba	-, r6
	
	
; 	li	r0, 0x123
; 	li	r2, 456
; 	
;	; r0 : r1 = r0 * r2
;	; destroys : r3, r4
; mult_16_16.unrolled:
; 	xor	r1, r1, r1
; 	xor	r4, r4, r4
; 	
; 	; optimized first iteration...
; 	; add	r1, r1, r1	; r1 = r1 * 2
; 	add	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	; unroll 15 times...
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; 	
; 	add	r1, r1, r1	; r1 = r1 * 2
; 	adc	r0, r0, r0	; C = msb(r0)
; 	sbc	r3, r3, r3	; r3 = sxt(msb(r0))
; 	and	r3, r3, r2	; r3 = msb(r0) ? r2 : 0
; 	add	r1, r1, r3	; r1 = r1 + r3
; 	adc	r0, r0, r4	; carry propagation into r0
; mult_16_16.unrolled.end:
; 	
	
end:
	reset

