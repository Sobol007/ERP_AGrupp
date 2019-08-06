
#Область СлужебныйПрограммныйИнтерфейс

// Проверяет заполнение кодов вычета НДФЛ документа.
// Параметры:
//		ДокументОбъект - объект проверяемого документа.
//		Отказ - устанавливается в Истина при непрохождении проверки.
Процедура ПроверитьЗаполненияКодовВычетаДокумента(ДокументОбъект, Отказ) Экспорт
	
	Если Не ВыполнятьПроверкуЗаполненияКодовВычета(ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗарплатаКадры.СоздатьВТПоТаблицеЗначений(МенеджерВременныхТаблиц, ДокументОбъект.НДФЛ.Выгрузить(), "ВТДокументНДФЛ");
	ЗарплатаКадры.СоздатьВТПоТаблицеЗначений(МенеджерВременныхТаблиц, ДокументОбъект.ПримененныеВычетыНаДетейИИмущественные.Выгрузить(), "ВТДокументПримененныеВычетыНаДетейИИмущественные");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументНДФЛ.ФизическоеЛицо,
		|	ДокументНДФЛ.ИдентификаторСтрокиНДФЛ,
		|	ДокументНДФЛ.НомерСтроки,
		|	""ПредставлениеВычетовНаДетейИИмущественных"" КАК ПолеВычета
		|ИЗ
		|	ВТДокументНДФЛ КАК ДокументНДФЛ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДокументПримененныеВычетыНаДетейИИмущественные КАК ДокументПримененныеВычетыНаДетейИИмущественные
		|		ПО ДокументНДФЛ.ИдентификаторСтрокиНДФЛ = ДокументПримененныеВычетыНаДетейИИмущественные.ИдентификаторСтрокиНДФЛ
		|ГДЕ
		|	ДокументПримененныеВычетыНаДетейИИмущественные.КодВычета = &ПустойКодВычета
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДокументНДФЛ.ФизическоеЛицо,
		|	ДокументНДФЛ.ИдентификаторСтрокиНДФЛ,
		|	ДокументНДФЛ.НомерСтроки,
		|	""ПредставлениеВычетовЛичных""
		|ИЗ
		|	ВТДокументНДФЛ КАК ДокументНДФЛ
		|ГДЕ
		|	(ДокументНДФЛ.ПримененныйВычетЛичный <> 0
		|				И ДокументНДФЛ.ПримененныйВычетЛичныйКодВычета = &ПустойКодВычета
		|			ИЛИ ДокументНДФЛ.ПримененныйВычетЛичныйКЗачетуВозврату <> 0
		|				И ДокументНДФЛ.ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета = &ПустойКодВычета)";
		
	Запрос.УстановитьПараметр("ПустойКодВычета", Справочники.ВидыВычетовНДФЛ.ПустаяСсылка());
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	МаксимальноСообщений = 10;
	ВыводимыхСообщений = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Отказ = Истина;
		Если ВыводимыхСообщений < МаксимальноСообщений Тогда
			
			ТекстСообщения = НСтр("ru = 'В строке %1 сотрудника %2 обнаружены незаполненные коды вычетов НДФЛ';
									|en = 'Unpopulated PIT deduction codes are found in line %1 of the %2 employee'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения,
				Выборка.НомерСтроки,
				Выборка.ФизическоеЛицо);
			
			ПолеСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Объект.НДФЛ[%1].%2", Выборка.НомерСтроки-1, Выборка.ПолеВычета);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , ПолеСообщения, , Отказ);
			ВыводимыхСообщений = ВыводимыхСообщений + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыполнятьПроверкуЗаполненияКодовВычета(ДокументОбъект)
	
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	Если МетаданныеДокумента.ТабличныеЧасти.Найти("НДФЛ") = Неопределено
		Или МетаданныеДокумента.ТабличныеЧасти.Найти("ПримененныеВычетыНаДетейИИмущественные") = Неопределено  Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ДокументОбъект.НДФЛ.Количество() > 0;
	
КонецФункции

#КонецОбласти