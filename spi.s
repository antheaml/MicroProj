#include <xc.inc>
    
global	SPI_MasterInit, SPI_MasterTransmit, SPI_MasterRead, read_byte1

psect	spi_data
    read_byte1: ds	1
    
psect	spi_code, class=CODE
    
SPI_MasterInit:	; Set Clock edge to negative
	bcf	CKE1	; CKE bit in SSP2STAT, 
	;MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
	movlw 	(SSP1CON1_SSPEN_MASK)|(SSP1CON1_CKP_MASK)|(SSP1CON1_SSPM1_MASK)
	movwf 	SSP1CON1, A
	; SDO2 output; SCK2 output
	bcf	TRISC, PORTC_SDO1_POSN, A	; SDO2 output #### can just wire up port e pins to port c 
	bcf	TRISC, PORTC_SCK1_POSN, A	; SCK2 output
	;bsf	TRISC, PORTC_SDI1_POSN, A
	;######### added by us
	bcf	TRISE, 0, A
	bsf	PORTE, 0, A
	;######### added by us
	return

SPI_MasterTransmit:  ; Start transmission of data (held in W)
	movwf 	SSP1BUF, A 	; write data to output buffer
Wait_Transmit:	; Wait for transmission to complete 
	btfss 	SSP1IF		; check interrupt flag to see if data has been sent
	bra 	Wait_Transmit
	bcf 	SSP1IF		; clear interrupt flag
	return

SPI_MasterRead:
	movwf	SSP1BUF, A ; send register we would like to access
Wait_Read:	; Wait for transmission + read to complete 
	btfss 	SSP1IF	; check interrupt flag to see if data has been sent
	bra 	Wait_Read
	;movff	SSP1BUF, read_byte1, A	    ; load SSP2BUF to read_byte1
Send_to_Master:
	movff	SSP1BUF, WREG, A
	bcf 	SSP1IF		; clear interrupt flag
	return