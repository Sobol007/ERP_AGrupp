#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//	КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВедомостьПоТоварамОрганизаций) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ВедомостьПоТоварамОрганизаций.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Движения товара в организациях';
											|en = 'Goods movements in companies'");
		
		
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Ложь;
		
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ВедомостьПоНоменклатуреОрганизаций");
		
		КомандаОтчет.КлючВарианта = "ПоНоменклатуреКонтекст";
		
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьНесколькоОрганизаций";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли