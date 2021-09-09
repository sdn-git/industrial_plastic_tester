

.org	$000		;RESET    Hardware Pin and Watchdog Reset
	jmp	RESET	;-- Reset Handle
.org	INT0addr		;INT0    Внешнее прерывание0
	jmp	Interrupt
.org	INT1addr		;INT1    Внешнее прерывание1
	jmp	Interrupt
.org	OC2addr			;совпадение таймера/счетчика Т2
	jmp	Interrupt
.org	OVF2addr		;Переполнение таймера/счетчика Т2
	jmp	TIMER2OVF	
.org	ICP1addr		;захват таймера/счетчика Т1
	jmp	Interrupt
.org	OC1Aaddr		;Совпадение "А" таймера/счетчика Т1
	jmp	Interrupt
.org	OC1Baddr		;Совпадение "В" таймера/счетчика Т1
	jmp	Interrupt
.org	OVF1addr		;Переполнение таймера/счетчика Т1
	jmp	Interrupt
.org	OVF0addr		;Переполнение таймера/счетчика Т0
	jmp	TIMER0OVF
.org	SPIaddr			;Передача по SPA завершена
	jmp	Interrupt
.org	URXCaddr		;USART, прием завершон
	jmp	Interrupt	
.org	UDREaddr		;Регистр данных USART пуст
	jmp	Interrupt
.org	UTXCaddr		;USART, передача завершена
	jmp	Interrupt
.org	ADCCaddr		;Передача АЦП завершено
	jmp	Interrupt
.org	ERDYaddr		;EEPROM, готово
	jmp	Interrupt
.org	ACIaddr			;Аналоговый компаратор
	jmp	Interrupt
.org	TWIaddr			;Прерывание отмодуля TWI
	jmp	Interrupt
.org	INT2addr		;Внешнее прерывание2
	jmp	Interrupt
.org	OC0addr			;Совпадение таймера/счетчика Т0
	jmp	Interrupt
.org	SPMRaddr
	jmp	Interrupt
  ;---------------------------------------------------------------------
Interrupt:
  reti


TIMER2OVF:
PUSH_ALL

cbi	ControlPort,LED1
cbi	ControlPort,LED2

	ldi tmp,233
	out	tcnt2,tmp
;--------------------

.macro S_MOV
	lds	TMP,@1
	sts	@0,TMP
.endmacro

	lds	XL,S_counterL					;
	lds	XH,S_counterH
;+++++++++++++++++++++++++++++++
	lds	  xtmp,S_MotorParking		;После парковки  система должна находиться в ждущем режиме.Поэтому - 
	sbrc  xtmp,f_MotorInStart		;после парковки установим этот флаг чтоб через все перепрыгивать.-
	rjmp  DataChrcking     			;Снимается он при нажатии кнопки ПУСК.
;+++++++++++++++++++++++++++++++
	lds	 xtmp,S_FlagButt1				;Это есть обработка паузы. Когда м нажимаем кнопку S_PauseButt инкремен
	sbrc xtmp,f_PauseSetted		        ;кнопка еще не нажималась.А пауза включена?
	rjmp DataChrcking	                ;не происходит. Снова нажимаем на кнопку получаем уже число 2. А если число не 	
;+++++++++++++++++++++++++++++++
	sbrs FlagReg,f_CountAndMotor   		;флаг синхронизирует работу двигателя и счетчика
	rjmp CompareWithButtConstants	
	sbrc FlagReg,f_IncrOne		   		;этот флаг ставится чтобы постоянно не инкриментировать после каждого прохождения.
	rjmp CompareWithButtConstants
;+++++++++++++++++++++++++++++++
	lds  tmp,S_FlagButt1				;Когда двигатель паркуется происходит ненужный инкрмент открываний/закрываний. 
	sbrc tmp,f_NoFirstIncr				;Чтоб этого не произошло установим флаг сначала - программа не будет инкрементировать.
	rjmp NoIncrDuringParking		    ;И уберем после нажатия кнопки ПУСК				
	adiw XL,1							;здесь происходит инкримнет числа, отображаемого на индикаторе.	
NoIncrDuringParking:			
	sbr FlagReg,m_IncrOne					
;+++++++++++++++++++++++++++++++
CompareWithButtConstants:
	;Константа S_LimitX задается кнопкой. Т е кнопку нажали, константа заняслась в S_LimitX.
	;Затем счетный регистр S_counterX сравнивается с этой константой. И если они сравняются
	;то счетный регистр обнуляеся. Константа показывает чило открываний/закрываний.
	lds	tmp,S_LimitL		        	;затем эту константу сравниваем со значением 
	lds tmp2,S_LimitH	
	cp	XL,tmp
	cpc	XH,tmp2
	brne CountContiniue
YesOvf:
	clr tmp						  		;если константы равны, то в счетчик заносится ноль.
	sts	S_counterL,tmp
	sts S_counterH,tmp
	lds tmp,S_MotorParking
	sbr tmp,m_MotorInStart				;как только  чило открываний/закрываний достигнет заданного
	cbr tmp,m_ButtStartWasWork  		;числа, то  ШД остановится. Запуск возможен по нажатию кнопки ПУСК.
	sts S_MotorParking,tmp
	lds tmp,S_FlagOfButtSubroutine
	sbr tmp,m_ReadyCount
	sts S_FlagOfButtSubroutine,tmp
	rjmp	DataChrcking	
;+++++++++++++++++++++++++++++++	
CountContiniue: 
	;Постепенно при износе ШД возможно его проскальзование и ток может не доходить
	;до НМТ, тем самым,усилие на пряжке может быть различно. Поэтому после определенного числа
	;открываний/закрываний нужно производить парковку к НМТ, чтоб установить шток в нулевой
	;отсчет. 
		                 
	lds YL,S_ParkingNormL
	lds YH,S_ParkingNormH
	cp	XL,YL						;Сравниваем число на индикаторе с константой периодической парковки.
	cpc	XH,YH						;
	brne 	NoOvf
	ldi	tmp, low(C_ParkingNorm)		;Если у нас через определенный промежуток времени произошла
	ldi tmp2,high(C_ParkingNorm)    ;парковка, то надо  подсчитать следующий момент, когда будет 
	add YL,tmp						;происходить автопарковка. Это делается сложением текущего числа 
	adc YH,tmp2						;с константой C_ParkingNorm.
	lds xtmp,S_FlagOfButtSubroutine
    sbr xtmp,m_PeriodicParking
	sts	S_FlagOfButtSubroutine,xtmp
NoOvf:
	sts S_ParkingNormL,YL
	sts S_ParkingNormH,YH
	sts	S_counterL,XL
	sts	S_counterH,XH
DataChrcking:
	rcall	HEX2DEC
	rcall	DEC2SEVSG
	;
	;Как только счет дойдет до константы количества открываний/закрываний, то установится флаг
	;f_ReadyCount.В программе ниже происходит вывод на индикатор слова DONE.При этом вся система останавливается
	;Сброс всей системы осуществляется нажатием кнопки ПУСК.
	lds tmp,S_FlagOfButtSubroutine 
	sbrc tmp,f_ReadyCount
	rcall ReadyIndicate	
	;
	S_MOV	S_1LED1,S_D1		;вывод цифр на индикатор.
	S_MOV	S_1LED2,S_D2
	S_MOV	S_1LED3,S_D3
	S_MOV	S_1LED4,S_D4
	S_MOV	S_1LED5,S_D5

	;============================================================================
; "LED_DRV.asm  ; Драйвер 7-мисегментного 4-хразрядного  LED дисплея.
; 25/VIII.06.  ; Драйвер поочерёдно (с частотой переключения системного
;    ; мультивибратора) выкидывает поразрядно (т.е. побайтно)
;    ; на LED дисплей содержимое 1-й и 2-й страниц экранного ОЗУ.
;
;INTERRUPT_SUBROUTINE
;Если хотим изпользовать матбиблиотеки, то нужно сохранять их регистры 
; в начале обработки данного прерывания !!!
;============================================================================
LED_DRV:
;Если хотим изпользовать матбиблиотеки, то нужно сохранять их регистры !!!
	S_INC	S_C_LED		;Смотрим, какое знакоместо будем обрабатывать.
	cpi	TMP,5		    ;Если уже обработали последнее, то ставим счётчик
	brne	PAGE_DEF	;  в позицию 0.
	clr	TMP
PAGE_DEF:
	sts	S_C_LED,TMP	    ;Сохраняем содержимое счётчика знакоместа.
#warning "only for 1-st page"
;	sbrc	SSH,F_FLASH	;
;	rjmp	SPAGE2_PROC	;Обрабатываем SCREENpage-2, если флаг "FLASH"=1,
                        ;иначе работаем с SCREENpage-1.
	;--------------------------------------------------------------------
