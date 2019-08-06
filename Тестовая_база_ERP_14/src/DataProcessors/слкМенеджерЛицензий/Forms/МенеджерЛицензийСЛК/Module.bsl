#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВерсияКомпонентыСЛК = слкМенеджерЗащиты.ВерсияКомпонентыСЛК();
	
	ЗаполнитьСерииКлючейЗащитыСервер();
	ОбновитьСтатусыСерийКлючейЗащитыСервер();
	
	Элементы.УправлениеОбщимиНастройками.Доступность = ПравоДоступа("АдминистрированиеДанных", Метаданные);
	Элементы.ТаблицаСерийКлючейЗащитыГруппаОбщиеНастройки.Доступность = ПравоДоступа("АдминистрированиеДанных", Метаданные);
	
	Элементы.ТаблицаСерийКлючейЗащитыОтключить.Видимость = НЕ слкМенеджерЗащитыПовтИсп.ЭтоКлиентСервернаяБаза();
	
	// +CRM
	CRM_СохраненыПерсональныеНастройки = Ложь;
	// -CRM
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "слкИзмененСоставЛицензий" Тогда
		ОбновитьСтатусыСерийКлючейЗащитыСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если Модифицированность Тогда
		
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаСохранитьНастройкиМенеджера", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Сохранить настройки менеджера лицензий?'"), Режим, 0);

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаСерийКлючейЗащитыПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайлыДанныхПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбращениеКМенеджеруЗащиты

&НаКлиенте
Процедура ПроверитьЛицензиюСеанса(Команда)
	
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	СостояниеЛицензииСеанса = слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(ТекущаяСерия.Серия, ОписаниеОшибки, "ПроверитьСтатус");
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		слкМенеджерЗащиты.СообщитьОбОшибкеСЛК(ОписаниеОшибки, ТекущаяСерия.Серия);
	Иначе
		ПоказатьПредупреждение(,"Менеджер лицензий серии ключей " + ТекущаяСерия.Серия + ?(СостояниеЛицензииСеанса, " подключен.", " не подключен."));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключить(Команда)
	
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// +CRM
	Если НЕ CRM_СохраненыПерсональныеНастройки Тогда
		СохранитьНастройкиМенеджераСерииЗащиты(Неопределено);
	КонецЕсли;
	// -CRM
	
	ОписаниеОшибки = "";
	слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(ТекущаяСерия.Серия, ОписаниеОшибки, "ПодключитьЕслиНеЗапущен");
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		слкМенеджерЗащиты.СообщитьОбОшибкеСЛК(ОписаниеОшибки);
	КонецЕсли;
	
	Оповестить("слкИзмененСоставЛицензий");
	
КонецПроцедуры

&НаКлиенте
Процедура Отключить(Команда)
	
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(ТекущаяСерия.Серия, ОписаниеОшибки, "Отключить");
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		слкМенеджерЗащиты.СообщитьОбОшибкеСЛК(ОписаниеОшибки);
	КонецЕсли;
	
	Оповестить("слкИзмененСоставЛицензий");
	
КонецПроцедуры

