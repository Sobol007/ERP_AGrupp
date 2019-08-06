
#Область ОбработчикиСобытийФормы

Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
	Если Параметры.Отбор.Свойство("Идентификатор") Тогда
		СписокИдентификаторов.ЗагрузитьЗначения(Параметры.Отбор.Идентификатор);
		ИспользуетсяОтбор = Истина;
	Иначе
		Элементы.СписокОчиститьОтбор.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ПоискНеНастроен.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.ПоискНеНастроен.ОтображениеСостояния.Текст = НСтр("ru = 'Элементы классификатора не выведены. Для отображения элементов справочника выберите команду Обновить.';
																|en = 'Элементы классификатора не выведены. Для отображения элементов справочника выберите команду Обновить.'");
	Элементы.ПоискНеНастроен.ОтображениеСостояния.Видимость = Истина;
	
	Элементы.СписокВыбратьИзСправочника.Видимость = РежимВыбора;
	Элементы.ВыбратьИзКлассификатора.Видимость = РежимВыбора;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЦелиВЕТИС" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗагружено;
		ПриСменеОсновнойСтраницы();
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Параметр;
		ОпределитьНаличиеПродукции();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиПродукцию(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(1);
	
	Элементы.СтраницыПоиска.ТекущаяСтраница = Элементы.СтраницаРезультатПоиска;
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПервая(Команда)
	
	ПерейтиПоНомеруСтраницы(1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПредыдущая(Команда)
	ПерейтиПоНомеруСтраницы(СписокНомерСтраницы-1);
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаТекущаяСтраница(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("МаксимальныйНомерСтраницы", КоличествоСтраниц);
	ПараметрыОткрытияФормы.Вставить("НомерСтраницы",             СписокНомерСтраницы);
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.ПереходКСтраницеПоНомеру",
		ПараметрыОткрытияФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ПослеВыбораНомераСтраницы", ЭтотОбъект));
		
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаСледующая(Команда)
	
	ПерейтиПоНомеруСтраницы(СписокНомерСтраницы + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПоследняя(Команда)
	
	ПерейтиПоНомеруСтраницы(КоличествоСтраниц);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзСправочника(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	ТекущиеДанные = Элементы.НазначенияГрузов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если ИспользуетсяОтбор
		И СписокИдентификаторов.НайтиПоЗначению(ТекущиеДанные.GUID) = Неопределено Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Выбранное значение не соответствует отбору.';
									|en = 'Выбранное значение не соответствует отбору.'"));
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.СсылкаВБазе) Тогда
		ОповеститьОВыборе(ТекущиеДанные.СсылкаВБазе);
	Иначе
		ОповеститьОВыборе(ЗагрузитьЭлементКлассификатора(ТекущиеДанные.GUID));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтбор(Команда)
	ИспользуетсяОтбор = НЕ ИспользуетсяОтбор;
	Элементы.СписокОчиститьОтбор.Пометка = НЕ ИспользуетсяОтбор;
	УстановитьСнятьОтборСписка();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ПриСменеОсновнойСтраницы();
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НазначенияГрузовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.НазначенияГрузов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		ВыбратьИзКлассификатора(Неопределено);
	Иначе
		ПараметрыОткрытия = Новый Структура;
		Если ЗначениеЗаполнено(ТекущиеДанные.СсылкаВБазе) Тогда
			ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.СсылкаВБазе);
		Иначе
			ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ТекущаяСтрокаСтруктурой(ТекущиеДанные));
		КонецЕсли;
		ОткрытьФорму("Справочник.ЦелиВЕТИС.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкаЭлементовФормы

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Элемент не соответствует отбору.';
								|en = 'Элемент не соответствует отбору.'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НазначенияГрузов");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НазначенияГрузов.GUID");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокИдентификаторов;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользуетсяОтбор");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНомераСтраницы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПерейтиПоНомеруСтраницы(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиПоНомеруСтраницы(НомерСтраницы)
	
	ОчиститьСообщения();
	
	Если НомерСтраницы < 1
		ИЛИ НомерСтраницы > КоличествоСтраниц Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьСписок(НомерСтраницы);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокКомандыНавигации()
	КолвоСтраницНадпись = ?(КоличествоСтраниц=0,1,КоличествоСтраниц);
	Элементы.НавигацияСтраницаТекущаяСтраница.Заголовок =
		СтрШаблон(
			НСтр("ru = 'Страница %1 из %2';
				|en = 'Страница %1 из %2'"),
			СписокНомерСтраницы, КолвоСтраницНадпись);
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

&НаКлиенте
Процедура УстановитьСнятьОтборСписка()
	
	ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Список.Отбор, "Идентификатор",,,,ИспользуетсяОтбор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбменСВЕТИС

&НаСервере
Процедура ЗагрузитьСписок(НомерСтраницы)
	
	Результат = ПрочиеКлассификаторыВЕТИСВызовСервера.СписокЦелей(НомерСтраницы);
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	НазначенияГрузов.Очистить();
	Для Каждого СтрокаТЧ Из Результат.Список Цикл
		
		НоваяСтрока = НазначенияГрузов.Добавить();
		НоваяСтрока.Активность              = СтрокаТЧ.active;
		НоваяСтрока.Актуальность            = СтрокаТЧ.last;
		НоваяСтрока.GUID                    = СтрокаТЧ.GUID;
		НоваяСтрока.UUID                    = СтрокаТЧ.UUID;
		НоваяСтрока.Наименование            = СтрокаТЧ.Name;
		НоваяСтрока.ДатаСоздания            = СтрокаТЧ.createDate;
		НоваяСтрока.ДатаИзменения           = СтрокаТЧ.updateDate;
		НоваяСтрока.ДляНекачественногоГруза = СтрокаТЧ.forSubstandard;
		
		НоваяСтрока.Статус = ИнтеграцияВЕТИСПовтИсп.СтатусВерсионногоОбъекта(СтрокаТЧ.status);
		
	КонецЦикла;
	
	ОпределитьНаличиеПродукции();
	
	ОбщееКоличество     = Результат.ОбщееКоличество;
	СписокНомерСтраницы = НомерСтраницы;
	КоличествоСтраниц   = Результат.КоличествоСтраниц;
	
	СформироватьЗаголовокКомандыНавигации();
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьЭлементКлассификатора(GUIDЭлемента)
	
	Возврат ИнтеграцияВЕТИС.Цель(GUIDЭлемента);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекущаяСтрокаСтруктурой(ТекущиеДанные)
	СтруктураЗаполнения = Новый Структура();
	СтруктураЗаполнения.Вставить("Наименование",            ТекущиеДанные.Наименование);
	СтруктураЗаполнения.Вставить("Идентификатор",           ТекущиеДанные.GUID);
	СтруктураЗаполнения.Вставить("ИдентификаторВерсии",     ТекущиеДанные.UUID);
	СтруктураЗаполнения.Вставить("Статус",                  ТекущиеДанные.Статус);
	СтруктураЗаполнения.Вставить("ДляНекачественныхГрузов", ТекущиеДанные.ДляНекачественногоГруза);
	
	Возврат СтруктураЗаполнения
КонецФункции

#КонецОбласти

#Область ПроверкаНаличияЭлементовКлассификатораВБазе

&НаСервере
Процедура ОпределитьНаличиеПродукции()
	
	ТаблицаФормы = ЭтаФорма.НазначенияГрузов;
	Если ТаблицаФормы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивИдентификаторов = ТаблицаФормы.Выгрузить(, "GUID").ВыгрузитьКолонку("GUID");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЦелиВЕТИС.Идентификатор КАК Идентификатор,
	|	ЦелиВЕТИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЦелиВЕТИС КАК ЦелиВЕТИС
	|ГДЕ
	|	ЦелиВЕТИС.Идентификатор В(&МассивИдентификаторов)";
	
	Запрос.УстановитьПараметр("МассивИдентификаторов", МассивИдентификаторов);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПараметрыПоиска = Новый Структура("GUID");
	
	Пока Выборка.Следующий() Цикл
		
		ПараметрыПоиска.GUID = Выборка.Идентификатор;
		
		НайденныеСтроки = ТаблицаФормы.НайтиСтроки(ПараметрыПоиска);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.ЕстьВБазе = 1;
			НайденнаяСтрока.СсылкаВБазе = Выборка.Ссылка;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
