#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//++ НЕ УТ
#Область ПрограммныйИнтерфейс
//++ НЕ УТКА

// Определяет источники уточнения счета, доступные в регистре и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиУточненияСчета().
//
// Параметры:
//  СвойстваИсточника - Строка - "ИмяПоля" - имя атрибута регистра накопления, из которого планируется получать источник
//                               уточнения счета.
//
// Возвращаемое значение:
//  Соответствие - Ключ - название источника уточнения счета. 
//                 Значение - структура свойств источника уточнения счета.
//
Функция ИсточникиУточненияСчета(СвойстваИсточника) Экспорт
	
	ИсточникиУточненияСчета = Новый Соответствие;
	
	ИсточникиУточненияСчета.Вставить(Перечисления.ТипыИсточниковУточненияСчета.ГруппаФинансовогоУчетаРасчетов,
		Новый Структура(СвойстваИсточника, "ГФУРасчетов"));
		
	ИсточникиУточненияСчета.Вставить(Перечисления.ТипыИсточниковУточненияСчета.ГруппаФинансовогоУчетаДоходовРасходов,
		Новый Структура(СвойстваИсточника, "ГФУДоходовРасходов"));
		
	Возврат ИсточникиУточненияСчета;
	
КонецФункции

// Определяет источники подразделений регистра и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиПодразделений().
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя источника. 
//                 Значение - структура свойств источника. 
//
Функция ИсточникиПодразделений() Экспорт

	ИсточникиПодразделений = Новый Соответствие;
	
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.ХозяйственнаяОперация, "Подразделение");
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.ОбъектРасчетовСКонтрагентом, "ОбъектРасчетовПодразделение");
	ИсточникиПодразделений.Вставить(Перечисления.ИсточникиПодразделенийАналитическихРегистров.АналитикаУчетаДоходовРасходов, "АналитикаДоходовРасходовПодразделение");
	
    Возврат ИсточникиПодразделений;
	
КонецФункции

// Определяет источники направлений регистра и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиНаправлений().
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя источника. 
//                 Значение - структура свойств источника. 
//
Функция ИсточникиНаправлений() Экспорт

	Результат = Новый Соответствие;
	
	ИсточникиНаправлений = Перечисления.ИсточникиНаправленийДеятельностиАналитическихРегистров;
	Результат.Вставить(ИсточникиНаправлений.НаправлениеДеятельностиКонтрагента, "НаправлениеДеятельностиКонтрагента");
	Результат.Вставить(ИсточникиНаправлений.НаправлениеДеятельностиСтатьи, "НаправлениеДеятельностиСтатьи");

	Возврат Результат;

КонецФункции

// Определяет источники заполнения субконто.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиСубконто().
//
// Возвращаемое значение:
//  Массив - массив атрибутов регистра.
//
Функция ИсточникиСубконто() Экспорт

	МассивСубконто = Новый Массив;
	МассивСубконто.Добавить("Партнер");
	МассивСубконто.Добавить("Контрагент");
	МассивСубконто.Добавить("Договор");
	МассивСубконто.Добавить("СтатьяДоходовРасходов");
	МассивСубконто.Добавить("АналитикаДоходов");
	МассивСубконто.Добавить("АналитикаРасходов");

	Возврат Новый Структура("СубконтоДт, СубконтоКт", МассивСубконто, МассивСубконто);
	
КонецФункции

// Определяет показатели в валюте регистра.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ПоказателиВВалюте().
//
// Параметры:
//  СвойстваПоказателей - Строка - "ИсточникВалюты" - источник валюты для показателя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция ПоказателиВВалюте(СвойстваПоказателей) Экспорт

	ПоказателиВВалюте = Новый Соответствие;
	
	ПоказателиВВалюте.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаВВалюте, Новый Структура(СвойстваПоказателей, "Валюта"));
	ПоказателиВВалюте.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаВВалютеВзаиморасчетов, Новый Структура(СвойстваПоказателей, "ВалютаВзаиморасчетов"));
	
	Возврат ПоказателиВВалюте;

КонецФункции

// Определяет документы отражаемые в международном учете.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ДокументыКОтражениюВМФУ().
//
// Возвращаемое значение:
//  Массив - массив регистраторов регистра отражаемых в международном учете.
//
Функция ДокументыКОтражениюВМеждународномУчете() Экспорт

	ДокументыКОтражению = Новый Массив;
	ДокументыКОтражению.Добавить("ВыбытиеДенежныхДокументов");
	ДокументыКОтражению.Добавить("ВыкупВозвратнойТарыКлиентом");
	ДокументыКОтражению.Добавить("КорректировкаЗадолженностиПоФинансовымИнструментам");
	ДокументыКОтражению.Добавить("КорректировкаПриобретения");
	ДокументыКОтражению.Добавить("КорректировкаРеализации");
	ДокументыКОтражению.Добавить("НачисленияКредитовИДепозитов");
	ДокументыКОтражению.Добавить("НачислениеСписаниеРезервовПоСомнительнымДолгам");
	ДокументыКОтражению.Добавить("ОтчетКомиссионера");
	ДокументыКОтражению.Добавить("ОтчетКомиссионераОСписании");
	ДокументыКОтражению.Добавить("ПередачаТоваровМеждуОрганизациями");
	ДокументыКОтражению.Добавить("ПриобретениеТоваровУслуг");
	ДокументыКОтражению.Добавить("ПриобретениеУслугПрочихАктивов");
	ДокументыКОтражению.Добавить("РасчетКурсовыхРазниц");
	ДокументыКОтражению.Добавить("РеализацияУслугПрочихАктивов");
	ДокументыКОтражению.Добавить("РегистраторРасчетов");
	ДокументыКОтражению.Добавить("СписаниеЗадолженности");
	ДокументыКОтражению.Добавить("СписаниеПринятыхНаХранениеТоваров");
	ДокументыКОтражению.Добавить("ТаможеннаяДекларацияИмпорт");
	
	Возврат ДокументыКОтражению;

КонецФункции
//-- НЕ УТКА

// Определяет показатели регистра.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.Показатели().
//
// Параметры:
//  Свойства - Структура - содержащая ключи СвойстваПоказателей, СвойстваРесурсов.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция Показатели(Свойства) Экспорт

	Показатели = Новый Соответствие;
	
	СвойстваПоказателей = Свойства.СвойстваПоказателей;
	СвойстваРесурсов = Свойства.СвойстваРесурсов;
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Сумма", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДС", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаРеглБезНДС", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДСВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДСВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаБезНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДС", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	Возврат Показатели;
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Подразделение)
	|	И ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли
