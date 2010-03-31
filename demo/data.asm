
; VGA buffer
.org	0

; user data
.org	5824
.db "Hello World!", 0
.db "Another test", 0

; font map
.org	4800

.db	%00000000	; NUL (nothing)
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; SOH (mr. happy)
.db	%01010000
.db	%00000000
.db	%00000000
.db	%10001000
.db	%01110000
.db	%00000000
.db	%00000000

.db	%00000000	; STX (mr. grumpy)
.db	%01010000
.db	%00000000
.db	%00000000
.db	%01110000
.db	%10001000
.db	%00000000
.db	%00000000

.db	%01010000	; ETX (heart)
.db	%11111000
.db	%11111000
.db	%11111000
.db	%11111000
.db	%01110000
.db	%00100000
.db	%00000000

.db	%00100000	; EOT (diamond)
.db	%01110000
.db	%11111000
.db	%11111000
.db	%11111000
.db	%01110000
.db	%00100000
.db	%00000000

.db	%01110000	; ENQ (club)
.db	%01110000
.db	%00100000
.db	%11111000
.db	%11111000
.db	%00100000
.db	%01110000
.db	%00000000

.db	%00100000	; ACK (spade)
.db	%01110000
.db	%11111000
.db	%11111000
.db	%01110000
.db	%00100000
.db	%01110000
.db	%00000000

.db	%00000000	; BEL (bullet)
.db	%00000000
.db	%01110000
.db	%01110000
.db	%01110000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%11111000	; BS (inv bullet)
.db	%11111000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%11111000
.db	%11111000
.db	%00000000

.db	%00000000	; HT (ring)
.db	%00000000
.db	%01110000
.db	%01010000
.db	%01110000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%11111000	; LF (inv ring)
.db	%11111000
.db	%10001000
.db	%10101000
.db	%10001000
.db	%11111000
.db	%11111000
.db	%00000000

.db	%00100000	; VT (male)
.db	%01110000
.db	%10101000
.db	%00100000
.db	%01110000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%01110000	; FF (female)
.db	%10001000
.db	%01110000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00100000
.db	%00000000

.db	%00111000	; CR (quaver)
.db	%00111000
.db	%00100000
.db	%00100000
.db	%01100000
.db	%11100000
.db	%01100000
.db	%00000000

.db	%01111000	; SO (double quaver)
.db	%01111000
.db	%01001000
.db	%01011000
.db	%01011000
.db	%11000000
.db	%11000000
.db	%00000000

.db	%00000000	; SI (star)
.db	%10101000
.db	%01010000
.db	%10001000
.db	%01010000
.db	%10101000
.db	%00000000
.db	%00000000

.db	%01000000	; DLE (triangle right)
.db	%01100000
.db	%01110000
.db	%01111000
.db	%01110000
.db	%01100000
.db	%01000000
.db	%00000000

.db	%00010000	; DC1 (triangle left)
.db	%00110000
.db	%01110000
.db	%11110000
.db	%01110000
.db	%00110000
.db	%00010000
.db	%00000000

.db	%00100000	; DC2 (up/down arrows)
.db	%01110000
.db	%10101000
.db	%00100000
.db	%10101000
.db	%01110000
.db	%00100000
.db	%00000000

.db	%01010000	; DC3 (double exclamation)
.db	%01010000
.db	%01010000
.db	%01010000
.db	%00000000
.db	%01010000
.db	%01010000
.db	%00000000

.db	%01111000	; DC4 (paragraph)
.db	%11101000
.db	%11101000
.db	%01111000
.db	%00101000
.db	%00101000
.db	%00101000
.db	%00000000

.db	%01111000	; NAK (section)
.db	%11001000
.db	%10100000
.db	%01010000
.db	%00101000
.db	%10011000
.db	%11110000
.db	%00000000

.db	%00000000	; SYN (block)
.db	%00000000
.db	%00000000
.db	%00000000
.db	%11111000
.db	%11111000
.db	%11111000
.db	%00000000

.db	%00100000	; ETB (underlined up/down arrows)
.db	%01110000
.db	%00100000
.db	%00100000
.db	%01110000
.db	%00100000
.db	%11111000
.db	%00000000

.db	%00100000	; CAN (up arrow)
.db	%01110000
.db	%11111000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%00100000	; EM (down arrow)
.db	%00100000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%01110000
.db	%00100000
.db	%00000000

.db	%00000000	; SUB (right arrow)
.db	%00100000
.db	%00110000
.db	%11111000
.db	%00110000
.db	%00100000
.db	%00000000
.db	%00000000

.db	%00000000	; ESC (left arrow)
.db	%00100000
.db	%01100000
.db	%11111000
.db	%01100000
.db	%00100000
.db	%00000000
.db	%00000000

.db	%00000000	; FS (not)
.db	%00000000
.db	%01000000
.db	%01111000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; GS (left/right arrows)
.db	%00000000
.db	%01010000
.db	%11111000
.db	%01010000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; RS (triangle up)
.db	%00100000
.db	%00100000
.db	%01110000
.db	%01110000
.db	%11111000
.db	%11111000
.db	%00000000

.db	%11111000	; US (triangle down)
.db	%11111000
.db	%01110000
.db	%01110000
.db	%00100000
.db	%00100000
.db	%00000000
.db	%00000000

.db	%00000000	; space
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00100000	; exclamation point
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00000000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%01010000	; quotation mark
.db	%01010000
.db	%01010000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%01010000	; number
.db	%01010000
.db	%11111000
.db	%01010000
.db	%11111000
.db	%01010000
.db	%01010000
.db	%00000000

.db	%00100000	; dollar
.db	%01110000
.db	%10100000
.db	%01110000
.db	%00101000
.db	%01110000
.db	%00100000
.db	%00000000

.db	%11000000	; percent
.db	%11001000
.db	%00010000
.db	%00100000
.db	%01000000
.db	%10011000
.db	%00011000
.db	%00000000

.db	%01000000	; ampersand
.db	%10100000
.db	%10100000
.db	%01000000
.db	%10101000
.db	%10010000
.db	%01101000
.db	%00000000

.db	%00100000	; apostrophe
.db	%00100000
.db	%01000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00010000	; left parenthesis
.db	%00100000
.db	%01000000
.db	%01000000
.db	%01000000
.db	%00100000
.db	%00010000
.db	%00000000

.db	%01000000	; right parenthesis
.db	%00100000
.db	%00010000
.db	%00010000
.db	%00010000
.db	%00100000
.db	%01000000
.db	%00000000

.db	%10101000	; asterisk
.db	%01110000
.db	%10101000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; plus
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00100000
.db	%00100000
.db	%00000000
.db	%00000000

.db	%00000000	; comma
.db	%00000000
.db	%00000000
.db	%00000000
.db	%01100000
.db	%00100000
.db	%01000000
.db	%00000000

.db	%00000000	; minus
.db	%00000000
.db	%00000000
.db	%11111000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; period
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%01100000
.db	%01100000
.db	%00000000

.db	%00000000	; virgule
.db	%00001000
.db	%00010000
.db	%00100000
.db	%01000000
.db	%10000000
.db	%00000000
.db	%00000000

.db	%01110000	; zero
.db	%10001000
.db	%10011000
.db	%10101000
.db	%11001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00100000	; one
.db	%11100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00000000

.db	%01110000	; two
.db	%10001000
.db	%00001000
.db	%00110000
.db	%01000000
.db	%10000000
.db	%11111000
.db	%00000000

.db	%01110000	; three
.db	%10001000
.db	%00001000
.db	%00110000
.db	%00001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%10001000	; four
.db	%10001000
.db	%10001000
.db	%11111000
.db	%00001000
.db	%00001000
.db	%00001000
.db	%00000000

.db	%11111000	; five
.db	%10000000
.db	%11110000
.db	%00001000
.db	%00001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%01110000	; six
.db	%10000000
.db	%10000000
.db	%11110000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%11111000	; seven
.db	%00001000
.db	%00001000
.db	%00010000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%01110000	; eight
.db	%10001000
.db	%10001000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%01110000	; nine
.db	%10001000
.db	%10001000
.db	%01111000
.db	%00001000
.db	%00001000
.db	%01110000
.db	%00000000

.db	%00000000	; colon
.db	%01100000
.db	%01100000
.db	%00000000
.db	%01100000
.db	%01100000
.db	%00000000
.db	%00000000

.db	%00000000	; semicolon
.db	%01100000
.db	%01100000
.db	%00000000
.db	%01100000
.db	%00100000
.db	%01000000
.db	%00000000

.db	%00010000	; less than
.db	%00100000
.db	%01000000
.db	%10000000
.db	%01000000
.db	%00100000
.db	%00010000
.db	%00000000

