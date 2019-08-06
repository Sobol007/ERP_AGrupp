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
	
	Возврат ВнеоборотныеАктивыЛокализация.ИсточникиУточненияСчетаАмортизация(СвойстваИсточника);
	
КонецФункции

// Определяет источники подразделений регистра и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиПодразделений().
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя источника. 
//                 Значение - структура свойств источника. 
//
Функция ИсточникиПодразделений() Экспорт

	Возврат ВнеоборотныеАктивыЛокализация.ИсточникиПодразделенийАмортизация();

КонецФункции

// Определяет источники направлений регистра и их свойства.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиНаправлений().
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя источника. 
//                 Значение - структура свойств источника. 
//
Функция ИсточникиНаправлений() Экспорт

	Возврат ВнеоборотныеАктивыЛокализация.ИсточникиНаправлений();

КонецФункции

// Определяет источники заполнения субконто.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.ИсточникиСубконто().
//
// Возвращаемое значение:
//  Массив - массив атрибутов регистра.
//
Функция ИсточникиСубконто() Экспорт

	МассивСубконто = Новый Массив;
	МассивСубконто.Добавить("НематериальныйАктив");
	МассивСубконто.Добавить("СтатьяРасходов");

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
	ДокументыКОтражению.Добавить("АмортизацияНМА2_4");
	ДокументыКОтражению.Добавить("ВводОстатковВнеоборотныхАктивов2_4");
	ДокументыКОтражению.Добавить("ИзменениеПараметровНМА2_4");
	ДокументыКОтражению.Добавить("ПеремещениеНМА2_4");
	ДокументыКОтражению.Добавить("ПереоценкаНМА2_4");
	ДокументыКОтражению.Добавить("ПодготовкаКПередачеНМА2_4");
	ДокументыКОтражению.Добавить("СписаниеНМА2_4");
	
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
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Амортизация", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "АмортизацияРегл", "ВалютаРегл"));//АмортизацияРегл = АмортизацияРегл + АмортизацияЦФ
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	Возврат Показатели;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

//-- НЕ УТ

#КонецЕсли