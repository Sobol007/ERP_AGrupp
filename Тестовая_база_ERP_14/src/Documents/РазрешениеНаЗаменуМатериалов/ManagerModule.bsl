#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Разрешение на замену материалов".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.РазрешениеНаЗаменуМатериалов) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РазрешениеНаЗаменуМатериалов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.РазрешениеНаЗаменуМатериалов);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьПроизводство";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаАналогиВПроизводстве(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	РазрешениеНаЗаменуМатериалов.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	РазрешениеНаЗаменуМатериалов.Спецификация КАК Спецификация,
	|	РазрешениеНаЗаменуМатериалов.Изделие КАК Изделие,
	|	РазрешениеНаЗаменуМатериалов.ХарактеристикаИзделия КАК ХарактеристикаИзделия,
	|	РазрешениеНаЗаменуМатериалов.ЗаказКлиента КАК ЗаказКлиента,
	|	РазрешениеНаЗаменуМатериалов.ДатаНачалаДействия КАК ДатаНачалаДействия,
	|	РазрешениеНаЗаменуМатериалов.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	РазрешениеНаЗаменуМатериалов.Статус КАК Статус,
	|	РазрешениеНаЗаменуМатериалов.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов КАК РазрешениеНаЗаменуМатериалов
	|ГДЕ
	|	РазрешениеНаЗаменуМатериалов.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Статус",                    Реквизиты.Статус);
	Запрос.УстановитьПараметр("ЗаказНаПроизводство",       Реквизиты.ЗаказНаПроизводство);
	Запрос.УстановитьПараметр("Спецификация",              Реквизиты.Спецификация);
	Запрос.УстановитьПараметр("Изделие",                   Реквизиты.Изделие);
	Запрос.УстановитьПараметр("ХарактеристикаИзделия",     Реквизиты.ХарактеристикаИзделия);
	Запрос.УстановитьПараметр("ЗаказКлиента",              Реквизиты.ЗаказКлиента);
	Запрос.УстановитьПараметр("ДатаНачалаДействия",        Реквизиты.ДатаНачалаДействия);
	Запрос.УстановитьПараметр("ДатаОкончанияДействия",     Реквизиты.ДатаОкончанияДействия);
	Запрос.УстановитьПараметр("Подразделение",             Реквизиты.Подразделение);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаАналогиВПроизводстве(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "АналогиВПроизводстве";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	&Спецификация КАК Спецификация,
	|	&Изделие КАК Изделие,
	|	&ХарактеристикаИзделия КАК ХарактеристикаИзделия,
	|	&ЗаказКлиента КАК ЗаказКлиента,
	|	&ДатаНачалаДействия КАК Период,
	|	&ДатаОкончанияДействия КАК ПериодЗавершения,
	|	&Подразделение КАК Подразделение,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Номенклатура КАК Материал,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Характеристика КАК ХарактеристикаМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Количество КАК КоличествоМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.КоличествоУпаковок КАК КоличествоУпаковокМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Упаковка КАК УпаковкаМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.КлючСвязиСпецификация КАК КлючСвязиСпецификация,
	|	РазрешениеНаЗаменуМатериаловАналоги.Номенклатура КАК Аналог,
	|	РазрешениеНаЗаменуМатериаловАналоги.Характеристика КАК ХарактеристикаАналога,
	|	РазрешениеНаЗаменуМатериаловАналоги.Количество КАК КоличествоАналога,
	|	РазрешениеНаЗаменуМатериаловАналоги.КоличествоУпаковок КАК КоличествоУпаковокАналога,
	|	РазрешениеНаЗаменуМатериаловАналоги.Упаковка КАК УпаковкаАналога
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов.Материалы КАК РазрешениеНаЗаменуМатериаловМатериалы,
	|	Документ.РазрешениеНаЗаменуМатериалов.Аналоги КАК РазрешениеНаЗаменуМатериаловАналоги
	|ГДЕ
	|	РазрешениеНаЗаменуМатериаловАналоги.Ссылка = &Ссылка
	|	И РазрешениеНаЗаменуМатериаловМатериалы.Ссылка = &Ссылка
	|	И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРазрешенийНаЗаменуМатериалов.Утверждено)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ТекстЗапросаДинамическогоСпискаРазрешенийНаЗаменуМатериалов() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОсновнаяТаблица.Ссылка КАК Ссылка,
	|	ОсновнаяТаблица.ВерсияДанных КАК ВерсияДанных,
	|	ОсновнаяТаблица.ПометкаУдаления КАК ПометкаУдаления,
	|	ОсновнаяТаблица.Номер КАК Номер,
	|	ОсновнаяТаблица.Дата КАК Дата,
	|	ОсновнаяТаблица.Проведен КАК Проведен,
	|	ОсновнаяТаблица.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ОсновнаяТаблица.Спецификация КАК Спецификация,
	|	ОсновнаяТаблица.Изделие КАК Изделие,
	|	ОсновнаяТаблица.ХарактеристикаИзделия КАК ХарактеристикаИзделия,
	|	ОсновнаяТаблица.ЗаказКлиента КАК ЗаказКлиента,
	|	ОсновнаяТаблица.ДатаНачалаДействия КАК ДатаНачалаДействия,
	|	ОсновнаяТаблица.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	ОсновнаяТаблица.Статус КАК Статус,
	|	ОсновнаяТаблица.УказаниеПоПрименению КАК УказаниеПоПрименению,
	|	ОсновнаяТаблица.Ответственный КАК Ответственный,
	|	ОсновнаяТаблица.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов КАК ОсновнаяТаблица
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура УстановитьОтборПоНоменклатуреВДинамическомСпискеРазрешенийНаЗаменуМатериалов(Список, Номенклатура, Назначение = Неопределено) Экспорт
	
	ОтборПоНоменклатуре = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,
		НСтр("ru = 'Отбор по номенклатуре';
			|en = 'Filter by products'"),
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ОтборПоНоменклатуре,
		"Ссылка.Изделие",
		ВидСравненияКомпоновкиДанных.Равно,
		Номенклатура,
		,
		ЗначениеЗаполнено(Номенклатура) И (НЕ ЗначениеЗаполнено(Назначение) ИЛИ Назначение = Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Изделие));
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ОтборПоНоменклатуре,
		"Ссылка.Материалы.Номенклатура",
		ВидСравненияКомпоновкиДанных.Равно,
		Номенклатура,
		,
		ЗначениеЗаполнено(Номенклатура) И (НЕ ЗначениеЗаполнено(Назначение) ИЛИ Назначение = Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Материал));
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ОтборПоНоменклатуре,
		"Ссылка.Аналоги.Номенклатура",
		ВидСравненияКомпоновкиДанных.Равно,
		Номенклатура,
		,
		ЗначениеЗаполнено(Номенклатура) И (НЕ ЗначениеЗаполнено(Назначение) ИЛИ Назначение = Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Аналог));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли