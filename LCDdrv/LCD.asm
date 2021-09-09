;============================================================================
; "LCD.asm" 	   ; LCD's buffer string processing service program.
;		   ; If system's FLASH flag is set, the show primary SCRPAGE,
;		   ;   otherwise show the secondary SCREENPAGE.
;  10/IV.02.        ; Write the string buffers to LCD module through LCD_DRV.
;============================================================================
LCD:    ;-- Copying the LCD's buffer string to LCD module.
	push	TMP		;Store working registers.
	push	XTMP
	PUSH_X
	cbr	TF,B_LCDRFRSH	;Clear the LCD refresh flag.
	;
	ldi	XTMP,$02        ;Store the SCRPAGE to XTMP.
	sbrc	SSH,F_FLASH
	ldi	XTMP,$01
	push	XTMP		; and push it to stack.
	;
	;-- Determine the processing SCREENPAGE.
	clr	TMP
	ldi	XTMP,$02        ;Return cursor to home.
	rcall	LCD_DRV		;Setup LCD
 	;
	pop	XTMP		;Restore SCREENPAGE.
	cpi	XTMP,$01	;Operation with primary SCRPAGE if F_FLASH=1
	brne	SECONDARY_SHOW
	;
	;-- SHOW THE PRIMARY SCREENPAGE.---------------------
PRIMARY_SHOW:
	LDX	SCREEN1		;Store LCD char pointer address to X
	;--Show the high string
SHOW1_H0:ld	TMP,X+		;LCD char pointer --> TMP, then  adress(X)++
	cpi	XL,low(LCD1_H15+2);Verify the end of shift address.
	brne	SHOW1_H		;Show the symbol.
	rjmp	SHOW1_LOW	;If end of H string, show the L string
SHOW1_H:clr	XTMP
	rcall	LCD_DRV		;Show the symbol.
	rjmp	SHOW1_H0	;Loop of SHOW_H0 cycle.
	;
	;--Show the low string -----------------------------------------------
SHOW1_LOW:clr	TMP		;Set the lower string address.
	ldi	XTMP,$c0
	rcall	LCD_DRV		;Setup LCD
	;
	ldi	XH,high(LCD1_L0) ;Store LCD char pointer address to X
	ldi	XL,low(LCD1_L0)
	;
SHOW1_L0:ld	TMP,X+		;LCD char pointer --> TMP, then  adress(X)++
	cpi	XL,low(LCD1_L15+2);Verify the end of shift address.
	brne	SHOW1_L		;Show the symbol.
	rjmp	LCD_QUIT	;If end of L string, QUIT.
SHOW1_L:clr	XTMP
	rcall	LCD_DRV		;Show the symbol.
	rjmp	SHOW1_L0	;Loop of SHOW_L0 cycle.
	;
	;-- SHOW THE SECONDARY SCREENPAGE.---------------------
SECONDARY_SHOW:
	LDX	SCREEN2		;Store LCD2 char pointer address to X
	;--Show the high string
SHOW2_H0:ld	TMP,X+		;LCD char pointer --> TMP, then  adress(X)++
	cpi	XL,low(LCD2_H15+2);Verify the end of shift address.
	brne	SHOW2_H		;Show the symbol.
	rjmp	SHOW2_LOW	;If end of H string, show the L string
SHOW2_H:clr	XTMP
	rcall	LCD_DRV		;Show the symbol.
	rjmp	SHOW2_H0	;Loop of SHOW_H0 cycle.
	;
	;--Show the low string -----------------------------------------------
SHOW2_LOW:
	clr	TMP		;Set the lower string address.
	ldi	XTMP,$c0
	rcall	LCD_DRV		;Setup LCD
	;
	ldi	XH,high(LCD2_L0) ;Store LCD char pointer address to X
	ldi	XL,low(LCD2_L0)
	;
SHOW2_L0:ld	TMP,X+		;LCD char pointer --> TMP, then  adress(X)++
	cpi	XL,low(LCD2_L15+2);Verify the end of shift address.
	brne	SHOW2_L		;Show the symbol.
	rjmp	LCD_QUIT	;If end of L string, QUIT.
SHOW2_L:clr	XTMP
	rcall	LCD_DRV		;Show the symbol.
	rjmp	SHOW2_L0	;Loop of SHOW_L0 cycle.
	;
	;
LCD_QUIT:;-- Quit from subroutine with restore working registers.
	POP_X
	pop	XTMP
	pop	TMP
	ret
