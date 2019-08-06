#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ОтменаДоплатыДоСреднегоЗаработка.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаОтмены, "Объект.ДатаОтмены", Отказ, НСтр("ru = 'Дата отмены';
																								|en = 'Cancellation date'"), , , Ложь);
	
	Если Не ОтменаДоплатыУтверждена Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Начисление");
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
	
	ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОбъектОснование = ДанныеЗаполнения;
	
	Если ТипЗнч(ОбъектОснование) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ОбъектОснование);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Сотрудник", ОбъектОснование);
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ПриказНаДоплатуДоСреднегоЗаработка.Ссылка,
			|	ПриказНаДоплатуДоСреднегоЗаработка.ДатаНачала КАК ДатаНачала
			|ИЗ
			|	Документ.ПриказНаДоплатуДоСреднегоЗаработка КАК ПриказНаДоплатуДоСреднегоЗаработка
			|ГДЕ
			|	ПриказНаДоплатуДоСреднегоЗаработка.Проведен
			|	И ПриказНаДоплатуДоСреднегоЗаработка.Сотрудник = &Сотрудник
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаНачала УБЫВ";
			
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			ОбъектОснование = Выборка.Ссылка;
			
		КонецЕсли; 
		
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ПриказНаДоплатуДоСреднегоЗаработка") Тогда
		ЗаполнитьРеквизитыПоОснованию(ОбъектОснование);
	ИначеЕсли ТипЗнч(ОбъектОснование) = Тип("Структура") Тогда
		Если ОбъектОснование.Свойство("Действие") И ОбъектОснование.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ОбъектОснование.Ссылка);
			
			ИсправленныйДокумент = ОбъектОснование.Ссылка;
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
		КонецЕсли;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ОбъектОснование, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект, , , ЗначениеЗаполнено(ИсправленныйДокумент));
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ИсправлениеПериодическихСведений.ИсправлениеПериодическихСведений(ЭтотОбъект, Отказ, РежимПроведения);
	
	ДанныеПроведения = ДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеПроведения.СотрудникиДаты, Ссылка);
	
	Если Не ОтменаДоплатыУтверждена Тогда 
		Возврат;
	КонецЕсли;
	
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеПроведения.ПлановыеНачисления);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений); 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКУдалениюПроведения(ЭтотОбъект, ЗначениеЗаполнено(ИсправленныйДокумент));
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если ОтменаДоплатыУтверждена Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОтменаДоплатыДоСреднегоЗаработка.ДатаОтмены КАК ДатаСобытия,
		|	ОтменаДоплатыДоСреднегоЗаработка.Сотрудник КАК Сотрудник,
		|	ОтменаДоплатыДоСреднегоЗаработка.Начисление,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОснование,
		|	ЛОЖЬ КАК Используется,
		|	ОтменаДоплатыДоСреднегоЗаработка.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ОтменаДоплатыДоСреднегоЗаработка.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	0 КАК Размер
		|ИЗ
		|	Документ.ОтменаДоплатыДоСреднегоЗаработка КАК ОтменаДоплатыДоСреднегоЗаработка
		|ГДЕ
		|	ОтменаДоплатыДоСреднегоЗаработка.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НачисленияСотрудника.Ссылка.ДатаОтмены,
		|	НачисленияСотрудника.Ссылка.Сотрудник,
		|	НачисленияСотрудника.Начисление,
		|	НачисленияСотрудника.ДокументОснование,
		|	ИСТИНА,
		|	НачисленияСотрудника.Ссылка.Сотрудник.ФизическоеЛицо,
		|	НачисленияСотрудника.Ссылка.Сотрудник.ГоловнаяОрганизация,
		|	НачисленияСотрудника.Размер
		|ИЗ
		|	Документ.ОтменаДоплатыДоСреднегоЗаработка.НачисленияСотрудника КАК НачисленияСотрудника
		|ГДЕ
		|	НачисленияСотрудника.Ссылка = &Ссылка";
		
		// Первый набор данных для проведения - таблица для формирования плановых начислений.
		ПлановыеНачисления = Запрос.Выполнить().Выгрузить();
		ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
		
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтменаДоплатыДоСреднегоЗаработка.ДатаОтмены КАК ДатаСобытия,
	|	ОтменаДоплатыДоСреднегоЗаработка.Сотрудник КАК Сотрудник
	|ИЗ
	|	Документ.ОтменаДоплатыДоСреднегоЗаработка КАК ОтменаДоплатыДоСреднегоЗаработка
	|ГДЕ
	|	ОтменаДоплатыДоСреднегоЗаработка.Ссылка = &Ссылка";
	
	// Второй набор данных для проведения - таблица для формирования времени регистрации документа.
	СотрудникиДаты = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура ЗаполнитьРеквизитыПоОснованию(ДокументОснование)
	
	РеквизитыДокументаОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Организация, Сотрудник, Начисление");

	ЭтотОбъект.Организация = РеквизитыДокументаОснования.Организация;
	ЭтотОбъект.Сотрудник = РеквизитыДокументаОснования.Сотрудник;
	ЭтотОбъект.ДокументОснование = ДокументОснование;	
	ЭтотОбъект.Начисление = РеквизитыДокументаОснования.Начисление;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
