ButtonsChecking:
;проверка рлновременного нажатия кнопки.Если нажать на 2 кнопки одновременно, то вся группа не
;реагирует на это нажатие.
;Если кнопка нажата то в F_Kх ячейки ОЗУ будет ноль.
;а когда кнопки не нажаты, то будет единиица.(!!!!!).Получаем, что  если ни одна
;кнопка не нажата, то сумма флагов F_Kx ячеек S_LKx будет равно 5 (кнокпи разделены
;на 2 группы по 5 в каждой). Одна группа отвечает за количество открываний/закрываний,
;другая за длину ход ШД.).Если нажата 1 кнопка, то 4, если 2 то 3 соответсвенно.	 
;
;Сначала мы проверяем 1 группу
	clr tmp
	clr xtmp
	lds	XL,low(S_LK0)	;выгружаем ячейку из ОЗУ в регистр X.
	lds	XH,high(S_LK0)	;
	bst	XL,F_K0			;Отправляем значение флага F_K0 с регистра X в Т ( в Т теперь или 0 или 1)		
	bld	tmp,0			;выгружаем с регистра Т значение в нулевой разряд тмп
	add xtmp,tmp		;теперь складываем с хтмп (сейчас в икстмп ноль).
		
	lds	XL,low(S_LK1)	; ниже все то же самое
	lds	XH,high(S_LK1)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp		;Теперь добавляем 0 или 1  к исктмп.	
	
	lds	XL,low(S_LK2)	;
	lds	XH,high(S_LK2)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp		;Опять добавляем 0 или 1  к исктмп.
	
	lds	XL,low(S_LK3)	;
	lds	XH,high(S_LK3)
	bst	XL,F_K0
	bld	tmp,0
	add	xtmp,tmp		;Снова добавляем 0 или 1  к исктмп.
	;После всех сложений в xtmp есть какое-то число.Делаем анализ этого числа.
	cpi	xtmp,NoButtPushed	;неужели ни одно канопка не нажата?
	brne	EqualOne_1		;не-е что-то нажато, поэтому иди к метке EqualOne_1
	rjmp YesButt_1			;Да, не фига ничего не нажато!Значит идем на YesButt_1.
	EqualOne_1:
	cpi	xtmp,OneButtPushed	;А одно кнопка нажата?
	brne MoreButtPushed_1 	;нет.Если что-то нажато, а это не является одной кнопкой, значит переполнение!
						  	;поэтому иди на метку MoreButtPushed_1
	rjmp YesButt_1		   ;да, нажата 1 кнопка. Переходим на YesButt_1	
	MoreButtPushed_1:
	sbr	FlagReg,m_MoreOneButt_1;установим флаг, благодаря которому анализ функций кнопки будет невозможен
							   ;это значит, что не будет включаться светодиод, и кнопка не будет выполнять свои 
							   ;функции
	rjmp SecondGroup
	YesButt_1:
	cbr	FlagReg,m_MoreOneButt_1;уберем флаг, чтобы функции кнопок обрабатывались 
;
	SecondGroup:
;	Обработка второй группы кнопок (комментарии см. выше) 
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
	EqualOne_2:
	cpi	xtmp,OneButtPushed
	brne MoreButtPushed_2
	rjmp YesButt_2
	MoreButtPushed_2:
	sbr	FlagReg,m_MoreOneButt_2
	rjmp ProcessPassed
	YesButt_2:
	cbr	FlagReg,m_MoreOneButt_2
    ProcessPassed:
ret
