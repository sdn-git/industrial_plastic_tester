;/// Initial page for the LCD
Display_1:
	SHOW_onLCD 0x00,'I'
	SHOW_onLCD 0x01,'N'
	SHOW_onLCD 0x02,'I'
	SHOW_onLCD 0x03,'T'
	SHOW_onLCD 0x04,' '
	SHOW_onLCD 0x05,'M'
	SHOW_onLCD 0x06,'O'
	SHOW_onLCD 0x07,'D'
	SHOW_onLCD 0x40,'E'
	SHOW_onLCD 0x41,' '
	SHOW_onLCD 0x42,' '
	SHOW_onLCD 0x43,' '
	SHOW_onLCD 0x44,' '
	SHOW_onLCD 0x45,' '
	SHOW_onLCD 0x46,' '
	SHOW_onLCD 0x47,' '
	clr	LCDChooser
ret
