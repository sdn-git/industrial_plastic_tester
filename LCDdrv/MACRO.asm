;*************************************************************************
;-------------------------------------------------------------------------
;--	S T A N D A R D	MACROS
;-------------------------------------------------------------------------
;.macro
;.endmacro
;-------------------------------------------------------------------------
.macro LDX			;Load the X-pointer with a 16 bit value
	ldi	 XL,low(@0)	;Load low byte
	ldi	XH,high(@0)	;Load high byte
.endmacro
;-------------------------------------------------------------------------
.macro LDY			;Load the Y-pointer with a 16 bit value
	ldi	 YL,low(@0)	;Load low byte
	ldi	 YH,high(@0)	;Load high byte
.endmacro
;-------------------------------------------------------------------------
.macro LDZ			;Load the Z-pointer with a 16 bit value
	ldi	 ZL,low(@0)	;Load low byte
	ldi	 ZH,high(@0)	;Load high byte
.endmacro
;-------------------------------------------------------------------------
.macro CLRX			;Clear the X-pointer
	clr	 XH		;Clear X-pointer high byte
	clr	 XL		;Clear X-pointer low byte
.endmacro
;-------------------------------------------------------------------------
.macro CLRY			;Clear the Y-pointer
	clr	 YH		;Clear Y-pointer high byte
	clr	 YL		;clear Y-pointer low byte
.endmacro
;-------------------------------------------------------------------------
.macro CLRZ			;Clear the Z-pointer
	clr	 ZH		;Clear Z-pointer high byte
	clr	 ZL		;Clear Z-pointer low byte
.endmacro
;-------------------------------------------------------------------------
.macro ADDXI			;Add an immediate to the X-pointer
	subi	XL,low(-@0)	;Add immediate low byte to XL
	sbci	XH,high(-@0)	;Add immediate high byte with carry to XH
.endmacro
;-------------------------------------------------------------------------
.macro SUBXI			;Subtract an immediate from the X-pointer
	subi	 XL,low(@0)	;Subtract immediate low byte from XL
	sbci	 XH,high(@0)	;Subtract immediate high byte with carry from XH
.endmacro
;-------------------------------------------------------------------------
.macro ADDYI			 ;Add an immediate to the Y-pointer
	subi	 YL,low(-@0)	;Add immediate low byte to YL
	sbci	YH,high(-@0)	;Add immediate high byte with carry to YH
.endmacro
;-------------------------------------------------------------------------
.macro SUBYI			;Subtract an immediate from the Y-pointer
	subi	 YL,low(@0)	;Subtract immediate low byte from YL
	sbci	 YH,high(@0)	;Subtract immediate high byte with carry from YH
.endmacro
;-------------------------------------------------------------------------
.macro ADDZI			;Add an immediate to the Z-pointer
	subi	 ZL,low(-@0)	;Add immediate low byte to ZL
	sbci	ZH,high(-@0)	;Add immediate high byte with carry to ZH
.endmacro
;-------------------------------------------------------------------------
.macro SUBZI			;Subtract an immediate from the Z-pointer
	subi	 ZL,low(@0)	;Subtract immediate low byte from ZL
	sbci	 ZH,high(@0)	;Subtract immediate high byte with carry from ZH
.endmacro
;-------------------------------------------------------------------------
.macro	 INCX			;16-bit increment X register
	subi	 XL,low(-1)
	sbci	XH,high(-1)
.endmacro
;-------------------------------------------------------------------------
.macro	 INCY			;16-bit increment Y register
	subi	 YL,low(-1)
	sbci	YH,high(-1)
.endmacro
;-------------------------------------------------------------------------
.macro	 INCZ			;16-bit increment Z register
	subi	 ZL,low(-1)
	sbci	ZH,high(-1)
.endmacro
;-------------------------------------------------------------------------
.macro	 DECX			;16-bit decrement X register
	subi	 XL,low(1)
	sbci	XH,high(1)
.endmacro
;-------------------------------------------------------------------------
.macro	 DECY			;16-bit decrement Y register
	subi	 YL,low(1)
	sbci	YH,high(1)
.endmacro
;-------------------------------------------------------------------------
.macro	 DECZ			;16-bit decrement Z register
	subi	 ZL,low(1)
	sbci	ZH,high(1)
.endmacro
;-------------------------------------------------------------------------
.macro	OUTI			;Out data to I/O register
	ldi	TMP,@1
	out	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	JB			;Jump if bit set
	sbrc	@0,@1
	rjmp	@2
.endmacro
;-------------------------------------------------------------------------
.macro	JNB			;Jump if bit cleared
	sbrs	@0,@1
	rjmp	@2
.endmacro
;-------------------------------------------------------------------------
.macro	JZ			;Jump if zero
	breq	@0
.endmacro
;-------------------------------------------------------------------------
.macro	JNZ	;Jump if not zero
	brne	@0
.endmacro
;-------------------------------------------------------------------------
.macro	DJNZ
	dec	@0
	brne	@1
.endmacro
;-------------------------------------------------------------------------
;--														 MACROS OTHER
;-------------------------------------------------------------------------
.macro	ADDZ
	add	r30,@0
	brcc	PC+2
	inc	r31
.endmacro
;--------------------------------------------------------------------
.macro	LDI_		;Immediate loading register
	ldi	TMP,@1
	mov	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	INC_IO		;Increment of I/O register
	in	TMP,@0
	inc	TMP
	out	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	DEC_IO		;Decrement of I/O register
	in	TMP,@0
	dec	TMP
	out	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_LDI		;Load Constant to SRAM address.
	ldi	TMP,@1	;Syntax S_LDI SRAM_address,Constant
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_DEC		;Decrement the SRAM byte
	lds	TMP,@0	;Syntax S_DEC SRAM_address
	dec	TMP
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_INC		;Increment the SRAM byte
	lds	TMP,@0	;Syntax S_INC SRAM_address
	inc	TMP
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_ROL		 ;Вращение влево	SRAM байта
	lds	TMP,@0	;Syntax S_ROL SRAM_address
	rol	TMP
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_ROR		;Вращение вправо	SRAM байта
	lds	TMP,@0	;Syntax S_ROR SRAM_address
	ror	TMP
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_LSL		;Сдвиг влево	SRAM байта
	lds	TMP,@0	;Syntax S_LSL SRAM_address
	lsl	TMP
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_LSR		;Сдвиг вправо	SRAM байта
	lds	TMP,@0	;Syntax S_LSR SRAM_address
	lsr	TMP
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	LSL_X	;-- Логический 16-ти разрядный сдвиг влево.
	lsl	XL
	rol	XH
.endmacro
;----------------------------------------------------------------------------
.macro	LSR_X	;-- Логический 16-ти разрядный сдвиг вправо.
	lsr	XH
	ror	XL
.endmacro
;-------------------------------------------------------------------------
.macro	LSL_Y	;-- Логический 16-ти разрядный сдвиг влево.
	lsl	YL
	rol	YH
.endmacro
;----------------------------------------------------------------------------
.macro	LSR_Y	;-- Логический 16-ти разрядный сдвиг вправо.
	lsr	YH
	ror	YL
.endmacro
;-------------------------------------------------------------------------
.macro	LSL_Z	;-- Логический 16-ти разрядный сдвиг влево.
	lsl	ZL
	rol	ZH
.endmacro
;----------------------------------------------------------------------------
.macro	LSR_Z	;-- Логический 16-ти разрядный сдвиг вправо.
	lsr	ZH
	ror	ZL
.endmacro
;-------------------------------------------------------------------------
.macro	 S_SBR		;Установка бита в SRAM ячейке
	lds	TMP,@0	;Syntax S_SBR SRAM_address,MASK
	sbr	TMP,@1
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_CBR		;Сброс бита в SRAM ячейке
	lds	TMP,@0	;Syntax S_SBR SRAM_address,MASK
	cbr	TMP,@1
	sts	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	CBR_		;CBR для младших регистров.
	mov	TMP,@0	;Syntax CBR_ reg,bit
	cbr	TMP,@1
	mov 	@0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	SBR_		;SBR для младших регистров.
	mov	TMP,@0	;Syntax SBR_ reg,bit
	sbr	TMP,@1
	mov 	@0,TMP
.endmacro

;******************************************************************************
;-------------------------------------------------------------------------
.macro	POWER_SAVE		;Activate the POWER SAVE mode (only PWMNG bits change)
	in	TMP,MCUCR	;Bits setting for SAVE mode
	sbr	TMP,0b00110000
	out	MCUCR,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	POWER_IDLE		;Activate the POWER_IDLE mode (only PWMNG bits change)
	in	TMP,MCUCR	;Bits setting for IDLE mode
	cbr	TMP,0b00110000
	out	MCUCR,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	 POWER_DOWN		;Activate the POWER DOWN mode (only PWMNG bits change)
	in	TMP,MCUCR	;Bits setting for POWER_DOWN mode
	sbr	TMP,0b00100000
	cbr	TMP,0b00010000
	out	MCUCR,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	 POWER_ON		;Deactivate all POWER SAVE modes (only PWMNG bits change)
	in	TMP,MCUCR
	cbr	TMP,0b01110000
	out	MCUCR,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	PUSH_PSW		;Сохранение PSW в стеке.
	in	TMP,SREG
	push	TMP
.endmacro
;-------------------------------------------------------------------------
.macro	POP_PSW			;Извлечение PSW из стека.
	pop	TMP
	out	SREG,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	PUSH_ALL	;Сохранение X,Y,Z,TMP,XTMP,ACC,SREG
	push	XL
	push	XH
	push	YL
	push	YH
	push	ZL
	push	ZH
	push	TMP
	push	XTMP
	in	TMP,SREG
	push	TMP
.endmacro
;-------------------------------------------------------------------------
.macro	PUSH_X		;Pushing the X register to stack
	push	XL
	push	XH
.endmacro
;-------------------------------------------------------------------------
.macro	PUSH_Y		;Pushing the Y register to stack
	push	YL
	push	YH
.endmacro

;-------------------------------------------------------------------------
.macro	PUSH_Z		;Pushing the Z register to stack
	push	ZL
	push	ZH
.endmacro
;-------------------------------------------------------------------------
.macro	POP_ALL
	pop	TMP
	out	SREG,TMP
	pop	XTMP
	pop	TMP
	pop	ZH
	pop	ZL
	pop	YH
	pop	YL
	pop	XH
	pop	XL
.endmacro
;-------------------------------------------------------------------------
.macro	POP_X		;Popping the X register from stack
	pop	XH
	pop	XL
.endmacro
;-------------------------------------------------------------------------
.macro	POP_Y		;Popping the Y register from stack
	pop	YH
	pop	YL
.endmacro
;-------------------------------------------------------------------------
.macro	POP_Z		;Popping the Z register from stack
	pop	ZH
	pop	ZL
.endmacro
;------------------- MARKERS !!! -----------------------------------------------
.macro	MARKER_FLASH	;Переключение ноги контроллера - FLASH индикатор.
			;Синтаксис: MARKER_FLASH PINx,PORTx,PIN (где PIN=0..7, x=A..F).
			;
	sbic	@0,@2 		;Регистр PIN и ножка маркера.
	rjmp	MARKER_RESET_PIN
	sbi	@1,@2		;Регистр PORT и ножка маркера.
	rjmp	MARKER_EXIT
MARKER_RESET_PIN:
	cbi	@1,@2		;Регистр PORT и ножка маркера.
	rjmp	MARKER_EXIT
MARKER_EXIT:
.endmacro
;----------------------------------
.macro	MARKER_NEEDLE		;Формирователь строб-иголки.
	;Синтаксис: MARKER_NEEDLE PORTx,PIN (где PIN=0..7, x=A..F).
	;
	sbi	@0,@1	;Регистр PORT и ножка маркера.
	nop
	nop
	nop
	cbi	@0,@1	;Регистр PORT и ножка маркера.
.endmacro

;-----------------------------------------------------------------------------
