#Область ОписаниеПеременных

&НаКлиенте
Перем БылаСтруктураНаименования;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		Объект.Валюта = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
		Объект.Наименование = "";
		СсылкаНаОбъект = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка).ПолучитьСсылку();
	КонецЕсли;
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ИспользоватьТиповойОбмен = ОбменСБанкамиПоЗарплатнымПроектам.ИспользоватьТиповойЭОИСБанком(СсылкаНаОбъект);
	Если ИспользоватьТиповойОбмен Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "НомерДоговора", 
			"ОграничениеТипа", Новый ОписаниеТипов("Строка",,,Новый КвалификаторыСтроки(8)));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НомерДоговора", "Подсказка", "");
	КонецЕсли;
	
	УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами();
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Объект.ИспользоватьЭлектронныйДокументооборотСБанком, ВидимостьПрямогоОбмена);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СсылкаНаОбъект = Объект.Ссылка;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	БылаСтруктураНаименования = СтруктураНаименования();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИспользованиеЭлектронногоОбменаСБанкамиПрежнее = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныйОбменСБанкамиПоЗарплатнымПроектам");
	
	// Обработчик подсистемы "Свойства".
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ИспользованиеЭлектронногоОбменаСБанками = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныйОбменСБанкамиПоЗарплатнымПроектам");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененЗарплатныйПроект", Объект.Ссылка);
	
	Если ИспользованиеЭлектронногоОбменаСБанкамиПрежнее <> ИспользованиеЭлектронногоОбменаСБанками Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами();
КонецПроцедуры

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	
	УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами();
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектронныйДокументооборотСБанкомПриИзменении(Элемент)
	
	УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами();
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Объект.ИспользоватьЭлектронныйДокументооборотСБанком, ВидимостьПрямогоОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерДоговораПриИзменении(Элемент)
	
	Объект.НомерДоговора = СокрЛП(Объект.НомерДоговора);
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаДоговораПриИзменении(Элемент)
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЭДОНажатие(Элемент)
	Обработчик = Новый ОписаниеОповещения("ПослеСозданияНастройкиЭДО", ЭтотОбъект);
	ОбменСБанкамиКлиент.ОткрытьСоздатьНастройкуОбмена(Объект.Организация, Объект.Банк, Объект.РасчетныйСчет, Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура ПослеСозданияНастройкиЭДО(НастройкаЭДО, Параметры) Экспорт
	Элементы.НастройкаЭДО.Заголовок = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(Объект.Организация, Объект.Банк);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма, ИспользоватьЭлектронныйДокументооборотСБанком, ВидимостьПрямогоОбмена)
	
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы(
		Форма, "Банк", ИспользоватьЭлектронныйДокументооборотСБанком);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ОтделениеБанка", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ФилиалОтделенияБанка", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "РасчетныйСчет", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "НомерДоговора", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ДатаДоговора", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "Валюта", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ФорматФайла", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
		
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "Кодировка", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы(
		Форма, "Кодировка", ИспользоватьЭлектронныйДокументооборотСБанком);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "СистемыРасчетовПоБанковскимКартам", "Доступность", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьТаблицыФормы(
		Форма, "СистемыРасчетовПоБанковскимКартам", ИспользоватьЭлектронныйДокументооборотСБанком);
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаТаблицыФормы(
		Форма, "СистемыРасчетовПоБанковскимКартамСистемаРасчетовПоБанковскимКартам", ИспользоватьЭлектронныйДокументооборотСБанком);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "НастройкаЭДО", "Видимость", ВидимостьПрямогоОбмена);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПрямогоОбменаЭлектроннымиДокументами()
	
	ВидимостьПрямогоОбмена = ВидимостьПрямогоОбмена();
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкаЭДО", "Видимость", ВидимостьПрямогоОбмена);
	
	ЗаголовокНадписи = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(Объект.Организация, Объект.Банк);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкаЭДО", "Заголовок", ЗаголовокНадписи);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкаЭДО", "Доступность", ЗначениеЗаполнено(ЗаголовокНадписи));
	
КонецПроцедуры

&НаСервере
Функция ВидимостьПрямогоОбмена()
	
	ВидимостьПрямогоОбмена = Объект.ИспользоватьЭлектронныйДокументооборотСБанком;
	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Банк) Тогда
		БИКБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Банк, "Код");
		ВидимостьПрямогоОбмена = ВидимостьПрямогоОбмена И ОбменСБанками.ВозможенПрямойОбменСБанком(БИКБанка, 2);
	КонецЕсли;
	
	Возврат ВидимостьПрямогоОбмена;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеНаименованияЗарплатногоПроекта(СтруктураНаименования)
	
	Представление = "";
	Если ЗначениеЗаполнено(СтруктураНаименования.Банк) И ЗначениеЗаполнено(СтруктураНаименования.НомерДоговора) И ЗначениеЗаполнено(СтруктураНаименования.ДатаДоговора) Тогда
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 №%2 от %3 г.';
																					|en = '%1 No.%2 dated %3 '"), 
				СтруктураНаименования.Банк,
				СтруктураНаименования.НомерДоговора,
				Формат(СтруктураНаименования.ДатаДоговора, "ДЛФ=Д"));
	ИначеЕсли ЗначениеЗаполнено(СтруктураНаименования.Банк) И ЗначениеЗаполнено(СтруктураНаименования.НомерДоговора) Тогда
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 №%2';
																					|en = '%1 No.%2'"), 
			СтруктураНаименования.Банк,
			СтруктураНаименования.НомерДоговора);
	ИначеЕсли ЗначениеЗаполнено(СтруктураНаименования.Банк) Тогда
		Представление = Строка(СтруктураНаименования.Банк);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

&НаКлиенте
Функция СтруктураНаименования()
	
	Возврат Новый Структура("Банк, НомерДоговора, ДатаДоговора", Объект.Банк, Объект.НомерДоговора, Объект.ДатаДоговора);
	
КонецФункции

&НаКлиенте
Процедура СформироватьАвтоНаименование()
	
	ПрежнееНаименование = ПредставлениеНаименованияЗарплатногоПроекта(БылаСтруктураНаименования);
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) 
		Или ПрежнееНаименование = Объект.Наименование Тогда
		Объект.Наименование = ПредставлениеНаименованияЗарплатногоПроекта(СтруктураНаименования());
	КонецЕсли;
	
	БылаСтруктураНаименования = СтруктураНаименования();
	
КонецПроцедуры

#Область ПроцедурыПодсистемыСвойств

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
