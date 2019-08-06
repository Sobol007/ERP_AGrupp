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
	
	ДополнительныеСвойства.Вставить("ТекущееЗначение", Константы.ИспользоватьРазделениеПоОбластямДанных.Получить());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// Следующие константы взаимоисключающие, используются в отдельных функциональных опциях.
	//
	// Константа.ЭтоАвтономноеРабочееМесто                -> ФО.РаботаВАвтономномРежиме
	// Константа.НеИспользоватьРазделениеПоОбластямДанных -> ФО.РаботаВЛокальномРежиме
	// Константа.ИспользоватьРазделениеПоОбластямДанных   -> ФО.РаботаВМоделиСервиса.
	//
	// Имена констант сохранены для обратной совместимости.
	
	Если Значение Тогда
		
		Константы.НеИспользоватьРазделениеПоОбластямДанных.Установить(Ложь);
		Константы.ЭтоАвтономноеРабочееМесто.Установить(Ложь);
		
	ИначеЕсли Константы.ЭтоАвтономноеРабочееМесто.Получить() Тогда
		
		Константы.НеИспользоватьРазделениеПоОбластямДанных.Установить(Ложь);
		
	Иначе
		
		Константы.НеИспользоватьРазделениеПоОбластямДанных.Установить(Истина);
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.ТекущееЗначение <> Значение Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		
		Если Значение Тогда
			
			ИнтеграцияПодсистемБСП.ПриВключенииРазделенияПоОбластямДанных();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on client.'");
#КонецЕсли