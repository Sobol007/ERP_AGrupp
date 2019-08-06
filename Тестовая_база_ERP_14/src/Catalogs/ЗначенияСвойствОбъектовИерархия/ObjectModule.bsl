///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		ВладелецДополнительныхЗначений = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец,
			"ВладелецДополнительныхЗначений");
		
		Если ЗначениеЗаполнено(ВладелецДополнительныхЗначений) Тогда
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дополнительные значения для свойства ""%1"", созданного
				           |по образцу свойства ""%2"" нужно создавать для свойства-образца.';
				           |en = 'It is required to create additional values of property
				           |""%1"" created on the basis of property ""%2"" for the basis property.'"),
				Владелец,
				ВладелецДополнительныхЗначений);
			
			Если ЭтоНовый() Тогда
				ВызватьИсключение ОписаниеОшибки;
			Иначе
				ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	ЛокализацияСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on client.'");
#КонецЕсли