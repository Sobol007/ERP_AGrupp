
#Область ОбработчикиСобытийФормы

Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;

	Элементы.ПоискНеНастроен.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.ПоискНеНастроен.ОтображениеСостояния.Текст = НСтр("ru = 'Элементы классификатора не выведены. Настройте отбор и выполните поиск.';
																|en = 'Элементы классификатора не выведены. Настройте отбор и выполните поиск.'");
	Элементы.ПоискНеНастроен.ОтображениеСостояния.Видимость = Истина;
	
	Элементы.СписокВыбратьИзСправочника.Видимость = РежимВыбора;
	Элементы.ВыбратьИзКлассификатора.Видимость = РежимВыбора;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	Если ЗначениеЗаполнено(Параметры.ВидПродукцииОтбор) Тогда
		ПолучитьИерархиюПродукции(Параметры.ВидПродукцииОтбор);
		Элементы.ОписаниеПродукции.Доступность = Ложь;
		УстановитьОтборПоВидуПродукции();
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ПредприятиеОтбор) Тогда
		ПредприятиеОтбор = Параметры.ПредприятиеОтбор;
		Элементы.Предприятие.ТолькоПросмотр = Истина;
		Элементы.ПредприятиеОтбор.ТолькоПросмотр = Истина;
		ПредприятиеПриИзмененииНаСервере(Истина);
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ХСПроизводительОтбор) Тогда
		ХСПроизводительОтбор = Параметры.ХСПроизводительОтбор;
		Элементы.ХозяйствующийСубъектОтбор.ТолькоПросмотр = Истина;
		Элементы.ХСПроизводительОтбор.ТолькоПросмотр = Истина;
		ХозяйствующийСубъектПриИзмененииНаСервере(Истина);
	КонецЕсли;
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	СФормироватьПараметрыОтбора(ЭтаФорма);
	
	ДобавлениеДоступно = ПравоДоступа("Добавление", Метаданные.Справочники.ПродукцияВЕТИС);
	Элементы.СписокСоздатьПродукцию.Видимость = ДобавлениеДоступно;
	Элементы.СписокКонтекстноеМенюСоздатьПродукцию.Видимость = ДобавлениеДоступно;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПродукцияВЕТИС" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗагружено;
		ПриСменеОсновнойСтраницы();
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Параметр;
		ОтборыИзменились = Истина;
		ПредупредитьОбИзмененииОтборов(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиПродукцию(Команда)
	
	ОчиститьСообщения();
	
	ПоискНачат = Истина;
	ЗагрузитьНаименованияПродукцииПредприятия(1);
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПервая(Команда)
	
	ПерейтиПоНомеруСтраницы(1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПредыдущая(Команда)
	ПерейтиПоНомеруСтраницы(НаименованияПродукцииНомерСтраницы-1);
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаТекущаяСтраница(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("МаксимальныйНомерСтраницы", КоличествоСтраниц);
	ПараметрыОткрытияФормы.Вставить("НомерСтраницы",             НаименованияПродукцииНомерСтраницы);
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.ПереходКСтраницеПоНомеру",
		ПараметрыОткрытияФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ПослеВыбораНомераСтраницы", ЭтотОбъект));
		
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаСледующая(Команда)
	
	ПерейтиПоНомеруСтраницы(НаименованияПродукцииНомерСтраницы + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПоследняя(Команда)
	
	ПерейтиПоНомеруСтраницы(КоличествоСтраниц);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНомераСтраницы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПерейтиПоНомеруСтраницы(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзСправочника(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	Если НЕ ТекущиеДанные.ЭтоГруппа Тогда
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	ТекущиеДанные = Элементы.НаименованияПродукции.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущиеДанные.НаименованиеПродукцииСсылка) Тогда
		ОповеститьОВыборе(ТекущиеДанные.НаименованиеПродукцииСсылка);
	ИначеЕсли ДобавлениеДоступно Тогда
		ОповеститьОВыборе(ЗагрузитьНаименованиеПродукции(ТекущиеДанные.GUID));
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Добавление продукции недоступно текущему пользователю.';
										|en = 'Добавление продукции недоступно текущему пользователю.'"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПродукцию(Команда)
	
	ПараметрыЗаполнения = Новый Структура;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.Продукция) И НЕ ЗначениеЗаполнено(ТекущиеДанные.ВидПродукции) Тогда
			ПараметрыЗаполнения.Вставить("ВидПродукции", ТекущиеДанные.Ссылка);
		Иначе
			ПараметрыЗаполнения.Вставить("ВидПродукции", ТекущиеДанные.ВидПродукции);
		КонецЕсли;
		ПараметрыЗаполнения.Вставить("Продукция", ТекущиеДанные.Продукция);
		ПараметрыЗаполнения.Вставить("ТипПродукции", ТекущиеДанные.ТипПродукции);
	КонецЕсли;
	
	ПараметрыЗаполнения.Вставить("ХозяйствующийСубъектПроизводитель", ХСПроизводительОтбор);
	ПараметрыЗаполнения.Вставить("Производитель", ПредприятиеОтбор);
	
	ОткрытьФорму("Справочник.ПродукцияВЕТИС.Форма.ПомощникСоздания",
		Новый Структура("ЗначенияЗаполнения", ПараметрыЗаполнения),
		ЭтаФорма,
		УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ХозяйствующийСубъектПриИзменении(Элемент)
	ХозяйствующийСубъектПриИзмененииНаСервере(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	ПредприятиеПриИзмененииНаСервере(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ХСПроизводительОтборОчистка(Элемент, СтандартнаяОбработка)
	ХСПроизводительGUIDОтбор = Неопределено;
	ХозяйствующийСубъектПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеОтборОчистка(Элемент, СтандартнаяОбработка)
	ПредприятиеGUIDОтбор = Неопределено;
	ПредприятиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ХСПроизводительОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещенияВыбора = Новый ОписаниеОповещения("ПриЗавершенииВыбораХСПроизводитель",ЭтотОбъект);
	ОткрытьФорму("Справочник.ХозяйствующиеСубъектыВЕТИС.ФормаСписка", 
		Новый Структура("ВыборИдентификаторов, РежимВыбора", Истина, Истина),
		ЭтаФорма,
		УникальныйИдентификатор,,,
		ОписаниеОповещенияВыбора,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииВыбораХСПроизводитель(Результат, ДопПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если ЗначениеЗаполнено(Результат.Ссылка) Тогда
			ХСПроизводительОтбор = Результат.Ссылка;
		Иначе
			ХСПроизводительОтбор = Результат.Наименование;
		КонецЕсли;
		ХСПроизводительGUIDОтбор = Результат.Идентификатор;
		ХозяйствующийСубъектПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ХозяйствующийСубъектИдентификатор", ХСПроизводительGUIDОтбор);
	СтруктураПараметров.Вставить("ХозяйствующийСубъектПредставление", ХСПроизводительОтбор);
	СтруктураПараметров.Вставить("РежимВыбора", Истина);
	СтруктураПараметров.Вставить("ВыборИдентификаторов", Истина);
	
	ОписаниеОповещенияВыбора = Новый ОписаниеОповещения("ПриЗавершенииВыбораПредприятие",ЭтотОбъект);
	ОткрытьФорму("Справочник.ПредприятияВЕТИС.ФормаСписка", 
		СтруктураПараметров,
		ЭтаФорма,
		УникальныйИдентификатор,,,
		ОписаниеОповещенияВыбора,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииВыбораПредприятие(Результат, ДопПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если ЗначениеЗаполнено(Результат.Ссылка) Тогда
			ПредприятиеОтбор = Результат.Ссылка;
		Иначе
			ПредприятиеОтбор = Результат.Наименование;
		КонецЕсли;
		ПредприятиеGUIDОтбор = Результат.Идентификатор;
		ПредприятиеПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Запрос = Новый Запрос();
	Запрос.Текст = Справочники.ПродукцияВЕТИС.ТекстЗапросаИнформацияОСопоставлении();
	Запрос.УстановитьПараметр("Продукция", Строки.ПолучитьКлючи());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаСписка = Строки[Выборка.Ссылка];
		Если Выборка.ЭтоГруппа Тогда
			СтрокаСписка.Данные["Сопоставлено"] = "";
		ИначеЕсли Выборка.Количество = 1 Тогда
			СтрокаСписка.Данные["Сопоставлено"] = ИнтеграцияИС.ПредставлениеНоменклатуры(
				Выборка.Номенклатура,
				Выборка.Характеристика);
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылкиГосИС);
		ИначеЕсли Выборка.Количество > 1 Тогда
			Если СтрДлина(Выборка.НоменклатураПредставление) > 45 Тогда 
				СтрокаКоличество = СтрШаблон(НСтр("ru = '( + еще %1)';
													|en = '( + еще %1)'"), Выборка.Количество - 1);
				ДлинаНаименования = 45 - СтрДлина(СтрокаКоличество);
				СтрокаСписка.Данные["Сопоставлено"] = Лев(Выборка.НоменклатураПредставление, ДлинаНаименования) + "... " + СтрокаКоличество;
			Иначе
				СтрокаСписка.Данные["Сопоставлено"] = СтрШаблон(НСтр("ru = '%1 ( + еще %2...)';
																	|en = '%1 ( + еще %2...)'"), Выборка.НоменклатураПредставление, Выборка.Количество - 1);
			КонецЕсли;
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылкиГосИС);
		Иначе
			СтрокаСписка.Данные["Сопоставлено"] = НСтр("ru = '<Не сопоставлено>';
														|en = '<Не сопоставлено>'");
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
		КонецЕсли;
		
		Если Выборка.ЭтоГруппа Тогда
			СтрокаСписка.Данные["Производитель"] = "";
		ИначеЕсли Выборка.КоличествоПроизводителей = 1 Тогда
			СтрокаСписка.Данные["Производитель"] = Выборка.ПроизводительПредставление;
		ИначеЕсли Выборка.КоличествоПроизводителей > 1 Тогда
			Если СтрДлина(Выборка.ПроизводительПредставление) > 45 Тогда 
				СтрокаКоличество = СтрШаблон(НСтр("ru = '( + еще %1)';
													|en = '( + еще %1)'"), Выборка.КоличествоПроизводителей - 1);
				ДлинаНаименования = 70 - СтрДлина(СтрокаКоличество);
				СтрокаСписка.Данные["Производитель"] = Лев(Выборка.ПроизводительПредставление, ДлинаНаименования) + "... " + СтрокаКоличество;
			Иначе
				СтрокаСписка.Данные["Производитель"] = СтрШаблон(НСтр("ru = '%1 ( + еще %2...)';
																		|en = '%1 ( + еще %2...)'"), Выборка.ПроизводительПредставление, Выборка.КоличествоПроизводителей - 1);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.Сопоставлено Тогда
		СтандартнаяОбработка = Ложь;
		
		ИнтеграцияВЕТИСКлиент.ОткрытьФормуСопоставленияПродукцииВЕТИС(
			ТекущиеДанные.Ссылка,
			ЭтотОбъект);
	ИначеЕсли РежимВыбора И НЕ ТекущиеДанные.ЭтоГруппа Тогда
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ЛОЖЬ;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИзменитьВидПродукции" Тогда
		ОткрытьФормыВыбораВидаПродукции();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОчиститьИерархию" Тогда
		ОчиститьИерархию();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтборПоПродукции" Тогда
		ОчиститьВидПродукции();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтборПоТипуПродукции" Тогда
		ОчиститьВидПродукцииПродукцию();
	КонецЕсли;
	
	ПоискНачат = Ложь;
	СформироватьЗаголовокКомандыНавигации();
	ПредупредитьОбИзмененииОтборов(ЭтаФорма);
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	СФормироватьПараметрыОтбора(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НаименованияПродукцииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.НаименованияПродукции.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		ВыбратьИзКлассификатора(Неопределено);
	Иначе
		ПараметрыОткрытия = Новый Структура;
		Если ЗначениеЗаполнено(ТекущиеДанные.НаименованиеПродукцииСсылка) Тогда
			ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.НаименованиеПродукцииСсылка);
		Иначе
			ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.НаименованиеПродукцииСсылка);
			ПараметрыОткрытия.Вставить("ИдентификаторПродукции",ТекущиеДанные.GUID);
		КонецЕсли;
		ОткрытьФорму("Справочник.ПродукцияВЕТИС.Форма.ФормаЭлемента", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ПриСменеОсновнойСтраницы();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИерархию()
	
	ВидПродукции     = Неопределено;
	ВидПродукцииGUID = Неопределено;
	Продукция        = Неопределено;
	ПродукцияGUID    = Неопределено;
	ТипПродукции     = Неопределено;
	ТипПродукцииGUID = Неопределено;
	ОтборыИзменились = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВидПродукции()
	
	ВидПродукции     = Неопределено;
	ВидПродукцииGUID = Неопределено;
	ОтборыИзменились = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВидПродукцииПродукцию()
	
	ВидПродукции     = Неопределено;
	ВидПродукцииGUID = Неопределено;
	Продукция        = Неопределено;
	ПродукцияGUID    = Неопределено;
	ОтборыИзменились = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормыВыбораВидаПродукции()
	ОткрытьФорму("Обработка.КлассификаторыВЕТИС.Форма.КлассификаторИерархииПродукции",,ЭтаФорма,,,,
		Новый ОписаниеОповещения("КлассификаторПродукцииПриЗавершенииВыбора",ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторПродукцииПриЗавершенииВыбора(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ПолучитьИерархиюПродукции(Результат);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьИерархиюПродукции(ВыбраннаяПродукция)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВидПродукцииВЕТИС.Идентификатор КАК Идентификатор,
	|	ВидПродукцииВЕТИС.Продукция КАК Продукция,
	|	ВидПродукцииВЕТИС.Продукция.Идентификатор КАК ПродукцияИдентификатор,
	|	ВидПродукцииВЕТИС.ТипПродукции КАК ТипПродукции
	|ИЗ
	|	Справочник.ПродукцияВЕТИС КАК ВидПродукцииВЕТИС
	|ГДЕ
	|	ВидПродукцииВЕТИС.Ссылка = &ПродукцияСсылка";
	
	Запрос.УстановитьПараметр("ПродукцияСсылка", ВыбраннаяПродукция);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Если ЗначениеЗаполнено(Выборка.Продукция) Тогда
			
			ВидПродукции = ВыбраннаяПродукция;
			Продукция    = Выборка.Продукция;
			ТипПродукции = Выборка.ТипПродукции;
			
			ВидПродукцииGUID = Выборка.Идентификатор;
			ПродукцияGUID    = Выборка.ПродукцияИдентификатор;
			ТипПродукцииGUID = ПродукцияВЕТИСВызовСервера.ТипПродукции(Выборка.ТипПродукции);
			
		ИначеЕсли ЗначениеЗаполнено(Выборка.ТипПродукции) Тогда
			
			ВидПродукции = Неопределено;
			Продукция    = ВыбраннаяПродукция;
			ТипПродукции = Выборка.ТипПродукции;
			
			ВидПродукцииGUID = Неопределено;
			ПродукцияGUID    = Выборка.Идентификатор;
			ТипПродукцииGUID = ПродукцияВЕТИСВызовСервера.ТипПродукции(Выборка.ТипПродукции);
			
		Иначе
			ВидПродукции = Неопределено;
			Продукция    = Неопределено;
			ТипПродукции = ВыбраннаяПродукция;
			
			ВидПродукцииGUID = Неопределено;
			ПродукцияGUID    = Неопределено;
			ТипПродукцииGUID = ПродукцияВЕТИСВызовСервера.ТипПродукции(ВыбраннаяПродукция);
			
		КонецЕсли;
		ОтборыИзменились = Истина;
		СФормироватьПараметрыОтбора(ЭтаФорма);
		ПредупредитьОбИзмененииОтборов(ЭтаФорма);
		ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

#Область НастройкаЭлементовФормы

&НаКлиенте
Процедура ПерейтиПоНомеруСтраницы(НомерСтраницы)
	
	ОчиститьСообщения();
	
	Если НомерСтраницы < 1
		ИЛИ НомерСтраницы > КоличествоСтраниц Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьНаименованияПродукцииПредприятия(НомерСтраницы);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокКомандыНавигации()
	
	КолвоСтраницНадпись = ?(КоличествоСтраниц=0,1,КоличествоСтраниц);
	Элементы.НавигацияСтраницаТекущаяСтраница.Заголовок =
		?(ПоискНачат,
			СтрШаблон(
				НСтр("ru = 'Страница %1 из %2';
					|en = 'Страница %1 из %2'"),
				НаименованияПродукцииНомерСтраницы, КолвоСтраницНадпись),
				НСтр("ru = 'Страница 1 из 1';
					|en = 'Страница 1 из 1'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьВидимостьТаблицыПоиска(Форма)
	Если (НЕ ЗначениеЗаполнено(Форма.ПредприятиеGUIDОтбор)
		И НЕ ЗначениеЗаполнено(Форма.ХСПроизводительGUIDОтбор)
		И НЕ ЗначениеЗаполнено(Форма.ВидПродукцииGUID)
		И НЕ ЗначениеЗаполнено(Форма.ПродукцияGUID)
		И НЕ ЗначениеЗаполнено(Форма.ТипПродукцииGUID))
		ИЛИ НЕ Форма.ПоискНачат Тогда
		
		Форма.Элементы.СтраницыПоиска.ТекущаяСтраница = Форма.Элементы.СтраницаНачальная;
		
	Иначе
		
		Форма.Элементы.СтраницыПоиска.ТекущаяСтраница = Форма.Элементы.СтраницаРезультатПоиска;
		
	КонецЕсли;
	ПредупредитьОбИзмененииОтборов(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиИнформациюОВидеТипеПродукции(Форма)
	
	ЦветГиперссылки = Форма.ЦветГиперссылки;
	
	Если ЗначениеЗаполнено(Форма.ТипПродукции) Тогда
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			Строка(Форма.ТипПродукции),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ОтборПоТипуПродукции");
		ОписаниеПродукцииПодсказка = Строка(Форма.ТипПродукции);
		
		ОписаниеПродукции = Новый ФорматированнаяСтрока(СтрокаСсылка);
		
		Если ЗначениеЗаполнено(Форма.Продукция) Тогда
			СтрокаПродукция = Строка(Форма.Продукция);
			ДлиннаяСтрока = СтрДлина(СтрокаПродукция)>30;
			СтрокаСсылка = Новый ФорматированнаяСтрока(
					Лев(СтрокаПродукция,30),
					Новый Шрифт(,,,,Истина),
					ЦветГиперссылки,,
					"ОтборПоПродукции");
			ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " > ", СтрокаСсылка, ?(ДлиннаяСтрока,"...",""));
			ОписаниеПродукцииПодсказка = ОписаниеПродукцииПодсказка + " > " + СтрокаПродукция;
		КонецЕсли;
		Если ЗначениеЗаполнено(Форма.ВидПродукции) Тогда
			СтрокаВидПродукции = Строка(Форма.ВидПродукции);
			ДлиннаяСтрока = СтрДлина(СтрокаВидПродукции)>30;
			СтрокаСсылка = Новый ФорматированнаяСтрока(
					Лев(СтрокаВидПродукции,30),
					Новый Шрифт(,,,,Истина),
					ЦветГиперссылки,,
					"ОтборПоВидуПродукции");
			ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " > ", СтрокаСсылка, ?(ДлиннаяСтрока,"...",""), " ");
			ОписаниеПродукцииПодсказка = ОписаниеПродукцииПодсказка + " > " + СтрокаВидПродукции;
		КонецЕсли;
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			НСтр("ru = 'изменить';
				|en = 'изменить'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ИзменитьВидПродукции");
		ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " ", "(", СтрокаСсылка, " ", НСтр("ru = 'или';
																											|en = 'или'"), " ");
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			НСтр("ru = 'очистить';
				|en = 'очистить'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ОчиститьИерархию");
		Форма.ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, СтрокаСсылка, ")");
	Иначе
		
		Форма.ОписаниеПродукции = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Выбрать группу продукции';
				|en = 'Выбрать группу продукции'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ИзменитьВидПродукции");
		
	КонецЕсли;
	
	Форма.Элементы.ОписаниеПродукции.Подсказка = ОписаниеПродукцииПодсказка;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПредупредитьОбИзмененииОтборов(Форма)
	Если Форма.ОтборыИзменились
		И Форма.Элементы.СтраницыПоиска.ТекущаяСтраница = Форма.Элементы.СтраницаРезультатПоиска Тогда
		
		Форма.Элементы.СтраницыОтборыИзменены.ТекущаяСтраница = Форма.Элементы.ГруппаОтборыИзменились;
		
	Иначе
		
		Форма.Элементы.СтраницыОтборыИзменены.ТекущаяСтраница = Форма.Элементы.ГруппаОтборыНеИзменились;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриСменеОсновнойСтраницы()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗагружено Тогда
		Элементы.СписокВыбратьИзСправочника.КнопкаПоУмолчанию = Истина;
		Элементы.ВыбратьИзКлассификатора.КнопкаПоУмолчанию    = Ложь;
	Иначе
		Элементы.СписокВыбратьИзСправочника.КнопкаПоУмолчанию = Ложь;
		Элементы.ВыбратьИзКлассификатора.КнопкаПоУмолчанию    = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбменСВЕТИС

&НаСервере
Процедура ЗагрузитьНаименованияПродукцииПредприятия(НомерСтраницы)
	Если НЕ ЗначениеЗаполнено(НаименованияПродукцииПараметрыПоиска) Тогда
		Возврат
	КонецЕсли;
	
	Результат = ПродукцияВЕТИСВызовСервера.СписокНаименованийПродукции(НаименованияПродукцииПараметрыПоиска, НомерСтраницы);
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если АдресВоВременномХранилище <> "" Тогда
		
		ДанныеВоВременномХранилище = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
		
		ХозяйствующиеСубъекты = ДанныеВоВременномХранилище.ХозяйствующиеСубъекты;
		Производители         = ДанныеВоВременномХранилище.Производители;
		
	Иначе
		
		ХозяйствующиеСубъекты = Новый ТаблицаЗначений;
		ХозяйствующиеСубъекты.Колонки.Добавить("GUID");
		ХозяйствующиеСубъекты.Колонки.Добавить("Наименование");
		ХозяйствующиеСубъекты.Индексы.Добавить("GUID");
		
		Производители = Новый ТаблицаЗначений;
		Производители.Колонки.Добавить("GUID");
		Производители.Колонки.Добавить("Наименование");
		Производители.Индексы.Добавить("GUID");
		
	КонецЕсли;
	
	НаименованияПродукции.Очистить();
	Для Каждого СтрокаТЧ Из Результат.Список Цикл
		
		НоваяСтрока = НаименованияПродукции.Добавить();
		НоваяСтрока.Активность       = СтрокаТЧ.active;
		НоваяСтрока.Актуальность     = СтрокаТЧ.last;
		НоваяСтрока.GUID             = СтрокаТЧ.GUID;
		НоваяСтрока.UUID             = СтрокаТЧ.UUID;
		НоваяСтрока.Наименование     = СтрокаТЧ.Name;
		НоваяСтрока.ДатаСоздания     = СтрокаТЧ.createDate;
		НоваяСтрока.ДатаИзменения    = СтрокаТЧ.updateDate;
		НоваяСтрока.Статус           = ИнтеграцияВЕТИСПовтИсп.СтатусВерсионногоОбъекта(СтрокаТЧ.status);
		
		НоваяСтрока.СоответствуетГОСТ = СтрокаТЧ.correspondsToGost;
		НоваяСтрока.ГОСТ              = СтрокаТЧ.gost;
		НоваяСтрока.GTIN              = СтрокаТЧ.globalID;
		НоваяСтрока.Артикул           = СтрокаТЧ.code;
		
		НоваяСтрока.ТипПродукции     = ПродукцияВЕТИСВызовСервера.ТипПродукции(СтрокаТЧ.productType);
		НоваяСтрока.ПродукцияGUID    = СтрокаТЧ.product.guid;
		НоваяСтрока.ВидПродукцииGUID = СтрокаТЧ.subProduct.guid;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.producer) Тогда
			
			НайденнаяСтрока = ХозяйствующиеСубъекты.Найти(СтрокаТЧ.producer.guid, "GUID");
			НоваяСтрока.ПроизводительХозяйствующийСубъектИдентификатор = СтрокаТЧ.producer.guid;
			Если НайденнаяСтрока = Неопределено Тогда
				
				РезультатВыполненияЗапроса = ЦерберВЕТИСВызовСервера.ХозяйствующийСубъектПоGUID(СтрокаТЧ.producer.guid);
				Если РезультатВыполненияЗапроса.Элемент <> Неопределено Тогда
					
					ХозяйствующиеСубъектыСтрокаТЧ = ХозяйствующиеСубъекты.Добавить();
					ХозяйствующиеСубъектыСтрокаТЧ.GUID = РезультатВыполненияЗапроса.Элемент.guid;
					ХозяйствующиеСубъектыСтрокаТЧ.Наименование = РезультатВыполненияЗапроса.Элемент.name;
					
					НоваяСтрока.ПроизводительХозяйствующийСубъект = РезультатВыполненияЗапроса.Элемент.name;
					
				КонецЕсли;
				
			Иначе
				
				НоваяСтрока.ПроизводительХозяйствующийСубъект = НайденнаяСтрока.Наименование;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.tmOwner) Тогда
			
			НайденнаяСтрока = ХозяйствующиеСубъекты.Найти(СтрокаТЧ.tmOwner.guid, "GUID");
			Если НайденнаяСтрока = Неопределено Тогда
				
				РезультатВыполненияЗапроса = ЦерберВЕТИСВызовСервера.ХозяйствующийСубъектПоGUID(СтрокаТЧ.tmOwner.guid);
				Если РезультатВыполненияЗапроса.Элемент <> Неопределено Тогда
					
					ХозяйствующиеСубъектыСтрокаТЧ = ХозяйствующиеСубъекты.Добавить();
					ХозяйствующиеСубъектыСтрокаТЧ.GUID = РезультатВыполненияЗапроса.Элемент.guid;
					ХозяйствующиеСубъектыСтрокаТЧ.Наименование = РезультатВыполненияЗапроса.Элемент.name;
					
					НоваяСтрока.СобственникТМ = РезультатВыполненияЗапроса.Элемент.name;
					
				КонецЕсли;
				
			Иначе
				
				НоваяСтрока.СобственникТМ = НайденнаяСтрока.Наименование;
				
			КонецЕсли;
			
		КонецЕсли;
		
		ПроизводителиСписокЗначений = Новый СписокЗначений;
		Для Каждого ПроизводительЭлементДанных Из СтрокаТЧ.producing Цикл
			
			НайденнаяСтрока = Производители.Найти(ПроизводительЭлементДанных.location.guid, "GUID");
			Если НайденнаяСтрока = Неопределено Тогда
				
				РезультатВыполненияЗапроса = ЦерберВЕТИСВызовСервера.ПредприятиеПоGUID(ПроизводительЭлементДанных.location.guid);
				Если РезультатВыполненияЗапроса.Элемент <> Неопределено Тогда
					
					ПроизводителиСтрокаТЧ = Производители.Добавить();
					ПроизводителиСтрокаТЧ.GUID = РезультатВыполненияЗапроса.Элемент.guid;
					ПроизводителиСтрокаТЧ.Наименование = РезультатВыполненияЗапроса.Элемент.name;
					
					ПроизводителиСписокЗначений.Добавить(РезультатВыполненияЗапроса.Элемент.name);
					
				КонецЕсли;
				
			Иначе
				
				ПроизводителиСписокЗначений.Добавить(НайденнаяСтрока.Наименование);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПроизводителиСписокЗначений.Количество() = 1 Тогда
			НоваяСтрока.Производитель = ПроизводителиСписокЗначений.Получить(0).Значение;
		ИначеЕсли ПроизводителиСписокЗначений.Количество() > 1 Тогда
			НоваяСтрока.Производитель = ПроизводителиСписокЗначений;
		КонецЕсли;
		
	КонецЦикла;
	
	ОпределитьНаличиеПродукции();
	
	ОбщееКоличество                      = Результат.ОбщееКоличество;
	НаименованияПродукцииНомерСтраницы   = НомерСтраницы;
	КоличествоСтраниц                    = Результат.КоличествоСтраниц;
	ОтборыИзменились                     = Ложь;
	
	СформироватьЗаголовокКомандыНавигации();
	
	ДанныеВоВременномХранилище = Новый Структура;
	ДанныеВоВременномХранилище.Вставить("ХозяйствующиеСубъекты", ХозяйствующиеСубъекты);
	ДанныеВоВременномХранилище.Вставить("Производители",         Производители);
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеВоВременномХранилище, УникальныйИдентификатор);
	НастроитьВидимостьТаблицыПоиска(ЭтаФорма);
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНаименованиеПродукции(GUIDПродукции)
	
	Возврат ИнтеграцияВЕТИС.НаименованиеПродукции(GUIDПродукции);
	
КонецФункции

#КонецОбласти

#Область ПроверкаНаличияЭлементовКлассификатораВБазе

&НаСервере
Процедура ОпределитьНаличиеПродукции()
	
	ТаблицаФормы = ЭтаФорма.НаименованияПродукции;
	Если ТаблицаФормы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивИдентификаторов = ТаблицаФормы.Выгрузить(, "GUID").ВыгрузитьКолонку("GUID");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПродукцияВЕТИС.Идентификатор КАК Идентификатор,
	|	ПродукцияВЕТИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПродукцияВЕТИС КАК ПродукцияВЕТИС
	|ГДЕ
	|	ПродукцияВЕТИС.Идентификатор В(&МассивИдентификаторов)";
	
	Запрос.УстановитьПараметр("МассивИдентификаторов", МассивИдентификаторов);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПараметрыПоиска = Новый Структура("GUID");
	
	Пока Выборка.Следующий() Цикл
		
		ПараметрыПоиска.GUID = Выборка.Идентификатор;
		
		НайденныеСтроки = ТаблицаФормы.НайтиСтроки(ПараметрыПоиска);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.ЕстьВБазе = 1;
			НайденнаяСтрока.НаименованиеПродукцииСсылка = Выборка.Ссылка;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура ХозяйствующийСубъектПриИзмененииНаСервере(ПолучатьИдентификатор=Ложь)
	Если ПолучатьИдентификатор
		И ТипЗнч(ХСПроизводительОтбор) = Тип("СправочникСсылка.ХозяйствующиеСубъектыВЕТИС") Тогда
		
		ХСПроизводительGUIDОтбор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ХСПроизводительОтбор, "Идентификатор");
		
	КонецЕсли;
	ОтборыИзменились = Истина;
	СФормироватьПараметрыОтбора(ЭтаФорма);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, 
		"ХозяйствующийСубъектПроизводительИдентификатор",
		ХСПроизводительGUIDОтбор,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ХСПроизводительGUIDОтбор));
КонецПроцедуры

&НаСервере
Процедура ПредприятиеПриИзмененииНаСервере(ПолучатьИдентификатор=Ложь)
	Если ПолучатьИдентификатор
		И ТипЗнч(ПредприятиеОтбор) = Тип("СправочникСсылка.ПредприятияВЕТИС") Тогда
		
		ПредприятиеGUIDОтбор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредприятиеОтбор, "Идентификатор");
		
	КонецЕсли;
	ОтборыИзменились = Истина;
	СФормироватьПараметрыОтбора(ЭтаФорма);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"Производители.Производитель.Идентификатор",
		ПредприятиеGUIDОтбор,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ПредприятиеGUIDОтбор));
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СФормироватьПараметрыОтбора(Форма)
	
	НаименованияПродукцииПараметрыПоиска = Новый Структура();
	Если ЗначениеЗаполнено(Форма.ПредприятиеGUIDОтбор) Тогда
		НаименованияПродукцииПараметрыПоиска.Вставить("Предприятие", Форма.ПредприятиеGUIDОтбор);
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.ХСПроизводительGUIDОтбор) Тогда
		НаименованияПродукцииПараметрыПоиска.Вставить("ХозяйствующийСубъект", Форма.ХСПроизводительGUIDОтбор);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.ВидПродукцииGUID) Тогда
		НаименованияПродукцииПараметрыПоиска.Вставить("ВидПродукции", Форма.ВидПродукцииGUID);
	ИначеЕсли ЗначениеЗаполнено(Форма.ПродукцияGUID) Тогда
		НаименованияПродукцииПараметрыПоиска.Вставить("Продукция", Форма.ПродукцияGUID);
	ИначеЕсли ЗначениеЗаполнено(Форма.ТипПродукцииGUID) Тогда
		НаименованияПродукцииПараметрыПоиска.Вставить("ТипПродукции", Форма.ТипПродукцииGUID);
	КонецЕсли;
	Форма.НаименованияПродукцииПараметрыПоиска = НаименованияПродукцииПараметрыПоиска;
	
	НастроитьВидимостьТаблицыПоиска(Форма);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоВидуПродукции()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, 
		"Родитель",
		ВидПродукции,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ВидПродукции));
КонецПроцедуры

#КонецОбласти

#КонецОбласти
