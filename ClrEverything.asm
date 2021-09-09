;Clear all register
ClrEverything:
	clr xtmp
	clr tmp2
	clr CmprL
	clr CmprH
	clr tmp3
	clr tmp		
	clr RegDelayL	
	clr RegDelayH			
	clr XL
	clr XH
	clr YL
	clr YH
	clr ZL
	clr ZH	


	clr RegReverseL
	clr	RegReverseH
	clr	RegDelay	
	clr	FlagReg	    
	sts	S_C_LED,tmp
	sts	S_1LED1,tmp
	sts S_1LED2,tmp	
    sts	S_1LED3,tmp	
	sts	S_1LED4,tmp	
	sts	S_1LED5,tmp	

	sts	S_2LED1,tmp	
	sts S_2LED2,tmp	
    sts	S_2LED3,tmp	
	sts S_2LED4,tmp	
	sts	S_2LED5,tmp	


	clr tmp
	sts	S_D1,TMP
	sts	S_D2,TMP
	sts	S_D3,TMP
	sts	S_D4,TMP
	sts	S_D5,TMP

	sts	S_counterH,TMP
	sts	S_counterL,TMP

	sts S_MotorParking,tmp

	sts	S_LimitL,tmp
	sts	S_LimitH,tmp		
	sts	S_FlagButt1,tmp 
	sts	S_FlagButt2,tmp

	ldi	tmp,0b00000011
	sts	S_LK0,tmp
	sts	S_LK1,tmp
.	sts	S_LK2,tmp
	sts	S_LK3,tmp
	sts	S_LK4,tmp

	lds tmp,S_FlagButt1
	sbr tmp,m_NoFirstIncr
	sts S_FlagButt1,tmp
	
	ldi tmp,low(500)			;Ёто нужно дл€ того, чтоб когда двигатель дает задний ход при-
	ldi	tmp2,high(500)			;включении питани€.
	sts S_MotorHighPointL,tmp
	sts S_MotorHighPointH,tmp2

	ldi tmp,low(C_ParkingNorm)		;C_ParkingNorm определ€ет через сколько открытий/закрытий
	ldi tmp2, high(C_ParkingNorm)	;будет происходить автоматическа€ парковка к Ќћ“.
	sts S_ParkingNormL,tmp			;
	sts S_ParkingNormH,tmp2			;


ret
