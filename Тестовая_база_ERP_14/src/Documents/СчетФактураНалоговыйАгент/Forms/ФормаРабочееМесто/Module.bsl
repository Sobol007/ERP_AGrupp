
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьЗначенияПоУмолчанию();
	УстановитьЗначенияПоПараметрамФормы(Параметры);
	ОбновитьДанныеФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовНДС");
	СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, Неопределено);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Настройки["Организация"] = Организация;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СмТакжеВРаботеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ИмяКлючевойОперации = СтрШаблон("Обработка.СчетФактураНалоговыйАгент.Форма.ФормаРабочееМесто.СмТакже.%1",
									НавигационнаяСсылкаФорматированнойСтроки);
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, ИмяКлючевойОперации);
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	СтруктураБыстрогоОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		СтруктураБыстрогоОтбора.Вставить("Организация", Организация);
		ПараметрыФормы.Вставить("Организация", Организация);
	КонецЕсли;
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	Период = Новый СтандартныйПериод;
	Период.ДатаНачала = НачалоПериода;
	Период.ДатаОкончания = КонецПериода;
	СтруктураБыстрогоОтбора.Вставить("Период", Период);
	СтруктураБыстрогоОтбора.Вставить("НачалоПериода", ?(ЗначениеЗаполнено(Период.ДатаНачала), Период.ДатаНачала, НачалоКвартала(ТекущаяДата)));
	ПараметрыФормы.Вставить("НачалоПериода", СтруктураБыстрогоОтбора.НачалоПериода);
	СтруктураБыстрогоОтбора.Вставить("КонецПериода", ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, КонецКвартала(ТекущаяДата)));
	ПараметрыФормы.Вставить("КонецПериода", СтруктураБыстрогоОтбора.КонецПериода);
	
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыФормы,ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицФормы

&НаКлиенте
Процедура ОплатыПоставщикамСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ОплатыПоставщикам.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПоставщикамВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если (Поле = Элементы.ОплатыПоставщикамСчетФактура ИЛИ Поле.Родитель = Элементы.ОплатыПоставщикамГруппаСФ) Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьДокумент(Элемент.ТекущиеДанные.СчетФактура, СтандартнаяОбработка);
	ИначеЕсли Поле <> Элементы.ОплатыПоставщикамВидАгентскогоДоговора 
		И Поле <> Элементы.ОплатыПоставщикамСтавкаНДС Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьДокумент(Элемент.ТекущиеДанные.ДокументОснование, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", 
		ПараметрыВыбора, 
		Элементы.ВыбратьПериод, 
		, 
		, 
		, 
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОплатыПоставщикам(Команда)
	
	ОчиститьСообщения();
	Если ПроверитьЗаполнение() Тогда
		ЗаполнитьОплатыПоставщикамНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСчетаФактуры(Команда)
	
	ОчиститьСообщения();
	СформироватьСчетаФактурыНаСервере();
	ОповеститьОбИзменении(Тип("ДокументСсылка.СчетФактураНалоговыйАгент"));
	Оповестить("Запись_СчетФактураНалоговыйАгент");

КонецПроцедуры

&НаКлиенте
Процедура СоздатьСчетФактуру(Команда)
	
	ОчиститьСообщения();
	СоздатьСчетФактуруНаСервере();
	ОповеститьОбИзменении(Тип("ДокументСсылка.СчетФактураНалоговыйАгент"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтавкуНДС18(Команда)
	
	Если СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18") Тогда
		УстановитьСтавкуНДС("18%");
	Иначе
		УстановитьСтавкуНДС("20%");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтавкуНДС10(Команда)
	
	УстановитьСтавкуНДС("10%");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидАгентскогоДоговораАренда(Команда)
	
	УстановитьВидАгентскогоДоговора(ПредопределенноеЗначение("Перечисление.ВидыАгентскихДоговоров.Аренда"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидАгентскогоДоговораНерезидент(Команда)
	
	УстановитьВидАгентскогоДоговора(ПредопределенноеЗначение("Перечисление.ВидыАгентскихДоговоров.Нерезидент"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидАгентскогоДоговораРеализацияИмущества(Команда)
	
	УстановитьВидАгентскогоДоговора(ПредопределенноеЗначение("Перечисление.ВидыАгентскихДоговоров.РеализацияИмущества"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидАгентскогоДоговораЭлектронныеУслуги(Команда)
	
	УстановитьВидАгентскогоДоговора(ПредопределенноеЗначение("Перечисление.ВидыАгентскихДоговоров.НерезидентЭлектронныеУслуги"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ОплатыПоставщикам);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ОплатыПоставщикам, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ОплатыПоставщикам);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОплатыПоставщикамСтавкаНДС.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОплатыПоставщикамСуммаНДС.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОплатыПоставщикамСуммаОплаты.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОплатыПоставщикамСумма.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОплатыПоставщикам.СФсформирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Указано в СФ';
																|en = 'Indicated in invoice'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОплатыПоставщикамПоставщик.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОплатыПоставщикам.Поставщик");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Указано в СФ';
																|en = 'Indicated in invoice'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОплатыПоставщикамНаСервере()
	
	ОплатыПоставщикам.Очистить();
	
	ОтборРасчетов = Документы.СчетФактураНалоговыйАгент.ОтборРасчетов();
	ЗаполнитьЗначенияСвойств(ОтборРасчетов, ЭтаФорма);
	Документы.СчетФактураНалоговыйАгент.ЗаполнитьОплатыПоставщикам(ОтборРасчетов, ОплатыПоставщикам);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьСчетФактуруНаСервере()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ИдентификаторСтроки Из Элементы.ОплатыПоставщикам.ВыделенныеСтроки Цикл
		СоздатьСчетФактуруНалоговыйАгент(ИдентификаторСтроки);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСчетаФактурыНаСервере()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
		РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСКлиентами(КонецПериода, АналитикиРасчета);
	КонецЕсли;
	
	Для каждого ДанныеСчетФактуры Из ОплатыПоставщикам Цикл
		
		Если НЕ СоздатьСчетФактуруНалоговыйАгент(ДанныеСчетФактуры) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось сформировать счет-фактуру на основании документа %1';
																						|en = 'Cannot generate a tax invoice based on document %1'"), ДанныеСчетФактуры.ДокументОснование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				,
				"Объект");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СоздатьСчетФактуруНалоговыйАгент(Знач ДанныеСчетФактуры) 
	
	Если ТипЗнч(ДанныеСчетФактуры) = Тип("Число") Тогда
		ДанныеСчетФактуры = ОплатыПоставщикам.НайтиПоИдентификатору(ДанныеСчетФактуры)
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ДанныеСчетФактуры.ВидАгентскогоДоговора) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо заполнить вид агентского договора';
				|en = 'Fill in an agency agreement kind'"),
			,
			"ОплатыПоставщикам[" + ДанныеСчетФактуры.ПолучитьИдентификатор() + "].ВидАгентскогоДоговора");
		Возврат Ложь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ДанныеСчетФактуры.ДокументОснование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо заполнить документ-основание';
				|en = 'Fill in base document'"),
			,
			"ОплатыПоставщикам[" + ДанныеСчетФактуры.ПолучитьИдентификатор() + "].ДокументОснование");
		Возврат Ложь;
	КонецЕсли;
	
	Если ДанныеСчетФактуры.Сумма = ДанныеСчетФактуры.СуммаСчетаФактуры И ДанныеСчетФактуры.СФсформирован Тогда
		Возврат Истина;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация", Организация);
	ДанныеЗаполнения.Вставить("Поставщик");
	ДанныеЗаполнения.Вставить("Договор");
	ДанныеЗаполнения.Вставить("ВидАгентскогоДоговора");
	ДанныеЗаполнения.Вставить("ДокументОснование");
	ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, ДанныеСчетФактуры);
	
	Если ДанныеСчетФактуры.СчетФактура.Пустая() Тогда
		СчетФактураОбъект = Документы.СчетФактураНалоговыйАгент.СоздатьДокумент();
	Иначе
		СчетФактураОбъект = ДанныеСчетФактуры.СчетФактура.ПолучитьОбъект();
	КонецЕсли; 
	
	СчетФактураОбъект.Заполнить(ДанныеЗаполнения);
	СчетФактураОбъект.Дата = КонецДня(ДанныеСчетФактуры.ДатаОплаты);
	
	СчетФактураОбъект.РасшифровкаСуммы.Очистить();
	
	НоваяСтрока = СчетФактураОбъект.РасшифровкаСуммы.Добавить();
	НоваяСтрока.Сумма = ДанныеСчетФактуры.Сумма;
	НоваяСтрока.СтавкаНДС = ДанныеСчетФактуры.СтавкаНДС;
	НоваяСтрока.НаправлениеДеятельности = ДанныеСчетФактуры.НаправлениеДеятельности;
	
	СтруктураПересчетаСуммы = Новый Структура();
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Ложь);
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, Неопределено);
	
	СчетФактураОбъект.Сумма     = СчетФактураОбъект.РасшифровкаСуммы.Итог("Сумма");
	СчетФактураОбъект.СуммаСНДС = СчетФактураОбъект.РасшифровкаСуммы.Итог("СуммаСНДС");
	СчетФактураОбъект.СуммаНДС  = СчетФактураОбъект.РасшифровкаСуммы.Итог("СуммаНДС");
	
	// Проведем счет-фактуру
	Попытка
		СчетФактураОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки; 
	
	// Обновим сведения о счете-фактуре
	ДанныеСчетФактуры.СФсформирован = Истина;
	ДанныеСчетФактуры.СуммаСчетаФактуры = СчетФактураОбъект.Сумма;
	ДанныеСчетФактуры.СчетФактура   = СчетФактураОбъект.Ссылка;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	НачалоПериода = НачалоМесяца(ТекущаяДатаСеанса());
	КонецПериода = КонецМесяца(ТекущаяДатаСеанса());
	
	СтавкаНДС = УчетНДСУП.СтавкаНДСПоУмолчанию(НачалоПериода);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	ОбновитьТекстКомандыУстановкиСтавкиНДС();
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
		ЗаполнитьОплатыПоставщикамНаСервере();
	КонецЕсли;
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстКомандыУстановкиСтавкиНДС()
	
	СтавкаНДС = УчетНДСУП.СтавкаНДСПоУмолчанию(НачалоПериода);
	Если СтавкаНДС = Перечисления.СтавкиНДС.НДС18 Тогда
		Элементы.УстановитьСтавкуНДС18.Заголовок = НСтр("ru = '18%';
														|en = '18%'");
	Иначе
		Элементы.УстановитьСтавкуНДС18.Заголовок = НСтр("ru = '20%';
														|en = '20%'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	ЗаголовокОтчета = НСтр("ru = 'Счета-фактуры налогового агента';
							|en = 'Tax invoices of tax agent'")
		+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Форма.НачалоПериода, Форма.КонецПериода);
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатВыбора, "НачалоПериода, КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтавкуНДС(ТекстСтавкаНДС)
	
	Если Элементы.ОплатыПоставщикам.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	Если ТекстСтавкаНДС = "10%" Тогда
		ТекСтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10")
	ИначеЕсли ТекстСтавкаНДС = "18%" Тогда
		ТекСтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18")
	Иначе
		ТекСтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20")
	КонецЕсли;
	
	Для каждого ИдентификаторСтроки Из Элементы.ОплатыПоставщикам.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ОплатыПоставщикам.ДанныеСтроки(ИдентификаторСтроки);
		Если ДанныеСтроки.СтавкаНДС <> ТекСтавкаНДС Тогда
			ДанныеСтроки.СтавкаНДС = ТекСтавкаНДС;
			ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ДанныеСтроки, СтруктураДействий, Неопределено);
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидАгентскогоДоговора(ВидАгентскогоДоговора)
	
	Если Элементы.ОплатыПоставщикам.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Для каждого ИдентификаторСтроки Из Элементы.ОплатыПоставщикам.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ОплатыПоставщикам.ДанныеСтроки(ИдентификаторСтроки);
		ДанныеСтроки.ВидАгентскогоДоговора = ВидАгентскогоДоговора;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПересчетСуммыНДСВСтрокеТЧ()

	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("ЦенаВключаетНДС", Ложь);
	
	Возврат СтруктураЗаполненияЦены;

КонецФункции

&НаКлиенте
Процедура ОткрытьДокумент(Ссылка, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоПараметрамФормы(Параметры)
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("НачалоПериода", НачалоПериода);
		СтруктураБыстрогоОтбора.Свойство("КонецПериода", КонецПериода);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
