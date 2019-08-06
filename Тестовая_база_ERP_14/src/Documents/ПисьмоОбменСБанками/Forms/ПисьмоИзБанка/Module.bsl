
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	МассивФайлов = Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Объект.Ссылка, МассивФайлов);
	Для каждого ЭлементКоллекции Из МассивФайлов Цикл
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементКоллекции, "ПометкаУдаления") Тогда
			Продолжить;
		КонецЕсли;
		НовСтрока = ПрисоединенныеФайлыТаблица.Добавить();
		НовСтрока.Ссылка = ЭлементКоллекции;
	КонецЦикла;
		
	ИспользуетсяКриптография = Ложь;
	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Банк) Тогда
		НастройкаОбмена = ОбменСБанками.НастройкаОбмена(Объект.Организация, Объект.Банк);
		ИспользуетсяКриптография = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаОбмена, "ИспользуетсяКриптография");
	КонецЕсли;
	Элементы.ФормаПоказатьПодписи.Видимость = ИспользуетсяКриптография;
	
	Если Объект.Прочитано Тогда
		Элементы.ФормаПрочитано.Пометка = Истина;
	КонецЕсли;
	
	Если ПрисоединенныеФайлыТаблица.Количество() = 0 Тогда
		Элементы.СохранитьФайлыНаДиск.Доступность = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
		// Обход ошибки проверки конфигурации
	Если Ложь Тогда
		Подключаемый_ВыполнитьКомандуНаСервере(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрисоединенныеФайлы

&НаКлиенте
Процедура ПрисоединенныеФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) Тогда
		ДанныеФайла = ДанныеФайла(Элемент.ТекущиеДанные.Ссылка, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	КонецЕсли;

	// Обход ошибки проверки конфигурации
	Если Ложь Тогда
		Подключаемый_ВыполнитьКоманду(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИнформациюДляТехническойПоддержки(Команда)
	
	СсылкаНаФайл = Неопределено; ИмяФайла = Неопределено;
	ПолучитьФайлДляТехническойПоддержки(Объект.Ссылка, УникальныйИдентификатор, СсылкаНаФайл, ИмяФайла);
	
	Если СсылкаНаФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьФайл(СсылкаНаФайл, ИмяФайла);

КонецПроцедуры

&НаКлиенте
Процедура Прочитано(Команда)
	
	УстановитьПризнакПрочитано(Объект.Ссылка);
	Элементы.ФормаПрочитано.Пометка = Не Элементы.ФормаПрочитано.Пометка;
	Оповестить("ОбновитьСостояниеОбменСБанками");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодписи(Команда)
	
	ПараметрыФормы = Новый Структура("Объект", Объект.Ссылка);
	ОткрытьФорму("Документ.ПисьмоОбменСБанками.Форма.Подписи", ПараметрыФормы, , , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Ответить(Команда)
	
	ПараметрыФормы = Новый Структура("ЗначениеЗаполнения", Объект.Ссылка);
	ОткрытьФорму("Документ.ПисьмоОбменСБанками.Форма.ПисьмоВБанк", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьПризнакПрочитано(Знач Ссылка)
	
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	ДокументОбъект.Прочитано = Не ДокументОбъект.Прочитано;
	ДокументОбъект.Записать();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеФайла(Знач ПрисоединенныйФайл, Знач УникальныйИдентификатор)
	
	Возврат РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура СохранитьФайлыНаДиск(Команда)
	
	МассивСсылок = Новый Массив;
	Для каждого ЭлементКоллекции Из ПрисоединенныеФайлыТаблица Цикл
		МассивСсылок.Добавить(ЭлементКоллекции.Ссылка);
	КонецЦикла;
	
	ПолучаемыеФайлы = ПолучаемыеФайлы(МассивСсылок, УникальныйИдентификатор);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПустойОбработчик", ЭлектронноеВзаимодействиеСлужебныйКлиент);
	
	НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы, КаталогДокументов(), Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьФайлДляТехническойПоддержки(Знач Письмо, Знач УникальныйИдентификатор, СсылкаНаФайл, ИмяФайла)
	
	СообщениеОбмена = ОбменСБанкамиСлужебный.СообщениеОбменаПоВладельцу(Письмо);
	
	Если Не ЗначениеЗаполнено(СообщениеОбмена) Тогда
		ТекстСообщения = НСтр("ru = 'Не найден электронный документ';
								|en = 'Email is not found'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанныеФайла = ОбменСБанкамиСлужебный.ДанныеФайлаДляТехническойПоддержки(СообщениеОбмена);
	
	Если ДвоичныеДанныеФайла = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружен присоединенный файл объекта.';
								|en = 'Attached file of the object is not found.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, СообщениеОбмена);
		Возврат;
	КонецЕсли;
	
	ИмяФайла = Строка(СообщениеОбмена);
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла) + ".zip";
	ИмяФайла = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(ИмяФайла);
	
	СсылкаНаФайл = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучаемыеФайлы(Знач МассивСсылок, Знач УникальныйИдентификатор)
	
	МассивВозврата = Новый Массив;
	Для каждого ЭлементКоллекции Из МассивСсылок Цикл
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(ЭлементКоллекции, УникальныйИдентификатор);
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ДанныеФайла.ИмяФайла, ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
		МассивВозврата.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	Возврат МассивВозврата;
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды



#КонецОбласти


