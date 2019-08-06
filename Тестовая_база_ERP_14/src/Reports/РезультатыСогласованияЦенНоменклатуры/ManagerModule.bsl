#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатыСогласованияЦенНоменклатуры) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьСогласованиеЦенНоменклатуры") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.РезультатыСогласованияЦенНоменклатуры.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Результаты согласования';
											|en = 'Approval results '");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьСогласованиеЦенНоменклатуры";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "РезультатыСогласованияЦенНоменклатуры");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчетаПоДокументу(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатыСогласованияЦенНоменклатуры) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьСогласованиеЦенНоменклатуры") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.РезультатыСогласованияЦенНоменклатуры.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Результаты согласования';
											|en = 'Approval results '");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьСогласованиеЦенНоменклатуры";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "РезультатыСогласованияЦенНоменклатурыПоДокументу");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли