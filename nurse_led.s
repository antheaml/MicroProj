#include <xc.inc>
    
global	ledSetup, nurse_fall, nurse_alert, nurse_remote_disable

extrn	start_fall_lcd, start_alertButton_lcd, start_disable_lcd,setup_lcd

psect	nurse_led_code,class=CODE

ledSetup: 
    ; ---- Subroutine to set up ports controlling LEDs ----
    movlw   0b11111100 ; RD0 and RD1 as output
    movwf   TRISD, A 
    movlw   0b00000000 ; all portD LEDs off
    movwf   PORTD, A
    return
	
nurse_fall:
    ; ---- Subroutine to control how nurse responds when client falls ----
    movlw   0b00000010 ; need RD1 high, rest low, triggers buzzer and red LED
    movwf   PORTD, A
    bcf	    RBIE		; Disable RB interrupt for lcd
    bcf	    GIE
    call    setup_lcd
    call    start_fall_lcd
    bsf	    RBIE		; Enable RB interrupt
    bsf	    GIE
    return
    
nurse_alert:
    ; ---- Subroutine to control how nurse responds when client presses ----
    ; ----			  distress button		        ---- 
    movlw   0b00000001 ; 
    movwf   PORTD, A ; triggers buzzer and yellow LED
    bcf	    RBIE		; Disable RB interrupt for lcd
    bcf	    GIE
    call    start_alertButton_lcd
    bsf	    RBIE		; Enable RB interrupt
    bsf	    GIE
    return
    
nurse_remote_disable:
    ; ---- Subroutine to control how nurse responds when client presses ----
    ; ----			  disable button		        ---- 
    movlw   0b00000000 ; all LEDs off, and buzzer off
    movwf   PORTD, A
    bcf	    RBIE		; Disable RB interrupt for lcd
    bcf	    GIE
    call    start_disable_lcd
    bsf	    RBIE		; Enable RB interrupt
    bsf	    GIE
    return

	