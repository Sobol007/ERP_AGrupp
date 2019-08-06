///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент

// Возвращает таблицу описаний внешних компонент, которые требуется обновлять автоматически с Портала 1С:ИТС.
//
// Возвращаемое значение:
//  ТаблицаЗначений - См. ПолучениеВнешнихКомпонент.ОписаниеВнешнихКомпонент
//          подсистемы ПолучениеВнешнихКомпонент Библиотеки интернет-поддержки пользователей (БИП).
//
Функция АвтоматическиОбновляемыеКомпоненты() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВнешниеКомпоненты.Идентификатор КАК Идентификатор,
			|	ВнешниеКомпоненты.Версия КАК Версия
			|ИЗ
			|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.ОбновлятьСПортала1СИТС";
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		
		МодульПолучениеВнешнихКомпонент = ОбщегоНазначения.ОбщийМодуль("ПолучениеВнешнихКомпонент");
		ОписаниеВнешнихКомпонент = МодульПолучениеВнешнихКомпонент.ОписаниеВнешнихКомпонент();
		
		Пока Выборка.Следующий() Цикл
			ОписаниеКомпоненты = ОписаниеВнешнихКомпонент.Добавить();
			ОписаниеКомпоненты.Идентификатор = Выборка.Идентификатор;
			ОписаниеКомпоненты.Версия = Выборка.Версия;
		КонецЦикла;
		
		Возврат ОписаниеВнешнихКомпонент;
		
	Иначе
		ВызватьИсключение 
			НСтр("ru = 'Ожидается существование подсистемы ""ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент""';
				|en = 'The ""OnlineUserSupport.Receiving ExternalComponents"" subsystem is expected to exist'");
	КонецЕсли;
	
КонецФункции

// Выполняет обновление внешних компонент.
//
// Параметры:
//  ДанныеВнешнихКомпонент - ТаблицаЗначений - таблица обновляемых компонент.
//    ** Идентификатор - Строка - идентификатор.
//    ** Версия - Строка - версия.
//    ** ДатаВерсии - Строка - дата версии.
//    ** Наименование - Строка - наименование.
//    ** ИмяФайла - Строка - имя файла.
//    ** АдресФайла - Строка - адрес файла.
//    ** КодОшибки - Строка - код ошибки.
//  АдресРезультата - Строка - (необязательный) адрес временного хранилища.
//      Если указан, в него будет помещено описание результата операции.
//
Процедура ОбновитьВнешниеКомпоненты(ДанныеВнешнихКомпонент, АдресРезультата = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент") Тогда
	
		Результат = "";
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ВнешниеКомпоненты.Ссылка КАК Ссылка,
			|	ВнешниеКомпоненты.Идентификатор КАК Идентификатор
			|ИЗ
			|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.Идентификатор В(&Идентификаторы)";
		
		Запрос.УстановитьПараметр("Идентификаторы", ДанныеВнешнихКомпонент.ВыгрузитьКолонку("Идентификатор"));
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		
		// Обход результата запроса.
		Для каждого СтрокаРезультата Из ДанныеВнешнихКомпонент Цикл
			
			ПредставлениеКомпоненты = ВнешниеКомпонентыСлужебный.ПредставлениеКомпоненты(
				СтрокаРезультата.Идентификатор, 
				СтрокаРезультата.Версия);
			
			КодОшибки = СтрокаРезультата.КодОшибки;
			
			Если ЗначениеЗаполнено(КодОшибки) Тогда
				
				Если КодОшибки = "АктуальнаяВерсия" Тогда
					Результат = Результат + ПредставлениеКомпоненты + " - " + НСтр("ru = 'Актуальная версия.';
																					|en = 'Current version.'") + Символы.ПС;
					Продолжить;
				КонецЕсли;
				
				ИнформацияОбОшибке = "";
				Если КодОшибки = "ОтсутствуетКомпонента" Тогда 
					ИнформацияОбОшибке = НСтр("ru = 'В сервисе внешних компонент не обнаружена внешняя компонента';
												|en = 'Add-in is not found in the add-in service'");
				ИначеЕсли КодОшибки = "ФайлНеЗагружен" Тогда 
					ИнформацияОбОшибке = НСтр("ru = 'При попытке загрузить файл внешней компоненты из сервиса, возникла ошибка';
												|en = 'An error occurred while trying to import add-in file from service'");
				КонецЕсли;
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'При загрузке внешней компоненты %1 возникала ошибка:
					           |%2';
					           |en = 'An error occurred while importing add-in %1:
					           |%2'"),
					ПредставлениеКомпоненты,
					ИнформацияОбОшибке);
				
				Результат = Результат + ПредставлениеКомпоненты + " - " + ИнформацияОбОшибке + Символы.ПС;
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент';
												|en = 'Update add-ins'",
					ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,,
					ТекстОшибки);
				
				Продолжить;
			КонецЕсли;
			
			Информация = ВнешниеКомпонентыСлужебный.ИнформацияОКомпонентеИзФайла(СтрокаРезультата.АдресФайла, Ложь);
			
			Если Не Информация.Разобрано Тогда 
				
				Результат = Результат + ПредставлениеКомпоненты + " - " + Информация.ОписаниеОшибки + Символы.ПС;
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент';
												|en = 'Update add-ins'",
					ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,, Информация.ОписаниеОшибки);
					
				Продолжить;
			КонецЕсли;
			
			// Поиск ссылки.
			Отбор = Новый Структура("Идентификатор", СтрокаРезультата.Идентификатор);
			Если Выборка.НайтиСледующий(Отбор) Тогда 
				
				Объект = Выборка.Ссылка.ПолучитьОбъект();
				
				// Когда уже загружена компонента по дате более свежая, чем на Портале 1С:ИТС, обновление не следует выполнять.
				Если Объект.ДатаВерсии > СтрокаРезультата.ДатаВерсии Тогда 
					Продолжить;
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(Объект, Информация.Реквизиты); // По данным манифеста.
				ЗаполнитьЗначенияСвойств(Объект, СтрокаРезультата);     // По данным с сайта.
				
				Объект.ДополнительныеСвойства.Вставить("ДвоичныеДанныеКомпоненты", Информация.ДвоичныеДанные);
				
				Объект.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Загружена с Портала 1С:ИТС. %1.';
						|en = 'Imported from 1C:ITS Portal. %1.'"),
					ТекущаяДатаСеанса());
				
				Попытка
					Объект.Записать();
					Результат = Результат 
						+ ПредставлениеКомпоненты + " - " + НСтр("ru = 'Успешно обновлена.';
																|en = 'Updated.'") + Символы.ПС;
				Исключение
					Результат = Результат 
						+ ПредставлениеКомпоненты + " - " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) + Символы.ПС;
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент';
													|en = 'Update add-ins'",
							ОбщегоНазначения.КодОсновногоЯзыка()),
						УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЗначениеЗаполнено(АдресРезультата) Тогда 
			ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		КонецЕсли;
		
	Иначе
		ВызватьИсключение 
			НСтр("ru = 'Ожидается существование подсистемы ""ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент""';
				|en = 'The ""OnlineUserSupport.Receiving ExternalComponents"" subsystem is expected to exist'");
	КонецЕсли;
	
КонецПроцедуры

// Структура параметров для см. процедуру ОбновитьОбщуюКомпоненту.
//
// Возвращаемое значение:
//  Структура - коллекция параметров:
//      * Идентификатор - Строка - идентификатор.
//      * Версия - Строка - версия.
//      * ДатаВерсии - Дата - дата версии.
//      * Наименование - Строка - наименование.
//      * ИмяФайла - Строка - имя файла.
//      * ПутьКФайлу - Строка - путь к файлу.
//
Функция ОписаниеПоставляемойОбщейКомпоненты() Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("Идентификатор");
	Описание.Вставить("Версия");
	Описание.Вставить("ДатаВерсии");
	Описание.Вставить("Наименование");
	Описание.Вставить("ИмяФайла");
	Описание.Вставить("ПутьКФайлу");
	Возврат Описание;
	
КонецФункции

// Выполняет обновление общих внешних компонент.
//
// Параметры:
//  ОписаниеКомпоненты - Структура - См. функцию ОписаниеПоставляемойОбщейКомпоненты.
//
Процедура ОбновитьОбщуюКомпоненту(ОписаниеКомпоненты) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ВнешниеКомпонентыВМоделиСервиса") Тогда
		МодульВнешниеКомпонентыВМоделиСервисаСлужебный = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыВМоделиСервисаСлужебный");
		МодульВнешниеКомпонентыВМоделиСервисаСлужебный.ОбновитьОбщуюКомпоненту(ОписаниеКомпоненты);
	КонецЕсли;
	
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент

#КонецОбласти

#КонецОбласти