
Macrosses:


.macro PauseDec255
Pause255clc:
	dec	XTMP
	brne Pause255clc
.endmacro



.macro SHOW_onLCD; syntax: SHOW_onLCD address,data
	ldi	TMP,@0
	sbr	TMP,0b10000000
	rcall	Write_AddrLCD
	ldi	TMP,@1
	rcall	Write_DataLCD
.endmacro

.macro Set_Command_LCD; syntax: Set_Command_LCD data
	ldi	TMP,@0
	rcall	Write_AddrLCD
.endmacro

.macro Pause100ms; программа задержки на 100 мС
#warning "added"
cli
	push tmp
	clr	xtmp
	clr	tmp
	push	tmp
  pause11:
	inc tmp
	cpi tmp,0xff
	brne	pause11
  pause12:
	pop	tmp
	inc tmp
	cpi	tmp,0xff
	brne	return1
	inc xtmp
	cpi xtmp,0x03
	brne	back1
	rjmp GoAway
  back1:
	clr	tmp
	push tmp
	rjmp  pause11
  return1:
	push tmp
	clr  tmp
	rjmp  pause11
  GoAway:
	pop tmp
#warning "added"
sei
.endmacro

.macro Pause100us;
#warning "added"
cli
	push tmp
	clr tmp
	pause11:
	   inc tmp
	   cpi tmp,0xff
	   brne	pause11
    pop tmp
#warning "added"
sei
.endmacro




;*************************************************************************
;-------------------------------------------------------------------------
;--                   S T A N D A R D  MACROS
;-------------------------------------------------------------------------
;.macro
;.endmacro
;-------------------------------------------------------------------------
.macro LDX       ;Load the X-pointer with a 16 bit value
  ldi   XL,low(@0)  ;Load low byte
  ldi  XH,high(@0)  ;Load high byte
.endmacro
;-------------------------------------------------------------------------
.macro LDY       ;Load the Y-pointer with a 16 bit value
  ldi   YL,low(@0)  ;Load low byte
  ldi   YH,high(@0)  ;Load high byte
.endmacro
;-------------------------------------------------------------------------
.macro LDZ       ;Load the Z-pointer with a 16 bit value
  ldi   ZL,low(@0)  ;Load low byte
  ldi   ZH,high(@0)  ;Load high byte
.endmacro
;-------------------------------------------------------------------------
.macro CLRX       ;Clear the X-pointer
  clr   XH    ;Clear X-pointer high byte
  clr   XL    ;Clear X-pointer low byte
.endmacro
;-------------------------------------------------------------------------
.macro CLRY       ;Clear the Y-pointer
  clr   YH    ;Clear Y-pointer high byte
  clr   YL    ;clear Y-pointer low byte
.endmacro
;-------------------------------------------------------------------------
.macro CLRZ       ;Clear the Z-pointer
  clr   ZH    ;Clear Z-pointer high byte
  clr   ZL    ;Clear Z-pointer low byte
.endmacro
;-------------------------------------------------------------------------
.macro ADDXI       ;Add an immediate to the X-pointer
        subi    XL,low(-@0)     ;Add immediate low byte to XL
        sbci    XH,high(-@0)    ;Add immediate high byte with carry to XH
.endmacro
;-------------------------------------------------------------------------
.macro SUBXI       ;Subtract an immediate from the X-pointer
  subi   XL,low(@0)  ;Subtract immediate low byte from XL
  sbci   XH,high(@0)  ;Subtract immediate high byte with carry from XH
.endmacro
;-------------------------------------------------------------------------
.macro ADDYI       ;Add an immediate to the Y-pointer
  subi   YL,low(-@0)  ;Add immediate low byte to YL
  sbci  YH,high(-@0)  ;Add immediate high byte with carry to YH
.endmacro
;-------------------------------------------------------------------------
.macro SUBYI       ;Subtract an immediate from the Y-pointer
  subi   YL,low(@0)  ;Subtract immediate low byte from YL
  sbci   YH,high(@0)  ;Subtract immediate high byte with carry from YH
.endmacro
;-------------------------------------------------------------------------
.macro ADDZI       ;Add an immediate to the Z-pointer
  subi   ZL,low(-@0)  ;Add immediate low byte to ZL
  sbci  ZH,high(-@0)  ;Add immediate high byte with carry to ZH
.endmacro
;-------------------------------------------------------------------------
.macro SUBZI       ;Subtract an immediate from the Z-pointer
  subi   ZL,low(@0)  ;Subtract immediate low byte from ZL
  sbci   ZH,high(@0)  ;Subtract immediate high byte with carry from ZH
.endmacro
;-------------------------------------------------------------------------
.macro   INCX         ;16-bit increment X register
  subi   XL,low(-1)
  sbci  XH,high(-1)
.endmacro
;-------------------------------------------------------------------------
.macro   INCY                    ;16-bit increment Y register
  subi   YL,low(-1)
  sbci  YH,high(-1)
.endmacro
;-------------------------------------------------------------------------
.macro   INCZ                    ;16-bit increment Z register
  subi   ZL,low(-1)
  sbci  ZH,high(-1)
.endmacro
;-------------------------------------------------------------------------
.macro   DECX                    ;16-bit decrement X register
  subi   XL,low(1)
  sbci  XH,high(1)
.endmacro
;-------------------------------------------------------------------------
.macro   DECY                    ;16-bit decrement Y register
  subi   YL,low(1)
  sbci  YH,high(1)
.endmacro
;-------------------------------------------------------------------------
.macro   DECZ                    ;16-bit decrement Z register
  subi   ZL,low(1)
  sbci  ZH,high(1)
.endmacro
;-------------------------------------------------------------------------
.macro  OUTI                    ;Out data to I/O register
  ldi  TMP,@1
  out  @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro  JB                      ;Jump if bit set
  sbrc  @0,@1
  rjmp  @2
.endmacro
;-------------------------------------------------------------------------
.macro  JNB                     ;Jump if bit cleared
  sbrs  @0,@1
  rjmp  @2
.endmacro
;-------------------------------------------------------------------------
.macro  JZ                      ;Jump if zero
  breq  @0
.endmacro
;-------------------------------------------------------------------------
.macro  JNZ                     ;Jump if not zero
  brne  @0
.endmacro
;-------------------------------------------------------------------------
.macro  DJNZ
  dec  @0
  brne  @1
.endmacro
;-------------------------------------------------------------------------
;--                             MACROS OTHER
;-------------------------------------------------------------------------
.macro   ADDZ
         add     r30,@0
         brcc    PC+2
         inc     r31
.endmacro
;-------------------------------------------------------------------------
.macro   LDI_            ;Immediate loading register
         ldi     TMP,@1
         mov     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   INC_IO                  ;Increment of I/O register
         in	TMP,@0
         inc	TMP
         out    @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   DEC_IO                  ;Decrement of I/O register
         in	TMP,@0
         dec	TMP
         out    @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   S_LDI           ;Load Constant to SRAM address.
         ldi     TMP,@1  ;Syntax S_LDI SRAM_address,Constant
         sts     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   S_DEC           ;Decrement the SRAM byte
         lds     TMP,@0  ;Syntax S_DEC SRAM_address
         dec     TMP
         sts     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   S_INC           ;Increment the SRAM byte
         lds     TMP,@0  ;Syntax S_INC SRAM_address
         inc     TMP
         sts     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   S_ROL           ;Вращение влево  SRAM байта
         lds     TMP,@0  ;Syntax S_ROL SRAM_address
         rol     TMP
         sts     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   S_ROR           ;Вращение вправо  SRAM байта
         lds     TMP,@0  ;Syntax S_ROR SRAM_address
         ror     TMP
         sts     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   S_LSL           ;Сдвиг влево  SRAM байта
         lds     TMP,@0  ;Syntax S_LSL SRAM_address
         lsl     TMP
         sts     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   S_LSR           ;Сдвиг вправо  SRAM байта
         lds     TMP,@0  ;Syntax S_LSR SRAM_address
         lsr     TMP
         sts     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro  LSL_X  ;-- Логический 16-ти разрядный сдвиг влево.
  lsl  XL
  rol  XH
.endmacro
;----------------------------------------------------------------------------
.macro  LSR_X  ;-- Логический 16-ти разрядный сдвиг вправо.
  lsr  XH
  ror  XL
.endmacro
;-------------------------------------------------------------------------
.macro  LSL_Y  ;-- Логический 16-ти разрядный сдвиг влево.
  lsl  YL
  rol  YH
.endmacro
;----------------------------------------------------------------------------
.macro  LSR_Y  ;-- Логический 16-ти разрядный сдвиг вправо.
  lsr  YH
  ror  YL
.endmacro
;-------------------------------------------------------------------------
.macro  LSL_Z  ;-- Логический 16-ти разрядный сдвиг влево.
  lsl  ZL
  rol  ZH
.endmacro
;----------------------------------------------------------------------------
.macro  LSR_Z  ;-- Логический 16-ти разрядный сдвиг вправо.
  lsr  ZH
  ror  ZL
.endmacro
;-------------------------------------------------------------------------
.macro   S_SBR           ;Установка бита в SRAM ячейке
         lds     TMP,@0  ;Syntax S_SBR SRAM_address,MASK
         sbr     TMP,@1
         sts     @0,TMP
.endmacro
;-------------------------------------------------------------------------
.macro	S_CBR           ;Сброс бита в SRAM ячейке
	lds     TMP,@0  ;Syntax S_SBR SRAM_address,MASK
	cbr     TMP,@1
	sts     @0,TMP
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
.macro   POWER_SAVE      ;Activate the POWER SAVE mode (only PWMNG bits change)
         in      TMP,MCUCR       ;Bits setting for SAVE mode
         sbr     TMP,0b00110000
         out     MCUCR,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   POWER_IDLE      ;Activate the POWER_IDLE mode (only PWMNG bits change)
         in      TMP,MCUCR       ;Bits setting for IDLE mode
         cbr     TMP,0b00110000
         out     MCUCR,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   POWER_DOWN      ;Activate the POWER DOWN mode (only PWMNG bits change)
         in      TMP,MCUCR       ;Bits setting for POWER_DOWN mode
         sbr     TMP,0b00100000
         cbr     TMP,0b00010000
         out     MCUCR,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   POWER_ON        ;Deactivate all POWER SAVE modes (only PWMNG bits change)
         in      TMP,MCUCR
         cbr     TMP,0b01110000
         out     MCUCR,TMP
.endmacro
;-------------------------------------------------------------------------
.macro   PUSH_PSW        ;Сохранение PSW в стеке.
         in      TMP,SREG
         push    TMP
.endmacro
;-------------------------------------------------------------------------
.macro   POP_PSW        ;Извлечение PSW из стека.
         pop     TMP
         out     SREG,TMP
.endmacro
;-------------------------------------------------------------------------
.macro  PUSH_ALL	;Сохранение X,Y,Z,TMP,XTMP,SREG
  push tmp3
  push tmp2
  push  XL
  push  XH
  push  YL
  push  YH
  push  ZL
  push  ZH
  push  TMP
  push  XTMP
  in  TMP,SREG
  push  TMP
.endmacro
;-------------------------------------------------------------------------
.macro  PUSH_X    ;Pushing the X register to stack
  push  XL
  push  XH
.endmacro
;-------------------------------------------------------------------------
.macro  PUSH_Y    ;Pushing the Y register to stack
  push  YL
  push  YH
.endmacro

;-------------------------------------------------------------------------
.macro  PUSH_Z    ;Pushing the Z register to stack
  push  ZL
  push  ZH
.endmacro
;-------------------------------------------------------------------------
.macro  POP_ALL
  pop  TMP
  out  SREG,TMP
  pop  XTMP
  pop  TMP
  pop  ZH
  pop  ZL
  pop  YH
  pop  YL
  pop  XH
  pop  XL
  pop	tmp2
  pop tmp3
.endmacro
;-------------------------------------------------------------------------
.macro  POP_X    ;Popping the X register from stack
  pop  XH
  pop  XL
.endmacro
;-------------------------------------------------------------------------
.macro  POP_Y    ;Popping the Y register from stack
  pop  YH
  pop  YL
.endmacro
;-------------------------------------------------------------------------
.macro  POP_Z    ;Popping the Z register from stack
  pop  ZH
  pop  ZL
.endmacro
;-------------------------------------------------------------------------
.macro  PUSH_MATH			;Сохранение регистров матподпрограмм
	push	DIV32_3			;Результат 32 битного деления.
	push	DIV32_2			;  .                 .                  .
	push	DIV32_1			;  .                 .                  .
	push	DIV32_0			;  .                 .                  .
	push	OPHI_RES1L		;  OPHI_RES1x  - 32 битный результат (ст.разряды).
	push	OPHI_RES1H		;      (регистры RES используются и как регистры для передачи
							;	32 битного операнда - расположение байт как в 32
							;	битном результате)
	push	OP1L			;Регистры математических П/П
	push	OP1H			;  OP1  - 16 битный операнд.
	push	OP2L_RES0L		;  OP2_RES0- 16/32 битный операнд/32 битный
	push	OP2H_RES0H		;      результат (мл.разряды).
	push	COUNTER			;  COUNTER  - счётчик циклов мат. П/П.
.endmacro
;-------------------------------------------------------------------------
.macro  POP_MATH			;Восстановление регистров матподпрограмм
	pop		COUNTER			;  COUNTER  - счётчик циклов мат. П/П.
	pop		OP2H_RES0H		;  OP2_RES0- 16/32 битный операнд/32 битный
	pop		OP2L_RES0L		;      результат (мл.разряды).
	pop		OP1H			;Регистры математических П/П
	pop		OP1L			;  OP1  - 16 битный операнд.
	pop		OPHI_RES1H		;  OPHI_RES1x  - 32 битный результат (ст.разряды).
	pop		OPHI_RES1L		;      (регистры RES используются и как регистры для передачи
							;	32 битного операнда - расположение байт как в 32
							;	битном результате)
	pop		DIV32_0			;Результат 32 битного деления.
	pop		DIV32_1			;  .                 .                  .
	pop		DIV32_2			;  .                 .                  .
	pop		DIV32_3			;  .                 .                  .
.endmacro

;------------------- MARKERS !!! -----------------------------------------------

.macro	MARKER_FLASH	;(C) VK 24/VII.06
			;Переключение ноги контроллера - FLASH индикатор.
			;Синтаксис: MARKER_FLASH PINx,PORTx,PIN (где PIN=0..7, x=A..F).
	sbic	@0,@2 	
	rjmp	MF_RESET_PIN
	sbi	@1,@2         
	rjmp	MF_EXIT
MF_RESET_PIN:
	cbi	@1,@2		
	rjmp	MF_EXIT
MF_EXIT:
.endmacro
;----------------------------------
.macro	MARKER_NEEDLE	;(C) VK 24/VII.06
			;Формирователь строб-иголки (инверсной по отношению к текущему уровню).
			;Синтаксис: MARKER_NEEDLE PINx,PORTx,PIN (где PIN=0..7, x=A..F).
	push	TMP
	ldi	TMP,5
	sbic	@0,@2 		
	rjmp	MN_inverseNeedle
	sbi	@1,@2         
MN_Pause1:dec	TMP
	brne	MN_Pause1
	cbi	@1,@2         
	rjmp	MN_EXIT
MN_inverseNeedle:
	cbi	@1,@2		
MN_Pause2:dec	TMP
	brne	MN_Pause2
	sbi	@1,@2         
	rjmp	MN_EXIT
MN_EXIT:pop	TMP
.endmacro
;----------------------------------
.macro	MARKER_nanoNEEDLE	;(C) VK 24/VII.06
			;Формирователь очень тонкой строб-иголки (инверсной по отношению к текущему уровню).
			;Синтаксис: MARKER_NEEDLE PINx,PORTx,PIN (где PIN=0..7, x=A..F).
	push	TMP
	ldi	TMP,5
	sbic	@0,@2 		
	rjmp	MnN_inverseNeedle
	sbi	@1,@2         
	cbi	@1,@2         
	rjmp	MnN_EXIT
MnN_inverseNeedle:
	cbi	@1,@2		
	sbi	@1,@2         
	rjmp	MnN_EXIT