SPAGE1_PROC:;-- Загрузка адресов страницы-1 экранного ОЗУ.
	ldi	XH,high(SCREEN1)
	ldi	XL,low(SCREEN1)
	rjmp	DRIVER		;Переходим к действиям.
	;--------------------------------------------------------------------
/*SPAGE2_PROC:;-- Загрузка адресов страницы-2 экранного ОЗУ.
	ldi	XH,high(SCREEN2)
	ldi	XL,low(SCREEN2)*/
	;--------------------------------------------------------------------
DRIVER:
	Pause100us		
	cbi	CHAR_PORT,P_CHAR;Отключаем текущий активный разряд LED дисплея.
	Pause100us
	push	TMP
	add	XL,TMP		    ;Теперь X содержит этот адрес.
	clr	TMP
	adc	XH,TMP
	pop	TMP
	;P.S. Проверку на переполнение младшего байта
	;  не делаем, так как сумма гарантировано <255.
	ld	XTMP,X		    	;Грузим содержимое этого адреса в XTMP
	out	DATA_PORT,XTMP		;  и отправляем его в порт данных.
	;
	sbi	CODE_PORT,P_CODE	;Защёлкиваем данные с порта в регистре.
	cbi	CODE_PORT,P_CODE
	out	DATA_PORT,tmp		;Теперь активизируем нужный разряд LED дисплея.
	sbi	CHAR_PORT,P_CHAR	;
;****************************
/*
В циклах сканирования знакомест 7-мисегментного индикатора "бегущим нулем",
организуем перебор байт "кнопочно-светодиодного" ОЗУ LK0..LK4
Каждый байт выкидывается на порт кнопок и светодиодов (столбцы кнопочно-светодиодной матрицы)
синхро с перебором знакомест 7-ми сегментного индикатора "бегущим нулем" (строки 
кнопочно-светодиодной матрицы).

Значение битовых полей L2,L3, определяют какие из светодиодов на текущей активной строке 
будут гореть. Эти биты мы выводим в порт столбцов кнопочно-светодиодной матрицы.

Значение битовых полей K0,K1, определяют какие из кнопок на текущей активной строке 
нажаты. Эти биты мы вводим из порта столбцов кнопочно-светодиодной матрицы.
*/
	ser	XTMP						;используем задержку, так как ТТЛ-логика не успевает за контроллером.
    PauseDec255
	
	ldi	XL,low(S_LK0)				;Загружаем АДРЕС нулевой ячейки 
	ldi	XH,high(S_LK0)	
	add	XL,TMP						; Складываем с ТМП. ( в ТМП число от 0 до 4 см выше)
	clr	TMP
	adc	XH,TMP						;В итоге  в регистре Х получаем текущий адрес ячейки
	ld	TMP,X						;Загружаем в тмп ячейку по адресу X+ТМП.Теперь в
									;тмп ячейка с ОЗУ, содержащая информацию о состоянии
									;кнопок и светодиодов.
	in	XTMP,ControlPort			;Загрузим РВВ порта С в XTMP		
	bst	TMP,F_L2					;Из tmp через флаг Т загрузим состояние светодиода
	bld	XTMP,led1					;в xtmp. 
						
	bst	TMP,F_L3					;Ааналогично делаем со светодиодом второй группы
	bld	XTMP,led2
	out	ControlPort,XTMP			;И весь регистр  XTMP отправляем в РВВ порта С.
									;Соответственно, если F_L2 = 1, следовательно и
									;led1 = 1, поэтому на выходе порта С будет 1 и
									;светодиод зажжется.
;Cостояние кнопок определяется в другом РВВ (!!!) другого порта (B).
	in	xtmp,PINB					; Здесь все делаем наоборот. Состояние кнопок
	bst	XTMP,F_K0					;снимаем непосредственно с порта ВВ и отправляем		
	bld	TMP,F_K0					;в ячейку ОЗУ
	bst	XTMP,F_K1		
	bld	TMP,F_K1		
	st	X,TMP
POP_ALL
	reti
;-------------------------------------------
TIMER0OVF:
   PUSH_ALL
;управление мотором
	cli
;++++++++++++++++++++++++++++++++++++
	lds	xtmp,S_MotorParking			;Этот флаг равен нулю до тех пор, пока ШД не совершит до конца паркинг.
    sbrc  xtmp,f_MotorInStart		;Как только парковка завершена, то флаг устанавливается и шаговый дви-
	rjmp CountCout     				;гатель останавливается и перходит в режим "Готов к работе"
									;Как только мы нажмем кнопку ПУСК, флаг снова убирается и двигатель начинает
									;работать
;++++++++++++++++++++++++++++++++++
	lds	xtmp,S_FlagButt1			;Это есть обработка паузы. Когда м нажимаем кнопку S_PauseButt инкремен
    sbrc xtmp,f_PauseSetted			;кнопка еще не нажималась.А пауза включена?
	rjmp CountCout                  ;не происходит. Снова нажимаем на кнопку получаем уже число 2. А если число не 		
;++++++++++++++++++++++++++++++++++
	sbi PORTC,Pulse							;мотор делает один шаг при перепаде с низкого уровня на высокий.
	inc Regdelay							; Инкремент делается, чтоб на порту получить  меандр правильной формы, иначе длительность
	cpi Regdelay, OptimalMeandrConstStepMot	;высокого уровня будет значительно короче длительности  низкого уровня.
	brne	PointExit						;
	cbi PORTC,Pulse							;здесь мы переходим с выского уровня меандра на низкий.
	clr	Regdelay		
	adiw RegReverseL,1	;
