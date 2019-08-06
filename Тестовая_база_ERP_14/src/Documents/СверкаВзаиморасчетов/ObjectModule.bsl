#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	// Очистим табличную часть документа.
	Если ДанныеКонтрагента.Количество() > 0 Тогда
		ДанныеКонтрагента.Очистить();
	КонецЕсли;
	
	Статус = Перечисления.СтатусыСверокВзаиморасчетов.Создана;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЕстьРасхождения = Ложь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьДокументПоДаннымПомощника(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьКорректностьПериода(Отказ);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если ЗначениеЗаполнено(ТипРасчетов) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГруппировкиРасчеты.ТипРасчетов");
	КонецЕсли;
	Если ЗначениеЗаполнено(Партнер) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДанныеКонтрагента.Партнер");
		МассивНепроверяемыхРеквизитов.Добавить("ГруппировкиРасчеты.Партнер");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Менеджер) Тогда
		Менеджер = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыСверокВзаиморасчетов.Создана;
	КонецЕсли;
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) И НЕ ЗначениеЗаполнено(КонтактноеЛицо) Тогда
		КонтактноеЛицо = ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераКонтрагентаПоУмолчанию(Контрагент);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоДаннымПомощника(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	ДанныеЗаполнения.Вставить("Дата", Дата);
	
	ДанныеДокумента = Документы.СверкаВзаиморасчетов.РеквизитыПоследнегоДокумента(Контрагент);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеДокумента, "ФИОРуководителяКонтрагента, ДолжностьРуководителяКонтрагента");
	
	УстановитьОтборыНаРавенство(ДанныеЗаполнения);
	ЭтотОбъект.НастройкиОтбора = Новый ХранилищеЗначения(ДанныеЗаполнения.НастройкиОтбора);
	
	Документы.СверкаВзаиморасчетов.ЗаполнитьДанныеПоРасчетам(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов.
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыСверокВзаиморасчетов[НовыйСтатус];
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

Процедура ПроверитьКорректностьПериода(Отказ)
	
	Если ЗначениеЗаполнено(НачалоПериода)
	 И ЗначениеЗаполнено(КонецПериода)
	 И НачалоПериода > КонецПериода Тогда
	 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дата начала периода не должна быть больше окончания периода %1';
				|en = 'Period start date cannot exceed period end date %1'"),
			Формат(КонецПериода, "ДЛФ=DD"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"НачалоПериода",
			, // ПутьКДанным
			Отказ);
	 
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОтборыНаРавенство(ДанныеЗаполнения)
	
	ПоляОтбора = Новый Массив();
	ПоляОтбора.Добавить("ТипРасчетов");
	ПоляОтбора.Добавить("Партнер");
	ПоляОтбора.Добавить("Договор");
	ПоляОтбора.Добавить("Организация");
	ПоляОтбора.Добавить("Контрагент");
	
	Отбор = ДанныеЗаполнения.НастройкиОтбора.Отбор;
	Для Каждого ПолеОтбора Из ПоляОтбора Цикл
		ИспользованиеОтбора = Истина;
		Если ПолеОтбора = "ТипРасчетов" Тогда
			ИспользованиеОтбора = ДанныеЗаполнения.РазбиватьПоТипамРасчетов;
			
		ИначеЕсли ПолеОтбора = "Партнер" Тогда
			ИспользованиеОтбора = ДанныеЗаполнения.РазбиватьПоПартнерам;
			
		ИначеЕсли ПолеОтбора = "Договор" Тогда
			ИспользованиеОтбора = ДанныеЗаполнения.РазбиватьПоДоговорам;
			
		КонецЕсли;
		ФинансоваяОтчетностьСервер.УстановитьОтбор(Отбор, ПолеОтбора, ДанныеЗаполнения[ПолеОтбора], ВидСравненияКомпоновкиДанных.Равно, ИспользованиеОтбора);
	КонецЦикла;
	
	ОтборДоговорыБезОборотов = ФинансоваяОтчетностьСервер.НайтиЭлементОтбора(Отбор, "ДоговорыБезОборотов");
	ОтборДоговорыБезОборотов.Использование = ДанныеЗаполнения.ДоговорыБезОборотов;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
