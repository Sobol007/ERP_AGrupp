////////////////////////////////////////////////////////////////////////////////
// Обработка.ОбменСКонтрагентами.Форма.УсловияИспользования
//
// Параметры:
//  СписокПрофилейНастроекЭДО - СписокЗначений - профили, для которых нужно соглашение с условиями использования
//                                               и заполнение информации для контрагентов.
//                                               Если не заполнен, то принятие условий использования не требуется (только текст).
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	СписокПрофилейНастроекЭДО = Параметры.СписокПрофилейНастроекЭДО;
	ЗаполнитьИнформациюДляКонтрагентов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнициализироватьТекущийЭтап();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПринятыУсловияИспользованияПриИзменении(Элемент)
	
	ОбработатьУсловияИспользования();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИнформацияДляКонтрагентов

&НаКлиенте
Процедура ИнформацияДляКонтрагентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ИнформацияДляКонтрагентовПрофильНастроекЭДО" Тогда
		ТекСтрока = ИнформацияДляКонтрагентов.НайтиПоИдентификатору(ВыбраннаяСтрока);
		ПоказатьЗначение(,ТекСтрока.ПрофильНастроекЭДО);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияДляКонтрагентовПриАктивизацииСтроки(Элемент)
	
	Для каждого СтрокаИнформации Из ИнформацияДляКонтрагентов Цикл
		Если СтрокаИнформации.ЭтоАктивнаяСтрока Тогда
			СтрокаИнформации.ЭтоАктивнаяСтрока = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элемент.ТекущиеДанные.ЭтоАктивнаяСтрока = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ВыпольнитьТекущийЭтап();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ОтменитьТекущийЭтап();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСФормой

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияДляКонтрагентовНазначениеУчетнойЗаписи.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияДляКонтрагентов.ЭтоАктивнаяСтрока");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияДляКонтрагентов.НазначениеУчетнойЗаписи");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Например, ""Для документов от поставщиков""';
																|en = 'For example, ""For documents from suppliers.""'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.МелкийШрифтТекста);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияДляКонтрагентовПодробноеОписаниеУчетнойЗаписи.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияДляКонтрагентов.ЭтоАктивнаяСтрока");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияДляКонтрагентов.ПодробноеОписаниеУчетнойЗаписи");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Например, можно указать контакты ответственных сотрудников';
																|en = 'For example, you can specify contacts of responsible employees'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.МелкийШрифтТекста);
	
КонецПроцедуры

#КонецОбласти

#Область ЭтапыОбработки

&НаКлиенте
Функция НовыйЭтап(Знач Имя = "")
	
	Этап = Новый Структура;
	Этап.Вставить("Имя", Имя);
	
	Возврат Этап;
	
КонецФункции

&НаКлиенте
Функция ЭтапыОбработки()
	
	Этапы = Новый Массив;
	Этапы.Добавить(ЭтапУсловияИспользования());
	Если ЗначениеЗаполнено(ИнформацияДляКонтрагентов) Тогда
		Этапы.Добавить(ЭтапИнформацияДляКонтрагентов());
	КонецЕсли;
	
	Возврат Этапы;
	
КонецФункции

&НаКлиенте
Процедура НастроитьКомандыПереходаПоЭтапам()
	
	ВсеЭтапы = ЭтапыОбработки();
	ВсегоЭтапов = ВсеЭтапы.Количество();
	
	ПервыйЭтап = ВсеЭтапы[0];
	ПоследнийЭтап = ВсеЭтапы[ВсегоЭтапов - 1];
	
	ЭтоПервыйЭтап = (ТекущийЭтап.Имя = ПервыйЭтап.Имя);
	ЭтоПоследнийЭтап = (ТекущийЭтап.Имя = ПоследнийЭтап.Имя);
	
	Элементы.КомандаНазад.Видимость = Не ЭтоПервыйЭтап;
	Элементы.КомандаДалее.Заголовок = ?(ЭтоПоследнийЭтап, НСтр("ru = 'Готово';
																|en = 'Finish'"), НСтр("ru = 'Далее';
																						|en = 'Next'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьТекущийЭтап(Знач Этап = Неопределено)
	
	Если Этап = Неопределено Тогда
		ВсеЭтапы = ЭтапыОбработки();
		Этап = ВсеЭтапы[0];
	КонецЕсли;
	
	ТекущийЭтап = Этап;
	
	НастроитьКомандыПереходаПоЭтапам();
	
	Если ТекущийЭтап.Имя = ЭтапУсловияИспользования().Имя Тогда
		ЭтапУсловияИспользования_Инициализация();
	ИначеЕсли ТекущийЭтап.Имя = ЭтапИнформацияДляКонтрагентов().Имя Тогда
		ЭтапИнформацияДляКонтрагентов_Инициализация();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыпольнитьТекущийЭтап()
	
	Если ТекущийЭтап.Имя = ЭтапИнформацияДляКонтрагентов().Имя Тогда
		ЭтапИнформацияДляКонтрагентов_Выполнение();
	Иначе
		ПерейтиКСледующемуЭтапу();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьТекущийЭтап()
	
	Если ТекущийЭтап.Имя = ЭтапУсловияИспользования().Имя Тогда
		ЭтапУсловияИспользования_Отмена();
	Иначе
		ПерейтиКПредыдущемуЭтапу();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСледующемуЭтапу()
	
	ВсеЭтапы = ЭтапыОбработки();
	ВсегоЭтапов = ВсеЭтапы.Количество();
	
	НомерТекущегоЭтапа = Неопределено;
	Для НомерЭтапа = 1 По ВсегоЭтапов Цикл
		Этап = ВсеЭтапы[НомерЭтапа - 1];
		Если Этап.Имя = ТекущийЭтап.Имя Тогда
			НомерТекущегоЭтапа = НомерЭтапа;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НомерТекущегоЭтапа >= ВсегоЭтапов Тогда
		ЗавершитьОбработку();
		Возврат;
	КонецЕсли;
	
	НовыйЭтап = ВсеЭтапы[НомерТекущегоЭтапа];
	ИнициализироватьТекущийЭтап(НовыйЭтап);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКПредыдущемуЭтапу()
	
	ВсеЭтапы = ЭтапыОбработки();
	ВсегоЭтапов = ВсеЭтапы.Количество();
	
	НомерТекущегоЭтапа = Неопределено;
	Для НомерЭтапа = 1 По ВсегоЭтапов Цикл
		Этап = ВсеЭтапы[НомерЭтапа - 1];
		Если Этап.Имя = ТекущийЭтап.Имя Тогда
			НомерТекущегоЭтапа = НомерЭтапа;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НомерТекущегоЭтапа <= 1 Тогда
		Возврат;
	КонецЕсли;
	
	НовыйЭтап = ВсеЭтапы[НомерТекущегоЭтапа - 2];
	ИнициализироватьТекущийЭтап(НовыйЭтап);
	
КонецПроцедуры

#КонецОбласти

#Область ЭтапУсловияИспользования

&НаКлиенте 
Функция ЭтапУсловияИспользования()
	
	Этап = НовыйЭтап("УсловияИспользования");
	
	Возврат Этап;
	
КонецФункции

&НаКлиенте
Процедура ЭтапУсловияИспользования_Инициализация()
	
	Элементы.Панель.ТекущаяСтраница = Элементы.СтраницаУсловияИспользования;
	Если Не ЗначениеЗаполнено(СписокПрофилейНастроекЭДО) Тогда
		Элементы.ПринятыУсловияИспользования.Видимость = Ложь;
		ПринятыУсловияИспользования = Истина;
	КонецЕсли;
	ОбработатьУсловияИспользования();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапУсловияИспользования_Отмена()
	
	ОбработатьУсловияИспользования(Истина);
	ПерейтиКПредыдущемуЭтапу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьУсловияИспользования(ОтменаЭтапа = Ложь)
	
	Элементы.КомандаДалее.Доступность = ПринятыУсловияИспользования ИЛИ ОтменаЭтапа;
	
КонецПроцедуры

#КонецОбласти

#Область ЭтапИнформацияДляКонтрагентов

&НаКлиенте
Функция ЭтапИнформацияДляКонтрагентов()
	
	Этап = НовыйЭтап("ИнформацияДляКонтрагентов");
	
	Возврат Этап;
	
КонецФункции

&НаКлиенте
Процедура ЭтапИнформацияДляКонтрагентов_Инициализация()
	
	Элементы.Панель.ТекущаяСтраница = Элементы.СтраницаИнформацияДляКонтрагентов;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапИнформацияДляКонтрагентов_Выполнение(Знач ПромежуточныйРезультат = Неопределено, Знач ПроцессВыполнения = Неопределено) Экспорт
	
	// Метод может вызывать сам себя через асинхронную обработку.
	// Параметр ПроцессВыполнения контролирует уже выполненные промежуточные этапы.
	Если ПроцессВыполнения = Неопределено Тогда
		ПроцессВыполнения = Новый Структура;
		ПроцессВыполнения.Вставить("ВопросПродолжитьБезЗаполнения", Неопределено);
	КонецЕсли;
	Если ПроцессВыполнения.Свойство("ПромежуточныйЭтап") Тогда
		ПроцессВыполнения.Вставить(ПроцессВыполнения.ПромежуточныйЭтап, ПромежуточныйРезультат);
	КонецЕсли;
	
	// Проверим, что заполнена информация для контрагентов 
	// или что пользователь продолжил обработку без заполнения.
	Если ИнформацияДляКонтрагентовЗаполнена()
		ИЛИ ПроцессВыполнения.ВопросПродолжитьБезЗаполнения = КодВозвратаДиалога.Да Тогда
		ПерейтиКСледующемуЭтапу();
	ИначеЕсли ПроцессВыполнения.ВопросПродолжитьБезЗаполнения = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Иначе
		ПроцессВыполнения.Вставить("ПромежуточныйЭтап", "ВопросПродолжитьБезЗаполнения");
		ОбработкаОтвета = Новый ОписаниеОповещения("ЭтапИнформацияДляКонтрагентов_Выполнение", ЭтотОбъект, ПроцессВыполнения);
		ТекстВопроса = НСтр("ru = 'Не заполнена информация для контрагентов. Продолжить без заполнения?';
							|en = 'Information for counterparties is not filled in. Continue without filling in?'");
		ПоказатьВопрос(ОбработкаОтвета, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИнформацияДляКонтрагентовЗаполнена()
	
	Результат = Истина;
	
	Для каждого СтрокаИнформации Из ИнформацияДляКонтрагентов Цикл
		Если Не (ЗначениеЗаполнено(СтрокаИнформации.НазначениеУчетнойЗаписи)
			И ЗначениеЗаполнено(СтрокаИнформации.ПодробноеОписаниеУчетнойЗаписи)) Тогда
			Результат = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьИнформациюДляКонтрагентов()
	
	ИнформацияДляКонтрагентов.Очистить();
	
	Если Не ЗначениеЗаполнено(СписокПрофилейНастроекЭДО) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДО.Ссылка КАК ПрофильНастроекЭДО,
	|	ПрофилиНастроекЭДО.НазначениеУчетнойЗаписи КАК НазначениеУчетнойЗаписи,
	|	ПрофилиНастроекЭДО.ПодробноеОписаниеУчетнойЗаписи КАК ПодробноеОписаниеУчетнойЗаписи
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО КАК ПрофилиНастроекЭДО
	|ГДЕ
	|	ПрофилиНастроекЭДО.Ссылка В(&СписокПрофилейНастроекЭДО)
	|	И ПрофилиНастроекЭДО.СпособОбменаЭД В(&СпособыОбменаЧерезОператора)
	|	И ПрофилиНастроекЭДО.НазначениеУчетнойЗаписи = """"
	|	И (ВЫРАЗИТЬ(ПрофилиНастроекЭДО.ПодробноеОписаниеУчетнойЗаписи КАК СТРОКА(100))) = """"
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПрофилиНастроекЭДО.Наименование";
	Запрос.УстановитьПараметр("СписокПрофилейНастроекЭДО", СписокПрофилейНастроекЭДО);
	СпособыОбменаЧерезОператора = Новый Массив;
	СпособыОбменаЧерезОператора.Добавить(Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО);
	СпособыОбменаЧерезОператора.Добавить(Перечисления.СпособыОбменаЭД.ЧерезОператораЭДОТакском);
	Запрос.УстановитьПараметр("СпособыОбменаЧерезОператора", СпособыОбменаЧерезОператора);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовСтр = ИнформацияДляКонтрагентов.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Выборка);
	КонецЦикла;
	
	ОдинПрофиль = (ИнформацияДляКонтрагентов.Количество() = 1);
	
	Элементы.ПанельИнформацияДляКонтрагентов.ТекущаяСтраница = 
		?(ОдинПрофиль,
		Элементы.СтраницаИнформацияДляКонтрагентовСтрока,
		Элементы.СтраницаИнформацияДляКонтрагентовТаблица);
	
	Элементы.НадписьИнформацияДляКонтрагентов.Заголовок =
		?(ОдинПрофиль,
		НСтр("ru = 'Заполните сведения о своей учетной записи.';
			|en = 'Fill in your account information.'"),
		НСтр("ru = 'Заполните сведения о своих учетных записях.';
			|en = 'Fill in your accounts information.'"))
		+ " " + НСтр("ru = 'Это позволит контрагентам получать информацию о ваших требованиях к электронному документообороту в любой удобный момент.';
					|en = 'This will allow counterparties to receive information about your requirements for electronic document flow at any convenient time.'");
	
КонецПроцедуры

#КонецОбласти

#Область ЗавершениеОбработки

&НаСервере
Процедура ОбработатьПрофильНастроекЭДО(Знач ПрофильНастроекЭДО)
	
	ПрофильОбъект = ПрофильНастроекЭДО.ПолучитьОбъект();
	ПрофильОбъект.Заблокировать();
	ПрофильОбъект.ПринятыУсловияИспользования = ПринятыУсловияИспользования;
	
	ОтборПрофиля = Новый Структура("ПрофильНастроекЭДО", ПрофильНастроекЭДО);
	НайденныеСтроки = ИнформацияДляКонтрагентов.НайтиСтроки(ОтборПрофиля);
	Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
		Информация = НайденныеСтроки[0];
		Если ЗначениеЗаполнено(Информация.НазначениеУчетнойЗаписи)
			И Не ЗначениеЗаполнено(ПрофильОбъект.НазначениеУчетнойЗаписи) Тогда
			ПрофильОбъект.НазначениеУчетнойЗаписи = Информация.НазначениеУчетнойЗаписи;
		КонецЕсли;
		Если ЗначениеЗаполнено(Информация.ПодробноеОписаниеУчетнойЗаписи)
			И Не ЗначениеЗаполнено(ПрофильОбъект.ПодробноеОписаниеУчетнойЗаписи) Тогда
			ПрофильОбъект.ПодробноеОписаниеУчетнойЗаписи = Информация.ПодробноеОписаниеУчетнойЗаписи;
		КонецЕсли;
	КонецЕсли;
	
	ПрофильОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьОбработкуНаСервере()
	
	Для каждого Элемент Из СписокПрофилейНастроекЭДО Цикл
		
		ОбработатьПрофильНастроекЭДО(Элемент.Значение);
		
	КонецЦикла;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработку()
	
	Если ЗначениеЗаполнено(СписокПрофилейНастроекЭДО) Тогда
		ЗавершитьОбработкуНаСервере();
	КонецЕсли;
	
	Закрыть(ПринятыУсловияИспользования);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

