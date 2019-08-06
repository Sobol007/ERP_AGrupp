#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ИспользоватьЗаполнениеПоОснованию() Тогда
		Элементы.ФормаОтменитьВсеИсправления.Видимость = Ложь;
		Элементы.ДокументОснование.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		Параметры.Свойство("Основание", Объект.ДокументОснование);
		ПриПолученииДанныхНаСервере("Объект");
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗаявлениеСотрудникаНаВыплатуПособия" Тогда
		ОбновитьПредставленияСведенийОДетях();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Объект"));
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	Если Не ДокументОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	ОбработатьСообщенияПользователю(ДокументОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Сообщения = ПолучитьСообщенияПользователю(Ложь);
	Для Каждого Сообщение Из Сообщения Цикл
		Сообщение.КлючДанных = Объект.Ссылка;
		Сообщение.ПутьКДанным = "Объект";
		Отказ = Истина;
	КонецЦикла;
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Ложь);
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтотОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтотОбъект, Объект);
	ОбновитьПредставленияСведенийОДетях();
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	СотрудникПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	ДокументОснованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПрекращенияОплатыПриИзменении(Элемент)
	ДатаПрекращенияОплатыПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрекращаемыеЗаявления

&НаКлиенте
Процедура ПрекращаемыеЗаявленияЗаявлениеПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.ПрекращаемыеЗаявления.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущаяСтрока.ПредставлениеРебенка = СведенияОДетяхИзЗаявлений(ТекущаяСтрока.Заявление)[ТекущаяСтрока.Заявление];
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПрекращаемыеЗаявления(Команда)
	ЗаполнитьПрекращаемыеЗаявленияНаСервере(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда) 
	ОтменитьВсеИсправленияНаСервере();
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()
	Объект.ФиксацияИзменений.Очистить();
	ПриПолученииДанныхНаСервере("Объект");
	ЗаполнитьПрекращаемыеЗаявленияНаСервере(Ложь);
КонецПроцедуры

#Область МеханизмФиксацииИзменений

&НаСервере
Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ПараметрыФиксации = Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ПараметрыФиксацииВторичныхДанных(Объект);
	ПараметрыФиксации.Вставить("ОписаниеФормы", ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы());
	
	ОписаниеЭлементовФормы = Новый Соответствие;
	ОписаниеПутиКРеквизитамОбъекта = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	ОписаниеПутиКРеквизитамОбъекта.ПрефиксПути = "Объект";
	Для Каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксации.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеПутиКРеквизитамОбъекта);
	КонецЦикла;
	
	ПараметрыФиксации.ОписаниеФормы.ОписаниеЭлементовФормы = ОписаниеЭлементовФормы;
	Возврат ПараметрыФиксации;
КонецФункции

&НаСервере
Функция ФиксацияБыстрыйПоискРеквизитов()
	БыстрыйПоискРеквизитов = Новый Соответствие; // Ключ - имя элемента, значение - имя реквизита.
	Для Каждого КлючИЗначение Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Значение.ИмяРеквизита;
		Если Элементы.Найти(ИмяРеквизита) <> Неопределено Тогда
			БыстрыйПоискРеквизитов.Вставить(ИмяРеквизита, ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	Возврат БыстрыйПоискРеквизитов;
КонецФункции

&НаСервере
Процедура ОбновитьВторичныеДанныеДокумента()
	Если ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОписанияТЧ = ПараметрыФиксацииВторичныхДанных.ОписанияТЧ;
	Для Каждого ОписаниеТЧ Из ОписанияТЧ Цикл
		ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗаполнитьИдентификаторыФиксТЧ(Объект[ОписаниеТЧ.Ключ]);
	КонецЦикла;
	
	Документ = РеквизитФормыВЗначение("Объект");
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(ЭтотОбъект, Документ);
	
	Если Документ.ОбновитьВторичныеДанныеДокумента() Тогда
		Если ТолькоПросмотр Или Не ПравоДоступа("Изменение", Документ.Метаданные()) Тогда
			ФиксацияВторичныхДанныхВДокументахФормы.ВывестиПредупреждениеОНаличииИзмененийВИсходныхДанныхКоторыеНельзяПрименить(ЭтотОбъект);
		Иначе
			Если Не Документ.ЭтоНовый() Тогда
				ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Истина);
			КонецЕсли;
			ЗначениеВРеквизитФормы(Документ, "Объект");
		КонецЕсли;
	КонецЕсли;
	
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтотОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	ОписаниеЭлементов = ФиксацияБыстрыйПоискРеквизитов();
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтотОбъект, Элемент, ОписаниеЭлементов);
КонецПроцедуры

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	Возврат Не Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.УведомлениеДоступноДляИзменения(Объект.Ссылка);
КонецФункции

#КонецОбласти

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

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

#КонецОбласти

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтотОбъект, ТекущийОбъект, ПараметрыФиксацииВторичныхДанных());
	
	ОписаниеЭлементов = ФиксацияБыстрыйПоискРеквизитов();
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ОписаниеЭлементов);
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Ложь);
	
	ОбновитьВторичныеДанныеДокумента();
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьПрекращаемыеЗаявленияНаСервере(Ложь);
	Иначе
		ОбновитьПредставленияСведенийОДетях();
	КонецЕсли;
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю(ДокументОбъект, Сообщения = Неопределено)
	Если Сообщения = Неопределено Тогда
		Сообщения = ПолучитьСообщенияПользователю(Ложь);
	КонецЕсли;
	Для Каждого Сообщение Из Сообщения Цикл
		// Привязка сообщений к объекту.
		Если Не ЗначениеЗаполнено(Сообщение.КлючДанных)
			И Не ЗначениеЗаполнено(Сообщение.ПутьКДанным)
			И Не СтрНачинаетсяС(Сообщение.Поле, "Объект.") Тогда
			Сообщение.ПутьКДанным = "Объект";
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьДоступность()
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "Организация");
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "Организация");
	ОбновитьВторичныеДанныеДокумента();
	ЗаполнитьПрекращаемыеЗаявленияНаСервере(Ложь);
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "Сотрудник");
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "Сотрудник");
	ОбновитьВторичныеДанныеДокумента();
	ЗаполнитьПрекращаемыеЗаявленияНаСервере(Ложь);
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	ЭтотОбъект.ПараметрыФиксацииВторичныхДанных = ПараметрыФиксацииВторичныхДанных();
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "ДокументОснование");
	ОбновитьВторичныеДанныеДокумента();
	ЗаполнитьПрекращаемыеЗаявленияНаСервере(Ложь);
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ДатаПрекращенияОплатыПриИзмененииНаСервере()
	ОбновитьВторичныеДанныеДокумента();
	ЗаполнитьПрекращаемыеЗаявленияНаСервере(Ложь);
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрекращаемыеЗаявленияНаСервере(ВыводитьОшибкиЗаполнения)
	Объект.ПрекращаемыеЗаявления.Очистить();
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		ОбъектМетаданных = ?(ВыводитьОшибкиЗаполнения, Метаданные.Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком, Неопределено);
		ЗарплатаКадрыОтображениеОшибок.СообщитьОбОшибке(Отказ, ОбъектМетаданных, "Сотрудник", , , "Объект");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.ДатаПрекращенияОплаты) Тогда
		ОбъектМетаданных = ?(ВыводитьОшибкиЗаполнения, Метаданные.Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком, Неопределено);
		ЗарплатаКадрыОтображениеОшибок.СообщитьОбОшибке(Отказ, ОбъектМетаданных, "ДатаПрекращенияОплаты", , , "Объект");
	КонецЕсли;
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОДетях = Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ДанныеОДетях(Объект.Ссылка, Объект.Сотрудник, Объект.ДатаПрекращенияОплаты);
	Для Каждого СтрокаТаблицы Из ДанныеОДетях Цикл
		ТекущаяСтрока = Объект.ПрекращаемыеЗаявления.Добавить();
		ТекущаяСтрока.Заявление = СтрокаТаблицы.Заявление;
		ТекущаяСтрока.ПредставлениеРебенка = ПредставлениеЗаписиОРебенке(СтрокаТаблицы.ИмяРебенка, СтрокаТаблицы.ДатаРожденияРебенка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставленияСведенийОДетях()
	Если Объект.ПрекращаемыеЗаявления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СведенияОДетях = СведенияОДетяхИзЗаявлений(Объект.ПрекращаемыеЗаявления.Выгрузить().ВыгрузитьКолонку("Заявление"));
	Для Каждого ТекущаяСтрока Из Объект.ПрекращаемыеЗаявления Цикл
		ТекущаяСтрока.ПредставлениеРебенка = СведенияОДетях[ТекущаяСтрока.Заявление];
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОДетяхИзЗаявлений(ЗаявлениеИлиМассивЗаявлений)
	Результат = Новый Соответствие;
	
	Если ТипЗнч(ЗаявлениеИлиМассивЗаявлений) = Тип("Массив") Тогда
		МассивЗаявлений = ЗаявлениеИлиМассивЗаявлений;
	Иначе
		МассивЗаявлений = Новый Массив;
		МассивЗаявлений.Добавить(ЗаявлениеИлиМассивЗаявлений);
	КонецЕсли;
	ЗначенияРеквизитовЗаявлений = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивЗаявлений, "ИмяРебенка, ДатаРожденияРебенка");
	
	Для Каждого Заявление Из МассивЗаявлений Цикл
		СведенияОРебенке = ЗначенияРеквизитовЗаявлений[Заявление];
		Если СведенияОРебенке = Неопределено Тогда
			Результат.Вставить(Заявление, "");
		Иначе
			Результат.Вставить(Заявление, ПредставлениеЗаписиОРебенке(СведенияОРебенке.ИмяРебенка, СведенияОРебенке.ДатаРожденияРебенка));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеЗаписиОРебенке(ИмяРебенка, ДатаРожденияРебенка)
	Если Не ЗначениеЗаполнено(ИмяРебенка) Тогда
		Возврат "";
	КонецЕсли;
	Возврат ИмяРебенка + " ("+ Формат(ДатаРожденияРебенка, "ДЛФ=D") +")";
КонецФункции

#КонецОбласти
