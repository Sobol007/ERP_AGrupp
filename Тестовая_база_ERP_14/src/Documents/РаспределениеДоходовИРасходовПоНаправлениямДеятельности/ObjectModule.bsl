#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	РаспределениеДоходовИРасходовПоНаправлениямДеятельностиЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Доходы.Очистить();
	Расходы.Очистить();
	
	РаспределениеДоходовИРасходовПоНаправлениямДеятельностиЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если РаспределениеПоВсемОрганизациям Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Доходы.Организация");
		МассивНепроверяемыхРеквизитов.Добавить("Расходы.Организация");
	КонецЕсли;
	
	// Если есть строка, в которой не требуется способ распределения,
	// выполним специальную проверку заполнения способа распределения.
		
	МассивНепроверяемыхРеквизитов.Добавить("Доходы.СпособРаспределения");
	МассивНепроверяемыхРеквизитов.Добавить("Расходы.СпособРаспределения");
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат") Тогда
	
		Для Каждого СтрокаТаблицы Из Доходы Цикл
			
			ВыводитьСообщение = Ложь;
			Если СтрокаТаблицы.ТребуетсяСпособРаспределения
			   И Не ЗначениеЗаполнено(СтрокаТаблицы.СпособРаспределения) Тогда
				ВыводитьСообщение = Истина;
				
			ИначеЕсли Не СтрокаТаблицы.ТребуетсяСпособРаспределения
				И Не ЗначениеЗаполнено(СтрокаТаблицы.НаправлениеДеятельности)
				И Не ЗначениеЗаполнено(СтрокаТаблицы.АналитикаДоходов)
				И Не ЗначениеЗаполнено(СтрокаТаблицы.СпособРаспределения) Тогда
				ВыводитьСообщение = Истина;
				
			КонецЕсли;
			Если ВыводитьСообщение Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Способ распределения"" в строке %1 списка ""Доходы"".';
						|en = 'The ""Allocation method"" column is not populated in line %1 of the ""Income"" list. '"),
					СтрокаТаблицы.НомерСтроки);
				Если НЕ ДополнительныеСвойства.Свойство("ВыводитьСообщенияВЖурналРегистрации") Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						Текст,
						ЭтотОбъект,
						"Доходы[" + (СтрокаТаблицы.НомерСтроки - 1) + "].СпособРаспределения",
						,
						Отказ);
				Иначе
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
				
		КонецЦикла;
		
		Для Каждого СтрокаТаблицы Из Расходы Цикл
			
			ВыводитьСообщение = Ложь;
			Если СтрокаТаблицы.ТребуетсяСпособРаспределения
			   И Не ЗначениеЗаполнено(СтрокаТаблицы.СпособРаспределения) Тогда
				ВыводитьСообщение = Истина;
				
			ИначеЕсли Не СтрокаТаблицы.ТребуетсяСпособРаспределения
				И Не ЗначениеЗаполнено(СтрокаТаблицы.НаправлениеДеятельности)
				И Не ЗначениеЗаполнено(СтрокаТаблицы.АналитикаРасходов)
				И Не ЗначениеЗаполнено(СтрокаТаблицы.СпособРаспределения) Тогда
				ВыводитьСообщение = Истина;
				
			КонецЕсли;
			Если ВыводитьСообщение Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Способ распределения"" в строке %1 списка ""Расходы"".';
						|en = 'The ""Allocation method"" column is not populated in line %1 of the ""Expenses"" list. '"),
					СтрокаТаблицы.НомерСтроки);
				Если НЕ ДополнительныеСвойства.Свойство("ВыводитьСообщенияВЖурналРегистрации") Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						Текст,
						ЭтотОбъект,
						"Расходы[" + (СтрокаТаблицы.НомерСтроки - 1) + "].СпособРаспределения",
						,
						Отказ);
				Иначе
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
				
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	РаспределениеДоходовИРасходовПоНаправлениямДеятельностиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РаспределениеПоВсемОрганизациям Тогда
		Если ЗначениеЗаполнено(Организация) Тогда
			Организация = Неопределено;
		КонецЕсли;
		ОбновитьПредставлениеОрганизации();
	Иначе
		Для Каждого СтрокаТаблицы Из Доходы Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Организация) Тогда
				СтрокаТаблицы.Организация = Организация;
			КонецЕсли;
		КонецЦикла;
		Для Каждого СтрокаТаблицы Из Расходы Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Организация) Тогда
				СтрокаТаблицы.Организация = Организация;
			КонецЕсли;
		КонецЦикла;
		ПредставлениеОрганизаций = Строка(Организация);
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из Доходы Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.АналитикаДоходов)
			И ТипЗнч(СтрокаТаблицы.АналитикаДоходов) = Тип("СправочникСсылка.НаправленияДеятельности") Тогда
			СтрокаТаблицы.СпособРаспределения = Справочники.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка();
		ИначеЕсли ЗначениеЗаполнено(СтрокаТаблицы.НаправлениеДеятельности) Тогда
			СтрокаТаблицы.СпособРаспределения = Справочники.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из Расходы Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.АналитикаРасходов)
			И ТипЗнч(СтрокаТаблицы.АналитикаРасходов) = Тип("СправочникСсылка.НаправленияДеятельности") Тогда
			СтрокаТаблицы.СпособРаспределения = Справочники.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка();
		ИначеЕсли ЗначениеЗаполнено(СтрокаТаблицы.НаправлениеДеятельности) Тогда
			СтрокаТаблицы.СпособРаспределения = Справочники.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
	РаспределениеДоходовИРасходовПоНаправлениямДеятельностиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	ПодготовитьНаборыЗаписейКРегистрацииДвижений(Отказ);
	
	// Инициализация данных документа
	Документы.РаспределениеДоходовИРасходовПоНаправлениямДеятельности.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	Если ДополнительныеСвойства.Свойство("НетБазыРаспределения")
	 И ДополнительныеСвойства.НетБазыРаспределения Тогда
		Отказ = Истина;
	КонецЕсли;
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по прочим доходам и расходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьФинансовыеРезультаты(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДоходыРасходыПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	
	// Запись наборов записей
	РаспределениеДоходовИРасходовПоНаправлениямДеятельностиЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	РаспределениеДоходовИРасходовПоНаправлениямДеятельностиЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#Область ЗаполнениеДокумента

Процедура ЗаполнитьДоходыПоОстаткам() Экспорт

	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Доходы.Организация КАК Организация,
	|	Доходы.Подразделение КАК Подразделение,
	|	Доходы.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Доходы.СтатьяДоходов КАК СтатьяДоходов,
	|	Доходы.АналитикаДоходов КАК АналитикаДоходов,
	|	Доходы.СпособРаспределения КАК СпособРаспределения
	|
	|ПОМЕСТИТЬ Доходы
	|ИЗ
	|	&Доходы КАК Доходы
	|ГДЕ
	|	Доходы.СпособРаспределения <> ЗНАЧЕНИЕ(Справочник.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Доходы.Организация КАК Организация,
	|	Доходы.Подразделение КАК Подразделение,
	|	Доходы.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Доходы.СтатьяДоходов КАК СтатьяДоходов,
	|	Доходы.АналитикаДоходов КАК АналитикаДоходов,
	|	МАКСИМУМ(Доходы.СпособРаспределения) КАК СпособРаспределения
	|
	|ПОМЕСТИТЬ Аналитика
	|ИЗ
	|	Доходы КАК Доходы
	|
	|СГРУППИРОВАТЬ ПО
	|	Доходы.Организация,
	|	Доходы.Подразделение,
	|	Доходы.НаправлениеДеятельности,
	|	Доходы.СтатьяДоходов,
	|	Доходы.АналитикаДоходов
	|;
	|/////////////////////////////////////////////////////////////////////////////
	| ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрочиеДоходы.Организация КАК Организация,
	|	ПрочиеДоходы.Подразделение КАК Подразделение,
	|	ПрочиеДоходы.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ПрочиеДоходы.СтатьяДоходов КАК СтатьяДоходов,
	|	ПрочиеДоходы.АналитикаДоходов КАК АналитикаДоходов,
	|	ЕСТЬNULL(Аналитика.СпособРаспределения,
	|	(ВЫБОР
	|		КОГДА ПрочиеДоходы.СтатьяДоходов.СпособРаспределения
	|			<> ЗНАЧЕНИЕ(Справочник.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка)
	|		ТОГДА ПрочиеДоходы.СтатьяДоходов.СпособРаспределения
	|		ИНАЧЕ &СпособРаспределения КОНЕЦ)) КАК СпособРаспределения,
	|	ПрочиеДоходы.СуммаОстаток КАК Сумма,
	|	ПрочиеДоходы.СуммаУпрОстаток КАК СуммаУпр,
	|	ПрочиеДоходы.СуммаРеглОстаток КАК СуммаРегл,
	|
	|	ВЫБОР КОГДА ПрочиеДоходы.АналитикаДоходов ССЫЛКА Справочник.НаправленияДеятельности
	|	 ИЛИ ПрочиеДоходы.НаправлениеДеятельности <> ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|	 ИЛИ НЕ &ФормироватьФинансовыйРезультат ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК ТребуетсяСпособРаспределения
	|ИЗ
	|	РегистрНакопления.ПрочиеДоходы.Остатки(&Граница, 
	|		Организация = &Организация
	|		ИЛИ &ПоВсемОрганизациям
	|	) КАК ПрочиеДоходы
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Аналитика КАК Аналитика
	|	ПО
	|		ПрочиеДоходы.Организация = Аналитика.Организация
	|		И ПрочиеДоходы.Подразделение = Аналитика.Подразделение
	|		И ПрочиеДоходы.НаправлениеДеятельности = Аналитика.НаправлениеДеятельности
	|		И ПрочиеДоходы.СтатьяДоходов  = Аналитика.СтатьяДоходов
	|		И ПрочиеДоходы.АналитикаДоходов = Аналитика.АналитикаДоходов
	|ГДЕ
	|	ПрочиеДоходы.СуммаОстаток <> 0
	|	ИЛИ ПрочиеДоходы.СуммаУпрОстаток <> 0
	|	ИЛИ ПрочиеДоходы.СуммаРеглОстаток <> 0
	|");
	Граница = Новый Граница(КонецМесяца(Дата), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", РаспределениеПоВсемОрганизациям);
	Запрос.УстановитьПараметр("Доходы", Доходы.Выгрузить(,));
	Запрос.УстановитьПараметр("СпособРаспределения",
		Справочники.СпособыРаспределенияПоНаправлениямДеятельности.СпособРаспределенияПоУмолчанию(Неопределено));
	Запрос.УстановитьПараметр("ФормироватьФинансовыйРезультат",	ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат"));
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗапроса = РезультатЗапроса.Выгрузить();
	
	Доходы.Загрузить(ТаблицаЗапроса);

КонецПроцедуры

Процедура ЗаполнитьРасходыПоОстаткам() Экспорт

	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Расходы.Организация КАК Организация,
	|	Расходы.Подразделение КАК Подразделение,
	|	Расходы.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Расходы.СтатьяРасходов КАК СтатьяРасходов,
	|	Расходы.АналитикаРасходов КАК АналитикаРасходов,
	|	Расходы.СпособРаспределения КАК СпособРаспределения
	|
	|ПОМЕСТИТЬ Расходы
	|ИЗ
	|	&Расходы КАК Расходы
	|ГДЕ
	|	Расходы.СпособРаспределения <> ЗНАЧЕНИЕ(Справочник.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расходы.Организация КАК Организация,
	|	Расходы.Подразделение КАК Подразделение,
	|	Расходы.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Расходы.СтатьяРасходов КАК СтатьяРасходов,
	|	Расходы.АналитикаРасходов КАК АналитикаРасходов,
	|	МАКСИМУМ(Расходы.СпособРаспределения) КАК СпособРаспределения
	|
	|ПОМЕСТИТЬ Аналитика
	|ИЗ
	|	Расходы КАК Расходы
	|
	|СГРУППИРОВАТЬ ПО
	|	Расходы.Организация,
	|	Расходы.Подразделение,
	|	Расходы.НаправлениеДеятельности,
	|	Расходы.СтатьяРасходов,
	|	Расходы.АналитикаРасходов
	|;
	|/////////////////////////////////////////////////////////////////////////////
	| ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Остатки.Организация КАК Организация,
	|	Остатки.Подразделение КАК Подразделение,
	|	Остатки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Остатки.СтатьяРасходов КАК СтатьяРасходов,
	|	Остатки.АналитикаРасходов КАК АналитикаРасходов,
	|	ЕСТЬNULL(Аналитика.СпособРаспределения,
	|	(ВЫБОР
	|		КОГДА Статья.СпособРаспределенияПоНаправлениямДеятельности
	|			<> ЗНАЧЕНИЕ(Справочник.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка)
	|		ТОГДА Статья.СпособРаспределенияПоНаправлениямДеятельности
	|		ИНАЧЕ &СпособРаспределения КОНЕЦ)) КАК СпособРаспределения,
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовУпр
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ТОГДА Остатки.СуммаОстаток
	|		ИНАЧЕ 0 КОНЕЦ) КАК Сумма,
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовУпр
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ТОГДА Остатки.СуммаУпрОстаток
	|		ИНАЧЕ 0 КОНЕЦ) КАК СуммаУпр,
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ТОГДА Остатки.СуммаРеглОстаток
	|		ИНАЧЕ 0 КОНЕЦ) КАК СуммаРегл,
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ТОГДА Остатки.ПостояннаяРазницаОстаток
	|		ИНАЧЕ 0 КОНЕЦ) КАК ПостояннаяРазница,
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты)
	|		 И НЕ Статья.КосвенныеЗатратыНУ
	|			ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты)
	|		 И Статья.КосвенныеЗатратыНУ
	|		 И (Остатки.СуммаРеглОстаток - Остатки.ВременнаяРазницаОстаток - Остатки.ПостояннаяРазницаОстаток) = 0
	|			ТОГДА 0
	|		ИНАЧЕ Остатки.ВременнаяРазницаОстаток КОНЕЦ) КАК ВременнаяРазница,
	|
	|	ВЫБОР КОГДА Остатки.АналитикаРасходов ССЫЛКА Справочник.НаправленияДеятельности
	|	 ИЛИ Остатки.НаправлениеДеятельности <> ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|	 ИЛИ НЕ &ФормироватьФинансовыйРезультат ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК ТребуетсяСпособРаспределения
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы.Остатки(&Граница, 
	|		(Организация = &Организация
	|			ИЛИ &ПоВсемОрганизациям)
	|		И (СтатьяРасходов.ВариантРаспределенияРасходовУпр
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ИЛИ СтатьяРасходов.ВариантРаспределенияРасходовРегл В (
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности),
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты))
	|		)
	|	) КАК Остатки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК Статья
	|		ПО Статья.Ссылка = Остатки.СтатьяРасходов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Аналитика КАК Аналитика
	|	ПО
	|		Остатки.Организация = Аналитика.Организация
	|		И Остатки.Подразделение = Аналитика.Подразделение
	|		И Остатки.НаправлениеДеятельности = Аналитика.НаправлениеДеятельности
	|		И Остатки.СтатьяРасходов  = Аналитика.СтатьяРасходов
	|		И Остатки.АналитикаРасходов = Аналитика.АналитикаРасходов
	|ГДЕ
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовУпр
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ТОГДА Остатки.СуммаОстаток
	|		ИНАЧЕ 0 КОНЕЦ) <> 0
	|	ИЛИ (ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовУпр
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ТОГДА Остатки.СуммаУпрОстаток
	|		ИНАЧЕ 0 КОНЕЦ) <> 0
	|	ИЛИ (ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ТОГДА Остатки.СуммаРеглОстаток
	|		ИНАЧЕ 0 КОНЕЦ) <> 0
	|	ИЛИ (ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|			ТОГДА Остатки.ПостояннаяРазницаОстаток
	|		ИНАЧЕ 0 КОНЕЦ) <> 0
	|	ИЛИ (ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл
	|				= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты)
	|		 И НЕ Статья.КосвенныеЗатратыНУ
	|			ТОГДА 0
	|		ИНАЧЕ Остатки.ВременнаяРазницаОстаток КОНЕЦ) <> 0
	|");
	Граница = Новый Граница(КонецМесяца(Дата), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", РаспределениеПоВсемОрганизациям);
	Запрос.УстановитьПараметр("Расходы", Расходы.Выгрузить(,));
	Запрос.УстановитьПараметр("СпособРаспределения",
		Справочники.СпособыРаспределенияПоНаправлениямДеятельности.СпособРаспределенияПоУмолчанию(Неопределено));
	Запрос.УстановитьПараметр("ФормироватьФинансовыйРезультат",	ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат"));
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗапроса = РезультатЗапроса.Выгрузить();
	
	Расходы.Загрузить(ТаблицаЗапроса);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация", "");
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПодготовитьНаборыЗаписейКРегистрацииДвижений(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Если документ новый, то подготовки не требуется, наборы записей и так пусты
	ЭтоНовый = Ложь;
	Если ДополнительныеСвойства.Свойство("ЭтоНовый", ЭтоНовый) И ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	ИсключаемыеРегистры = Неопределено;
	РежимЗаписи         = Неопределено;
	ОтменаПроведения    = ДополнительныеСвойства.Свойство("РежимЗаписи", РежимЗаписи)
	                      И (РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения);
	
	// Если перепроводим документ, то проводки не очищаем.
	Если Не ОтменаПроведения Тогда
		ИсключаемыеРегистры = Новый Массив;
		ИсключаемыеРегистры.Добавить("Хозрасчетный");
	КонецЕсли;
	
	Для Каждого НаборЗаписей Из Движения Цикл
		
		// Очищаем наборы записей
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Очистить();
		КонецЕсли;
		
	КонецЦикла;
	
	// Определяем наборы записей, в которых есть движения
	МассивИменРегистров = ПроведениеСерверУТ.ПолучитьИспользуемыеРегистры(
		Ссылка,
		Метаданные().Движения,
		ИсключаемыеРегистры);
	
	// Записываем наборы записей, в которых есть движения
	Для Каждого ИмяРегистра Из МассивИменРегистров Цикл
		Движения[ИмяРегистра].Записывать = Истина;
	КонецЦикла;
	
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбновитьПредставлениеОрганизации()

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.Наименование КАК ОрганизацияПредставление
	|ИЗ
	|	Справочник.Организации КАК ДанныеСправочника
	|ГДЕ
	|	ДанныеСправочника.Ссылка В (&МассивОрганизацийДоходы)
	|	ИЛИ ДанныеСправочника.Ссылка В (&МассивОрганизацийРасходы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОрганизацияПредставление
	|");
	
	МассивОрганизацийДоходы = Доходы.ВыгрузитьКолонку("Организация");
	МассивОрганизацийРасходы = Расходы.ВыгрузитьКолонку("Организация");
	Запрос.УстановитьПараметр("МассивОрганизацийДоходы", МассивОрганизацийДоходы);
	Запрос.УстановитьПараметр("МассивОрганизацийРасходы", МассивОрганизацийРасходы);
	
	ТекстПредставлениеОрганизаций = "";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстПредставлениеОрганизаций = ТекстПредставлениеОрганизаций
			+ ?(ПустаяСтрока(ТекстПредставлениеОрганизаций), "", ", ")
			+ Выборка.ОрганизацияПредставление;
	КонецЦикла;

	Если ПустаяСтрока(ТекстПредставлениеОрганизаций) Тогда 
		ТекстПредставлениеОрганизаций = НСтр("ru = 'Укажите организацию';
											|en = 'Specify the company'");
	КонецЕсли;

	Если ПредставлениеОрганизаций <> ТекстПредставлениеОрганизаций Тогда
		ПредставлениеОрганизаций = ТекстПредставлениеОрганизаций;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
