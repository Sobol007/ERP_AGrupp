#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗаблокироватьДанные();
		ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСПринятыКУчету(ЭтотОбъект, Отказ);
		ВнеоборотныеАктивыСлужебный.ПроверитьВозможностьПринятияКУчетуОС(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Если ОтражатьВУпрУчете И ОтражатьВРеглУчете Тогда
		ДокументВДругомУчете = Неопределено;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПередЗаписью();
	
	РазукомплектацияОСЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.РазукомплектацияОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	РазукомплектацияОСЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	РазукомплектацияОСЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокументПередЗаполнением();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.РазукомплектацияОС") Тогда
		ЗаполнитьНаОснованииРазукомплектации(ДанныеЗаполнения);
	КонецЕсли;
	
	РазукомплектацияОСЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьУУ");
	
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
		
	ВспомогательныеРеквизиты = ВспомогательныеРеквизиты();
		
	ПараметрыРеквизитовОбъекта = 
		ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_РазукомплектацияОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ВнеоборотныеАктивыСлужебный.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов);
	
	ПроверитьТаблицуОсновныхСредств(ВспомогательныеРеквизиты, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	РазукомплектацияОСЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.РазукомплектацияОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	РазукомплектацияОСЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РазукомплектацияОСЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокументПередЗаполнением()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ОтражатьВУпрУчете = Истина;
	ОтражатьВРеглУчете = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Основание)

	Если Основание.Свойство("ОсновноеСредство") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание.ОсновноеСредство);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание)
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ЭтоГруппа");
	
	Если РеквизитыОснования.ЭтоГруппа Тогда
		
		ТекстСообщения = НСтр("ru = 'Разукомплектация группы ОС невозможна.
			|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз.';
			|en = 'Cannot disassemble FA group.
			| Select a FA. To expand the group, press Ctrl + down arrow.'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ПервоначальныеСведения = ВнеоборотныеАктивыСлужебный.СообщитьЕслиОСНеПринятоКУчету(Основание, Дата);
	
	Организация = ПервоначальныеСведения.Организация;
	Подразделение = ПервоначальныеСведения.Местонахождение;
	
	ОсновноеСредство = Основание;
	
	ОтражатьВУпрУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ);
	ОтражатьВРеглУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииРазукомплектации(Основание, ОсновноеСредство = Неопределено)

	ОснованиеОбъект = Основание.ПолучитьОбъект();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОснованиеОбъект,, "Номер,Дата,ВерсияДанных,Ответственный,ПометкаУдаления,Проведен");
	
	ДокументВДругомУчете = Основание;
	
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		ОсновноеСредство = ОснованиеОбъект.ОсновноеСредство;
	КонецЕсли; 
	
	
	Если ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА() Тогда
		Если ОснованиеОбъект.ОтражатьВРеглУчете Тогда
			ОтражатьВРеглУчете = Ложь;
			ОтражатьВУпрУчете  = Истина;
		Иначе
			ОтражатьВРеглУчете = Истина;
			ОтражатьВУпрУчете  = Ложь;
		КонецЕсли; 
	Иначе	
		ОтражатьВРеглУчете = Истина;
		ОтражатьВУпрУчете  = Истина;
	КонецЕсли;
	
	ОС.Загрузить(ОснованиеОбъект.ОС.Выгрузить());
	
	Если Константы.ВалютаУправленческогоУчета.Получить() = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		
		Для каждого ДанныеСтроки Из ОС Цикл
			Если ОтражатьВРеглУчете Тогда
				ДанныеСтроки.СтоимостьБУ = ДанныеСтроки.СтоимостьУУ;
				ДанныеСтроки.СтоимостьНУ = ДанныеСтроки.СтоимостьУУ;
			ИначеЕсли ОтражатьВУпрУчете Тогда
				ДанныеСтроки.СтоимостьУУ = ?(ДанныеСтроки.СтоимостьБУ <> 0, ДанныеСтроки.СтоимостьБУ, ДанныеСтроки.СтоимостьНУ);
			КонецЕсли; 
		КонецЦикла; 
		
	КонецЕсли; 
	
	ОчиститьНеиспользуемыеРеквизиты();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаблокироватьДанные()

	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПервоначальныеСведенияОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.МестонахождениеОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	Блокировка.Заблокировать(); 
	
КонецПроцедуры

Процедура ПроверитьТаблицуОсновныхСредств(ВспомогательныеРеквизиты, Отказ)

	ВнеоборотныеАктивыСлужебный.ПроверитьРеквизитыОСПриПринятииКУчету(ЭтотОбъект, "ОС", Отказ);
	
	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		
		ДанныеСтроки = ОС.Найти(ОсновноеСредство, "ОсновноеСредство");
		Если ДанныеСтроки <> Неопределено Тогда
			
			ТекстСообщения = НСтр("ru = 'Основное средство уже принято к учету';
									|en = 'Fixed asset has already been entered in the books'");
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
			
		КонецЕсли; 
		
		// Проверка группы ОС и направления деятельности у принимаемых к учету ОС.
		СписокОС = ОС.ВыгрузитьКолонку("ОсновноеСредство");
		РезультатПроверки = Документы.РазукомплектацияОС.ПроверитьВыборОсновныхСредств(ОсновноеСредство, СписокОС);
		Если РезультатПроверки.ПроблемныеОС.Количество() <> 0 Тогда
			
			ШаблонСообщения = РазукомплектацияОСЛокализация.ШаблонСообщенияПроверкиОС(РезультатПроверки);
			Если ШаблонСообщения = Неопределено Тогда
				ШаблонСообщения = НСтр("ru = 'У принимаемого к учету основного средства ""%1"" должно быть аналогичное направление деятельности';
										|en = 'The ""%1"" fixed asset being entered in the books must have similar line of business'");
			КонецЕсли; 
			
			Для каждого ДанныеСтроки Из ОС Цикл
				Если РезультатПроверки.ПроблемныеОС.Найти(ДанныеСтроки.ОсновноеСредство) <> Неопределено Тогда
					ТекстСообщения = СтрШаблон(ШаблонСообщения, Строка(ДанныеСтроки.ОсновноеСредство));
					Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли; 
	
	// Проверка заполнения табличной части
	
	ШаблонСообщенияСтоимостьРегл = НСтр("ru = 'Для основного средства ""%1"" необходимо указать стоимость в валюте регл.';
										|en = 'Specify cost in the currency of compl. for the ""%1"" fixed asset'");
	
	Если НЕ ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА Тогда
		ШаблонСообщенияСтоимостьУпр = НСтр("ru = 'Для основного средства ""%1"" необходимо указать стоимость в валюте упр.';
											|en = 'Specify cost in man. accounting for the ""%1"" fixed asset'");
	Иначе
		ШаблонСообщенияСтоимостьУпр = НСтр("ru = 'Для основного средства ""%1"" необходимо указать стоимость в управленческом учете';
											|en = 'Specify cost in management accounting for the ""%1"" fixed asset'");
	КонецЕсли;
			
	ШаблонСообщенияЛиквидационнаяСтоимость = НСтр("ru = 'Ликвидационная стоимость в строке %1 должна быть меньше стоимости по упр. учету';
													|en = 'Residual value in line %1 must be less than the cost in man. accounting'");
	ШаблонСообщенияЛиквидационнаяСтоимостьРегл = НСтр("ru = 'Ликвидационная стоимость в строке %1 должна быть меньше стоимости по регл. учету';
														|en = 'Residual value in line %1 must be less than the cost in compl. accounting'");
	
	Для каждого ДанныеСтроки Из ОС Цикл
		
		Если ОтражатьВУпрУчете Тогда
			
			Если ОтражатьВРеглУчете Тогда
				Если ДанныеСтроки.СтоимостьБУ = 0 
					И НЕ ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА Тогда
						
					ТекстСообщения = СтрШаблон(ШаблонСообщенияСтоимостьРегл, ДанныеСтроки.ОсновноеСредство);
					Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "СтоимостьБУ");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
				КонецЕсли; 
			КонецЕсли;
			
			Если ДанныеСтроки.СтоимостьУУ = 0
				И (ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА
					ИЛИ НЕ ВспомогательныеРеквизиты.ВалютыСовпадают) Тогда
				
				ТекстСообщения = СтрШаблон(ШаблонСообщенияСтоимостьУпр, ДанныеСтроки.ОсновноеСредство);
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "СтоимостьУУ");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
				
			КонецЕсли; 
			
			Если ДанныеСтроки.ЛиквидационнаяСтоимостьРегл >= ДанныеСтроки.СтоимостьБУ 
				И ДанныеСтроки.СтоимостьБУ <> 0 
				И НЕ ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА Тогда
				
				ТекстСообщения = СтрШаблон(ШаблонСообщенияЛиквидационнаяСтоимостьРегл, Формат(ДанныеСтроки.НомерСтроки, "ЧГ="));
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ЛиквидационнаяСтоимостьРегл");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
				
			КонецЕсли; 
			
			Если ДанныеСтроки.ЛиквидационнаяСтоимость >= ДанныеСтроки.СтоимостьУУ 
				И ДанныеСтроки.СтоимостьУУ <> 0 
				И (ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА
					ИЛИ НЕ ВспомогательныеРеквизиты.ВалютыСовпадают) Тогда
					
				ТекстСообщения = СтрШаблон(ШаблонСообщенияЛиквидационнаяСтоимость, Формат(ДанныеСтроки.НомерСтроки, "ЧГ="));
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ЛиквидационнаяСтоимость");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
				
			КонецЕсли; 
			
		КонецЕсли;
		
		РазукомплектацияОСЛокализация.ПроверитьСтрокуТЧ(ДанныеСтроки, ЭтотОбъект, ВспомогательныеРеквизиты, Отказ);
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПередЗаписью()

	ОчиститьНеиспользуемыеРеквизиты();
	
	Если ОтражатьВУпрУчете И ОтражатьВРеглУчете Тогда
		ДокументВДругомУчете = Неопределено;
	КонецЕсли;
	
	Если НЕ ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА()
		И Константы.ВалютаУправленческогоУчета.Получить() = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		
		Для каждого ДанныеСтроки Из ОС Цикл
			ДанныеСтроки.СтоимостьУУ = ДанныеСтроки.СтоимостьБУ;
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОчиститьНеиспользуемыеРеквизиты()
	
	ВспомогательныеРеквизиты = ВспомогательныеРеквизиты();
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_РазукомплектацияОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ВнеоборотныеАктивыКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ПараметрыРеквизитовОбъекта, "ОС");
	
КонецПроцедуры

Функция ВспомогательныеРеквизиты()
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", ВалютаУпр = ВалютаРегл);
	
	РазукомплектацияОСЛокализация.ДополнитьВспомогательныеРеквизиты(ЭтотОбъект, ВспомогательныеРеквизиты);
	
	Возврат ВспомогательныеРеквизиты;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
