
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ХозяйственнаяОперация = Параметры.Отбор.ХозяйственнаяОперация;
	Параметры.Отбор.Удалить("ХозяйственнаяОперация");
	
	ШаблонЗаголовка = НСтр("ru = 'Выбор статьи ДДС для операции ""%1""';
							|en = 'Select cash flow item for transaction ""%1""'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, ХозяйственнаяОперация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокПоХозяйственнойОперации,
			"ХозяйственныеОперации.ХозяйственнаяОперация",
			ХозяйственнаяОперация,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
			
	РежимВыбора = "ПоХозОперации";
	Элементы.СписокПоХозяйственнойОперацииВыбрать.КнопкаПоУмолчанию = Истина;
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.СтатьиДвиженияДенежныхСредств) Тогда
		Элементы.РежимВыбора.Видимость = Ложь;
		Элементы.СписокПоХозяйственнойОперацииСкрытьОтВыбора.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СписокПоХозяйственнойОперации.ТекущаяСтрока = Параметры.ТекущаяСтрока;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФильтрПриИзменении(Элемент)
	
	ИспользованиеОтбора = ?(РежимВыбора = "ПоХозОперации", Истина, Ложь);
	
	Элементы.ГруппаСтраницыСписков.ТекущаяСтраница = ?(ИспользованиеОтбора,
		Элементы.СтраницаОтборПоХозОперации, Элементы.СтраницаВсе);
		
	Элементы.СписокПоХозяйственнойОперацииВыбрать.КнопкаПоУмолчанию = ИспользованиеОтбора;
	Элементы.СписокВсеВыбрать.КнопкаПоУмолчанию = НЕ ИспользованиеОтбора;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПоХозяйственнойОперацииВыборЗначения(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВсеВыборЗначения(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПривязатьХозОперациюКСтатьям(ВыбранноеЗначение, ХозяйственнаяОперация);
	Если ВыбранноеЗначение.Количество() > 1 Тогда
		РежимВыбора = "ПоХозОперации";
		Элементы.ГруппаСтраницыСписков.ТекущаяСтраница = Элементы.СтраницаОтборПоХозОперации;
	Иначе
		ОповеститьОВыборе(ВыбранноеЗначение[0]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкрытьОтВыбора(Команда)
	
	МассивСтатей = Элементы.СписокПоХозяйственнойОперации.ВыделенныеСтроки;
	МассивЗаблокированных = ПеренестиВоВсеСтатьиНаСервере(МассивСтатей, ХозяйственнаяОперация);
	
	Если МассивЗаблокированных.Количество() = 1 Тогда
		ШаблонТекстаОшибки = НСтр("ru = 'Не удалось перенести статью ДДС ""%1"".
									|Возможно статья ДДС редактируется другим пользователем.';
									|en = 'Cannot transfer CF item ""%1"".
									|Maybe, CF item is being edited by another user.'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаОшибки, МассивЗаблокированных[0]);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
	ИначеЕсли МассивЗаблокированных.Количество() > 1 Тогда
		ТекстОшибки = НСтр("ru = 'Не удалось перенести несколько статей ДДС.
								|Возможно статьи ДДС редактируются другими пользователями:';
								|en = 'Cannot transfer several CF items.
								|Maybe, CF items are being edited by another user:'");
		Для Индекс = 0 По МассивЗаблокированных.ВГраница()-1 Цикл
			СтатьяДДС = МассивЗаблокированных[Индекс];
			ТекстОшибки = ТекстОшибки + Символы.ПС + 
							"   - " + СтатьяДДС + ";"
		КонецЦикла;
		ТекстОшибки = ТекстОшибки + Символы.ПС + 
			"   - " + МассивЗаблокированных[Индекс] + ".";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
	КонецЕсли;
	
	Элементы.СписокПоХозяйственнойОперации.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПеренестиВоВсеСтатьиНаСервере(МассивСтатейДДС, ХозяйственнаяОперация)
	
	МассивЗаблокированных = Новый Массив;
	
	Для Каждого СтатьяДДС Из МассивСтатейДДС Цикл		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(СтатьяДДС);
		Исключение
			МассивЗаблокированных.Добавить(СтатьяДДС);
			Продолжить;
		КонецПопытки;
		СтатьяОбъект = СтатьяДДС.ПолучитьОбъект();
		СтатьяОбъект.ОбменДанными.Загрузка = Истина;
		СтрокаТабличнойЧасти = СтатьяОбъект.ХозяйственныеОперации.Найти(ХозяйственнаяОперация, "ХозяйственнаяОперация");
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			СтатьяОбъект.ХозяйственныеОперации.Удалить(СтрокаТабличнойЧасти);
			СтатьяОбъект.Записать();
		КонецЕсли;
		СтатьяОбъект.Разблокировать();
	КонецЦикла;
	
	Возврат МассивЗаблокированных;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПривязатьХозОперациюКСтатьям(МассивСтатейДДС, ХозяйственнаяОперация)
	
	Для Каждого СтатьяДДС Из МассивСтатейДДС Цикл
		Попытка
			ЗаблокироватьДанныеДляРедактирования(СтатьяДДС);
		Исключение
			Продолжить;
		КонецПопытки;
		СтатьяОбъект = СтатьяДДС.ПолучитьОбъект();
		Если СтатьяОбъект.ХозяйственныеОперации.Найти(ХозяйственнаяОперация, "ХозяйственнаяОперация") = Неопределено Тогда
			СтатьяОбъект.ОбменДанными.Загрузка = Истина;
			СтатьяОбъект.ХозяйственныеОперации.Добавить().ХозяйственнаяОперация = ХозяйственнаяОперация;
			СтатьяОбъект.Записать();
			СтатьяОбъект.Разблокировать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВсеСоздать(Команда)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриЗакрытииВладельца, ЗначенияЗаполнения");
	ПараметрыФормы.ЗакрыватьПриЗакрытииВладельца = Истина;
	ПараметрыФормы.ЗначенияЗаполнения = Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация);
	ОткрытьФорму("Справочник.СтатьиДвиженияДенежныхСредств.Форма.ФормаЭлемента", ПараметрыФормы, Элементы.СписокВсе);
	
КонецПроцедуры

#КонецОбласти