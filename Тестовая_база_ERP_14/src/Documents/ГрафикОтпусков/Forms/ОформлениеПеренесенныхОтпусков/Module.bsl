
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "ВидОтпуска,ПереносОтпуска,Организация,Сотрудник,ГрафикОтпусков,ДоступноОформлениеОтпусков");
	УстановитьУсловноеОформление();
	
	ЗаполнитьТаблицуОтпусков();
	ЗаполнитьСвязанныеДокументы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанДокументОтпуск" Тогда
		ЗаполнитьСвязанныеДокументы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтпуска

&НаКлиенте
Процедура ОтпускаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ОтпускаОтпуск" Тогда
		СтандартнаяОбработка = Ложь;
		ОбработатьТекущийОтпуск(ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуОтпусков()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ПереносОтпуска);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПереносОтпускаПереносы.ДатаНачала КАК ДатаНачала,
	               |	ПереносОтпускаПереносы.ДатаОкончания КАК ДатаОкончания,
	               |	ПереносОтпускаПереносы.КоличествоДней КАК КоличествоДней
	               |ИЗ
	               |	Документ.ПереносОтпуска.Переносы КАК ПереносОтпускаПереносы
	               |ГДЕ
	               |	ПереносОтпускаПереносы.Ссылка = &Ссылка";
	
	ДанныеОтпусков = Запрос.Выполнить().Выгрузить();
	Отпуска.Загрузить(ДанныеОтпусков);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвязанныеДокументы()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("ВидОтпуска", ВидОтпуска);
	Запрос.УстановитьПараметр("Отпуска", Отпуска.Выгрузить());
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&Сотрудник КАК Сотрудник,
	               |	&ВидОтпуска КАК ВидОтпуска,
	               |	Отпуска.ДатаНачала КАК ДатаНачала
	               |ПОМЕСТИТЬ ВТИсходныеДанные
	               |ИЗ
	               |	&Отпуска КАК Отпуска
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ИсходныеДанные.Сотрудник КАК Сотрудник,
	               |	ИсходныеДанные.ВидОтпуска КАК ВидОтпуска,
	               |	ИсходныеДанные.ДатаНачала КАК ДатаНачала,
	               |	ДОБАВИТЬКДАТЕ(ИсходныеДанные.ДатаНачала, ДЕНЬ, -1) КАК ДатаНачалаФакта,
	               |	ДОБАВИТЬКДАТЕ(ИсходныеДанные.ДатаНачала, ДЕНЬ, 1) КАК ДатаОкончанияФакта
	               |ПОМЕСТИТЬ ВТПлановыеОтпуска
	               |ИЗ
	               |	ВТИсходныеДанные КАК ИсходныеДанные
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	Отпуск.Ссылка КАК Ссылка,
	               |	Отпуск.Сотрудник КАК Сотрудник,
	               |	ЗНАЧЕНИЕ(Справочник.ВидыОтпусков.Основной) КАК ВидОтпуска,
	               |	ПлановыеОтпуска.ДатаНачалаФакта КАК ДатаНачалаФакта,
	               |	Отпуск.Проведен КАК Проведен
	               |ПОМЕСТИТЬ ВТФактическиеОтпуска
	               |ИЗ
	               |	ВТПлановыеОтпуска КАК ПлановыеОтпуска
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Отпуск КАК Отпуск
	               |		ПО ПлановыеОтпуска.Сотрудник = Отпуск.Сотрудник
	               |			И (ПлановыеОтпуска.ВидОтпуска = ЗНАЧЕНИЕ(Справочник.ВидыОтпусков.Основной))
	               |			И (Отпуск.ДатаНачалаОсновногоОтпуска МЕЖДУ ПлановыеОтпуска.ДатаНачалаФакта И ПлановыеОтпуска.ДатаОкончанияФакта)
	               |			И (Отпуск.ПредоставитьОсновнойОтпуск)
	               |			И (НЕ Отпуск.ПометкаУдаления)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ОтпускДополнительныеОтпуска.Ссылка,
	               |	ОтпускДополнительныеОтпуска.Ссылка.Сотрудник,
	               |	ОтпускДополнительныеОтпуска.ВидОтпуска,
	               |	ПлановыеОтпуска.ДатаНачалаФакта,
	               |	ОтпускДополнительныеОтпуска.Ссылка.Проведен
	               |ИЗ
	               |	ВТПлановыеОтпуска КАК ПлановыеОтпуска
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Отпуск.ДополнительныеОтпуска КАК ОтпускДополнительныеОтпуска
	               |		ПО ПлановыеОтпуска.Сотрудник = ОтпускДополнительныеОтпуска.Ссылка.Сотрудник
	               |			И ПлановыеОтпуска.ВидОтпуска = ОтпускДополнительныеОтпуска.ВидОтпуска
	               |			И (ОтпускДополнительныеОтпуска.ДатаНачала МЕЖДУ ПлановыеОтпуска.ДатаНачалаФакта И ПлановыеОтпуска.ДатаОкончанияФакта)
	               |			И (НЕ ОтпускДополнительныеОтпуска.Ссылка.ПометкаУдаления)
	               |			И (ОтпускДополнительныеОтпуска.Ссылка.ПредоставитьДополнительныйОтпуск)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ФактическиеОтпуска.ВидОтпуска КАК ВидОтпуска,
	               |	ФактическиеОтпуска.ДатаНачалаФакта КАК ДатаНачалаФакта,
	               |	МАКСИМУМ(ФактическиеОтпуска.Ссылка) КАК Отпуск
	               |ПОМЕСТИТЬ ВТПроведенныеОтпуска
	               |ИЗ
	               |	ВТФактическиеОтпуска КАК ФактическиеОтпуска
	               |ГДЕ
	               |	ФактическиеОтпуска.Проведен
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ФактическиеОтпуска.ВидОтпуска,
	               |	ФактическиеОтпуска.ДатаНачалаФакта
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ФактическиеОтпуска.ВидОтпуска КАК ВидОтпуска,
	               |	ФактическиеОтпуска.ДатаНачалаФакта КАК ДатаНачалаФакта,
	               |	МАКСИМУМ(ФактическиеОтпуска.Ссылка) КАК Отпуск
	               |ПОМЕСТИТЬ ВТНеПроведенныеОтпуска
	               |ИЗ
	               |	ВТФактическиеОтпуска КАК ФактическиеОтпуска
	               |ГДЕ
	               |	НЕ ФактическиеОтпуска.Проведен
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ФактическиеОтпуска.ВидОтпуска,
	               |	ФактическиеОтпуска.ДатаНачалаФакта
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПлановыеОтпуска.ДатаНачала КАК ДатаНачала,
	               |	ВЫБОР
	               |		КОГДА ПроведенныеОтпуска.Отпуск ЕСТЬ НЕ NULL 
	               |			ТОГДА ПроведенныеОтпуска.Отпуск
	               |		КОГДА НеПроведенныеОтпуска.Отпуск ЕСТЬ НЕ NULL 
	               |			ТОГДА НеПроведенныеОтпуска.Отпуск
	               |		ИНАЧЕ ЗНАЧЕНИЕ(Документ.Отпуск.ПустаяСсылка)
	               |	КОНЕЦ КАК Отпуск,
	               |	ВЫБОР
	               |		КОГДА ПроведенныеОтпуска.Отпуск ЕСТЬ НЕ NULL 
	               |			ТОГДА ПроведенныеОтпуска.Отпуск.ДокументРассчитан
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК Рассчитан,
	               |	ВЫБОР
	               |		КОГДА ПроведенныеОтпуска.Отпуск ЕСТЬ НЕ NULL 
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК Проведен
	               |ИЗ
	               |	ВТПлановыеОтпуска КАК ПлановыеОтпуска
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТПроведенныеОтпуска КАК ПроведенныеОтпуска
	               |		ПО ПлановыеОтпуска.ВидОтпуска = ПроведенныеОтпуска.ВидОтпуска
	               |			И ПлановыеОтпуска.ДатаНачалаФакта = ПроведенныеОтпуска.ДатаНачалаФакта
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТНеПроведенныеОтпуска КАК НеПроведенныеОтпуска
	               |		ПО ПлановыеОтпуска.ВидОтпуска = НеПроведенныеОтпуска.ВидОтпуска
	               |			И ПлановыеОтпуска.ДатаНачалаФакта = НеПроведенныеОтпуска.ДатаНачалаФакта
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаНачала";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		СтрокиОтпусков = Отпуска.НайтиСтроки(Новый Структура("ДатаНачала", Выборка.ДатаНачала));
		Если СтрокиОтпусков.Количество() > 0 Тогда
			ЗаполняемаяСтрока = СтрокиОтпусков[0];
			ЗаполнитьЗначенияСвойств(ЗаполняемаяСтрока, Выборка, , "ДатаНачала");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Отпуск не оформлен.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Оформить отпуск';
																					|en = 'Register leave'"));
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтпускаОтпуск");	
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отпуска.Отпуск");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДоступноОформлениеОтпусков");
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	// Отпуск не рассчитан.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отпуск предоставлен';
																					|en = 'Leave is granted'"));
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтпускаОтпуск");	
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отпуска.Проведен");
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отпуска.Рассчитан");
	ЭлементОтбора.ПравоеЗначение = Ложь;
	
	// Отпуск проведен и рассчитан.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отпуск предоставлен, начисления выполнены';
																					|en = 'Leave is granted, accruals are performed'"));
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтпускаОтпуск");	
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отпуска.Отпуск");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отпуска.Рассчитан");
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	// Отпуск не проведен.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отпуск не проведен';
																					|en = 'Leave is not posted'"));
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтпускаОтпуск");	
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отпуска.Отпуск");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отпуска.Проведен");
	ЭлементОтбора.ПравоеЗначение = Ложь;
	
	// Отпуск не оформлен, оформление недоступно.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отпуск не предоставлялся';
																					|en = 'Leave is not granted'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтпускаОтпуск");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отпуска.Отпуск");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДоступноОформлениеОтпусков");
	ЭлементОтбора.ПравоеЗначение = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьТекущийОтпуск(ИдентификаторСтроки)
	
	ТекущиеДанные = Отпуска.НайтиПоИдентификатору(ИдентификаторСтроки);
	ДополнительныеПараметры = Новый Структура("ПерезаполнитьНачисления", Ложь);
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Отпуск) Тогда
		ДополнительныеПараметры.ПерезаполнитьНачисления = Истина;
		Оповещение = Новый ОписаниеОповещения("ОбработатьТекущийОтпускЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДобавитьОтпускКДокументу(Оповещение);
	Иначе 
		ОбработатьТекущийОтпускЗавершение(ТекущиеДанные, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьТекущийОтпускЗавершение(ТекущиеДанные, ДополнительныеПараметры) Экспорт 
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Отпуск) Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.Отпуск);
		ПараметрыОткрытия.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		ПараметрыОткрытия.Вставить("ПерезаполнитьНачисления", ДополнительныеПараметры.ПерезаполнитьНачисления);
		
		ОткрытьФорму("Документ.Отпуск.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОтпускКДокументу(ОповещениеЗавершения = Неопределено)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.Отпуска.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Отпуск) Тогда
		ПараметрыЗаполненияСтроки = ПараметрыЗаполненияОтпуска(Элементы.Отпуска.ТекущаяСтрока);
		Если ПараметрыЗаполненияСтроки.Количество() > 0 Тогда
			РезультатЗаполнения = РасчетныйДокументПоПараметрыЗаполнения(Сотрудник, ПараметрыЗаполненияСтроки[0]);
			Если РезультатЗаполнения.Отпуск <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ТекущиеДанные, РезультатЗаполнения);
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыЗаполненияОтпуска(ИдентификаторСтрокиСотрудника)
	
	ПараметрыЗаполненияДокументов = Новый Массив;
	
	// Формирование массива обрабатываемых строк.
	СтрокаСотрудника = Отпуска.НайтиПоИдентификатору(ИдентификаторСтрокиСотрудника);
	Если СтрокаСотрудника = Неопределено Тогда
		Возврат ПараметрыЗаполненияДокументов;
	КонецЕсли; 
	
	ДанныеСотрудника = Новый Структура("Сотрудник,Организация,ДатаНачала,ДатаОкончания");
	ЗаполнитьЗначенияСвойств(ДанныеСотрудника, ЭтаФорма, "Сотрудник,Организация");
	ЗаполнитьЗначенияСвойств(ДанныеСотрудника, СтрокаСотрудника, "ДатаНачала,ДатаОкончания");
	
	ПараметрыЗаполненияДокументов = Документы.ГрафикОтпусков.ПараметрыЗаполненияОтпуска(ГрафикОтпусков, ДанныеСотрудника);
	
	Возврат ПараметрыЗаполненияДокументов;
	
КонецФункции

&НаСервере
Функция РасчетныйДокументПоПараметрыЗаполнения(Сотрудник, ПараметрыЗаполнения)
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗаполнения = Документы.ГрафикОтпусков.РасчетныйДокументПоПараметрыЗаполнения(Сотрудник, ПараметрыЗаполнения);
	ЗаполнитьСвязанныеДокументы();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗаполнения;
	
КонецФункции

#КонецОбласти
