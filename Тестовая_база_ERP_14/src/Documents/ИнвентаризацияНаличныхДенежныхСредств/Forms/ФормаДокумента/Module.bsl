
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// Обработчик механизма "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Кассы.Очистить();
	Объект.ПоследнийНомерПКО = "";
	Объект.ПоследнийНомерРКО = "";
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
	Объект.КассоваяКнига = Неопределено;
	КассоваяКнигаПредставление = НСтр("ru = '<Основная кассовая книга организации>';
										|en = '<Main company cash book>'");
	
	ЗаполнитьСписокВыбораКассовыхКниг();
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", Объект.Организация));
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборКассовойКниги", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.КассовыеКниги.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКассовойКниги(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.КассоваяКнига = Результат;
		КассоваяКнигаПредставление = Строка(Объект.КассоваяКнига);
		
		Объект.Кассы.Очистить();
		Объект.ПоследнийНомерПКО = "";
		Объект.ПоследнийНомерРКО = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Объект.КассоваяКнига = Неопределено;
	КассоваяКнигаПредставление = НСтр("ru = '<Основная кассовая книга организации>';
										|en = '<Main company cash book>'");
	
	Объект.Кассы.Очистить();
	Объект.ПоследнийНомерПКО = "";
	Объект.ПоследнийНомерРКО = "";
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.КассоваяКнига = ВыбранноеЗначение;
	
	Если ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.КассовыеКниги.ПустаяСсылка") Тогда
		ВыбранноеЗначение = НСтр("ru = '<Основная кассовая книга организации>';
								|en = '<Main company cash book>'");
	КонецЕсли;
	
	Объект.Кассы.Очистить();
	Объект.ПоследнийНомерПКО = "";
	Объект.ПоследнийНомерРКО = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧасти

&НаКлиенте
Процедура КассыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТаблицы = Элементы.Кассы.ТекущиеДанные;
	
	Если НоваяСтрока И Не Копирование Тогда
		Если Не ИспользоватьНесколькоКасс Тогда
			Если Не ЗначениеЗаполнено(Касса) Тогда
				ПолучитьКассуПоУмолчанию();
			КонецЕсли;
			СтрокаТаблицы.Касса = Касса;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыКассаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Кассы.ТекущиеДанные;
	ТекущаяСтрока.СуммаПоУчету = ОстатокВКассеПоУчету(ТекущаяСтрока.Касса);
	
КонецПроцедуры

&НаКлиенте
Процедура КассыСуммаПоУчетуПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Кассы.ТекущиеДанные;
	ТекущаяСтрока.СуммаРасхождения = ТекущаяСтрока.СуммаПоФакту - ТекущаяСтрока.СуммаПоУчету;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыСуммаФактПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Кассы.ТекущиеДанные;
	ТекущаяСтрока.СуммаРасхождения = ТекущаяСтрока.СуммаПоФакту - ТекущаяСтрока.СуммаПоУчету;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыСтатьяДоходовРасходовПриИзменении(Элемент)
	
	КассыСтатьяДоходовРасходовПриИзмененииСервер(КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура КассыСтатьяДоходовРасходовПриИзмененииСервер(КэшированныеЗначения)
	
	СтрокаТаблицы = Объект.Кассы.НайтиПоИдентификатору(Элементы.Кассы.ТекущаяСтрока);
	
	Если ТипЗнч(СтрокаТаблицы.СтатьяДоходовРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиДоходов") Тогда
		ДоходыИРасходыСервер.СтатьяДоходовПриИзменении(
			Объект, СтрокаТаблицы.СтатьяДоходовРасходов, СтрокаТаблицы.Подразделение, СтрокаТаблицы.АналитикаДоходов);
		СтрокаТаблицы.АналитикаРасходов = Неопределено;
		СтрокаТаблицы.АналитикаРасходовОбязательна = Ложь;
	ИначеЕсли ТипЗнч(СтрокаТаблицы.СтатьяДоходовРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
			Объект, СтрокаТаблицы.СтатьяДоходовРасходов, СтрокаТаблицы.АналитикаРасходов);
		СтрокаТаблицы.АналитикаДоходов = Неопределено;
		СтрокаТаблицы.АналитикаДоходовОбязательна = Ложь;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаДоходовОбязательна", "СтатьяДоходовРасходов, АналитикаДоходов");
	СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаРасходовОбязательна", "СтатьяДоходовРасходов, АналитикаРасходов");
	СтруктураДействий.Вставить("ЗаполнитьТипСтатьи", "СтатьяДоходовРасходов");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура КассыСтатьяДоходовРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Кассы.ТекущиеДанные;
	
	МассивТипов = Новый Массив;
	Если ТекущаяСтрока.СуммаРасхождения > 0 Тогда
		МассивТипов.Добавить(Тип("ПланВидовХарактеристикСсылка.СтатьиДоходов"));
		Элемент.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов, , );
	ИначеЕсли ТекущаяСтрока.СуммаРасхождения < 0 Тогда
		МассивТипов.Добавить(Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов"));
		Элемент.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов, , );
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКассы(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьКассыЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение,
		ЭтаФорма,
		Объект.Кассы,
		СтруктураРеквизитов);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКассыЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаполнитьКассыСервер();
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
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

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ИспользоватьНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	
	ЗаполнитьСписокВыбораКассовыхКниг();
	
	Если ЗначениеЗаполнено(Объект.КассоваяКнига) Тогда
		КассоваяКнигаПредставление = Строка(Объект.КассоваяКнига);
	ИначеЕсли ЗначениеЗаполнено(Объект.Организация) Тогда
		КассоваяКнигаПредставление = НСтр("ru = '<Основная кассовая книга организации>';
											|en = '<Main company cash book>'");
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиДоходов.ЗаполнитьПризнакАналитикаДоходовОбязательна(Объект.Кассы, "СтатьяДоходовРасходов, АналитикаДоходов");
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.Кассы, "СтатьяДоходовРасходов, АналитикаРасходов");
	
	ДоходыИРасходыСервер.ЗаполнитьТипСтатьи(Объект.Кассы, "СтатьяДоходовРасходов");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиДоходов.УстановитьУсловноеОформлениеАналитик(
		УсловноеОформление, Новый Структура("Кассы", "СтатьяДоходовРасходов, АналитикаДоходов"));
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(
		УсловноеОформление, Новый Структура("Кассы", "СтатьяДоходовРасходов, АналитикаРасходов"));
	
	ТипыСтатей = Новый Массив;
	ТипыСтатей.Добавить(1); // Статьи расходов
	ТипыСтатей.Добавить(2); // Статьи доходов
	ДоходыИРасходыСервер.УстановитьУсловноеОформлениеАналитикПриСовместномИспользованииСтатей(ЭтаФорма, "Кассы", ТипыСтатей);
	
	// Подсказка ввода суммы по факту
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КассыСуммаПоФакту.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Кассы.СуммаПоФакту");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для внесения результата>';
																|en = '<for entering result>'"));
	
	// Поле расхождения - недостача
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИзлишекНедостача.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Кассы.СуммаРасхождения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Недостача';
																|en = 'Shortage'"));
	
	// Поле расхождения - излишек
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИзлишекНедостача.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Кассы.СуммаРасхождения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Излишек';
																|en = 'Surplus'"));
	
	// Есть расхождения
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КассыСтатьяДоходовРасходов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Кассы.СуммаРасхождения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Кассы.СтатьяДоходовРасходов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКассовыхКниг()
	
	Справочники.КассовыеКниги.КассовыеКнигиОрганизации(Объект.Организация, Элементы.КассоваяКнига.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКассыСервер()
	
	Объект.Кассы.Очистить();
	Объект.ПоследнийНомерПКО = "";
	Объект.ПоследнийНомерРКО = "";
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Кассы.Ссылка КАК Касса,
	|	Кассы.ВалютаДенежныхСредств КАК Валюта,
	|	ЕСТЬNULL(ДенежныеСредстваНаличные.СуммаОстаток, 0) КАК СуммаПоУчету,
	|	ВЫБОР КОГДА ЕСТЬNULL(ДенежныеСредстваНаличные.СуммаОстаток, 0) > 0 ТОГДА
	|		-ЕСТЬNULL(ДенежныеСредстваНаличные.СуммаОстаток, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаРасхождения
	|	
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ДенежныеСредстваНаличные.Остатки(&ДатаИнвентаризации, Организация = &Организация) КАК ДенежныеСредстваНаличные
	|	ПО
	|		ДенежныеСредстваНаличные.Касса = Кассы.Ссылка
	|		И ДенежныеСредстваНаличные.Организация = &Организация
	|	
	|ГДЕ
	|	Кассы.Владелец = &Организация
	|	И Кассы.КассоваяКнига = &КассоваяКнига
	|	И НЕ Кассы.ПометкаУдаления
	|	
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("КассоваяКнига", Объект.КассоваяКнига);
	Запрос.УстановитьПараметр("ДатаИнвентаризации", Новый Граница(КонецДня(Объект.Дата)));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Отсутствуют кассы для заполнения.';
																|en = 'No cash accounts for population.'"));
		Возврат;
	Иначе
		ТаблицаКасс = РезультатЗапроса.Выгрузить();
		ИнвентаризируемыеКассы = ТаблицаКасс.ВыгрузитьКолонку("Касса");
		Объект.Кассы.Загрузить(ТаблицаКасс);
	КонецЕсли;
	
	// Максимальные номера ордеров
	ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПриходныйКассовыйОрдер.Номер КАК НомерПКО
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|ГДЕ
	|	ПриходныйКассовыйОрдер.Проведен
	|	И ПриходныйКассовыйОрдер.Касса В (&Кассы)
	|	И ПриходныйКассовыйОрдер.Дата <= &ДатаИнвентаризации
	|УПОРЯДОЧИТЬ ПО
	|	ПриходныйКассовыйОрдер.Дата УБЫВ
	|;
	|/////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасходныйКассовыйОрдер.Номер КАК НомерРКО
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Проведен
	|	И РасходныйКассовыйОрдер.Касса В (&Кассы)
	|	И РасходныйКассовыйОрдер.Дата <= &ДатаИнвентаризации
	|УПОРЯДОЧИТЬ ПО
	|	РасходныйКассовыйОрдер.Дата УБЫВ
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Кассы", ИнвентаризируемыеКассы);
	Запрос.УстановитьПараметр("ДатаИнвентаризации", КонецДня(Объект.Дата));
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Если Не РезультатЗапроса[0].Пустой() Тогда
		Выборка = РезультатЗапроса[0].Выбрать();
		Выборка.Следующий();
		Объект.ПоследнийНомерПКО = Выборка.НомерПКО;
	КонецЕсли;
	Если Не РезультатЗапроса[1].Пустой() Тогда
		Выборка = РезультатЗапроса[1].Выбрать();
		Выборка.Следующий();
		Объект.ПоследнийНомерРКО = Выборка.НомерРКО;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОстатокВКассеПоУчету(КассаСсылка)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДенежныеСредстваНаличные.СуммаОстаток КАК СуммаПоУчету
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные.Остатки(,Касса = &Касса) КАК ДенежныеСредстваНаличные
	|");
	
	Запрос.УстановитьПараметр("Касса", КассаСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.СуммаПоУчету;
	
КонецФункции

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьКассуПоУмолчанию()
	
	Касса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти
