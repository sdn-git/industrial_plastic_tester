;============================================================================
;  "CLS"	; Clear (fill by $20) the SCREEN PAGEs (LCD buffers).
;  16/V.01.
;
;registers: TMP = SCREEN PAGE 	TMP= $01 - Primary SCREENPAGE
;				TMP<>$01 - Secondary SCREENPAGE
;============================================================================
CLS:
	;--Show the high string
	;
	cpi	TMP,$01
	brne	CLS_2A     	;Operation with secondary SCRPAGE if TMP<>$01
	;
	LDX	SCREEN1		;Store LCD char pointer address to X
	rjmp	CLEAR
CLS_2A:;Operation with secondary SCREENPAGE.
	LDX	SCREEN2		;Store LCD2 char pointer address to X
	;
CLEAR:	;-- Clear the SCREENPAGE.
	ldi	XTMP,' '	;'Space' --> XTMP (filling symbol)
CLEAR_1:st	X+,XTMP		;Fill the SCREENPAGE by XTMP.
	;
	cpi	TMP,$01
	brne	CLS_2B     	;Operation with secondary SCRPAGE if TMP<>$01
	cpi	XL,low(LCD1_L15+1);Verify the end of shift address.
	breq	CLS_QUIT	;If end of H string, QUIT from subroutine.
	rjmp	CLEAR_1		;Loop of CLEAR_1 cycle.
CLS_2B:	cpi	XL,low(LCD2_L15+1);Verify the end of shift address.
	breq	CLS_QUIT	;If end of H string, QUIT from subroutine.
	rjmp	CLEAR_1		;Loop of CLEAR_1 cycle.
	;
CLS_QUIT:
	ret
	;
;============================================================================
;  "CLS_ALL"	; Clear (fill by $20) the all SCREEN PAGEs (LCD buffers).
;  12/XII.02.
;============================================================================
CLS_ALL:
	push	TMP
	;
	call	No_show_digits	;Сбросим признаки отображения числовых параметров.
	;
	ldi	TMP,$01	;Clear the primary SCREENPAGE.
	call	CLS
	ldi	TMP,$02	;Clear the secondary SCREENPAGE.
	call	CLS
	pop	TMP
	ret
	;
;============================================================================
;  "COPYSCREEN"	; Copying the primary to secondary SCREENPAGES.
;  29/III.02.
;============================================================================
COPYSCREEN:
	push	TMP
	PUSH_X
	PUSH_Y
	LDX	SCREEN1		;Store LCD char pointer address to X
	LDY	SCREEN2		;Store LCD2 char pointer address to Y
	;
COPY_BEGIN:
	ld	TMP,X+		;LCD char pointer --> TMP, then  adress(X)++
		;Copy the primary to secondary symbols.
	st	Y+,TMP
	cpi	XL,low(LCD1_L15+1);Verify the end of shift address.
	breq	COPY_BREAK	;Break the copying if address=LCD_L15+1
	rjmp	COPY_BEGIN	;Loop of copy.
COPY_BREAK:
	POP_Y
	POP_X
	pop	TMP
	ret
	;
;============================================================================
;  "LCD_INIT"	; Initializations of LCD module and move cursor to home.
;  27/X.02.
;============================================================================
LCD_INIT:;-- Initialization of LCD module and move cursor to home.
	ldi	TMP,low(SCREEN2);Set the cursor pointer to home.
	sts	S_CURPOS,TMP
	push	TMP
	push	XTMP
	ldi	TMP,$40		;PAUSE about 0.5(S).
	call	PAUSE
	clr	TMP		;Set the control operations for LCD".
	ldi	XTMP,$3c   	;Set to 8-bit operations, font=5x7, 2-lines.
	call	LCD_DRV
	ldi	XTMP,$16        ;Shift mode.
	call	LCD_DRV
	ldi	XTMP,$0c        ;Turn ON display w/o cursor.
	call	LCD_DRV
	ldi	XTMP,$01	;Clear the display and set cursor to home.
	call	LCD_DRV
	pop	XTMP
	pop	TMP
	ret
;============================================================================
