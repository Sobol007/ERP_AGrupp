#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.НастройкаЗаполненияСвободныхСтрокФормСтатистики) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Отбор = Новый Массив;
	Отбор.Добавить("ОбъектНаблюдения");
	Отбор.Добавить("Организация");
	
	Для Каждого ИмяЭлементаОтбора Из Отбор Цикл
		
		ЭлементОтбора = НаборЗаписей.Отбор[ИмяЭлементаОтбора];
		
		ЭлементОтбора.ВидСравнения  = ВидСравнения.Равно;
		ЭлементОтбора.Использование = Истина;
		
		ЗначениеОтбора = ЭлементОтбора.Значение;
		
		Если Не ЗначениеЗаполнено(ЭлементОтбора.Значение) Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ЭтаФорма[ИмяЭлементаОтбора]  = ЭлементОтбора.Значение;
		
	КонецЦикла;
	
	Детализация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектНаблюдения, "Детализация");
	Если Не ЗначениеЗаполнено(Детализация) Тогда
		// Такие объекты выбирать не следует.
		Элементы.ДетализацияОбъектаНаблюдения.Заголовок = НСтр("ru = 'Аналитика';
																|en = 'Dimension'");
		ТипДетализации = Неопределено;
	Иначе
		Элементы.ДетализацияОбъектаНаблюдения.Заголовок = Детализация;
		ТипДетализации = Перечисления.ВидыСвободныхСтрокФормСтатистики.ТипКлассификатора(Детализация);
		
		// Установим параметры выбора Детализации объекта наблюдения.
		ИмяСправочникаДетализации = Перечисления.ВидыСвободныхСтрокФормСтатистики.ИмяСправочника(Детализация);
		
		ПараметрыВыбора	= Новый Массив();
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Назначение", 			ОбъектНаблюдения.Детализация));
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("ДанныеКлассификатора", 	Истина));
		Элементы.ДетализацияОбъектаНаблюдения.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектНаблюдения) Тогда
		Заголовок = РегистрыСведений.НастройкаЗаполненияФормСтатистики.ПредставлениеОбъектаНастройки(
			ОбъектНаблюдения,
			ЗначениеЗаполнено(Детализация),
			Детализация);
			
		АвтоЗаголовок = Ложь;
		Элементы.ОбъектНаблюдения.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") 
		И ВыбранноеЗначение.Свойство("Команда") 
		И ВыбранноеЗначение.Команда = "РедактированиеНастройки" Тогда
		
		ДанныеСтроки = НаборЗаписей.НайтиПоИдентификатору(ВыбранноеЗначение.ИдентификаторСтроки);
		Если ДанныеСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыбранноеЗначение.Данные);
		Модифицированность = Истина;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		
		Для Каждого ЗначениеИзПодбора Из ВыбранноеЗначение Цикл
			
			ДанныеСтроки = НаборЗаписей.Добавить();
			ДанныеСтроки.ДетализацияОбъектаНаблюдения = ЗначениеИзПодбора;
			
		КонецЦикла;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрСообщения = Новый Структура;
	ПараметрСообщения.Вставить("Организация",      Организация);
	ПараметрСообщения.Вставить("ОбъектНаблюдения", ОбъектНаблюдения);
	ПараметрСообщения.Вставить("Детализировать",   Истина);
	ПараметрСообщения.Вставить("Заполнять",        НаборЗаписей.Количество() > 0);
	
	Оповестить("НастройкаЗаполненияФормСтатистики.Изменение", ПараметрСообщения);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		Если ТипДетализации = Неопределено Тогда
		    Элемент.ТекущиеДанные.ДетализацияОбъектаНаблюдения = Неопределено;
		ИначеЕсли ТипЗнч(Элемент.ТекущиеДанные.ДетализацияОбъектаНаблюдения) <> ТипДетализации Тогда
			Элемент.ТекущиеДанные.ДетализацияОбъектаНаблюдения = Новый(ТипДетализации);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ПредставлениеНастройки" Тогда
		СтандартнаяОбработка = Ложь;
		НачатьРедактированиеНастройки(ВыбраннаяСтрока);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеНастройкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НачатьРедактированиеНастройки(Элементы.НаборЗаписей.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПодбор(Команда)
	
	ПараметрыФормы = Новый Структура();
	
	ПараметрыФормы.Вставить("Назначение", 			Детализация); 
	ПараметрыФормы.Вставить("ДанныеКлассификатора", Истина); 
	ПараметрыФормы.Вставить("Подбор",				Истина);
	
	ОткрытьФорму("Справочник." + ИмяСправочникаДетализации + ".ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	
	// ПредставлениеНастройки
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПредставлениеНастройки");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"НаборЗаписей.ПредставлениеНастройки", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<...>';
																	|en = '<...>'"));
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРедактированиеНастройки(ИдентификаторСтроки)
	
	ДанныеСтроки = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;   
	ПараметрыФормы.Вставить("ИдентификаторСтроки",          ИдентификаторСтроки);
	ПараметрыФормы.Вставить("ОбъектНаблюдения",             ОбъектНаблюдения);
	ПараметрыФормы.Вставить("ДетализацияОбъектаНаблюдения", ДанныеСтроки.ДетализацияОбъектаНаблюдения);
	ПараметрыФормы.Вставить("Настройка",                    ДанныеСтроки.Настройка);
	ПараметрыФормы.Вставить("Организация",                  Организация);
	
	Если ТолькоПросмотр Тогда
		ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.НастройкаЗаполненияСвободныхСтрокФормСтатистики.Форма.РедактированиеНастройкиВСтрокеНабораЗаписей",
		ПараметрыФормы,
		ЭтаФорма,
		ИдентификаторСтроки);
	
КонецПроцедуры

#КонецОбласти