MnN_EXIT:pop	TMP
.endmacro
;-----------------------------------------------------------------------------
.macro	MARKER_PULSE	;(C) VK 24/VII.06
			;Формирователь строб-импульса (инверсного по отношению к текущему уровню).
			;Синтаксис: MARKER_PULSE PINx,PORTx,PIN (где PIN=0..7, x=A..F).
	push	TMP
	ser	TMP
	sbic	@0,@2 		
	rjmp	MP_inverseNeedle
	sbi	@1,@2         
MP_Pause1:dec	TMP
	brne	MP_Pause1
	cbi	@1,@2         
	rjmp	MP_EXIT
MP_inverseNeedle:
	cbi	@1,@2		
MP_Pause2:dec	TMP
	brne	MP_Pause2
	sbi	@1,@2         
	rjmp	MP_EXIT
MP_EXIT:pop	TMP
.endmacro
;-----------------------------------------------------------------------------
.macro	DEBUG_PAUSE	;(C) VK 24/VII.06
			;Формирователь паузы (аргумент - количество прокрутки внутренных циклов).
			;Синтаксис: DEBUG_PAUSE 0..65535
	push	TMP
	;
	ldi	TMP,high(@0)
	push	TMP
	ldi	TMP,low(@0)
DP_Cycle:
	;--------------\
	;----------\
	push	TMP	;6 тактов
	pop	TMP	;
	dec	TMP
	brne	DP_Cycle
	;----------/
	pop	TMP
	dec	TMP
	push	TMP
	cpi	TMP,0xff
	breq	DP_Exit
	rjmp	DP_Cycle
	;--------------/
DP_Exit:pop	TMP
	;
	pop	TMP
.endmacro
;-----------------------------------------------------------------------------

.macro	SAVE_and_MASKING_ALLinterrupts	;Сохранив управляющие регистры в стеке
					;  записываем в них их же значение, (в
					;  итоге, разряды с "1" - сбросятся.
;N.B. !!! ДАННЫЙ МАКРОС ИСПОЛНЯЕТСЯ ВСЕГДА СОВМЕСТНО (ДО) С МАКРОСОМ "RESTORE_ALLinterrupts".

	in	TMP,ADCSRA	;АЦП
	push	TMP
	clr	TMP
	out	ADCSRA,TMP
	;
	in	TMP,ACSR	;Компаратор
	push	TMP
	clr	TMP
	out	ACSR,TMP
	;
	in	TMP,SPMCSR	;FLASH
	push	TMP
	clr	TMP
	out	SPMCSR,TMP
	;
	in	TMP,EECR	;EEPROM
	push	TMP
	clr	TMP
	out	EECR,TMP
	;
	in	TMP,GICR	;Внешние прерывания
	push	TMP
	clr	TMP
	out	GICR,TMP
	;
	in	TMP,SPCR	;SPI
	push	TMP
	clr	TMP
	out	SPCR,TMP
	;
	in	TMP,TIMSK	;Таймера
	push	TMP
	clr	TMP
	out	TIMSK,TMP
	;
	in	TMP,TWCR	;TWI
	push	TMP
	clr	TMP
	out	TWCR,TMP
	;
	in	TMP,UCSRB	;UART
	push	TMP
	clr	TMP
	out	UCSRB,TMP
	;
.endmacro
;--------------------
.macro	RESTORE_ALLinterrupts	;Восстанавливаем из стека контрольные регистры.
;N.B. !!! ДАННЫЙ МАКРОС ИСПОЛНЯЕТСЯ ВСЕГДА СОВМЕСТНО (ПОСЛЕ) С МАКРОСОМ "SAVE_and_MASKING_ALLinterrupts".
	pop	TMP
	out	UCSRB,TMP	;UART
	;
	pop	TMP
	out	TWCR,TMP	;TWI
	;
	pop	TMP
	out	TIMSK,TMP	;Таймера
	;
	pop	TMP
	out	SPCR,TMP	;SPI
	;
	pop	TMP
	out	GICR,TMP	;Внешние прерывания
	;
	pop	TMP
	out	EECR,TMP	;EEPROM
	;
	pop	TMP
	out	SPMCSR,TMP	;FLASH
	;
	pop	TMP
	out	ACSR,TMP	;Компаратор
	;
	pop	TMP
	out	ADCSRA,TMP	;АЦП
	;
.endmacro


