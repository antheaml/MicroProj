#include <xc.inc>

global	setup_lcd, start_fall_lcd, start_alertButton_lcd, start_disable_lcd


extrn	UART_Setup, UART_Transmit_Message  ; external subroutines
extrn	LCD_Setup, LCD_Write_Message
extrn   ledSetup, nurse_fall, nurse_alert, nurse_remote_disable

	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable_fall: 
	db	'F','a','l','l',' ','i','n',' ','R','o','o','m',' ','1','0','8',0x0a
					; message, plus carriage return
	myTable_l   EQU	17	; length of data
	align	2
	
myTable_disable: 
	db	'D','e','v','i','c','e',' ','i','d','l','e',0x0a
					; message, plus carriage return
	myTable_2   EQU	12	; length of data
	align	2
	
myTable_alertButton: 
	db	'H','e','l','p',' ','i','n',' ','R','o','o','m',' ','1','0','8',0x0a
					; message, plus carriage return
	myTable_3   EQU	17	; length of data
	align	2
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup_lcd

	; ******* Programme FLASH read Setup Code ***********************
setup_lcd:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	return
	;goto	start
	
	; ******* Main programme ****************************************
start_fall_lcd: 	
	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable_fall)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(myTable_fall)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(myTable_fall)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter, A		; our counter register
	goto	loop_fall_lcd
	
	
start_disable_lcd: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable_disable)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(myTable_disable)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(myTable_disable)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	myTable_2	; bytes to read
	movwf 	counter, A		; our counter register
	goto	loop_disable_lcd
	
	
start_alertButton_lcd: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable_alertButton)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(myTable_alertButton)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(myTable_alertButton)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	myTable_3	; bytes to read
	movwf 	counter, A		; our counter register
	goto	loop_alertButton_lcd
	
loop_fall_lcd: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop_fall_lcd		; keep going until finished
		
	movlw	myTable_l	; output message to UART
	lfsr	2, myArray
	call	UART_Transmit_Message

	movlw	myTable_l	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, myArray
	call	LCD_Write_Message

	goto	$		; goto current line in code

loop_disable_lcd: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop_disable_lcd		; keep going until finished
		
	movlw	myTable_2	; output message to UART
	lfsr	2, myArray
	call	UART_Transmit_Message

	movlw	myTable_2	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, myArray
	call	LCD_Write_Message

	goto	$		; goto current line in code
	
	
loop_alertButton_lcd: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop_alertButton_lcd		; keep going until finished
		
	movlw	myTable_3	; output message to UART
	lfsr	2, myArray
	call	UART_Transmit_Message

	movlw	myTable_3	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, myArray
	call	LCD_Write_Message

	goto	$		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	

