#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Сотрудник.ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, ПараметрыФормы, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	ВсеПараметры = Новый Структура("Ключ, Основание");
	ЗаполнитьЗначенияСвойств(ВсеПараметры, ПараметрыФормы);
	Если Не ЗначениеЗаполнено(ВсеПараметры.Ключ) Тогда
		УстановитьПривилегированныйРежим(Истина);
		Уведомление = НайтиУведомлениеПоОснованию(ВсеПараметры.Основание);
		УстановитьПривилегированныйРежим(Ложь);
		Если Уведомление.Ссылка <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыФормы.Вставить("Ключ", Уведомление.Ссылка);
			ВыбраннаяФорма = "Документ.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.Форма.ФормаДокумента";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа.
//
// Возвращаемое значение:
//   Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
//
Функция ОписаниеСоставаДокумента() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаФизическоеЛицоВШапке("", "Сотрудник");
КонецФункции

// Вызывается из события "ПередЗаписью" документов, указанных в определяемом типе ДокументыОснованияУведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.
// Устанавливает пометка удаления уведомлений вместе с документом-основанием.
//
// Параметры:
//   ДокументОбъект - ДокументОбъект.* - Документов-основание уведомления.
//
Процедура ПередЗаписьюОснованияУведомления(ДокументОбъект) Экспорт
	Если ДокументОбъект.ЭтоНовый() Тогда
		Возврат; // Для новых документов проверка не нужна.
	КонецЕсли;
	ДокументОснование = ДокументОбъект.Ссылка;
	ПометкаУдаления   = ДокументОбъект.ПометкаУдаления;
	Если ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ПометкаУдаления") Тогда
		Уведомление = НайтиУведомлениеПоОснованию(ДокументОснование, "Ссылка, ПометкаУдаления");
		Если Уведомление.Ссылка <> Неопределено
			И Уведомление.ПометкаУдаления <> ПометкаУдаления
			И УведомлениеДоступноДляИзменения(Уведомление.Ссылка) Тогда
			УведомлениеОбъект = Уведомление.Ссылка.ПолучитьОбъект();
			УведомлениеОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Находит документ "Уведомление о прекращении отпуска по уходу за ребенком" по документу-основанию и возвращает значения его реквизитов.
//
// Параметры:
//   ДокументОснование - ОпределяемыйТип.ДокументыОснованияУведомлениеОПрекращенииОтпускаПоУходуЗаРебенком - Основание уведомления.
//   ИменаРеквизитов - Строка - Имена реквизитов заявления, через запятую.
//
// Возвращаемое значение:
//   Неопределено - Если документ не найден.
//   ВыборкаИзРезультатаЗапроса - Если документ найден.
//
Функция НайтиУведомлениеПоОснованию(ДокументОснование, ИменаРеквизитов = "Ссылка") Экспорт
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат Новый Структура(ИменаРеквизитов);
	КонецЕсли;
	
	Отбор = Новый Структура("ДокументОснование", ДокументОснование);
	
	Запрос = ЗапросПоДокументу(Отбор, ИменаРеквизитов, Истина, Неопределено);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка;
	КонецЕсли;
	
	Возврат Новый Структура(ИменаРеквизитов);
КонецФункции

// Возвращает признак заполненности определяемого типа ДокументыОснованияУведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.
//
// Возвращаемое значение:
//   Булево - Признак заполненности определяемого типа ДокументыОснованияУведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.
//
Функция ИспользоватьЗаполнениеПоОснованию() Экспорт
	МассивТипов = Метаданные.Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.Реквизиты.ДокументОснование.Тип.Типы();
	ТипНеЗаполнен = (МассивТипов.Количество() = 1 И МассивТипов[0] = Тип("Строка"));
	Возврат Не ТипНеЗаполнен;
КонецФункции

// Возвращает запрос по документу с отборам и указанными полями.
Функция ЗапросПоДокументу(Отбор, Поля, ВыбратьПервый, Порядок)
	Запрос = Новый Запрос;
	
	Если Порядок = Неопределено Тогда
		Если ВыбратьПервый Тогда
			Порядок = "ПометкаУдаления ВОЗР, Дата УБЫВ, " + Поля;
		Иначе
			Порядок = Поля;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыбратьПервый Тогда
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	&ИменаПолей КАК ИменаПолей
		|ИЗ
		|	Документ.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком КАК Таблица
		|ГДЕ
		|	&Условия
		|
		|УПОРЯДОЧИТЬ ПО
		|	&ПорядокЗаписей";
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	&ИменаПолей КАК ИменаПолей
		|ИЗ
		|	Документ.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком КАК Таблица
		|ГДЕ
		|	&Условия
		|
		|УПОРЯДОЧИТЬ ПО
		|	&ПорядокЗаписей";
	КонецЕсли;
	
	ФрагментыУсловий = Новый Массив;
	Для Каждого КлючИЗначение Из Отбор Цикл
		ПолеОтбора = КлючИЗначение.Ключ;
		ЗначениеОтбора = КлючИЗначение.Значение;
		Запрос.УстановитьПараметр(ПолеОтбора, ЗначениеОтбора);
		Если ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
			ФрагментыУсловий.Добавить("Таблица." + ПолеОтбора + " В (&" + ПолеОтбора + ")");
		Иначе
			ФрагментыУсловий.Добавить("Таблица." + ПолеОтбора + " = &" + ПолеОтбора + "");
		КонецЕсли;
	КонецЦикла;
	Если ФрагментыУсловий.Количество() > 0 Тогда
		ТекстУсловий = "ГДЕ
		|	" + СтрСоединить(ФрагментыУсловий, Символы.ПС + Символы.Таб + "И ");
	Иначе
		ТекстУсловий = "";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"ГДЕ
		|	&Условия",
		ТекстУсловий);
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ИменаПолей КАК ИменаПолей",
		Поля);
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ПорядокЗаписей",
		Порядок);
	
	Возврат Запрос;
КонецФункции

// Объект можно изменять если он не использован в реестрах, отправленных в ФСС.
Функция УведомлениеДоступноДляИзменения(Ссылка, ВозвращатьТекстОшибки = Ложь) Экспорт
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат ?(ВозвращатьТекстОшибки, "", Истина);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Уведомление", Ссылка);
	Запрос.УстановитьПараметр("Статусы", Перечисления.СтатусыЗаявленийИРеестровНаВыплатуПособий.СтатусыНеПозволяющиеРедактироватьДокументы());
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтрокиРеестров.Ссылка КАК Реестр,
	|	СтрокиРеестров.Ссылка.СтатусДокумента КАК СтатусРеестра
	|ИЗ
	|	Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СведенияНеобходимыеДляНазначенияПособий КАК СтрокиРеестров
	|ГДЕ
	|	СтрокиРеестров.ПервичныйДокумент = &Уведомление
	|	И СтрокиРеестров.Ссылка.СтатусДокумента В(&Статусы)";
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаРеестров = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	УведомлениеМожноИзменять = (ТаблицаРеестров.Количество() = 0);
	
	Если ВозвращатьТекстОшибки Тогда
		Если УведомлениеМожноИзменять Тогда
			ТекстОшибки = "";
		Иначе
			МассивРеестров = Новый Массив;
			Для Каждого СтрокаТаблицы Из ТаблицаРеестров Цикл
				МассивРеестров.Добавить(СтрШаблон(НСтр("ru = '%1 со статусом %2';
														|en = '%1 with the %2 status'"), СтрокаТаблицы.Реестр, СтрокаТаблицы.СтатусРеестра));
			КонецЦикла;
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Запрещено изменять %1, поскольку оно уже отправлено в ФСС (%2).';
										|en = 'Cannot change %1 as it has already been sent to SSF (%2).'"), Ссылка, СтрСоединить(МассивРеестров, "; "));
		КонецЕсли;
		Возврат ТекстОшибки;
	Иначе
		Возврат УведомлениеМожноИзменять;
	КонецЕсли;
КонецФункции

Функция ДанныеОДетях(Уведомление, Сотрудник, ДатаПрекращенияОплаты) Экспорт
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("ДатаПрекращенияОплаты", ДатаПрекращенияОплаты);
	Запрос.УстановитьПараметр("ЕжемесячноеПособиеПоУходуЗаРебенком", Перечисления.ПособияНазначаемыеФСС.ЕжемесячноеПособиеПоУходуЗаРебенком);
	Запрос.УстановитьПараметр("Уведомление", Уведомление);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Заявления.Ссылка КАК Заявление,
	|	Заявления.ИдентификаторСтрокиОснования КАК ИдентификаторСтрокиОснования,
	|	Заявления.ДокументОснование КАК ДокументОснование,
	|	Заявления.Дата КАК Дата,
	|	Заявления.ИмяРебенка КАК ИмяРебенка,
	|	Заявления.ДатаРожденияРебенка КАК ДатаРожденияРебенка
	|ПОМЕСТИТЬ ВТВсеЗаявления
	|ИЗ
	|	Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК Заявления
	|ГДЕ
	|	Заявления.Сотрудник = &Сотрудник
	|	И Заявления.ВидПособия = &ЕжемесячноеПособиеПоУходуЗаРебенком
	|	И Заявления.ДатаОкончанияОтпускаПоУходуЗаРебенком >= &ДатаПрекращенияОплаты
	|	И Заявления.ДатаНачалаОтпускаПоУходуЗаРебенком <= &ДатаПрекращенияОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВсеЗаявления.ИдентификаторСтрокиОснования КАК ИдентификаторСтрокиОснования,
	|	ВТВсеЗаявления.ДокументОснование КАК ДокументОснование,
	|	МАКСИМУМ(ВТВсеЗаявления.Дата) КАК Дата
	|ПОМЕСТИТЬ ВТМаксимальныеДаты
	|ИЗ
	|	ВТВсеЗаявления КАК ВТВсеЗаявления
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТВсеЗаявления.ИдентификаторСтрокиОснования,
	|	ВТВсеЗаявления.ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Заявления.ИдентификаторСтрокиОснования КАК ИдентификаторСтрокиОснования,
	|	Заявления.ДокументОснование КАК ДокументОснование,
	|	Заявления.ИмяРебенка КАК ИмяРебенка,
	|	Заявления.ДатаРожденияРебенка КАК ДатаРожденияРебенка,
	|	МИНИМУМ(Заявления.Заявление) КАК Заявление
	|ПОМЕСТИТЬ ВТМаксимальныеЗаявления
	|ИЗ
	|	ВТМаксимальныеДаты КАК МаксимальныеДаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВсеЗаявления КАК Заявления
	|		ПО МаксимальныеДаты.ИдентификаторСтрокиОснования = Заявления.ИдентификаторСтрокиОснования
	|			И МаксимальныеДаты.ДокументОснование = Заявления.ДокументОснование
	|			И МаксимальныеДаты.Дата = Заявления.Дата
	|
	|СГРУППИРОВАТЬ ПО
	|	Заявления.ИдентификаторСтрокиОснования,
	|	Заявления.ДокументОснование,
	|	Заявления.ИмяРебенка,
	|	Заявления.ДатаРожденияРебенка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТМаксимальныеЗаявления.ИдентификаторСтрокиОснования КАК ИдентификаторСтрокиОснования,
	|	ВТМаксимальныеЗаявления.ДокументОснование КАК ДокументОснование,
	|	ВТМаксимальныеЗаявления.Заявление КАК Заявление,
	|	ВТМаксимальныеЗаявления.ИмяРебенка КАК ИмяРебенка,
	|	ВТМаксимальныеЗаявления.ДатаРожденияРебенка КАК ДатаРожденияРебенка
	|ИЗ
	|	ВТМаксимальныеЗаявления КАК ВТМаксимальныеЗаявления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ПрекращаемыеЗаявления КАК УведомленияЗаявлений
	|		ПО ВТМаксимальныеЗаявления.Заявление = УведомленияЗаявлений.Заявление
	|			И (УведомленияЗаявлений.Ссылка <> &Уведомление)
	|			И (НЕ УведомленияЗаявлений.Ссылка.ПометкаУдаления)
	|ГДЕ
	|	УведомленияЗаявлений.Ссылка ЕСТЬ NULL";
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеОДетях = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ДанныеОДетях;
КонецФункции

#Область МеханизмФиксацииИзменений

Функция ПараметрыФиксацииВторичныхДанных(Объект) Экспорт
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксацииВторичныхДанных(ФиксируемыеРеквизиты(Объект), , ФиксируемыеТаблицы());
КонецФункции

Функция ФиксируемыеТаблицы()
	ФиксируемыеТаблицы = Новый Структура;
	Возврат ФиксируемыеТаблицы;
КонецФункции

Функция ФиксируемыеРеквизиты(Объект)
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// Реквизиты документа-основания.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "ДокументОснование";
	Шаблон.Используется        = ИспользоватьЗаполнениеПоОснованию() И ЗначениеЗаполнено(Объект.ДокументОснование);
	Шаблон.ИмяГруппы           = "Шапка";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Организация");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Сотрудник");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТипПриказа");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаПриказа");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НомерПриказа");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаПрекращенияОплаты");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли