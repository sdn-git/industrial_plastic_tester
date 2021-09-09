 
.def	tmp			=r16 ;РОН
.def	xtmp		=r17
.def	tmp2		=r18
.def	FlagReg	    =r19 ;Регистр Флагов
.def	RegDelay	=r20 ;Используется для создания задержки
.def	CmprL		=r21 
.def	CmprH		=r22
.def	tmp3	=r23	 ;РОН
.def	RegReverseL	=r24 ;Там инкрементируется число, определяющее время переключения реверса
.def	RegReverseH	=r25
.def	RegDelayL	=r28
.def	RegDelayH	=r29

.equ	DataPort	=PORTA		;вывод информации на сегментный индикатор.
	.equ	DataPort0	=PA0
	.equ	DataPort1	=PA1
	.equ	DataPort2	=PA2
	.equ	DataPort3	=PA3
	.equ	DataPort4	=PA4
	.equ	DataPort5	=PA5
	.equ	DataPort6	=PA6
	.equ	DataPort7	=PA7

.equ	ButtonsPort	=PORTB
	.equ	ButtSelect	=PB0	;Порты с которых непосредственно считывают состояние кнопки первой группы
	.equ	ButtMove   	=PB1	;Порты с которых непосредственно считывают состояние кнопки второй группы

.equ    ControlPort	=PORTC
	.equ	EPort		=PC4	;Команды записи/чтения для инициализации/управления -
	.equ	RSPort		=PC5	;ЖК-дисплееем
	.equ	LED1	=PC6		;Зажигание СД первой группы
	.equ	LED2	=PC7		;Зажигание СД второй группы


.equ	Const500	=500		;константы количесвта открываний/закрываний
.equ	Const1000	=1000
.equ	Const5000	=5000
.equ	Const10000	=10000
.equ	C_ParkingNorm	=100    ;константа периодической парковки ( подробнее в int.asm)
.equ    ParkingConst	=15	    ;Константа нужна при парковки. Включили прибор, шток пошел вниз
							 	;дошел до конца, и сделал 15 шагов вперед и остановился.
.equ    C_ConstLowPointPark=130 ;константа, для периодической парковки. Прибавляется к основной константе
							    ;реверса, чтоб увеличить 1 раз ход ШД вниз, чтоб совершить
								;парковку.

.equ	Const200	=180	;константы,определяющие ход ШД
.equ	Const250	=230
.equ	Const300	=280
.equ	Const350	=350
.equ	Const400	=400

.equ    OptimalMeandrConstStepMot	=0x02;константа для оптимальнейшей работы ШД. Определяет
										 ;длительность меандра.

;адреса ПЗУ, куда загоняются константы побайтно
.equ E_OpenCloseAddrL=0		;адрес ячейки ПЗУ, куда загоняется мл байт константы 
							;количества открываний-закрываний	
.equ E_OpenCloseAddrH=1		;---//--- старший байт константы количества открываний/закрываний
.equ E_LengthAddrL 	 =2		;адрес ячейки ПЗУ с младшим байтом константы длины хода ШД
.equ E_LengthAddrH	 =3		;---//---старший байт константы длины хода ШД

;константы нажатия кнопок.
.equ	NoButtPushed	=4; ни одна кнопа не нажата
.equ	OneButtPushed	=3; одна кнопка нажата






;это все флаги и маски регистра FlagReg
.EQU	f_FIRSTPUSH_1	=0			
.EQU	M_FIRSTPUSH_1	=0B00000001
.EQU	f_FIRSTPUSH_2	=1
.EQU	M_FIRSTPUSH_2	=0B00000010
.equ	f_EEPROMpush	=2			;флаг для постоянной неперезаписи информации.
.equ	m_EEPROMpush	=0B00000100
.equ	f_MoreOneButt_1	=3			;
.equ	m_MoreOneButt_1	=0B00001000	;f_MoreOneButt_1=1 значит одновременно нажали несколько кнопок первой группы
.equ	f_MoreOneButt_2	=4			;f_MoreOneButt_2=1 значит одновременно нажали несколько кнопок второй группы
.equ	m_MoreOneButt_2	=0B00010000
.equ	f_IncrOne	=5
.equ	m_IncrOne	=0B00100000     ;Это тоже синхронизирует ШД и сегментный дисплэй.
.equ	f_PauseButt		=6		    ;флаг оказывает, что это уже не первое нажатие кнопки Пауза.
.equ	m_PauseButt	=	 0b01000000
.equ	f_CountAndMotor	=7			;Синхронизация работы ШД и сегментного дисплея.
.equ	m_CountAndMotor =0B10000000
;-----------------------
#define DATA_PORT PORTA
	;
#define CODE_PORT PORTC
#define CHAR_PORT PORTC

.equ	P_CODE	=PC0	;Порт для защелкивания в регистр данных для сегментного индикатора
.equ	P_CHAR	=PC3	;Порт для возможности записи информации на дешифратор
	;
.equ	PULSE	=PC2	;Для создания тактовых импульсов работы ШД. Подключен к блоку управления ШД
.equ	Reverse	=PC1	;Для создания обратного хода ШД. Подключен к Блоку управления ШД

.equ	f_reverse	= 0          ;По этому флагу происходит выбор пути программы.На одно ветви включается реверс и возводится
.equ	m_reverse	= 0b00000001 ;этот флаг. На другой выключается реверс.Время переключения реверса задается константой
	

.equ	S_D1	=0x060	;Ячейки, с которых выводят инфу на сегменты
.equ	S_D2	=0x061
.equ	S_D3	=0x062
.equ	S_D4	=0x063
.equ	S_D5	=0x064
;
.equ	S_D6	=0x089	;Зарезервировано D6,D7,D8.
.equ	S_D7	=0x090
.equ	S_D8	=0x091



#define	S_C_LED	0x065	;Это что-то из драйвера сегментного индикатора
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

.equ	S_LK0	=0x070	;Ячейки ОЗУ, для хранения информации о кнопках и СД.
.equ	S_LK1	=0x071
.equ	S_LK2	=0x072
.equ	S_LK3	=0x073
.equ	S_LK4	=0x074
  ;флаги этих ОЗУ.	
  .equ	F_K0	=0			;первая кнопка (1 и 2 группы)
  .equ	M_K0	=0b00000001
  .equ	F_K1	=1			;вторая кнопка (1 и 2 группы)
  .equ	M_K1	=0b00000010
  .equ	F_L2	=2			;СД первой кнопки
  .equ	M_L2	=0b00000100
  .equ	F_L3	=3			;СД второй кнопки
  .equ	M_L3	=0b00001000



.equ	S_counterL =0x075;Эта пара инкриментируется, а сегментный индикатор показывает число,
.equ	S_counterH =0x076;находящаяся в этих ячейках.
.equ	S_FirstGroup =0x077
.equ	S_SecondGroup =0x078
.equ	S_LimitL	  =0x079
.equ	S_LimitH	  =0x07a
		
.equ	S_FlagButt1	=0x07b;здесь содержатся состояния кнопок 1 группы
    ;флаги нажаитя кнопок 1 группы.
	.equ	f_Butt11	=0			;500 открытий/закрытий
	.equ	m_Butt11	=0b00000001
	.equ	f_Butt12	=1			;1000 открытий/закрытий
	.equ	m_Butt12	=0b00000010
	.equ	f_Butt13	=2			;5000 открытий/закрытий
	.equ	m_Butt13	=0b00000100
	.equ	f_Butt14	=3			;10000 открытий/закрытий
	.equ	m_Butt14	=0b00001000
	.equ	f_Butt15	=4			;кнопка Пауза
	.equ	m_Butt15	=0b00010000
	.equ	f_PauseSetted	=5			;флаг пауза установлена. Устанавливается после первого нажатия кнопки.
	.equ	m_PauseSetted	=0b00100000	
	.equ	f_NoFirstIncr	=6
	.equ	m_NoFirstIncr	=0b01000000
	



.equ		S_FlagButt2	=0x07f;;здесь содержатся состояния кнопок 2 группы
	;флаги состояний кнопок второй группы.
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
	.equ	m_OnlyStart =0b01000000
	.equ	f_ConstStore	=7			;флаг будет отвечать за то, чтоб константа длины хода
	.equ	m_ConstStore    =0b10000000 ;попала в рабочий цикл, когда двигатель будет находится
										;в нижней мертвой точке.


.equ	S_MotorHighPointL	=0x07c;сюда заносится константа длины хода мотора.
.equ	S_MotorHighPointH	=0x07d

.equ	S_MotorParking		=0x080		;Все флаги этой ячейки отвечают за парковку двигателя
	.equ	f_FirstCicle	=0			;при включении прибора.
	.equ	m_FirstCicle	=0b00000001
	.equ	f_FinishParking	=1
	.equ	m_FinishParking	=0b00000010
	.equ	f_MotorInStart	=2
	.equ	m_MotorInStart	=0b00000100		
	.equ	f_ButtStartWasWork	=3
	.equ	m_ButtStartWasWork	=0b00001000
	.equ	f_ParkingButt	=4
	.equ	m_ParkingButt	=0b00010000
	.equ	f_ParkingLowPoint	=5
	.equ	m_ParkingLowPoint	=0b00100000	
	.equ	f_ParkingHighPoint	=6
	.equ	m_ParkingHighPoint	=0b01000000
	.equ	f_PushParking		=7
	.equ	m_PushParking		=0b10000000
.equ	S_ConstStoreL	=0x081; здечь находится ячейка, с которой выкидывается константа
.equ	S_ConstStoreH	=0x082; длины хода двигателя в тот момент, когда он находится в 
							  ; нижней мертвой точке.


.equ	S_FlagOfButtSubroutine		=0x083
.equ	f_PeriodicParking	=0			
.equ	m_PeriodicParking	=0b00000001
.equ	f_StabilizeConstReverse	=1	
.equ	m_StabilizeConstReverse	=0b00000010
.equ	f_ReadyCount			=2
.equ	m_ReadyCount			=0b00000100
.equ	f_ParkingDenied			=3
.equ	m_ParkingDenied			=0b00001000
.equ	f_PauseDenied			=4
.equ	m_PauseDenied			=0b00010000








.equ	S_ParkingNormL		=0x084
.equ	S_ParkingNormH		=0x085
	
.equ	HD44780_ClearDisplay = 0b00000001;--
.equ	HD44780_ReturnHome	 = 0b00000010
;
.equ	HD44780_EntryModeSet0 = 0b00000110;---
.equ	HD44780_EntryModeSet1 = 0b00000001
.equ	HD44780_EntryModeSet2 = 0b00000001
.equ	HD44780_EntryModeSet3 = 0b00000001
;
.equ	HD44780_DisplayOnOffControl0 = 0b00001111;---
.equ	HD44780_DisplayOnOffControl1 = 0b00000001
.equ	HD44780_DisplayOnOffControl2 = 0b00000001
.equ	HD44780_DisplayOnOffControl3 = 0b00000001
;
.equ	HD44780_CursorOrDisplayShift0 = 0b00010100;---
.equ	HD44780_CursorOrDisplayShift1 = 0b00000001
.equ	HD44780_CursorOrDisplayShift2 = 0b00000001
.equ	HD44780_CursorOrDisplayShift3 = 0b00000001
;
.equ	HD44780_FunctionSet0 = 0b00111000;---
.equ	HD44780_FunctionSet1 = 0b00000001
.equ	HD44780_FunctionSet2 = 0b00000001
.equ	HD44780_FunctionSet3 = 0b00000001
;

.equ	cmd1=0b00110000
.equ	cmd2=0b00001110
.equ	cmd3=0b00000110
.equ	cmd4=0b01000000
