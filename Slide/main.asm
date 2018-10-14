;
; TestApplication.asm
;
; Created: 10/12/2018 10:12:59 PM
; Author : Jayden
;

; Remove this line if running in Atmel Studio 7
.INCLUDE "../inc/m2560def.inc"

.cseg

; Init
call setup_leds
call setup_adc

loop:
	lds r20, ADCSRA
	ori r20, 0x40
	sts ADCSRA, r20

	wait_for_adc:
		lds r20, ADCSRA
		andi r20, 0x40
		brne wait_for_adc

	lds r26, ADCL
	lds r27, ADCH

	cpi r27, 0x03
	brlo some_button

	; ADCH is 3.

	cpi r26, 0x17		; this will have to be 0x53 for v1.1
	brlo some_button
	rjmp no_button

	no_button:
		rjmp done

	some_button:
		call lights
		rjmp done

done: rjmp loop



; subroutines

lights:	ldi r16, 0b10000000
l_loop:
	sts PORTL, r16
	call wait
	call shift
	brne l_loop
	sts PORTL, r16
	ldi r16, 0b00001000
b_loop:
	out PORTB, r16
	call wait
	call shift
	brne b_loop
	out PORTB, r16
	ret

wait:	ldi r17, 0x0F
l1:	ldi r18, 0x6F
l2:	ldi r19, 0xFF
l3:	nop
	nop
	nop
	nop
	nop
	nop
	dec r19
	brne l3
	dec r18
	brne l2
	dec r17
	brne l1
	ret

shift:
	lsr r16
	lsr r16
	ret

setup_adc:
	; configure the ADC
	ldi r20, 0x87
	sts ADCSRA, r20
	ldi r20, 0x00
	sts ADCSRB, r20
	ldi r20, 0x40
	sts ADMUX, r20
	ret

setup_leds:
	ldi r16, 0xFF
	sts DDRL, r16
	out DDRB, r16
	ret

finish:	jmp finish
