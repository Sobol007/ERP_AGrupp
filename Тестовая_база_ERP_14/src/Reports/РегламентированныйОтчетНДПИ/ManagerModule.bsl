#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату > '20110401' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	ИначеЕсли НаДату > '20050101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия300;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв2";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 07.04.2011 № MMB-7-3/253@.";
	НоваяФорма.РедакцияФормы      = "от 07.04.2011 № MMB-7-3/253@.";
	НоваяФорма.ДатаНачалоДействия = '2011-04-01';
	НоваяФорма.ДатаКонецДействия  = '2012-02-29';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 16.12.2011 № ММВ-7-3/928@.";
	НоваяФорма.РедакцияФормы      = "от 16.12.2011 № ММВ-7-3/928@.";
	НоваяФорма.ДатаНачалоДействия = '2012-01-01';
	НоваяФорма.ДатаКонецДействия  = '2013-11-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 16.12.2011 № ММВ-7-3/928@ (в ред. приказа ФНС России от 14.11.2013 № ММВ-7-3/501@).";
	НоваяФорма.РедакцияФормы      = "от 14.11.2013 № ММВ-7-3/501@.";
	НоваяФорма.ДатаНачалоДействия = '2013-12-01';
	НоваяФорма.ДатаКонецДействия  = '2015-05-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв2";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 14.05.2015 № ММВ-7-3/197@.";
	НоваяФорма.РедакцияФормы      = "от 14.05.2015 № ММВ-7-3/197@.";
	НоваяФорма.ДатаНачалоДействия = '2015-05-01';
	НоваяФорма.ДатаКонецДействия  = '2019-02-28';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1_Р";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 4 к письму ФНС России от 29.12.2018 № СД-4-3/24833@.";
	НоваяФорма.РедакцияФормы      = "от 29.12.2018 № СД-4-3/24833@.";
	НоваяФорма.ДатаНачалоДействия = '2019-01-01';
	НоваяФорма.ДатаКонецДействия  = '2019-02-28';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 20.12.2018 № ММВ-7-3/827@.";
	НоваяФорма.РедакцияФормы      = "от 20.12.2018 № ММВ-7-3/827@.";
	НоваяФорма.ДатаНачалоДействия = '2019-03-01';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2019Кв1"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2019Кв1_Р"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2015Кв2"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2013Кв4"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2012Кв1"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2011Кв2" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел 1 (многострочный)
		// 010 - КБК
		// 020 - ОКАТО
		// 030 - сумма
		
		Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2019Кв1"
			ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2019Кв1_Р"
			ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2015Кв2" Тогда
			ИмяМногострочногоРаздела = "П0001000001";
		Иначе
			ИмяМногострочногоРаздела = "П0001000010";
		КонецЕсли;
		
		ИмяКБК   = ИмяМногострочногоРаздела + "01";
		ИмяОКАТО = ИмяМногострочногоРаздела + "02";
		ИмяСумма = ИмяМногострочногоРаздела + "03";

		Если ДанныеРеглОтчета.ДанныеМногоСтрочныхРазделов.Свойство(ИмяМногострочногоРаздела) Тогда
			
			Раздел1 = ДанныеРеглОтчета.ДанныеМногоСтрочныхРазделов[ИмяМногострочногоРаздела];
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			
			Для Каждого СтрокаРаздела Из Раздел1 Цикл
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.Период = Период;
				Сумма.КБК    = СтрокаРаздела[ИмяКБК];
				Сумма.ОКАТО  = СтрокаРаздела[ИмяОКАТО];
				Сумма.Сумма  = СтрокаРаздела[ИмяСумма];
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаДанныхРеглОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20110401 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,  "1151054", '2011-04-07', "MMB-7-3/253@",  "ФормаОтчета2011Кв2");
	ОпределитьФорматВДеревеФормИФорматов(Форма20110401, "5.01");
	
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,  "1151054", '2011-12-16', "ММВ-7-3/928@",  "ФормаОтчета2012Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20120101, "5.02");
	
	Форма2013Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,   "1151054", '2013-11-14', "ММВ-7-3/501@",  "ФормаОтчета2013Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2013Кв4, "5.03");
	
	Форма2015Кв2 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,   "1151054", '2015-05-14', "ММВ-7-3/197@",  "ФормаОтчета2015Кв2");
	ОпределитьФорматВДеревеФормИФорматов(Форма2015Кв2, "5.04");
	
	Форма2019Кв1_Р = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151054", '2018-12-29', "СД-4-3/24833@", "ФормаОтчета2019Кв1_Р");
	ОпределитьФорматВДеревеФормИФорматов(Форма2019Кв1_Р, "5.05");
	
	Форма2019Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,   "1151054", '2018-12-20', "ММВ-7-3/827@",  "ФормаОтчета2019Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма2019Кв1, "5.06");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли