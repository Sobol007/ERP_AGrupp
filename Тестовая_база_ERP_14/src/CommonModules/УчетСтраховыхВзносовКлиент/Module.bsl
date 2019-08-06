
#Область СлужебныйПрограммныйИнтерфейс

// Для переданного описания ячейки рег.отчета выбирает подходящий отчет-расшифровку,
// настраивает соотв. вариант и получает подготовленную к показу форму отчета.
// Параметры:
//	ИДОтчета - Строка - идентификатор отчета (совпадает с именем объекта метаданных).
// 	ИДРедакцииОтчета - Строка - идентификатор редакции формы отчета (совпадает с именем формы объекта метаданных).
//  ИДИменПоказателей - Массив - массив идентификаторов имен показателей, по которым формируется расшифровка.
//  ПараметрыОтчета - Структура - структура параметров отчета, необходимых для формирования расшифровки.
// 
Функция ФормаРасшифровкиРегламентированногоОтчета(ИДОтчета, ИДРедакцииОтчета, ИДИменПоказателей, ПараметрыОтчета) Экспорт
	
	Если Не ЗначениеЗаполнено(ИДИменПоказателей) Тогда
		Возврат Неопределено
	КонецЕсли;
	
	ИмяПоказателя = ИДИменПоказателей[0];
	ИмяНабораДанных = "";
	ИмяОтчетаРасшифровки = "";
	ИмяРасчета = "";
	
	Если ИДОтчета = "РегламентированныйОтчет4ФСС" Тогда
		Год = Число(Лев(СтрЗаменить(ИДРедакцииОтчета, "ФормаОтчета", ""), 4));
		Если Год = 2013 Или Год = 2014 Тогда
			ИмяОтчетаРасшифровки = "Расшифровка4ФСС";
			ИмяРасчета = "РасчетПоказателей_4ФСС_2012Кв1";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчета4ФССЗа2013Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		ИначеЕсли Год = 2015 Тогда	
			ИмяОтчетаРасшифровки = "Расшифровка4ФСС";
			ИмяРасчета = "РасчетПоказателей_4ФСС_2015Кв1";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчета4ФССЗа2015Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		ИначеЕсли Год = 2016 Тогда	
			ИмяОтчетаРасшифровки = "Расшифровка4ФСС";
			ИмяРасчета = "РасчетПоказателей_4ФСС_2016Кв1";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчета4ФССЗа2016Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		ИначеЕсли Год = 2017 Тогда	
			ИмяОтчетаРасшифровки = "Расшифровка4ФСС";
			ИмяРасчета = "РасчетПоказателей_4ФСС_2017Кв1";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчета4ФССЗа2017Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		КонецЕсли;
	ИначеЕсли ИДОтчета = "РегламентированныйОтчетРСВ1" Тогда
		Год = Число(Лев(СтрЗаменить(ИДРедакцииОтчета, "ФормаОтчета", ""), 4));
		Если Год = 2013 Тогда
			ИмяОтчетаРасшифровки = "РасшифровкаРСВ1";
			ИмяРасчета = "РасчетПоказателей_РСВ1_2013Кв1";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчетаРСВ1За2013Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		ИначеЕсли Год = 2014 Тогда	
			ИмяОтчетаРасшифровки = "РасшифровкаРСВ1";
			ИмяРасчета = "РасчетПоказателей_РСВ1_2014";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчетаРСВ1За2014Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		ИначеЕсли Год = 2015 Тогда	
			ИмяОтчетаРасшифровки = "РасшифровкаРСВ1";
			ИмяРасчета = "РасчетПоказателей_РСВ1_2015";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчетаРСВ1За2015Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		КонецЕсли;
	ИначеЕсли ИДОтчета = "РегламентированныйОтчетРасчетПоСтраховымВзносам" Тогда
		ИмяОтчетаРасшифровки = "РасшифровкаРСВ";
		ИмяРасчета = "РасчетПоказателей_РСВ_2017Кв1";
		ДополнитьПараметрыОтчетаРСВза2017год(ПараметрыОтчета, ИмяПоказателя);
		ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
	Иначе
		
	КонецЕсли;
	
	// Подготовка отчета-расшифровки к показу.
	Если ЗначениеЗаполнено(ИмяОтчетаРасшифровки) И ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИсточникРасшифровки","УчетСтраховыхВзносов");
		ПараметрыОтчета.Вставить("ИмяОтчетаРасшифровки",ИмяОтчетаРасшифровки);
		ПараметрыОтчета.Вставить("ИмяРасчета",ИмяРасчета);
		ПараметрыОтчета.Вставить("ИДИменПоказателей",ИДИменПоказателей);
		
		ФормаРасшифровки = ПолучитьФорму("ОбщаяФорма.РасшифровкаРегламентированногоОтчетаЗарплата", ПараметрыОтчета);
		Возврат ФормаРасшифровки
		
	КонецЕсли;
	
	Возврат Неопределено
	
