;--------------------------------------------------------------------------------

;                        FastexChecker Ver1.1
;						(LastUpdate 12 september 2007y)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ;---------------------------------------------------------------------------------
     

;---------------------------------------------------------------------------------
.device ATmega16
.include "m16def.inc"
.include "RegVarInit.asm"
.include "Macroses.asm"
.include "int.asm"
;----------------
.include "LED_driver.asm"			;���������� ���
.include "LCDPortsTimersInit.asm"	;������������� ������� � ��������
.include "ReadEEPROM.asm"			;������ EEPROM
.include "WriteEEPROM.asm"			;������ EEPROM
.include "ClrEverything.asm"		;������ ������� ���� ��������� � ���
.include "ClrLeds.asm"				;������� �� ������ ������ ������
.include "ClrLeds2.asm"				;jxbcnrf C� ������ ������ ������
.include "ButtonsChecking.asm"		;�������� �������������� ������� ������
.include "ReadyIndicate.asm"		;������ ��������� DONE ��� ���������� �����
.cseg
	Reset:
	ldi	tmp,low(RAMEND)
	out	SPL,tmp
	ldi	tmp,high(RAMEND)
	out	SPH,tmp
	rcall LCDPortsTimersInit
	rcall ClrEverything
	rcall ReadEEPROM	 ;���� ���� ��� ����� ��������� ������� ������ ����������
 						 ;�����, �� ���������������� rcall ReadEEPROM
/*cycle:
	SHOW_onLCD 0x00,'A'  ;��������������� ��� ��� ���������.
	SHOW_onLCD 0x01,'P'
	SHOW_onLCD 0x02,'R'
	SHOW_onLCD 0x03,'I'
	SHOW_onLCD 0x04,'.'
	SHOW_onLCD 0x05,'A'
	SHOW_onLCD 0x06,'P'
	SHOW_onLCD 0x07,'R'
	SHOW_onLCD 0x40,'I'
	SHOW_onLCD 0x41,'.'
	SHOW_onLCD 0x42,'2'
	SHOW_onLCD 0x43,'0'
	SHOW_onLCD 0x44,'0'
	SHOW_onLCD 0x45,'6'
	SHOW_onLCD 0x46,'y'
	SHOW_onLCD 0x47,'r'
Pause100ms
*/
Main:
		cli
		rcall	ButtonsChecking ;������������ ��������� �������������� ������� ������
		sei
