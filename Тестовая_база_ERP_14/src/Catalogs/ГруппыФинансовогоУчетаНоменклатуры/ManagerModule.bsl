#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет группу финансового учета по умолчанию.
// Возвращает группу финансового учета, если найден один элемент справочника.
// Возвращает ПустуюСсылку в противном случае.
//
// Возвращаемое значение:
//	ГруппаФинансовогоУчета - СправочникСсылка.ГруппыФинансовогоУчетаНоменклатуры - Группа фин. учета по умолчанию.
//
Функция ПолучитьГруппуФинансовогоУчетаПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ДанныеСправочника.Ссылка КАК ГруппаФинансовогоУчета
	|ИЗ
	|	Справочник.ГруппыФинансовогоУчетаНоменклатуры КАК ДанныеСправочника
	|ГДЕ
	|	НЕ ДанныеСправочника.ПометкаУдаления
	|	И НЕ ДанныеСправочника.ЭтоГруппа
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 
	   И Выборка.Следующий()
	Тогда
		ГруппаФинансовогоУчета = Выборка.ГруппаФинансовогоУчета;
	Иначе
		ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ГруппаФинансовогоУчета;

КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

//++ НЕ УТ

//-- НЕ УТ

#КонецОбласти

#КонецОбласти

#КонецЕсли

