#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ЧтениеНастройкиОбменаЕГАИС = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.НастройкиОбменаЕГАИС);
	
	ИспользоватьРозничныеПродажи           = ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи");
	ИспользоватьНесколькоКассККМ           = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ");
	ИспользоватьНесколькоКасс              = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	ИспользоватьПодключаемоеОборудование   = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование");
	ИспользоватьОплатуПлатежнымиКартами    = ПолучитьФункциональнуюОпцию("ИспользоватьОплатуПлатежнымиКартами");
	ВестиСведенияДляДекларацийАлкоВРознице = ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийАлкоВРознице");
	
	Элементы.ГруппаКассыККМ.Видимость                         = ИспользоватьНесколькоКассККМ И ИспользоватьРозничныеПродажи;
	Элементы.ГруппаОднаКассаККМ.Видимость                     = Не ИспользоватьНесколькоКассККМ И ИспользоватьРозничныеПродажи;
	
	Элементы.ГруппаКассы.Видимость                            = ИспользоватьНесколькоКасс;
	Элементы.ГруппаОднаКасса.Видимость                        = Не ИспользоватьНесколькоКасс;
	
	Элементы.АвтоматическаяИнкассация.Видимость               = Не ИспользоватьНесколькоКассККМ;
	Элементы.ДекорацияПараметрыПодключенияЕГАИС.Видимость     = Не ИспользоватьНесколькоКассККМ И ВестиСведенияДляДекларацийАлкоВРознице;
	Элементы.КассыККМПараметрыПодключенияЕГАИС.Видимость      =    ИспользоватьНесколькоКассККМ И ВестиСведенияДляДекларацийАлкоВРознице;
	Элементы.ИспользоватьБезПодключенияОборудования.Видимость = Не ИспользоватьНесколькоКассККМ И ИспользоватьПодключаемоеОборудование;
	Элементы.ПодключаемоеОборудование.Видимость               = Не ИспользоватьНесколькоКассККМ И ИспользоватьПодключаемоеОборудование;
	Элементы.ПодключаемоеОборудованиеКасса.Видимость          = Не ИспользоватьНесколькоКасс    И ИспользоватьПодключаемоеОборудование;
	Элементы.ГруппаЭквайринговыеТерминалы.Видимость           = ИспользоватьОплатуПлатежнымиКартами;
	
	Элементы.ГруппаАвторизация.Видимость                = ИспользоватьРозничныеПродажи;
	Элементы.ИспользоватьАвторизациюПояснение.Видимость = ИспользоватьРозничныеПродажи;
	Элементы.ГорячиеКлавишиПояснение.Видимость          = ИспользоватьРозничныеПродажи;
	
	Если ИспользоватьРозничныеПродажи
		И Не ЗначениеЗаполнено(Объект.Ссылка)
		И Не ИспользоватьНесколькоКассККМ Тогда
		КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторПоУмолчанию();
		Если Не ЗначениеЗаполнено(КассаККМ) Тогда
			ВызватьИсключение НСтр("ru = 'В информационной базе не создано кассы ККМ с типом: Фискальный регистратор.
			|Для работы с настройкой РМК в системе должен быть зарегистрирован как минимум один фискальный регистратор.';
			|en = 'Cash register with type ""Fiscal register"" is not created in the infobase.
			|At least one fiscal register should be registered in the application to operate with the CWP setting.'");
		КонецЕсли;
		
		ИспользоватьБезПодключенияОборудования = Истина;
		Элементы.ПодключаемоеОборудование.Доступность = НЕ ИспользоватьБезПодключенияОборудования;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		И Не ИспользоватьНесколькоКасс Тогда
		Касса = Справочники.Кассы.ПолучитьКассуПоУмолчанию(Неопределено);
		Если Не ЗначениеЗаполнено(Касса) Тогда
			ВызватьИсключение НСтр("ru = 'В информационной базе не создано ни одной кассы.
			                             |Для работы с настройкой РМК в системе должна быть зарегистрирована как минимум одна касса предприятия.';
			                             |en = 'No cash register is created in the infobase.
			                             |At least one cash register should be registered in the application to operate with the CWP setting.'");
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Объект.РабочееМесто) Тогда
		МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
		Объект.РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИспользоватьРозничныеПродажи
		И ИмяСобытия = "Запись_ПараметрыПодключенияЕГАИС" Тогда
		ОбновитьПараметрыПодключенияЕГАИСПослеЗаписи(
			Параметр.ИдентификаторФСРАР);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если ИспользоватьРозничныеПродажи
		И Не ИспользоватьНесколькоКассККМ Тогда
		
		ТекущийОбъект.КассыККМ.Очистить();
		НоваяСтрока = ТекущийОбъект.КассыККМ.Добавить();
		НоваяСтрока.КассаККМ                               = КассаККМ;
		НоваяСтрока.ИспользоватьБезПодключенияОборудования = ИспользоватьБезПодключенияОборудования;
		НоваяСтрока.АвтоматическаяИнкассация               = АвтоматическаяИнкассация;
		НоваяСтрока.ПодключаемоеОборудование               = ПодключаемоеОборудование;
		ЗаполнитьПараметрыПодключенияЕГАИС();
		
	КонецЕсли;
	
	Если Не ИспользоватьНесколькоКасс Тогда
		
		ТекущийОбъект.Кассы.Очистить();
		НоваяСтрока = ТекущийОбъект.Кассы.Добавить();
		НоваяСтрока.Касса                    = Касса;
		НоваяСтрока.ПодключаемоеОборудование = ПодключаемоеОборудованиеКасса;
		
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ИспользоватьРозничныеПродажи Тогда
		ЗаполнитьПараметрыПодключенияЕГАИС();
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокИдентификационныеДанныеПользователей(Команда)
	
	ОткрытьФорму("РегистрСведений.ИдентификационныеДанныеПользователей.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПараметрыПодключенияЕГАИС(Команда)
	
	ТекущаяСтрока = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущаяСтрока.СтатусПодключенияКЕгаис)
		И ТекущаяСтрока.СтатусПодключенияКЕгаис = "НеУказываются" Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Для данной кассы ККМ параметры подключения к ЕГАИС не указываются.';
									|en = 'USAIS connection parameters are not specified for this cash register.'"));
		
	Иначе
		ОткрытьФормуПараметрыПодключенияЕГАИС(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьАвторизациюПриИзменении(Элемент)
	
	Элементы.ИдентификационныеДанныеПользователей.Доступность = Объект.ИспользоватьАвторизацию;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочееМестоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		СтандартнаяОбработка = Ложь;
		МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
		Объект.РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассирМожетБытьПродавцомПриИзменении(Элемент)
	
	Если Не Объект.МенеджерТорговогоЗалаМожетБытьПродавцом И Не Объект.КассирМожетБытьПродавцом Тогда
		Объект.МенеджерТорговогоЗалаМожетБытьПродавцом = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерТорговогоЗалаМожетБытьПродавцомПриИзменении(Элемент)
	
	Если Не Объект.МенеджерТорговогоЗалаМожетБытьПродавцом И Не Объект.КассирМожетБытьПродавцом Тогда
		Объект.КассирМожетБытьПродавцом = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПараметрыПодключенияЕГАИСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПараметрыПодключенияКЕГАИС"
		И ЧтениеНастройкиОбменаЕГАИС Тогда
		
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(СтатусПодключенияКЕгаис)
			И СтатусПодключенияКЕгаис <> "НеУказываются" Тогда
			
			ПараметрыЗаписи = Новый Структура();
			ПараметрыЗаписи.Вставить("ИдентификаторФСРАР",          ИдентификаторФСРАР);
			ПараметрыЗаписи.Вставить("РабочееМесто",                Объект.РабочееМесто);
			
			Если СтатусПодключенияКЕгаис = "Настроить" Тогда
				
				ОткрытьФорму("РегистрСведений.НастройкиОбменаЕГАИС.ФормаЗаписи", 
					Новый Структура("ЗначенияЗаполнения", ПараметрыЗаписи),
					ЭтотОбъект)
				
			Иначе
				
				ЗначениеКлюча = Новый Массив;
				ЗначениеКлюча.Добавить(ПараметрыЗаписи);
				
				КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.НастройкиОбменаЕГАИС", ЗначениеКлюча);
				
				ОткрытьФорму("РегистрСведений.НастройкиОбменаЕГАИС.ФормаЗаписи",
					Новый Структура("Ключ", КлючЗаписи), 
					ЭтотОбъект);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиКассыККМ

&НаКлиенте
Процедура КассыККМКассаККМПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьПараметрыПодключенияЕГАИСВСтроке(ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура КассыККМВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.КассыККМПараметрыПодключенияЕГАИС
		И ЧтениеНастройкиОбменаЕГАИС Тогда
		
		ОткрытьФормуПараметрыПодключенияЕГАИС(ТекущаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КассыККМПараметрыПодключенияЕГАИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.КассыККМ.Склад");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КассыККМПодключаемоеОборудование.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.КассыККМ.ИспользоватьБезПодключенияОборудования");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Используется без подключения';
																|en = 'Used without connection'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭквайринговыеТерминалыПодключаемоеОборудование.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭквайринговыеТерминалы.ИспользоватьБезПодключенияОборудования");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Используется без подключения';
																|en = 'Used without connection'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБезПодключенияОборудованияПриИзменении(Элемент)
	
	Элементы.ПодключаемоеОборудование.Доступность = НЕ ИспользоватьБезПодключенияОборудования;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользоватьРозничныеПродажи
		И Не ЗначениеЗаполнено(ПодключаемоеОборудование)
		И Не ИспользоватьБезПодключенияОборудования
		И Не ИспользоватьНесколькоКассККМ Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСТр("ru = 'Не заполнено поле ""Подключаемое оборудование""';
				|en = 'Fill in the ""Peripherals"" field'"),,"ПодключаемоеОборудование",,Отказ);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПодключаемоеОборудованиеКасса)
		И Не ИспользоватьНесколькоКасс Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСТр("ru = 'Не заполнено поле ""Подключаемое оборудование""';
				|en = 'Fill in the ""Peripherals"" field'"),,"ПодключаемоеОборудованиеКасса",,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеКассыИКассыККМ()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ")
		И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Объект.КассыККМ.Количество() > 0 Тогда
			
			Если Не ЗначениеЗаполнено(Объект.КассыККМ[0].КассаККМ) Тогда
				Объект.КассыККМ[0].КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторПоУмолчанию();
				Модифицированность = Истина;
			КонецЕсли;
			
			КассаККМ                               = Объект.КассыККМ[0].КассаККМ;
			ПодключаемоеОборудование               = Объект.КассыККМ[0].ПодключаемоеОборудование;
			ИспользоватьБезПодключенияОборудования = Объект.КассыККМ[0].ИспользоватьБезПодключенияОборудования;
			АвтоматическаяИнкассация               = Объект.КассыККМ[0].АвтоматическаяИнкассация;
			ПараметрыПодключенияЕГАИС              = Объект.КассыККМ[0].ПараметрыПодключенияЕГАИС;
			СтатусПодключенияКЕгаис                = Объект.КассыККМ[0].СтатусПодключенияКЕгаис;
			
		Иначе
			
			КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторПоУмолчанию();
			
		КонецЕсли;
		
		Элементы.ПодключаемоеОборудование.Доступность = НЕ ИспользоватьБезПодключенияОборудования;
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс")
		И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Объект.Кассы.Количество() > 0 Тогда
			
			Если Не ЗначениеЗаполнено(Объект.Кассы[0].Касса) Тогда
				Объект.Кассы[0].Касса = Справочники.Кассы.ПолучитьКассуПоУмолчанию(Неопределено);
				Модифицированность = Истина;
			КонецЕсли;
			
			Касса                         = Объект.Кассы[0].Касса;
			ПодключаемоеОборудованиеКасса = Объект.Кассы[0].ПодключаемоеОборудование;
			
		Иначе
			
			Касса = Справочники.Кассы.ПолучитьКассуПоУмолчанию(Неопределено);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьДанныеКассыИКассыККМ();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи") Тогда
		
		Элементы.ИдентификационныеДанныеПользователей.Доступность = Объект.ИспользоватьАвторизацию;
		
		ЗаполнитьПараметрыПодключенияЕГАИС();
		
	КонецЕсли;
	
КонецПроцедуры

#Область ЕГАИС

&НаСервереБезКонтекста
Функция КлючЗаписи(ИдентификаторФСРАР, РабочееМесто)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ИдентификаторФСРАР",          ИдентификаторФСРАР);
	ПараметрыЗаписи.Вставить("РабочееМесто",                РабочееМесто);
	ПараметрыЗаписи.Вставить("УдалитьИзмерениеОрганизация", Неопределено);
	ПараметрыЗаписи.Вставить("УдалитьИзмерениеСклад",       Неопределено);
	
	КлючЗаписи = РегистрыСведений.НастройкиОбменаЕГАИС.СоздатьКлючЗаписи(ПараметрыЗаписи);
	
	Возврат КлючЗаписи;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуПараметрыПодключенияЕГАИС(ТекущаяСтрока)
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.СтатусПодключенияКЕгаис)
		И ТекущаяСтрока.СтатусПодключенияКЕгаис <>"НеУказываются" Тогда
		
		Если ТекущаяСтрока.СтатусПодключенияКЕгаис = "Настроить" Тогда
			
			ЗначенияЗаполнения = Новый Структура;
			ЗначенияЗаполнения.Вставить("ИдентификаторФСРАР", ТекущаяСтрока.ИдентификаторФСРАР);
			ЗначенияЗаполнения.Вставить("РабочееМесто",       Объект.РабочееМесто);
			
			ОткрытьФорму("РегистрСведений.НастройкиОбменаЕГАИС.ФормаЗаписи", 
				Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения),
				ЭтотОбъект)
			
		Иначе
			
			КлючЗаписи = КлючЗаписи(ТекущаяСтрока.ИдентификаторФСРАР, Объект.РабочееМесто);
			
			ОткрытьФорму("РегистрСведений.НастройкиОбменаЕГАИС.ФормаЗаписи",
				Новый Структура("Ключ", КлючЗаписи),
				ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыПодключенияЕГАИС()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ") Тогда
		КассыККМ = Объект.КассыККМ.Выгрузить(,"КассаККМ").ВыгрузитьКолонку("КассаККМ");
	Иначе
		КассыККМ = Новый Массив;
		КассыККМ.Добавить(КассаККМ);
	КонецЕсли;
	
	ТаблицаПараметров = ТаблицаПараметровЕГАИС(КассыККМ);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ") Тогда
		Для Каждого ТекСтрока Из Объект.КассыККМ Цикл
			ЗаполнитьВСтрокеПараметрыПодключенияЕГАИС(ТаблицаПараметров, ТекСтрока);
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ") Тогда
		ЗаполнитьВСтрокеПараметрыПодключенияЕГАИС(ТаблицаПараметров, ЭтаФорма);
		УстановитьЗаголовокПараметрыПодключенияЕГАИС(ПараметрыПодключенияЕГАИС, СтатусПодключенияКЕгаис);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыПодключенияЕГАИСВСтроке(ИдентификаторСтроки)
	
	ТекСтрока = Объект.КассыККМ.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	КассыККМ = ТекСтрока.КассаККМ;
	ТаблицаПараметров = ТаблицаПараметровЕГАИС(КассыККМ);
	
	ЗаполнитьВСтрокеПараметрыПодключенияЕГАИС(ТаблицаПараметров, ТекСтрока);
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ") Тогда
		УстановитьЗаголовокПараметрыПодключенияЕГАИС(ПараметрыПодключенияЕГАИС, СтатусПодключенияКЕгаис);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыПодключенияЕГАИСНаФорме()
	
	КассыККМ = Новый Массив;
	КассыККМ.Добавить(КассаККМ);
	
	ТаблицаПараметров = ТаблицаПараметровЕГАИС(КассыККМ);
	
	ЗаполнитьВСтрокеПараметрыПодключенияЕГАИС(ТаблицаПараметров, ЭтаФорма);
	УстановитьЗаголовокПараметрыПодключенияЕГАИС(ПараметрыПодключенияЕГАИС, СтатусПодключенияКЕгаис);
	
КонецПроцедуры

&НаСервере
Функция ТаблицаПараметровЕГАИС(КассыККМ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КассыККМ.Владелец КАК Организация,
	|	КассыККМ.Склад КАК Склад,
	|	КассыККМ.Ссылка КАК КассаККМ,
	|	ВЫБОР
	|		КОГДА КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор) ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ФискальныйРегистратор
	|ПОМЕСТИТЬ КассыКММ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.Ссылка В(&КассыККМ)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	КассаККМ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КассыКММ.Организация,
	|	КассыКММ.Склад,
	|	КассыКММ.КассаККМ,
	|	КассыКММ.ФискальныйРегистратор,
	|	ПараметрыПодключенияЕГАИС.ИдентификаторФСРАР   КАК ИдентификаторФСРАР,
	|	ПараметрыПодключенияЕГАИС.АдресУТМ             КАК АдресУТМ,
	|	ПараметрыПодключенияЕГАИС.ПортУТМ              КАК ПортУТМ
	|ИЗ
	|	КассыКММ КАК КассыКММ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|		ПО КлассификаторОрганизацийЕГАИС.Контрагент = КассыКММ.Организация
	|		 И КлассификаторОрганизацийЕГАИС.ТорговыйОбъект = КассыКММ.Склад
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаЕГАИС КАК ПараметрыПодключенияЕГАИС
	|		ПО ПараметрыПодключенияЕГАИС.РабочееМесто = &РабочееМесто
	|		 И ПараметрыПодключенияЕГАИС.ИдентификаторФСРАР = КлассификаторОрганизацийЕГАИС.Код
	|ГДЕ
	|	КассыКММ.ФискальныйРегистратор";
	
	Запрос.УстановитьПараметр("КассыККМ", КассыККМ);
	Запрос.УстановитьПараметр("РабочееМесто", Объект.РабочееМесто);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьВСтрокеПараметрыПодключенияЕГАИС(ТаблицаПараметров, ТекСтрока)
	
	СтрокаПараметров = ТаблицаПараметров.Найти(ТекСтрока.КассаККМ, "КассаККМ");
	Если СтрокаПараметров <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(СтрокаПараметров.АдресУТМ) ИЛИ НЕ СтрокаПараметров.ФискальныйРегистратор Тогда
			Если СтрокаПараметров.ФискальныйРегистратор Тогда
				ТекСтрока.ПараметрыПодключенияЕГАИС = "" + СтрокаПараметров.АдресУТМ + ":" + Формат(СтрокаПараметров.ПортУТМ, "ЧГ=0");
				ТекСтрока.СтатусПодключенияКЕгаис = "Указываются";
			Иначе
				ТекСтрока.ПараметрыПодключенияЕГАИС = НСтр("ru = '<не указываются>';
															|en = '<not specified>'");
				ТекСтрока.СтатусПодключенияКЕгаис = "НеУказываются";
			КонецЕсли;
		Иначе
			ТекСтрока.ПараметрыПодключенияЕГАИС = НСтр("ru = '<не настроены>';
														|en = '<not configured>'");
			ТекСтрока.СтатусПодключенияКЕгаис = "Настроить";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТекСтрока, СтрокаПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокПараметрыПодключенияЕГАИС(ПараметрыПодключения, СтатусПодключенияКЕгаис)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ") Тогда
		
		СтрокаЗаголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'Параметры подключения к ЕГАИС';
															|en = 'USAIS connection parameters'"));
		
		Ссылка = "ПараметрыПодключенияКЕГАИС";
		Если СтатусПодключенияКЕгаис = "Настроить" Тогда
			СтрокаСсылка = Новый ФорматированнаяСтрока(НСтр("ru = '<настроить>';
															|en = '<configure>'"),,,,Ссылка);
		ИначеЕсли СтатусПодключенияКЕгаис = "НеУказываются" Тогда
			СтрокаСсылка = Новый ФорматированнаяСтрока(ПараметрыПодключения);
		Иначе
			СтрокаСсылка = Новый ФорматированнаяСтрока(ПараметрыПодключения,,,,Ссылка);
		КонецЕсли;
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(СтрокаЗаголовок);
		МассивСтрок.Добавить(": ");
		МассивСтрок.Добавить(СтрокаСсылка);
		
		Элементы.ДекорацияПараметрыПодключенияЕГАИС.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыПодключенияЕГАИСПослеЗаписи(ИдентификаторФСРАР)
	
	СтруктураПоиска = Новый Структура("ИдентификаторФСРАР", ИдентификаторФСРАР);
	НайденныеСтроки = Объект.КассыККМ.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		ЗаполнитьПараметрыПодключенияЕГАИСВСтроке(НайденныеСтроки[0].ПолучитьИдентификатор());
	КонецЕсли;
	Если Не ИспользоватьНесколькоКассККМ Тогда
		ЗаполнитьПараметрыПодключенияЕГАИСНаФорме();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
