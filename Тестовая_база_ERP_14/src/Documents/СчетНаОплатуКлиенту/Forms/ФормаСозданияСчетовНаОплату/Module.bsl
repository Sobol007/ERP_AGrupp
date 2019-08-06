
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОснование = Параметры.ДокументОснование;
	
	Если НЕ ПроверитьВозможностьСозданияСчетовНаОплату(ДокументОснование) Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить счет на оплату на основании документа %1. Расчеты ведутся по накладным.';
				|en = 'It is not required to enter a proforma invoice based on document %1. Settlements are made based on invoices.'"),
			ДокументОснование);
		ВызватьИсключение Текст;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ДокументОснование", ДокументОснование, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	Если ДокументОснование <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(ДокументОснование) Тогда
			
			Заголовок = Заголовок + ": " + ДокументОснование;
			
		Иначе
			
			ТекстДокумент = НСтр("ru = '%ТипДокумента% (новый)';
								|en = '%ТипДокумента% (new)'");
			ТекстДокумент = СтрЗаменить(ТекстДокумент, "%ТипДокумента%", ДокументОснование.Метаданные().Синоним);
			Заголовок = Заголовок + ": " + ТекстДокумент;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ШапкаОснование = Новый Структура("
		|Партнер,
		|Контрагент,
		|Договор,
		|Организация,
		|Валюта,
		|ДокументОснование,
		|СуммаДокумента,
		|НомерДокумента,
		|БанковскийСчет,
		|Префикс,
		|Касса,
		|ФормаОплаты, 
		|КонтактноеЛицо
		|");
		
	УстановитьВидимость();
		
	ОбновитьСервер();
	
	Если ЗначениеЗаполнено(Валюта) Тогда
		
		Элементы.ТаблицаЭтаповСуммаПлатежа.Заголовок = СформироватьЗаголовокКолонкиСВалютой(Элементы.ТаблицаЭтаповСуммаПлатежа.Заголовок, Валюта);
		Элементы.ТаблицаЭтаповСуммаКОплате.Заголовок = СформироватьЗаголовокКолонкиСВалютой(Элементы.ТаблицаЭтаповСуммаКОплате.Заголовок, Валюта);
		Элементы.ТаблицаЭтаповСуммаОплаты.Заголовок  = СформироватьЗаголовокКолонкиСВалютой(Элементы.ТаблицаЭтаповСуммаОплаты.Заголовок, Валюта);
		
	КонецЕсли;
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСчет(Команда)
	
	СформироватьСчет();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРаспечататьСчет(Команда)
	
	СформироватьСчет(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Аннулировать(Команда)
	
	Если Не ОбщегоНазначенияУТКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.Список) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Выделенные в списке счетов на оплату будут аннулированы. Продолжить?';
						|en = 'Those selected in the list of proforma invoices will be canceled. Continue?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("АннулироватьЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура АннулироватьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    КоличествоОбработанных = УстановитьПризнакАннулироваСервер(Элементы.Список.ВыделенныеСтроки);
    
    Если КоличествоОбработанных > 0 Тогда
        
        Элементы.Список.Обновить();
        
        ТекстСообщения = НСтр("ru = '%КоличествоОбработанных% из %КоличествоВсего% выделенных в списке счетов на оплату аннулированы.';
								|en = '%КоличествоОбработанных% from %КоличествоВсего% selected in the account list for payment are canceled.'");
        ТекстСообщения = СтрЗаменить(ТекстСообщения,"%КоличествоОбработанных%", КоличествоОбработанных);
        ТекстСообщения = СтрЗаменить(ТекстСообщения,"%КоличествоВсего%",        Элементы.Список.ВыделенныеСтроки.Количество());
        ПоказатьОповещениеПользователя(НСтр("ru = 'Счета на оплату аннулированы';
											|en = 'Proforma invoices are canceled'"),, ТекстСообщения, БиблиотекаКартинок.Информация32);
        
    Иначе
        
        ТекстСообщения = НСтр("ru = 'Не аннулирован ни один счет на оплату.';
								|en = 'No proforma invoice is canceled.'");
        ПоказатьОповещениеПользователя(НСтр("ru = 'Счета на оплату не аннулированы';
											|en = 'Proforma invoices are not canceled'"),, ТекстСообщения, БиблиотекаКартинок.Информация32);
        
    КонецЕсли;

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтапов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЭтапов.ДатаПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Новый СтандартнаяДатаНачала(ВариантСтандартнойДатыНачала.НачалоЭтогоДня);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЭтапов.Оплачен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтапов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЭтапов.Оплачен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.MediumGray);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповВыбран.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЭтапов.Оплачен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЭтапов.ЭтоЗалогЗаТару");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<залог за тару>';
																|en = '<deposit for package>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЭтаповПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаЭтапов.ЭтапСверхЗаказа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<сверх заказа>';
																|en = '<exceeding the order>'"));

КонецПроцедуры

#Область Прочее

&НаСервереБезКонтекста
Функция УстановитьПризнакАннулироваСервер (Знач СчетаНаОплату)
	
	Возврат Документы.СчетНаОплатуКлиенту.УстановитьПризнакАннулирован(СчетаНаОплату);
	
КонецФункции

&НаСервере
Процедура УстановитьВидимость()
	
	Если ТипЗнч(ДокументОснование) <> Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
	
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДокументОснование, 
			Новый Структура("ПорядокРасчетов", "Договор.ПорядокРасчетов"));
		ОтображатьОплату = СтруктураРеквизитов.ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
		
	Иначе
		
		ОтображатьОплату = Истина;
		
	КонецЕсли;
	
	Элементы.ТаблицаЭтаповСуммаПлатежа.Видимость = ОтображатьОплату;
	Элементы.ТаблицаЭтаповСуммаОплаты.Видимость  = ОтображатьОплату;
	Элементы.ИтогоСуммаПлатежа.Видимость         = ОтображатьОплату;
	Элементы.ИтогоСуммаОплаты.Видимость          = ОтображатьОплату;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСервер()
	
	Если ТипЗнч(ДокументОснование) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка                    КАК Договор,
		|	ДанныеДокумента.Партнер                   КАК Партнер,
		|	ДанныеДокумента.Контрагент                КАК Контрагент,
		|	ДанныеДокумента.Организация               КАК Организация,
		|	ДанныеДокумента.ВалютаВзаиморасчетов      КАК Валюта,
		|	ДанныеДокумента.Ссылка                    КАК ДокументОснование,
		|	0                                         КАК СуммаДокумента,
		|	ДанныеДокумента.Номер                     КАК НомерДокумента,
		|	ДанныеДокумента.БанковскийСчет            КАК БанковскийСчет,
		|	ДанныеДокумента.Организация.Префикс       КАК Префикс,
		|	Неопределено                              КАК Касса,
		|	Неопределено                              КАК ФормаОплаты,
		|	ДанныеДокумента.Ссылка                    КАК Документ,
		|	ДанныеДокумента.ХозяйственнаяОперация     КАК ХозяйственнаяОперация,
		|	ДанныеДокумента.Статус                    КАК Статус,
		|	ДанныеДокумента.КонтактноеЛицо            КАК КонтактноеЛицо,
		|
		|	ВЫБОР КОГДА ДанныеДокумента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.НеСогласован) ТОГДА
		|		ИСТИНА
		|	ИНАЧЕ
		|		ЛОЖЬ
		|	КОНЕЦ                                     КАК ЕстьОшибкиСтатус
		|
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(РасчетыСКлиентами.Период, ДЕНЬ) КАК Период,
		|	СУММА(РасчетыСКлиентами.КОплате) КАК КОплате
		|ПОМЕСТИТЬ ТаблицаРасчеты
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
		|ГДЕ
		|	РасчетыСКлиентами.ЗаказКлиента = &Договор
		|	И РасчетыСКлиентами.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|	И РасчетыСКлиентами.КОплате > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыСКлиентами.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЛОЖЬ                                                КАК Выбран,
		|	ЛОЖЬ                                                КАК Оплачена,
		|	1                                                   КАК ИндексКартинки,
		|	МАКСИМУМ(ТаблицаПериодов.КОплате)                   КАК СуммаПлатежа,
		|
		|	ВЫБОР КОГДА МАКСИМУМ(РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток)
		|			>= СУММА(ТаблицаКОплате.КОплате) ТОГДА
		|		МАКСИМУМ(ТаблицаПериодов.КОплате)
		|	ИНАЧЕ
		|		МАКСИМУМ(РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток)
		|			- (СУММА(ТаблицаКОплате.КОплате) - МАКСИМУМ(ТаблицаПериодов.КОплате))
		|	КОНЕЦ                                               КАК СуммаКОплате,
		|
		|	ТаблицаПериодов.Период                              КАК ДатаПлатежа,
		|
		|	ВЫБОР КОГДА МАКСИМУМ(РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток)
		|			>= СУММА(ТаблицаКОплате.КОплате) ТОГДА
		|		МАКСИМУМ(ТаблицаПериодов.КОплате)
		|	ИНАЧЕ
		|		МАКСИМУМ(РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток)
		|			- (СУММА(ТаблицаКОплате.КОплате) - МАКСИМУМ(ТаблицаПериодов.КОплате))
		|	КОНЕЦ / МАКСИМУМ(РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток)
		|	* 100                                               КАК ПроцентПлатежа,
		|
		|	МАКСИМУМ(ТаблицаПериодов.КОплате) - ВЫБОР КОГДА МАКСИМУМ(РасчетыСКлиентамиОстатки.КОплатеОстаток
		|			- РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток) >= СУММА(ТаблицаКОплате.КОплате) ТОГДА
		|		МАКСИМУМ(ТаблицаПериодов.КОплате)
		|	ИНАЧЕ
		|		МАКСИМУМ(РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток)
		|			- (СУММА(ТаблицаКОплате.КОплате) - МАКСИМУМ(ТаблицаПериодов.КОплате))
		|	КОНЕЦ                                               КАК СуммаОплаты
		|
		|ИЗ
		|	ТаблицаРасчеты КАК ТаблицаПериодов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаРасчеты КАК ТаблицаКОплате
		|		ПО ТаблицаПериодов.Период <= ТаблицаКОплате.Период
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентами.Остатки(, ЗаказКлиента = &Договор) КАК РасчетыСКлиентамиОстатки
		|		ПО ИСТИНА
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаПериодов.Период
		|
		|ИМЕЮЩИЕ
		|	МАКСИМУМ(РасчетыСКлиентамиОстатки.КОплатеОстаток - РасчетыСКлиентамиОстатки.ОплачиваетсяОстаток)
		|		> СУММА(ТаблицаКОплате.КОплате) - МАКСИМУМ(ТаблицаПериодов.КОплате)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаПериодов.Период
		|");
		Запрос.УстановитьПараметр("Договор", ДокументОснование);
		
		МассивРезультатов       = Запрос.ВыполнитьПакет();
		
		Если МассивРезультатов[2].Пустой() Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не требуется вводить счета на оплату. Остаток задолженности по договору %1 равен 0.';
					|en = 'It is not required to enter proforma invoices. Remaining contract debt %1 is 0.'"),
				ДокументОснование);
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		ВыборкаШапка            = МассивРезультатов[0].Выбрать();
		// МассивРезультатов[1] - ТаблицаРасчеты
		ВыборкаЭтаповОплаты     = МассивРезультатов[2].Выбрать();
		
		Если ВыборкаШапка.Следующий() Тогда
			
			ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
				ВыборкаШапка.ДокументОснование,
				ВыборкаШапка.Статус,
				, // ЕстьОшибкиПроведен
				ВыборкаШапка.ЕстьОшибкиСтатус);
			
			ЗаполнитьЗначенияСвойств(ШапкаОснование, ВыборкаШапка);
			Валюта = ВыборкаШапка.Валюта;
			
		КонецЕсли;
		
		ТаблицаЭтапов.Очистить();
		
		Пока ВыборкаЭтаповОплаты.Следующий() Цикл
			
			НоваяСтрокаЭтап = ТаблицаЭтапов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаЭтап, ВыборкаЭтаповОплаты);
			
		КонецЦикла;
			
		ИтогоСуммаКОплате    = ТаблицаЭтапов.Итог("СуммаКОплате");
		ИтогоСуммаОплаты     = ТаблицаЭтапов.Итог("СуммаОплаты");
		ИтогоСуммаПлатежа    = ТаблицаЭтапов.Итог("СуммаПлатежа");
		ИтогоПроцентПлатежа  = ТаблицаЭтапов.Итог("ПроцентПлатежа");
		
		ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
		
		ИтогоОтмеченоКОплате = 0;
		
		Для Каждого ТекущийЭтап Из ТаблицаЭтапов Цикл
			
			Если Не ТекущийЭтап.Оплачен Тогда
				Если ТекущийЭтап.ДатаПлатежа <= ТекущаяДата Тогда
					ТекущийЭтап.Выбран = Истина;
					ИтогоОтмеченоКОплате = ИтогоОтмеченоКОплате + ТекущийЭтап.СуммаКОплате;
				КонецЕсли;
				
				Если ТекущийЭтап.ДатаПлатежа > ТекущаяДата Тогда
					ТекущийЭтап.Выбран = Истина;
					ИтогоОтмеченоКОплате = ИтогоОтмеченоКОплате + ТекущийЭтап.СуммаКОплате;
					Прервать;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		ТекстЗапросаДокумент = ДокументОснование.Метаданные().ПолноеИмя();
		
		Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	1                                                   КАК Порядок,
			|	ЛОЖЬ                                                КАК Выбран,
			|	ЛОЖЬ                                                КАК Оплачена,
			|	1                                                   КАК ИндексКартинки,
			|	ЭтапыГрафикаОплаты.СуммаПлатежа                     КАК СуммаПлатежа,
			|	ЭтапыГрафикаОплаты.СуммаПлатежа                     КАК СуммаКОплате,
			|	ЭтапыГрафикаОплаты.ДатаПлатежа                      КАК ДатаПлатежа,
			|	ЭтапыГрафикаОплаты.ПроцентПлатежа                   КАК ПроцентПлатежа,
			|	ЛОЖЬ                                                КАК ЭтоЗалогЗаТару,
			|	ЛОЖЬ                                                КАК ЭтапСверхЗаказа
			|ИЗ
			|	" + ТекстЗапросаДокумент + ".ЭтапыГрафикаОплаты КАК ЭтапыГрафикаОплаты
			|ГДЕ
			|	ЭтапыГрафикаОплаты.Ссылка  = &ДокументОснование
			|	И ЭтапыГрафикаОплаты.СуммаПлатежа <> 0
			|" + ?(ТекстЗапросаДокумент = "Документ.ЗаказКлиента" ИЛИ ТекстЗапросаДокумент = "Документ.ЗаявкаНаВозвратТоваровОтКлиента", "
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ
				|	2                                                   КАК Порядок,
				|	ЛОЖЬ                                                КАК Выбран,
				|	ЛОЖЬ                                                КАК Оплачена,
				|	1                                                   КАК ИндексКартинки,
				|	ЭтапыГрафикаОплаты.СуммаЗалогаЗаТару                КАК СуммаПлатежа,
				|	ЭтапыГрафикаОплаты.СуммаЗалогаЗаТару                КАК СуммаКОплате,
				|	ЭтапыГрафикаОплаты.ДатаПлатежа                      КАК ДатаПлатежа,
				|	ЭтапыГрафикаОплаты.ПроцентЗалогаЗаТару              КАК ПроцентПлатежа,
				|	ИСТИНА                                              КАК ЭтоЗалогЗаТару,
				|	ЛОЖЬ                                                КАК ЭтапСверхЗаказа
				|ИЗ
				|	" + ТекстЗапросаДокумент + ".ЭтапыГрафикаОплаты КАК ЭтапыГрафикаОплаты
				|ГДЕ
				|	ЭтапыГрафикаОплаты.Ссылка  = &ДокументОснование
				|	И ЭтапыГрафикаОплаты.Ссылка.ТребуетсяЗалогЗаТару
				|	И ЭтапыГрафикаОплаты.СуммаЗалогаЗаТару <> 0
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ
				|	3 КАК Порядок,
				|	ЛОЖЬ КАК Выбран,
				|	ЛОЖЬ КАК Оплачена,
				|	1 КАК ИндексКартинки,
				|	ЕСТЬNULL(РасчетыСКлиентамиОстаткиИОбороты.КОплатеПриход, 0) КАК СуммаПлатежа,
				|	ЕСТЬNULL(РасчетыСКлиентамиОстаткиИОбороты.КОплатеПриход, 0) КАК СуммаКОплате,
				|	РасчетыСКлиентамиОстаткиИОбороты.Период КАК ДатаПлатежа,
				|	0 КАК ПроцентПлатежа,
				|	ЛОЖЬ КАК ЭтоЗалогЗаТару,
				|	ИСТИНА КАК ЭтапСверхЗаказа
				|ИЗ
				|	РегистрНакопления.РасчетыСКлиентами.ОстаткиИОбороты(, , РЕГИСТРАТОР, , ЗаказКлиента = &ДокументОснование) КАК РасчетыСКлиентамиОстаткиИОбороты
				|ГДЕ
				|	РасчетыСКлиентамиОстаткиИОбороты.Регистратор <> РасчетыСКлиентамиОстаткиИОбороты.ЗаказКлиента
				|	И ЕСТЬNULL(РасчетыСКлиентамиОстаткиИОбороты.КОплатеПриход, 0) > 0
				|	И &ИспользоватьРасширенныеВозможностиЗаказаКлиента
				|
			|","") + "
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаПлатежа,
			|	Порядок
			|;
			|ВЫБРАТЬ
			|	ЕСТЬNULL(РасчетыСКлиентамиОбороты.КОплатеРасход, 0)
			|		+ ЕСТЬNULL(РасчетыСКлиентамиОбороты.ОплачиваетсяОборот, 0) КАК СуммаОплаты
			|ИЗ
			|	РегистрНакопления.РасчетыСКлиентами.Обороты(, , Период, ЗаказКлиента = &ДокументОснование) КАК РасчетыСКлиентамиОбороты
			|;
			|ВЫБРАТЬ
			|	ДанныеДокумента.Партнер                   КАК Партнер,
			|	ДанныеДокумента.Контрагент                КАК Контрагент,
			|	ДанныеДокумента.Договор		              КАК Договор,
			|	ДанныеДокумента.Организация               КАК Организация,
			|	ДанныеДокумента.Валюта                    КАК Валюта,
			|	ДанныеДокумента.Ссылка                    КАК ДокументОснование,
			|" + ?(ТекстЗапросаДокумент = "Документ.ЗаявкаНаВозвратТоваровОтКлиента", "
			|	ВЫБОР КОГДА ДанныеДокумента.ТребуетсяЗалогЗаТару ТОГДА
			|		ДанныеДокумента.СуммаЗамены + ДанныеДокумента.СуммаВозвратнойТары
			|	ИНАЧЕ
			|		ДанныеДокумента.СуммаЗамены
			|	КОНЕЦ КАК СуммаДокумента,
			|", ?(ТекстЗапросаДокумент = "Документ.ЗаказКлиента", "
			|	ВЫБОР КОГДА ДанныеДокумента.ТребуетсяЗалогЗаТару ТОГДА
			|		ДанныеДокумента.СуммаДокумента + ДанныеДокумента.СуммаВозвратнойТары
			|	ИНАЧЕ
			|		ДанныеДокумента.СуммаДокумента
			|	КОНЕЦ КАК СуммаДокумента,
			|", "
			|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
			|")) + "
			|	ДанныеДокумента.Номер                     КАК НомерДокумента,
			|	ДанныеДокумента.БанковскийСчет            КАК БанковскийСчет,
			|	ДанныеДокумента.Организация.Префикс       КАК Префикс,
			|	ДанныеДокумента.Касса                     КАК Касса,
			|	//ДанныеДокументаКонтактноеЛицо
			|	ДанныеДокумента.ФормаОплаты               КАК ФормаОплаты,
			|	ДанныеДокумента.Ссылка                    КАК Документ,
			|" + ?(ТекстЗапросаДокумент <> "Документ.ОтчетКомиссионера", "
			|	ДанныеДокумента.Статус                    КАК Статус,
			|	ВЫБОР
			|		КОГДА
			|			ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию)
			|			ИЛИ ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОтКомиссионера)
			|		ТОГДА
			|			ИСТИНА
			|		ИНАЧЕ
			|			ЛОЖЬ
			|	КОНЕЦ                                     КАК ЕстьОшибкиХозяйственнаяОперация,
			|	ДанныеДокумента.ХозяйственнаяОперация     КАК ХозяйственнаяОперация,
			|","
			|	НЕОПРЕДЕЛЕНО                              КАК Статус,
			|	ЛОЖЬ                                      КАК ЕстьОшибкиХозяйственнаяОперация,
			|	НЕОПРЕДЕЛЕНО                              КАК ХозяйственаяОперация,
			|") + "
			|	НЕ ДанныеДокумента.Проведен               КАК ЕстьОшибкиПроведен
			|ИЗ
			|	" + ТекстЗапросаДокумент + " КАК ДанныеДокумента
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &ДокументОснование
			|");
			
		Если ТекстЗапросаДокумент = "Документ.ЗаказКлиента" Тогда
		
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "//ДанныеДокументаКонтактноеЛицо","ДанныеДокумента.КонтактноеЛицо КАК КонтактноеЛицо,");
		
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		Запрос.УстановитьПараметр("ИспользоватьРасширенныеВозможностиЗаказаКлиента", ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента"));
		МассивРезультатов       = Запрос.ВыполнитьПакет();
		ВыборкаДокументовЭтапы  = МассивРезультатов[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ВыборкаДокументовОплата = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ВыборкаШапка            = МассивРезультатов[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если ВыборкаШапка.Следующий() Тогда
			
			МассивДопустимыхСтатусов = Неопределено;
			ТипОснования = ТипЗнч(ДокументОснование);
			
			Если ТипОснования = Тип("ДокументСсылка.ЗаказКлиента") Тогда
				
				Документы.ЗаказКлиента.ПроверитьВозможностьВводаНаОсновании(
					ВыборкаШапка.ДокументОснование,
					ВыборкаШапка.Статус,
					ВыборкаШапка.ЕстьОшибкиПроведен,
					Истина);

			ИначеЕсли ТипОснования = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
				
				Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПроверитьВозможностьВводаНаОсновании(
					ВыборкаШапка.ДокументОснование,
					ВыборкаШапка.Статус,
					ВыборкаШапка.ЕстьОшибкиПроведен,
					Истина);
				
			КонецЕсли;
			
			Если ТекстЗапросаДокумент <> "Документ.ОтчетКомиссионера" Тогда
				
				Документы.СчетНаОплатуКлиенту.ПроверитьКорректностьХозяйственнойОперацииДокументаОснования(
					ВыборкаШапка.ЕстьОшибкиХозяйственнаяОперация,
					ВыборкаШапка.ХозяйственнаяОперация);
				
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ШапкаОснование, ВыборкаШапка);
			Валюта = ВыборкаШапка.Валюта;
			
		КонецЕсли;
		
		Если ВыборкаДокументовЭтапы.Количество() = 0 Тогда
			
			ТекстОшибки = НСтр("ru = 'В документе %Документ% не заполнены этапы графика оплаты';
								|en = 'Payment schedule steps are not populated in document %Документ%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДокументОснование);
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		ТаблицаЭтапов.Очистить();
		
		Пока ВыборкаДокументовЭтапы.Следующий() Цикл
			
			НоваяСтрокаЭтап = ТаблицаЭтапов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаЭтап, ВыборкаДокументовЭтапы);
			
		КонецЦикла;
		
		Если ТаблицаЭтапов.Итог("СуммаПлатежа") = 0 Тогда
			
			ТекстОшибки = НСтр("ru = 'Не требуется вводить счета на оплату. Сумма платежа по документу %Документ% равна 0.';
								|en = 'It is not required to enter proforma invoices. Payment amount by document %Документ% is 0.'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДокументОснование);
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		Если ВыборкаДокументовОплата.Следующий() Тогда
			
			СуммаОстатокОплаты = 0;
			СуммаОстатокОплаты = ВыборкаДокументовОплата.СуммаОплаты;
			
			Для Каждого ТекущийЭтап Из ТаблицаЭтапов Цикл
				
				Если СуммаОстатокОплаты < ТекущийЭтап.СуммаПлатежа Тогда
					ТекущийЭтап.СуммаОплаты = СуммаОстатокОплаты;
					ТекущийЭтап.СуммаКОплате = ТекущийЭтап.СуммаПлатежа - ТекущийЭтап.СуммаОплаты;
					Прервать;
				КонецЕсли;
					
				ТекущийЭтап.СуммаОплаты  = ТекущийЭтап.СуммаПлатежа;
				ТекущийЭтап.СуммаКОплате = 0;
				ТекущийЭтап.Оплачен      = Истина;
				СуммаОстатокОплаты       = СуммаОстатокОплаты - ТекущийЭтап.СуммаПлатежа;
				
			КонецЦикла;
				
		КонецЕсли;
		
		ИтогоСуммаКОплате    = ТаблицаЭтапов.Итог("СуммаКОплате");
		ИтогоСуммаОплаты     = ТаблицаЭтапов.Итог("СуммаОплаты");
		ИтогоСуммаПлатежа    = ТаблицаЭтапов.Итог("СуммаПлатежа");
		ИтогоПроцентПлатежа  = ТаблицаЭтапов.Итог("ПроцентПлатежа");
		
		ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
		
		ИтогоОтмеченоКОплате = 0;
		
		Для Каждого ТекущийЭтап Из ТаблицаЭтапов Цикл
			
			Если Не ТекущийЭтап.Оплачен Тогда
				Если ТекущийЭтап.ДатаПлатежа <= ТекущаяДата Тогда
					ТекущийЭтап.Выбран = Истина;
					ИтогоОтмеченоКОплате = ИтогоОтмеченоКОплате + ТекущийЭтап.СуммаКОплате;
				КонецЕсли;
				
				Если ТекущийЭтап.ДатаПлатежа > ТекущаяДата Тогда
					ТекущийЭтап.Выбран = Истина;
					ИтогоОтмеченоКОплате = ИтогоОтмеченоКОплате + ТекущийЭтап.СуммаКОплате;
					Прервать;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьСчетНаОплатуСервер()
	
	СчетНаОплатуКлиенту = Неопределено;
	
	НачатьТранзакцию();
	
	Попытка
		
		ДокументОбъект = Документы.СчетНаОплатуКлиенту.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(ДокументОбъект, ШапкаОснование);
		ДокументОбъект.Заполнить(Неопределено);
		ДокументОбъект.Дата = ТекущаяДатаСеанса();
		ДокументОбъект.УстановитьНовыйНомер();
		
		СуммаДокумента   = 0;
		КоличествоЭтапов = 0;
		НомерЭтапа       = 1;
		ПроцентПлатежа   = 0;
		СуммаДокументаБезЗалога = 0;
		
		Для Каждого ТекущийЭтап Из ТаблицаЭтапов Цикл
			
			Если Не ТекущийЭтап.Выбран Тогда
				Продолжить;
			КонецЕсли;
			
			СуммаДокумента = СуммаДокумента + ТекущийЭтап.СуммаПлатежа - ТекущийЭтап.СуммаОплаты;
			Если Не ТекущийЭтап.ЭтоЗалогЗаТару Тогда
				СуммаДокументаБезЗалога = СуммаДокументаБезЗалога + ТекущийЭтап.СуммаПлатежа - ТекущийЭтап.СуммаОплаты;
			КонецЕсли;
			КоличествоЭтапов = КоличествоЭтапов + 1;
			
		КонецЦикла;
		
		ДокументОбъект.СуммаДокумента = СуммаДокумента;
		
		Если ШапкаОснование.СуммаДокумента <> СуммаДокумента Тогда
			ДокументОбъект.ЧастичнаяОплата = Истина;
		КонецЕсли;
		
		Для Каждого ТекущийЭтап Из ТаблицаЭтапов Цикл
			
			Если Не ТекущийЭтап.Выбран Тогда
				Продолжить;
			КонецЕсли;
			
			НовыйЭтап = ДокументОбъект.ЭтапыГрафикаОплаты.Добавить();
			НовыйЭтап.ДатаПлатежа    = ТекущийЭтап.ДатаПлатежа;
			НовыйЭтап.СуммаПлатежа   = ТекущийЭтап.СуммаКОплате;
			НовыйЭтап.ЭтоЗалогЗаТару = ТекущийЭтап.ЭтоЗалогЗаТару;
			
			Если СуммаДокументаБезЗалога > 0 Тогда
				Если НомерЭтапа = КоличествоЭтапов Тогда
					НовыйЭтап.ПроцентПлатежа = 100 - ПроцентПлатежа;
				ИначеЕсли Не ТекущийЭтап.ЭтоЗалогЗаТару Тогда
					НовыйЭтап.ПроцентПлатежа = НовыйЭтап.СуммаПлатежа * 100 / СуммаДокументаБезЗалога;
					ПроцентПлатежа = ПроцентПлатежа + НовыйЭтап.ПроцентПлатежа;
				КонецЕсли;
			КонецЕсли;
			
			НомерЭтапа = НомерЭтапа + 1;
			
		КонецЦикла;
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация    		= ДокументОбъект.Организация;
		СтруктураПараметров.БанковскийСчет		= ДокументОбъект.БанковскийСчет;
		БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация = ДокументОбъект.Организация;
		СтруктураПараметров.ФормаОплаты	= ДокументОбъект.ФормаОплаты;
		СтруктураПараметров.Касса		= ДокументОбъект.Касса;
		Касса          = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
		
		ДокументОбъект.НазначениеПлатежа = Документы.СчетНаОплатуКлиенту.СформироватьНазначениеПлатежа(
			ШапкаОснование.НомерДокумента,
			ШапкаОснование.ДокументОснование);
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		СчетНаОплатуКлиенту = ДокументОбъект.Ссылка;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстОшибки = НСтр("ru = 'Не удалось записать %Документ%. %ОписаниеОшибки%';
							|en = 'Failed to write %Документ%. %ОписаниеОшибки%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%",       ДокументОбъект);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
	КонецПопытки;
	
	Возврат СчетНаОплатуКлиенту;
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьЗаголовокКолонкиСВалютой(ЗаголовокКолонки, Валюта)
	
	 Возврат ЗаголовокКолонки + " (" + Валюта + ")";
	
КонецФункции

&НаКлиенте
Процедура СформироватьСчет(ВыводитьСчетНаПечать = Ложь)
	
	ЕстьВыбранные = Ложь;
	
	Для Каждого ТекущийЭтап Из ТаблицаЭтапов Цикл
		
		Если ТекущийЭтап.Выбран Тогда
			ЕстьВыбранные = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЕстьВыбранные Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Не выбраны этапы оплаты';
									|en = 'Payment steps are not selected'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	СчетНаОплатуКлиенту =  СоздатьСчетНаОплатуСервер();
	
	Если СчетНаОплатуКлиенту <> Неопределено Тогда
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Создание:';
											|en = 'Created:'"),
		                               ПолучитьНавигационнуюСсылку(СчетНаОплатуКлиенту),
		                               СчетНаОплатуКлиенту,
		                               БиблиотекаКартинок.Информация32);
	
		ОповеститьОбИзменении(СчетНаОплатуКлиенту);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСчетаНаОплату;
		Элементы.Список.ТекущаяСтрока = СчетНаОплатуКлиенту;
		
		Если ВыводитьСчетНаПечать Тогда
			СформироватьПечатнуюФорму(СчетНаОплатуКлиенту);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПечатнуюФорму(СчетНаОплатуКлиенту)

	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СчетНаОплатуКлиенту);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПроведенностьДокументовЗавершение", ЭтотОбъект);
	
	УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов(ОписаниеОповещения, МассивДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПроведенностьДокументовЗавершение(МассивДокументов, ДополнительныеПараметры) Экспорт
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьСчетовНаОплату",
		"СчетНаОплату",
		МассивДокументов,
		Неопределено,
		Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЭтаповВыбранПриИзменении(Элемент)
	
	ТекущийЭтап = Элементы.ТаблицаЭтапов.ТекущиеДанные;
	
	Если ТекущийЭтап <> Неопределено Тогда
		
		РедактируемаяСтрока = ТаблицаЭтапов.НайтиПоИдентификатору(ТекущийЭтап.ПолучитьИдентификатор());
		
		Если Не РедактируемаяСтрока.Выбран Тогда
			
			СброситьФлаг = Ложь;
			
			Для Каждого ТекСтрока Из ТаблицаЭтапов Цикл
				
				Если РедактируемаяСтрока = ТекСтрока Тогда
					СброситьФлаг = Истина;
				КонецЕсли;
				
				Если СброситьФлаг И ТекСтрока.Выбран Тогда
					ТекСтрока.Выбран = Ложь;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			
			УстановитьФлаг = Истина;
			
			Для Каждого ТекСтрока Из ТаблицаЭтапов Цикл
				
				Если РедактируемаяСтрока = ТекСтрока Тогда
					УстановитьФлаг = Ложь;
				КонецЕсли;
				
				Если УстановитьФлаг И Не ТекСтрока.Выбран И Не ТекСтрока.Оплачен Тогда
					ТекСтрока.Выбран = Истина;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИтогоОтмеченоКОплате = 0;
	
	Для Каждого ТекущийЭтап Из ТаблицаЭтапов Цикл
		
		Если ТекущийЭтап.Выбран Тогда
			ИтогоОтмеченоКОплате = ИтогоОтмеченоКОплате + ТекущийЭтап.СуммаКОплате;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВозможностьСозданияСчетовНаОплату(ДокументОснование)
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ПорядокРасчетов");
	Возврат ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоНакладным;
	
КонецФункции

#КонецОбласти

#КонецОбласти