;����� ���������� ��������� �����������, ���� ���������� ���� F_K0 ��� F_K1 � ����� ������������ ������
;������ ������.
;���� ������ ��������� ������ (������������� � ButtonsChecking) , ������ ���� ������������� ����
;f_MoreOneButt_1 � f_MoreOneButt_2 ������� ������ ����������� ����� ��� ��������� ������ ������, � ������� ��� ��� ���� ��
;���� ��� ��������� ������ ���� ������
		sbrc	FlagReg,f_MoreOneButt_1
		rjmp	SecondGroupButt	
  FirstGroupButt:	
        ;���������� ����������-����������.		
  Butt11:;��������� ������ ������ ������ ������ (500 ����������/����������)
		lds		TMP3,S_LK0 ;��������� ������ �� ���.
		sbrs	TMP3,F_K0  ;������ �� ������? (1=�� ������, 0=������)
		rjmp	K11_pressed;������.������ ���� �� ���������.
		rjmp	Flag11Off ;�������,������ ������ ���� �������*/

  K11_pressed:
		lds	tmp2,S_FlagButt1 ;�������� ������� ������ � 
		sbrc tmp2,f_Butt11	;��������� ���� �� ��� ���� f_Butt11. �� ����� ��� ����,
							;���� ��� ������ ��������� ������ ��������� �� ������
							;������ ��� �� ����� ����. 0=������ �����������.1=������
							;�����������.
		rjmp  S_LK11_end
		rcall ClrLeds
		sbr	  TMP3,M_L2  ;������� �����������, �������������� ������ ������.
       	cbr	  TMP3,m_K0  ;**?????**������ ������ ������, ��� ��������� �� ���� ������.
		ldi	  XL,low(Const500)	    ;��������� ��������� ������ ����������/����������
		ldi	XH,high(Const500)
		sts	S_limitL,XL
		sts	S_limitH,XH
		clr xtmp
		sts	S_counterL,xtmp ;�������� ������� �������� ��������. ��� ������ 
		sts S_counterH,xtmp	;������ �� ���� �� ������ ���� ������, ������� ����������
		clr tmp
		sbr tmp,m_Butt11	;��������� ����, ���� ����� ������ ��� ��������� ������� ��
							;���� �����,��� �� ������ ������� � ����� �� ������� ��������� 
		sts	  S_FlagButt1,tmp	;
	    rcall WriteConstOpenCloseInEEPROM
 		rjmp  S_LK11_end
     Flag11Off:
		lds	tmp,S_FlagButt1
		cbr tmp,m_Butt11
		sts	S_FlagButt1,tmp
     S_LK11_end:
		sts		S_LK0,tmp3
		;
		

	 Butt12:;��������� ������ ������ ������ ������ (1000 ����������/����������)
		;----------------
	 	lds		TMP3,S_LK1
		sbrs	TMP3,F_K0
		rjmp	K12_pressed
		rjmp	Flag12Off ;�������,������ ������ ���� �������*/
   	 K12_pressed:
		lds	  tmp2,S_FlagButt1
		sbrc  tmp2,f_Butt12
		rjmp  S_LK12_end
		rcall ClrLeds
		sbr		TMP3,M_L2
		cbr		TMP3,m_K0
		ldi	XL,low(Const1000)
		ldi	XH,high(Const1000)
		sts	S_limitL,XL
		sts	S_limitH,XH
		clr	xtmp
		sts	S_counterL,xtmp
		sts S_counterH,xtmp
		clr tmp
		sbr tmp,m_Butt12
		sts	  S_FlagButt1,tmp	
		rcall WriteConstOpenCloseInEEPROM
		rjmp  S_LK12_end
	 Flag12Off:
		lds	tmp,S_FlagButt1
		cbr tmp,m_Butt12
		sts	S_FlagButt1,tmp
	 S_LK12_end:
		sts		S_LK1,tmp3

	Butt13:;��������� ������� ������ ������ ������ (5000 ����������/����������)
		;----------------
	 	lds		TMP3,S_LK2
		sbrs	TMP3,F_K0
		rjmp	K13_pressed
		rjmp	Flag13Off ;�������,������ ������ ���� �������
    K13_pressed:
		lds	 tmp2,S_FlagButt1
		sbrc tmp2,f_Butt13
		rjmp  S_LK13_end
		rcall ClrLeds
		sbr	  TMP3,M_L2
		cbr	  TMP3,m_K0
		ldi	XL,low(Const5000)
		ldi	XH,high(Const5000)
		sts	S_limitL,XL
		sts	S_limitH,XH
		clr	xtmp
		sts	S_counterL,xtmp
		sts S_counterH,xtmp
		sbr tmp2,m_Butt13
		sts	S_FlagButt1,tmp2
		rcall WriteConstOpenCloseInEEPROM
		rjmp S_LK13_end
    Flag13Off:
		lds	tmp2,S_FlagButt1
		cbr tmp2,m_Butt13
		sts	S_FlagButt1,tmp2	
    S_LK13_end:
		sts		S_LK2,tmp3
	;----------------
	Butt14:;��������� ��������� ������ ������ ������ (10000 ����������/����������)
	 	lds		TMP3,S_LK3
		sbrs	TMP3,F_K0
		rjmp	K14_pressed
		rjmp	Flag14Off ;�������,������ ������ ���� �������
	K14_pressed:
		lds	 tmp2,S_FlagButt1
		sbrc tmp2,f_Butt14
		rjmp	S_LK14_end
    	rcall 	ClrLeds
		sbr		TMP3,M_L2
		cbr		TMP3,m_K0
		ldi	XL,low(Const10000)
		ldi	XH,high(Const10000)
		sts	S_limitL,XL
		sts	S_limitH,XH
		clr	xtmp
		sts	S_counterL,xtmp
		sts S_counterH,xtmp
		sbr tmp2,m_Butt14
		sts	S_FlagButt1,tmp2	
		rcall WriteConstOpenCloseInEEPROM
		rjmp S_LK14_end
	Flag14Off:
		lds	tmp2,S_FlagButt1
		cbr tmp2,m_Butt14
		sts	S_FlagButt1,tmp2	
	S_LK14_end:
		sts		S_LK3,tmp3
		
	Butt15:;��������� ����� ������ ������ ������ (������ �����). ����� ��������� ���. �������� ������
	;��� �� ������.���������� ���� f_PauseSetted � S_PauseButt.� ���� f_PauseSetted=1, �� ����� ����������
	;� ��� ��������� ��������� ��������, ��� ��� ����� ��������� ������, �� ��������� ������ ��������� 
	;������� ����� f_PauseSetted.������ ������ ������, ��������� - ���� ����������.����� ������-��������� 
	;�� ����� - ���� f_PauseSetted ��������.
   	
		lds     xtmp,S_FlagOfButtSubroutine
		sbrc    xtmp,f_PauseDenied
		rjmp    SecondGroupButt
		;
	 	lds		TMP3,S_LK4			;��������� ������ � ���
		sbrs	TMP3,F_K0			;���� ���������� (������ �� �� ������?)
		rjmp	K15_pressed			;F_K0=0,������ ������ ������. ��������� �� �����
		rjmp	Flag15Off	        ;� ��������� �� �����
	K15_pressed:;������ ��������
 	  	cbr		TMP3,m_K0			;
		lds	tmp2,S_FlagButt1		;��������� ������ ��������� ������ ������ ������
		sbrc tmp2,f_Butt15			;������ ��� ���� ������? ���� ���� �������� ���� ��� ������ 
									;��������� ��������� ������ ��� �� ��������� �� ���� �����.
									;� ������ ��� ������, ���� ���������. ������ ��� ��� ������� �
									;����� ������ �� �����
		rjmp	S_LK15_end			;�� f_FirstPushPause=1 (������ ��� �������� ���������), ������� �� �����
		sbrs 	tmp2,f_PauseSetted	;� ����� �����������?
		rjmp	FirstPushPause		;���, �� �����������, ������� ���� �� FirstPushPause
		rjmp    SecondPushPause		;��, �����������.
    FirstPushPause:
		sbr		TMP3,M_L2			;�������� ���������
		sbr		tmp2,m_PauseSetted		;������ �������-����������.��������� ����. ��������� �� ��������
		;
		lds tmp,S_FlagOfButtSubroutine
		sbr tmp,m_ParkingDenied
		sts S_FlagOfButtSubroutine,tmp
		;
		rjmp 	SetFlags
    SecondPushPause:
		cbr		TMP3,M_L2
		cbr		tmp2,m_PauseSetted		;������ ������-����������.������ ����. ��������� ����� �����������
        sts 	S_FlagButt1,tmp2 
		;
		lds tmp,S_FlagOfButtSubroutine
		cbr tmp,m_ParkingDenied
		sts S_FlagOfButtSubroutine,tmp
		;
		rjmp	SetFlags
	SetFlags:
		sbr 	tmp2,m_Butt15
		sts 	S_FlagButt1,tmp2 	
		rjmp	 S_LK15_end	
	Flag15Off:
		lds		tmp2,S_FlagButt1
		cbr 	tmp2,m_Butt15
		sts		S_FlagButt1,tmp2
	S_LK15_end:
		sts		S_LK4,tmp3			;���������� �������� ��� �������� ������� � ������ ���

SecondGroupButt:
		sbrc	FlagReg,f_MoreOneButt_2 ;���� �������� �� ������������� ������� 2-� ������
		rjmp	ENDPoint				;���� (�� ����) ���� ������� ���������� ������									;�� f_MoreOneButt_2=1 � ��������� ��������� �� ENDPoint
		;-------------------
	Butt21:	;������ ������������ ����� ���� (5 ��)			
     	lds		TMP3,S_LK0		;
		sbrs	TMP3,F_K1
		rjmp	K21_pressed
		rjmp    Flag21Off	
		
	K21_pressed:
		lds	 tmp2,S_FlagButt2
		sbrc tmp2,f_Butt21
		rjmp	S_LK21_end
		rcall ClrLeds2
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		ldi	XL,low(Const200)
		ldi	XH,high(Const200)
		sts	S_ConstStoreL,XL
		sts	S_ConstStoreH,XH
		sbr tmp2,m_Butt21
		sbr tmp2,m_ConstStore
		sts	S_FlagButt2,tmp2
		rcall WriteConstLengthInEEPROM
		rjmp S_LK21_end	
	Flag21Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt21
		sts	S_FlagButt2,tmp2	
	S_LK21_end:
		sts		S_LK0,tmp3

		;----------------
	Butt22:	;������ ������������ ����� ���� (10 ��)
	 	lds		TMP3,S_LK1
		sbrs	TMP3,F_K1
		rjmp	K22_pressed
		rjmp	Flag22Off	;
	K22_pressed:
		lds	 tmp2,S_FlagButt2
		sbrc tmp2,f_Butt22
		rjmp	S_LK22_end
		rcall ClrLeds2
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		ldi	XL,low(Const250)
		ldi	XH,high(Const250)
		sts	S_ConstStoreL,XL
		sts	S_ConstStoreH,XH
		sbr tmp2,m_ConstStore
		sbr tmp2,m_Butt22
		sts	S_FlagButt2,tmp2
		rcall WriteConstLengthInEEPROM
		rjmp	S_LK22_end		
	Flag22Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt22
		sts	S_FlagButt2,tmp2
	S_LK22_end:
		sts		S_LK1,tmp3
		;----------------
	Butt23:	;������ ������������ ����� ���� (15 ��)
	 	lds		TMP3,S_LK2
		sbrs	TMP3,F_K1
		rjmp	K23_pressed
		rjmp	Flag23Off	;
	K23_pressed:
		lds	 tmp2,S_FlagButt2
		sbrc tmp2,f_Butt23
		rjmp	S_LK23_end
		rcall ClrLeds2
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		ldi	XL,low(Const300)
		ldi	XH,high(Const300)
		sts	S_ConstStoreL,XL
		sts	S_ConstStoreH,XH
		sbr tmp2,m_ConstStore
		sbr tmp2,m_Butt23
		sts	S_FlagButt2,tmp2
		rcall WriteConstLengthInEEPROM
		rjmp	S_LK23_end	
	Flag23Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt23
		sts	S_FlagButt2,tmp2			
	S_LK23_end:
		sts		S_LK2,tmp3
	;----------------
	Butt24:;������ ��������. �������� � ���� ���� � ������� ������� �����. ����� ����� ��������� �������
		   ;���� ������ �� ������ ����. ������� ��������, ��� ���� ������, �� �������, �� ������ ������
		   ;����� �� ������ �����. ���� �������� �� �������, �� ��������������� ���� ������� �����. � 
		   ;��������, ���� ������ �����, �� ��������������� ���� ������� ������� ��������

		lds     xtmp,S_FlagOfButtSubroutine	; �������� ����� ������� ��������
		sbrc    xtmp,f_ParkingDenied
		rjmp    Butt25
		;
	 	lds		TMP3,S_LK3
		sbrs	TMP3,F_K1
		rjmp	K24_pressed
		rjmp	Flag24Off;
	K24_pressed:
		lds	 tmp2,S_FlagButt2
		sbrc tmp2,f_Butt24
		rjmp	S_LK24_end
