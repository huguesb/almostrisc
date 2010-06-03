
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
	

	; old tests
	
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
	
	; test register-indexed shift/rotates
	li	r6, 3
	
	rrr	r5, r0, r6
	rrl	r5, r1, r6
	rsr	r5, r2, r6
	rsl	r5, r3, r6
	
	; test hw multiplication
	mul	r6, r1, r0 ; r1:r6 = r1 * r0
	
test.puts:
	li	r0, 39
	li	r1, 0
	liw	r2, font_map + 4 * 0x23
	li	r3, 8
	bail	-, r6, put_sprite_8_aligned
	
	li	r0, 4
	li	r1, 0
	liw	r2, hello_str
	
	bail	-, r6, puts
	
	
	xor	r0, r0, r0
	li	r1, 20
	
	liw	r2, 0x2020
	sw	r2, r0
	add	r0, r0, r1
	liw	r2, 0x7070
	sw	r2, r0
	add	r0, r0, r1
	liw	r2, 0xF8F8 ; 
	sw	r2, r0
	add	r0, r0, r1
	liw	r2, 0xF8F8 ; 
	sw	r2, r0
	add	r0, r0, r1
	liw	r2, 0xF870 ; 
	sw	r2, r0
	add	r0, r0, r1
	liw	r2, 0x7020 ; 
	sw	r2, r0
	add	r0, r0, r1
	liw	r2, 0x2070 ; 
	sw	r2, r0
	add	r0, r0, r1
	liw	r2, 0x0000 ; 
	sw	r2, r0
	add	r0, r0, r1
	
	; stop there
	;bri	-, $
	
	li	r0, 8
	li	r1, 8
	
redraw:
	dec	r7, r7
	sw	r1, r7
	dec	r7, r7
	sw	r0, r7
	
	; display char
	liw	r2, font_map + 4 * 0x23
	li	r3, 8
	bail	-, r6, put_sprite_8
	
	lw	r0, r7
	inc	r7, r7
	lw	r1, r7
	inc	r7, r7
	
	
	; small delay
	li	r2, 20
	li	r3, 0
	dec	r3, r3
	brine	r3, $-1
	dec	r2, r2
	brine	r2, $-4
	
event_loop:
	
event_kbd:
	
	; keyboard polling...
	
; 	liw	r3, PS2_stat
; 	lw	r3, r3
; 	
; 	bspl	r4, r3, 0
; 	brine	r4, event_not_kbd
; 	
; 	dec	r7, r7
; 	sw	r2, r7
; 	dec	r7, r7
; 	sw	r0, r7
; 	dec	r7, r7
; 	sw	r1, r7
; 	
; 	liw	r3, PS2_rx
; 	lw	r3, r3
; 	
; 	shl	r3, r3, 1
; 	add	r2, r2, r3
; 	
; 	li	r3, 8
; 	bail	-, r6, put_sprite_8_aligned
; 	
; 	lw	r1, r7
; 	inc	r7, r7
; 	lw	r0, r7
; 	inc	r7, r7
; 	
; 	inc	r0, r0
; 	li	r2, 40
; 	sub	r2, r0, r2
; 	brilt	r2, event_kbd_end
; 	shr	r0, r1, 2
; 	li	r2, 8
; 	add	r1, r1, r2
; 	li	r2, 233
; 	sub	r2, r1, r2
; 	brilt	r2, event_kbd_end
; 	li	r1, 8
; 	li	r0, 0
; event_kbd_end:
; 	lw	r2, r7
; 	inc	r7, r7
	
	; interrupt-based conversion, only use key codes
	
	liw	r2, key_press_map
	lw	r2, r2
	brieq	r2, event_not_kbd
	
	dec	r7, r7
	sw	r2, r7
	
	
	dec	r7, r7
	sw	r1, r7
	dec	r7, r7
	sw	r0, r7
	
	; clear char
	liw	r2, font_map
	li	r3, 8
	bail	-, r6, put_sprite_8
	
	lw	r0, r7
	inc	r7, r7
	lw	r1, r7
	inc	r7, r7
	
	
	lw	r2, r7
	inc	r7, r7
	
	; up
	bspl	r3, r2, 0
	brieq	r3, event_kbd_no_up
	
	li	r3, 8
	sub	r3, r1, r3
	brine	r3, event_kbd_no_clip_up
	li	r1, 240
event_kbd_no_clip_up:
	li	r3, 8
	sub	r1, r1, r3
	
event_kbd_no_up:
	; left
	bspl	r3, r2, 1
	brieq	r3, event_kbd_no_left
	
	brine	r0, event_kbd_no_clip_left
	li	r0, 39*8 ; 40
event_kbd_no_clip_left:
	dec	r0, r0
	
event_kbd_no_left:
	; down
	bspl	r3, r2, 2
	brieq	r3, event_kbd_no_down
	li	r3, 232
	sub	r3, r1, r3
	brilt	r3, event_kbd_no_clip_down
	li	r1, 0
event_kbd_no_clip_down:
	li	r3, 8
	add	r1, r1, r3
	
event_kbd_no_down:
	; right
	bspl	r3, r2, 3
	brieq	r3, event_kbd_no_right
	li	r3, 39*8
	sub	r3, r0, r3
	brilt	r3, event_kbd_no_clip_right
	li	r0, -1
event_kbd_no_clip_right:
	inc	r0, r0
	
event_kbd_no_right:
	bri	-, redraw
	
event_not_kbd:
	
	bri	-, event_loop
	
	
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
