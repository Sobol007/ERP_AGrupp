
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ЭкспортныеСвойства

// Производит загрузку сообщения из указанного файла данных
//
Процедура ЗагрузкаСообщения(ИмяФайлаДанных, РезультатЗагрузки) Экспорт
	КомпонентыОбмена = КомпонентыОбмена("Получение", ИмяФайлаДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЧтениеXML = Новый ЧтениеXML;
	Попытка
		ЧтениеXML.ОткрытьФайл(ИмяФайлаДанных);
		ЛокальноеИмя = "";
		Пока ЛокальноеИмя <> "Body" И ЧтениеXML.Прочитать() Цикл
			ЛокальноеИмя = ЧтениеXML.ЛокальноеИмя;
		КонецЦикла;
		
		ЧтениеXML.Прочитать();
	Исключение
		РезультатЗагрузки.Отказ = Истина;
		РезультатЗагрузки.СтрокаСообщения = НСтр("ru = 'Загрузка данных не выполнена. Файл не найден или формат данных не поддерживается в текущей конфигурации';
												|en = 'Data import is not completed. The file is not found or data format is not supported in the current configuration '");
		Возврат;
	КонецПопытки;
	
	КомпонентыОбмена.Вставить("ФайлОбмена", ЧтениеXML);
	
	ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена);
	ЧтениеXML.Закрыть();
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		РезультатЗагрузки.Отказ = Истина;
		РезультатЗагрузки.СтрокаСообщения = НСтр("ru = 'При загрузке данных возникли ошибки:';
												|en = 'Errors occurred when importing data:'") + Символы.ПС + КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1 *
	|ИЗ РегистрСведений.РезультатыОбменаДанными
	|ГДЕ УзелИнформационнойБазы.Код is null";
	РезультатЗапроса = Запрос.Выполнить();
	РезультатЗагрузки.ЕстьПредупреждения = НЕ РезультатЗапроса.Пустой();
КонецПроцедуры

// Функция вызывает инициализацию компонент обмена
// по указанному адресу файла.
Функция КомпонентыОбмена(НаправлениеОбмена, ИмяФайлаДанных="") Экспорт
	
	Если ЗначениеЗаполнено(ИмяФайлаДанных) Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ИмяФайлаДанных);
		ЧтениеXML.Прочитать(); // Message
		ЧтениеXML.Прочитать(); // Header
		Header = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип("http://www.1c.ru/SSL/Exchange/Message", "Header"));
		ВерсияФорматаФайла = Header.AvailableVersion[0];
		ЧтениеXML.Закрыть();

		ДоступныеВерсииФормата = Новый Соответствие();
		ОбменДаннымиУТ.ДоступныеВерсииУниверсальногоФормата(ДоступныеВерсииФормата);
		Если ДоступныеВерсииФормата.Получить(ВерсияФорматаФайла) = Неопределено Тогда
			Отказ = Истина;
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ВерсияФорматаФайла = "1.2";
	КонецЕсли;
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена(НаправлениеОбмена);
	
	КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь;
	КомпонентыОбмена.Вставить("УзелКорреспондента", ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ПустаяСсылка());
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = НСтр("ru = 'Перенос данных БП-УП';
															|en = 'Transfer EA-EM data'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	КомпонентыОбмена.ВерсияФорматаОбмена = ВерсияФорматаФайла;
	КомпонентыОбмена.XMLСхема = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/" + ВерсияФорматаФайла;
	
	// Определение менеджера обмена для версии формата
	ДоступныеВерсииФормата = Новый Соответствие();
	ОбменДаннымиУТ.ДоступныеВерсииУниверсальногоФормата(ДоступныеВерсииФормата);
	КомпонентыОбмена.МенеджерОбмена = ДоступныеВерсииФормата.Получить(ВерсияФорматаФайла);
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	
	Возврат КомпонентыОбмена;
	
КонецФункции

// Производит загрузку данных из текста в объекты информационной базы
//
Функция XMLТекстВДанныеИБ(КомпонентыОбмена, Текст, ИмяПравилаЗагрузки) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Текст);
	ЧтениеXML.Прочитать();
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип(ЧтениеXML.URIПространстваИмен, ЧтениеXML.ЛокальноеИмя));
	ДанныеXDTO = ОбменДаннымиXDTOСервер.ОбъектXDTOВСтруктуру(ОбъектXDTO);
	
	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ПКОПоИмени(КомпонентыОбмена, ИмяПравилаЗагрузки);
	ДанныеИБ = ОбменДаннымиXDTOСервер.СтруктураОбъектаXDTOВДанныеИБ(КомпонентыОбмена, ДанныеXDTO, ПравилоКонвертации, "КонвертироватьИЗаписать");
	
	Возврат ДанныеИБ.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли