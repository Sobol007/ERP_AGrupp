#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("РаботаВАвтономномРежиме") Тогда
		ВызватьИсключение НСтр("ru = 'Изменение классификатора ОКОФ в режиме ""Автономного рабочего места"" запрещено';
								|en = 'You cannot change RNCFA classifier in mode ""Offline workplace""'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли