////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен с банками по зарплатным проектам".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выгружает файл обмена с банком по платежному документу, который объединяет ведомости в банк.
//
// Параметры:
//		ПлатежныеДокументы  - Массив           - платежные документы (ДокументСсылка).
//		Форма               - УправляемаяФорма - форма, из которой производится выгрузка файла.
//
Процедура ВыгрузитьВФайлПлатежныеДокументыПеречисленияЗарплаты(ПлатежныеДокументы, Форма) Экспорт
	
	ТекстСостояния = НСтр("ru = 'Выполняется сохранение файлов.
	|Пожалуйста, подождите.';
	|en = 'Saving files.
	|Please wait.'");
	Состояние(ТекстСостояния);
	
	СтруктураПараметровДляФормированияФайла = Новый Структура;
	СтруктураПараметровДляФормированияФайла.Вставить("МассивДокументов", ПлатежныеДокументы);
	СтруктураПараметровДляФормированияФайла.Вставить("УникальныйИдентификаторФормы", Форма.УникальныйИдентификатор);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Форма.УникальныйИдентификатор);
	
	ПолучаемыеФайлы = 
		ОбменСБанкамиПоЗарплатнымПроектамВызовСервера.ВыгрузитьФайлыДляОбменаСБанком(
			СтруктураПараметровДляФормированияФайла, 
			АдресХранилища);
	
	СохранитьФайлыДляОбменаСБанком(ПолучаемыеФайлы);
	
	Если ПлатежныеДокументы.Количество() > 0 Тогда
		ОповеститьОбИзменении(ТипЗнч(ПлатежныеДокументы[0]));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Конструирует структуру данных для заполнения параметров загрузки подтверждений из файлов обмена с банками.
//
// Возвращаемое значение
//		ПомещаемыеФайлы -	Массив объектов типа ОписаниеПередаваемогоФайла,
//							каждый объект описывает получаемый файл.
//		ПомещенныеФайлы -	Массив объектов типа ОписаниеПереданногоФайла,
//							каждый объект описывает помещенный файл.
//		КаталогФайлов -		Каталог загрузки файлов.
//
//
Функция ПараметрыЗагрузкиФайловИзБанка() Экспорт
	
	Параметры = Новый Структура(
		"ПомещаемыеФайлы, 
		|ПомещенныеФайлы, 
		|КаталогФайлов, 
		|ОповещениеЗавершения, 
		|МножественныйВыбор,
		|СтруктураОшибок");
		
	Параметры.ПомещаемыеФайлы = Новый Массив; 
	Параметры.ПомещенныеФайлы = Новый Массив;
	Параметры.КаталогФайлов = ""; 
	Параметры.МножественныйВыбор = Истина;
	Параметры.СтруктураОшибок = Новый Структура;
		
	Возврат Параметры;
	
КонецФункции

// Конструирует структуру данных для заполнения параметров сохранения на диске файлов обмена с банками.
//
Функция ПараметрыСохраненияФайловДляБанка() Экспорт
	
	Параметры = Новый Структура(
		"ПолучаемыеФайлы,
		|КаталогФайлов, 
		|ИнициализированныйКаталогФайлов, 
		|ОповещениеЗавершения, 
		|СтруктураОшибок");
		
	Параметры.ПолучаемыеФайлы = Новый Массив;
	Параметры.КаталогФайлов = ""; 
	Параметры.СтруктураОшибок = Новый Структура;
		
	Возврат Параметры;
	
КонецФункции

// Загружает файлы выбранные с диска на сервер.
//
Процедура ЗагрузитьФайлыИзБанка(ПараметрыЗагрузки) Экспорт
	
	ТекстСообщения = НСтр("ru = 'Для загрузки файлов рекомендуется установить расширение для веб-клиента 1С:Предприятие.';
							|en = 'To import files, install extension for the 1C:Enterprise web client. '");
	Обработчик = Новый ОписаниеОповещения("ЗагрузитьФайлыИзБанкаПродолжение", ЭтотОбъект, ПараметрыЗагрузки);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
	
КонецПроцедуры

// Сохраняет получаемые файлы на диск и сообщает пользователю об операции.
//
// Параметры:
//		ПолучаемыеФайлы - массив описаний файлов, которые должны быть сохранены на диск.
//		КаталогФайлов - Путь, куда сохранены файлы.
//
// Возвращаемое значение:
//		СтруктураОшибок - структура с ошибками, возникшими при сохранении файлов.
//
Процедура СохранитьФайлыДляОбменаСБанком(ПолучаемыеФайлы, ПараметрыСохранения = Неопределено) Экспорт
	
	МассивОшибок = Новый Массив;
	
	Если ПолучаемыеФайлы.Количество() = 0 Тогда
		ОписаниеОшибки = Новый Структура("Описание, ТекстОшибки");
		ОписаниеОшибки.ТекстОшибки = НСтр("ru = 'Сохранение файлов не выполнено.';
											|en = 'Files not saved.'");
		МассивОшибок.Добавить(Новый Структура("ОписаниеОшибки, ТекстСообщения", ОписаниеОшибки, ОписаниеОшибки.ТекстОшибки));
		Состояние(ОписаниеОшибки.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыСохранения = Неопределено Тогда
		ПараметрыСохранения = ПараметрыСохраненияФайловДляБанка();
	КонецЕсли;
	ПараметрыСохранения.ПолучаемыеФайлы = ПолучаемыеФайлы;
	
	ТекстСообщения = НСтр("ru = 'Для сохранения файлов рекомендуется установить расширение для веб-клиента 1С:Предприятие.';
							|en = 'To save files, install 1C:Enterprise web client extension.'");
	Обработчик = Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомПродолжение", ЭтотОбъект, ПараметрыСохранения);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
	
КонецПроцедуры

Процедура ОткрытьДокументПодтверждение(Форма) Экспорт
	
	Если Не ПустаяСтрока(Форма.ТипДокументаПодтвержденияИзБанка) Тогда
		Отбор = Новый Структура("Ссылка", Форма.ДокументПодтверждениеИзБанка);
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		ОткрытьФорму(Форма.ТипДокументаПодтвержденияИзБанка + ".ФормаСписка", ПараметрыФормы, Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьКомандыОбменаОбъекта(Форма, Источник, РазрешенаОтправкаДокумента = Истина) Экспорт
	
	Для Каждого КомандаОбмена Из Форма.КомандыОбмена Цикл
		ПоказыватьКоманду = Истина;
		Если Не РазрешенаОтправкаДокумента Или КомандаОбмена.Значение.Найти(Источник) = Неопределено Тогда
			ПоказыватьКоманду = Ложь;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, КомандаОбмена.Ключ, "Видимость", ПоказыватьКоманду);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьКомандыОбменаВедомости(Форма, Источник) Экспорт
	
	ОбновитьКомандыОбменаОбъекта(Форма, Источник, Форма.РазрешенаОтправкаОтдельнойВедомости);
	
КонецПроцедуры

Процедура СписокВедомостейПриАктивизацииСтроки(Форма, Элемент) Экспорт
	
	СписокПриАктивизацииСтроки(Форма, Элемент);
	ОбновитьКомандыОбменаСпискаВедомостей(Форма, Форма.Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьФайлДляОбменаСБанком(МассивДокументов, Форма) Экспорт
	
	ТекстСостояния = НСтр("ru = 'Выполняется сохранение файлов.
		|Пожалуйста, подождите.';
		|en = 'Saving files.
		|Please wait.'");
	Состояние(ТекстСостояния);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Форма.УникальныйИдентификатор);
	
	ПараметрыВыгрузки = Новый Структура("МассивДокументов, УникальныйИдентификаторФормы");
	ПараметрыВыгрузки.МассивДокументов = МассивДокументов;
	ПараметрыВыгрузки.УникальныйИдентификаторФормы = Форма.УникальныйИдентификатор;
	ПолучаемыеФайлы = ОбменСБанкамиПоЗарплатнымПроектамВызовСервера.ВыгрузитьФайлыДляОбменаСБанком(ПараметрыВыгрузки, АдресХранилища);
	
	СохранитьФайлыДляОбменаСБанком(ПолучаемыеФайлы);
	
	ОбменСБанкамиПоЗарплатнымПроектамКлиентВнутренний.ПослеВыгрузкиДокументовВФайл(МассивДокументов, ПолучаемыеФайлы, Форма);
	
КонецПроцедуры

Процедура ОбновитьКомандыОбменаФормыСписка(Форма, Источник, РазрешенаОтправкаДокумента = Ложь)
	
	ВыбранныеОбъекты = Новый Массив;
	ВыделенныеСтроки = Источник.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		ТекущаяСтрока = Источник.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущаяСтрока <> Неопределено И ТекущаяСтрока.Свойство("ЗарплатныйПроект") Тогда
			ВыбранныеОбъекты.Добавить(ТекущаяСтрока);
		КонецЕсли;
	КонецЦикла;
	Если ВыбранныеОбъекты.Количество() = 0 Тогда
		Для Каждого КомандаОбмена Из Форма.КомандыОбмена Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, КомандаОбмена.Ключ, "Видимость", Ложь);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	Для Каждого ВыбранныйОбъект Из ВыбранныеОбъекты Цикл
		ОбновитьКомандыОбменаОбъекта(Форма, ВыбранныйОбъект.ЗарплатныйПроект, РазрешенаОтправкаДокумента);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьКомандыОбменаСпискаВедомостей(Форма, Источник)
	
	ОбновитьКомандыОбменаФормыСписка(Форма, Источник, Форма.РазрешенаОтправкаОтдельнойВедомости);
	
КонецПроцедуры

#Область СохранениеФайловНаДиске

Процедура СохранитьФайлыДляОбменаСБанкомПродолжение(Подключено, ПараметрыСохранения) Экспорт
	
	Если Не Подключено Тогда
		// Веб-клиент без расширения для работы с файлами.
		Для Каждого ОписаниеФайла Из ПараметрыСохранения.ПолучаемыеФайлы Цикл
			ПолучитьФайл(ОписаниеФайла.Хранение, ОписаниеФайла.Имя, Истина);
		КонецЦикла;
		СохранитьФайлыДляОбменаСБанкомЗавершение(ПараметрыСохранения.ПолучаемыеФайлы, ПараметрыСохранения);
		Возврат;
	КонецЕсли;
	
	ОписаниеЗавершения = Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомЗавершение", ЭтотОбъект, ПараметрыСохранения);
	
	// Вариант для установленного расширения для работы с файлами.
	// Если каталог не передан, запрашиваем его перед записью.
	Если Не ЗначениеЗаполнено(ПараметрыСохранения.КаталогФайлов) Тогда
		ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогВыбораКаталога.Заголовок = НСтр("ru = 'Выберите папку для сохранения файлов обмена с банком';
												|en = 'Select a folder to save bank exchange files'");
		НачатьПолучениеФайлов(ОписаниеЗавершения, ПараметрыСохранения.ПолучаемыеФайлы, ДиалогВыбораКаталога, Истина);
		Возврат;
	КонецЕсли;
	
	// Если передан каталог проверим его и запишем, не запрашивая.
	
	// Проверим существует ли каталог.
	ВыбранныйКаталог = Новый Файл;
	ВыбранныйКаталог.НачатьИнициализацию(Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомПослеИнициализации", ЭтотОбъект, ПараметрыСохранения), ПараметрыСохранения.КаталогФайлов);
	
КонецПроцедуры

Процедура СохранитьФайлыДляОбменаСБанкомПослеИнициализации(ВыбранныйКаталог, ПараметрыСохранения) Экспорт
	
	ПараметрыСохранения.ИнициализированныйКаталогФайлов = ВыбранныйКаталог;
	
	ВыбранныйКаталог = ПараметрыСохранения.ИнициализированныйКаталогФайлов;
	ВыбранныйКаталог.НачатьПроверкуСуществования(Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомПослеПроверкиКаталогСуществует", ЭтотОбъект, ПараметрыСохранения));
	
КонецПроцедуры

Процедура СохранитьФайлыДляОбменаСБанкомПослеПроверкиКаталогСуществует(Существует, ПараметрыСохранения) Экспорт
	
	Если Не Существует Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Выбранного каталога не существует.';
										|en = 'The selected directory does not exist.'"));
		Возврат;
	КонецЕсли;
	
	// Проверим каталог ли это.
	ВыбранныйКаталог = ПараметрыСохранения.ИнициализированныйКаталогФайлов;
	ВыбранныйКаталог.НачатьПроверкуЭтоКаталог(Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомПослеПроверкиЭтоКаталог", ЭтотОбъект, ПараметрыСохранения));
	
КонецПроцедуры

Процедура СохранитьФайлыДляОбменаСБанкомПослеПроверкиЭтоКаталог(ЭтоКаталог, ПараметрыСохранения) Экспорт
	
	Если Не ЭтоКаталог Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Выбранный путь не является каталогом.';
										|en = 'The selected path is not a directory.'"));
		Возврат;
	КонецЕсли;
	
	// Проверка завершена, запишем файлы в каталог.
	НачатьПолучениеФайлов(Новый ОписаниеОповещения("СохранитьФайлыДляОбменаСБанкомЗавершение", ЭтотОбъект, ПараметрыСохранения), ПараметрыСохранения.ПолучаемыеФайлы, ПараметрыСохранения.КаталогФайлов, Ложь);
	
КонецПроцедуры

Процедура СохранитьФайлыДляОбменаСБанкомЗавершение(ПолученныеФайлы, ПараметрыСохранения) Экспорт
	
	// Оповещаем вызывающую сторону, если нас об этом просили.
	Если ПараметрыСохранения.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ПараметрыСохранения.ОповещениеЗавершения, ПолученныеФайлы <> Неопределено);
	КонецЕсли;
	
	Если ПолученныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыСохранения.ПолучаемыеФайлы.Количество() <> ПолученныеФайлы.Количество() Тогда
		Состояние(НСтр("ru = 'Файлы сохранены частично.';
						|en = 'Files partly saved.'"), , ПараметрыСохранения.КаталогФайлов);
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Файлы успешно сохранены.';
					|en = 'Files saved successfully.'"), , ПараметрыСохранения.КаталогФайлов);

КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаФайловСДиска

// Помещает файлы подтверждения банка по зарплатным проектам.
//
Процедура ЗагрузитьФайлыИзБанкаПродолжение(Подключено, ПараметрыЗагрузки) Экспорт
	
	Если Не Подключено Тогда
		// Веб-клиент без расширения для работы с файлами.
		ОповещениеФайла = Новый ОписаниеОповещения("ЗагрузитьФайлИзБанкаЗавершение", ЭтотОбъект, ПараметрыЗагрузки);
		НачатьПомещениеФайла(ОповещениеФайла);
		Возврат;
	КонецЕсли;
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("ЗагрузитьФайлыИзБанкаЗавершение", ЭтотОбъект, ПараметрыЗагрузки);
	
	// Вариант для установленного расширения для работы с файлами.
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.МножественныйВыбор = ПараметрыЗагрузки.МножественныйВыбор;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы подтверждения, полученные из банка';
										|en = 'Select confirmation files received from the bank'");
	ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Файлы подтверждения из банка(*.xml)|*.xml|Все файлы (*.*)|*.*';
										|en = 'Confirmation files from the bank(*.xml)|*.xml|All files (*.*)|*.*'");
	ДиалогОткрытияФайла.Каталог = ПараметрыЗагрузки.КаталогФайлов;
	
	НачатьПомещениеФайлов(ОповещениеЗавершения, , ДиалогОткрытияФайла, Истина);
	
КонецПроцедуры

Процедура ЗагрузитьФайлИзБанкаЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ПараметрыЗагрузки) Экспорт
	
	Если Результат Тогда
		ПараметрыЗагрузки.ПомещенныеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ВыбранноеИмяФайла, Адрес));
	КонецЕсли;
	
	ЗагрузитьФайлыИзБанкаЗавершение(ПараметрыЗагрузки.ПомещенныеФайлы, ПараметрыЗагрузки);
	
КонецПроцедуры

Процедура ЗагрузитьФайлыИзБанкаЗавершение(ПомещенныеФайлы, ПараметрыЗагрузки) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПомещенныеФайлы.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Загрузка файлов не выполнена.';
										|en = 'Files are not imported. '"));
	КонецЕсли;
	
	Если ПараметрыЗагрузки.СтруктураОшибок.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗагрузки.ОповещениеЗавершения <> Неопределено Тогда
		ПараметрыЗагрузки.ПомещенныеФайлы = ПомещенныеФайлы;
		ВыполнитьОбработкуОповещения(ПараметрыЗагрузки.ОповещениеЗавершения, ПараметрыЗагрузки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьПодтвержденияБанкаЗавершение(СозданныеДокументы) Экспорт
	
	ПриЗагрузкеБылиОшибки = Ложь;
	ДанныеОповещения = Новый Структура();
	Для Каждого СозданныйДокумент Из СозданныеДокументы Цикл
		
		Если СозданныйДокумент = Неопределено Тогда
			ПриЗагрузкеБылиОшибки = Истина;
			Продолжить;
		КонецЕсли;
		ДанныеОповещения.Вставить(ОбменСБанкамиПоЗарплатнымПроектамКлиентСервер.ПривестиСтрокуКИдентификатору(СозданныйДокумент.Ключ), ТипЗнч(СозданныйДокумент.Ключ));
		ДанныеОповещения.Вставить(ОбменСБанкамиПоЗарплатнымПроектамКлиентСервер.ПривестиСтрокуКИдентификатору(СозданныйДокумент.Значение), ТипЗнч(СозданныйДокумент.Значение));
		Если ТипЗнч(СозданныйДокумент.Ключ) = Тип("ДокументСсылка.ПодтверждениеОткрытияЛицевыхСчетовСотрудников") Тогда
			ДанныеОповещения.Вставить("ЗагруженоПодтверждениеОткрытияЛицевыхСчетов", СозданныйДокумент.Значение);
		ИначеЕсли ТипЗнч(СозданныйДокумент.Ключ) = Тип("ДокументСсылка.ПодтверждениеЗачисленияЗарплаты") Тогда
			ДанныеОповещения.Вставить("ЗагруженоПодтверждениеЗачисленияЗарплаты", СозданныйДокумент.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ЗначениеОповещения Из ДанныеОповещения Цикл
		Если ЗначениеОповещения.Ключ = "ЗагруженоПодтверждениеОткрытияЛицевыхСчетов" Или ЗначениеОповещения.Ключ = "ЗагруженоПодтверждениеЗачисленияЗарплаты" Тогда
			Оповестить(ЗначениеОповещения.Ключ, ЗначениеОповещения.Значение);
		Иначе
			ОповеститьОбИзменении(ЗначениеОповещения.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ПриЗагрузкеБылиОшибки Тогда
		Состояние(НСтр("ru = 'При загрузке файлов подтверждений банка были ошибки';
						|en = 'Errors occurred while importing the bank confirmation files'"));
	Иначе
		Состояние(НСтр("ru = 'Все файлы успешно загружены';
						|en = 'All files have been successfully imported'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура СписокПриАктивизацииСтроки(Форма, Элемент)
	
	ПоказыватьКомандуОбмена = Ложь;
	ИспользоватьПрямойОбмен = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Элементы = Форма.Элементы;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.Свойство("ЗарплатныйПроект") Тогда
		ПоказыватьКомандуОбмена = Истина;
		ПараметрыОтбора = Новый Структура("ЗарплатныйПроект", ТекущиеДанные.ЗарплатныйПроект);
		НайденныеСтроки = Форма.ПрямыеОбменыСБанкомПоЗарплатномуПроекту.НайтиСтроки(ПараметрыОтбора);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ИспользоватьПрямойОбмен = НайденнаяСтрока.ИспользоватьПрямойОбмен;
		КонецЦикла;
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыгрузитьФайлДляОбменаСБанком", "Видимость", ПоказыватьКомандуОбмена И Не ИспользоватьПрямойОбмен);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОтправитьВБанк", "Видимость", ПоказыватьКомандуОбмена И ИспользоватьПрямойОбмен);
	
КонецПроцедуры

Процедура СписокФормыПриАктивизацииСтроки(Форма, Элемент) Экспорт
	
	СписокПриАктивизацииСтроки(Форма, Элемент);
	ОбновитьКомандыОбменаФормыСписка(Форма, Форма.Элементы.Список, Истина);
	
КонецПроцедуры

#КонецОбласти