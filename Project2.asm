;--------------------------------------------------------------------------------

;                        FastexChecker Ver1.1
;						(LastUpdate 12 september 2007y)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ;---------------------------------------------------------------------------------
     

;---------------------------------------------------------------------------------
.device ATmega16
.include "m16def.inc"
.include "RegVarInit.asm"
.include "Macroses.asm"
.include "int.asm"
;----------------
.include "LED_driver.asm"			;управление ЖКД
.include "LCDPortsTimersInit.asm"	;инициализация попртов и Таймеров
.include "ReadEEPROM.asm"			;чтение EEPROM
.include "WriteEEPROM.asm"			;запись EEPROM
.include "ClrEverything.asm"		;полная очистка всех регистров и Озу
.include "ClrLeds.asm"				;очистка СД кнопок первой группы
.include "ClrLeds2.asm"				;jxbcnrf CД кнопок второй группы
.include "ButtonsChecking.asm"		;проверка одновременного нажатия клавиш
.include "ReadyIndicate.asm"		;выдает индикацию DONE при завершении счета
.cseg
	Reset:
	ldi	tmp,low(RAMEND)
	out	SPL,tmp
	ldi	tmp,high(RAMEND)
	out	SPH,tmp
	rcall LCDPortsTimersInit
	rcall ClrEverything
	rcall ReadEEPROM	 ;Если надо что диоды последних нажатых кнопок загорелись
 						 ;сразу, то раскомменировать rcall ReadEEPROM
/*cycle:
	SHOW_onLCD 0x00,'A'  ;Зарезервировано для ЖКД индикации.
	SHOW_onLCD 0x01,'P'
	SHOW_onLCD 0x02,'R'
	SHOW_onLCD 0x03,'I'
	SHOW_onLCD 0x04,'.'
	SHOW_onLCD 0x05,'A'
	SHOW_onLCD 0x06,'P'
	SHOW_onLCD 0x07,'R'
	SHOW_onLCD 0x40,'I'
	SHOW_onLCD 0x41,'.'
	SHOW_onLCD 0x42,'2'
	SHOW_onLCD 0x43,'0'
	SHOW_onLCD 0x44,'0'
	SHOW_onLCD 0x45,'6'
	SHOW_onLCD 0x46,'y'
	SHOW_onLCD 0x47,'r'
Pause100ms
*/
Main:
		cli
		rcall	ButtonsChecking ;Подпрограмма обработки одновременного нажатия кнопок
		sei
;здесь происходит зажигание светодиодов, если установлен флаг F_K0 или F_K1 а также распознвание функцй
;каждой кнопки.
;Если нажато несколько кнопок (обрабаывается в ButtonsChecking) , строки выше устанавливают флаг
;f_MoreOneButt_1 и f_MoreOneButt_2 которые просто перепрыгнут через всю обработку группы кнопок, и оставят все как есть до
;того как несколько конпок были нажаты
		sbrc	FlagReg,f_MoreOneButt_1
		rjmp	SecondGroupButt	
  FirstGroupButt:	
        ;количество открываний-закрываний.		
  Butt11:;обработка первой кнопки первой группы (500 открываний/закрываний)
		lds		TMP3,S_LK0 ;выгружаем ячейку из ОЗУ.
		sbrs	TMP3,F_K0  ;кнопка не нажата? (1=не нажата, 0=нажата)
		rjmp	K11_pressed;нажата.Значит идем на обработку.
		rjmp	Flag11Off ;выходим,заодно снимая флаг нажатия*/

  K11_pressed:
		lds	tmp2,S_FlagButt1 ;загрузим регистр Флагов и 
		sbrc tmp2,f_Butt11	;посмотрим есть ли там флаг f_Butt11. Он нужен для того,
							;чтоб при долгом удержании кнопки программа не прошла
							;второй раз по этому пути. 0=первое прохождение.1=второе
							;прохождение.
		rjmp  S_LK11_end
		rcall ClrLeds
		sbr	  TMP3,M_L2  ;Включим светодиодик, подсвечивающий данную кнопку.
       	cbr	  TMP3,m_K0  ;**?????**Уберем флажок кнопки, что постоянно не была нажата.
		ldi	  XL,low(Const500)	    ;Загружаем константы лимиты открываний/закрываний
		ldi	XH,high(Const500)
		sts	S_limitL,XL
		sts	S_limitH,XH
		clr xtmp
		sts	S_counterL,xtmp ;Затираем текущее значение светчика. Как только 
		sts S_counterH,xtmp	;нажмем на одну из кнопок этой группы, счетчик затирается
		clr tmp
		sbr tmp,m_Butt11	;установим флаг, чтоб когда второй раз программа пройдет по
							;этой ветке,она не сотрет счетчик и снова не занесет константу 
		sts	  S_FlagButt1,tmp	;
	    rcall WriteConstOpenCloseInEEPROM
 		rjmp  S_LK11_end
     Flag11Off:
		lds	tmp,S_FlagButt1
		cbr tmp,m_Butt11
		sts	S_FlagButt1,tmp
     S_LK11_end:
		sts		S_LK0,tmp3
		;
		

	 Butt12:;обработка второй кнопки первой группы (1000 открываний/закрываний)
		;----------------
	 	lds		TMP3,S_LK1
		sbrs	TMP3,F_K0
		rjmp	K12_pressed
		rjmp	Flag12Off ;выходим,заодно снимая флаг нажатия*/
   	 K12_pressed:
		lds	  tmp2,S_FlagButt1
		sbrc  tmp2,f_Butt12
		rjmp  S_LK12_end
		rcall ClrLeds
		sbr		TMP3,M_L2
		cbr		TMP3,m_K0
		ldi	XL,low(Const1000)
		ldi	XH,high(Const1000)
		sts	S_limitL,XL
		sts	S_limitH,XH
		clr	xtmp
		sts	S_counterL,xtmp
		sts S_counterH,xtmp
		clr tmp
		sbr tmp,m_Butt12
		sts	  S_FlagButt1,tmp	
		rcall WriteConstOpenCloseInEEPROM
		rjmp  S_LK12_end
	 Flag12Off:
		lds	tmp,S_FlagButt1
		cbr tmp,m_Butt12
		sts	S_FlagButt1,tmp
	 S_LK12_end:
		sts		S_LK1,tmp3

	Butt13:;обработка третьей кнопки первой группы (5000 открываний/закрываний)
		;----------------
	 	lds		TMP3,S_LK2
		sbrs	TMP3,F_K0
		rjmp	K13_pressed
		rjmp	Flag13Off ;выходим,заодно снимая флаг нажатия
    K13_pressed:
		lds	 tmp2,S_FlagButt1
		sbrc tmp2,f_Butt13
		rjmp  S_LK13_end
		rcall ClrLeds
		sbr	  TMP3,M_L2
		cbr	  TMP3,m_K0
		ldi	XL,low(Const5000)
		ldi	XH,high(Const5000)
		sts	S_limitL,XL
		sts	S_limitH,XH
		clr	xtmp
		sts	S_counterL,xtmp
		sts S_counterH,xtmp
		sbr tmp2,m_Butt13
		sts	S_FlagButt1,tmp2
		rcall WriteConstOpenCloseInEEPROM
		rjmp S_LK13_end
    Flag13Off:
		lds	tmp2,S_FlagButt1
		cbr tmp2,m_Butt13
		sts	S_FlagButt1,tmp2	
    S_LK13_end:
		sts		S_LK2,tmp3
	;----------------
	Butt14:;обработка четвертой кнопки первой группы (10000 открываний/закрываний)
	 	lds		TMP3,S_LK3
		sbrs	TMP3,F_K0
		rjmp	K14_pressed
		rjmp	Flag14Off ;выходим,заодно снимая флаг нажатия
	K14_pressed:
		lds	 tmp2,S_FlagButt1
		sbrc tmp2,f_Butt14
		rjmp	S_LK14_end
    	rcall 	ClrLeds
		sbr		TMP3,M_L2
		cbr		TMP3,m_K0
		ldi	XL,low(Const10000)
		ldi	XH,high(Const10000)
		sts	S_limitL,XL
		sts	S_limitH,XH
		clr	xtmp
		sts	S_counterL,xtmp
		sts S_counterH,xtmp
		sbr tmp2,m_Butt14
		sts	S_FlagButt1,tmp2	
		rcall WriteConstOpenCloseInEEPROM
		rjmp S_LK14_end
	Flag14Off:
		lds	tmp2,S_FlagButt1
		cbr tmp2,m_Butt14
		sts	S_FlagButt1,tmp2	
	S_LK14_end:
		sts		S_LK3,tmp3
		
	Butt15:;обработка пятой кнопки первой группы (кнопка ПАУЗА). Пауза работаент так. Нажимаем первый
	;раз на кнопку.Установили флаг f_PauseSetted в S_PauseButt.И если f_PauseSetted=1, то мотор индикаторы
	;и вся переферия перестает работать, так как после включения мтороа, СД программа всегда проверяет 
	;наличие флага f_PauseSetted.Значит кнопку нажали, отпустили - флаг установили.Снова нажмем-отпускаем 
	;на паузу - Флаг f_PauseSetted уберется.
   	
		lds     xtmp,S_FlagOfButtSubroutine
		sbrc    xtmp,f_PauseDenied
		rjmp    SecondGroupButt
		;
	 	lds		TMP3,S_LK4			;выгружаем ячейку в тмп
		sbrs	TMP3,F_K0			;флаг установлен (кнопка не не нажата?)
		rjmp	K15_pressed			;F_K0=0,значит кнопка нажата. переходим на метку
		rjmp	Flag15Off	        ;и переходим на метку
	K15_pressed:;кнопка включена
 	  	cbr		TMP3,m_K0			;
		lds	tmp2,S_FlagButt1		;выгружаем ячейку обработки кнопок первой группы
		sbrc tmp2,f_Butt15			;кнопка уже была нажата? Этот флаг ставится чтоб при долгом 
									;удержании программа второй раз не проходила по этой ветке.
									;В первый раз прошла, флаг установил. Второй раз уже обойдет и
									;сразу пойдет на выход
		rjmp	S_LK15_end			;Да f_FirstPushPause=1 (второй раз проходит программа), поэтому на выход
		sbrs 	tmp2,f_PauseSetted	;А Пауза установлена?
		rjmp	FirstPushPause		;Нет, не установлена, поэтому идем на FirstPushPause
		rjmp    SecondPushPause		;Да, установлена.
    FirstPushPause:
		sbr		TMP3,M_L2			;зажигаем светодиод
		sbr		tmp2,m_PauseSetted		;Первое нажатие-отпускание.Установим флаг. Пеерферия не работает
		;
		lds tmp,S_FlagOfButtSubroutine
		sbr tmp,m_ParkingDenied
		sts S_FlagOfButtSubroutine,tmp
		;
		rjmp 	SetFlags
    SecondPushPause:
		cbr		TMP3,M_L2
		cbr		tmp2,m_PauseSetted		;Второе нажати-отпускание.Убрали флаг. Переферия снова запустилась
        sts 	S_FlagButt1,tmp2 
		;
		lds tmp,S_FlagOfButtSubroutine
		cbr tmp,m_ParkingDenied
		sts S_FlagOfButtSubroutine,tmp
		;
		rjmp	SetFlags
	SetFlags:
		sbr 	tmp2,m_Butt15
		sts 	S_FlagButt1,tmp2 	
		rjmp	 S_LK15_end	
	Flag15Off:
		lds		tmp2,S_FlagButt1
		cbr 	tmp2,m_Butt15
		sts		S_FlagButt1,tmp2
	S_LK15_end:
		sts		S_LK4,tmp3			;содержимое регистра тмп засылаем обратно в ячейку ОЗУ

SecondGroupButt:
		sbrc	FlagReg,f_MoreOneButt_2 ;идет проверка на одновременное нажатие 2-х кнопок
		rjmp	ENDPoint				;Если (см выше) есть нажатие нескольких кнопок									;то f_MoreOneButt_2=1 и программа переходит на ENDPoint
		;-------------------
	Butt21:	;Кнопка переключения длины хода (5 мм)			
     	lds		TMP3,S_LK0		;
		sbrs	TMP3,F_K1
		rjmp	K21_pressed
		rjmp    Flag21Off	
		
	K21_pressed:
		lds	 tmp2,S_FlagButt2
		sbrc tmp2,f_Butt21
		rjmp	S_LK21_end
		rcall ClrLeds2
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		ldi	XL,low(Const200)
		ldi	XH,high(Const200)
		sts	S_ConstStoreL,XL
		sts	S_ConstStoreH,XH
		sbr tmp2,m_Butt21
		sbr tmp2,m_ConstStore
		sts	S_FlagButt2,tmp2
		rcall WriteConstLengthInEEPROM
		rjmp S_LK21_end	
	Flag21Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt21
		sts	S_FlagButt2,tmp2	
	S_LK21_end:
		sts		S_LK0,tmp3

		;----------------
	Butt22:	;Кнопка переключения длины хода (10 мм)
	 	lds		TMP3,S_LK1
		sbrs	TMP3,F_K1
		rjmp	K22_pressed
		rjmp	Flag22Off	;
	K22_pressed:
		lds	 tmp2,S_FlagButt2
		sbrc tmp2,f_Butt22
		rjmp	S_LK22_end
		rcall ClrLeds2
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		ldi	XL,low(Const250)
		ldi	XH,high(Const250)
		sts	S_ConstStoreL,XL
		sts	S_ConstStoreH,XH
		sbr tmp2,m_ConstStore
		sbr tmp2,m_Butt22
		sts	S_FlagButt2,tmp2
		rcall WriteConstLengthInEEPROM
		rjmp	S_LK22_end		
	Flag22Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt22
		sts	S_FlagButt2,tmp2
	S_LK22_end:
		sts		S_LK1,tmp3
		;----------------
	Butt23:	;Кнопка переключения длины хода (15 мм)
	 	lds		TMP3,S_LK2
		sbrs	TMP3,F_K1
		rjmp	K23_pressed
		rjmp	Flag23Off	;
	K23_pressed:
		lds	 tmp2,S_FlagButt2
		sbrc tmp2,f_Butt23
		rjmp	S_LK23_end
		rcall ClrLeds2
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		ldi	XL,low(Const300)
		ldi	XH,high(Const300)
		sts	S_ConstStoreL,XL
		sts	S_ConstStoreH,XH
		sbr tmp2,m_ConstStore
		sbr tmp2,m_Butt23
		sts	S_FlagButt2,tmp2
		rcall WriteConstLengthInEEPROM
		rjmp	S_LK23_end	
	Flag23Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt23
		sts	S_FlagButt2,tmp2			
	S_LK23_end:
		sts		S_LK2,tmp3
	;----------------
	Butt24:;кнопка паркинга. Нажимаем и шток идет к верхней мертвой точке. Чтобы снова запустить процесс
		   ;надо нажать на кнопку ПУСК. Следует отметить, что если нажать, на паркинг, то нельзя нажать
		   ;потом на кнопку пауза. Если нажимаем на паркинг, то устанавливается флаг запрета паузы. И 
		   ;наоборот, если нажата пауза, то устанавливается флаг запрета нажатия паркинга

		lds     xtmp,S_FlagOfButtSubroutine	; Проверка флага запрета паркинга
		sbrc    xtmp,f_ParkingDenied
		rjmp    Butt25
		;
	 	lds		TMP3,S_LK3
		sbrs	TMP3,F_K1
		rjmp	K24_pressed
		rjmp	Flag24Off;
	K24_pressed:
		lds	 tmp2,S_FlagButt2
		sbrc tmp2,f_Butt24
		rjmp	S_LK24_end
;		rcall    ClrLeds2
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		sbr    tmp2,m_Butt24
		;
		lds tmp,S_FlagOfButtSubroutine  ;Если кнопка нажата, то  устанавливаем флаг запрета нажатия 
		sbr tmp,m_PauseDenied		    ;кнопки ПАУЗЫ. Он убирается при нажатии на кнопку ПУСК.
		sts S_FlagOfButtSubroutine,tmp
		;
		lds	tmp,S_MotorParking
		sbr tmp,m_ParkingButt
		sts S_MotorParking,tmp
		sts	S_FlagButt2,tmp2
		rjmp	S_LK24_end	
	Flag24Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt24
		sts	S_FlagButt2,tmp2
	S_LK24_end:
		sts		S_LK3,tmp3
		
   ;----------------
	Butt25:							;Кнопка ПУСКА!!!
		
		;
		lds		xtmp,S_MotorParking
		sbrc 	xtmp,f_ButtStartWasWork
		rjmp	ENDPoint			;
	 	lds		TMP3,S_LK4
		sbrs	TMP3,F_K1
		rjmp	K25_pressed
		rjmp	Flag25Off;
			;
	K25_pressed:
		sbr		TMP3,M_L3
		cbr		TMP3,m_K1
		lds		tmp2,S_FlagButt2
		sbrc 	tmp2,f_Butt25
		rjmp	S_LK25_end		
   		cbr xtmp,m_MotorInStart		;Здесь только убираются флаги. Как только флаги убраны
		cbr xtmp,m_FinishParking	;Вся система начинает работать.
		sbr xtmp,m_ButtStartWasWork
		sbr	xtmp,m_FirstCicle
		sts S_MotorParking,xtmp
		; 
		lds xtmp,S_FlagOfButtSubroutine ;Убираем запрет нажатия кнопки паркинга.Этот флаг устанавливается  
		cbr xtmp,m_PauseDenied        ;
		sts S_FlagOfButtSubroutine,xtmp ;
		;
		lds	TMP3,S_LK3
		cbr	TMP3,M_L3
		sts S_LK3,tmp3
		lds tmp,S_FlagOfButtSubroutine
	    cbr tmp,m_ReadyCount
		sts S_FlagOfButtSubroutine,tmp
		clr RegReverseL	
		clr RegReverseH	
		
		lds  tmp,S_FlagButt1			;Когда двигатель паркуется происходит 1 ненужный инкрмент открываний/закрываний. 
		cbr  tmp,m_NoFirstIncr			;Здесь флаг убирается.
		sts	 S_FlagButt1,tmp	
		rjmp	S_LK25_end	
	Flag25Off:
		lds	tmp2,S_FlagButt2
		cbr tmp2,m_Butt25
		sts	S_FlagButt2,tmp2
S_LK25_end:
		sts		S_LK4,tmp3	
ENDPoint:
OutButtonLED:	
rjmp main

