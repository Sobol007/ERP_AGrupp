#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// +SMS4B
	ЗаполнитьСостоянияСообщений();
	// -SMS4B
	
	// +CRM
	CRM_СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// -CRM

	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// +SMS4B
	СостоянияСообщенийРазвернутьВсе();
	// -SMS4B
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

// +SMS4B

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостоянияСообщений

&НаКлиенте
Процедура СостоянияСообщенийПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("СостоянияСообщенийПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СостоянияСообщенийПриАктивизацииСтрокиОбработчикОжидания()
	
	ТекущиеДанные = Элементы.СостоянияСообщений.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СостоянияСообщенийПриИзмененииНаСервере(ТекущиеДанные.Состояние);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// -SMS4B

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// +SMS4B

&НаКлиенте
Процедура СостоянияСообщенийРазвернутьВсе()
	
	СостоянияСообщенийЭлементы = СостоянияСообщений.ПолучитьЭлементы();
	Для Каждого Строка Из СостоянияСообщенийЭлементы Цикл
		ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
		Элементы.СостоянияСообщений.Развернуть(ИдентификаторСтроки, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСостоянияСообщений()
	
	СостоянияСообщенийЭлементы = СостоянияСообщений.ПолучитьЭлементы();
	СостоянияСообщенийЭлементы.Очистить();
	
	СтрокаВсе = СостоянияСообщенийЭлементы.Добавить();
	СтрокаВсе.Состояние = "Все";
	СтрокаВсе.ИндексКартинки = 3;
	
	СтрокаИсходящие = СостоянияСообщенийЭлементы.Добавить();
	СтрокаИсходящие.Состояние = "Исходящие";
	СтрокаИсходящие.ИндексКартинки = 2;
	СтрокаИсходящиеЭлементы = СтрокаИсходящие.ПолучитьЭлементы();
	
	НоваяСтрока = СтрокаИсходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние = Перечисления.СостоянияДокументаСообщениеSMS.Черновик;
	НоваяСтрока.ИндексКартинки = 3;
	
	НоваяСтрока = СтрокаИсходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние = "Отправляется";
	НоваяСтрока.ИндексКартинки = 3;
	
	НоваяСтрока = СтрокаИсходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние = Перечисления.СостоянияДокументаСообщениеSMS.Доставлено;
	НоваяСтрока.ИндексКартинки = 3;
	
	НоваяСтрока = СтрокаИсходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние = Перечисления.СостоянияДокументаСообщениеSMS.НеДоставлено;
	НоваяСтрока.ИндексКартинки = 3;
	
	СтрокаВходящие = СостоянияСообщенийЭлементы.Добавить();
	СтрокаВходящие.Состояние = "Входящие";
	СтрокаВходящие.ИндексКартинки = 1;
	СтрокаВходящиеЭлементы = СтрокаВходящие.ПолучитьЭлементы();
	
	НоваяСтрока = СтрокаВходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние = Перечисления.СостоянияДокументаСообщениеSMS.SMS4B_Получено;
	НоваяСтрока.ИндексКартинки = 3;
	
	НоваяСтрока = СтрокаВходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние = Перечисления.СостоянияДокументаСообщениеSMS.SMS4B_ПолученоЧастично;
	НоваяСтрока.ИндексКартинки = 3;
	
КонецПроцедуры

&НаСервере
Процедура СостоянияСообщенийПриИзмененииНаСервере(Состояние)
	
	Если ТипЗнч(Состояние) = Тип("ПеречислениеСсылка.СостоянияДокументаСообщениеSMS") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Состояние",
			Состояние,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
		
	ИначеЕсли ТипЗнч(Состояние) = Тип("Строка") Тогда
		
		Если Состояние = "Все" Тогда
			СписокСостояний = Новый СписокЗначений;
		ИначеЕсли Состояние = "Отправляется" Тогда
			СписокСостояний = Новый СписокЗначений;
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.Исходящее);
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.Доставляется);
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.ЧастичноДоставлено);
		ИначеЕсли Состояние = "Исходящие" Тогда
			СписокСостояний = Новый СписокЗначений;
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.Черновик);
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.Исходящее);
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.Доставляется);
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.Доставлено);
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.ЧастичноДоставлено);
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.НеДоставлено);
		ИначеЕсли Состояние = "Входящие" Тогда
			СписокСостояний = Новый СписокЗначений;
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.SMS4B_Получено);
			СписокСостояний.Добавить(Перечисления.СостоянияДокументаСообщениеSMS.SMS4B_ПолученоЧастично);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Состояние",
			СписокСостояний,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			СписокСостояний.Количество() > 0);
		
	КонецЕсли;
	
КонецПроцедуры

// -SMS4B


&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	CRM_СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры


// +Рабочий стол
#Область Подключаемый_РабочийСтол

&НаКлиенте
Процедура Подключаемый_ПолеHTMLНапоминанийПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	CRM_РабочийСтолКлиент.ПолеHTMLНапоминанийПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_ПолеHTMLНапоминанийПриНажатии()

&НаКлиенте
Процедура Подключаемый_ПолеHTMLЗаметокПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	CRM_РабочийСтолКлиент.ПолеHTMLЗаметокПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_ПолеHTMLЗаметокПриНажатии()

#КонецОбласти
// -Рабочий стол

#КонецОбласти

