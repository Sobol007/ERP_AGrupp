#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает сторнирующие проводки документа(ов).
//
// Параметры:
//  Регистраторы - ДокументСсылка - документы (массив документов) для которых необходимо получить сторнирующие проводки.
//  ПериодРегистратора - Булево - признак заполнения даты проводки датой сторнируемого документа если не указан, то дата
//                                не заполнена.
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица проводок переданных регистраторов с обратным знаком сумм и типом проводки "Реверс".
//
Функция ПроводкиСторно(Регистраторы, ПериодРегистратора = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаПроводокСторно();
	Запрос.УстановитьПараметр("СписокДокументов", Регистраторы);
	Запрос.УстановитьПараметр("Ссылка", Документы.ОперацияМеждународный.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяДата", Дата("00010101"));
	Запрос.УстановитьПараметр("ПериодРегистратора", ПериодРегистратора);
	
	Результа = Запрос.Выполнить().Выгрузить();
	
	Возврат Результа;
	
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

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаПроводокСторно()
	
	Возврат
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА &ПериодРегистратора
	|			ТОГДА Проводки.Период
	|		ИНАЧЕ &ПустаяДата
	|	КОНЕЦ КАК Период,
	|	ВЫБОР
	|		КОГДА &Ссылка = НЕОПРЕДЕЛЕНО
	|			ТОГДА Проводки.Регистратор
	|		ИНАЧЕ &Ссылка
	|	КОНЕЦ КАК Регистратор,
	|	Проводки.Организация,
	|	Проводки.СчетДт,
	|	Проводки.ПодразделениеДт,
	|	Проводки.НаправлениеДеятельностиДт,
	|	Проводки.ВидСубконтоДт1 КАК ВидСубконтоДт1,
	|	Проводки.СубконтоДт1,
	|	Проводки.ВидСубконтоДт2 КАК ВидСубконтоДт2,
	|	Проводки.СубконтоДт2,
	|	Проводки.ВидСубконтоДт3 КАК ВидСубконтоДт3,
	|	Проводки.СубконтоДт3,
	|	Проводки.СчетКт,
	|	Проводки.ПодразделениеКт,
	|	Проводки.НаправлениеДеятельностиКт,
	|	Проводки.ВидСубконтоКт1 КАК ВидСубконтоКт1,
	|	Проводки.СубконтоКт1,
	|	Проводки.ВидСубконтоКт2 КАК ВидСубконтоКт2,
	|	Проводки.СубконтоКт2,
	|	Проводки.ВидСубконтоКт3 КАК ВидСубконтоКт3,
	|	Проводки.СубконтоКт3,
	|	Проводки.ВалютаДт,
	|	-Проводки.ВалютнаяСуммаДт КАК ВалютнаяСуммаДт,
	|	Проводки.ВалютаКт,
	|	-Проводки.ВалютнаяСуммаКт КАК ВалютнаяСуммаКт,
	|	-Проводки.Сумма КАК Сумма,
	|	-Проводки.СуммаПредставления КАК СуммаПредставления,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыПроводокМеждународныйУчет.Реверс) КАК ТипПроводки,
	|	Проводки.Содержание КАК Содержание
	|ИЗ
	|	РегистрБухгалтерии.Международный.ДвиженияССубконто(, , Регистратор В (&СписокДокументов), , ) КАК Проводки";
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли