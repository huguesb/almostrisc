
; test file for assembler

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
	
test_li:
	li	r0, 0x1ff
	li	r1, 12
	li	r7, test_li
	li	r6, test_lw
	
test_lw:
	lw	r0, R2
	lw	r3	,r4
	
test_sw:
	sw	r1 , r5
	sw	r7, r6
	
test_brcc:
	br	r0, r0
	breq	r0, r1
	brinc	r2, r3
	brne	r6, r7
	
test_bacc:
	balt	r5, r4
	bage	r1, r3
	ba	r6, r6
	
test_bricc:
	brine	r0, test_ops

test_brl:

test_bal:

test_ops:
	
	
test_reset:
	reset
	