
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ПериодРегистрации", ПериодРегистрации);
	Параметры.Свойство("Сотрудник", Сотрудник);
	Параметры.Свойство("СуммарнаяДоляСтоПроцентов", СуммарнаяДоляСтоПроцентов);
	Параметры.Свойство("АдресСпискаПодобранныхСотрудников", АдресСпискаПодобранныхСотрудников);
	
	ЗаполнениеРаспределения = Параметры.Свойство("ЗаполнениеРаспределения");
	
	ЕстьПодразделениеУчетаЗатрат = Ложь;
	Если Параметры.Свойство("РаспределениеЗаработка") И Параметры.РаспределениеЗаработка <> Неопределено Тогда
		Для каждого СтрокаРаспределения Из Параметры.РаспределениеЗаработка Цикл
			ЗаполнитьЗначенияСвойств(РаспределениеЗаработка.Добавить(), СтрокаРаспределения);
			ЕстьПодразделениеУчетаЗатрат = ЕстьПодразделениеУчетаЗатрат Или ЗначениеЗаполнено(СтрокаРаспределения.ПодразделениеУчетаЗатрат);
		КонецЦикла;
	КонецЕсли;
	
	ИтогРаспределения = РаспределениеЗаработка.Итог("ДоляРаспределения");

	ИменаКолонок = "ДоляРаспределения,СпособОтраженияЗарплатыВБухучете";
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный") Тогда
		ИменаКолонок = ИменаКолонок + ",СтатьяФинансирования";
	КонецЕсли;
	ИменаПроверяемыхКолонок = Новый ФиксированныйМассив(СтрРазделить(ИменаКолонок,","));
	
	УстановитьВидимостьАналитикиПодробно(Элементы, ЕстьПодразделениеУчетаЗатрат);
	
	ТекстПустогоЗначения = НСтр("ru = '<подбирается автоматически>';
								|en = '<selected automatically>'");
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстПустогоЗначения);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РаспределениеЗаработка.ПодразделениеУчетаЗатрат");
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("РаспределениеЗаработкаПодразделениеУчетаЗатрат");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Сотрудник",
		"Видимость",
		Не ЗаполнениеРаспределения);

КонецПроцедуры

&НаКлиенте
Процедура РаспределениеЗаработкаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ИтогРаспределения = РаспределениеЗаработка.Итог("ДоляРаспределения");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АналитикаПодробно(Команда)
	
	ВидимостьПолейАналитикаПодробно = Не ОбщегоНазначенияКлиентСервер.ЗначениеСвойстваЭлементаФормы(
		Элементы,
		"РаспределениеЗаработкаАналитикаПодробно",
		"Пометка");
		
	УстановитьВидимостьАналитикиПодробно(Элементы, ВидимостьПолейАналитикаПодробно);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ЗавершитьРедактированиеСтрокиДокумента();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьАналитикиПодробно(Элементы, ВидимостьПолейАналитикаПодробно)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РаспределениеЗаработкаАналитикаПодробно",
		"Пометка",
		ВидимостьПолейАналитикаПодробно);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РаспределениеЗаработкаПодразделениеУчетаЗатрат",
		"Видимость",
		ВидимостьПолейАналитикаПодробно);	

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактированиеСтрокиДокумента()
	
	Отказ = Ложь;
	
	Если Модифицированность Тогда
		
		Если Не ПроверитьЗаполнение() Тогда
			Отказ = Истина;
		Иначе
			РезультатРаспределения = РезультатРаспределения();
			Модифицированность = Ложь;
		КонецЕсли;
		
	Иначе
		РезультатРаспределения = Неопределено;
	КонецЕсли;
	
	Если Не Отказ Тогда
		Закрыть(РезультатРаспределения);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция РезультатРаспределения()
	
	ДанныеРаспределения   = РаспределениеЗаработка.Выгрузить();
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный") Тогда
		ОтражениеЗарплатыВБухучетеРасширенный.ДополнитьТаблицуРаспределенияКодомСтатьиФинансирования(ДанныеРаспределения);
	КонецЕсли;
	
	Описание = Новый Структура;
	Описание.Вставить("Сотрудник", Сотрудник);
	Описание.Вставить("РаспределениеЗаработка", ЗарплатаКадрыРасширенный.ТаблицаЗначенийВСтруктуру(ДанныеРаспределения));
	
	Возврат Описание;           

КонецФункции

&НаСервере
Функция ОписанияПроверяемыхКолонок()
	
	ОписаниеКолонок = Новый Соответствие;
	
	РеквизитыТаблицы = ПолучитьРеквизиты("РаспределениеЗаработка");
	Для каждого РеквизитТаблицы Из РеквизитыТаблицы Цикл
		Если ИменаПроверяемыхКолонок.Найти(РеквизитТаблицы.Имя) <> Неопределено Тогда
			ОписаниеКолонок.Вставить(РеквизитТаблицы.Имя, РеквизитТаблицы.Заголовок);
		КонецЕсли; 
	КонецЦикла;
	
	Возврат ОписаниеКолонок;
	
КонецФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗаполнениеРаспределения Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудник");
	КонецЕсли;
	
	ОписаниеКолонок = ОписанияПроверяемыхКолонок();
	
	СуммарнаяДоля = 0;
	НомерСтроки = 0;
	Для каждого СтрокаРаспределения Из РаспределениеЗаработка Цикл
		
		Для каждого ОписаниеКолонки Из ОписаниеКолонок Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаРаспределения[ОписаниеКолонки.Ключ]) Тогда
				
				ЗаголовокКолонки = ОписаниеКолонки.Значение;
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Поле ""%1"" не заполнено';
					|en = 'The ""%1"" field is not filled in'"),
				ЗаголовокКолонки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"РаспределениеЗаработка[" + НомерСтроки + "]." + ОписаниеКолонки.Ключ,
				,
				Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
		СуммарнаяДоля = СуммарнаяДоля + СтрокаРаспределения.ДоляРаспределения;
				
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;  
	
	Если СуммарнаяДоляСтоПроцентов И СуммарнаяДоля <> 100 Тогда
		
		НомерСтроки = НомерСтроки-1;
		
		ТекстСообщения = НСтр("ru = 'Cуммарная доля распределения не равна 100%';
								|en = 'Total allocation share is not equal to 100%'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"РаспределениеЗаработка[" + НомерСтроки + "].ДоляРаспределения",
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


