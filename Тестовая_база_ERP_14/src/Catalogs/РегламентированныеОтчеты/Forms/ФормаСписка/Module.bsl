
#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьОтчет(НаименованиеОтчета = Неопределено)
	Перем Расширение;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	РегламентированныеОтчеты.ЭтоГруппа КАК ЭтоГруппа,
		|	РегламентированныеОтчеты.ИсточникОтчета КАК ИсточникОтчета,
		|	РегламентированныеОтчеты.Наименование КАК Наименование
		|ИЗ
		|	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
		|ГДЕ
		|	РегламентированныеОтчеты.Ссылка = &ТекущаяСтрока
		|");
	
	Запрос.УстановитьПараметр("ТекущаяСтрока", Элементы.Список.ТекущаяСтрока);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Если Выборка.ЭтоГруппа Тогда
		Возврат "ЭтоГруппа";
	КонецЕсли;
	
	ФайлВнешнегоОтчета = Выборка.ИсточникОтчета;
	
	НаименованиеИзСправочника = Выборка.Наименование;
	МетаОтчет = Метаданные.Отчеты.Найти(ФайлВнешнегоОтчета);
	Если МетаОтчет <> Неопределено И МетаОтчет.ОсновнаяФорма <> Неопределено Тогда
			
		НаименованиеОтчета = МетаОтчет.ОсновнаяФорма.Синоним;
			
	Иначе
			
		НаименованиеОтчета = НаименованиеИзСправочника;
			
	КонецЕсли;
	
	ПравоДоступаКОтчету = РегламентированнаяОтчетностьВызовСервера.ПравоДоступаКРегламентированномуОтчету(ФайлВнешнегоОтчета);
	Если ПравоДоступаКОтчету = Ложь Тогда
				
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Недостаточно прав.';
								|en = 'Недостаточно прав.'");
		Сообщение.Сообщить();
		
		Возврат Неопределено;
		
	ИначеЕсли ПравоДоступаКОтчету = Неопределено Тогда
				
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Отчет не найден.';
								|en = 'Отчет не найден.'");
		Сообщение.Сообщить();
		
		Возврат Неопределено;
		
	КонецЕсли;
		
	Если Метаданные.Документы.Найти(ФайлВнешнегоОтчета) <> Неопределено Тогда // это внутренний отчет-документ
			
		ВнутреннийОтчет = Документы[ФайлВнешнегоОтчета];
		Возврат "Документ." + Сред(ВнутреннийОтчет, СтрНайти(ВнутреннийОтчет, ".") + 1) + ".Форма.ФормаДокумента";
			
	КонецЕсли;
	
	// Возвращает типы ВнешнийОтчетОбъект.<Имя> и ОтчетМенеджер.<Имя>
	ТекОтчет = РегламентированнаяОтчетность.РеглОтчеты(ФайлВнешнегоОтчета);
	Если ТекОтчет = Неопределено Тогда
				
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не удалось получить отчет.';
								|en = 'Не удалось получить отчет.'");
		Сообщение.Сообщить();
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Если Сред(ТекОтчет, СтрНайти(ТекОтчет, ".") + 1) = "РегламентированныйОтчетРСВ1" Тогда
		Возврат "Отчет." + Сред(ТекОтчет, СтрНайти(ТекОтчет, ".") + 1) + ".Форма." + РегламентированнаяОтчетностьКлиентСерверПереопределяемый.ИмяОсновнойФормыРСВ1();
	Иначе
		// ВнешнийОтчетОбъект или ОтчетМенеджер
		Возврат ?(СтрНайти(ТекОтчет, "ОтчетМенеджер") > 0, "Отчет.", "ВнешнийОтчет.") + Сред(ТекОтчет, СтрНайти(ТекОтчет, ".") + 1) + ".Форма.ОсновнаяФорма";
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьКнопок(ТекЭлемент)

	Показать = Истина;

	Если ТекЭлемент.ЭтоГруппа Тогда
		Показать = Ложь;
	КонецЕсли;

	Если РежимВыбора Тогда
		Показать = Ложь;
	КонецЕсли;
	
	Элементы.Новый.Доступность = Показать;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
		
	УстановитьОтборДанных();
		
	Список.КомпоновщикНастроек.Настройки.Порядок.Элементы.Очистить();
	ЭлементПорядкаДанных = Список.КомпоновщикНастроек.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядкаДанных.Поле = Новый ПолеКомпоновкиДанных("Код");
	ЭлементПорядкаДанных.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядкаДанных.Использование = Истина;
	
	Список.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
	Список.Параметры.УстановитьЗначениеПараметра("Внешний", " (внешний)");
	
	#Область РасширенныйФункционал
	РегламентированнаяОтчетность.СправочникРегламентированныеОтчеты_ПриСозданииНаСервере(ЭтотОбъект);
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДанных()
	
	СписокСкрытыхРеглОтчетов = Новый СписокЗначений;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
						  | СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет КАК Ссылка
						  |ИЗ
						  |	РегистрСведений.СкрытыеРегламентированныеОтчеты КАК СкрытыеРегламентированныеОтчеты");
						  
	СписокСкрытыхРеглОтчетов.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		
	Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	
	ЭлементОтбораДанных = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
	        	
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбораДанных.ПравоеЗначение = СписокСкрытыхРеглОтчетов;
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбораДанных.Использование = Истина;
		
	Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Элементы.Список.ТекущаяСтрока = НовыйОбъект.Ссылка;
		
