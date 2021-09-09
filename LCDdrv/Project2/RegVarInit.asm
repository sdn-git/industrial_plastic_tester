
.def	tmp			=r16
.def	xtmp		=r17
.def	RegDelayL	=r28
.def	RegDelayH	=r29
.def	CmprL		=r21
.def	CmprH		=r22
.def	Count		=r18




.equ	DataPort0	=PD0
.equ	DataPort1	=PD1
.equ	DataPort2	=PD2
.equ	DataPort3	=PD3
.equ	DataPort4	=PD4
.equ	DataPort5	=PD5
.equ	DataPort6	=PD6
.equ	DataPort7	=PD7
.equ	RSPort		=PC5
.equ	EPort		=PC4
.equ	DataPort	=PORTD
.equ    ControlPort	=PORTC


.equ	HD44780_ClearDisplay = 0b00000001;--
.equ	HD44780_ReturnHome	 = 0b00000010
;
.equ	HD44780_EntryModeSet0 = 0b00000110;---
.equ	HD44780_EntryModeSet1 = 0b00000001
.equ	HD44780_EntryModeSet2 = 0b00000001
.equ	HD44780_EntryModeSet3 = 0b00000001
;
.equ	HD44780_DisplayOnOffControl0 = 0b00001111;---
.equ	HD44780_DisplayOnOffControl1 = 0b00000001
.equ	HD44780_DisplayOnOffControl2 = 0b00000001
.equ	HD44780_DisplayOnOffControl3 = 0b00000001
;
.equ	HD44780_CursorOrDisplayShift0 = 0b00010100;---
.equ	HD44780_CursorOrDisplayShift1 = 0b00000001
.equ	HD44780_CursorOrDisplayShift2 = 0b00000001
.equ	HD44780_CursorOrDisplayShift3 = 0b00000001
;
.equ	HD44780_FunctionSet0 = 0b00111000;---
.equ	HD44780_FunctionSet1 = 0b00000001
.equ	HD44780_FunctionSet2 = 0b00000001
.equ	HD44780_FunctionSet3 = 0b00000001
;

.equ	cmd1=0b00110000
.equ	cmd2=0b00001110
.equ	cmd3=0b00000110
.equ	cmd4=0b01000000



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

