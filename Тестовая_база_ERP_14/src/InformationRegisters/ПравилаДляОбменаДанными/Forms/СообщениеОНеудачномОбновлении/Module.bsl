///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = Параметры.ИмяПланаОбмена;
	СинонимПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Синоним;
	
	ПравилаКонвертацииОбъектов = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов;
	ПравилаРегистрацииОбъектов = Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов;
	
	ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,
		Параметры.ПодробноеПредставлениеОшибки);
		
	СообщениеОбОшибке = Элементы.ТекстСообщенияОбОшибке.Заголовок;
	СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%2", Параметры.КраткоеПредставлениеОшибки);
	СообщениеОбОшибке = СтрЗаменитьСВыделением(СообщениеОбОшибке, "%1", СинонимПланаОбмена);
	Элементы.ТекстСообщенияОбОшибке.Заголовок = СообщениеОбОшибке;
	
	ПравилаИзФайла = РегистрыСведений.ПравилаДляОбменаДанными.ИспользуютсяПравилаИзФайла(ИмяПланаОбмена, Истина);
	
	Если ПравилаИзФайла.ПравилаКонвертации И ПравилаИзФайла.ПравилаРегистрации Тогда
		ТипПравил = НСтр("ru = 'конвертации и регистрации';
						|en = 'conversions and registrations'");
	ИначеЕсли ПравилаИзФайла.ПравилаКонвертации Тогда
		ТипПравил = НСтр("ru = 'конвертации';
						|en = 'conversions'");
	ИначеЕсли ПравилаИзФайла.ПравилаРегистрации Тогда
		ТипПравил = НСтр("ru = 'регистрации';
						|en = 'registrations'");
	КонецЕсли;
	
	Элементы.ТекстПравилаИзФайла.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.ТекстПравилаИзФайла.Заголовок, СинонимПланаОбмена, ТипПравил);
	
	ВремяНачалаОбновления = Параметры.ВремяНачалаОбновления;
	Если Параметры.ВремяОкончанияОбновления = Неопределено Тогда
		ВремяОкончанияОбновления = ТекущаяДатаСеанса();
	Иначе
		ВремяОкончанияОбновления = Параметры.ВремяОкончанияОбновления;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОбновления);
	ПараметрыФормы.Вставить("ЗапускатьНеВФоне", Истина);
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Перезапустить(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКомплектПравил(Команда)
	
	ОбменДаннымиКлиент.ЗагрузитьПравилаСинхронизацииДанных(ИмяПланаОбмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СтрЗаменитьСВыделением(Строка, ПодстрокаПоиска, ПодстрокаЗамены)
	
	ПозицияНачала = СтрНайти(Строка, ПодстрокаПоиска);
	
	МассивСтроки = Новый Массив;
	
	МассивСтроки.Добавить(Лев(Строка, ПозицияНачала - 1));
	МассивСтроки.Добавить(Новый ФорматированнаяСтрока(ПодстрокаЗамены, Новый Шрифт(,,Истина)));
	МассивСтроки.Добавить(Сред(Строка, ПозицияНачала + СтрДлина(ПодстрокаПоиска)));
	
	Возврат Новый ФорматированнаяСтрока(МассивСтроки);
	
КонецФункции

#КонецОбласти