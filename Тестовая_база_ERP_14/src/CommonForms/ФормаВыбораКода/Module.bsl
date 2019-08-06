////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.ТекущийПериод) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Период';
																					|en = 'Period'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.ТекущийПериод", , Отказ);
	КонецЕсли;
	
	ТипОбъекта		 = Параметры.ТипОбъекта;
	НазваниеОбъекта	 = Параметры.НазваниеОбъекта;
	НазваниеМакета	 = Параметры.НазваниеМакета;
	ВыборСпискаКодов = Параметры.ВыборСпискаКодов;
	ЗакрыватьПриВыборе = Ложь;
	
	Элементы.СписокКодовПометка.Видимость = ВыборСпискаКодов;
	
	Если ТипОбъекта = "РегистрСведений" Тогда
		ПараметрыВыбораДляКода = РегистрыСведений[НазваниеОбъекта].ПолучитьПараметрыФормыВыбораДляКода(НазваниеМакета, Параметры.ТекущийПериод);
	ИначеЕсли ТипОбъекта = "Справочник" Тогда	
		ПараметрыВыбораДляКода = Справочники[НазваниеОбъекта].ПолучитьПараметрыФормыВыбораДляКода(НазваниеМакета, Параметры.ТекущийПериод);
	Иначе
		Отказ	= Истина;
		Возврат;
	КонецЕсли;
	
	Если ПараметрыВыбораДляКода.Свойство("ТекущийПериод") Тогда
		ТекущийПериод = ПараметрыВыбораДляКода.ТекущийПериод;
	КонецЕсли;
	
	Если ПараметрыВыбораДляКода.Свойство("СписокПериодовДействия")
		И ПараметрыВыбораДляКода.СписокПериодовДействия.Количество() > 1 Тогда
	
		Счетчик = 0;
		Элементы.ПериодНачалаДействия.СписокВыбора.Очистить();
		Для каждого СтрокаСписокОбластей Из ПараметрыВыбораДляКода.СписокПериодовДействия Цикл
			Элементы.ПериодНачалаДействия.СписокВыбора.Вставить(
			Счетчик, СтрокаСписокОбластей.Значение, СтрокаСписокОбластей.Значение + " г.");
			Счетчик = Счетчик + 1;
		КонецЦикла;
		ПериодНачалаДействия = ТекущийПериод;
	Иначе
		Элементы.ПериодНачалаДействия.Видимость	= Ложь;
	КонецЕсли;
	
	ДлинаНаименования	= 0;
	Для каждого СтрокаКода Из ПараметрыВыбораДляКода.СписокКодов Цикл
		ДлинаНаименования	= Макс(ДлинаНаименования, СтрДлина(СтрокаКода.Наименование));
	КонецЦикла;
	
	Если ДлинаНаименования > 100 Тогда
		Элементы.СписокКодовНаименование.МногострочныйРежим	= Истина;
	КонецЕсли;
	
	СписокКодов.Загрузить(ПараметрыВыбораДляКода.СписокКодов);
	
	Если ВыборСпискаКодов Тогда
	
		Если Параметры.Свойство("ТекущийСписок") 
			И ТипЗнч(Параметры.ТекущийСписок) = Тип("Массив") Тогда
			Для каждого ТекущийКод Из Параметры.ТекущийСписок Цикл
				НайденныеКоды = СписокКодов.НайтиСтроки(Новый Структура("Код", ТекущийКод));
				Если НайденныеКоды.Количество() > 0 Тогда
					НайденныеКоды[0].Пометка = Истина;
					Если Элементы.СписокКодов.ТекущаяСтрока = Неопределено Тогда
						Элементы.СписокКодов.ТекущаяСтрока = НайденныеКоды[0].ПолучитьИдентификатор();
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	
	Иначе
		
		Если Параметры.Свойство("ТекущийКод") Тогда
			НайденныеКоды = СписокКодов.НайтиСтроки(Новый Структура("Код", Параметры.ТекущийКод));
			Если НайденныеКоды.Количество() > 0 Тогда
				Элементы.СписокКодов.ТекущаяСтрока = НайденныеКоды[0].ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Комментарий) Тогда
		Комментарий = Параметры.Комментарий;
		Элементы.Комментарий.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ПериодНачалаДействияПриИзменении(Элемент)
	
	Если Элемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокКодов.Очистить();
	
	ПериодНачалаДействияПриИзмененииСервер(Элемент.ТекстРедактирования);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ТАБЛИЦЫ СписокКодов

&НаКлиенте
Процедура СписокКодовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыборСпискаКодов Тогда
		
		ВыбранныеКоды = Новый Массив;
		ОтмеченныеСтроки = СписокКодов.НайтиСтроки(Новый Структура("Пометка", Истина));
		Если ОтмеченныеСтроки.Количество() > 0 Тогда
			Для каждого ОтмеченнаяСтрока Из ОтмеченныеСтроки Цикл
				ВыбранныеКоды.Добавить(ОтмеченнаяСтрока.Код);
			КонецЦикла;
		КонецЕсли;
		Закрыть(ВыбранныеКоды);
	
	Иначе
	
		ВыбраннаяСтрока = Элементы.СписокКодов.ТекущиеДанные;
		Если НЕ ВыбраннаяСтрока = Неопределено И НЕ ПустаяСтрока(ВыбраннаяСтрока.Код) Тогда
			Если НазваниеМакета = "ВидыТранспортныхСредств" Тогда
				Закрыть(Новый Структура("КодВидаТС, Наименование, КодЕдиницыИзмерения",
					ВыбраннаяСтрока.Код, ВыбраннаяСтрока.Наименование, ВыбраннаяСтрока.КодЕдиницыИзмерения));

			ИначеЕсли НазваниеМакета = "ОКВЭД" ИЛИ НазваниеМакета = "ОКОПФ" ИЛИ НазваниеМакета = "ОКФС" ИЛИ НазваниеМакета = "ОКВЭД2" Тогда
				
				Закрыть(Новый Структура("Код, Наименование",
					ВыбраннаяСтрока.Код, ВыбраннаяСтрока.Наименование));
					
			Иначе
				Закрыть(ВыбраннаяСтрока.Код);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ПериодНачалаДействияПриИзмененииСервер(ИсходнаяСтрока)
	
	Значение = ПолучитьТолькоЦифрыИзСтроки(ИсходнаяСтрока);
	
	Если ТипОбъекта = "РегистрСведений" Тогда
		Макет = РегистрыСведений[НазваниеОбъекта].ПолучитьМакет(НазваниеМакета);
	ИначеЕсли ТипОбъекта = "Справочник" Тогда	
		Макет = Справочники[НазваниеОбъекта].ПолучитьМакет(НазваниеМакета);
	Иначе
		Возврат;
	КонецЕсли;
	
	ТекущаяОбласть = Макет.Области.Найти("Область" + Значение);
	
	Если НЕ ТекущаяОбласть = Неопределено Тогда	
		
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			// Перебираем строки макета.
			КодПоказателя = СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название      = СокрП(Макет.Область(НомерСтр, 2).Текст);
			Единица       = СокрП(Макет.Область(НомерСтр, 3).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				НоваяСтрока = СписокКодов.Добавить();
				НоваяСтрока.Код                 = КодПоказателя;
				НоваяСтрока.Наименование        = Название;
				НоваяСтрока.КодЕдиницыИзмерения = Единица;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьТолькоЦифрыИзСтроки(ИсходнаяСтрока)
	
	Результат = "";
	
	Для НомерСимвола = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		КодСимвола = КодСимвола(ИсходнаяСтрока, НомерСимвола);
		Если КодСимвола > 47 И КодСимвола < 58 Тогда // Число.
			Результат = Результат + Символ(КодСимвола);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
