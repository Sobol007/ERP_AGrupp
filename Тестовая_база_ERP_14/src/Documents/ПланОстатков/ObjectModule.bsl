#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет табличную часть документа по правилу заполнения из различных источников.
//
Процедура ЗаполнитьПоПравилуЗаполнения() Экспорт 
	
	Параметры = Новый Структура("Ссылка, Сценарий, КроссТаблица, ИзменитьРезультатНа, ЗаполненоАвтоматически, ТочностьОкругления, 
		|Склад, Статус, Периодичность, НачалоПериода, ОкончаниеПериода");
	
	ЗаполнитьЗначенияСвойств(Параметры, ЭтотОбъект);
	
	Параметры.Вставить("ЗаполнятьПоПравилу", Истина);
	Параметры.Вставить("ПравилоЗаполнения", ПравилоЗаполнения.Выгрузить());
	Параметры.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки.Получить());
	
	ЗаполняемаяТЧ = Товары.Выгрузить();
	Если ОбновитьДополнить = 0 Тогда
		ЗаполняемаяТЧ.Очистить();
	КонецЕсли;
	
	Параметры.Вставить("ЗаполняемаяТЧ", ЗаполняемаяТЧ);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	Документы.ПланОстатков.ЗаполнитьПоПравилуЗаполнения(Параметры, АдресХранилища);
	
	ЗаполняемаяТЧ = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Товары.Загрузить(ЗаполняемаяТЧ);
	
	ЗаполненоАвтоматически = Истина;
	
КонецПроцедуры

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыПланов[НовыйСтатус];
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	// Пропускаем обработку, чтобы гарантировать получение формы объекта при передаче параметра "АвтоТест".
	Если ДанныеЗаполнения = "АвтоТест" Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	ЗаполнитьДанныеПоУмолчанию();
	
	ЗаполнитьРеквизитыПланаПоСценариюВидуПлана();

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Замещающий Тогда
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗамещениеПланов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ВидПлана", ВидПлана);
		Блокировка.Заблокировать();
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Планирование.ПроверитьСтатусУтвержден(ЭтотОбъект, Отказ, РежимЗаписи, Перечисления.ТипыПланов.ПланОстатков);
	
	Для каждого СтрокаТЧ Из Товары Цикл
		
		Если ЗначениеЗаполнено(Склад) Тогда
			СтрокаТЧ.Склад = Склад;
		КонецЕсли; 
		
	КонецЦикла;
	
	//++ НЕ УТ
	Если НЕ ОтражаетсяВБюджетировании Тогда
		СтатьяБюджетов = Неопределено;
	КонецЕсли;
	
	Если НЕ ОтражаетсяВБюджетировании Тогда
		СценарийБюджетирования = Неопределено;
	КонецЕсли;
	//-- НЕ УТ
	
	Если Замещающий 
		И Не ЭтоНовый()
		И Не Отказ Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбновитьЗамещениеПлана(РежимЗаписи);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если Не Замещающий
		И Не ЭтоНовый()
		И Не Отказ
		И Планирование.ЕстьЗамещениеПлана(Ссылка) Тогда
		НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
		НаборЗаписей.Записать();
	КонецЕсли;
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбновитьЗамещениеПлана(РежимЗаписи, ОбновлениеИБ = Ложь) Экспорт
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
		Или (РежимЗаписи = РежимЗаписиДокумента.Запись И Не Проведен) Тогда
		
		Для Каждого Строка Из Товары Цикл
			Строка.Замещен = Ложь;
		КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
		НаборЗаписей.Записать();
		Возврат;
	КонецЕсли;
		
	Периоды = Новый ТаблицаЗначений();
	Периоды.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДобавлениеДатаНачала = НачалоПериода;
	Пока ДобавлениеДатаНачала < КонецДня(ОкончаниеПериода) Цикл
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.Период = ДобавлениеДатаНачала;
		
		ДатуОкончанияПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДобавлениеДатаНачала, Периодичность);
		ДобавлениеДатаНачала = ДатуОкончанияПериода+1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Периоды.Период
	|ПОМЕСТИТЬ Периоды
	|ИЗ
	|	&Периоды КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланОстатковЗамещающий.Ссылка,
	|	ПланОстатковЗамещающий.ВидПлана,
	|	ВЫБОР
	|		КОГДА &НачалоПериода > ПланОстатковЗамещающий.НачалоПериода
	|			ТОГДА &НачалоПериода
	|		ИНАЧЕ ПланОстатковЗамещающий.НачалоПериода
	|	КОНЕЦ КАК НачалоПериода,
	|	ВЫБОР
	|		КОГДА &ОкончаниеПериода < ПланОстатковЗамещающий.ОкончаниеПериода
	|			ТОГДА &ОкончаниеПериода
	|		ИНАЧЕ ПланОстатковЗамещающий.ОкончаниеПериода
	|	КОНЕЦ КАК ОкончаниеПериода
	|ПОМЕСТИТЬ ЗамещаемыеПланы
	|ИЗ
	|	Документ.ПланОстатков КАК ПланОстатковЗамещающий
	|ГДЕ
	|	ПланОстатковЗамещающий.ОкончаниеПериода >= &НачалоПериода
	|	И ПланОстатковЗамещающий.НачалоПериода <= &ОкончаниеПериода
	|	И ПланОстатковЗамещающий.Ссылка <> &Ссылка
	|	И ПланОстатковЗамещающий.Проведен
	|	И ПланОстатковЗамещающий.ВидПлана = &ВидПлана
	|	И ПланОстатковЗамещающий.Статус.Порядок >= &СтатусИндекс
	|	И ПланОстатковЗамещающий.Дата > &Дата
	|	И ПланОстатковЗамещающий.Назначение = &Назначение
	|	И ПланОстатковЗамещающий.Склад = &Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещаемыеПланы.ВидПлана,
	|	Периоды.Период КАК ЗамещенныйПериод,
	|	ЛОЖЬ КАК КЗамещению,
	|	ЛОЖЬ КАК КОтменеЗамещения,
	|	ЗамещаемыеПланы.Ссылка КАК ЗамещающийПлан,
	|	&Ссылка КАК ЗамещенныйПлан
	|ПОМЕСТИТЬ ЗамещениеПланов
	|ИЗ
	|	ЗамещаемыеПланы КАК ЗамещаемыеПланы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Периоды КАК Периоды
	|		ПО ЗамещаемыеПланы.НачалоПериода <= Периоды.Период
	|			И ЗамещаемыеПланы.ОкончаниеПериода >= Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОстатковТовары.ДатаОстатка,
	|	ВЫБОР &Периодичность
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланОстатковТовары.ДатаОстатка, НЕДЕЛЯ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланОстатковТовары.ДатаОстатка, ДЕКАДА)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланОстатковТовары.ДатаОстатка, МЕСЯЦ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланОстатковТовары.ДатаОстатка, КВАРТАЛ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланОстатковТовары.ДатаОстатка, ПОЛУГОДИЕ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланОстатковТовары.ДатаОстатка, ГОД)
	|		ИНАЧЕ ПланОстатковТовары.ДатаОстатка
	|	КОНЕЦ КАК Период
	|ПОМЕСТИТЬ ПланОстатковТовары
	|ИЗ
	|	&ПланОстатковТовары КАК ПланОстатковТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОстатковТовары.ДатаОстатка
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОстатковТовары КАК ПланОстатковТовары
	|		ПО ЗамещениеПланов.ЗамещенныйПериод = ПланОстатковТовары.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ВидПлана,
	|	ЗамещениеПланов.ЗамещенныйПериод,
	|	ЗамещениеПланов.КЗамещению,
	|	ЗамещениеПланов.КОтменеЗамещения,
	|	ЗамещениеПланов.ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
	Запрос.УстановитьПараметр("СтатусИндекс", Перечисления.СтатусыПланов.Индекс(Статус));
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ОкончаниеПериода);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	Запрос.УстановитьПараметр("ПланОстатковТовары", Товары.Выгрузить());
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	Выборка = ЗапросПакет[4].Выбрать();
	ТаблицаЗамещениеПлана = ЗапросПакет[5].Выгрузить();
	
	Для Каждого Строка Из Товары Цикл
		Строка.Замещен = Ложь;
	КонецЦикла;
	
	Пока Выборка.Следующий() Цикл
		
		Отбор = Новый Структура("ДатаОстатка", Выборка.ДатаОстатка);
		ЗамещаемыеСтроки = Товары.НайтиСтроки(Отбор);
		Для Каждого Строка Из ЗамещаемыеСтроки Цикл
			Строка.Замещен = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
	НаборЗаписей.Загрузить(ТаблицаЗамещениеПлана);
	
	Если ОбновлениеИБ Тогда
		НаборЗаписей.ДополнительныеСвойства.Вставить("РегистрироватьНаУзлахПлановОбменаПриОбновленииИБ", Неопределено);
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		НаборЗаписей.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И (Замещающий ИЛИ Планирование.ЕстьЗамещениеПлана(Ссылка)) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбновитьЗамещенныеПланы();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗамещенныеПланы()
	
	Периоды = Новый ТаблицаЗначений();
	Периоды.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДобавлениеДатаНачала = НачалоПериода;
	Пока ДобавлениеДатаНачала < КонецДня(ОкончаниеПериода) Цикл
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.Период = ДобавлениеДатаНачала;
		
		ДатуОкончанияПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДобавлениеДатаНачала, Периодичность);
		ДобавлениеДатаНачала = ДатуОкончанияПериода+1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Периоды.Период
	|ПОМЕСТИТЬ Периоды
	|ИЗ
	|	&Периоды КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланОстатковЗамещенный.Ссылка,
	|	ПланОстатковЗамещенный.ВидПлана,
	|	ВЫБОР
	|		КОГДА ПланОстатков.НачалоПериода > ПланОстатковЗамещенный.НачалоПериода
	|			ТОГДА ПланОстатков.НачалоПериода
	|		ИНАЧЕ ПланОстатковЗамещенный.НачалоПериода
	|	КОНЕЦ КАК НачалоПериода,
	|	ВЫБОР
	|		КОГДА ПланОстатков.ОкончаниеПериода < ПланОстатковЗамещенный.ОкончаниеПериода
	|			ТОГДА ПланОстатков.ОкончаниеПериода
	|		ИНАЧЕ ПланОстатковЗамещенный.ОкончаниеПериода
	|	КОНЕЦ КАК ОкончаниеПериода
	|ПОМЕСТИТЬ ЗамещенныеПланы
	|ИЗ
	|	Документ.ПланОстатков КАК ПланОстатков
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПланОстатков КАК ПланОстатковЗамещенный
	|		ПО ПланОстатков.ВидПлана = ПланОстатковЗамещенный.ВидПлана
	|			И ПланОстатков.Статус.Порядок >= ПланОстатковЗамещенный.Статус.Порядок
	|			И ПланОстатков.Дата > ПланОстатковЗамещенный.Дата
	|			И ПланОстатков.Назначение = ПланОстатковЗамещенный.Назначение
	|			И ПланОстатков.Склад = ПланОстатковЗамещенный.Склад
	|			И ПланОстатковЗамещенный.Проведен
	|			И ПланОстатковЗамещенный.Замещающий
	|ГДЕ
	|	ПланОстатковЗамещенный.ОкончаниеПериода >= ПланОстатков.НачалоПериода
	|	И ПланОстатковЗамещенный.НачалоПериода <= ПланОстатков.ОкончаниеПериода
	|	И ПланОстатков.Ссылка = &Ссылка
	|	И ПланОстатков.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещаемыеПланы.ВидПлана,
	|	Периоды.Период КАК ЗамещенныйПериод,
	|	ЗамещаемыеПланы.Ссылка КАК ЗамещенныйПлан,
	|	&Ссылка КАК ЗамещающийПлан
	|ПОМЕСТИТЬ ЗамещенныеПланыПоПериодам
	|ИЗ
	|	ЗамещенныеПланы КАК ЗамещаемыеПланы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Периоды КАК Периоды
	|		ПО ЗамещаемыеПланы.НачалоПериода <= Периоды.Период
	|			И ЗамещаемыеПланы.ОкончаниеПериода >= Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещающийПлан КАК ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.ЗамещенныйПериод КАК ЗамещенныйПериод,
	|	ЗамещениеПланов.ВидПлана КАК ВидПлана,
	|	ЗамещениеПланов.КЗамещению КАК КЗамещению,
	|	ВЫБОР
	|		КОГДА ЗамещенныеПланыПоПериодам.ЗамещенныйПериод ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК КОтменеЗамещения
	|ПОМЕСТИТЬ ЗамещениеПлановСуммаДвижений
	|ИЗ
	|	РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗамещенныеПланыПоПериодам КАК ЗамещенныеПланыПоПериодам
	|		ПО ЗамещениеПланов.ВидПлана = ЗамещенныеПланыПоПериодам.ВидПлана
	|			И ЗамещениеПланов.ЗамещенныйПериод = ЗамещенныеПланыПоПериодам.ЗамещенныйПериод
	|			И ЗамещениеПланов.ЗамещающийПлан = ЗамещенныеПланыПоПериодам.ЗамещающийПлан
	|			И ЗамещениеПланов.ЗамещенныйПлан = ЗамещенныеПланыПоПериодам.ЗамещенныйПлан
	|ГДЕ
	|	&Ссылка = ЗамещениеПланов.ЗамещающийПлан
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗамещенныеПланыПоПериодам.ЗамещающийПлан,
	|	ЗамещенныеПланыПоПериодам.ЗамещенныйПлан,
	|	ЗамещенныеПланыПоПериодам.ЗамещенныйПериод,
	|	ЗамещенныеПланыПоПериодам.ВидПлана,
	|	ИСТИНА,
	|	ЛОЖЬ
	|ИЗ
	|	ЗамещенныеПланыПоПериодам КАК ЗамещенныеПланыПоПериодам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ПО ЗамещенныеПланыПоПериодам.ВидПлана = ЗамещениеПланов.ВидПлана
	|			И ЗамещенныеПланыПоПериодам.ЗамещенныйПериод = ЗамещениеПланов.ЗамещенныйПериод
	|			И ЗамещенныеПланыПоПериодам.ЗамещенныйПлан = ЗамещениеПланов.ЗамещенныйПлан
	|			И ЗамещенныеПланыПоПериодам.ЗамещающийПлан = ЗамещениеПланов.ЗамещающийПлан
	|ГДЕ
	|	ЗамещениеПланов.ЗамещенныйПериод ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗамещениеПлановСуммаДвижений.ЗамещающийПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод,
	|	ЗамещениеПлановСуммаДвижений.ВидПлана,
	|	МИНИМУМ(ЕСТЬNULL(ЗамещениеПланов1.КЗамещению, ЗамещениеПлановСуммаДвижений.КЗамещению)) КАК КЗамещению,
	|	МИНИМУМ(ЗамещениеПлановСуммаДвижений.КОтменеЗамещения) КАК КОтменеЗамещения,
	|	МИНИМУМ(ЕСТЬNULL(ЗамещениеПланов.КОтменеЗамещения, ИСТИНА)) КАК ВыполнитьОтменуЗамещению
	|ПОМЕСТИТЬ ЗамещениеПланов
	|ИЗ
	|	ЗамещениеПлановСуммаДвижений КАК ЗамещениеПлановСуммаДвижений
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ПО ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан = ЗамещениеПланов.ЗамещенныйПлан
	|			И ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод = ЗамещениеПланов.ЗамещенныйПериод
	|			И (НЕ ЗамещениеПланов.КОтменеЗамещения)
	|			И (&Ссылка <> ЗамещениеПланов.ЗамещающийПлан)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов1
	|		ПО ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан = ЗамещениеПланов1.ЗамещенныйПлан
	|			И ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод = ЗамещениеПланов1.ЗамещенныйПериод
	|			И (НЕ ЗамещениеПланов1.КЗамещению)
	|			И (&Ссылка <> ЗамещениеПланов1.ЗамещающийПлан)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗамещениеПлановСуммаДвижений.ВидПлана,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещающийПлан
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.ЗамещенныйПериод,
	|	ЗамещениеПланов.ВидПлана,
	|	ЗамещениеПланов.КЗамещению,
	|	ЗамещениеПланов.КОтменеЗамещения,
	|	ЗамещениеПланов.ВыполнитьОтменуЗамещению
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|ИТОГИ ПО
	|	ЗамещенныйПлан";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	ВыборкаЗамещенныйПлан = ЗапросПакет[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ОбновитьЗамещениеПлана = Ложь;
	
	Пока ВыборкаЗамещенныйПлан.Следующий() Цикл
		
		НаборЗаписейОчереди = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписейОчереди.Отбор.ЗамещающийПлан.Установить(Ссылка);
		НаборЗаписейОчереди.Отбор.ЗамещенныйПлан.Установить(ВыборкаЗамещенныйПлан.ЗамещенныйПлан); 
		
		Выборка = ВыборкаЗамещенныйПлан.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
			
			Если (Выборка.КЗамещению И Выборка.КОтменеЗамещения)Тогда
				ОбновитьЗамещениеПлана = Истина;
			ИначеЕсли Выборка.КОтменеЗамещения И НЕ Выборка.ВыполнитьОтменуЗамещению Тогда
				Продолжить;
			ИначеЕсли Выборка.КЗамещению Или Выборка.КОтменеЗамещения Тогда
				ОбновитьЗамещениеПлана = Истина;
				ЗаписьОчереди = НаборЗаписейОчереди.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьОчереди, Выборка);
			ИначеЕсли Проведен Тогда
				ЗаписьОчереди = НаборЗаписейОчереди.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьОчереди, Выборка);
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписейОчереди.Записать();
		
	КонецЦикла;
	
	Если ОбновитьЗамещениеПлана Тогда
		Планирование.ЗапускВыполненияФоновогоПроведенияПлана();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	ЗаполнитьРеквизитыПланаПоСценариюВидуПлана();
	Для каждого СтрокаТовары Из Товары Цикл

		СтрокаТовары.Отменено = Ложь;

	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ПланОстатков.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Планирование.ОтразитьПланОстатков(ДополнительныеСвойства, Движения, Отказ);
	
	//++ НЕ УТ
	РегистрыНакопления.ОборотыБюджетов.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =  
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Товары.ДатаОстатка КАК Период,
		|	&Сценарий КАК Сценарий,
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Склад КАК Склад
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Товары КАК Товары
		|ГДЕ
		|	Товары.КоличествоУпаковок <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДвиженияДокумента.Период КАК Период,
		|	ДвиженияДокумента.Сценарий КАК Сценарий,
		|	ДвиженияДокумента.Номенклатура КАК Номенклатура,
		|	ДвиженияДокумента.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ДвиженияДокумента.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК УказаниеСклада
		|ПОМЕСТИТЬ ДвиженияДокумента
		|ИЗ
		|	Товары КАК ДвиженияДокумента
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДвиженияДокумента.Период,
		|	ДвиженияДокумента.Сценарий,
		|	ДвиженияДокумента.Номенклатура,
		|	ДвиженияДокумента.Характеристика,
		|	ВЫБОР
		|		КОГДА ПланыОстатков.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ
		|ИЗ
		|	Товары КАК ДвиженияДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПланыОстатков КАК ПланыОстатков
		|		ПО ДвиженияДокумента.Период = ПланыОстатков.Период
		|			И ДвиженияДокумента.Номенклатура = ПланыОстатков.Номенклатура
		|			И ДвиженияДокумента.Характеристика = ПланыОстатков.Характеристика
		|			И ДвиженияДокумента.Сценарий = ПланыОстатков.Сценарий
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
		|			ПО ПланыОстатков.ПланОстатков = ЗамещениеПланов.ЗамещающийПлан
		|ГДЕ
		|	ВЫБОР
		|			КОГДА ЗамещениеПланов.ЗамещающийПлан ЕСТЬ NULL
		|				ТОГДА ПланыОстатков.Регистратор <> &Ссылка
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И ПланыОстатков.Количество <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияДокумента.Период КАК Период,
		|	ДвиженияДокумента.Сценарий КАК Сценарий,
		|	ДвиженияДокумента.Номенклатура КАК Номенклатура,
		|	ДвиженияДокумента.Характеристика КАК Характеристика,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДвиженияДокумента.УказаниеСклада) КАК УказаниеСклада
		|ИЗ
		|	ДвиженияДокумента КАК ДвиженияДокумента
		|
		|СГРУППИРОВАТЬ ПО
		|	ДвиженияДокумента.Период,
		|	ДвиженияДокумента.Сценарий,
		|	ДвиженияДокумента.Номенклатура,
		|	ДвиженияДокумента.Характеристика
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДвиженияДокумента.УказаниеСклада) > 1";

	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(, "ДатаОстатка, Номенклатура, Характеристика,
		|Склад, КоличествоУпаковок"));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ШаблонСообщения1 = НСтр("ru = 'Для номенклатуры %НоменклатураХарактеристика% 
		|нельзя одновременно использовать в одном периоде и подразделении планы с пустым и планы с заполненным значением поля:';
		|en = 'Cannot use plans with an empty field value and plans with a populated field value simultaneously for products %НоменклатураХарактеристика%
		| in one period and department:'") + " ";
	ШаблонСообщения2 = НСтр("ru = '%Поле%';
							|en = '%Поле%'");
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл

		ТекстСообщения = СтрЗаменить(ШаблонСообщения1, "%НоменклатураХарактеристика%",
						НоменклатураКлиентСервер.ПредставлениеНоменклатуры(Выборка.Номенклатура, Выборка.Характеристика));
		
		Если Выборка.УказаниеСклада > 1 Тогда
			ТекстСообщения = ТекстСообщения + СтрЗаменить(ШаблонСообщения2, "%Поле%", "Склад");
		КонецЕсли; 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ,, Отказ);

	КонецЦикла;

	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	Иначе
		ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
		ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
		ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	КонецЕсли; 
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ИмяТЧ",                    "Товары");
	ПараметрыПроверки.Вставить("ПредставлениеТЧ",          НСтр("ru = 'Товары';
																|en = 'Goods'"));
	ПараметрыПроверки.Вставить("Периодичность",            Периодичность);
	ПараметрыПроверки.Вставить("ДатаНачала",               НачалоПериода);
	ПараметрыПроверки.Вставить("ДатаОкончания",            ОкончаниеПериода);
	ПараметрыПроверки.Вставить("ИмяПоляДатыПериода",       "ДатаОстатка");
	ПараметрыПроверки.Вставить("ПредставлениеДатыПериода", НСтр("ru = 'Дата поступления';
																|en = 'Inpayment date'"));
	
	ПланированиеКлиентСервер.ПроверитьДатуПериодаТЧ(ЭтотОбъект, Отказ, ПараметрыПроверки);
	
	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	Иначе
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	КонецЕсли; 
	
	Планирование.ОбработкаПроверкиЗаполненияПоСценариюВидуПлана(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	//++ НЕ УТ
		
	Если Не ОтражаетсяВБюджетировании Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетов");
		МассивНепроверяемыхРеквизитов.Добавить("СценарийБюджетирования");
	КонецЕсли;
	
	//-- НЕ УТ
	
	Если Не КроссТаблица
		И ЗначениеЗаполнено(ВидПлана) Тогда
		
		РеквизитыВидПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана,"ЗаполнятьНазначениеВТЧ, ЗаполнятьСклад");
		
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика,
		|	ТаблицаТовары.Склад,
		|	ТаблицаТовары.Назначение,
		|	ТаблицаТовары.Количество
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Склад,
		|	Товары.Назначение,
		|	СУММА(Товары.Количество) КАК Количество
		|ИЗ
		|	Товары КАК Товары
		|ГДЕ
		|	Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	И (Не &ЗаполнятьСклад ИЛИ Товары.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
		|
		|СГРУППИРОВАТЬ ПО
		|	Товары.Номенклатура,
		|	Товары.Склад,
		|	Товары.Назначение,
		|	Товары.Характеристика
		|
		|ИМЕЮЩИЕ
		|	СУММА(Товары.Количество) = 0";
		Запрос.УстановитьПараметр("ТаблицаТовары", Товары.Выгрузить());
		Запрос.УстановитьПараметр("ЗаполнятьСклад", РеквизитыВидПлана.ЗаполнятьСклад);
		РеквизитыВидПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана,"ЗаполнятьНазначениеВТЧ, ЗаполнятьСклад, ЗаполнятьСкладВТЧ");
		
		ТаблицаОшибок = Запрос.Выполнить().Выгрузить();
		
		КлючДанных = ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(ЭтотОбъект);
		СтруктураПоиска = Новый Структура("Номенклатура,Характеристика,Назначение,Склад");
		
		Для Каждого СтрокаОшибки Из ТаблицаОшибок Цикл
			
			ТекстСообщения = НСтр("ru = 'Для строк плана с номенклатурой %Номенклатура%%Характеристика%%Назначение%%Склад% не запланировано количество ни в одном периоде планирования.';
									|en = 'Quantity is not planned in any planning period for lines of plan with the %Номенклатура%%Характеристика%%Назначение%%Склад% products.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%", СтрокаОшибки.Номенклатура);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Характеристика%", ?(ЗначениеЗаполнено(СтрокаОшибки.Характеристика), НСтр("ru = ', характеристикой';
																																	|en = ', characteristics'") + " " + СтрокаОшибки.Характеристика, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Назначение%", ?(ЗначениеЗаполнено(СтрокаОшибки.Назначение)
				И РеквизитыВидПлана.ЗаполнятьНазначениеВТЧ,
				НСтр("ru = ', назначением';
					|en = ', assignment'") + " " + СтрокаОшибки.Назначение, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Склад%", ?(ЗначениеЗаполнено(СтрокаОшибки.Склад)
				И РеквизитыВидПлана.ЗаполнятьСкладВТЧ , НСтр("ru = ', складом';
															|en = ', warehouse'") + " " + СтрокаОшибки.Склад, ""));
			
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаОшибки);
			СтрокаПоиска = Товары.НайтиСтроки(СтруктураПоиска)[0];
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаПоиска.НомерСтроки, "КоличествоУпаковок");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных, Поле,"Объект",Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет подразделение, сценарий, вид плана и признак кросс-таблицы в документе, значением по умолчанию.
//
Процедура ЗаполнитьДанныеПоУмолчанию()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА СценарииТоварногоПланирования.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СценарииТоварногоПланирования.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.Сценарий
	|	КОНЕЦ КАК Сценарий,
	|	ВЫБОР
	|		КОГДА ВидыПланов.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыПланов.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.ВидПлана
	|	КОНЕЦ КАК ВидПлана,
	|	ДанныеДокумента.ЗаполнятьПоФормуле КАК ЗаполнятьПоФормуле,
	|	ДанныеДокумента.КроссТаблица КАК КроссТаблица
	|ИЗ
	|	Документ.ПланОстатков КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПланов КАК ВидыПланов
	|		ПО ДанныеДокумента.ВидПлана = ВидыПланов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СценарииТоварногоПланирования КАК СценарииТоварногоПланирования
	|		ПО ДанныеДокумента.Сценарий = СценарииТоварногоПланирования.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ответственный = &Ответственный
	|	И ДанныеДокумента.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокумента.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		
	КонецЕсли;
	
	Сценарий = ЗначениеНастроекПовтИсп.ПолучитьСценарийПоУмолчанию(Перечисления.ТипыПланов.ПланОстатков, Сценарий);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПланаПоСценариюВидуПлана()
	
	РеквизитыСценария = "Периодичность";
	//++ НЕ УТ
	РеквизитыСценария = РеквизитыСценария + ", СценарийБюджетирования";
	//-- НЕ УТ
	ПараметрыСценария = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сценарий, РеквизитыСценария);
	Если НЕ ЗначениеЗаполнено(ВидПлана) Тогда
		ВидПлана = Планирование.ПолучитьВидПланаПоУмолчанию(Перечисления.ТипыПланов.ПланОстатков, Сценарий);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыСценария);
	
	//++ НЕ УТ
	Если ЗначениеЗаполнено(ВидПлана) Тогда
		РеквизитыВидаПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана, "ОтражаетсяВБюджетировании, СтатьяБюджетов");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыВидаПлана);
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
