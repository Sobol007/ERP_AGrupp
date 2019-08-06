////////////////////////////////////////////////////////////////////////////////
// Модуль "НаборыВызовСервера", содержит процедуры и функции для
// работы с наборами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура устанавливает условное оформление для механизма Наборов
// 
// Параметры:
//  Форма - Форма, в которой нужно установить условное оформление
//  ИмяТЧ - Строка - Имя табличной части
//  ТЧФормы - Булево - ТЧ это реквизит формы.
//
// Возвращаемое значение:
//  Нет
Процедура УстановитьУсловноеОформление(Форма, ИмяТЧ, ТЧФормы = Ложь) Экспорт
	
	ПоЗаказам = Ложь;
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, "Ссылка")
		И ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		И Форма.Объект.РеализацияПоЗаказам Тогда
		ПоЗаказам = Истина;
	КонецЕсли;
	
	//++ НЕ УТ
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, "Ссылка")
		И ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ПередачаТоваровХранителю")
		И Форма.Объект.ПередачаПоЗаказам Тогда
		
		ПоЗаказам = Истина;
		
	КонецЕсли;
	//-- НЕ УТ
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, "Ссылка")
		И ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктВыполненныхРабот")
		И Форма.Объект.АктПоЗаказам Тогда
		ПоЗаказам = Истина;
	КонецЕсли;
	
	УсловноеОформление = Форма.УсловноеОформление;
	Элементы           = Форма.Элементы;
	
	БлокируемыеЭлементы = НаборыКлиентСервер.БлокируемыеЭлементы(ИмяТЧ);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Для Каждого БлокируемыйЭлемент Из БлокируемыеЭлементы Цикл
		Если Элементы.Найти(БлокируемыйЭлемент) <> Неопределено Тогда
			ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы[БлокируемыйЭлемент].Имя);
		КонецЕсли;
	КонецЦикла;

	Если ТЧФормы Тогда
		Путь = ИмяТЧ;
	Иначе
		Путь = "Объект." + ИмяТЧ;
	КонецЕсли;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Путь + ".НоменклатураНабора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	Если ПоЗаказам Тогда
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Путь + ".КодСтроки");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 0;
	КонецЕсли;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

// Процедура должна вызываться при окончании редактирования набора
// в форме редактирования набора.
//
// Параметры:
//  Форма - Форма
//  ИмяТЧ - Строка - Имя табличной части
//  Параметры - Структура.
//
// Возвращаемое значение:
//  Нет
Процедура ПриОкончанииРедактированияНабора(Форма, ИмяТЧ = "Товары", Параметры) Экспорт
	
	Данные                                 = Параметры.Данные;
	СтруктураДействийСИзмененнымиСтроками  = Параметры.СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействийСДобавленнымиСтроками = Параметры.СтруктураДействийСДобавленнымиСтроками;
	Колонки                                = Параметры.КолонкиНабора;
	
	Отбор = Новый Структура;
	Отбор.Вставить("НоменклатураНабора",   Данные.НоменклатураНабора);
	Отбор.Вставить("ХарактеристикаНабора", Данные.ХарактеристикаНабора);
	Если ЗначениеЗаполнено(Данные.ДокументРеализации) Тогда
		Отбор.Вставить("ДокументРеализации", Данные.ДокументРеализации);
	КонецЕсли;
	Если Параметры.Свойство("СверхЗаказа") Тогда
		Отбор.Вставить("КодСтроки", 0);
	КонецЕсли;
	
	ОтвязатьОтНабора = Ложь;
	Если Данные.Свойство("ОтвязатьОтНабора") Тогда
		ОтвязатьОтНабора = Данные.ОтвязатьОтНабора;
	КонецЕсли;
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, ИмяТЧ) Тогда
		СтрокиКомплекта = Форма.Объект[ИмяТЧ].НайтиСтроки(Отбор);
	Иначе
		СтрокиКомплекта = Форма[ИмяТЧ].НайтиСтроки(Отбор);
	КонецЕсли;
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, ИмяТЧ) Тогда
		ТЧ = Форма.Объект[ИмяТЧ];
	Иначе
		ТЧ = Форма[ИмяТЧ];
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Данные.Комплектующие Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("НомерСтроки", СтрокаТЧ.НомерСтрокиДокумента);
		
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, ИмяТЧ) Тогда
			НайденныеСтроки = Форма.Объект[ИмяТЧ].НайтиСтроки(Отбор);
		Иначе
			НайденныеСтроки = Форма[ИмяТЧ].НайтиСтроки(Отбор);
		КонецЕсли;
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			
			ТекущаяСтрока = НайденныеСтроки[0];
			
			ИзмененныеПоля = Новый Массив;
			Для Каждого Колонка Из Колонки Цикл
				Если ТекущаяСтрока[Колонка] <> СтрокаТЧ[Колонка] Тогда
					ТекущаяСтрока[Колонка] = СтрокаТЧ[Колонка];
					ИзмененныеПоля.Добавить(Колонка);
				КонецЕсли;
			КонецЦикла;
			
			Если ОтвязатьОтНабора Тогда
				ТекущаяСтрока.НоменклатураНабора   = Неопределено;
				ТекущаяСтрока.ХарактеристикаНабора = Неопределено;
				ТекущаяСтрока.ИндексНабора         = 0;
			КонецЕсли;
			
			ОчищатьАвтоматическиеСкидки = Ложь;
			Если ИзмененныеПоля.Найти("КоличествоУпаковок") <> Неопределено
				ИЛИ ИзмененныеПоля.Найти("Цена") <> Неопределено
				ИЛИ ИзмененныеПоля.Найти("ВидЦены") <> Неопределено Тогда
				ОчищатьАвтоматическиеСкидки = Истина;
			КонецЕсли;
			
			ПараметрыСерий = Неопределено;
			
			Если СтруктураДействийСИзмененнымиСтроками.Свойство("ПроверитьСериюРассчитатьСтатус", ПараметрыСерий)  Тогда
				Если ПараметрыСерий = Неопределено Тогда
					ПараметрыУказанияСерий = ОпределитьПараметрыСерийПомощникаПродаж(Форма.Объект, Форма.ПараметрыУказанияСерий, ТекущаяСтрока);
					СтруктураДействийСИзмененнымиСтроками.ПроверитьСериюРассчитатьСтатус = Новый Структура("ПараметрыУказанияСерий", ПараметрыУказанияСерий);
				КонецЕсли;
				СтруктураДействийСИзмененнымиСтроками.ПроверитьСериюРассчитатьСтатус.Вставить("Склад", ТекущаяСтрока.Склад);
			КонецЕсли;
			
			Если СтруктураДействийСИзмененнымиСтроками.Свойство("ПересчитатьСуммуСУчетомАвтоматическойСкидки") Тогда
				СтруктураДействийСИзмененнымиСтроками.ПересчитатьСуммуСУчетомАвтоматическойСкидки.Вставить("Очищать", ОчищатьАвтоматическиеСкидки);
			КонецЕсли;
			
			КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействийСИзмененнымиСтроками, КэшированныеЗначения);
			
			ИндексСтроки = СтрокиКомплекта.Найти(ТекущаяСтрока);
			Если Не ИндексСтроки = Неопределено Тогда
				СтрокиКомплекта.Удалить(ИндексСтроки);
			КонецЕсли;
			
		Иначе
			
			НоваяСтрока = ТЧ.Добавить();
			НоваяСтрока.НоменклатураНабора   = Данные.НоменклатураНабора;
			НоваяСтрока.ХарактеристикаНабора = Данные.ХарактеристикаНабора;
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ,,"НоменклатураНабора,ХарактеристикаНабора");
			НоваяСтрока.ИндексНабора = ?(ЗначениеЗаполнено(НоваяСтрока.НоменклатураНабора), 1, 0);
			
			Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, "ВариантОформленияДокументов") Тогда
				ЗаполнитьВариантОформленияВСтрокеТабличнойЧастиПомощникаПродаж(НоваяСтрока, Форма.Объект.ВариантОформленияДокументов);
			КонецЕсли;
			
			Если СтруктураДействийСДобавленнымиСтроками.Свойство("ПроверитьХарактеристикуПоВладельцу") Тогда
				СтруктураДействийСДобавленнымиСтроками.ПроверитьХарактеристикуПоВладельцу = НоваяСтрока.Характеристика;
			КонецЕсли;
			Если СтруктураДействийСДобавленнымиСтроками.Свойство("ПроверитьЗаполнитьУпаковкуПоВладельцу") Тогда
				СтруктураДействийСДобавленнымиСтроками.ПроверитьЗаполнитьУпаковкуПоВладельцу = НоваяСтрока.Упаковка;
			КонецЕсли;
			
			ПараметрыСерий = Неопределено;
			Если СтруктураДействийСДобавленнымиСтроками.Свойство("ПроверитьСериюРассчитатьСтатус", ПараметрыСерий)  Тогда
				Если ПараметрыСерий = Неопределено Тогда
					ПараметрыУказанияСерий = ОпределитьПараметрыСерийПомощникаПродаж(Форма.Объект, Форма.ПараметрыУказанияСерий, НоваяСтрока);
					СтруктураДействийСДобавленнымиСтроками.ПроверитьСериюРассчитатьСтатус = Новый Структура("ПараметрыУказанияСерий", ПараметрыУказанияСерий);
				КонецЕсли;
				СтруктураДействийСДобавленнымиСтроками.ПроверитьСериюРассчитатьСтатус.Вставить("Склад", Форма.Объект.Склад);
			КонецЕсли;
			
			КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействийСДобавленнымиСтроками, КэшированныеЗначения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаКомплекта Из СтрокиКомплекта Цикл
		ТЧ.Удалить(СтрокаКомплекта);
	КонецЦикла;
	
	Если СтруктураДействийСДобавленнымиСтроками.Свойство("ПроверитьСериюРассчитатьСтатус") Тогда
		Если Форма.ПараметрыУказанияСерий.Свойство("Реализация")
			И Форма.ПараметрыУказанияСерий.Свойство("Заказ") Тогда
			НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Форма.Объект, Форма.ПараметрыУказанияСерий.Реализация);
			НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Форма.Объект, Форма.ПараметрыУказанияСерий.Заказ);
		Иначе
			НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Форма.Объект, Форма.ПараметрыУказанияСерий);
		КонецЕсли;
	КонецЕсли;
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

// Процедура должна вызываться при чтении или создании формы на сервере
//
// Параметры:
//  Форма - Форма
//  ИмяТЧ - Строка - Имя табличной части
//  ТЧТаблицаЗначенийФормы - Булево.
//
// Возвращаемое значение:
//  Нет
Процедура ЗаполнитьСлужебныеРеквизиты(Форма, ИмяТЧ = "Товары", ТЧТаблицаЗначенийФормы = Ложь) Экспорт
	
	Если НЕ ТЧТаблицаЗначенийФормы И ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, ИмяТЧ) Тогда
		ТЧ = Форма.Объект[ИмяТЧ];
	Иначе
		ТЧ = Форма[ИмяТЧ];
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ТЧ Цикл
		
		СтрокаТЧ.ИндексНабора = ?(ЗначениеЗаполнено(СтрокаТЧ.НоменклатураНабора), 1, 0);
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает адрес набора во временном хранилище для
// последующего редактирования набора во временном хранилище.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  Параметры - Структура - Параметры.
//  ИмяТЧ - Строка - Имя табличной части.
//
// Возвращаемое значение:
//  Строка - Адрес во временном хранилище.
//
Функция АдресНабораВоВременномХранилище(Форма, Параметры, ИмяТЧ = "Товары") Экспорт
	
	Параметры.КолонкиНабора.Добавить("НомерСтроки");
	Параметры.КолонкиНабора.Добавить("НомерСтрокиДокумента");
	Комплектующие = СоздатьТаблицуСоставаНабора(Параметры.КолонкиНабора);
	
	КопироватьКоличество = Ложь;
	Если Параметры.КолонкиНабора.Найти("Количество") <> Неопределено
		И Параметры.КолонкиНабора.Найти("КоличествоУпаковок") = Неопределено Тогда
		КопироватьКоличество = Истина;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("НоменклатураНабора",   Параметры.НоменклатураНабора);
	ПараметрыОтбора.Вставить("ХарактеристикаНабора", Параметры.ХарактеристикаНабора);
	Если Параметры.КолонкиНабора.Найти("ДокументРеализации") <> Неопределено Тогда
		ПараметрыОтбора.Вставить("ДокументРеализации", Параметры.ДокументРеализации);
	КонецЕсли;
	Если Параметры.Свойство("СверхЗаказа") Тогда
		ПараметрыОтбора.Вставить("КодСтроки", 0);
	КонецЕсли;
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, ИмяТЧ) Тогда
		НайденныеСтроки = Форма.Объект[ИмяТЧ].НайтиСтроки(ПараметрыОтбора);
	Иначе
		НайденныеСтроки = Форма[ИмяТЧ].НайтиСтроки(ПараметрыОтбора);
	КонецЕсли;
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		
		НоваяСтрока = Комплектующие.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, НайденнаяСтрока);
		НоваяСтрока.НомерСтрокиДокумента = НоваяСтрока.НомерСтроки;
		Если КопироватьКоличество Тогда
			НоваяСтрока.КоличествоУпаковок = НоваяСтрока.Количество;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(Комплектующие, Форма.УникальныйИдентификатор);
	
КонецФункции

// Возвращает таблицу коэффициентов распределения цены набора на комплектующие
//
// Параметры:
//  ТабличнаяЧасть - УправляемаяФорма - Форма.
//  Параметры - Структура - Параметры распределения.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица коэффициентов распределения цены набора на комплектующие.
//
Функция КоэффициентыРаспределения(ТабличнаяЧасть, Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Таблица.НомерСтроки                                       КАК НомерСтроки,
	|	Таблица.НоменклатураНабора                                КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора                              КАК ХарактеристикаНабора,
	|	Таблица.Номенклатура                                      КАК Номенклатура,
	|	Таблица.Характеристика                                    КАК Характеристика,
	|	Таблица.Упаковка                                          КАК Упаковка,
	|	Таблица.Количество                                        КАК Количество,
	|	Таблица.КоличествоУпаковок                                КАК КоличествоУпаковок
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&ТабличнаяЧасть КАК Таблица
	|;
	|
	|//////////////////////////
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки                                       КАК НомерСтроки,
	|	Таблица.НоменклатураНабора                                КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора                              КАК ХарактеристикаНабора,
	|	Таблица.Номенклатура                                      КАК Номенклатура,
	|	Таблица.Характеристика                                    КАК Характеристика,
	|	Таблица.Упаковка                                          КАК Упаковка,
	|	Таблица.Количество                                        КАК Количество,
	|	Таблица.КоличествоУпаковок                                КАК КоличествоУпаковок,
	|	ВариантыКомплектацииНоменклатуры.Ссылка                   КАК ВариантыКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора
	|ПОМЕСТИТЬ ТаблицаСВариантамиКомплектации
	|ИЗ
	|	Таблица КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ПО Таблица.НоменклатураНабора = ВариантыКомплектацииНоменклатуры.Владелец
	|			И Таблица.ХарактеристикаНабора = ВариантыКомплектацииНоменклатуры.Характеристика
	|			И ВариантыКомплектацииНоменклатуры.Основной
	|ГДЕ
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора <> ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих)
	|;
	|
	|/////
	|ВЫБРАТЬ
	|	Товары.Ссылка            КАК ВариантыКомплектацииНоменклатуры,
	|	Товары.Номенклатура      КАК Номенклатура,
	|	Товары.Характеристика    КАК Характеристика,
	|	СУММА(ВЫБОР
	|			КОГДА Товары.Количество <> 0
	|				ТОГДА Товары.ДоляСтоимости / Товары.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ДоляСтоимости
	|ПОМЕСТИТЬ ДолиСтоимости
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В (ВЫБРАТЬ РАЗЛИЧНЫЕ Т.ВариантыКомплектацииНоменклатуры ИЗ ТаблицаСВариантамиКомплектации КАК Т ГДЕ Т.ВариантРасчетаЦеныНабора = ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям))
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Ссылка
	|;
	|
	|/////
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки                                           КАК НомерСтроки,
	|	Таблица.НоменклатураНабора                                    КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора                                  КАК ХарактеристикаНабора,
	|	Таблица.Номенклатура                                          КАК Номенклатура,
	|	Таблица.Характеристика                                        КАК Характеристика,
	|	Таблица.Упаковка                                              КАК Упаковка,
	|	Таблица.Количество                                            КАК Количество,
	|	Таблица.КоличествоУпаковок                                    КАК КоличествоУпаковок,
	|	ВЫРАЗИТЬ(Таблица.Количество * ЕСТЬNULL(ДолиСтоимости.ДоляСтоимости, 0) КАК Число(15,2)) КАК Цена,
	|	Таблица.ВариантыКомплектацииНоменклатуры                      КАК ВариантыКомплектацииНоменклатуры,
	|	Таблица.ВариантРасчетаЦеныНабора                              КАК ВариантРасчетаЦеныНабора
	|ИЗ
	|	ТаблицаСВариантамиКомплектации КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДолиСтоимости КАК ДолиСтоимости
	|		ПО ДолиСтоимости.ВариантыКомплектацииНоменклатуры = Таблица.ВариантыКомплектацииНоменклатуры
	|			И Таблица.ВариантРасчетаЦеныНабора = ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям)
	|			И Таблица.Номенклатура = ДолиСтоимости.Номенклатура
	|			И Таблица.Характеристика = ДолиСтоимости.Характеристика
	|");
	
	// Выгрузить из таблицы источника
	Если ТипЗнч(ТабличнаяЧасть) = Тип("ТаблицаЗначений") Тогда
		Запрос.Параметры.Вставить("ТабличнаяЧасть", ТабличнаяЧасть.Скопировать());
	Иначе
		Запрос.Параметры.Вставить("ТабличнаяЧасть", ТабличнаяЧасть.Выгрузить());
	КонецЕсли;
	
	ПараметрыРасчета = Новый Структура;
	Для Каждого Параметр Из Параметры Цикл
		ПараметрыРасчета.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	ПараметрыРасчета.Вставить("РассчитыватьНаборы", Ложь);
	
	ТЧ = Запрос.Выполнить().Выгрузить();
	
	ЦеныРассчитаны = ПродажиСервер.ЗаполнитьЦены(
		ТЧ,
		Новый Структура("ВариантРасчетаЦеныНабора", Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам), // Массив строк или структура отбора
		ПараметрыРасчета);
		
	Для Каждого СтрокаТЧ Из ТЧ Цикл
		Если СтрокаТЧ.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам Тогда
			СтрокаТЧ.Цена = Окр(СтрокаТЧ.Цена * СтрокаТЧ.КоличествоУпаковок, 2);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТЧ;
	
КонецФункции

#Область ПечатныеФормы

// Возвращает пустые значения параметров подсистемы.
//
// Возвращаемое значение:
//  Структура - Пустые значения параметров.
Функция ПустыеДанные() Экспорт
	
	Знак = "";
	ПустыеДанные = Новый Структура;
	ПустыеДанные.Вставить("Количество", Знак);
	ПустыеДанные.Вставить("ЕдиницаИзмерения", Знак);
	ПустыеДанные.Вставить("Цена", Знак);
	ПустыеДанные.Вставить("Сумма", Знак);
	ПустыеДанные.Вставить("СтавкаНДС", Знак);
	ПустыеДанные.Вставить("СуммаНДС", Знак);
	ПустыеДанные.Вставить("СуммаБезНДС", Знак);
	ПустыеДанные.Вставить("СуммаСНДС", Знак);
	ПустыеДанные.Вставить("СуммаНДС", Знак);
	ПустыеДанные.Вставить("ВидЦеныИсполнителя", Знак);
	ПустыеДанные.Вставить("ДатаОтгрузки", Знак);
	ПустыеДанные.Вставить("Характеристика", Знак);
	ПустыеДанные.Вставить("Упаковка", Знак);
	ПустыеДанные.Вставить("СуммаСкидки", Знак);
	ПустыеДанные.Вставить("СуммаБезСкидки", Знак);
	
	ПустыеДанные.Вставить("НоменклатураКод", Знак);
	ПустыеДанные.Вставить("ЕдиницаИзмеренияНаименование", Знак);
	ПустыеДанные.Вставить("ЕдиницаИзмеренияКод", Знак);
	ПустыеДанные.Вставить("ВидУпаковки", Знак);
	ПустыеДанные.Вставить("КоличествоВОдномМесте", Знак);
	ПустыеДанные.Вставить("КоличествоМест", Знак);
	ПустыеДанные.Вставить("МассаБрутто", Знак);
	
	ПустыеДанные.Вставить("Акциз", Знак);
	
	Возврат ПустыеДанные;
	
КонецФункции

// Возвращает префикс и постфикс наименования для вывода в печатных формах
// 
// Параметры:
//  СтрокаТовары - СтрокаТаблицы
//  ИспользоватьНаборы - Значение ФО "ИспользоватьНаборы".
//
// Возвращаемое значение:
//  Структура - префикс и постфикс.
Функция ПолучитьПрефиксИПостфикс(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Префикс = "";
	Постфикс = "";
	Если ИспользоватьНаборы 
		И (СтрокаТовары.ЭтоКомплектующие ИЛИ СтрокаТовары.ЭтоНабор)
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие Тогда
		
		Если СтрокаТовары.ЭтоКомплектующие Тогда
			Префикс = Символы.Таб + "•" + " ";
		КонецЕсли;
		
		Если СтрокаТовары.ЭтоКомплектующие
			И (СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
			  ИЛИ СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам) Тогда
			Постфикс = " - " + СтрокаТовары.Количество + " " +СтрокаТовары.ЕдиницаИзмерения;
		КонецЕсли;
		
		ПолныйНабор = Истина;
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТовары, "ПолныйНабор")
			И СтрокаТовары.ЭтоНабор Тогда
			ПолныйНабор = СтрокаТовары.ПолныйНабор;
		КонецЕсли;
		
		Если СтрокаТовары.ЭтоНабор
			И СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих Тогда
			Постфикс = " - " + СтрокаТовары.Количество + " " +СтрокаТовары.ЕдиницаИзмерения;
		КонецЕсли;
		
		Если НЕ ПолныйНабор Тогда
			Постфикс = Постфикс + " " + НСтр("ru = '(Часть набора)';
											|en = '(Part of a set)'");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Новый Структура("Префикс, Постфикс", Префикс, Постфикс);
	
КонецФункции

// Возвращает Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
// за исключением наименования.
// 
// Параметры:
//  СтрокаТовары - Структура - Строка таблицы.
//  ИспользоватьНаборы - Булево - Значение ФО "ИспользоватьНаборы".
//
// Возвращаемое значение:
//  Булево - СтрокаТовара должна отображаться с пустыми данными в колонках
//           за исключением наименования.
Функция ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
		Возврат ВыводитьТолькоЗаголовокНабора(СтрокаТовары, ИспользоватьНаборы)
	ИначеЕсли ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
		Возврат ВыводитьТолькоЗаголовокКомплектующих(СтрокаТовары, ИспользоватьНаборы)
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
// за исключением наименования и данная строка - Комплектующие набора.
// 
// Параметры:
//  СтрокаТовары - СтрокаТаблицы
//  ИспользоватьНаборы - Значение ФО "ИспользоватьНаборы".
//
// Возвращаемое значение:
//  Булево
Функция ВыводитьТолькоЗаголовокКомплектующих(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоКомплектующие
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие
		И (    СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
		   ИЛИ СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам)
		Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
// за исключением наименования и данная строка - Набор.
// 
// Параметры:
//  СтрокаТовары - Структура - Строка таблицы.
//  ИспользоватьНаборы - Булево - Значение ФО "ИспользоватьНаборы".
//
// Возвращаемое значение:
//  Булево - СтрокаТовара должна отображаться с пустыми данными в колонках
//           за исключением наименования и данная строка - Набор.
//
Функция ВыводитьТолькоЗаголовокНабора(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоНабор
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие
		И СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих
		Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если область набора должна быть использована в печатной форме
// 
// Параметры:
//  СтрокаТовары - Структура - СтрокаТаблицы.
//  ИспользоватьНаборы - Булево - Значение ФО "ИспользоватьНаборы".
//
// Возвращаемое значение:
//  Булево - область набора должна быть использована в печатной форме.
//
Функция ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоНабор
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если область комплектующих должна быть использована в печатной форме.
// 
// Параметры:
//  СтрокаТовары - Структура - Строка таблицы.
//  ИспользоватьНаборы - Булево - Значение ФО "ИспользоватьНаборы".
//
// Возвращаемое значение:
//  Булево - область комплектующих должна быть использована в печатной форме.
//
Функция ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоКомплектующие
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Процедура обработчик события ПриУдалении
// 
// Параметры:
//  Форма     - Форма
//  ИмяТЧ     - Строка, Имя табличной части
//  Параметры - Структура (Наборы, Прочее).
//
Процедура ПриУдаленииКомплектующих(Форма, ИмяТЧ, Параметры) Экспорт
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, ИмяТЧ) Тогда
		ТЧ = Форма.Объект[ИмяТЧ];
	Иначе
		ТЧ = Форма[ИмяТЧ];
	КонецЕсли;

	Для Индекс = -Параметры.Прочее.Количество() + 1 По 0 Цикл
		СтрокаТЧ = ТЧ.НайтиПоИдентификатору(Параметры.Прочее[-Индекс]);
		ТЧ.Удалить(СтрокаТЧ);
	КонецЦикла;
	
	Для Каждого Набор Из Параметры.Наборы Цикл
		НайденныеСтроки = ТЧ.НайтиСтроки(Набор);
		Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
			ТЧ.Удалить(СтрокаТЧ);
		КонецЦикла;
	КонецЦикла;
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создать таблицу состава набора
//
// Параметры:
//  КолонкиНабора - Массив - Наименования колонок.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица состава набора.
//
Функция СоздатьТаблицуСоставаНабора(КолонкиНабора) Экспорт
	
	Комплектующие = Новый ТаблицаЗначений;
	
	Комплектующие.Колонки.Добавить("НоменклатураНабора",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Комплектующие.Колонки.Добавить("ХарактеристикаНабора", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	
	Если КолонкиНабора.Найти("НомерСтроки") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("НомерСтроки",          ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(5,0));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("НомерСтрокиДокумента") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("НомерСтрокиДокумента", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(5,0));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("Номенклатура") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("Характеристика") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("Цена") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("Цена", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	КонецЕсли;
	
	Если КолонкиНабора.Найти("ВидЦены") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("ВидЦены", Новый ОписаниеТипов("СправочникСсылка.ВидыЦен"));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("Упаковка") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("Количество") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("Количество", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,3));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("КоличествоУпаковок") <> Неопределено ИЛИ КолонкиНабора.Найти("Количество") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("КоличествоУпаковок", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,3));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("ПроцентРучнойСкидки") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("ПроцентРучнойСкидки", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,2));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("СуммаРучнойСкидки") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("СуммаРучнойСкидки", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	КонецЕсли;
	
	Если КолонкиНабора.Найти("ПроцентАвтоматическойСкидки") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("ПроцентАвтоматическойСкидки", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,2));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("СуммаАвтоматическойСкидки") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("СуммаАвтоматическойСкидки", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	КонецЕсли;
	
	Если КолонкиНабора.Найти("ПричинаОтмены") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("ПричинаОтмены", Новый ОписаниеТипов("СправочникСсылка.ПричиныОтменыЗаказовКлиентов"));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("Отменено") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("Отменено", Новый ОписаниеТипов("Булево"));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("СтавкаНДС") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("СтавкаНДС", Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС"));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("СуммаНДС") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("СуммаНДС", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	КонецЕсли;

	Если КолонкиНабора.Найти("СуммаСНДС") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("СуммаСНДС", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	КонецЕсли;

	Если КолонкиНабора.Найти("Сумма") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("Сумма", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	КонецЕсли;
	
	Если КолонкиНабора.Найти("Доступно") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("Доступно", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,3));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("ВНаличии") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("ВНаличии", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,3));
	КонецЕсли;
	
	Если КолонкиНабора.Найти("ДокументРеализации") <> Неопределено Тогда
		Комплектующие.Колонки.Добавить("ДокументРеализации", Новый ОписаниеТипов("ДокументСсылка.РеализацияТоваровУслуг, 
		//++ НЕ УТ
											|ДокументСсылка.ПередачаТоваровХранителю, 
		//-- НЕ УТ
											|ДокументСсылка.ОтчетОРозничныхПродажах"));
	КонецЕсли;
	
	Возврат Комплектующие;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПомощникПродаж

// Возвращает параметры указания серий.
//
// Параметры:
//  Объект - Объект
//  ПараметрыУказанияСерий - Структура со свойствами:
//   * Реализация - Структура - состав полей задается функцией НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//   * Заказ - Структура - состав полей задается функцией НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//  ТекущиеДанные - ТекущиеДанные - Текущие данные.
//
// Возвращаемое значение:
//  Структура - состав полей задается функцией НоменклатураКлиентСервер.ПараметрыУказанияСерий
//             (см. описание полей в комментарии к этой функции).
Функция ОпределитьПараметрыСерийПомощникаПродаж(Объект, ПараметрыУказанияСерий, ТекущиеДанные)
	
	Если ТекущиеДанные.ВариантОформления = Перечисления.ВариантыОформленияДокументовПродажи.РеализацияТоваровУслуг
		Или	ТекущиеДанные.ВариантОформления = Перечисления.ВариантыОформленияДокументовПродажи.ЗаказКлиентаРеализацияТоваровУслуг Тогда
		Возврат ПараметрыУказанияСерий.Реализация;
	Иначе
		Возврат ПараметрыУказанияСерий.Заказ;
	КонецЕсли;
	
КонецФункции

// Заполняет вариант оформления в строке табличной части помощника продаж.
//
// Параметры:
//  ТекСтрока - Структура - Текущая строка.
//  ВариантОформленияДокументов - ПеречислениеСсылка.ВариантыОформленияДокументовПродажи - Вариант оформления.
//
Процедура ЗаполнитьВариантОформленияВСтрокеТабличнойЧастиПомощникаПродаж(ТекСтрока, ВариантОформленияДокументов)
	
	Если ВариантОформленияДокументов = ПредопределенноеЗначение("Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаРеализацияТоваровУслуг") Тогда
		Если ТекСтрока.ДатаОтгрузки = НачалоДня(ТекущаяДатаСеанса()) Или ТекСтрока.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга") Или ТекСтрока.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда
			ТекСтрока.ВариантОформления = ПредопределенноеЗначение("Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаРеализацияТоваровУслуг");
		Иначе
			ТекСтрока.ВариантОформления = ПредопределенноеЗначение("Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиента");
		КонецЕсли;
	Иначе
		ТекСтрока.ВариантОформления = ВариантОформленияДокументов;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти