
#Область ПрограммныйИнтерфейс

// Получить адреса схемы компоновки данных во временном хранилище
//
// Параметры:
//  Форма - УправляемаяФорма - Форма
//  Имя - Строка - Имя схемы.
// 
// Возвращаемое значение:
//  Структура - адреса схемы компоновки данных во временном хранилище.
//
Функция ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище(Форма, Имя) Экспорт
	
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.СкидкиНаценки") Тогда
		Если Имя = "КомпоновщикНастроекОтборПоНоменклатуре" Тогда
			ИмяМакета = "ОтборСтрокНоменклатура";
		Иначе
			Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
				ИмяМакета = "ОтборСтрокДополнительныеУсловия";
			Иначе
				ИмяМакета = "ОтборСтрокДополнительныеУсловияБезХарактеристик";
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("СправочникСсылка.УсловияПредоставленияСкидокНаценок") Тогда
		ИмяМакета = "ОтборУсловияПредоставленияСуммаКоличество";
	КонецЕсли;
	
	Адреса = Новый Структура;
	
	Макет = Справочники.СкидкиНаценки.ПолучитьМакет(ИмяМакета);
	Набор = Макет.НаборыДанных.Найти("НаборДанных");
	Поля = "СвободныеОстаткиОстатки.Номенклатура,СвободныеОстаткиОстатки.Характеристика,СвободныеОстаткиОстатки.Склад";
	Набор.Запрос = РегистрыСведений.ТоварныеОграничения.ПодставитьСоединение(Набор.Запрос, "ПодстановкаТоварногоОграничения", Поля);
	
	Адреса.Вставить("СхемаКомпоновкиДанных", ПоместитьВоВременноеХранилище(Макет, Форма.УникальныйИдентификатор));
	Адреса.Вставить("НастройкиКомпоновкиДанных",
		ПоместитьВоВременноеХранилище(
			Форма[Имя].ПолучитьНастройки(), Форма.УникальныйИдентификатор));
	
	Возврат Адреса;
	
КонецФункции

// Описание действия внешней обработки
//
// Параметры:
//  ВнешняяОбработка - ВнешняяОбработкаОбъект - Объект подключенной обработки.
//  АдресНастроекВнешнейОбработки - Строка - Адрес настроек во временном хранилище.
// 
// Возвращаемое значение:
//  Строка - Описание действия внешней обработки.
//
Функция ОписаниеДействияВнешнейОбработки(ВнешняяОбработка, АдресНастроекВнешнейОбработки) Экспорт
	
	ВнешнийОбъект = СкидкиНаценкиПовтИсп.ОбъектВнешнейОбработки(ВнешняяОбработка);
	
	Если ЗначениеЗаполнено(АдресНастроекВнешнейОбработки) Тогда
		Параметры = ПолучитьИзВременногоХранилища(АдресНастроекВнешнейОбработки);
	Иначе
		Параметры = Неопределено;
	КонецЕсли;
	
	УстановитьБезопасныйРежим(Истина);
	Описание = ВнешнийОбъект.ОписаниеДействия(Параметры);
	УстановитьБезопасныйРежим(Ложь);
	
	Возврат Описание;
	
КонецФункции

// Автонаименование внешней обработки
//
// Параметры:
//  ВнешняяОбработка - ВнешняяОбработкаОбъект - Объект подключенной обработки.
//  АдресНастроекВнешнейОбработки - Строка - Адрес настроек во временном хранилище.
// 
// Возвращаемое значение:
//  Строка - Наименование
//
Функция АвтонаименованиеВнешнейОбработки(ВнешняяОбработка, АдресНастроекВнешнейОбработки) Экспорт
	
	ВнешнийОбъект = СкидкиНаценкиПовтИсп.ОбъектВнешнейОбработки(ВнешняяОбработка);
	
	Если ЗначениеЗаполнено(АдресНастроекВнешнейОбработки) Тогда
		Параметры = ПолучитьИзВременногоХранилища(АдресНастроекВнешнейОбработки);
	Иначе
		Параметры = Неопределено;
	КонецЕсли;
	
	УстановитьБезопасныйРежим(Истина);
	Автонаименование = ВнешнийОбъект.Автонаименование(Параметры);
	УстановитьБезопасныйРежим(Ложь);
	
	Возврат Автонаименование;
	
КонецФункции

// Имя формы настроек внешней обработки
//
// Параметры:
//  ВнешняяОбработка - ВнешняяОбработкаОбъект - Объект подключенной обработки.
//  АдресНастроекВнешнейОбработки - Строка - Адрес настроек во временном хранилище.
// 
// Возвращаемое значение:
//  Строка - Имя формы настроек внешней обработки.
//
Функция ИмяФормыНастроекВнешнейОбработки(ВнешняяОбработка, АдресНастроекВнешнейОбработки) Экспорт
	
	ИмяОбработки = СкидкиНаценкиПовтИсп.ПодключитьВнешнююОбработку(ВнешняяОбработка);
	ВнешнийОбъект = СкидкиНаценкиПовтИсп.ОбъектВнешнейОбработки(ВнешняяОбработка);
	
	УстановитьБезопасныйРежим(Истина);
	Попытка
		ИмяФормыНастроек = ВнешнийОбъект.ИмяФормыНастроек();
		Если ТипЗнч(ИмяФормыНастроек) <> Тип("Строка") Тогда
			ИмяФормыНастроек = "";
		КонецЕсли;
	Исключение
		ИмяФормыНастроек = "";
	КонецПопытки;
	УстановитьБезопасныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(ИмяФормыНастроек) Тогда
		Возврат "ВнешняяОбработка."+ ИмяОбработки +".Форма."+ИмяФормыНастроек;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Описание внешней обработки
//
// Параметры:
//  ВнешняяОбработка - ВнешняяОбработкаОбъект - Объект подключенной обработки.
//  АдресНастроекВнешнейОбработки - Строка - Адрес настроек во временном хранилище.
// 
// Возвращаемое значение:
//  Структура - Описание внешней обработки.
//
Функция ОписаниеВнешнейОбработки(ВнешняяОбработка, АдресНастроекВнешнейОбработки) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ИмяФормыНастроек", ИмяФормыНастроекВнешнейОбработки(ВнешняяОбработка, АдресНастроекВнешнейОбработки));
	ВозвращаемоеЗначение.Вставить("Автонаименование", АвтонаименованиеВнешнейОбработки(ВнешняяОбработка, АдресНастроекВнешнейОбработки));
	ВозвращаемоеЗначение.Вставить("ОписаниеДействия", ОписаниеДействияВнешнейОбработки(ВнешняяОбработка, АдресНастроекВнешнейОбработки));
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Данные для представления списка товаров
//
// Параметры:
//  Ссылка - СправочникСсылка.СкидкиНаценки - Скидка (наценка).
// 
// Возвращаемое значение:
//  Структура - Данные для представления списка товаров.
//
Функция ДанныеДляПредставленияСпискаТоваров(Ссылка) Экспорт

	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 3
	|	Т.Номенклатура.Представление КАК НоменклатураНаименование,
	|	Т.Характеристика.Представление КАК ХарактеристикаНаименование
	|ИЗ
	|	РегистрСведений.ДействиеСкидокНаценокПоНоменклатуре.СрезПоследних(&ТекущаяДата, Источник = &Источник) КАК Т
	|ГДЕ
	|	Т.Статус = &Статус
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(1) КАК КоличествоПозиций
	|ИЗ
	|	РегистрСведений.ДействиеСкидокНаценокПоНоменклатуре.СрезПоследних(&ТекущаяДата, Источник = &Источник) КАК Т
	|ГДЕ
	|	Т.Статус = &Статус
	|");
	Запрос.Параметры.Вставить("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.Параметры.Вставить("Источник", Ссылка);
	Запрос.Параметры.Вставить("Статус", Перечисления.СтатусыДействияСкидок.Действует);
	
	ПервыеПозиции = Новый Массив;
	
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Пока Выборка.Следующий() Цикл
		Наименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				Выборка.НоменклатураНаименование,
				Выборка.ХарактеристикаНаименование);
		ПервыеПозиции.Добавить(Наименование);
	КонецЦикла;
	
	Выборка = Запрос.ВыполнитьПакет()[1].Выбрать();
	Выборка.Следующий();
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ПервыеПозиции", ПервыеПозиции);
	ВозвращаемоеЗначение.Вставить("ВсегоПозиций", Выборка.КоличествоПозиций);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Функция проверяет необходимость расчета скидок объекта
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - проверяемый объект
//  УправляемыеСкидки - СписокЗначений - список управляемых скидок
//  ИдентификаторФормы - УникальныйИдентификатор - уникальный идентификатор формы
//  РассчитанныеСкидкиАдресВХранилище - Строка - адрес хранилища, куда будут помещены рассчитанные скидки/наценки.
//
Функция НеобходимПерерасчетСкидок(Объект, УправляемыеСкидки, ИдентификаторФормы, РассчитанныеСкидкиАдресВХранилище) Экспорт
	
	СкидкиИзменились = Ложь;
	
	ПараметрыРасчета = Новый Структура;
	ПараметрыРасчета.Вставить("ПрименятьКОбъекту",                Ложь);
	ПараметрыРасчета.Вставить("ТолькоПредварительныйРасчет",      Ложь);
	ПараметрыРасчета.Вставить("ВосстанавливатьУправляемыеСкидки", Истина);
	ПараметрыРасчета.Вставить("УправляемыеСкидки",                УправляемыеСкидки);
	РассчитанныеСкидки = СкидкиНаценкиСервер.Рассчитать(Объект, ПараметрыРасчета);
	
	КоличествоСтрокАктуальныхСкидок = РассчитанныеСкидки.ТаблицаСкидкиНаценки.Количество();
	Если КоличествоСтрокАктуальныхСкидок <> Объект.СкидкиНаценки.Количество() Тогда 
		СкидкиИзменились = Истина;
	Иначе
		
		Для НомерСтроки = 1 По КоличествоСтрокАктуальныхСкидок Цикл
			СтрокаТекущиеСкидки      = Объект.СкидкиНаценки[НомерСтроки-1];
			СтрокаРассчитанныеСкидки = РассчитанныеСкидки.ТаблицаСкидкиНаценки[НомерСтроки-1];
			
			Если    СтрокаТекущиеСкидки.Сумма          <> СтрокаРассчитанныеСкидки.Сумма
				ИЛИ СтрокаТекущиеСкидки.КлючСвязи      <> СтрокаРассчитанныеСкидки.КлючСвязи
				ИЛИ СтрокаТекущиеСкидки.СкидкаНаценка  <> СтрокаРассчитанныеСкидки.СкидкаНаценка
				ИЛИ СтрокаТекущиеСкидки.НапомнитьПозже <> СтрокаРассчитанныеСкидки.НапомнитьПозже Тогда
				СкидкиИзменились = Истина;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ИдентификаторФормы <> Неопределено Тогда
		РассчитанныеСкидкиАдресВХранилище = ПоместитьВоВременноеХранилище(РассчитанныеСкидки, ИдентификаторФормы);
	КонецЕсли;
	
	Возврат СкидкиИзменились;
	
КонецФункции

#КонецОбласти