
#Область ОписаниеПеременных

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументССылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	ПроверкаКонтрагентовВызовСервераПереопределяемыйУТ.ФормаДокументаПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ИспользоватьКомиссиюПриПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах");
	ИспользоватьПродажуАгентскихУслуг = ПолучитьФункциональнуюОпцию("ИспользоватьПродажуАгентскихУслуг");
	
	УчетНДСУПСлужебный.НастроитьСовместныйВыборКонтрагентовОрганизаций(Элементы.Контрагент);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Поле ""Дата выставления"" не заполнено';
							|en = 'The ""Issue date"" field is not filled in'");
	
	Если Выставлен И НЕ ЗначениеЗаполнено(Объект.ДатаВыставления) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ДатаВыставления","Объект",Отказ);
	ИначеЕсли НЕ Выставлен Тогда
		Объект.ДатаВыставления = '00010101';
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьИнформациюПоСчетуФактуреОснованию();
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПослеЗаписи = ОбменСКонтрагентами.ПараметрыПослеЗаписиНаСервере();
	ПараметрыПослеЗаписи.Форма = ЭтотОбъект;
	ПараметрыПослеЗаписи.ДокументСсылка = Объект.Ссылка;
	ПараметрыПослеЗаписи.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПослеЗаписи.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;

	ОбменСКонтрагентами.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ПараметрыПослеЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами	
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
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

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещения = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	ПараметрыОповещения.Форма = ЭтотОбъект;
	ПараметрыОповещения.ДокументСсылка = Объект.Ссылка;
	ПараметрыОповещения.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыОповещения.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИсправленииПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыставленияПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.ДатаВыставления);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма, Выставлен);
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ДанныеОснования = ПолучитьДанныеОснованияНаСервере(Объект.ДокументОснование);
		Ответ = Неопределено;
		ПоказатьВопрос(Новый ОписаниеОповещения("ДокументОснованиеПриИзмененииЗавершение", ЭтотОбъект, Новый Структура("ДанныеОснования", ДанныеОснования)), НСтр("ru = 'Перезаполнить данные о платежно-расчетном документе?';
																																									|en = 'Refill accounting document data?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ДанныеОснования = ДополнительныеПараметры.ДанныеОснования;
	
	Ответ = РезультатВопроса;
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		ИсключаяСвойства = "НомерПлатежноРасчетногоДокумента,ДатаПлатежноРасчетногоДокумента";
	КонецЕсли; 
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОснования,, ИсключаяСвойства);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.Контрагент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ВыставленПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	УправлениеДоступностью(ЭтаФорма, Выставлен);
	
КонецПроцедуры

&НаКлиенте
Процедура КорректировочныйПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма, Выставлен);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыставленВЭлектронномВидеПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма, Выставлен);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокКодовВидовОпераций.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("КодВидаОперацииНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.КодВидаОперации = ВыбранныйЭлемент.Значение;
		ОбновитьПредставлениеВидаОперации(ЭтаФорма);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЭДОНажатие(Элемент, СтандартнаяОбработка)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ДекорацияСостояниеЭДОНажатие(ЭтотОбъект, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Авансы.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСтавкаНДСПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Авансы.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогообложениеНДСПриИзменении(Элемент)
	
	НалогообложениеНДСПриИзмененииНаСервере();
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

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

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура КППКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СписокВыбораКПП.Количество() = 0 Тогда
		
		Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
			ЗаполнитьСписокВыбораКПП(СписокВыбораКПП, Объект.Контрагент, Объект.Дата);
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеВыбора = СписокВыбораКПП;
	
КонецПроцедуры

&НаКлиенте
Процедура КППКонтрагентаПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ИННКонтрагентаПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	УчетНДСУП.УстановитьУсловноеОформлениеСуммНДСПоНалогообложениюПродажи(ЭтаФорма, "АвансыСтавкаНДС", "АвансыСуммаНДС", "АвансыСуммаНДС");
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АвансыИсходныйСчетФактура.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Корректировочный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаПлатежноРасчетногоДокумента.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НомерПлатежноРасчетногоДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомерПлатежноРасчетногоДокумента.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ДатаПлатежноРасчетногоДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомерИсправления.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, "АвансыХарактеристика", "Объект.Авансы.ХарактеристикиИспользуются");

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииКлючевыхРеквизитовСостояниеЭДО()
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	ПараметрыПриИзменении = ОбменСКонтрагентами.ПараметрыКлючевыеРеквизитыТекстСостоянияЭДОПриИзменении();
	
	ПараметрыПриИзменении.Форма                 = ЭтотОбъект;
	ПараметрыПриИзменении.ДокументСсылка        = Объект.Ссылка;
	ПараметрыПриИзменении.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПриИзменении.ГруппаСостояниеЭДО    = Элементы.ГруппаСостояниеЭДО;
	ПараметрыПриИзменении.Организация           = Объект.Организация;
	ПараметрыПриИзменении.Контрагент            = Объект.Контрагент;
	ПараметрыПриИзменении.Договор               = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	
	ОбменСКонтрагентами.КлючевыеРеквизитыТекстСостоянияЭДОПриИзменении(ПараметрыПриИзменении);
	
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
	ПриИзмененииКлючевыхРеквизитовСостояниеЭДО();
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	УчетНДСУПСлужебный.ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ЭтотОбъект, Объект.Дата, Истина);
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	Выставлен = ЗначениеЗаполнено(Объект.ДатаВыставления);
	УправлениеДоступностью(ЭтаФорма, Выставлен);
	ЗаполнитьСписокКодовВидовОпераций();
	
	УчетНДСУПСлужебный.ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ЭтотОбъект, Объект.Дата);
	
	ПоСчетуФактуре = Объект.Исправление;
	ЕстьПравоНаРедактирование = ПравоДоступа("Изменение", Метаданные.Документы.СчетФактураВыданныйАванс);
	ОбновитьИнформациюПоСчетуФактуреОснованию();
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма, Выставлен)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ЭтоНовый = НЕ ЗначениеЗаполнено(Объект.Ссылка);
	
	ТипОснования = ТипЗнч(Объект.ДокументОснование);
	
	ТолькоПросмотрПоляКонтрагент = (Форма.Выставлен И НЕ ЭтоНовый)
	                               Или Не (ТипОснования = Тип("ДокументСсылка.ВводОстатков")
	                                       Или ТипОснования = Тип("ДокументСсылка.ВзаимозачетЗадолженности"));
	
	ТолькоПросмотрПоляИНН        = (Форма.Выставлен И НЕ ЭтоНовый) 
	                                Или Не ЗначениеЗаполнено(Форма.Объект.Контрагент)
	                                Или ТипЗнч(Форма.Объект.Контрагент) <> Тип("СправочникСсылка.Контрагенты");
	
	ТолькоПросмотрПоляКПП        = ТолькоПросмотрПоляИНН 
	                             Или Не Форма.КонтрагентЮрЛицо;

	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Контрагент", "ТолькоПросмотр", ТолькоПросмотрПоляКонтрагент);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИННКонтрагента", "ТолькоПросмотр", ТолькоПросмотрПоляИНН);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КППКонтрагента", "ТолькоПросмотр", ТолькоПросмотрПоляКПП);
	
	Элементы.ГруппаРеквизитыИсправления.Видимость = Объект.Исправление;
	Элементы.ГруппаНомерДатаПриИсправлении.Видимость = Объект.Исправление;
	Элементы.ГруппаНомерДата.Видимость = Не Объект.Исправление;
	Элементы.АвансыУказатьИсходныйСчетФактуру.Видимость = Объект.Корректировочный;
	
	МассивИменЭлементов = Новый Массив;
	МассивИменЭлементов.Добавить("Номер");
	МассивИменЭлементов.Добавить("Дата");
	МассивИменЭлементов.Добавить("Организация");
	МассивИменЭлементов.Добавить("ДокументОснование");
	МассивИменЭлементов.Добавить("КодВидаОперации");
	МассивИменЭлементов.Добавить("Исправление");
	МассивИменЭлементов.Добавить("Корректировочный");
	МассивИменЭлементов.Добавить("ДатаПлатежноРасчетногоДокумента");
	МассивИменЭлементов.Добавить("НомерПлатежноРасчетногоДокумента");
	МассивИменЭлементов.Добавить("ПравилоОтбораАванса");
	МассивИменЭлементов.Добавить("Авансы");
	МассивИменЭлементов.Добавить("АвансыИтогСумма");
	МассивИменЭлементов.Добавить("АвансыИтогСуммаНДС");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивИменЭлементов, "ТолькоПросмотр", Форма.Выставлен И НЕ ЭтоНовый);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыставленВЭлектронномВиде", "Доступность", Форма.Выставлен);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаВыставления", "Доступность", Форма.Выставлен);
	
	Элементы.ДатаВыставления.АвтоОтметкаНезаполненного = Выставлен;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеОснованияНаСервере(ДокументОснование)

	ДанныеОснования = Документы.СчетФактураВыданныйАванс.ВходящийНомерИДатаДокумента(ДокументОснование);
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями") Тогда
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Контрагент,РасчетыЧерезОтдельногоКонтрагента,Организация");
		Если ЗначенияРеквизитов.РасчетыЧерезОтдельногоКонтрагента Тогда
			Контрагент = ЗначенияРеквизитов.Контрагент;
		Иначе
			Контрагент = ЗначенияРеквизитов.Организация;
		КонецЕсли; 
		ДанныеОснования.Вставить("Контрагент", Контрагент);
		
	ИначеЕсли ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВводОстатков") 
		И ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВзаимозачетЗадолженности") Тогда
		ДанныеОснования.Вставить("Контрагент", ДоходыИРасходыСервер.ПолучитьКонтрагентаИзОснования(ДокументОснование));
	КонецЕсли;
	
	Возврат ДанныеОснования;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчетСуммыНДСВСтрокеТЧ(Объект)

	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("ЦенаВключаетНДС", Истина);
	СтруктураЗаполненияЦены.Вставить("НалогообложениеНДС", Объект.НалогообложениеНДС);
	
	Возврат СтруктураЗаполненияЦены;

КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАвансы

&НаКлиенте
Процедура АвансыПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
	Если Элемент.ТекущийЭлемент = Неопределено ИЛИ ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "АвансыТипЗапасов" Тогда
		СписокВыбора = СписокВыбораТипаЗапасов(ТекущиеДанные.Номенклатура);
		Элементы.АвансыТипЗапасов.СписокВыбора.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения()); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Авансы.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыбора = СписокВыбораТипаЗапасов(ТекущаяСтрока.Номенклатура);
	Если СписокВыбора.НайтиПоЗначению(ТекущаяСтрока.ТипЗапасов) = Неопределено Тогда
		ТекущаяСтрока.ТипЗапасов = СписокВыбора[0].Значение;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЗаказуКлиента(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("РаспределитьАвансыПоТоварам", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПлатежныйДокумент", Объект.ДокументОснование);
	ОткрытьФорму("Документ.СчетФактураВыданныйАванс.Форма.ФормаВыбораТоваровПоЗаказамКлиентов", 
		ПараметрыФормы, , , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьИсходныйСчетФактуру(Команда)
	
	ВыделенныеСтроки = Элементы.Авансы.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() Тогда
		ВыборСчетаФактуры(Ложь, ВыделенныеСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьАвансыПоТоварам(АдресВоВременомХранилище, ДополнительныеПараметры) Экспорт
	
	Если АдресВоВременомХранилище = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаспределитьАвансыПоТоварамНаСервере(АдресВоВременомХранилище);

КонецПроцедуры

&НаСервере
Процедура РаспределитьАвансыПоТоварамНаСервере(АдресВоВременомХранилище)
	
	Товары = ПолучитьИзВременногоХранилища(АдресВоВременомХранилище);
	Авансы = Объект.Авансы.Выгрузить();
	Документы.СчетФактураВыданныйАванс.РаспределитьАвансыПоТоварам(Авансы, Товары, Объект.ДокументОснование);
	Объект.Авансы.Загрузить(Авансы);
	
	Для Каждого СтрокаАвансов Из Объект.Авансы Цикл
		СтрокаАвансов.ИндексНабора = ?(ЗначениеЗаполнено(СтрокаАвансов.НоменклатураНабора), 1, 0);
	КонецЦикла;
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();

КонецПроцедуры

&НаСервере
Функция СписокВыбораТипаЗапасов(Номенклатура)
	
	ТипыЗапасов = Новый СписокЗначений();
	
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда
		ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.Товар);
		Если ИспользоватьКомиссиюПриПродажах Тогда
			ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.КомиссионныйТовар);
		КонецЕсли;
		ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.Услуга);
		Если ИспользоватьПродажуАгентскихУслуг Тогда
			ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.АгентскаяУслуга);
		КонецЕсли;
		Возврат ТипыЗапасов;
	КонецЕсли;
	
	Реквизиты = Новый Структура();
	Реквизиты.Вставить("ТипНоменклатуры",  "ТипНоменклатуры");
	Реквизиты.Вставить("ОсобенностьУчета", "ОсобенностьУчета");
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, Реквизиты);
	
	Если ЗначенияРеквизитов.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
		Если ИспользоватьПродажуАгентскихУслуг
			И (ЗначенияРеквизитов.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПоАгентскойСхеме
				ИЛИ ЗначенияРеквизитов.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Партнером) Тогда
			ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.АгентскаяУслуга);
		Иначе
			ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.Услуга);
		КонецЕсли;
	ИначеЕсли ЗначенияРеквизитов.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
		ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.Услуга);
	Иначе
		ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.Товар);
		Если ИспользоватьКомиссиюПриПродажах Тогда
			ТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.КомиссионныйТовар);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТипыЗапасов;
	
КонецФункции

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ДатаПриИзмененииКлиент()
	
	ДатаПриИзмененииСервер();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	Если Не ЗначениеЗаполнено(Объект.ДатаВыставления) Тогда
		ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправлениеПриИзменении(Элемент)
	
	Если Не Объект.Исправление Тогда
		
		Объект.Номер = "";
		Объект.НомерИсправления = "";
		
		ОчиститьДокументыОснования();
		
	Иначе
		
		ОбновитьИнформациюПоСчетуФактуреОснованию();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСчетФактураОснованиеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "ОткрытьИсходныеСчетаФактуры" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьСчетФактуруОснование();
	ИначеЕсли  НавигационнаяСсылка = "ВыборСчетаФактурыОснования" Тогда
		СтандартнаяОбработка = Ложь;
		ВыборСчетаФактуры();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСчетФактуруОснование()
	
	ПоказатьЗначение(, Объект.СчетФактураОснование);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСчетаФактуры(ВыборОснования = Истина, МассивСтрок = Неопределено)
	
	СтруктураПараметров = Новый Структура;
	
	ЗначениеОтбора = Новый Структура;
	ЗначениеОтбора.Вставить("ПометкаУдаления", Ложь);
	ЗначениеОтбора.Вставить("Проведен", Истина);
	Если ВыборОснования Тогда
		ЗначениеОтбора.Вставить("Исправление", Ложь);
	Иначе
		Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
			ЗначениеОтбора.Вставить("Контрагент", Объект.Контрагент)
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗначениеОтбора.Вставить("ИсключитьСчетФактуру", Объект.Ссылка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗначениеОтбора.Вставить("Организация", Объект.Организация)
	КонецЕсли;
	
	СтруктураПараметров.Вставить("Отбор", ЗначениеОтбора);
	
	ДополнительныеПараметры = Новый Структура("ВыборОснования,МассивСтрок", ВыборОснования, МассивСтрок);
	Оповещение = Новый ОписаниеОповещения("ВыборСчетаФактурыЗавершение", ЭтаФорма, ДополнительныеПараметры);
	
	ОткрытьФорму(
		"Документ.СчетФактураВыданныйАванс.ФормаВыбора",
		СтруктураПараметров,
		ЭтаФорма, , , ,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСчетаФактурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Модифицированность = Истина;
		Если ДополнительныеПараметры.ВыборОснования Тогда
			Объект.СчетФактураОснование = Результат;
			ЗаполнитьНаОснованииСчетаФактуры();
		Иначе
			УказатьИсходныйСчетФактуруВАвансах(Результат, ДополнительныеПараметры.МассивСтрок);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДокументыОснования()
	
	Объект.СчетФактураОснование = Неопределено;
	
	ОбновитьИнформациюПоСчетуФактуреОснованию();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоСчетуФактуреОснованию()
	
	МассивСтрок = Новый Массив;
	
	РазрешеноИзменение = ЕстьПравоНаРедактирование
		И Не (ЗначениеЗаполнено(Объект.Ссылка) И Выставлен);
	
	Если Объект.Исправление И ЗначениеЗаполнено(Объект.СчетФактураОснование) Тогда
		
		РеквизитыСФ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СчетФактураОснование, "Номер, Дата");
		СчетФактураОснованиеПредставление = ПродажиСервер.ПредставлениеСчетаФактуры(РеквизитыСФ.Номер, РеквизитыСФ.Дата);
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			СчетФактураОснованиеПредставление, ,
			ЦветаСтиля.ЦветГиперссылки, ,
			ПолучитьНавигационнуюСсылку(Объект.СчетФактураОснование)));
			
	КонецЕсли;
	
	Если РазрешеноИзменение И Объект.Исправление Тогда
		
		Если ЗначениеЗаполнено(Объект.СчетФактураОснование) Тогда
			
			МассивСтрок.Добавить("   ");
			
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				НСтр("ru = 'Изменить';
					|en = 'Change'"), ,
				ЦветаСтиля.ЦветГиперссылки, ,
				"ВыборСчетаФактурыОснования"));
			
		Иначе
			
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				НСтр("ru = 'Не выбран счет-фактура';
					|en = 'Tax invoice is not selected'"), ,
				WebЦвета.Кирпичный, ,
				"ВыборСчетаФактурыОснования"));
				
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстСчетФактураОснование = Новый ФорматированнаяСтрока(МассивСтрок)
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьИсходныйСчетФактуруВАвансах(ВыбранныйСчетФактура, МассивСтрок)
	
	Для Каждого ИдентификаторСтроки Из МассивСтрок Цикл
		СтрокаАванса = Объект.Авансы.НайтиПоИдентификатору(ИдентификаторСтроки);
		СтрокаАванса.ИсходныйСчетФактура = ВыбранныйСчетФактура;
		СтрокаАванса.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20_120");
		СтрокаАванса.СуммаНДС = СтрокаАванса.Сумма;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаОснованииСчетаФактуры()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьИсправлениеПоСчетуФактуре();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ОбновитьИнформациюПоСчетуФактуреОснованию();
	УчетНДСУПСлужебный.ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ЭтотОбъект, Объект.Дата, Истина);
	
	УправлениеДоступностью(ЭтаФорма, Выставлен);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеВидаОперации(Форма)
	
	ТекущийКод = Форма.СписокКодовВидовОпераций.НайтиПоЗначению(Форма.Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		Форма.ПредставлениеВидаОперации = Сред(ТекущийКод.Представление, 4);
	Иначе
		Форма.ПредставлениеВидаОперации = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовВидовОпераций()
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры,
		СписокКодовВидовОпераций,
		?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	
	ОчиститьДокументыОснования();
	
	УчетНДСУПСлужебный.ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ЭтотОбъект, Объект.Дата, Истина);
	
	УправлениеДоступностью(ЭтотОбъект, Выставлен);
	
	ПриИзмененииКлючевыхРеквизитовСостояниеЭДО();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораКПП(СписокВыбора, Контрагент, ДатаСведений)
	
	УчетНДСУПСлужебный.ЗаполнитьСписокВыбораКППСчетФактурыВыданные(СписокВыбора, Контрагент, ДатаСведений);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Авансы,ПараметрыЗаполненияРеквизитов);
	
	НаборыСервер.ЗаполнитьСлужебныеРеквизиты(ЭтаФорма, "Авансы");
	
КонецПроцедуры

&НаСервере
Процедура НалогообложениеНДСПриИзмененииНаСервере()
	
	Если Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
		Объект.КодВидаОперации = "33";
	Иначе
		Объект.КодВидаОперации = "02";
	КонецЕсли;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",
		Новый Структура("НалогообложениеНДС, Дата", Объект.НалогообложениеНДС, Объект.Дата));
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.Авансы, СтруктураДействий, Неопределено);
	
КонецПроцедуры

#КонецОбласти
