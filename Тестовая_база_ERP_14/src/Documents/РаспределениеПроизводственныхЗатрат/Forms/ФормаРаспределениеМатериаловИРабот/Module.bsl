
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Состояние",         ОтборСостояние);
	Параметры.Свойство("ПериодРегистрации", Период);
	
	СтруктураОтборов = Неопределено;
	Если Параметры.Свойство("СтруктураОтборов", СтруктураОтборов) Тогда
		СтруктураБыстрогоОтбора = Новый Структура;
		
		Если СтруктураОтборов.Свойство("Организация", ОтборОрганизация) Тогда
			СтруктураБыстрогоОтбора.Вставить("Организация", ОтборОрганизация);
		КонецЕсли;
		
		Если СтруктураОтборов.Свойство("Подразделение", ОтборПодразделение) Тогда
			СтруктураБыстрогоОтбора.Вставить("Подразделение", ОтборПодразделение);
		КонецЕсли;
		
	Иначе
		Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
		Если СтруктураБыстрогоОтбора = Неопределено Тогда
			Параметры.Свойство("Организация",	ОтборОрганизация);
			Параметры.Свойство("Подразделение",	ОтборПодразделение);
		Иначе
			СтруктураБыстрогоОтбора.Свойство("Организация", ОтборОрганизация);
			СтруктураБыстрогоОтбора.Свойство("Подразделение", ОтборПодразделение);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Параметры.Свойство("ОформитьПроизводствоБезЗаказов") Тогда
		Элементы.ГруппаПроизводствоБезЗаказов.Видимость = Параметры.ОформитьПроизводствоБезЗаказов;
	Иначе
		Элементы.ГруппаПроизводствоБезЗаказов.Видимость = Ложь;
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);
	ОбновитьСостояние();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РаспределениеПроизводственныхЗатрат" Тогда
		
		ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Параметр, "Наличие, Распределить, Распределено");
		ТекущиеДанные.Ссылка = Параметр.Ссылка;
		Расшифровка = ПроизводствоКлиентСервер.РасшифровкаВходящегоОстатка(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Настройки.Удалить("ОтборОрганизация");
		Настройки.Удалить("ОтборПодразделение");
	Иначе
		Если Параметры.Свойство("Подразделение") Тогда
			Настройки["ОтборПодразделение"] = Параметры.Подразделение;
		КонецЕсли;
		Если Параметры.Свойство("Организация") Тогда
			Настройки["ОтборОрганизация"] = Параметры.Организация;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		Настройки["Период"] = Параметры.ПериодРегистрации;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьМатериалы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцСтрокаНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.НачалоВыбораПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, Период, ЭтаФорма, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод <> Неопределено Тогда
		Период = ВыбранныйПериод;
		МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);
	КонецЕсли;
	
	ОчиститьСообщения();
	ЗаполнитьМатериалы();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Период = ДобавитьМесяц(Период, Направление);
	МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);
	
	ОчиститьСообщения();
	ЗаполнитьМатериалы();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	ОчиститьСообщения();
	ЗаполнитьМатериалы();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ОчиститьСообщения();
	ЗаполнитьМатериалы();
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипНоменклатурыПриИзменении(Элемент)
	ОчиститьСообщения();
	ЗаполнитьМатериалы();
КонецПроцедуры

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	ОбновитьСостояние();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояние()
	
	Если ОтборСостояние = "Распределено" Тогда
		Элементы.Материалы.ОтборСтрок = Новый ФиксированнаяСтруктура("ТребуетсяРаспределить", Ложь);
	ИначеЕсли ОтборСостояние = "ТребуетсяРаспределить" Тогда
		Элементы.Материалы.ОтборСтрок = Новый ФиксированнаяСтруктура("ТребуетсяРаспределить", Истина);
	Иначе
		Элементы.Материалы.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаДокументыПроизводстваОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ОткрытьЖурнал(ПараметрыЖурнала());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМатериалы

&НаКлиенте
Процедура ЗатратыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РасшифроватьПоле(Поле.Имя, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	Расшифровка = ПроизводствоКлиентСервер.РасшифровкаВходящегоОстатка(ТекущиеДанные);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНаличиеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если ТекущиеДанные.Наличие > ТекущиеДанные.ВходящийОстаток Тогда
		ТекущиеДанные.Наличие = ТекущиеДанные.ВходящийОстаток;
		ТекстСообщения = НСтр("ru = 'Фактическое наличие материала в кладовой не может превышать входящий остаток.';
								|en = 'Actual material availability in the storeroom cannot exceed the incoming balance.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	ТекущиеДанные.Распределить = ТекущиеДанные.ВходящийОстаток - ТекущиеДанные.Наличие - ТекущиеДанные.Распределено;
	
	СтруктураДанных = СтруктураДокумента();
	ЗаполнитьЗначенияСвойств(СтруктураДанных, ТекущиеДанные);
	СтруктураДанных.Дата = КонецМесяца(Период);
	
	ДокументСсылка = ЗаписатьКРаспределениюВДокумент(СтруктураДанных);
	
	Если ДокументСсылка <> Неопределено Тогда
		ТекущиеДанные.Ссылка = ДокументСсылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОткрытьДокументРаспределения(Команда)
	
	ОткрытьДокументРаспределения();

КонецПроцедуры

&НаКлиенте
Процедура КомандаРасшифроватьПоле(Команда)
	
	ТекущийЭлементЗатраты = Элементы.Материалы.ТекущийЭлемент;
	Если ТекущийЭлементЗатраты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасшифроватьПоле(ТекущийЭлементЗатраты.Имя) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Расшифровка выбранного поля не предусмотрена.';
										|en = 'Explanation of the selected field is not supported.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрытьДвижениеМатериаловПродукцииРабот(Команда)
	
	Отбор = Новый Структура;
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		Отбор.Вставить("Организация", ОтборОрганизация);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборПодразделение) Тогда
		Отбор.Вставить("Подразделение", ОтборПодразделение);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборТипНоменклатуры) Тогда
		Отбор.Вставить("ТипНоменклатуры", ОтборТипНоменклатуры);
	КонецЕсли;
	
	ОткрытьДвижениеМатериаловПродукцииРабот(Отбор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПечатьАктИнвентаризации(Команда)
	
	ПараметрОрганизация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
	Если Элементы.Материалы.ТекущиеДанные <> Неопределено Тогда
		ПараметрОрганизация = Элементы.Материалы.ТекущиеДанные.Организация;
	ИначеЕсли ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ПараметрОрганизация = ОтборОрганизация;
	КонецЕсли;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("Организация",       ПараметрОрганизация);
	ПараметрыПечати.Вставить("Подразделение",     ОтборПодразделение);
	ПараметрыПечати.Вставить("Период",            Период);
	ПараметрыПечати.Вставить("Затраты",           Материалы);
	ПараметрыПечати.Вставить("НовоеПроизводство", Истина);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.РаспределениеПроизводственныхЗатрат", 
		"АктИнвентаризацииМатериаловИПолуфабрикатов", 
		ПараметрОрганизация, 
		Неопределено, 
		ПараметрыПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОчиститьСообщения();
	ЗаполнитьМатериалы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьПроизводствоБезЗаказов(Команда)
	
	//++ НЕ УТ
	ПараметрыФормы = Новый Структура("ПериодРегистрации, Организация", Период, ОтборОрганизация);
	ОткрытьФорму("Обработка.ОформлениеПроизводстваБезЗаказов.Форма.ФормаРабочееМесто", ПараметрыФормы, ЭтаФорма);
	//-- НЕ УТ
	
	Возврат; // в УТ, КА пустой
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#Область ОбработчикиКомандСоздать

&НаКлиенте
Процедура СоздатьАктВыполненныхВнутреннихРабот(Команда)
	СоздатьДокументНаОсновании("АктВыполненныхВнутреннихРабот");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьАктВыполненныхРабот(Команда)
	СоздатьДокументНаОсновании("АктВыполненныхРабот");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратМатериаловИзКладовой(Команда)
	СоздатьДокументНаОсновании("ВозвратМатериаловИзКладовой");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПередачаПродукцииИзКладовой(Команда)
	СоздатьДокументНаОсновании("ПередачаПродукцииИзКладовой");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеремещениеПолуфабрикатов(Команда)
	СоздатьДокументНаОсновании("ПеремещениеПолуфабрикатов");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеализацияТоваровИУслуг(Команда)
	СоздатьДокументНаОсновании("РеализацияТоваровИУслуг");
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Материалы);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Материалы, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Материалы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеФормы

&НаСервере
Процедура ЗаполнитьМатериалы()
	
	ДатаПереходаНаПартионныйУчетВерсии22 = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22();
	
	Если ЗначениеЗаполнено(ДатаПереходаНаПартионныйУчетВерсии22) И ДатаПереходаНаПартионныйУчетВерсии22 > НачалоМесяца(Период) Тогда
		
		Материалы.Очистить();
		
		ТекстОшибки = НСтр("ru = 'В указанном периоде используется партионный учет версии 2.1.
		|Для распределения материалов и работ рекомендуется воспользоваться аналогичным рабочим местом для версии 2.1. Рабочее место доступно в группе ""См. также"" раздела Производство.';
		|en = 'Batch accounting 2.1 is used in the specified periood.
		|It is recommended that you use the same workplace for version 2.1 to allocate materials and works. You can access the workplace from the ""See also"" group of the Production section.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
		Возврат;
		
	КонецЕсли;

	ГраницаДатаОкончания = Новый Граница(КонецМесяца(Период), ВидГраницы.Включая);
	Запрос = Новый Запрос(Документы.РаспределениеПроизводственныхЗатрат.ТекстЗапросаМатериаловИРаботВКладовых());
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДоступныеОрганизации = ДоступныеОрганизации(ОтборОрганизация);
	
	Запрос.УстановитьПараметр("ВсеДвижения",              Истина);
	Запрос.УстановитьПараметр("НачалоПериода",            НачалоМесяца(Период));
	Запрос.УстановитьПараметр("ГраницаОкончаниеПериода",  ГраницаДатаОкончания);
	Запрос.УстановитьПараметр("ОкончаниеПериода",         КонецМесяца(Период));
	Запрос.УстановитьПараметр("ВсеОрганизации",           ДоступныеОрганизации.Количество() = 0);
	Запрос.УстановитьПараметр("Организации",              ДоступныеОрганизации);
	Запрос.УстановитьПараметр("ВсеПодразделения",         Не ЗначениеЗаполнено(ОтборПодразделение));
	Запрос.УстановитьПараметр("Подразделения",            ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОтборПодразделение));
	Запрос.УстановитьПараметр("ВсеТипыНоменклатуры",      Не ЗначениеЗаполнено(ОтборТипНоменклатуры));
	Запрос.УстановитьПараметр("ТипНоменклатуры",          ОтборТипНоменклатуры);
	Запрос.УстановитьПараметр("ВсеАналитики",	           Истина);
	Запрос.УстановитьПараметр("АналитикаУчетаНоменклатуры",Неопределено);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаЗатрат = Запрос.Выполнить().Выгрузить();
	ТаблицаЗатрат.Сортировать("Организация, Подразделение, Склад, Номенклатура, Характеристика, Серия");
	
	Материалы.Загрузить(ТаблицаЗатрат);
	
КонецПроцедуры

&НаСервере
Функция ДоступныеОрганизации(Организация = Неопределено)
	
	СписокОрганизаций = Новый СписокЗначений;
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеСправочника.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК ДанныеСправочника
		|ГДЕ
		|	(ДанныеСправочника.Ссылка = &Организация
		|	ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
		|	И
		|	(ДанныеСправочника.Ссылка <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация))
		|");
		Запрос.УстановитьПараметр("Организация", Организация);
		МассивОрганизаций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");
		СписокОрганизаций.ЗагрузитьЗначения(МассивОрганизаций);
	Иначе
		СписокОрганизаций.Добавить(Организация);
	КонецЕсли;
	Возврат СписокОрганизаций;
	
КонецФункции

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураДокумента()
	
	СтруктураДокумента = Новый Структура("НовоеПроизводство, Дата, Организация, Подразделение, АналитикаУчетаНоменклатуры,
	|Склад, Номенклатура, Характеристика, Серия, СтатусУказанияСерий, Назначение, Ссылка, Распределить");
	
	СтруктураДокумента.НовоеПроизводство = Истина;
	
	Возврат СтруктураДокумента;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьДокументРаспределения()
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Ссылка.Пустая() Тогда
		СтруктураОснования = СтруктураДокумента();
		СтруктураОснования.Дата = КонецМесяца(Период);
		ЗаполнитьЗначенияСвойств(СтруктураОснования, ТекущиеДанные);
		ПараметрыФормы = Новый Структура("Основание", СтруктураОснования);
	ИначеЕсли Не ТекущиеДанные.НовоеПроизводство Тогда
		Текст = НСтр("ru = 'Распределение выполнено документом для производства версии 2.1. Для работы с документом требуется перейти в рабочее место распределения 2.1.
			|Для распределения на производство версии 2.2 существующий документ распределения следует пометить на удаление.';
			|en = 'Allocation is performed by a production document version 2.1. To work with the document, go to the allocation workplace 2.1. 
			|To allocate to production of version 2.2, mark the existent allocation document for deletion.'");
		ПоказатьПредупреждение(, Текст);
		Возврат;
	Иначе
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ВходящийОстаток",  ТекущиеДанные.ВходящийОстаток);
	ПараметрыФормы.Вставить("НачальныйОстаток", ТекущиеДанные.НачальныйОстаток);
	ПараметрыФормы.Вставить("Поступило",        ТекущиеДанные.Поступило);
	ПараметрыФормы.Вставить("Передано",         ТекущиеДанные.Передано);
	
	ОткрытьФорму("Документ.РаспределениеПроизводственныхЗатрат.ФормаОбъекта", ПараметрыФормы, Элементы.Материалы);
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьКРаспределениюВДокумент(СтруктураДанных)
	
	Если ЗначениеЗаполнено(СтруктураДанных.Ссылка) Тогда
		
		ДокументОбъект = СтруктураДанных.Ссылка.ПолучитьОбъект();
		ДокументОбъект.Распределить = СтруктураДанных.Распределить;
		
	Иначе
		
		ДокументОбъект = Документы.РаспределениеПроизводственныхЗатрат.СоздатьДокумент();
		ДокументОбъект.Заполнить(СтруктураДанных);
		
	КонецЕсли;
	
	Попытка
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Возврат ДокументОбъект.Ссылка;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, Ложь, "МатериалыСерия", "Материалы.СтатусУказанияСерий", "Материалы.ТипНоменклатуры");

	// организация не отображается, если включен отбор

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыОрганизация.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборОрганизация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Организации.ПустаяСсылка();

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	// подразделение не отображается, если включен отбор

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыПодразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборПодразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Справочники.СтруктураПредприятия.ПустаяСсылка();

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// кладовая не отображается, если включен отбор по работам

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыСклад.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыНоменклатуры.Работа;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	// количество к распределению выделяется красным

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыРаспределить.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Материалы.Распределить");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтрицательногоЧисла);

	// если распределение не требуется

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыРаспределить.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Материалы.Распределить");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Нстр("ru = '<не требуется>';
																|en = '<not required>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "МатериалыХарактеристика",
																		     "Материалы.ХарактеристикиИспользуются");

	// без назначения, если назначение не заполнено.

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыНазначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Материалы.Назначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Нстр("ru = '<без назначения>';
																|en = '<without assignment>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	// кладовая не указывается для работ

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыСклад.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Материалы.ТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыНоменклатуры.Работа;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Нстр("ru = '<для товаров>';
																|en = '<for goods>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

&НаКлиенте
Функция РасшифроватьПоле(ИмяПоля, СтандартнаяОбработка = Ложь)
	
	Если ИмяПоля = "МатериалыРаспределить" Или ИмяПоля = "МатериалыРаспределено" Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьДокументРаспределения();
	ИначеЕсли ИмяПоля = "МатериалыОстаток" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
		
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура",       ТекущиеДанные.Номенклатура);
		Отбор.Вставить("Характеристика",     ТекущиеДанные.Характеристика);
		Отбор.Вставить("СкладПодразделение", ?(ЗначениеЗаполнено(ТекущиеДанные.Склад), ТекущиеДанные.Склад, ТекущиеДанные.Подразделение));
		Отбор.Вставить("Серия",              ТекущиеДанные.Серия);
		Отбор.Вставить("Назначение",         ТекущиеДанные.Назначение);
		Отбор.Вставить("Организация",        ТекущиеДанные.Организация);
		
		ОткрытьДвижениеМатериаловПродукцииРабот(Отбор);
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьДвижениеМатериаловПродукцииРабот(Отбор)
	
	ПользовательскиеПараметры = Новый Массив;
	СтандартныйПериод = Новый СтандартныйПериод;
	СтандартныйПериод.ДатаНачала = НачалоМесяца(Период);
	СтандартныйПериод.ДатаОкончания = КонецМесяца(Период);
	ПользовательскийПараметр = Новый Структура("Имя, Значение", "Период", СтандартныйПериод);
	ПользовательскиеПараметры.Добавить(ПользовательскийПараметр);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор",                     Отбор);
	ПараметрыФормы.Вставить("ПользовательскиеПараметры", ПользовательскиеПараметры);
	ПараметрыФормы.Вставить("КлючВарианта",              "ДвижениеМатериаловПродукцииРабот");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",   Истина);
	ОткрытьФорму("Отчет.ПроизводственныеЗатратыТМЦ.Форма", ПараметрыФормы, ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументНаОсновании(Тип)
	
	// СтандартныеПодсистемы.ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(,
		"Документ.РаспределениеПроизводственныхЗатрат.Форма.ФормаРаспределениеМатериаловИРабот.СоздатьДокументНаОсновании");
	// Конец СтандартныеПодсистемы.ЗамерПроизводительности
	
	МассивСтрок = Элементы.Материалы.ВыделенныеСтроки;
	
	Если МассивСтрок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыШапки = Новый Структура("Организация, Подразделение, Кладовая");
	Товары = Новый Массив;
	
	ЕстьОшибки					= Ложь;
	ЕстьОшибкиОрганизация		= Ложь;
	ЕстьОшибкиПодразделение		= Ложь;
	ЕстьОшибкиКладовая			= Ложь;
	ЕстьОшибкиТипНоменклатуры	= Ложь;
	ЕстьОшибкиНетДанных			= Ложь;
	ЕстьОшибкиВариантОформления	= Ложь;
	
	ТекОрганизация = Неопределено;
	ТекПодразделение = Неопределено;
	ТекКладовая = Неопределено;
	
	Для Каждого ТекСтрока Из МассивСтрок Цикл
		ТекущиеДанные = Материалы.НайтиПоИдентификатору(ТекСтрока);
		
		Если ТекОрганизация = Неопределено Тогда
			ТекОрганизация = ТекущиеДанные.Организация;
			ТекПодразделение = ТекущиеДанные.Подразделение;
			ТекКладовая = ТекущиеДанные.Склад;
			
			ЗаполнитьЗначенияСвойств(РеквизитыШапки, ТекущиеДанные);
			
			Если Тип = "ВозвратМатериаловИзКладовой"
				ИЛИ Тип = "ПередачаПродукцииИзКладовой"
				ИЛИ Тип = "ПеремещениеПолуфабрикатов" Тогда
				
				РеквизитыШапки.Вставить("Отправитель", ТекущиеДанные.Склад);
				
				Если Тип = "ВозвратМатериаловИзКладовой" Тогда
					РеквизитыШапки.Вставить("ХозяйственнаяОперация",
						ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратМатериаловИзКладовой"));
				КонецЕсли;
				
				Если Тип = "ПередачаПродукцииИзКладовой" Тогда
					РеквизитыШапки.Вставить("ХозяйственнаяОперация",
						ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаПродукцииИзКладовой"));
				КонецЕсли;
				
				Если Тип = "ПеремещениеПолуфабрикатов" Тогда
					РеквизитыШапки.Вставить("ХозяйственнаяОперация",
						ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеремещениеПолуфабрикатов"));
				КонецЕсли;
				
			КонецЕсли;
			
			Если Тип = "РеализацияТоваровИУслуг" Тогда
				РеквизитыШапки.Вставить("Склад", ТекущиеДанные.Склад);
			КонецЕсли;
				
		КонецЕсли;
		
		Если Не ТекОрганизация = ТекущиеДанные.Организация Тогда
			ЕстьОшибки = Истина;
			ЕстьОшибкиОрганизация = Истина;
		КонецЕсли;
		
		Если Не ТекПодразделение = ТекущиеДанные.Подразделение Тогда
			ЕстьОшибки = Истина;
			ЕстьОшибкиПодразделение = Истина;
		КонецЕсли;
		
		Если Не ТекКладовая = ТекущиеДанные.Склад Тогда
			ЕстьОшибки = Истина;
			ЕстьОшибкиКладовая = Истина;
		КонецЕсли;
		
		Если (Тип = "АктВыполненныхВнутреннихРабот"
				ИЛИ Тип = "АктВыполненныхРабот")
			И Не ТекущиеДанные.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда
			ЕстьОшибки = Истина;
			ЕстьОшибкиТипНоменклатуры = Истина;
		КонецЕсли;
		
		Если (Тип = "ВозвратМатериаловИзКладовой"
				ИЛИ Тип = "ПередачаПродукцииИзКладовой"
				ИЛИ Тип = "ПеремещениеПолуфабрикатов")
			И ТекущиеДанные.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда
			ЕстьОшибки = Истина;
			ЕстьОшибкиТипНоменклатуры = Истина;
		КонецЕсли;
		
		Если ТекущиеДанные.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа")
			И Тип = "АктВыполненныхРабот"
			И Не ТекущиеДанные.ВариантОформленияПродажи = ПредопределенноеЗначение("Перечисление.ВариантыОформленияПродажи.АктВыполненныхРабот") Тогда
			ЕстьОшибки = Истина;
			ЕстьОшибкиВариантОформления = Истина;
		КонецЕсли;
		
		Если ТекущиеДанные.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа")
			И Тип = "РеализацияТоваровИУслуг"
			И Не ТекущиеДанные.ВариантОформленияПродажи = ПредопределенноеЗначение("Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг") Тогда
			ЕстьОшибки = Истина;
			ЕстьОшибкиВариантОформления = Истина;
		КонецЕсли;
		
		Если Не ТекущиеДанные.Распределить = 0 Тогда
			СтруктураТовара = Новый Структура("Номенклатура, ТипНоменклатуры, Характеристика,
											|Серия, Назначение, НоменклатураНаименованиеПолное,
											|ХарактеристикаНаименованиеПолное, Количество, КоличествоУпаковок");
			ЗаполнитьЗначенияСвойств(СтруктураТовара, ТекущиеДанные);
			СтруктураТовара.Количество			= ТекущиеДанные.Распределить;
			СтруктураТовара.КоличествоУпаковок	= ТекущиеДанные.Распределить;
			Товары.Добавить(СтруктураТовара);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Товары.Количество() = 0 Тогда
		ЕстьОшибки = Истина;
		ЕстьОшибкиНетДанных = Истина;
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		Если ЕстьОшибкиНетДанных Тогда
			ТекстОшибки = НСтр("ru = 'Отсутствуют строки, требующие распределения.';
								|en = 'No lines that require allocation.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
		Если ЕстьОшибкиОрганизация
				ИЛИ ЕстьОшибкиПодразделение
				ИЛИ ЕстьОшибкиКладовая Тогда
			ТекстОшибки = НСтр("ru = 'В выбранных строках различаются значения:';
								|en = 'Values are different in the selected lines:'");
			
			Если ЕстьОшибкиОрганизация Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.Таб +  НСтр("ru = '- Организаций';
																			|en = '- Companies'");
			КонецЕсли;
			
			Если ЕстьОшибкиПодразделение Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.Таб + НСтр("ru = '- Подразделений';
																			|en = '- Departments'");
			КонецЕсли;
			
			Если ЕстьОшибкиКладовая Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.Таб + НСтр("ru = '- Кладовых';
																			|en = '- Storerooms'");
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
		Если ЕстьОшибкиТипНоменклатуры Тогда
			ТекстОшибки = НСтр("ru = 'Документ не предназначен для отражения движений по выбранной номенклатуре.';
								|en = 'Document is not designed for recording movements for the selected products.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
		Если ЕстьОшибкиВариантОформления Тогда
			ТекстОшибки = НСтр("ru = 'В выбранных строках вариант оформления продажи номенклатуры не соответствует типу оформляемого документа.';
								|en = 'Sale registration option of products in the selected lines does not correspond to the registered document type.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
		ТекстОшибки = НСтр("ru = 'Оформление документа невозможно!';
							|en = 'Cannot register the document.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	Иначе
		ПараметрыОснования = Новый Структура;
		ПараметрыОснования.Вставить("РеквизитыШапки", РеквизитыШапки);
		Если Тип = "АктВыполненныхРабот" Тогда
			ПараметрыОснования.Вставить("Услуги", Товары);
		Иначе
			ПараметрыОснования.Вставить("Товары", Товары);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Основание", ПараметрыОснования);
	
	Если Тип = "АктВыполненныхВнутреннихРабот" Тогда
		ИмяФормыДокумента = "Документ.АктВыполненныхВнутреннихРабот.ФормаОбъекта";
	ИначеЕсли Тип = "АктВыполненныхРабот" Тогда
		ИмяФормыДокумента = "Документ.АктВыполненныхРабот.ФормаОбъекта";
	ИначеЕсли Тип = "ВозвратМатериаловИзКладовой"
			ИЛИ Тип = "ПередачаПродукцииИзКладовой"
			ИЛИ Тип = "ПеремещениеПолуфабрикатов" Тогда
		ИмяФормыДокумента = "Документ.ДвижениеПродукцииИМатериалов.ФормаОбъекта";
	ИначеЕсли Тип = "РеализацияТоваровИУслуг" Тогда
		ИмяФормыДокумента = "Документ.РеализацияТоваровУслуг.ФормаОбъекта";
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыДокумента, ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыЖурнала()
	
	ПараметрыЖурнала = Новый Структура;
	ПараметрыЖурнала.Вставить("КлючНазначенияФормы", "РаспределениеМатериаловИРабот");
	ПараметрыЖурнала.Вставить("ИмяРабочегоМеста", "ЖурналДокументовПроизводства");
	ПараметрыЖурнала.Вставить("СинонимЖурнала",НСтр("ru = 'Документы производства';
													|en = 'Production documents'"));
	ОтборыФормыСписка = Новый Структура;
	ОтборыФормыСписка.Вставить("Период", Новый СтандартныйПериод(НачалоМесяца(Период), КонецМесяца(Период)));
	ОтборыФормыСписка.Вставить("Организация", ОтборОрганизация);
	ОтборыФормыСписка.Вставить("Подразделение", ОтборПодразделение);
	
	ОтборТипыДокументов = Новый СписокЗначений;
	
	ОтборТипыДокументов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.РаспределениеПроизводственныхЗатрат"));
	ОтборыФормыСписка.Вставить("ОтборТипыДокументов", ОтборТипыДокументов);
	
	ОтборХозяйственныеОперации = Новый СписокЗначений;
	ОтборХозяйственныеОперации.Добавить(Перечисления.ХозяйственныеОперации.СписаниеРасходовНаПартииПроизводства);
	ОтборыФормыСписка.Вставить("ОтборХозяйственныеОперации", ОтборХозяйственныеОперации);
	
	ПараметрыЖурнала.Вставить("ОтборыФормыСписка", ОтборыФормыСписка);
	
	Возврат ПараметрыЖурнала;
	
КонецФункции

#КонецОбласти

#КонецОбласти
