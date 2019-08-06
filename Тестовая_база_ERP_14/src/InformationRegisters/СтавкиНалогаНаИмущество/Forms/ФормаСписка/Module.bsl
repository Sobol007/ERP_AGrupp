
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СтавкиНалогаНаИмущество" Тогда
		УправлениеВидимостью();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	#Область КодНалоговойЛьготыОсвобождениеОтНалогообложения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КодНалоговойЛьготыОсвобождениеОтНалогообложения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ОсвобождениеОтНалогообложения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Нет льгот';
																|en = 'No benefits'"));
	#КонецОбласти
	
	#Область ПроцентУменьшения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентУменьшения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.УменьшениеСуммыНалогаВПроцентах");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '-';
																|en = '-'"));
	#КонецОбласти
	
	#Область НалоговаяСтавкаДвижимоеИмущество_До2018
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НалоговаяСтавкаДвижимоеИмущество.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Период");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = '201801010000';
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<совпадает с общей ставкой>';
																|en = '<matches the general rate>'"));
	#КонецОбласти
	
	#Область НалоговаяСтавкаДвижимоеИмущество_С2019
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НалоговаяСтавкаДвижимоеИмущество.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Период");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = '201901010000';
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не используется>';
																|en = '<not used>'"));
	#КонецОбласти
	
	#Область ОсвобождениеОтНалогообложенияДвижимогоИмущества_До2018
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОсвобождениеОтНалогообложенияДвижимогоИмущества.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Период");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = '201801010000';
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Да';
																|en = 'Yes'"));
	#КонецОбласти
	
	#Область ОсвобождениеОтНалогообложенияДвижимогоИмущества_С2019
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОсвобождениеОтНалогообложенияДвижимогоИмущества.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Период");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = '201901010000';
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не используется>';
																|en = '<not used>'"));
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	РегистрСведений.СтавкиНалогаНаИмущество КАК СтавкиНалогаНаИмущество
	|ГДЕ
	|	СтавкиНалогаНаИмущество.Период < ДАТАВРЕМЯ(2019, 1, 1)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Результат = Запрос.Выполнить();
	ЕстьЗаписиДо2019 = НЕ Результат.Пустой();
	Элементы.НалоговаяСтавкаДвижимоеИмущество.Видимость = ЕстьЗаписиДо2019;
	Элементы.ОсвобождениеОтНалогообложенияДвижимогоИмущества.Видимость = ЕстьЗаписиДо2019;

КонецПроцедуры
 
#КонецОбласти
