
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создание контрагента в информационной базе по реквизитам.
//
// Параметры:
//   РеквизитыКонтрагента - Структура - реквизиты необходимые для создания контрагента.
//    * ИНН - Строка - ИНН контрагента.
//    * КПП - Строка - КПП контрагента.
//    * Наименование - Строка - наименование контрагента.
//   Контрагент - СправочникСсылка - ссылка на созданного контрагента.
//   Отказ - Булево - признак ошибки.
//
Процедура СоздатьКонтрагентаПоРеквизитам(Знач РеквизитыКонтрагента, Контрагент, Отказ = Ложь) Экспорт
	
	//++ НЕ ГОСИС
	Контрагент = ЭлектронноеВзаимодействиеУТ.СоздатьКонтрагентаВБД(РеквизитыКонтрагента);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возвращает контакты пользователя для регистрации в сервисе.
//
// Параметры:
//   КонтактноеЛицо - СправочникСсылка - пользователь программы, контактное лицо.
//   Результат - Структура - информация о пользователе:
//     * ФИО - Строка - ФИО пользователя.
//     * Телефон - Строка - номер телефона.
//     * ЭлектроннаяПочта - Строка - адрес электронной почты пользователя.
//
Процедура ПолучитьКонтактнуюИнформациюПользователя(Знач КонтактноеЛицо, Результат) Экспорт
	
	//++ НЕ ГОСИС
	Если Не ЗначениеЗаполнено(КонтактноеЛицо) Тогда
		КонтактноеЛицо = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если ТипЗнч(КонтактноеЛицо) = Тип("СправочникСсылка.Пользователи") Тогда
		КонтактноеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователи.ТекущийПользователь(), "ФизическоеЛицо");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтактноеЛицо) И ТипЗнч(КонтактноеЛицо) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Результат.ФИО = Строка(КонтактноеЛицо);
		Результат.ЭлектроннаяПочта = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(КонтактноеЛицо, Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица);
		Результат.Телефон = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(КонтактноеЛицо, Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица);
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Проверка соответствия реквизитов в документах.
//
// Параметры:
//   ДокументыКонтроля - Массив - проверяемые ссылки объектов.
//   ТекстСообщения - Строка - текст сообщения в случае ошибки проверки.
//   Отказ - Булево - результат проверки.
//
Процедура ВыполнитьКонтрольРеквизитовДокументов(Знач ДокументыКонтроля, ТекстСообщения, Отказ) Экспорт
	
	//++ НЕ ГОСИС
	ИмяМетаданных = "";
	Для Каждого Ссылка Из ДокументыКонтроля Цикл
		Если ИмяМетаданных = "" Тогда
			ИмяМетаданных = Ссылка.Метаданные().Имя;
		ИначеЕсли ИмяМетаданных <> Ссылка.Метаданные().Имя Тогда
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'Операция невозможна для разных видов документов';
									|en = 'Operation is not allowed for different document kinds'");
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Реквизиты = "Организация, Контрагент";
	Если ИмяМетаданных = "КоммерческоеПредложениеКлиенту" Тогда
		Реквизиты = "Организация, Соглашение.Контрагент";
	КонецЕсли;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ";
	МассивРеквизитов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(Реквизиты, ",");
	ПоследнийЭлемент = МассивРеквизитов.Получить(МассивРеквизитов.Количество()-1);
	Для Каждого Элемент Из МассивРеквизитов Цикл
		ТекстЗапроса = ТекстЗапроса + Символы.ПС + Символы.Таб + ИмяМетаданных + "." + СокрЛП(Элемент)
			+ ?(Элемент = ПоследнийЭлемент, "", ",");
	КонецЦикла;
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ИЗ " + "Документ." + ИмяМетаданных + " КАК "
		+ ИмяМетаданных	+ " ГДЕ " + ИмяМетаданных + ".Ссылка В(&ДокументыКонтроля)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ДокументыКонтроля", ДокументыКонтроля);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() > 1 Тогда
		Отказ = Истина;
		Шаблон = НСтр("ru = 'Операция невозможна. Отличаются реквизиты документов (%1)';
						|en = 'Operation is not allowed. Different document attributes (%1)'");
		ТекстСообщения = СтрШаблон(Шаблон, Реквизиты);
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Получение списка контрагентов по сделкам для отправки приглашений.
//
// Параметры:
//  Организация			 - СправочникСсылка - ссылка на организацию, от которой производится приглашение.
//  РежимЗаполнения		 - Строка - режим заполнения контрагентов: "ЗаполнитьПоПоставкам", "ЗаполнитьПоЗакупкам", "ЗаполнитьПоВсемСделкам".
//  НачалоПериода		 - Дата - начало периода заполнения.
//  СписокКонтрагентов	 - ТаблицаЗначений - список контрагентов:
//    * Ссылка - СправочникСсылка - контрагент.
//    * ЭлектроннаяПочта - Строка - адрес электронной почты.
//
Процедура ПолучитьКонтрагентовПоСделкам(Организация, РежимЗаполнения, НачалоПериода, СписокКонтрагентов) Экспорт
	
	//++ НЕ ГОСИС
	ВзаиморасчетыСервер.ПолучитьКонтрагентовПоСделкам(Организация, РежимЗаполнения, НачалоПериода, СписокКонтрагентов)
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