КонецФункции

// Вызывается в обработчике события "ПриИзменении" поля - строкового представления 
// реквизита "ДатаПолученияДохода", таблицы "Взносы". 
//
// Параметры:
//	ДанныеТекущейСтроки - данные текущей строки таблицы "Взносы".
// 	ИмяПоляДатаПолученияДохода - имя реквизита содержащего дату получения дохода в таблице взносов.
// 	ИмяПоляПредставление - имя реквизита, содержащего строковое представление даты получения дохода.
//	Модифицированность - булево - признак модифицированности формы.
//
Процедура ВзносыДатаПолученияДоходаСтрокойПриИзменении(ДанныеТекущейСтроки, ИмяПоляДатаПолученияДохода, ИмяПоляПредставление, Модифицированность) Экспорт 
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ДанныеТекущейСтроки, ИмяПоляДатаПолученияДохода, ИмяПоляПредставление, Модифицированность);
	Если ЗначениеЗаполнено(ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода]) Тогда
		ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода] = УчетСтраховыхВзносовКлиентСервер.ДатаПолученияДохода(ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода]);
	КонецЕсли;	
КонецПроцедуры	

// Вызывается в обработчике события "НачалоВыбора" поля - строкового представления 
// реквизита "ДатаПолученияДохода", таблицы "Взносы". 
//
// Параметры:
//	Форма
//	ДанныеТекущейСтроки - данные текущей строки таблицы "Взносы".
// 	ИмяПоляДатаПолученияДохода - имя реквизита содержащего дату получения дохода в таблице взносов.
// 	ИмяПоляПредставление - имя реквизита, содержащего строковое представление даты получения дохода.
//
Процедура ВзносыДатаПолученияДоходаСтрокойНачалоВыбора(Форма, ДанныеТекущейСтроки, ИмяПоляДатаПолученияДохода, ИмяПоляПредставление) Экспорт 
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ДанныеТекущейСтроки", ДанныеТекущейСтроки);
	ПараметрыОповещения.Вставить("ИмяПоляДатаПолученияДохода", ИмяПоляДатаПолученияДохода);
	ПараметрыОповещения.Вставить("ИмяПоляПредставление", ИмяПоляПредставление);
	
	Оповещение = Новый ОписаниеОповещения("ВзносыДатаПолученияДоходаСтрокойНачалоВыбораЗавершение", ЭтотОбъект, ПараметрыОповещения);	
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		Форма, 
		ДанныеТекущейСтроки,                                                 
		ИмяПоляДатаПолученияДохода, 
		ИмяПоляПредставление, ,
		Оповещение);
		
КонецПроцедуры

// Вызывается в обработчике события "Регулирование" поля - строкового представления 
// реквизита "ДатаПолученияДохода", таблицы "Взносы".
//
// Параметры:
//  ДанныеТекущейСтроки - данные текущей строки таблицы "Взносы".
//  ИмяПоляДатаПолученияДохода - имя реквизита содержащего дату получения дохода в таблице взносов.
//  ИмяПоляПредставление - имя реквизита, содержащего строковое представление даты получения дохода.
//  Направление - параметр события "Регулирование".
//  Модифицированность - булево - признак модифицированности формы.
//
Процедура ВзносыДатаПолученияДоходаСтрокойРегулирование(ДанныеТекущейСтроки, ИмяПоляДатаПолученияДохода, ИмяПоляПредставление, Направление, Модифицированность) Экспорт 
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ДанныеТекущейСтроки, ИмяПоляДатаПолученияДохода, ИмяПоляПредставление, Направление, Модифицированность);
	Если ЗначениеЗаполнено(ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода]) Тогда
		ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода] = УчетСтраховыхВзносовКлиентСервер.ДатаПолученияДохода(ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода]);
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

