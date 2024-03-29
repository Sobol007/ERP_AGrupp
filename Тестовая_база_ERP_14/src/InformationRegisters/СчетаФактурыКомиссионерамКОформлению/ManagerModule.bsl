#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Переформировывает распоряжения на оформления счетов-фактур комиссионерам.
//
// Параметры:
// 	 ОтчетыКомиссионеров - Массив - Отчеты по комиссии, по которым необходимо выполнить формирование распоряжений.
// 
Процедура ОбновитьСостояние(ОтчетыКомиссионеров) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеОтчетовКомиссионеров.Организация КАК Организация,
	|	ДанныеОтчетовКомиссионеров.Регистратор КАК ОтчетКомиссионера,
	|	ДанныеОтчетовКомиссионеров.Контрагент  КАК Комиссионер,
	|	ДанныеОтчетовКомиссионеров.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактуры,
	|	ДанныеОтчетовКомиссионеров.НомерСчетаФактурыКомиссионера КАК НомерСчетаФактуры,
	|	ДанныеОтчетовКомиссионеров.ПокупательКомиссионногоТовара КАК Покупатель,
	|	ДанныеОтчетовКомиссионеров.Валюта КАК Валюта,
	|	СУММА(ДанныеОтчетовКомиссионеров.СуммаБезНДС + ДанныеОтчетовКомиссионеров.СуммаНДС) КАК СуммаСНДС,
	|	СУММА(ДанныеОтчетовКомиссионеров.СуммаНДС) КАК СуммаНДС
	|ПОМЕСТИТЬ СчетаФакутурыКомиссионеруКРегистрации
	|ИЗ
	|	РегистрСведений.ДанныеОснованийСчетовФактур КАК ДанныеОтчетовКомиссионеров
	|ГДЕ
	|	ДанныеОтчетовКомиссионеров.Регистратор В (&Ссылки)
	|	И ДанныеОтчетовКомиссионеров.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС)
	|	И ДанныеОтчетовКомиссионеров.ТипСчетаФактуры = &ИдентификаторСчетФактураКомиссионеру
	|	
	|СГРУППИРОВАТЬ ПО
	|	ДанныеОтчетовКомиссионеров.Организация,
	|	ДанныеОтчетовКомиссионеров.Регистратор,
	|	ДанныеОтчетовКомиссионеров.Контрагент,
	|	ДанныеОтчетовКомиссионеров.ДатаСчетаФактурыКомиссионера,
	|	ДанныеОтчетовКомиссионеров.НомерСчетаФактурыКомиссионера,
	|	ДанныеОтчетовКомиссионеров.ПокупательКомиссионногоТовара,
	|	ДанныеОтчетовКомиссионеров.Валюта
	|;
	|
	|ВЫБРАТЬ
	|	СчетФактураКомиссионеру.Ссылка КАК Ссылка,
	|	СчетФактураКомиссионеру.Организация КАК Организация,
	|	СчетФактураКомиссионеру.ДокументОснование КАК ОтчетКомиссионера,
	|	СчетФактураКомиссионеру.Комиссионер КАК Комиссионер,
	|	ТаблицаПокупатели.Покупатель КАК Покупатель,
	|	СчетФактураКомиссионеру.Дата КАК ДатаСчетаФактуры,
	|	ТаблицаПокупатели.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|	СчетФактураКомиссионеру.Валюта КАК Валюта
	|ПОМЕСТИТЬ СчетаФактурыКомиссионеру
	|ИЗ
	|	Документ.СчетФактураКомиссионеру КАК СчетФактураКомиссионеру
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СчетФактураКомиссионеру.Покупатели КАК ТаблицаПокупатели
	|	ПО
	|		СчетФактураКомиссионеру.Ссылка = ТаблицаПокупатели.Ссылка
	|ГДЕ
	|	СчетФактураКомиссионеру.ДокументОснование В (&Ссылки)
	|	И СчетФактураКомиссионеру.Проведен
	|;
	|
	|ВЫБРАТЬ
	|	КРегистрации.ОтчетКомиссионера,
	|	КРегистрации.Комиссионер,
	|	КРегистрации.Организация,
	|	КРегистрации.Покупатель,
	|	КРегистрации.ДатаСчетаФактуры,
	|	КРегистрации.НомерСчетаФактуры,
	|	КРегистрации.Валюта,
	|	КРегистрации.СуммаСНДС,
	|	КРегистрации.СуммаНДС
	|ИЗ
	|	СчетаФакутурыКомиссионеруКРегистрации КАК КРегистрации
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СчетаФактурыКомиссионеру КАК СчетаФактурыКомиссионеру
	|	ПО
	|		КРегистрации.ОтчетКомиссионера = СчетаФактурыКомиссионеру.ОтчетКомиссионера
	|		И КРегистрации.Покупатель = СчетаФактурыКомиссионеру.Покупатель
	|		И КРегистрации.НомерСчетаФактуры = СчетаФактурыКомиссионеру.НомерСчетаФактуры
	|		И (КРегистрации.ДатаСчетаФактуры = СчетаФактурыКомиссионеру.ДатаСчетаФактуры
	|			ИЛИ КРегистрации.ДатаСчетаФактуры = &ПустаяДата)
	|ГДЕ
	|	СчетаФактурыКомиссионеру.Ссылка ЕСТЬ NULL
	|";
	ИдентификаторСчетФактураКомиссионеру = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураКомиссионеру");
	Запрос.УстановитьПараметр("ИдентификаторСчетФактураКомиссионеру", ИдентификаторСчетФактураКомиссионеру);
	Запрос.УстановитьПараметр("Ссылки", ОтчетыКомиссионеров);
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));
	
	СчетаФактурыКомиссионерамКОформлению = Запрос.Выполнить().Выгрузить(); 
	СчетаФактурыКомиссионерамКОформлению.Индексы.Добавить("ОтчетКомиссионера");
	
	Для каждого ОтчетКомиссионера Из ОтчетыКомиссионеров Цикл
		НаборЗаписей = РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОтчетКомиссионера.Установить(ОтчетКомиссионера);
		Строки = СчетаФактурыКомиссионерамКОформлению.НайтиСтроки(Новый Структура("ОтчетКомиссионера", ОтчетКомиссионера));
		Для каждого Строка Из Строки Цикл
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Строка);
		КонецЦикла;
		НаборЗаписей.Записывать = Истина;
		НаборЗаписей.Записать();
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ОтчетКомиссионера.Организация)
	|	И ЗначениеРазрешено(ОтчетКомиссионера.Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли