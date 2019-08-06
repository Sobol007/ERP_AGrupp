#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Покупатели") Тогда
		
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.СчетФактураКомитента.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетНДСУП.СформироватьДвиженияВРегистры(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ Исправление Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаИсправления");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СчетаФактурыВыданные = ЭтотОбъект.Покупатели.ВыгрузитьКолонку("СчетФактураВыданный");
	РегистрыСведений.СчетаФактурыКомитентовКРегистрации.ОбновитьСостояние(СчетаФактурыВыданные);
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаСНДС = Покупатели.Итог("СуммаСНДС");
	СуммаНДС  = Покупатели.Итог("СуммаНДС");
	
	Сводный = (Покупатели.Количество() > 1);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Ответственный") Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ЗаполнитьИННКППКонтрагентов(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения)
	
	Для каждого Строка Из ДанныеЗаполнения.Покупатели Цикл
		НоваяСтрока = Покупатели.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	ДанныеЗаполнения.Вставить("КодВидаОперации", КодВидаОперации());
	
	ПараметрыСчетаФактуры = ПолучитьПараметрыСчетаФактурыПоОснованиям();
	
	Если Не ПараметрыСчетаФактуры.Организация = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Организация", ПараметрыСчетаФактуры.Организация);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Контрагент = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Контрагент", ПараметрыСчетаФактуры.Контрагент);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Партнер = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Партнер", ПараметрыСчетаФактуры.Партнер);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Договор = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Договор", ПараметрыСчетаФактуры.Договор);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Склад = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Склад", ПараметрыСчетаФактуры.Склад);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.Подразделение = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Подразделение", ПараметрыСчетаФактуры.Подразделение);
	КонецЕсли;
	
	Если Не ПараметрыСчетаФактуры.НаправлениеДеятельности = Неопределено Тогда
		ДанныеЗаполнения.Вставить("НаправлениеДеятельности", ПараметрыСчетаФактуры.НаправлениеДеятельности);
	КонецЕсли;
	
КонецПроцедуры

Функция КодВидаОперации()
	
	ВерсияКодовВидовОпераций = УчетНДСКлиентСервер.ВерсияКодовВидовОпераций(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	КодВидаОперации = ?(ВерсияКодовВидовОпераций >= 3, "01", "04");
	
	Если Покупатели.Количество() > 1 Тогда
		КодВидаОперации = "27";
	КонецЕсли;
	
	Возврат КодВидаОперации;
	
КонецФункции

Процедура ЗаполнитьИННКППКонтрагентов(ДанныеЗаполнения)
	
	КомитентДанныхЗаполнения = Неопределено;
	ДатаСоставленияДанныхЗаполнения = ТекущаяДатаСеанса();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("Комитент")
		И ЗначениеЗаполнено(ДанныеЗаполнения.Комитент)
		И ТипЗнч(ДанныеЗаполнения.Комитент) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		КомитентДанныхЗаполнения = ДанныеЗаполнения.Комитент;
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ДатаСоставления") Тогда
		
		ДатаСоставленияДанныхЗаполнения = ДанныеЗаполнения.ДатаСоставления;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КомитентДанныхЗаполнения) Тогда
		РеквизитыКомитента = Справочники.Контрагенты.РеквизитыКонтрагента(КомитентДанныхЗаполнения, ДатаСоставленияДанныхЗаполнения);
		ИННКомитента = РеквизитыКомитента.ИНН;
		КППКомитента = РеквизитыКомитента.КПП;
	КонецЕсли;
	
	МассивСубкомиссионеров = Новый Массив;
	Для Каждого СтрокаПокупатели Из Покупатели Цикл
		
		Если ЗначениеЗаполнено(СтрокаПокупатели.Субкомиссионер)
			И ТипЗнч(СтрокаПокупатели.Субкомиссионер) = Тип("СправочникСсылка.Контрагенты") Тогда
			
			МассивСубкомиссионеров.Добавить(СтрокаПокупатели.Субкомиссионер);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивСубкомиссионеров.Количество() > 0 Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	МАКСИМУМ(ИсторияКППКонтрагентов.Период) КАК Период,
		|	ИсторияКППКонтрагентов.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ЗначенияКПП
		|ИЗ
		|	Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
		|ГДЕ
		|	ИсторияКППКонтрагентов.Ссылка  В (&МассивКонтрагентов)
		|	И ИсторияКППКонтрагентов.Период <= &ДатаСведений
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсторияКППКонтрагентов.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	ИсторияКППКонтрагентов.КПП КАК КПП,
		|	ИсторияКППКонтрагентов.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ИсторическоеЗначениеКПП
		|ИЗ
		|	ЗначенияКПП КАК ЗначенияКПП
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
		|		ПО ЗначенияКПП.Ссылка = ИсторияКППКонтрагентов.Ссылка
		|			И ЗначенияКПП.Период = ИсторияКППКонтрагентов.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ИсторическоеЗначениеКПП.КПП, Контрагенты.КПП) КАК КПП,
		|	Контрагенты.ИНН                                        КАК ИНН,
		|	Контрагенты.Ссылка                                     КАК Контрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеКПП КАК ИсторическоеЗначениеКПП
		|			ПО ИсторическоеЗначениеКПП.Ссылка = Контрагенты.Ссылка
		|ГДЕ
		|	Контрагенты.Ссылка  В (&МассивКонтрагентов)
		|";
		
		Запрос.УстановитьПараметр("МассивКонтрагентов", МассивСубкомиссионеров);
		Запрос.УстановитьПараметр("ДатаСведений", ДатаСоставленияДанныхЗаполнения);
		
		СоотвествиеКонтрагентов = Новый Соответствие;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ДанныеКонтрагента = Новый Структура("ИННСубкомиссионера, КППСубкомиссионера");
			ДанныеКонтрагента.ИННСубкомиссионера = Выборка.ИНН;
			ДанныеКонтрагента.КППСубкомиссионера = Выборка.КПП;
			
			СоотвествиеКонтрагентов.Вставить(Выборка.Контрагент, ДанныеКонтрагента);
			
		КонецЦикла;
		
		Для Каждого СтрокаПокупатели Из Покупатели Цикл
			
			Если ЗначениеЗаполнено(СтрокаПокупатели.Субкомиссионер)
				И ТипЗнч(СтрокаПокупатели.Субкомиссионер) = Тип("СправочникСсылка.Контрагенты") Тогда
				
				ДанныеКонтрагента = СоотвествиеКонтрагентов.Получить(СтрокаПокупатели.Субкомиссионер);
				Если ДанныеКонтрагента <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(СтрокаПокупатели, ДанныеКонтрагента);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры

// Определяет реквизиты счета-фактуры на основании выбранных документов-оснований
//
// Возвращаемое значение:
//	Структура - реквизиты счета-фактуры.
//
Функция ПолучитьПараметрыСчетаФактурыПоОснованиям()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура("Организация, Контрагент, Партнер, Договор,
		|НаправлениеДеятельности, Склад, Подразделение, Ответственный");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументыОснования", Покупатели.ВыгрузитьКолонку("СчетФактураВыданный"));
	
	ТекстЗапросаОснований = 
	"ВЫБРАТЬ
	|	ДанныеОснований.Ссылка КАК Ссылка,
	|	ДанныеОснований.Организация КАК Организация,
	|	ЕСТЬNULL(ДанныеРеестра.Контрагент.Ключ, НЕОПРЕДЕЛЕНО) КАК Контрагент,
	|	ЕСТЬNULL(ДанныеРеестра.Партнер, НЕОПРЕДЕЛЕНО) КАК Партнер,
	|	ЕСТЬNULL(ДанныеРеестра.Договор, НЕОПРЕДЕЛЕНО) КАК Договор,
	|	ЕСТЬNULL(ДанныеРеестра.Подразделение, НЕОПРЕДЕЛЕНО) КАК Подразделение,
	|	ЕСТЬNULL(ДанныеРеестра.МестоХранения.Ключ, НЕОПРЕДЕЛЕНО) КАК Склад,
	|	ЕСТЬNULL(ДанныеРеестра.НаправлениеДеятельности, НЕОПРЕДЕЛЕНО) КАК НаправлениеДеятельности
	|ИЗ
	|	(ВЫБРАТЬ
	|		СчетФактураВыданный.Ссылка КАК Ссылка,
	|		СчетФактураВыданный.Организация КАК Организация
	|	ИЗ
	|		Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|	ГДЕ
	|		СчетФактураВыданный.Ссылка В (&ДокументыОснования)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СчетФактураКомиссионеру.Ссылка,
	|		СчетФактураКомиссионеру.Организация КАК Организация
	|	ИЗ
	|		Документ.СчетФактураКомиссионеру КАК СчетФактураКомиссионеру
	|	ГДЕ
	|		СчетФактураКомиссионеру.Ссылка В (&ДокументыОснования)) КАК ДанныеОснований
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК ДанныеРеестра
	|		ПО ДанныеОснований.Ссылка = ДанныеРеестра.Ссылка
	|			И (НЕ ДанныеРеестра.ДополнительнаяЗапись)
	|";
	
	Запрос.Текст = ТекстЗапросаОснований;
	ВыборкаОснований = Запрос.Выполнить().Выбрать();
	
	ПерваяСтрока      = Истина;
	РазныеОрганизации = Ложь;
	РазныеКонтрагенты = Ложь;
	РазныеПартнеры    = Ложь;
	РазныеДоговоры    = Ложь;
	РазныеСклады      = Ложь;
	РазныеВалюты      = Ложь;
	РазныеПодразделения = Ложь;
	РазныеНаправленияДеятельности = Ложь;
	
	Пока ВыборкаОснований.Следующий() Цикл
		
		Если ПерваяСтрока Тогда
			ПерваяСтрока = Ложь;
			ЗаполнитьЗначенияСвойств(Результат, ВыборкаОснований);
			Продолжить;
		КонецЕсли;
		
		РазныеОрганизации   = РазныеОрганизации Или Результат.Организация <> ВыборкаОснований.Организация;
		РазныеКонтрагенты   = РазныеКонтрагенты Или Результат.Контрагент <> ВыборкаОснований.Контрагент;
		РазныеПартнеры      = РазныеПартнеры Или Результат.Партнер <> ВыборкаОснований.Партнер;
		РазныеДоговоры      = РазныеДоговоры Или Результат.Договор <> ВыборкаОснований.Договор;
		РазныеСклады        = РазныеСклады Или Результат.Склад <> ВыборкаОснований.Склад;
		РазныеВалюты        = РазныеВалюты Или Результат.Валюта <> ВыборкаОснований.Валюта;
		РазныеПодразделения = РазныеПодразделения Или Результат.Подразделение <> ВыборкаОснований.Подразделение;
		РазныеНаправленияДеятельности = РазныеНаправленияДеятельности
			Или Результат.НаправлениеДеятельности <> ВыборкаОснований.НаправлениеДеятельности;
		
	КонецЦикла;
	
	Если РазныеОрганизации ИЛИ РазныеВалюты Тогда
			
		ТекстСообщения = НСтр("ru = 'Реквизиты документов, на основании которых зарегистрирован счет-фактура, не совпадают:';
								|en = 'Document attributes based on which the tax invoice is registered do not match:'")
			+ ?(РазныеОрганизации, Символы.ПС + НСтр("ru = '- организация';
													|en = '- company'"), "")
			+ ?(РазныеВалюты, Символы.ПС + НСтр("ru = '- валюта документа';
												|en = '- document currency'"), "") + Символы.ПС 
			+ НСтр("ru = 'Необходимо изменить реквизиты документов-оснований или зарегистрировать по документам с расхождениями отдельные счета-фактуры.';
					|en = 'Change attributes of base documents or register separate tax invoices for documents with variances.'");
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Если РазныеОрганизации Тогда
			Результат.Организация = Неопределено;
		КонецЕсли;
		Если РазныеВалюты Тогда
			Результат.Валюта = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Если РазныеКонтрагенты Тогда
		Результат.Контрагент = Неопределено;
	КонецЕсли;
	Если РазныеПартнеры Тогда
		Результат.Партнер = Неопределено;
	КонецЕсли;
	Если РазныеДоговоры Тогда
		Результат.Договор = Неопределено;
	КонецЕсли;
	Если РазныеСклады Тогда
		Результат.Склад = Неопределено;
	КонецЕсли;
	Если РазныеПодразделения Тогда
		Результат.Подразделение = Неопределено;
	КонецЕсли;
	Если РазныеНаправленияДеятельности Тогда
		Результат.НаправлениеДеятельности = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
