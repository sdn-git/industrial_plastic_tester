ReadEEPROM:
cli

;�������� ���������, ������������ ���������� ����������/����������
;��� ��� ��������� �������� 2 �����, �� �������������� ���������� ���������� � ���� �������
;� ������ ������ ��������� 1 ���� �� ������ N.�� ������ ������ ��������� ��������� �� ������ N+1
LoadLowConstOpenClose:
	sbic EECR,EEWE
	rjmp LoadLowConstOpenClose
	ldi	xtmp,E_OpenCloseAddrL			;��������� ����� ������ EEPROM� ������ ����.
	ldi tmp,0							;����� 512���� (0�200)
	out	EEARH,tmp
	out EEARL,xtmp
	sbi	EECR,EERE
	in tmp2,EEDR		;� ���2 ��������� ������� ���� ��������� ���������� ��������/��������
LoadHighConstOpenClose: ;��������� ������ ����
	sbic EECR,EEWE
	rjmp LoadHighConstOpenClose
	ldi	xtmp,E_OpenCloseAddrH			;������ ���� ������������� �� ������ 1.		
	ldi tmp,0
	out	EEARH,tmp
	out EEARL,xtmp
	sbi	EECR,EERE
	in tmp,EEDR			;������ �� ����� ������ ��������� � tmp  
	sts S_limitH,tmp	;������� ������� ���� ��������� � ���. 
	sts S_limitL,tmp2    ;������� ������� ���� ��������� � ��� 

LoadLowConstLength:;�������� ���������, ������������  ����� ����(�� �� �����).
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
	sts	S_MotorHighPointH,tmp	;������� ������
	sts	S_MotorHighPointL,tmp2 
	sts S_ConstStoreL,tmp2		;������ ��� �������� ������.
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
