
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КассаККМ = Параметры.КассаККМ;
	СтруктураСостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	КассоваяСмена = СтруктураСостояниеКассовойСмены.КассоваяСмена;
	
	Период = Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
	
	Если ЗначениеЗаполнено(КассоваяСмена) Тогда
		ИспользуетсяККТФЗ54 = РозничныеПродажиВызовСервера.ИспользуетсяККТФЗ54(КассоваяСмена);
	Иначе
		ИспользуетсяККТФЗ54 = Ложь;
	КонецЕсли;
	
	ЗаполнитьТаблицуТоваров();
	
	Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КассаККМ, "Склад");
	
	Элементы.Период.Видимость                  = ИспользуетсяККТФЗ54;
	Элементы.ТаблицаТоваровПомещение.Видимость = СкладыСервер.ИспользоватьСкладскиеПомещения(Склад, ТекущаяДатаСеанса());
	
	ИспользоватьНаборы                     = ПолучитьФункциональнуюОпцию("ИспользоватьНаборы");
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	Элементы.ТаблицаТоваровНоменклатураНабора.Видимость   = ИспользоватьНаборы;
	Элементы.ТаблицаТоваровХарактеристикаНабора.Видимость = ИспользоватьНаборы И ИспользоватьХарактеристикиНоменклатуры;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьВозврат(Команда)
	
	Если ПодобраноПозиций = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЧекККМ = Неопределено;
	Для Каждого СтрокаТЧ Из ТаблицаТоваров Цикл
		Если СтрокаТЧ.Выбран Тогда
			ЧекККМ = СтрокаТЧ.ЧекККМ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Товары", АдресВоВременномХранилище(ВладелецФормы.УникальныйИдентификатор));
	ПараметрыОткрытия.Вставить("ЧекККМ", ЧекККМ);
	
	ОткрытьФорму("Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК", Новый Структура("Основание", ПараметрыОткрытия), ВладелецФормы);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаТоваровВыбранПриИзменении(Элемент)
	
	ТаблицаТоваровВыбранПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция АдресВоВременномХранилище(УникальныйИдентификатор)
	
	Товары = ТаблицаТоваров.Выгрузить(Новый Структура("Выбран", Истина));
	
	Возврат ПоместитьВоВременноеХранилище(Товары, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	ТаблицаТоваров.Очистить();

	ТекстУсловияИспользуетсяККТФЗ54        = "И Т.Дата >= &ДатаНачала И (Т.Дата <= &ДатаОкончания ИЛИ &БезОграниченияОкончанияПериода)";
	ТекстУсловияИспользуетсяККТФЗ54Возврат = "И Т.Дата >= &ДатаНачала";
	ТекстУсловияНеИспользуетсяККТФЗ54      = "И Т.КассоваяСмена = &КассоваяСмена";
	ТекстУсловияНомерЧека                  = "И ФискальныеОперации.НомерЧекаККМ = &НомерЧекаККМ";
	ТекстУсловияКартаЛояльности            = "И Т.КартаЛояльности = &КартаЛояльности";
	
	Если ИспользуетсяККТФЗ54 Тогда
		ТекстУсловияНоменклатура =
		"И Т.Ссылка В (
		|	ВЫБРАТЬ Т.Ссылка
		|ИЗ
		|	Документ.ЧекККМ.Товары КАК Т
		|ГДЕ
		|	Т.Ссылка.Дата >= &ДатаНачала И Т.Номенклатура = &Номенклатура И (Т.Ссылка.Дата <= &ДатаОкончания ИЛИ &БезОграниченияОкончанияПериода))
		|";
	Иначе
		ТекстУсловияНоменклатура =
		"И Т.Ссылка В (
		|	ВЫБРАТЬ Т.Ссылка
		|ИЗ
		|	Документ.ЧекККМ.Товары КАК Т
		|ГДЕ
		|	Т.Ссылка.КассоваяСмена = &КассоваяСмена И Т.Номенклатура = &Номенклатура)
		|";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ЧекиККМ
	|ИЗ
	|	Документ.ЧекККМ КАК Т
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФискальныеОперации КАК ФискальныеОперации
	|		ПО Т.Ссылка = ФискальныеОперации.ДокументОснование
	|	
	|ГДЕ
	|	Т.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|	" + ?(ИспользуетсяККТФЗ54,                ТекстУсловияИспользуетсяККТФЗ54, ТекстУсловияНеИспользуетсяККТФЗ54) + "
	|	" + ?(ЗначениеЗаполнено(НомерЧекаККМ),    ТекстУсловияНомерЧека,           "")                                + "
	|	" + ?(ЗначениеЗаполнено(КартаЛояльности), ТекстУсловияКартаЛояльности,     "")                                + "
	|	" + ?(ЗначениеЗаполнено(Номенклатура),    ТекстУсловияНоменклатура,        "")                                + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЧекККМВозврат КАК Т
	|ГДЕ
	|	Т.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|	" + ?(ИспользуетсяККТФЗ54, ТекстУсловияИспользуетсяККТФЗ54Возврат, ТекстУсловияНеИспользуетсяККТФЗ54) + "
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОплатаПлатежнымиКартами.Ссылка,
	|	ИСТИНА КАК ОплаченКартой
	|ПОМЕСТИТЬ ЧекиККМОплаченныеКартами
	|ИЗ
	|	Документ.ЧекККМ.ОплатаПлатежнымиКартами КАК ОплатаПлатежнымиКартами
	|ГДЕ
	|	ОплатаПлатежнымиКартами.Ссылка В (Выбрать Т.Ссылка ИЗ ЧекиККМ КАК Т)
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка                       КАК ЧекККМ,
	|	Товары.НоменклатураЕГАИС            КАК НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора           КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора         КАК ХарактеристикаНабора,
	|	Товары.Номенклатура                 КАК Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Товары.Характеристика               КАК Характеристика,
	|	Товары.Упаковка           КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество         КАК Количество,
	|	
	|	ВЫРАЗИТЬ(ВЫБОР
	|		КОГДА
	|			Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки + Товары.СуммаБонусныхБалловКСписаниюВВалюте = 0
	|			ИЛИ Товары.КоличествоУпаковок = 0
	|		ТОГДА
	|			Товары.Цена
	|		ИНАЧЕ
	|			Товары.Сумма / Товары.КоличествоУпаковок
	|	КОНЕЦ КАК Число(15,2)) КАК Цена,
	|	
	|	Товары.Сумма                    КАК Сумма,
	|	Товары.СтавкаНДС                КАК СтавкаНДС,
	|	Товары.СуммаНДС                 КАК СуммаНДС,
	|	Товары.Помещение                КАК Помещение,
	|	Товары.Продавец                 КАК Продавец
	|ПОМЕСТИТЬ врТовары
	|ИЗ
	|	Документ.ЧекККМ.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В (Выбрать Т.Ссылка ИЗ ЧекиККМ КАК Т)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Товары.Ссылка.ЧекККМ                КАК ЧекККМ,
	|	Товары.НоменклатураЕГАИС            КАК НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора           КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора         КАК ХарактеристикаНабора,
	|	Товары.Номенклатура                 КАК Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Товары.Характеристика               КАК Характеристика,
	|	Товары.Упаковка                     КАК Упаковка,
	|	-Товары.КоличествоУпаковок          КАК КоличествоУпаковок,
	|	-Товары.Количество                  КАК Количество,
	|	Товары.Цена                      КАК Цена,
	|	-Товары.Сумма                    КАК Сумма,
	|	Товары.СтавкаНДС                 КАК СтавкаНДС,
	|	-Товары.СуммаНДС                 КАК СуммаНДС,
	|	Товары.Помещение                КАК Помещение,
	|	Товары.Продавец                 КАК Продавец
	|ИЗ
	|	Документ.ЧекККМВозврат.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В (Выбрать Т.Ссылка ИЗ ЧекиККМ КАК Т)
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.ЧекККМ                       КАК ЧекККМ,
	|	Товары.НоменклатураЕГАИС            КАК НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора           КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора         КАК ХарактеристикаНабора,
	|	Товары.Номенклатура                 КАК Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Товары.Характеристика               КАК Характеристика,
	|	Товары.Упаковка                     КАК Упаковка,
	|	Товары.СтавкаНДС                    КАК СтавкаНДС,
	|	Товары.Цена                         КАК Цена,
	|	Товары.Помещение                    КАК Помещение,
	|	Товары.Продавец                     КАК Продавец,
	|	СУММА(Товары.КоличествоУпаковок)       КАК КоличествоУпаковок,
	|	СУММА(Товары.Количество)               КАК Количество,
	|	СУММА(Товары.Сумма)                    КАК Сумма,
	|	СУММА(Товары.СуммаНДС)                 КАК СуммаНДС
	|ПОМЕСТИТЬ Результат
	|ИЗ
	|	врТовары КАК Товары
	|СГРУППИРОВАТЬ ПО
	|	Товары.ЧекККМ,
	|	Товары.НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора,
	|	Товары.ХарактеристикаНабора,
	|	Товары.Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Помещение,
	|	Товары.Продавец,
	|	Товары.СтавкаНДС,
	|	Товары.Цена
	|ИМЕЮЩИЕ
	|	СУММА(Товары.Количество) > 0
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.ЧекККМ                                          КАК ЧекККМ,
	|	ФискальныеОперации.НомерЧекаККМ КАК НомерЧекаККМ,
	|	Таблица.ЧекККМ.КартаЛояльности                          КАК КартаЛояльности,
	|	Таблица.ЧекККМ.Партнер                                  КАК Клиент,
	|	ЕСТЬNULL(ЧекиККМОплаченныеКартами.ОплаченКартой, ЛОЖЬ) КАК ОплаченКартой,
	|	ВЫБОР КОГДА Таблица.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) ТОГДА 1 ИНАЧЕ 0 КОНЕЦ КАК ИндексНабора,
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора,
	|	Таблица.НоменклатураЕГАИС             КАК НоменклатураЕГАИС,
	|	Таблица.НоменклатураНабора           КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора         КАК ХарактеристикаНабора,
	|	Таблица.Номенклатура                 КАК Номенклатура,
	|	Таблица.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Таблица.Характеристика               КАК Характеристика,
	|	Таблица.Упаковка                     КАК Упаковка,
	|	Таблица.СтавкаНДС                    КАК СтавкаНДС,
	|	Таблица.Цена                         КАК Цена,
	|	Таблица.КоличествоУпаковок           КАК КоличествоУпаковок,
	|	Таблица.Количество                   КАК Количество,
	|	Таблица.Сумма                        КАК Сумма,
	|	Таблица.СуммаНДС                     КАК СуммаНДС,
	|	Таблица.Помещение                    КАК Помещение,
	|	Таблица.Продавец                     КАК Продавец
	|ИЗ
	|	Результат КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФискальныеОперации КАК ФискальныеОперации
	|		ПО Таблица.ЧекККМ = ФискальныеОперации.ДокументОснование
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЧекиККМОплаченныеКартами ПО Таблица.ЧекККМ = ЧекиККМОплаченныеКартами.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|			ПО ВариантыКомплектацииНоменклатуры.Владелец = Таблица.НоменклатураНабора
	|			И ВариантыКомплектацииНоменклатуры.Характеристика = Таблица.ХарактеристикаНабора
	|			И ВариантыКомплектацииНоменклатуры.Основной
	|УПОРЯДОЧИТЬ ПО
	|	Таблица.ЧекККМ.Дата УБЫВ
	|";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.Параметры.Вставить("КассоваяСмена", КассоваяСмена);
	
	Если ЗначениеЗаполнено(НомерЧекаККМ) Тогда
		Запрос.Параметры.Вставить("НомерЧекаККМ", НомерЧекаККМ);
	КонецЕсли;
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Запрос.Параметры.Вставить("Номенклатура", Номенклатура);
	КонецЕсли;
	Если ЗначениеЗаполнено(КартаЛояльности) Тогда
		Запрос.Параметры.Вставить("КартаЛояльности", КартаЛояльности);
	КонецЕсли;
	Если ИспользуетсяККТФЗ54 Тогда
		Запрос.Параметры.Вставить("ДатаНачала",     Период.ДатаНачала);
		Запрос.Параметры.Вставить("ДатаОкончания",  Период.ДатаОкончания);
		Запрос.Параметры.Вставить("БезОграниченияОкончанияПериода", НЕ ЗначениеЗаполнено(Период.ДатаОкончания));
	КонецЕсли;
	
	ПодобраноПозиций = 0;
	Всего = 0;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТЧ = ТаблицаТоваров.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, Выборка);
		
		Если ЗначениеЗаполнено(Номенклатура) Тогда
			Если Номенклатура = СтрокаТЧ.Номенклатура ИЛИ СтрокаТЧ.ОплаченКартой Тогда
				СтрокаТЧ.Выбран = Истина;
				ПодобраноПозиций = ПодобраноПозиций + 1;
				Всего = Всего + СтрокаТЧ.Сумма;
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(НомерЧекаККМ) ИЛИ ЗначениеЗаполнено(КартаЛояльности) Тогда
			СтрокаТЧ.Выбран = Истина;
			ПодобраноПозиций = ПодобраноПозиций + 1;
			Всего = Всего + СтрокаТЧ.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиТовары(Команда)
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьНаСервере()
	
	ПодобраноПозиций = 0;
	Всего            = 0;
	
	Для Каждого СтрокаТЧ Из ТаблицаТоваров Цикл
		
		Если НЕ СтрокаТЧ.Выбран Тогда
			Продолжить;
		КонецЕсли;
		
		ПодобраноПозиций = ПодобраноПозиций + 1;
		Всего = Всего + СтрокаТЧ.Сумма;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ТаблицаТоваровВыбранПриИзмененииНаСервере()
	
	ТекущиеДанные = ТаблицаТоваров.НайтиПоИдентификатору(Элементы.ТаблицаТоваров.ТекущаяСтрока);
	
	НоменклатураНабора   = ТекущиеДанные.НоменклатураНабора;
	ХарактеристикаНабора = ТекущиеДанные.ХарактеристикаНабора;
	
	ЧекККМ        = ТекущиеДанные.ЧекККМ;
	ОплаченКартой = ТекущиеДанные.ОплаченКартой;
	ЦенаЗадаетсяЗаНабор = ТекущиеДанные.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
	                  ИЛИ ТекущиеДанные.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам;
	
	Для Каждого СтрокаТЧ Из ТаблицаТоваров Цикл
		Если СтрокаТЧ.ЧекККМ = ЧекККМ
			И (ОплаченКартой
				ИЛИ (СтрокаТЧ.НоменклатураНабора = НоменклатураНабора
				И СтрокаТЧ.ХарактеристикаНабора = ХарактеристикаНабора)) Тогда
			СтрокаТЧ.Выбран = ТекущиеДанные.Выбран;
		КонецЕсли;
		Если НЕ СтрокаТЧ.ЧекККМ = ЧекККМ Тогда
			СтрокаТЧ.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	ПересчитатьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
