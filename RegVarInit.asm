 
.def	tmp		=r16 
.def	xtmp		=r17
.def	tmp2		=r18
.def	FlagReg	        =r19 
.def	RegDelay	=r20 
.def	CmprL		=r21 
.def	CmprH		=r22
.def	tmp3	        =r23
.def	RegReverseL	=r24 
.def	RegReverseH	=r25
.def	RegDelayL	=r28
.def	RegDelayH	=r29

.equ	DataPort	=PORTA		
.equ	DataPort0	=PA0
.equ	DataPort1	=PA1
.equ	DataPort2	=PA2
.equ	DataPort3	=PA3
.equ	DataPort4	=PA4
.equ	DataPort5	=PA5
.equ	DataPort6	=PA6
.equ	DataPort7	=PA7

.equ	ButtonsPort	=PORTB
.equ	ButtSelect	=PB0	
.equ	ButtMove   	=PB1	

.equ    ControlPort	=PORTC
.equ	EPort		=PC4	
.equ	RSPort		=PC5	
.equ	LED1		=PC6	
.equ	LED2		=PC7		


.equ	Const500	=500		
.equ	Const1000	=1000
.equ	Const5000	=5000
.equ	Const10000	=10000
.equ	C_ParkingNorm	=100    
.equ    ParkingConst	=15	   
							 	
.equ    C_ConstLowPointPark=130 ;

.equ	Const200	=180	
.equ	Const250	=230
.equ	Const300	=280
.equ	Const350	=350
.equ	Const400	=400

.equ    OptimalMeandrConstStepMot=0x02
.equ 	E_OpenCloseAddrL=0		
.equ 	E_OpenCloseAddrH=1		
.equ 	E_LengthAddrL 	=2		
.equ 	E_LengthAddrH	=3		
.equ	NoButtPushed	=4
.equ	OneButtPushed	=3

.equ	f_FIRSTPUSH_1	=0			
.equ	M_FIRSTPUSH_1	=0B00000001
.equ	f_FIRSTPUSH_2	=1
.EQU	M_FIRSTPUSH_2	=0B00000010
.equ	f_EEPROMpush	=2			
.equ	m_EEPROMpush	=0B00000100
.equ	f_MoreOneButt_1	=3			
.equ	m_MoreOneButt_1	=0B00001000	
.equ	f_MoreOneButt_2	=4			
.equ	m_MoreOneButt_2	=0B00010000
.equ	f_IncrOne	=5
.equ	m_IncrOne	=0B00100000     
.equ	f_PauseButt	=6		    
.equ	m_PauseButt	=0b01000000
.equ	f_CountAndMotor	=7			
.equ	m_CountAndMotor =0B10000000

#define DATA_PORT PORTA
#define CODE_PORT PORTC
#define CHAR_PORT PORTC

.equ	P_CODE	=PC0
.equ	P_CHAR	=PC3	
	;
.equ	PULSE	=PC2	
.equ	Reverse	=PC1	

.equ	f_reverse= 0         
.equ	m_reverse= 0b00000001 
	
.equ	S_D1	=0x060	
.equ	S_D2	=0x061
.equ	S_D3	=0x062
.equ	S_D4	=0x063
.equ	S_D5	=0x064

.equ	S_D6	=0x089	
.equ	S_D7	=0x090
.equ	S_D8	=0x091

#define	S_C_LED	0x065	
.equ	screen1	=0x066
.equ	S_1LED1	=0x066
.equ	S_1LED2	=0x067
.equ	S_1LED3	=0x068
.equ	S_1LED4	=0x069
.equ	S_1LED5	=0x06a
.equ	screen2	=0x06b
.equ	S_2LED1	=0x06b
.equ	S_2LED2	=0x06c
.equ	S_2LED3	=0x06d
.equ	S_2LED4	=0x06e
.equ	S_2LED5	=0x06f	

.equ	S_LK0	=0x070	
.equ	S_LK1	=0x071
.equ	S_LK2	=0x072
.equ	S_LK3	=0x073
.equ	S_LK4	=0x074

.equ	F_K0	=0			
.equ	M_K0	=0b00000001
.equ	F_K1	=1			
.equ	M_K1	=0b00000010
.equ	F_L2	=2			
.equ	M_L2	=0b00000100
.equ	F_L3	=3			
.equ	M_L3	=0b00001000

.equ	S_counterL    =0x075
.equ	S_counterH    =0x076
.equ	S_FirstGroup  =0x077
.equ	S_SecondGroup =0x078
.equ	S_LimitL      =0x079
.equ	S_LimitH      =0x07a
		
.equ	S_FlagButt1	=0x07b
.equ	f_Butt11	=0			
.equ	m_Butt11	=0b00000001
.equ	f_Butt12	=1			
.equ	m_Butt12	=0b00000010
.equ	f_Butt13	=2			
.equ	m_Butt13	=0b00000100
.equ	f_Butt14	=3			
.equ	m_Butt14	=0b00001000
.equ	f_Butt15	=4			
.equ	m_Butt15	=0b00010000
.equ	f_PauseSetted	=5			
.equ	m_PauseSetted	=0b00100000	
.equ	f_NoFirstIncr	=6
.equ	m_NoFirstIncr	=0b01000000
	
.equ	S_FlagButt2	=0x07f
.equ	f_Butt21	=0
.equ	m_Butt21	=0b00000001
.equ	f_Butt22	=1
.equ	m_Butt22	=0b00000010
.equ	f_Butt23	=2
.equ	m_Butt23	=0b00000100
.equ	f_Butt24	=3
.equ	m_Butt24	=0b00001000
.equ	f_Butt25	=4
.equ	m_Butt25	=0b00010000
.equ	f_OnlyStart	=6
.equ	m_OnlyStart 	=0b01000000
.equ	f_ConstStore	=7			
.equ	m_ConstStore    =0b10000000 

.equ	S_MotorHighPointL=0x07c
.equ	S_MotorHighPointH=0x07d

.equ	S_MotorParking	  =0x080		
.equ	f_FirstCicle	  =0			
.equ	m_FirstCicle	  =0b00000001
.equ	f_FinishParking	  =1
.equ	m_FinishParking	  =0b00000010
.equ	f_MotorInStart	  =2
.equ	m_MotorInStart	  =0b00000100		
.equ	f_ButtStartWasWork=3
.equ	m_ButtStartWasWork=0b00001000
.equ	f_ParkingButt	  =4
.equ	m_ParkingButt	  =0b00010000
.equ	f_ParkingLowPoint =5
.equ	m_ParkingLowPoint=0b00100000	
.equ	f_ParkingHighPoint=6
.equ	m_ParkingHighPoint=0b01000000
.equ	f_PushParking	  =7
.equ	m_PushParking	  =0b10000000
.equ	S_ConstStoreL	  =0x081; 
.equ	S_ConstStoreH	  =0x082; 

.equ	S_FlagOfButtSubroutine	=0x083
.equ	f_PeriodicParking	=0			
.equ	m_PeriodicParking	=0b00000001
.equ	f_StabilizeConstReverse	=1	
.equ	m_StabilizeConstReverse	=0b00000010
.equ	f_ReadyCount		=2
.equ	m_ReadyCount		=0b00000100
.equ	f_ParkingDenied		=3
.equ	m_ParkingDenied		=0b00001000
.equ	f_PauseDenied		=4
.equ	m_PauseDenied		=0b00010000

.equ	S_ParkingNormL		=0x084
.equ	S_ParkingNormH		=0x085
	
.equ	HD44780_ClearDisplay 	= 0b00000001
.equ	HD44780_ReturnHome	= 0b00000010

.equ	HD44780_EntryModeSet0 = 0b00000110;---
.equ	HD44780_EntryModeSet1 = 0b00000001
.equ	HD44780_EntryModeSet2 = 0b00000001
.equ	HD44780_EntryModeSet3 = 0b00000001

.equ	HD44780_DisplayOnOffControl0 = 0b00001111;---
.equ	HD44780_DisplayOnOffControl1 = 0b00000001
.equ	HD44780_DisplayOnOffControl2 = 0b00000001
.equ	HD44780_DisplayOnOffControl3 = 0b00000001

.equ	HD44780_CursorOrDisplayShift0 = 0b00010100;---
.equ	HD44780_CursorOrDisplayShift1 = 0b00000001
.equ	HD44780_CursorOrDisplayShift2 = 0b00000001
.equ	HD44780_CursorOrDisplayShift3 = 0b00000001

.equ	HD44780_FunctionSet0 = 0b00111000;---
.equ	HD44780_FunctionSet1 = 0b00000001
.equ	HD44780_FunctionSet2 = 0b00000001
.equ	HD44780_FunctionSet3 = 0b00000001

.equ	cmd1=0b00110000
.equ	cmd2=0b00001110
.equ	cmd3=0b00000110
.equ	cmd4=0b01000000
