#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату < '20070101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия300;
	ИначеЕсли НаДату < '20090101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия400;
	Иначе
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу Министерства финансов Российской Федерации от 16.09.2008 № 95н.";
	НоваяФорма.РедакцияФормы      = "от 16.09.2008 № 95н.";
	НоваяФорма.ДатаНачалоДействия = '2009-01-01';
	НоваяФорма.ДатаКонецДействия  = '2010-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 28.10.2011 № ММВ-7-11/696@.";
	НоваяФорма.РедакцияФормы      = "от 28.10.2011 № ММВ-7-11/696@.";
	НоваяФорма.ДатаНачалоДействия = '2011-01-01';
	НоваяФорма.ДатаКонецДействия  = '2012-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 28.10.2011 № ММВ-7-11/696@ (в ред. приказа ФНС России от 14.11.2013 № ММВ-7-3/501@).";
	НоваяФорма.РедакцияФормы      = "от 14.11.2013 № ММВ-7-3/501@.";
	НоваяФорма.ДатаНачалоДействия = '2013-01-01';
	НоваяФорма.ДатаКонецДействия  = '2013-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 28.10.2011 № ММВ-7-11/696@ (в ред. приказа ФНС России от 14.11.2013 № ММВ-7-3/501@).";
	НоваяФорма.РедакцияФормы      = "от 14.11.2013 № ММВ-7-3/501@.";
	НоваяФорма.ДатаНачалоДействия = '2014-01-01';
	НоваяФорма.ДатаКонецДействия  = '2016-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 10.05.2017 № ММВ-7-21/347@.";
	НоваяФорма.РедакцияФормы      = "от 10.05.2017 № ММВ-7-21/347@.";
	НоваяФорма.ДатаНачалоДействия = '2017-01-01';
	НоваяФорма.ДатаКонецДействия  = '2017-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 10.05.2017 № ММВ-7-21/347@ (в ред. приказа ФНС России от 02.03.2018 № ММВ-7-21/118@).";
	НоваяФорма.РедакцияФормы      = "от 02.03.2018 № ММВ-7-21/118@.";
	НоваяФорма.ДатаНачалоДействия = '2018-01-01';
	НоваяФорма.ДатаКонецДействия  = '2018-11-21';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв3";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 10.05.2017 № ММВ-7-21/347@ (в ред. приказа ФНС России от 30.08.2018 № ММВ-7-21/509@).";
	НоваяФорма.РедакцияФормы      = "от 30.08.2018 № ММВ-7-21/509@.";
	НоваяФорма.ДатаНачалоДействия = '2018-01-01';
	НоваяФорма.ДатаКонецДействия  = '2019-12-31';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2018Кв3"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2018Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2017Кв4" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		Если ДанныеРеглОтчета.Свойство("ДанныеМногоуровневыхРазделов") Тогда
			
			ДанныеМногострочнойЧастиРаздела1
			= ДанныеРеглОтчета.ДанныеМногоуровневыхРазделов["Раздел1"].Строки[0].ДанныеМногострочныхЧастей["П0000100"];
			
			Для каждого СтрокаМнЧ Из ДанныеМногострочнойЧастиРаздела1.Строки Цикл
				
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.Период = ЭкземплярРеглОтчета.ДатаОкончания;
				Сумма.КБК   = СтрокаМнЧ.Данные.П000010001003;
				Сумма.ОКАТО = СтрокаМнЧ.Данные.П000010002003;
				Сумма.Сумма = СтрокаМнЧ.Данные.П000010003003;
				
			КонецЦикла;
			
		КонецЕсли;
		
	ИначеЕсли ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2011Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2013Кв4"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2014Кв4" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел 1 (многостраничный)
		// На странице - два комплекта строк (с одинаковыми номерами)
		// 010 - КБК
		// 020 - ОКАТО
		// 030 - сумма
		
		ИмяКБК   = "П000010001003"; // 010
		ИмяОКАТО = "П000010002003"; // 020
		ИмяСумма = "П000010003003"; // 030
		
		Если ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Свойство("Раздел1") Тогда
			
			Раздел1 = ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Раздел1;
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			
			Для Каждого Страница Из Раздел1 Цикл
				
				Данные = Страница.Данные;
				
				Для НомерКомплекта = 1 По 2 Цикл
					
					ПостфиксКомплекта = "_" + НомерКомплекта;
					
					Сумма = ТаблицаДанныхРеглОтчета.Добавить();
					Сумма.Период = Период;
					Сумма.КБК    = Данные[ИмяКБК   + ПостфиксКомплекта];
					Сумма.ОКАТО  = Данные[ИмяОКАТО + ПостфиксКомплекта];
					Сумма.Сумма  = Данные[ИмяСумма + ПостфиксКомплекта];
					
				КонецЦикла;
				
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
	
	Форма20090101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1153005", '2008-09-16', "95н", "ФормаОтчета2009Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20090101, "5.01");
	
	Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1153005", '2011-10-28', "ММВ-7-11/696@", "ФормаОтчета2011Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20110101, "5.02");
	
	Форма2013Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1153005", '2013-11-14', "ММВ-7-3/501@", "ФормаОтчета2013Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2013Кв4, "5.03");
	
	Форма2014Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1153005", '2013-11-14', "ММВ-7-3/501@", "ФормаОтчета2014Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2014Кв4, "5.03");
	
	Форма2017Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1153005", '2017-05-10', "ММВ-7-21/347@", "ФормаОтчета2017Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2017Кв4, "5.04");
	
	Форма2018Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1153005", '2018-03-02', "ММВ-7-21/118@", "ФормаОтчета2018Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма2018Кв1, "5.05");
	
	Форма2018Кв3 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1153005", '2018-08-30', "ММВ-7-21/509@", "ФормаОтчета2018Кв3");
	ОпределитьФорматВДеревеФормИФорматов(Форма2018Кв3, "5.06");
	
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