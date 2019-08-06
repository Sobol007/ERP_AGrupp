//++ НЕ УТКА

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет обработку данными этапов производства.
//
// Параметры:
//  ДанныеЗаполнения - Структура - данные заполнения
//
Процедура Прочитать(ДанныеЗаполнения) Экспорт
	
	Очистить();
	
	ДанныеПартииПроизводства = Документы.ЭтапПроизводства2_2.ДанныеПартииПроизводства(
		ДанныеЗаполнения.Распоряжение,
		ДанныеЗаполнения.НазначениеПродукция,
		ДанныеЗаполнения.ПартияПроизводства);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеПартииПроизводства);
	
	Если ПартияПроизводства.Пустая() Тогда
		
		Если Не ДанныеЗаполнения.Свойство("ТипПроизводственногоПроцесса", ТипПроизводственногоПроцесса) Тогда
			ТипПроизводственногоПроцесса = Перечисления.ТипыПроизводственныхПроцессов.Сборка;
		КонецЕсли;
		
		Возврат; // нет этапов
		
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ПометкаУдаления", Ложь);
	Отбор.Вставить("ПартияПроизводства", ДанныеЗаполнения.ПартияПроизводства);
	
	СписокЭтапов = Документы.ЭтапПроизводства2_2.НайтиЭтапы(Отбор);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка В (&СписокЭтапов)
	|	И НЕ Таблица.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерЭтапа,
	|	НомерСледующегоЭтапа
	|");
	Запрос.УстановитьПараметр("СписокЭтапов", СписокЭтапов);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	СписокТЧ = СписокВложенныхТабличныхЧастей();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ЭтотОбъект.Этапы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Для каждого ИмяТЧ Из СписокТЧ Цикл
		
			ВложеннаяВыборка = Выборка[ИмяТЧ].Выбрать();
			Пока ВложеннаяВыборка.Следующий() Цикл
				НоваяСтрока = ЭтотОбъект[ИмяТЧ].Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВложеннаяВыборка);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Очищает данные обработки
//
Процедура Очистить() Экспорт
	
	Реквизиты = Метаданные.Обработки.РедактированиеПоследовательностиЭтаповПроизводства.Реквизиты;
	Для каждого Элемент Из Реквизиты Цикл
		ЭтотОбъект[Элемент.Имя] = Неопределено;
	КонецЦикла;
	
	ТЧ = Метаданные.Обработки.РедактированиеПоследовательностиЭтаповПроизводства.ТабличныеЧасти;
	Для каждого Элемент Из ТЧ Цикл
		ЭтотОбъект[Элемент.Имя].Очистить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	
	МассивНепроверяемыхРеквизитов.Добавить("Партнер");
	МассивНепроверяемыхРеквизитов.Добавить("Договор");
	
	МассивНепроверяемыхРеквизитов.Добавить("Этапы.МаршрутнаяКарта");
	МассивНепроверяемыхРеквизитов.Добавить("Этапы.КоэффициентМаршрутнойКарты");
	
	Документы.ЭтапПроизводства2_2.ПроверитьИспользованиеПартионногоУчета22(ЭтотОбъект, Отказ);
	
	МенеджерВременныхТаблиц = Документы.ЭтапПроизводства2_2.СформироватьВременныеТаблицыДляПроверки(ЭтотОбъект);
	
	Документы.ЭтапПроизводства2_2.ПроверитьЗаполнениеОбъекта(
		ЭтотОбъект,
		МенеджерВременныхТаблиц,
		Отказ,
		ПроверяемыеРеквизиты);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Обработки.РедактированиеПоследовательностиЭтаповПроизводства);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий.ВыходныеИзделия, Отказ, МассивНепроверяемыхРеквизитов);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий.ПобочныеИзделия, Отказ, МассивНепроверяемыхРеквизитов);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий.ОбеспечениеМатериаламиИРаботами, Отказ, МассивНепроверяемыхРеквизитов);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий.РасходМатериаловИРабот, Отказ, МассивНепроверяемыхРеквизитов);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий.ЭкономияМатериалов, Отказ, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СписокЭтапов

Функция ДанныеДляПроверкиЗаполнения() Экспорт
	
	ДанныеДляПроверки = УправлениеПроизводством.ДанныеЭтаповДляПроверкиЗаполнения();
	
	// Шапка
	Для каждого Строка Из Этапы Цикл
		НоваяСтрока = ДанныеДляПроверки.Реквизиты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	// ТЧ
	СписокТЧ = Новый Массив;
	СписокТЧ.Добавить("ВыходныеИзделия");
	СписокТЧ.Добавить("ПобочныеИзделия");
	СписокТЧ.Добавить("ОбеспечениеМатериаламиИРаботами");
	СписокТЧ.Добавить("РасходМатериаловИРабот");
	СписокТЧ.Добавить("ЭкономияМатериалов");
	СписокТЧ.Добавить("Трудозатраты");
	Для каждого ИмяТЧ Из СписокТЧ Цикл
		Если ДанныеДляПроверки.Свойство("ПроверятьТЧ" + ИмяТЧ) Тогда
			ДанныеДляПроверки["ПроверятьТЧ" + ИмяТЧ] = Истина;
			Для каждого Строка Из ЭтотОбъект[ИмяТЧ] Цикл
				ЗаполнитьЗначенияСвойств(ДанныеДляПроверки[ИмяТЧ].Добавить(), Строка);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

Функция ПутьКДаннымРеквизитаФормыРедактирования() Экспорт
	
	Возврат "Объект";
	
КонецФункции

Функция СписокВложенныхТабличныхЧастей()
	
	Список = Новый Массив;
	
	Список.Добавить("ВыходныеИзделия");
	Список.Добавить("ВыходныеИзделияСерии");
	Список.Добавить("ПобочныеИзделия");
	Список.Добавить("ПобочныеИзделияСерии");
	
	Список.Добавить("ОбеспечениеМатериаламиИРаботами");
	Список.Добавить("РасходМатериаловИРабот");
	Список.Добавить("ЭкономияМатериалов");
	Список.Добавить("ЭкономияМатериаловСерии");
	
	Список.Добавить("Трудозатраты");
	
	Возврат Список;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

//-- НЕ УТКА

