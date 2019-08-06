#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Расчитывает и записывает состояния этапов.
//
// Параметры:
//  ЭтапыКОбновлению			 - Массив	 - список этапов к обновлению состояния
//  ЭтапыКОчистке				 - Массив	 - список этапов к очистке состояния.
//
Процедура ОтразитьСостояниеЭтапов(ЭтапыКОбновлению, ЭтапыКОчистке = Неопределено) Экспорт
	
	МассивСсылокКОчистке = УправлениеПроизводствомКлиентСервер.МассивЗначений(ЭтапыКОчистке);
	
	Если МассивСсылокКОчистке.Количество() > 0 Тогда
		
		ОчиститьСостояниеЭтапов(МассивСсылокКОчистке);
		
	КонецЕсли;
	
	МассивСсылокКОбновлению = УправлениеПроизводствомКлиентСервер.МассивЗначений(ЭтапыКОбновлению);
	
	Если МассивСсылокКОбновлению.Количество() > 0 Тогда
		
		ПараметрыРасчета = ПараметрыРасчетаКонструктор(
			МассивСсылокКОбновлению,
			МассивСсылокКОчистке);
		
		ВыборкаИзменений = ВыборкаИзмененийСостояния(ПараметрыРасчета);
		
		Если ПараметрыРасчета.ЗаписыватьНаборами Тогда
			ЗаписатьСостоянияПоРаспоряжениям(ВыборкаИзменений);
		Иначе
			ЗаписатьСостоянияПоЭтапам(ВыборкаИзменений);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обновляет состояния обеспечения этапов при изменении обособленного обеспечения.
//
// Параметры:
//  Этапы	 - Массив	 - список этапов к обновлению состояния.
//
Процедура ОбновитьСостояниеОбеспечения(Этапы) Экспорт
	
	МассивСсылок = УправлениеПроизводствомКлиентСервер.МассивЗначений(Этапы);
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Показатели = Новый Массив;
	Показатели.Добавить("ТребуетОбеспечения");
	
	ПараметрыРасчета = ПараметрыРасчетаКонструктор(
		МассивСсылок,
		,
		Показатели);
	
	ОбработанныеРаспоряжения = Новый Массив;
	
	Выборка = ВыборкаИзмененийСостояния(ПараметрыРасчета);
	ЗаписатьСостоянияПоЭтапамВыборочно(Выборка, Показатели, ОбработанныеРаспоряжения);
	
	Если ОбработанныеРаспоряжения.Количество() > 0 Тогда
		РегистрыСведений.СостоянияЗаказовНаПроизводство.ОтразитьСостояние(ОбработанныеРаспоряжения);
	КонецЕсли;
	
КонецПроцедуры

// Обновляет состояния операций.
//
// Параметры:
//  Этапы	 - Массив	 - список этапов к обновлению состояния.
//
Процедура ОбновитьСостояниеОпераций(Этапы) Экспорт
	
	МассивСсылок = УправлениеПроизводствомКлиентСервер.МассивЗначений(Этапы);
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Показатели = Новый Массив;
	Показатели.Добавить("СостояниеОпераций");
	
	ПараметрыРасчета = ПараметрыРасчетаКонструктор(
		МассивСсылок,
		,
		Показатели);
	
	Выборка = ВыборкаИзмененийСостояния(ПараметрыРасчета);
	ЗаписатьСостоянияПоЭтапамВыборочно(Выборка, Показатели);
	
КонецПроцедуры

// Обновляет состояния оформления выработки этапов при изменении параметров выработки.
//
// Параметры:
//  Этапы	 - Массив	 - список этапов к обновлению состояния.
//
Процедура ОбновитьСостояниеОформленияВыработки(Этапы) Экспорт
	
	МассивСсылок = УправлениеПроизводствомКлиентСервер.МассивЗначений(Этапы);
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Показатели = Новый Массив;
	Показатели.Добавить("ТребуетОформленияВыработки");
	
	ПараметрыРасчета = ПараметрыРасчетаКонструктор(
		МассивСсылок,
		,
		Показатели);
	
	Выборка = ВыборкаИзмененийСостояния(ПараметрыРасчета);
	ЗаписатьСостоянияПоЭтапамВыборочно(Выборка, Показатели);
	
КонецПроцедуры

// Удаляет текущее состояние обеспечения этапов
//
// Параметры:
//  Этапы - ДокументСсылка.ЭтапПроизводства2_2, Массив - этапы производства.
//
Процедура ОчиститьСостояниеЭтапов(Этапы) Экспорт
	
	МассивСсылок = УправлениеПроизводствомКлиентСервер.МассивЗначений(Этапы);
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Ссылка Из МассивСсылок Цикл
		Набор = РегистрыСведений.СостоянияЭтаповПроизводства.СоздатьНаборЗаписей();
		Набор.Отбор.Этап.Установить(Ссылка);
		Набор.Записать(Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеВсехСостояний

Функция ВыборкаИзмененийСостояния(ПараметрыРасчета)
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("МассивСсылок",         ПараметрыРасчета.МассивСсылокКОбновлению);
	Запрос.УстановитьПараметр("МассивСсылокКОчистке", ПараметрыРасчета.МассивСсылокКОчистке);
	
	Запрос.УстановитьПараметр("СтатусФормируется", Перечисления.СтатусыЭтаповПроизводства2_2.Формируется);
	Запрос.УстановитьПараметр("СтатусСформирован", Перечисления.СтатусыЭтаповПроизводства2_2.Сформирован);
	Запрос.УстановитьПараметр("СтатусКВыполнению", Перечисления.СтатусыЭтаповПроизводства2_2.КВыполнению);
	Запрос.УстановитьПараметр("СтатусНачат",       Перечисления.СтатусыЭтаповПроизводства2_2.Начат);
	Запрос.УстановитьПараметр("СтатусЗавершен",    Перечисления.СтатусыЭтаповПроизводства2_2.Завершен);
	
	Запрос.УстановитьПараметр("НетПредшественников",      Перечисления.СостоянияПредшественниковЭтапа.НетПредшественников);
	Запрос.УстановитьПараметр("НеНачатыПредшественники",  Перечисления.СостоянияПредшественниковЭтапа.НеНачатыПредшественники);
	Запрос.УстановитьПараметр("НачатыПредшественники",    Перечисления.СостоянияПредшественниковЭтапа.НачатыПредшественники);
	Запрос.УстановитьПараметр("ЗавершеныПредшественники", Перечисления.СостоянияПредшественниковЭтапа.ЗавершеныПредшественники);
	
	Запрос.УстановитьПараметр("ПустоеСостояниеНаМежцеховомУровне",    Перечисления.СостоянияЭтаповНаМежцеховомУровне.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустоеСостояниеНаВнутрицеховомУровне", Перечисления.СостоянияЭтаповНаВнутрицеховомУровне.ПустаяСсылка());
	
	Запрос.Текст = ТекстЗапросаРасчетаСостояния(ПараметрыРасчета);
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса  = Запрос.ВыполнитьПакет();
	КоличествоПакетов = РезультатЗапроса.Количество();
	
	Если ПараметрыРасчета.ОпределитьСпособЗаписи Тогда
		ВыборкаИзменений = РезультатЗапроса[КоличествоПакетов-2].Выбрать();
		ПараметрыРасчета.ЗаписыватьНаборами = НЕ РезультатЗапроса[КоличествоПакетов-1].Пустой();
	Иначе
		ВыборкаИзменений = РезультатЗапроса[КоличествоПакетов-1].Выбрать();
		ПараметрыРасчета.ЗаписыватьНаборами = Ложь;
	КонецЕсли;
	
	Возврат ВыборкаИзменений;

КонецФункции

Функция ТекстЗапросаРасчетаСостояния(ПараметрыРасчета)
	
	ВременныеТаблицыДокумента = Документы.ЭтапПроизводства2_2.ВременныеТаблицыДляРасчетаСостояния();
	
	ТекстыЗапроса = Новый Массив;
	
	ТекстыЗапроса.Добавить(ВременныеТаблицыДокумента.Реквизиты);
	
	Если ПараметрыРасчета.РассчитатьОбеспечение Тогда
		
		ТекстыЗапроса.Добавить(ВременныеТаблицыДокумента.Обеспечение);
		
		ТекстЗапроса = ТекстЗапросаВТЕстьОстаткиКЗаказу();
		ТекстыЗапроса.Добавить(ТекстЗапроса);
		
	КонецЕсли;
	
	Если ПараметрыРасчета.РассчитатьОформлениеВыработки Тогда
		ТекстЗапроса = ТекстЗапросаВТТрудозатратыКОформлению();
		ТекстыЗапроса.Добавить(ТекстЗапроса);
	КонецЕсли;
	
	Если ПараметрыРасчета.РассчитатьСостояниеЭтапов Тогда
		ТекстыЗапроса.Добавить(ВременныеТаблицыДокумента.СостоянияПредшественников);
	КонецЕсли;
	
	Если ПараметрыРасчета.РассчитатьСостояниеОпераций Тогда
		ТекстЗапроса = ТекстЗапросаВТСостоянияОпераций();
		ТекстыЗапроса.Добавить(ТекстЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаСостоянияЭтаповПроизводства(ПараметрыРасчета);
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	Если ПараметрыРасчета.ОпределитьСпособЗаписи Тогда
		ТекстЗапроса = ТекстЗапросаЗаписыватьНаборами();
		ТекстыЗапроса.Добавить(ТекстЗапроса);
	КонецЕсли;
	
	Возврат УправлениеПроизводством.ОбъединитьТекстыЗапросаВПакет(ТекстыЗапроса);
	
КонецФункции

Процедура ЗаписатьСостоянияПоРаспоряжениям(Выборка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЕстьЗаписиВВыборке = Выборка.Следующий();
	
	Пока ЕстьЗаписиВВыборке Цикл
		
		ТекущееРаспоряжение = Выборка.Распоряжение;
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияЭтаповПроизводства");
			ЭлементБлокировки.УстановитьЗначение("Распоряжение", ТекущееРаспоряжение);
			
			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.СостоянияЭтаповПроизводства.СоздатьНаборЗаписей();
			Набор.Отбор.Распоряжение.Установить(ТекущееРаспоряжение);
			
			Набор.Прочитать();
			
			СоответствиеЗаписей = Новый Соответствие;
			Для каждого Запись Из Набор Цикл
				СоответствиеЗаписей.Вставить(Запись.Этап,Запись);
			КонецЦикла;
			
			Пока ЕстьЗаписиВВыборке
				И Выборка.Распоряжение = ТекущееРаспоряжение Цикл
				
				Запись = СоответствиеЗаписей[Выборка.Этап];
				Если Запись = Неопределено Тогда
					ЗаполнитьЗначенияСвойств(Набор.Добавить(), Выборка);
				Иначе
					ЗаполнитьЗначенияСвойств(Запись, Выборка);
				КонецЕсли;
				
				ЕстьЗаписиВВыборке = Выборка.Следующий();
				
			КонецЦикла;
			
			Набор.Записать(Истина);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось отразить состояние этапа по распоряжению: %Ссылка% по причине: %Причина%';
									|en = 'Cannot record the stage state by reference: %Ссылка% due to: %Причина%'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", ТекущееРаспоряжение);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Предупреждение, ТекущееРаспоряжение.Метаданные(), ТекущееРаспоряжение, ТекстСообщения);
				
			Пока ЕстьЗаписиВВыборке
				И Выборка.Распоряжение = ТекущееРаспоряжение Цикл
				ЕстьЗаписиВВыборке = Выборка.Следующий();
				Продолжить;
			КонецЦикла;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьСостоянияПоЭтапам(Выборка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пока Выборка.Следующий() Цикл
		
		Набор = РегистрыСведений.СостоянияЭтаповПроизводства.СоздатьНаборЗаписей();
		Набор.Отбор.Распоряжение.Установить(Выборка.Распоряжение);
		Набор.Отбор.Этап.Установить(Выборка.Этап);
		
		ЗаполнитьЗначенияСвойств(Набор.Добавить(), Выборка);
		
		Попытка
			
			Набор.Записать(Истина);
			
		Исключение
			
			ТекстСообщения = НСтр("ru = 'Не удалось отразить состояние этапа: %Ссылка% по причине: %Причина%';
									|en = 'Cannot record the stage state: %Ссылка% due to: %Причина%'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Этап);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			СобытиеЖурналаРегистрации = СобытиеЖурналаРегистрации();
			
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации, УровеньЖурналаРегистрации.Предупреждение,
				УровеньЖурналаРегистрации.Предупреждение, Выборка.Этап.Метаданные(), Выборка.Этап, ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеПоПоказателям

Процедура ЗаписатьСостоянияПоЭтапамВыборочно(Выборка, Показатели, ОбработанныеРаспоряжения = Неопределено)
	
	СписокПоказателей = СписокПоказателей(Показатели);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияЭтаповПроизводства");
			ЭлементБлокировки.УстановитьЗначение("Этап", Выборка.Этап);
			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.СостоянияЭтаповПроизводства.СоздатьНаборЗаписей();
			Набор.Отбор.Этап.Установить(Выборка.Этап);
		
			Набор.Прочитать();
			
			Если Набор.Количество() > 0 Тогда
				
				ЗаполнитьЗначенияСвойств(Набор[0], Выборка, СписокПоказателей);
				
			Иначе
				
				ЗаполнитьЗначенияСвойств(Набор.Добавить(), Выборка);
				
			КонецЕсли;
		
			Набор.Записать(Истина);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось отразить состояние обеспечения этапа: %Ссылка% по причине: %Причина%';
									|en = 'Cannot record the stage supply state: %Ссылка% due to: %Причина%'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Этап);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			СобытиеЖурналаРегистрации = СобытиеЖурналаРегистрации();
			
			ЗаписьЖурналаРегистрации(
				СобытиеЖурналаРегистрации,
				УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Этап.Метаданные(),
				Выборка.Этап,
				ТекстСообщения);
			
			Продолжить;
			
		КонецПопытки;
		
		Если ОбработанныеРаспоряжения <> Неопределено 
			И ОбработанныеРаспоряжения.Найти(Выборка.Распоряжение) = Неопределено Тогда
			ОбработанныеРаспоряжения.Добавить(Выборка.Распоряжение);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ТекстыЗапросов

Функция ТекстЗапросаВТЕстьОстаткиКЗаказу()
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеквизитыДокумента.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТЕстьОстаткиКЗаказу
		|ИЗ
		|	ВТРеквизитыДокумента КАК РеквизитыДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			Обеспечение.Номенклатура   КАК Номенклатура,
		|			Обеспечение.Характеристика КАК Характеристика,
		|			Обеспечение.Склад          КАК Склад,
		|			Обеспечение.Назначение     КАК Назначение
		|		ИЗ
		|			РегистрНакопления.ОбеспечениеЗаказов.Остатки(
		|					,
		|					Назначение В
		|						(ВЫБРАТЬ
		|							Т.НазначениеМатериалы КАК Назначение
		|						ИЗ
		|							ВТРеквизитыДокумента КАК Т)) КАК Обеспечение
		|		ГДЕ
		|			Обеспечение.КЗаказуОстаток > 0) КАК ТаблицаОстатки
		|		ПО РеквизитыДокумента.НазначениеМатериалы = ТаблицаОстатки.Назначение
		|ГДЕ
		|	РеквизитыДокумента.РассчитыватьОстаткиКЗаказу
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеквизитыДокумента.Ссылка
		|ИЗ
		|	ВТРеквизитыДокумента КАК РеквизитыДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			Обеспечение.Номенклатура   КАК Номенклатура,
		|			Обеспечение.Характеристика КАК Характеристика,
		|			Обеспечение.Подразделение  КАК Подразделение,
		|			Обеспечение.Назначение     КАК Назначение
		|		ИЗ
		|			РегистрНакопления.ОбеспечениеЗаказовРаботами.Остатки(
		|					,
		|					Назначение В
		|						(ВЫБРАТЬ
		|							Т.НазначениеМатериалы КАК Назначение
		|						ИЗ
		|							ВТРеквизитыДокумента КАК Т)) КАК Обеспечение) КАК ТаблицаОстатки
		|		ПО РеквизитыДокумента.НазначениеМатериалы = ТаблицаОстатки.Назначение
		|ГДЕ
		|	РеквизитыДокумента.РассчитыватьОстаткиКЗаказу";
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ТекстЗапросаВТСостоянияОпераций()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	РеквизитыДокумента.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(МИНИМУМ(ВЫБОР
		|						КОГДА ОчередьПроизводственныхОпераций.Создано >= ОчередьПроизводственныхОпераций.Запланировано + ОчередьПроизводственныхОпераций.ТребуетПовторения
		|								И ОчередьПроизводственныхОпераций.Создано = ОчередьПроизводственныхОпераций.Выполнено + ОчередьПроизводственныхОпераций.Пропущено
		|							ТОГДА ИСТИНА
		|						ИНАЧЕ ЛОЖЬ
		|					КОНЕЦ), ЛОЖЬ) = ИСТИНА
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОперацийЭтапаПроизводства.Выполнено)
		|		КОГДА ЕСТЬNULL(МАКСИМУМ(ВЫБОР
		|						КОГДА ОчередьПроизводственныхОпераций.Создано > ОчередьПроизводственныхОпераций.Выполнено + ОчередьПроизводственныхОпераций.Пропущено
		|								ИЛИ ОперацииНазначенныеСЗ.СменноеЗадание ЕСТЬ НЕ NULL
		|							ТОГДА ИСТИНА
		|						ИНАЧЕ ЛОЖЬ
		|					КОНЕЦ), ЛОЖЬ) = ИСТИНА
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОперацийЭтапаПроизводства.ОжидаетЗавершения)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СостоянияОперацийЭтапаПроизводства.ОжидаетНазначения)
		|	КОНЕЦ                     КАК Состояние
		|
		|ПОМЕСТИТЬ ВТСостоянияОпераций
		|ИЗ
		|	ВТРеквизитыДокумента КАК РеквизитыДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОчередьПроизводственныхОпераций КАК ОчередьПроизводственныхОпераций
		|		ПО РеквизитыДокумента.Подразделение = ОчередьПроизводственныхОпераций.Подразделение
		|			И РеквизитыДокумента.Ссылка = ОчередьПроизводственныхОпераций.Этап
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОперацииКСозданиюСменныхЗаданий КАК ОперацииНазначенныеСЗ
		|		ПО РеквизитыДокумента.Подразделение = ОперацииНазначенныеСЗ.Подразделение
		|			И РеквизитыДокумента.Ссылка = ОперацииНазначенныеСЗ.Этап
		|			И ОперацииНазначенныеСЗ.СменноеЗадание <> ЗНАЧЕНИЕ(Документ.СменноеЗадание.ПустаяСсылка)
		|ГДЕ
		|	ВЫБОР
		|		КОГДА (РеквизитыДокумента.Подразделение.ИспользоватьПооперационноеПланирование
		|			ИЛИ РеквизитыДокумента.Подразделение.ИспользоватьСменныеЗадания)
		|				И РеквизитыДокумента.Статус В (
		|					ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.КВыполнению),
		|					ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Начат))
		|			ТОГДА ИСТИНА
		|		КОГДА РеквизитыДокумента.Подразделение.ИспользоватьПооперационноеУправление
		|				И РеквизитыДокумента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Начат) 
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|	И НЕ РеквизитыДокумента.ПроизводствоНаСтороне
		|	И РеквизитыДокумента.МаршрутнаяКарта <> ЗНАЧЕНИЕ(Справочник.МаршрутныеКарты.ПустаяСсылка)
		|СГРУППИРОВАТЬ ПО
		|	РеквизитыДокумента.Ссылка";
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ТекстЗапросаВТТрудозатратыКОформлению()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ТрудозатратыКОформлениюОстатки.Распоряжение КАК Ссылка
		|ПОМЕСТИТЬ ВТТрудозатратыКОформлению
		|ИЗ
		|	РегистрНакопления.ТрудозатратыКОформлению.Остатки(
		|				,
		|				Распоряжение В
		|					(ВЫБРАТЬ
		|						Т.Ссылка КАК Распоряжение
		|					ИЗ
		|						ВТРеквизитыДокумента КАК Т)) КАК ТрудозатратыКОформлениюОстатки";
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ТекстЗапросаСостоянияЭтаповПроизводства(ПараметрыРасчета)
	
	ТекстЗапроса = "ВЫБРАТЬ"
		+ ?(ПараметрыРасчета.РассчитатьСостояниеЭтапов, "
			|	ВЫБОР
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусФормируется ТОГДА
			|			ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаМежцеховомУровне.ТребуетУточнения)
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусСформирован
			|			ТОГДА ВЫБОР
			|					КОГДА ЕСТЬNULL(СостоянияПредшественников.Состояние, &НетПредшественников) В (&НетПредшественников, &ЗавершеныПредшественники)
			|						ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаМежцеховомУровне.ГотовКВыполнению)
			|					ИНАЧЕ &ПустоеСостояниеНаМежцеховомУровне
			|				КОНЕЦ
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусКВыполнению
			|			ТОГДА ВЫБОР
			|					КОГДА ЕСТЬNULL(СостоянияПредшественников.Состояние, &НетПредшественников) В (&НетПредшественников, &ЗавершеныПредшественники)
			|						ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаМежцеховомУровне.ОжидаетНачала)
			|					ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаМежцеховомУровне.ОжидаетПредшественников)
			|				КОНЕЦ
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусНачат
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаМежцеховомУровне.ОжидаетЗавершения)
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусЗавершен
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаМежцеховомУровне.Завершен)
			|		ИНАЧЕ &ПустоеСостояниеНаМежцеховомУровне
			|
			|	КОНЕЦ                               КАК СостояниеНаМежцеховомУровне,
			|
			|	ВЫБОР
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусЗавершен
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаВнутрицеховомУровне.Завершен)
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусНачат
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаВнутрицеховомУровне.Начат)
			|		КОГДА ЕСТЬNULL(СостоянияПредшественников.Состояние, &НетПредшественников) В (&НетПредшественников, &ЗавершеныПредшественники)
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаВнутрицеховомУровне.МожноВыполнять)
			|		КОГДА ЕСТЬNULL(СостоянияПредшественников.Состояние, &НетПредшественников) = &НачатыПредшественники
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаВнутрицеховомУровне.НачатыПредшествующие)
			|		КОГДА ЕСТЬNULL(СостоянияПредшественников.Состояние, &НетПредшественников) = &НеНачатыПредшественники
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповНаВнутрицеховомУровне.ОжиданиеПредшествующих)
			|		ИНАЧЕ &ПустоеСостояниеНаВнутрицеховомУровне
			|
			|	КОНЕЦ                               КАК СостояниеНаВнутрицеховомУровне,
			|
			|	ВЫБОР
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусЗавершен
			|			ТОГДА 5
			|		КОГДА ВТРеквизитыДокумента.Статус = &СтатусНачат
			|			ТОГДА 4
			|		КОГДА ЕСТЬNULL(СостоянияПредшественников.Состояние, &НетПредшественников) В (&НетПредшественников, &ЗавершеныПредшественники)
			|			ТОГДА 3
			|		КОГДА ЕСТЬNULL(СостоянияПредшественников.Состояние, &НетПредшественников) = &НачатыПредшественники
			|			ТОГДА 2
			|		КОГДА ЕСТЬNULL(СостоянияПредшественников.Состояние, &НетПредшественников) = &НеНачатыПредшественники
			|			ТОГДА 1
			|		ИНАЧЕ 0
			|
			|	КОНЕЦ                               КАК КодСостоянияНаВнутрицеховомУровне, 
			|", "")
		+ ?(ПараметрыРасчета.РассчитатьСостояниеОпераций, "
			|	ВЫБОР
			|		КОГДА НЕ СостоянияОпераций.Ссылка ЕСТЬ NULL
			|			ТОГДА СостоянияОпераций.Состояние
			|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СостоянияОперацийЭтапаПроизводства.ПустаяСсылка)
			|
			|	КОНЕЦ                               КАК СостояниеОпераций,
			|", "")
		+ ?(ПараметрыРасчета.РассчитатьОбеспечение, "
			|	ВЫБОР
			|		КОГДА ВТРеквизитыДокумента.СтатусЗавершен
			|				ИЛИ НЕ ВТРеквизитыДокумента.Проведен
			|				ИЛИ ОбеспечениеЗаказа.Ссылка ЕСТЬ NULL 
			|			ТОГДА ЛОЖЬ
			|		КОГДА ОбеспечениеЗаказа.ЕстьКОбеспечению
			|				ИЛИ ОбеспечениеЗаказа.ЕстьРезервироватьКДате
			|			ТОГДА ИСТИНА
			|		КОГДА ОбеспечениеЗаказа.ЕстьКОбеспечениюОбособленно
			|				И НЕ ЕстьОстаткиКЗаказу.Ссылка ЕСТЬ NULL
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ                               КАК ТребуетОбеспечения,
			|", "")
		+ ?(ПараметрыРасчета.РассчитатьОформлениеВыработки, "
			|	ВЫБОР
			|		КОГДА ТрудозатратыКОформлению.Ссылка ЕСТЬ NULL
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ 								КАК ТребуетОформленияВыработки,
			|", "")
		+ ("
			|	ВТРеквизитыДокумента.Распоряжение   КАК Распоряжение,
			|	ВТРеквизитыДокумента.Ссылка         КАК Этап
			|ИЗ
			|	ВТРеквизитыДокумента КАК ВТРеквизитыДокумента
			|")
		+ ?(ПараметрыРасчета.РассчитатьОбеспечение, "
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОбеспечениеЗаказа КАК ОбеспечениеЗаказа
			|		ПО ОбеспечениеЗаказа.Ссылка = ВТРеквизитыДокумента.Ссылка
			|
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЕстьОстаткиКЗаказу КАК ЕстьОстаткиКЗаказу
			|		ПО ЕстьОстаткиКЗаказу.Ссылка = ВТРеквизитыДокумента.Ссылка
			|", "")
		+ ?(ПараметрыРасчета.РассчитатьОформлениеВыработки, "
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТрудозатратыКОформлению КАК ТрудозатратыКОформлению
			|		ПО ТрудозатратыКОформлению.Ссылка = ВТРеквизитыДокумента.Ссылка
			|", "")
		+ ?(ПараметрыРасчета.РассчитатьСостояниеОпераций, "
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСостоянияОпераций КАК СостоянияОпераций
			|		ПО СостоянияОпераций.Ссылка = ВТРеквизитыДокумента.Ссылка
			|", "")
		+ ?(ПараметрыРасчета.РассчитатьСостояниеЭтапов, "
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСостоянияПредшественников КАК СостоянияПредшественников
			|		ПО СостоянияПредшественников.Ссылка = ВТРеквизитыДокумента.Ссылка
			|", "")
		+ ("
			|УПОРЯДОЧИТЬ ПО
			|	Распоряжение
			|");
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаЗаписыватьНаборами()
	
	ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	ВТРеквизитыДокумента КАК Таблица
		|
		|СГРУППИРОВАТЬ ПО
		|	Таблица.Распоряжение
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(Таблица.Ссылка) > 100";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Межцеховое управление.Ошибка отражения состояния обеспечения этапов';
				|en = 'Intershop management.An error occurred when recording the stage supply state'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Функция ПараметрыРасчетаКонструктор(МассивСсылокКОбновлению = Неопределено, МассивСсылокКОчистке = Неопределено, Показатели = Неопределено)
	
	ПараметрыРасчета = Новый Структура;
	
	Если МассивСсылокКОбновлению <> Неопределено Тогда
		ПараметрыРасчета.Вставить("МассивСсылокКОбновлению", МассивСсылокКОбновлению);
	Иначе
		ПараметрыРасчета.Вставить("МассивСсылокКОбновлению", Новый Массив);
	КонецЕсли;
	
	Если МассивСсылокКОчистке <> Неопределено Тогда
		ПараметрыРасчета.Вставить("МассивСсылокКОчистке", МассивСсылокКОчистке);
	Иначе
		ПараметрыРасчета.Вставить("МассивСсылокКОчистке", Новый Массив);
	КонецЕсли;
	
	Если Показатели = Неопределено Тогда
		Показатели = ПоказателиКонструктор();
	КонецЕсли;
	
	ПараметрыРасчета.Вставить("РассчитатьОбеспечение", Показатели.Найти("ТребуетОбеспечения") <> Неопределено);
	ПараметрыРасчета.Вставить("РассчитатьОформлениеВыработки", Показатели.Найти("ТребуетОформленияВыработки") <> Неопределено);
	ПараметрыРасчета.Вставить("РассчитатьСостояниеЭтапов", Показатели.Найти("СостояниеНаМежцеховомУровне") <> Неопределено);
	ПараметрыРасчета.Вставить("РассчитатьСостояниеОпераций", Показатели.Найти("СостояниеОпераций") <> Неопределено);
	
	ПараметрыРасчета.Вставить("Показатели", Показатели);
	
	Если МассивСсылокКОбновлению <> Неопределено
		И МассивСсылокКОбновлению.Количество() > 100 Тогда
		ПараметрыРасчета.Вставить("ОпределитьСпособЗаписи", Истина);
	Иначе
		ПараметрыРасчета.Вставить("ОпределитьСпособЗаписи", Ложь);
	КонецЕсли;

	ПараметрыРасчета.Вставить("ЗаписыватьНаборами", Ложь);
	
	Возврат ПараметрыРасчета;
	
КонецФункции

Функция ПоказателиКонструктор()
	
	Показатели = Новый Массив;
	
	Показатели.Добавить("ТребуетОбеспечения");
	Показатели.Добавить("ТребуетОформленияВыработки");
	Показатели.Добавить("СостояниеНаМежцеховомУровне");
	Показатели.Добавить("СостояниеНаВнутрицеховомУровне");
	Показатели.Добавить("СостояниеОпераций");
	
	Возврат Показатели;
	
КонецФункции

Функция СписокПоказателей(Показатели)
	
	Возврат СтрСоединить(Показатели, ",");

КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
