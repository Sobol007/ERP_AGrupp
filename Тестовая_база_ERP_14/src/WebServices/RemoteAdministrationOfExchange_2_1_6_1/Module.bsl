
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики операций

// Соответствует операции GetExchangeFeatures
Функция ПолучитьПланыОбменаКонфигурации()
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ExchangeAdministration/Common", "ExchangeFeatures"));
	ТипExchangeFeature = ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ExchangeAdministration/Common", "ExchangeFeature");
	
	Для Каждого ИмяПланаОбмена Из ОбменДаннымиВМоделиСервисаПовтИсп.ПланыОбменаСинхронизацииДанных() Цикл
		
		ExchangeFeature = ФабрикаXDTO.Создать(ТипExchangeFeature);
		ExchangeFeature.ExchangePlan = ИмяПланаОбмена;
		
		ВерсияБСП243 = ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СтандартныеПодсистемыСервер.ВерсияБиблиотеки(), "2.4.3.1") >= 0;
		
		ExchangeFeature.ExchangeRole = ?(ВерсияБСП243,
			ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена,"ИмяКонфигурацииИсточника"),
			ПланыОбмена[ИмяПланаОбмена].ИмяКонфигурацииИсточника());
			
		ExchangeFeature.ExchangeRole = СокрЛП(ExchangeFeature.ExchangeRole);
		
		Если ПустаяСтрока(ExchangeFeature.ExchangeRole) Тогда
			Если ВерсияБСП243 Тогда
				ВызватьИсключение СтрШаблон(НСтр("ru = 'Не задано возвращаемое значение функции ИмяКонфигурацииИсточника() в модуле менеджера плана обмена %1';
												|en = 'Return value of function ИмяКонфигурацииИсточника() is not specified in the module of exchange plan manager %1 '"),
					ИмяПланаОбмена);
			Иначе
				ВызватьИсключение СтрШаблон(НСтр("ru = 'Не задано значение свойства ИмяКонфигурацииИсточника в процедуре ПриПолученииНастроек() модуля менеджера плана обмена %1';
												|en = 'The ИмяКонфигурацииИсточника property value is not specified in the ПриПолученииНастроек() procedure of the module of the %1 exchange plan manager '"),
					ИмяПланаОбмена);
			КонецЕсли;
		КонецЕсли;
		
		Результат.Feature.Добавить(ExchangeFeature);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Соответствует операции PrepareExchangeExecution
Функция ЗапланироватьВыполнениеОбменаДанными(ОбластиДляОбменаДаннымиXDTO)
	
	ОбластиДляОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(ОбластиДляОбменаДаннымиXDTO);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Элемент Из ОбластиДляОбменаДанными Цикл
		
		ЗначениеРазделителя = Элемент.Ключ;
		СценарийОбменаДанными = Элемент.Значение;
		
		Параметры = Новый Массив;
		Параметры.Добавить(СценарийОбменаДанными);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода"    , "ОбменДаннымиВМоделиСервиса.ВыполнитьОбменДанными");
		ПараметрыЗадания.Вставить("Параметры"    , Параметры);
		ПараметрыЗадания.Вставить("Ключ"         , "1");
		ПараметрыЗадания.Вставить("ОбластьДанных", ЗначениеРазделителя);
		
		Попытка
			ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> ОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат "";
КонецФункции

// Соответствует операции StartExchangeExecutionInFirstDataBase
Функция ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе(ИндексСтрокиСценария, СценарийОбменаДаннымиXDTO)
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(СценарийОбменаДаннымиXDTO);
	
	СтрокаСценария = СценарийОбменаДанными[ИндексСтрокиСценария];
	
	Ключ = СтрокаСценария.ИмяПланаОбмена + СтрокаСценария.КодУзлаИнформационнойБазы + СтрокаСценария.КодЭтогоУзла;
	
	РежимОбмена = РежимОбменаДанными(СценарийОбменаДанными);
	
	Если РежимОбмена = "Ручной" Тогда
		
		Параметры = Новый Массив;
		Параметры.Добавить(ИндексСтрокиСценария);
		Параметры.Добавить(СценарийОбменаДанными);
		Параметры.Добавить(СтрокаСценария.ЗначениеРазделителяПервойИнформационнойБазы);
		
		ФоновыеЗадания.Выполнить("ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазеИзНеразделенногоСеанса",
			Параметры,
			Ключ
		);
	ИначеЕсли РежимОбмена = "Автоматический" Тогда
		
		Попытка
			Параметры = Новый Массив;
			Параметры.Добавить(ИндексСтрокиСценария);
			Параметры.Добавить(СценарийОбменаДанными);
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ОбластьДанных", СтрокаСценария.ЗначениеРазделителяПервойИнформационнойБазы);
			ПараметрыЗадания.Вставить("ИмяМетода", "ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВПервойИнформационнойБазе");
			ПараметрыЗадания.Вставить("Параметры", Параметры);
			ПараметрыЗадания.Вставить("Ключ", Ключ);
			ПараметрыЗадания.Вставить("Использование", Истина);
			
			УстановитьПривилегированныйРежим(Истина);
			ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> ОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неизвестный режим обмена данными %1';
										|en = 'Unknown data exchange mode %1'"), Строка(РежимОбмена)
		);
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Соответствует операции StartExchangeExecutionInSecondDataBase
Функция ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазе(ИндексСтрокиСценария, СценарийОбменаДаннымиXDTO)
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(СценарийОбменаДаннымиXDTO);
	
	СтрокаСценария = СценарийОбменаДанными[ИндексСтрокиСценария];
	
	Ключ = СтрокаСценария.ИмяПланаОбмена + СтрокаСценария.КодУзлаИнформационнойБазы + СтрокаСценария.КодЭтогоУзла;
	
	РежимОбмена = РежимОбменаДанными(СценарийОбменаДанными);
	
	Если РежимОбмена = "Ручной" Тогда
		
		Параметры = Новый Массив;
		Параметры.Добавить(ИндексСтрокиСценария);
		Параметры.Добавить(СценарийОбменаДанными);
		Параметры.Добавить(СтрокаСценария.ЗначениеРазделителяВторойИнформационнойБазы);
		
		ФоновыеЗадания.Выполнить("ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазеИзНеразделенногоСеанса",
			Параметры,
			Ключ
		);
		
	ИначеЕсли РежимОбмена = "Автоматический" Тогда
		
		Попытка
			Параметры = Новый Массив;
			Параметры.Добавить(ИндексСтрокиСценария);
			Параметры.Добавить(СценарийОбменаДанными);
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ОбластьДанных", СтрокаСценария.ЗначениеРазделителяВторойИнформационнойБазы);
			ПараметрыЗадания.Вставить("ИмяМетода", "ОбменДаннымиВМоделиСервиса.ВыполнитьДействиеСценарияОбменаДаннымиВоВторойИнформационнойБазе");
			ПараметрыЗадания.Вставить("Параметры", Параметры);
			ПараметрыЗадания.Вставить("Ключ", Ключ);
			ПараметрыЗадания.Вставить("Использование", Истина);
			
			УстановитьПривилегированныйРежим(Истина);
			ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		Исключение
			Если ИнформацияОбОшибке().Описание <> ОчередьЗаданий.ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неизвестный режим обмена данными %1';
										|en = 'Unknown data exchange mode %1'"), Строка(РежимОбмена)
		);
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Соответствует операции TestConnection
Функция ПроверитьПодключение(СтруктураНастроекXDTO, ВидТранспортаСтрокой, СообщениеОбОшибке)
	
	Отказ = Ложь;
	
	// Проверяем подключение обработки транспорта сообщений обмена
	ОбменДаннымиСервер.ПроверитьПодключениеОбработкиТранспортаСообщенийОбмена(Отказ,
			СериализаторXDTO.ПрочитатьXDTO(СтруктураНастроекXDTO),
			Перечисления.ВидыТранспортаСообщенийОбмена[ВидТранспортаСтрокой],
			СообщениеОбОшибке);
	
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

// Соответствует операции Ping
Функция Ping()
	
	// Заглушка. Необходима, чтобы не выдавалась ошибка проверки конфигурации.
	Заглушка = Истина;
	
КонецФункции

//

Функция РежимОбменаДанными(СценарийОбменаДанными)
	
	Результат = "Ручной";
	
	Если СценарийОбменаДанными.Колонки.Найти("Режим") <> Неопределено Тогда
		Результат = СценарийОбменаДанными[0].Режим;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