;+++++++++++++++++++++++++++++++++++
	lds	tmp,S_MotorHighPointL		;S_MotorHighPointL содержит константу, задаваемую кнопкой. То есть эта константа	
	lds	tmp2,S_MotorHighPointH		;определяет время, через которое двигатель совершит реверс.
	cp	tmp,RegReverseL				;RegReverse(L,H) инкриментируется, и когда он станет равным S_MotorHighPoint((L,H)	
	cpc	tmp2,RegReverseH			;происходит реверс.
	PointExit:
	brne WayToExit
;+++++++++++++++++++++++++++++++++++
	sbrc FlagReg,f_reverse			;этот флаг отвечает за направление движения.
	rjmp ReversOff
;:++++++++++++++++++++++++++++++++++++
	;Эта часть отвечает за парковку двигателя при включении питания
	lds  xtmp,S_MotorParking		;Сперва попадаем в PrepairForParking, все установим, а затем								
	sbrs xtmp, f_FinishParking		;проходим по FinishParking.
	rjmp PrepairForParking			;
		FinishParking:
	sbr  xtmp,m_MotorInStart		;Сюда мы попадаем, когда парковка завершена.При этом нам 
	sts  S_MotorParking,xtmp		;нужно вытащить последние константы, и занести их в рабочее ОЗу
	rcall ReadEEPROM
	rjmp CountCout		
    	PrepairForParking:			
	lds xtmp,S_MotorParking			;
	sbrc xtmp,f_FirstCicle
	rjmp NoParking
	ldi tmp,0						;При включении шток ШД пошел к НМТ. После этого реверсиро
	sts	S_MotorHighPointH,tmp		;вался и сделал 15 шагов к ВМТ и остановился.ParkingConst
	ldi tmp,ParkingConst			;это константа для небольшого движения вперед при парковки
	sts	S_MotorHighPointL,tmp
	sbr xtmp,m_FinishParking
	sts S_MotorParking,xtmp
	NoParking:		
;+++++++++++++++++++++++++++++++++++++
	cbi PORTC,Reverse		;когда f_reverse=0, то двигатель тянет шток к врехней мертвой точке 
	sbr	FlagReg,m_reverse
	clr	RegReverseL
	clr	RegReverseH
	cbr	FlagReg,m_CountAndMotor ;эта маска создает синхронизацию мотора и счетчика на индикаторе
	;
	;Если установлен флаг того, что пора делать периодич паркинг, и если ШД движется назад, то к константе
	;реверса мы прибавляем C_ConstLowPointPar, получая тем самым другую уонстанту, большую S_MotorHighPointL
	;Тем самым произойдет паркинг.То есть шток назад пройдет больший путь чем вперед.Тем самым исключится
	;вероятность постепенного смещение штока на определенный шаг вверх.
	lds  xtmp, S_FlagOfButtSubroutine	;
    sbrs xtmp,f_PeriodicParking
	rjmp ParkingPoint
	lds	XL,S_MotorHighPointL
	lds	XH,S_MotorHighPointH
	ldi ZL,low(C_ConstLowPointPark)
	ldi ZH,high(C_ConstLowPointPark)
	add XL,ZL
	adc XH,ZH
	sts S_MotorHighPointL,XL
	sts S_MotorHighPointH,XH
	cbr xtmp,m_PeriodicParking
	sbr xtmp,m_StabilizeConstReverse
	sts S_FlagOfButtSubroutine,xtmp
	;
	;Нажимаем на кнопку ПАРКИНГ, устанавлвается флаг f_ParkingButt. Затем когда ШД будет ехать к НМТ
	;то установится флаг f_ParkingLowPoint. После этого как только шток дойдет до ВМТ, и проверит наличие
	;установленного флага f_ParkingLowPoint. Если он есть, устанавливается флаг m_MotorInStart. Он не дает
	;проходить по ветке прерывания T0ovf.Сбрасывается m_MotorInStart нажатием кнопки ПУСК
ParkingPoint:
	lds	 tmp,S_MotorParking		;Следует отметить, что щток ЩД останавливается в соответствие 
	sbrs tmp,f_ParkingLowPoint	;с установленной кнопками константы высоты хода двигателя.
	rjmp CountCout				;
	sbr  tmp,m_MotorInStart		;
	cbr tmp,m_ParkingLowPoint	;
	cbr tmp,m_ButtStartWasWork
	sts S_MotorParking,tmp		
	;
  WayToExit:
	rjmp CountCout

	ReversOff:					;Под этой меткой находится текст, отвечающий за занесение константы
	lds  tmp,S_FlagButt2		;в рабочий цикл в момент нахождения штока ШД в НМТ.Иначе, если у нас
	sbrs tmp,f_ConstStore		;константа будет заходит в цикл например в ВМТ, то получаем , что в цикл
	rjmp ReverseOff_2			;во время использования одной константы поступила другая, тем самым, шток
	lds  tmp2,S_ConstStoreL		;выпадает с ШД.
	lds	 tmp3,S_ConstStoreH
	sts	 S_MotorHighPointL,tmp2
	sts  S_MotorHighPointH,tmp3
	cbr	 tmp,m_ConstStore		;Этот флаг устанавливается, если нажата хоть одна кнопка  группы "Длина хода"
	sts  S_FlagButt2,tmp
	ReverseOff_2:
;+++++++++++++++++++++++++++++++++++++			;когда f_reverse=1, то двигатель тянет шток к нижней мертвой точке 
	sbi	PortC,Reverse			
	cbr FlagReg,m_reverse
	clr	RegReverseL
	clr	RegReverseH
	sbr	FlagReg,m_CountAndMotor
	cbr FlagReg,m_IncrOne
	;
	;f_StabilizeConstReverse говорит о том, что ШД сделал парковку в НМТ. Но инкрементированная константа 
	;при этом осталась и ее надо вернуть в неинкрементированную константу, иначе ШД так и  будет топать
	;ишачьими шагами. Поэтому как только ШД вышел из НМТ, а это значит f_reverse=1, то мы берем
	;константу реверса и обратно отнимаем C_ConstLowPointPark, при этом получая прежнее число, которое было 
	;до паркинга. 
	lds xtmp,S_FlagOfButtSubroutine		;
	sbrs xtmp,f_StabilizeConstReverse
	rjmp SoubrtneParkingInLow
    lds	XL,S_MotorHighPointL			;S_MotorHighPointL-определяет константу реверса или длину хода ШД
	lds	XH,S_MotorHighPointH
	ldi ZL,low(C_ConstLowPointPark)
	ldi ZH,high(C_ConstLowPointPark)
	sub XL,ZL
	sbc XH,ZH
	sts S_MotorHighPointL,XL
	sts S_MotorHighPointH,XH
	cbr xtmp,m_StabilizeConstReverse
	sts S_FlagOfButtSubroutine,xtmp
	;	
 SoubrtneParkingInLow:
	lds	 tmp,S_MotorParking    ;Эта часть программы обработки кнопки паркинг (см. выше). Происходит 
	sbrs tmp,f_ParkingButt	   ;обработка флагов во время хода ЩД вниз.
	rjmp CountCout
	sbr tmp,m_ParkingLowPoint
	cbr tmp,m_ParkingButt
	sts  S_MotorParking,tmp
	;
	CountCout:
	sei
	POP_ALL
MotorOut:
	reti
    
	


