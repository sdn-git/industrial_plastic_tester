
;/// LED control. Disable all leds except the one pushed
ClrLeds: 
	Push_ALL
	cli
	lds tmp3,S_LK0
	sbr tmp3,F_k0
	cbr tmp3,M_L2
	sts S_LK0,tmp3

	lds tmp3,S_LK1
	sbr tmp3,F_k0
	cbr tmp3,M_L2
	sts S_LK1,tmp3

	lds tmp3,S_LK2
	sbr tmp3,F_k0
	cbr tmp3,M_L2
	sts S_LK2,tmp3

	lds tmp3,S_LK3
	sbr tmp3,F_k0
	cbr tmp3,M_L2
	sts S_LK3,tmp3

	sei
	POP_All
ret
