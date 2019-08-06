
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если Не Параметры.Свойство("КлючНазначенияФормы")
		Или ПустаяСтрока(Параметры.КлючНазначенияФормы) Тогда
		КлючНазначенияИспользования = Обработки.ЖурналДокументовНМАМеждународныйУчет.КлючНазначенияФормыПоУмолчанию();
		КлючНастроек = "";
	Иначе
		
		КлючНазначенияИспользования = Параметры.КлючНазначенияФормы;
		КлючНастроек                = Параметры.КлючНазначенияФормы;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ОтборыФормыСписка") Тогда
		ФормыОткрытаПоГиперссылке = Истина;
		ОтборТипыДокументов = Параметры.ОтборыФормыСписка.ОтборТипыДокументов;
		ОтборХозяйственныеОперации = Параметры.ОтборыФормыСписка.ОтборХозяйственныеОперации;
	ИначеЕсли Параметры.Свойство("НематериальныйАктив") Тогда
		ФормыОткрытаПоГиперссылке = Истина;
		ОтборНематериальныйАктив = Параметры.НематериальныйАктив;
		Элементы.Список.Видимость = Ложь;
		Элементы.ОтборОрганизация.Видимость = Ложь;
		Элементы.ИнформационнаяНадписьОтбор.Видимость = Ложь;
		Элементы.ОтборНематериальныйАктив.Видимость = Ложь;
		Элементы.СписокДетальноНематериальныйАктив.Видимость = Ложь;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		АвтоЗаголовок = Ложь;
		ВидОбъектаУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтборНематериальныйАктив, "ВидОбъектаУчета");
		Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
			Заголовок = СтрШаблон(НСтр("ru = 'Документы по расходам на НИОКР %1';
										|en = '%1 R&D expense documents'"), Строка(ОтборНематериальныйАктив));
		Иначе
			Заголовок = СтрШаблон(НСтр("ru = 'Документы по нематериальному активу %1';
										|en = '%1 intangible asset documents'"), Строка(ОтборНематериальныйАктив));
		КонецЕсли; 
	Иначе
		ВосстановитьНастройки();
	КонецЕсли;
	
	// ПроверкаДокументовВРеглУчете
	ТекстЗапроса = Список.ТекстЗапроса;
	ПроверкаДокументовСервер.ДоработатьЗапросДинамическогоСпискаЖурналаДокументов(ТекстЗапроса, "РеестрДокументов");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СтатусПроверки КАК СтатусПроверки", "НЕОПРЕДЕЛЕНО КАК УдаленСтатусПроверки");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВЫРАЗИТЬ(&ИндикаторПроверки КАК БУЛЕВО) КАК ИндикаторПроверки", "ЛОЖЬ КАК УдаленИндикаторПроверки");
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	// Конец ПроверкаДокументовВРеглУчете
	
	ДополнительныеПараметры = Новый Структура("МестоРазмещенияДанныхПроверкиРегл", Элементы.СписокГруппаРеглПроверка);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);
	
	ЗаполнитьРеквизитыФормыПриСоздании();
	НастроитьЭлементыФормыПриСоздании();
	
	ОбщегоНазначенияУТ.СформироватьНадписьОтбор(
		ИнформационнаяНадписьОтбор, 
		ХозяйственныеОперацииИДокументы, 
		ОтборТипыДокументов, 
		ОтборХозяйственныеОперации);
	
	ИспользуемыеТипыДокументов = Новый Массив;
	Для каждого ОписаниеОперации Из ХозяйственныеОперацииИДокументы Цикл
		ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка." + СтрРазделить(ОписаниеОперации.ПолноеИмяДокумента, ".")[1]));
	КонецЦикла;
	Если ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыСведений.ДокументыПоНМА.ПолноеИмя()) Тогда
		ОбновлениеИнформационнойБазыУТ.СообщитьЧтоРаботаСФормойВременноОграничена();
	Иначе
		ОбновлениеИнформационнойБазыУТ.ПроверитьВозможностьОткрытияЖурналаДокументов(ИспользуемыеТипыДокументов);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокКоманднаяПанель;
	ПараметрыРазмещения.ПрефиксГрупп = "Список";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокДетальноКоманднаяПанель;
	ПараметрыРазмещения.ПрефиксГрупп = "СписокДетально";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ВводОстатковВнеоборотныхАктивов"
		ИЛИ ИмяСобытия = "Запись_ВводОстатковВнеоборотныхАктивов2_4" Тогда
		
		// Документы ввода остатков включаются в журнал другим способом.
		Элементы.Список.Обновить();
		Элементы.СписокДетально.Обновить();
		
	ИначеЕсли СтрНайти(ИмяСобытия, "Запись_") <> 0 Тогда
	
		Для каждого СтрокаДокумент Из ХозяйственныеОперацииИДокументы Цикл
			ИмяСобытияЗаписьДокумента = СтрЗаменить(СтрокаДокумент.ПолноеИмяДокумента, "Документ.", "Запись_");
			Если ИмяСобытияЗаписьДокумента = ИмяСобытия Тогда
				Элементы.Список.Обновить();
				Элементы.СписокДетально.Обновить();
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНематериальныйАктивПриИзменении(Элемент)
	
	ОтборНематериальныйАктивПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяНадписьОтборОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДоступныеХозяйственныеОперацииИДокументы", ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы());
	
	ПараметрыФормы.Вставить("КлючНастроек", КлючНазначенияИспользования);
	ПараметрыФормы.Вставить("КлючФормы", КлючНазначенияФормыПоУмолчанию());
	
	ОткрытьФорму("Справочник.НастройкиХозяйственныхОпераций.Форма.ФормаУстановкиОтбора",
	ПараметрыФормы,,,,,Новый ОписаниеОповещения("УстановитьОтборыПоХозОперациямИДокументам", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Если Элементы.СписокГруппаСоздатьГенерируемая.ПодчиненныеЭлементы.Количество() <> 0 Тогда 
		Если Копирование Тогда
			ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
		ИначеЕсли ОтборТипыДокументов.Количество() = 1 И ОтборХозяйственныеОперации.Количество() = 1 Тогда 
			СтруктураКоманды = Новый Структура("Имя", Элементы.СписокГруппаСоздатьГенерируемая.ПодчиненныеЭлементы[0].Имя);
			Подключаемый_СоздатьДокумент(СтруктураКоманды);
		Иначе
			Подключаемый_СоздатьДокументЧерезФормуВыбора(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДетально

&НаКлиенте
Процедура СписокДетальноПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДетальноВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДетальноПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Если Элементы.СписокДетальноГруппаСоздатьГенерируемая.ПодчиненныеЭлементы.Количество() <> 0 Тогда 
		Если Копирование Тогда
			ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
		ИначеЕсли ОтборТипыДокументов.Количество() = 1 И ОтборХозяйственныеОперации.Количество() = 1 Тогда 
			СтруктураКоманды = Новый Структура("Имя", Элементы.СписокДетальноГруппаСоздатьГенерируемая.ПодчиненныеЭлементы[0].Имя);
			Подключаемый_СоздатьДокумент(СтруктураКоманды);
		Иначе
			Подключаемый_СоздатьДокументЧерезФормуВыбора(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДетальноПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДетальноПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область Список

&НаКлиенте
Процедура СписокУстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(СписокИнтервал,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.Список, Заголовок);
	
КонецПроцедуры

#КонецОбласти

#Область СписокДетально

&НаКлиенте
Процедура СписокДетальноОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокДетально, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДетальноПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокДетально, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДетальноСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.СписокДетально);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДетальноУстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(СписокДетальноИнтервал,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДетальноУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.СписокДетально, Заголовок);
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаДокументыДетально Тогда
		СтруктураОтборы = Новый Структура("Организация,НематериальныйАктив", ОтборОрганизация, ОтборНематериальныйАктив);
	Иначе
		СтруктураОтборы = Новый Структура("Организация", ОтборОрганизация);
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезКоманду(Команда.Имя, СтруктураОтборы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокументЧерезФормуВыбора(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаДокументыДетально Тогда
		СтруктураОтборы = Новый Структура("Организация,НематериальныйАктив", ОтборОрганизация, ОтборНематериальныйАктив);
	Иначе
		СтруктураОтборы = Новый Структура("Организация", ОтборОрганизация);
	КонецЕсли;
	
	КлючФормы = КлючНазначенияФормыПоУмолчанию();
	АдресХозяйственныеОперацииИДокументы = ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы();
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезФормуВыбора(АдресХозяйственныеОперацииИДокументы,
		КлючФормы, КлючНазначенияИспользования, СтруктураОтборы);
		
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийСписок(ЭтаФорма));
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, ТекущийСписок(ЭтаФорма), Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, ТекущийСписок(ЭтаФорма));
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВосстановитьНастройки()
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.ЖурналДокументовНМАМеждународныйУчет.Форма.ДокументыПоНМА", КлючНазначенияИспользования);
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
	
		СписокИнтервал = Настройки.СписокИнтервал;
		СписокДетальноИнтервал = Настройки.СписокДетальноИнтервал;
		ОтборОрганизация = Настройки.ОтборОрганизация;
		ОтборНематериальныйАктив = Настройки.ОтборНематериальныйАктив;
		
		Настройки.Свойство("ОтборХозяйственныеОперации", ОтборХозяйственныеОперации);
		Настройки.Свойство("ОтборТипыДокументов", ОтборТипыДокументов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если ФормыОткрытаПоГиперссылке Тогда
		Возврат;
	КонецЕсли;
	
	ИменаСохраняемыхРеквизитов =
		"СписокИнтервал,СписокДетальноИнтервал,
		|ОтборОрганизация,
		|ОтборНематериальныйАктив,
		|ОтборХозяйственныеОперации,
		|ОтборТипыДокументов";
	
	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.ЖурналДокументовНМАМеждународныйУчет.Форма.ДокументыПоНМА", КлючНазначенияИспользования, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПриСоздании()
	
	ТаблицаЗначенийДоступно = Обработки.ЖурналДокументовНМАМеждународныйУчет.ИнициализироватьХозяйственныеОперацииИДокументы(
		ХозяйственныеОперацииИДокументы.Выгрузить(),
		ОтборХозяйственныеОперации,
		ОтборТипыДокументов,
		КлючНастроек);
	
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаЗначенийДоступно);
	
	УстановитьОтборыДинамическогоСписка();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыПриСоздании()
	
	Если Параметры.Свойство("СтруктураБыстрогоОтбора") Тогда
		Если Параметры.СтруктураБыстрогоОтбора.Свойство("ПолноеИмяДокумента") Тогда
						
			Отбор = Новый Структура();
			Отбор.Вставить("ПолноеИмяДокумента", Параметры.СтруктураБыстрогоОтбора.ПолноеИмяДокумента);
			
			НайденныеСтроки = ХозяйственныеОперацииИДокументы.НайтиСтроки(Отбор);
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НайденнаяСтрока.Отбор = Истина;
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	НастроитьФормуПоНастройкамХозяйственныхОперацийИДокументов();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоНастройкамХозяйственныхОперацийИДокументов()
	
	ДанныеРабочегоМеста = ОбщегоНазначенияУТ.ДанныеРабочегоМеста(
		ХозяйственныеОперацииИДокументы.Выгрузить(), 
		КлючНазначенияФормыПоУмолчанию(), 
		НСтр("ru = 'все';
			|en = 'all'"));
	
	НастроитьКнопкиУправленияДокументами();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыДинамическогоСписка()
	
	#Область Список
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ХозяйственнаяОперация",
		ОтборХозяйственныеОперации,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ТипСсылки",
		ОтборТипыДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОтборОрганизация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ДополнительнаяЗапись",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		НЕ ЗначениеЗаполнено(ОтборОрганизация));
		
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода", СписокИнтервал.ДатаНачала);
	
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		?(ЗначениеЗаполнено(СписокИнтервал.ДатаОкончания),
			КонецДня(СписокИнтервал.ДатаОкончания),
			СписокИнтервал.ДатаОкончания));
			
	Элементы.СписокУстановитьИнтервал.Пометка = 
		ЗначениеЗаполнено(СписокИнтервал.ДатаНачала) ИЛИ ЗначениеЗаполнено(СписокИнтервал.ДатаОкончания);
	#КонецОбласти
	
	#Область СписокДетально
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДетально,
		"ХозяйственнаяОперация",
		ОтборХозяйственныеОперации,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДетально,
		"ТипСсылки",
		ОтборТипыДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДетально,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОтборОрганизация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДетально,
		"ДополнительнаяЗапись",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		НЕ ЗначениеЗаполнено(ОтборОрганизация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДетально,
		"НематериальныйАктив",
		ОтборНематериальныйАктив,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОтборНематериальныйАктив));
		
	СписокДетально.Параметры.УстановитьЗначениеПараметра("НачалоПериода", СписокДетальноИнтервал.ДатаНачала);
	
	СписокДетально.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		?(ЗначениеЗаполнено(СписокДетальноИнтервал.ДатаОкончания),
			КонецДня(СписокДетальноИнтервал.ДатаОкончания),
			СписокДетальноИнтервал.ДатаОкончания));
			
	Элементы.СписокДетальноУстановитьИнтервал.Пометка = 
		ЗначениеЗаполнено(СписокДетальноИнтервал.ДатаНачала) ИЛИ ЗначениеЗаполнено(СписокДетальноИнтервал.ДатаОкончания);
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ОтборНематериальныйАктивПриИзмененииНаСервере()

	ПриИзмененииОтбора();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияФормыПоУмолчанию()
	
	Возврат "ДокументыОС";
	
КонецФункции

&НаСервере
Процедура ПриИзмененииОтбора()
	
	СохранитьНастройки();
	УстановитьОтборыДинамическогоСписка();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма 												= ЭтаФорма;
	СтруктураПараметров.ИмяГруппыСоздать                                    = "СписокГруппаСоздатьГенерируемая";
	СтруктураПараметров.ИмяГруппыСоздатьКонтекст                            = "СписокГруппаСоздатьГенерируемаяКонтекст";
	СтруктураПараметров.ИмяКнопкиСкопировать                                = "СписокСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню                 = "СписокСкопироватьКонтекст";
	СтруктураПараметров.ИмяКнопкиИзменить                                   = "СписокИзменить";
	СтруктураПараметров.ИмяКнопкиИзменитьКонтекстноеМеню                    = "СписокИзменитьКонтекст";
	СтруктураПараметров.ИмяКнопкиПровести                                   = "СписокПровести";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню                    = "СписокПровестиКонтекст";
	СтруктураПараметров.ИмяКнопкиОтменаПроведения                           = "СписокОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню            = "СписокОтменаПроведенияКонтекст";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаления                  = "СписокУстановитьПометкуУдаления";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню   = "СписокУстановитьПометкуУдаленияКонтекст";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);

	//
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма 												= ЭтаФорма;
	СтруктураПараметров.ИмяГруппыСоздать                                    = "СписокДетальноГруппаСоздатьГенерируемая";
	СтруктураПараметров.ИмяГруппыСоздатьКонтекст                            = "СписокДетальноГруппаСоздатьГенерируемаяКонтекст";
	СтруктураПараметров.ИмяКнопкиСкопировать                                = "СписокДетальноСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню                 = "СписокДетальноСкопироватьКонтекст";
	СтруктураПараметров.ИмяКнопкиИзменить                                   = "СписокДетальноИзменить";
	СтруктураПараметров.ИмяКнопкиИзменитьКонтекстноеМеню                    = "СписокДетальноИзменитьКонтекст";
	СтруктураПараметров.ИмяКнопкиПровести                                   = "СписокДетальноПровести";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню                    = "СписокДетальноПровестиКонтекст";
	СтруктураПараметров.ИмяКнопкиОтменаПроведения                           = "СписокДетальноОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню            = "СписокДетальноОтменаПроведенияКонтекст";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаления                  = "СписокДетальноУстановитьПометкуУдаления";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню   = "СписокДетальноУстановитьПометкуУдаленияКонтекст";
	СтруктураПараметров.ПрефиксЭлементов                                    = "СписокДетально";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", "СписокДата");
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокДетально.Дата", "СписокДетальноДата");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборыПоХозОперациямИДокументам(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		СтандартнаяОбработка = Ложь;
		
		АдресДоступныхХозяйственныхОперацийИДокументов = ВыбранноеЗначение;
		
		ОтборОперацияТипОбработкаВыбораСервер(АдресДоступныхХозяйственныхОперацийИДокументов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтборОперацияТипОбработкаВыбораСервер(АдресДоступныхХозяйственныхОперацийИДокументов)
	
	ТаблицаХозяйственныеОперацииИДокументы = ПолучитьИзВременногоХранилища(АдресДоступныхХозяйственныхОперацийИДокументов);
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаХозяйственныеОперацииИДокументы);
	
	ОбщегоНазначенияУТ.ЗаполнитьОтборыПоТаблицеХозОперацийИТиповДокументов(
		ТаблицаХозяйственныеОперацииИДокументы, ОтборХозяйственныеОперации, ОтборТипыДокументов);
	
	НастроитьФормуПоНастройкамХозяйственныхОперацийИДокументов();
	
	ПриИзмененииОтбора();
	
	ОбщегоНазначенияУТ.СформироватьНадписьОтбор(
		ИнформационнаяНадписьОтбор, ХозяйственныеОперацииИДокументы, ОтборТипыДокументов, ОтборХозяйственныеОперации);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы()
	Возврат ПоместитьВоВременноеХранилище(ХозяйственныеОперацииИДокументы.Выгрузить(), УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииОтбора();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекущийСписок(Форма)

	Если Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаДокументыДетально Тогда
		Возврат Форма.Элементы.СписокДетально;
	Иначе
		Возврат Форма.Элементы.Список;
	КонецЕсли; 

КонецФункции

#Область ШтрихкодыИТорговоеОборудование

&НаСервере
Функция ДанныеПоШтрихКодуПечатнойФормы(Штрихкод)
	
	ДанныеПоШтрихКоду = ОбщегоНазначенияУТ.ДанныеПоШтрихКодуПечатнойФормы(Штрихкод, ХозяйственныеОперацииИДокументы.Выгрузить());	
	
	Возврат ДанныеПоШтрихКоду;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	Состояние(НСтр("ru = 'Выполняется поиск документа по штрихкоду...';
					|en = 'Searching for the document by barcode...'"));
	ДанныеПоШтрихКоду = ДанныеПоШтрихКодуПечатнойФормы(Данные.Штрихкод);
	ОбщегоНазначенияУТКлиент.ОбработатьШтрихкоды(Данные.Штрихкод, ДанныеПоШтрихКоду, ЭтаФорма, "Список");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