КонецПроцедуры

&НаКлиенте
Функция СоздатьНовыйОтчет()
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Выберите отчет.';
								|en = 'Выберите отчет.'");
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	НаименованиеОтчета = "";
	ТекФорма = ПолучитьОтчет(НаименованиеОтчета);
	
	Если ТекФорма = Неопределено
		ИЛИ ТекФорма = "ЭтоГруппа" Тогда
		Возврат ТекФорма;
	КонецЕсли;
	
	Если Ограничения.НайтиПоЗначению(НаименованиеОтчета) <> Неопределено Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Создание отчета в текущем используемом тарифе программы недоступно.';
								|en = 'Создание отчета в текущем используемом тарифе программы недоступно.'");
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	// Сначала попробуем найти его среди открытых стартовых форм.
	// Необходимо при работе под Веб-клиентом для предотвращения
	// открытия нескольких стартовых форм одного отчета
	НайденоОкно = Ложь;
	РегламентированнаяОтчетностьКлиент.ВебКлиентНайтиАктивизироватьОкно(ТекФорма, ЭтаФорма, НайденоОкно);
	Если НайденоОкно <> Неопределено Тогда
		Если НайденоОкно Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
	КонецЕсли;
	
	ТекФорма = ПолучитьФорму(ТекФорма, , ЭтаФорма, ТекФорма);
	
	Если ТекФорма = Неопределено Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не удалось открыть отчет.';
								|en = 'Не удалось открыть отчет.'");
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	ТекФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ТекФорма.Открыть();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНовый(Команда)
	
	СоздатьНовыйОтчет();
	
КонецПроцедуры

&НаСервере
Процедура СкрытьОтчет()
			
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Выберите отчет.';
								|en = 'Выберите отчет.'");
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	РегламентированныеОтчеты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
		|ГДЕ
		|	РегламентированныеОтчеты.Ссылка В(&МассивСсылок)
		|");
	
	Запрос.УстановитьПараметр("МассивСсылок", Элементы.Список.ВыделенныеСтроки);
	Выборка = Запрос.Выполнить().Выбрать();
    	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
				
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		
		Если Объект.ЭтоГруппа Тогда
		
			Попытка
		
				ВыборкаЭлементовГруппы = Справочники.РегламентированныеОтчеты.ВыбратьИерархически(Объект.Ссылка);
				
				Пока ВыборкаЭлементовГруппы.Следующий() Цикл
					
					СкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
					СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет = ВыборкаЭлементовГруппы.Ссылка;
					СкрытыеРегламентированныеОтчеты.Записать();
					
				КонецЦикла;
				
			Исключение
				
				Сообщение = Новый СообщениеПользователю;
				
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось записать ссылку на скрытый отчет в регистр сведений. %1';
																								|en = 'Не удалось записать ссылку на скрытый отчет в регистр сведений. %1'"), ОписаниеОшибки());
				
				Сообщение.Сообщить();
				
				Возврат;
				
			КонецПопытки;
		
		Иначе
		
			Попытка 
				
				СкрытыеРегламентированныеОтчеты = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
				СкрытыеРегламентированныеОтчеты.РегламентированныйОтчет = Объект.Ссылка;
				СкрытыеРегламентированныеОтчеты.Записать();
				
			Исключение
								
				Сообщение = Новый СообщениеПользователю;
				
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось записать ссылку на скрытый отчет в регистр сведений. %1';
																								|en = 'Не удалось записать ссылку на скрытый отчет в регистр сведений. %1'"), ОписаниеОшибки());
				
				Сообщение.Сообщить();
				
				Возврат;
				
			КонецПопытки;
			
		КонецЕсли;
	
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	УстановитьОтборДанных();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Скрыть(Команда)
	
	СкрытьОтчет();
	
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	
	ФормаВыбораЭлементовДляВосстановленияПоказа = ПолучитьФорму("Справочник.РегламентированныеОтчеты.Форма.ФормаВыбораЭлементовДляВосстановленияПоказа", , ЭтаФорма);
	
	Если НЕ ФормаВыбораЭлементовДляВосстановленияПоказа = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВосстановитьЗавершение", ЭтотОбъект);
		ФормаВыбораЭлементовДляВосстановленияПоказа.ОписаниеОповещенияОЗакрытии = ОписаниеОповещения;
		ФормаВыбораЭлементовДляВосстановленияПоказа.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ФормаВыбораЭлементовДляВосстановленияПоказа.Открыть();
	Иначе
		УстановитьОтборДанных();
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УстановитьОтборДанных();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
			
	ОткрытьФорму("Обработка.ОбновлениеРегламентированнойОтчетности.Форма.ОсновнаяФорма", , ЭтаФорма);
	
	УстановитьОтборДанных();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодробнуюИнформацию(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Выберите отчет.';
									|en = 'Выберите отчет.'"));
		
		Возврат;
		
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
				
		ПоказатьПредупреждение(,НСтр("ru = 'Функция недоступна для группы отчетов.';
									|en = 'Функция недоступна для группы отчетов.'"));
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НачальноеЗначениеВыбора", Элементы.Список.ТекущаяСтрока);
	
	ФормаПодробнееОФормах = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ПодробнееОбОтчете", ПараметрыФормы, ЭтаФорма);
	ФормаПодробнееОФормах.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаПодробнееОФормах.Открыть();

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурнал(Команда)
			
	ОткрытьФорму("Документ.РегламентированныйОтчет.ФормаСписка");
		
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если НЕ СоздатьНовыйОтчет() = "ЭтоГруппа" Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)

	ТекущиеДанные = Элемент.ТекущиеДанные;

	Если Не ТекущиеДанные = Неопределено Тогда
		УстановитьВидимостьКнопок(ТекущиеДанные);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Элементы.Список.ТекущаяСтрока = НовыйОбъект;
		
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	СтруктураПараметров = Новый Структура("Ключ", Элементы.Список.ТекущаяСтрока);
	
	Если Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда 
		
		ОткрытьФорму("Справочник.РегламентированныеОтчеты.ФормаГруппы", СтруктураПараметров);
		
	Иначе
		
		ОткрытьФорму("Справочник.РегламентированныеОтчеты.ФормаОбъекта", СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти