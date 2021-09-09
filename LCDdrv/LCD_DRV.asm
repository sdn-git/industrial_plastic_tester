;============================================================================
; "LCD_DRV.asm"    ; LCD writing driver for WINTEK LCM WM1602Q
;		   ; (emulation of hardware interface).
;  12/XII.02.          TMP=Data, 	XTMP=Addres
;		     PD7=RS	PD6=E
;                    PORTC=D0..D7
;If some register (TMP or XTMP) contain zero DATA (00h), then its procedure
;  (DATA or ADDRESS) has been branched.
;Линии D0..D7 работают на вывод только в П/П драйвера, затем 
;  перепрограммируются обратно на ввод.
;============================================================================
LCD_DRV:sei			;ENABLE INTERRUPTS.
	;-- LCD writing driver (emulation of hardware interface).
	;-- RE-Configuration PORT A,B I/O lines.
	;-- port A --
	push	TMP		;Store the DATAbyte to stack.
	OUTI	DDRC, 0b11111111;All lines prepare for otput.
	;
	pop	TMP		;Restore the DATAbyte from stack.
	;
	;-- Detecting an enpty ADDRESS cell.
	cpi	XTMP,$00        ;If ADDRESS cell is empty, then go to
	breq	D_LCDDRV        ;  DATA writing procedure.
	;
	;-- ADDRESS writing
	cbi	RS_PORT,P_RS	;"RS" line set to zero.
	call	DRV_DELAY	;Little pause.
	sbi	E_PORT,P_E	;"E" line set to one.
	call	DRV_DELAY	;Little pause.
	out  	DATA_PORT,XTMP	;Set the ADDRbyte to PORT_A.
	call	DRV_DELAY	;Little pause.
	cbi	E_PORT,P_E	;"E" line set to zero.
	call	DRV_DELAY	;Little pause.
	sbi	RS_PORT,P_RS	;"RS" line set to one.
	ldi	TMP,8		;Rotate pause cycle 8 times
PAUSE1:	call	DRV_DELAY	;(Wait some pause)
	dec	TMP
	brne	PAUSE1
	cbi	RS_PORT,P_RS	;"RS" line set to zero.
	;
	;-- Detecting an enpty DATA cell.
D_LCDDRV:cpi	TMP,$00 	;If DATA cell is empty,then RETURN from driver.
	breq	R_LCDDRV	;
	;
	;-- DATA writing
	sbi	RS_PORT,P_RS	;"RS" line set to one.
	call	DRV_DELAY	;Little pause.
	sbi	E_PORT,P_E	;"E" line set to one.
	call	DRV_DELAY	;Little pause.
	out  	DATA_PORT,TMP	;Set the DATAbyte to PORT_A.
	call	DRV_DELAY	;Little pause.
	cbi	E_PORT,P_E	;"E" line set to zero.
	call	DRV_DELAY	;Little pause.
	cbi	RS_PORT,P_RS	;"RS" line set to zero.
	;
R_LCDDRV:call	DRV_DELAY	;Little pause.
	;-- Configuration PORT A I/O and SPI lines to old state.
	OUTI	DDRC, 0b00000000;All lines pulled up and prepare for input.
	OUTI	PORTC,0b00000000;The lines is "Z" state.
	;
	;-------------------------------------------------------------------
DRV_DELAY:;-- LCD driver's DELAY subroutine. (one internal cycle time =0.5uS).
	push	TMP		;Store the DATAbyte to stack.
	push	XTMP		;Store the ADDRbyte to stack.
	push	ACC		;Store the ACC to stack.
	ldi	XTMP,$00        ;Delay cycle constant (HI_CONSTANT).
	;			;--- first cycle.
DRV_DELAY0:ldi	TMP,128		;Set the delay constant (LOW_CONSTANT).
	mov	ACC,TMP
DRV_DELAY1:                     ;-------- second cycle.
	dec	ACC
	mov	TMP,ACC         ;  INTERNAL CYCLE.
	cpi	TMP,$00
	brne	DRV_DELAY1	;-------- Rotate cycle until TMP=0.
	cpi	XTMP,$00
	breq	DRV_DELAY_RET
	dec	XTMP
	rjmp	DRV_DELAY0      ;--- loop of the first cycle.
DRV_DELAY_RET:
	pop	ACC		;Restore the ACC from stack.
	pop	XTMP		;Restore the ADDRbyte from stack.
	pop	TMP		;Restore the DATAbyte from stack.
	ret
	