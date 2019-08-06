#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в возврате товаров поставщику
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияЗакупок.Валюта;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация <> Организация Тогда
		Организация = УсловияЗакупок.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	ХозяйственнаяОперацияДоговора = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");
	ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
	ДопПараметры.ВалютаВзаиморасчетов = Валюта;
	Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(ЭтотОбъект, ХозяйственнаяОперацияДоговора, ДопПараметры);
	
	Если НЕ ЗначениеЗаполнено(УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов) 
		ИЛИ НЕ УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
		ПорядокОплаты = УсловияЗакупок.ПорядокОплаты;
	Иначе
		ПорядокОплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокОплаты");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия закупок по умолчанию в возврате товаров поставщику
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Соглашение) Тогда
		Соглашение = Справочники.СоглашенияСПоставщиками.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(Партнер);
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			
			Если Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
				И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
				
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
				
			Иначе
				
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				
			КонецЕсли;
				
		Иначе
			
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в возврате товаров поставщику
//
Процедура ЗаполнитьУсловияЗакупокПоСоглашению() Экспорт
	
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Соглашение);
	ЗаполнитьУсловияЗакупок(УсловияЗакупок);
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ИнициализироватьДокумент(ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнитьРеквизитыЗначениямиПоУмолчанию();
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ВыбытиеДенежныхДокументов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
		
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, , МассивНепроверяемыхРеквизитов, Отказ);
		
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, , МассивНепроверяемыхРеквизитов, Отказ);
		
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхДокументовПоставщику Тогда
		
		Разница = ДенежныеДокументы.Итог("Сумма") - ДенежныеДокументы.Итог("СуммаВозврата");
		
		Если Разница <= 0 Тогда // Доход или нет разницы между стоимостями
			МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
			МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходов");
		КонецЕсли;
		
		Если Разница >= 0 Тогда // Расход или нет разницы между стоимостями
			МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
			МассивНепроверяемыхРеквизитов.Добавить("АналитикаДоходов");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхДокументовПодотчетнику Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаАвансовогоОтчета");
		
		Если НЕ ЗначениеЗаполнено(ДатаАвансовогоОтчета) Тогда
			ТекстОшибки = НСтр("ru = 'Поле ""Отчитаться"" не заполнено';
								|en = 'The ""Report"" field is not filled in'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				"ПериодАвансовогоОтчета",
				, // ПутьКДанным
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ВыбытиеДенежныхДокументов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
		
	СуммаДокумента = ДенежныеДокументы.Итог("Сумма");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ДенежныеДокументы);
		
		// Уникальность строки для суммы разницы между возвратом и ценой денежного документа.
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхДокументовПоставщику Тогда
			
			Уникальность = Новый Соответствие;
			Для Каждого СтрокаТаблицы Из ДенежныеДокументы Цикл
				Если Не ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторСтрокиНаРазницу)
					Или Неопределено <> Уникальность.Получить(СтрокаТаблицы.ИдентификаторСтрокиНаРазницу)
					Тогда
					// Идентификатор в строке не заполнен ИЛИ идентификатор встречался ранее
					СтрокаТаблицы.ИдентификаторСтрокиНаРазницу = Строка(Новый УникальныйИдентификатор);
				КонецЕсли;
				Уникальность.Вставить(СтрокаТаблицы.ИдентификаторСтрокиНаРазницу, СтрокаТаблицы.ИдентификаторСтрокиНаРазницу);
			КонецЦикла;
			
			СуммаВозврата = ДенежныеДокументы.Итог("СуммаВозврата");
			Если РасшифровкаПлатежа.Количество() = 0 И СуммаВозврата <> 0 Тогда
				НоваяСтрока = РасшифровкаПлатежа.Добавить();
				НоваяСтрока.Сумма = СуммаВозврата;
			КонецЕсли;
			
			ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВТабличнойЧасти(
				Валюта,
				Дата,
				РасшифровкаПлатежа);
				
		Иначе
				
			РасшифровкаПлатежа.Очистить();
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ВыбытиеДенежныхДокументов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваУПодотчетныхЛиц(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДвижениеДенежныхДокументов(ДополнительныеСвойства, Движения, Отказ);
	
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныхСредств(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваКонтрагент(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Инициализация

Процедура ИнициализироватьДокумент(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	Если ДанныеЗаполнения.Свойство("ДенежныеДокументы") Тогда
		ДенежныеСредстваСервер.ЗаполнитьПоОстаткамДД(ДанныеЗаполнения, ДенежныеДокументы);
	КонецЕсли;
	
	ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(Валюта,,Валюта);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыЗначениямиПоУмолчанию()
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	Массив.Добавить(Движения.ДенежныеДокументы);
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
