
#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивПропуститьРеквизиты = Новый Массив();
	//МассивПропуститьРеквизиты.Добавить("Код");
	//МассивПропуститьРеквизиты.Добавить("Предопределенный");
	//МассивПропуститьРеквизиты.Добавить("Ссылка");
	//МассивПропуститьРеквизиты.Добавить("ЭтоГруппа");
	//МассивПропуститьРеквизиты.Добавить("ПометкаУдаления");
	//МассивПропуститьРеквизиты.Добавить("Владелец");
	
	// Реквизиты справочника Партнеры
	Для Каждого Реквизит Из Метаданные.БизнесПроцессы.CRM_БизнесПроцесс.СтандартныеРеквизиты Цикл
		Если МассивПропуститьРеквизиты.Найти(Реквизит.Имя) <> Неопределено Тогда Продолжить; КонецЕсли;
		
		НоваяСтрока = ТаблицаРеквизиты.Добавить();
		НоваяСтрока.Имя = Реквизит.Имя;
		НоваяСтрока.Представление = ?(ЗначениеЗаполнено(Реквизит.Синоним), Реквизит.Синоним, Реквизит.Имя);
	КонецЦикла;
	Для Каждого Реквизит Из Метаданные.БизнесПроцессы.CRM_БизнесПроцесс.Реквизиты Цикл
		Если МассивПропуститьРеквизиты.Найти(Реквизит.Имя) <> Неопределено Тогда Продолжить; КонецЕсли;
		
		НоваяСтрока = ТаблицаРеквизиты.Добавить();
		НоваяСтрока.Имя = Реквизит.Имя;
		НоваяСтрока.Представление = Реквизит.Синоним;
	КонецЦикла;
	
	// Реквизиты справочника КонтактныеЛицаПартнеров
	Для Каждого Реквизит Из Метаданные.Задачи.ЗадачаИсполнителя.СтандартныеРеквизиты Цикл
		Если МассивПропуститьРеквизиты.Найти(Реквизит.Имя) <> Неопределено Тогда Продолжить; КонецЕсли;
		
		НоваяСтрока = ТаблицаРеквизитыЗадача.Добавить();
		НоваяСтрока.Имя = Реквизит.Имя;
		НоваяСтрока.Представление = ?(ЗначениеЗаполнено(Реквизит.Синоним), Реквизит.Синоним, Реквизит.Имя);
	КонецЦикла;
	
	Для Каждого Реквизит Из Метаданные.Задачи.ЗадачаИсполнителя.Реквизиты Цикл
		Если МассивПропуститьРеквизиты.Найти(Реквизит.Имя) <> Неопределено Тогда Продолжить; КонецЕсли;
		
		НоваяСтрока = ТаблицаРеквизитыЗадача.Добавить();
		НоваяСтрока.Имя = Реквизит.Имя;
		НоваяСтрока.Представление = Реквизит.Синоним;
	КонецЦикла;
	
	//Если ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения") Тогда
	//	// Дополнительные реквизиты справочника Партнеры
	//	МассивРеквизитов = Новый Массив();
	//	Для Каждого СтрокаТаблицы Из Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Партнеры_Общие.ДополнительныеРеквизиты Цикл
	//		Если МассивРеквизитов.Найти(СтрокаТаблицы.Свойство) = Неопределено Тогда
	//			МассивРеквизитов.Добавить(СтрокаТаблицы.Свойство);
	//		КонецЕсли;
	//	КонецЦикла;
	//	Для Каждого СтрокаТаблицы Из Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Партнеры_Компании_CRM.ДополнительныеРеквизиты Цикл
	//		Если МассивРеквизитов.Найти(СтрокаТаблицы.Свойство) = Неопределено Тогда
	//			МассивРеквизитов.Добавить(СтрокаТаблицы.Свойство);
	//		КонецЕсли;
	//	КонецЦикла;
	//	Для Каждого СтрокаТаблицы Из Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Партнеры_ЧастныеЛица_CRM.ДополнительныеРеквизиты Цикл
	//		Если МассивРеквизитов.Найти(СтрокаТаблицы.Свойство) = Неопределено Тогда
	//			МассивРеквизитов.Добавить(СтрокаТаблицы.Свойство);
	//		КонецЕсли;
	//	КонецЦикла;
	//	Для Каждого ДопРеквизитСсылка Из МассивРеквизитов Цикл
	//		НоваяСтрока = ТаблицаРеквизиты.Добавить();
	//		НоваяСтрока.Имя = ДопРеквизитСсылка;
	//		НоваяСтрока.Представление = Строка(ДопРеквизитСсылка);
	//	КонецЦикла;
	//	
	//	// Дополнительные реквизиты справочника КонтактныеЛицаПартнеров
	//	МассивРеквизитов = Новый Массив();
	//	Для Каждого СтрокаТаблицы Из Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_КонтактныеЛицаПартнеров.ДополнительныеРеквизиты Цикл
	//		Если МассивРеквизитов.Найти(СтрокаТаблицы.Свойство) = Неопределено Тогда
	//			МассивРеквизитов.Добавить(СтрокаТаблицы.Свойство);
	//		КонецЕсли;
	//	КонецЦикла;
	//	Для Каждого ДопРеквизитСсылка Из МассивРеквизитов Цикл
	//		НоваяСтрока = ТаблицаРеквизитыЗадача.Добавить();
	//		НоваяСтрока.Имя = ДопРеквизитСсылка;
	//		НоваяСтрока.Представление = Строка(ДопРеквизитСсылка);
	//	КонецЦикла;
	//	
	//КонецЕсли;
	
	//// Контактная информация справочника Партнеры
	//МассивРодителей = Новый Массив();
	//МассивРодителей.Добавить(Справочники.ВидыКонтактнойИнформации.СправочникПартнеры);
	//МассивРодителей.Добавить(Справочники.ВидыКонтактнойИнформации.CRM_СправочникПартнерыЧастноеЛицо);
	//МассивРодителей.Добавить(Справочники.ВидыКонтактнойИнформации.CRM_СправочникПартнерыКомпания);
	//Запрос = Новый Запрос("
	//|ВЫБРАТЬ
	//|	Ссылка КАК Ссылка
	//|ИЗ
	//|	Справочник.ВидыКонтактнойИнформации
	//|ГДЕ
	//|	Родитель В (&МассивРодителей)
	//|	И НЕ ПометкаУдаления
	//|	И НЕ ЭтоГруппа
	//|УПОРЯДОЧИТЬ ПО
	//|	Наименование
	//|");
	//Запрос.УстановитьПараметр("МассивРодителей", МассивРодителей);
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	НоваяСтрока = ТаблицаРеквизиты.Добавить();
	//	НоваяСтрока.Имя = Выборка.Ссылка;
	//	НоваяСтрока.Представление = Строка(Выборка.Ссылка);
	//КонецЦикла;
	//
	//// Контактная информация справочника КонтактныеЛицаПартнеров
	//МассивРодителей = Новый Массив();
	//МассивРодителей.Добавить(Справочники.ВидыКонтактнойИнформации.СправочникКонтактныеЛицаПартнеров);
	//Запрос = Новый Запрос("
	//|ВЫБРАТЬ
	//|	Ссылка КАК Ссылка
	//|ИЗ
	//|	Справочник.ВидыКонтактнойИнформации
	//|ГДЕ
	//|	Родитель В (&МассивРодителей)
	//|	И НЕ ПометкаУдаления
	//|	И НЕ ЭтоГруппа
	//|УПОРЯДОЧИТЬ ПО
	//|	Наименование
	//|");
	//Запрос.УстановитьПараметр("МассивРодителей", МассивРодителей);
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	НоваяСтрока = ТаблицаРеквизитыЗадача.Добавить();
	//	НоваяСтрока.Имя = Выборка.Ссылка;
	//	НоваяСтрока.Представление = Строка(Выборка.Ссылка);
	//КонецЦикла;
	//
	//
	//НоваяСтрока = ТаблицаРеквизиты.Добавить();
	//НоваяСтрока.Имя = "Сегмент";
	//НоваяСтрока.Представление = НСтр("ru='Сегмент клиента';en='Segment of customer'");
	//
	//бОтмеченРеквизитСегмент = Ложь;
	//СтруктураНастройки = РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров.ПолучитьНастройку();
	//Если ТипЗнч(СтруктураНастройки) = Тип("Структура") И ТипЗнч(СтруктураНастройки.СтруктураНастройки) = Тип("Структура") Тогда
	//	Если СтруктураНастройки.СтруктураНастройки.Свойство("Реквизиты") И ТипЗнч(СтруктураНастройки.СтруктураНастройки.Реквизиты) = Тип("Массив") Тогда
	//		Для Каждого СтрокаТаблицы Из ТаблицаРеквизиты Цикл
	//			Если СтруктураНастройки.СтруктураНастройки.Реквизиты.Найти(СтрокаТаблицы.Имя) <> Неопределено Тогда
	//				СтрокаТаблицы.Пометка = Истина;
	//				Если СтрокаТаблицы.Имя = "Сегмент" Тогда
	//					бОтмеченРеквизитСегмент = Истина;
	//				КонецЕсли;
	//			КонецЕсли;
	//		КонецЦикла;
	//	КонецЕсли;
	//	Если СтруктураНастройки.СтруктураНастройки.Свойство("РеквизитыЗадачи") И ТипЗнч(СтруктураНастройки.СтруктураНастройки.РеквизитыЗадачи) = Тип("Массив") Тогда
	//		Для Каждого СтрокаТаблицы Из ТаблицаРеквизитыЗадача Цикл
	//			Если СтруктураНастройки.СтруктураНастройки.РеквизитыЗадачи.Найти(СтрокаТаблицы.Имя) <> Неопределено Тогда
	//				СтрокаТаблицы.Пометка = Истина;
	//			КонецЕсли;
	//		КонецЦикла;
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если Модифицированность Тогда
		Ответ = Вопрос(НСтр("ru='Данные были модифицированны. Сохранить данные?';en='Data has been modified. Save data?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			СохранитьНастройку();
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	
	СохранитьНастройку();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРеквизитыПометкаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажкиТаблицаРеквизиты(Команда)
	Для Каждого СтрокаТаблицы Из ТаблицаРеквизиты Цикл
		СтрокаТаблицы.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажкиТаблицаРеквизитыЗадача(Команда)
	Для Каждого СтрокаТаблицы Из ТаблицаРеквизитыЗадача Цикл
		СтрокаТаблицы.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажкиТаблицаРеквизиты(Команда)
	Для Каждого СтрокаТаблицы Из ТаблицаРеквизиты Цикл
		СтрокаТаблицы.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажкиТаблицаРеквизитыЗадача(Команда)
	Для Каждого СтрокаТаблицы Из ТаблицаРеквизитыЗадача Цикл
		СтрокаТаблицы.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

///////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура СохранитьНастройку()
	СтруктураНастройки = Новый Структура("Реквизиты,РеквизитыЗадачи", Новый Массив(), Новый Массив());
	
	Для Каждого СтрокаТаблицы Из ТаблицаРеквизиты Цикл
		Если СтрокаТаблицы.Пометка Тогда
			СтруктураНастройки.Реквизиты.Добавить(СтрокаТаблицы.Имя);
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаТаблицы Из ТаблицаРеквизитыЗадача Цикл
		Если СтрокаТаблицы.Пометка Тогда
			СтруктураНастройки.РеквизитыЗадачи.Добавить(СтрокаТаблицы.Имя);
		КонецЕсли;
	КонецЦикла;
	РегистрыСведений.bpmНастройкаВерсионированияРеквизитовБизнесПроцессов.СохранитьНастройку(СтруктураНастройки);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

#КонецОбласти 



