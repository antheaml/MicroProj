#include <xc.inc>
	
global	DAC_Setup, DAC_Int_Hi
    
extrn	nurse_fall, nurse_alert, nurse_remote_disable
        
psect udata_acs
delay_counter1:	    ds 1
delay_counter2:	    ds 1
alert_code:	    ds 1

psect	dac_code, class=CODE
	
DAC_Int_Hi:	
	btfss	RBIF		; check that this is RB interrupt
	retfie	f		; if not then return
	; logic to figure out which subroutine to call depending on signal
	movff	PORTG, alert_code
	call	check_fall
	call	check_alert_button
	call	check_disable_button
	bcf	RBIF		; clear interrupt flag
	retfie	f		; fast return from interrupt
	
check_fall:
    movlw   0b00000001
    CPFSEQ alert_code, A ; alert code is the code sent from the client to nurse, if alert_code = 1, will call nurse_fall, else will return
    return
    call    nurse_fall
    
check_alert_button:
    movlw   0b00000011
    CPFSEQ alert_code, A ; alert code is the code sent from the client to nurse, if alert_code = 2, will call nurse_fall, else will return
    return
    call    nurse_alert
    
check_disable_button:
    movlw   0b000001111
    CPFSEQ  alert_code, A ; alert code is the code sent from the client to nurse, if alert_code = 2, will call nurse_fall, else will return
    return
    call    nurse_remote_disable

delay:
    movlw	0xff
    movwf	delay_counter2, A
    call	delay2
    decfsz	delay_counter1, A
    bra		delay
    return
    
delay2:
    decfsz	delay_counter2, A
    bra		delay2
    return
    

;	
;	DAC_Int_Hi:	
;	btfss	TMR0IF		; check that this is timer0 interrupt
;	retfie	f		; if not then return
;	incf	LATJ, F, A	; increment PORTD
;	bcf	TMR0IF		; clear interrupt flag
;	retfie	f		; fast return from interrupt
DAC_Setup:
	movlw	0xff
	movwf	TRISB, A
	;bsf	TRISB,A
	;clrf	TRIS, A	; Set PORTD as all outputs
	;clrf	LATE, A		; Clear PORTD outputs
	;movlw	10000111B	; Set timer0 to 16-bit, Fosc/4/256
	;movwf	T0CON, A	; = 62.5KHz clock rate, approx 1sec rollover
	movlw	0x00
	movwf	TRISE, A
	movwf	PORTE, A
	;bcf	TRISE
	bsf	RBIE		; Enable timer0 interrupt
	bsf	GIE		; Enable all interrupts
	return
	
;DAC_Setup:
;	clrf	TRISJ, A	; Set PORTD as all outputs
;	clrf	LATJ, A		; Clear PORTD outputs
;	movlw	10000111B	; Set timer0 to 16-bit, Fosc/4/256
;	movwf	T0CON, A	; = 62.5KHz clock rate, approx 1sec rollover
;	bsf	TMR0IE		; Enable timer0 interrupt
;	bsf	GIE		; Enable all interrupts
;	return
	


