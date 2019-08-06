#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
//
// Возвращаемое значение:
//  Массив(Строка) - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриДобавленииКлассификаторов(Классификаторы) Экспорт
	
	Описатель = РаботаСКлассификаторами.ОписаниеКлассификатора();
	Описатель.Наименование           = НСтр("ru = 'Общероссийский классификатор основных фондов';
											|en = 'All-Russian Classifier of Fixed Assets'");
	Описатель.Идентификатор          = "RussianClassificationOfFixedAssets";
	Описатель.ОбновлятьАвтоматически = Истина;
	Описатель.ОбщиеДанные            = Истина;

	Классификаторы.Добавить(Описатель);
	
КонецПроцедуры

Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан) Экспорт
	
	Если Идентификатор <> "RussianClassificationOfFixedAssets" Тогда
		Возврат;
	КонецЕсли;
		
	ПутьКФайлу = ПолучитьИмяВременногоФайла();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ДвоичныеДанные.Записать(ПутьКФайлу);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПутьКФайлу);
	ЧтениеXML.ПерейтиКСодержимому();
	
	xmlnsКлассификатор = "urn:uuid:be515360-d4a7-11dc-8abf-0002a5d5c51b";
	xmlnsV8XDTO        = "http://v8.1c.ru/8.1/xdto";
	
	Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента
	   И ЧтениеXML.URIПространстваИмен = xmlnsКлассификатор
	   И ЧтениеXML.ЛокальноеИмя = "classifier" Тогда
		
		Если ЧтениеXML.ЗначениеАтрибута("classifier-type-id") <> "#ОКОФ" Тогда
			Возврат;
		КонецЕсли;
		
		МассивОбщихПакетовXDTO = Новый Массив;
		
		xdtoМодельXDTOТипов = xdtoПрочитать(
			Справочники.ОбщероссийскийКлассификаторОсновныхФондов.ПолучитьМакет("МодельXDTO").ПолучитьТекст(),
			ФабрикаXDTO, xmlnsV8XDTO, "Model");
			
		Для Каждого xdtoПакет Из xdtoМодельXDTOТипов.Package Цикл
			МассивОбщихПакетовXDTO.Добавить(xdtoПакет);
		КонецЦикла;
		
		ФабрикаXDTOКлассификаторов = Новый ФабрикаXDTO(xdtoМодельXDTOТипов);
		
		ЧтениеXML.Прочитать();
		Пока ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Или ЧтениеXML.Прочитать() Цикл
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				Если ЧтениеXML.ЛокальноеИмя = "additional-packages" И ЧтениеXML.URIПространстваИмен = xmlnsКлассификатор Тогда
					xdtoДопМодель = xdtoПрочитать(ЧтениеXML, ФабрикаXDTOКлассификаторов, xmlnsV8XDTO, "Model");
					Для Каждого xdtoПакет Из МассивОбщихПакетовXDTO Цикл
						xdtoДопМодель.Package.Добавить(xdtoПакет);
					КонецЦикла;
					ДанныеФабрикаXDTO = Новый ФабрикаXDTO(xdtoДопМодель);
				ИначеЕсли ЧтениеXML.ЛокальноеИмя = "data" И ЧтениеXML.URIПространстваИмен = xmlnsКлассификатор Тогда
					КоличествоЭлементов = Число(ЧтениеXML.ЗначениеАтрибута("item-count"));
					Содержание = xdtoПрочитать(ЧтениеXML, ДанныеФабрикаXDTO, xmlnsКлассификатор, "ClassifierDataType");
				Иначе
					ЧтениеXML.Пропустить();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	ЧтениеXML.Закрыть();
	УдалитьФайлы(ПутьКФайлу);
	
	Обработано = 0;
	Родитель = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка();
	
	НачатьТранзакцию();
	Попытка

        // Устанавливаем исключительную блокировку на справочник, чтобы предотвратить
        // параллельный запуск обновления классификатора из другого сеанса.
        БлокировкаДанных        = Новый БлокировкаДанных();
        ЭлементБлокировки      = БлокировкаДанных.Добавить("Справочник.ОбщероссийскийКлассификаторОсновныхФондов");
        ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
        БлокировкаДанных.Заблокировать();
	
		ЗаписатьКоллекциюВСправочник(Содержание.Строки, Родитель, Обработано, КоличествоЭлементов);
		Обработан = Истина;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление ОКОФ';
										|en = 'RNCFA update'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Обработчик обновления версии 3.0.46. Создает новый корневой элемент в справочнике и помещает в нее 
//  существующие корневые элементы, по формату относящиеся к ОКОФ ОК 013-94.
//
Процедура ОбновитьОКОФ_94() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОбщероссийскийКлассификаторОсновныхФондов.Ссылка
	|ИЗ
	|	Справочник.ОбщероссийскийКлассификаторОсновныхФондов КАК ОбщероссийскийКлассификаторОсновныхФондов
	|ГДЕ
	|	ОбщероссийскийКлассификаторОсновныхФондов.Родитель = ЗНАЧЕНИЕ(Справочник.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка)
	|	И ПОДСТРОКА(ОбщероссийскийКлассификаторОсновныхФондов.Код, 3, 1) = "" ""
	|	И ОбщероссийскийКлассификаторОсновныхФондов.Код ПОДОБНО ""[0-9][0-9]_%""");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КорневойЭлемент = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.НайтиПоКоду("ОК 013-94");
	Если КорневойЭлемент.Пустая() Тогда
		ЭлементОбъект = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.СоздатьЭлемент();
		ЭлементОбъект.Код = "ОК 013-94";
		ЭлементОбъект.Наименование = НСтр("ru = 'Утвержден Постановлением Госстандарта РФ от 26 декабря 1994 г. N 359';
											|en = 'Confirmed by decree of Federal Agency on Technical Regulating and Metrology of the Russian Federation dated December 26, 1994 No. 359'");
		ЭлементОбъект.НаименованиеГруппировки =
			НСтр("ru = 'Утвержден Постановлением Госстандарта РФ от 26 декабря 1994 г. N 359. Срок действия 01.01.1996 - 31.12.2016)';
				|en = 'Confirmed by decree of Federal Agency on Technical Regulating and Metrology of the Russian Federation dated December 26, 1994 No. 359. Validity period 01/01/1996 - 12/31/2016)'");
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ЭлементОбъект);
		
		КорневойЭлемент = ЭлементОбъект.Ссылка;
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		ЭлементОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЭлементОбъект.Родитель = КорневойЭлемент;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ЭлементОбъект);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция xdtoПрочитать(Знач XML, Знач Фабрика, Знач ТипURI = "", Знач ТипИмя = "")
	
	Если Не ПустаяСтрока(ТипИмя) Тогда
		Тип = Фабрика.Тип(ТипURI, ТипИмя);
	Иначе
		Тип = Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(XML) = Тип("Строка") Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(XML);
	Иначе
		ЧтениеXML = XML;
	КонецЕсли;
	
	Возврат Фабрика.ПрочитатьXML(ЧтениеXML, Тип);
	
КонецФункции

Процедура ЗаписатьКоллекциюВСправочник(Коллекция, Родитель, Обработано, КоличествоЭлементов)
	
	Пробелы = "                                                  "; // 50 пробелов (для «добивки» до длины кода)
	МетаданныеСправочника = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка().Метаданные();
		
	Для Каждого Строка Из Коллекция Цикл
		
		Обработано = Обработано + 1;
		
		Если КоличествоЭлементов > 0 Тогда
			Процент = Окр(100 * Обработано / КоличествоЭлементов);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 из %2';
					|en = '%1 out of %2'"), Формат(Обработано, "ЧГ="), Формат(КоличествоЭлементов, "ЧГ="));
			ДлительныеОперации.СообщитьПрогресс(Процент, ТекстСообщения);
		КонецЕсли;
		
		ТекСсылка = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.НайтиПоКоду(Строка.Код);
		
		// Создание элемента
		Если ТекСсылка.Пустая() Тогда
			Объект = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.СоздатьЭлемент();
		Иначе
			Объект = ТекСсылка.ПолучитьОбъект();
			// Если элемент справочника удалили, пока ссылка на него хранилась в дереве.
			Если Объект = Неопределено Тогда
				Объект = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.СоздатьЭлемент();
				Объект.УстановитьСсылкуНового(ТекСсылка);
			КонецЕсли;
		КонецЕсли;

		Попытка
			Объект.Заблокировать();
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление ОКОФ';
											|en = 'RNCFA update'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
		КонецПопытки;
		
		Если Объект.Заблокирован() Тогда
			
			// Заполнение элемента
			УстановитьНовоеЗначение(Объект.Родитель, Родитель);
			УстановитьНовоеЗначение(Объект.ПометкаУдаления, Ложь);
			УстановитьНовоеЗначение(Объект.НаименованиеГруппировки, Строка.Наименование);
			
			Если Объект.Модифицированность() Или Объект.ЭтоНовый() Тогда // уже бессмысленно проверять, изменились ли значения свойств
				
				ЗаполнитьЗначенияСвойств(Объект, Строка);
				
			Иначе
				
				Реквизиты = МетаданныеСправочника.Реквизиты;
				Для Каждого Свойство Из Строка.Свойства() Цикл
					
					Если ТипЗнч(Свойство.Тип) = Тип("ТипЗначенияXDTO") Тогда
						ИмяСвойства = Свойство.Имя;
						
						Если НРег(ИмяСвойства) = "код" Или НРег(ИмяСвойства) = "code" Тогда
							УстановитьНовоеЗначение(Объект.Код, Лев(Строка(Строка[ИмяСвойства]) + Пробелы, МетаданныеСправочника.ДлинаКода));
						ИначеЕсли НРег(ИмяСвойства) = "наименование" Или НРег(ИмяСвойства) = "description" Тогда
							УстановитьНовоеЗначение(Объект.Наименование, Строка[ИмяСвойства]);
						ИначеЕсли Реквизиты.Найти(ИмяСвойства) <> Неопределено Тогда
							УстановитьНовоеЗначение(Объект[ИмяСвойства], Строка[ИмяСвойства]);
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Объект.ОбменДанными.Загрузка = Истина;
			Объект.ДополнительныеСвойства.Вставить("ОбъектXDTO", Строка);
			Объект.ДополнительныеСвойства.Вставить("ЗагрузкаКлассификаторов", Истина);
			
			Если Объект.Модифицированность() Или Объект.ЭтоНовый() Тогда
				Объект.Записать();
			КонецЕсли;
			
		КонецЕсли;

		Если Строка.Свойства().Получить("amort_group") <> Неопределено Тогда
			
			xdtoАмортизационныеГруппы = Строка.amort_group;
			Если ТипЗнч(xdtoАмортизационныеГруппы) = Тип("ОбъектXDTO") Тогда // а не СписокXDTO
				
				ПодставнойМассив = Новый Массив;
				ПодставнойМассив.Добавить(xdtoАмортизационныеГруппы);
				xdtoАмортизационныеГруппы = ПодставнойМассив;
				
			КонецЕсли;
			
			Если xdtoАмортизационныеГруппы.Количество() > 0 Тогда
				
				НаборЗаписей = РегистрыСведений.АмортизационныеГруппыОКОФ.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ОКОФ.Установить(Объект.Ссылка);
				Для Каждого xdtoСсылкаНаАмортизационнуюГруппу Из xdtoАмортизационныеГруппы Цикл
					НомерГруппы = Число(xdtoСсылкаНаАмортизационнуюГруппу.АмортизационнаяГруппа);
					Если НомерГруппы = 0 Тогда //отдельная группа
						НомерГруппы = 11
					КонецЕсли;
					АмортизационнаяГруппа = Перечисления.АмортизационныеГруппы[НомерГруппы - 1];
					
					Запись = НаборЗаписей.Добавить();
					Запись.Активность            = Истина;
					Запись.ОКОФ                  = Объект.Ссылка;
					Запись.АмортизационнаяГруппа = АмортизационнаяГруппа;
					Запись.Примечание            = xdtoСсылкаНаАмортизационнуюГруппу.Примечание;
				КонецЦикла;
				НаборЗаписей.Записать(Истина);
				
			КонецЕсли;
			
		КонецЕсли;
	
		ЗаписатьКоллекциюВСправочник(Строка.Строки, Объект.Ссылка, Обработано, КоличествоЭлементов);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьНовоеЗначение(Параметр, Значение)
	
	Если Параметр <> Значение Тогда
		Параметр = Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли