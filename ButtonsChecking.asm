; /// Check first buttons group: two buttons cannot be pushed simultaneously
ButtonsChecking: 
	clr tmp
	clr xtmp
	lds	XL,low(S_LK0)	
	lds	XH,high(S_LK0)	
	bst	XL,F_K0					
	bld	tmp,0			
	add     xtmp,tmp
	
	lds	XL,low(S_LK1)	
	lds	XH,high(S_LK1)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp			
	
	lds	XL,low(S_LK2)	
	lds	XH,high(S_LK2)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp		
	
	lds	XL,low(S_LK3)
	lds	XH,high(S_LK3)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp		 
	
	cpi	xtmp,NoButtPushed	
	brne	EqualOne_1		
	rjmp    YesButt_1
	
/// One button is pushed	
EqualOne_1: ; 
	cpi	xtmp,OneButtPushed
	brne    MoreButtPushed_1 	
	rjmp    YesButt_1		        ;// One button is pushed

/// More than one button is pushed	
MoreButtPushed_1:
	sbr	FlagReg,m_MoreOneButt_1         ;// The button has been processed
	rjmp SecondGroup
	YesButt_1:
	cbr	FlagReg,m_MoreOneButt_1 
	
; /// Check second buttons group: two buttons cannot be pushed simultaneously
SecondGroup:
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
	
/// One button is pushed		
EqualOne_2:
	cpi	xtmp,OneButtPushed
	brne MoreButtPushed_2
	rjmp YesButt_2

/// More than one button is pushed
MoreButtPushed_2:
	sbr	FlagReg,m_MoreOneButt_2
	rjmp ProcessPassed
	
YesButt_2:
	cbr	FlagReg,m_MoreOneButt_2
    ProcessPassed:
ret
