#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует отчет в табличном документе по указанному объекту основного средства
//
// Параметры:
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ, в котором необходимо сформировать отчет
// 		Список - Массив, СписокЗначений - список объектов типа <СправочникСсылка.ОбъектыЭксплуатации> по которым необходимо сформировать отчет.
//
Процедура СформироватьОтчет(ТабличныйДокумент, Список) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Очистить();
	
	Запрос = Новый Запрос(ТекстЗапроса());
	Запрос.УстановитьПараметр("Объекты", Список);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Макет = ЭтотОбъект.ПолучитьМакет("Макет");
	
	ОблЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОблЗаголовокРаздела = Макет.ПолучитьОбласть("ЗаголовокРаздела");
	ОблОсновные = Макет.ПолучитьОбласть("Основные");
	ОблАмортизация = Макет.ПолучитьОбласть("Амортизация");
	ОблАмортизацияСрок = Макет.ПолучитьОбласть("АмортизацияСрок");
	ОблАмортизацияНаработка = Макет.ПолучитьОбласть("АмортизацияНаработка");
	ОблПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	ОблНеПринятоКУчету = Макет.ПолучитьОбласть("ЗаголовокНеПринятоКУчету");
	
	МетодЛинейный = Перечисления.СпособыНачисленияАмортизацииОС.Линейный;
	МетодОстатка = Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка;
	МетодНаработки = Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОблЗаголовок.Параметры.Заполнить(Выборка);
		ТабличныйДокумент.Вывести(ОблЗаголовок);
		
		Если Выборка.Состояние = Перечисления.ВидыСостоянийНМА.НеПринятКУчету Тогда
			ТабличныйДокумент.Вывести(ОблНеПринятоКУчету);
			Продолжить;
		КонецЕсли;
		
		ТабличныйДокумент.НачатьГруппуСтрок("Объект", Истина);
		
		ТабличныйДокумент.Вывести(ОблПустаяСтрока);
		
		#Область ОсновныеСведения
		ОблЗаголовокРаздела.Параметры.Заголовок = НСтр("ru = 'Основные сведения';
														|en = 'Main data'");
		ТабличныйДокумент.Вывести(ОблЗаголовокРаздела);
		ТабличныйДокумент.НачатьГруппуСтрок("ОсновныеСведения", Истина);
		
		ОблОсновные.Параметры.Заполнить(Выборка);
		ТабличныйДокумент.Вывести(ОблОсновные);
		
		ТабличныйДокумент.ЗакончитьГруппуСтрок();
		#КонецОбласти
		
		ТабличныйДокумент.Вывести(ОблПустаяСтрока);
		
		#Область ПараметрыАмортизации
		ОблЗаголовокРаздела.Параметры.Заголовок = НСтр("ru = 'Амортизация';
														|en = 'Depreciation'");
		ТабличныйДокумент.Вывести(ОблЗаголовокРаздела);
		ТабличныйДокумент.НачатьГруппуСтрок("Амортизация", Истина);
		
		ОблАмортизация.Параметры.Заполнить(Выборка);
		ТабличныйДокумент.Вывести(ОблАмортизация);
		
		Если Выборка.МетодНачисленияАмортизации = МетодЛинейный
			Или Выборка.МетодНачисленияАмортизации = МетодОстатка Тогда
			ОблАмортизацияСрок.Параметры.Заполнить(Выборка);
			ТабличныйДокумент.Вывести(ОблАмортизацияСрок);
		КонецЕсли;
		Если Выборка.МетодНачисленияАмортизации = МетодНаработки Тогда
			ОблАмортизацияНаработка.Параметры.Заполнить(Выборка);
			ТабличныйДокумент.Вывести(ОблАмортизацияНаработка);
		КонецЕсли;
		
		ТабличныйДокумент.ЗакончитьГруппуСтрок();
		#КонецОбласти
		
		ТабличныйДокумент.ЗакончитьГруппуСтрок();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапроса()
	
	Возврат
	"ВЫБРАТЬ
	|	Объекты.Ссылка КАК Объект,
	|	СостоянияТекущие.Организация,
	|	СостоянияТекущие.СчетУчета,
	|	СостоянияТекущие.ЛиквидационнаяСтоимость,
	|	СостоянияТекущие.МетодНачисленияАмортизации,
	|	СостоянияТекущие.ПорядокУчета,
	|	СостоянияТекущие.СчетАмортизации,
	|	СостоянияТекущие.СрокИспользования,
	|	СостоянияТекущие.ОбъемНаработки,
	|	ЕСТЬNULL(СостоянияТекущие.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) КАК Состояние,
	|	ЕСТЬNULL(СостоянияСписания.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаДоПринятияКУчету
	|ПОМЕСТИТЬ СостоянияТекущие
	|ИЗ
	|	Справочник.НематериальныеАктивы КАК Объекты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(, НематериальныйАктив В (&Объекты)) КАК СостоянияТекущие
	|		ПО Объекты.Ссылка = СостоянияТекущие.НематериальныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(
	|				,
	|				НематериальныйАктив В (&Объекты)
	|					И Состояние <> ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету)) КАК СостоянияСписания
	|		ПО Объекты.Ссылка = СостоянияСписания.НематериальныйАктив
	|ГДЕ
	|	Объекты.Ссылка В(&Объекты)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Объект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияПринятияКУчету.Период) КАК Период,
	|	ДвиженияПринятияКУчету.НематериальныйАктив КАК НематериальныйАктив
	|ПОМЕСТИТЬ ПериодыСостояний
	|ИЗ
	|	СостоянияТекущие КАК СостоянияТекущие
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НематериальныеАктивыМеждународныйУчет КАК ДвиженияПринятияКУчету
	|		ПО СостоянияТекущие.Объект = ДвиженияПринятияКУчету.НематериальныйАктив
	|			И СостоянияТекущие.ДатаДоПринятияКУчету < ДвиженияПринятияКУчету.Период
	|ГДЕ
	|	ДвиженияПринятияКУчету.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияПринятияКУчету.НематериальныйАктив
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Период,
	|	НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МеждународныйОстатки.Субконто1 КАК Актив,
	|	МеждународныйОстатки.СуммаОборотДт КАК Сумма
	|ПОМЕСТИТЬ Стоимость
	|ИЗ
	|	РегистрБухгалтерии.Международный.ОстаткиИОбороты(
	|			,
	|			,
	|			,
	|			,
	|			Счет В
	|				(ВЫБРАТЬ
	|					СостоянияТекущие.СчетУчета
	|				ИЗ
	|					СостоянияТекущие КАК СостоянияТекущие),
	|			,
	|			(Организация, Субконто1) В
	|				(ВЫБРАТЬ
	|					СостоянияТекущие.Организация,
	|					СостоянияТекущие.Объект
	|				ИЗ
	|					СостоянияТекущие КАК СостоянияТекущие)) КАК МеждународныйОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МеждународныйОстатки.Субконто1 КАК Актив,
	|	МеждународныйОстатки.СуммаОборотКт КАК Сумма
	|ПОМЕСТИТЬ НачисленнаяАмортизация
	|ИЗ
	|	РегистрБухгалтерии.Международный.ОстаткиИОбороты(
	|			,
	|			,
	|			,
	|			,
	|			Счет В
	|				(ВЫБРАТЬ
	|					СостоянияТекущие.СчетАмортизации
	|				ИЗ
	|					СостоянияТекущие КАК СостоянияТекущие),
	|			,
	|			(Организация, Субконто1) В
	|				(ВЫБРАТЬ
	|					СостоянияТекущие.Организация,
	|					СостоянияТекущие.Объект
	|				ИЗ
	|					СостоянияТекущие КАК СостоянияТекущие)) КАК МеждународныйОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Ссылка КАК НематериальныйАктив,
	|	СостоянияТекущие.Организация,
	|	СостоянияТекущие.Состояние КАК Состояние,
	|	СостоянияТекущие.СчетУчета,
	|	Стоимость.Сумма КАК ПервоначальнаяСтоимость,
	|	0 КАК СправедливаяСтоимость,
	|	СостоянияТекущие.ЛиквидационнаяСтоимость,
	|	СостоянияТекущие.МетодНачисленияАмортизации,
	|	НачисленнаяАмортизация.Сумма КАК СуммаНачисленнойАмортизации,
	|	СостоянияТекущие.СчетАмортизации,
	|	СостоянияТекущие.СрокИспользования,
	|	СостоянияТекущие.ОбъемНаработки,
	|	Объекты.НаименованиеПолное,
	|	Объекты.Наименование КАК Наименование,
	|	Объекты.ГруппаНМАМеждународныйУчет КАК Группа,
	|	ПериодыСостояний.Период КАК ДатаПринятияКУчету
	|ИЗ
	|	Справочник.НематериальныеАктивы КАК Объекты
	|		ЛЕВОЕ СОЕДИНЕНИЕ СостоянияТекущие КАК СостоянияТекущие
	|		ПО Объекты.Ссылка = СостоянияТекущие.Объект
	|		ЛЕВОЕ СОЕДИНЕНИЕ Стоимость КАК Стоимость
	|		ПО Объекты.Ссылка = Стоимость.Актив
	|		ЛЕВОЕ СОЕДИНЕНИЕ НачисленнаяАмортизация КАК НачисленнаяАмортизация
	|		ПО Объекты.Ссылка = НачисленнаяАмортизация.Актив
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПериодыСостояний КАК ПериодыСостояний
	|		ПО Объекты.Ссылка = ПериодыСостояний.НематериальныйАктив
	|ГДЕ
	|	Объекты.Ссылка В(&Объекты)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
КонецФункции

#КонецОбласти

#КонецЕсли