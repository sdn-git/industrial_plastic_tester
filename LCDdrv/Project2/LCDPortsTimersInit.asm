 LCDPortsTimersInit:
 
  ;Ports Initialization
	;________________________________
	ser tmp
	out DDRD,tmp; ports D, C are outputs
	out DDRC,tmp
	out PORTB, tmp
	clr	tmp
	out	PORTD,tmp
	out	PORTC,tmp
	out DDRB,tmp ;port B is input
   ;WatchDog Initialization
   ;_________________________________
	ldi	tmp,6 			
   ;out	WDTCR,tmp 		
	wdr
	cli          
   ;T0 Initialization
   ;_________________________________
T0:
	ldi	tmp,2			
	out	TIMSK,tmp	
	ldi	tmp,0b00000001		
	out	TCCR0,tmp		

	;T1 Initialization
;____________________________________
T1:
	ldi	tmp,0x82
	out	TIMSK,tmp
	ldi	tmp,1
	out	TCCR1B,tmp
	
;T2 Initialization
;___________________________________	
T2:	
	ldi	tmp,2			
	out	TIMSK,tmp	
	ldi	tmp,0b00000001		
	out	TCCR2,tmp	

;Clear all register
    clr	Count
	clr tmp		
	clr RegDelayL	
	clr RegDelayH	
	clr CmprL		
	clr CmprH		
	clr Count		

;Segment Display Initialization
	pause1:
     	adiw	RegDelayL,1
	    ldi	CmprL,low(1000)
	    ldi CmprH,high(1000)
	    cp	RegDelayL,CmprL
	    cpc RegDelayH,CmprH
     	brne pause1
		clr RegDelayL
		clr RegDelayH
		inc count
		cpi count,30
		brne pause1
	Bitset1:
		Set_Command_LCD	HD44780_FunctionSet0
		clr count
		clr RegDelayL
		clr RegDelayH
		clr CmprL
		clr CmprH
	pause2:
		adiw	RegDelayL,1
	    ldi	CmprL,low(1000)
	    ldi CmprH,high(1000)
	    cp	RegDelayL,CmprL
	    cpc RegDelayH,CmprH
     	brne pause2
		clr RegDelayL
		clr RegDelayH
		inc count
		cpi count,5
		brne pause2
	Bitset2:
		Set_Command_LCD	HD44780_FunctionSet0
		clr count
		clr RegDelayL
		clr RegDelayH
		clr CmprL
		clr CmprH	
     pause3:
		adiw	RegDelayL,1
	    ldi	CmprL,low(1000)
	    ldi CmprH,high(1000)
	    cp	RegDelayL,CmprL
	    cpc RegDelayH,CmprH
     	brne pause3
	Bitset3:
		Set_Command_LCD	HD44780_FunctionSet0
		clr count
		clr RegDelayL
		clr RegDelayH
		clr CmprL
		clr CmprH	


		Set_Command_LCD	HD44780_FunctionSet0
		Set_Command_LCD	HD44780_DisplayOnOffControl0
		Set_Command_LCD	HD44780_ClearDisplay
		Set_Command_LCD	HD44780_EntryModeSet0
			
	
pause_ALL:
     	adiw	RegDelayL,1
	    ldi	CmprL,low(1000)
	    ldi CmprH,high(1000)
	    cp	RegDelayL,CmprL
	    cpc RegDelayH,CmprH
     	brne pause_ALL
		clr RegDelayL
		clr RegDelayH
		inc count
		cpi count,30
		brne pause_ALL
		ret    
