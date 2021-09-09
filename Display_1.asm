Display_1:
	SHOW_onLCD 0x00,'V'
	SHOW_onLCD 0x01,'L'
	SHOW_onLCD 0x02,'A'
	SHOW_onLCD 0x03,'D'
	SHOW_onLCD 0x04,'I'
	SHOW_onLCD 0x05,'M'
	SHOW_onLCD 0x06,'I'
	SHOW_onLCD 0x07,'R'
	SHOW_onLCD 0x40,' '
	SHOW_onLCD 0x41,' '
	SHOW_onLCD 0x42,' '
	SHOW_onLCD 0x43,' '
	SHOW_onLCD 0x44,' '
	SHOW_onLCD 0x45,' '
	SHOW_onLCD 0x46,' '
	SHOW_onLCD 0x47,' '
	clr	LCDChooser
ret
