#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ПериодДействия", ПериодДействия);
	Параметры.Свойство("Сотрудник", Сотрудник);
	
	Заголовок = Строка(Сотрудник) + ", " + Формат(ПериодДействия, "ДФ='ММММ гггг'");
	
	ПрочитатьПерерасчеты();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПричиныПерерасчетаЗарплатыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПричиныПерерасчета(ПричиныПерерасчетаЗарплаты, Элемент)
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыПерерасчетыЛьгот

&НаКлиенте
Процедура ПерерасчетыЛьготВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		Если Поле.Имя = "ПерерасчетыЛьготПричины" Тогда
			ОткрытьПричиныПерерасчета(Элемент.ТекущиеДанные.Причины, Элемент);
		Иначе
			ПоказатьЗначение(, Элемент.ТекущиеДанные.Льгота);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыПерерасчетыУдержаний

&НаКлиенте
Процедура ПерерасчетыУдержанийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		Если Поле.Имя = "ПерерасчетыУдержанийПричины" Тогда
			ОткрытьПричиныПерерасчета(Элемент.ТекущиеДанные.Причины, Элемент);
		ИначеЕсли Поле.Имя = "ПерерасчетыУдержанийУдержание" Тогда
			ПоказатьЗначение( , Элемент.ТекущиеДанные.Удержание);
		ИначеЕсли ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДокументОснование) Тогда
			ПоказатьЗначение( , Элемент.ТекущиеДанные.ДокументОснование);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьПерерасчеты()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПериодДействия", ПериодДействия);
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПерерасчетЗарплаты.Основание
		|ИЗ
		|	РегистрСведений.ПерерасчетЗарплаты КАК ПерерасчетЗарплаты
		|ГДЕ
		|	ПерерасчетЗарплаты.Сотрудник = &Сотрудник
		|	И ПерерасчетЗарплаты.ПериодДействия = &ПериодДействия
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПерерасчетЗарплаты.Основание.Дата,
		|	ПерерасчетЗарплаты.Основание.Ссылка";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПерерасчетЗарплаты.ДобавитьПричинуПерерасчета(ПричиныПерерасчетаЗарплаты, Выборка.Основание);
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПричиныПерерасчетаЗарплаты",
			"Доступность",
			ПричиныПерерасчетаЗарплаты.Количество() > 0);
		
		Если ПричиныПерерасчетаЗарплаты.Количество() = 0 Тогда
			ПричиныПерерасчетаЗарплаты.Добавить(НСтр("ru = 'Причина неизвестна';
													|en = 'Reason is unknown'"));
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПерерасчетЗарплатыГруппа",
		"Видимость",
		Не РезультатЗапроса.Пустой());
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда 
		
		МодульЛьготыСотрудников = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		МодульЛьготыСотрудников.ФормаПодробнееОПерерасчетахПрочитатьПерерасчеты(ЭтотОбъект);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПерерасчетыЛьготГруппа",
			"Видимость",
			Ложь);
		
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПерерасчетУдержаний.Удержание,
		|	ПерерасчетУдержаний.ДокументОснование,
		|	ПерерасчетУдержаний.Основание
		|ИЗ
		|	РегистрСведений.ПерерасчетУдержаний КАК ПерерасчетУдержаний
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО ПерерасчетУдержаний.ФизическоеЛицо = Сотрудники.ФизическоеЛицо
		|			И (Сотрудники.Ссылка = &Сотрудник)
		|ГДЕ
		|	ПерерасчетУдержаний.ПериодДействия = &ПериодДействия
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПерерасчетУдержаний.Удержание.РеквизитДопУпорядочивания,
		|	ПерерасчетУдержаний.ДокументОснование,
		|	ПерерасчетУдержаний.Основание.Дата,
		|	ПерерасчетУдержаний.Основание.Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Удержание") Цикл
			
			Пока Выборка.СледующийПоЗначениюПоля("ДокументОснование") Цикл
				
				НоваяСтрока = ПерерасчетыУдержаний.Добавить();
				НоваяСтрока.Удержание = Выборка.Удержание;
				НоваяСтрока.ДокументОснование = Выборка.ДокументОснование;
				
				Пока Выборка.Следующий() Цикл
					ПерерасчетЗарплаты.ДобавитьПричинуПерерасчета(НоваяСтрока.Причины, Выборка.Основание);
				КонецЦикла;
				
				Если НоваяСтрока.Причины.Количество() = 0 Тогда
					НоваяСтрока.ПричинаНеизвестна = Истина;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПерерасчетыУдержаний",
		"Видимость",
		Не РезультатЗапроса.Пустой());
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПричиныПерерасчета(Причина, Элемент)
	
	Если Причина.Количество() > 0 Тогда
		
		Если Причина.Количество() = 1 Тогда
			ОткрытьПричиныПерерасчетаЗавершение(Причина[0]);
		Иначе
			
			Оповещение = Новый ОписаниеОповещения("ОткрытьПричиныПерерасчетаЗавершение", ЭтотОбъект);
			ПоказатьВыборИзСписка(Оповещение, Причина, Элемент);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПричиныПерерасчетаЗавершение(Результат, ДополнительныеСвойства = Неопределено) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОткрытьФормуОбъекта(Результат.Значение);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОбъекта(СсылкаНаОбъект, ПараметрыОткрытия = Неопределено)
	
	Если ПараметрыОткрытия = Неопределено Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", СсылкаНаОбъект);
	КонецЕсли; 
	
	ОткрытьФорму("Документ." + ИмяОбъектаМетаданных(СсылкаНаОбъект) + ".ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяОбъектаМетаданных(Ссылка)
	
	Возврат Ссылка.Метаданные().Имя;
	
КонецФункции

#КонецОбласти
