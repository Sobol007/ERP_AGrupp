#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	АдресВоВременномХранилищеКонтракты = Параметры.АдресВоВременномХранилищеКонтракты;
	Организация = Параметры.Организация;
	ДатаСоставленияОтчета = Параметры.ДатаСоставленияОтчета;
	
	ВыбранныеКонтракты = ПолучитьИзВременногоХранилища(АдресВоВременномХранилищеКонтракты);
	Если ВыбранныеКонтракты = Неопределено Тогда
		ВыбранныеКонтракты = Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НаправленияДеятельности.ГосударственныйКонтракт КАК ГосударственныйКонтракт,
	|	НаправленияДеятельности.ГосударственныйКонтракт.Код КАК ИГК,
	|	НаправленияДеятельности.ГосударственныйКонтракт.Наименование КАК НаименованиеГосударственногоКонтракт,
	|	НаправленияДеятельности.ГосударственныйКонтракт.Ссылка КАК ГосударственногоКонтракт,
	|	НаправленияДеятельности.ГосударственныйКонтракт.ДатаЗаключения КАК ДатаЗаключенияГосударственногоКонтракта,
	|	НаправленияДеятельности.Ссылка КАК Контракт,
	|	НаправленияДеятельности.Наименование КАК Наименование,
	|	НаправленияДеятельности.ДатаЗаключенияКонтракта КАК ДатаЗаключенияКонтракта,
	|	НаправленияДеятельности.НомерКонтракта КАК НомерКонтракта,
	|	ВЫБОР
	|		КОГДА НаправленияДеятельности.Ссылка В (&ВыбранныеКонтракты) 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Флаг
	|ИЗ
	|	Справочник.НаправленияДеятельности КАК НаправленияДеятельности
	|ГДЕ
	|	НаправленияДеятельности.ТипНаправленияДеятельности = ЗНАЧЕНИЕ(Перечисление.ТипыНаправленийДеятельности.КонтрактГОЗ)
	|	И НЕ НаправленияДеятельности.ПометкаУдаления
	|	И НаправленияДеятельности.ДатаЗаключенияКонтракта <= &ДатаСоставленияОтчета 
	|	И НаправленияДеятельности.ДатаЗаключенияКонтракта <> ДАТАВРЕМЯ(1,1,1)
	|	И ВЫБОР 
	|		КОГДА НаправленияДеятельности.ФактическаяДатаЗавершения <> ДАТАВРЕМЯ(1,1,1)
	|			ТОГДА КОНЕЦПЕРИОДА(НаправленияДеятельности.ФактическаяДатаЗавершения, МЕСЯЦ) > КОНЕЦПЕРИОДА(&ДатаСоставленияОтчета, МЕСЯЦ)
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|ИТОГИ
	|	МАКСИМУМ(ИГК),
	|	МАКСИМУМ(ГосударственногоКонтракт),
	|	МАКСИМУМ(ДатаЗаключенияГосударственногоКонтракта),
	|	МАКСИМУМ(Флаг)
	|ПО
	|	ГосударственныйКонтракт";
	Запрос.УстановитьПараметр("ВыбранныеКонтракты", ВыбранныеКонтракты);
	Запрос.УстановитьПараметр("ДатаСоставленияОтчета", ДатаСоставленияОтчета);
	
	Дерево = РеквизитФормыВЗначение("ДеревоКонтрактов");
	Дерево.Строки.Очистить();
	ВыборкаГосударственныеКонтракты = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаГосударственныеКонтракты.Следующий() Цикл
		СтрокаГосударственныйКонтракт = Дерево.Строки.Добавить();
		СтрокаГосударственныйКонтракт.Ссылка = ВыборкаГосударственныеКонтракты.ГосударственногоКонтракт;
		СтрокаГосударственныйКонтракт.Наименование = ВыборкаГосударственныеКонтракты.НаименованиеГосударственногоКонтракт;
		СтрокаГосударственныйКонтракт.НомерКонтракта = ВыборкаГосударственныеКонтракты.ИГК;
		СтрокаГосударственныйКонтракт.ДатаЗаключенияКонтракта = ВыборкаГосударственныеКонтракты.ДатаЗаключенияГосударственногоКонтракта;
		СтрокаГосударственныйКонтракт.Флаг = ВыборкаГосударственныеКонтракты.Флаг;
		ВыборкаКонтракты = ВыборкаГосударственныеКонтракты.Выбрать();
		Пока ВыборкаКонтракты.Следующий() Цикл
			 СтрокаКонтракт = СтрокаГосударственныйКонтракт.Строки.Добавить();
			 СтрокаКонтракт.Ссылка = ВыборкаКонтракты.Контракт;
			 СтрокаКонтракт.Наименование = ВыборкаКонтракты.Наименование;
			 СтрокаКонтракт.ДатаЗаключенияКонтракта = ВыборкаКонтракты.ДатаЗаключенияКонтракта;
			 СтрокаКонтракт.НомерКонтракта = ВыборкаКонтракты.НомерКонтракта;
			 СтрокаКонтракт.Флаг = ВыборкаКонтракты.Флаг;
		КонецЦикла;
	КонецЦикла;
	ЗначениеВРеквизитФормы(Дерево, "ДеревоКонтрактов");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Строки = ДеревоКонтрактов.ПолучитьЭлементы();
	Для Каждого Строка Из Строки Цикл
		Элементы.ДеревоКонтрактов.Развернуть(Строка.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Выбранные контракты не перенесены в отчет. После закрытия сделанные изменения сохранены не будут.';
									|en = 'Selected contracts are not transferred to the report. After closing, the changes you made will not be saved.'");
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикОповещенияВопросПередЗакрытием", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Выбранные контракты не перенесены в отчет. Перенести?';
							|en = 'Selected contracts are not transferred to the report. Transfer?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоКонтрактовФлагПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоКонтрактов.ТекущиеДанные;
	
	Контракты = ТекущиеДанные.ПолучитьЭлементы();
	Для каждого Контракт Из Контракты Цикл
		Контракт.Флаг = ТекущиеДанные.Флаг;
	КонецЦикла;
	
	ГосударственныйКонтракт = ТекущиеДанные.ПолучитьРодителя();
	Если ГосударственныйКонтракт <> Неопределено Тогда
		ГосударственныйКонтракт.Флаг = ГосударственныйКонтракт.Флаг ИЛИ ТекущиеДанные.Флаг;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтрактовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = ДеревоКонтрактов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если Поле.Имя <> "ДеревоКонтрактовФлаг" 
		И ЗначениеЗаполнено(ДанныеСтроки.Ссылка) Тогда
		ПоказатьЗначение(, ДанныеСтроки.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Результат = ПоместитьВыбранныеКонтрактыВХранилище();
	Если Результат <> Неопределено Тогда
		Модифицированность = Ложь;
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьЗначенияФлажков(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьЗначенияФлажков(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработчикОповещенияВопросПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Результат = ПоместитьВыбранныеКонтрактыВХранилище();
		Если Результат <> Неопределено Тогда
			Отказ = Ложь;
			Модифицированность = Ложь;
			Закрыть(Результат);
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоместитьВыбранныеКонтрактыВХранилище()
	
	ВыбранныеКонтракты = Новый Массив;
	ГосударственныеКонтракты = ДеревоКонтрактов.ПолучитьЭлементы();
	Для каждого ГосударственныйКонтракт Из ГосударственныеКонтракты Цикл 
		Контракты = ГосударственныйКонтракт.ПолучитьЭлементы();
		Для каждого Контракт Из Контракты Цикл
			Если Контракт.Флаг Тогда
				ВыбранныеКонтракты.Добавить(Контракт.Ссылка);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если ВыбранныеКонтракты.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо выбрать контракты.';
																|en = 'Select contracts.'"), , "ДеревоКонтрактов");
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ВыбранныеКонтракты,  АдресВоВременномХранилищеКонтракты);
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКонтрактовНаименование.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКонтрактов.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Государственный контракт не выбран';
																|en = 'State contract not selected'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКонтрактовНомерКонтракта.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКонтрактов.НомерКонтракта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не заполнен>';
																|en = '<Not populated>'"));
	
	//
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьЗначенияФлажков(Значение)
	
	ГосударственныеКонтракты = ДеревоКонтрактов.ПолучитьЭлементы();
	Для каждого ГосударственныйКонтракт Из ГосударственныеКонтракты Цикл 
		ГосударственныйКонтракт.Флаг = Значение;
		Контракты = ГосударственныйКонтракт.ПолучитьЭлементы();
		Для каждого Контракт Из Контракты Цикл
			Контракт.Флаг = Значение;
		КонецЦикла;
	КонецЦикла;
	
КонецФункции

#КонецОбласти