&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокумента 				= Параметры.ВидДокумента;
	ИННКППОрганизации 			= Параметры.ИННКППОрганизации;
	ИдентификаторФормыВладельца = Параметры.ИдентификаторФормыВладельца;
	
	СписокВыбораВидовДокументов = Элементы.ВидДокумента.СписокВыбора;
	СписокВыбораВидовДокументов.Добавить(Перечисления.ВидыПредставляемыхДокументов.СчетФактура);
	СписокВыбораВидовДокументов.Добавить(Перечисления.ВидыПредставляемыхДокументов.АктПриемкиСдачиРабот);
	СписокВыбораВидовДокументов.Добавить(Перечисления.ВидыПредставляемыхДокументов.ТоварнаяНакладнаяТОРГ12);
	СписокВыбораВидовДокументов.Добавить(Перечисления.ВидыПредставляемыхДокументов.КорректировочныйСчетФактура);
	СписокВыбораВидовДокументов.Добавить(Перечисления.ВидыПредставляемыхДокументов.ПередачаТоваров);
	СписокВыбораВидовДокументов.Добавить(Перечисления.ВидыПредставляемыхДокументов.ПередачаУслуг);
	СписокВыбораВидовДокументов.Добавить(Перечисления.ВидыПредставляемыхДокументов.УПД);
	СписокВыбораВидовДокументов.Добавить(Перечисления.ВидыПредставляемыхДокументов.УКД);
	
	СписокВыбораНаправлений = Элементы.Направление.СписокВыбора;
	СписокВыбораНаправлений.Добавить("Входящий", 	"Входящие");
	СписокВыбораНаправлений.Добавить("Исходящий", 	"Исходящие");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	ЗаполнитьПоОтборамТаблицуОтображаемыеДокументы();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ЗаполнитьПоОтборамТаблицуОтображаемыеДокументы();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеПриИзменении(Элемент)
	
	ЗаполнитьПоОтборамТаблицуОтображаемыеДокументы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого Строка Из ОтображаемыеДокументы Цикл
		Строка.Выбрать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого Строка Из ОтображаемыеДокументы Цикл
		Строка.Выбрать = Истина;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Выбрать", Истина);
	
	СтрокиВыбранныхДокументов = ОтображаемыеДокументы.НайтиСтроки(ПараметрыОтбора);
	
	Если СтрокиВыбранныхДокументов.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Для загрузки необходимо выбрать хотя бы один документ.';
								|en = 'Для загрузки необходимо выбрать хотя бы один документ.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;	
	
	СтруктураРезультата = Новый Структура;
	АдресТЗВыбранныеДокументы = ПоместитьВХранилищеТаблицуВыбранныхДокументов();
	СтруктураРезультата.Вставить("АдресТЗЗагруженныеДокументы", АдресТЗВыбранныеДокументы);
	СтруктураРезультата.Вставить("ПолноеИмяФайлаОбмена", ПолноеИмяФайлаОбменаНаСервере);
	
	ОповеститьОВыборе(СтруктураРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьФайл(ВыполняемоеОповещение)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлПослеПодключенияРасширенияРаботыСФайлами", ЭтотОбъект, ВыполняемоеОповещение);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения, , Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлПослеПодключенияРасширенияРаботыСФайлами(Результат, ВыполняемоеОповещение) Экспорт 

	ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами = Результат;
	
	НачалоИмениФайла = "EDI_" + ИННКППОрганизации + "_";
	
	Если ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами Тогда
		
		ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогВыбора.Заголовок = "Выберите файл для загрузки";
		ДиалогВыбора.МножественныйВыбор = Ложь;
		ДиалогВыбора.ПроверятьСуществованиеФайла = Истина;
		ДиалогВыбора.Фильтр = "ZIP архив(" + НачалоИмениФайла + "*.zip)|" + НачалоИмениФайла + "*.zip";
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлПослеВыбораФайла", ЭтотОбъект, ВыполняемоеОповещение);
		ДиалогВыбора.Показать(ОписаниеОповещения);
	
	Иначе
		
		АдресФайлаОбменаВоВременномХранилище = "";
		ИмяФайлаОбмена = "";                                                           
		
		ДополнительныеПараметры = Новый Структура("НачалоИмениФайла, ВыполняемоеОповещение", НачалоИмениФайла, ВыполняемоеОповещение);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(ОписаниеОповещения, АдресФайлаОбменаВоВременномХранилище, ИмяФайлаОбмена, Истина, УникальныйИдентификатор);
	    Возврат;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлПослеВыбораФайла(МассивПолныхИменВыбранныхФайлов, ВыполняемоеОповещение) Экспорт
	
	Если МассивПолныхИменВыбранныхФайлов = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайлаОбменаНаКлиенте = МассивПолныхИменВыбранныхФайлов[0];
	
	ПомещаемыеФайлы = Новый Массив;
	ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ПолноеИмяФайлаОбменаНаКлиенте); 
	ПомещаемыеФайлы.Добавить(ОписаниеФайла);

	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлПослеПомещенияФайла", ЭтотОбъект, ВыполняемоеОповещение); 
	НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы, , Ложь, УникальныйИдентификатор);
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлПослеПомещенияФайла(ПомещенныеФайлы, ВыполняемоеОповещение) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
		Возврат;
	КонецЕсли;	
	
	АдресФайлаОбменаВоВременномХранилище = ПомещенныеФайлы[0].Хранение;
		
	Результат = ЗагрузитьФайлНаСервере(АдресФайлаОбменаВоВременномХранилище);
	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлЗавершение(Результат, АдресФайлаОбменаВоВременномХранилище, ИмяФайлаОбмена, ДополнительныеПараметры) Экспорт
	
	НачалоИмениФайла = ДополнительныеПараметры.НачалоИмениФайла;
	ВыполняемоеОповещение = ДополнительныеПараметры.ВыполняемоеОповещение;
	
	Если НЕ Результат Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
		Возврат;
	КонецЕсли;
	
	Если НЕ КонтекстЭДОКлиент.ВыбранКорректныйФайл(ИмяФайлаОбмена, ".zip") Тогда
		ТекстПредупреждения = НСтр("ru = 'Имя выбираемого файла должно иметь формат %1*.zip';
									|en = 'Имя выбираемого файла должно иметь формат %1*.zip'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", НачалоИмениФайла);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
		Возврат;
	КонецЕсли;
	
	Результат = ЗагрузитьФайлНаСервере(АдресФайлаОбменаВоВременномХранилище);
	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Результат);

