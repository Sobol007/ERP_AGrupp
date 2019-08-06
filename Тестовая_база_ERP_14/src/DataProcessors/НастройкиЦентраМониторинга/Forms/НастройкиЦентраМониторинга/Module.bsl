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
	
	СостояниеЗаданияПолученияИдентификатора = "";
	
	Если Параметры.Свойство("ИдентификаторЗадания") Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
		АдресРезультатаЗадания = Параметры.АдресРезультатаЗадания;
		Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			СостояниеЗаданияПолученияИдентификатора = ЗаданиеВыполнено(ИдентификаторЗадания);
		КонецЕсли;
	КонецЕсли;  	
	
	ИдентификаторЦентраМониторинга = ИдентификаторЦентраМониторинга();
	Если НЕ ПустаяСтрока(ИдентификаторЦентраМониторинга) Тогда
		Идентификатор = ИдентификаторЦентраМониторинга;
	Иначе
		// Идентификатора нет по какой-то причине, надо получить его повторно.
		Элементы.ГруппаИдентификатор.ТекущаяСтраница = Элементы.СтраницаПолучитьИдентификатор;
	КонецЕсли;
	
	ПараметрыДляПолучения = Новый Структура("ОтправлятьФайлыДампов, СпрашиватьПередОтправкой");
	ПараметрыЦентраМониторинга = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга(ПараметрыДляПолучения);
	ОтправлятьИнформациюОбОшибках = ПараметрыЦентраМониторинга.ОтправлятьФайлыДампов;
	Если ОтправлятьИнформациюОбОшибках = 2 Тогда
		Элементы.ОтправлятьИнформациюОбОшибках.ТриСостояния = Истина;
	КонецЕсли;
	СпрашиватьПередОтправкой = ПараметрыЦентраМониторинга.СпрашиватьПередОтправкой;
	СодержимоеПодсказки = Элементы.ОтправлятьИнформациюОбОшибкахРасширеннаяПодсказка.Заголовок;
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда                                   		
		Элементы.ОтправлятьИнформациюОбОшибкахРасширеннаяПодсказка.Заголовок = СтрЗаменить(СодержимоеПодсказки,"%ДопИнфо","");
	Иначе
		Элементы.ОтправлятьИнформациюОбОшибкахРасширеннаяПодсказка.Заголовок = СтрЗаменить(СодержимоеПодсказки,"%ДопИнфо"," " + НСтр("ru = 'на сервере 1С';
																																	|en = 'on 1C server'"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПараметрыВидимости = Новый Структура("Статус, АдресРезультата", СостояниеЗаданияПолученияИдентификатора, АдресРезультатаЗадания);
	Если НЕ ПустаяСтрока(СостояниеЗаданияПолученияИдентификатора) И ПустаяСтрока(Идентификатор) Тогда
		УстановитьВидимостьЭлементов(ПараметрыВидимости);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьИнформациюОбОшибкахПриИзменении(Элемент)
	Элемент.ТриСостояния = Ложь;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	НовыеПараметры = Новый Структура("ОтправлятьФайлыДампов, СпрашиватьПередОтправкой", 
										ОтправлятьИнформациюОбОшибках, СпрашиватьПередОтправкой);
	УстановитьПараметрыЦентраМониторинга(НовыеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	НовыеПараметры = Новый Структура("ОтправлятьФайлыДампов, СпрашиватьПередОтправкой", 
										ОтправлятьИнформациюОбОшибках, СпрашиватьПередОтправкой);
	УстановитьПараметрыЦентраМониторинга(НовыеПараметры);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИдентификатор(Команда)
	РезультатЗапуска = ОтправкаОзнакомительногоПакета();
	ИдентификаторЗадания = РезультатЗапуска.ИдентификаторЗадания;
	АдресРезультатаЗадания = РезультатЗапуска.АдресРезультата;
	СостояниеЗаданияПолученияИдентификатора = "Выполняется";
	Оповещение = Новый ОписаниеОповещения("ПослеОбновленияИдентификатора", ЦентрМониторингаКлиент);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатЗапуска, Оповещение, ПараметрыОжидания);
	
	// Вывести состояние получения идентификатора.
	ПараметрыВидимости = Новый Структура("Статус, АдресРезультата", СостояниеЗаданияПолученияИдентификатора, АдресРезультатаЗадания);
	УстановитьВидимостьЭлементов(ПараметрыВидимости);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновлениеИдентификатораЦентрМониторинга" И Параметр <> Неопределено Тогда
		УстановитьВидимостьЭлементов(Параметр);	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьПараметрыЦентраМониторинга(НовыеПараметры)
	ЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(НовыеПараметры);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИдентификаторЦентраМониторинга()
	Возврат ЦентрМониторинга.ИдентификаторИнформационнойБазы();
КонецФункции

&НаКлиенте
Процедура АктуализироватьПараметры()
	ИдентификаторЦентраМониторинга = ИдентификаторЦентраМониторинга();
	Если НЕ ПустаяСтрока(ИдентификаторЦентраМониторинга) Тогда
		Идентификатор = ИдентификаторЦентраМониторинга;
	КонецЕсли;                                                                     	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	РезультатВыполнения = "Выполняется";
	Попытка
		ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
		Если ЗаданиеВыполнено Тогда 
			РезультатВыполнения = "Выполнено";
		Иначе
			РезультатВыполнения = "Выполняется";
		КонецЕсли;
	Исключение
		РезультатВыполнения = "Ошибка";
	КонецПопытки;
	Возврат РезультатВыполнения;
КонецФункции

&НаСервереБезКонтекста
Функция ОтправкаОзнакомительногоПакета()
	// Отправка ознакомительного пакета.
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыПроцедуры = Новый Структура("Итератор, ОтправкаТестовогоПакета, ПолучениеИдентификатора", 0, Ложь, Истина);
	Возврат ДлительныеОперации.ВыполнитьВФоне("ЦентрМониторингаСлужебный.ОтправитьТестовыйПакет", ПараметрыПроцедуры, ПараметрыВыполнения);
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементов(ПараметрыВидимости)
	РезультатВыполнения = ПолучитьИзВременногоХранилища(ПараметрыВидимости.АдресРезультата);
	Если ПараметрыВидимости.Статус = "Выполняется" Тогда
		Элементы.ОписаниеПрогресса.Заголовок = НСтр("ru = 'Выполняется получение идентификатора';
													|en = 'Receiving ID'");		
		Элементы.ОписаниеПрогресса.Видимость = Истина;
		Элементы.Прогресс.Картинка = БиблиотекаКартинок.ДлительнаяОперация16;
		Элементы.Прогресс.Видимость = Истина;
		Элементы.ГруппаИдентификатор.Видимость = Ложь;	
	ИначеЕсли ПараметрыВидимости.Статус = "Выполнено" И РезультатВыполнения.Успешно Тогда
		Элементы.ОписаниеПрогресса.Заголовок = НСтр("ru = 'Идентификатор успешно получен';
													|en = 'ID is received successfully'");		
		Элементы.ОписаниеПрогресса.Видимость = Ложь;
		Элементы.Прогресс.Видимость = Ложь;
		Элементы.ГруппаИдентификатор.Видимость = Истина;
		Элементы.ГруппаИдентификатор.ТекущаяСтраница = Элементы.СтраницаИдентификатора;
		АктуализироватьПараметры();
	ИначеЕсли ПараметрыВидимости.Статус = "Выполнено" И НЕ РезультатВыполнения.Успешно ИЛИ ПараметрыВидимости.Статус = "Ошибка" Тогда
		Если ПараметрыВидимости.Статус = "Ошибка" Тогда
			Пояснение = НСтр("ru = 'Ошибка при выполнении фонового задания.';
							|en = 'An error occurred while executing the background job.'");
		Иначе
			Пояснение = РезультатВыполнения.КраткоеПредставлениеОшибки;
		КонецЕсли;
		ШаблонЗаголовка = НСтр("ru = 'Не удалось получить идентификатор. %1 Подробнее см. в журнале регистрации';
								|en = 'Cannot receive ID. %1 For more information, see the event log'");
		Элементы.ОписаниеПрогресса.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, Пояснение);		
		Элементы.ОписаниеПрогресса.Видимость = Истина;
		Элементы.Прогресс.Картинка = БиблиотекаКартинок.Предупреждение;
		Элементы.Прогресс.Видимость = Истина;
		Элементы.ГруппаИдентификатор.Видимость = Истина;
		Элементы.ГруппаИдентификатор.ТекущаяСтраница = Элементы.СтраницаПолучитьИдентификатор;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

