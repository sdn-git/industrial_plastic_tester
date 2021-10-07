
; ///HEX to DECIMAL numerical converter (16 bit operation).
; ///(Registers: X).
; ///X=source HEX word.
; /// S_D1,S_D2,S_D3,S_D4,S_D5=destination DEC ciphers SRAM cells.

HEX2DEC:
	push	TMP
	push	xtmp
	push	tmp2
	PUSH_Y
	clr	TMP		;Clear the decade digit counters.
	sts	S_D1,TMP
	sts	S_D2,TMP
	sts	S_D3,TMP
	sts	S_D4,TMP
	sts	S_D5,TMP
	sts	S_D6,TMP
	sts	S_D7,TMP
	sts	S_D8,TMP
	;

H2B_8D:	

ldi	tmp2,BYTE4(10000000)			;10000000
ldi	xtmp,BYTE3(10000000)
ldi	YH,BYTE2(10000000)
ldi	YL,LOW(10000000)

H2B_8:	
	cp	XL,YL		
	cpc	XH,YH
	cpc	ZL,xtmp
	cpc	ZH,tmp2
	brcs	H2B_7D		
	sub	XL,YL
	sbc	XH,YH
	sbc	ZL,xtmp
	sbc	ZH,tmp2
	S_INC	S_D8		;otherwise increment the 10000 decade counter.
	rjmp	H2B_8		;Try compare again.

H2B_7D:	;///1000000

	ldi	tmp2,BYTE4(1000000)			
	ldi	xtmp,BYTE3(1000000)
	ldi	YH,BYTE2(1000000)
	ldi	YL,LOW(1000000)

H2B_7:	
	cp	XL,YL		
	cpc	XH,YH
	cpc	ZL,xtmp
	cpc	ZH,tmp2
	brcs	H2B_6D				
	sub	XL,YL
	sbc	XH,YH
	sbc	ZL,xtmp
	sbc	ZH,tmp2
	S_INC	S_D7		
	rjmp	H2B_7	

H2B_6D:	;100000
	ldi	tmp2,BYTE4(100000)			;100000
	ldi	xtmp,BYTE3(100000)
	ldi	YH,BYTE2(100000)
	ldi	YL,LOW(100000)

H2B_6:	
	cp	XL,YL		
	cpc	XH,YH
	cpc	ZL,xtmp
	cpc	ZH,tmp2
	brcs	H2B_5D	  
	sub	XL,YL
	sbc	XH,YH
	sbc	ZL,xtmp
	sbc	ZH,tmp2
	S_INC	S_D6		
	rjmp	H2B_6		

H2B_5D:	;10000
	ldi	tmp2,BYTE4(10000)			;10000
	ldi	xtmp,BYTE3(10000)
	ldi	YH,BYTE2(10000)
	ldi	YL,LOW(10000)

H2B_5:	
	cp	XL,YL		
	cpc	XH,YH
	cpc	ZL,xtmp
	cpc	ZH,tmp2
	brcs	H2B_4D		 
	sub	XL,YL
	sbc	XH,YH
	sbc	ZL,xtmp
	sbc	ZH,tmp2
	S_INC	S_D5		 
	rjmp	H2B_5		
 
H2B_4D:	;1000
	ldi	tmp2,BYTE4(1000)			;1000
	ldi	xtmp,BYTE3(1000)
	ldi	YH,BYTE2(1000)
	ldi	YL,LOW(1000)

H2B_4:	
	cp	XL,YL		
	cpc	XH,YH
	cpc	ZL,xtmp
	cpc	ZH,tmp2
	brcs	H2B_3D		
	sub	XL,YL
	sbc	XH,YH
	sbc	ZL,xtmp
	sbc	ZH,tmp2
	S_INC	S_D4		
	rjmp	H2B_4		
  
H2B_3D:	;100
	ldi	tmp2,BYTE4(100)			;100
	ldi	xtmp,BYTE3(100)
	ldi	YH,BYTE2(100)
	ldi	YL,LOW(100)

H2B_3:	
	cp	XL,YL		
	cpc	XH,YH
	cpc	ZL,xtmp
	cpc	ZH,tmp2
	brcs	H2B_2D		
	sub	XL,YL
	sbc	XH,YH
	sbc	ZL,xtmp
	sbc	ZH,tmp2
	S_INC	S_D3		 
	rjmp	H2B_3		

H2B_2D:	;10
	ldi	tmp2,BYTE4(10)			;10
	ldi	xtmp,BYTE3(10)
	ldi	YH,BYTE2(10)
	ldi	YL,LOW(10)
	
H2B_2:	
	cp	XL,YL		
	cpc	XH,YH
	cpc	ZL,xtmp
	cpc	ZH,tmp2
	brcs	H2B_1D		
	sub	XL,YL
	sbc	XH,YH
	sbc	ZL,xtmp
	sbc	ZH,tmp2
	S_INC	S_D2		
	rjmp	H2B_2		

H2B_1D:	;1
	ldi	tmp2,BYTE4(1)			;1
	ldi	xtmp,BYTE3(1)
	ldi	YH,BYTE2(1)
	ldi	YL,LOW(1)

H2B_1:	
	cp	XL,YL		
	cpc	XH,YH
	cpc	ZL,xtmp
	cpc	ZH,tmp2
	brcs	H2B_END	  
	sub	XL,YL
	sbc	XH,YH
	sbc	ZL,xtmp
	sbc	ZH,tmp2
	S_INC	S_D1		
	rjmp	H2B_1		

H2B_END:
	POP_Y
	pop	tmp2
	pop	xtmp
	pop	TMP
	ret
;----------------------------------------------------------------------------
;/// LED segment control
SEVSG:  
	cpi  TMP,0
	brne  SEVSG1
	ldi  TMP,_0
	ret
	
SEVSG1: 
	cpi  TMP,1
	brne  SEVSG2
	ldi  TMP,_1
	ret
	
SEVSG2:  
	cpi  TMP,2
  	brne  SEVSG3
  	ldi  TMP,_2
  	ret
	
SEVSG3:  
	cpi  TMP,3
  	brne  SEVSG4
  	ldi  TMP,_3
  	ret
	
SEVSG4:  
	cpi  TMP,4
  	brne  SEVSG5
  	ldi  TMP,_4
  	ret
	
SEVSG5:  
	cpi  TMP,5
  	brne  SEVSG6
  	ldi  TMP,_5
  	ret
	
SEVSG6: 
	cpi  TMP,6
  	brne  SEVSG7
  	ldi  TMP,_6
  	ret
	
SEVSG7: 
	cpi  TMP,7
  	brne  SEVSG8
  	ldi  TMP,_7
  	ret
	
SEVSG8:  
	cpi  TMP,8
  	brne  SEVSG9
  	ldi  TMP,_8
  	ret
	
SEVSG9:  
	ldi  TMP,_9
ret
;----------------------------------------------------------------------------

;-- DEC buffer to 7-th segment code convertor.
; (Registers: X).
;X=source HEX word.
;S_D1,S_D2,S_D3,S_D4,S_D5=destination 7seg codes.
;

DEC2SEVSG:
  push  TMP
  lds  TMP,S_D1  
  rcall  SEVSG    
  sts  S_D1,TMP   
  
  lds  TMP,S_D2  
  rcall  SEVSG     
  sts  S_D2,TMP   
  
  lds  TMP,S_D3  
  rcall  SEVSG    
  sts  S_D3,TMP  
  
  lds  TMP,S_D4  
  rcall  SEVSG     
  sts  S_D4,TMP   
  
  lds  TMP,S_D5  
  rcall  SEVSG    
  sts  S_D5,TMP  
  
  lds  TMP,S_D6  
  rcall  SEVSG     
  sts  S_D6,TMP
  
  lds  TMP,S_D7  
  rcall  SEVSG    
  sts  S_D7,TMP

  lds  TMP,S_D8  
  rcall  SEVSG    
  sts  S_D8,TMP

  pop  TMP
  ret
  
;---------------------------------------------------------------------------- ---------------------------------------------------------------------------
;/// Segment decoding
.equ  _deg  =0b10011100  
.equ  _com  =0b01111111  
.equ  _spc  =0b11111111  
.equ  _min  =0b10111111  
.equ  _und  =0b11110111  

.equ  _0  =0b11000000  
.equ  _1  =0b11111001
.equ  _2  =0b10100100
.equ  _3  =0b10110000
.equ  _4  =0b10011001
.equ  _5  =0b10010010
.equ  _6  =0b10000010
.equ  _7  =0b11111000
.equ  _8  =0b10000000
.equ  _9  =0b10010000
;
.equ  _Ab  =0b10001000  
.equ  _Bs  =0b10000011 
.equ  _Cb  =0b11000110
.equ  _Cs  =0b10100111

.equ  _Ds  =0b10100001
.equ  _Eb  =0b10000110
.equ  _Fb  =0b10001110
.equ  _Gb  =0b11000010
.equ  _Hb  =0b10001001
.equ  _Hs  =0b10001011
.equ  _Ib  =0b11111001
.equ  _Is  =0b11111011
.equ  _Jb  =0b11110001
.equ  _Js  =0b11110011
.equ  _Lb  =0b11000111
.equ  _Ls  =0b11100111
.equ  _Ns  =0b10101011
.equ  _Ob  =0b11000000
.equ  _Os  =0b10100011
.equ  _Pb  =0b10001100
.equ  _Sb  =0b10010010
.equ  _Ub  =0b11000001
.equ  _Us  =0b11100011
.equ  _Yb  =0b10010001
