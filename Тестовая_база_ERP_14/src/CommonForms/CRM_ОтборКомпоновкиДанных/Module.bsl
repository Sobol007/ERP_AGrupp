
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Параметры.Свойство("ТекстЗапроса") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОтборКомпоновкиДанных = Неопределено;
	Параметры.Свойство("ОтборКомпоновкиДанных", ОтборКомпоновкиДанных);
	
	Если Параметры.Свойство("Заголовок") И ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ИнициализацияКомпоновки(Параметры.ТекстЗапроса, ОтборКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	Закрыть(КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Если ЭтоАдресВременногоХранилища(АдресСКДВоВременномХранилище) Тогда
		Попытка УдалитьИзВременногоХранилища(АдресСКДВоВременномХранилище);
		Исключение КонецПопытки;
	КонецЕсли;
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализацияКомпоновки(ТекстЗапроса, ОтборКомпоновкиДанных = Неопределено)
	// Создание и настройка схемы компоновки данных.
	СКДДанные = Новый СхемаКомпоновкиДанных();
	
	ИсточникДанных = СКДДанные.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКДДанные.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных";
	НаборДанных.ИсточникДанных = "ИсточникДанных";
	НаборДанных.Запрос = ТекстЗапроса;
	
	Настройки = СКДДанные.НастройкиПоУмолчанию;
	
	ДетальнаяГруппировка = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ДетальнаяГруппировка.Использование = Истина;
	
	ВыбранноеАвтоПоле = Настройки.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеАвтоПоле.Использование = Истина;
	
	Если ЭтоАдресВременногоХранилища(АдресСКДВоВременномХранилище) Тогда
		Попытка УдалитьИзВременногоХранилища(АдресСКДВоВременномХранилище);
		Исключение КонецПопытки;
	КонецЕсли;
	
	АдресСКДВоВременномХранилище = ПоместитьВоВременноеХранилище(СКДДанные, УникальныйИдентификатор);
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКДВоВременномХранилище));
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКДДанные));
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	Для Каждого ПолеВыбора Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		// Пропускаем системные поля
		Если Лев(Строка(ПолеВыбора.Поле), 13) = "СистемныеПоля" Или Лев(Строка(ПолеВыбора.Поле), 12) = "SystemFields" Тогда Продолжить; КонецЕсли;
		Если Лев(Строка(ПолеВыбора.Поле), 15) = "ПараметрыДанных" Или Лев(Строка(ПолеВыбора.Поле), 14) = "DataParameters" Тогда Продолжить; КонецЕсли;
		
		ВыбранныеПоляДетальнаяГруппировка = ДетальнаяГруппировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранныеПоляДетальнаяГруппировка.Поле  = Новый ПолеКомпоновкиДанных(ПолеВыбора.Поле);
	КонецЦикла;
	
	Настройки.ПараметрыДанных.Элементы.Очистить();
	
	Если ОтборКомпоновкиДанных <> Неопределено Тогда
		CRM_ОбщегоНазначенияКлиентСервер.СкопироватьОтборКомпоновкиДанных(КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы, ОтборКомпоновкиДанных.Элементы, КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.ДоступныеПоляОтбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
