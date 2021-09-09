 LCDPortsTimersInit:

	ldi tmp,0b00000000;Порт В - вход.При модернизации с включением обратить
	out DDRB,tmp	  ;RS-232 следует внимание на установку флагов(!!!)
	ldi tmp,0b00000011
	out	PORTB,tmp
;Порты A, C, D - выходы.
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

   ;WatchDog Initialization
   ;_________________________________
	ldi	tmp,6 			
   ;out	WDTCR,tmp 		
	wdr
;	cli          
   ;T0 Initialization
   
T0:
	ldi	tmp,0x45		;Load constant in registr tmp (r16)
	out	TIMSK,tmp		;Allow interrupt processing
	ldi	tmp,0b00000011		;Load constant in registr tmp (r16).Constant before is deleting<!!>
	out	TCCR0,tmp		;T0 frequency equal signal microcontroller
	wdr
	;

	;Инициализация таймера Т1
;________________________________________
T1:
	ldi	tmp,0b00000001
	out	TCCR1B,tmp
	
;T2 Initialization
;___________________________________1	
T2:	
	ldi	tmp,0b00000111		
	out	TCCR2,tmp	
/*
	
Это все нужно для вывод информации на ЖКД

;Segment Display Initialization     				;Инициализация
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
		 
Write_AddrLCD:; TMP - ADDRESS						;Запись адреса
	;ADDRESS
	cbi	ControlPort,RSPort
	Pause100us
	sbi	ControlPort,EPort
	Pause100us
	out	DataPort,tmp
	Pause100us
	cbi	ControlPort,EPort
    Pause100us
	ret

Write_DataLCD:; TMP - DATA							;Запись данных												
	;DATA
	sbi	ControlPort,RSPort
	Pause100us
	sbi	ControlPort,EPort
	Pause100us
	out	DataPort,tmp
	Pause100us
	cbi	ControlPort,EPort
    Pause100us*/
	;
	ret
	
