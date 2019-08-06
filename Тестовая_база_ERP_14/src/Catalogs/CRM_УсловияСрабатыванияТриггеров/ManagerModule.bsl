#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Шаблоны схемы компоновки данных
// 
// Возвращаемое значение:
//  Шаблоны - Массив - Массив шаблонов ключевых показателей.
//
Функция ШаблоныСхемыКомпоновкиДанных() Экспорт
	
	Шаблоны = Новый Массив;
	
	Для каждого Макет из Метаданные.Справочники.CRM_ШаблоныКлючевыхПоказателей.Макеты Цикл
		
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Шаблоны.Добавить(Новый Структура("Имя, Синоним", Макет.Имя, Макет.Синоним));
		
	КонецЦикла;
	
	Возврат Шаблоны;
	
КонецФункции

// Процедура - Создать предопределенные действия
//  Процедура создает предопределенные действия.
//
Процедура СоздатьПредопределенныеДействия(Параметры = Неопределено) Экспорт
	
	ИдентификаторМетаданныхИнтерес = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.CRM_Интерес);
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ПроверкаСвязиСИнтересом.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПроверкаСвязиСИнтересом"));
	ОбработкаТриггера.НазваниеОбработки = "ПроверкаСвязиСИнтересом";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ПриЗаписи;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	ОбработкаТриггера.ОбъектДействия = ИдентификаторМетаданныхИнтерес;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
		НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ПисьмоОтНовогоКлиента.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПисьмоОтНовогоКлиента"));
	ОбработкаТриггера.НазваниеОбработки = "ПисьмоОтНовогоКлиента";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ПриЗаписи;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
		НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ПриВыбореНовогоСостоянияИнтереса.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПриВыбореНовогоСостоянияИнтереса"));
	ОбработкаТриггера.НазваниеОбработки = "ПриВыбореНовогоСостоянияИнтереса";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ПриЗаписи;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	ОбработкаТриггера.ОбъектДействия = ИдентификаторМетаданныхИнтерес;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
		НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("ДокументСсылка.CRM_Интерес"));
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ПриИзмененииТекущегоСостоянияИнтереса.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПриИзмененииТекущегоСостоянияИнтереса"));
	ОбработкаТриггера.НазваниеОбработки = "ПриИзмененииТекущегоСостоянияИнтереса";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ПриЗаписи;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	ОбработкаТриггера.ОбъектДействия = ИдентификаторМетаданныхИнтерес;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
		НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("ДокументСсылка.CRM_Интерес"));
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ВходящееСообщениеЧатаПоИнтересуКлиента.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПроверкаСвязиСИнтересом"));
	ОбработкаТриггера.НазваниеОбработки = "ПроверкаСвязиСИнтересом";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ПриЗаписи;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	ОбработкаТриггера.ОбъектДействия = ИдентификаторМетаданныхИнтерес;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
		НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("ДокументСсылка.CRM_СообщениеМессенджера"));
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ВходящееЭлектронноеПисьмоПоИнтересуКлиента.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПроверкаСвязиСИнтересом"));
	ОбработкаТриггера.НазваниеОбработки = "ПроверкаСвязиСИнтересом";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ПриЗаписи;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	ОбработкаТриггера.ОбъектДействия = ИдентификаторМетаданныхИнтерес;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
		НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ВходящийТелефонныйЗвонокПоИнтересуКлиента.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(Справочники.CRM_УсловияСрабатыванияТриггеров.ПолучитьМакет("ПроверкаСвязиСИнтересом"));
	ОбработкаТриггера.НазваниеОбработки = "ПроверкаСвязиСИнтересом";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ПриЗаписи;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	ОбработкаТриггера.ОбъектДействия = ИдентификаторМетаданныхИнтерес;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
		НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("ДокументСсылка.ТелефонныйЗвонок"));
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ПриОплатеПоИнтересу.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(ПолучитьМакет(?(CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM(),"","CRM_Модуль_")+"ПриОплатеПоИнтересу"));
	ОбработкаТриггера.НазваниеОбработки = "ПриОплатеПоИнтересу";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ОбработкаПроведения;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	ОбработкаТриггера.ОбъектДействия = ИдентификаторМетаданныхИнтерес;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
			НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
			НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.CRM_ДокументРасчетовСКонтрагентом");
			НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
			НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.CRM_СчетНаОплатуПокупателю");
		Иначе
			НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
			НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПоступлениеБезналичныхДенежныхСредств");
			НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
			НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПриходныйКассовыйОрдер");
			НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
			НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ОперацияПоПлатежнойКарте");
		КонецЕсли;
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
	ОбработкаТриггера = Справочники.CRM_УсловияСрабатыванияТриггеров.ПриОтгрузкеПоИнтересу.ПолучитьОбъект();
	ОбработкаТриггера.ОбработкаПроверки = Новый ХранилищеЗначения(ПолучитьМакет(?(CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM(),"","CRM_Модуль_")+"ПриОтгрузкеПоИнтересу"));
	ОбработкаТриггера.НазваниеОбработки = "ПриОтгрузкеПоИнтересу";
	ОбработкаТриггера.ИспользуетсяСтандартнаяОбработка = Истина;
	ОбработкаТриггера.Событие = Перечисления.CRM_СобытияТриггеров.ОбработкаПроведения;
	ОбработкаТриггера.ОткрыватьПоПути = Ложь;
	ОбработкаТриггера.ИспользоватьСКД = Ложь;
	ОбработкаТриггера.РежимОтладки = Ложь;
	ОбработкаТриггера.ОбъектДействия = ИдентификаторМетаданныхИнтерес;
	
	Если ОбработкаТриггера.ОбъектыОбработки.Количество() = 0 Тогда
		Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
			НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
			НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.CRM_СчетНаОплатуПокупателю");
		Иначе
			НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
			НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.РеализацияТоваровУслуг");
			НовыйОбъект = ОбработкаТриггера.ОбъектыОбработки.Добавить();
			НовыйОбъект.ОбъектОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.РасходныйОрдерНаТовары");
		КонецЕсли;
	КонецЕсли;
	
	ОбработкаТриггера.Записать();
	
КонецПроцедуры

// Функция - Массив исключаемых по функциональным опциям предопределенных элементов справочника.
// 
// Возвращаемое значение:
//  МассивИсключаемых - Массив - Массив ссылок.
//
Функция МассивИсключаемыхПоФОПредопределенных() Экспорт
	
	МассивИсключаемых = Новый Массив;
	
	Выборка = Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ОбъектДействия) И НЕ ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(
				ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Выборка.ОбъектДействия)) Тогда
			МассивИсключаемых.Добавить(Выборка.Ссылка);
			Продолжить;
		КонецЕсли;
		Если Выборка.ОбъектыОбработки.Количество() > 0 Тогда
			Исключить = Истина;
			Для каждого ОбъектОбработки из Выборка.ОбъектыОбработки Цикл
				Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(
					ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ОбъектОбработки.ОбъектОбработки)) Тогда
					Исключить = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;	
			Если Исключить Тогда
				МассивИсключаемых.Добавить(Выборка.Ссылка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивИсключаемых;
	
КонецФункции

Процедура ЗаполнитьТЧОбъектыОбработкиПриОбновлении(Параметры = Неопределено) Экспорт
	
	Выборка = Справочники.CRM_УсловияСрабатыванияТриггеров.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ОбъектыОбработки.Количество() = 0 И ЗначениеЗаполнено(Выборка.УдалитьТипОбъекта) И ЗначениеЗаполнено(Выборка.УдалитьОбъектОбработки) Тогда
			ИдентификаторОбъектаОбработки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
												ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
												СтрЗаменить(Выборка.УдалитьТипОбъекта, "-", "")+"."+Выборка.УдалитьОбъектОбработки).ПустаяСсылка()));
			УсловиеОбъект = Выборка.ПолучитьОбъект();
			НовСтр = УсловиеОбъект.ОбъектыОбработки.Добавить();
			НовСтр.ОбъектОбработки = ИдентификаторОбъектаОбработки;
			УсловиеОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("ОбъектДействия") Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	CRM_УсловияСрабатыванияТриггеров.Ссылка КАК Ссылка
		                      |ИЗ
		                      |	Справочник.CRM_УсловияСрабатыванияТриггеров КАК CRM_УсловияСрабатыванияТриггеров
		                      |ГДЕ
		                      |	(CRM_УсловияСрабатыванияТриггеров.ОбъектОбработки = &ОбъектОбработки
		                      |			ИЛИ CRM_УсловияСрабатыванияТриггеров.ОбъектДействия = &ОбъектДействия)
		                      |	И CRM_УсловияСрабатыванияТриггеров.Наименование ПОДОБНО &Наименование
		                      |	И НЕ CRM_УсловияСрабатыванияТриггеров.ПометкаУдаления");
		Запрос.УстановитьПараметр("ОбъектДействия", Параметры.Отбор.ОбъектДействия);
		Запрос.УстановитьПараметр("ОбъектОбработки", Параметры.Отбор.ОбъектДействия.Имя);
		Запрос.УстановитьПараметр("Наименование", "%"+Параметры.СтрокаПоиска+"%");
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли