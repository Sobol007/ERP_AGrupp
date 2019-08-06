#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	Элементы.Разделитель.ТолькоПросмотр = Не ПравоДоступа("Изменение", Метаданные.Справочники.СкладскиеЯчейки);
	Разделитель = "-";
	
	КодЗаполнитьСписокВыбора(Элементы.Код, Объект, Разделитель);
	НаименованиеЗаполнитьСписокВыбора(Элементы.Наименование, Объект.Код);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

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
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСкладскойЯчейкиПриИзменении(Элемент)
	
	Если (Объект.ТипСкладскойЯчейки = ПредопределенноеЗначение("Перечисление.ТипыСкладскихЯчеек.Отгрузка")
		ИЛИ Объект.ТипСкладскойЯчейки = ПредопределенноеЗначение("Перечисление.ТипыСкладскихЯчеек.Приемка"))
		И Объект.ИспользованиеПериодичностиИнвентаризацииЯчейки 
			= ПредопределенноеЗначение("Перечисление.ВариантыИспользованияПериодическойИнвентаризацииЯчеек.ИспользоватьНастройкиОбластиХранения") Тогда 
		Объект.ИспользованиеПериодичностиИнвентаризацииЯчейки 
			= ПредопределенноеЗначение("Перечисление.ВариантыИспользованияПериодическойИнвентаризацииЯчеек.НеИспользовать");		
	КонецЕсли; 
	УстановитьВидимостьПоТипуСкладскойЯчейки();
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = СокрЛП(Объект.Код);
	КонецЕсли;
	
	НаименованиеЗаполнитьСписокВыбора(Элементы.Наименование, Объект.Код);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлементГруппыАдресацияПодробноПриИзменении(Элемент)
	
	КодЗаполнитьСписокВыбора(Элементы.Код, Объект, Разделитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипоразмерПриИзменении(Элемент)
	
	НастроитьДоступностьКоэффициентовНаполненности();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.СкладскиеЯчейки.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад,Помещение",Объект.Владелец,Объект.Помещение));
		
	УправлениеФормой();
	
КонецПроцедуры

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьПоТипуСкладскойЯчейки()
	
	Элементы.ГруппаНаполнение.Видимость = ИспользоватьАдресноеХранение И ((Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Хранение)
										  Или  (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Архив));
	Элементы.УровеньДоступности.Видимость = (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Хранение)
										  Или  (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Архив);
	Элементы.ОбластьХранения.Видимость = (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Хранение)
										  Или  (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Архив);
	
	Элементы.ПорядокОбхода.Видимость = (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Хранение)
										Или  (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Архив)
										Или Не ЗначениеЗаполнено(Объект.ТипСкладскойЯчейки);
										
	Элементы.РабочийУчасток.Видимость = (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Хранение)
										Или  (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Архив)
										Или Не ЗначениеЗаполнено(Объект.ТипСкладскойЯчейки);
																			
										
	Элементы.ГруппаПериодичностьИнвентаризацииЯчейкиНастройкиОбластиХранения.Видимость = 
	    ИспользоватьАдресноеХранение
		И (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Архив 
			ИЛИ Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Хранение);									
						
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьКоэффициентовНаполненности()
	
	Если Не ЗначениеЗаполнено(Объект.Типоразмер) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыТипоразмера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Типоразмер,
		"НеОграниченаПоРазмерам, НеОграниченаПоГрузоподъемности");
	
	Элементы.ГруппаНаполнениеПоОбъему.Доступность = Не РеквизитыТипоразмера.НеОграниченаПоРазмерам;
	Элементы.ГруппаНаполнениеПоВесу.Доступность = Не РеквизитыТипоразмера.НеОграниченаПоГрузоподъемности;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Объект.Владелец, Объект.Помещение);
	
	УстановитьВидимостьПоТипуСкладскойЯчейки();
	НастроитьДоступностьКоэффициентовНаполненности();
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"ГруппаРазмещениеОтбор", 
			"ОтображатьЗаголовок",
			ИспользоватьАдресноеХранение);		
			
	Элементы.ГруппаПериодИнвентаризацииЯчейки.Видимость = ИспользоватьАдресноеХранение;
	
	Если ИспользоватьАдресноеХранение 
		И (Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Архив
			ИЛИ Объект.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек.Хранение) Тогда 
		ЗаполнитьНастройкиПериодичностиИнвентаризацииОбластиХранения();	
	КонецЕсли;
			
	ИспользованиеПериодичностиИнвентаризацииЯчейкиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура КодЗаполнитьСписокВыбора(Элемент, Объект, Разделитель)
	
	Если Разделитель = "П" Тогда
		РазделительСтрока = " ";	
	ИначеЕсли Разделитель = "Н"	Тогда
		РазделительСтрока = "";	
	Иначе
		РазделительСтрока = Разделитель;
	КонецЕсли;
	
	Адрес = СокрЛП(Объект.Секция)
			+ ?(ПустаяСтрока(Объект.Секция), "", РазделительСтрока)
			+ СокрЛП(Объект.Линия)
			+ ?(ПустаяСтрока(Объект.Линия), "", РазделительСтрока)
			+ СокрЛП(Объект.Стеллаж)
			+ ?(ПустаяСтрока(Объект.Стеллаж), "", РазделительСтрока)
			+ СокрЛП(Объект.Ярус) 
			+ ?(ПустаяСтрока(Объект.Ярус), "", РазделительСтрока)
			+ СокрЛП(Объект.Позиция);
			
	Если Прав(Адрес, 1) = РазделительСтрока Тогда
		Адрес = Лев(Адрес, СтрДлина(Адрес)-1);
	КонецЕсли;
	
	Элемент.СписокВыбора.Очистить();
	Элемент.СписокВыбора.Добавить(Адрес);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НаименованиеЗаполнитьСписокВыбора(Элемент, Код)
	
	Элемент.СписокВыбора.Очистить();
	Элемент.СписокВыбора.Добавить(СокрЛП(Код));
	
КонецПроцедуры

#КонецОбласти


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
Процедура ИспользованиеПериодичностиИнвентаризацииЯчейкиПриИзменении(Элемент)
	ИспользованиеПериодичностиИнвентаризацииЯчейкиПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбластьХраненияПриИзменении(Элемент)
	ЗаполнитьНастройкиПериодичностиИнвентаризацииОбластиХранения();	
КонецПроцедуры

&НаСервере
Процедура ИспользованиеПериодичностиИнвентаризацииЯчейкиПриИзмененииНаСервере()
	
	Если Не ИспользоватьАдресноеХранение Тогда 
		Возврат
	КонецЕсли;
	
	Если Объект.ИспользованиеПериодичностиИнвентаризацииЯчейки 
			= Перечисления.ВариантыИспользованияПериодическойИнвентаризацииЯчеек.ИспользоватьНастройкиЯчейки Тогда 
		Элементы.КоличествоДнейМеждуИнвентаризациямиСтраницы.ТекущаяСтраница = Элементы.КоличествоДнейМеждуИнвентаризациямиДоступно;
	Иначе
		Объект.КоличествоДнейМеждуИнвентаризациями = 0;
		Элементы.КоличествоДнейМеждуИнвентаризациямиСтраницы.ТекущаяСтраница = Элементы.КоличествоДнейМеждуИнвентаризациямиНедоступно;
	КонецЕсли;
				
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиПериодичностиИнвентаризацииОбластиХранения()
	Если ЗначениеЗаполнено(Объект.ОбластьХранения) Тогда
		КоличествоДнейМеждуИнвентаризациями = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Объект.ОбластьХранения, 
				"КоличествоДнейМеждуИнвентаризациями");
		Если КоличествоДнейМеждуИнвентаризациями = 0 Тогда 
			НастройкиИспользованияПериодичностиПересчетаОбластиХранения
					= НСтр("ru = 'периодическая инвентаризация в области хранения не используется.';
							|en = 'periodic stocktaking is not used in the storage area.'");
		Иначе
			НастройкиИспользованияПериодичностиПересчетаОбластиХранения = НСтр("ru = 'пересчитывать %Каждые% %КоличествоДней%.';
																				|en = 'recalculate %Каждые% %КоличествоДней%.'");
			НастройкиИспользованияПериодичностиПересчетаОбластиХранения = СтрЗаменить(
					НастройкиИспользованияПериодичностиПересчетаОбластиХранения,
					"%Каждые%",
					?(КоличествоДнейМеждуИнвентаризациями = 1, НСтр("ru = 'каждый';
																	|en = 'each'"), НСтр("ru = 'каждые';
																							|en = 'each'")));
			КоличествоДней = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
					КоличествоДнейМеждуИнвентаризациями, 
					 НСтр("ru = 'день,дня,дней';
							|en = 'day,day,days'"));
			НастройкиИспользованияПериодичностиПересчетаОбластиХранения = СтрЗаменить(
					НастройкиИспользованияПериодичностиПересчетаОбластиХранения,
					"%КоличествоДней%",
					КоличествоДней);
		КонецЕсли;
	Иначе
		НастройкиИспользованияПериодичностиПересчетаОбластиХранения = НСтр("ru = '<область хранения не указана, периодическая инвентаризация не проводится>';
																			|en = '<storage area is not specified, periodic stocktaking is not carried out>'");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
