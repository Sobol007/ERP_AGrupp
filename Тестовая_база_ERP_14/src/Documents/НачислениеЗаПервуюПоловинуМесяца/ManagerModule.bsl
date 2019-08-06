#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.НачислениеЗаПервуюПоловинуМесяца;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.НачислениеЗаПервуюПоловинуМесяца);
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатЗаполнения = Новый Структура;
	
	// Получение данных для заполнения табличных частей документа.
	ОписаниеДокумента = СтруктураПараметров.ОписаниеДокумента;
	Организация = СтруктураПараметров.Организация;
	МесяцНачисления = СтруктураПараметров.МесяцНачисления;
	
	ДополнительныеПараметры = РасчетЗарплатыРасширенный.ДополнительныеПараметрыЗаполненияТаблицДокумента();
	ДополнительныеПараметры.ДокументСсылка = СтруктураПараметров.ДокументСсылка;
	ДополнительныеПараметры.Подразделение = СтруктураПараметров.Подразделение;
	ДополнительныеПараметры.ОкончаниеПериода = СтруктураПараметров.ОкончаниеПериода;
	ДополнительныеПараметры.РежимНачисления = СтруктураПараметров.РежимНачисления;
	ДополнительныеПараметры.ПорядокВыплаты = СтруктураПараметров.ПорядокВыплаты;
	ДополнительныеПараметры.ОкончательныйРасчетНДФЛ = СтруктураПараметров.ОкончательныйРасчетНДФЛ;
	
	ДанныеЗаполнения = РасчетЗарплатыРасширенный.ДанныеДляЗаполненияТаблицДокумента(ОписаниеДокумента, Организация, МесяцНачисления, ДополнительныеПараметры);
	
	РезультатЗаполнения.Вставить("ДанныеДляЗаполненияТаблицДокумента", ДанныеЗаполнения);
	
	ПоместитьВоВременноеХранилище(РезультатЗаполнения, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли