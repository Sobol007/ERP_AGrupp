
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Организация = Параметры.Организация;
	ВидДвижения = Параметры.ВидДвижения;
	Счет = Параметры.Счет;
	
	Элементы.УчетПоНаправлениямДеятельности.Видимость = Справочники.НаправленияДеятельности.ИспользуетсяУчетПоНаправлениям();
	ЗаполнитьИспользованныеСчета();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСписок 

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Элемент.ДанныеСтроки(Значение).ЗапретитьИспользоватьВПроводках Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыИспользованныеСчета

&НаКлиенте
Процедура ИспользованныеСчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ИспользованныеСчетаДокумент Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованныеСчетаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОповеститьОВыборе(Элемент.ТекущиеДанные.Счет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ЗаполнитьИспользованныеСчета()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ОтражениеДокументов.Регистратор) КАК Документ,
	|	ВЫБОР
	|		КОГДА &ВидДвижения = Значение(Перечисление.ВидыДвиженийБухгалтерии.Дебет)
	|			ТОГДА РегистрБухгалтерии.СчетДт
	|		ИНАЧЕ РегистрБухгалтерии.СчетКт
	|	КОНЕЦ КАК Счет
	|ПОМЕСТИТЬ ТаблицаСчетов
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ОтражениеДокументов
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрБухгалтерии.Международный КАК РегистрБухгалтерии
	|	ПО
	|		ОтражениеДокументов.Регистратор = РегистрБухгалтерии.Регистратор
	|ГДЕ
	|	ОтражениеДокументов.Организация = &Организация
	|	И ОтражениеДокументов.Статус = Значение(Перечисление.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчетеВручную)
	|	И ((&ВидДвижения = Значение(Перечисление.ВидыДвиженийБухгалтерии.Дебет) И РегистрБухгалтерии.СчетКт = &Счет)
	|		ИЛИ (&ВидДвижения = Значение(Перечисление.ВидыДвиженийБухгалтерии.Кредит) И РегистрБухгалтерии.СчетДт = &Счет))
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА &ВидДвижения = Значение(Перечисление.ВидыДвиженийБухгалтерии.Дебет)
	|			ТОГДА РегистрБухгалтерии.СчетДт
	|		ИНАЧЕ РегистрБухгалтерии.СчетКт
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСчетов.Документ КАК Документ,
	|	ТаблицаСчетов.Счет КАК Счет
	|ИЗ
	|	ТаблицаСчетов КАК ТаблицаСчетов
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПланСчетов.Международный КАК Международный
	|	ПО
	|		НЕ Международный.ЗапретитьИспользоватьВПроводках
	|		И ТаблицаСчетов.Счет = Международный.Ссылка
	|";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвижения);
	Запрос.УстановитьПараметр("Счет", Счет);
	ИспользованныеСчета.Загрузить(Запрос.Выполнить().Выгрузить());
	КоличествоИспользованныхСчетов = ИспользованныеСчета.Количество();

КонецПроцедуры

#КонецОбласти