.db	%00000000	; equals
.db	%00000000
.db	%11111000
.db	%00000000
.db	%11111000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%01000000	; greater than
.db	%00100000
.db	%00010000
.db	%00001000
.db	%00010000
.db	%00100000
.db	%01000000
.db	%00000000

.db	%01110000	; question mark
.db	%10001000
.db	%00001000
.db	%00010000
.db	%00100000
.db	%00000000
.db	%00100000
.db	%00000000

.db	%01110000	; at
.db	%10001000
.db	%10011000
.db	%10101000
.db	%10011000
.db	%10000000
.db	%01110000
.db	%00000000

.db	%00100000	; A
.db	%00100000
.db	%01010000
.db	%01110000
.db	%01010000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%11110000	; B
.db	%10001000
.db	%10001000
.db	%11110000
.db	%10001000
.db	%10001000
.db	%11110000
.db	%00000000

.db	%01110000	; C
.db	%10001000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%11110000	; D
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%11110000
.db	%00000000

.db	%11111000	; E
.db	%10000000
.db	%10000000
.db	%11110000
.db	%10000000
.db	%10000000
.db	%11111000
.db	%00000000

.db	%11111000	; F
.db	%10000000
.db	%10000000
.db	%11110000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%00000000

.db	%01110000	; G
.db	%10001000
.db	%10000000
.db	%10111000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%10001000	; H
.db	%10001000
.db	%10001000
.db	%11111000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%11111000	; I
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00000000

.db	%00001000	; J
.db	%00001000
.db	%00001000
.db	%00001000
.db	%00001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%10001000	; K
.db	%10010000
.db	%10100000
.db	%11000000
.db	%10100000
.db	%10010000
.db	%10001000
.db	%00000000

.db	%10000000	; L
.db	%10000000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%11111000
.db	%00000000

.db	%10001000	; M
.db	%11011000
.db	%10101000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%10001000	; N
.db	%11001000
.db	%10101000
.db	%10011000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%01110000	; O
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%11110000	; P
.db	%10001000
.db	%10001000
.db	%11110000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%00000000

.db	%01110000	; Q
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10101000
.db	%10010000
.db	%01101000
.db	%00000000

.db	%11110000	; R
.db	%10001000
.db	%10001000
.db	%11110000
.db	%10010000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%01110000	; S
.db	%10001000
.db	%10000000
.db	%01110000
.db	%00001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%11111000	; T
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%10001000	; U
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%10001000	; V
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01010000
.db	%00100000
.db	%00000000

.db	%10001000	; W
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10101000
.db	%11011000
.db	%10001000
.db	%00000000

.db	%10001000	; X
.db	%10001000
.db	%01010000
.db	%00100000
.db	%01010000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%10001000	; Y
.db	%10001000
.db	%10001000
.db	%01010000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%11111000	; Z
.db	%00001000
.db	%00010000
.db	%00100000
.db	%01000000
.db	%10000000
.db	%11111000
.db	%00000000

.db	%01110000	; left bracket
.db	%01000000
.db	%01000000
.db	%01000000
.db	%01000000
.db	%01000000
.db	%01110000
.db	%00000000

.db	%00000000	; backslash
.db	%10000000
.db	%01000000
.db	%00100000
.db	%00010000
.db	%00001000
.db	%00000000
.db	%00000000

.db	%01110000	; right bracket
.db	%00010000
.db	%00010000
.db	%00010000
.db	%00010000
.db	%00010000
.db	%01110000
.db	%00000000

.db	%00100000	; caret
.db	%01010000
.db	%10001000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; underscore
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%11111000
.db	%00000000

.db	%00000000	; prime
.db	%00010000
.db	%00100000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; a
.db	%00000000
.db	%01110000
.db	%00001000
.db	%01111000
.db	%10001000
.db	%01111000
.db	%00000000

.db	%10000000	; b
.db	%10000000
.db	%10000000
.db	%11110000
.db	%10001000
.db	%10001000
.db	%11110000
.db	%00000000

.db	%00000000	; c
.db	%00000000
.db	%01110000
.db	%10001000
.db	%10000000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00001000	; d
.db	%00001000
.db	%00001000
.db	%01111000
.db	%10001000
.db	%10001000
.db	%01111000
.db	%00000000

.db	%00000000	; e
.db	%00000000
.db	%01110000
.db	%10001000
.db	%11111000
.db	%10000000
.db	%01111000
.db	%00000000

.db	%00110000	; f
.db	%01001000
.db	%01000000
.db	%11100000
.db	%01000000
.db	%01000000
.db	%01000000
.db	%00000000

.db	%00000000	; g
.db	%00000000
.db	%01111000
.db	%10001000
.db	%01111000
.db	%00001000
.db	%11110000
.db	%00000000

.db	%10000000	; h
.db	%10000000
.db	%10000000
.db	%11110000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%00000000	; i
.db	%00100000
.db	%00000000
.db	%01100000
.db	%00100000
.db	%00100000
.db	%01110000
.db	%00000000

.db	%00000000	; j
.db	%00010000	
.db	%00000000
.db	%00010000
.db	%00010000
.db	%10010000
.db	%01100000
.db	%00000000

.db	%10000000	; k
.db	%10000000
.db	%10010000
.db	%10100000
.db	%11000000
.db	%10100000
.db	%10011000
.db	%00000000

.db	%01100000	; l
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%01110000
.db	%00000000

.db	%00000000	; m
.db	%00000000
.db	%11010000
.db	%10101000
.db	%10101000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%00000000	; n
.db	%00000000
.db	%10110000
.db	%11001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%00000000	; o
.db	%00000000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00000000	; p
.db	%00000000
.db	%11110000
.db	%10001000
.db	%11110000
.db	%10000000
.db	%10000000
.db	%00000000

.db	%00000000	; q
.db	%00000000
.db	%01111000
.db	%10001000
.db	%01111000
.db	%00001000
.db	%00001000
.db	%00000000

.db	%00000000	; r
.db	%00000000
.db	%10110000
.db	%11001000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%00000000

.db	%00000000	; s
.db	%00000000
.db	%01111000
.db	%10000000
.db	%01110000
.db	%00001000
.db	%11110000
.db	%00000000

.db	%01000000	; t
.db	%01000000
.db	%11100000
.db	%01000000
.db	%01000000
.db	%01001000
.db	%00110000
.db	%00000000

.db	%00000000	; u
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10011000
.db	%01101000
.db	%00000000

.db	%00000000	; v
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01010000
.db	%00100000
.db	%00000000

.db	%00000000	; w
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10101000
.db	%01010000
.db	%00000000

.db	%00000000	; x
.db	%00000000
.db	%10001000
.db	%01010000
.db	%00100000
.db	%01010000
.db	%10001000
.db	%00000000

.db	%00000000	; y
.db	%00000000
.db	%10001000
.db	%01010000
.db	%00100000
.db	%01000000
.db	%10000000
.db	%00000000

.db	%00000000	; z
.db	%00000000
.db	%11111000
.db	%00010000
.db	%00100000
.db	%01000000
.db	%11111000
.db	%00000000

.db	%00011000	; left brace
.db	%00100000
.db	%00100000
.db	%01000000
.db	%00100000
.db	%00100000
.db	%00011000
.db	%00000000

.db	%00100000	; pipe
.db	%00100000
.db	%00100000
.db	%00000000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%01100000	; right brace
.db	%00010000
.db	%00010000
.db	%00001000
.db	%00010000
.db	%00010000
.db	%01100000
.db	%00000000

.db	%00000000	; swung dash
.db	%00000000
.db	%01000000
.db	%10101000
.db	%00010000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; DEL (triangle)
.db	%00100000
.db	%01010000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%11111000
.db	%00000000

.db	%01110000	; C CEDILLA
.db	%10001000
.db	%10000000
.db	%10001000
.db	%01110000
.db	%00100000
.db	%11000000
.db	%00000000

.db	%00000000	; c cedilla
.db	%01110000
.db	%10000000
.db	%10001000
.db	%01110000
.db	%00100000
.db	%11000000
.db	%00000000

.db	%00010100	;82 N TILDE
.db	%01001000
.db	%10001000
.db	%11001000
.db	%10101000
.db	%10011000
.db	%10001000
.db	%00000000

.db	%00101000	;83 n tilde
.db	%01010000
.db	%00000000
.db	%10110000
.db	%11001000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%00010000	; A ACUTE
.db	%00100000
.db	%01110000
.db	%10001000
.db	%11111000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%01000000	; A GRAVE
.db	%00100000
.db	%01110000
.db	%10001000
.db	%11111000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%01010000	; A DIAERESIS
.db	%00000000
.db	%01110000
.db	%10001000
.db	%11111000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%00100000	; A CIRCUMFLEX
.db	%01010000
.db	%00000000
.db	%01110000
.db	%10001000
.db	%11111000
.db	%10001000
.db	%00000000

.db	%00010000	; E ACUTE
.db	%00100000
.db	%11111000
.db	%10000000
.db	%11110000
.db	%10000000
.db	%11111000
.db	%00000000

.db	%01000000	; E GRAVE
.db	%00100000
.db	%11111000
.db	%10000000
.db	%11110000
.db	%10000000
.db	%11111000
.db	%00000000

.db	%01010000	; E DIAERESIS
.db	%00000000
.db	%11111000
.db	%10000000
.db	%11110000
.db	%10000000
.db	%11111000
.db	%00000000

.db	%00100000	; E CIRCUMFLEX
.db	%01010000
.db	%11111000
.db	%10000000
.db	%11110000
.db	%10000000
.db	%11111000
.db	%00000000

.db	%00010000	; I ACUTE
.db	%00100000
.db	%11111000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00000000

.db	%01000000	; I GRAVE
.db	%00100000
.db	%11111000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00000000

.db	%01010000	; I DIAERESIS
.db	%00000000
.db	%11111000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00000000

.db	%00100000	; I CIRCUMFLEX
.db	%01010000
.db	%11111000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00000000

.db	%00010000	; O ACUTE
.db	%00100000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%01000000	; O GRAVE
.db	%00100000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%01010000	; O DIAERESIS
.db	%00000000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00100000	; O CIRCUMFLEX
.db	%01010000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00010000	; U ACUTE
.db	%00100000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%01000000	; U GRAVE
.db	%00100000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%01010000	; U DIAERESIS
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00100000	; U CIRCUMFLEX
.db	%01010000
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00010000	; a acute
.db	%00100000
.db	%01110000
.db	%00001000
.db	%01111000
.db	%10001000
.db	%01111000
.db	%00000000

.db	%01000000	; a grave
.db	%00100000
.db	%01110000
.db	%00001000
.db	%01111000
.db	%10001000
.db	%01111000
.db	%00000000

.db	%01010000	; a diaeresis
.db	%00000000
.db	%01110000
.db	%00001000
.db	%01111000
.db	%10001000
.db	%01111000
.db	%00000000

.db	%00100000	; a circumflex
.db	%01010000
.db	%01110000
.db	%00001000
.db	%01111000
.db	%10001000
.db	%01111000
.db	%00000000

.db	%00010000	;e acute
.db	%00100000
.db	%01111000
.db	%10000100
.db	%11111100
.db	%10000000
.db	%01111100
.db	%00000000

.db	%00100000	; e grave
.db	%00010000
.db	%01111000
.db	%10000100
.db	%11111100
.db	%10000000
.db	%01111100
.db	%00000000

.db	%01010000	; e diaeresis
.db	%00000000
.db	%01111000
.db	%10000100
.db	%11111100
.db	%10000000
.db	%01111100
.db	%00000000

.db	%00100000	; e circumflex
.db	%01010000
.db	%01111000
.db	%10000100
.db	%11111100
.db	%10000000
.db	%01111100
.db	%00000000

.db	%00010000	; i acute
.db	%00100000
.db	%00000000
.db	%01100000
.db	%00100000
.db	%00100000
.db	%01110000
.db	%00000000

.db	%01000000	; i grave
.db	%00100000
.db	%00000000
.db	%01100000
.db	%00100000
.db	%00100000
.db	%01110000
.db	%00000000

.db	%00000000	; i diaeresis
.db	%01010000
.db	%00000000
.db	%01100000
.db	%00100000
.db	%00100000
.db	%01110000
.db	%00000000

.db	%00100000	; i circumflex
.db	%01010000
.db	%00000000
.db	%01100000
.db	%00100000
.db	%00100000
.db	%01110000
.db	%00000000

.db	%00010000	; o acute
.db	%00100000
.db	%00000000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%01000000	; o grave
.db	%00100000
.db	%00000000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00000000	; o diaeresis
.db	%01010000
.db	%00000000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00100000	; o circumflex
.db	%01010000
.db	%00000000
.db	%01110000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00010000	; u acute
.db	%00100000
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10011000
.db	%01101000
.db	%00000000

.db	%01000000	; u grave
.db	%00100000
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10011000
.db	%01101000
.db	%00000000

.db	%00000000	; u diaeresis
.db	%01010000
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10011000
.db	%01101000
.db	%00000000

.db	%00100000	; u circumflex
.db	%01010000
.db	%00000000
.db	%10001000
.db	%10001000
.db	%10011000
.db	%01101000
.db	%00000000

.db	%01010000	; Y DIAERESIS
.db	%00000000
.db	%10001000
.db	%01010000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%01010000	; y diaeresis
.db	%00000000
.db	%10001000
.db	%01010000
.db	%00100000
.db	%01000000
.db	%10000000
.db	%00000000

.db	%00100000	; inv question mark
.db	%00000000
.db	%00100000
.db	%01000000
.db	%10000000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00100000	; inv exclamation point
.db	%00100000
.db	%00000000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%00000000	; left european quote
.db	%00000000
.db	%01001000
.db	%10010000
.db	%01001000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	; right european quote
.db	%00000000
.db	%10010000
.db	%01001000
.db	%10010000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%10001000	; sparse fill
.db	%00100010
.db	%10001000
.db	%00100010
.db	%10001000
.db	%00100010
.db	%10001000
.db	%00100010

.db	%10101010	; medium fill
.db	%01010101
.db	%10101010
.db	%01010101
.db	%10101010
.db	%01010101
.db	%10101010
.db	%01010100

.db	%11001100	; dense fill
.db	%11111111
.db	%00110011
.db	%11001100
.db	%11111111
.db	%00110011
.db	%11001100
.db	%11111111

.db	%00110000	;B5 n/s
.db	%00110000
.db	%00110000
.db	%00110000
.db	%00110000
.db	%00110000
.db	%00110000
.db	%00110000

.db	%00000000	;B6 w/e
.db	%00000000
.db	%00000000
.db	%11111100
.db	%11111100
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00110000	;B7 n/e
.db	%00110000
.db	%00110000
.db	%00111100
.db	%00111100
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00110000	;B8 n/w
.db	%00110000
.db	%00110000
.db	%11110000
.db	%11110000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	;B9 e/s
.db	%00000000
.db	%00000000
.db	%00111100
.db	%00111100
.db	%00110000
.db	%00110000
.db	%00110000

.db	%00000000	;BA w/s
.db	%00000000
.db	%00000000
.db	%11110000
.db	%11110000
.db	%00110000
.db	%00110000
.db	%00110000

.db	%00110000	;BB n/w/s
.db	%00110000
.db	%00110000
.db	%11110000
.db	%11110000
.db	%00110000
.db	%00110000
.db	%00110000

.db	%00110000	;BC n/w/e
.db	%00110000
.db	%00110000
.db	%11111100
.db	%11111100
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00110000	;BD n/e/s
.db	%00110000
.db	%00110000
.db	%00111100
.db	%00111100
.db	%00110000
.db	%00110000
.db	%00110000

.db	%00000000	;BE w/e/s
.db	%00000000
.db	%00000000
.db	%11111100
.db	%11111100
.db	%00110000
.db	%00110000
.db	%00110000

.db	%00110000	;BF n/w/e/s
.db	%00110000
.db	%00110000
.db	%11111100
.db	%11111100
.db	%00110000
.db	%00110000
.db	%00110000

.db	%00110000	;C0 n
.db	%00110000
.db	%00110000
.db	%00110000
.db	%00110000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	;C1 w
.db	%00000000
.db	%00000000
.db	%11110000
.db	%11110000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	;C2 e
.db	%00000000
.db	%00000000
.db	%00111100
.db	%00111100
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	;C3 s
.db	%00000000
.db	%00000000
.db	%00110000
.db	%00110000
.db	%00110000
.db	%00110000
.db	%00110000

.db	%11111100	;C4 block 1
.db	%10000100
.db	%10000100
.db	%10000100
.db	%10000100
.db	%10000100
.db	%10000100
.db	%11111100

.db	%11111100	;C5 block 2
.db	%11111100
.db	%11001100
.db	%11001100
.db	%11001100
.db	%11001100
.db	%11111100
.db	%11111100

.db	%11111100	;C6 block 3
.db	%11111100
.db	%11111100
.db	%11111100
.db	%11111100
.db	%11111100
.db	%11111100
.db	%11111100

.db	%11111100	;C7 top half block
.db	%11111100
.db	%11111100
.db	%11111100
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%11100000	;C8 left half block
.db	%11100000
.db	%11100000
.db	%11100000
.db	%11100000
.db	%11100000
.db	%11100000
.db	%11100000

.db	%00011100	;C9 right half block
.db	%00011100
.db	%00011100
.db	%00011100
.db	%00011100
.db	%00011100
.db	%00011100
.db	%00011100

.db	%00000000	;CA bottom half block
.db	%00000000
.db	%00000000
.db	%00000000
.db	%11111100
.db	%11111100
.db	%11111100
.db	%11111100

.db	%00000000	;CB alpha
.db	%00000000
.db	%01101000
.db	%10010000
.db	%10010000
.db	%10010000
.db	%01101000
.db	%00000000

.db	%00110000	;CC beta
.db	%01001000
.db	%01001000
.db	%01110000
.db	%01001000
.db	%01101000
.db	%01010000
.db	%00000000

.db	%00000000	;CD GAMMA
.db	%11111000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%10000000
.db	%00000000

.db	%00000000	;CE gamma
.db	%01000000
.db	%10101000
.db	%00010000
.db	%00010000
.db	%00010000
.db	%00010000
.db	%00000000

.db	%00100000	;CF DELTA
.db	%00100000
.db	%01010000
.db	%01010000
.db	%10001000
.db	%10001000
.db	%11111000
.db	%00000000

.db	%01110000	;D0 delta
.db	%10001000
.db	%01100000
.db	%00010000
.db	%01110000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00000000	;D1 epsilon
.db	%00000000
.db	%01111000
.db	%10000000
.db	%11111000
.db	%10000000
.db	%01111000
.db	%00000000

.db	%00100000	;D2 zeta
.db	%00011000
.db	%00100000
.db	%01000000
.db	%00110000
.db	%00001000
.db	%01110000
.db	%00000000

.db	%01110000	;D3 theta
.db	%10001000
.db	%10001000
.db	%11111000
.db	%10001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%00000000	;D4 iota
.db	%00000000
.db	%11000000
.db	%01000000
.db	%01000000
.db	%01010000
.db	%00100000
.db	%00000000

.db	%00100000	;D5 LAMBDA
.db	%00100000
.db	%01010000
.db	%01010000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%00000000	;D6 lambda
.db	%11000000
.db	%00100000
.db	%00100000
.db	%01010000
.db	%01001000
.db	%10001000
.db	%00000000

.db	%00000000	;D7 mu
.db	%00000000
.db	%10010000
.db	%10000000
.db	%10010000
.db	%11111000
.db	%10000000
.db	%00000000

.db	%00000000	;D8 PI
.db	%11111000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%00000000	;D9 pi
.db	%00000000
.db	%00000000
.db	%11111000
.db	%01010000
.db	%01010000
.db	%01010000
.db	%00000000

.db	%11111100	;DA SIGMA
.db	%01000000
.db	%00100000
.db	%00010000
.db	%00100000
.db	%01000000
.db	%11111000
.db	%00000000

.db	%00000000	;DB sigma
.db	%00000000
.db	%01111000
.db	%10010000
.db	%10010000
.db	%10010000
.db	%01100000
.db	%00000000

.db	%00000000	;DC tau
.db	%00000000
.db	%01111000
.db	%10100000
.db	%00100000
.db	%00100000
.db	%00011000
.db	%00000000

.db	%00100000	;DD phi
.db	%00100000
.db	%01110000
.db	%10101000
.db	%01110000
.db	%00100000
.db	%00100000
.db	%00000000

.db	%10000000	;DE chi
.db	%01001000
.db	%01010000
.db	%00100000
.db	%01010000
.db	%10010000
.db	%00001000
.db	%00000000

.db	%00000000	;DF OMEGA
.db	%01110000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%01010000
.db	%11011000
.db	%00000000

.db	%00000000	;E0 equivalent
.db	%11111000
.db	%00000000
.db	%11111000
.db	%00000000
.db	%11111000
.db	%00000000
.db	%00000000

.db	%00000000	;E1 plus/minus
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00100000
.db	%00100000
.db	%11111000
.db	%00000000

.db	%11000000	;E2 greater than/equal to
.db	%00110000
.db	%00001000
.db	%00110000
.db	%11000000
.db	%00000000
.db	%11111000
.db	%00000000

.db	%00011000	;E3 less than/equal to
.db	%01100000
.db	%10000000
.db	%01100000
.db	%00011000
.db	%00000000
.db	%11111000
.db	%00000000

.db	%00000000	;E4 obelus
.db	%00100000
.db	%00000000
.db	%11111000
.db	%00000000
.db	%00100000
.db	%00000000
.db	%00000000

.db	%00110000	;E5 degrees
.db	%01001000
.db	%00110000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%00000000	;E6 radical
.db	%00011000
.db	%00010000
.db	%00010000
.db	%10010000
.db	%01010000
.db	%00100000
.db	%00000000

.db	%01100000	;E7 square
.db	%00010000
.db	%00100000
.db	%01110000
.db	%00000000
.db	%00000000
.db	%00000000
.db	%00000000

.db	%01110000	;E8 double-s
.db	%10001000
.db	%10001000
.db	%10010000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10110000

.db	%00000000	;E9 cent
.db	%00100000
.db	%01110000
.db	%10100000
.db	%10100000
.db	%01110000
.db	%00100000
.db	%00000000

.db	%00111100	;EA AE LIGATURE
.db	%01010000
.db	%10010000
.db	%11111100
.db	%10010000
.db	%10010000
.db	%10011100
.db	%00000000

.db	%01111100	;EB OE LIGATURE
.db	%10010000
.db	%10010000
.db	%10011100
.db	%10010000
.db	%10010000
.db	%01111100
.db	%00000000

.db	%01110000	;EC pound
.db	%10001000
.db	%10000000
.db	%11110000
.db	%01000000
.db	%01000000
.db	%11111000
.db	%00000000

.db	%10001000	;ED yen
.db	%10001000
.db	%01010000
.db	%11111000
.db	%00100000
.db	%11111000
.db	%00100000
.db	%00000000

.db	%00010000	;EE long-s
.db	%00101000
.db	%00100000
.db	%00100000
.db	%00100000
.db	%10100000
.db	%01000000
.db	%00000000

.db	%11111000	;EF B
.db	%10000000
.db	%10000000
.db	%11110000
.db	%10001000
.db	%10001000
.db	%11110000
.db	%00000000

.db	%11110000	;F0 D
.db	%01010000
.db	%01010000
.db	%10010000
.db	%10010000
.db	%11111000
.db	%10001000
.db	%00000000

.db	%10101000	;F1 ZH
.db	%10101000
.db	%01110000
.db	%10101000
.db	%10101000
.db	%10101000
.db	%10101000
.db	%00000000

.db	%01110000	;F2 Z
.db	%10001000
.db	%00001000
.db	%00110000
.db	%00001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%10001000	;F3 I
.db	%10001000
.db	%11001000
.db	%10101000
.db	%10011000
.db	%10001000
.db	%10001000
.db	%00000000

.db	%01010000	;F4
.db	%00100000
.db	%10001000
.db	%11001000
.db	%10101000
.db	%10011000
.db	%10001000
.db	%00000000

.db	%01111000	;F5 L
.db	%01001000
.db	%01001000
.db	%01001000
.db	%01001000
.db	%01001000
.db	%11001000
.db	%00000000

.db	%10001000	;F6 TS
.db	%10001000
.db	%10001000
.db	%10001000
.db	%10001000
.db	%11111000
.db	%00001000
.db	%00000000

.db	%10001000	;F7 CH
.db	%10001000
.db	%10001000
.db	%01111000
.db	%00001000
.db	%00001000
.db	%00001000
.db	%00000000

.db	%10101000	;F8 SH
.db	%10101000
.db	%10101000
.db	%10101000
.db	%10101000
.db	%10101000
.db	%11111000
.db	%00000000

.db	%10101000	;F9 SHCH
.db	%10101000
.db	%10101000
.db	%10101000
.db	%10101000
.db	%11111000
.db	%00001000
.db	%00000000

.db	%11000000	;FA UNPALATIZE
.db	%01000000
.db	%01000000
.db	%01110000
.db	%01001000
.db	%01001000
.db	%01110000
.db	%00000000

.db	%10001000	;FB Y
.db	%10001000
.db	%10001000
.db	%11101000
.db	%10011000
.db	%10011000
.db	%11101000
.db	%00000000

.db	%10000000	;FC PALATIZE
.db	%10000000
.db	%10000000
.db	%11110000
.db	%10001000
.db	%10001000
.db	%11110000
.db	%00000000

.db	%01110000	;FD E
.db	%10001000
.db	%00001000
.db	%01111000
.db	%00001000
.db	%10001000
.db	%01110000
.db	%00000000

.db	%10010000	;FE YU
.db	%10101000
.db	%10101000
.db	%11101000
.db	%10101000
.db	%10101000
.db	%10010000
.db	%00000000

.db	%01111000	;FF YA
.db	%10001000
.db	%10001000
.db	%01111000
.db	%01001000
.db	%10001000
.db	%10001000
.db	%00000000
