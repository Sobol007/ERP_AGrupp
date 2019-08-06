
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЭтоРасчетыСКлиентами = Параметры.ЭтоРасчетыСКлиентами;
	
	Если Не ЭтоРасчетыСКлиентами Тогда
		Заголовок = НСтр("ru = 'Выбор документа расчетов с поставщиком';
						|en = 'Select a document for settlements with a supplier'");
		Элементы.ДанныеКонтрагента.Заголовок = НСтр("ru = 'Данные поставщика';
													|en = 'Supplier data'");
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Партнер") Тогда
		
		Партнер = Параметры.Отбор.Партнер;
		
		СписокПартнеров = Новый СписокЗначений;
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Партнер, СписокПартнеров);
		
		Параметры.Отбор.Партнер = СписокПартнеров;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Контрагент") Тогда
		
		Контрагент = Параметры.Отбор.Контрагент;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			Если ТипЗнч(Параметры.Отбор.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
				Если ЗначениеЗаполнено(Параметры.Отбор.Контрагент) Тогда
					ПартнерКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Отбор.Контрагент, "Партнер");
				Иначе
					ПартнерКонтрагента = Неопределено;
				КонецЕсли;
				СписокПартнеров = Новый СписокЗначений;
				ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(ПартнерКонтрагента, СписокПартнеров);
				
				Параметры.Отбор.Вставить("Партнер", СписокПартнеров);
			ИначеЕсли ТипЗнч(Параметры.Отбор.Контрагент) = Тип("СправочникСсылка.Организации") Тогда
				Параметры.Отбор.Вставить("Партнер",Справочники.Партнеры.НашеПредприятие);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс")
		И Параметры.Отбор.Свойство("Организация")
		И Параметры.УчитыватьФилиалы Тогда
		
		Организация = Параметры.Отбор.Организация;
		
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ГоловнаяОрганизация В (&Организация)
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", Организация);
		ДоступныеОрганизации = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		Если ТипЗнч(Организация) = Тип("Массив") Тогда // В качестве отбора передано несколько организаций
			Для Каждого ЭлементОрганизаций Из Организация Цикл 
				ДоступныеОрганизации.Добавить(ЭлементОрганизаций);
			КонецЦикла;
		Иначе
			ДоступныеОрганизации.Добавить(Организация);
		КонецЕсли;
		
		Параметры.Отбор.Организация = ДоступныеОрганизации;
		
	КонецЕсли;
	
	Параметры.Отбор.Свойство("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	Если ЭтоРасчетыСКлиентами Тогда
		
		ПараметрыОтбора = ВзаиморасчетыСервер.ПараметрыОтбораПриВыбореДокументаРасчетовСКлиентами();
		ПараметрыОтбора.ИсключитьРедактируемыйДокумент = Истина;
		ПараметрыОтбора.ЗапретитьДоговорыПоДокументам  = Параметры.ЗапретитьДоговорыПоДокументам;
		
		Если Параметры.Отбор.Свойство("Организация") И Параметры.Отбор.Свойство("Контрагент") Тогда
			ПараметрыОтбора.ОтборПоОрганизацииИКонтрагенту = Истина;
		КонецЕсли;
		
		ТекстЗапроса = ВзаиморасчетыСервер.ПолучитьТекстЗапросаДокументыРасчетовСКлиентами(
			Параметры.ВыборОснованияПлатежа, 
			ПараметрыОтбора);
		Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
			ПараметрыСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
			ПараметрыСписка.ТекстЗапроса = ТекстЗапроса;
			ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, ПараметрыСписка)
		КонецЕсли;
			
		Если Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыборОснованияПлатежа")) <> Неопределено Тогда
			Список.Параметры.УстановитьЗначениеПараметра("ВыборОснованияПлатежа", Параметры.ВыборОснованияПлатежа);
		КонецЕсли;
		
		Если ПараметрыОтбора.ОтборПоОрганизацииИКонтрагенту Тогда
			Список.Параметры.УстановитьЗначениеПараметра("Организация", Параметры.Отбор.Организация);
			Список.Параметры.УстановитьЗначениеПараметра("Контрагент", Параметры.Отбор.Контрагент);
		КонецЕсли;
		
	Иначе
		
		ПараметрыОтбора = ВзаиморасчетыСервер.ПараметрыОтбораПриВыбореДокументаРасчетовСПоставщиками();
		ПараметрыОтбора.ИсключитьРедактируемыйДокумент = Истина;
		ПараметрыОтбора.ИсключитьХозяйственнуюОперацию = Параметры.ИсключитьХозяйственнуюОперацию;
		ПараметрыОтбора.ЗапретитьДоговорыПоДокументам  = Параметры.ЗапретитьДоговорыПоДокументам;
		//++ НЕ УТ
		ПараметрыОтбора.ПлатежиПо275ФЗ                 = Параметры.ПлатежиПо275ФЗ;
		//-- НЕ УТ
		
		Если Параметры.Отбор.Свойство("Организация") И Параметры.Отбор.Свойство("Контрагент") Тогда
			ПараметрыОтбора.ОтборПоОрганизацииИКонтрагенту = Истина;
		КонецЕсли;
		
		ТекстЗапроса = ВзаиморасчетыСервер.ПолучитьТекстЗапросаДокументыРасчетовСПоставщиками(ПараметрыОтбора);
		Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
			ПараметрыСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
			ПараметрыСписка.ТекстЗапроса = ТекстЗапроса;
			ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, ПараметрыСписка);
			Список.Параметры.УстановитьЗначениеПараметра("ОперацииРаздельнойЗакупки", ЗакупкиСервер.ХозяйственныеОперацииРаздельнойЗакупкиБезОтборов());
		КонецЕсли;
		
		Если ПараметрыОтбора.ОтборПоОрганизацииИКонтрагенту Тогда
			Если Список.Параметры.Элементы.Найти("Организация") <> Неопределено Тогда
				Список.Параметры.УстановитьЗначениеПараметра("Организация", Параметры.Отбор.Организация);
			КонецЕсли;
			Если Список.Параметры.Элементы.Найти("Контрагент") <> Неопределено Тогда
				Список.Параметры.УстановитьЗначениеПараметра("Контрагент", Параметры.Отбор.Контрагент);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Список.Параметры.Элементы.Найти("ИсключаемыйДокумент") <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ИсключаемыйДокумент", Параметры.РедактируемыйДокумент);
	КонецЕсли;
	
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	ВалютаУправленческогоУчета = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета();
	
	Валюта = Параметры.Валюта;
	СуммаПлатежа = Параметры.Сумма;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Валюта", "Видимость", ИспользоватьНесколькоВалют);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	РезультатВыбора = РезультатВыбора(СтрокаТаблицы);
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		РезультатВыбора = РезультатВыбора(СтрокаТаблицы);
		ОповеститьОВыборе(РезультатВыбора);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, СтрокаТаблицы.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Функция РезультатВыбора(СтрокаТаблицы)
	
	Если Не ИспользоватьНесколькоВалют Тогда
		ВалютаДокумента = ВалютаУправленческогоУчета;
	Иначе
		ВалютаДокумента = СтрокаТаблицы.Валюта;
	КонецЕсли;
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ОснованиеПлатежа", СтрокаТаблицы.Ссылка);
	РезультатВыбора.Вставить("Заказ", СтрокаТаблицы.ОбъектРасчетов);
	РезультатВыбора.Вставить("Договор", СтрокаТаблицы.Договор);
	РезультатВыбора.Вставить("Партнер", СтрокаТаблицы.Партнер);
	РезультатВыбора.Вставить("ВалютаВзаиморасчетов", ВалютаДокумента);
	РезультатВыбора.Вставить("СуммаВзаиморасчетов", 0);
	РезультатВыбора.Вставить("Дата", СтрокаТаблицы.Дата);
	РезультатВыбора.Вставить("Номер", СтрокаТаблицы.Номер);
	РезультатВыбора.Вставить("Организация", СтрокаТаблицы.Организация);
	
	РезультатВыбора.Вставить("СтавкаНДС", ПредопределенноеЗначение("Перечисление.СтавкиНДС.ПустаяСсылка"));
	РезультатВыбора.Вставить("СуммаНДС", 0);
	РезультатВыбора.Вставить("СуммаЗаказа", СтрокаТаблицы.Сумма);
	
	//++ НЕ УТ
	ПлатежиПо275ФЗ = ?(СтрокаТаблицы.Свойство("ПлатежиПо275ФЗ"), СтрокаТаблицы.ПлатежиПо275ФЗ, Ложь);
	РезультатВыбора.Вставить("ПлатежиПо275ФЗ", ПлатежиПо275ФЗ);
	//-- НЕ УТ
	
	ДополнитьРезультатВыбора(РезультатВыбора);
	
	Возврат РезультатВыбора;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Номер.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Дата.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Тип.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сумма.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Валюта.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Организация.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Партнер.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Контрагент.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Ссылка.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СостояниеДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

КонецПроцедуры

&НаСервере
Процедура ДополнитьРезультатВыбора(РезультатВыбора)
	
	РезультатВыбора.Вставить("СтатьяДвиженияДенежныхСредств",
		ДенежныеСредстваСервер.СтатьяДвиженияДенежныхСредствОбъектаРасчетов(РезультатВыбора.ОснованиеПлатежа, ХозяйственнаяОперация));
	
	ОбъектыРасчетов = Новый Массив;
	ОбъектыРасчетов.Добавить(РезультатВыбора.ОснованиеПлатежа);
	ОбъектыРасчетов.Добавить(РезультатВыбора.Заказ);
	
	ТаблицаНДС = ДенежныеСредстваСервер.РасшифровкаПлатежаНДС(Неопределено, Неопределено, ОбъектыРасчетов, ЭтоРасчетыСКлиентами);
	Если ТаблицаНДС.Количество() = 1 Тогда
		РезультатВыбора.Вставить("СтавкаНДС", ТаблицаНДС[0].СтавкаНДС);
		Если СуммаПлатежа = РезультатВыбора.СуммаЗаказа Тогда
			РезультатВыбора.Вставить("СуммаНДС", ТаблицаНДС[0].СуммаНДС);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
