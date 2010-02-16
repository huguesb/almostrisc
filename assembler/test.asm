
; test file for assembler

test_li:
	li	r0, $+1
	li	r0, 1 + 1 * 2
	li	r0, 0x1ff
	li	r1, 12
	li	R2 2
	li r3, 42
	li r4, -5
	li r5, 33
	li	r0 test_sw + 1
	li	r7, test_li
	li	r6, test_lw
	
test_sw:
	sw	r1 , r5
	sw	r7, r6
	
test_ops:
	nop
	
	inc r0, r0
	dec	r0, r0
	
	add	r0, r1, r0
	sub r5, r4, r3
	
	adc r0, r0, r0
	sbc r0, r0, r0
	
	and r0 r1 r1
	or  r3 r2 r4
	xor r0, r0 r0
	
	not	r0, r0
	
	mova r0, r1
	movb r2, r3
	negb r0, r0
	nega r5, r6
	
	shl r0, r2, 3
	shr r1, r5, 7
	
test_lw:
	lw	r0, R2
	lw	r3	,r4
	
test_brcc:
	BR	r0, r0
	breq	r0, r1
	brIC	r2, r3
	brne	r6, r7
	
test_bacc:
	balt	r5, r4
	bage	r1, r3
	ba	r6, r6
	
test_bricc:
	brine	r0, test_ops

test_brl:
	brl	r0 , r0
	
test_bal:
	bal	r6	r7
	
test_in:
	in r0
	in	r1
	in	r2
	in r3
	in r4
 in r5  
 in r6
 in r7 ; inline comment

test_out:  ; label comment
out r0
out	r1
 out	r2
	out	r3
	out	r4
	out	r5
	out	r6
	out	r7
	
test_reset:
	reset
	