#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	
	УстановитьДоступ();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ОбновитьКонтрольЗаполненияАналитикиРасходов(ЭтаФорма, Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ОтчетБанкаПоОперациямЭквайринга.Форма.ФормаПодбораПлатежей" Тогда
		
		ПолучитьПлатежиИзХранилища(
			РезультатВыбора.ПодборВходящихПлатежей,
			РезультатВыбора.АдресПлатежейВХранилище);
		РассчитатьСуммуДокумента();
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ОтчетБанкаПоОперациямЭквайринга", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	БанковскийСчетПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура БанковскийСчетПриИзмененииСервер()
	
	СтруктураПараметров = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(Объект.БанковскийСчет);
	Объект.Организация = СтруктураПараметров.Организация;
	Объект.Валюта = СтруктураПараметров.Валюта;
	
	УстановитьЗаголовкиСуммПлатежей();
	
	ЗаполнитьСписокЭквайеров();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	СтатьяРасходовПриИзмененииСервер(КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомиссияПриИзменении(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если АналитикаРасходовЗаказРеализация Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходов = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПокупки

&НаКлиенте
Процедура ПокупкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупкиПослеУдаления(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВозвраты

&НаКлиенте
Процедура ВозвратыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратыПослеУдаления(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборВТабличнуюЧастьВозвраты(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("БанковскийСчет", НСтр("ru = 'Банковский счет';
														|en = 'Bank account'"));
	СтруктураРеквизитов.Вставить("Эквайер", НСтр("ru = 'Эквайер';
												|en = 'Acquirer'"));
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьПодборВТабличнуюЧастьВозвратыЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Неопределено, 
		СтруктураРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборВТабличнуюЧастьВозвратыЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	АдресПлатежейВХранилище = АвтоТест_ПоместитьВозвратыВХранилище();
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресПлатежейВХранилище", АдресПлатежейВХранилище);
	ПараметрыПодбора.Вставить("Организация", Объект.Организация);
	ПараметрыПодбора.Вставить("Валюта", Объект.Валюта);
	ПараметрыПодбора.Вставить("БанковскийСчет", Объект.БанковскийСчет);
	ПараметрыПодбора.Вставить("Эквайер", Объект.Эквайер);
	
	ОткрытьФорму(
		"Документ.ОтчетБанкаПоОперациямЭквайринга.Форма.ФормаПодбораПлатежей",
		ПараметрыПодбора,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборВТабличнуюЧастьПокупки(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("БанковскийСчет", НСтр("ru = 'Банковский счет';
														|en = 'Bank account'"));
	СтруктураРеквизитов.Вставить("Эквайер", НСтр("ru = 'Эквайер';
												|en = 'Acquirer'"));
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьПодборВТабличнуюЧастьПокупкиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Неопределено, 
		СтруктураРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборВТабличнуюЧастьПокупкиЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	АдресПлатежейВХранилище = АвтоТест_ПоместитьПокупкиВХранилище();
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресПлатежейВХранилище", АдресПлатежейВХранилище);
	ПараметрыПодбора.Вставить("Организация", Объект.Организация);
	ПараметрыПодбора.Вставить("Валюта", Объект.Валюта);
	ПараметрыПодбора.Вставить("БанковскийСчет", Объект.БанковскийСчет);
	ПараметрыПодбора.Вставить("Эквайер", Объект.Эквайер);
	ПараметрыПодбора.Вставить("ПодборВходящихПлатежей", Истина);
	
	ОткрытьФорму(
		"Документ.ОтчетБанкаПоОперациямЭквайринга.Форма.ФормаПодбораПлатежей",
		ПараметрыПодбора,
		ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьКонтрольЗаполненияАналитикиРасходов(Форма, КэшированныеЗначения)
	
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна, ЗаполнитьПризнакАналитикаРасходовЗаказРеализация");
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("СтатьяРасходов", Форма.Объект.СтатьяРасходов);
	ДанныеОбъекта.Вставить("АналитикаРасходовОбязательна", Форма.АналитикаРасходовОбязательна);
	ДанныеОбъекта.Вставить("АналитикаРасходовЗаказРеализация", Форма.АналитикаРасходовЗаказРеализация);
	
#Если Клиент Тогда
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ДанныеОбъекта, СтруктураДействий, КэшированныеЗначения);
#Иначе
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ДанныеОбъекта, СтруктураДействий, КэшированныеЗначения);
#КонецЕсли
	
	Форма.АналитикаРасходовОбязательна = ДанныеОбъекта.АналитикаРасходовОбязательна;
	Форма.АналитикаРасходовЗаказРеализация = ДанныеОбъекта.АналитикаРасходовЗаказРеализация;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатьяРасходов.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СуммаКомиссии");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер(КэшированныеЗначения)
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(Объект, Объект.СтатьяРасходов, Объект.АналитикаРасходов);
	УстановитьДоступ();
	
	ОбновитьКонтрольЗаполненияАналитикиРасходов(ЭтаФорма, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ПодборыИОбработкаПроверкиКоличества

// Функция используется в автотесте процесса продаж.
//
&НаСервере
Функция АвтоТест_ПоместитьПокупкиВХранилище() Экспорт 

	АдресПлатежейВХранилище = ПоместитьВоВременноеХранилище(
		Объект.Покупки.Выгрузить(,"ДатаПлатежа, ЭквайринговыйТерминал, КодАвторизации, НомерПлатежнойКарты, Сумма"),
		УникальныйИдентификатор);
		
	Возврат АдресПлатежейВХранилище;
	
КонецФункции

// Функция используется в автотесте процесса продаж.
//
&НаСервере
Функция АвтоТест_ПоместитьВозвратыВХранилище() Экспорт 

	АдресПлатежейВХранилище = ПоместитьВоВременноеХранилище(
		Объект.Возвраты.Выгрузить(,"ДатаПлатежа, ЭквайринговыйТерминал, КодАвторизации, НомерПлатежнойКарты, Сумма"),
		УникальныйИдентификатор);
	
	Возврат АдресПлатежейВХранилище;
	
КонецФункции

&НаСервере
Процедура ПолучитьПлатежиИзХранилища(ПодборВходящихПлатежей, АдресПлатежейВХранилище)

	Если ПодборВходящихПлатежей Тогда
		Объект.Покупки.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	Иначе
		Объект.Возвраты.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьСписокЭквайеров();
	УстановитьЗаголовкиСуммПлатежей();
	
	АналитикаРасходовЗаказРеализация = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиСуммПлатежей()
	
	Элементы.ПокупкиСумма.Заголовок = НСтр("ru = 'Сумма (';
											|en = 'Amount ('") + Строка(Объект.Валюта) + ")";
	Элементы.ВозвратыСумма.Заголовок = НСтр("ru = 'Сумма (';
											|en = 'Amount ('") + Строка(Объект.Валюта) + ")";
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступ()
	
	Элементы.АналитикаРасходов.ТолькоПросмотр = Не ЗначениеЗаполнено(Объект.СтатьяРасходов);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаПокупок = Объект.Покупки.Итог("Сумма");
	Объект.СуммаВозвратов = Объект.Возвраты.Итог("Сумма");
	Объект.СуммаДокумента = Объект.СуммаПокупок
		- Объект.СуммаВозвратов
		- Объект.СуммаКомиссии;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЭквайеров()
	
	МассивЭквайеров = 
		Справочники.ЭквайринговыеТерминалы.ЭквайерыПоБанковскомуСчету(?(ЗначениеЗаполнено(Объект.БанковскийСчет), Объект.БанковскийСчет, Неопределено));
		
	Элементы.Эквайер.СписокВыбора.ЗагрузитьЗначения(МассивЭквайеров);
	Если МассивЭквайеров.Количество() = 1 Тогда
		Объект.Эквайер = МассивЭквайеров[0];
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
