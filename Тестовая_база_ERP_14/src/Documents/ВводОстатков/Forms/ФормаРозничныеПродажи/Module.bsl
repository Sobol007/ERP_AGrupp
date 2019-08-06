#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаСтр = Строка(ВалютаУправленческогоУчета);
	КоэффициентПересчетаИзВалютыУпрВРегл = КоэффициентПересчета(ВалютаУправленческогоУчета, ВалютаРегламентированногоУчета, Объект.Дата);
	
	СтрокаЗаголовка = "%1 (%2)";
	ЗаголовокЦена = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'Цена';
																									|en = 'Price'"), ВалютаСтр);
	ЗаголовокСумма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'Сумма';
																									|en = 'Amount'"), ВалютаСтр);
	ЗаголовокНДС = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'НДС';
																								|en = 'VAT'"), ВалютаСтр);
	Элементы.РозничныеПродажиЦена.Заголовок = ЗаголовокЦена;
	Элементы.РозничныеПродажиСумма.Заголовок = ЗаголовокСумма;
	Элементы.РозничныеПродажиСуммаНДС.Заголовок = ЗаголовокНДС;
	
	ИспользуетсяНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	ИспользуютсяКартыЛояльности = ПолучитьФункциональнуюОпцию("ИспользоватьКартыЛояльности");
	
	Если Не (ИспользуетсяНесколькоОрганизаций ИЛИ ЗначениеЗаполнено(Объект.Организация)) Тогда
		Объект.Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	УстановитьЗаголовок();
	ИмяТекущейТаблицыФормы = Элементы.РозничныеПродажи.Имя;
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.РозничныеПродажи, ПараметрыЗаполненияРеквизитов);
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, КэшированныеЗначения);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Обработка.ЗагрузкаДанныхИзВнешнихФайлов.Форма.Форма" Тогда
		ПолучитьЗагруженныеТоварыИзХранилища(ВыбранноеЗначение.АдресТоваровВХранилище, КэшированныеЗначения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВидКартыЛояльности" Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРозничныеПродажи

&НаКлиенте
Процедура РозничныеПродажиНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, ИмяТекущейТаблицыФормы)); 
		
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.СтавкаНДС) Тогда
		ТекущаяСтрока.СтавкаНДС = СтавкаНДСНоменклатуры(ТекущаяСтрока.Номенклатура);
	КонецЕсли;
	УпаковкаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиКоличествоПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиУпаковкаПриИзменении(Элемент)
	
	УпаковкаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиЦенаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиСуммаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьЦенуПоСумме", "Количество");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.РозничныеПродажи.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиШтрихкодПриИзменении(Элемент)
	
	ШтрихКодПриИзменении(Элементы.РозничныеПродажи.ТекущиеДанные.ПолучитьИдентификатор())
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиМагнитныйКодПриИзменении(Элемент)
	
	МагнитныйКодПриИзменении(Элементы.РозничныеПродажи.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиВидКартыЛояльностиПриИзменении(Элемент)

	ВидКартыЛояльностиПриИзмененииСервер(Элементы.РозничныеПродажи.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиКартаЛояльностиПриИзменении(Элемент)
	
	КартаЛояльностиПриИзмененииСервер(Элементы.РозничныеПродажи.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиКартаЛояльностиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	МассивПараметров = Новый Массив;
	Если ЗначениеЗаполнено(Элементы.РозничныеПродажи.ТекущиеДанные.ВидКартыЛояльности) Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", Элементы.РозничныеПродажи.ТекущиеДанные.ВидКартыЛояльности));
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		Элементы.РозничныеПродажиКартаЛояльности.ПараметрыВыбора = ПараметрыВыбора;
	Иначе
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		Элементы.РозничныеПродажиКартаЛояльности.ПараметрыВыбора = ПараметрыВыбора;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ВводОстатков.ФормаРозничныеПродажи.Команда.ОткрытьПодбор");
	
	Отказ = Ложь;

	ПараметрЗаголовок = НСтр("ru = 'Подбор товаров в %Документ%';
							|en = 'Select goods in %Документ%'");
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Объект.Ссылка);
	Иначе
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru = 'ввод остатков';
																				|en = 'enter balance '"));
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Соглашение",		Объект.СоглашениеСКлиентом);
	ПараметрыФормы.Вставить("Валюта",			Объект.Валюта);
	ПараметрыФормы.Вставить("ЦенаВключаетНДС",	Объект.ЦенаВключаетНДС);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров", Ложь);
	ПараметрыФормы.Вставить("РежимПодбораИспользоватьСкладыВТабличнойЧасти", Ложь);
	ПараметрыФормы.Вставить("СкрыватьРучныеСкидки", Истина);
	ПараметрыФормы.Вставить("ИспользоватьДатыОтгрузки", Ложь);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры", Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах", Истина);
	ПараметрыФормы.Вставить("ПоказыватьПодобранныеТовары", Истина);
	ПараметрыФормы.Вставить("ЗапрашиватьКоличество", Истина);
	ПараметрыФормы.Вставить("Заголовок", ПараметрЗаголовок);
	ПараметрыФормы.Вставить("Дата",      Объект.Дата);
	ПараметрыФормы.Вставить("Документ",  Объект.Ссылка);
	ПараметрыФормы.Вставить("БезОтбораПоВключениюНДСВЦену", Истина);

	ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЗагружатьЦены", Истина);
	ПараметрыФормы.Вставить("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС);
	ПараметрыФормы.Вставить("НалогообложениеНДС", Объект.НалогообложениеНДС);
	
	ОткрытьФорму(
		"Обработка.ЗагрузкаДанныхИзВнешнихФайлов.Форма.Форма",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
																						  Объект.Номер,
																						  Объект.Дата,
																						  Объект.ТипОперации);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "РозничныеПродажиХарактеристика",
																			 "Объект.РозничныеПродажи.ХарактеристикиИспользуются");
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "РозничныеПродажиНоменклатураЕдиницаИзмерения",
																   "Объект.РозничныеПродажи.Упаковка");
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РозничныеПродажиУпаковка.Имя);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТипОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОперацийВводаОстатков.РозничныеПродажиЗаПрошлыеПериоды;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, Форма)

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Форма.Объект);

	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", Форма.КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);

КонецПроцедуры

&НаСервере
Процедура ПолучитьЗагруженныеТоварыИзХранилища(АдресТоваровВХранилище, КэшированныеЗначения)
	
	ТоварыИзХранилища = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);

	Для Каждого СтрокаТоваров Из ТоварыИзХранилища Цикл
		СтрокаТЧТовары = Объект.РозничныеПродажи.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧТовары, СтрокаТоваров);
		СтрокаТЧТовары.СуммаНДС = 0;
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧТовары, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, КэшированныеЗначения)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		ТекущаяСтрока = Объект.РозничныеПродажи.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, "Номенклатура, Характеристика, Упаковка, КоличествоУпаковок, Цена");
		ТекущаяСтрока.СтавкаНДС = СтавкаНДСНоменклатуры(ТекущаяСтрока.Номенклатура);

		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	КонецЦикла;
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
											
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.РозничныеПродажи,ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоэффициентПересчета(ВалютаУправленческогоУчета, ВалютаРегламентированногоУчета, ДатаДокумента)
	
	Возврат РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
											ВалютаУправленческогоУчета,
											ВалютаРегламентированногоУчета,
											?(ДатаДокумента = Дата(1,1,1), ТекущаяДатаСеанса(), ДатаДокумента));
	
КонецФункции

&НаКлиенте
Процедура УпаковкаПриИзменении()

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");

	Если ТекущаяСтрока.Количество > 0 Тогда
		СтруктураДействий.Вставить("ПересчитатьЦенуЗаУпаковку", ТекущаяСтрока.Количество);
	КонецЕсли;

	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаСервереБезКонтекста
Функция СтавкаНДСНоменклатуры(Номенклатура)

	Возврат Справочники.Номенклатура.ЗначенияРеквизитовНоменклатуры(Номенклатура).СтавкаНДС;

КонецФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.РозничныеПродажи,ПараметрыЗаполненияРеквизитов);
	
	ПолучитьДанныеОВидахКартЛояльности();
	УстановитьВидимость();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеОВидахКартЛояльности()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКарт.Ссылка
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКарт
	|ГДЕ
	|	ВидыКарт.ТипКарты = ЗНАЧЕНИЕ(Перечисление.ТипыКарт.Магнитная)
	|
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКарт.Ссылка
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКарт
	|ГДЕ
	|	ВидыКарт.ТипКарты = ЗНАЧЕНИЕ(Перечисление.ТипыКарт.Штриховая)
	|
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКарт.Ссылка
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКарт
	|ГДЕ
	|	ВидыКарт.ТипКарты = ЗНАЧЕНИЕ(Перечисление.ТипыКарт.Смешанная)
	|");
	
	Результат = Запрос.ВыполнитьПакет();
	ВведеныМагнитныеВидыКарт = НЕ Результат[0].Пустой();
	ВведеныШтриховыеВидыКарт = НЕ Результат[1].Пустой();
	ВведеныСмешанныеВидыКарт = НЕ Результат[2].Пустой();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.РозничныеПродажиШтрихкод.Видимость = ИспользуютсяКартыЛояльности 
																И (ВведеныШтриховыеВидыКарт ИЛИ ВведеныСмешанныеВидыКарт);
	Элементы.РозничныеПродажиМагнитныйКод.Видимость = ИспользуютсяКартыЛояльности
																	И (ВведеныМагнитныеВидыКарт ИЛИ ВведеныСмешанныеВидыКарт);
	Элементы.РозничныеПродажиВидКартыЛояльности.Видимость = ИспользуютсяКартыЛояльности
	
КонецПроцедуры

&НаСервере
Процедура ШтрихКодПриИзменении(Идентификатор)
	
	ТекущаяСтрока = Объект.РозничныеПродажи.НайтиПоИдентификатору(Идентификатор);
	ТипКода = Перечисления.ТипыКодовКарт.Штрихкод;
	Счетчик = 0;
	
	Если ТекущаяСтрока.ШтрихКод <> "" Тогда
		КартыЛояльностиШтриховые = КартыЛояльностиСервер.НайтиКартыЛояльности(ТекущаяСтрока.ШтрихКод, ТипКода);
		Для Каждого СтрокаТЧ Из КартыЛояльностиШтриховые.ЗарегистрированныеКартыЛояльности Цикл
			Если ЗначениеЗаполнено(ТекущаяСтрока.ВидКартыЛояльности) Тогда
				Если ТекущаяСтрока.ВидКартыЛояльности = СтрокаТЧ.ВидКарты Тогда
					НайденнаяКарта = СтрокаТЧ.Ссылка;
					НайденныйВидКарты = СтрокаТЧ.ВидКарты;
					МагнитныйКод = СтрокаТЧ.МагнитныйКод;
					Счетчик = Счетчик + 1;
				КонецЕсли;
			Иначе
				НайденнаяКарта = СтрокаТЧ.Ссылка;
				НайденныйВидКарты = СтрокаТЧ.ВидКарты;
				МагнитныйКод = СтрокаТЧ.МагнитныйКод;
				Счетчик = Счетчик + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Счетчик = 1 Тогда
		ТекущаяСтрока.КартаЛояльности = НайденнаяКарта;
		ТекущаяСтрока.ВидКартыЛояльности = НайденныйВидКарты;
		ТекущаяСтрока.МагнитныйКод = МагнитныйКод;
	Иначе 
		Если ТекущаяСтрока.ШтрихКод <> "" И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВидКартыЛояльности) Тогда
			ВидыКарт = КартыЛояльностиСервер.ПолучитьВозможныеВидыКартыЛояльностиПоКодуКарты(ТекущаяСтрока.ШтрихКод, ТипКода);
			Если ВидыКарт.Количество() = 1 Тогда
				ТекущаяСтрока.ВидКартыЛояльности = ВидыКарт[0];
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура МагнитныйКодПриИзменении(Идентификатор)
	
	ТекущаяСтрока = Объект.РозничныеПродажи.НайтиПоИдентификатору(Идентификатор);
	ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод;
	Счетчик = 0;
	
	Если ТекущаяСтрока.МагнитныйКод <> "" Тогда
		КартыЛояльностиМагнитные = КартыЛояльностиСервер.НайтиКартыЛояльности(ТекущаяСтрока.МагнитныйКод, ТипКода);
		Для Каждого СтрокаТЧ Из КартыЛояльностиМагнитные.ЗарегистрированныеКартыЛояльности Цикл
			Если ЗначениеЗаполнено(ТекущаяСтрока.ВидКартыЛояльности) Тогда
				Если ТекущаяСтрока.ВидКартыЛояльности = СтрокаТЧ.ВидКарты Тогда
					НайденнаяКарта = СтрокаТЧ.Ссылка;
					НайденныйВидКарты = СтрокаТЧ.ВидКарты;
					Штрихкод = СтрокаТЧ.ШтрихКод;
					Счетчик = Счетчик + 1;
				КонецЕсли;
			Иначе
				НайденнаяКарта = СтрокаТЧ.Ссылка;
				НайденныйВидКарты = СтрокаТЧ.ВидКарты;
				Штрихкод = СтрокаТЧ.ШтрихКод;
				Счетчик = Счетчик + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Счетчик = 1 Тогда
		ТекущаяСтрока.КартаЛояльности = НайденнаяКарта;
		ТекущаяСтрока.ВидКартыЛояльности = НайденныйВидКарты;
		ТекущаяСтрока.ШтрихКод = ШтрихКод;
	Иначе
		Если ТекущаяСтрока.МагнитныйКод <> "" И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВидКартыЛояльности) Тогда
			ВидыКарт = КартыЛояльностиСервер.ПолучитьВозможныеВидыКартыЛояльностиПоКодуКарты(ТекущаяСтрока.МагнитныйКод, ТипКода);
			Если ВидыКарт.Количество() = 1 Тогда
				ТекущаяСтрока.ВидКартыЛояльности = ВидыКарт[0];
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВидКартыЛояльностиПриИзмененииСервер(Идентификатор)
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущаяСтрока = Объект.РозничныеПродажи.НайтиПоИдентификатору(Идентификатор);
	
	МагнитныйКод = СокрЛП(ТекущаяСтрока.МагнитныйКод);
	Штрихкод = СокрЛП(ТекущаяСтрока.Штрихкод);
	
	Счетчик = 0;
	НайденнаяКарта = Неопределено;
	
	Если МагнитныйКод <> "" Тогда
		КартыЛояльностиМагнитные = КартыЛояльностиСервер.НайтиКартыЛояльности(МагнитныйКод, Перечисления.ТипыКодовКарт.МагнитныйКод);
		Для Каждого СтрокаТЧ Из КартыЛояльностиМагнитные.ЗарегистрированныеКартыЛояльности Цикл
			НайденнаяКарта = СтрокаТЧ.Ссылка;
			Счетчик = Счетчик + 1;
		КонецЦикла;
	КонецЕсли;
	
	Если Штрихкод <> "" Тогда
		КартыЛояльностиШтриховые = КартыЛояльностиСервер.НайтиКартыЛояльности(Штрихкод, Перечисления.ТипыКодовКарт.Штрихкод);
		Для Каждого СтрокаТЧ Из КартыЛояльностиШтриховые.ЗарегистрированныеКартыЛояльности Цикл
			НайденнаяКарта = СтрокаТЧ.Ссылка;
			Счетчик = Счетчик + 1;
		КонецЦикла;
	КонецЕсли;
	
	Если Счетчик = 1 Тогда
		ТекущаяСтрока.КартаЛояльности = НайденнаяКарта;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КартаЛояльностиПриИзмененииСервер(Идентификатор)
	
	ТекущаяСтрока = Объект.РозничныеПродажи.НайтиПоИдентификатору(Идентификатор);
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	КартыЛояльности.Владелец КАК ВидКартыЛояльности,
		|	КартыЛояльности.Штрихкод,
		|	КартыЛояльности.МагнитныйКод
		|ИЗ
		|	Справочник.КартыЛояльности КАК КартыЛояльности
		|ГДЕ
		|	КартыЛояльности.Ссылка = &Ссылка
		|");
	
	Запрос.УстановитьПараметр("Ссылка", ТекущаяСтрока.КартаЛояльности);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Выборка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.НалогообложениеНДС = Справочники.Организации.НалогообложениеНДС(
			Объект.Организация,
			,
			Объект.Дата);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользуютсяКартыЛояльности Тогда
		Ошибки = Неопределено;
		Для Каждого Стр Из Объект.РозничныеПродажи Цикл
			Если Стр.ВидКартыЛояльности.ТипКарты = Перечисления.ТипыКарт.Штриховая И НЕ ЗначениеЗаполнено(Стр.ШтрихКод) Тогда
				Группа = "ШтрихКоды";
				Текст = Нстр("ru = 'Штрихкод для данного вида карт лояльности обязателен к заполнению!';
							|en = 'Barcode for this loyalty card kind is required.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
																						"Объект.РозничныеПродажи[%1].ШтрихКод",
																						Текст, ""
																						,
																						Стр.НомерСтроки - 1,
																						Текст);
			ИначеЕсли Стр.ВидКартыЛояльности.ТипКарты = Перечисления.ТипыКарт.Магнитная И НЕ ЗначениеЗаполнено(Стр.МагнитныйКод) Тогда
				Группа = "МагнитныеКоды";
				Текст = Нстр("ru = 'Магнитный код для данного вида карт лояльности обязателен к заполнению!';
							|en = 'Magnetic code for this loyalty card kind should be populated.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
																						"Объект.РозничныеПродажи[%1].МагнитныйКод",
																						Текст, ""
																						,
																						Стр.НомерСтроки - 1,
																						Текст);
			ИначеЕсли Стр.ВидКартыЛояльности.ТипКарты = Перечисления.ТипыКарт.Смешанная Тогда 
				Группа = "СмешанныеКоды";
				Если НЕ ЗначениеЗаполнено(Стр.ШтрихКод) Тогда
					Текст = Нстр("ru = 'Штрихкод для данного вида карт лояльности обязателен к заполнению!';
								|en = 'Barcode for this loyalty card kind is required.'");
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
																							"Объект.РозничныеПродажи[%1].ШтрихКод",
																							Текст, ""
																							,
																							Стр.НомерСтроки - 1,
																							Текст);
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(Стр.МагнитныйКод) Тогда
					Текст = Нстр("ru = 'Магнитный код для данного вида карт лояльности обязателен к заполнению!';
								|en = 'Magnetic code for this loyalty card kind should be populated.'");
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
																							"Объект.РозничныеПродажи[%1].МагнитныйКод",
																							Текст, ""
																							,
																							Стр.НомерСтроки - 1,
																							Текст);
				КонецЕсли;
			КонецЕсли
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
