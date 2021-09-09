
.device ATmega8
.include "m8def.inc"
.include "RegVarInit.asm"

.cseg
.org 0
	rjmp	Reset
	rjmp	EXT_INT0
	rjmp	EXT_INT1
	rjmp	OUT_COMPARE2
	rjmp	OVF_T2
	rjmp	ICP_INT1
	rjmp	OC1A_INT
	rjmp	OC1B_INT
	rjmp	OVF_T1
	rjmp	OVF_T0
	rjmp	SPI_INT
	rjmp	URXC_INT
	rjmp	UDRE_INT
	rjmp	UTXC_INT
	rjmp	ADCC_INT
	rjmp	ERDY_INT
	rjmp	ACI_INT
	rjmp	TWI_INT
	rjmp	SPM_INT

EXT_INT0:
	reti
EXT_INT1:
	reti
OUT_COMPARE2:
	reti
OVF_T2:
	reti
ICP_INT1:
	reti
OC1A_INT:
	reti
OC1B_INT:
	reti
OVF_T1:
	reti
OVF_T0:
	reti
SPI_INT:
	reti
URXC_INT:
	reti
UDRE_INT:
	reti
UTXC_INT:
	reti
ADCC_INT:
	reti
ERDY_INT:
	reti
ACI_INT:
	reti
TWI_INT:
	reti
SPM_INT:
	reti
	
   .include "LCDPortsTimersInit.asm"


	Reset:
	cli
	ldi	tmp,low(RAMEND)
	out	SPL,tmp
	ldi	tmp,high(RAMEND)
	out	SPH,tmp
	
	rcall	Little_Pause


	rcall LCDPortsTimersInit
cycle:
	SHOW_onLCD 0x01,'a'
	SHOW_onLCD 0x0B,'b'
	SHOW_onLCD 0x11,'c'
	SHOW_onLCD 0x15,'d'
	SHOW_onLCD 0x40,'e'
	SHOW_onLCD 0x41,'+'
	SHOW_onLCD 0x42,'+'
	SHOW_onLCD 0x43,'+'

cycle1:rjmp cycle1



Write_AddrLCD:; TMP - ADDRESS
	;ADDRESS
	cbi	ControlPort,RSPort
	rcall	Little_Pause
	sbi	ControlPort,EPort
	rcall   Little_Pause
	out	DataPort,tmp
	rcall	Little_Pause
	cbi	ControlPort,EPort
	rcall Little_Pause
	ret

Write_DataLCD:; TMP - DATA
	;DATA
	sbi	ControlPort,RSPort
	rcall	Little_Pause
	sbi	ControlPort,EPort
	rcall	Little_Pause
	out	DataPort,tmp
	rcall	Little_Pause
	cbi	ControlPort,EPort
	rcall	Little_Pause
	;
	ret
	

Little_Pause:
	push	TMP
	ser	TMP
LittleP_cycle:
	nop
	dec	TMP
	brne	LittleP_cycle
	pop	TMP
	ret

Large_Pause:
	push	TMP
	ldi	TMP,255
LargeP_cycle:
	rcall	Little_Pause
	dec	TMP
	brne	LargeP_cycle
	pop	TMP
	ret
