////////////////////////////////////////////////////////////////////////////////
// ОтчетностьВБанкиСлужебныйПереопределяемый: переопределяемые механизмы
// формирования и отправки финансовой отчетности в банки.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Находит счет по коду в плане счетов, в котором ведется бухгалтерский учет,
// и помещает ссылку в переданную переменную.
//
// Параметры:
//   КодСчета - Строка - код счета, который нужно найти в плане счетов;
//   СчетУчета - Произвольный - переменная, в которую будет помещен результат поиска.
//
// Пример реализации:
//   СчетУчета = ПланыСчетов.Хозрасчетный.НайтиПоКоду(КодСчета);
//
Процедура УстановитьСчетУчетаПоКоду(КодСчета, СчетУчета) Экспорт
	
	СчетУчета = ПланыСчетов.Хозрасчетный.НайтиПоКоду(КодСчета);
	
КонецПроцедуры

// Добавляет ссылки на счета учета и их названия в переданную таблицу.
//
// Параметры:
//   ИмяФормы - Строка - имя формы отчета БухгалтерскаяОтчетностьВБанк, для которой заполняется список счетов.
//   ВидОтчета - Строка - имя отчета, для которого надо заполнить список счетов.
//   ТаблицаСчетов - ТаблицаЗначений - таблица с колонками, в которую будут помещены счета для отчетов:
//     * Включен - Булево - признак включения счета в отчет;
//     * Счет - ПланСчетовСсылка - ссылка на счет плана счетов, в котором ведется бухгалтерский учет;
//     * Наименование - Строка - наименование счета плана счетов, в котором ведется бухгалтерский учет.
//
// Пример реализации:
//   ЗаполнениеОтчетностиВБанки.ДобавитьСчетаЗаполнения(ИмяФормы, ВидОтчета, ТаблицаСчетов);
//
Процедура ЗаполнитьТаблицуСчетовЗаполнения(ИмяФормы, ВидОтчета, ТаблицаСчетов) Экспорт
	
	ЗаполнениеОтчетностиВБанки.ДобавитьСчетаЗаполнения(ИмяФормы, ВидОтчета, ТаблицаСчетов);
	
КонецПроцедуры