;		rcall    ClrLeds2
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		sbr    tmp2,m_Butt24
		;
		lds tmp,S_FlagOfButtSubroutine  ;���� ������ ������, ��  ������������� ���� ������� ������� 
		sbr tmp,m_PauseDenied		    ;������ �����. �� ��������� ��� ������� �� ������ ����.
		sts S_FlagOfButtSubroutine,tmp
		;
		lds	tmp,S_MotorParking
		sbr tmp,m_ParkingButt
		sts S_MotorParking,tmp
		sts	S_FlagButt2,tmp2
		rjmp	S_LK24_end	
	Flag24Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt24
		sts	S_FlagButt2,tmp2
	S_LK24_end:
		sts		S_LK3,tmp3
		
   ;----------------
	Butt25:							;������ �����!!!
		
		;
		lds		xtmp,S_MotorParking
		sbrc 	xtmp,f_ButtStartWasWork
		rjmp	ENDPoint			;
	 	lds		TMP3,S_LK4
		sbrs	TMP3,F_K1
		rjmp	K25_pressed
		rjmp	Flag25Off;
			;
	K25_pressed:
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		lds		tmp2,S_FlagButt2
		sbrc 	tmp2,f_Butt25
		rjmp	S_LK25_end		
   		cbr xtmp,m_MotorInStart		;����� ������ ��������� �����. ��� ������ ����� ������
		cbr xtmp,m_FinishParking	;��� ������� �������� ��������.
		sbr xtmp,m_ButtStartWasWork
		sbr	xtmp,m_FirstCicle
		sts S_MotorParking,xtmp
		; 
		lds xtmp,S_FlagOfButtSubroutine ;������� ������ ������� ������ ��������.���� ���� ���������������  
		cbr xtmp,m_PauseDenied        ;
		sts S_FlagOfButtSubroutine,xtmp ;
		;
		lds	TMP3,S_LK3
		cbr	TMP3,M_L3
		sts S_LK3,tmp3
		lds tmp,S_FlagOfButtSubroutine
	    cbr tmp,m_ReadyCount
		sts S_FlagOfButtSubroutine,tmp
		clr RegReverseL	
		clr RegReverseH	
		
		lds  tmp,S_FlagButt1			;����� ��������� ��������� ���������� 1 �������� �������� ����������/����������. 
		cbr  tmp,m_NoFirstIncr			;����� ���� ���������.
		sts	 S_FlagButt1,tmp	
		rjmp	S_LK25_end	
	Flag25Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt25
		sts	S_FlagButt2,tmp2
S_LK25_end:
		sts		S_LK4,tmp3	
ENDPoint:
OutButtonLED:	
rjmp main