&НаКлиенте
Процедура СерийныйНомерКлюча(Команда)
	
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	Если слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(ТекущаяСерия.Серия, ОписаниеОшибки, "ПроверитьСтатус") Тогда
		НомерКлюча = слкМенеджерЗащиты.ПолучитьНомерКлюча(ТекущаяСерия.Серия, ОписаниеОшибки);
	Иначе
		ПоказатьПредупреждение(,"Менеджер лицензий серии ключей " + ТекущаяСерия.Серия + " не подключен");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		слкМенеджерЗащиты.СообщитьОбОшибкеСЛК(ОписаниеОшибки, ТекущаяСерия.Серия);
	Иначе
		ПоказатьПредупреждение(,"Серийный номер ключа серии " + ТекущаяСерия.Серия + ", лицензию которого занимает текущий сеанс: " + НомерКлюча);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКлючей(Команда)
		
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	Если слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(ТекущаяСерия.Серия, ОписаниеОшибки, "ПроверитьСтатус") Тогда
		СписокКлючей = слкМенеджерЗащиты.ПолучитьСписокКлючей(ТекущаяСерия.Серия, ОписаниеОшибки);
	Иначе
		ПоказатьПредупреждение(,"Менеджер лицензий серии ключей " + ТекущаяСерия.Серия + " не подключен");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		слкМенеджерЗащиты.СообщитьОбОшибкеСЛК(ОписаниеОшибки, ТекущаяСерия.Серия);
	Иначе
		ПоказатьПредупреждение(,"Список установленных на сервере СЛК ключей серии " + ТекущаяСерия.Серия + ": " + СписокКлючей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрационныеНомераКлючей(Команда)
		
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	Если слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(ТекущаяСерия.Серия, ОписаниеОшибки, "ПроверитьСтатус") Тогда
		РегистрационныеНомераКлючей = слкМенеджерЗащиты.ПолучитьРегНомераКлючей(ТекущаяСерия.Серия, ОписаниеОшибки);
	Иначе
		ПоказатьПредупреждение(,"Менеджер лицензий серии ключей " + ТекущаяСерия.Серия + " не подключен");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		слкМенеджерЗащиты.СообщитьОбОшибкеСЛК(ОписаниеОшибки, ТекущаяСерия.Серия);
	Иначе
		ПоказатьПредупреждение(,"Список регистрационных номеров установленных на сервере СЛК ключей серии " + ТекущаяСерия.Серия + ": " + РегистрационныеНомераКлючей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрационныеНомераОсновныхКлючей(Команда)
		
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	Если слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(ТекущаяСерия.Серия, ОписаниеОшибки, "ПроверитьСтатус") Тогда
		РегистрационныеНомераКлючей = слкМенеджерЗащиты.ПолучитьРегНомераКлючей(ТекущаяСерия.Серия, ОписаниеОшибки, 3);
	Иначе
		ПоказатьПредупреждение(,"Менеджер лицензий серии ключей " + ТекущаяСерия.Серия + " не подключен");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		слкМенеджерЗащиты.СообщитьОбОшибкеСЛК(ОписаниеОшибки, ТекущаяСерия.Серия);
	Иначе
		ПоказатьПредупреждение(,"Список регистрационных номеров установленных на сервере СЛК ключей серии " + ТекущаяСерия.Серия + ": " + РегистрационныеНомераКлючей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЛицензий(Команда)
		
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	Если НЕ слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(ТекущаяСерия.Серия, ОписаниеОшибки, "ПроверитьСтатус") Тогда
		ПоказатьПредупреждение(,"Менеджер лицензий серии ключей " + ТекущаяСерия.Серия + " не подключен.");
		Возврат;
	КонецЕсли;
	
	ПоказатьПредупреждение(,"Количество лицензий ключей серии " + ТекущаяСерия.Серия + ":
		|	- общее: " + слкМенеджерЗащиты.ПолучитьОбщееКоличествоЛицензий(ТекущаяСерия.Серия) + "
		|	- использованных: " + слкМенеджерЗащиты.ПолучитьОбщееКоличествоЛицензий(ТекущаяСерия.Серия, 1) + "
		|	- свободных: " + слкМенеджерЗащиты.ПолучитьОбщееКоличествоЛицензий(ТекущаяСерия.Серия, 2)
		);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ЗаполнитьСерииКлючейЗащиты(Команда)
	ЗаполнитьСерииКлючейЗащитыСервер();
КонецПроцедуры

#Область НастройкиМенеджераЗащиты

&НаКлиенте
Процедура СохранитьНастройкиМенеджераЗащиты(Команда)
	
	СохранитьНастройкиМенеджераЗащитыНаСервере();	
	
	Модифицированность = Ложь;	
	ЗаполнитьСерииКлючейЗащитыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПерсональныеНастройкиМенеджераЗащиты(Команда)
	
	СохранитьНастройкиМенеджераЗащитыНаСервере(Истина);	
	
	Модифицированность = Ложь;	
	ЗаполнитьСерииКлючейЗащитыСервер();
	
	// +CRM
	CRM_СохраненыПерсональныеНастройки = Истина;
	// -CRM
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкиМенеджераЗащиты(Команда)
	
	УдалитьНастройкиМенеджераЗащитыНаСервере();	
	
	Модифицированность = Ложь;	
	ЗаполнитьСерииКлючейЗащитыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПерсональныеНастройкиМенеджераЗащиты(Команда)
	
	УдалитьНастройкиМенеджераЗащитыНаСервере(Истина);	
	
	Модифицированность = Ложь;	
	ЗаполнитьСерииКлючейЗащитыСервер();
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиМенеджераСерииЗащиты

&НаКлиенте
Процедура СохранитьНастройкиМенеджераСерииЗащиты(Команда)
	
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьНастройкиМенеджераСерииЗащитыНаСервере(ТекущаяСерия.Серия);
	
	Модифицированность = Ложь;	
	ЗаполнитьСерииКлючейЗащитыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПерсональныеНастройкиМенеджераСерииЗащиты(Команда)
	
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьНастройкиМенеджераСерииЗащитыНаСервере(ТекущаяСерия.Серия, Истина);
	
	Модифицированность = Ложь;	
	ЗаполнитьСерииКлючейЗащитыСервер();
	
	// +CRM
	CRM_СохраненыПерсональныеНастройки = Истина;
	// -CRM
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкиМенеджераСерииЗащиты(Команда)
	
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьНастройкиМенеджераСерииЗащитыНаСервере(ТекущаяСерия.Серия);
	
	Модифицированность = Ложь;	
	ЗаполнитьСерииКлючейЗащитыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПерсональныеНастройкиМенеджераСерииЗащиты(Команда)
	
	ТекущаяСерия = Элементы.ТаблицаСерийКлючейЗащиты.ТекущиеДанные;
	Если ТекущаяСерия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьНастройкиМенеджераСерииЗащитыНаСервере(ТекущаяСерия.Серия, Истина);
	
	Модифицированность = Ложь;	
	ЗаполнитьСерииКлючейЗащитыСервер();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеЗакрытияВопросаСохранитьНастройкиМенеджера(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;

    СохранитьНастройкиМенеджераЗащитыНаСервере();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСерииКлючейЗащитыСервер(Активные = Истина)

	ТаблицаСерийКлючейЗащиты.Очистить();
	ТаблицаФайлыДанных.Очистить();
	
	МенеджерЗащиты = слкМенеджерЗащитыПовтИсп.ПолучитьМенеджерЗащиты(Истина);
	Для каждого СерияКлючейЗащиты Из МенеджерЗащиты Цикл
		
		СтрокаСерииЗащиты = ТаблицаСерийКлючейЗащиты.Добавить();
		СтрокаСерииЗащиты.Серия = СерияКлючейЗащиты.Ключ;
		СтрокаСерииЗащиты.Наименование = СерияКлючейЗащиты.Значение.Наименование;
		СтрокаСерииЗащиты.ТолькоНаличиеКлюча = СерияКлючейЗащиты.Значение.ТолькоНаличиеКлюча;
		
		ЗаполнитьЗначенияСвойств(СтрокаСерииЗащиты, СерияКлючейЗащиты.Значение.ПараметрыПодключения);
		
		ДобавитьФайлыДанныхСервер(СтрокаСерииЗащиты.Серия, СерияКлючейЗащиты.Значение.ПараметрыПодключения.ФайлыДанных);
	
	КонецЦикла;
	
	ОбновитьСтатусыСерийКлючейЗащитыСервер();

КонецПроцедуры // ЗаполнитьСерииКлючейЗащитыСервер()

&НаСервере
Процедура ДобавитьФайлыДанныхСервер(Серия, ФайлыДанных)
	
	Для каждого ФайлДанных Из ФайлыДанных Цикл
		СтрокаФайлаЗащиты = ТаблицаФайлыДанных.Добавить();
		СтрокаФайлаЗащиты.Серия = Серия;
		СтрокаФайлаЗащиты.Макет = ФайлДанных.Ключ;
		СтрокаФайлаЗащиты.Псевдоним = ФайлДанных.Значение;
	КонецЦикла;
	
КонецПроцедуры // ДобавитьФайлыДанныхСервер()

&НаСервере
Процедура ОбновитьСтатусыСерийКлючейЗащитыСервер()

	Для каждого СерияКлючейЗащиты Из ТаблицаСерийКлючейЗащиты Цикл
		СерияКлючейЗащиты.Запущен = слкМенеджерЗащиты.ПроверитьЛицензиюСеанса(СерияКлючейЗащиты.Серия,, "ПроверитьСтатус");
		
		// Количество ключей по регномерам
		Если СерияКлючейЗащиты.Запущен Тогда
			РегНомераКлючей = слкМенеджерЗащиты.ПолучитьРегНомераКлючей(СерияКлючейЗащиты.Серия);
			Если ЗначениеЗаполнено(РегНомераКлючей) Тогда
				СерияКлючейЗащиты.КоличествоКлючей = СтрРазделить(РегНомераКлючей, ";").Количество();
			Иначе
				СерияКлючейЗащиты.КоличествоКлючей = 0;
			КонецЕсли;
		Иначе
			СерияКлючейЗащиты.КоличествоКлючей = 0;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ОбновитьСтатусЛицензий()

&НаСервере
Процедура СохранитьНастройкиМенеджераЗащитыНаСервере(ПерсональныеНастройки = Ложь)
	
	Для каждого СтрокаСерииКлючейЗащиты Из ТаблицаСерийКлючейЗащиты Цикл
		СохранитьНастройкиМенеджераСерииЗащитыНаСервере(СтрокаСерииКлючейЗащиты.Серия, ПерсональныеНастройки);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНастройкиМенеджераЗащитыНаСервере(ПерсональныеНастройки = Ложь)
	
	Для каждого СтрокаСерииКлючейЗащиты Из ТаблицаСерийКлючейЗащиты Цикл
		УдалитьНастройкиМенеджераСерииЗащитыНаСервере(СтрокаСерииКлючейЗащиты.Серия, ПерсональныеНастройки);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиМенеджераСерииЗащитыНаСервере(Серия, ПерсональныеНастройки = Ложь)
	
	ПараметрыПодключенияСерииКлючейЗащиты = ПолучитьПараметрыПодключенияСерииКлючейЗащиты(Серия);
	Если ПараметрыПодключенияСерииКлючейЗащиты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПерсональныеНастройки Тогда
		слкМенеджерЗащитыСервер.СохранитьПерсональныеНастройкиМенеджераСерииЗащиты(Серия, ПараметрыПодключенияСерииКлючейЗащиты);
	Иначе
		слкМенеджерЗащитыСервер.СохранитьНастройкиМенеджераСерииЗащиты(Серия, ПараметрыПодключенияСерииКлючейЗащиты);		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНастройкиМенеджераСерииЗащитыНаСервере(Серия, ПерсональныеНастройки = Ложь)
	
	Если ПерсональныеНастройки Тогда
		слкМенеджерЗащитыСервер.УдалитьПерсональныеНастройкиМенеджераСерииЗащиты(Серия);
	Иначе
		слкМенеджерЗащитыСервер.УдалитьНастройкиМенеджераСерииЗащиты(Серия);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыПодключенияСерииКлючейЗащиты(Серия)

	ПараметрыПодключения = слкМенеджерЗащитыСервер.ПолучитьНастройкиМенеджераСерииЗащиты();
	
	СтрокиСерииЗащиты = ТаблицаСерийКлючейЗащиты.НайтиСтроки(Новый Структура("Серия", Серия));
	Если СтрокиСерииЗащиты.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокаСерииЗащиты = СтрокиСерииЗащиты[0];
	
	ЗаполнитьЗначенияСвойств(ПараметрыПодключения, СтрокаСерииЗащиты);
	
	// Файлы данных
	ФайлыДанныхСЛК = Новый Соответствие;
	СтрокиФайловДанных = ТаблицаФайлыДанных.НайтиСтроки(Новый Структура("Серия", СтрокаСерииЗащиты.Серия));		
	Для каждого СтрокаФайла Из СтрокиФайловДанных Цикл
		ФайлыДанныхСЛК.Вставить(СтрокаФайла.Макет, СтрокаФайла.Псевдоним);
	КонецЦикла;
	ПараметрыПодключения.ФайлыДанных = ФайлыДанныхСЛК;
	
	Возврат ПараметрыПодключения;
	
КонецФункции // ПолучитьПараметрыПодключенияСерииКлючейЗащитыСервер()

#КонецОбласти