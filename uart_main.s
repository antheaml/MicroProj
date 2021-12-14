#include <xc.inc>

extrn	UART_Setup ; UART_Transmit_Message  ; external subroutines
	
psect	udata_acs   ; reserve data space in access ram
message:    ds 1
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	goto	start
	
	; ******* Main programme ****************************************
start: 	
    movlw	0b00000001
    movwf	message, A
    ;movlw	1 ; length of data is 1 byte
    ;movff	message, W, A  
    movwf	TXREG1, A

    end	rst
 