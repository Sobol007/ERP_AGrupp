#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявлениеОПостановкеНаУчет") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЗаявлениеОПостановкеНаУчет", "Заявление о постановке на учет'", ПолучитьТабличныйДокументЗаявлениеОПостановкеНаУчет(МассивОбъектов));
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПаспортСделки") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПаспортСделки", "Паспорт сделки (до 01.03.2018)", ПолучитьТабличныйДокументПаспортСделки(МассивОбъектов));
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьТабличныйДокументЗаявлениеОПостановкеНаУчет(МассивОбъектов)
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ПервыйДокумент = Истина;
	Для Каждого Ссылка Из МассивОбъектов Цикл
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		ОбъектСсылки = Ссылка.ПолучитьОбъект();
		Если ОбъектСсылки.КонтрактВЭД.КредитныйДоговор Тогда
			ТабличныйДокумент.Вывести(ОбъектСсылки.ПечатьПоставновкаНаУчетКредитногоДоговора_2018());
		Иначе
			ТабличныйДокумент.Вывести(ОбъектСсылки.ПечатьПоставновкаНаУчетКонтракта_2018());
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

Функция ПолучитьТабличныйДокументПаспортСделки(МассивОбъектов)
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ПервыйДокумент = Истина;
	Для Каждого Ссылка Из МассивОбъектов Цикл
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		ОбъектСсылки = Ссылка.ПолучитьОбъект();
		
		Если ОбъектСсылки.Дата >= Дата(2015,02,23) Тогда
			Если ОбъектСсылки.КонтрактВЭД.КредитныйДоговор Тогда
				ТабличныйДокумент.Вывести(ОбъектСсылки.ПечатьПС_Форма2_2015_02_23());
			Иначе
				ТабличныйДокумент.Вывести(ОбъектСсылки.ПечатьПС_Форма1_2015_02_23());
			КонецЕсли;
		Иначе
			ДанныеДляПечати = ОбъектСсылки.ПолучитьДанныеДляПечатиПС("ПС2012");
			Если ОбъектСсылки.КонтрактВЭД.КредитныйДоговор Тогда
				ТабличныйДокумент.Вывести(ОбъектСсылки.ПечатьПаспортаСделкиКредитныйДоговор(ДанныеДляПечати));
			Иначе
				ТабличныйДокумент.Вывести(ОбъектСсылки.ПечатьПаспортаСделки(ДанныеДляПечати));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

Процедура ПолучитьСтруктуруПараметров(СсылкаНаДокумент, ИмяМакета, СтруктураПараметров) Экспорт
	СтруктураПараметров = СсылкаНаДокумент.ПолучитьОбъект().ПолучитьДанныеДляПечати();
КонецПроцедуры

#КонецЕсли

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "РЭЙ_СлужебныйКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.РЭЙ_ПаспортСделки";
	КомандаПечати.Идентификатор = "ПаспортСделки";
	КомандаПечати.Представление = НСтр("ru = 'Паспорт сделки (до 01.03.2018)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "РЭЙ_СлужебныйКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.РЭЙ_ПаспортСделки";
	КомандаПечати.Идентификатор = "ЗаявлениеОПостановкеНаУчет";
	КомандаПечати.Представление = НСтр("ru = 'Заявление о постановке на учет контракта'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
КонецПроцедуры

#КонецОбласти
