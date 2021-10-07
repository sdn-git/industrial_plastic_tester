

.org	$000		;RESET    Hardware Pin and Watchdog Reset
	jmp	RESET	;-- Reset Handle
.org	INT0addr		;INT0    Внешнее прерывание0
	jmp	Interrupt
.org	INT1addr		;INT1    Внешнее прерывание1
	jmp	Interrupt
.org	OC2addr			;совпадение таймера/счетчика Т2
	jmp	Interrupt
.org	OVF2addr		;Переполнение таймера/счетчика Т2
	jmp	TIMER2OVF	
.org	ICP1addr		;захват таймера/счетчика Т1
	jmp	Interrupt
.org	OC1Aaddr		;Совпадение "А" таймера/счетчика Т1
	jmp	Interrupt
.org	OC1Baddr		;Совпадение "В" таймера/счетчика Т1
	jmp	Interrupt
.org	OVF1addr		;Переполнение таймера/счетчика Т1
	jmp	Interrupt
.org	OVF0addr		;Переполнение таймера/счетчика Т0
	jmp	TIMER0OVF
.org	SPIaddr			;Передача по SPA завершена
	jmp	Interrupt
.org	URXCaddr		;USART, прием завершон
	jmp	Interrupt	
.org	UDREaddr		;Регистр данных USART пуст
	jmp	Interrupt
.org	UTXCaddr		;USART, передача завершена
	jmp	Interrupt
.org	ADCCaddr		;Передача АЦП завершено
	jmp	Interrupt
.org	ERDYaddr		;EEPROM, готово
	jmp	Interrupt
.org	ACIaddr			;Аналоговый компаратор
	jmp	Interrupt
.org	TWIaddr			;Прерывание отмодуля TWI
	jmp	Interrupt
.org	INT2addr		;Внешнее прерывание2
	jmp	Interrupt
.org	OC0addr			;Совпадение таймера/счетчика Т0
	jmp	Interrupt
.org	SPMRaddr
	jmp	Interrupt
  ;---------------------------------------------------------------------
Interrupt:
  reti


TIMER2OVF:
PUSH_ALL

cbi	ControlPort,LED1
cbi	ControlPort,LED2

	ldi tmp,233
	out	tcnt2,tmp
;--------------------

.macro S_MOV
	lds	TMP,@1
	sts	@0,TMP
.endmacro

	lds	XL,S_counterL					
	lds	XH,S_counterH

	lds	xtmp,S_MotorParking		;Waiting  after parking the PUSH button
	sbrc  	xtmp,f_MotorInStart		
	rjmp  	DataChrcking     			

	lds	xtmp,S_FlagButt1		;Pause button check
	sbrc 	xtmp,f_PauseSetted		       
	rjmp 	DataChrcking	                

	sbrs 	FlagReg,f_CountAndMotor   	;Conter-and-motor sync flag
	rjmp 	CompareWithButtConstants	
	sbrc 	FlagReg,f_IncrOne		   		
	rjmp 	CompareWithButtConstants

	lds  	tmp,S_FlagButt1			;Avoid first plastck check
	sbrc 	tmp,f_NoFirstIncr				
	rjmp 	NoIncrDuringParking		    			
	adiw 	XL,1		
	
NoIncrDuringParking:			
	sbr 	FlagReg,m_IncrOne					

;/// Check the if the limit is reached
CompareWithButtConstants:
	lds	tmp,S_LimitL		        	
	lds 	tmp2,S_LimitH	
	cp	XL,tmp
	cpc	XH,tmp2
	brne 	CountContiniue

;/// Stop if limit is reached. Waits until START button is pushed.
YesOvf:
	clr 	tmp				
	sts	S_counterL,tmp
	sts 	S_counterH,tmp
	lds	tmp,S_MotorParking
	sbr 	tmp,m_MotorInStart			
	cbr 	tmp,m_ButtStartWasWork  		
	sts 	S_MotorParking,tmp
	lds 	tmp,S_FlagOfButtSubroutine
	sbr 	tmp,m_ReadyCount
	sts 	S_FlagOfButtSubroutine,tmp
	rjmp	DataChrcking	
	
;/// Calibration happens after the number of measurements	
CountContiniue:                   
	lds 	YL,S_ParkingNormL
	lds 	YH,S_ParkingNormH
	cp	XL,YL						
	cpc	XH,YH						
	brne 	NoOvf
	ldi	tmp, low(C_ParkingNorm)		
	ldi 	tmp2,high(C_ParkingNorm)    
	add 	YL,tmp						
	adc 	YH,tmp2						
	lds 	xtmp,S_FlagOfButtSubroutine
    	sbr 	xtmp,m_PeriodicParking
	sts	S_FlagOfButtSubroutine,xtmp

;/// The limit is not reached, continue the calculation
NoOvf:
	sts S_ParkingNormL,YL
	sts S_ParkingNormH,YH
	sts	S_counterL,XL
	sts	S_counterH,XH
	
DataChrcking:
	rcall	HEX2DEC
	rcall	DEC2SEVSG
	lds tmp,S_FlagOfButtSubroutine 
	sbrc tmp,f_ReadyCount
	rcall ReadyIndicate	
	S_MOV	S_1LED1,S_D1		
	S_MOV	S_1LED2,S_D2
	S_MOV	S_1LED3,S_D3
	S_MOV	S_1LED4,S_D4
	S_MOV	S_1LED5,S_D5
	
;///Find data for the measurement
LED_DRV:
	S_INC	S_C_LED		
	cpi	TMP,5		 
	brne	PAGE_DEF	
	clr	TMP

;///Find page for the LED
PAGE_DEF:
	sts	S_C_LED,TMP	   
 	sbrc	SSH,F_FLASH
	rjmp	SPAGE2_PROC	

;///First page processing
SPAGE1_PROC:
	ldi	XH,high(SCREEN1)
	ldi	XL,low(SCREEN1)
	rjmp	DRIVER		

;///Second page processing
SPAGE2_PROC: 
	ldi	XH,high(SCREEN2)
	ldi	XL,low(SCREEN2)

DRIVER:
	Pause100us		
	cbi	CHAR_PORT,P_CHAR
	Pause100us
	push	TMP
	add	XL,TMP		    
	clr	TMP
	adc	XH,TMP
	pop	TMP
	ld	XTMP,X		    	
	out	DATA_PORT,XTMP		
	sbi	CODE_PORT,P_CODE	
	cbi	CODE_PORT,P_CODE
	out	DATA_PORT,tmp		
	sbi	CHAR_PORT,P_CHAR	
	ser	XTMP						
   	PauseDec255	
	ldi	XL,low(S_LK0)				
	ldi	XH,high(S_LK0)	
	add	XL,TMP						
	clr	TMP
	adc	XH,TMP						
	ld	TMP,X																				
	in	XTMP,ControlPort				
	bst	TMP,F_L2					
	bld	XTMP,led1								
	bst	TMP,F_L3					
	bld	XTMP,led2
	out	ControlPort,XTMP			
	in	xtmp,PINB					
	bst	XTMP,F_K0							
	bld	TMP,F_K0					
	bst	XTMP,F_K1		
	bld	TMP,F_K1		
	st	X,TMP
	POP_ALL
	reti

TIMER0OVF:
   	PUSH_ALL
	cli
	lds	xtmp,S_MotorParking			
    	sbrc    xtmp,f_MotorInStart		
	rjmp 	CountCout     													
	lds	xtmp,S_FlagButt1			
    	sbrc 	xtmp,f_PauseSetted			
	rjmp 	CountCout                  	
	sbi 	PORTC,Pulse							
	inc 	Regdelay							
	cpi	Regdelay, OptimalMeandrConstStepMot	
	brne	PointExit						
	cbi 	PORTC,Pulse							
	clr	Regdelay		
	adiw 	RegReverseL,1	
	lds	tmp,S_MotorHighPointL			
	lds	tmp2,S_MotorHighPointH		
	cp	tmp,RegReverseL				
	cpc	tmp2,RegReverseH			
	
PointExit:
	brne 	WayToExit
	sbrc 	FlagReg,f_reverse			
	rjmp 	ReversOff
	lds  	xtmp,S_MotorParking										
	sbrs 	xtmp, f_FinishParking		
	rjmp 	PrepairForParking	
	
FinishParking:
	sbr  	xtmp,m_MotorInStart		
	sts  	S_MotorParking,xtmp		
	rcall 	ReadEEPROM
	rjmp 	CountCout	
	
PrepairForParking:
	lds 	xtmp,S_MotorParking			
	sbrc 	xtmp,f_FirstCicle
	rjmp 	NoParking
	ldi 	tmp,0						
	sts	S_MotorHighPointH,tmp		
	ldi 	tmp,ParkingConst			
	sts	S_MotorHighPointL,tmp
	sbr 	xtmp,m_FinishParking
	sts 	S_MotorParking,xtmp
	
NoParking:		
	cbi 	PORTC,Reverse		
	sbr	FlagReg,m_reverse
	clr	RegReverseL
	clr	RegReverseH
	cbr	FlagReg,m_CountAndMotor 
	lds  	xtmp, S_FlagOfButtSubroutine	
   	sbrs 	xtmp,f_PeriodicParking
	rjmp 	ParkingPoint
	lds	XL,S_MotorHighPointL
	lds	XH,S_MotorHighPointH
	ldi 	ZL,low(C_ConstLowPointPark)
	ldi 	ZH,high(C_ConstLowPointPark)
	add 	XL,ZL
	adc 	XH,ZH
	sts 	S_MotorHighPointL,XL
	sts 	S_MotorHighPointH,XH
	cbr 	xtmp,m_PeriodicParking
	sbr 	xtmp,m_StabilizeConstReverse
	sts 	S_FlagOfButtSubroutine,xtmp

ParkingPoint:
	lds	tmp,S_MotorParking		
	sbrs 	tmp,f_ParkingLowPoint	
	rjmp 	CountCout				
	sbr  	tmp,m_MotorInStart		
	cbr 	tmp,m_ParkingLowPoint	
	cbr 	tmp,m_ButtStartWasWork
	sts 	S_MotorParking,tmp		

WayToExit:
	rjmp 	CountCout

ReversOff:					
	lds  	tmp,S_FlagButt2		
	sbrs 	tmp,f_ConstStore		
	rjmp 	ReverseOff_2			
	lds  	tmp2,S_ConstStoreL		
	lds	tmp3,S_ConstStoreH
	sts	S_MotorHighPointL,tmp2
	sts  	S_MotorHighPointH,tmp3
	cbr	tmp,m_ConstStore		
	sts  	S_FlagButt2,tmp

ReverseOff_2:
	sbi	PortC,Reverse			
	cbr 	FlagReg,m_reverse
	clr	RegReverseL
	clr	RegReverseH
	sbr	FlagReg,m_CountAndMotor
	cbr 	FlagReg,m_IncrOne
	lds 	xtmp,S_FlagOfButtSubroutine		
	sbrs 	xtmp,f_StabilizeConstReverse
	rjmp 	SoubrtneParkingInLow
   	lds	XL,S_MotorHighPointL			
	lds	XH,S_MotorHighPointH
	ldi 	ZL,low(C_ConstLowPointPark)
	ldi 	ZH,high(C_ConstLowPointPark)
	sub 	XL,ZL
	sbc 	XH,ZH
	sts 	S_MotorHighPointL,XL
	sts	 S_MotorHighPointH,XH
	cbr 	xtmp,m_StabilizeConstReverse
	sts 	S_FlagOfButtSubroutine,xtmp

SoubrtneParkingInLow:
	lds	tmp,S_MotorParking    
	sbrs 	tmp,f_ParkingButt	  
	rjmp 	CountCout
	sbr 	tmp,m_ParkingLowPoint
	cbr 	tmp,m_ParkingButt
	sts  	S_MotorParking,tmp

CountCout:
	sei
	POP_ALL
MotorOut:
	retI
