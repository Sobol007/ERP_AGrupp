
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка"
		И Параметры.Свойство("ТекущаяСтрока") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаСпискаДокументов";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбменеВЕТИС

// Статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Ссылка на документ.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 3.
//
Функция СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала Тогда
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.РассчитатьСтатусыКПередаче(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.КПередаче);
		
	Иначе
		ВызватьИсключение ИнтеграцияВЕТИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Ссылка на документ.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийВЕТИС - Статус обработки сообщения.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 3.
//
Функция СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Если Операция = Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовВЕТИС.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.Обрабатывается;
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОжидайтеЗавершенияОбработкиДанныхВЕТИС);
		
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.РассчитатьСтатусы(
			ДокументСсылка, 
			СтатусОбработки, 
			СтатусыБазовыйПроцесс);
		
	Иначе
		ВызватьИсключение ИнтеграцияВЕТИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после получения данных из ВЕТИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС
//  ДополнительныеПараметры - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 3.
//
Функция СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры) Экспорт
	
	Если Операция = Перечисления.ВидыОперацийВЕТИС.ОтветНаЗапросЗаписейСкладскогоЖурнала Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовВЕТИС.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ЗагруженыОстатки;
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОтклоненВЕТИС;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.РассчитатьСтатусы(
			ДокументСсылка,
			ДополнительныеПараметры.СтатусОбработки,
			СтатусыБазовыйПроцесс);
		
	Иначе
		ВызватьИсключение ИнтеграцияВЕТИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции


// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Ссылка на документ.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
//  ДополнительныеПараметры - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Ссылка на документ.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//  ДополнительныеПараметры - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после получения данных из ВЕТИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
//  ДополнительныеПараметры - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//
Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции


// Получить последовательность операций в течении жизненного цикла документа.
//
// Параметры:
//  ДокументСсылка - документ, для которого требуется обновить статус.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ИнтеграцияВЕТИС.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Таблица   = ИнтеграцияВЕТИС.ПустаяТаблицаПоследовательностьОпераций();
	Исходящий = Перечисления.ТипыЗапросовИС.Исходящий;
	Входящий  = Перечисления.ТипыЗапросовИС.Входящий;
	
	ИнтеграцияВЕТИС.ДобавитьОперациюВПоследовательность(Таблица, 0,
		Исходящий,
		Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала);
	ИнтеграцияВЕТИС.ДобавитьОперациюВПоследовательность(Таблица, 0,
		Входящий,
		Перечисления.ВидыОперацийВЕТИС.ОтветНаЗапросЗаписейСкладскогоЖурнала);
	
	Возврат Таблица;
	
КонецФункции


// Опеределить необходимость перезаписи движений.
//
// Параметры:
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
// 
// Возвращаемое значение:
//  Булево - Необходимость перезаписи движений.
//
Функция ОбновлятьДвижения(ПредыдущийСтатус, НовыйСтатус) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Расчитать новый статуса оформления документов.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Документ, по которому требуется рассчитать статус оформления.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
// 
Процедура РассчитатьСтатусОформления(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус) Экспорт
	
	Если КонечныеСтатусы().Найти(НовыйСтатус) <> Неопределено Тогда
		РасчетСтатусовОформленияВЕТИС.РассчитатьСтатусОформленияДокументаВЕТИС(ДокументСсылка);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик изменения статуса документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Документ.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
//  ПараметрыОбновленияСтатуса - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса) Экспорт
	
	ИнтеграцияВЕТИСПереопределяемый.ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса);
	
	РассчитатьСтатусОформления(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус);
	
КонецПроцедуры

Функция ОперацииДопустимыхДействий() Экспорт
	
	СоответствиеОпераций = Новый Соответствие;
	СоответствиеОпераций.Вставить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные,
		Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала);
	
	Возврат СоответствиеОпераций
	
КонецФункции

#КонецОбласти

#Область Серии

// Имена реквизитов, от значений которых зависят параметры указания серий.
//
// Возвращаемое значение:
//	Строка - Имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	ТипДокумента = ТипДокумента();
	ИменаРеквизитов = ИнтеграцияИС.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(ТипДокумента);
	Возврат ИменаРеквизитов;
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//	Объект - Структура - Значения реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
//  (см. ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыУказанияСерий) - параметры указания серий
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ТипДокумента = ТипДокумента();
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерий(ТипДокумента, Объект);
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//
// Параметры:
//   ПараметрыУказанияСерий - (см. ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыУказанияСерий) - параметры указания серий
//
// Возвращаемое значение:
//   Строка - Текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТипДокумента = ТипДокумента();
	ТекстЗапроса = ИнтеграцияИС.ТекстЗапросаЗаполненияСтатусовУказанияСерий(ТипДокумента, ПараметрыУказанияСерий);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Статусы

// Возвращает статус по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Статус по-умолчанию.
//
Функция СтатусПоУмолчанию() Экспорт
	
	Возврат Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.Черновик;
	
КонецФункции

// Возвращает статусы ошибок.
//
// Возвращаемое значение:
//  Массив - Статусы ошибок.
//
Функция СтатусыОшибок() Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОшибкаПередачи);
	Статусы.Добавить(Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОтклоненВЕТИС);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает конечные статусы.
