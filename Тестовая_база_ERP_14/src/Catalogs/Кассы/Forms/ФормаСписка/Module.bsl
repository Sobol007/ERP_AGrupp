
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьОтборыСписка();
	
	КассовыеКниги.Параметры.УстановитьЗначениеПараметра(
		"ОсновнаяКассоваяКнига", НСтр("ru = '<Основная кассовая книга организации>';
										|en = '<Main company cash book>'"));
	
	ДоступноСоздание = ПравоДоступа("Изменение", Метаданные.Справочники.Кассы);
	Элементы.СписокСоздатьКассовуюКнигу.Видимость = ДоступноСоздание;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Кассы);
	Элементы.СписокИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Элементы.ОрганизацияОтбор.ТолькоПросмотр Тогда
		Настройки.Удалить("ОрганизацияОтбор");
	Иначе
		ОрганизацияОтбор = Настройки.Получить("ОрганизацияОтбор");
	КонецЕсли;
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КассоваяКнига" Тогда
		Элементы.КассовыеКниги.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.СписокВключитьОтбор.Пометка = ОтборПоКассовойКниге;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииСервер();
	УстановитьОтборКассПоКассовойКниге();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОтборПриИзмененииСервер()
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура КассовыеКнигиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.КассовыеКниги.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассовыеКнигиПриАктивизацииСтроки(Элемент)
	
	Если ОтборПоКассовойКниге Тогда
		ПодключитьОбработчикОжидания("УстановитьОтборКассПоКассовойКниге", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьКассовуюКнигу(Команда)
	
	СтруктураОтбор = Новый Структура;
	СтруктураОтбор.Вставить("Владелец", ОрганизацияОтбор);
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", СтруктураОтбор);
	
	ОткрытьФорму("Справочник.КассовыеКниги.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтбор(Команда)
	
	ОтборПоКассовойКниге = Не ОтборПоКассовойКниге;
	Элементы.СписокВключитьОтбор.Пометка = ОтборПоКассовойКниге;
	
	УстановитьОтборКассПоКассовойКниге();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		КассовыеКниги, "Владелец", ОрганизацияОтбор, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОрганизацияОтбор));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Владелец", ОрганизацияОтбор, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОрганизацияОтбор));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыСписка()
	
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("Организация") Тогда
			ОрганизацияОтбор = Параметры.Отбор.Организация;
			Элементы.ОрганизацияОтбор.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборКассПоКассовойКниге()
	
	ТекущиеДанные = Элементы.КассовыеКниги.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "КассоваяКнига", ТекущиеДанные.Ссылка, ВидСравненияКомпоновкиДанных.Равно,, ОтборПоКассовойКниге);
		Если Не ЗначениеЗаполнено(ОрганизацияОтбор) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Владелец", ТекущиеДанные.Владелец, ВидСравненияКомпоновкиДанных.Равно,, ОтборПоКассовойКниге);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти