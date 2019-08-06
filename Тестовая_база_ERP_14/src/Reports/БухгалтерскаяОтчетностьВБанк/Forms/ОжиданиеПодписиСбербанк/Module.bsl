&НаКлиенте
Перем ПодключаемыйМодуль;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ОбъектПодписи) = Тип("Строка") Тогда
		ПредставлениеДанных = Параметры.ОбъектПодписи;
		Элементы.ПредставлениеДанных.Гиперссылка = Ложь;
	Иначе
		ПредставлениеДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ОбъектПодписи, "Представление");
	КонецЕсли;
	
	Если Параметры.ТипУстройства = "SCR" Тогда // экранный
		Элементы.Пояснение.Заголовок = НСтр("ru = 'Подтвердите подпись на электронном ключе';
											|en = 'Подтвердите подпись на электронном ключе'");
	КонецЕсли;
	
	Счетчик = 60;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключаемыйМодуль = ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ПодключаемыйМодуль;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьУстановкуПодписи", 1);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка)
	
	Если НЕ ТипЗнч(Параметры.ОбъектПодписи) = Тип("Строка") Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьУстановкуПодписи()
	
	Если Счетчик = 0 Тогда
		ТекстОповещения = НСтр("ru = 'Подпись документа не подтверждена!';
								|en = 'Подпись документа не подтверждена!'");
		Результат = Новый Структура("Успех, ТекстОшибки", Ложь, ТекстОповещения);
		Закрыть(Результат);
	КонецЕсли;
	
	Элементы.Отсчет.Заголовок = СтрШаблон(НСтр("ru = '%1 сек.';
												|en = '%1 сек.'"), Счетчик);
	
	Состояние = 0;
	ЭП = "";
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияДанныхПодписи", ЭтотОбъект, ,
		"ОбработатьОшибкуПолученияДанныхПодписи", ЭтотОбъект);
	
	ПодключаемыйМодуль.НачатьВызовПолучитьДанныеПодписиИзVPNKeyTLSPKCS7(Оповещение, Состояние, ЭП);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияДанныхПодписи(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	Если РезультатВызова <> 0 Тогда
		Операция = НСтр("ru = 'Подписание данных';
						|en = 'Подписание данных'");
		ТекстОшибки = НСтр("ru = 'При подписании электронного документа произошла ошибка
								|Внешний модуль VpnKey-TLS при подписании вернул код ошибки %1';
								|en = 'При подписании электронного документа произошла ошибка
								|Внешний модуль VpnKey-TLS при подписании вернул код ошибки %1'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, РезультатВызова);
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(Операция, ТекстОшибки);
		Результат = Новый Структура("Успех, ТекстОшибки", Ложь, ТекстОшибки);
		Закрыть(Результат);
	КонецЕсли;
	
	Состояние = ПараметрыВызова.Получить(0);
	ЭП = ПараметрыВызова.Получить(1);
	
	Если Состояние = "COMPLETE" Тогда // Данные подписаны
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьУстановкуПодписи");
		Результат = Новый Структура("Успех, ЭП", Истина, ЭП);
		Закрыть(Результат);
		Возврат;
	ИначеЕсли Состояние = "FAILED" Тогда
		Операция = НСтр("ru = 'Подписание данных';
						|en = 'Подписание данных'");
		ТекстОшибки = НСтр("ru = 'При подписании электронного документа произошла ошибка
							|Код состояния: %1';
							|en = 'При подписании электронного документа произошла ошибка
							|Код состояния: %1'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Состояние);
		ТекстСообщения = НСтр("ru = 'При подписании электронного документа произошла ошибка';
								|en = 'При подписании электронного документа произошла ошибка'");
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(Операция, ТекстОшибки);
		Результат = Новый Структура("Успех, ТекстОшибки", Ложь, ТекстСообщения);
		Закрыть(Результат);
	ИначеЕсли Состояние = "REJECTED" Тогда
		ТекстОповещения = НСтр("ru = 'Подпись документа не подтверждена!';
								|en = 'Подпись документа не подтверждена!'");
		Результат = Новый Структура("Успех, ТекстОшибки", Ложь, ТекстОповещения);
		Закрыть(Результат);
	КонецЕсли;
		
	Счетчик = Счетчик - 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуПолученияДанныхПодписи(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПодробнаяИнформация = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	КраткаяИнформация = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	ШаблонОшибки = НСтр("ru = 'При получении данных подписи произошла ошибка.
						|%1';
						|en = 'При получении данных подписи произошла ошибка.
						|%1'");
	ТекстСообщения = СтрШаблон(ШаблонОшибки, КраткаяИнформация);
	ВидОперации = НСтр("ru = 'Получение данных подписи.';
						|en = 'Получение данных подписи.'");
	ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ПодробнаяИнформация);
	Результат = Новый Структура;
	Результат.Вставить("Успех", Ложь);
	Результат.Вставить("ТекстОшибки", ТекстСообщения);
	Закрыть(Результат);

КонецПроцедуры

#КонецОбласти