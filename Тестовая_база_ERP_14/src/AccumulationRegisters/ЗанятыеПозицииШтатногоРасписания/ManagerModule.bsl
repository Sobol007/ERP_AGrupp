#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодчиненностьПодразделенийОрганизаций КАК Т2 
	|	ПО Т2.Подразделение = Т.ПозицияШтатногоРасписания.Подразделение
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т2.ВышестоящееПодразделение)
	|	И ЗначениеРазрешено(Т.ПозицияШтатногоРасписания.Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Сторнирование движений исправленного документа.
//
// Параметры:
//  НаборЗаписей		 - РегистрНакопленияНаборЗаписей - Целевой набор записей в который будут добавлены сторнирующие строки.
//  ИсправленныйДокумент - ДокументСсылка				 - Документ, записи которого необходимо сторнировать.
//  Записывать			 - Булево						 - Если Истина, то набор будет записан сразу, если Ложь, то набору будет установлен признак Записывать = Истина.
//
Процедура СторнироватьДвижения(НаборЗаписей, ИсправленныйДокумент, Записывать = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрНакопления.ЗанятыеПозицииШтатногоРасписания КАК ЗанятыеПозицииШтатногоРасписания
	|ГДЕ
	|	ЗанятыеПозицииШтатногоРасписания.Регистратор = &Регистратор
	|	И ЗанятыеПозицииШтатногоРасписания.Сторно = ЛОЖЬ";
	Запрос.УстановитьПараметр("Регистратор", ИсправленныйДокумент);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.ВидДвижения = ?(Выборка.ВидДвижения = ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход, ВидДвиженияНакопления.Приход);
		НоваяСтрока.Сторно = Истина;
		
	КонецЦикла;
	
	Если Записывать Тогда
		НаборЗаписей.Записать();
		НаборЗаписей.Записывать = Ложь;
	Иначе
		НаборЗаписей.Записывать = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли