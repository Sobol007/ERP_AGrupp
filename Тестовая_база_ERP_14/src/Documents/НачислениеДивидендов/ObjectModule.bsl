
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("ФизическиеЛица.Контрагент");
	
	НайденныеСтроки = ФизическиеЛица.НайтиСтроки(Новый Структура("ПрочийАкционер, Контрагент", Истина, Справочники.Контрагенты.ПустаяСсылка()));
	
	Для Каждого Строка Из НайденныеСтроки Цикл
		
		ТекстСообщения = НСтр("ru = 'Не заполнен акционер в строке %1 списка ""Физические лица""';
								|en = 'Stockholder is not filled in in line %1 of the ""Individuals"" list'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ФизическиеЛица", Строка.НомерСтроки, "Контрагент"),
			,
			Отказ);

	КонецЦикла;
	
	Если ФизическиеЛица.Количество() = 0 И ЮридическиеЛица.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указаны акционеры в списках получателей дивидендов';
				|en = 'Stockholders are not specified in the dividend recipient lists'"),
			ЭтотОбъект,
			"ФизическиеЛица",
			,
			Отказ);
		
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
	
	СуммаДокумента = ФизическиеЛица.Итог("Начислено") + ЮридическиеЛица.Итог("Начислено");
	ПериодУчетнойПолитики = ?(ЗначениеЗаполнено(Дата), КонецМесяца(Дата), КонецМесяца(ТекущаяДатаСеанса()));
	ПараметрыУчетнойПолитики = РегистрыСведений.УчетнаяПолитикаОрганизаций.ПараметрыУчетнойПолитики(Организация, ПериодУчетнойПолитики);
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПроводкиПоРаботникам = ПараметрыУчетнойПолитики.ПроводкиПоРаботникам
	КонецЕсли;
	
	Для Каждого Строка Из ФизическиеЛица Цикл
		Если Не ЗначениеЗаполнено(Строка.РегистрацияВНалоговомОргане) Тогда
			Строка.РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане(Организация, Дата);
		КонецЕсли;
	КонецЦикла;

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.НачислениеДивидендов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДоходыРасходыПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") Тогда
		
		УчетНДФЛРасширенный.СформироватьДоходыИНДФЛСДивидендов(
			Ссылка,
			Движения,
			Отказ,
			Организация,
			ДатаВыплаты,
			ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДивиденды,
			ВключатьВДекларациюПоНалогуНаПрибыль,
			Истина,
			ДатаВыплаты);
			
		УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДивиденды, Организация, ДатаВыплаты);
		
		УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияУдержанияПоКонтрагентамАкционерам(
			Движения,
			Отказ,
			Организация,
			ДатаВыплаты,
			ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаНачисления,
			,
			ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДивиденды);
			
	КонецЕсли;
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРеквизитыПоУмолчанию()
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	Ответственный = Пользователи.ТекущийПользователь();
	Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли