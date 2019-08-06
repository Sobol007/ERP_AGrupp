///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресныйОбъект = Параметры.Идентификатор;
	
	Если СтрСравнить(Параметры.ТипДома, РаботаСАдресамиКлиентСервер.НаименованиеЗемельногоУчастка()) <> 0 Тогда
		ТипВыбора = "СписокДомов";
	Иначе
		ТипВыбора = "ЗемельныеУчастки";
		Заголовок = НСтр("ru = 'Выбрать земельный участок';
						|en = 'Select a land lot'");
		Элементы.Найти.Подсказка = НСтр("ru = 'Поиск по номеру земельного участка';
										|en = 'Search by a land lot number'");
		Элементы.Найти.ПодсказкаВвода = НСтр("ru = 'Номер земельного участка';
											|en = 'Land lot number'");
	КонецЕсли;
	
	ЗаполнитьСписок(?(Параметры.Отбор, Параметры.Номер, Неопределено));
	
	// позиционирование
	Отбор = Новый Структура("Дом", Параметры.Номер);
	Если ЗначениеЗаполнено(Параметры.ТипСтроения) Тогда
		Если ВРег(Параметры.ТипСтроения) = "КОРПУС" Тогда
			Отбор.Вставить("Корпус", Параметры.Строение);
			Отбор.Вставить("Строение", "");
		Иначе
			Отбор.Вставить("Строение", Параметры.Строение);
			Отбор.Вставить("Корпус", "");
		КонецЕсли;
	КонецЕсли;
	
	Строки = СписокАдресныхОбъектов.НайтиСтроки(Отбор);
	Если Строки.Количество() > 0 Тогда
		Элементы.СписокАдресныхОбъектов.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВыбрать", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НайтиОчистка(Элемент, СтандартнаяОбработка)
	СписокАдресныхОбъектов.Очистить();
	ЗаполнитьСписок(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура НомерДомаСтроенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ТекстПоиска = ?(ПустаяСтрока(Текст), Найти, Текст);
	ПодключитьОбработчикОжидания("НайтиИЗаполнитьСписокДомов", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДомовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Закрыть(Элементы.СписокАдресныхОбъектов.ТекущиеДанные.Значение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Если Элементы.СписокАдресныхОбъектов.ТекущиеДанные <> Неопределено Тогда
		Закрыть(Элементы.СписокАдресныхОбъектов.ТекущиеДанные.Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НайтиИЗаполнитьСписокДомов()
	ЗаполнитьСписок(ТекстПоиска + "%");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок(Текст)
	
	Если ТипВыбора = "СписокДомов" Тогда
		ЗаполнитьСписокДомов(Текст);
	Иначе
		ЗаполнитьСписокЗемельныхУчастков(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДомов(Текст)
	
	СписокАдресныхОбъектов.Очистить();
	СтрокаПоиска = ?(ЗначениеЗаполнено(Текст), Текст, "");
	ПорцияПриПоиске = 2000;
	ПолныйСписокДомов = Обработки.РасширенныйВводКонтактнойИнформации.СписокДомов(АдресныйОбъект, СтрокаПоиска, ПорцияПриПоиске);
	Если ПолныйСписокДомов = Неопределено ИЛИ ПолныйСписокДомов.Количество() = 0 Тогда
		Элементы.ФормаВыбрать.Доступность = Ложь;
	Иначе
		СписокАдресныхОбъектов.Загрузить(ПолныйСписокДомов);
		Элементы.ФормаВыбрать.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЗемельныхУчастков(Текст)
	
	СписокАдресныхОбъектов.Очистить();
	СтрокаПоиска = ?(ЗначениеЗаполнено(Текст), Текст, "");
	ПорцияПриПоиске = 2000;
	ЗемельныеУчастки = Обработки.РасширенныйВводКонтактнойИнформации.СписокЗемельныхУчастков(АдресныйОбъект, СтрокаПоиска, ПорцияПриПоиске);
	Если ЗемельныеУчастки = Неопределено ИЛИ ЗемельныеУчастки.Количество() = 0 Тогда
		Элементы.ФормаВыбрать.Доступность = Ложь;
	Иначе
		
		СписокАдресныхОбъектов.Загрузить(ЗемельныеУчастки);
		Элементы.ФормаВыбрать.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

