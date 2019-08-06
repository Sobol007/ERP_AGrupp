
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтбор();
					
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	ОтборДинамическогоСписка = ЖурналОтчетов.КомпоновщикНастроек.Настройки.Отбор;
		
	ИсточникОтчета  = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Периодичность   = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Организация     = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	КодНалоговогоОргана = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ДатаНачала      = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ДатаОкончания   = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ДатаОкончания2  = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ИсточникОтчета.Использование = Истина;
	ИсточникОтчета.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ИсточникОтчета.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсточникОтчета");
	
	Периодичность.Использование = Ложь;
	Периодичность.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Периодичность.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Периодичность");
	
	Организация.Использование = Ложь;
	Организация.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	Организация.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	
	КодНалоговогоОргана.Использование = Ложь;
	КодНалоговогоОргана.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КодНалоговогоОргана.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КодНалоговогоОргана");
	
	ДатаНачала.Использование = Ложь;
	ДатаНачала.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ДатаНачала.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаНачала");
	
	ДатаОкончания.Использование = Ложь;
	ДатаОкончания.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
		
	ДатаОкончания2.Использование = Ложь;
	ДатаОкончания2.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
		
	Если Параметры.мВыбраннаяФормаКалендаря = Неопределено Тогда
		ИсточникОтчета.ПравоеЗначение = Параметры.ИсточникОтчета;
	Иначе
		ИсточникОтчета.ПравоеЗначение = Параметры.мВыбраннаяФормаКалендаря;
	КонецЕсли;

	Если Параметры.мПериодичностьКалендарь = Неопределено Тогда
		// Режим из ЦУО
		ВладелецФормыПериодичность = Параметры.Периодичность;
	Иначе
		ВладелецФормыПериодичность = "Уникальная";
		// Установим отбор по периодичности.
		Если Параметры.мПериодичностьКалендарь = "Месячная" Тогда
			Периодичность.ПравоеЗначение = Перечисления.Периодичность.Месяц;
		КонецЕсли;

		Если Параметры.мПериодичностьКалендарь = "Квартальная" Тогда
			Периодичность.ПравоеЗначение = Перечисления.Периодичность.Квартал;
		КонецЕсли;

	КонецЕсли;

	Если Параметры.мДатаКонцаПериодаОтчетаКалендарь = Неопределено Тогда
		ВладелецФормыДатаКонцаПериодаОтчета = Параметры.ДатаКонцаПериодаОтчета;
	Иначе
		ВладелецФормыДатаКонцаПериодаОтчета = Параметры.мДатаКонцаПериодаОтчетаКалендарь;
	КонецЕсли;

	Если Параметры.Организация.Количество() = 0 Тогда
		Организация.Использование = Ложь;
	Иначе
		Организация.Использование = Истина;
		Организация.ПравоеЗначение = Параметры.Организация;
	КонецЕсли;
		
	Если НЕ Параметры.ОтборКодИФНС Тогда
		КодНалоговогоОргана.Использование = Ложь;
	Иначе
		КодНалоговогоОргана.Использование = Истина;
		КодНалоговогоОргана.ПравоеЗначение = Параметры.КодИФНС;
	КонецЕсли;
		
	Если НЕ Параметры.ОтборПериод Тогда
		ДатаНачала.Использование = Ложь;
		ДатаОкончания.Использование = Ложь;
	Иначе                            
		Если ВладелецФормыПериодичность = "Произвольный" Тогда
			ДатаНачала.Использование = Истина;
			ДатаОкончания.Использование = Истина;
			ДатаНачала.ПравоеЗначение = Параметры.ДатаНачалаПериодаОтчета;
			ДатаОкончания.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			ДатаОкончания.ПравоеЗначение = Параметры.ДатаКонцаПериодаОтчета;
		Иначе
			ДатаНачала.Использование = Ложь;
			
			ДатаОкончания.Использование = Истина;
			ДатаОкончания.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			ДатаОкончания.ПравоеЗначение = НачалоДня(ВладелецФормыДатаКонцаПериодаОтчета);
			
			ДатаОкончания2.Использование = Истина;
			ДатаОкончания2.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			ДатаОкончания2.ПравоеЗначение = КонецДня(ВладелецФормыДатаКонцаПериодаОтчета);
		КонецЕсли;
	КонецЕсли;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
			
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОтчет(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОтчет(Команда)
	
	Если Элементы.ЖурналОтчетов.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Выберите отчет для открытия.';
									|en = 'Select a report for opening.'"));
		Возврат;
	КонецЕсли;
	Закрыть(Элементы.ЖурналОтчетов.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналОтчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Закрыть(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти