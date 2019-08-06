////////////////////////////////////////////////////////////////////////////////
// ОУП: Процедуры подсистемы оперативного учета производства
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Рассчитывает объем работ
//
// Параметры:
//  ВремяРаботы						- Число - время работы
//  Количество						- Число - Количество работы
//  ОдновременноПроизводимаяПартия	- Число - Одновременно производимое количество работы.
//
// Возвращаемое значение:
//   Число   - объем работ
//
Функция ОбъемРабот(ВремяРаботы, Количество, ОдновременноПроизводимаяПартия) Экспорт

	ОбъемРабот = ВремяРаботы * Цел((Количество - 1) / ОдновременноПроизводимаяПартия) + ВремяРаботы;
	
	Возврат ОбъемРабот;

КонецФункции

// Рассчитывает загрузку
//
// Параметры:
//  ЗагрузкаИсходная				- Число - Загрузка
//  Количество						- Число - Количество работы
//  ОдновременноПроизводимаяПартия	- Число - Одновременно производимое количество работы.
//
// Возвращаемое значение:
//   Число   - Загрузка
//
Функция Загрузка(ЗагрузкаИсходная, Количество, ОдновременноПроизводимаяПартия) Экспорт

	Загрузка = ЗагрузкаИсходная * Цел((Количество - 1) / ОдновременноПроизводимаяПартия) + ЗагрузкаИсходная;
	
	Возврат Загрузка;

КонецФункции

// Рассчитывает длительность периода с учетом графика работы
//
// Параметры:
//  Начало						- Дата - Начало периода
//  Окончание					- Дата - Окончание периода
//  ГрафикРаботы				- ТаблицаЗначений, ДанныеФормыКоллекция - график работы
//  НачалоПериода				- Дата - Начало периода в котором нужно определить длительность
//  ОкончаниеПериода			- Дата - Окончание периода в котором нужно определить длительность
//  ВремяРаботыВРабочееВремя	- Число - Время работы в нерабочее время
//  ПериодыВыполнения			- Массив - занятые периоды.
//
// Возвращаемое значение:
//   Число   - длительность периода в секундах.
//
Функция ДлительностьПериодаСУчетомГрафикаРаботы(Начало, Окончание, ГрафикРаботы, НачалоПериода = Неопределено, ОкончаниеПериода = Неопределено, ВремяРаботыВРабочееВремя = 0, ПериодыВыполнения = Неопределено) Экспорт
	
	ВремяРаботыВРабочееВремя = 0;
	ПериодыВыполнения = Новый Массив;
	
	Если Начало = '000101010000' ИЛИ Окончание = '000101010000' ИЛИ Окончание <= Начало Тогда
		Возврат 0;
	КонецЕсли;
	
	Если ГрафикРаботы.Количество() = 0 Тогда
		// Графика нет, считаем что все время доступно
		ДанныеПериода = Новый Структура;
		ДанныеПериода.Вставить("Начало", Начало);
		ДанныеПериода.Вставить("Окончание", Окончание);
		ДанныеПериода.Вставить("ВремяРаботы", (ДанныеПериода.Окончание - ДанныеПериода.Начало) + 1);
		ДанныеПериода.Вставить("ВремяРаботыВРабочееВремя", 0);
		ПериодыВыполнения.Добавить(ДанныеПериода);
		
		Если НачалоПериода = Неопределено И ОкончаниеПериода = Неопределено Тогда
			Возврат Окончание - Начало + 1;
		Иначе
			Возврат ОкончаниеПериода - НачалоПериода;
		КонецЕсли; 
	КонецЕсли;
	
	ОбъемРабот = 0;
	Для каждого СтрокаГрафикРаботы Из ГрафикРаботы Цикл
		
		Если Начало > СтрокаГрафикРаботы.Окончание 
			ИЛИ НачалоПериода <> Неопределено 
				И НачалоПериода > СтрокаГрафикРаботы.Окончание Тогда
			// Строка графика вне текущего периода
			Продолжить;
		КонецЕсли;
		
		Если Окончание < СтрокаГрафикРаботы.Начало 
			ИЛИ ОкончаниеПериода <> Неопределено 
				И ОкончаниеПериода < СтрокаГрафикРаботы.Начало Тогда
			// Следующие строки вне текущего периода
			Прервать;
		КонецЕсли;
		
		Если НачалоПериода = Неопределено И ОкончаниеПериода = Неопределено Тогда
			ОбъемРабот = ОбъемРабот 
							+ (Мин(Окончание, СтрокаГрафикРаботы.Окончание) 
								- Макс(Начало, СтрокаГрафикРаботы.Начало)) + 1;
		Иначе
			ОбъемРабот = ОбъемРабот 
							+ (Мин(Окончание, ОкончаниеПериода, СтрокаГрафикРаботы.Окончание) 
								- Макс(Начало, НачалоПериода, СтрокаГрафикРаботы.Начало)) + 1;
		КонецЕсли; 
		
		НачалоВРабочееВремя = Макс(Начало, СтрокаГрафикРаботы.Начало);
		ОкончаниеВРабочееВремя = Мин(Окончание, СтрокаГрафикРаботы.Окончание);
		
		ВремяРаботыВРабочееВремяВПериоде = (ОкончаниеВРабочееВремя - НачалоВРабочееВремя) + 1;
		ВремяРаботыВРабочееВремя = ВремяРаботыВРабочееВремя + ВремяРаботыВРабочееВремяВПериоде;
		
		// Определим занятый период 
		ДанныеПериода = Новый Структура;
		ДанныеПериода.Вставить("Начало", НачалоВРабочееВремя);
		ДанныеПериода.Вставить("Окончание", ОкончаниеВРабочееВремя);
		
		ВремяРаботыВПериоде = (ДанныеПериода.Окончание - ДанныеПериода.Начало) + 1;
		ДанныеПериода.Вставить("ВремяРаботы", ВремяРаботыВПериоде);
		ДанныеПериода.Вставить("ВремяРаботыВРабочееВремя", ВремяРаботыВРабочееВремяВПериоде);
		ПериодыВыполнения.Добавить(ДанныеПериода);
		
	КонецЦикла;
	
	// Учтем время не попавшее в график работы
	НачалоПопалоВГрафик    = Ложь;
	ОкончаниеПопалоВГрафик = Ложь;
	НачалоВнеГрафика       = Неопределено;
	ОкончаниеВнеГрафика    = Неопределено;
	Для каждого СтрокаГрафикРаботы Из ГрафикРаботы Цикл
		
		Если Начало > СтрокаГрафикРаботы.Окончание Тогда
			// Строка графика вне текущего периода
			Продолжить;
		КонецЕсли;
		
		Если Окончание < СтрокаГрафикРаботы.Начало Тогда
			// Следующие строки вне текущего периода
			Прервать;
		КонецЕсли;
		
		Если Начало >= СтрокаГрафикРаботы.Начало И Начало <= СтрокаГрафикРаботы.Окончание Тогда
			НачалоПопалоВГрафик = Истина;
		КонецЕсли;
		Если Окончание > СтрокаГрафикРаботы.Начало И Окончание <= СтрокаГрафикРаботы.Окончание Тогда
			ОкончаниеПопалоВГрафик = Истина;
		КонецЕсли;
		
		Если НЕ НачалоПопалоВГрафик И ОкончаниеВнеГрафика = Неопределено Тогда
			ОкончаниеВнеГрафика = СтрокаГрафикРаботы.Начало;
		КонецЕсли;
		
		Если СтрокаГрафикРаботы.Окончание < Окончание Тогда
			НачалоВнеГрафика = Мин(СтрокаГрафикРаботы.Окончание, Окончание);
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ НачалоПопалоВГрафик 
		И НЕ ОкончаниеПопалоВГрафик 
		И ОкончаниеВнеГрафика = Неопределено
		И НачалоВнеГрафика = Неопределено Тогда
		
		Если НачалоПериода = Неопределено И ОкончаниеПериода = Неопределено Тогда
			
			НачалоПериодаВнеГрафика = Начало;
			ОкончаниеПериодаВнеГрафика = Окончание;
			
		Иначе
			
			НачалоПериодаВнеГрафика = Макс(Начало, НачалоПериода);
			ОкончаниеПериодаВнеГрафика = Мин(Окончание, ОкончаниеПериода);
			
		КонецЕсли;
		
		ОбъемРабот = ОбъемРабот + (ОкончаниеПериодаВнеГрафика - НачалоПериодаВнеГрафика) + 1;
		
		ДанныеПериода = Новый Структура;
		ДанныеПериода.Вставить("Начало", НачалоПериодаВнеГрафика);
		ДанныеПериода.Вставить("Окончание", ОкончаниеПериодаВнеГрафика);
		
		ВремяРаботыВПериоде = (ДанныеПериода.Окончание - ДанныеПериода.Начало) + 1;
		ДанныеПериода.Вставить("ВремяРаботы", ВремяРаботыВПериоде);
		ДанныеПериода.Вставить("ВремяРаботыВРабочееВремя", 0);
		ПериодыВыполнения.Добавить(ДанныеПериода);
		
	Иначе
		
		Если НЕ НачалоПопалоВГрафик Тогда
			
			НачалоПериодаВнеГрафика = Неопределено;
			ОкончаниеПериодаВнеГрафика = Неопределено;
			
			Если НачалоПериода = Неопределено И ОкончаниеПериода = Неопределено Тогда
				
				НачалоПериодаВнеГрафика = Начало;
				ОкончаниеПериодаВнеГрафика = ?(ОкончаниеВнеГрафика <> Неопределено, ОкончаниеВнеГрафика, Окончание);
				
			ИначеЕсли ?(ОкончаниеВнеГрафика <> Неопределено, ОкончаниеВнеГрафика, Окончание) > НачалоПериода Тогда 
				
				НачалоПериодаВнеГрафика = Макс(Начало, НачалоПериода);
				ОкончаниеПериодаВнеГрафика = Мин(?(ОкончаниеВнеГрафика <> Неопределено, ОкончаниеВнеГрафика, Окончание), ОкончаниеПериода);
				
			КонецЕсли;
			
			Если НачалоПериодаВнеГрафика <> Неопределено И ОкончаниеПериодаВнеГрафика <> Неопределено Тогда
				ОбъемРабот = ОбъемРабот + (ОкончаниеПериодаВнеГрафика - НачалоПериодаВнеГрафика);
				
				ДанныеПериода = Новый Структура;
				ДанныеПериода.Вставить("Начало", НачалоПериодаВнеГрафика);
				ДанныеПериода.Вставить("Окончание", ОкончаниеПериодаВнеГрафика);
				
				ВремяРаботыВПериоде = (ДанныеПериода.Окончание - ДанныеПериода.Начало) + 1;
				ДанныеПериода.Вставить("ВремяРаботы", ВремяРаботыВПериоде);
				ДанныеПериода.Вставить("ВремяРаботыВРабочееВремя", 0);
				ПериодыВыполнения.Добавить(ДанныеПериода);
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ ОкончаниеПопалоВГрафик Тогда
			
			НачалоПериодаВнеГрафика = Неопределено;
			ОкончаниеПериодаВнеГрафика = Неопределено;
			
			Если НачалоПериода = Неопределено И ОкончаниеПериода = Неопределено Тогда
				
				НачалоПериодаВнеГрафика = ?(НачалоВнеГрафика <> Неопределено, НачалоВнеГрафика, Начало);
				ОкончаниеПериодаВнеГрафика = Окончание;
				
			ИначеЕсли ?(НачалоВнеГрафика <> Неопределено, НачалоВнеГрафика, Начало) > ОкончаниеПериода Тогда 
				
				НачалоПериодаВнеГрафика = Макс(?(НачалоВнеГрафика <> Неопределено, НачалоВнеГрафика, Начало), НачалоПериода);
				ОкончаниеПериодаВнеГрафика = Мин(Окончание, ОкончаниеПериода);
				
			КонецЕсли;
			
			Если НачалоПериодаВнеГрафика <> Неопределено И ОкончаниеПериодаВнеГрафика <> Неопределено Тогда
				ОбъемРабот = ОбъемРабот + (ОкончаниеПериодаВнеГрафика - НачалоПериодаВнеГрафика);
				
				ДанныеПериода = Новый Структура;
				ДанныеПериода.Вставить("Начало", НачалоПериодаВнеГрафика);
				ДанныеПериода.Вставить("Окончание", ОкончаниеПериодаВнеГрафика);
				
				ВремяРаботыВПериоде = (ДанныеПериода.Окончание - ДанныеПериода.Начало) + 1;
				ДанныеПериода.Вставить("ВремяРаботы", ВремяРаботыВПериоде);
				ДанныеПериода.Вставить("ВремяРаботыВРабочееВремя", 0);
				ПериодыВыполнения.Добавить(ДанныеПериода);
			КонецЕсли; 

		КонецЕсли;
		
	КонецЕсли;
	
    Возврат ОбъемРабот;
	
КонецФункции

#Область МаршрутныйЛист

// Заполняет табличные части маршрутного листа "РаспоряжениеСпецификация" и "РаспоряжениеТрудозатраты".
//
// Параметры:
//  Объект - ДокументОбъект.МаршрутныйЛистПроизводства - заполняемый документ.
//
Процедура ЗаполнитьДанныеРаспоряженияМаршрутногоЛиста(Объект) Экспорт
	
	ВыходныеИзделия  = Объект.ВыходныеИзделия;
	ВозвратныеОтходы = Объект.ВозвратныеОтходы;
	
	СписокСвойствПродукции = "Номенклатура,Характеристика,Получатель,Назначение";
		
	СтруктураПоискаПродукции = Новый Структура(СписокСвойствПродукции);
	
	РаспоряжениеСпецификация = Объект.РаспоряжениеСпецификация;
	
	// Обнулим количество по маршрутному листу
	Для каждого ДанныеСтроки Из РаспоряжениеСпецификация Цикл
		ДанныеСтроки.Количество = 0;
	КонецЦикла;
	
	Для каждого ДанныеСтроки Из ВыходныеИзделия Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоискаПродукции, ДанныеСтроки);
		СписокСтрок = РаспоряжениеСпецификация.НайтиСтроки(СтруктураПоискаПродукции);
		
		Если СписокСтрок.Количество() = 0 Тогда
			СтрокаПлан = РаспоряжениеСпецификация.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПлан, ДанныеСтроки, СписокСвойствПродукции);
		Иначе
			СтрокаПлан = СписокСтрок[0];
		КонецЕсли;
		
		СтрокаПлан.Количество = СтрокаПлан.Количество + ДанныеСтроки.Количество;
		
	КонецЦикла;
	
	Для каждого ДанныеСтроки Из ВозвратныеОтходы Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоискаПродукции, ДанныеСтроки);
		СписокСтрок = РаспоряжениеСпецификация.НайтиСтроки(СтруктураПоискаПродукции);
		
		Если СписокСтрок.Количество() = 0 Тогда
			СтрокаПлан = РаспоряжениеСпецификация.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПлан, ДанныеСтроки, СписокСвойствПродукции);
		Иначе
			СтрокаПлан = СписокСтрок[0];
		КонецЕсли;
		
		СтрокаПлан.Количество = СтрокаПлан.Количество + ДанныеСтроки.Количество;
		
	КонецЦикла;
	
	// Удалим строки в которых нулевое количество по заказу и по маршрутному листу
	СписокСтрок = РаспоряжениеСпецификация.НайтиСтроки(Новый Структура("Количество,КоличествоПоЗаказу", 0, 0));
	Для каждого СтрокаПлан Из СписокСтрок Цикл
		РаспоряжениеСпецификация.Удалить(СтрокаПлан);
	КонецЦикла; 
	
	// Рассчитаем отклонение от заказа
	Для каждого ДанныеСтроки Из РаспоряжениеСпецификация Цикл
		ДанныеСтроки.КоличествоОтклонение = ДанныеСтроки.Количество - ДанныеСтроки.КоличествоПоЗаказу;
	КонецЦикла;
	
	Трудозатраты             = Объект.Трудозатраты;
	РаспоряжениеТрудозатраты = Объект.РаспоряжениеТрудозатраты;
	
	// Обнулим количество по маршрутному листу
	Для каждого ДанныеСтроки Из РаспоряжениеТрудозатраты Цикл
		ДанныеСтроки.Количество = 0;
	КонецЦикла;
	
	Для каждого ДанныеСтроки Из Трудозатраты Цикл
		
		СписокСтрок = РаспоряжениеТрудозатраты.НайтиСтроки(Новый Структура("ВидРабот", ДанныеСтроки.ВидРабот));
		Если СписокСтрок.Количество() = 0 Тогда
			СтрокаПлан = РаспоряжениеТрудозатраты.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПлан, ДанныеСтроки, "ВидРабот");
		Иначе
			СтрокаПлан = СписокСтрок[0];
		КонецЕсли;
		
		СтрокаПлан.Количество = СтрокаПлан.Количество + ДанныеСтроки.Количество;
		
	КонецЦикла;
	
	// Удалим строки в которых нулевое количество по заказу и по маршрутному листу
	СписокСтрок = РаспоряжениеТрудозатраты.НайтиСтроки(Новый Структура("Количество,КоличествоПоЗаказу", 0, 0));
	Для каждого СтрокаПлан Из СписокСтрок Цикл
		РаспоряжениеТрудозатраты.Удалить(СтрокаПлан);
	КонецЦикла; 
	
	// Рассчитаем отклонение от заказа
	Для каждого ДанныеСтроки Из РаспоряжениеТрудозатраты Цикл
		ДанныеСтроки.КоличествоОтклонение = ДанныеСтроки.Количество - ДанныеСтроки.КоличествоПоЗаказу;
	КонецЦикла;
	
	РаспоряжениеТрудозатраты.Сортировать("ВидРабот");
	
КонецПроцедуры

#КонецОбласти

#Область ПереработкаНаСтороне

// Заполняет табличные части "РаспоряжениеСпецификация" и "РаспоряжениеТрудозатраты" в заказе переработчику.
//
// Параметры:
//  Объект - ДокументОбъект.ЗаказПереработчику - заполняемый документ.
//  ТипСтрокиПоступление - ПеречислениеСсылка.ТипыДвиженияЗапасов - тип движения (поступление).
//  ТипСтрокиОтгрузка - ПеречислениеСсылка.ТипыДвиженияЗапасов - тип движения (отгрузка).
//
Процедура ЗаполнитьДанныеРаспоряженияЗаказаПереработчику(Объект, ТипСтрокиПоступление, ТипСтрокиОтгрузка) Экспорт
	
	Если Объект.ГруппировкаЗатрат <> ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЗаказамНаПроизводство") Тогда
		Возврат;
	КонецЕсли; 
	
	ВыходныеИзделия  = Объект.Продукция;
	МатериалыИУслуги = Объект.Материалы;
	ВозвратныеОтходы = Объект.ВозвратныеОтходы;
	
	СписокСвойствМатериалов = "Номенклатура, Характеристика, Склад, ВариантОбеспечения, Назначение, НомерГруппыЗатрат";
	СписокСвойствПродукции  = "Номенклатура, Характеристика, Склад, НомерГруппыЗатрат";
	СписокСвойствЗаполнения = "Номенклатура, Характеристика, НомерГруппыЗатрат";
	
	СтруктураПоискаПродукции = Новый Структура(СписокСвойствПродукции);
	СтруктураПоискаПродукции.Вставить("ТипДвиженияЗапасов", ТипСтрокиПоступление);
	
	РаспоряжениеСпецификация = Объект.РаспоряжениеСпецификация;
	
	// Обнулим количество по заказу переработчику
	Для каждого ДанныеСтроки Из РаспоряжениеСпецификация Цикл
		ДанныеСтроки.Количество = 0;
	КонецЦикла;
	
	Для каждого ДанныеСтроки Из ВыходныеИзделия Цикл
		
		Если ДанныеСтроки.Отменено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоискаПродукции, ДанныеСтроки);
		СтруктураПоискаПродукции.Склад = ДанныеСтроки.Получатель;
		
		СписокСтрок = РаспоряжениеСпецификация.НайтиСтроки(СтруктураПоискаПродукции);
		
		Если СписокСтрок.Количество() = 0 Тогда
			СтрокаПлан = РаспоряжениеСпецификация.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПлан, ДанныеСтроки, СписокСвойствЗаполнения);
			СтрокаПлан.Склад              = ДанныеСтроки.Получатель;
			СтрокаПлан.ТипДвиженияЗапасов = ТипСтрокиПоступление;
			СтрокаПлан.ЗаказатьНаСклад    = Истина;
		Иначе
			СтрокаПлан = СписокСтрок[0];
		КонецЕсли;
		
		СтрокаПлан.Количество = СтрокаПлан.Количество + ДанныеСтроки.Количество;
		
	КонецЦикла;
	
	Для каждого ДанныеСтроки Из ВозвратныеОтходы Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоискаПродукции, ДанныеСтроки);
		СтруктураПоискаПродукции.Склад = ДанныеСтроки.Получатель;
		
		СписокСтрок = РаспоряжениеСпецификация.НайтиСтроки(СтруктураПоискаПродукции);
		
		Если СписокСтрок.Количество() = 0 Тогда
			СтрокаПлан = РаспоряжениеСпецификация.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПлан, ДанныеСтроки, СписокСвойствЗаполнения);
			СтрокаПлан.Склад              = ДанныеСтроки.Получатель;
			СтрокаПлан.ТипДвиженияЗапасов = ТипСтрокиПоступление;
			СтрокаПлан.ЗаказатьНаСклад    = Истина;
		Иначе
			СтрокаПлан = СписокСтрок[0];
		КонецЕсли;
		
		СтрокаПлан.Количество = СтрокаПлан.Количество + ДанныеСтроки.Количество;
		
	КонецЦикла;
	
	СтруктураПоискаМатериалов = Новый Структура(СписокСвойствМатериалов);
	СтруктураПоискаМатериалов.Вставить("ТипДвиженияЗапасов", ТипСтрокиОтгрузка);
	Для каждого ДанныеСтроки Из МатериалыИУслуги Цикл
		
		КоличествоРаспределить = ДанныеСтроки.Количество;
		Если ДанныеСтроки.Отменено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоискаМатериалов, ДанныеСтроки);
		СписокСтрок = РаспоряжениеСпецификация.НайтиСтроки(СтруктураПоискаМатериалов);
		
		Если СписокСтрок.Количество() = 0 Тогда
			СтрокаПлан = РаспоряжениеСпецификация.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПлан, ДанныеСтроки, СписокСвойствМатериалов);
			СтрокаПлан.ТипДвиженияЗапасов = ТипСтрокиОтгрузка;
			СтрокаПлан.ЗаказатьНаСклад = Истина;
		Иначе
			Для Счетчик = 0 По СписокСтрок.Количество() - 2 Цикл
				
				СтрокаПлан = СписокСтрок[Счетчик];
				РаспределитьТекущуюСтроку = Мин(СтрокаПлан.КоличествоПоЗаказу - СтрокаПлан.Количество);
				Если КоличествоРаспределить > 0 И РаспределитьТекущуюСтроку > 0 Тогда
					СтрокаПлан.Количество = СтрокаПлан.Количество + РаспределитьТекущуюСтроку;
					КоличествоРаспределить = КоличествоРаспределить - РаспределитьТекущуюСтроку;
				КонецЕсли;
				
			КонецЦикла;
			СтрокаПлан = СписокСтрок[СписокСтрок.Количество() - 1];
		КонецЕсли;
		
		СтрокаПлан.Количество = СтрокаПлан.Количество + КоличествоРаспределить;
		
	КонецЦикла;
	
	// Удалим строки в которых нулевое количество по заказу и по заказу переработчику
	СписокСтрок = РаспоряжениеСпецификация.НайтиСтроки(Новый Структура("Количество,КоличествоПоЗаказу", 0, 0));
	Для каждого СтрокаПлан Из СписокСтрок Цикл
		РаспоряжениеСпецификация.Удалить(СтрокаПлан);
	КонецЦикла; 
	
	// Рассчитаем отклонение от заказа
	Для каждого ДанныеСтроки Из РаспоряжениеСпецификация Цикл
		ДанныеСтроки.КоличествоОтклонение = ДанныеСтроки.Количество - ДанныеСтроки.КоличествоПоЗаказу;
	КонецЦикла;
	
	РаспоряжениеСпецификация.Сортировать("ТипДвиженияЗапасов Убыв"); // чтобы изделия были сверху
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВремяПереналадки(ТекущийВариантНаладки, СледующийВариантНаладки, НастройкаПереналадки) Экспорт

	СтруктураПоиска = Новый Структура("ТекущийВариантНаладки, СледующийВариантНаладки", 
										ТекущийВариантНаладки, СледующийВариантНаладки);
										
 	СписокСтрок = НастройкаПереналадки.НайтиСтроки(СтруктураПоиска);
	
	ВремяПереналадкиСек = 0;
	ТекущийПриоритет = 100;
	Для каждого ТекущаяНастройкаПереналадки Из СписокСтрок Цикл
		Если ТекущаяНастройкаПереналадки.Приоритет < ТекущийПриоритет Тогда
			ВремяПереналадкиСек  = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВСекундах(
										ТекущаяНастройкаПереналадки.ВремяПереналадки, 
										ТекущаяНастройкаПереналадки.ЕдиницаВремениПереналадки);

			ТекущийПриоритет = ТекущаяНастройкаПереналадки.Приоритет;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат ВремяПереналадкиСек;

КонецФункции

Процедура УстановитьДатуПоОтметке(Отметка, ПолеДата, ДатаСобытия) Экспорт
	
	Если НЕ Отметка И ПолеДата <> '000101010000' Тогда
		ПолеДата  = '000101010000';
	ИначеЕсли Отметка И ПолеДата = '000101010000' Тогда
		ПолеДата = ДатаСобытия;
	КонецЕсли;

КонецПроцедуры

// Выполняет необходимые действия с объектом при изменении отметки прохождения маршрута
// Процедуру необходимо вызывать при изменении маршрута маршрутного листа.
//
Процедура ПриИзмененииМаршрута(Объект, НачатоВыполнение, ДатаСобытия) Экспорт
	
	Если Объект.ПланироватьРаботуВидовРабочихЦентров Тогда
		
		// Запомним даты чтобы при необходимости сбросить затраты буферов
		ДатаВыполненияРаботВПредварительномБуфереДоИзменения = Объект.ДатаВыполненияРаботВПредварительномБуфере;
		ДатаВыполненияРаботВЗавершающемБуфереДоИзменения     = Объект.ДатаВыполненияРаботВЗавершающемБуфере;
		
		УстановитьДатуПоОтметке(
					НачатоВыполнение, 
					Объект.ФактическоеНачало,
					ДатаСобытия);
		
		УстановитьДатуПоОтметке(
					Объект.ГотовоКРаботеКлючевогоРабочегоЦентра, 
					Объект.ДатаВыполненияРаботВПредварительномБуфере,
					ДатаСобытия);
					
		УстановитьДатуПоОтметке(
					Объект.ЗавершенаРаботаКлючевогоРабочегоЦентра, 
					Объект.ФактическоеОкончаниеРаботыКлючевогоРабочегоЦентра,
					ДатаСобытия);
					
		УстановитьДатуПоОтметке(
					Объект.ЗавершеноВыполнениеМаршрутногоЛиста, 
					Объект.ДатаВыполненияРаботВЗавершающемБуфере,
					ДатаСобытия);

		УстановитьДатуПоОтметке(
					Объект.ЗавершеноВыполнениеМаршрутногоЛиста, 
					Объект.ФактическоеОкончание,
					ДатаСобытия);
					
		// Если даты изменились то нужно сбросить затраты буферов, чтобы рассчитать их заново.
		Если ДатаВыполненияРаботВПредварительномБуфереДоИзменения <> Объект.ДатаВыполненияРаботВПредварительномБуфере Тогда
			Объект.ЗатраченоВремениОтПредварительногоБуфера = 0;
		КонецЕсли; 
		Если ДатаВыполненияРаботВЗавершающемБуфереДоИзменения <> Объект.ДатаВыполненияРаботВЗавершающемБуфере Тогда
			Объект.ЗатраченоВремениОтЗавершающегоБуфера = 0;
		КонецЕсли; 
		
	Иначе
		
		// Запомним дату чтобы при необходимости сбросить затраты буфера
		ФактическоеОкончаниеДоИзменения = Объект.ФактическоеОкончание;
		
		УстановитьДатуПоОтметке(
					НачатоВыполнение, 
					Объект.ФактическоеНачало,
					ДатаСобытия);
		
		УстановитьДатуПоОтметке(
					Объект.ЗавершеноВыполнениеМаршрутногоЛиста, 
					Объект.ФактическоеОкончание,
					ДатаСобытия);
					
		// Если дата изменились то нужно сбросить затраты буфера, чтобы рассчитать его заново.
		Если ФактическоеОкончаниеДоИзменения <> Объект.ФактическоеОкончание Тогда
			Объект.ЗатраченоВремениОтДлительностиЭтапа = 0;
		КонецЕсли; 
		
	КонецЕсли; 
	
	УстановитьСтатусПоМаршруту(Объект, НачатоВыполнение);
	
КонецПроцедуры

Процедура ПроверитьОтклонение(ДанныеСтроки) Экспорт

	Если ДанныеСтроки.Количество + ДанныеСтроки.КоличествоОтклонение < 0 Тогда
		ДанныеСтроки.КоличествоОтклонение = 0;
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьСтатусПоМаршруту(Объект, НачатоВыполнение)

	Если Объект.ЗавершеноВыполнениеМаршрутногоЛиста Тогда
		
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполнен");
		
	ИначеЕсли НЕ Объект.ЗавершеноВыполнениеМаршрутногоЛиста
		И НачатоВыполнение
		И Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполнен") Тогда
		
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполняется");
		
	ИначеЕсли (НачатоВыполнение
				ИЛИ Объект.ГотовоКРаботеКлючевогоРабочегоЦентра
				ИЛИ Объект.ЗавершенаРаботаКлючевогоРабочегоЦентра)
		И (Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Создан")
			ИЛИ Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.КВыполнению")) Тогда
		
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполняется");
		
	ИначеЕсли НЕ НачатоВыполнение 
		И (Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполняется")
			ИЛИ Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполнен")) Тогда
		
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.КВыполнению");
		
	КонецЕсли;

	ЗаполнитьПроизведеноЕслиМаршрутныйЛистВыполнен(Объект);
	
КонецПроцедуры

Процедура ЗаполнитьПроизведеноЕслиМаршрутныйЛистВыполнен(Объект)

	Если (Объект.Произведено + Объект.Брак) = 0
		И Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполнен") Тогда
		
		Объект.Произведено = Объект.Запланировано;
		
		СписокТЧ = Новый Массив;
		СписокТЧ.Добавить("ВыходныеИзделия");
		СписокТЧ.Добавить("ВозвратныеОтходы");
		Для каждого ИмяТЧ Из СписокТЧ Цикл
			Для каждого СтрокаТабличнойЧасти Из Объект[ИмяТЧ] Цикл
				
				Если СтрокаТабличнойЧасти.КоличествоФакт <> 0 Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаТабличнойЧасти.КоличествоФакт = СтрокаТабличнойЧасти.Количество;
				СтрокаТабличнойЧасти.КоличествоУпаковокФакт = СтрокаТабличнойЧасти.КоличествоУпаковок;
				
				СтрокаТабличнойЧасти.КоличествоОтклонение = 0;
				СтрокаТабличнойЧасти.КоличествоУпаковокОтклонение = 0;
				
			КонецЦикла; 
		КонецЦикла; 
		
	КонецЕсли;

КонецПроцедуры

// Проверяет, что указанный период не конфликтует с расписанием
//
// Параметры:
//	Начало 						- Дата - Начало периода выполнения
//	Окончание 					- Дата - Окончание периода выполнения
//  ВариантНаладки 				- СправочникСсылка.ВариантыНаладки - применяемый вариант наладки
//  РасписаниеРабочихЦентров	- Массив - содержит структуру данных расписания
//  СообщитьОбОшибке			- Булево - Истина, если нужно сообщить об ошибке
//  Отказ						- Булево - Истина, если найдены ошибки.
//
// Возвращаемое значение:
//   Булево   - Ложь, если найдены ошибки.
//
Функция ПроверитьПериодВыполнения(Начало, Окончание, ВариантНаладки, РасписаниеРабочихЦентров, СообщитьОбОшибке = Истина, Отказ = Ложь) Экспорт

	Для каждого ДанныеСтрокиРасписания Из РасписаниеРабочихЦентров Цикл
		Если Начало <= ДанныеСтрокиРасписания.Окончание
			И Окончание >= ДанныеСтрокиРасписания.Начало
			И ДанныеСтрокиРасписания.ВариантНаладки <> ВариантНаладки Тогда
			
			Если СообщитьОбОшибке Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											НСтр("ru = 'В указанном периоде запланировано выполнение маршрутного листа %1 с другим вариантом наладки.
														|В одном периоде допускается выполнение маршрутных листов с одинаковым вариантом наладки.';
														|en = 'Execution of route sheet %1 is planned with a different setup option in the specified period.
														|Only route sheet execution with the same setup option is allowed within one period.'"),
											ДанныеСтрокиРасписания.МаршрутныйЛистСтрока);
											
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
			КонецЕсли; 
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#Область ПооперационноеПланирование

// Выполняет расчет общего времени выполнения операции на основании штучного времени и времени ПЗ. 
// В качестве единицы измерения общего времени устанавливается наибольшая из двух единиц: времени
// штучного и времени ПЗ.
//
// Параметры:
//  ТекущиеДанные - Произвольный - коллекция, содержащая данные, необходимые для расчета:
//		* ВремяШтучное - Число - время выполнения операции для одной единицы/партии изделий.
//		* ВремяШтучноеЕдИзм - ПеречислениеСсылка.ЕдиницыИзмеренияВремени - единица измерения штучного времени.
//		* ВремяПЗ - Число - подготовительно-заключительное время.
//		* ВремяПЗЕдИзм - ПеречислениеСсылка.ЕдиницыИзмеренияВремени - единица измерения подготовительно-заключительного времени.
//		* ВремяВыполнения - Число - общее время выполнения операции.
//		* ВремяВыполненияЕдИзм - ПеречислениеСсылка.ЕдиницыИзмеренияВремени - единица измерения общего времени.
//		* ПараллельнаяЗагрузка - Булево - флаг параллельной загрузки рабочего центра.
//	ЕдиницПартийИзделий - Число - количество производимых единиц/партий изделий.
//
Процедура РассчитатьОбщееВремяВыполненияОперации(ТекущиеДанные, ЕдиницПартийИзделий) Экспорт

	Если НЕ ТекущиеДанные.ПараллельнаяЗагрузка Тогда
		ВремяПартии = ТекущиеДанные.ВремяШтучное * ЕдиницПартийИзделий;
	Иначе
		ВремяПартии = ТекущиеДанные.ВремяШтучное;
	КонецЕсли;
	
	ВремяПЗ = ТекущиеДанные.ВремяПЗ;
	
	ВремяПартии = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВСекундах(ВремяПартии, ТекущиеДанные.ВремяШтучноеЕдИзм);
	ВремяПЗ     = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВСекундах(ВремяПЗ, ТекущиеДанные.ВремяПЗЕдИзм);
	
	ВремяВыполненияЕдИзм = ЕдиницаИзмеренияОбщегоВремени(ТекущиеДанные);
	
	ТекущиеДанные.ВремяВыполненияЕдИзм = ВремяВыполненияЕдИзм;
	ТекущиеДанные.ВремяВыполнения      = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВЕдиницеИзмерения(
		ВремяПартии + ВремяПЗ, ВремяВыполненияЕдИзм);
	
КонецПроцедуры

// Возвращает структуру содержащую данные необходимые для расчета общего времени выполнения операции.
// 
// Возвращаемое значение:
//   - Структура - структура данных.
//
Функция СтруктураРасчетаОбщегоВремениВыполнения() Экспорт
	
	Возврат Новый Структура(
					"ВремяШтучное,
					|ВремяШтучноеЕдИзм,
					|ВремяПЗ,
					|ВремяПЗЕдИзм,
					|ПараллельнаяЗагрузка,
					|ВремяВыполнения,
					|ВремяВыполненияЕдИзм");
	
КонецФункции

Функция ЕдиницаИзмеренияОбщегоВремени(ТекущиеДанные)
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ВремяШтучноеЕдИзм) И ЗначениеЗаполнено(ТекущиеДанные.ВремяПЗЕдИзм) Тогда
		
		Если ТекущиеДанные.ВремяШтучноеЕдИзм = ТекущиеДанные.ВремяПЗЕдИзм Тогда
			
			Результат = ТекущиеДанные.ВремяШтучноеЕдИзм;
			
		Иначе
			
			ВеличинаШтучное = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВСекундах(1, ТекущиеДанные.ВремяШтучноеЕдИзм);
			ВеличинаПЗ = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВСекундах(1, ТекущиеДанные.ВремяПЗЕдИзм);
			Результат = ?(ВеличинаШтучное>ВеличинаПЗ, ТекущиеДанные.ВремяШтучноеЕдИзм, ТекущиеДанные.ВремяПЗЕдИзм);
			
		КонецЕсли;
		
	Иначе
		
		Результат = ?(ЗначениеЗаполнено(ТекущиеДанные.ВремяПЗЕдИзм),
			ТекущиеДанные.ВремяПЗЕдИзм,
			ТекущиеДанные.ВремяШтучноеЕдИзм);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
