#include <xc.inc>

extrn	DAC_Setup, DAC_Int_Hi, delay, delay2, UART_Setup, uart_start

psect	code, abs
rst:	org	0x0000	; reset vector
	goto	setup

int_hi:	org	0x0008	; high vector, no low vector
	goto	DAC_Int_Hi
	
setup:	call	DAC_Setup
	call	UART_Setup
	call    uart_start
	goto	$	; Sit in infinite loop

	end	rst