// Добавляет банки и их БИК в переданную таблицу.
// 
// Параметры:
//   Организация - СправочникСсылка.Организация - организация, для которой нужно получить таблицу с банками.
//   ТаблицаБанков - ТаблицаЗначений - таблица с колонками:
//     * БИК  - Строка - БИК банка.
//     * Банк - ОпределяемыйТип.СправочникБанкиБРО - банк.
//
// Пример реализации:
//   Запрос = Новый Запрос;
//   Запрос.УстановитьПараметр("Организация", Организация);
//   Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
//                  |	БанковскиеСчетаОрганизаций.Банк.Код КАК БИК,
//                  |	БанковскиеСчетаОрганизаций.Банк КАК Банк
//                  |ИЗ
//                  |	Справочник.БанковскиеСчета КАК БанковскиеСчетаОрганизаций
//                  |ГДЕ
//                  |	БанковскиеСчетаОрганизаций.Владелец = &Организация
//                  |	И НЕ БанковскиеСчетаОрганизаций.ПометкаУдаления
//                  |
//                  |СГРУППИРОВАТЬ ПО
//                  |	БанковскиеСчетаОрганизаций.Банк,
//                  |	БанковскиеСчетаОрганизаций.Банк.Код";
//   
//   ТаблицаБанков = Запрос.Выполнить().Выгрузить();
//
Процедура ЗаполнитьТаблицуБанковРасчетныхСчетовОрганизации(Организация, ТаблицаБанков) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	ВЫБОР КОГДА БанковскиеСчетаОрганизаций.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчетаОрганизаций.БИКБанка
	|	ИНАЧЕ ЕСТЬNULL(БанковскиеСчетаОрганизаций.Банк.Код,"""") КОНЕЦ КАК БИК,
	|	БанковскиеСчетаОрганизаций.Банк КАК Банк
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	БанковскиеСчетаОрганизаций.Владелец = &Организация
	|	И НЕ БанковскиеСчетаОрганизаций.ПометкаУдаления";
	
	ТаблицаБанков = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры

// Заполняет дерево счетов бухгалтерского учета.
//
// Параметры:
//   ДеревоСчетовБУ - ДеревоЗначений - дерево значений, в которое будут помещены счета.
//
// Пример реализации:
//   Запрос = Новый Запрос;
//   Запрос.Текст =
//       "ВЫБРАТЬ
//       |	Хозрасчетный.Ссылка КАК Ссылка,
//       |	Хозрасчетный.Код КАК Код,
//       |	Хозрасчетный.Наименование КАК Наименование,
//       |	ВЫБОР
//       |		КОГДА Хозрасчетный.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
//       |			ТОГДА ""А""
//       |		ИНАЧЕ ВЫБОР
//       |				КОГДА Хозрасчетный.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
//       |					ТОГДА ""П""
//       |				ИНАЧЕ ""АП""
//       |			КОНЕЦ
//       |	КОНЕЦ КАК Вид
//       |ИЗ
//       |	ПланСчетов.Хозрасчетный КАК Хозрасчетный
//       |ГДЕ
//       |	НЕ Хозрасчетный.Забалансовый
//       |
//       |УПОРЯДОЧИТЬ ПО
//       |	Код
//       |ИТОГИ ПО
//       |	Ссылка ИЕРАРХИЯ";
//   
//   ДеревоСчетовБУ = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
//
Процедура ЗаполнитьДеревоСчетовБУ(ДеревоСчетовБУ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Ссылка,
	|	Хозрасчетный.Код КАК Код,
	|	Хозрасчетный.Наименование КАК Наименование,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|			ТОГДА ""А""
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Хозрасчетный.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|					ТОГДА ""П""
	|				ИНАЧЕ ""АП""
	|			КОНЕЦ
	|	КОНЕЦ КАК Вид
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	НЕ Хозрасчетный.Забалансовый
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код
	|ИТОГИ ПО
	|	Ссылка ИЕРАРХИЯ";
	
	ДеревоСчетовБУ = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
КонецПроцедуры

// Устанавливает банк по умолчанию в переданной переменой.
//
// Параметры:
//   БанкОрганизации - Произвольный - переменная, которой будет присвоена ссылка на банк.
//
// Пример реализации:
//   БанкОрганизации = Справочники.Банки.НайтиПоКоду("044525225");
//
Процедура ЗаполнитьБанкПоУмолчанию(БанкОрганизации) Экспорт
	БанкОрганизации = Справочники.КлассификаторБанков.НайтиПоКоду("044525225")
КонецПроцедуры

// Устанавливает перечень разделов, заполняемых по сведениям ИБ.
//
// Параметры:
//   ИмяФормы - Строка - имя формы отчета БухгалтерскаяОтчетностьВБанк, для которой заполняется перечень разделов.
//   ЗаполняемыеРазделы - Массив - массив, в который будут добавлены идентификаторы заполняемых разделов.
//
// Пример реализации:
//   Если ИмяФормыОтчета = "ФормаОтчета2017Кв3" Тогда
//     ЗаполняемыеРазделы.Добавить("Баланс");
//     ЗаполняемыеРазделы.Добавить("ОФР");
//     ЗаполняемыеРазделы.Добавить("ОИК");
//     ЗаполняемыеРазделы.Добавить("ОДДС");
//     ЗаполняемыеРазделы.Добавить("ДополнительныеПоказатели");
//     ЗаполняемыеРазделы.Добавить("РасшифровкиОбеспеченийПолученные");
//     ЗаполняемыеРазделы.Добавить("РасшифровкиОбеспеченийВыданные");
//     ЗаполняемыеРазделы.Добавить("ЗадолженностьПоКредитамЗаймамКраткосрочная");
//     ЗаполняемыеРазделы.Добавить("ЗадолженностьПоКредитамЗаймамДолгосрочная");
//     ЗаполняемыеРазделы.Добавить("ДенежныеСредства50");
//     ЗаполняемыеРазделы.Добавить("ДенежныеСредства51");
//     ЗаполняемыеРазделы.Добавить("ДенежныеСредства52");
//     ЗаполняемыеРазделы.Добавить("ДенежныеСредства55");
//     ЗаполняемыеРазделы.Добавить("ОСВ");
//     ЗаполняемыеРазделы.Добавить("ОСВПоСчету");
//     ЗаполняемыеРазделы.Добавить("АнализСчета");
//     ЗаполняемыеРазделы.Добавить("Операции51");
//     ЗаполняемыеРазделы.Добавить("Операции52");
//     ЗаполняемыеРазделы.Добавить("Операции55");
//     ЗаполняемыеРазделы.Добавить("Дебиторская");
//     ЗаполняемыеРазделы.Добавить("Кредиторская");
//   КонецЕсли;
//
Процедура ЗаполнитьПереченьЗаполняемыхРазделов(ИмяФормыОтчета, ЗаполняемыеРазделы) Экспорт
	
	Если ИмяФормыОтчета = "ФормаОтчета2017Кв3" Тогда
		ЗаполняемыеРазделы.Добавить("Баланс");
		ЗаполняемыеРазделы.Добавить("ОФР");
		ЗаполняемыеРазделы.Добавить("ОИК");
		ЗаполняемыеРазделы.Добавить("ОДДС");
		ЗаполняемыеРазделы.Добавить("ДополнительныеПоказатели");
		ЗаполняемыеРазделы.Добавить("РасшифровкиОбеспеченийПолученные");
		ЗаполняемыеРазделы.Добавить("РасшифровкиОбеспеченийВыданные");
		ЗаполняемыеРазделы.Добавить("ЗадолженностьПоКредитамЗаймамКраткосрочная");
		ЗаполняемыеРазделы.Добавить("ЗадолженностьПоКредитамЗаймамДолгосрочная");
		ЗаполняемыеРазделы.Добавить("ЛизингОбязательства");
		ЗаполняемыеРазделы.Добавить("ДенежныеСредства50");
		ЗаполняемыеРазделы.Добавить("ДенежныеСредства51");
		ЗаполняемыеРазделы.Добавить("ДенежныеСредства52");
		ЗаполняемыеРазделы.Добавить("ДенежныеСредства55");
		ЗаполняемыеРазделы.Добавить("ОСВ");
		ЗаполняемыеРазделы.Добавить("ОСВПоСчету");
		ЗаполняемыеРазделы.Добавить("АнализСчета");
		ЗаполняемыеРазделы.Добавить("Операции51");
		ЗаполняемыеРазделы.Добавить("Операции52");
		ЗаполняемыеРазделы.Добавить("Операции55");
		ЗаполняемыеРазделы.Добавить("Дебиторская");
		ЗаполняемыеРазделы.Добавить("Кредиторская");
		ЗаполняемыеРазделы.Добавить("ДоходыРасходы");
		ЗаполняемыеРазделы.Добавить("ФинансовыеВложенияКраткосрочные");
		ЗаполняемыеРазделы.Добавить("ФинансовыеВложенияДолгосрочные");
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает описание типов сущности с указанным наименованием.
//
// Параметры:
//   НазваниеСущности - Строка - название сущности, для которой нужно заполнить типы.
//   ОписаниеТиповСущности - ОписаниеТипов - описание типов, в который будут добавлены типы сущности.
//
// Пример реализации:
//   Если НазваниеСущности = "БанковскиеСчета" Тогда
//     ОписаниеТиповСущности = Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета");
//   КонецЕсли;
//
Процедура ЗаполнитьТипыСущности(НазваниеСущности, ОписаниеТиповСущности) Экспорт
	
	Если НазваниеСущности = "БанковскиеСчета" Тогда
		ОписаниеТиповСущности = Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчетаОрганизаций,СправочникСсылка.БанковскиеСчетаКонтрагентов");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
