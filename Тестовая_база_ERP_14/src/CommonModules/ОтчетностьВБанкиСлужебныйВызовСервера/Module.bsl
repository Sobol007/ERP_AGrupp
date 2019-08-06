////////////////////////////////////////////////////////////////////////////////
// ОтчетностьВБанкиСлужебныйВызовСервера: Механизм отправки отчетов в банки.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет возможность отправки отчета для данной организации.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - ссылка на организацию;
//  Банк - ОпределяемыйТип.СправочникБанки - ссылка на банк;
//  ПодключенаИнтернетПоддержка - Булево - (возвращаемый параметр). Если Истина - то интернет-поддержка включена.
//  СоглашениеПринято - Булево - (возвращаемый параметр). Если Истина - то соглашение было принято пользователем.
// 
// Возвращаемое значение:
// Булево - если Истина, то отправка отчета возможна.
//
Функция ВозможнаОтправкаОтчета(Знач Организация, Знач Банк, Знач ПараметрыКлиента, ПодключенаИнтернетПоддержка = Ложь, СоглашениеПринято = Ложь) Экспорт
	
	Дата = ТекущаяДатаСеанса();
	
	РеквизитыОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, Дата, "ИННЮЛ, КППЮЛ");
	
	ВремФайл = ПолучитьИмяВременногоФайла();
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(ВремФайл);
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("inn");
	ЗаписьJSON.ЗаписатьЗначение(РеквизитыОрганизации.ИННЮЛ);
	ЗаписьJSON.ЗаписатьИмяСвойства("kpp");
	ЗаписьJSON.ЗаписатьЗначение(РеквизитыОрганизации.КППЮЛ);
	ЗаписьJSON.ЗаписатьИмяСвойства("bic");
	ЗаписьJSON.ЗаписатьЗначение(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Банк, "Код"));
	
	ОтчетностьВБанкиСлужебный.ДобавитьДополнительныеПараметры(ЗаписьJSON, ПараметрыКлиента);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	ЗаписьJSON.Закрыть();
	
	Данные = Новый ДвоичныеДанные(ВремФайл);
	
	Попытка
		УдалитьФайлы(ВремФайл);
	Исключение
		ВидОперации = НСтр("ru = 'Удаление временного файла.';
							|en = 'Удаление временного файла.'");
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбработатьОшибку(ВидОперации, ПодробноеПредставлениеОшибки);
	КонецПопытки;
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	Результат = ОтчетностьВБанкиСлужебный.ОтправитьЗапросНаСервер(
		"https://reportbank.1c.ru", "/api/rest/organization/check/", Заголовки, Данные, Истина, 15);
	
	Успех = Ложь;
	ТекстСообщения = ""; ТекстОшибки = "";
	
	Если Результат.Статус Тогда
		ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
		Если НЕ ДанныеОтвета = Неопределено Тогда
			Успех = ДанныеОтвета.result;
			Если Не Успех Тогда
				ТекстСообщения = НСтр("ru = 'Для указанной организации нет возможности отправлять отчеты.
											|Обратитесь в свой банк.';
											|en = 'Для указанной организации нет возможности отправлять отчеты.
											|Обратитесь в свой банк.'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(Результат.Тело) Тогда
			ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
			Если НЕ ДанныеОтвета = Неопределено Тогда
				Если ДанныеОтвета.Свойство("errorText") Тогда
					ТекстСообщения = ДанныеОтвета.errorText;
				Иначе
					ТекстСообщения = НСтр("ru = 'Получена неизвестная ошибка с сервиса Бизнес-сеть.';
											|en = 'Получена неизвестная ошибка с сервиса Бизнес-сеть.'");
				КонецЕсли;
			КонецЕсли;
			ТекстОшибки = НСтр("ru = 'Ошибка получения данных с сервиса Бизнес-сеть.
								|Код состояния: %1
								|%2';
								|en = 'Ошибка получения данных с сервиса Бизнес-сеть.
								|Код состояния: %1
								|%2'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.КодСостояния, Результат.Тело);
		Иначе
			ТекстСообщения = Результат.СообщениеОбОшибке;
			ТекстОшибки = НСтр("ru = 'Ошибка получения данных с сервиса Бизнес-сеть.
								|Код состояния: %1';
								|en = 'Ошибка получения данных с сервиса Бизнес-сеть.
								|Код состояния: %1'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) ИЛИ ЗначениеЗаполнено(ТекстСообщения) Тогда
		ВидОперации = НСтр("ru = 'Проверка организации на сервисе Бизнес-сеть.';
							|en = 'Проверка организации на сервисе Бизнес-сеть.'");
		ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстСообщения);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПодключенаИнтернетПоддержка = ОбщегоНазначенияПовтИсп.РазделениеВключено()
		ИЛИ ДанныеАутентификации <> Неопределено;
	СоглашениеПринято = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОтчетностьВБанки", "СоглашениеПринято", Ложь);
	
	Возврат Успех;
	
КонецФункции

// Выводит текст ошибки в виде сообщения и производит запись в журнал регистрации.
//
// Параметры:
//  ВидОперации - Строка - выполняемая операция
//  ПодробныйТекстОшибки - Строка - подробная информация об ошибке
//  ТекстСообщения - Строка - текст сообщения, выводимый пользователю.
//
Процедура ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстСообщения = "") Экспорт
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь( , , Ложь);
	
	Если ЭтоПолноправныйПользователь И ЗначениеЗаполнено(ПодробныйТекстОшибки) И НЕ ПустаяСтрока(ТекстСообщения)
		И ПодробныйТекстОшибки <> ТекстСообщения Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС
			+ Нстр("ru = 'Подробности см. в журнале регистрации.';
					|en = 'Подробности см. в журнале регистрации.'");
	КонецЕсли;

	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	Если Прав(ВидОперации, 1) <> "." Тогда
		ВидОперации = ВидОперации + ".";
	КонецЕсли;
	ТекстОшибки = СтрШаблон(НСтр("ru = 'Выполнение операции: %1
		|%2';
		|en = 'Выполнение операции: %1
		|%2'"), ВидОперации, ПодробныйТекстОшибки);
	
	ВыполнитьЗаписьСобытияВЖурналРегистрации(ТекстОшибки);
	
КонецПроцедуры

// Отправляет отчет в банк.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация;
//  Банк - ОпределяемыйТип.СправочникБанки - банк;
//  ДанныеФайл - ДвоичныеДанные - данные файла отчета;
//  ИмяФайла - Строка - имя файла документа
//  ЭлектроннаяПодпись - ДвоичныеДанные - данные электронной подписи.
//  ПараметрыКлиента - Структура - содержит параметры клиентского приложения:
//        * ТипПлатформы - Строка - тип клиентского приложения;
//        * ВерсияОС - Строка - версия ОС на клиенте;
//  Отчет - ДокументСсылка.РегламентированныйОтчет - ссылка на отправляемый отчет.
//
// Возвращаемое значение:
//  Булево - если Истина, то отчет успешно отправлен.
//
Функция ОтправитьДанныеВБанк(Знач Организация, Знач Банк, Знач ДанныеФайла, Знач ИмяФайла, Знач ЭлектроннаяПодпись, Знач ПараметрыКлиента, Знач Отчет, ДатаОтправки) Экспорт
	
	ТикетАутентификации = ТикетАутентификации();
	Если Не ЗначениеЗаполнено(ТикетАутентификации) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НазваниеКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(НазваниеКаталога);
	
	НазваниеКаталога = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(НазваниеКаталога);
	ВремФайлОтчет = НазваниеКаталога + ИмяФайла;
	ВремФайлЭП =  НазваниеКаталога + ИмяФайла + ".p7s";
	ДанныеФайла.Записать(ВремФайлОтчет);
	ЭлектроннаяПодпись.Записать(ВремФайлЭП);
	ФайлZIP = ПолучитьИмяВременногоФайла("zip");
	
	ЗаписьZIP = Новый ЗаписьZipФайла(ФайлZIP, , , , УровеньСжатияZIP.Максимальный);
	ЗаписьZIP.Добавить(ВремФайлОтчет);
	ЗаписьZIP.Добавить(ВремФайлЭП);
	ЗаписьZIP.Записать();
	
	Попытка
		УдалитьФайлы(НазваниеКаталога);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отчетность в банки. Ошибка удаления временного каталога';
										|en = 'Отчетность в банки. Ошибка удаления временного каталога'"),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	ДвоичныеДанныеZIP = Новый ДвоичныеДанные(ФайлZIP);
	
	Попытка
		УдалитьФайлы(ФайлZIP);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отчетность в банки. Ошибка удаления временного файла';
										|en = 'Отчетность в банки. Ошибка удаления временного файла'"),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Дата = ТекущаяДатаСеанса();
	РеквизитыОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, Дата, "ИННЮЛ, КППЮЛ");
	
	ВремФайл = ПолучитьИмяВременногоФайла();
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(ВремФайл);
	
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("authenticationInfo");
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("authToken");
	ЗаписьJSON.ЗаписатьЗначение(ТикетАутентификации);
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	
	ЗаписьJSON.ЗаписатьИмяСвойства("inn");
	ЗаписьJSON.ЗаписатьЗначение(РеквизитыОрганизации.ИННЮЛ);
	ЗаписьJSON.ЗаписатьИмяСвойства("kpp");
	ЗаписьJSON.ЗаписатьЗначение(РеквизитыОрганизации.КППЮЛ);
	ЗаписьJSON.ЗаписатьИмяСвойства("bic");
	ЗаписьJSON.ЗаписатьЗначение(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Банк, "Код"));
	ЗаписьJSON.ЗаписатьИмяСвойства("data");
	СтрокаДанных = СтрЗаменить(СтрЗаменить(Base64Строка(ДвоичныеДанныеZIP), Символы.ПС, ""), Символы.ВК, "");
	ЗаписьJSON.ЗаписатьЗначение(СтрокаДанных);
	
	ОтчетностьВБанкиСлужебный.ДобавитьДополнительныеПараметры(ЗаписьJSON, ПараметрыКлиента);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	ЗаписьJSON.Закрыть();
	
	Данные = Новый ДвоичныеДанные(ВремФайл);
	
	Попытка
		УдалитьФайлы(ВремФайл);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отчетность в банки. Ошибка удаления временного файла';
										|en = 'Отчетность в банки. Ошибка удаления временного файла'"),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	Результат = ОтчетностьВБанкиСлужебный.ОтправитьЗапросНаСервер(
		"https://reportbank.1c.ru", "/api/rest/report/send/", Заголовки, Данные, Истина, 30);
		
	Успех = Ложь;
	ТекстСообщения = ""; ТекстОшибки = "";
	
	Если Результат.Статус Тогда
		ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
		ИдентификаторДокумента = ДанныеОтвета.guid;
	Иначе
		Если ЗначениеЗаполнено(Результат.Тело) Тогда
			ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
			Если НЕ ДанныеОтвета = Неопределено Тогда
				Если ДанныеОтвета.Свойство("errorText") Тогда
					ТекстСообщения = ДанныеОтвета.errorText;
				Иначе
					ТекстСообщения = НСтр("ru = 'Получена неизвестная ошибка с сервиса Бизнес-сеть.';
											|en = 'Получена неизвестная ошибка с сервиса Бизнес-сеть.'");
				КонецЕсли;
			КонецЕсли;
			ТекстОшибки = НСтр("ru = 'Ошибка отправки отчета через сервис Бизнес-сеть.
								|Код состояния: %1
								|%2';
								|en = 'Ошибка отправки отчета через сервис Бизнес-сеть.
								|Код состояния: %1
								|%2'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.КодСостояния, Результат.Тело);
		Иначе
			ТекстСообщения = Результат.СообщениеОбОшибке;
			ТекстОшибки = НСтр("ru = 'Ошибка отправки отчета через сервис Бизнес-сеть.
								|Код состояния: %1';
								|en = 'Ошибка отправки отчета через сервис Бизнес-сеть.
								|Код состояния: %1'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.КодСостояния);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) ИЛИ ЗначениеЗаполнено(ТекстСообщения) Тогда
		ВидОперации = НСтр("ru = 'Отправка отчета через сервис Бизнес-сеть.';
							|en = 'Отправка отчета через сервис Бизнес-сеть.'");
		ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Объект = Отчет.ПолучитьОбъект();
	Объект.Идентификатор = ИдентификаторДокумента;
	Объект.СтатусОтчета = НСтр("ru = 'Отправлено';
								|en = 'Отправлено'");
	Объект.ДатаОтправки = ДатаОтправки;
	Объект.Записать();
	
	Возврат Истина;
	
КонецФункции

// Производит запрос URL внешней компоненты с сервиса Бизнес-сеть, скачивание и сохранение в информационной базе.
//
// Параметры:
//  Банк - ОпределяемыйТип.СправочникБанки - ссылка на банк;
//  ПараметрыКлиента - Структура - содержит параметры клиентского приложения:
//        * ТипПлатформы - Строка - тип клиентского приложения;
//        * ВерсияОС - Строка - версия ОС на клиенте.
//
// Возвращаемое значение:
//  Структура              - параметры выполнения задания: 
//   * Статус               - Строка - "Выполняется", если задание еще не завершилось;
//                                     "Выполнено", если задание было успешно выполнено;
//                                     "Ошибка", если задание завершено с ошибкой;
//                                     "Отменено", если задание отменено пользователем или администратором.
//   * ИдентификаторЗадания - УникальныйИдентификатор - если Статус = "Выполняется", то содержит 
//                                     идентификатор запущенного фонового задания.
//   * АдресРезультата       - Строка - адрес временного хранилища, в которое будет
//                                     помещен (или уже помещен) результат работы процедуры.
//   * АдресДополнительногоРезультата - Строка - если установлен параметр ДополнительныйРезультат, 
//                                     содержит адрес дополнительного временного хранилища,
//                                     в которое будет помещен (или уже помещен) результат работы процедуры.
//   * КраткоеПредставлениеОшибки   - Строка - краткая информация об исключении, если Статус = "Ошибка".
//   * ПодробноеПредставлениеОшибки - Строка - подробная информация об исключении, если Статус = "Ошибка".
// 
Функция СкачатьВнешнююКомпоненту(Знач Банк, Знач ПараметрыКлиента) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Нстр("ru = 'Загрузка внешней компоненты.';
															|en = 'Загрузка внешней компоненты.'");
	ПараметрыПроцедуры = Новый Структура("Банк, ПараметрыКлиента", Банк, ПараметрыКлиента);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Отчеты.БухгалтерскаяОтчетностьВБанк.СкачатьВнешнююКомпоненту", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТикетАутентификации()
	
	Тикет          			= Неопределено;
	ПодробныйТекстОшибки	= "";
	ТекстСообщения 			= "";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки("reportBank");
	
	Если ЗначениеЗаполнено(Результат.Тикет) Тогда
		Тикет = Результат.Тикет;
	Иначе
		ПодробныйТекстОшибки = Результат.ИнформацияОбОшибке;
		ТекстСообщения 		 = Результат.СообщениеОбОшибке;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПодробныйТекстОшибки) ИЛИ ЗначениеЗаполнено(ТекстСообщения) Тогда
		ВидОперации = НСтр("ru = 'Ошибка аутентификации на сервисе 1С:Логин.';
							|en = 'Ошибка аутентификации на сервисе 1С:Логин.'");
		ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстСообщения);
	КонецЕсли;
	
	Возврат Тикет;
	
КонецФункции

Процедура ВыполнитьЗаписьСобытияВЖурналРегистрации(ОписаниеСобытия, УровеньВажности = Неопределено, РежимТранзакции = Неопределено)
	
	ИмяСобытия = НСтр("ru = 'Отчетность в банки';
						|en = 'Отчетность в банки'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	УровеньВажностиСобытия = ?(ТипЗнч(УровеньВажности) = Тип("УровеньЖурналаРегистрации"),
		УровеньВажности, УровеньЖурналаРегистрации.Ошибка);
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньВажностиСобытия, , , ОписаниеСобытия, РежимТранзакции);
	
КонецПроцедуры

#КонецОбласти
