
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.Сообщение) Тогда
		Отказ = Истина;
		Возврат;
	Иначе 
		Сообщение = Параметры.Сообщение;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	// извлекаем файл документа из содержимого сообщения
	СтрДокументы = КонтекстЭДО.ПолучитьВложенияТранспортногоСообщения(Сообщение, Истина, Перечисления.ТипыСодержимогоТранспортногоКонтейнера.СообщениеОПроверке, ИмяФайлаДокумента);
	Если СтрДокументы.Количество() = 0 Тогда
		ТекстПредупреждения = "Сообщение о проверке не обнаружено среди содержимого сообщения.";
		Возврат;
	КонецЕсли;
	СтрДокумент = СтрДокументы[0];
	
	// записываем вложение во временный файл
	ФайлДокумента = ПолучитьИмяВременногоФайла("xml");
	Попытка
		СтрДокумент.Данные.Получить().Записать(ФайлДокумента);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка выгрузки сообщения о проверке во временный файл:
                  |%1';
                  |en = 'An error occurred while exporting a check message to the temporary file:
                  |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецПопытки;
	
	// считываем документ из файла в дерево XML
	ОписаниеОшибки = "";
	ДеревоXML = КонтекстЭДО.ЗагрузитьXMLВДеревоЗначений(ФайлДокумента, , ОписаниеОшибки);
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ФайлДокумента);
	Если НЕ ЗначениеЗаполнено(ДеревоXML) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка чтения XML из файла:
                  |%1';
                  |en = 'An error occurred while reading XML from file:
                  |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// анализируем XML
	УзелФайл = ДеревоXML.Строки.Найти("Файл", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелФайл) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла: не обнаружен узел ""Файл"".';
				|en = 'Incorrect structure of XML file: the ""File"" node is not found.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// начинаем заполнять общие сведения
	ОбщиеСведения = Новый Структура;
	Для Каждого УзелСведений Из УзелФайл.Строки Цикл
		ИмяУзла = УзелСведений.Имя;
		Если ИмяУзла = "ИдФайл" ИЛИ ИмяУзла = "ВерсПрог" ИЛИ ИмяУзла = "ВерсФорм" Тогда
			ОбщиеСведения.Вставить(УзелСведений.Имя, СокрЛП(УзелСведений.Значение));
		КонецЕсли;
	КонецЦикла;
	
	УзелДокумент = УзелФайл.Строки.Найти("Документ", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелДокумент) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла: не обнаружен узел ""Документ"".';
				|en = 'Incorrect structure of XML file: the ""Document"" node is not found.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	УзелСвПроверка = УзелДокумент.Строки.Найти("СвПроверка", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелСвПроверка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла: не обнаружен узел ""СвПроверка"".';
				|en = 'Incorrect structure of XML file: the ""СвПроверка"" node is not found.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// продолжаем заполнять общие сведения
	Для Каждого УзелОбщСвед Из УзелСвПроверка.Строки Цикл
		ОбщиеСведения.Вставить(УзелОбщСвед.Имя, СокрЛП(УзелОбщСвед.Значение));
	КонецЦикла;
	
	//разбираем общие сведения
	Если ОбщиеСведения.Свойство("ИдФайл") Тогда
		ИдФайл = ОбщиеСведения.ИдФайл;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ВерсПрог") Тогда
		ВерсПрог = ОбщиеСведения.ВерсПрог;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ВерсФорм") Тогда
		ВерсФорм = ОбщиеСведения.ВерсФорм;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("НомерДокНП") Тогда
		НомерДокНП = ОбщиеСведения.НомерДокНП;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ДатаДокНП") Тогда
		ДатаДокНП = ОбщиеСведения.ДатаДокНП;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("РегНомДок") Тогда
		РегНомДок = ОбщиеСведения.РегНомДок;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ДатаРегБум") Тогда
		ДатаРегБум = ОбщиеСведения.ДатаРегБум;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ДатаРегЭл") Тогда
		ДатаРегЭл = ОбщиеСведения.ДатаРегЭл;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("НомерУведОткз") Тогда
		НомерУведОткз = ОбщиеСведения.НомерУведОткз;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ДатаУведОткз") Тогда
		ДатаУведОткз = ОбщиеСведения.ДатаУведОткз;
	КонецЕсли;

	// разбираем сведения об отметке
	Если НЕ ОбщиеСведения.Свойство("Отметка") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла: не обнаружен атрибут ""Отметка"".';
				|en = 'Incorrect structure of XML file: the ""Mark"" attribute is not found.'"),,,, Отказ);
		Возврат;
	Иначе
		КодОтметка = СокрЛП(ОбщиеСведения.Отметка);
		Если КодОтметка = "1" Тогда
			Отметка = "Проставлена отметка об уплате косвенных налогов.";
			Элементы.ГруппаУведомлениеОбОтказе.Видимость = Ложь;
		ИначеЕсли КодОтметка = "2" Тогда
			Отметка = "Проставлена отметка об освобождении от налогобложения.";
			Элементы.ГруппаУведомлениеОбОтказе.Видимость = Ложь;
		ИначеЕсли КодОтметка = "3" Тогда
			Отметка = "Принято решение об отказе в проставлении отметки";
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Некорректная структура XML файла: некорректное значение атрибута ""Отметка"".';
					|en = 'Incorrect structure of XML file: value of the ""Mark"" attribute is incorrect.'"),,,, Отказ);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Печать.Видимость = Параметры.ПечатьВозможна;
	Если Параметры.ПечатьВозможна Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбщиеСведенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура("ПечататьРезультатОбработки, ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти