ReadEEPROM:
cli

;загрузка константы, определяющей количество открываний/закрываний
;Так как константа занимает 2 байта, то соответственно считывание происходит с двух заходов
;в первом заходе считываем 1 байт по адресу N.Во втором заходе считываем константу по адресу N+1
LoadLowConstOpenClose:
	sbic EECR,EEWE
	rjmp LoadLowConstOpenClose
	ldi	xtmp,E_OpenCloseAddrL			;формируем адрес ячейки EEPROMа равный нулю.
	ldi tmp,0							;всего 512байт (0х200)
	out	EEARH,tmp
	out EEARL,xtmp
	sbi	EECR,EERE
	in tmp2,EEDR		;в тмп2 находится младший байт константы количества открытий/закрытий
LoadHighConstOpenClose: ;выгружаем второй байт
	sbic EECR,EEWE
	rjmp LoadHighConstOpenClose
	ldi	xtmp,E_OpenCloseAddrH			;второй байт располагается по адресу 1.		
	ldi tmp,0
	out	EEARH,tmp
	out EEARL,xtmp
	sbi	EECR,EERE
	in tmp,EEDR			;данные по этому адресу загружаем в tmp  
	sts S_limitH,tmp	;заносим старший байт константы в ОЗУ. 
	sts S_limitL,tmp2    ;заносим младший байт константы в ОЗУ 

LoadLowConstLength:;загрузка константы, определяющей  длину хода(то же самое).
	sbic EECR,EEWE
	rjmp LoadLowConstLength
	ldi	xtmp,E_LengthAddrL
	ldi tmp,0
	out	EEARH,tmp
	out EEARL,xtmp
	sbi	EECR,EERE
	in tmp2,EEDR
LoadHighConstLength:
	sbic EECR,EEWE
	rjmp LoadHighConstLength
	ldi	xtmp,E_LengthAddrH
	ldi tmp,0
	out	EEARH,tmp
	out EEARL,xtmp
	sbi	EECR,EERE
	in tmp,EEDR
	sts	S_MotorHighPointH,tmp	;Рабочая ячейка
	sts	S_MotorHighPointL,tmp2 
	sts S_ConstStoreL,tmp2		;Ячейка для хранения данных.
	sts S_ConstStoreH,tmp



First_GroupCheckLED:
	lds tmp,S_limitL
	lds tmp2,S_limitH

  FirstConstCompare_1:
	ldi xtmp,low(Const500)
	ldi	tmp3,high(Const500)
	cp tmp,xtmp
	cpc tmp2,tmp3
	brne SecondConstCompare_1
	rcall ClrLeds
	lds xtmp,S_LK0
	sbr	xtmp,M_L2
	sts s_Lk0,xtmp
	rjmp Second_GroupCheckLED

  SecondConstCompare_1:
	ldi xtmp,low(Const1000)
	ldi	tmp3,high(Const1000)
	cp tmp,xtmp
	cpc tmp2,tmp3
	brne ThirdConstCompare_1
	rcall ClrLeds
	lds xtmp,S_LK1
	sbr	xtmp,M_L2
	sts s_Lk1,xtmp
	rjmp Second_GroupCheckLED

  ThirdConstCompare_1:
	ldi xtmp,low(Const5000)
	ldi	tmp3,high(Const5000)
	cp tmp,xtmp
	cpc tmp2,tmp3
	brne FourthConstCompare_1
	rcall ClrLeds
	lds xtmp,S_LK2
	sbr	xtmp,M_L2
	sts s_Lk2,xtmp
	rjmp Second_GroupCheckLED

  FourthConstCompare_1:
	rcall ClrLeds
	lds xtmp,S_LK3
	sbr	xtmp,M_L2
	sts s_Lk3,xtmp
	rjmp Second_GroupCheckLED

Second_GroupCheckLED:
	lds tmp,S_MotorHighPointL
	lds tmp2,S_MotorHighPointH

  FirstConstCompare_2:
	ldi xtmp,low(Const200)
	ldi	tmp3,high(Const200)
	cp tmp,xtmp
	cpc tmp2,tmp3
	brne SecondConstCompare_2
	rcall ClrLeds2
	lds xtmp,S_LK0
	sbr	xtmp,M_L3
	sts s_Lk0,xtmp
	rjmp AwayFromReading

  SecondConstCompare_2:
	ldi xtmp,low(Const250)
	ldi	tmp3,high(Const250)
	cp tmp,xtmp
	cpc tmp2,tmp3
	brne ThirdConstCompare_2
	rcall ClrLeds2
	lds xtmp,S_LK1
	sbr	xtmp,M_L3
	sts s_Lk1,xtmp
	rjmp AwayFromReading

  ThirdConstCompare_2:
	ldi xtmp,low(Const300)
	ldi	tmp3,high(Const300)
	cp tmp,xtmp
	cpc tmp2,tmp3
	brne FourthConstCompare_2
	rcall ClrLeds2
	lds xtmp,S_LK2
	sbr	xtmp,M_L3
	sts s_Lk2,xtmp
	rjmp AwayFromReading

  FourthConstCompare_2:
  	rcall ClrLeds2
	lds xtmp,S_LK3
	sbr	xtmp,M_L3
	sts s_Lk3,xtmp
	rjmp AwayFromReading

AwayFromReading:
	sei 
ret
