

.org	$000		;RESET    Hardware Pin and Watchdog Reset
	jmp	RESET	;-- Reset Handle
.org	INT0addr		;INT0    ������� ����������0
	jmp	Interrupt
.org	INT1addr		;INT1    ������� ����������1
	jmp	Interrupt
.org	OC2addr			;���������� �������/�������� �2
	jmp	Interrupt
.org	OVF2addr		;������������ �������/�������� �2
	jmp	TIMER2OVF	
.org	ICP1addr		;������ �������/�������� �1
	jmp	Interrupt
.org	OC1Aaddr		;���������� "�" �������/�������� �1
	jmp	Interrupt
.org	OC1Baddr		;���������� "�" �������/�������� �1
	jmp	Interrupt
.org	OVF1addr		;������������ �������/�������� �1
	jmp	Interrupt
.org	OVF0addr		;������������ �������/�������� �0
	jmp	TIMER0OVF
.org	SPIaddr			;�������� �� SPA ���������
	jmp	Interrupt
.org	URXCaddr		;USART, ����� ��������
	jmp	Interrupt	
.org	UDREaddr		;������� ������ USART ����
	jmp	Interrupt
.org	UTXCaddr		;USART, �������� ���������
	jmp	Interrupt
.org	ADCCaddr		;�������� ��� ���������
	jmp	Interrupt
.org	ERDYaddr		;EEPROM, ������
	jmp	Interrupt
.org	ACIaddr			;���������� ����������
	jmp	Interrupt
.org	TWIaddr			;���������� �������� TWI
	jmp	Interrupt
.org	INT2addr		;������� ����������2
	jmp	Interrupt
.org	OC0addr			;���������� �������/�������� �0
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

	lds	XL,S_counterL					;
	lds	XH,S_counterH
;+++++++++++++++++++++++++++++++
	lds	  xtmp,S_MotorParking		;����� ��������  ������� ������ ���������� � ������ ������.������� - 
	sbrc  xtmp,f_MotorInStart		;����� �������� ��������� ���� ���� ���� ����� ��� �������������.-
	rjmp  DataChrcking     			;��������� �� ��� ������� ������ ����.
;+++++++++++++++++++++++++++++++
	lds	 xtmp,S_FlagButt1				;��� ���� ��������� �����. ����� � �������� ������ S_PauseButt ��������
	sbrc xtmp,f_PauseSetted		        ;������ ��� �� ����������.� ����� ��������?
	rjmp DataChrcking	                ;�� ����������. ����� �������� �� ������ �������� ��� ����� 2. � ���� ����� �� 	
;+++++++++++++++++++++++++++++++
	sbrs FlagReg,f_CountAndMotor   		;���� �������������� ������ ��������� � ��������
	rjmp CompareWithButtConstants	
	sbrc FlagReg,f_IncrOne		   		;���� ���� �������� ����� ��������� �� ���������������� ����� ������� �����������.
	rjmp CompareWithButtConstants
;+++++++++++++++++++++++++++++++
	lds  tmp,S_FlagButt1				;����� ��������� ��������� ���������� �������� �������� ����������/����������. 
	sbrc tmp,f_NoFirstIncr				;���� ����� �� ��������� ��������� ���� ������� - ��������� �� ����� ����������������.
	rjmp NoIncrDuringParking		    ;� ������ ����� ������� ������ ����				
	adiw XL,1							;����� ���������� ��������� �����, ������������� �� ����������.	
NoIncrDuringParking:			
	sbr FlagReg,m_IncrOne					
;+++++++++++++++++++++++++++++++
CompareWithButtConstants:
	;��������� S_LimitX �������� �������. � � ������ ������, ��������� ��������� � S_LimitX.
	;����� ������� ������� S_counterX ������������ � ���� ����������. � ���� ��� ����������
	;�� ������� ������� ���������. ��������� ���������� ���� ����������/����������.
	lds	tmp,S_LimitL		        	;����� ��� ��������� ���������� �� ��������� 
	lds tmp2,S_LimitH	
	cp	XL,tmp
	cpc	XH,tmp2
	brne CountContiniue
