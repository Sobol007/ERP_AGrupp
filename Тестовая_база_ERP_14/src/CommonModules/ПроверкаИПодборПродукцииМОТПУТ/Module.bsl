#Область ПрограмныйИнтерфейс

Процедура ЕстьТабачнаяПродукцияВКоллекции(Коллекция, ЕстьТабачнаяПродукция) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаТовары", Коллекция.Выгрузить(, "Номенклатура"));

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ
	|	ВремТаблТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|
	|;
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьТабачнаяПродукция
	|ИЗ
	|	ВремТаблТаблицаТовары КАК ТаблицаТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТаблицаТовары.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	СправочникНоменклатура.ТабачнаяПродукция
	|";
	
	Результат = Запрос.Выполнить();
	
	ЕстьТабачнаяПродукция = НЕ Результат.Пустой();
	
КонецПроцедуры

Функция ТаблицаТабачнойПродукцииДокумента(Контекст) Экспорт
	
	ТаблицаТабачнойПродукции = ТаблицаТабачнойПродукции();
	
	Если ИнтеграцияМОТПУТКлиентСервер.ЭтоДокументПриобретения(Контекст) Тогда
		ВыборкаТабачнойПродукции = ВыборкаТабачнойПродукцииПриобретениеТоваровУслуг(Контекст);
	ИначеЕсли ИнтеграцияМОТПУТКлиентСервер.ЭтоЧекККМ(Контекст)
		Или ИнтеграцияМОТПУТКлиентСервер.ЭтоЧекККМВозврат(Контекст)
	Тогда
		ВыборкаТабачнойПродукции = ВыборкаТабачнойПродукцииЧекККМ(Контекст);
	ИначеЕсли ИнтеграцияМОТПУТКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "РеализацияТоваровУслуг") Тогда
		ВыборкаТабачнойПродукции = ВыборкаТабачнойПродукцииРеализацияТоваровУслуг(Контекст);
	ИначеЕсли ИнтеграцияМОТПУТКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "ВозвратТоваровПоставщику") Тогда
		ВыборкаТабачнойПродукции = ВыборкаТабачнойПродукцииВозвратТоваровПоставщику(Контекст);
	ИначеЕсли ИнтеграцияМОТПУТКлиентСервер.ЭтоДокументПоНаименованию(Контекст, "РеализацияТоваровУслуг") Тогда
		ВыборкаТабачнойПродукции = ВыборкаТабачнойПродукцииКорректировкаРеализации(Контекст);
	Иначе
		Возврат ТаблицаТабачнойПродукции;
	КонецЕсли;
	
	Пока ВыборкаТабачнойПродукции.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаТабачнойПродукции.Добавить(), ВыборкаТабачнойПродукции);
	КонецЦикла;
	
	Возврат ТаблицаТабачнойПродукции;
		
КонецФункции

// Заполняет в табличной части служебные реквизиты, например: признак использования характеристик номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  ТабличнаяЧасть - ДанныеФормыКоллекция, ТаблицаЗначений - таблица для заполнения.
//
Процедура ЗаполнитьСлужебныеРеквизитыВКоллекции(Форма, ТабличнаяЧасть) Экспорт
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
		
	ПараметрыЗаполненияРеквизитов.Вставить(
		"ЗаполнитьПризнакХарактеристикиИспользуются",
		Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	ПараметрыЗаполненияРеквизитов.Вставить(
		"ЗаполнитьПризнакТипНоменклатуры",
		Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		ТабличнаяЧасть, ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

#Область СерииНоменклатуры

// Определяет параметры указания серий для товаров, указанных в форме.
//
// Параметры:
//		Форма						- УправляемаяФорма	- форма с товарами, для которой необходимо определить параметры указания серий.
//		ПараметрыУказанияСерий	- Структура			- заполняемые параметры указания серий, состав полей структуры задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Процедура ЗаполнитьПараметрыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта                  = Форма.ИмяФормы;
	ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта = "ЭтотОбъект";
	
	ПараметрыУказанияСерий.ИмяТЧТовары       = "ПодобраннаяТабачнаяПродукция";
	ПараметрыУказанияСерий.ИмяТЧСерии        = "ПодобраннаяТабачнаяПродукция";
	ПараметрыУказанияСерий.ИмяПоляСклад      = "Склад";
	ПараметрыУказанияСерий.ИмяПоляКоличество = "Количество";
	
	ПараметрыУказанияСерий.ИменаПолейДополнительные.Добавить("КоличествоПодобрано");
	
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Форма.Склад, Ложь);

	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры
																	Или ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерий.Дата = ТекущаяДатаСеанса();
	
КонецПроцедуры

// Формирует текст запроса для расчета статусов указания серий
//	Параметры:
//		ТекстЗапроса				- Строка		- формируемый текст запроса.
//		ПараметрыУказанияСерий	- Структура	- состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//
Процедура СформироватьТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий, ТекстЗапроса) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	Товары.Номенклатура,
	|	Товары.Серия,
	|	Товары." + ПараметрыУказанияСерий.ИмяПоляКоличество + " КАК Количество,";
	
	Для Каждого ИмяПоля Из ПараметрыУказанияСерий.ИменаПолейДополнительные Цикл
		ТекстЗапроса = ТекстЗапроса + "
		|	Товары." + ИмяПоля + " КАК " + ИмяПоля + ",";
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,";
	
	Если ПараметрыУказанияСерий.ПроверяемыйДокумент = "ЧекККМ"
	 Или ПараметрыУказанияСерий.ПроверяемыйДокумент = "ЧекККМВозврат" Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	ВЫБОР
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL
		|			ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий = ЗНАЧЕНИЕ(Справочник.ПолитикиУчетаСерий.ПустаяСсылка)
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|			ТОГДА ВЫБОР
		|				КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|					И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|					ТОГДА 14
		|				ИНАЧЕ 13
		|			КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
		|			ТОГДА ВЫБОР
		|				КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|					И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|					ТОГДА 10
		|				ИНАЧЕ 9
		|			КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
		|			ТОГДА ВЫБОР
		|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчетСерийПоFEFO
		|					ТОГДА ВЫБОР
		|						КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|							И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|							ТОГДА 6
		|						ИНАЧЕ 5
		|					КОНЕЦ
		|				ИНАЧЕ ВЫБОР
		|					КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|						И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 8
		|					ИНАЧЕ 7
		|				КОНЕЦ
		|			КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
		|			И ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеВРозницу
		|			ТОГДА ВЫБОР
		|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
		|					ТОГДА ВЫБОР
		|						КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|							И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|							ТОГДА 4
		|						ИНАЧЕ 3
		|					КОНЕЦ
		|				ИНАЧЕ ВЫБОР
		|					КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|						И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 2
		|					ИНАЧЕ 1
		|				КОНЕЦ
		|			КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СтатусУказанияСерий";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|	ВЫБОР
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL
		|			ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий = ЗНАЧЕНИЕ(Справочник.ПолитикиУчетаСерий.ПустаяСсылка)
		|			ТОГДА 0
		|		ИНАЧЕ ВЫБОР
		|			КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
		|				ТОГДА ВЫБОР
		|					КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|						И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА ВЫБОР
		|							КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|								ТОГДА 14
		|							ИНАЧЕ 10
		|						КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|						КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|							ТОГДА 13
		|						ИНАЧЕ 9
		|					КОНЕЦ
		|				КОНЕЦ
		|			КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
		|				ТОГДА ВЫБОР
		|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчетСерийПоFEFO
		|						ТОГДА ВЫБОР
		|							КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|								И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|								ТОГДА 6
		|							ИНАЧЕ 5
		|						КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|						КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|							И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|							ТОГДА 8
		|						ИНАЧЕ 7
		|					КОНЕЦ
		|				КОНЕЦ
		|			КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке
		|				И (ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеОтПоставщика
		|					И &ПриемкаОтПоставщика
		|				  ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеПоВозвратуОтКлиента
		|					И &ПриемкаПоВозвратуОтКлиента
		|				  ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеПоПеремещению
		|					И &ПриемкаПоПеремещению
		|				  ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеПоПрочемуОприходованию
		|					И &ПриемкаПоПрочемуОприходованию)
		|				ТОГДА ВЫБОР
		|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
		|						ТОГДА ВЫБОР
		|							КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|								И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|								ТОГДА 4
		|							ИНАЧЕ 3
		|						КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|						КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|							И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|							ТОГДА 2
		|						ИНАЧЕ 1
		|					КОНЕЦ
		|				КОНЕЦ
		|			КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
		|				И (ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеКлиенту
		|					И &ОтгрузкаКлиенту
		|				  ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеНаВнутренниеНужды
		|					И &ОтгрузкаНаВнутренниеНужды
		|				  ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеПоВозвратуПоставщику
		|					И &ОтгрузкаПоВозвратуПоставщику
		|				  ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеПоПеремещению
		|					И &ОтгрузкаПоПеремещению)
		|				ТОГДА ВЫБОР
		|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
		|						ТОГДА ВЫБОР
		|							КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|								И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|								ТОГДА 4
		|							ИНАЧЕ 3
		|						КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|						КОГДА (Товары.Количество <> 0 ИЛИ Товары.КоличествоПодобрано <> 0)
		|							И Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|							ТОГДА 2
		|						ИНАЧЕ 1
		|					КОНЕЦ
		|				КОНЕЦ
		|			ИНАЧЕ 0
		|		КОНЕЦ
		|	КОНЕЦ КАК СтатусУказанияСерий";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|ПОМЕСТИТЬ ТаблицаСтатусов
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО (ПолитикиУчетаСерий.Склад = &Склад)
	|			И (ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСтатусов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаСтатусов.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ИЗ
	|	ТаблицаСтатусов КАК ТаблицаСтатусов
	|ГДЕ
	|	ТаблицаСтатусов.СтарыйСтатусУказанияСерий <> ТаблицаСтатусов.СтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
КонецПроцедуры

Процедура ЗаполнитьСтатусыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Форма, ПараметрыУказанияСерий);
	
КонецПроцедуры

Процедура ОпределитьПравоДобавлениеСерий(ПравоДобавлениеСерий) Экспорт
	
	ПравоДобавлениеСерий = ПравоДоступа("Добавление", Метаданные.Справочники.СерииНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ТаблицаТабачнойПродукцииДокумента
	

// Формирует пустую таблицу табачной продукции
// 
// Параметры:
// Возвращаемое значение:
// 	ТаблицаЗначений - таблица определяющая состав табачной продукции документа:
// * GTIN           - ОпределяемыйТип.GTIN                       - штрихкод
// * Номенклатура   - ОпределяемыйТип.Номенклатура               - номенклатура
// * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика
// * Серия          - ОпределяемыйТип.СерияНоменклатуры          - серия
// * Количество     - Число                                      - количество
Функция ТаблицаТабачнойПродукции()

	ТаблицаТабачнойПродукции = Новый ТаблицаЗначений();
	ТаблицаТабачнойПродукции.Колонки.Добавить("GTIN",           Метаданные.ОпределяемыеТипы.GTIN.Тип);
	ТаблицаТабачнойПродукции.Колонки.Добавить("Номенклатура",   Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ТаблицаТабачнойПродукции.Колонки.Добавить("Характеристика", Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ТаблицаТабачнойПродукции.Колонки.Добавить("Серия",          Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ТаблицаТабачнойПродукции.Колонки.Добавить("Количество",     Новый ОписаниеТипов("Число"));
	
	Возврат ТаблицаТабачнойПродукции;
	
КонецФункции

Функция ВыборкаТабачнойПродукцииПриобретениеТоваровУслуг(Документ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументСсылка", Документ);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """")      КАК GTIN,
	|	ПриобретениеТоваровУслугТовары.Номенклатура         КАК Номенклатура,
	|	ПриобретениеТоваровУслугТовары.Характеристика       КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	ПриобретениеТоваровУслугТовары.Количество           КАК Количество
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК ПриобретениеТоваровУслугТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ПриобретениеТоваровУслугТовары.Номенклатура = СправочникНоменклатура.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО ПриобретениеТоваровУслугТовары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|		 И ПриобретениеТоваровУслугТовары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|		 И СправочникНоменклатура.ЕдиницаИзмерения = ШтрихкодыНоменклатуры.Упаковка
	|ГДЕ
	|	ПриобретениеТоваровУслугТовары.Ссылка = &ДокументСсылка
	|	И СправочникНоменклатура.ТабачнаяПродукция
	|";
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выбрать();
	
КонецФункции

Функция ВыборкаТабачнойПродукцииЧекККМ(Форма)
	
	Товары = Форма.Объект.Товары.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.Количество КАК Количество
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """") КАК GTIN,
	|	ВТ_Товары.Номенклатура КАК Номенклатура,
	|	ВТ_Товары.Характеристика КАК Характеристика,
	|	ВТ_Товары.Серия КАК Серия,
	|	СУММА(ВТ_Товары.Количество) КАК Количество
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ВТ_Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО ВТ_Товары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|		И ВТ_Товары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|		И СправочникНоменклатура.ЕдиницаИзмерения = ШтрихкодыНоменклатуры.Упаковка
	|ГДЕ
	|	СправочникНоменклатура.ТабачнаяПродукция
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """"),
	|	ВТ_Товары.Номенклатура,
	|	ВТ_Товары.Характеристика,
	|	ВТ_Товары.Серия";
	
	Запрос.УстановитьПараметр("Товары", Товары);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция ВыборкаТабачнойПродукцииРеализацияТоваровУслуг(Документ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументСсылка", Документ);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """")) КАК GTIN,
	|	Товары.Номенклатура                                      КАК Номенклатура,
	|	Товары.Характеристика                                    КАК Характеристика,
	|	ЕСТЬNULL(Серии.Серия, Товары.Серия)                      КАК Серия,
	|	ЕСТЬNULL(Серии.Количество, Товары.Количество)            КАК Количество
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК Товары
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Серии КАК Серии
	|		ПО Товары.Ссылка = Серии.Ссылка
	|		И Товары.Номенклатура = Серии.Номенклатура
	|		И Товары.Характеристика = Серии.Характеристика
	|		И Товары.Назначение = Серии.Назначение
	|		И Товары.Склад = Серии.Склад
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО Товары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|		 И Товары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|		 И СправочникНоменклатура.ЕдиницаИзмерения = ШтрихкодыНоменклатуры.Упаковка
	|ГДЕ
	|	Товары.Ссылка = &ДокументСсылка
	|	И СправочникНоменклатура.ТабачнаяПродукция
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	ЕСТЬNULL(Серии.Серия, Товары.Серия),
	|	ЕСТЬNULL(Серии.Количество, Товары.Количество)";
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выбрать();
	
КонецФункции

Функция ВыборкаТабачнойПродукцииВозвратТоваровПоставщику(Документ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументСсылка", Документ);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """")) КАК GTIN,
	|	Товары.Номенклатура                                      КАК Номенклатура,
	|	Товары.Характеристика                                    КАК Характеристика,
	|	ЕСТЬNULL(Серии.Серия, Товары.Серия)                      КАК Серия,
	|	ЕСТЬNULL(Серии.Количество, Товары.Количество)            КАК Количество
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровПоставщику.Серии КАК Серии
	|		ПО Товары.Ссылка = Серии.Ссылка
	|		И Товары.Номенклатура = Серии.Номенклатура
	|		И Товары.Характеристика = Серии.Характеристика
	|		И Товары.Назначение = Серии.Назначение
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО Товары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|		И Товары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|		И СправочникНоменклатура.ЕдиницаИзмерения = ШтрихкодыНоменклатуры.Упаковка
	|ГДЕ
	|	Товары.Ссылка = &ДокументСсылка
	|	И СправочникНоменклатура.ТабачнаяПродукция
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	ЕСТЬNULL(Серии.Серия, Товары.Серия),
	|	ЕСТЬNULL(Серии.Количество, Товары.Количество)";
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выбрать();
	
КонецФункции

Функция ВыборкаТабачнойПродукцииКорректировкаРеализации(Документ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументСсылка", Документ);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """")) КАК GTIN,
	|	Товары.Номенклатура                                      КАК Номенклатура,
	|	Товары.Характеристика                                    КАК Характеристика,
	|	Товары.Серия                                             КАК Серия,
	|	Товары.Количество                                        КАК Количество
	|ИЗ
	|	Документ.КорректировкаРеализации.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО Товары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|		И Товары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|		И СправочникНоменклатура.ЕдиницаИзмерения = ШтрихкодыНоменклатуры.Упаковка
	|ГДЕ
	|	Товары.Ссылка = &ДокументСсылка
	|	И СправочникНоменклатура.ТабачнаяПродукция
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Серия,
	|	Товары.Количество";
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выбрать();
	
КонецФункции

#КонецОбласти

#КонецОбласти
