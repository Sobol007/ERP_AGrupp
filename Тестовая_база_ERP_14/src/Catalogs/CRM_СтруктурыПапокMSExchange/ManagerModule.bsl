#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Получить дерево папок электронной почты
//
// Параметры:
//  УчетнаяЗапись	 - Ссылка, СправочникСсылка.CRM_УчетныеЗаписиПользователейMSExchange - Учетная запись MS Exchange.
//  СерверMSExchange - Ссылка, СправочникСсылка.CRM_СерверыMSExchange					 - Сервер MS Exchange.
// 
// Возвращаемое значение:
//  Дерево - Дерево иерархии папок MS Exchange.
//
Функция ПолучитьДеревоПапокЭлектроннойПочты(УчетнаяЗапись, СерверMSExchange) Экспорт
	МассивDistinguishedFolderId = Новый Массив();
	МассивDistinguishedFolderId.Добавить("inbox");
	МассивDistinguishedFolderId.Добавить("drafts");
	МассивDistinguishedFolderId.Добавить("sentitems");
	МассивDistinguishedFolderId.Добавить("deleteditems");
	МассивDistinguishedFolderId.Добавить("outbox");
	МассивDistinguishedFolderId.Добавить("junkemail");
	
	МассивРодителей = Новый Массив();
	Для Каждого DistinguishedFolderId Из МассивDistinguishedFolderId Цикл
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтруктурыПапокMSExchange.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.CRM_СтруктурыПапокMSExchange КАК СтруктурыПапокMSExchange
		|ГДЕ
		|	НЕ СтруктурыПапокMSExchange.ПометкаУдаления
		|	И СтруктурыПапокMSExchange.СерверMSExchange = &СерверMSExchange
		|	И СтруктурыПапокMSExchange.УчетнаяЗапись = &УчетнаяЗапись
		|	И СтруктурыПапокMSExchange.DistinguishedFolderId = &DistinguishedFolderId
		|");
		Запрос.УстановитьПараметр("СерверMSExchange", СерверMSExchange);
		Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
		Запрос.УстановитьПараметр("DistinguishedFolderId", DistinguishedFolderId);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			МассивРодителей.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Папкаmsgfolderroot = Неопределено;
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтруктурыПапокMSExchange.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.CRM_СтруктурыПапокMSExchange КАК СтруктурыПапокMSExchange
	|ГДЕ
	|	НЕ СтруктурыПапокMSExchange.ПометкаУдаления
	|	И СтруктурыПапокMSExchange.СерверMSExchange = &СерверMSExchange
	|	И СтруктурыПапокMSExchange.УчетнаяЗапись = &УчетнаяЗапись
	|	И СтруктурыПапокMSExchange.DistinguishedFolderId = &DistinguishedFolderId
	|");
	Запрос.УстановитьПараметр("СерверMSExchange", СерверMSExchange);
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("DistinguishedFolderId", "msgfolderroot");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Папкаmsgfolderroot = Выборка.Ссылка;
	КонецЕсли;
	
	ПапкаОшибкиСинхронизации = Неопределено;
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтруктурыПапокMSExchange.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.CRM_СтруктурыПапокMSExchange КАК СтруктурыПапокMSExchange
	|ГДЕ
	|	НЕ СтруктурыПапокMSExchange.ПометкаУдаления
	|	И СтруктурыПапокMSExchange.СерверMSExchange = &СерверMSExchange
	|	И СтруктурыПапокMSExchange.УчетнаяЗапись = &УчетнаяЗапись
	|	И (СтруктурыПапокMSExchange.DisplayName = &DisplayName ИЛИ СтруктурыПапокMSExchange.DisplayName = &DisplayName1)
	|");
	Запрос.УстановитьПараметр("СерверMSExchange", СерверMSExchange);
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("DisplayName", "Ошибки синхронизации");
	Запрос.УстановитьПараметр("DisplayName1", "Sync Issues");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПапкаОшибкиСинхронизации = Выборка.Ссылка;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СтруктурыПапокMSExchange.Ссылка КАК Ссылка,
	|	СтруктурыПапокMSExchange.Родитель КАК РодительСсылка,
	|	СтруктурыПапокMSExchange.Наименование КАК Наименование,
	|	СтруктурыПапокMSExchange.DisplayName КАК DisplayName,
	|	СтруктурыПапокMSExchange.ВидПапкиЭлектроннойПочты1С КАК ВидПапкиЭлектроннойПочты1С,
	|	СтруктурыПапокMSExchange.Родитель.ВидПапкиЭлектроннойПочты1С КАК ВидПапкиЭлектроннойПочты1СРодителя,
	|	СтруктурыПапокMSExchange.DistinguishedFolderId КАК DistinguishedFolderId
	|ИЗ
	|	Справочник.CRM_СтруктурыПапокMSExchange КАК СтруктурыПапокMSExchange
	|ГДЕ
	|	НЕ СтруктурыПапокMSExchange.ПометкаУдаления
	|	И СтруктурыПапокMSExchange.СерверMSExchange = &СерверMSExchange
	|	И СтруктурыПапокMSExchange.УчетнаяЗапись = &УчетнаяЗапись
	|	
	|	И
	|	(
	|";
	Для НомерСтроки = 0 По МассивРодителей.ВГраница() Цикл
		Родитель = МассивРодителей[НомерСтроки];
		ИмяПараметра = "Родитель" + Формат(НомерСтроки, "ЧН=0; ЧГ=");
		
		ТекстЗапроса = ТекстЗапроса + "
		|" + ?(НомерСтроки = 0, "", "ИЛИ ") + "(СтруктурыПапокMSExchange.Ссылка В ИЕРАРХИИ (&" + ИмяПараметра + ") И СтруктурыПапокMSExchange.FolderClass = ""IPF.Note"")" + "
		|";
		
		Запрос.УстановитьПараметр(ИмяПараметра, Родитель);
	КонецЦикла;
	Если ЗначениеЗаполнено(Папкаmsgfolderroot) Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ИЛИ (СтруктурыПапокMSExchange.Ссылка В ИЕРАРХИИ (&Папкаmsgfolderroot) И СтруктурыПапокMSExchange.FolderClass = ""IPF.Note"")
		|";
		Запрос.УстановитьПараметр("Папкаmsgfolderroot", Папкаmsgfolderroot);
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + "
	|	)
	|";
	
	Если ЗначениеЗаполнено(ПапкаОшибкиСинхронизации) Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|И (НЕ СтруктурыПапокMSExchange.Ссылка В ИЕРАРХИИ (&ПапкаОшибкиСинхронизации))
		|";
		Запрос.УстановитьПараметр("ПапкаОшибкиСинхронизации", ПапкаОшибкиСинхронизации);
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтруктурыПапокMSExchange.Ссылка ИЕРАРХИЯ
	|";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("СерверMSExchange", СерверMSExchange);
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Возврат Дерево;
КонецФункции

// Процедура - Добавляет папки MS Exchange в справочник папки электронных писем.
//
// Параметры:
//  УчетнаяЗаписьЭлектроннойПочты	 - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты	 - Учетная запись электронной почты
//  УчетнаяЗаписьMSExchange			 - СправочникСсылка.CRM_УчетныеЗаписиПользователейMSExchange - Учетная запись MS Exchange.
//  СерверMSExchange				 - СправочникСсылка.CRM_СерверыMSExchange					 - Сервер MS Exchange.
//
Процедура ДобавитьПапкиMSExchangeВСправочникПапкиЭлектронныхПисем(УчетнаяЗаписьЭлектроннойПочты, УчетнаяЗаписьMSExchange, СерверMSExchange) Экспорт
	Если Не ЗначениеЗаполнено(УчетнаяЗаписьЭлектроннойПочты) Или Не ЗначениеЗаполнено(УчетнаяЗаписьMSExchange) Или Не ЗначениеЗаполнено(СерверMSExchange) Тогда
		Возврат;
	КонецЕсли;
	
	ДеревоПапок = ПолучитьДеревоПапокЭлектроннойПочты(УчетнаяЗаписьMSExchange, СерверMSExchange);
	Если ДеревоПапок.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПапкиMSExchangeРекурсивно(ДеревоПапок.Строки, УчетнаяЗаписьЭлектроннойПочты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПапкуЭлектронныхПисемПоВиду(УчетнаяЗаписьЭлектроннойПочты, Вид)
	Если Не ЗначениеЗаполнено(Вид) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 РАЗРЕШЕННЫЕ
	|	Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПапкиЭлектронныхПисем
	|ГДЕ
	|	НЕ ПометкаУдаления
	|	И Владелец = &УчетнаяЗаписьЭлектроннойПочты
	|	И CRM_Вид = &Вид
	|");
	Запрос.УстановитьПараметр("УчетнаяЗаписьЭлектроннойПочты", УчетнаяЗаписьЭлектроннойПочты);
	Запрос.УстановитьПараметр("Вид", Вид);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ПолучитьПапкуЭлектронныхПисемПоПапкеMSExchange(УчетнаяЗаписьЭлектроннойПочты, ПапкаMSExchange)
	Если Не ЗначениеЗаполнено(ПапкаMSExchange) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 РАЗРЕШЕННЫЕ
	|	Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПапкиЭлектронныхПисем
	|ГДЕ
	|	Владелец = &УчетнаяЗаписьЭлектроннойПочты
	|	И CRM_ПапкаMSExchange = &ПапкаMSExchange
	|");
	Запрос.УстановитьПараметр("УчетнаяЗаписьЭлектроннойПочты", УчетнаяЗаписьЭлектроннойПочты);
	Запрос.УстановитьПараметр("ПапкаMSExchange", ПапкаMSExchange);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Процедура ДобавитьПапку(УчетнаяЗаписьЭлектроннойПочты, СтрокаДерева)
	Если Не ЗначениеЗаполнено(УчетнаяЗаписьЭлектроннойПочты) Тогда
		Возврат;
	КонецЕсли;
	
	Папка = ПолучитьПапкуЭлектронныхПисемПоПапкеMSExchange(УчетнаяЗаписьЭлектроннойПочты, СтрокаДерева.Ссылка);
	Если ЗначениеЗаполнено(Папка) Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаДерева.ВидПапкиЭлектроннойПочты1С) Тогда
		Папка = ПолучитьПапкуЭлектронныхПисемПоВиду(УчетнаяЗаписьЭлектроннойПочты, СтрокаДерева.ВидПапкиЭлектроннойПочты1С);
		Если ЗначениеЗаполнено(Папка) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Родитель = ПолучитьПапкуЭлектронныхПисемПоПапкеMSExchange(УчетнаяЗаписьЭлектроннойПочты, СтрокаДерева.РодительСсылка);
	Если Не ЗначениеЗаполнено(Родитель) И ЗначениеЗаполнено(СтрокаДерева.ВидПапкиЭлектроннойПочты1СРодителя) Тогда
		Родитель = ПолучитьПапкуЭлектронныхПисемПоВиду(УчетнаяЗаписьЭлектроннойПочты, СтрокаДерева.ВидПапкиЭлектроннойПочты1СРодителя);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Родитель) Тогда
		// Создаем папку в корне
		Родитель = Справочники.ПапкиЭлектронныхПисем.ПустаяСсылка();
	КонецЕсли;
	
	Объект = Справочники.ПапкиЭлектронныхПисем.СоздатьЭлемент();
	Объект.Владелец			= УчетнаяЗаписьЭлектроннойПочты;
	Объект.Родитель			= Родитель;
	Объект.CRM_ПапкаMSExchange	= СтрокаДерева.Ссылка;
	Объект.CRM_Вид				= СтрокаДерева.ВидПапкиЭлектроннойПочты1С;
	Объект.Наименование		= СтрокаДерева.DisplayName;
	Объект.Записать();
	
КонецПроцедуры

Процедура ДобавитьПапкиMSExchangeРекурсивно(Строки, УчетнаяЗаписьЭлектроннойПочты)
	Если Не ЗначениеЗаполнено(УчетнаяЗаписьЭлектроннойПочты) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаДерева Из Строки Цикл
		Папка = ПолучитьПапкуЭлектронныхПисемПоПапкеMSExchange(УчетнаяЗаписьЭлектроннойПочты, СтрокаДерева.Ссылка);
		Если Не ЗначениеЗаполнено(Папка) И ЗначениеЗаполнено(СтрокаДерева.ВидПапкиЭлектроннойПочты1С) Тогда
			Папка = ПолучитьПапкуЭлектронныхПисемПоВиду(УчетнаяЗаписьЭлектроннойПочты, СтрокаДерева.ВидПапкиЭлектроннойПочты1С);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Папка) Тогда
			// Папку нужно добавить
			ДобавитьПапку(УчетнаяЗаписьЭлектроннойПочты, СтрокаДерева);
		КонецЕсли;
		
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			ДобавитьПапкиMSExchangeРекурсивно(СтрокаДерева.Строки, УчетнаяЗаписьЭлектроннойПочты);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли