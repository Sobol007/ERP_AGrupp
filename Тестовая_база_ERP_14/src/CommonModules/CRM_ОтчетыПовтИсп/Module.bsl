
#Область ПрограммныйИнтерфейс

// Формирует список предопределенных вариантов отчетов конфигурации,
//  недоступных текущему пользователю по функциональным опциям.
//  Данный массив следует использовать во всех запросах к таблице
//  справочника "ВариантыОтчетов" как исключающий отбор по реквизиту "ПредопределенныйВариант".
// 
// Возвращаемое значение:
//  Массив - из СправочникСсылка.ПредопределенныеВариантыОтчетов,
//  СправочникСсылка.ПредопределенныеВариантыОтчетовРасширений -
//  Варианты отчетов, которые отключены по функциональным опциям.
//
Функция ПредопределенныеВариантыНедоступныеПоФО() Экспорт
	
	ТаблицаОпций = ВариантыОтчетовПовтИсп.Параметры().ТаблицаФункциональныхОпций;
	
	ТаблицаВариантов = ТаблицаОпций.СкопироватьКолонки("ПредопределенныйВариант, ИмяФункциональнойОпции");
	ТаблицаВариантов.Колонки.Добавить("ЗначениеОпции", Новый ОписаниеТипов("Число"));
	
	ОтчетыПользователя = ВариантыОтчетовПовтИсп.ДоступныеОтчеты();
	Для Каждого ОтчетСсылка Из ОтчетыПользователя Цикл
		Найденные = ТаблицаОпций.НайтиСтроки(Новый Структура("Отчет", ОтчетСсылка));
		Для Каждого СтрокаТаблицы Из Найденные Цикл
			СтрокаВариант = ТаблицаВариантов.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаВариант, СтрокаТаблицы);
			Значение = ПолучитьФункциональнуюОпцию(СтрокаТаблицы.ИмяФункциональнойОпции);
			Если Значение = Истина Тогда
				СтрокаВариант.ЗначениеОпции = 1;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаВариантов.Свернуть("ПредопределенныйВариант", "ЗначениеОпции");
	ТаблицаОтключенных = ТаблицаВариантов.Скопировать(Новый Структура("ЗначениеОпции", 0));
	ТаблицаОтключенных.Свернуть("ПредопределенныйВариант");
	ОтключенныеВарианты = ТаблицаОтключенных.ВыгрузитьКолонку("ПредопределенныйВариант");
	
	Возврат ОтключенныеВарианты;
	
КонецФункции

// Формирует список вариантов отчетов конфигурации, недоступных текущему пользователю по функциональным опциям.
//  Данный массив следует использовать во всех запросах к таблице
//  справочника "ВариантыОтчетов" как исключающий отбор по реквизиту "Вариант".
// 
// Возвращаемое значение:
//  Массив - из СправочникСсылка.ВариантыОтчетов, СправочникСсылка.ВариантыДополнительныхОтчетов -
//  Варианты отчетов, которые отключены по функциональным опциям.
//
Функция ВариантыНедоступныеПоФО() Экспорт
	
	ОтключенныеВарианты = Новый Массив;
	
	
	Возврат ОтключенныеВарианты;
	
КонецФункции

// Возвращает идентификатор объекта метаданных, содержащего заданную форму
//
// Параметры:
//  ПолноеИмяФормы	 - Строка	 - Полный путь к форме
// 
// Возвращаемое значение:
//  СправочникСсылка.ИдентификаторыОбъектовМетаданных - Идентификатор объект, содержащего форму
//  Неопределено - Если это общая форма или форма не найдена
//
Функция ИдентификаторОбъектаМетаданныхПоИмениФормы(ПолноеИмяФормы) Экспорт
	
	ФормаМетаданные = Метаданные.НайтиПоПолномуИмени(ПолноеИмяФормы);
	Если ФормаМетаданные = Неопределено Тогда
		ПозицияТочки = СтрДлина(ПолноеИмяФормы);
		Пока Сред(ПолноеИмяФормы, ПозицияТочки, 1) <> "." Цикл
			ПозицияТочки = ПозицияТочки - 1;
		КонецЦикла;
		ПолноеИмяМетаданных = Лев(ПолноеИмяФормы, ПозицияТочки - 1);
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	Иначе
		ОбъектМетаданных = ФормаМетаданные.Родитель();
	КонецЕсли;
	
	Если ОбъектМетаданных = Неопределено
		Или ТипЗнч(ОбъектМетаданных) = Тип("ОбъектМетаданныхКонфигурация") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных);
	
КонецФункции

#КонецОбласти
