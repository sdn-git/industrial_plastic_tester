WriteConstOpenCloseInEEPROM:
	cli
	Push_All
	
WriteLowConstOpenClose:
	sbic	EECR,EEWE
	rjmp	WriteLowConstOpenClose
	ldi	tmp,E_OpenCloseAddrL		
	ldi	tmp2,0
	out	EEARH,tmp2
	out	EEARL,tmp
	out	EEDR,XL
	sbi	EECR,EEMWE
	sbi	EECR,EEWE

WriteHighConstOpenClose:
	sbic	EECR,EEWE
	rjmp	WriteHighConstOpenClose
	ldi 	tmp,E_OpenCloseAddrH
	ldi	tmp2,0
	out	EEARH,tmp2
	out	EEARL,tmp
	out	EEDR,XH
	sbi	EECR,EEMWE
	sbi	EECR,EEWE
	
Pop_All
	sei
	ret

WriteConstLengthInEEPROM:
	cli
	Push_All
	
WriteLowConstLength:
	sbic	EECR,EEWE
	rjmp	WriteLowConstLength
	ldi	tmp,E_LengthAddrL 		
	ldi	tmp2,0
	out	EEARH,tmp2
	out	EEARL,tmp
	out	EEDR,XL
	sbi	EECR,EEMWE
	sbi	EECR,EEWE
	
WriteHighConstLength:
	sbic	EECR,EEWE
	rjmp	WriteHighConstLength
	ldi 	tmp,E_LengthAddrH 
	ldi	tmp2,0
	out	EEARH,tmp2
	out	EEARL,tmp
	out	EEDR,XH
	sbi	EECR,EEMWE
	sbi	EECR,EEWE
	Pop_All
	sei
	ret
