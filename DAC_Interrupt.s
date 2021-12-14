#include <xc.inc>
	
global	DAC_Setup, DAC_Int_Hi, delay, delay2
extrn	UART_Setup, uart_start

psect	udata_acs   ; reserve data space in access ram
ACC_RANGE:    ds 1   
    
    
    
    
    

    
    
    
    
IMUsetup:
	; first just allocate initial params in motherchip
	movlw	5
	movwf	ACC_RANGE, A
	movlw	7
	movwf	...
	movlw
	
	; send these somehow to IMU
    
    
    
    
    
    
    
    
    
    
    
    
    
psect udata_acs
delay_counter1:	    ds 1
delay_counter2:	    ds 1

psect	dac_code, class=CODE
	
DAC_Int_Hi: ; interrupt subroutine
	btfss	RBIF		    ; check that this is RB interrupt
	retfie	f		    ; if not then return
	call	uart_start
	bcf	RBIF		    ; clear interrupt flag
	retfie	f		    ; fast return from interrupt
	

delay: ; subroutine to prolong the LEDs staying on
    movlw	0xff
    movwf	delay_counter2, A
    call	delay2		    ;includes nested delay
    decfsz	delay_counter1, A
    bra		delay
    return
    
delay2:	; delay2 is nested in delay
    decfsz	delay_counter2, A
    bra		delay2
    return

DAC_Setup: ; set up interrupt
	movlw	0xff
	movwf	TRISB, A	    ; enable PORTB as input. when RB0 is high, interrupt is triggered
;	movlw	0x00		
;	movwf	TRISE, A	    ; enable PORTE as output
;	movwf	PORTE, A	    ; turn off LEDs
	bsf	RBIE		    ; Enable RB interrupt
	bsf	GIE		    ; Enable all interrupts
	return	
	
	end

