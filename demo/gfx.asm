
	; inputs :
	;	* r0 : tilemap (20*15=300 16*16 cells = 150 words)
	;	* r1 : sprite map (max 64 sprites, each 16 words-long => 1024words)
	;	
	;	* r6 = return address
	;
	; destroys : anything but r6 and r7
draw_tilemap_16:
	
	; push	r6
	dec	r7, r7
	sw	r6, r7
	
	; counter
	li	r2, 150
	
	; VGA buffer
	xor	r6, r6, r6
	
draw_tilemap_16.loop:
	; load tilemap cell (1/2)
	lw	r3, r0
	
	; find corresponding sprite data
	shr	r4, r3, 7
	shl	r4, r4, 3
	add	r4, r4, r1
	
	li	r3, 16
	
draw_tile16.loop:
	; draw it
	lw	r5, r4
	inc	r4
	sw	r5, r6
	li	r5, 20
	add	r6, r6, r5
	
	dec	r3, r3
	brine	r3, draw_tile16.loop
	
	liw	r5, 1-(16*20)
	add	r6, r6, r5
	
	; load tilemap cell (2/2)
	lw	r3, r0
	
	; find corresponding sprite data
	shl	r4, r3, 7
	shr	r4, r4, 4
	add	r4, r4, r1
	
	li	r3, 16
	
draw_tile16.loop2:
	; draw it
	lw	r5, r4
	inc	r4
	sw	r5, r6
	li	r5, 20
	add	r6, r6, r5
	
	dec	r3, r3
	brine	r3, draw_tile16.loop2
	
	inc	r6, r6
	
	dec	r2, r2
	brine	r2, draw_tilemap_16.loop
	
	; pop	r6
	lw	r6, r7
	inc	r7, r7
	
	ba	-, r6

	; inputs : 
	;	* (r0, r1) = (x / 16, y)
	;	* r2 = sprite data
	;	* r3 = sprite height / 2
	;	
	;	* r6 = return address
	;
	; destroys : anything but r6 and r7
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
	
	li	r5, 20
	
put_sprite_16_aligned.loop:
	lw	r1, r2
	inc	r2, r2
	
	sw	r1, r4
	add	r4, r4, r5
	
	dec	r3, r3
	brine	r3, put_sprite_16_aligned.loop
	
put_sprite_16_aligned.end:
	
	ba	-, r6

	; inputs : 
	;	* (r0, r1) = (x / 8, y)
	;	* r2 = sprite data
	;	* r3 = sprite height / 2
	;	
	;	* r6 = return address 
	;
	; destroys : anything but r6 and r7
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
	
	; check for sprite end (odd height, one byte "wasted")
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
	
	; check for sprite end
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
	
	; check for sprite end (odd height, one byte "wasted")
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
	
	; check for sprite end
	dec	r3, r3
	baeq	r3, r6
	
	bri	-, put_sprite_8_aligned.loop1