Процедура ДополнитьПараметрыОтчетаРСВза2017год(ПараметрыОтчета, ИмяПоказателя)

	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	
	Если ВРег(Лев(ИмяПоказателя,1)) <> "П" Или СтрДлина(ИмяПоказателя) < 13 Тогда
		Возврат 
	КонецЕсли;	
	Раздел = Сред(ИмяПоказателя, 4, 3);
	
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ОписаниеРаздела = "";
	Если Раздел = "111" Тогда
		ОписаниеРаздела = "Подраздел 1.1";
		Если НомерКолонки = "02" Тогда
		ИначеЕсли НомерСтроки = "061" Или НомерСтроки = "062" Тогда
			ИмяНабораДанных = "Подразделы12Взносы2017"
		ИначеЕсли НомерСтроки = "030" Или НомерСтроки = "040" Или НомерСтроки = "051" Тогда
			ИмяНабораДанных = "Подразделы12Доходы2017"
		КонецЕсли;
	ИначеЕсли Раздел = "112" Тогда	
		ОписаниеРаздела = "Подраздел 1.2";
		Если НомерКолонки = "02" Тогда
		ИначеЕсли НомерСтроки = "060" Тогда
			ИмяНабораДанных = "Подразделы12Взносы2017"
		ИначеЕсли НомерСтроки = "030" Или НомерСтроки = "040" Тогда
			ИмяНабораДанных = "Подразделы12Доходы2017"
		КонецЕсли;
	ИначеЕсли Раздел = "131" Тогда	
		ОписаниеРаздела = "Подраздел 1.3.1";
		Если НомерКолонки = "02" Тогда
		ИначеЕсли НомерСтроки = "050" Тогда
			ИмяНабораДанных = "Подраздел31Взносы2017"
		ИначеЕсли НомерСтроки = "020" Или НомерСтроки = "030" Тогда
			ИмяНабораДанных = "Подраздел31Доходы2017"
		КонецЕсли;
	ИначеЕсли Раздел = "132" Тогда	
		ОписаниеРаздела = "Подраздел 1.3.2";
		Если НомерКолонки = "02" Тогда
		ИначеЕсли НомерСтроки = "050" Тогда
			ИмяНабораДанных = "Подраздел32Взносы2017"
		ИначеЕсли НомерСтроки = "020" Или НомерСтроки = "030" Тогда
			ИмяНабораДанных = "Подраздел32Доходы2017"
		КонецЕсли;
	ИначеЕсли Раздел = "114" Тогда	
		ОписаниеРаздела = "Подраздел 1.4";
		Если НомерКолонки = "02" Тогда
		ИначеЕсли НомерСтроки = "050" Тогда
			ИмяНабораДанных = "Подраздел4Взносы2017"
		ИначеЕсли НомерСтроки = "020" Или НомерСтроки = "030" Тогда
			ИмяНабораДанных = "Подраздел4Доходы2017"
		КонецЕсли;
	ИначеЕсли Раздел = "012" Тогда	
		ОписаниеРаздела = "Приложение 2";
		Если ИмяПоказателя = "П000120000101" Или НомерКолонки = "02" Или НомерСтроки = "010" Или НомерСтроки = "050" Или НомерСтроки = "070" Или НомерСтроки = "080" Или НомерСтроки = "090" Тогда
		Иначе
			ИмяНабораДанных = "ДоходыФСС2017"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
			
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1, строка %2, графа %3';
				|en = '%1, line %2, column %3'"),
			ОписаниеРаздела,
			НомерСтроки,
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
		
		ЗаголовокПоля = "";
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля", ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчетаРСВ1За2013Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "21" Тогда
		НомерПодраздела = Лев(НомерСтроки, 2);
		Если НомерСтроки = "250" Или НомерСтроки = "251" Или НомерСтроки = "276" Тогда
			ИмяНабораДанных = "Раздел21Взносы2013"
		ИначеЕсли НомерСтроки = "252" Или НомерПодраздела = "27" Или НомерПодраздела = "20" Или НомерПодраздела = "21" Или НомерПодраздела = "22" Или НомерПодраздела = "23" Тогда
			ИмяНабораДанных = "Раздел21Доходы2013"
		КонецЕсли;
	ИначеЕсли Раздел = "22" Тогда	
		Если НомерСтроки = "284" Тогда
			ИмяНабораДанных = "Раздел22Взносы2013"
		ИначеЕсли НомерСтроки <> "283" И НомерСтроки <> "285" Тогда
			ИмяНабораДанных = "Раздел22Доходы2013"
		КонецЕсли;
	ИначеЕсли Раздел = "23" Тогда	
		Если НомерСтроки = "294" Тогда
			ИмяНабораДанных = "Раздел22Взносы2013"
		ИначеЕсли НомерСтроки <> "293" И НомерСтроки <> "295" Тогда
			ИмяНабораДанных = "Раздел22Доходы2013"
		КонецЕсли;
	ИначеЕсли Раздел = "31" Тогда	
		Если НомерКолонки = "05" Или НомерКолонки = "06" Или НомерКолонки = "07" Или НомерКолонки = "08" Тогда
			ИмяНабораДанных = "Раздел312013"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
			
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Разд. %1, строка %2, графа %3';
				|en = 'Sect. %1, line %2, column %3'"),
			Формат(Раздел / 10, "ЧРД=."),
			Формат(Число(НомерСтроки), "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ЗаголовокПоля = "";
		Если Раздел = "21" Тогда
			Если НомерСтроки = "250" Или НомерСтроки = "251" Или НомерСтроки = "276" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		ИначеЕсли Раздел = "22" Тогда	
			Если НомерСтроки = "284" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		ИначеЕсли Раздел = "23" Тогда	
			Если НомерСтроки = "294" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля", ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчетаРСВ1За2014Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "21" Тогда
		Если ИмяПоказателя = "П000210001001" Тогда
			Возврат
		КонецЕсли;
		Если НомерСтроки = "205" Или НомерСтроки = "215" Тогда
			ИмяНабораДанных = "Раздел21Взносы2014"
		ИначеЕсли НомерСтроки <> "204" И НомерСтроки <> "206" И НомерСтроки <> "207" И НомерСтроки <> "208" И НомерСтроки <> "214" Тогда
			ИмяНабораДанных = "Раздел21Доходы2014"
		КонецЕсли;
	ИначеЕсли Раздел = "22" Тогда	
		Если НомерСтроки = "224" Тогда
			ИмяНабораДанных = "Раздел22Взносы2014"
		ИначеЕсли НомерСтроки <> "223" И НомерСтроки <> "225" Тогда
			ИмяНабораДанных = "Раздел22Доходы2014"
		КонецЕсли;
	ИначеЕсли Раздел = "23" Тогда	
		Если НомерСтроки = "234" Тогда
			ИмяНабораДанных = "Раздел22Взносы2014"
		ИначеЕсли НомерСтроки <> "233" И НомерСтроки <> "235" Тогда
			ИмяНабораДанных = "Раздел22Доходы2014"
		КонецЕсли;
	ИначеЕсли Раздел = "24" Тогда	
		Если НомерСтроки = "244" Или НомерСтроки = "250" Или НомерСтроки = "256" Или НомерСтроки = "262" Или НомерСтроки = "268" Тогда
			ИмяНабораДанных = "Раздел24Взносы2014"
		ИначеЕсли НомерСтроки <> "010" И НомерСтроки <> "020" И НомерСтроки <> "243" И НомерСтроки <> "245" И НомерСтроки <> "249" И НомерСтроки <> "251" И НомерСтроки <> "255" И НомерСтроки <> "257" И НомерСтроки <> "261" И НомерСтроки <> "263" И НомерСтроки <> "267" И НомерСтроки <> "269" Тогда
			ИмяНабораДанных = "Раздел24Доходы2014"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
			
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Разд. %1, строка %2, графа %3';
				|en = 'Sect. %1, line %2, column %3'"),
			Формат(Раздел / 10, "ЧРД=."),
			Формат(Число(НомерСтроки), "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ЗаголовокПоля = "";
		Если Раздел = "21" Тогда
			Если НомерСтроки = "205" Или НомерСтроки = "215" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		ИначеЕсли Раздел = "22" Тогда	
			Если НомерСтроки = "224" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		ИначеЕсли Раздел = "23" Тогда	
			Если НомерСтроки = "234" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		ИначеЕсли Раздел = "24" Тогда	
			Если НомерСтроки = "244" Или НомерСтроки = "250" Или НомерСтроки = "256" Или НомерСтроки = "262" Или НомерСтроки = "268" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля", ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчетаРСВ1За2015Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "21" Тогда
		Если ИмяПоказателя = "П000210001001" Тогда
			Возврат
		КонецЕсли;
		Если НомерСтроки = "205" Или НомерСтроки = "206" Или НомерСтроки = "214" Тогда
			ИмяНабораДанных = "Раздел21Взносы2015"
		ИначеЕсли НомерСтроки <> "204" И НомерСтроки <> "207" И НомерСтроки <> "208" И НомерСтроки <> "213" И НомерСтроки <> "215" Тогда
			ИмяНабораДанных = "Раздел21Доходы2014"
		КонецЕсли;
	ИначеЕсли Раздел = "22" Тогда	
		Если НомерСтроки = "224" Тогда
			ИмяНабораДанных = "Раздел22Взносы2014"
		ИначеЕсли НомерСтроки <> "223" И НомерСтроки <> "225" Тогда
			ИмяНабораДанных = "Раздел22Доходы2014"
		КонецЕсли;
	ИначеЕсли Раздел = "23" Тогда	
		Если НомерСтроки = "234" Тогда
			ИмяНабораДанных = "Раздел22Взносы2014"
		ИначеЕсли НомерСтроки <> "233" И НомерСтроки <> "235" Тогда
			ИмяНабораДанных = "Раздел22Доходы2014"
		КонецЕсли;
	ИначеЕсли Раздел = "24" Тогда	
		Если НомерСтроки = "244" Или НомерСтроки = "250" Или НомерСтроки = "256" Или НомерСтроки = "262" Или НомерСтроки = "268" Тогда
			ИмяНабораДанных = "Раздел24Взносы2014"
		ИначеЕсли НомерСтроки <> "010" И НомерСтроки <> "020" И НомерСтроки <> "243" И НомерСтроки <> "245" И НомерСтроки <> "249" И НомерСтроки <> "251" И НомерСтроки <> "255" И НомерСтроки <> "257" И НомерСтроки <> "261" И НомерСтроки <> "263" И НомерСтроки <> "267" И НомерСтроки <> "269" Тогда
			ИмяНабораДанных = "Раздел24Доходы2014"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
			
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Разд. %1, строка %2, графа %3';
				|en = 'Sect. %1, line %2, column %3'"),
			Формат(Раздел / 10, "ЧРД=."),
			Формат(Число(НомерСтроки), "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ЗаголовокПоля = "";
		Если Раздел = "21" Тогда
			Если НомерСтроки = "205" Или НомерСтроки = "215" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		ИначеЕсли Раздел = "22" Тогда	
			Если НомерСтроки = "224" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		ИначеЕсли Раздел = "23" Тогда	
			Если НомерСтроки = "234" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		ИначеЕсли Раздел = "24" Тогда	
			Если НомерСтроки = "244" Или НомерСтроки = "250" Или НомерСтроки = "256" Или НомерСтроки = "262" Или НомерСтроки = "268" Тогда
				ЗаголовокПоля = "Сумма"
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля", ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчета4ФССЗа2013Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "03" Тогда
		Если НомерСтроки <> "040" И НомерСтроки <> "050" Тогда
			ИмяНабораДанных = "Доходы2013"
		КонецЕсли;
	ИначеЕсли Раздел = "31" Тогда	
		Если НомерКолонки = "05" Или НомерКолонки = "06" Или НомерКолонки = "07" Или НомерКолонки = "08" Тогда
			ИмяНабораДанных = "ДоходыИнвалидов2013"
		КонецЕсли;
	ИначеЕсли Раздел = "06" Тогда	
		Если НомерСтроки <> "012" И (НомерКолонки = "03" Или НомерКолонки = "04" Или НомерКолонки = "05") Тогда
			ИмяНабораДанных = "Доходы2013"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		Таблица = Число(Раздел);
		Если Таблица > 10 Тогда
			Таблица = Таблица / 10
		КонецЕсли;
		НомерСтроки = Число(НомерСтроки);
		Если Таблица = 6 Тогда
			НомерСтроки = НомерСтроки - 10
		Иначе	
			НомерСтроки = НомерСтроки / 10
		КонецЕсли;
		
		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Табл. %1, строка %2, графа %3';
				|en = 'Tabl. %1, row %2, column %3'"),
			Формат(Таблица, "ЧРД=."),
			Формат(НомерСтроки, "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ПараметрыОтчета.Вставить("ЗаголовокПоля", "");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчета4ФССЗа2015Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "03" Тогда
		Если НомерСтроки <> "040" И НомерСтроки <> "070" Тогда
			ИмяНабораДанных = "Доходы2015"
		КонецЕсли;
	ИначеЕсли Раздел = "06" Тогда	
		Если НомерСтроки <> "012" И (НомерКолонки = "03" Или НомерКолонки = "04" Или НомерКолонки = "05") Тогда
			ИмяНабораДанных = "Доходы2015"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		Таблица = Число(Раздел);
		Если Таблица > 10 Тогда
			Таблица = Таблица / 10
		КонецЕсли;
		НомерСтроки = Число(НомерСтроки);
		Если Таблица = 6 Тогда
			НомерСтроки = НомерСтроки - 10
		Иначе	
			НомерСтроки = НомерСтроки / 10
		КонецЕсли;
		
		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Табл. %1, строка %2, графа %3';
				|en = 'Tabl. %1, row %2, column %3'"),
			Формат(Таблица, "ЧРД=."),
			Формат(НомерСтроки, "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ПараметрыОтчета.Вставить("ЗаголовокПоля", "");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчета4ФССЗа2016Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "03" Тогда
		Если НомерСтроки <> "040" И НомерСтроки <> "070" Тогда
			ИмяНабораДанных = "Доходы2016"
		КонецЕсли;
	ИначеЕсли Раздел = "06" Тогда	
		Если НомерСтроки = "001" Или НомерСтроки = "002" Или НомерСтроки = "004" Тогда
			ИмяНабораДанных = "Доходы2016"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		Таблица = Число(Раздел);
		Если Таблица > 10 Тогда
			Таблица = Таблица / 10
		КонецЕсли;
		НомерСтроки = Число(НомерСтроки);
		Если Таблица = 6 Тогда
		Иначе	
			НомерСтроки = НомерСтроки / 10
		КонецЕсли;
		
		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Табл. %1, строка %2, графа %3';
				|en = 'Tabl. %1, row %2, column %3'"),
			Формат(Таблица, "ЧРД=."),
			Формат(НомерСтроки, "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ПараметрыОтчета.Вставить("ЗаголовокПоля", "");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчета4ФССЗа2017Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "01" Тогда	
		Если НомерСтроки = "001" Или НомерСтроки = "002" Или НомерСтроки = "004" Тогда
			ИмяНабораДанных = "Доходы2017"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Табл. %1, строка %2, графа %3';
				|en = 'Tabl. %1, row %2, column %3'"),
			Формат(Число(Раздел), "ЧРД=."),
			Формат(Число(НомерСтроки), "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ПараметрыОтчета.Вставить("ЗаголовокПоля", "Сумма");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВзносыДатаПолученияДоходаСтрокойНачалоВыбораЗавершение(Результат, Параметры) Экспорт 
	Если Результат = Истина Тогда
		ДанныеТекущейСтроки = Параметры.ДанныеТекущейСтроки;
		ИмяПоляДатаПолученияДохода = Параметры.ИмяПоляДатаПолученияДохода;
		
		Если ЗначениеЗаполнено(ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода]) Тогда
			ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода] = УчетСтраховыхВзносовКлиентСервер.ДатаПолученияДохода(ДанныеТекущейСтроки[ИмяПоляДатаПолученияДохода]);
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры	

#КонецОбласти
