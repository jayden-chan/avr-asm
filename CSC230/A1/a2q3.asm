;
; a2q3.asm
;
; Write a main program that increments a counter when the buttons are pressed
;
; Use the subroutine you wrote in a2q2.asm to solve this problem.
;

; initialize the Analog to Digital conversion
.INCLUDE "../../inc/m2560def.inc"

ldi r16, 0x87
sts ADCSRA, r16
ldi r16, 0x40
sts ADMUX, r16

; initialize PORTB and PORTL for ouput
ldi        r16, 0xFF
out DDRB,r16
sts DDRL,r16

; Your code here
; make sure your code is an infinite loop

clr r0

loop:
        call check_button
        tst r24
        breq no_button
        inc r0
        ldi r20, 12
        call delay
        no_button:
        call display
        rjmp loop



done: jmp done                ; if you get here, you're doing it wrong

;
; the function tests to see if the button
; UP or SELECT has been pressed
;
; on return, r24 is set to be: 0 if not pressed, 1 if pressed
;
; this function uses registers:
;        r16
;        r17
;        r24
;
; This function could be made much better.  Notice that the a2d
; returns a 2 byte value (actually 12 bits).
;
; if you consider the word:
;         value = (ADCH << 8) +  ADCL
; then:
;
; value > 0x3E8 - no button pressed
;
; Otherwise:
; value < 0x032 - right button pressed
; value < 0x0C3 - up button pressed
; value < 0x17C - down button pressed
; value < 0x22B - left button pressed
; value < 0x316 - select button pressed
;
; This function 'cheats' because I observed
; that ADCH is 0 when the right or up button is
; pressed, and non-zero otherwise.
;
check_button:
; start a2d
lds        r16, ADCSRA
ori r16, 0x40
sts        ADCSRA, r16

; wait for it to complete
wait:
lds r16, ADCSRA
andi r16, 0x40
brne wait

; read the value
lds r16, ADCL
lds r17, ADCH

clr r24
cpi r17, 0
brne skip
ldi r24,1
skip:        ret

;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; this function uses registers:
;
;        r20
;        r21
;        r22
;
delay:
        del1:   nop
                ldi r21,0xFF
        del2:   nop
                ldi r22, 0xFF
        del3:   nop
                dec r22
                brne del3
                dec r21
                brne del2
                dec r20
                brne del1
                ret

;
; display
;
; copy your display subroutine from a2q2.asm here

; display the value in r0 on the 6 bit LED strip
;
; registers used:

; I used r20, r21, r16, and r0 because that's what I had in
; the previous part. It doesn't matter anyway since I am
; pushing the values before using them.
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

