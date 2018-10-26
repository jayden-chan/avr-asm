;
; a2q1.asm
;
; Write a program that displays the binary value in r16
; on the LEDs.
;
; See the assignment PDF for details on the pin numbers and ports.
;

.INCLUDE "../../inc/m2560def.inc"

ldi r16, 0xFF
out DDRB, r16  ; PORTB all output
sts DDRL, r16  ; PORTL all output

ldi r16, 0x33  ; display the value
mov r0, r16    ; in r0 on the LEDs

; Your code here

clr r20
ldi r21, 0b10000000

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

jmp done

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
; Don't change anything below here
;
done: jmp done
