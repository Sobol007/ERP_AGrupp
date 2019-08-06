#Область ПрограммныйИнтерфейс

// Проверяет, является ли переданный тип договора договором продажи.
//
// Параметры:
//  ТипДоговора - ПеречислениеСсылка.ТипыДоговоров - тип договора, который необходимо проверить.
//
// Возвращаемое значение:
//  Булево - Истина, если тип договора относится к договорам продажи.
//
Функция ЭтоДоговорПродажи(ТипДоговора) Экспорт
	
	Если ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем
		Или ТипДоговора = Перечисления.ТипыДоговоров.СКомиссионером
		Или ТипДоговора = Перечисления.ТипыДоговоров.СХранителем
		Или ТипДоговора = Перечисления.ТипыДоговоров.СДавальцем Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Проверяет, является ли переданный тип договора договором закупки.
//
// Параметры:
//  ТипДоговора - ПеречислениеСсылка.ТипыДоговоров - тип договора, который необходимо проверить.
//
// Возвращаемое значение:
//  Булево - Истина, если тип договора относится к договорам закупки.
//
Функция ЭтоДоговорЗакупки(ТипДоговора) Экспорт
	
Если ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком Или
	ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком Или
	ТипДоговора = Перечисления.ТипыДоговоров.СПоклажедателем Или
	ТипДоговора = Перечисления.ТипыДоговоров.СКомитентом Или
	ТипДоговора = Перечисления.ТипыДоговоров.ВвозИзЕАЭС Или
	ТипДоговора = Перечисления.ТипыДоговоров.Импорт Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами") Тогда
		
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПокупателем"));
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СКомиссионером"));
		КонецЕсли;
		
		//++ НЕ УТ
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СХранителем"));
		КонецЕсли;
		//-- НЕ УТ
		
	КонецЕсли;
	
	//++ НЕ УТКА
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоИзДавальческогоСырья") Тогда
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СДавальцем"));
	КонецЕсли;
	//-- НЕ УТКА
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками") Тогда
		
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПоставщиком"));
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СКомитентом"));
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупки") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.Импорт"));
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.ВвозИзЕАЭС"));
		КонецЕсли;
		
		//++ НЕ УТ
		Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранениеВПроцессеЗакупки") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПоклажедателем"));
		КонецЕсли;
		//-- НЕ УТ
		
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоНаСтороне") Тогда
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПереработчиком"));
	КонецЕсли;
	//-- НЕ УТ
	
	Если Параметры.Отбор.Свойство("Ссылка") Тогда
		
		СписокДопустимыхЗначений = ДанныеВыбора.Скопировать();
		ДанныеВыбора.Очистить();
		
		ЗначениеОтбораСсылки = Параметры.Отбор.Ссылка;
		Если Не ТипЗнч(ЗначениеОтбораСсылки) = Тип("ФиксированныйМассив") Тогда
			
			МассивЗначенийВОтборе = Новый Массив;
			МассивЗначенийВОтборе.Добавить(ЗначениеОтбораСсылки);
			
		Иначе
			МассивЗначенийВОтборе = ЗначениеОтбораСсылки;
		КонецЕсли;
		
		Для Каждого ТекЗначение Из МассивЗначенийВОтборе Цикл
			
			Если СписокДопустимыхЗначений.НайтиПоЗначению(ТекЗначение) <> Неопределено Тогда
				ДанныеВыбора.Добавить(ТекЗначение);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

