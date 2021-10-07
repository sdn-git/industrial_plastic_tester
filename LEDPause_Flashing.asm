;/// LED flashing modes
LEDPause_Flashing:
	Push_All
	clr	tmp
	clr	tmp3
	clr	Xtmp
	lds	xtmp,S_FlagButt1			    	
	sbrs	xtmp,f_PauseSetted		        
	rjmp	NoFlashing
	lds 	tmp,S_LedFlashing1
	lds	xtmp,S_LedFlashing2
	inc	tmp
	cpi	tmp,0xff
	brne	NoFlashing
	clr	tmp
	inc	xtmp
	cpi	xtmp,0x03
	brne	NoFlashing

YesFlashing:    ;/// blinking
	CLR 	XTMP
	clr 	tmp
	lds	TMP3,S_LK4			
	sbrs    tmp3,f_L2
	rjmp	OnPauseLed
	rjmp	OffPauseLed
	
OnPauseLed:
	sbr	tmp3,m_l2
	rjmp	BackToRam
	
OffPauseLed:
	cbr	tmp3,m_l2
	
BackToRam:
	sts	S_LK4,Tmp3
	
NoFlashing:     /// constant
	sts	S_LedFlashing1,Tmp
	sts	S_LedFlashing2,xtmp	
	Pop_All
ret
