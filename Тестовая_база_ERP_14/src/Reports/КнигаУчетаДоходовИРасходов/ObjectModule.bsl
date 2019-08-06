#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) ИЛИ НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		ТекстСообщения = НСтр("ru = 'Не задан период формирования отчета!';
								|en = 'Report generation period is not specified.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПредставлениеПериода",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Не указана организация!';
								|en = 'Company is not specified.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Отчет.Организация",, Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли