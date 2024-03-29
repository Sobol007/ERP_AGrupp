#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
		
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ИсполнениеПланаПродаж) И ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж") Тогда
		
		Выборка = Справочники.СценарииТоварногоПланирования.Выбрать();
		Выборка.Следующий();
						
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Представление = НСтр("ru = 'Исполнение плана продаж'");
		КомандаОтчет.Важность = "Важное";
			
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.РежимЗаписи = "НеЗаписывать";
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ИсполнениеПланаПродаж.ПолноеИмя();
		КомандаОтчет.Обработчик = "АГ_ПланПродажКлиент.ОтчетИсполнениеПланаПродаж";
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает доступные типы для заполнения аналитики бюджетирования.
//
// Параметры:
//	ДокументСсылка - Ссылка на документа
//	ИмяТаблицы - Строка - Имя таблицы документа
// Возвращаемое значение:
// 	  ДоступныеТипыАналитик - Соотвествие - Ключ: Тип, Значение: Источник заполнения.
//
Функция ДоступныеТипыАналитикБюджетирования(ДокументСсылка, ИмяТаблицы = "") Экспорт
	
	Результат = Новый Соответствие;
		
	Результат.Вставить(Тип("СправочникСсылка.Контрагенты"), "ВтКонтрагентыПартнеров.Контрагент");
	
	Результат.Вставить(Тип("СправочникСсылка.Партнеры"), ИмяТаблицы + ".Партнер");
	Результат.Вставить(Тип("СправочникСсылка.CRM_Отрасли"), ИмяТаблицы + ".Партнер.CRM_ОсновнаяОтрасль");
	
	Если ИмяТаблицы = "Товары" Тогда
		Результат.Вставить(Тип("СправочникСсылка.ТоварныеКатегории"), "Товары.ТоварнаяКатегория");
	ИначеЕсли ИмяТаблицы = "Услуги" Тогда
		Результат.Вставить(Тип("СправочникСсылка.ТоварныеКатегории"), "Услуги.Номенклатура.ТоварнаяКатегория");
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
КонецПроцедуры

#КонецОбласти

#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаОборотыБюджетов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПланыОплатКлиентов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПланПродажПоКатегориям(Запрос, ТекстыЗапроса, Регистры);
	
	//<--АГ:[PLAN_0001_1][23.04.2019 19:07:51][Фирсанов О.И.]
	ТекстЗапросаТаблицаПланПродажПоКлиентамКатегориям(Запрос, ТекстыЗапроса, Регистры);
	//-->АГ:[ PLAN_0001_1 ]
	
	//<--АГ:[PLAN_0001_1][03.05.2019 16:07:51][Фирсанов О.И.]
	ТекстЗапросаТаблицаПланыОплатКлиентовПоДаннымМенеджера(Запрос, ТекстыЗапроса, Регистры);
	//-->АГ:[ PLAN_0001_1 ]
	
	
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Статус КАК Статус,
	|	ДанныеДокумента.Сценарий КАК Сценарий,
	|	ДанныеДокумента.ВидПлана КАК ВидПлана,
	|	ДанныеДокумента.ВидПлана.Замещающий КАК Замещающий,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Ответственный КАК Менеджер,
	|	ДанныеДокумента.Дата КАК Дата,
	//<--АГ:[PLAN_0001_1][05.05.2019 13:07:51][Фирсанов О.И.]
	|	ДанныеДокумента.Организация КАК Организация,	
	//-->АГ:[ PLAN_0001_1 ]
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Сценарий.ПланПродажПланироватьПоСумме
	|			ТОГДА ДанныеДокумента.ВалютаДокумента
	|		ИНАЧЕ ДанныеДокумента.Сценарий.СценарийБюджетирования.Валюта
	|	КОНЕЦ КАК Валюта,
	|	ДанныеДокумента.ВидПлана.СтатьяБюджетов КАК СтатьяБюджетов,
	|	ДанныеДокумента.Сценарий.СценарийБюджетирования КАК СценарийБюджетирования,
	|	ДанныеДокумента.ВидПлана.ОтражаетсяВБюджетировании КАК ОтражаетсяВБюджетировании,
	|	ДанныеДокумента.ВидПлана.СтатьяБюджетовОплат КАК СтатьяБюджетовОплат,
	|	ДанныеДокумента.ВидПлана.ОтражаетсяВБюджетированииОплаты КАК ОтражаетсяВБюджетированииОплаты,
	|	ДанныеДокумента.ВидПлана.СтатьяБюджетовОплатКредит КАК СтатьяБюджетовОплатКредит,
	|	ДанныеДокумента.ВидПлана.ОтражаетсяВБюджетированииОплатыКредит КАК ОтражаетсяВБюджетированииОплатыКредит,
	|	КОНЕЦПЕРИОДА(ДанныеДокумента.Период, МЕСЯЦ) КАК ОкончаниеПериода,
	|	ДанныеДокумента.Период КАК НачалоПериода
	|ИЗ
	|	Документ.АГ_ПланПродаж КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	РезультатЗапроса = Запрос.Выполнить();
	Реквизиты = РезультатЗапроса.Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Статус",                 Реквизиты.Статус);
	Запрос.УстановитьПараметр("Подразделение",          Реквизиты.Подразделение);
	Запрос.УстановитьПараметр("Сценарий",               Реквизиты.Сценарий);
	Запрос.УстановитьПараметр("ВидПлана",               Реквизиты.ВидПлана);
	Запрос.УстановитьПараметр("Замещающий",             Реквизиты.Замещающий);
	Запрос.УстановитьПараметр("Менеджер",               Реквизиты.Менеджер);
	Запрос.УстановитьПараметр("НачалоПериода",          Реквизиты.НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода",       Реквизиты.ОкончаниеПериода);
	
	//<--АГ:[PLAN_0001_1][05.05.2019 13:07:51][Фирсанов О.И.]
	Запрос.УстановитьПараметр("Организация",	Реквизиты.Организация);
	//-->АГ:[ PLAN_0001_1 ]
	
	Запрос.УстановитьПараметр("Дата",                                  Реквизиты.Дата);
	Запрос.УстановитьПараметр("Валюта",                                Реквизиты.Валюта);
	Запрос.УстановитьПараметр("СтатьяБюджетов",                        Реквизиты.СтатьяБюджетов);
	Запрос.УстановитьПараметр("СтатьяБюджетовОплат",                   Реквизиты.СтатьяБюджетовОплат);
	Запрос.УстановитьПараметр("СтатьяБюджетовОплатКредит",             Реквизиты.СтатьяБюджетовОплатКредит);
	Запрос.УстановитьПараметр("СценарийБюджетирования",                Реквизиты.СценарийБюджетирования);
	Запрос.УстановитьПараметр("ОтражаетсяВБюджетировании",             Реквизиты.ОтражаетсяВБюджетировании);
	Запрос.УстановитьПараметр("ОтражаетсяВБюджетированииОплаты",       Реквизиты.ОтражаетсяВБюджетированииОплаты);
	Запрос.УстановитьПараметр("ОтражаетсяВБюджетированииОплатыКредит", Реквизиты.ОтражаетсяВБюджетированииОплатыКредит);
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",     Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаОборотыБюджетов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОборотыБюджетов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтКонтрагентыПартнеров", ТекстыЗапроса) Тогда
		ТекстЗапросаВтКонтрагентыПартнеров(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПериодыПланирования", ТекстыЗапроса) Тогда
		ТекстЗапросаВтПериодыПланирования(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтКурсыВалюты", ТекстыЗапроса) Тогда
		ТекстЗапросаВтКурсыВалюты(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПериодыКурсовВалюты", ТекстыЗапроса) Тогда
		ТекстЗапросаВтПериодыКурсовВалюты(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрогнозныеКурсыВалюты", ТекстыЗапроса) Тогда
		ТекстЗапросаВтПрогнозныеКурсыВалюты(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Дата КАК Период,
	|	&Статус КАК Статус,
	|	&Валюта КАК Валюта,
	|	&НачалоПериода КАК ПериодПланирования,
	|	&СценарийБюджетирования КАК Сценарий,
	|	НЕОПРЕДЕЛЕНО КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	&СтатьяБюджетов КАК СтатьяБюджетов,
	|	
	|	//%АналитикаТовары1 КАК Аналитика1,
	|	//%АналитикаТовары2 КАК Аналитика2,
	|	//%АналитикаТовары3 КАК Аналитика3,
	|	//%АналитикаТовары4 КАК Аналитика4,
	|	//%АналитикаТовары5 КАК Аналитика5,
	|	//%АналитикаТовары6 КАК Аналитика6,
	|	
	|	СУММА(Товары.Количество) КАК Количество,
	|	СУММА(Товары.Сумма) КАК СуммаВВалюте,
	|	СУММА(Товары.Сумма) КАК СуммаСценария,
	|	СУММА(Товары.Сумма * ВЫРАЗИТЬ(ЕСТЬNULL(КурсыВалютыДокумента.Курс, 1) КАК ЧИСЛО(15,3)) / ВЫРАЗИТЬ(ЕСТЬNULL(КурсыВалютыРегл.Курс, 1) КАК ЧИСЛО(15,3))) КАК СуммаРегл,
	|	СУММА(Товары.Сумма * ВЫРАЗИТЬ(ЕСТЬNULL(КурсыВалютыДокумента.Курс, 1) КАК ЧИСЛО(15,3)) / ВЫРАЗИТЬ(ЕСТЬNULL(КурсыВалютыУпр.Курс, 1) КАК ЧИСЛО(15,3))) КАК СуммаУпр
	|ИЗ
	|	Документ.АГ_ПланПродаж.Товары КАК Товары
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтПрогнозныеКурсыВалюты КАК КурсыВалютыДокумента
	|		ПО (КурсыВалютыДокумента.Валюта = &Валюта
	|			И КурсыВалютыДокумента.ПериодПланирования = &НачалоПериода)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтПрогнозныеКурсыВалюты КАК КурсыВалютыУпр
	|		ПО (КурсыВалютыУпр.Валюта = &ВалютаУправленческогоУчета
	|			И КурсыВалютыУпр.ПериодПланирования = &НачалоПериода)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтПрогнозныеКурсыВалюты КАК КурсыВалютыРегл
	|		ПО (КурсыВалютыРегл.Валюта = &ВалютаРегламентированногоУчета
	|			И КурсыВалютыРегл.ПериодПланирования = &НачалоПериода)
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтКонтрагентыПартнеров КАК ВтКонтрагентыПартнеров
	|		ПО Товары.Партнер = ВтКонтрагентыПартнеров.Партнер
	|	
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И &ОтражаетсяВБюджетировании
	|	И &Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)
	|
	|СГРУППИРОВАТЬ ПО
	|	//%АналитикаТовары1,
	|	//%АналитикаТовары2,
	|	//%АналитикаТовары3,
	|	//%АналитикаТовары4,
	|	//%АналитикаТовары5,
	|	//%АналитикаТовары6
	|	
	|ИМЕЮЩИЕ
	|	(СУММА(Товары.Количество) <> 0 ИЛИ СУММА(Товары.Сумма) <> 0)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Дата КАК Период,
	|	&Статус КАК Статус,
	|	&Валюта КАК Валюта,
	|	&НачалоПериода КАК ПериодПланирования,
	|	&СценарийБюджетирования КАК Сценарий,
	|	НЕОПРЕДЕЛЕНО КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	&СтатьяБюджетов КАК СтатьяБюджетов,
	|	
	|	//%АналитикаУслуги1 КАК Аналитика1,
	|	//%АналитикаУслуги2 КАК Аналитика2,
	|	//%АналитикаУслуги3 КАК Аналитика3,
	|	//%АналитикаУслуги4 КАК Аналитика4,
	|	//%АналитикаУслуги5 КАК Аналитика5,
	|	//%АналитикаУслуги6 КАК Аналитика6,
	|	
	|	СУММА(Услуги.Количество) КАК Количество,
	|	СУММА(Услуги.Сумма) КАК СуммаВВалюте,
	|	СУММА(Услуги.Сумма) КАК СуммаСценария,
	|	СУММА(Услуги.Сумма * ВЫРАЗИТЬ(ЕСТЬNULL(КурсыВалютыДокумента.Курс, 1) КАК ЧИСЛО(15,3)) / ВЫРАЗИТЬ(ЕСТЬNULL(КурсыВалютыРегл.Курс, 1) КАК ЧИСЛО(15,3))) КАК СуммаРегл,
	|	СУММА(Услуги.Сумма * ВЫРАЗИТЬ(ЕСТЬNULL(КурсыВалютыДокумента.Курс, 1) КАК ЧИСЛО(15,3)) / ВЫРАЗИТЬ(ЕСТЬNULL(КурсыВалютыУпр.Курс, 1) КАК ЧИСЛО(15,3))) КАК СуммаУпр
	|ИЗ
	|	Документ.АГ_ПланПродаж.Услуги КАК Услуги
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтПрогнозныеКурсыВалюты КАК КурсыВалютыДокумента
	|		ПО (КурсыВалютыДокумента.Валюта = &Валюта
	|			И КурсыВалютыДокумента.ПериодПланирования = &НачалоПериода)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтПрогнозныеКурсыВалюты КАК КурсыВалютыУпр
	|		ПО (КурсыВалютыУпр.Валюта = &ВалютаУправленческогоУчета
	|			И КурсыВалютыУпр.ПериодПланирования = &НачалоПериода)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтПрогнозныеКурсыВалюты КАК КурсыВалютыРегл
	|		ПО (КурсыВалютыРегл.Валюта = &ВалютаРегламентированногоУчета
	|			И КурсыВалютыРегл.ПериодПланирования = &НачалоПериода)
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтКонтрагентыПартнеров КАК ВтКонтрагентыПартнеров
	|		ПО Услуги.Партнер = ВтКонтрагентыПартнеров.Партнер
	|	
	|ГДЕ
	|	Услуги.Ссылка = &Ссылка
	|	И &ОтражаетсяВБюджетировании
	|	И &Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)
	|
	|СГРУППИРОВАТЬ ПО
	|	//%АналитикаУслуги1,
	|	//%АналитикаУслуги2,
	|	//%АналитикаУслуги3,
	|	//%АналитикаУслуги4,
	|	//%АналитикаУслуги5,
	|	//%АналитикаУслуги6
	|	
	|ИМЕЮЩИЕ
	|	(СУММА(Услуги.Количество) <> 0 ИЛИ СУММА(Услуги.Сумма) <> 0)
	|";
	
	БюджетированиеСервер.УстановитьВЗапросеВыраженияЗаполненияАналитики(
		Запрос.Параметры.Ссылка, ТекстЗапроса, Запрос.Параметры.СтатьяБюджетов, Документы.АГ_ПланПродаж, "Товары");
		
	БюджетированиеСервер.УстановитьВЗапросеВыраженияЗаполненияАналитики(
		Запрос.Параметры.Ссылка, ТекстЗапроса, Запрос.Параметры.СтатьяБюджетов, Документы.АГ_ПланПродаж, "Услуги");
		
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтКонтрагентыПартнеров(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтКонтрагентыПартнеров";
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланПродажТовары.Партнер КАК Партнер,
	|	МАКСИМУМ(Контрагенты.Ссылка) КАК Контрагент
	|ПОМЕСТИТЬ ВтКонтрагентыПартнеров
	|ИЗ
	|	Документ.АГ_ПланПродаж.Товары КАК ПланПродажТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО ПланПродажТовары.Партнер = Контрагенты.Партнер
	|ГДЕ
	|	ПланПродажТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланПродажТовары.Партнер
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтПериодыПланирования(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПериодыПланирования";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&НачалоПериода КАК ПериодПланирования
	|ПОМЕСТИТЬ ВтПериодыПланирования
	|ГДЕ
	|	&ОтражаетсяВБюджетировании
	|	И &Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтКурсыВалюты(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтКурсыВалюты";
	
	УстановитьПараметрыЗапросаКурсыСценария(Запрос);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Курсы.Период,
	|	Курсы.Валюта,
	|	Курсы.Курс
	|ПОМЕСТИТЬ ВтКурсыВалюты
	|ИЗ
	|	&КурсыСценария КАК Курсы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Курсы.Валюта,
	|	Курсы.Период";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура УстановитьПараметрыЗапросаКурсыСценария(Запрос)
	
	Если Запрос.Параметры.Свойство("КурсыСценария") Тогда
		Возврат;
	КонецЕсли;
	
	КурсыСценария = Справочники.Сценарии.ТаблицаКурсовСценария(
		Запрос.Параметры.СценарийБюджетирования, , Запрос.Параметры.НачалоПериода, Запрос.Параметры.ОкончаниеПериода);
	
	Запрос.УстановитьПараметр("КурсыСценария", КурсыСценария);
	
КонецПроцедуры

Функция ТекстЗапросаВтПериодыКурсовВалюты(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПериодыКурсовВалюты";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВтПериодыПланирования.ПериодПланирования КАК ПериодПланирования,
	|	КурсыВалют.Валюта КАК Валюта,
	|	МАКСИМУМ(КурсыВалют.Период) КАК Период
	|ПОМЕСТИТЬ ВтПериодыКурсовВалюты
	|ИЗ
	|	ВтПериодыПланирования КАК ВтПериодыПланирования
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтКурсыВалюты КАК КурсыВалют
	|		ПО ВтПериодыПланирования.ПериодПланирования >= КурсыВалют.Период
	|			И (КурсыВалют.Валюта В (&Валюта, &ВалютаУправленческогоУчета, &ВалютаРегламентированногоУчета))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВтПериодыПланирования.ПериодПланирования,
	|	КурсыВалют.Валюта
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Период,
	|	Валюта";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтПрогнозныеКурсыВалюты(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПрогнозныеКурсыВалюты";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВтПериодыКурсовВалюты.ПериодПланирования КАК ПериодПланирования,
	|	ВтПериодыКурсовВалюты.Валюта КАК Валюта,
	|	КурсыВалют.Курс КАК Курс
	|ПОМЕСТИТЬ ВтПрогнозныеКурсыВалюты
	|ИЗ
	|	ВтПериодыКурсовВалюты КАК ВтПериодыКурсовВалюты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтКурсыВалюты КАК КурсыВалют
	|		ПО ВтПериодыКурсовВалюты.Период = КурсыВалют.Период
	|			И ВтПериодыКурсовВалюты.Валюта = КурсыВалют.Валюта
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта,
	|	ПериодПланирования";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПланыОплатКлиентов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПланыОплатКлиентов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтКонтрагентыПартнеров", ТекстыЗапроса) Тогда
		ТекстЗапросаВтКонтрагентыПартнеров(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтЭтапыГрафикаОплатыОсновногоСоглашения", ТекстыЗапроса) Тогда
		ТекстЗапросаВтЭтапыГрафикаОплатыОсновногоСоглашения(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Статус КАК Статус,
	|	ВЫБОР
	|		КОГДА ВтЭтапыГрафикаОплатыОсновногоСоглашения.ВариантОплаты В (ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитПослеОтгрузки), ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг))
	|			ТОГДА ДОБАВИТЬКДАТЕ(&НачалоПериода, ДЕНЬ, ВтЭтапыГрафикаОплатыОсновногоСоглашения.Сдвиг)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачалоПериода, ДЕНЬ, -ЕСТЬNULL(ВтЭтапыГрафикаОплатыОсновногоСоглашения.Сдвиг, 0))
	|	КОНЕЦ КАК Период,
	|	&Сценарий КАК Сценарий,
	|	ЕСТЬNULL(ВтЭтапыГрафикаОплатыОсновногоСоглашения.Договор, ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)) КАК Договор,
	|	ВложенныйЗапрос.Партнер КАК Партнер,
	|	ВложенныйЗапрос.Ссылка КАК План,
	|	СУММА(ВложенныйЗапрос.Сумма * ЕСТЬNULL(ВтЭтапыГрафикаОплатыОсновногоСоглашения.ПроцентПлатежа, 100) / 100) КАК Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТовары.Партнер КАК Партнер,
	|		ТаблицаТовары.Ссылка КАК Ссылка,
	|		ТаблицаТовары.Сумма КАК Сумма
	|	ИЗ
	|		Документ.АГ_ПланПродаж.Товары КАК ТаблицаТовары
	|	ГДЕ
	|		ТаблицаТовары.Ссылка = &Ссылка
	|		И ТаблицаТовары.Сумма <> 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаУслуги.Партнер,
	|		ТаблицаУслуги.Ссылка,
	|		ТаблицаУслуги.Сумма
	|	ИЗ
	|		Документ.АГ_ПланПродаж.Услуги КАК ТаблицаУслуги
	|	ГДЕ
	|		ТаблицаУслуги.Ссылка = &Ссылка
	|		И ТаблицаУслуги.Сумма <> 0) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтЭтапыГрафикаОплатыОсновногоСоглашения КАК ВтЭтапыГрафикаОплатыОсновногоСоглашения
	|		ПО ВложенныйЗапрос.Партнер = ВтЭтапыГрафикаОплатыОсновногоСоглашения.Партнер
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Партнер,
	|	ВложенныйЗапрос.Ссылка,
	|	ВЫБОР
	|		КОГДА ВтЭтапыГрафикаОплатыОсновногоСоглашения.ВариантОплаты В (ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитПослеОтгрузки), ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг))
	|			ТОГДА ДОБАВИТЬКДАТЕ(&НачалоПериода, ДЕНЬ, ВтЭтапыГрафикаОплатыОсновногоСоглашения.Сдвиг)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачалоПериода, ДЕНЬ, -ЕСТЬNULL(ВтЭтапыГрафикаОплатыОсновногоСоглашения.Сдвиг, 0))
	|	КОНЕЦ,
	|	ЕСТЬNULL(ВтЭтапыГрафикаОплатыОсновногоСоглашения.Договор, ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка))";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтЭтапыГрафикаОплатыОсновногоСоглашения(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтЭтапыГрафикаОплатыОсновногоСоглашения";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВтКонтрагентыПартнеров.Партнер КАК Партнер,
	|	ВтКонтрагентыПартнеров.Контрагент КАК Контрагент,
	|	ЕСТЬNULL(СоглашенияСКлиентамиЭтапыГрафикаОплаты.Ссылка.АГ_Договор, ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)) КАК Договор,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.ВариантОплаты КАК ВариантОплаты,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.Сдвиг КАК Сдвиг,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.ПроцентПлатежа КАК ПроцентПлатежа
	|ПОМЕСТИТЬ ВтЭтапыГрафикаОплатыОсновногоСоглашения
	|ИЗ
	|	ВтКонтрагентыПартнеров КАК ВтКонтрагентыПартнеров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СоглашенияСКлиентами.ЭтапыГрафикаОплаты КАК СоглашенияСКлиентамиЭтапыГрафикаОплаты
	|		ПО ВтКонтрагентыПартнеров.Контрагент = СоглашенияСКлиентамиЭтапыГрафикаОплаты.Ссылка.Контрагент
	|			И (СоглашенияСКлиентамиЭтапыГрафикаОплаты.Ссылка.АГ_Договор.АГ_Основной)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПланПродажПоКатегориям(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПланыПродажПоКатегориям";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
		
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Статус КАК Статус,
	|	&НачалоПериода КАК Период,
	|	&Сценарий КАК Сценарий,
	|	&Подразделение КАК Подразделение,
	|	&ВидПлана КАК ВидПлана,
	|	ВложенныйЗапрос.ПланПродажПоКатегориям КАК ПланПродажПоКатегориям,
	|	ВложенныйЗапрос.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТовары.Ссылка КАК ПланПродажПоКатегориям,
	|		ТаблицаТовары.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|		ТаблицаТовары.Количество КАК Количество
	|	ИЗ
	|		Документ.АГ_ПланПродаж.Товары КАК ТаблицаТовары
	|	ГДЕ
	|		ТаблицаТовары.Ссылка = &Ссылка
	|		И ТаблицаТовары.Количество <> 0
	|		И ТаблицаТовары.ТоварнаяКатегория <> ЗНАЧЕНИЕ(Справочник.ТоварныеКатегории.ПустаяСсылка)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаУслуги.Ссылка,
	|		ТаблицаУслуги.Номенклатура.ТоварнаяКатегория,
	|		ТаблицаУслуги.Количество
	|	ИЗ
	|		Документ.АГ_ПланПродаж.Услуги КАК ТаблицаУслуги
	|	ГДЕ
	|		ТаблицаУслуги.Ссылка = &Ссылка
	|		И ТаблицаУслуги.Количество <> 0
	|		И ТаблицаУслуги.Номенклатура.ТоварнаяКатегория <> ЗНАЧЕНИЕ(Справочник.ТоварныеКатегории.ПустаяСсылка)) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ПланПродажПоКатегориям,
	|	ВложенныйЗапрос.ТоварнаяКатегория";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

//<--АГ:[PLAN_0001_1][23.04.2019 19:07:51][Фирсанов О.И.]
Функция ТекстЗапросаТаблицаПланПродажПоКлиентамКатегориям(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "АГ_ПланыПродажПоКлиентамИКатегориям";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
		
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Статус КАК Статус,
	|	&НачалоПериода КАК Период,
	|	&Сценарий КАК Сценарий,
	|	&Подразделение КАК Подразделение,
	|	&Организация КАК Организация,
	|	ВложенныйЗапрос.Партнер КАК Партнер,
	|	ВложенныйЗапрос.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество,
	|	СУММА(ВложенныйЗапрос.КоличествоСкладАГ) КАК КоличествоСкладАГ,
	|	СУММА(ВложенныйЗапрос.КоличествоСкладТранзитный) КАК КоличествоСкладТранзитный,
	|	СУММА(ВложенныйЗапрос.Сумма) КАК Сумма,
	|	СУММА(ВложенныйЗапрос.СуммаСкладАГ) КАК СуммаСкладАГ,
	|	СУММА(ВложенныйЗапрос.СуммаСкладТранзитный) КАК СуммаСкладТранзитный,
	|	МАКСИМУМ(ВложенныйЗапрос.СкладАГ) КАК СкладАГ,
	|	МАКСИМУМ(ВложенныйЗапрос.СкладТранзитный) КАК СкладТранзитный
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТовары.Партнер КАК Партнер,
	|		ТаблицаТовары.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|		ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
	|		ТаблицаТовары.Количество КАК Количество,
	|		ТаблицаТовары.КоличествоСоСклада КАК КоличествоСкладАГ,
	|		ТаблицаТовары.КоличествоСТранзитногоСклада	КАК КоличествоСкладТранзитный,
	|		ТаблицаТовары.Сумма КАК Сумма,
	|		ТаблицаТовары.КоличествоСоСклада*ТаблицаТовары.Цена КАК СуммаСкладАГ,
	|		ТаблицаТовары.КоличествоСТранзитногоСклада*ТаблицаТовары.Цена КАК СуммаСкладТранзитный,
	|		ВЫБОР КОГДА ТаблицаТовары.КоличествоСоСклада>0 ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК СкладАГ,
	|		ВЫБОР КОГДА ТаблицаТовары.КоличествоСТранзитногоСклада>0 ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК СкладТранзитный
	|	ИЗ
	|		Документ.АГ_ПланПродаж.Товары КАК ТаблицаТовары
	|	ГДЕ
	|		ТаблицаТовары.Ссылка = &Ссылка
	|		И ТаблицаТовары.Количество <> 0
	|		И ТаблицаТовары.ТоварнаяКатегория <> ЗНАЧЕНИЕ(Справочник.ТоварныеКатегории.ПустаяСсылка)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаУслуги.Партнер КАК Партнер,
	|		ТаблицаУслуги.Номенклатура.ТоварнаяКатегория,
	|		ТаблицаУслуги.Номенклатура,
	|		ТаблицаУслуги.Количество,
	|		0,
	|		0,		
	|		ТаблицаУслуги.Сумма,
	|		0,
	|		0,
	|		ЛОЖЬ,
	|		ЛОЖЬ
	|	ИЗ
	|		Документ.АГ_ПланПродаж.Услуги КАК ТаблицаУслуги
	|	ГДЕ
	|		ТаблицаУслуги.Ссылка = &Ссылка
	|		И ТаблицаУслуги.Количество <> 0
	|		И ТаблицаУслуги.Номенклатура.ТоварнаяКатегория <> ЗНАЧЕНИЕ(Справочник.ТоварныеКатегории.ПустаяСсылка)) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Партнер,
	|	ВложенныйЗапрос.ТоварнаяКатегория,
	|	ВложенныйЗапрос.Номенклатура";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-->АГ:[ PLAN_0001_1 ]

//<--АГ:[PLAN_0001_1][03.05.2019 16:07:51][Фирсанов О.И.]
Функция ТекстЗапросаТаблицаПланыОплатКлиентовПоДаннымМенеджера(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "АГ_ПланыОплатКлиентовПоДаннымМенеджера";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
		
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Статус КАК Статус,
	|	&НачалоПериода КАК Период,
	|	&Сценарий КАК Сценарий,
	|	ВложенныйЗапрос.Партнер КАК Партнер,
	|	СУММА(ВложенныйЗапрос.Сумма) КАК Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПартнеры.Партнер КАК Партнер,
	|		ТаблицаПартнеры.КорректировкаПлановогоПоступленияДС КАК Сумма
	|	ИЗ
	|		Документ.АГ_ПланПродаж.Партнеры КАК ТаблицаПартнеры
	|	ГДЕ
	|		ТаблицаПартнеры.Ссылка = &Ссылка
	|		И ТаблицаПартнеры.КорректировкаПлановогоПоступленияДС <> 0
	|	) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Партнер";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-->АГ:[ PLAN_0001_1 ]


#КонецОбласти

#КонецЕсли