YesOvf:
	clr tmp						  		;���� ��������� �����, �� � ������� ��������� ����.
	sts	S_counterL,tmp
	sts S_counterH,tmp
	lds tmp,S_MotorParking
	sbr tmp,m_MotorInStart				;��� ������  ���� ����������/���������� ��������� ���������
	cbr tmp,m_ButtStartWasWork  		;�����, ��  �� �����������. ������ �������� �� ������� ������ ����.
	sts S_MotorParking,tmp
	lds tmp,S_FlagOfButtSubroutine
	sbr tmp,m_ReadyCount
	sts S_FlagOfButtSubroutine,tmp
	rjmp	DataChrcking	
;+++++++++++++++++++++++++++++++	
CountContiniue: 
	;���������� ��� ������ �� �������� ��� ��������������� � ��� ����� �� ��������
	;�� ���, ��� �����,������ �� ������ ����� ���� ��������. ������� ����� ������������� �����
	;����������/���������� ����� ����������� �������� � ���, ���� ���������� ���� � �������
	;������. 
		                 
	lds YL,S_ParkingNormL
	lds YH,S_ParkingNormH
	cp	XL,YL						;���������� ����� �� ���������� � ���������� ������������� ��������.
	cpc	XH,YH						;
	brne 	NoOvf
	ldi	tmp, low(C_ParkingNorm)		;���� � ��� ����� ������������ ���������� ������� ���������
	ldi tmp2,high(C_ParkingNorm)    ;��������, �� ����  ���������� ��������� ������, ����� ����� 
	add YL,tmp						;����������� ������������. ��� �������� ��������� �������� ����� 
	adc YH,tmp2						;� ���������� C_ParkingNorm.
	lds xtmp,S_FlagOfButtSubroutine
    sbr xtmp,m_PeriodicParking
	sts	S_FlagOfButtSubroutine,xtmp
NoOvf:
	sts S_ParkingNormL,YL
	sts S_ParkingNormH,YH
	sts	S_counterL,XL
	sts	S_counterH,XH
DataChrcking:
	rcall	HEX2DEC
	rcall	DEC2SEVSG
	;
	;��� ������ ���� ������ �� ��������� ���������� ����������/����������, �� ����������� ����
	;f_ReadyCount.� ��������� ���� ���������� ����� �� ��������� ����� DONE.��� ���� ��� ������� ���������������
	;����� ���� ������� �������������� �������� ������ ����.
	lds tmp,S_FlagOfButtSubroutine 
	sbrc tmp,f_ReadyCount
	rcall ReadyIndicate	
	;
	S_MOV	S_1LED1,S_D1		;����� ���� �� ���������.
	S_MOV	S_1LED2,S_D2
	S_MOV	S_1LED3,S_D3
	S_MOV	S_1LED4,S_D4
	S_MOV	S_1LED5,S_D5

	;============================================================================
; "LED_DRV.asm  ; ������� 7-������������� 4-�����������  LED �������.
; 25/VIII.06.  ; ������� ��������� (� �������� ������������ ����������
;    ; ���������������) ���������� ���������� (�.�. ��������)
;    ; �� LED ������� ���������� 1-� � 2-� ������� ��������� ���.
;
;INTERRUPT_SUBROUTINE
;���� ����� ������������ �������������, �� ����� ��������� �� �������� 
; � ������ ��������� ������� ���������� !!!
;============================================================================
LED_DRV:
;���� ����� ������������ �������������, �� ����� ��������� �� �������� !!!
	S_INC	S_C_LED		;�������, ����� ���������� ����� ������������.
	cpi	TMP,5		    ;���� ��� ���������� ���������, �� ������ �������
	brne	PAGE_DEF	;  � ������� 0.
	clr	TMP
PAGE_DEF:
	sts	S_C_LED,TMP	    ;��������� ���������� �������� ����������.
#warning "only for 1-st page"
;	sbrc	SSH,F_FLASH	;
;	rjmp	SPAGE2_PROC	;������������ SCREENpage-2, ���� ���� "FLASH"=1,
                        ;����� �������� � SCREENpage-1.
	;--------------------------------------------------------------------
SPAGE1_PROC:;-- �������� ������� ��������-1 ��������� ���.
	ldi	XH,high(SCREEN1)
	ldi	XL,low(SCREEN1)
	rjmp	DRIVER		;��������� � ���������.
	;--------------------------------------------------------------------
/*SPAGE2_PROC:;-- �������� ������� ��������-2 ��������� ���.
	ldi	XH,high(SCREEN2)
	ldi	XL,low(SCREEN2)*/
	;--------------------------------------------------------------------
DRIVER:
	Pause100us		
	cbi	CHAR_PORT,P_CHAR;��������� ������� �������� ������ LED �������.
	Pause100us
	push	TMP
	add	XL,TMP		    ;������ X �������� ���� �����.
	clr	TMP
	adc	XH,TMP
	pop	TMP
	;P.S. �������� �� ������������ �������� �����
	;  �� ������, ��� ��� ����� ������������� <255.
	ld	XTMP,X		    	;������ ���������� ����� ������ � XTMP
	out	DATA_PORT,XTMP		;  � ���������� ��� � ���� ������.
	;
	sbi	CODE_PORT,P_CODE	;����������� ������ � ����� � ��������.
	cbi	CODE_PORT,P_CODE
	out	DATA_PORT,tmp		;������ ������������ ������ ������ LED �������.
	sbi	CHAR_PORT,P_CHAR	;
;****************************
/*
� ������ ������������ ��������� 7-������������� ���������� "������� �����",
���������� ������� ���� "��������-�������������" ��� LK0..LK4
������ ���� ������������ �� ���� ������ � ����������� (������� ��������-������������ �������)
������ � ��������� ��������� 7-�� ����������� ���������� "������� �����" (������ 
��������-������������ �������).

�������� ������� ����� L2,L3, ���������� ����� �� ����������� �� ������� �������� ������ 
����� ������. ��� ���� �� ������� � ���� �������� ��������-������������ �������.

�������� ������� ����� K0,K1, ���������� ����� �� ������ �� ������� �������� ������ 
������. ��� ���� �� ������ �� ����� �������� ��������-������������ �������.
*/
	ser	XTMP						;���������� ��������, ��� ��� ���-������ �� �������� �� ������������.
    PauseDec255
	
	ldi	XL,low(S_LK0)				;��������� ����� ������� ������ 
	ldi	XH,high(S_LK0)	
	add	XL,TMP						; ���������� � ���. ( � ��� ����� �� 0 �� 4 �� ����)
	clr	TMP
	adc	XH,TMP						;� �����  � �������� � �������� ������� ����� ������
	ld	TMP,X						;��������� � ��� ������ �� ������ X+���.������ �
									;��� ������ � ���, ���������� ���������� � ���������
									;������ � �����������.
	in	XTMP,ControlPort			;�������� ��� ����� � � XTMP		
	bst	TMP,F_L2					;�� tmp ����� ���� � �������� ��������� ����������
	bld	XTMP,led1					;� xtmp. 
						
	bst	TMP,F_L3					;����������� ������ �� ����������� ������ ������
	bld	XTMP,led2
	out	ControlPort,XTMP			;� ���� �������  XTMP ���������� � ��� ����� �.
									;��������������, ���� F_L2 = 1, ������������� �
									;led1 = 1, ������� �� ������ ����� � ����� 1 �
									;��������� ��������.
;C�������� ������ ������������ � ������ ��� (!!!) ������� ����� (B).
	in	xtmp,PINB					; ����� ��� ������ ��������. ��������� ������
	bst	XTMP,F_K0					;������� ��������������� � ����� �� � ����������		
	bld	TMP,F_K0					;� ������ ���
	bst	XTMP,F_K1		
	bld	TMP,F_K1		
	st	X,TMP
POP_ALL
	reti
;-------------------------------------------
TIMER0OVF:
   PUSH_ALL
;���������� �������
	cli
;++++++++++++++++++++++++++++++++++++
	lds	xtmp,S_MotorParking			;���� ���� ����� ���� �� ��� ���, ���� �� �� �������� �� ����� �������.
    sbrc  xtmp,f_MotorInStart		;��� ������ �������� ���������, �� ���� ��������������� � ������� ���-
	rjmp CountCout     				;������ ��������������� � �������� � ����� "����� � ������"
									;��� ������ �� ������ ������ ����, ���� ����� ��������� � ��������� ��������
									;��������
;++++++++++++++++++++++++++++++++++
	lds	xtmp,S_FlagButt1			;��� ���� ��������� �����. ����� � �������� ������ S_PauseButt ��������
    sbrc xtmp,f_PauseSetted			;������ ��� �� ����������.� ����� ��������?
	rjmp CountCout                  ;�� ����������. ����� �������� �� ������ �������� ��� ����� 2. � ���� ����� �� 		
;++++++++++++++++++++++++++++++++++
	sbi PORTC,Pulse							;����� ������ ���� ��� ��� �������� � ������� ������ �� �������.
	inc Regdelay							; ��������� ��������, ���� �� ����� ��������  ������ ���������� �����, ����� ������������
	cpi Regdelay, OptimalMeandrConstStepMot	;�������� ������ ����� ����������� ������ ������������  ������� ������.
	brne	PointExit						;
	cbi PORTC,Pulse							;����� �� ��������� � ������� ������ ������� �� ������.
	clr	Regdelay		
	adiw RegReverseL,1	;
;+++++++++++++++++++++++++++++++++++
	lds	tmp,S_MotorHighPointL		;S_MotorHighPointL �������� ���������, ���������� �������. �� ���� ��� ���������	
	lds	tmp2,S_MotorHighPointH		;���������� �����, ����� ������� ��������� �������� ������.
	cp	tmp,RegReverseL				;RegReverse(L,H) ����������������, � ����� �� ������ ������ S_MotorHighPoint((L,H)	
	cpc	tmp2,RegReverseH			;���������� ������.
	PointExit:
	brne WayToExit
;+++++++++++++++++++++++++++++++++++
	sbrc FlagReg,f_reverse			;���� ���� �������� �� ����������� ��������.
	rjmp ReversOff
;:++++++++++++++++++++++++++++++++++++
	;��� ����� �������� �� �������� ��������� ��� ��������� �������
	lds  xtmp,S_MotorParking		;������ �������� � PrepairForParking, ��� ���������, � �����								
	sbrs xtmp, f_FinishParking		;�������� �� FinishParking.
	rjmp PrepairForParking			;
		FinishParking:
	sbr  xtmp,m_MotorInStart		;���� �� ��������, ����� �������� ���������.��� ���� ��� 
	sts  S_MotorParking,xtmp		;����� �������� ��������� ���������, � ������� �� � ������� ���
	rcall ReadEEPROM
	rjmp CountCout		
    	PrepairForParking:			
	lds xtmp,S_MotorParking			;
	sbrc xtmp,f_FirstCicle
	rjmp NoParking
	ldi tmp,0						;��� ��������� ���� �� ����� � ���. ����� ����� ���������
	sts	S_MotorHighPointH,tmp		;����� � ������ 15 ����� � ��� � �����������.ParkingConst
	ldi tmp,ParkingConst			;��� ��������� ��� ���������� �������� ������ ��� ��������
	sts	S_MotorHighPointL,tmp
	sbr xtmp,m_FinishParking
	sts S_MotorParking,xtmp
	NoParking:		
;+++++++++++++++++++++++++++++++++++++
	cbi PORTC,Reverse		;����� f_reverse=0, �� ��������� ����� ���� � ������� ������� ����� 
	sbr	FlagReg,m_reverse
	clr	RegReverseL
	clr	RegReverseH
	cbr	FlagReg,m_CountAndMotor ;��� ����� ������� ������������� ������ � �������� �� ����������
	;
	;���� ���������� ���� ����, ��� ���� ������ �������� �������, � ���� �� �������� �����, �� � ���������
	;������� �� ���������� C_ConstLowPointPar, ������� ��� ����� ������ ���������, ������� S_MotorHighPointL
	;��� ����� ���������� �������.�� ���� ���� ����� ������� ������� ���� ��� ������.��� ����� ����������
	;����������� ������������ �������� ����� �� ������������ ��� �����.
	lds  xtmp, S_FlagOfButtSubroutine	;
    sbrs xtmp,f_PeriodicParking
	rjmp ParkingPoint
	lds	XL,S_MotorHighPointL
	lds	XH,S_MotorHighPointH
	ldi ZL,low(C_ConstLowPointPark)
	ldi ZH,high(C_ConstLowPointPark)
	add XL,ZL
	adc XH,ZH
	sts S_MotorHighPointL,XL
	sts S_MotorHighPointH,XH
	cbr xtmp,m_PeriodicParking
	sbr xtmp,m_StabilizeConstReverse
	sts S_FlagOfButtSubroutine,xtmp
	;
	;�������� �� ������ �������, �������������� ���� f_ParkingButt. ����� ����� �� ����� ����� � ���
	;�� ����������� ���� f_ParkingLowPoint. ����� ����� ��� ������ ���� ������ �� ���, � �������� �������
	;�������������� ����� f_ParkingLowPoint. ���� �� ����, ��������������� ���� m_MotorInStart. �� �� ����
	;��������� �� ����� ���������� T0ovf.������������ m_MotorInStart �������� ������ ����
ParkingPoint:
	lds	 tmp,S_MotorParking		;������� ��������, ��� ���� �� ��������������� � ������������ 
	sbrs tmp,f_ParkingLowPoint	;� ������������� �������� ��������� ������ ���� ���������.
	rjmp CountCout				;
	sbr  tmp,m_MotorInStart		;
	cbr tmp,m_ParkingLowPoint	;
	cbr tmp,m_ButtStartWasWork
	sts S_MotorParking,tmp		
	;
  WayToExit:
	rjmp CountCout

	ReversOff:					;��� ���� ������ ��������� �����, ���������� �� ��������� ���������
	lds  tmp,S_FlagButt2		;� ������� ���� � ������ ���������� ����� �� � ���.�����, ���� � ���
	sbrs tmp,f_ConstStore		;��������� ����� ������� � ���� �������� � ���, �� �������� , ��� � ����
	rjmp ReverseOff_2			;�� ����� ������������� ����� ��������� ��������� ������, ��� �����, ����
	lds  tmp2,S_ConstStoreL		;�������� � ��.
	lds	 tmp3,S_ConstStoreH
	sts	 S_MotorHighPointL,tmp2
	sts  S_MotorHighPointH,tmp3
	cbr	 tmp,m_ConstStore		;���� ���� ���������������, ���� ������ ���� ���� ������  ������ "����� ����"
	sts  S_FlagButt2,tmp
	ReverseOff_2:
;+++++++++++++++++++++++++++++++++++++			;����� f_reverse=1, �� ��������� ����� ���� � ������ ������� ����� 
	sbi	PortC,Reverse			
	cbr FlagReg,m_reverse
	clr	RegReverseL
	clr	RegReverseH
	sbr	FlagReg,m_CountAndMotor
	cbr FlagReg,m_IncrOne
	;
	;f_StabilizeConstReverse ������� � ���, ��� �� ������ �������� � ���. �� ������������������ ��������� 
	;��� ���� �������� � �� ���� ������� � �������������������� ���������, ����� �� ��� �  ����� ������
	;�������� ������. ������� ��� ������ �� ����� �� ���, � ��� ������ f_reverse=1, �� �� �����
	;��������� ������� � ������� �������� C_ConstLowPointPark, ��� ���� ������� ������� �����, ������� ���� 
	;�� ��������. 
	lds xtmp,S_FlagOfButtSubroutine		;
	sbrs xtmp,f_StabilizeConstReverse
	rjmp SoubrtneParkingInLow
    lds	XL,S_MotorHighPointL			;S_MotorHighPointL-���������� ��������� ������� ��� ����� ���� ��
	lds	XH,S_MotorHighPointH
	ldi ZL,low(C_ConstLowPointPark)
	ldi ZH,high(C_ConstLowPointPark)
	sub XL,ZL
	sbc XH,ZH
	sts S_MotorHighPointL,XL
	sts S_MotorHighPointH,XH
	cbr xtmp,m_StabilizeConstReverse
	sts S_FlagOfButtSubroutine,xtmp
	;	
 SoubrtneParkingInLow:
	lds	 tmp,S_MotorParking    ;��� ����� ��������� ��������� ������ ������� (��. ����). ���������� 
	sbrs tmp,f_ParkingButt	   ;��������� ������ �� ����� ���� �� ����.
	rjmp CountCout
	sbr tmp,m_ParkingLowPoint
	cbr tmp,m_ParkingButt
	sts  S_MotorParking,tmp
	;
	CountCout:
	sei
	POP_ALL
MotorOut:
	reti
    
	


