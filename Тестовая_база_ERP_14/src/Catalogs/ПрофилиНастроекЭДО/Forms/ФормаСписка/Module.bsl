
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаГруппаПодключиться.Видимость   = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД");
	Элементы.ФормаГруппаПодключиться.Доступность = ПравоДоступа("Добавление", Метаданные.Справочники.ПрофилиНастроекЭДО);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого СтрокаТаблицы Из Строки Цикл
		НачальныйНомер = СтрНайти(СтрокаТаблицы.Значение.Данные.Наименование, ",");
		СтрокаТаблицы.Значение.Данные.СпособОбменаПредставление = 
			Сред(СтрокаТаблицы.Значение.Данные.Наименование, НачальныйНомер + 1);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКСервису1СЭДО(Команда)
	
	ОбменСКонтрагентамиКлиент.ПомощникПодключенияКСервису1СЭДО();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКСервису1СТакском(Команда)
	
	ОбменСКонтрагентамиКлиент.ПомощникПодключенияКСервису1СТакском();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКПрямомуОбмену(Команда)
	
	ОбменСКонтрагентамиКлиент.ПомощникПодключенияКПрямомуОбмену();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	
КонецПроцедуры

#КонецОбласти

