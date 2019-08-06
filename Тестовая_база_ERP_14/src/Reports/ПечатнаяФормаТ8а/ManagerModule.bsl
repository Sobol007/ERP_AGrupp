#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Т8а");
	НастройкиВарианта.Описание = НСтр("ru = 'Унифицированная форма № Т-8а';
										|en = 'Unified form No. T-8a'");
	НастройкиВарианта.Включен = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ЗарплатаКадрыОтчеты.ВывестиВКоллекциюПечатнуюФорму("Отчет.ПечатнаяФормаТ8а",
		МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

Процедура Сформировать(ДокументРезультат, РезультатКомпоновки, ОбъектыПечати = Неопределено) Экспорт
	
	ДокументРезультат.КлючПараметровПечати = "ПараметрыПечати_Т8а";
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	Для Каждого ДанныеСсылок Из РезультатКомпоновки.ДанныеОтчета.Строки Цикл
		
		Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПерваяСтрокаПечатнойФормы = ДокументРезультат.ВысотаТаблицы + 1;
		
		ДанныеПользовательскихПолейСсылки = ЗарплатаКадрыОтчеты.ЗначенияЗаполненияПользовательскихПолей(РезультатКомпоновки.ИдентификаторыМакета, ДанныеСсылок);
		
		ЗарплатаКадрыОтчеты.ВывестиВДокументРезультатОбластиМакета(
			ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, "Шапка",
			ДанныеСсылок,
			ДанныеПользовательскихПолейСсылки);
		
		ОбластьШапкиТаблицы = РезультатКомпоновки.МакетПечатнойФормы.ПолучитьОбласть("ШапкаТаблицы");
		ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыОбластиМакета(ОбластьШапкиТаблицы,
			ДанныеСсылок,
			ДанныеПользовательскихПолейСсылки);
		
		ДокументРезультат.Вывести(ОбластьШапкиТаблицы);
		
		ОбластьПодвал = РезультатКомпоновки.МакетПечатнойФормы.ПолучитьОбласть("Подвал");
		ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыОбластиМакета(ОбластьПодвал,
			ДанныеСсылок,
			ДанныеПользовательскихПолейСсылки);
		
		Для Каждого ДанныеДетальныхЗаписей Из ДанныеСсылок.Строки Цикл
			
			ДанныеПользовательскихПолей = ЗарплатаКадрыОтчеты.ЗначенияЗаполненияПользовательскихПолей(РезультатКомпоновки.ИдентификаторыМакета, ДанныеДетальныхЗаписей);
			
			ОбластьСтроки = РезультатКомпоновки.МакетПечатнойФормы.ПолучитьОбласть("Строка");
			ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыОбластиМакета(ОбластьСтроки,
				ДанныеСсылок,
				ДанныеДетальныхЗаписей,
				ДанныеПользовательскихПолей);
			
			СписокУмещаемыхОбластей = Новый Массив;
			СписокУмещаемыхОбластей.Добавить(ОбластьСтроки);
			СписокУмещаемыхОбластей.Добавить(ОбластьПодвал);
			
			Если НЕ ДокументРезультат.ПроверитьВывод(СписокУмещаемыхОбластей) Тогда
				
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОбластьШапкиТаблицы);
				
			КонецЕсли;
			
			ДокументРезультат.Вывести(ОбластьСтроки);
			
		КонецЦикла;
		
		ДокументРезультат.Вывести(ОбластьПодвал);
		
		Если ОбъектыПечати <> Неопределено Тогда
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, ПерваяСтрокаПечатнойФормы, ОбъектыПечати, ДанныеСсылок.СсылкаНаОбъект);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли