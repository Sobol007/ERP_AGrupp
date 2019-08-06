#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область СтандартныеПодсистемыКоманды

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд создания на основании.
//
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании.
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	АктВыполненныхВнутреннихРаботЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Заполняет список команд создания на основании.
//
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании.
// Возвращаемое значение:
//   КомандаФормы - Добавленная Команда.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.АктВыполненныхВнутреннихРабот) Тогда
		
		КомандаСоздатьНаОсновании						= КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик			= "ПроизводствоКлиент.СоздатьАктВыполненныхВнутреннихРаботНаОсновании";
		КомандаСоздатьНаОсновании.Менеджер				= "Документ.АктВыполненныхВнутреннихРабот";
		КомандаСоздатьНаОсновании.Идентификатор			= "СозданиеАктаВыполненныхВнутреннихРабот";
		КомандаСоздатьНаОсновании.Представление			= ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.АктВыполненныхВнутреннихРабот);
		КомандаСоздатьНаОсновании.РежимЗаписи			= "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции	= "ИспользоватьУправлениеПроизводством2_2";
		КомандаСоздатьНаОсновании.МножественныйВыбор	= Истина;
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Заполняет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	АктВыполненныхВнутреннихРаботЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	АктВыполненныхВнутреннихРаботЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

// Инициализирует параметры, обслуживающие выбор назначений в формах документа.
//
//  Возвращаемое значение:
//  Структура - структура параметров, см. Справочники.Назначения.МакетФормыВыбораНазначений().
//
Функция МакетФормыВыбораНазначений() Экспорт
	
	МакетФормы = Справочники.Назначения.МакетФормыВыбораНазначений();
	
	ШаблонНазначения = Справочники.Назначения.ДобавитьШаблонНазначений(МакетФормы, "Объект.Товары.Назначение");
	ШаблонНазначения.НаправлениеДеятельности  = "Объект.НаправлениеДеятельности";
	ШаблонНазначения.ТипыНазначений.Удалить(ШаблонНазначения.ТипыНазначений.Найти(Перечисления.ТипыНазначений.Давальческое21));
	ШаблонНазначения.ТипыНазначений.Удалить(ШаблонНазначения.ТипыНазначений.Найти(Перечисления.ТипыНазначений.ДавальческоеПродукция22));
	
	// Потребности в выпущенных работах в подразделении-получателе.
	ОписаниеКолонок = Справочники.Назначения.ДобавитьОписаниеКолонок(МакетФормы, "ОбеспечениеЗаказовРаботами", Истина, "Объект.Товары.Назначение");
	ОписаниеКолонок.Колонки.НайтиПоЗначению("Потребность").Пометка = Истина;
	ОписаниеКолонок.УсловиеИспользования = "Объект.Товары.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)";
	
	ОписаниеКолонок.ПутиКДанным.Номенклатура     = "Объект.Товары.Номенклатура";
	ОписаниеКолонок.ПутиКДанным.Характеристика   = "Объект.Товары.Характеристика";
	ОписаниеКолонок.ПутиКДанным.Подразделение    = "Объект.Товары.Подразделение";
	
	Возврат МакетФормы;
	
КонецФункции

#Область УчетНДС

// Инициализирует параметры заполнения вида деятельности НДС
//
// Параметры:
//  Объект		- ДокументОбъект.АктВыполненныхВнутреннихРабот, ДанныеФормыСтруктура	- документ, для которого необходимо получить параметры.
//
// Возвращаемое значение:
//  Структура - структура параметров, см. УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС().
//
Функция ПараметрыЗаполненияВидаДеятельностиНДС(Объект) Экспорт
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС();
	ПараметрыЗаполнения.Дата								= Объект.Дата;
	ПараметрыЗаполнения.НаправлениеДеятельности				= Объект.НаправлениеДеятельности;
	ПараметрыЗаполнения.ДвижениеТоваровИРаботВПроизводстве	= Истина;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами Тогда
		ПараметрыЗаполнения.Организация = Объект.ОрганизацияПолучатель;
	Иначе
		ПараметрыЗаполнения.Организация = Объект.Организация;
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

#Область Инициализация

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.АктВыполненныхВнутреннихРабот";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ТекстыЗапросаВременныхТаблиц = Новый Соответствие;
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		ТекстыЗапросаВременныхТаблиц.Вставить("ВтПодразделения", ТекстЗапросаВтПодразделения(Запрос, ТекстыЗапроса));
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров,
										ТекстыЗапросаВременныхТаблиц);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	// Создание запроса инициализации движений и заполенение его параметров.
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	// Формирование текста запроса.
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаТаблицаДвиженияНоменклатураНоменклатура(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаМатериалыИРаботыВПроизводстве(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСебестоимостьТоваров(Запрос, ТекстыЗапроса, Регистры);
	
	// Исполнение запроса и выгрузка полученных таблиц для движений.
	АктВыполненныхВнутреннихРаботЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)

	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);

	Запрос.Текст =
		"ВЫБРАТЬ
		|	Реквизиты.Ссылка						КАК Ссылка,
		|	Реквизиты.Проведен						КАК Проведен,
		|	Реквизиты.ПометкаУдаления				КАК ПометкаУдаления,
		|	Реквизиты.Номер							КАК Номер,
		|	Реквизиты.Дата							КАК Дата,
		|	Реквизиты.Организация					КАК Организация,
		|	Реквизиты.ОрганизацияПолучатель			КАК ОрганизацияПолучатель,
		|	Реквизиты.Подразделение					КАК Подразделение,
		|	Реквизиты.ХозяйственнаяОперация			КАК ХозяйственнаяОперация,
		|	Реквизиты.ПеремещениеПодДеятельность	КАК ПеремещениеПодДеятельность,
		|	Реквизиты.НаправлениеДеятельности		КАК НаправлениеДеятельности,
		|	Реквизиты.Ответственный					КАК Ответственный,
		|	Реквизиты.Комментарий					КАК Комментарий
		|ИЗ
		|	Документ.АктВыполненныхВнутреннихРабот КАК Реквизиты
		|ГДЕ
		|	Реквизиты.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
	ПараметрыПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для Каждого ТекПараметр Из ПараметрыПроведения Цикл
		Запрос.УстановитьПараметр(ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;
	
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.АктВыполненныхВнутреннихРабот"));

	ЗначенияПараметровПроведения.Вставить("ФормироватьВидыЗапасовПоГруппамФинансовогоУчета",
								ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоГруппамФинансовогоУчета"));
	
	ЗначенияПараметровПроведения.Вставить("АналитическийУчетПоГруппамПродукции",
								ПолучитьФункциональнуюОпцию("АналитическийУчетПоГруппамПродукции"));
	
								
	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ИнициализироватьКлючиАналитикиНоменклатуры(Запрос)

	Если Запрос = Неопределено
		ИЛИ Запрос.Параметры.Свойство("КлючиАналитикиНоменклатурыИнициализированы") Тогда
		Возврат;
	КонецЕсли;
	
	ЗапросАналитики = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Склад КАК Склад,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Назначение КАК Назначение,
	|	ТаблицаТовары.Серия КАК Серия,
	|	ТаблицаТовары.СтатьяКалькуляции КАК СтатьяКалькуляции
	|ИЗ
	|	(
	// аналитика отправителя работ без назначения
	|	ВЫБРАТЬ
	|		Работы.Номенклатура									КАК Номенклатура,
	|		Работы.Характеристика								КАК Характеристика,
	|		ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)	КАК Серия,
	|		&Подразделение										КАК Склад,
	|		ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)		КАК Назначение,
	|		ЗНАЧЕНИЕ(Справочник.СтатьиКалькуляции.ПустаяСсылка)	КАК СтатьяКалькуляции
	|	ИЗ
	|		Документ.АктВыполненныхВнутреннихРабот.Товары КАК Работы
	|	ГДЕ
	|		Работы.Ссылка = &Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	// аналитика получателя работ
	|	ВЫБРАТЬ
	|		Работы.Номенклатура									КАК Номенклатура,
	|		Работы.Характеристика								КАК Характеристика,
	|		ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)	КАК Серия,
	|		Работы.Подразделение								КАК Склад,
	|		Работы.Назначение									КАК Назначение,
	|		ЗНАЧЕНИЕ(Справочник.СтатьиКалькуляции.ПустаяСсылка)	КАК СтатьяКалькуляции
	|	ИЗ
	|		Документ.АктВыполненныхВнутреннихРабот.Товары КАК Работы
	|	ГДЕ
	|		Работы.Ссылка = &Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	// аналитика получателя работ без назначения
	|	ВЫБРАТЬ
	|		Работы.Номенклатура									КАК Номенклатура,
	|		Работы.Характеристика								КАК Характеристика,
	|		ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)	КАК Серия,
	|		Работы.Подразделение								КАК Склад,
	|		ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)		КАК Назначение,
	|		ЗНАЧЕНИЕ(Справочник.СтатьиКалькуляции.ПустаяСсылка)	КАК СтатьяКалькуляции
	|	ИЗ
	|		Документ.АктВыполненныхВнутреннихРабот.Товары КАК Работы
	|	ГДЕ
	|		Работы.Ссылка = &Ссылка
	|	) КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаТовары.Номенклатура = Аналитика.Номенклатура
	|			И ТаблицаТовары.Характеристика = Аналитика.Характеристика
	|			И ТаблицаТовары.Серия = Аналитика.Серия
	|			И ТаблицаТовары.Склад = Аналитика.МестоХранения
	|			И ТаблицаТовары.Назначение = Аналитика.Назначение
	|			И ТаблицаТовары.СтатьяКалькуляции = Аналитика.СтатьяКалькуляции
	|ГДЕ
	|	Аналитика.Номенклатура ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Склад,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ТаблицаТовары.Назначение,
	|	ТаблицаТовары.Серия,
	|	ТаблицаТовары.СтатьяКалькуляции");
	
	ЗапросАналитики.УстановитьПараметр("Ссылка", Запрос.Параметры.Ссылка);
	ЗапросАналитики.УстановитьПараметр("Подразделение", Запрос.Параметры.Подразделение);
	
	Выборка = ЗапросАналитики.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РегистрыСведений.АналитикаУчетаНоменклатуры.СоздатьКлючАналитики(Выборка)
	КонецЦикла;

	Запрос.УстановитьПараметр("КлючиАналитикиНоменклатурыИнициализированы", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ПроведениеПоРеглУчету

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса.
//
Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат АктВыполненныхВнутреннихРаботЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламетированном учете.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат АктВыполненныхВнутреннихРаботЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

#КонецОбласти

#Область ТекстыЗапросовПроведения

#Область ТекстыЗапросовВременныеТаблицы

Функция ТекстЗапросаВтПодразделения(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПодразделения";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Подразделения.Ссылка КАК Ссылка,
	|	Подразделения.Организация КАК Организация,
	|	Подразделения.Подразделение КАК Подразделение,
	|	Подразделения.ДополнительнаяЗапись КАК ДополнительнаяЗапись
	|ПОМЕСТИТЬ ВтПодразделения
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДанныеДокумента.Ссылка КАК Ссылка,
	|		ДанныеДокумента.Организация КАК Организация,
	|		ДанныеДокумента.Подразделение КАК Подразделение,
	|		ЛОЖЬ КАК ДополнительнаяЗапись
	|	ИЗ
	|		Документ.АктВыполненныхВнутреннихРабот КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Ссылка = &Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Ссылка,
	|		ВЫБОР
	|			КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|				ТОГДА &ОрганизацияПолучатель
	|			ИНАЧЕ &Организация
	|		КОНЕЦ,
	|		ДанныеДокумента.Подразделение,
	|		ИСТИНА
	|	ИЗ
	|		Документ.АктВыполненныхВнутреннихРабот.Товары КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Ссылка = &Ссылка
	|		И (НЕ ДанныеДокумента.Подразделение = &Подразделение
	|				ИЛИ &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами))) КАК Подразделения
	|
	|СГРУППИРОВАТЬ ПО
	|	Подразделения.Ссылка,
	|	Подразделения.Подразделение,
	|	Подразделения.ДополнительнаяЗапись,
	|	Подразделения.Организация";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтТовары(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтТовары";
	
	ИнициализироватьКлючиАналитикиНоменклатуры(Запрос);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Работы.АналитикаУчетаНоменклатуры				КАК АналитикаНоменклатуры,
	|	КлючиНоменклатурыБезНазначения.КлючАналитики	КАК АналитикаНоменклатурыБезНазначения,
	|	КлючиПоПолучателю.КлючАналитики					КАК АналитикаНоменклатурыПоПолучателю,
	|	КлючиПоПолучателюБезНазначения.КлючАналитики	КАК АналитикаНоменклатурыПоПолучателюБезНазначения,
	|	Работы.Подразделение							КАК ПодразделениеПолучатель,
	|	Работы.Номенклатура								КАК Номенклатура,
	|	Работы.Характеристика							КАК Характеристика,
	|	Работы.Назначение								КАК Назначение,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(Работы.Назначение.ВидДеятельностиНДС,ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|			ТОГДА Работы.Назначение.ВидДеятельностиНДС
	|		ИНАЧЕ &ПеремещениеПодДеятельность
	|	КОНЕЦ 											КАК ВидДеятельностиНДС,
	|	ВЫБОР
	|		КОГДА &АналитическийУчетПоГруппамПродукции
	|			И НЕ СпрНоменклатура.ГруппаАналитическогоУчета = ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)
	|			ТОГДА СпрНоменклатура.ГруппаАналитическогоУчета
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ											КАК ГруппаПродукцииОтправитель,
	|	ВЫБОР
	|		КОГДА &АналитическийУчетПоГруппамПродукции
	|			И НЕ Работы.ГруппаПродукции = ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)
	|			ТОГДА Работы.ГруппаПродукции
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ											КАК ГруппаПродукции,
	|	СУММА(Работы.Количество)						КАК Количество
	|ПОМЕСТИТЬ втТовары
	|ИЗ
	|	Документ.АктВыполненныхВнутреннихРабот.Товары КАК Работы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК КлючиНоменклатурыБезНазначения
	|			ПО КлючиНоменклатурыБезНазначения.Номенклатура		= Работы.Номенклатура
	|			И КлючиНоменклатурыБезНазначения.Характеристика		= Работы.Характеристика
	|			И КлючиНоменклатурыБезНазначения.Серия				= ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			И КлючиНоменклатурыБезНазначения.МестоХранения		= &Подразделение
	|			И КлючиНоменклатурыБезНазначения.Назначение			= ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			И КлючиНоменклатурыБезНазначения.СтатьяКалькуляции	= ЗНАЧЕНИЕ(Справочник.СтатьиКалькуляции.ПустаяСсылка)
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК КлючиПоПолучателю
	|			ПО КлючиПоПолучателю.Номенклатура		= Работы.Номенклатура
	|			И КлючиПоПолучателю.Характеристика		= Работы.Характеристика
	|			И КлючиПоПолучателю.Серия				= ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			И КлючиПоПолучателю.МестоХранения		= Работы.Подразделение
	|			И КлючиПоПолучателю.Назначение			= Работы.Назначение
	|			И КлючиПоПолучателю.СтатьяКалькуляции	= ЗНАЧЕНИЕ(Справочник.СтатьиКалькуляции.ПустаяСсылка)
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК КлючиПоПолучателюБезНазначения
	|			ПО КлючиПоПолучателюБезНазначения.Номенклатура		= Работы.Номенклатура
	|			И КлючиПоПолучателюБезНазначения.Характеристика		= Работы.Характеристика
	|			И КлючиПоПолучателюБезНазначения.Серия				= ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			И КлючиПоПолучателюБезНазначения.МестоХранения		= Работы.Подразделение
	|			И КлючиПоПолучателюБезНазначения.Назначение			= ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			И КлючиПоПолучателюБезНазначения.СтатьяКалькуляции	= ЗНАЧЕНИЕ(Справочник.СтатьиКалькуляции.ПустаяСсылка)
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|			ПО СпрНоменклатура.Ссылка = Работы.Номенклатура
	|ГДЕ
	|	Работы.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	КлючиПоПолучателюБезНазначения.КлючАналитики,
	|	Работы.Назначение,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(Работы.Назначение.ВидДеятельностиНДС,ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|			ТОГДА Работы.Назначение.ВидДеятельностиНДС
	|		ИНАЧЕ &ПеремещениеПодДеятельность
	|	КОНЕЦ,
	|	Работы.Характеристика,
	|	КлючиНоменклатурыБезНазначения.КлючАналитики,
	|	Работы.Номенклатура,
	|	Работы.АналитикаУчетаНоменклатуры,
	|	ВЫБОР
	|		КОГДА &АналитическийУчетПоГруппамПродукции
	|			И НЕ СпрНоменклатура.ГруппаАналитическогоУчета = ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)
	|			ТОГДА СпрНоменклатура.ГруппаАналитическогоУчета
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА &АналитическийУчетПоГруппамПродукции
	|			И НЕ Работы.ГруппаПродукции = ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)
	|			ТОГДА Работы.ГруппаПродукции
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	Работы.Подразделение,
	|	КлючиПоПолучателю.КлючАналитики";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

Функция ТекстЗапросаТаблицаСебестоимостьТоваров(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	ИмяРегистра = "СебестоимостьТоваров";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	// Расход работ с отправителя
	"ВЫБРАТЬ
	|	&Дата																			КАК Период,
	|	&Ссылка																			КАК ДокументДвижения,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)											КАК ВидДвижения,
	|	НЕОПРЕДЕЛЕНО																	КАК ИдентификаторСтроки,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.Потребление)							КАК ТипЗаписи,
	|	&ХозяйственнаяОперация															КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)	КАК РазделУчета,
	|	&Организация																	КАК Организация,
	|	НЕОПРЕДЕЛЕНО																	КАК ВидЗапасов,
	|	ВЫБОР
	|		КОГДА &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	|			ТОГДА ВтТовары.АналитикаНоменклатуры
	|		ИНАЧЕ ВтТовары.АналитикаНоменклатурыБезНазначения
	|	КОНЕЦ																			КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО																	КАК Партия,
	|	НЕОПРЕДЕЛЕНО																	КАК АналитикаУчетаПартий,
	|	ВтТовары.ГруппаПродукцииОтправитель												КАК АналитикаФинансовогоУчета,
	|	ВтТовары.ВидДеятельностиНДС														КАК ВидДеятельностиНДС,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)	КАК КорРазделУчета,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА &ОрганизацияПолучатель
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ																			КАК КорОрганизация,
	|	НЕОПРЕДЕЛЕНО																	КАК КорВидЗапасов,
	|	ВЫБОР
	|		КОГДА &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	|			ТОГДА ВтТовары.АналитикаНоменклатурыПоПолучателю
	|		ИНАЧЕ ВтТовары.АналитикаНоменклатурыПоПолучателюБезНазначения
	|	КОНЕЦ																			КАК КорАналитикаУчетаНоменклатуры,
	|	ВтТовары.ВидДеятельностиНДС														КАК КорВидДеятельностиНДС,
	|	НЕОПРЕДЕЛЕНО																	КАК КорПартия,
	|	НЕОПРЕДЕЛЕНО																	КАК КорАналитикаУчетаПартий,
	|	ВтТовары.ГруппаПродукции														КАК КорАналитикаФинансовогоУчета,
	|	НЕОПРЕДЕЛЕНО																	КАК СтатьяКалькуляции,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА ВтТовары.ПодразделениеПолучатель
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ																			КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО																	КАК СтатьяРасходовСписания,
	|	НЕОПРЕДЕЛЕНО																	КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО																	КАК СтатьяАктивовПассивов,
	|	НЕОПРЕДЕЛЕНО																	КАК АналитикаАктивовПассивов,
	|	НЕОПРЕДЕЛЕНО																	КАК АналитикаУчетаПоПартнерам,
	|	ВтТовары.Количество																КАК Количество,
	|	0																				КАК Стоимость,
	|	0																				КАК СтоимостьБезНДС,
	|	0																				КАК СтоимостьРегл
	|ИЗ
	|	ВтТовары КАК ВтТовары
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	// приход работ на получателя
	|ВЫБРАТЬ
	|	&Дата																			КАК Период,
	|	&Ссылка																			КАК ДокументДвижения,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)											КАК ВидДвижения,
	|	НЕОПРЕДЕЛЕНО																	КАК ИдентификаторСтроки,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.ПеремещениеОбособленно)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.Перемещение)
	|	КОНЕЦ																			КАК ТипЗаписи,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнутреннееПоступлениеРабот)
	|		ИНАЧЕ &ХозяйственнаяОперация
	|	КОНЕЦ																			КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)	КАК РазделУчета,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА &ОрганизацияПолучатель
	|		ИНАЧЕ &Организация
	|	КОНЕЦ																			КАК Организация,
	|	НЕОПРЕДЕЛЕНО																	КАК ВидЗапасов,
	|	ВЫБОР
	|		КОГДА &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	|			ТОГДА ВтТовары.АналитикаНоменклатурыПоПолучателю
	|		ИНАЧЕ ВтТовары.АналитикаНоменклатурыПоПолучателюБезНазначения
	|	КОНЕЦ																			КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО																	КАК Партия,
	|	НЕОПРЕДЕЛЕНО																	КАК АналитикаУчетаПартий,
	|	ВтТовары.ГруппаПродукции														КАК АналитикаФинансовогоУчета,
	|	ВтТовары.ВидДеятельностиНДС														КАК ВидДеятельностиНДС,
	|	НЕОПРЕДЕЛЕНО																	КАК КорРазделУчета,
	|	НЕОПРЕДЕЛЕНО																	КАК КорОрганизация,
	|	НЕОПРЕДЕЛЕНО																	КАК КорВидЗапасов,
	|	НЕОПРЕДЕЛЕНО																	КАК КорАналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО																	КАК КорВидДеятельностиНДС,
	|	НЕОПРЕДЕЛЕНО																	КАК КорПартия,
	|	НЕОПРЕДЕЛЕНО																	КАК КорАналитикаУчетаПартий,
	|	НЕОПРЕДЕЛЕНО																	КАК КорАналитикаФинансовогоУчета,
	|	НЕОПРЕДЕЛЕНО																	КАК СтатьяКалькуляции,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА ВтТовары.ПодразделениеПолучатель
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ																			КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО																	КАК СтатьяРасходовСписания,
	|	НЕОПРЕДЕЛЕНО																	КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО																	КАК СтатьяАктивовПассивов,
	|	НЕОПРЕДЕЛЕНО																	КАК АналитикаАктивовПассивов,
	|	НЕОПРЕДЕЛЕНО																	КАК АналитикаУчетаПоПартнерам,
	|	ВтТовары.Количество																КАК Количество,
	|	0																				КАК Стоимость,
	|	0																				КАК СтоимостьБезНДС,
	|	0																				КАК СтоимостьРегл
	|ИЗ
	|	ВтТовары КАК ВтТовары";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаМатериалыИРаботыВПроизводстве(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "МатериалыИРаботыВПроизводстве";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	// расход работ с отправителя
	"ВЫБРАТЬ
	|	&Дата									КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)	КАК ВидДвижения,
	|	&Организация							КАК Организация,
	|	&Подразделение							КАК Подразделение,
	|	ВтТовары.Номенклатура					КАК Номенклатура,
	|	ВтТовары.Характеристика					КАК Характеристика,
	|	ВтТовары.Назначение						КАК Назначение,
	|	ВтТовары.Количество						КАК Количество
	|ИЗ
	|	ВтТовары КАК ВтТовары
	|
	|ОБЪЕДИНИТЬ ВСЕ
	// приход работ на получателя
	|ВЫБРАТЬ
	|	&Дата									КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)	КАК ВидДвижения,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА &ОрганизацияПолучатель
	|		ИНАЧЕ &Организация
	|	КОНЕЦ									КАК Организация,
	|	ВтТовары.ПодразделениеПолучатель		КАК Подразделение,
	|	ВтТовары.Номенклатура					КАК Номенклатура,
	|	ВтТовары.Характеристика					КАК Характеристика,
	|	ВтТовары.Назначение						КАК Назначение,
	|	ВтТовары.Количество						КАК Количество
	|ИЗ
	|	ВтТовары КАК ВтТовары";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияНоменклатураНоменклатура(Запрос, ТекстыЗапроса, Регистры)

	ИмяРегистра = "ДвиженияНоменклатураНоменклатура";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Дата										КАК Период,
	|	&ХозяйственнаяОперация						КАК ХозяйственнаяОперация,
	|	&Организация								КАК Организация,
	|	ВтТовары.ПодразделениеПолучатель			КАК Подразделение,
	|	ВтТовары.Назначение.НаправлениеДеятельности	КАК НаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	|			ТОГДА ВтТовары.АналитикаНоменклатуры
	|		ИНАЧЕ ВтТовары.АналитикаНоменклатурыБезНазначения
	|	КОНЕЦ										КАК АналитикаУчетаНоменклатуры,
	|	&Подразделение								КАК Склад,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)	КАК ТипЗапасов,
	|	НЕОПРЕДЕЛЕНО								КАК ВидЗапасов,
	|	ВтТовары.Назначение.НаправлениеДеятельности	КАК КорНаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	|			ТОГДА ВтТовары.АналитикаНоменклатурыПоПолучателю
	|		ИНАЧЕ ВтТовары.АналитикаНоменклатурыПоПолучателюБезНазначения
	|	КОНЕЦ										КАК КорАналитикаУчетаНоменклатуры,
	|	ВтТовары.ПодразделениеПолучатель			КАК КорСклад,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)	КАК КорТипЗапасов,
	|	НЕОПРЕДЕЛЕНО								КАК КорВидЗапасов,
	|	ВтТовары.Количество							КАК Количество,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА 0
	|		ИНАЧЕ ВтТовары.Количество
	|	КОНЕЦ										КАК КорКоличество,
	|	0											КАК Стоимость,
	|	0											КАК СтоимостьБезНДС,
	|	0											КАК СтоимостьРегл,
	|	ВЫБОР
	|		КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		ИНАЧЕ ВтТовары.Номенклатура
	|	КОНЕЦ										КАК ИсточникГФУНоменклатуры,
	|	ВЫБОР
	|		КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		ИНАЧЕ ВтТовары.Номенклатура
	|	КОНЕЦ										КАК КорИсточникГФУНоменклатуры,
	|	НЕОПРЕДЕЛЕНО								КАК ДокументДвижения,
	|	ВЫБОР
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)
	|			ТОГДА &ОрганизацияПолучатель
	|		ИНАЧЕ &Организация
	|	КОНЕЦ										КАК КорОрганизация
	|ИЗ
	|	ВтТовары КАК ВтТовары
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Дата										КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнутреннееПоступлениеРабот) КАК ХозяйственнаяОперация,
	|	&ОрганизацияПолучатель						КАК Организация,
	|	ВтТовары.ПодразделениеПолучатель			КАК Подразделение,
	|	ВтТовары.Назначение.НаправлениеДеятельности	КАК НаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	|			ТОГДА ВтТовары.АналитикаНоменклатуры
	|		ИНАЧЕ ВтТовары.АналитикаНоменклатурыБезНазначения
	|	КОНЕЦ										КАК АналитикаУчетаНоменклатуры,
	|	&Подразделение								КАК Склад,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)	КАК ТипЗапасов,
	|	НЕОПРЕДЕЛЕНО								КАК ВидЗапасов,
	|	ВтТовары.Назначение.НаправлениеДеятельности	КАК КорНаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА &УчитыватьСебестоимостьТоваровПоВидамЗапасов
	|			ТОГДА ВтТовары.АналитикаНоменклатурыПоПолучателю
	|		ИНАЧЕ ВтТовары.АналитикаНоменклатурыПоПолучателюБезНазначения
	|	КОНЕЦ										КАК КорАналитикаУчетаНоменклатуры,
	|	ВтТовары.ПодразделениеПолучатель			КАК КорСклад,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)	КАК КорТипЗапасов,
	|	НЕОПРЕДЕЛЕНО								КАК КорВидЗапасов,
	|	0											КАК Количество,
	|	ВтТовары.Количество							КАК КорКоличество,
	|	0											КАК Стоимость,
	|	0											КАК СтоимостьБезНДС,
	|	0											КАК СтоимостьРегл,
	|	ВЫБОР
	|		КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		ИНАЧЕ ВтТовары.Номенклатура
	|	КОНЕЦ										КАК ИсточникГФУНоменклатуры,
	|	ВЫБОР
	|		КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		ИНАЧЕ ВтТовары.Номенклатура
	|	КОНЕЦ										КАК КорИсточникГФУНоменклатуры,
	|	НЕОПРЕДЕЛЕНО								КАК ДокументДвижения,
	|	&Организация								КАК КорОрганизация
	|ИЗ
	|	ВтТовары КАК ВтТовары
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПодразделения", ТекстыЗапроса) Тогда
		ТекстЗапросаВтПодразделения(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Ссылка,
	|	НЕОПРЕДЕЛЕНО КАК РазделительЗаписи,
	|	&Дата КАК ДатаДокументаИБ,
	|	&Номер КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	Подразделения.Организация КАК Организация,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	&Подразделение КАК Подразделение,
	|	&Ответственный КАК Ответственный,
	|	&Комментарий КАК Комментарий,
	|	0 КАК Сумма,
	|	&Проведен КАК Проведен,
	|	&ПометкаУдаления КАК ПометкаУдаления,
	|	Подразделения.ДополнительнаяЗапись КАК ДополнительнаяЗапись,
	|	"""" КАК Дополнительно,
	|	&Дата КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать КАК НомерПервичногоДокумента,
	|	Подразделения.Подразделение КАК МестоХранения,
	|	&Дата КАК ДатаОтраженияВУчете
	|ИЗ
	|	ВтПодразделения КАК Подразделения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВыполненныхВнутреннихРабот КАК ДанныеДокумента
	|		ПО Подразделения.Ссылка = ДанныеДокумента.Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Прочее

// Возвращает описание метаданных документа
//
// Возвращаемое значение:
//  Структура - Описание метаданных документа.
//
Функция ОписаниеФормыДокументаДляЗаполненияРеквизитовСвязанныхСНаправлениемДеятельности() Экспорт
	
	СтруктураОбъекта = НаправленияДеятельностиСервер.СтруктураОбъекта();
	СтруктураОбъекта.ОформляетсяПоЗаказу = Ложь;
	Возврат СтруктураОбъекта;
	
КонецФункции

Функция СписокОпераций() Экспорт

	СписокОпераций = Новый СписокЗначений;
	
	ВыполнениеРабот					= ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуПодразделениями");
	ВыполнениеРаботМеждуФилиалами	= ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемПередачаРаботМеждуФилиалами");
	
	СписокОпераций.Добавить(ВыполнениеРабот,				НСтр("ru = 'Прием-передача между подразделениями';
																|en = 'Acceptance and transfer between departments'"));
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		СписокОпераций.Добавить(ВыполнениеРаботМеждуФилиалами, НСтр("ru = 'Прием-передача между филиалами';
																	|en = 'Acceptance and transfer between branches'"));
	КонецЕсли;
	
	Возврат СписокОпераций;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
