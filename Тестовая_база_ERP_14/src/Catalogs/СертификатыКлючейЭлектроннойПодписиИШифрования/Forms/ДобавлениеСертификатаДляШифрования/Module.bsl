///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СертификатПараметрыРеквизитов = Новый Структура;
	Если Параметры.Свойство("Организация") Тогда
		СертификатПараметрыРеквизитов.Вставить("Организация", Параметры.Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.АдресДанныхСертификата) Тогда
		ДанныеСертификата = ПолучитьИзВременногоХранилища(Параметры.АдресДанныхСертификата);
		
		СертификатКриптографии = ЭлектроннаяПодписьСлужебный.СертификатИзДвоичныхДанных(ДанныеСертификата);
		Если СертификатКриптографии = Неопределено Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ПоказатьСтраницуУточнениеСвойствСертификата(ЭтотОбъект,
			СертификатКриптографии,
			СертификатКриптографии.Выгрузить(),
			ЭлектроннаяПодпись.СвойстваСертификата(СертификатКриптографии));
		
		Элементы.Назад.Видимость = Ложь;
	Иначе
		Если ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере() Тогда
			Элементы.ГруппаСертификаты.Заголовок =
				НСтр("ru = 'Личные сертификаты на компьютере и сервере';
					|en = 'Personal certificates on computer and on server'");
		КонецЕсли;
		
		ОшибкаПолученияСертификатовНаКлиенте = Параметры.ОшибкаПолученияСертификатовНаКлиенте;
		ОбновитьСписокСертификатовНаСервере(Параметры.СвойстваСертификатовНаКлиенте);
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка")) Тогда
		Элементы.СертификатОрганизация.Видимость = Ложь;
	Иначе
		ОпределяемыйТипОрганизацияНастроен = Истина;
	КонецЕсли;
	
	Элементы.СертификатПользователь.Подсказка =
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Пользователь.Подсказка;
	
	Элементы.СертификатОрганизация.Подсказка =
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Организация.Подсказка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Сертификат) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СертификатАдрес) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ПрограммыЭлектроннойПодписиИШифрования")
	 Или ВРег(ИмяСобытия) = ВРег("Запись_ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux") Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		Если Элементы.Назад.Видимость Тогда
			ОбновитьСписокСертификатов();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Установка_РасширениеРаботыСКриптографией") Тогда
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности наименования.
	ЭлектроннаяПодписьСлужебный.ПроверитьУникальностьПредставления(
		СертификатНаименование, Сертификат, "СертификатНаименование", Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатыНедоступныНаКлиентеНадписьНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Сертификаты на компьютере';
			|en = 'Certificates on computer'"), "", ОшибкаПолученияСертификатовНаКлиенте, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНедоступныНаСервереНадписьНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Сертификаты на сервере';
			|en = 'Certificates on server'"), "", ОшибкаПолученияСертификатовНаСервере, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВсеПриИзменении(Элемент)
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОткрытьИнструкциюПоРаботеСПрограммами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Далее(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		ОтпечатокВыбранногоСертификата = "";
	Иначе
		ОтпечатокВыбранногоСертификата = Элементы.Сертификаты.ТекущиеДанные.Отпечаток;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеТекущегоСертификата(Команда)
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ОткрытьСертификат(ТекущиеДанные.Отпечаток, Не ТекущиеДанные.ЭтоЗаявление);
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выделите сертификаты, которые требуется добавить.';
										|en = 'Select certificates that you want to add.'"));
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	
	Если ТекущиеДанные.ЭтоЗаявление Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Для этого сертификата заявление на выпуск еще не исполнено.
			           |Откройте заявление на выпуск сертификата и выполните требуемые шаги.';
			           |en = 'The application for issue for this certificate has not been processed yet.
			           |Open the application for certificate issue and perform the required steps.'"));
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
	Элементы.Далее.Доступность = Ложь;
	
	Если ЭлектроннаяПодписьСлужебныйКлиент.ИспользоватьЭлектроннуюПодписьВМоделиСервиса() И ТекущиеДанные.ВОблачномСервисе Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Отпечаток", Base64Значение(ТекущиеДанные.Отпечаток));
		МодульХранилищеСертификатовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ХранилищеСертификатовКлиент");
		МодульХранилищеСертификатовКлиент.НайтиСертификат(Новый ОписаниеОповещения(
			"ДалееПослеПоискаСертификатаВОблачномСервисе", ЭтотОбъект), СтруктураПоиска);
	Иначе
		ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСертификатПоОтпечатку(Новый ОписаниеОповещения(
			"ДалееПослеПоискаСертификата", ЭтотОбъект), ТекущиеДанные.Отпечаток, Ложь, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеПоискаСертификата(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("СертификатКриптографии") Тогда
		Результат.НачатьВыгрузку(Новый ОписаниеОповещения(
			"ДалееПослеВыгрузкиСертификата", ЭтотОбъект, Результат));
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	
	Если Результат.Свойство("СертификатНеНайден") Тогда
		Контекст.Вставить("ОписаниеОшибки", НСтр("ru = 'Сертификат не найден на компьютере (возможно удален).';
												|en = 'Certificate is not found on the computer (it might have been deleted).'"));
	Иначе
		Контекст.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
	КонецЕсли;
	
	ОбновитьСписокСертификатов(Новый ОписаниеОповещения(
		"ДалееПослеОбновленияСпискаСертификатов", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеВыгрузкиСертификата(ВыгруженныеДанные, СертификатКриптографии) Экспорт
	
	ПоказатьСтраницуУточнениеСвойствСертификата(ЭтотОбъект,
		СертификатКриптографии,
		ВыгруженныеДанные,
		ЭлектроннаяПодписьКлиент.СвойстваСертификата(СертификатКриптографии));
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеОбновленияСпискаСертификатов(Результат, Контекст) Экспорт
	
	ПоказатьПредупреждение(, Контекст.ОписаниеОшибки);
	Элементы.Далее.Доступность = Истина;
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеПоискаСертификатаВОблачномСервисе(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Результат.Выполнено Тогда
			ДалееПослеВыгрузкиСертификата(Результат.Сертификат.Сертификат, Результат.Сертификат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	
	Если Не Результат.Выполнено Тогда
		Контекст.Вставить("ОписаниеОшибки", НСтр("ru = 'Сертификат не найден в облачном сервисе (возможно удален).';
												|en = 'Certificate was not found in the cloud service (may have been deleted).'"));
	Иначе
		Контекст.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
	КонецЕсли;
	
	ОбновитьСписокСертификатов(Новый ОписаниеОповещения(
		"ДалееПослеОбновленияСпискаСертификатов", ЭтотОбъект, Контекст));
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыборСертификата;
	Элементы.Далее.КнопкаПоУмолчанию = Истина;
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		ДополнительныеПараметры.Вставить("ЭтоНовый");
	КонецЕсли;
	
	ЗаписатьСертификатВСправочник();
	
	ОповеститьОбИзменении(Сертификат);
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования",
		ДополнительныеПараметры, Сертификат);
	
	ОповеститьОВыборе(Сертификат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	Если ЗначениеЗаполнено(СертификатАдрес) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатАдрес, Истина);
	Иначе
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатОтпечаток, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьСтраницуУточнениеСвойствСертификата(Форма, СертификатКриптографии, ДанныеСертификата, СвойстваСертификата)
	
	Элементы = Форма.Элементы;
	
	Форма.СертификатАдрес = ПоместитьВоВременноеХранилище(ДанныеСертификата, Форма.УникальныйИдентификатор);
	
	Форма.СертификатОтпечаток = Base64Строка(СертификатКриптографии.Отпечаток);
	
	ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(
		Форма.СертификатОписаниеДанных, СвойстваСертификата);
	
	СохраненныеСвойства = СохраненныеСвойстваСертификата(
		Форма.СертификатОтпечаток,
		Форма.СертификатАдрес,
		Форма.СертификатПараметрыРеквизитов);
	
	Если Форма.СертификатПараметрыРеквизитов.Свойство("Наименование") Тогда
		Если Форма.СертификатПараметрыРеквизитов.Наименование.ТолькоПросмотр Тогда
			Элементы.СертификатНаименование.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Форма.ОпределяемыйТипОрганизацияНастроен Тогда
		Если Форма.СертификатПараметрыРеквизитов.Свойство("Организация") Тогда
			Если Не Форма.СертификатПараметрыРеквизитов.Организация.Видимость Тогда
				Элементы.СертификатОрганизация.Видимость = Ложь;
			ИначеЕсли Форма.СертификатПараметрыРеквизитов.Организация.ТолькоПросмотр Тогда
				Элементы.СертификатОрганизация.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Форма.Сертификат             = СохраненныеСвойства.Ссылка;
	Форма.СертификатНаименование = СохраненныеСвойства.Наименование;
	Форма.СертификатПользователь = СохраненныеСвойства.Пользователь;
	Форма.СертификатОрганизация  = СохраненныеСвойства.Организация;
	
	Элементы.Страницы.ТекущаяСтраница   = Элементы.СтраницаУточнениеСвойствСертификата;
	Элементы.Добавить.КнопкаПоУмолчанию = Истина;
	Элементы.Далее.Доступность          = Истина;
	
	Строка = ?(ЗначениеЗаполнено(Форма.Сертификат), НСтр("ru = 'Обновить';
														|en = 'Update'"), НСтр("ru = 'Добавить';
																					|en = 'Add'"));
	Если Элементы.Добавить.Заголовок <> Строка Тогда
		Элементы.Добавить.Заголовок = Строка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СохраненныеСвойстваСертификата(Знач Отпечаток, Адрес, ПараметрыРеквизитов)
	
	Возврат ЭлектроннаяПодписьСлужебный.СохраненныеСвойстваСертификата(Отпечаток, Адрес, ПараметрыРеквизитов, Истина);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокСертификатов(Оповещение = Неопределено)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСвойстваСертификатовНаКлиенте(Новый ОписаниеОповещения(
		"ОбновитьСписокСертификатовПродолжение", ЭтотОбъект, Контекст), Ложь, ПоказыватьВсе);
	
КонецПроцедуры

// Продолжение процедуры ОбновитьСписокСертификатов.
&НаКлиенте
Процедура ОбновитьСписокСертификатовПродолжение(Результат, Контекст) Экспорт
	
	ОшибкаПолученияСертификатовНаКлиенте = Результат.ОшибкаПолученияСертификатовНаКлиенте;
	
	ОбновитьСписокСертификатовНаСервере(Результат.СвойстваСертификатовНаКлиенте);
	
	Если Контекст.Оповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСертификатовНаСервере(Знач СвойстваСертификатовНаКлиенте)
	
	ОшибкаПолученияСертификатовНаСервере = Новый Структура;
	
	ЭлектроннаяПодписьСлужебный.ОбновитьСписокСертификатов(Сертификаты, СвойстваСертификатовНаКлиенте,
		Истина, Ложь, ОшибкаПолученияСертификатовНаСервере, ПоказыватьВсе);
	
	Если ЗначениеЗаполнено(ОтпечатокВыбранногоСертификата)
	   И (    Элементы.Сертификаты.ТекущаяСтрока = Неопределено
	      Или Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока) = Неопределено
	      Или Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока).Отпечаток
	              <> ОтпечатокВыбранногоСертификата) Тогда
		
		Отбор = Новый Структура("Отпечаток", ОтпечатокВыбранногоСертификата);
		Строки = Сертификаты.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			Элементы.Сертификаты.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаСертификатыНедоступныНаКлиенте.Видимость =
		ЗначениеЗаполнено(ОшибкаПолученияСертификатовНаКлиенте);
	
	Элементы.ГруппаСертификатыНедоступныНаСервере.Видимость =
		ЗначениеЗаполнено(ОшибкаПолученияСертификатовНаСервере);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСертификатВСправочник()
	
	ЭлектроннаяПодписьСлужебный.ЗаписатьСертификатВСправочник(ЭтотОбъект, , Истина);
	
КонецПроцедуры

#КонецОбласти
