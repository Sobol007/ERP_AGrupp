
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ДокументОплаты Из Параметры.ПосредническаяДеятельность Цикл
		ЗаполнитьЗначенияСвойств(ПосредническаяДеятельность.Добавить(), ДокументОплаты.Значение);
	КонецЦикла;
	
	Если ТолькоПросмотр Тогда
		Элементы.ПосредническаяДеятельность.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		Элементы.ФормаКомандаОК.Видимость = Ложь;
	КонецЕсли;
	
	РеквизитыПосредническойДеятельности = Документы.ПоясненияКДекларацииПоНДС.РеквизитыПосредническойДеятельности();
	
	ЗаполнитьКонтрагентов();
	
	УстановитьВозможностьВыбораКонтрагентов();
	
	УстановитьУсловноеОформление();
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда 
		
		Если НЕ ПеренестиВДокумент Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Отменить изменения?';
										|en = 'Отменить изменения?'");
	
			ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
				ЭтотОбъект, 
				Отказ, 
				ЗавершениеРаботы,
				ТекстПредупреждения, 
				"ПеренестиВДокумент");
			
		ИначеЕсли Не Отказ Тогда
				
			Отказ = НЕ ПроверитьЗаполнениеНаКлиенте();
			Если Отказ Тогда
				ПеренестиВДокумент = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ПосредническаяДеятельностьПродавецИННПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.ПосредническаяДеятельность.ТекущиеДанные;
	
	Сведения = СведенияОКонтрагентеПоИНН(ДанныеСтроки.ПродавецИНН);
	
	УстановитьСведенияОКонтрагентеРеквизита(ДанныеСтроки, Сведения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПосредническаяДеятельностьПродавецИНННачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.ПосредническаяДеятельность.ТекущиеДанные;
	
	ВыбратьКонтрагента(ДанныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПосредническаяДеятельностьПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		УстановитьНадписиСтроки(Элементы.ПосредническаяДеятельность.ТекущиеДанные);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ПосредническаяДеятельностьКодВалютыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.ПосредническаяДеятельность.ТекущиеДанные;
	
	ОткрытьФормуВыбораВалюты(ДанныеСтроки, "КодВалюты");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Если ПроверитьЗаполнениеНаКлиенте() Тогда 
		РезультатЗакрытия = СписокПосредническойДеятельности();
		ОповеститьОВыборе(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ПеренестиВДокумент = Ложь;
	Модифицированность = Ложь;
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СписокПосредническойДеятельности()
	
	СписокПосредническойДеятельности = Новый СписокЗначений();
	
	Для Каждого ЭлементПосредническойДеятельности Из ПосредническаяДеятельность Цикл
		ЗначенияРеквизитов = Новый Структура(РеквизитыПосредническойДеятельности);
		ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, ЭлементПосредническойДеятельности);
		СписокПосредническойДеятельности.Добавить(ЗначенияРеквизитов);
	КонецЦикла;
	
	Возврат СписокПосредническойДеятельности;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКонтрагентов()
	
	ТаблицаИНН = ПосредническаяДеятельность.Выгрузить(, "ПродавецИНН");
	ТаблицаИНН.Колонки["ПродавецИНН"].Имя = "ИНН";
	
	ТаблицаКонтрагентов = Документы.ПоясненияКДекларацииПоНДС.КонтрагентыПоСпискуИНН(ТаблицаИНН);
	
	Для Каждого Элемент Из ПосредническаяДеятельность Цикл
		
		Сведения = Документы.ПоясненияКДекларацииПоНДС.СведенияОКонтрагентеПоТаблицеКонтрагентов(Элемент.ПродавецИНН, ТаблицаКонтрагентов);
		УстановитьСведенияОКонтрагентеРеквизита(Элемент, Сведения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКонтрагента(ДанныеСтроки)
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	Если ДанныеСтроки.ПродавецИННКонтрагенты.Количество()>0 Тогда
		ПараметрыФормы.Вставить("ТекущаяСтрока", ДанныеСтроки.ПродавецИННКонтрагенты[0].Значение);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ИдентификаторСтроки", ДанныеСтроки.ПолучитьИдентификатор());
	
	ОповещениеФормы = Новый ОписаниеОповещения("ВыбратьКонтрагентаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , ОповещениеФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКонтрагентаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		
		ДанныеСтроки = ПосредническаяДеятельность.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		Если ДанныеСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Модифицированность = Истина;
		
		Сведения = СведенияОКонтрагентеПоСсылке(РезультатЗакрытия);
		
		УстановитьСведенияОКонтрагентеРеквизита(ДанныеСтроки, Сведения);
		
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОКонтрагентеПоСсылке(Контрагент)
	
	Возврат Документы.ПоясненияКДекларацииПоНДС.СведенияОКонтрагентеПоСсылке(Контрагент);
	
КонецФункции

&НаСервереБезКонтекста
Функция СведенияОКонтрагентеПоИНН(ИНН)
	
	Возврат Документы.ПоясненияКДекларацииПоНДС.СведенияОКонтрагентеПоИНН(ИНН);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСведенияОКонтрагентеРеквизита(ДанныеСтроки, Сведения)
	
	ДанныеСтроки.ПродавецИНН            = Сведения.ИНН;
	ДанныеСтроки.ПредставлениеПродавца  = Сведения.Представление;
	ДанныеСтроки.ПродавецИННКонтрагенты = Сведения.Контрагенты;
	ДанныеСтроки.КоличествоПродавцов    = Сведения.Контрагенты.Количество();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПосредническаяДеятельностьПродавецИНН");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ПосредническаяДеятельность.КоличествоПродавцов", ВидСравненияКомпоновкиДанных.Больше, 0);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ПосредническаяДеятельность.ПредставлениеПродавца"));
	
КонецПроцедуры

&НаСервере
Функция ДобавитьОформляемоеПоле(КоллекцияОформляемыхПолей, ИмяПоля) Экспорт
	
	ПолеЭлемента 		= КоллекцияОформляемыхПолей.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных(ИмяПоля);
	
	Возврат ПолеЭлемента;
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	Отказ = Ложь;
	
	Для Каждого Элемент Из ПосредническаяДеятельность Цикл
		Если ЗначениеЗаполнено(Элемент.ПродавецИНН) 
			И НЕ (СтрДлина(Элемент.ПродавецИНН) = 10 ИЛИ СтрДлина(Элемент.ПродавецИНН) = 12) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность", НСтр("ru = 'ИНН продавца';
																											|en = 'ИНН продавца'"), , , НСтр("ru = 'Длина ИНН должна быть 10 или 12 символов';
																																				|en = 'Длина ИНН должна быть 10 или 12 символов'"));
			Поле = "ПосредническаяДеятельность["+ Формат(ПосредническаяДеятельность.Индекс(Элемент), "ЧДЦ=; ЧГ=0") +"].ПродавецИНН";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Элемент.НомерСчетаФактуры) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Номер с/ф';
																											|en = 'Номер с/ф'"));
			Поле = "ПосредническаяДеятельность["+ Формат(ПосредническаяДеятельность.Индекс(Элемент), "ЧДЦ=; ЧГ=0") +"].НомерСчетаФактуры";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Элемент.ДатаСчетаФактуры) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата с/ф';
																											|en = 'Дата с/ф'"));
			Поле = "ПосредническаяДеятельность["+ Формат(ПосредническаяДеятельность.Индекс(Элемент), "ЧДЦ=; ЧГ=0") +"].ДатаСчетаФактуры";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	Для Каждого Элемент Из ПосредническаяДеятельность Цикл
		УстановитьНадписиСтроки(Элемент);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНадписиСтроки(Строка)
	Строка.НадписьСумма = НСтр("ru = 'Сумма';
								|en = 'Сумма'");
	Строка.НадписьНДС   = НСтр("ru = 'в т.ч. НДС';
								|en = 'в т.ч. НДС'");	
КонецПроцедуры

&НаСервере
Процедура УстановитьВозможностьВыбораКонтрагентов()
	
	КонтрагентыДоступны = ЭлектронныйДокументооборотСКонтролирующимиОрганами.СправочникКонтрагентовДоступен();
	
	Если НЕ КонтрагентыДоступны Тогда
		Элементы.ПосредническаяДеятельностьПродавецИНН.КнопкаВыбора = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#Область ВыборВалюты

&НаКлиенте
Процедура ОткрытьФормуВыбораВалюты(ДанныеСтроки, ИмяРеквизита)
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", 		Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", 	ПолучитьВалютуПоКоду(ДанныеСтроки[ИмяРеквизита]));
	
	ДополнительныеПараметры = Новый Структура("ИдентификаторСтроки, ИмяРеквизита", 
					ДанныеСтроки.ПолучитьИдентификатор(), ИмяРеквизита);
	
	ОповещениеФормы = Новый ОписаниеОповещения("ОбработчикЗакрытияФормыВыбораВалютыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Справочник.Валюты.ФормаВыбора", ПараметрыФормы, ЭтаФорма, , , , ОповещениеФормы, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикЗакрытияФормыВыбораВалютыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
	
		ДанныеСтроки = ПосредническаяДеятельность.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		Если ДанныеСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Модифицированность = Истина;
		
		ДанныеСтроки[ДополнительныеПараметры.ИмяРеквизита] = КодВалюты(РезультатЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВалютуПоКоду(КодВалюты)
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("КодВалюты", СокрЛП(КодВалюты));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Код = &КодВалюты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.Валюты.ПустаяСсылка();
	
КонецФункции

&НаСервереБезКонтекста
Функция КодВалюты(Валюта)
	
	Если ЗначениеЗаполнено(Валюта) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Валюта, "Код");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#КонецОбласти