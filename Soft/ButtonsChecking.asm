ButtonsChecking:
;�������� �������������� ������� ������.���� ������ �� 2 ������ ������������, �� ��� ������ ��
;��������� �� ��� �������.
;���� ������ ������ �� � F_K� ������ ��� ����� ����.
;� ����� ������ �� ������, �� ����� ��������.(!!!!!).��������, ���  ���� �� ����
;������ �� ������, �� ����� ������ F_Kx ����� S_LKx ����� ����� 5 (������ ���������
;�� 2 ������ �� 5 � ������). ���� ������ �������� �� ���������� ����������/����������,
;������ �� ����� ��� ��.).���� ������ 1 ������, �� 4, ���� 2 �� 3 �������������.	 
;
;������� �� ��������� 1 ������
	clr tmp
	clr xtmp
	lds	XL,low(S_LK0)	;��������� ������ �� ��� � ������� X.
	lds	XH,high(S_LK0)	;
	bst	XL,F_K0			;���������� �������� ����� F_K0 � �������� X � � ( � � ������ ��� 0 ��� 1)		
	bld	tmp,0			;��������� � �������� � �������� � ������� ������ ���
	add xtmp,tmp		;������ ���������� � ���� (������ � ������ ����).
		
	lds	XL,low(S_LK1)	; ���� ��� �� �� �����
	lds	XH,high(S_LK1)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp		;������ ��������� 0 ��� 1  � ������.	
	
	lds	XL,low(S_LK2)	;
	lds	XH,high(S_LK2)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp		;����� ��������� 0 ��� 1  � ������.
	
	lds	XL,low(S_LK3)	;
	lds	XH,high(S_LK3)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp		;����� ��������� 0 ��� 1  � ������.
	;����� ���� �������� � xtmp ���� �����-�� �����.������ ������ ����� �����.
	cpi	xtmp,NoButtPushed	;������� �� ���� ������� �� ������?
	brne	EqualOne_1		;��-� ���-�� ������, ������� ��� � ����� EqualOne_1
	rjmp YesButt_1			;��, �� ���� ������ �� ������!������ ���� �� YesButt_1.
	EqualOne_1:
	cpi	xtmp,OneButtPushed	;� ���� ������ ������?
	brne MoreButtPushed_1 	;���.���� ���-�� ������, � ��� �� �������� ����� �������, ������ ������������!
						  	;������� ��� �� ����� MoreButtPushed_1
	rjmp YesButt_1		   ;��, ������ 1 ������. ��������� �� YesButt_1	
	MoreButtPushed_1:
	sbr	FlagReg,m_MoreOneButt_1;��������� ����, ��������� �������� ������ ������� ������ ����� ����������
							   ;��� ������, ��� �� ����� ���������� ���������, � ������ �� ����� ��������� ���� 
							   ;�������
	rjmp SecondGroup
	YesButt_1:
	cbr	FlagReg,m_MoreOneButt_1;������ ����, ����� ������� ������ �������������� 
;
	SecondGroup:
;	��������� ������ ������ ������ (����������� ��. ����) 
	clr xtmp
	clr tmp
	lds	XL,low(S_LK0)	;
	lds	XH,high(S_LK0)
	bst	XL,F_K1
	bld	tmp,0
	add	xtmp,tmp	
		
	lds	XL,low(S_LK1)	;
	lds	XH,high(S_LK1)
	bst	XL,F_K1
	bld	tmp,0
	add	xtmp,tmp	
	
	lds	XL,low(S_LK2)	;
	lds	XH,high(S_LK2)
	bst	XL,F_K1
	bld	tmp,0
	add	xtmp,tmp	
	
	lds	XL,low(S_LK3)	;
	lds	XH,high(S_LK3)
	bst	XL,F_K1
	bld	tmp,0
	add	xtmp,tmp	
 
	cpi	xtmp,NoButtPushed
	brne	EqualOne_2
	rjmp YesButt_2
	EqualOne_2:
	cpi	xtmp,OneButtPushed
	brne MoreButtPushed_2
	rjmp YesButt_2
	MoreButtPushed_2:
	sbr	FlagReg,m_MoreOneButt_2
	rjmp ProcessPassed
	YesButt_2:
	cbr	FlagReg,m_MoreOneButt_2
    ProcessPassed:
ret