КонецПроцедуры

&НаСервере
Функция ЗагрузитьФайлНаСервере(АдресФайлаОбменаВоВременномХранилище)
	
	ПолноеИмяФайлаОбменаНаСервере = ПолучитьИмяВременногоФайла();
	ПолучитьИзВременногоХранилища(АдресФайлаОбменаВоВременномХранилище).Записать(ПолноеИмяФайлаОбменаНаСервере);
	
	// распаковываем файл описания из архива обмена
	ИмяФайлаОписания = "Описание.xml";
	ЧтениеЗИП = Новый ЧтениеZipФайла(ПолноеИмяФайлаОбменаНаСервере);
	ЭлементОписание = ЧтениеЗИП.Элементы.Найти(ИмяФайлаОписания);
	Если ЭлементОписание = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	КаталогРаспаковки = ОперацииСФайламиЭДКО.СоздатьВременныйКаталог();
	ЧтениеЗИП.Извлечь(ЭлементОписание, КаталогРаспаковки, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	
	// читаем XML
	ТекстXML = КонтекстЭДОСервер.ПрочитатьТекстИзФайла(КаталогРаспаковки + ИмяФайлаОписания, , Истина);
	Если НЕ ЗначениеЗаполнено(ТекстXML) Тогда
		ЧтениеЗИП.Закрыть();
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ПолноеИмяФайлаОбменаНаСервере);
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(КаталогРаспаковки);
		Возврат Ложь;
	КонецЕсли;
	
	// загружаем XML в дерево
	ДеревоXML = КонтекстЭДОСервер.ЗагрузитьСтрокуXMLВДеревоЗначений(ТекстXML);
	Если НЕ ЗначениеЗаполнено(ДеревоXML) Тогда
		ЧтениеЗИП.Закрыть();
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ПолноеИмяФайлаОбменаНаСервере);
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(КаталогРаспаковки);
		Возврат Ложь;
	КонецЕсли;
	
	// разбираем дерево XML, заполняем таблицу ЗагруженныеДокументы
	Если НЕ ЗаполнитьТаблицуЗагруженныеДокументы(ДеревоXML) Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	//заполняем таблицу ОтображаемыеДокументы
	ЗаполнитьПоОтборамТаблицуОтображаемыеДокументы();
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЗаполнитьТаблицуЗагруженныеДокументы(ДеревоXML)
	
	УзелФайл = ДеревоXML.Строки.Найти("Файл", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелФайл) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла описания.';
				|en = 'Некорректная структура XML файла описания.'"));
		Возврат Ложь;
	КонецЕсли;
	
	УзелВерсФорм 		= УзелФайл.Строки.Найти("ВерсФорм", 		"Имя");
	УзелДатаВыгрузки 	= УзелФайл.Строки.Найти("ДатаВыгрузки", 	"Имя");
	УзелВремяВыгрузки 	= УзелФайл.Строки.Найти("ВремяВыгрузки", 	"Имя");
	
	УзелОрганизация 	= УзелФайл.Строки.Найти("Организация", 		"Имя");
	УзелКонтрагенты 	= УзелФайл.Строки.Найти("Контрагенты", 		"Имя");
	
	УзлыДокумент = УзелФайл.Строки.НайтиСтроки(Новый Структура("Имя", "Документ"));
	
	Если НЕ ЗначениеЗаполнено(УзелВерсФорм) 
		ИЛИ НЕ ЗначениеЗаполнено(УзелДатаВыгрузки) 
		ИЛИ НЕ ЗначениеЗаполнено(УзелВремяВыгрузки) 
		ИЛИ НЕ ЗначениеЗаполнено(УзелОрганизация) 
		ИЛИ НЕ ЗначениеЗаполнено(УзелКонтрагенты) 
		ИЛИ НЕ ЗначениеЗаполнено(УзлыДокумент) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла описания.';
				|en = 'Некорректная структура XML файла описания.'"));
		Возврат Ложь;
		
	КонецЕсли;
	
	УзелНаименование 	= УзелОрганизация.Строки.Найти("Наименование", 		"Имя");
	УзелИНН			 	= УзелОрганизация.Строки.Найти("ИНН", 				"Имя");
	УзелКПП 			= УзелОрганизация.Строки.Найти("КПП", 				"Имя");
	
	Если НЕ ЗначениеЗаполнено(УзелНаименование) 
		ИЛИ НЕ ЗначениеЗаполнено(УзелИНН)Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла описания.';
				|en = 'Некорректная структура XML файла описания.'"));
		Возврат Ложь;
		
	КонецЕсли;
	
	ПредставлениеОрганизация = УзелНаименование.Значение + " " 
		+ УзелИНН.Значение 
		+ ?(ЗначениеЗаполнено(УзелКПП), "/" + УзелКПП.Значение, "");
		
	ПредставлениеДатаВремяВыгрузки = УзелДатаВыгрузки.Значение + " " + СтрЗаменить(УзелВремяВыгрузки.Значение, ".", ":");
	
	СоответствиеКонтрагентов = Новый Соответствие;
	СписокВыбораКонтрагентов = Элементы.Контрагент.СписокВыбора;
	СписокВыбораКонтрагентов.Очистить();
	
	Для каждого УзелКонтрагент Из УзелКонтрагенты.Строки Цикл
		УзелНаименование 	= УзелКонтрагент.Строки.Найти("Наименование",	"Имя");	
		УзелИНН			 	= УзелКонтрагент.Строки.Найти("ИНН", 			"Имя");
		УзелКПП 			= УзелКонтрагент.Строки.Найти("КПП", 			"Имя");
		УзелИдентификатор	= УзелКонтрагент.Строки.Найти("Идентификатор", 	"Имя");
		
		Если НЕ ЗначениеЗаполнено(УзелНаименование) 
			ИЛИ НЕ ЗначениеЗаполнено(УзелИНН)
			ИЛИ НЕ ЗначениеЗаполнено(УзелИдентификатор) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Некорректная структура XML файла описания.';
					|en = 'Некорректная структура XML файла описания.'"));
			Возврат Ложь;
			
		КонецЕсли;
		
		ПредставлениеКонтрагента = УзелНаименование.Значение + " " 
			+ УзелИНН.Значение 
			+ ?(ЗначениеЗаполнено(УзелКПП), "/" + УзелКПП.Значение, "");
		
		СоответствиеКонтрагентов.Вставить(УзелИдентификатор.Значение, ПредставлениеКонтрагента);
		СписокВыбораКонтрагентов.Добавить(ПредставлениеКонтрагента);
		
	КонецЦикла;
	
	ЗагруженныеДокументы.Очистить();
	
	СоответствиеВидовДокументов = Новый Соответствие;
	
	СоответствиеВидовДокументов.Вставить("01", Перечисления.ВидыПредставляемыхДокументов.СчетФактура);
	СоответствиеВидовДокументов.Вставить("02", Перечисления.ВидыПредставляемыхДокументов.АктПриемкиСдачиРабот);
	СоответствиеВидовДокументов.Вставить("03", Перечисления.ВидыПредставляемыхДокументов.ТоварнаяНакладнаяТОРГ12);
	СоответствиеВидовДокументов.Вставить("04", Перечисления.ВидыПредставляемыхДокументов.КорректировочныйСчетФактура);
	СоответствиеВидовДокументов.Вставить("05", Перечисления.ВидыПредставляемыхДокументов.ПередачаТоваров);
	СоответствиеВидовДокументов.Вставить("06", Перечисления.ВидыПредставляемыхДокументов.ПередачаУслуг);
	СоответствиеВидовДокументов.Вставить("07", Перечисления.ВидыПредставляемыхДокументов.УПД);
	СоответствиеВидовДокументов.Вставить("08", Перечисления.ВидыПредставляемыхДокументов.УКД);
	
	СоответствиеНаправлений = Новый Соответствие;
	
	СоответствиеНаправлений.Вставить("0", "Входящий");
	СоответствиеНаправлений.Вставить("1", "Исходящий");
	
	Для каждого УзелДокумент Из УзлыДокумент Цикл
		УзелВид				= УзелДокумент.Строки.Найти("Вид",				"Имя");	
		УзелКНД				= УзелДокумент.Строки.Найти("КНД",				"Имя");
		УзелНаправление		= УзелДокумент.Строки.Найти("Направление",		"Имя");
		УзелНомер			= УзелДокумент.Строки.Найти("Номер",			"Имя");
		УзелДата			= УзелДокумент.Строки.Найти("Дата",				"Имя");
		УзелНомерДокОсн		= УзелДокумент.Строки.Найти("НомерДокОсн",		"Имя");
		УзелДатаДокОсн		= УзелДокумент.Строки.Найти("ДатаДокОсн",		"Имя");
		УзелИдКонтрагента	= УзелДокумент.Строки.Найти("ИдКонтрагента",	"Имя");
		УзелФайлДок			= УзелДокумент.Строки.Найти("ФайлДок",			"Имя");
		УзелФайлЭЦП			= УзелДокумент.Строки.Найти("ФайлЭЦП",			"Имя");
		
		
		Если НЕ ЗначениеЗаполнено(УзелВид) 
			ИЛИ НЕ ЗначениеЗаполнено(УзелКНД)
			ИЛИ НЕ ЗначениеЗаполнено(УзелНаправление)
			ИЛИ НЕ ЗначениеЗаполнено(УзелНомер)
			ИЛИ НЕ ЗначениеЗаполнено(УзелДата)
			ИЛИ НЕ ЗначениеЗаполнено(УзелИдКонтрагента)
			ИЛИ НЕ ЗначениеЗаполнено(УзелФайлДок)
			ИЛИ НЕ ЗначениеЗаполнено(УзелФайлЭЦП) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Некорректная структура XML файла описания.';
					|en = 'Некорректная структура XML файла описания.'"));
			Возврат Ложь;
			
		КонецЕсли;
		
		УзелФайлДокИмя		= УзелФайлДок.Строки.Найти("Имя", 		"Имя");
		УзелФайлДокРазмер	= УзелФайлДок.Строки.Найти("Размер", 	"Имя");
		
		УзелФайлЭЦПИмя		= УзелФайлЭЦП.Строки.Найти("Имя", 		"Имя");
		УзелФайлЭЦПРазмер	= УзелФайлЭЦП.Строки.Найти("Размер", 	"Имя");
		
		Если НЕ ЗначениеЗаполнено(УзелФайлДокИмя) 
			ИЛИ НЕ ЗначениеЗаполнено(УзелФайлДокРазмер)
			ИЛИ НЕ ЗначениеЗаполнено(УзелФайлЭЦПИмя)
			ИЛИ НЕ ЗначениеЗаполнено(УзелФайлЭЦПРазмер) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Некорректная структура XML файла описания.';
					|en = 'Некорректная структура XML файла описания.'"));
			Возврат Ложь;
			
		КонецЕсли;
		
		//добавляем новую строку таблицы ЗагруженныеДокументы и заполняем ее
		НоваяСтрока = ЗагруженныеДокументы.Добавить();
		
		НоваяСтрока.ВидДокумента 		= СоответствиеВидовДокументов[УзелВид.Значение];
		НоваяСтрока.КНД 				= УзелКНД.Значение;
		НоваяСтрока.Направление 		= СоответствиеНаправлений[УзелНаправление.Значение];
		НоваяСтрока.Номер 				= УзелНомер.Значение;
		НоваяСтрока.Дата 				= ДатаИзСтроки(УзелДата.Значение);
		НоваяСтрока.НомерДокОсн 		= ?(ЗначениеЗаполнено(УзелНомерДокОсн), УзелНомерДокОсн.Значение, "");
		НоваяСтрока.ДатаДокОсн 			= ?(ЗначениеЗаполнено(УзелНомерДокОсн), ДатаИзСтроки(УзелДатаДокОсн.Значение), "");
		НоваяСтрока.Контрагент 			= СоответствиеКонтрагентов[УзелИдКонтрагента.Значение];
		НоваяСтрока.ФайлВыгрузкиИмя 	= УзелФайлДокИмя.Значение;
		НоваяСтрока.ФайлВыгрузкиРазмер 	= XMLЗначение(Тип("Число"),УзелФайлДокРазмер.Значение);
		НоваяСтрока.ФайлПодписиИмя 		= УзелФайлЭЦПИмя.Значение;
		НоваяСтрока.ФайлПодписиРазмер 	= XMLЗначение(Тип("Число"),УзелФайлЭЦПРазмер.Значение);
		
		ЕстьФайлыПодтверждения = УзелДокумент.Строки.Найти("ФайлДокПодтверждения", "Имя") <> Неопределено;
		Если ЕстьФайлыПодтверждения Тогда
			УзелФайлДокПодтверждения = УзелДокумент.Строки.Найти("ФайлДокПодтверждения", "Имя");
			УзелФайлЭЦППодтверждения = УзелДокумент.Строки.Найти("ФайлЭЦППодтверждения", "Имя");
			
			УзелПодтверждениеКНД = УзелФайлДокПодтверждения.Строки.Найти("КНД", "Имя");
			
			УзелФайлДокПодтвержденияИмя		= УзелФайлДокПодтверждения.Строки.Найти("Имя", 		"Имя");
			УзелФайлДокПодтвержденияРазмер	= УзелФайлДокПодтверждения.Строки.Найти("Размер", 	"Имя");
		
			УзелФайлЭЦППодтвержденияИмя		= УзелФайлЭЦППодтверждения.Строки.Найти("Имя", 		"Имя");
			УзелФайлЭЦППодтвержденияРазмер	= УзелФайлЭЦППодтверждения.Строки.Найти("Размер", 	"Имя");
			
			НоваяСтрока.ПодтверждениеКНД 				= УзелПодтверждениеКНД.Значение;
			НоваяСтрока.ПодтверждениеФайлВыгрузкиИмя 	= УзелФайлДокПодтвержденияИмя.Значение;
			НоваяСтрока.ПодтверждениеФайлВыгрузкиРазмер = XMLЗначение(Тип("Число"),УзелФайлДокПодтвержденияРазмер.Значение);
			НоваяСтрока.ПодтверждениеФайлПодписиИмя 	= УзелФайлЭЦППодтвержденияИмя.Значение;
			НоваяСтрока.ПодтверждениеФайлПодписиРазмер 	= XMLЗначение(Тип("Число"),УзелФайлЭЦППодтвержденияРазмер.Значение);
			
		Иначе
			
			НоваяСтрока.ПодтверждениеКНД 				= "";
			НоваяСтрока.ПодтверждениеФайлВыгрузкиИмя 	= "";
			НоваяСтрока.ПодтверждениеФайлВыгрузкиРазмер = 0;
			НоваяСтрока.ПодтверждениеФайлПодписиИмя 	= "";
			НоваяСтрока.ПодтверждениеФайлПодписиРазмер 	= 0;
			
		КонецЕсли;
		
		НоваяСтрока.ПредставлениеДокумента = Строка(НоваяСтрока.ВидДокумента) + " N" + НоваяСтрока.Номер + " от " + Формат(НоваяСтрока.Дата, "ДЛФ=D");
		Если ЗначениеЗаполнено(НоваяСтрока.НомерДокОсн) ИЛИ ЗначениеЗаполнено(НоваяСтрока.ДатаДокОсн) Тогда
			НоваяСтрока.ПредставлениеОснования = "Договор N" + НоваяСтрока.НомерДокОсн + " от " + Формат(НоваяСтрока.ДатаДокОсн, "ДЛФ=D");
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДатаИзСтроки(СтрДата)
	Если СтрДата = "" Тогда
		ВозвращаемаяДата = Дата(1, 1, 1);
	Иначе
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрДата, ".");
		Если Число(МассивПодстрок[0]) = 0 Тогда
			МассивПодстрок[0] = "1";
		КонецЕсли;
		Если Число(МассивПодстрок[1]) = 0 Тогда
			МассивПодстрок[1] = "1";
		КонецЕсли;
		Если Число(МассивПодстрок[2]) = 0 Тогда
			МассивПодстрок[2] = "1";
		КонецЕсли;
		ВозвращаемаяДата = Дата(МассивПодстрок[2], МассивПодстрок[1], МассивПодстрок[0]);
	КонецЕсли;
	
	Возврат ВозвращаемаяДата;
	
КонецФункции

&НаСервере
Функция ЗаполнитьПоОтборамТаблицуОтображаемыеДокументы()
	
	ПараметрыОтбора = Новый Структура;
	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		ПараметрыОтбора.Вставить("ВидДокумента", ВидДокумента);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Направление) Тогда
		ПараметрыОтбора.Вставить("Направление", Направление);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ПараметрыОтбора.Вставить("Контрагент", Контрагент);
	КонецЕсли;
	
	Если ПараметрыОтбора.Количество() = 0 Тогда
		ОтобранныеСтроки = ЗагруженныеДокументы;	// ОтобранныеСтроки - ТЗ
	Иначе
		ОтобранныеСтроки = ЗагруженныеДокументы.НайтиСтроки(ПараметрыОтбора); // ОтобранныеСтроки - массив строк ТЗ
	КонецЕсли;
	
	ОтображаемыеДокументы.Очистить();
	
	Для каждого ОтобраннаяСтрока Из ОтобранныеСтроки Цикл
		НоваяСтрока = ОтображаемыеДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОтобраннаяСтрока); 
	КонецЦикла;
		
КонецФункции

&НаСервере
Функция ПоместитьВХранилищеТаблицуВыбранныхДокументов()
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Выбрать", Истина);
	
	ВыбранныеСтроки = ОтображаемыеДокументы.НайтиСтроки(ПараметрыОтбора);
	
	ТЗОтображаемыеДокументы = РеквизитФормыВЗначение("ОтображаемыеДокументы");
	ВыбранныеДокументы = ТЗОтображаемыеДокументы.Скопировать(Новый Массив);
	
	Для каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		НоваяСтрока = ВыбранныеДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыбраннаяСтрока); 
	КонецЦикла;
	
 	Возврат ПоместитьВоВременноеХранилище(ВыбранныеДокументы, ИдентификаторФормыВладельца);
		
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеЗагрузкиФайла", ЭтотОбъект);
	
	ЗагрузитьФайл(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииПослеЗагрузкиФайла(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатЗагрузки Тогда
		Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти