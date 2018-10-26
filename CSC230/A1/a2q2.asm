;
; a2q2.asm
;
;
; Turn the code you wrote in a2q1.asm into a subroutine
; and then use that subroutine with the delay subroutine
; to have the LEDs count up in binary.

.INCLUDE "../../inc/m2560def.inc"

ldi r16, 0xFF
out DDRB, r16		; PORTB all output
sts DDRL, r16		; PORTL all output

; Your code here
; Be sure that your code is an infite loop

clr r0
loop:
        ldi r20, 12
        call display
        call delay
        inc r0
        rjmp loop


done: jmp done	; if you get here, you're doing it wrong

;
; display
; 
; display the value in r0 on the 6 bit LED strip
;
; registers used:
;	r0 - value to display
;
display:
        push r20
        push r21
        push r16

        clr r20
        ldi r21, 0b10000000
        mov r16, r0

        lsl r0
        lsl r0
        lsl r0
        lsl r0
        lsl r0
        lsl r0
        lsl r0

        call applyL

        lsl r0
        lsl r0
        lsl r0
        lsl r0

        call applyL

        lsl r0
        call applyL

        lsr r0
        lsr r0
        call applyL

        ldi r21, 0b00001000
        clr r20
        lsr r0
        call applyB

        lsr r0
        lsr r0
        lsr r0
        lsr r0
        call applyB

        pop r16
        pop r21
        pop r20
ret

applyL:
        and r0, r21
        or r20, r0
        sts PORTL, r20
        mov r0, r16
        lsr r21
        lsr r21
ret

applyB:
        and r0, r21
        or r20, r0
        out PORTB, r20
        mov r0, r16
        lsr r21
        lsr r21
ret
;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; registers used:
;	r20
;	r21
;	r22
;
delay:	
        del1:	nop
                ldi r21,0xFF
        del2:	nop
                ldi r22, 0xFF
        del3:	nop
                dec r22
                brne del3
                dec r21
                brne del2
                dec r20
                brne del1	
                ret
