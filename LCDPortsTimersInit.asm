;/// Init MCU ports for the LCD control
LCDPortsTimersInit:

	ldi tmp,0b00000000;
	out DDRB,tmp	  ;
	ldi tmp,0b00000011
	out	PORTB,tmp

	ldi tmp,0b11111111
	out DDRA,tmp
	ldi tmp,0b00000000
	out	PORTA,tmp

	ldi tmp,0b11111111
	out DDRC,tmp
	ldi	tmp,0b00000000	
	out	PORTC,tmp

	ldi tmp,0b11111111
	out DDRD,tmp
	ldi	tmp,0b00000000	
	out	PORTD,tmp
	
;///WatchDog Initialization
	ldi	tmp,6 				
	wdr
	cli          
   
;///Timer0 initialization
T0:
	ldi	tmp,0x45		
	out	TIMSK,tmp		
	ldi	tmp,0b00000011		
	out	TCCR0,tmp		
	wdr

;///Timer1 initialization
T1:
	ldi	tmp,0b00000001
	out	TCCR1B,tmp
	
;///Timer2  Initialization
T2:	
	ldi	tmp,0b00000111		
	out	TCCR2,tmp	
	
;/// SSegment Display Initialization     				
   Pause100ms
	Bitset1:
		Set_Command_LCD	HD44780_FunctionSet0
	Pause100ms
	Bitset2:
		Set_Command_LCD	HD44780_FunctionSet0
	Pause100us
	Bitset3:
		Set_Command_LCD	HD44780_FunctionSet0
	Pause100us
		Set_Command_LCD	HD44780_FunctionSet0
		Set_Command_LCD	HD44780_DisplayOnOffControl0
		Set_Command_LCD	HD44780_ClearDisplay
		Set_Command_LCD	HD44780_EntryModeSet0		
Pause100us
		ret   
		 
Write_AddrLCD:						
	cbi	ControlPort,RSPort
	Pause100us
	sbi	ControlPort,EPort
	Pause100us
	out	DataPort,tmp
	Pause100us
	cbi	ControlPort,EPort
        Pause100us
	ret

Write_DataLCD:																		
	sbi	ControlPort,RSPort
	Pause100us
	sbi	ControlPort,EPort
	Pause100us
	out	DataPort,tmp
	Pause100us
	cbi	ControlPort,EPort
        Pause100us
ret
	