//
// Возвращаемое значение:
//  Массив - Конечные статусы.
//
Функция КонечныеСтатусы() Экспорт
	
	Статусы = Новый Массив;
	
	Возврат Статусы;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные;
	
КонецФункции

#КонецОбласти

#Область ПанельОбменСВЕТИС

Функция ВсеТребующиеДействия(Все = Ложь) Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
	
	Если Все Или Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхВЕТИС") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ВыполнитеОбмен);
	КонецЕсли;
	
	Возврат МассивДействий;
	
КонецФункции

Функция ВсеТребующиеОжидания(Все = Ложь) Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОжидайтеЗавершенияОбработкиДанныхВЕТИС);
	
	Если Все Или ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхВЕТИС") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	
	Возврат МассивДействий;
	
КонецФункции

#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияВЕТИС

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, ПараметрыПередачи, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПараметрыПередачи.ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные Тогда
		
		Возврат СкладскойЖурналВЕТИСXML(ДокументСсылка, ПараметрыПередачи, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецФункции

Функция СкладскойЖурналВЕТИСXML(ДокументСсылка, ПараметрыПередачи, ДополнительныеПараметры)
	
	ДанныеДокумента = ДанныеЗапросаСкладскогоЖурналаВЕТИС(ДокументСсылка, Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала);
	
	Шапка = ДанныеДокумента.Шапка.Выбрать();
	Шапка.Следующий();
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(Шапка.ХозяйствующийСубъект);
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   Шапка.ХозяйствующийСубъект);
	ПараметрыЗапроса.Вставить("Предприятие",            Шапка.Предприятие);
	ПараметрыЗапроса.Вставить("КоличествоЭлементов",    ПараметрыОбмена.РазмерПорции);
	ПараметрыЗапроса.Вставить("Смещение",               0);
	ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
	ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
	ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", 0);
	ПараметрыЗапроса.Вставить("Документ",               ДокументСсылка);
	ПараметрыЗапроса.Вставить("Версия",                 НомерВерсии);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросЗаписейСкладскогоЖурналаXML(
		Шапка.ХозяйствующийСубъект,
		ПараметрыЗапроса,
		ПараметрыОбмена);
	
	Возврат СообщенияXML;
	
КонецФункции

Функция ДанныеЗапросаСкладскогоЖурналаВЕТИС(ДокументСсылка, Операция)
	
	СписокЗапросов = Новый СписокЗначений;
	
	#Область Версии
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ВЕТИСПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомер
	|ПОМЕСТИТЬ Версии
	|ИЗ
	|	Справочник.ВЕТИСПрисоединенныеФайлы КАК ВЕТИСПрисоединенныеФайлы
	|ГДЕ
	|	ВЕТИСПрисоединенныеФайлы.Документ = &Ссылка
	|	И ВЕТИСПрисоединенныеФайлы.Операция = &Операция
	|	И ВЕТИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)";
	
	СписокЗапросов.Добавить(ТекстЗапроса, "Версии");
	
	#КонецОбласти
	
	#Область Шапка
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Шапка.Номер                         КАК Номер,
	|	Шапка.Дата                          КАК Дата,
	|	Шапка.Идентификатор                 КАК Идентификатор,
	|	ЕСТЬNULL(Версии.ПоследнийНомер, 0)  КАК ПоследнийНомерВерсии,
	|	
	|	&Операция                           КАК Операция,
	|	
	|	Шапка.ХозяйствующийСубъект               КАК ХозяйствующийСубъект,
	|	Шапка.ХозяйствующийСубъект.Идентификатор КАК ХозяйствующийСубъектGUID,
	|	
	|	Шапка.Предприятие                      КАК Предприятие,
	|	Шапка.Предприятие.Идентификатор        КАК ПредприятиеGUID,
	|	
	|	Шапка.Ответственный                    КАК Ответственный,
	|	Шапка.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ЗапросСкладскогоЖурналаВЕТИС КАК Шапка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
	|		ПО (Истина)
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка";
	
	СписокЗапросов.Добавить(ТекстЗапроса, "Шапка");
	
	#КонецОбласти
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",   ДокументСсылка);
	Запрос.УстановитьПараметр("Операция", Операция);
	
	Результат = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, СписокЗапросов, Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДвиженияСерийТоваров(ТекстыЗапроса, Регистры);
	
	ИнтеграцияВЕТИС.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаДвиженияСерийТоваров(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияСерийТоваров";
	
	Если Не ИнтеграцияВЕТИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли; 
	
	ТекстЗапроса = ИнтеграцияВЕТИС.ТекстЗапросаДвижениеСерийТоваров(Метаданные.Документы.ЗапросСкладскогоЖурналаВЕТИС);
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата   КАК Период,
	|	ДанныеШапки.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗапросСкладскогоЖурналаВЕТИС КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

Функция ТипДокумента()
	
	ТипДокумента = Метаданные.Документы.ЗапросСкладскогоЖурналаВЕТИС;
	
	Возврат ТипДокумента;
	
КонецФункции

#КонецОбласти

#КонецЕсли
