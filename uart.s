#include <xc.inc>
    
global  UART_Setup, uart_start

psect	udata_acs   ; reserve data space in access ram
message:    ds 1


psect	uart_code,class=CODE
UART_Setup:
    bcf	CFGS	; point to Flash program memory  
    bsf	EEPGD 	; access Flash program memory
    bsf	    SPEN	; enable
    bcf	    SYNC	; synchronous
    bcf	    BRGH	; slow speed
    bsf	    TXEN	; enable transmit
    bcf	    BRG16	; 8-bit generator only
    movlw   103		; gives 9600 Baud rate (actually 9615)
    movwf   SPBRG1, A	; set baud rate
    bsf	    TRISC, PORTC_TX1_POSN, A	; TX1 pin is output on RC6 pin
					; must set TRISC6 to 1
    return
    
uart_start: 	
    movlw	0b00000001
    movwf	message, A
    movwf	TXREG1, A
    return
    
    end	
