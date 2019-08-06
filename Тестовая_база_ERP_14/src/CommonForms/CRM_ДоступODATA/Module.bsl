
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Массив = ПолучитьСоставСтандартногоИнтерфейсаOData();
	Если Массив.Количество() = 0 Тогда
		ПоУмолчаниюНаСервере();
	КонецЕсли;
	УстановитьСоставСтандартногоИнтерфейсаOData(Массив);
	
	ЗначениеДерева = РеквизитФормыВЗначение("ДеревоЗначений", Тип("ДеревоЗначений"));
	
	ЗначениеДерева.Строки.Очистить();
	ДобавитьДанныеВДеревоНастроекOData("Константы", 				"Константа", 					ЗначениеДерева, НСтр("ru='Константы';en='Constants'"));
	ДобавитьДанныеВДеревоНастроекOData("Справочники", 				"Справочник",					ЗначениеДерева, НСтр("ru='Справочники';en='Reference manuals'"));
	ДобавитьДанныеВДеревоНастроекOData("Документы", 				"Документ", 					ЗначениеДерева, НСтр("ru='Документы';en='Documents'"));
	ДобавитьДанныеВДеревоНастроекOData("ЖурналыДокументов",			"ЖурналДокументов",				ЗначениеДерева, НСтр("ru='Журналы документов';en='Documents logs'"));
	ДобавитьДанныеВДеревоНастроекOData("Перечисления",				"Перечисление",					ЗначениеДерева, НСтр("ru='Перечисления';en='Transfers'"));
	ДобавитьДанныеВДеревоНастроекOData("ПланыВидовХарактеристик",	"ПланВидовХарактеристик",	 	ЗначениеДерева, НСтр("ru='Планы видов характеристик';en='Plans of types of characteristics'"));
	ДобавитьДанныеВДеревоНастроекOData("РегистрыСведений", 			"РегистрСведений",	 			ЗначениеДерева, НСтр("ru='Регистры сведений';en='Registers of information'"));
	ДобавитьДанныеВДеревоНастроекOData("РегистрыНакопления", 		"РегистрНакопления",	 		ЗначениеДерева, НСтр("ru='Регистры накопления';en='Registers of accumulation'"));
	ДобавитьДанныеВДеревоНастроекOData("БизнесПроцессы", 			"БизнесПроцесс", 				ЗначениеДерева, НСтр("ru='Бизнес-процессы';en='Business processes'"));
	ДобавитьДанныеВДеревоНастроекOData("Задачи", 					"Задача", 						ЗначениеДерева, НСтр("ru='Задачи';en='Tasks'"));
	ДобавитьДанныеВДеревоНастроекOData("ПланыОбмена", 				"ПланОбмена",	 				ЗначениеДерева, НСтр("ru='Планы обмена';en='Plans of an exchange'"));
	
	ЗначениеВРеквизитФормы(ЗначениеДерева, "ДеревоЗначений");	
	
	Для Каждого тРодитель Из ДеревоЗначений.ПолучитьЭлементы() Цикл
		ЕстьДоступРодителя = (ИСТИНА ИЛИ тРодитель.ЕстьДоступ);
		Для Каждого тПодчиненный Из тРодитель.ПолучитьЭлементы() Цикл
			ЕстьДоступРодителя = (ЕстьДоступРодителя И тПодчиненный.ЕстьДоступ);
			Если тПодчиненный.ЕстьДоступ И НЕ тРодитель.ЕстьДоступ Тогда
				тРодитель.ЕстьДоступ = 2;
				Прервать;
			ИначеЕсли НЕ тПодчиненный.ЕстьДоступ И тРодитель.ЕстьДоступ = 1 Тогда
				тРодитель.ЕстьДоступ = 2;
				Прервать;
			ИначеЕсли НЕ тПодчиненный.ЕстьДоступ И тРодитель.ЕстьДоступ = 1 Тогда
				тРодитель.ЕстьДоступ = 2;
				Прервать;
			КонецЕсли;
			тРодитель.ЕстьДоступ = ЕстьДоступРодителя;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоЗначенийЕстьДоступПриИзменении(Элемент)
	тДанные = Элементы.ДеревоЗначений.ТекущиеДанные;
	Если тДанные <> Неопределено Тогда
		Если тДанные.ПолучитьРодителя() = Неопределено Тогда
			Подчиненные = тДанные.ПолучитьЭлементы();
			Если тДанные.ЕстьДоступ <> 1 Тогда
				тДанные.ЕстьДоступ = 0;
			КонецЕсли;
			Для Каждого тЭлемент Из Подчиненные Цикл
				тЭлемент.ЕстьДоступ = тДанные.ЕстьДоступ;
			КонецЦикла;
		Иначе
			Если тДанные.ЕстьДоступ <> 1 Тогда
				тДанные.ЕстьДоступ = 0;
			КонецЕсли;
			тРодитель = тДанные.ПолучитьРодителя();
			ЕстьДоступРодителя = (ИСТИНА ИЛИ тРодитель.ЕстьДоступ);
			Для Каждого тПодчиненный Из тРодитель.ПолучитьЭлементы() Цикл
				ЕстьДоступРодителя = (ЕстьДоступРодителя И тПодчиненный.ЕстьДоступ);
				тРодитель.ЕстьДоступ = ЕстьДоступРодителя;
				Если тПодчиненный.ЕстьДоступ И НЕ тРодитель.ЕстьДоступ Тогда
					тРодитель.ЕстьДоступ = 2;
					Прервать;
				ИначеЕсли НЕ тПодчиненный.ЕстьДоступ И тРодитель.ЕстьДоступ = 1 Тогда
					тРодитель.ЕстьДоступ = 2;
					Прервать;
				ИначеЕсли НЕ тПодчиненный.ЕстьДоступ И тРодитель.ЕстьДоступ = 1 Тогда
					тРодитель.ЕстьДоступ = 2;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтключитьВсе(Команда)
	ОбработатьВсе(Неопределено, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсе(Команда)
	ОбработатьВсе(Неопределено, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПоУмолчанию(Команда)
	ВопросОповещениеЗавершение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ВопросОповещениеЗавершение, НСтр("ru='Установить типовую настройку объектов?';en='Set the default settings for objects?'"), РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВсе(Родитель, Включено)
	Если Родитель = Неопределено Тогда
		тРодитель = ДеревоЗначений.ПолучитьЭлементы();
	Иначе
		тРодитель = Родитель.ПолучитьЭлементы();
	КонецЕсли;
	Для Каждого тСтрока Из тРодитель Цикл
		Если тСтрока.ПолучитьЭлементы().Количество() > 0 Тогда
			ОбработатьВсе(тСтрока, Включено);
		КонецЕсли;
		тСтрока.ЕстьДоступ = Включено;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ЗаписатьНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПоУмолчаниюНаСервере();
		ПриСозданииНаСервере(Ложь, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоУмолчаниюНаСервере()
	
	Массив = Новый Массив;
	Массив.Добавить(Метаданные.Документы.CRM_Интерес);
	Массив.Добавить(Метаданные.Справочники.Партнеры);
	Массив.Добавить(Метаданные.Справочники.CRM_СостоянияИнтересов);
	Массив.Добавить(Метаданные.Справочники.Организации);
	Массив.Добавить(Метаданные.Справочники.Пользователи);
	Массив.Добавить(Метаданные.Справочники.СтруктураПредприятия);
	Массив.Добавить(Метаданные.Справочники.CRM_ПричиныОтказаПоИнтересам);
	Массив.Добавить(Метаданные.Справочники.CRM_ВажностьКлиентов);
	Массив.Добавить(Метаданные.Справочники.БизнесРегионы);
	Массив.Добавить(Метаданные.Справочники.CRM_СегментыРынка);
	
	УстановитьСоставСтандартногоИнтерфейсаOData(Массив);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ЗначениеДерева = РеквизитФормыВЗначение("ДеревоЗначений", Тип("ДеревоЗначений"));
	РезультатыПоиска = ЗначениеДерева.Строки.НайтиСтроки(Новый Структура("ЕстьДоступ", 1), Истина);
	
	Массив = Новый Массив;
	Для каждого ЭлементПоиска Из РезультатыПоиска Цикл
		
		Если ПустаяСтрока(ЭлементПоиска.Метаданные) Тогда
			Продолжить;
		КонецЕсли;
		
		Массив.Добавить(Метаданные.НайтиПоПолномуИмени(ЭлементПоиска.Метаданные));
	
	КонецЦикла; 
		
	УстановитьСоставСтандартногоИнтерфейсаOData(Массив);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьДанныеВДеревоНастроекOData(ИмяОбъекта, ИмяМетаданных, ДеревоЗначений, ИмяРаздела)

	МассивДоступа = ПолучитьСоставСтандартногоИнтерфейсаOData();
	
	СтрокаКорневойУзел = ДеревоЗначений.Строки.Добавить();
	СтрокаКорневойУзел.Данные = ИмяОбъекта;
	СтрокаКорневойУзел.Представление = ИмяРаздела;
	
	КоллекцияОбъектовМетаданных = Метаданные[ИмяОбъекта];
	Для каждого ЭлементКоллекции Из КоллекцияОбъектовМетаданных Цикл
				
		ПодчиненныйУзел = СтрокаКорневойУзел.Строки.Добавить();
		ПодчиненныйУзел.Данные = ЭлементКоллекции.Имя;
		ПодчиненныйУзел.Метаданные = ИмяМетаданных + "." + ЭлементКоллекции.Имя;
		ПодчиненныйУзел.Представление = ЭлементКоллекции.Синоним;
		
		Если МассивДоступа.Найти(ЭлементКоллекции) <> Неопределено Тогда
			ПодчиненныйУзел.ЕстьДоступ = 1;
			СтрокаКорневойУзел.ЕстьДоступ = 2;
		КонецЕсли;
		
	КонецЦикла; 
	
	СтрокаКорневойУзел.Строки.Сортировать("Представление");
	
КонецПроцедуры // ДобавитьДанныеВДеревоНастроекOData()

#КонецОбласти


