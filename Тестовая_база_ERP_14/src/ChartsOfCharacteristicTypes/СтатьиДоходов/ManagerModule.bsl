#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТВызовСервера.ОбработкаПолученияДанныхВыбораПВХСтатьиДоходов(ДанныеВыбора, Параметры, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет реквизиты выбранной статьи доходов.
//
// Параметры:
//  СтатьяДоходов - ПланВидовХарактеристикСсылка.СтатьиДоходов - Ссылка на статью доходов.
//
// Возвращаемое значение:
//	Структура - реквизиты статьи доходов.
//
Функция ПолучитьРеквизитыСтатьиДоходов(СтатьяДоходов) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СтатьиДоходов.СпособРаспределения КАК СпособРаспределения,
	|	СтатьиДоходов.ТипЗначения КАК ТипЗначения
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиДоходов КАК СтатьиДоходов
	|ГДЕ
	|	СтатьиДоходов.Ссылка = &СтатьяДоходов
	|");
	
	Запрос.УстановитьПараметр("СтатьяДоходов", СтатьяДоходов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СпособРаспределения = Выборка.СпособРаспределения;
		ТребуетсяСпособРаспределения = Не Выборка.ТипЗначения.СодержитТип(Тип("СправочникСсылка.НаправленияДеятельности"));
	Иначе
		СпособРаспределения = Неопределено;
		ТребуетсяСпособРаспределения = Ложь;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("СпособРаспределения, ТребуетсяСпособРаспределения",
		СпособРаспределения,
		ТребуетсяСпособРаспределения);
	
	Возврат СтруктураРеквизитов;

КонецФункции

// Функция определяет аналитику доходов для подстановки в документ по статье доходов.
//
// Параметры:
//  СтатьяДоходов - ПланВидовХарактеристикСсылка.СтатьиДоходов - Ссылка на статью доходов
//	Объект - ДанныеФормыСтруктура - Текущий объект 
//	Подразделение - СправочникСсылка.СтруктураПредприятия - Ссылка на подразделение, указанное в документе.
//
// Возвращаемое значение:
//	СправочникСсылка - значение аналитики доходов.
//
Функция ПолучитьАналитикуДоходовПоУмолчанию(СтатьяДоходов, Объект, Подразделение) Экспорт
	
	ОписаниеТипов = Новый ОписаниеТипов(СтатьяДоходов.ТипЗначения);
	АналитикаДоходов = ОписаниеТипов.ПривестиЗначение();
	
	Если СтатьяДоходов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Партнеры")
		И Объект.Свойство("Партнер") Тогда
		
		АналитикаДоходов = Объект.Партнер;	
		
	ИначеЕсли СтатьяДоходов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации")
	   И Объект.Свойство("Организация") Тогда
	   
		АналитикаДоходов = Объект.Организация;
		
	ИначеЕсли СтатьяДоходов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия") Тогда
		
		Если Объект.Свойство("Подразделение") Тогда
			АналитикаДоходов = Объект.Подразделение;
		Иначе
			АналитикаДоходов = Подразделение;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат АналитикаДоходов;
	
КонецФункции

// Производит проверку заполнения реквизитов аналитик статей доходов в переданном объекте.
//
// Параметры:
// 		Объект - СправочникОбъект, ДокументОбъект, ДанныеФормыСтруктура - Объект ИБ предназначенный для проверки
// 		Реквизиты - Строка, Структура, Массив - Реквизиты статей доходов для проверки
// 			<Строка> Перечисление пар реквизитов для проверки в формате "СтатьяДоходов1, АналитикаДоходов1, СтатьяДоходов2, АналитикаДоходов2, ..."
// 				Пустая строка трактуется как "СтатьяДоходов, АналитикаДоходов"
// 			<Структура> Ключ: Строка с именем табличной части; Значение - Строка в нотации как у параметра типа <Строка>
// 			<Массив> Массив, элементы которого либо структуры в нотации как у параметра с типа <Структура>, либо строки в нотации <Строка>
// 		НепроверяемыеРеквизиты - Массив - Массив для накопления не проверяемых реквизитов переданного объекта
// 		Отказ - Булево - Признак наличия ошибок заполнения аналитик переданного объекта
// 		ДополнительныеПараметры - Структура - При наличии свойства "ПрограммнаяПроверка", ошибки записываются в эту структуру, пользователю не выводятся.
//
Процедура ПроверитьЗаполнениеАналитик(Объект, Реквизиты = "", НепроверяемыеРеквизиты = Неопределено, Отказ = Ложь,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Ошибки = Новый Структура;
	Ошибки.Вставить("СписокОшибок", Новый Массив);
	Ошибки.Вставить("ГруппыОшибок", Новый Соответствие);
	Ошибки.Вставить("ПрефиксОбъекта", ?(ТипЗнч(Объект)=Тип("УправляемаяФорма"), "", "Объект."));
	
	МассивОбработки = Новый Массив;
	Если ТипЗнч(Реквизиты) = Тип("Массив") Тогда
		МассивОбработки = Реквизиты;
	Иначе
		МассивОбработки.Добавить(Реквизиты);
	КонецЕсли;
	
	Для Каждого ЭлементМассива Из МассивОбработки Цикл
		
		Если ТипЗнч(ЭлементМассива) = Тип("Структура") Тогда
			ПроверкаЗаполненияАналитикТЧОбъекта(Объект, ЭлементМассива, НепроверяемыеРеквизиты, Ошибки);
		Иначе
			ПроверкаЗаполненияАналитикОбъекта(Объект, ЭлементМассива, НепроверяемыеРеквизиты, Ошибки);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ПрограммнаяПроверка") Тогда
		ДополнительныеПараметры.Вставить("Ошибки", Ошибки);
	Иначе
		Если Ошибки.СписокОшибок.Количество() <> 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Производит заполнение условного оформления формы
//
// Параметры:
// 		УсловноеОФормление - УсловноеОформлениеКомпоновкиДанных - Условное оформление формы объекта
// 		Реквизиты - Строка, Структура, Массив - Реквизиты статей доходов и их аналитик для оформления
// 			<Строка> Перечисление пар реквизитов в формате "СтатьяДоходов1, АналитикаДоходов1, СтатьяДоходов2, АналитикаДоходов2, ..."
// 				Пустая строка трактуется как "СтатьяДоходов, АналитикаДоходов"
// 			<Структура> Ключ: Строка с именем табличной части; Значение - Строка в нотации как у параметра типа <Строка>
// 			<Массив> Массив, элементы которого либо структуры в нотации как у параметра с типа <Структура>, либо строки в нотации <Строка>
// 		ФормаОбъекта - Булево - Признак формы объекта ИБ.
//
Процедура УстановитьУсловноеОформлениеАналитик(УсловноеОФормление, Реквизиты = "", ФормаОбъекта = Истина, ПрефиксКонтроля = "") Экспорт
	
	МассивОбработки = Новый Массив;
	Если ТипЗнч(Реквизиты) = Тип("Массив") Тогда
		МассивОбработки = Реквизиты;
	Иначе
		МассивОбработки.Добавить(Реквизиты);
	КонецЕсли;
	
	Для Каждого ЭлементМассива Из МассивОбработки Цикл
		
		Если ТипЗнч(ЭлементМассива) = Тип("Структура") Тогда
			
			Для Каждого КлючИЗначение Из ЭлементМассива Цикл
				
				СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(КлючИЗначение.Значение);
				УстановитьУсловноеОформление(УсловноеОформление, СтруктураРеквизитов, КлючИЗначение.Ключ, ФормаОбъекта, ПрефиксКонтроля)
				
			КонецЦикла;
			
		Иначе
			
			СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(ЭлементМассива);
			УстановитьУсловноеОформление(УсловноеОформление, СтруктураРеквизитов, , ФормаОбъекта, ПрефиксКонтроля)
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура заполнения колонок "АналитикаДоходовОбязательна" в формах.
//
// Параметры:
// 		ТаблицаФормы - ДанныеФормыКоллекция - Коллекция формы, в которой необходимо заполнить реквизиты признаков обязательности аналитики доходов
// 		Реквизиты - Строка - Реквизиты статей доходов и их аналитик
// 			Перечисление пар реквизитов в формате "СтатьяДоходов1, АналитикаДоходов1, СтатьяДоходов2, АналитикаДоходов2, ..."
// 			Пустая строка трактуется как "СтатьяДоходов, АналитикаДоходов".
//
Процедура ЗаполнитьПризнакАналитикаДоходовОбязательна(ТаблицаФормы, Реквизиты="") Экспорт
	
	Если ТаблицаФормы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Таблица.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки%ПоляСтатей%
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица;
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки%ПоляФлагов%
	|ИЗ
	|	Таблица КАК Таблица%ПоляСоединений%";
	
	ШаблонСтатьи = ",
	|	Таблица.%ИмяСтатьи% КАК %ИмяСтатьи%";
	ШаблонФлага = ",
	|	ЕСТЬNULL(ПВХ%ИмяСтатьи%.КонтролироватьЗаполнениеАналитики, ЛОЖЬ) КАК %ИмяАналитики%Обязательна";
	ШаблонСоединения = "
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиДоходов КАК ПВХ%ИмяСтатьи%
	|		ПО Таблица.%ИмяСтатьи% = ПВХ%ИмяСтатьи%.Ссылка";
	
	ПоляСтатей = "";
	ПоляФлагов = "";
	ПоляСоединений ="";
	
	СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(Реквизиты);
	
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ПоляСтатей = ПоляСтатей + СтрЗаменить(ШаблонСтатьи, "%ИмяСтатьи%", КлючИЗначение.Ключ);
		ПоляФлагов = ПоляФлагов + СтрЗаменить(СтрЗаменить(ШаблонФлага, "%ИмяАналитики%", КлючИЗначение.Значение), "%ИмяСтатьи%", КлючИЗначение.Ключ);
		ПоляСоединений = ПоляСоединений + СтрЗаменить(ШаблонСоединения, "%ИмяСтатьи%", КлючИЗначение.Ключ);
	КонецЦикла;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПоляСтатей%", ПоляСтатей);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПоляФлагов%", ПоляФлагов);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПоляСоединений%", ПоляСоединений);
	
	Запрос.УстановитьПараметр(
		"Таблица",
		ТаблицаФормы.Выгрузить(,"НомерСтроки, " + ?(ПустаяСтрока(Реквизиты), "СтатьяДоходов, АналитикаДоходов", Реквизиты)));
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаФормы[Выборка.НомерСтроки-1], Выборка,, "НомерСтроки");
	КонецЦикла;
	
КонецПроцедуры

// Возвращает статьи доходов, использование которых запрещено
//
// Возвращаемое значение:
// 	ЗаблокированныеСтатьи - СписокЗначений - Список заблокированных статей доходов.
//
Функция ЗаблокированныеСтатьиДоходов() Экспорт
	
	ЗаблокированныеСтатьи = Новый СписокЗначений;
	Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ЗакрытиеРезервовПоСомнительнымДолгам);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.КурсовыеРазницы);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ПрибыльУбытокПрошлыхЛет);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ПрибыльУбытокПрошлыхЛет);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.РеализацияОС);
	КонецЕсли;
	
	Возврат ЗаблокированныеСтатьи;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеПроцедурыИФункцииЗаполненияАналитик

Функция ОбязательныеСтатьи(МассивСтатей)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Статьи.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиДоходов КАК Статьи
	|ГДЕ
	|	Статьи.Ссылка В (&МассивСтатей)
	|	И Статьи.КонтролироватьЗаполнениеАналитики");
	
	Запрос.УстановитьПараметр("МассивСтатей", МассивСтатей);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Функция ИменаРеквизитовСтатьиИАналитики(СтрокаРеквизитов, НепроверяемыеРеквизиты = Неопределено, ПрефиксТабличнойЧасти = "")
	
	Если ПустаяСтрока(СтрокаРеквизитов) Тогда
		Если НепроверяемыеРеквизиты <> Неопределено Тогда
			НепроверяемыеРеквизиты.Добавить(ПрефиксТабличнойЧасти + "АналитикаДоходов");
		КонецЕсли;
		Возврат Новый Структура("СтатьяДоходов", "АналитикаДоходов");
	КонецЕсли;
	
	СтруктураОбработки = Новый Структура(СтрокаРеквизитов);
	СтруктураВозврата = Новый Структура;
	ПредыдущийКлюч = Неопределено;
	Для Каждого КлючИЗначение Из СтруктураОбработки Цикл
		Если ПредыдущийКлюч = Неопределено Тогда
			ПредыдущийКлюч = КлючИЗначение.Ключ;
		Иначе
			СтруктураВозврата.Вставить(ПредыдущийКлюч, КлючИЗначение.Ключ);
			ПредыдущийКлюч = Неопределено;
			Если НепроверяемыеРеквизиты <> Неопределено Тогда
				НепроверяемыеРеквизиты.Добавить(ПрефиксТабличнойЧасти + КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Процедура ПроверкаЗаполненияАналитикОбъекта(Объект, Реквизиты, НепроверяемыеРеквизиты, Ошибки)
	
	СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(Реквизиты, НепроверяемыеРеквизиты);
	МассивСтатей = Новый Массив;
	
	// Определим список статей для контроля
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		
		Статья = Объект[КлючИЗначение.Ключ];
		
		Если ЗначениеЗаполнено(Статья) Тогда
			МассивСтатей.Добавить(Статья);
		КонецЕсли;
		
	КонецЦикла;
	
	// Проверим заполнение аналитики
	ОбязательныеСтатьи = ОбязательныеСтатьи(МассивСтатей);
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		
		Статья = Объект[КлючИЗначение.Ключ];
		Аналитика = Объект[КлючИЗначение.Значение];
		
		Если Не (ОбязательныеСтатьи.Найти(Статья) = Неопределено Или ЗначениеЗаполнено(Аналитика)) Тогда
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
				Ошибки,
				Ошибки.ПрефиксОбъекта + КлючИЗначение.Значение,
				НСтр("ru = 'Аналитика доходов не заполнена';
					|en = 'Income dimension is not filled in'"), "");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверкаЗаполненияАналитикТЧОбъекта(Объект, Реквизиты, НепроверяемыеРеквизиты, Ошибки)
	
	// Определим список статей для контроля
	ОбщийМассивСтатей = Новый Массив;
	Для Каждого ОписаниеТЧ Из Реквизиты Цикл
		
		ИмяТЧ = ОписаниеТЧ.Ключ;
		
		СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(ОписаниеТЧ.Значение, НепроверяемыеРеквизиты, ИмяТЧ + ".");
		
		Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
			
			МассивСтатей = Объект[ИмяТЧ].ВыгрузитьКолонку(КлючИЗначение.Ключ);
			Для Каждого Статья Из МассивСтатей Цикл
				ОбщийМассивСтатей.Добавить(Статья);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Проверим заполнение аналитики
	ОбязательныеСтатьи = ОбязательныеСтатьи(ОбщийМассивСтатей);
	Для Каждого ОписаниеТЧ Из Реквизиты Цикл // Табличные части
		
		ИмяТЧ = ОписаниеТЧ.Ключ;
		ТЧ = Объект[ИмяТЧ];
		
		СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(ОписаниеТЧ.Значение, Неопределено, ИмяТЧ + ".");
		
		Для Индекс = 0 По ТЧ.Количество() - 1 Цикл // Строки табличной части
			
			СтрокаТЧ = ТЧ[Индекс];
			
			Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
				
				Статья = СтрокаТЧ[КлючИЗначение.Ключ];
				Аналитика = СтрокаТЧ[КлючИЗначение.Значение];
				
				Если Не (ОбязательныеСтатьи.Найти(Статья) = Неопределено Или ЗначениеЗаполнено(Аналитика)) Тогда
					
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
						Ошибки,
						Ошибки.ПрефиксОбъекта + ИмяТЧ + "[%1]." + КлючИЗначение.Значение,
						НСтр("ru = 'Не заполнена аналитика доходов';
							|en = 'Income dimension is not populated'"),
						ИмяТЧ,
						Индекс,
						НСтр("ru = 'Не заполнена аналитика доходов в строке %1';
							|en = 'Income dimension is not populated in line %1'"));
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьУсловноеОформление(УсловноеОформление, СтруктураРеквизитов, ИмяТабличнойЧасти = "", ФормаОбъекта, ПрефиксКонтроля)
	
	ПревиксТЧ = ?(ПустаяСтрока(ИмяТабличнойЧасти), "", ИмяТабличнойЧасти + ".");
	ПрефиксАналитики = ?(ФормаОбъекта, "Объект.", "") + ПревиксТЧ;
	Если ПустаяСтрока(ПрефиксКонтроля) Тогда
		ПрефиксКонтроля  = ?(ФормаОбъекта И Не ПустаяСтрока(ПревиксТЧ), "Объект.", "") + ПревиксТЧ;
	Иначе
		ПрефиксКонтроля  = ПрефиксКонтроля + ".";
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		
		ИмяАналитики = КлючИЗначение.Значение;
		ИмяКонтроля = ИмяАналитики + "Обязательна";
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(ИмяТабличнойЧасти + ИмяАналитики);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПрефиксКонтроля + ИмяКонтроля);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		ОтборЭлемента.ПравоеЗначение = Истина;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
		
		Если ПустаяСтрока(ИмяТабличнойЧасти) Тогда
			
			Элемент = УсловноеОформление.Элементы.Добавить();
			Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(ИмяАналитики);
			
			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПрефиксКонтроля + ИмяКонтроля);
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборЭлемента.ПравоеЗначение = Истина;
			
			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПрефиксАналитики + ИмяАналитики);
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
			
			Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьПредопределенныеСтатьиДоходов() Экспорт
	
	МассивСтатейДоходов = Новый Массив;
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ЗакрытиеРезервовПоСомнительнымДолгам);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.КурсовыеРазницы);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ДоходыПриКонвертацииВалюты);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ПрибыльУбытокПрошлыхЛет);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.РеализацияОС);
	
	Для каждого Статья Из МассивСтатейДоходов Цикл
		
		СтатьиДоходовОбъект = Статья.ПолучитьОбъект();
		
		Если Статья = ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж Тогда
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.НаправленияДеятельности");
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.ЗакрытиеРезервовПоСомнительнымДолгам Тогда
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
			//++ НЕ УТ
			СтатьиДоходовОбъект.ВидПрочихДоходов = Перечисления.ВидыПрочихДоходовИРасходов.ОтчисленияВОценочныеРезервы;	
			//-- НЕ УТ
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.КурсовыеРазницы Тогда
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
			//++ НЕ УТ
			СтатьиДоходовОбъект.ВидПрочихДоходов = Перечисления.ВидыПрочихДоходовИРасходов.КурсовыеРазницы;
			//-- НЕ УТ
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.ДоходыПриКонвертацииВалюты Тогда
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
			//++ НЕ УТ
			СтатьиДоходовОбъект.ВидПрочихДоходов = Перечисления.ВидыПрочихДоходовИРасходов.ПрочиеВнереализационныеДоходыРасходы;
			СтатьиДоходовОбъект.СчетУчета = ПланыСчетов.Хозрасчетный.ПрочиеДоходы;
			//-- НЕ УТ
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.РеализацияОС Тогда
			Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
				СтатьиДоходовОбъект.Наименование = НСтр("ru = 'Реализация прочих активов';
														|en = 'Other asset implementation'");
				СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
			КонецЕсли;
			//++ НЕ УТ
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ОбъектыЭксплуатации");
			СтатьиДоходовОбъект.КонтролироватьЗаполнениеАналитики = Истина;
			СтатьиДоходовОбъект.ВидПрочихДоходов = Перечисления.ВидыПрочихДоходовИРасходов.РеализацияОсновныхСредств;	
			//-- НЕ УТ
		//++ НЕ УТ
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.ПрибыльУбытокПрошлыхЛет Тогда
			СтатьиДоходовОбъект.ВидПрочихДоходов = Перечисления.ВидыПрочихДоходовИРасходов.ПрибыльУбытокПрошлыхЛет;	
		//-- НЕ УТ
		КонецЕсли;
		
		//++ НЕ УТ
		СтатьиДоходовОбъект.ПринятиеКналоговомуУчету = Истина;
		СтатьиДоходовОбъект.ВидДеятельностиДляНалоговогоУчетаЗатрат = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения;
		Если Не ЗначениеЗаполнено(СтатьиДоходовОбъект.ВидПрочихДоходов) Тогда
			СтатьиДоходовОбъект.ВидПрочихДоходов = Перечисления.ВидыПрочихДоходовИРасходов.ПрочиеОперационныеДоходыРасходы;	
		КонецЕсли;
		//-- НЕ УТ
		
		СтатьиДоходовОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
