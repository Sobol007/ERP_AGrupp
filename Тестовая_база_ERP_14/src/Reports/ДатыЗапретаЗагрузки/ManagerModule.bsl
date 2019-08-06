///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	НастройкиОтчета.Включен = Ложь;
	
	ПервыйВариант = ПервыйВариант();
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ПервыйВариант.Имя);
	НастройкиВарианта.Включен  = Истина;
	НастройкиВарианта.Описание = ПервыйВариант.Описание;
	
	ВторойВариант = ВторойВариант();
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ВторойВариант.Имя);
	НастройкиВарианта.Включен  = Истина;
	НастройкиВарианта.Описание = ВторойВариант.Описание;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "Форма" Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = "ФормаОтчета";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается из форма отчета.
Процедура УстановитьВариант(Форма, Вариант) Экспорт
	
	ПервыйВариант = ПервыйВариант();
	ВторойВариант = ВторойВариант();
	
	Отчеты.ДатыЗапретаИзменения.НастроитьФорму(Форма, ПервыйВариант, ВторойВариант, Вариант);
	
КонецПроцедуры

Функция ПервыйВариант()
	
	Попытка
		Свойства = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
	Исключение
		Свойства = Новый Структура("ПоказыватьРазделы, ВсеРазделыБезОбъектов", Ложь, Истина);
	КонецПопытки;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоИнформационнымБазам";
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоИнформационнымБазамБезОбъектов";
	Иначе
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоИнформационнымБазамБезРазделов";
	КонецЕсли;
	
	СвойстваВарианта = Новый Структура;
	СвойстваВарианта.Вставить("Имя", ИмяВарианта);
	
	СвойстваВарианта.Вставить("Заголовок",
		НСтр("ru = 'Даты запрета загрузки данных по информационным базам';
			|en = 'Closing date of data import by infobases'"));
	
	СвойстваВарианта.Вставить("Описание",
		НСтр("ru = 'Выводит даты запрета загрузки для объектов, сгруппированные по информационным базам.';
			|en = 'Displays import closing dates for objects grouped by infobases.  '"));
	
	Возврат СвойстваВарианта;
	
КонецФункции

Функция ВторойВариант()
	
	Попытка
		Свойства = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
	Исключение
		Свойства = Новый Структура("ПоказыватьРазделы, ВсеРазделыБезОбъектов", Ложь, Истина);
	КонецПопытки;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоРазделамОбъектамДляИнформационныхБаз";
		Заголовок = НСтр("ru = 'Даты запрета загрузки данных по разделам и объектам';
						|en = 'Closing date of data import by sections and objects'");
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета загрузки, сгруппированные по разделам с объектами.';
				|en = 'Displays import closing dates grouped by sections with objects.  '");
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоРазделамДляИнформационныхБаз";
		Заголовок = НСтр("ru = 'Даты запрета загрузки данных по разделам';
						|en = 'Closing date of data import by sections'");
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета загрузки, сгруппированные по разделам.';
				|en = 'Displays import closing dates grouped by sections.  '");
	Иначе
		ИмяВарианта = "ДатыЗапретаЗагрузкиПоОбъектамДляИнформационныхБаз";
		Заголовок = НСтр("ru = 'Даты запрета загрузки данных по объектам';
						|en = 'Closing date of data import by objects'");
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета загрузки, сгруппированные по объектам.';
				|en = 'Displays import closing dates grouped by objects.  '");
	КонецЕсли;
	
	СвойстваВарианта = Новый Структура;
	СвойстваВарианта.Вставить("Имя",       ИмяВарианта);
	СвойстваВарианта.Вставить("Заголовок", Заголовок);
	СвойстваВарианта.Вставить("Описание",  ОписаниеВарианта);
	
	Возврат СвойстваВарианта;
	
КонецФункции

#КонецОбласти

#КонецЕсли
