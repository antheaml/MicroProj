#include <xc.inc>

extrn	DAC_Setup, DAC_Int_Hi, ledSetup, nurse_alert, setup_lcd

psect	code, abs
	
rst:	org	0x0000	; reset vector
	goto	globalSetup

int_hi:	org	0x0008	; high vector, no low vector,
	goto	DAC_Int_Hi
	
globalSetup:	
	call	DAC_Setup
	call	ledSetup
	call	nurse_alert ; for testing
	;call	nurse_fall ; for testing
	goto	$	; Sit in infinite loop

end	rst
