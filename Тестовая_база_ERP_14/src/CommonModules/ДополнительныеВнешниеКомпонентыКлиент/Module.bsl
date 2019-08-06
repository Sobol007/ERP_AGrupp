////////////////////////////////////////////////////////////////////////////////
// ДополнительныеВнешниеКомпонентыКлиент: Механизм для работы с внешними компонентами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Производит подключение внешней компоненты
//
// Параметры:
//  Оповещение - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения вызова метода со следующими параметрами: 
//                   * РезультатВызова - AddIn - подключенная внешняя компонента;
//                                     - Неопределено - в процессе подключения произошла ошибка
//                   * ДополнительныеПараметры - значение, которое было указано при создании объекта ОписаниеОповещения.
//  ИмяМодуля - Строка - уникальное название внешнего модуля.
//  ПроверятьВерсию - Булево - контролировать версию после подключения.
//  ТекстУточнения - Строка - данный текст будет добавлен в предупреждение при установке компоненты.
//
Процедура ПодключитьВнешнююКомпонентуПоИдентификатору(Оповещение, ИмяМодуля, ПроверятьВерсию = Истина, ТекстУточнения = Неопределено) Экспорт
	
	ВнешняяКомпонентаИзКэш = ВнешняяКомпонентаИзКэша(ИмяМодуля);
	
	Если ВнешняяКомпонентаИзКэш <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Оповещение, ВнешняяКомпонентаИзКэш);
		Возврат;
	КонецЕсли;
	
	Версия = Неопределено;
	АдресВК = ДополнительныеВнешниеКомпонентыВызовСервера.АдресВК(ИмяМодуля, Версия);
	
	Если АдресВК = Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'В информационной базе не найдена внешняя компонента %1.';
							|en = 'Add-in %1 was not found in the infobase.'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, ИмяМодуля);
		ВидОперации = НСтр("ru = 'Подключение внешней компоненты.';
							|en = 'Attaching add-in.'");
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстОшибки);
		ВыполнитьОбработкуОповещения(Оповещение, Неопределено);
		Возврат;
	КонецЕсли;

	ИдентификаторВК = "С" + СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", ""); //генерация уникального имени
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИдентификаторВК", ИдентификаторВК);
	ДополнительныеПараметры.Вставить("АдресВК", АдресВК);
	ДополнительныеПараметры.Вставить("ИмяМодуля", ИмяМодуля);
	ДополнительныеПараметры.Вставить("ОповещениеПослеПодключенияВК", Оповещение);
	ДополнительныеПараметры.Вставить("ВерсияВИБ", Версия);
	ДополнительныеПараметры.Вставить("ПроверятьВерсию", ПроверятьВерсию);
	ДополнительныеПараметры.Вставить("ТекстУточнения", ТекстУточнения);
	ОповещениеПослеПодключенияКомпоненты = Новый ОписаниеОповещения(
		"ПослеПопыткиПодключенияВнешнейКомпоненты", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеВнешнейКомпоненты(
		ОповещениеПослеПодключенияКомпоненты, АдресВК, ИдентификаторВК, ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

// Производит подключение внешней компоненты
//
// Параметры:
//  Оповещение - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения вызова метода со следующими параметрами: 
//                   * РезультатВызова - AddIn - подключенная внешняя компонента;
//                                     - Неопределено - в процессе подключения произошла ошибка
//                   * ДополнительныеПараметры - значение, которое было указано при создании объекта ОписаниеОповещения.
//  АдресВК - Строка - текст ссылки на реквизит справочника в формате 1С:Предприятия;
//  ИмяМодуля - Строка - уникальное название внешнего модуля;
//  ПроверятьВерсию - Булево - признак необходимости проверки реальной и ожидаемой версии внешней компоненты.
//  ТекстУточнения - Строка - данный текст будет добавлен в предупреждение при установке компоненты.
//
Процедура ПодключитьВнешнююКомпонентуПоСсылке(Оповещение, АдресВК, ИмяМодуля, ПроверятьВерсию = Ложь, ТекстУточнения = Неопределено) Экспорт
	
	ИдентификаторВК = "С" + СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", ""); //генерация уникального имени
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИдентификаторВК", ИдентификаторВК);
	ДополнительныеПараметры.Вставить("АдресВК", АдресВК);
	ДополнительныеПараметры.Вставить("ИмяМодуля", ИмяМодуля);
	ДополнительныеПараметры.Вставить("ОповещениеПослеПодключенияВК", Оповещение);
	ДополнительныеПараметры.Вставить("ПроверятьВерсию", ПроверятьВерсию);
	ДополнительныеПараметры.Вставить("ТекстУточнения", ТекстУточнения);

	ОповещениеПослеПодключенияКомпоненты = Новый ОписаниеОповещения(
		"ПослеПопыткиПодключенияВнешнейКомпоненты", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеВнешнейКомпоненты(
		ОповещениеПослеПодключенияКомпоненты, АдресВК, ИдентификаторВК, ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

// Возвращает внешнюю компоненту из кэша
//
// Параметры:
//  ИмяМодуля - Строка - уникальное название внешнего модуля.
// 
// Возвращаемое значение:
//  AddIn - внешняя компонента
//  Неопределено - в кэше нет внешней компоненты.
//
Функция ВнешняяКомпонентаИзКэша(ИмяМодуля) Экспорт
	
	ПараметрыПодсистемыВнешниеКомпоненты = ПараметрыПриложения["ВнешниеКомпоненты"];
	Если ПараметрыПодсистемыВнешниеКомпоненты <> Неопределено Тогда
		ПодключаемыйМодуль = Неопределено;
		ПараметрыПодсистемыВнешниеКомпоненты.Свойство(ИмяМодуля, ПодключаемыйМодуль);
		Если ПодключаемыйМодуль <> Неопределено Тогда
			Возврат ПодключаемыйМодуль;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Скачать внешнюю компоненту и сохраняет в информационной базе
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение,вызываемое после выполнения процедуры.
//    Результат - Структура - результат выполнения процедуры, содержит следующие поля:
//      * Успех - Булево - если Истина, то операция успешно завершена.
//      * Идентификатор - Строка - идентификатор внешней компоненты. Поле присутствует если Успех=Истина
//  URLИнфоФайла - Строка - адрес в интернете, где расположен информационный файл внешней компоненты.
//
Процедура СкачатьВнешнююКомпоненту(Оповещение, URLИнфоФайла) Экспорт
	
	Результат = ДополнительныеВнешниеКомпонентыВызовСервера.ЗапускЗаданияПоПолучениюИнформацииОВнешнейКомпоненте(URLИнфоФайла);
	ДополнительныеПараметры = Новый Структура("ОповещениеПослеСкачиванияВК", Оповещение);
	
	Если Результат.Статус = "Выполняется" Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
		ПараметрыОжидания.ВыводитьСообщения = Истина;
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПослеПолученияИнформацииОВнешнейКомпоненте = Новый ОписаниеОповещения(
			"ПослеПолученияИнформацииОВнешнейКомпоненте", ЭтотОбъект, ДополнительныеПараметры);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ПослеПолученияИнформацииОВнешнейКомпоненте, ПараметрыОжидания);
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ВидОперации = НСтр("ru = 'Получение информации о внешней компоненте.';
							|en = 'Receiving information about the add-in.'");
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(
			ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки);
		ВыполнитьОбработкуОповещения(Оповещение, Новый Структура("Успех", Ложь));
	Иначе
		ПослеПолученияИнформацииОВнешнейКомпоненте(Результат, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Удаляет внешнюю компоненту из Кэш
//
// Параметры:
//  ИмяМодуля - Строка - название удаляемого модуля.
//
Процедура УдалитьВнешнююКомпонентуИзКэш(ИмяМодуля) Экспорт
	
	ПараметрыПодсистемыВнешниеКомпоненты = ПараметрыПриложения["ВнешниеКомпоненты"];
	Если ПараметрыПодсистемыВнешниеКомпоненты <> Неопределено Тогда
		ПараметрыПодсистемыВнешниеКомпоненты.Удалить(ИмяМодуля);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет, соответствует ли версия подключенной компоненты ожидаемой версии.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения вызова метода со следующими параметрами:
//    РезультатВызова - Строка - текст сообщения об ошибке
//                    - Булево - Истина, если ожидаемая версия соответствует реальной.
//    ДополнительныеПараметры - значение, которое было указано при создании объекта ОписаниеОповещения.
//  ПодключаемыйМодуль - AddIn - внешний модуль;
//  ОжидаемаяВерсия - Строка - ожидаемая версия подключенной внешней компоненты.
//
Процедура ПроверитьВерсиюВК(Оповещение, ПодключаемыйМодуль, ОжидаемаяВерсия)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПодключаемыйМодуль", ПодключаемыйМодуль);
	ДополнительныеПараметры.Вставить("ОжидаемаяВерсия", ОжидаемаяВерсия);
	ДополнительныеПараметры.Вставить("ОповещениеПослеПолученияНомераВерсии", Оповещение);
	
	ОповещениеПослеПолученияВерсии = Новый ОписаниеОповещения(
		"ПослеПолученияВерсииВК", ЭтотОбъект, ДополнительныеПараметры, "ОбработатьОшибкуПолученияВерсииВК", ЭтотОбъект);
	
	ПодключаемыйМодуль.НачатьВызовВерсия(ОповещениеПослеПолученияВерсии);
	
КонецПроцедуры

Процедура ПослеПолученияВерсииВК(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Если РезультатВызова = ДополнительныеПараметры.ОжидаемаяВерсия Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПолученияНомераВерсии, Истина);
	Иначе
		#Если ВебКлиент Тогда
			ТекстСообщения = НСтр("ru = 'На компьютере уже установлен внешний модуль другой версии.
										|Удалите расширение для браузера, перезагрузите компьютер и повторите операцию.';
										|en = 'External module of another version is already installed on the computer.
										|Remove the browser extension, restart the computer, and try again.'");
		#Иначе
			ТекстСообщения = НСтр("ru = 'Отличаются версии используемого и загруженного внешнего модуля.
										|Перезапустите программу.';
										|en = 'Versions of imported external module and the module in use are different. 
										|Restart the application.'");
		#КонецЕсли
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПолученияНомераВерсии, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОшибкуПолученияВерсииВК(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПодробнаяИнформация = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	КраткаяИнформация = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	
	ВидОперации = НСтр("ru = 'Получение версии внешней компоненты.';
						|en = 'Receiving the add-in version.'");
	ШаблонОшибки = НСтр("ru = 'При получении версии внешней компоненты произошла ошибка.
						|%1';
						|en = 'An error occurred while receiving add-in version. 
						|%1'");

	ТекстСообщения = СтрШаблон(ШаблонОшибки, КраткаяИнформация);
	ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ПодробнаяИнформация, ТекстСообщения);
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПолученияНомераВерсии, Ложь);
	
КонецПроцедуры

Процедура ПослеПопыткиПодключенияВнешнейКомпоненты(Результат, Параметры) Экспорт
	
	Если Результат Тогда
		Попытка
			ПодключаемыйМодуль = Новый("AddIn." + Параметры.ИдентификаторВК + "." + Параметры.ИмяМодуля);
			
			Если НЕ Параметры.ПроверятьВерсию Тогда
				ЗакэшироватьВнешнююКомпоненту(ПодключаемыйМодуль, Параметры.ИмяМодуля);
				ВыполнитьОбработкуОповещения(Параметры.ОповещениеПослеПодключенияВК, ПодключаемыйМодуль);
				ДополнительныеВнешниеКомпонентыВызовСервера.ОбновитьВнешнююКомпоненту(Параметры.ИмяМодуля);
				Возврат;
			КонецЕсли;
			
			Параметры.Вставить("ПодключаемыйМодуль", ПодключаемыйМодуль);
			Оповещение = Новый ОписаниеОповещения("ПослеПроверкиВерсииВК", ЭтотОбъект, Параметры);
			ПроверитьВерсиюВК(Оповещение, ПодключаемыйМодуль, Параметры.ВерсияВИБ);
		Исключение
			ТекстСообщения = НСтр("ru = 'Ошибка подключения внешней компоненты.';
									|en = 'An error occurred when attaching the add-in.'");
			Операция = НСтр("ru = 'Подключение внешней компоненты.';
							|en = 'Attaching add-in.'");
			ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(Операция, ПодробноеПредставлениеОшибки, ТекстСообщения);
			ВыполнитьОбработкуОповещения(Параметры.ОповещениеПослеПодключенияВК, Неопределено);
		КонецПопытки;
	Иначе
		ИнформацияОВК = ДополнительныеВнешниеКомпонентыВызовСервера.ИнформацияОВнешнейКомпоненте(Параметры.АдресВК);
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуВнешнейКомпонентыПослеВопроса", ЭтотОбъект, Параметры);
		Если ЗначениеЗаполнено(Параметры.ТекстУточнения) Тогда
			ТекстВопроса = НСтр("ru = 'Для продолжения необходимо установить внешний модуль
							|%1. (Версия %2)
							|%3.
							|Установить внешний модуль?';
							|en = 'To continue, install an external module 
							|%1. (Version %2)
							|%3.
							|Install the external module?'");
			ТекстВопроса = СтрШаблон(ТекстВопроса, ИнформацияОВК.Название, ИнформацияОВК.Версия, Параметры.ТекстУточнения);
		Иначе
			ТекстВопроса = НСтр("ru = 'Для продолжения необходимо установить внешний модуль
							|%1. (Версия %2)
							|Установить внешний модуль?';
							|en = 'To continue, an external module 
							|%1 must be installed. (Version %2)
							|Install the external module?'");
			ТекстВопроса = СтрШаблон(ТекстВопроса, ИнформацияОВК.Название, ИнформацияОВК.Версия);
		КонецЕсли;
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(Истина, НСтр("ru = 'Установить и продолжить';
									|en = 'Install and continue'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена';
														|en = 'Cancel'"));
		Заголовок = НСтр("ru = 'Установка внешней компоненты';
						|en = 'Install add-in'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , Истина, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьУстановкуВнешнейКомпонентыПослеВопроса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = Истина Тогда
		Оповещение = Новый ОписаниеОповещения(
			"ПодключитьВнешнююКомпонентуПослеУстановки", ЭтотОбъект, ДополнительныеПараметры);
		НачатьУстановкуВнешнейКомпоненты(Оповещение, ДополнительныеПараметры.АдресВК);
	Иначе
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПодключенияВК, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеПроверкиВерсииВК(Результат, Параметры) Экспорт
	
	Если НЕ Результат Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеПослеПодключенияВК, Неопределено);
		Возврат;
	КонецЕсли;
	
	ЗакэшироватьВнешнююКомпоненту(Параметры.ПодключаемыйМодуль, Параметры.ИмяМодуля);
	
	ВыполнитьОбработкуОповещения(Параметры.ОповещениеПослеПодключенияВК, Параметры.ПодключаемыйМодуль);
	
	ДополнительныеВнешниеКомпонентыВызовСервера.ОбновитьВнешнююКомпоненту(Параметры.ИмяМодуля);
	
КонецПроцедуры

Процедура ПодключитьВнешнююКомпонентуПослеУстановки(ДополнительныеПараметры) Экспорт
	
	ОповещениеПослеПодключенияКомпоненты = Новый ОписаниеОповещения(
		"ПослеПодключенияВнешнейКомпоненты", ЭтотОбъект, ДополнительныеПараметры);

	НачатьПодключениеВнешнейКомпоненты(ОповещениеПослеПодключенияКомпоненты,
		ДополнительныеПараметры.АдресВК, ДополнительныеПараметры.ИдентификаторВК, ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

Процедура ПослеПодключенияВнешнейКомпоненты(Подключено, Параметры) Экспорт

	Если Подключено Тогда
		Попытка
			ПодключаемыйМодуль = Новый("AddIn." + Параметры.ИдентификаторВК + "." + Параметры.ИмяМодуля);
			Если НЕ Параметры.ПроверятьВерсию Тогда
				ЗакэшироватьВнешнююКомпоненту(ПодключаемыйМодуль, Параметры.ИмяМодуля);
				ВыполнитьОбработкуОповещения(Параметры.ОповещениеПослеПодключенияВК, ПодключаемыйМодуль);
				ДополнительныеВнешниеКомпонентыВызовСервера.ОбновитьВнешнююКомпоненту(Параметры.ИмяМодуля);
				Возврат;
			КонецЕсли;
			Параметры.Вставить("ПодключаемыйМодуль", ПодключаемыйМодуль);
			Оповещение = Новый ОписаниеОповещения("ПослеПроверкиВерсииВК", ЭтотОбъект, Параметры);
			ПроверитьВерсиюВК(Оповещение, ПодключаемыйМодуль, Параметры.ВерсияВИБ);
		Исключение
			ТекстСообщения = НСтр("ru = 'Ошибка подключения внешней компоненты.';
									|en = 'An error occurred when attaching the add-in.'");
			Операция = НСтр("ru = 'Подключение внешней компоненты.';
							|en = 'Attaching add-in.'");
			ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(Операция, ПодробноеПредставлениеОшибки, ТекстСообщения);
			ВыполнитьОбработкуОповещения(Параметры.ОповещениеПослеПодключенияВК, Неопределено);
		КонецПопытки;
	Иначе
		ТекстСообщения = НСтр("ru = 'Ошибка подключения внешней компоненты.';
								|en = 'An error occurred when attaching the add-in.'");
		Операция = НСтр("ru = 'Подключение внешней компоненты.';
						|en = 'Attaching add-in.'");
		ШаблонОшибки = НСтр("ru = 'Не удалось подключить внешнюю компоненту %1';
							|en = 'Cannot attach the add-in %1'") ;
		ТекстОшибки = СтрШаблон(ШаблонОшибки, Параметры.ИмяМодуля);
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения);
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеПослеПодключенияВК, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗакэшироватьВнешнююКомпоненту(ПодключаемыйМодуль, ИмяМодуля)
	
	ПараметрыПодсистемыВнешниеКомпоненты = ПараметрыПриложения["ВнешниеКомпоненты"];
	Если ТипЗнч(ПараметрыПодсистемыВнешниеКомпоненты) <> Тип("Структура") Тогда
		ПараметрыПриложения.Вставить("ВнешниеКомпоненты", Новый Структура);
		ПараметрыПодсистемыВнешниеКомпоненты = ПараметрыПриложения["ВнешниеКомпоненты"];
	КонецЕсли;
	
	ПараметрыПодсистемыВнешниеКомпоненты.Вставить(ИмяМодуля, ПодключаемыйМодуль);
	
КонецПроцедуры

Процедура ПослеПолученияИнформацииОВнешнейКомпоненте(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, Новый Структура("Успех", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ИнформацияОВК = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		РазделениеВключено = Ложь; ТребуетсяСкачатьВК = Ложь;
		ДополнительныеВнешниеКомпонентыВызовСервера.ПроверитьНеобходимостьСкачиванияВК(
			ИнформацияОВК, РазделениеВключено, ТребуетсяСкачатьВК);
		ДополнительныеПараметры.Вставить("ИнформацияОВК", ИнформацияОВК);
			
		Если РазделениеВключено И ТребуетсяСкачатьВК Тогда
			ТекстСообщения = НСтр("ru = 'В информационной базе отсутствует внешняя компонента %1.
										|Необходимо обратиться в техническую поддержку сервиса.';
										|en = 'The %1 add-in is missing in the infobase. 
										|Contact service technical support.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, ИнформацияОВК.ИмяМодуля);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, Новый Структура("Успех", Ложь));
			Возврат;
		ИначеЕсли ТребуетсяСкачатьВК Тогда
			
			Результат = ДополнительныеВнешниеКомпонентыВызовСервера.ЗапускЗаданияПоСкачиваниюВнешнейКомпоненты(ИнформацияОВК.URLВК);
			Если Результат.Статус = "Выполняется" Тогда
				ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
				ПараметрыОжидания.ВыводитьСообщения = Истина;
				ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
				Оповещение = Новый ОписаниеОповещения("ПослеСкачиванияВнешнейКомпоненты", ЭтотОбъект, ДополнительныеПараметры);
				ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, Оповещение, ПараметрыОжидания);
			ИначеЕсли Результат.Статус = "Ошибка" Тогда
				ВидОперации = НСтр("ru = 'Скачивание внешней компоненты из интернет.';
									|en = 'Download add-in from the Internet.'");
				ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(
					ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки);
				ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, Новый Структура("Успех", Ложь));
				Возврат;
			Иначе
				СтруктураВозврата = Новый Структура;
				СтруктураВозврата.Вставить("Успех", Истина);
				СтруктураВозврата.Вставить("Идентификатор", ИнформацияОВК.ИмяМодуля);
				ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, СтруктураВозврата);
			КонецЕсли;
		Иначе
			СтруктураВозврата = Новый Структура;
			СтруктураВозврата.Вставить("Успех", Истина);
			СтруктураВозврата.Вставить("Идентификатор", ИнформацияОВК.ИмяМодуля);
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, СтруктураВозврата);
		КонецЕсли;
	Иначе // Ошибка
		ВидОперации = НСтр("ru = 'Получение информации о внешней компоненте.';
							|en = 'Receiving information about the add-in.'");
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(
			ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, Новый Структура("Успех", Ложь));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеСкачиванияВнешнейКомпоненты(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, Новый Структура("Успех", Ложь));
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("Успех", Истина);
		СтруктураВозврата.Вставить("Идентификатор", ДополнительныеПараметры.ИнформацияОВК.ИмяМодуля);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, СтруктураВозврата);
	Иначе // Ошибка
		ВидОперации = НСтр("ru = 'Скачивание внешней компоненты из интернет.';
							|en = 'Download add-in from the Internet.'");
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(
			ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеСкачиванияВК, Новый Структура("Успех", Ложь));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти