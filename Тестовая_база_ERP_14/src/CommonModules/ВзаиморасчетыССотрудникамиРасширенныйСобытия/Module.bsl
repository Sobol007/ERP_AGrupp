
#Область СлужебныеПроцедурыИФункции

Процедура КонтрольСоответствияНачисленийИВыплатПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
	     Возврат; 
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ПроверятьСоответствиеНачисленийИВыплат") Тогда
	     Возврат; 
	КонецЕсли;
		
	Регистратор = Источник.Отбор.Регистратор.Значение;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗарплатаКВыплате.ВидДвижения КАК ВидДвижения,
	|	ЗарплатаКВыплате.ДокументОснование КАК ДокументОснование,
	|	ЗарплатаКВыплате.Сотрудник КАК Сотрудник,
	|	ЗарплатаКВыплате.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ЗарплатаКВыплате.СтатьяРасходов КАК СтатьяРасходов,
	|	СУММА(ЗарплатаКВыплате.СуммаКВыплате) КАК СуммаКВыплате
	|ПОМЕСТИТЬ ВТЗарплатаКВыплатеПередЗаписью
	|ИЗ
	|	#ЗарплатаКВыплате КАК ЗарплатаКВыплате
	|ГДЕ
	|	ЗарплатаКВыплате.Регистратор = &Регистратор
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплате.ВидДвижения,
	|	ЗарплатаКВыплате.ДокументОснование,
	|	ЗарплатаКВыплате.Сотрудник,
	|	ЗарплатаКВыплате.СтатьяФинансирования,
	|	ЗарплатаКВыплате.СтатьяРасходов";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ЗарплатаКВыплате", Источник.Метаданные().ПолноеИмя());
	
	Запрос.Выполнить();
	
	Источник.ДополнительныеСвойства.Вставить(
		"КонтрольСоответствияНачисленийИВыплат", 
		Новый Структура("МенеджерВременныхТаблиц", Запрос.МенеджерВременныхТаблиц));
	
КонецПроцедуры

Процедура КонтрольСоответствияНачисленийИВыплатПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
	     Возврат; 
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ПроверятьСоответствиеНачисленийИВыплат") Тогда
	     Возврат; 
	КонецЕсли;
	
	Регистратор = Источник.Отбор.Регистратор.Значение;
	
	МенеджерВременныхТаблиц = Источник.ДополнительныеСвойства.КонтрольСоответствияНачисленийИВыплат.МенеджерВременныхТаблиц;
	
	// Разрезы учета, по которым сальдо изменяется в сторону увеличения задолженности работника
	СоздатьВТУвеличениеЗадолженности(МенеджерВременныхТаблиц, Регистратор, Источник.Метаданные().ПолноеИмя());
	
	// Те изменения сальдо, по которым были выплаты
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Изменения.ДокументОснование КАК ДокументОснование,
	|	Изменения.Сотрудник КАК Сотрудник,
	|	Изменения.СтатьяФинансирования КАК СтатьяФинансирования,
	|	Изменения.СтатьяРасходов КАК СтатьяРасходов
	|ПОМЕСТИТЬ ВТОтборыИзменений
	|ИЗ
	|	ВТУвеличениеЗадолженности КАК Изменения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ #ЗарплатаКВыплате КАК ЗарплатаКВыплате
	|		ПО (ЗарплатаКВыплате.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход))
	|			И Изменения.ДокументОснование = ЗарплатаКВыплате.ДокументОснование
	|			И Изменения.Сотрудник = ЗарплатаКВыплате.Сотрудник
	|			И Изменения.СтатьяФинансирования = ЗарплатаКВыплате.СтатьяФинансирования
	|			И Изменения.СтатьяРасходов = ЗарплатаКВыплате.СтатьяРасходов";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ЗарплатаКВыплате", Источник.Метаданные().ПолноеИмя());
	ОтборыИзменений = Запрос.Выполнить().Выбрать();
	Если Не ОтборыИзменений.Следующий() Или ОтборыИзменений.Количество = 0 Тогда
		Возврат
	КонецЕсли;	
	
	// Возникающие из-за изменений переплаты 
	Переплаты = ВзаиморасчетыССотрудникамиРасширенный.ПереплатыПоДокументамСотрудникам(МенеджерВременныхТаблиц, "ВТОтборыИзменений");
	
	Если Переплаты.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Изменения.ДокументОснование КАК ДокументОснование,
	|	Изменения.Сотрудник КАК Сотрудник,
	|	Изменения.СтатьяФинансирования КАК СтатьяФинансирования,
	|	Изменения.СтатьяРасходов КАК СтатьяРасходов,
	|	Изменения.ВидДвижения КАК ВидДвижения,
	|	Изменения.Старый КАК Старый,
	|	Изменения.Новый КАК Новый
	|ИЗ
	|	ВТУвеличениеЗадолженности КАК Изменения";
	Изменения = Запрос.Выполнить().Выгрузить();
	
	ПоляКлюча = "ДокументОснование, Сотрудник, СтатьяФинансирования, СтатьяРасходов";
	Изменения.Индексы.Добавить(ПоляКлюча);
	ПараметрыОтбораИзменений = Новый Структура(ПоляКлюча);
	
	ПревышенияВыплат     = Новый Массив;
	УменьшенияНачислений = Новый Массив;
	УдаленияНачислений   = Новый Массив;
	
	Пока Переплаты.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(Переплаты.ДокументОснование) Тогда
			Продолжить;
		КонецЕсли;	
		
		ЗаполнитьЗначенияСвойств(ПараметрыОтбораИзменений, Переплаты); 
		Изменение = Изменения.НайтиСтроки(ПараметрыОтбораИзменений)[0];
		
		Если Изменение.ВидДвижения = ВидДвиженияНакопления.Расход И Изменение.Старый И Не Изменение.Новый Тогда
			// удаление выплаты не контролируем
		ИначеЕсли Изменение.ВидДвижения = ВидДвиженияНакопления.Расход Тогда
			ПревышенияВыплат.Добавить(Изменение);
		ИначеЕсли Изменение.ВидДвижения = ВидДвиженияНакопления.Приход И Изменение.Старый И Изменение.Новый Тогда
			УменьшенияНачислений.Добавить(Изменение)
		ИначеЕсли Изменение.ВидДвижения = ВидДвиженияНакопления.Приход И Изменение.Старый И Не Изменение.Новый Тогда
			УдаленияНачислений.Добавить(Изменение)
		КонецЕсли;
		
	КонецЦикла;
	
	КонтрольСоответствияНачисленийИВыплатСообщитьПользователю(Регистратор, Отказ, Изменения, УменьшенияНачислений, УдаленияНачислений, ПревышенияВыплат);
	
КонецПроцедуры

Процедура СоздатьВТУвеличениеЗадолженности(МенеджерВременныхТаблиц, Регистратор, ПолноеИмя)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗарплатаКВыплате.ВидДвижения КАК ВидДвижения,
	|	МАКСИМУМ(ЗарплатаКВыплате.Старый) КАК Старый,
	|	МАКСИМУМ(ЗарплатаКВыплате.Новый) КАК Новый,
	|	ЗарплатаКВыплате.ДокументОснование КАК ДокументОснование,
	|	ЗарплатаКВыплате.Сотрудник КАК Сотрудник,
	|	ЗарплатаКВыплате.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ЗарплатаКВыплате.СтатьяРасходов КАК СтатьяРасходов,
	|	СУММА(ВЫБОР
	|			КОГДА ЗарплатаКВыплате.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА 1
	|			ИНАЧЕ -1
	|		КОНЕЦ * ЗарплатаКВыплате.СуммаКВыплате) КАК Сумма
	|ПОМЕСТИТЬ ВТУвеличениеЗадолженности
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗарплатаКВыплате.ВидДвижения КАК ВидДвижения,
	|		ИСТИНА КАК Старый,
	|		ЛОЖЬ КАК Новый,
	|		ЗарплатаКВыплате.ДокументОснование КАК ДокументОснование,
	|		ЗарплатаКВыплате.Сотрудник КАК Сотрудник,
	|		ЗарплатаКВыплате.СтатьяФинансирования КАК СтатьяФинансирования,
	|		ЗарплатаКВыплате.СтатьяРасходов КАК СтатьяРасходов,
	|		-ЗарплатаКВыплате.СуммаКВыплате КАК СуммаКВыплате
	|	ИЗ
	|		ВТЗарплатаКВыплатеПередЗаписью КАК ЗарплатаКВыплате
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗарплатаКВыплате.ВидДвижения,
	|		ЛОЖЬ,
	|		ИСТИНА,
	|		ЗарплатаКВыплате.ДокументОснование,
	|		ЗарплатаКВыплате.Сотрудник,
	|		ЗарплатаКВыплате.СтатьяФинансирования,
	|		ЗарплатаКВыплате.СтатьяРасходов,
	|		ЗарплатаКВыплате.СуммаКВыплате
	|	ИЗ
	|		#ЗарплатаКВыплате КАК ЗарплатаКВыплате
	|	ГДЕ
	|		ЗарплатаКВыплате.Регистратор = &Регистратор) КАК ЗарплатаКВыплате
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплате.ВидДвижения,
	|	ЗарплатаКВыплате.ДокументОснование,
	|	ЗарплатаКВыплате.Сотрудник,
	|	ЗарплатаКВыплате.СтатьяФинансирования,
	|	ЗарплатаКВыплате.СтатьяРасходов
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВЫБОР
	|			КОГДА ЗарплатаКВыплате.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА 1
	|			ИНАЧЕ -1
	|		КОНЕЦ * ЗарплатаКВыплате.СуммаКВыплате) < 0";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ЗарплатаКВыплате", ПолноеИмя);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура КонтрольСоответствияНачисленийИВыплатСообщитьПользователю(Регистратор, Отказ, Изменения, УменьшенияНачислений, УдаленияНачислений, ПревышенияВыплат)
	
	ПоказыватьСтатьиРасходов		= ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
	ПоказыватьСтатьиФинансирования	= ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный");
	
	Если ПоказыватьСтатьиФинансирования Тогда
		КодыСтатейФинансирования = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Изменения.ВыгрузитьКолонку("СтатьяФинансирования"), "Код");
	Иначе
		КодыСтатейФинансирования = Новый Соответствие;
	КонецЕсли;	
	Если ПоказыватьСтатьиРасходов Тогда
		КодыСтатейРасходов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Изменения.ВыгрузитьКолонку("СтатьяРасходов"), "Код");
	Иначе
		КодыСтатейРасходов = Новый Соответствие;
	КонецЕсли;	
	
	Если ПоказыватьСтатьиФинансирования И ПоказыватьСтатьиРасходов Тогда
		ШаблонФинансирования = НСтр("ru = 'по источнику %1(%2)';
									|en = 'by the %1 source (%2)'");
	ИначеЕсли ПоказыватьСтатьиФинансирования Тогда 
		ШаблонФинансирования = НСтр("ru = 'по источнику %1';
									|en = 'by the %1 source'");
	Иначе	
		ШаблонФинансирования = "";
	КонецЕсли;
	
	СообщениеУменьшенияНачислений = "";
	
	Если УменьшенияНачислений.Количество() > 0 Тогда
		
		ПредставлениеФинансирования = "";
		Если ПоказыватьСтатьиФинансирования Или ПоказыватьСтатьиРасходов Тогда
			ПредставлениеФинансирования =
				" " +
				СтрШаблон(
					ШаблонФинансирования,
					КодыСтатейФинансирования[УменьшенияНачислений[0].СтатьяФинансирования],
					КодыСтатейРасходов[УменьшенияНачислений[0].СтатьяРасходов])
		КонецЕсли;	
		
		СообщениеУменьшенияНачислений = 
			СообщениеУменьшенияНачислений +
			СтрШаблон(
				НСтр("ru = 'Сотруднику %1 на основании этого документа уже произведена выплата%2, превышающая начисленное.';
					|en = 'Payment%2 based on this document has already been made to employee %1, which exceeds the accruals.'"),
				УменьшенияНачислений[0].Сотрудник,
				ПредставлениеФинансирования);
			
		Если УменьшенияНачислений.Количество() > 1 Тогда
			СообщениеУменьшенияНачислений = 
				СообщениеУменьшенияНачислений + 
				Символы.ПС + 
				НСтр("ru = 'Имеются и другие начисления, которые меньше уже произведенных выплат.';
					|en = 'There are other accruals that are less than the payments made.'")
		КонецЕсли;
		
	КонецЕсли;	
	
	СообщениеУменьшенияНачислений = 
		СообщениеУменьшенияНачислений + 
		Символы.ПС;
		
	Если УдаленияНачислений.Количество() > 0 Тогда
		
		ПредставлениеФинансирования = "";
		Если ПоказыватьСтатьиФинансирования Или ПоказыватьСтатьиРасходов Тогда
			ПредставлениеФинансирования =
				" " +
				СтрШаблон(
					ШаблонФинансирования,
					КодыСтатейФинансирования[УдаленияНачислений[0].СтатьяФинансирования],
					КодыСтатейРасходов[УдаленияНачислений[0].СтатьяРасходов])
		КонецЕсли;	
		
		СообщениеУменьшенияНачислений = 
			СообщениеУменьшенияНачислений +
			СтрШаблон(
				НСтр("ru = 'На основании этого документа сотруднику %1%2 уже произведена выплата. Эти данные о начислении нельзя отменять.';
					|en = 'Payment to employee %1%2  based on this document has already been made. You cannot cancel this data on accruals.'"),
				УдаленияНачислений[0].Сотрудник,
				ПредставлениеФинансирования);
			
		Если УменьшенияНачислений.Количество() > 1 Тогда
			СообщениеУменьшенияНачислений = 
				СообщениеУменьшенияНачислений + 
				Символы.ПС + 
				НСтр("ru = 'Имеются и другие удаленные начисления, по которым уже произведена выплата.';
					|en = 'There are other remote accruals, by which the payment was made.'")
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(СообщениеУменьшенияНачислений) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеУменьшенияНачислений, Регистратор, , , Отказ);
	КонецЕсли;
			
	Если ПревышенияВыплат.Количество() > 0 Тогда
		
		ПредставлениеФинансирования = "";
		Если ПоказыватьСтатьиФинансирования Или ПоказыватьСтатьиРасходов Тогда
			ПредставлениеФинансирования =
				" " +
				СтрШаблон(
					ШаблонФинансирования,
					КодыСтатейФинансирования[ПревышенияВыплат[0].СтатьяФинансирования],
					КодыСтатейРасходов[ПревышенияВыплат[0].СтатьяРасходов])
		КонецЕсли;	
		
		СообщениеПревышенияВыплат = 
			СтрШаблон(
				НСтр("ru = 'Выплата сотруднику %1%2 превышает начисления документа %3.';
					|en = 'Payment to the %1%2 employee exceeds the %3 document accruals.'"),
				ПревышенияВыплат[0].Сотрудник,
				ПредставлениеФинансирования,
				ПревышенияВыплат[0].ДокументОснование);
			
		Если ПревышенияВыплат.Количество() > 1 Тогда
			СообщениеПревышенияВыплат = 
				СообщениеПревышенияВыплат + 
				НСтр("ru = 'Имеются и другие переплаты.';
					|en = 'There are other overpayments.'")
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПревышенияВыплат, Регистратор, , , Отказ);
		
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти