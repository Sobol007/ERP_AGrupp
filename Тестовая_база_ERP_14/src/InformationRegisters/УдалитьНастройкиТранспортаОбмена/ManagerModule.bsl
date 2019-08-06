///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра             = "РегистрСведений.УдалитьНастройкиТранспортаОбмена";
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ПланыОбменаМассив",                 Новый Массив);
	ПараметрыЗапроса.Вставить("ДополнительныеСвойстваПланаОбмена", "");
	ПараметрыЗапроса.Вставить("РезультатВоВременнуюТаблицу",       Истина);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ЗапросУзлыОбмена = Новый Запрос(ОбменДаннымиСервер.ТекстЗапросаПланыОбменаДляМонитора(ПараметрыЗапроса, Ложь));
	ЗапросУзлыОбмена.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗапросУзлыОбмена.Выполнить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиТранспорта.УзелИнформационнойБазы КАК УзелИнформационнойБазы
	|ИЗ
	|	ПланыОбменаКонфигурации КАК ПланыОбменаКонфигурации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьНастройкиТранспортаОбмена КАК НастройкиТранспорта
	|		ПО (НастройкиТранспорта.УзелИнформационнойБазы = ПланыОбменаКонфигурации.УзелИнформационнойБазы)");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Результат, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаЗавершена = Истина;
	
	МетаданныеРегистра    = Метаданные.РегистрыСведений.УдалитьНастройкиТранспортаОбмена;
	ПолноеИмяРегистра     = МетаданныеРегистра.ПолноеИмя();
	ПредставлениеРегистра = МетаданныеРегистра.Представление();
	
	ДополнительныеПараметрыВыборкиДанныхДляОбработки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, ПолноеИмяРегистра, ДополнительныеПараметрыВыборкиДанныхДляОбработки);
	
	Обработано = 0;
	Проблемных = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			ПеренестиНастройкиТранспортаОбменаДаннымиКорреспондента(Выборка.УзелИнформационнойБазы);
			Обработано = Обработано + 1;
			
		Исключение
			
			Проблемных = Проблемных + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать набор записей регистра ""%1"" с отбором ""УзелИнформационнойБазы = %2"" по причине:
				|%3';
				|en = 'Cannot process set of ""%1"" register records with filter ""УзелИнформационнойБазы = %2"" due to: 
				|%3'"), ПредставлениеРегистра, Выборка.УзелИнформационнойБазы, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра, , ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра) Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если Обработано = 0 И Проблемных <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре РегистрыСведений.УдалитьНастройкиТранспортаОбмена.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые записи узлов обмена (пропущены): %1';
				|en = 'The РегистрыСведений.УдалитьНастройкиТранспортаОбмена.ОбработатьДанныеДляПереходаНаНовуюВерсию procedure cannot process some exchange node records (skipped): %1'"), 
			Проблемных);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			, ,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура РегистрыСведений.УдалитьНастройкиТранспортаОбмена.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию записей: %1';
				|en = 'The РегистрыСведений.УдалитьНастройкиТранспортаОбмена.ОбработатьДанныеДляПереходаНаНовуюВерсию procedure processed records: %1'"),
			Обработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ПеренестиНастройкиТранспортаОбменаДаннымиКорреспондента(УзелИнформационнойБазы) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);
		
		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УдалитьНастройкиТранспортаОбмена");
		ЭлементБлокировки.УстановитьЗначение("УзелИнформационнойБазы", УзелИнформационнойБазы);
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиТранспортаОбменаДанными");
		ЭлементБлокировки.УстановитьЗначение("Корреспондент", УзелИнформационнойБазы);
		
		Блокировка.Заблокировать();
		
		НаборЗаписейСтарый = СоздатьНаборЗаписей();
		НаборЗаписейСтарый.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);
		
		НаборЗаписейСтарый.Прочитать();
		
		Если НаборЗаписейСтарый.Количество() = 0 Тогда
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписейСтарый);
		Иначе
			НаборЗаписейНовый = РегистрыСведений.НастройкиТранспортаОбменаДанными.СоздатьНаборЗаписей();
			НаборЗаписейНовый.Отбор.Корреспондент.Установить(УзелИнформационнойБазы);
			
			ЗаписьНовый = НаборЗаписейНовый.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНовый, НаборЗаписейСтарый[0]);
			ЗаписьНовый.Корреспондент = УзелИнформационнойБазы;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейНовый);
			
			НаборЗаписейСтарый.Очистить();
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейСтарый);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли