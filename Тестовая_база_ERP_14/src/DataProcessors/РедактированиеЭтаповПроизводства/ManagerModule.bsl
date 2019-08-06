//++ НЕ УТКА

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Переносит изменения в этап.
//
// Параметры:
//  ЭтапОбъект			 - ДокументОбъект.ЭтапПроизводства2_2	 - данные этапа.
//  РедактированиеЭтапов - ДанныеФормыСтруктура					 - данные обработки РедактированиеЭтаповПроизводства.
// 
// Возвращаемое значение:
//  ДанныеФормыСтруктура - строка ТЧ "Этапы", к которой относится этап.
//
Функция ПеренестиИзмененияВЭтап(ЭтапОбъект, РедактированиеЭтапов) Экспорт

	СтруктураПоиска = Новый Структура("Распоряжение", ЭтапОбъект.Ссылка);
 	ДанныеЭтапа = РедактированиеЭтапов.Этапы.НайтиСтроки(СтруктураПоиска)[0];

	ЭтапОбъект.ПроизводствоОднойДатой = РедактированиеЭтапов.ПроизводствоОднойДатой;
	ЭтапОбъект.НеОтгружатьЧастями = РедактированиеЭтапов.НеОтгружатьЧастями;
	ЭтапОбъект.ЖелаемаяДатаОбеспечения = РедактированиеЭтапов.ЖелаемаяДатаОтгрузки;
	
	Если РедактированиеЭтапов.ПроизводствоОднойДатой Тогда
		ЭтапОбъект.ДатаПроизводства = РедактированиеЭтапов.ДатаПроизводства;
	КонецЕсли; 
	Если РедактированиеЭтапов.НеОтгружатьЧастями Тогда
		ЭтапОбъект.ДатаОтгрузки = РедактированиеЭтапов.ДатаОтгрузки;
	КонецЕсли;
	
	ЭтапОбъект.ВыходныеИзделия.Загрузить(РедактированиеЭтапов.ВыходныеИзделия.Выгрузить(СтруктураПоиска));
	ЭтапОбъект.ПобочныеИзделия.Загрузить(РедактированиеЭтапов.ПобочныеИзделия.Выгрузить(СтруктураПоиска));
	ЭтапОбъект.ОбеспечениеМатериаламиИРаботами.Загрузить(РедактированиеЭтапов.ОбеспечениеМатериаламиИРаботами.Выгрузить(СтруктураПоиска));
	
	Если ДанныеЭтапа.Статус <> ДанныеЭтапа.ТекущийСтатус Тогда
		ЭтапОбъект.Статус = ДанныеЭтапа.Статус;
		УправлениеПроизводством.ЗаполнитьРеквизитыЭтапаПриИзмененииСтатуса(ЭтапОбъект, ДанныеЭтапа.ТекущийСтатус);
	КонецЕсли;
	
	Возврат ДанныеЭтапа;
	
КонецФункции

// Добавляет в обработку данные указанных этапов.
//
// Параметры:
//  Объект		 - ДанныеФормыСтруктура	 - данные обработки РедактированиеЭтаповПроизводства.
//  СписокЭтапов - Массив - список этапов.
//
Процедура ДобавитьДанныеЭтапов(Объект, СписокЭтапов) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ВыходныеИзделия КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка В (&СписокЭтапов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабличнаяЧасть.Ссылка,
	|	ТабличнаяЧасть.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ПобочныеИзделия КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка В (&СписокЭтапов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабличнаяЧасть.Ссылка,
	|	ТабличнаяЧасть.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка В (&СписокЭтапов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабличнаяЧасть.Ссылка,
	|	ТабличнаяЧасть.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеквизитыЭтапов.Ссылка,
	|	РеквизитыЭтапов.ВерсияДанных,
	|	РеквизитыЭтапов.Дата,
	|	РеквизитыЭтапов.Статус,
	|	РеквизитыЭтапов.ПроизводствоНаСтороне,
	|	РеквизитыЭтапов.ЖелаемаяДатаОбеспечения,
	|	РеквизитыЭтапов.Подразделение,
	|	РеквизитыЭтапов.Распоряжение,
	|
	|	РеквизитыЭтапов.Назначение КАК Назначение,
	|	РеквизитыЭтапов.НазначениеМатериалы КАК НазначениеМатериалы,
	|	РеквизитыЭтапов.НазначениеПолуфабрикаты КАК НазначениеПолуфабрикаты,
	|
	|	РеквизитыЭтапов.РучноеРазмещениеВГрафике,
	|	РеквизитыЭтапов.ПроизводствоОднойДатой,
	|	РеквизитыЭтапов.ДатаПроизводства,
	|	РеквизитыЭтапов.НеОтгружатьЧастями,
	|	РеквизитыЭтапов.ДатаОтгрузки,
	|	РеквизитыЭтапов.ЗаказПереработчику,
	|	РеквизитыЭтапов.НомерСледующегоЭтапа,
	|	РеквизитыЭтапов.СпособРаспределенияЗатратНаВыходныеИзделия
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК РеквизитыЭтапов
	|ГДЕ
	|	РеквизитыЭтапов.Ссылка В (&СписокЭтапов)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокЭтапов", СписокЭтапов);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	// Этапы
	НовыеЭтапы = Новый Соответствие;
	ДобавленныеЭтапы = Новый Соответствие;
	Выборка = Результат[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеЭтапа = Объект.Этапы.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеЭтапа, Выборка);
		ДанныеЭтапа.ТекущийСтатус = ДанныеЭтапа.Статус;
		ДанныеЭтапа.ЭтоВыпускающийЭтап = УправлениеПроизводствомКлиентСервер.ЭтоВыпускающийЭтап(Выборка);
		ДанныеЭтапа.Распоряжение = Выборка.Ссылка;
		ДанныеЭтапа.Заказ = Выборка.Распоряжение;
		Если ДанныеЭтапа.ЭтоВыпускающийЭтап Тогда
			Объект.ЕстьВыпускающийЭтап = Истина;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Выборка.ЗаказПереработчику) Тогда
			НовыеЭтапы.Вставить(Выборка.Ссылка, Истина);
		КонецЕсли;
		
		Если ДанныеЭтапа.ДатаПроизводства = '000101010000' Тогда
			ДанныеЭтапа.ДатаПроизводства = Документы.ЭтапПроизводства2_2.ПлановаяДатаПоступления(ДанныеЭтапа.Распоряжение);
		КонецЕсли; 
		
		ДобавленныеЭтапы.Вставить(Выборка.Ссылка, ДанныеЭтапа);
		
	КонецЦикла;
	
	// ВыходныеИзделия
	Выборка = Результат[0].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеЭтапа = ДобавленныеЭтапы.Получить(Выборка.Ссылка);
		
		ДанныеСтроки = Объект.ВыходныеИзделия.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		ДанныеСтроки.Распоряжение = Выборка.Ссылка;
		
		Если НовыеЭтапы.Получить(Выборка.Ссылка) <> Неопределено Тогда
			ДанныеСтроки.КодСтроки = 0;
		КонецЕсли;
		
		Если ДанныеСтроки.ДатаПроизводства = '000101010000' Тогда
			ДанныеСтроки.ДатаПроизводства = ДанныеЭтапа.ДатаПроизводства;
		КонецЕсли;
		
		Объект.МаксимальныйКодСтрокиИзделия = Макс(ДанныеСтроки.КодСтроки, Объект.МаксимальныйКодСтрокиИзделия);
		
	КонецЦикла;
	
	// ПобочныеИзделия
	Выборка = Результат[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеЭтапа = ДобавленныеЭтапы.Получить(Выборка.Ссылка);
		
		ДанныеСтроки = Объект.ПобочныеИзделия.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		ДанныеСтроки.Распоряжение = Выборка.Ссылка;
		
		Если НовыеЭтапы.Получить(Выборка.Ссылка) <> Неопределено Тогда
			ДанныеСтроки.КодСтроки = 0;
		КонецЕсли; 
		Если ДанныеСтроки.ДатаПроизводства = '000101010000' Тогда
			ДанныеСтроки.ДатаПроизводства = ДанныеЭтапа.ДатаПроизводства;
		КонецЕсли; 
		
		Объект.МаксимальныйКодСтрокиИзделия = Макс(ДанныеСтроки.КодСтроки, Объект.МаксимальныйКодСтрокиИзделия);
		
	КонецЦикла;
	
	// ОбеспечениеМатериаламиИРаботами
	Выборка = Результат[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеЭтапа = ДобавленныеЭтапы.Получить(Выборка.Ссылка);
		
		ДанныеСтроки = Объект.ОбеспечениеМатериаламиИРаботами.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		
		ДанныеСтроки.Распоряжение = Выборка.Ссылка;
		
		Если НовыеЭтапы.Получить(Выборка.Ссылка) <> Неопределено Тогда
			ДанныеСтроки.КодСтроки = 0;
		КонецЕсли;
		
		Объект.МаксимальныйКодСтрокиОбеспечение = Макс(ДанныеСтроки.КодСтроки, Объект.МаксимальныйКодСтрокиОбеспечение);
		
	КонецЦикла;
	
КонецПроцедуры

#Область Серии

// Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	ИменаРеквизитов = "";
	
	Возврат ИменаРеквизитов;
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект	 - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура - Состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыУказанияСерий = Новый Структура;
	
	#Область ОбеспечениеМатериаламиИРаботами
	ПараметрыУказанияСерийТЧ = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТЧ.ПолноеИмяОбъекта = "Обработка.РедактированиеЭтаповПроизводства";
	ПараметрыУказанияСерийТЧ.ИмяТЧТовары      = "ОбеспечениеМатериаламиИРаботами";
	ПараметрыУказанияСерийТЧ.ИмяТЧСерии       = "ОбеспечениеМатериаламиИРаботами";
	
	ПараметрыУказанияСерийТЧ.УчитыватьСебестоимостьПоСериям = ПолучитьФункциональнуюОпцию("УчитыватьСебестоимостьПоСериямСклад", Новый Структура());
	ПараметрыУказанияСерийТЧ.ИспользоватьСерииНоменклатуры  = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатурыСклад", Новый Структура());
	
	ПараметрыУказанияСерийТЧ.ИменаПолейДополнительные.Добавить("Склад");
	
	ПараметрыУказанияСерийТЧ.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаКлиенту);
	
	ПараметрыУказанияСерийТЧ.ЭтоЗаказ = Истина;
	ПараметрыУказанияСерийТЧ.ПланированиеОтгрузки = Истина;
	ПараметрыУказанияСерийТЧ.РегистрироватьСерии = Ложь;
	
	ПараметрыУказанияСерий.Вставить("ОбеспечениеМатериаламиИРаботами", ПараметрыУказанияСерийТЧ);
	#КонецОбласти
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Если ПараметрыУказанияСерий.ИмяТЧТовары = "ОбеспечениеМатериаламиИРаботами" Тогда
		ТекстЗапроса = ТекстЗапросаЗаполненияСтатусовУказанияСерийОбеспечениеМатериаламиИРаботами();
	КонецЕсли;                                                        
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

// Возвращает параметры выбора спецификаций для изделий, указанных в документе.
//
// Параметры:
//   Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров выбора спецификаций.
//
// Возвращаемое значение:
//   Структура - Структура, переопределяющая умолчания, заданные в функции УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификаций().
//
Функция ПараметрыВыбораСпецификаций(Объект) Экспорт
	
	ПараметрыВыбораСпецификаций = Новый Структура;
	
	ПараметрыВыбораСпецификацийТЧ = УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификаций();
	
	ПараметрыВыбораСпецификацийТЧ.ДоступныеТипы.Добавить(Перечисления.ТипыПроизводственныхПроцессов.Сборка);
	ПараметрыВыбораСпецификацийТЧ.ДоступныеТипы.Добавить(Перечисления.ТипыПроизводственныхПроцессов.Ремонт);
	
	ПараметрыВыбораСпецификацийТЧ.ДоступныеСтатусы.Добавить(Перечисления.СтатусыСпецификаций.Действует);
	
	ПараметрыВыбораСпецификаций.Вставить("ОбеспечениеМатериаламиИРаботами", ПараметрыВыбораСпецификацийТЧ);
	
	Возврат ПараметрыВыбораСпецификаций;
	
КонецФункции

// Имена реквизитов, от значений которых зависят параметры выбора спецификаций
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровВыбораСпецификаций() Экспорт
	
	ИменаРеквизитов = "";
	Возврат ИменаРеквизитов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет вариант обеспечения в строках табличной части.
// Вызывается при выборе варианта обеспечения.
//
Функция ЗаполнитьВариантОбеспечения(Объект, Форма, Операция, ДанныеЗаполнения, ПараметрыРедактированияЭтапа = Неопределено, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	Если ПараметрыРедактированияЭтапа = Неопределено Тогда
		ПараметрыРедактированияЭтапа = Новый ФиксированнаяСтруктура(ПараметрыРедактированияЭтапа());
	КонецЕсли;

	Если ПараметрыУказанияСерий = Неопределено Тогда
		ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(Объект, Обработки.РедактированиеЭтаповПроизводства);
		ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(ПараметрыУказанияСерий);
	КонецЕсли;
	
	Результат = УправлениеПроизводством.ЗаполнитьВариантОбеспеченияЭтапа(
						Объект,
						Форма,
						Операция,
						ДанныеЗаполнения,
						ПараметрыРедактированияЭтапа,
						ПараметрыУказанияСерий);
	
	Возврат Результат;

КонецФункции

Функция ТекстЗапросаЗаполненияСтатусовУказанияСерийОбеспечениеМатериаламиИРаботами()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.Склад,
	|	Товары.Номенклатура,
	|	Товары.Серия,
	|	Товары.СтатусУказанияСерий,
	|	Товары.НомерСтроки,
	|	Товары.ВариантОбеспечения
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|				ИЛИ НЕ Товары.ВариантОбеспечения В (
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада),
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить),
	|						ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно))
	|			ТОГДА 0
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|			ТОГДА ВЫБОР
	|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|						ТОГДА 14
	|					КОГДА Товары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада)
	|						ТОГДА 15
	|					ИНАЧЕ 13
	|				КОНЕЦ
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
	|			ТОГДА ВЫБОР
	|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|						ТОГДА 10
	|					КОГДА Товары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада)
	|						ТОГДА 11
	|					ИНАЧЕ 9
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Статусы
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО (ПолитикиУчетаСерий.Склад = Товары.Склад)
	|			И (ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Статусы.НомерСтроки,
	|	Статусы.СтатусУказанияСерий
	|ИЗ
	|	Статусы КАК Статусы
	|ГДЕ
	|	Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статусы.НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПараметрыРедактированияЭтапа() Экспорт
	
	ПараметрыРедактированияЭтапа = УправлениеПроизводством.ПараметрыРедактированияЭтапа("Обработка");
	
	ПараметрыРедактированияЭтапа.ИмяРеквизитаОбъект = "РедактированиеЭтапов";
	ПараметрыРедактированияЭтапа.ИмяРеквизитаСсылка = "Распоряжение";
	
	ПараметрыРедактированияЭтапа.ИмяРеквизитаПараметрыУказанияСерий = "ПараметрыУказанияСерийРедактированиеЭтапов";
	
	ПараметрыРедактированияЭтапа.ЭтоЗаказПереработчику = Истина;
	
	Возврат ПараметрыРедактированияЭтапа;
	
КонецФункции

#КонецОбласти

#КонецЕсли

//-- НЕ УТКА
