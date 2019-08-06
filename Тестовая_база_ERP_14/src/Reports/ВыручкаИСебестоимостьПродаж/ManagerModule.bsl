#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуПродажи(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Продажи';
											|en = 'Sales'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "СмТакже";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьДанныеПартнераКлиентаКонтекст";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "Продажи");
		КомандаОтчет.КлючВарианта = "ДинамикаПродажКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуПродажиПоЗаказу(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Продажи по заказу';
											|en = 'Sales by order'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ПродажиПоЗаказу");
		КомандаОтчет.КлючВарианта = "ПродажиПоЗаказуКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуПродажиПоСегменту(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Продажи по сегменту';
											|en = 'Sales by segment'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "СмТакже";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ПродажиПоСегменту");
		КомандаОтчет.КлючВарианта = "ДинамикаПродажКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//	КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуПродажиПоНоменклатуре(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Продажи номенклатуры';
											|en = 'Product sales'");
		
		
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Ложь;
		
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ПродажиПоНоменклатуре");
		
		КомандаОтчет.КлючВарианта = "ПоНоменклатуреКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли