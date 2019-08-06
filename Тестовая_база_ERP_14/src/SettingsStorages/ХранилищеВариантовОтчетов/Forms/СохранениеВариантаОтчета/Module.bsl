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
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОпределитьПоведениеВМобильномКлиенте();
	
	Контекст = Новый Структура;
	Контекст.Вставить("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	Контекст.Вставить("ПолныеПраваНаВарианты", ВариантыОтчетов.ПолныеПраваНаВарианты());
	
	ПрототипКлюч = Параметры.КлючТекущихНастроек;
	
	ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(Параметры.КлючОбъекта);
	Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
		ВызватьИсключение ОтчетИнформация.ТекстОшибки;
	КонецЕсли;
	Контекст.Вставить("ОтчетСсылка", ОтчетИнформация.Отчет);
	Контекст.Вставить("ОтчетИмя",    ОтчетИнформация.ОтчетИмя);
	Контекст.Вставить("ТипОтчета",   ОтчетИнформация.ТипОтчета);
	Контекст.Вставить("ЭтоВнешний",  ОтчетИнформация.ТипОтчета = Перечисления.ТипыОтчетов.Внешний);
	Контекст.Вставить("ПоискПоНаименованию", Новый Соответствие);
	
	ЗаполнитьСписокВариантов(Ложь);
	
	Элементы.ГруппаДоступен.ТолькоПросмотр = Не Контекст.ПолныеПраваНаВарианты;
	Если Контекст.ЭтоВнешний Тогда
		Элементы.ОписаниеВнешнегоОтчета.Видимость = Истина;
		Элементы.ВариантВидимостьПоУмолчанию.Видимость = Ложь;
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Ложь;
		Элементы.ГруппаДоступен.Видимость = Ложь;
		Элементы.ДекорацияЧтоБудетДальшеНовый.Заголовок = НСтр("ru = 'Будет сохранен новый вариант отчета.';
																|en = 'A new report option will be saved.'");
		Элементы.ДекорацияЧтоБудетДальшеПерезапись.Заголовок = НСтр("ru = 'Будет перезаписан существующий вариант отчета.';
																	|en = 'Existing report option will be rewritten.'");
	КонецЕсли;
	
	ЛокализуемыеЭлементы = Новый Массив;
	ЛокализуемыеЭлементы.Добавить(Элементы.Наименование);
	ЛокализуемыеЭлементы.Добавить(Элементы.ОписаниеВнешнегоОтчета);
	ЛокализуемыеЭлементы.Добавить(Элементы.Описание);
	ЛокализацияСервер.ПриСозданииНаСервере(ЛокализуемыеЭлементы);
	
	Элементы.Описание.КнопкаВыбора = Не Элементы.Описание.КнопкаОткрытия;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Поле ""Наименование"" не заполнено';
				|en = 'Name is not populated'"),
			,
			"Наименование");
		Отказ = Истина;
	ИначеЕсли ВариантыОтчетов.НаименованиеЗанято(Контекст.ОтчетСсылка, ВариантСсылка, Объект.Наименование) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '""%1"" занято, необходимо указать другое Наименование.';
					|en = '""%1"" is already used, enter another Name.'"),
				Объект.Наименование),
			,
			"Наименование");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник = ИмяФормы Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = ВариантыОтчетовКлиент.ИмяСобытияИзменениеВарианта()
		Или ИмяСобытия = "Запись_НаборКонстант" Тогда
		ЗаполнитьСписокВариантов(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекущийЭлемент = Элементы.Наименование;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеОткрытие(Элемент, СтандартнаяОбработка)
	ЛокализацияКлиент.ПриОткрытии(Объект, Элемент, "Наименование", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	НаименованиеМодифицировано = Истина;
	УстановитьСценарийСохраненияВарианта();
КонецПроцедуры

&НаКлиенте
Процедура ДоступенПриИзменении(Элемент)
	Объект.ТолькоДляАвтора = (Доступен = "ТолькоАвтор");
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ОписаниеНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Элементы.Описание.ТекстРедактирования,
		НСтр("ru = 'Описание';
			|en = 'Details'"));
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОткрытие(Элемент, СтандартнаяОбработка)
	ЛокализацияКлиент.ПриОткрытии(Объект, Элемент, "Описание", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	ОписаниеМодифицировано = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеВнешнегоОтчетаОткрытие(Элемент, СтандартнаяОбработка)
	ЛокализацияКлиент.ПриОткрытии(Объект, Элемент, "Описание", СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВариантыОтчета

&НаКлиенте
Процедура ВариантыОтчетаПриАктивизацииСтроки(Элемент)
	Если Не НаименованиеМодифицировано И Не ОписаниеМодифицировано Тогда 
		ПодключитьОбработчикОжидания("УстановитьСценарийСохраненияВариантаОтложенно", 0.1, Истина);
	КонецЕсли;
	НаименованиеМодифицировано = Ложь;
	ОписаниеМодифицировано = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СохранитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьВариантДляИзменения();
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	Вариант = Элементы.ВариантыОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Контекст.ПолныеПраваНаВарианты И Не Вариант.АвторТекущийПользователь Тогда
		ТекстПредупреждения = НСтр("ru = 'Недостаточно прав для удаления варианта отчета ""%1"".';
									|en = 'Insufficient rights to delete the report option ""%1"".'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если Не Вариант.Пользовательский Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Невозможно удалить предопределенный вариант отчета.';
										|en = 'Cannot delete the predefined report option.'"));
		Возврат;
	КонецЕсли;
	
	Если Вариант.ПометкаУдаления Тогда
		ТекстВопроса = НСтр("ru = 'Снять с ""%1"" пометку на удаление?';
							|en = 'Clear mark for deletion for ""%1""?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Пометить ""%1"" на удаление?';
							|en = 'Mark ""%1"" for deletion?'");
	КонецЕсли;
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Вариант.Наименование);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Идентификатор", Вариант.ПолучитьИдентификатор());
	Обработчик = Новый ОписаниеОповещения("ВариантыОтчетаПередУдалениемЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да); 
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередУдалениемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УдалитьВариантНаСервере(ДополнительныеПараметры.Идентификатор);
		ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	ПерейтиНаСтраницу1();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	Пакет = Новый Структура;
	Пакет.Вставить("ПроверитьСтраницу1",       Истина);
	Пакет.Вставить("ПерейтиНаСтраницу2",       Истина);
	Пакет.Вставить("ЗаполнитьСтраницу2Сервер", Истина);
	Пакет.Вставить("ПроверитьИЗаписатьСервер", Ложь);
	Пакет.Вставить("ЗакрытьПослеЗаписи",       Ложь);
	Пакет.Вставить("ТекущийШаг", Неопределено);
	
	ВыполнитьПакет(Неопределено, Пакет);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьИЗакрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	ЭтоМобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	Если Не ЭтоМобильныйКлиент Тогда 
		Возврат;
	КонецЕсли;
	
	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыОтчета.Пользовательский");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
 
 	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПолныеПраваНаВарианты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыОтчета.АвторТекущийПользователь");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);
	
 	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыОтчета.Порядок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 3;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);
	
	ВариантыОтчетов.УстановитьУсловноеОформлениеДереваПодсистем(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура УстановитьСценарийСохраненияВариантаОтложенно()
	УстановитьСценарийСохраненияВарианта();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПакет(Результат, Пакет) Экспорт
	Если Не Пакет.Свойство("ВариантЭтоНовый") Тогда
		Пакет.Вставить("ВариантЭтоНовый", Не ЗначениеЗаполнено(ВариантСсылка));
	КонецЕсли;
	
	// Обработка результата предыдущего шага.
	Если Пакет.ТекущийШаг = "ВопросНаПерезапись" Тогда
		Пакет.ТекущийШаг = Неопределено;
		Если Результат = КодВозвратаДиалога.Да Тогда
			Пакет.Вставить("ВопросНаПерезаписьПройден", Истина);
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Выполнение следующего шага.
	Если Пакет.ПроверитьСтраницу1 = Истина Тогда
		// Наименование не введено.
		Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
			ТекстОшибки = НСтр("ru = 'Поле ""Наименование"" не заполнено';
								|en = 'Name is not populated'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "Объект.Наименование");
			Возврат;
		КонецЕсли;
		
		// Введено наименование существующего варианта отчета.
		Если Не Пакет.ВариантЭтоНовый Тогда
			Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Ссылка", ВариантСсылка));
			Вариант = Найденные[0];
			Если Не ПравоЗаписиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты) Тогда
				ТекстОшибки = НСтр("ru = 'Недостаточно прав для изменения варианта ""%1"". Необходимо выбрать другой вариант или изменить Наименование.';
									|en = 'Insufficient rights to change option ""%1"". Select another option or change the name.'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Объект.Наименование);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "Объект.Наименование");
				Возврат;
			КонецЕсли;
			
			Если Не Пакет.Свойство("ВопросНаПерезаписьПройден") Тогда
				Если Вариант.ПометкаУдаления = Истина Тогда
					ТекстВопроса = НСтр("ru = 'Вариант отчета ""%1"" помечен на удаление.
					|Заменить помеченный на удаление вариант отчета?';
					|en = 'Report option ""%1"" is marked for deletion. 
					|Replace the report option marked for deletion?'");
					КнопкаПоУмолчанию = КодВозвратаДиалога.Нет;
				Иначе
					ТекстВопроса = НСтр("ru = 'Заменить ранее сохраненный вариант отчета ""%1""?';
										|en = 'Replace a previously saved option of report ""%1""?'");
					КнопкаПоУмолчанию = КодВозвратаДиалога.Да;
				КонецЕсли;
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Объект.Наименование);
				Пакет.ТекущийШаг = "ВопросНаПерезапись";
				Обработчик = Новый ОписаниеОповещения("ВыполнитьПакет", ЭтотОбъект, Пакет);
				ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КнопкаПоУмолчанию);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		// Проверка завершена.
		Пакет.ПроверитьСтраницу1 = Ложь;
	КонецЕсли;
	
	Если Пакет.ПерейтиНаСтраницу2 = Истина Тогда
		// Для внешних отчетов выполняются только проверки заполнения, без переключения страницы.
		Если Не Контекст.ЭтоВнешний Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Дополнительно;
			Элементы.Назад.Доступность        = Истина;
			Элементы.Далее.Доступность        = Ложь;
		КонецЕсли;
		
		// Переключение выполнено.
		Пакет.ПерейтиНаСтраницу2 = Ложь;
	КонецЕсли;
	
	Если Пакет.ЗаполнитьСтраницу2Сервер = Истина
		Или Пакет.ПроверитьИЗаписатьСервер = Истина Тогда
		
		ВыполнитьПакетСервер(Пакет);
		
		СтрокиДерева = ДеревоПодсистем.ПолучитьЭлементы();
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			Элементы.ДеревоПодсистем.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
		КонецЦикла;
		
		Если Пакет.Отказ = Истина Тогда
			ПерейтиНаСтраницу1();
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Пакет.ЗакрытьПослеЗаписи = Истина Тогда
		ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы(, ИмяФормы);
		Закрыть(Новый ВыборНастроек(ВариантКлючВарианта));
		Пакет.ЗакрытьПослеЗаписи = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницу1()
	Элементы.Страницы.ТекущаяСтраница = Элементы.Основное;
	Элементы.Назад.Доступность        = Ложь;
	Элементы.Далее.Заголовок          = "";
	Элементы.Далее.Доступность        = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВариантДляИзменения()
	Вариант = Элементы.ВариантыОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	Если Не ПравоНастройкиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты) Тогда
		ТекстПредупреждения = НСтр("ru = 'Недостаточно прав доступа для изменения варианта ""%1"".';
									|en = 'Insufficient access rights to change option ""%1"".'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(Вариант.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть()
	СтраницаДополнительноЗаполнена = (Элементы.Страницы.ТекущаяСтраница = Элементы.Дополнительно);
	
	Пакет = Новый Структура;
	Пакет.Вставить("ПроверитьСтраницу1",       Не СтраницаДополнительноЗаполнена);
	Пакет.Вставить("ПерейтиНаСтраницу2",       Не СтраницаДополнительноЗаполнена);
	Пакет.Вставить("ЗаполнитьСтраницу2Сервер", Не СтраницаДополнительноЗаполнена);
	Пакет.Вставить("ПроверитьИЗаписатьСервер", Истина);
	Пакет.Вставить("ЗакрытьПослеЗаписи",       Истина);
	Пакет.Вставить("ТекущийШаг", Неопределено);
	
	ВыполнитьПакет(Неопределено, Пакет);
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбораЗавершение(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Объект.Описание = ВведенныйТекст;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент и сервер

&НаСервере
Процедура УстановитьСценарийСохраненияВарианта()
	БудетЗаписанНовый = Ложь;
	БудетПерезаписанСуществующий = Ложь;
	ПерезаписьНевозможна = Ложь;
	
	Если НаименованиеМодифицировано Тогда 
		Элементы.ВариантыОтчета.ТекущаяСтрока = Контекст.ПоискПоНаименованию.Получить(Объект.Наименование);
	КонецЕсли;
	
	Идентификатор = Элементы.ВариантыОтчета.ТекущаяСтрока;
	Вариант = ?(Идентификатор <> Неопределено, ВариантыОтчета.НайтиПоИдентификатору(Идентификатор), Неопределено);
	
	Если Вариант = Неопределено Тогда
		БудетЗаписанНовый = Истина;
		ВариантСсылка = Неопределено;
		Объект.ВидимостьПоУмолчанию = Истина;
		Если Не ОписаниеМодифицировано Тогда
			Объект.Описание = "";
		КонецЕсли;
		Элементы.ВариантыОтчета.ТекущаяСтрока = Неопределено;
		Если Не Контекст.ПолныеПраваНаВарианты Тогда
			Объект.ТолькоДляАвтора = Истина;
		КонецЕсли;
	Иначе
		ПравоЗаписиВарианта = ПравоЗаписиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты);
		Если ПравоЗаписиВарианта Тогда
			БудетПерезаписанСуществующий = Истина;
			НаименованиеМодифицировано = Ложь;
			Объект.Наименование = Вариант.Наименование;
			
			ВариантСсылка = Вариант.Ссылка;
			Если Контекст.ПолныеПраваНаВарианты Тогда
				Объект.ТолькоДляАвтора = Вариант.ТолькоДляАвтора;
			Иначе
				Объект.ТолькоДляАвтора = Истина;
			КонецЕсли;
			Объект.ВидимостьПоУмолчанию = Вариант.ВидимостьПоУмолчанию;
			Если Не ОписаниеМодифицировано Тогда
				Объект.Описание = Вариант.Описание;
			КонецЕсли;
			ЗаполнитьПредставления(Вариант.Ссылка);
		Иначе
			Если НаименованиеМодифицировано Тогда
				ПерезаписьНевозможна = Истина;
				Элементы.ВариантыОтчета.ТекущаяСтрока = Неопределено;
			Иначе
				БудетЗаписанНовый = Истина;
				Объект.Наименование = СформироватьСвободноеНаименование(Вариант, ВариантыОтчета);
			КонецЕсли;
			
			ВариантСсылка = Неопределено;
			Объект.ТолькоДляАвтора      = Истина;
			Объект.ВидимостьПоУмолчанию = Истина;
			Если Не ОписаниеМодифицировано Тогда
				Объект.Описание = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Доступен = ?(Объект.ТолькоДляАвтора, "ТолькоАвтор", "ВсеПользователи");
	
	Если БудетЗаписанНовый Тогда
		Элементы.ЧтоБудетДальше.ТекущаяСтраница = Элементы.Новый;
		Элементы.СброситьНастройки.Видимость = Ложь;
		Элементы.Далее.Доступность     = Истина;
		Элементы.Сохранить.Доступность = Истина;
	ИначеЕсли БудетПерезаписанСуществующий Тогда
		Элементы.ЧтоБудетДальше.ТекущаяСтраница = Элементы.Перезапись;
		Элементы.СброситьНастройки.Видимость = Истина;
		Элементы.Далее.Доступность     = Истина;
		Элементы.Сохранить.Доступность = Истина;
	ИначеЕсли ПерезаписьНевозможна Тогда
		Элементы.ЧтоБудетДальше.ТекущаяСтраница = Элементы.ПерезаписьНевозможна;
		Элементы.СброситьНастройки.Видимость = Ложь;
		Элементы.Далее.Доступность     = Ложь;
		Элементы.Сохранить.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПравоНастройкиВарианта(Вариант, ПолныеПраваНаВарианты)
	Возврат (ПолныеПраваНаВарианты Или Вариант.АвторТекущийПользователь) И ЗначениеЗаполнено(Вариант.Ссылка);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПравоЗаписиВарианта(Вариант, ПолныеПраваНаВарианты)
	Возврат Вариант.Пользовательский И ПравоНастройкиВарианта(Вариант, ПолныеПраваНаВарианты);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьСвободноеНаименование(Вариант, ВариантыОтчета)
	ШаблонИмениВарианта = СокрЛП(Вариант.Наименование) +" - "+ НСтр("ru = 'копия';
																	|en = 'copy'");
	
	СвободноеНаименование = ШаблонИмениВарианта;
	Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
	Если Найденные.Количество() = 0 Тогда
		Возврат СвободноеНаименование;
	КонецЕсли;
	
	НомерВарианта = 1;
	Пока Истина Цикл
		НомерВарианта = НомерВарианта + 1;
		СвободноеНаименование = ШаблонИмениВарианта +" (" + Формат(НомерВарианта, "") + ")";
		Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
		Если Найденные.Количество() = 0 Тогда
			Возврат СвободноеНаименование;
		КонецЕсли;
	КонецЦикла;
КонецФункции

&НаСервере
Процедура ЗаполнитьПредставления(Вариант)
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&КодОсновногоЯзыка КАК КодЯзыка,
	|	ВЫБОР
	|		КОГДА НЕ ИзКонфигурации.Наименование ЕСТЬ NULL
	|			ТОГДА ИзКонфигурации.Наименование
	|		КОГДА НЕ ИзРасширений.Наименование ЕСТЬ NULL
	|			ТОГДА ИзРасширений.Наименование
	|		ИНАЧЕ Пользовательские.Наименование
	|	КОНЕЦ КАК Наименование,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(Пользовательские.Описание, 1, 1) <> """"
	|			ТОГДА Пользовательские.Описание
	|		КОГДА НЕ ИзКонфигурации.Описание ЕСТЬ NULL
	|			ТОГДА ИзКонфигурации.Описание
	|		КОГДА НЕ ИзРасширений.Описание ЕСТЬ NULL
	|			ТОГДА ИзРасширений.Описание
	|		ИНАЧЕ ВЫРАЗИТЬ("""" КАК СТРОКА(1000))
	|	КОНЕЦ КАК Описание
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Пользовательские
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов КАК ИзКонфигурации
	|		ПО ИзКонфигурации.Ссылка = Пользовательские.ПредопределенныйВариант
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетовРасширений КАК ИзРасширений
	|		ПО ИзРасширений.Ссылка = Пользовательские.ПредопределенныйВариант
	|ГДЕ
	|	Пользовательские.Ссылка = &Вариант
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НЕ ПредставленияИзКонфигурации.КодЯзыка ЕСТЬ NULL
	|			ТОГДА ПредставленияИзКонфигурации.КодЯзыка
	|		КОГДА НЕ ПредставленияИзРасширений.КодЯзыка ЕСТЬ NULL
	|			ТОГДА ПредставленияИзРасширений.КодЯзыка
	|		КОГДА НЕ ПредставленияПользовательских.КодЯзыка ЕСТЬ NULL
	|			ТОГДА ПредставленияПользовательских.КодЯзыка
	|		ИНАЧЕ ВЫРАЗИТЬ("""" КАК СТРОКА(10))
	|	КОНЕЦ КАК КодЯзыка,
	|	ВЫБОР
	|		КОГДА НЕ ПредставленияИзКонфигурации.Наименование ЕСТЬ NULL
	|			ТОГДА ПредставленияИзКонфигурации.Наименование
	|		КОГДА НЕ ПредставленияИзРасширений.Наименование ЕСТЬ NULL
	|			ТОГДА ПредставленияИзРасширений.Наименование
	|		КОГДА НЕ ПредставленияПользовательских.Наименование ЕСТЬ NULL
	|			ТОГДА ПредставленияПользовательских.Наименование
	|		ИНАЧЕ ВЫРАЗИТЬ("""" КАК СТРОКА(150))
	|	КОНЕЦ КАК Наименование,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ЕСТЬNULL(ПредставленияПользовательских.Описание, """"), 1, 1) <> """"
	|			ТОГДА ПредставленияПользовательских.Описание
	|		КОГДА НЕ ПредставленияИзКонфигурации.Описание ЕСТЬ NULL
	|			ТОГДА ПредставленияИзКонфигурации.Описание
	|		КОГДА НЕ ПредставленияИзРасширений.Описание ЕСТЬ NULL
	|			ТОГДА ПредставленияИзРасширений.Описание
	|		ИНАЧЕ ВЫРАЗИТЬ("""" КАК СТРОКА(1000))
	|	КОНЕЦ КАК Описание
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Пользовательские
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтчетов.Представления КАК ПредставленияПользовательских
	|		ПО ПредставленияПользовательских.Ссылка = Пользовательские.Ссылка
	|		И ПредставленияПользовательских.КодЯзыка <> &КодОсновногоЯзыка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов.Представления КАК ПредставленияИзКонфигурации
	|		ПО ПредставленияИзКонфигурации.Ссылка = Пользовательские.ПредопределенныйВариант
	|		И ПредставленияИзКонфигурации.КодЯзыка <> &КодОсновногоЯзыка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетовРасширений.Представления КАК ПредставленияИзРасширений
	|		ПО ПредставленияИзРасширений.Ссылка = Пользовательские.ПредопределенныйВариант
	|		И ПредставленияИзРасширений.КодЯзыка <> &КодОсновногоЯзыка
	|ГДЕ
	|	Пользовательские.Ссылка = &Вариант
	|");
	Запрос.УстановитьПараметр("Вариант", Вариант);
	Запрос.УстановитьПараметр("КодОсновногоЯзыка", Метаданные.ОсновнойЯзык.КодЯзыка);
	
	Объект.Представления.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Процедура ВыполнитьПакетСервер(Пакет)
	
	Пакет.Вставить("Отказ", Ложь);
	
	Если Пакет.ЗаполнитьСтраницу2Сервер = Истина Тогда
		Если Не Контекст.ЭтоВнешний Тогда
			ПерезаполнитьСтраницуДополнительно(Пакет);
		КонецЕсли;
		Пакет.ЗаполнитьСтраницу2Сервер = Ложь;
	КонецЕсли;
	
	Если Пакет.ПроверитьИЗаписатьСервер = Истина Тогда
		ПроверитьИЗаписатьВариантОтчета(Пакет);
		Пакет.ПроверитьИЗаписатьСервер = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВариантНаСервере(Идентификатор)
	Если Идентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Вариант = ВариантыОтчета.НайтиПоИдентификатору(Идентификатор);
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПометкаУдаления = Не Вариант.ПометкаУдаления;
	ВариантОбъект = Вариант.Ссылка.ПолучитьОбъект();
	ВариантОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	Вариант.ПометкаУдаления = ПометкаУдаления;
	Вариант.ИндексКартинки  = ?(ПометкаУдаления, 4, ?(ВариантОбъект.Пользовательский, 3, 5));
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьСтраницуДополнительно(Пакет)
	Если Пакет.ВариантЭтоНовый Тогда
		ВариантОснование = ПрототипСсылка;
	Иначе
		ВариантОснование = ВариантСсылка;
	КонецЕсли;
	
	ДеревоПриемник = ВариантыОтчетов.ДеревоПодсистемСформировать(ЭтотОбъект, ВариантОснование);
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
КонецПроцедуры

&НаСервере
Процедура ПроверитьИЗаписатьВариантОтчета(Пакет)
	ЭтоНовыйВариантОтчета = Не ЗначениеЗаполнено(ВариантСсылка);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Если Не ЭтоНовыйВариантОтчета Тогда
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВариантСсылка);
		КонецЕсли;
		Блокировка.Заблокировать();
		
		Если ЭтоНовыйВариантОтчета И ВариантыОтчетов.НаименованиеЗанято(Контекст.ОтчетСсылка, ВариантСсылка, Объект.Наименование) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '""%1"" занято, необходимо указать другое наименование.';
																						|en = '""%1"" is already used, enter another name.'"), Объект.Наименование);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "Объект.Наименование");
			Пакет.Отказ = Истина;
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		
		Если ЭтоНовыйВариантОтчета Тогда
			ВариантОбъект = Справочники.ВариантыОтчетов.СоздатьЭлемент();
			ВариантОбъект.Отчет            = Контекст.ОтчетСсылка;
			ВариантОбъект.ТипОтчета        = Контекст.ТипОтчета;
			ВариантОбъект.КлючВарианта     = Строка(Новый УникальныйИдентификатор());
			ВариантОбъект.Пользовательский = Истина;
			ВариантОбъект.Автор            = Контекст.ТекущийПользователь;
			Если ПрототипПредопределенный Тогда
				ВариантОбъект.Родитель = ПрототипСсылка;
			ИначеЕсли ТипЗнч(ПрототипСсылка) = Тип("СправочникСсылка.ВариантыОтчетов") И Не ПрототипСсылка.Пустая() Тогда
				ВариантОбъект.Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрототипСсылка, "Родитель");
			Иначе
				ВариантОбъект.ЗаполнитьРодителя();
			КонецЕсли;
		Иначе
			ВариантОбъект = ВариантСсылка.ПолучитьОбъект();
		КонецЕсли;
		
		Если Контекст.ЭтоВнешний Тогда
			ВариантОбъект.Размещение.Очистить();
		Иначе
			ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
			Если ЭтоНовыйВариантОтчета Тогда
				ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
			Иначе
				ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Модифицированность", Истина), Истина);
			КонецЕсли;
			ВариантыОтчетов.ДеревоПодсистемЗаписать(ВариантОбъект, ИзмененныеРазделы);
		КонецЕсли;
		
		ВариантОбъект.Наименование = Объект.Наименование;
		ВариантОбъект.Описание     = Объект.Описание;
		ВариантОбъект.ТолькоДляАвтора      = Объект.ТолькоДляАвтора;
		ВариантОбъект.ВидимостьПоУмолчанию = Объект.ВидимостьПоУмолчанию;
		
		ВариантОбъект.Представления.Загрузить(Объект.Представления.Выгрузить());
		ЛокализацияСервер.ПередЗаписьюНаСервере(ВариантОбъект);
		
		ВариантОбъект.Записать();
		
		ВариантСсылка       = ВариантОбъект.Ссылка;
		ВариантКлючВарианта = ВариантОбъект.КлючВарианта;
		
		Если СброситьНастройки Тогда
			ВариантыОтчетов.СброситьПользовательскиеНастройки(ВариантОбъект.Ссылка);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ЗаполнитьСписокВариантов(ОбновитьФорму)
	
	ТекущийКлючВарианта = ПрототипКлюч;
	
	// Подмена на ключ варианта "до перезаполнения".
	ИдентификаторТекущейСтроки = Элементы.ВариантыОтчета.ТекущаяСтрока;
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = ВариантыОтчета.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
		Если ТекущаяСтрока <> Неопределено Тогда
			ТекущийКлючВарианта = ТекущаяСтрока.КлючВарианта;
		КонецЕсли;
	КонецЕсли;
	
	ОтборОтчеты = Новый Массив;
	ОтборОтчеты.Добавить(Контекст.ОтчетСсылка);
	ПараметрыПоиска = Новый Структура("Отчеты, ТолькоЛичные", ОтборОтчеты, Истина);
	ТаблицаВариантов = ВариантыОтчетов.ТаблицаВариантовОтчетов(ПараметрыПоиска);
	
	// Заполнить автовычисляемые колонки.
	ВариантыОтчета.Загрузить(ТаблицаВариантов);
	Для каждого Вариант Из ВариантыОтчета Цикл
		Вариант.АвторТекущийПользователь = (Вариант.Автор = Контекст.ТекущийПользователь);
		Вариант.ИндексКартинки = ?(Вариант.ПометкаУдаления, 3, ?(Вариант.Пользовательский, 3, 5));
		Вариант.Порядок = ?(Вариант.ПометкаУдаления, 3, ?(Вариант.Пользовательский, 2, 1));
	КонецЦикла;
	
	Если Контекст.ЭтоВнешний
		И Не ХранилищаНастроек.ХранилищеВариантовОтчетов.ДобавитьВариантыВнешнегоОтчета(
			ВариантыОтчета, Контекст.ОтчетСсылка, Контекст.ОтчетИмя) Тогда
		Возврат;
	КонецЕсли;
	
	ВариантыОтчета.Сортировать("Наименование Возр");
	
	Контекст.ПоискПоНаименованию = Новый Соответствие;
	Для Каждого Вариант Из ВариантыОтчета Цикл
		Идентификатор = Вариант.ПолучитьИдентификатор();
		Контекст.ПоискПоНаименованию.Вставить(Вариант.Наименование, Идентификатор);
		Если Вариант.КлючВарианта = ПрототипКлюч Тогда
			ПрототипСсылка           = Вариант.Ссылка;
			ПрототипПредопределенный = Не Вариант.Пользовательский;
		КонецЕсли;
		Если Вариант.КлючВарианта = ТекущийКлючВарианта Тогда
			Элементы.ВариантыОтчета.ТекущаяСтрока = Идентификатор;
		КонецЕсли;
	КонецЦикла;
	
	УстановитьСценарийСохраненияВарианта();
	
КонецПроцедуры

#КонецОбласти
