///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет задать настройки для регистрации событий доступа к персональным данным.
//
// При расширении состава субъектов персональных данных следует иметь в виду, что регистрация событий для них
// не начнется автоматически (это отдельно настраивает администратор программы). Однако если необходимо управлять этим
// при переходе на новую версию программы, то следует реализовать обработчик обновления, вызывающий 
// процедуру ЗащитаПерсональныхДанных.УстановитьИспользованиеСобытияДоступ.
//
// Параметры:
//   ТаблицаСведений    - ТаблицаЗначений - таблица с полями:
//    * Объект          - Строка - полное имя объекта метаданных с персональными данными;
//    * ПоляРегистрации - Строка - имена полей, значения которых выводятся в журнал событий доступа к персональным
//                                 данным для идентификации субъекта персональных данных. Для ссылочных типов, 
//                                 как правило, это поле "Ссылка". Отдельные поля регистрации отделяются запятой, 
//                                 альтернативные - символом "|";
//    * ПоляДоступа     - Строка - имена полей доступа через запятую. Обращение (попытка доступа) к этим полям 
//                                 приводит к записи журнала;
//    * ОбластьДанных   - Строка - идентификатор области данных, если их несколько. Необязательно для заполнения.
//
// Пример:
//  Сведения = ТаблицаСведений.Добавить();
//  Сведения.Объект				= "Справочник.ФизическиеЛица";
//  Сведения.ПоляРегистрации	= "Ссылка";
//  Сведения.ПоляДоступа		= "Наименование,ДатаРождения";
//  Сведения.ОбластьДанных		= "ЛичныеДанные";
//
//  Сведения = ТаблицаСведений.Добавить();
//  Сведения.Объект				= "Справочник.ФизическиеЛица";
//  Сведения.ПоляРегистрации	= "Ссылка";
//  Сведения.ПоляДоступа		= "СерияДокумента,НомерДокумента,КемВыданДокумент,ДатаВыдачиДокумента";
//  Сведения.ОбластьДанных		= "ПаспортныеДанные";
//
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	//++ Локализация
	
	//++ НЕ УТ
	ЗарплатаКадры.ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений);
	
	ТаблицаСведенийСтрока = ТаблицаСведений.Найти("Документ.ОтражениеЗарплатыВФинансовомУчете", "Объект");
	Пока ТаблицаСведенийСтрока <> Неопределено Цикл
		
		ТаблицаСведений.Удалить(ТаблицаСведенийСтрока);
		ТаблицаСведенийСтрока = ТаблицаСведений.Найти("Документ.ОтражениеЗарплатыВФинансовомУчете", "Объект")
		
	КонецЦикла;
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ОтражениеЗарплатыВФинансовомУчете";
	НовыеСведения.ПоляРегистрации	= "НачисленнаяЗарплатаИВзносыПоФизлицам.ФизическоеЛицо,УдержаннаяЗарплата.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа		= "НачисленнаяЗарплатаИВзносыПоФизлицам.Сумма,УдержаннаяЗарплата.Сумма";
	НовыеСведения.ОбластьДанных		= "Доходы";
	
	//-- НЕ УТ
	
	// СтандартныеПодсистемы.ФизическиеЛица
	Если ТаблицаСведений.Найти("Справочник.ФизическиеЛица", "Объект") = Неопределено Тогда
		НовыеСведения = ТаблицаСведений.Добавить();
		НовыеСведения.Объект			= "Справочник.ФизическиеЛица";
		НовыеСведения.ПоляРегистрации	= "Ссылка";
		НовыеСведения.ПоляДоступа		= "ДатаРождения,Пол,ИНН";
		НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
		
		НовыеСведения = ТаблицаСведений.Добавить();
		НовыеСведения.Объект			= "Справочник.ФизическиеЛица";
		НовыеСведения.ПоляРегистрации	= "Ссылка";
		НовыеСведения.ПоляДоступа		= "КонтактнаяИнформация.ЗначенияПолей,КонтактнаяИнформация.Представление,КонтактнаяИнформация.Регион,КонтактнаяИнформация.Город,КонтактнаяИнформация.АдресЭП,КонтактнаяИнформация.НомерТелефона,КонтактнаяИнформация.НомерТелефонаБезКодов";
		НовыеСведения.ОбластьДанных		= "КонтактнаяИнформация";
	КонецЕсли;
	
	Если ТаблицаСведений.Найти("РегистрСведений.ДокументыФизическихЛиц", "Объект") = Неопределено Тогда
		НовыеСведения = ТаблицаСведений.Добавить();
		НовыеСведения.Объект			= "РегистрСведений.ДокументыФизическихЛиц";
		НовыеСведения.ПоляРегистрации	= "Физлицо";
		НовыеСведения.ПоляДоступа		= "ВидДокумента,Серия,Номер,ДатаВыдачи,СрокДействия,КемВыдан,КодПодразделения,Представление";
		НовыеСведения.ОбластьДанных		= "ПаспортныеДанные";
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФизическиеЛица
	
	//-- Локализация
	
КонецПроцедуры

// Обеспечивает составление коллекции областей персональных данных.
//
// Параметры:
//		ОбластиПерсональныхДанных - ТаблицаЗначений - таблица с полями:
//			* Имя			- Строка - идентификатор области данных.
//			* Представление	- Строка - пользовательское представление области данных.
//			* Родитель		- Строка - идентификатор родительской области данных.
//
Процедура ЗаполнитьОбластиПерсональныхДанных(ОбластиПерсональныхДанных) Экспорт
	
	//++ Локализация
	
	//++ НЕ УТ 
	ЗарплатаКадры.ЗаполнитьОбластиПерсональныхДанных(ОбластиПерсональныхДанных);
	//-- НЕ УТ
	
	// СтандартныеПодсистемы.ФизическиеЛица
	Если ОбластиПерсональныхДанных.Найти("ЛичныеДанные", "Имя") = Неопределено Тогда
		НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
		НоваяОбласть.Имя = "ЛичныеДанные";
		НоваяОбласть.Представление = НСтр("ru = 'Личные данные';
											|en = 'Personal data'");
	КонецЕсли;
	
	Если ОбластиПерсональныхДанных.Найти("ПаспортныеДанные", "Имя") = Неопределено Тогда
		НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
		НоваяОбласть.Имя = "ПаспортныеДанные";
		НоваяОбласть.Представление = НСтр("ru = 'Паспортные данные';
											|en = 'Passport data'");
		НоваяОбласть.Родитель = "ЛичныеДанные";
	КонецЕсли;
	
	Если ОбластиПерсональныхДанных.Найти("КонтактнаяИнформация", "Имя") = Неопределено Тогда
		НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
		НоваяОбласть.Имя = "КонтактнаяИнформация";
		НоваяОбласть.Представление = НСтр("ru = 'Адреса и телефоны';
											|en = 'Addresses and phones'");
		НоваяОбласть.Родитель = "ЛичныеДанные";
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФизическиеЛица
	
	//-- Локализация

КонецПроцедуры

// Вызывается при заполнении формы "Согласие на обработку персональных данных" данными, 
// переданных в качестве параметров, субъектов.
//
// Параметры:
//		СубъектыПерсональныхДанных 	- ДанныеФормыКоллекция - содержит сведения о субъектах.
//		ДатаАктуальности			- Дата - дата, на которую нужно заполнить сведения.
//
Процедура ДополнитьДанныеСубъектовПерсональныхДанных(СубъектыПерсональныхДанных, ДатаАктуальности) Экспорт
	
	//++ Локализация
	
	Для Каждого СтрокаСубъект Из СубъектыПерсональныхДанных Цикл
		Если ТипЗнч(СтрокаСубъект.Субъект) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			СтрокаСубъект.ФИО 			   = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаСубъект.Субъект, "Наименование");
			СтрокаСубъект.ПаспортныеДанные = РегистрыСведений.ДокументыФизическихЛиц.ДокументУдостоверяющийЛичностьФизлица(СтрокаСубъект.Субъект, ДатаАктуальности);
			СтрокаСубъект.Адрес 		   = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(СтрокаСубъект.Субъект, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
		КонецЕсли;
	КонецЦикла;
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается при заполнении формы "Согласие на обработку персональных данных" данными организации.
//
// Параметры:
//		Организация			- ОпределяемыйТип.Организация - оператор персональных данных.
//		ДанныеОрганизации	- Структура - данные об организации (адрес, ФИО ответственного и т.д.).
//		ДатаАктуальности	- Дата      - дата, на которую нужно заполнить сведения.
//
Процедура ДополнитьДанныеОрганизацииОператораПерсональныхДанных(Организация, ДанныеОрганизации, ДатаАктуальности) Экспорт
	
	//++ Локализация
	ДанныеОрганизации.Вставить(
		"НаименованиеОрганизации",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование"));
	ДанныеОрганизации.Вставить(
		"АдресОрганизации",
		УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			Организация,
			Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, ДатаАктуальности));
	ДанныеОрганизации.Вставить(
		"ОтветственныйЗаОбработкуПерсональныхДанных",
		ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(
			ОтветственныеЛицаСервер.ПолучитьДанныеОтветственногоЛица(
				Организация,
				ДатаАктуальности,
				Перечисления.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы
			).ФизическоеЛицо,
			ДатаАктуальности));
	//-- Локализация
	
КонецПроцедуры

// Вызывается при заполнении формы "Согласие на обработку персональных данных".
// Предназначена для заполнения поля ФИО ответственного за обработку ПДн.
//
// Параметры:
//		ФизическоеЛицо	- ОпределяемыйТип.ФизическоеЛицо - ответственный за обработку персональных данных.
//		ФИО				- Строка - ФИО ответственного, которые нужно заполнить.
//
Процедура ЗаполнитьФИОФизическогоЛица(ФизическоеЛицо, ФИО) Экспорт
	
	//++ Локализация
	//++ НЕ УТ 
	ЗарплатаКадры.ПриЗаполненииФИОФизическогоЛица(ФизическоеЛицо, ФИО);
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

// Позволяет проверить возможность скрытия персональных данных и задать состав исключений для записи в данных.
//
// Параметры:
//   Субъекты - Массив - ссылки на объекты данных, чьи персональные данные будут скрыты.
//   ТаблицаИсключений - ТаблицаЗначений - таблица, в которую добавляются субъекты и причины отказа их скрытия.
//   							Состав полей см. в функции ЗащитаПерсональныхДанных.НоваяТаблицаИсключений.
//   Отказ - Булево - (по умолчанию Истина) признак отказа от скрытия. Если конфигурация адаптирована к обменам, и
//   							определены причины отказа от скрытия, то параметру необходимо установить значение Ложь.
//
Процедура ПередСкрытиемПерсональныхДанныхСубъектов(Субъекты, ТаблицаИсключений, Отказ) Экспорт

	
	
КонецПроцедуры

#КонецОбласти
