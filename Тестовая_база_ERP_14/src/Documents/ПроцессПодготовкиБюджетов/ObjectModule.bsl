#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ПометкаУдаления Тогда
		Если Статус <> Перечисления.СтатусыПроцессовПодготовкиБюджетов.Завершен Тогда
			Статус = Перечисления.СтатусыПроцессовПодготовкиБюджетов.Отменен;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыПроцессовПодготовкиБюджетов.Выполняется Тогда
		ПараметрыЗадания = Новый Массив();
		ПараметрыЗадания.Добавить(МодельБюджетирования);
		ПараметрыЗадания.Добавить(Ссылка);
		ФоновыеЗадания.Выполнить("БюджетированиеСервер.ФормированиеБюджетныхЗадач",ПараметрыЗадания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли