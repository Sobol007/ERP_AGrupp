///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
//
// Возвращаемое значение:
//  Массив(Строка) - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Наименование");
	
	Возврат Результат;
	
КонецФункции

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СвойстваРазделовДатЗапрета() Экспорт
	
	Разделы = Новый ТаблицаЗначений;
	Разделы.Колонки.Добавить("Имя",           Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(150)));
	Разделы.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("УникальныйИдентификатор"));
	Разделы.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Разделы.Колонки.Добавить("ТипыОбъектов",  Новый ОписаниеТипов("Массив"));
	
	ИнтеграцияПодсистемБСП.ПриЗаполненииРазделовДатЗапретаИзменения(Разделы);
	ДатыЗапретаИзмененияПереопределяемый.ПриЗаполненииРазделовДатЗапретаИзменения(Разделы);
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка в процедуре ПриЗаполненииРазделовДатЗапретаИзменения
		           |общего модуля ДатыЗапретаИзмененияПереопределяемый.';
		           |en = 'An error occurred in the ПриЗаполненииРазделовДатЗапретаИзменения
		           |procedure of the ДатыЗапретаИзмененияПереопределяемый common module.'")
		+ Символы.ПС
		+ Символы.ПС;
	
	РазделыДатЗапрета     = Новый Соответствие;
	РазделыБезОбъектов    = Новый Массив;
	ВсеРазделыБезОбъектов = Истина;
	
	ТипыОбъектовДатЗапрета = Новый Соответствие;
	Типы = Метаданные.ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.Тип.Типы();
	Для Каждого Тип Из Типы Цикл
		Если Тип = Тип("ПеречислениеСсылка.ВидыНазначенияДатЗапрета")
		 Или Тип = Тип("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения")
		 Или Не ОбщегоНазначения.ЭтоСсылка(Тип) Тогда
			Продолжить;
		КонецЕсли;
		ТипыОбъектовДатЗапрета.Вставить(Тип, Истина);
	КонецЦикла;
	
	Для Каждого Раздел Из Разделы Цикл
		Если Не ЗначениеЗаполнено(Раздел.Имя) Тогда
			ВызватьИсключение ЗаголовокОшибки + НСтр("ru = 'Имя раздела дат запрета не заполнено.';
													|en = 'Name for closing date section is not populated.'");
		КонецЕсли;
		
		Если РазделыДатЗапрета.Получить(Раздел.Имя) <> Неопределено Тогда
			ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имя раздела дат запрета ""%1"" уже определено.';
					|en = 'Name for the ""%1"" closing date section is determined.'"),
				Раздел.Имя);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Раздел.Идентификатор) И Раздел.Имя <> "ОбщаяДата" Тогда
			ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Идентификатор раздела дат запрета ""%1"" не заполнен.';
					|en = 'The ""%1"" closing date section ID is required.'"),
				Раздел.Имя);
		КонецЕсли;
		
		РазделСсылка = ПолучитьСсылку(Раздел.Идентификатор);
		
		Если РазделыДатЗапрета.Получить(РазделСсылка) <> Неопределено Тогда
			ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Идентификатор ""%1"" раздела дат запрета
				           |""%2"" уже используется для раздела ""%3"".';
				           |en = 'The ""%1"" ID of the 
				           |""%2"" closing date section is already used for the ""%3"" section.'"),
				Раздел.Идентификатор, Раздел.Имя, РазделыДатЗапрета.Получить(РазделСсылка).Имя);
		КонецЕсли;
		
		ТипыОбъектов = Новый Массив;
		Для Каждого Тип Из Раздел.ТипыОбъектов Цикл
			ВсеРазделыБезОбъектов = Ложь;
			Если Не ОбщегоНазначения.ЭтоСсылка(Тип) Тогда
				ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Тип ""%1"" указан, как тип объектов для раздела дат запрета ""%2"".
					           |Однако это не тип ссылки.';
					           |en = 'The ""%1"" type is specified as an object type for the ""%2"" closing date section. 
					           |However, it is not a reference type.'"),
					Строка(Тип), Раздел.Имя);
			КонецЕсли;
			Если ТипыОбъектовДатЗапрета.Получить(Тип) = Неопределено Тогда
				ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Тип объектов ""%1"" раздела дат запрета ""%2""
					           |не указан в свойстве ""Тип"" плана видов характеристик ""Разделы дат запрета изменения"".';
					           |en = 'The ""%1"" object type of the ""%2""
					           |closing date section is not specified in the Type property of the ""Sections of change closing dates"" сhart of characteristic types.'"),
					Строка(Тип), Раздел.Имя);
			КонецЕсли;
			МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
			ПолноеИмя = МетаданныеТипа.ПолноеИмя();
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
			СвойстваТипа = Новый Структура;
			СвойстваТипа.Вставить("ПустаяСсылка",  МенеджерОбъекта.ПустаяСсылка());
			СвойстваТипа.Вставить("ПолноеИмя",     ПолноеИмя);
			СвойстваТипа.Вставить("Представление", Строка(Тип));
			ТипыОбъектов.Добавить(Новый ФиксированнаяСтруктура(СвойстваТипа));
		КонецЦикла;
		
		СвойстваРаздела = Новый Структура;
		СвойстваРаздела.Вставить("Имя",           Раздел.Имя);
		СвойстваРаздела.Вставить("Ссылка",        РазделСсылка);
		СвойстваРаздела.Вставить("Представление", Раздел.Представление);
		СвойстваРаздела.Вставить("ТипыОбъектов",  Новый ФиксированныйМассив(ТипыОбъектов));
		СвойстваРаздела = Новый ФиксированнаяСтруктура(СвойстваРаздела);
		РазделыДатЗапрета.Вставить(СвойстваРаздела.Имя,    СвойстваРаздела);
		РазделыДатЗапрета.Вставить(СвойстваРаздела.Ссылка, СвойстваРаздела);
		
		Если ТипыОбъектов.Количество() = 0 Тогда
			РазделыБезОбъектов.Добавить(Раздел.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Добавление пустого раздела (общая дата).
	СвойстваРаздела = Новый Структура;
	СвойстваРаздела.Вставить("Имя", "");
	СвойстваРаздела.Вставить("Ссылка", ПустаяСсылка());
	СвойстваРаздела.Вставить("Представление", НСтр("ru = 'Общая дата';
													|en = 'Common date'"));
	СвойстваРаздела.Вставить("ТипыОбъектов",  Новый ФиксированныйМассив(Новый Массив));
	СвойстваРаздела = Новый ФиксированнаяСтруктура(СвойстваРаздела);
	РазделыДатЗапрета.Вставить(СвойстваРаздела.Имя,    СвойстваРаздела);
	РазделыДатЗапрета.Вставить(СвойстваРаздела.Ссылка, СвойстваРаздела);
	
	Свойства = Новый Структура;
	Свойства.Вставить("Разделы",               Новый ФиксированноеСоответствие(РазделыДатЗапрета));
	Свойства.Вставить("РазделыБезОбъектов",    Новый ФиксированныйМассив(РазделыБезОбъектов));
	Свойства.Вставить("ВсеРазделыБезОбъектов", ВсеРазделыБезОбъектов);
	Свойства.Вставить("БезРазделовИОбъектов",  Разделы.Количество() = 0);
	Свойства.Вставить("ЕдинственныйРаздел",    ?(Разделы.Количество() = 1,
	                                             РазделыДатЗапрета[Разделы[0].Имя].Ссылка,
	                                             ПустаяСсылка()));
	Свойства.Вставить("ПоказыватьРазделы",     Свойства.ВсеРазделыБезОбъектов
	                                           Или Не ЗначениеЗаполнено(Свойства.ЕдинственныйРаздел));
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

#КонецОбласти

#КонецЕсли