#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Период КАК Период,
	|	ТаблицаПередЗаписью.Организация КАК Организация,
	|	ТаблицаПередЗаписью.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаПередЗаписью.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияДляВычисленияАмортизации,
	|	ТаблицаПередЗаписью.СтоимостьДляВычисленияАмортизации КАК СтоимостьДляВычисленияАмортизации,
	|	ТаблицаПередЗаписью.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ТаблицаПередЗаписью.КоэффициентАмортизации КАК КоэффициентАмортизации,
	|	ТаблицаПередЗаписью.КоэффициентУскорения КАК КоэффициентУскорения
	|ПОМЕСТИТЬ ПараметрыАмортизацииОСБухгалтерскийУчетПередЗаписью
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Регистратор = &Регистратор";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	&Регистратор             КАК Документ
	|ПОМЕСТИТЬ ПараметрыАмортизацииОСБухгалтерскийУчетИзменение
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 1
	|		ТаблицаПередЗаписью.Период            КАК Период,
	|		ТаблицаПередЗаписью.Организация       КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		ПараметрыАмортизацииОСБухгалтерскийУчетПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет КАК ТаблицаПриЗаписи
	|			ПО ТаблицаПриЗаписи.ОсновноеСредство = ТаблицаПередЗаписью.ОсновноеСредство
	|				И ТаблицаПриЗаписи.Организация = ТаблицаПередЗаписью.Организация
	|				И ТаблицаПриЗаписи.Регистратор = &Регистратор
	|		ГДЕ
	|			(НАЧАЛОПЕРИОДА(ТаблицаПриЗаписи.Период, МЕСЯЦ) <> НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ)
	|				ИЛИ ТаблицаПриЗаписи.СрокИспользованияДляВычисленияАмортизации <> ТаблицаПередЗаписью.СрокИспользованияДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьДляВычисленияАмортизации <> ТаблицаПередЗаписью.СтоимостьДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.ОбъемПродукцииРаботДляВычисленияАмортизации <> ТаблицаПередЗаписью.ОбъемПродукцииРаботДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.КоэффициентАмортизации <> ТаблицаПередЗаписью.КоэффициентАмортизации
	|				ИЛИ ТаблицаПриЗаписи.КоэффициентУскорения <> ТаблицаПередЗаписью.КоэффициентУскорения
	|				ИЛИ ТаблицаПриЗаписи.Период ЕСТЬ NULL)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ ПЕРВЫЕ 1
	|		ТаблицаПриЗаписи.Период,
	|		ТаблицаПриЗаписи.Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет КАК ТаблицаПриЗаписи
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПараметрыАмортизацииОСБухгалтерскийУчетПередЗаписью КАК ТаблицаПередЗаписью
	|			ПО ТаблицаПриЗаписи.ОсновноеСредство = ТаблицаПередЗаписью.ОсновноеСредство
	|				И ТаблицаПриЗаписи.Организация = ТаблицаПередЗаписью.Организация
	|		ГДЕ
	|			(НАЧАЛОПЕРИОДА(ТаблицаПриЗаписи.Период, МЕСЯЦ) <> НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ)
	|				ИЛИ ТаблицаПриЗаписи.СрокИспользованияДляВычисленияАмортизации <> ТаблицаПередЗаписью.СрокИспользованияДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьДляВычисленияАмортизации <> ТаблицаПередЗаписью.СтоимостьДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.ОбъемПродукцииРаботДляВычисленияАмортизации <> ТаблицаПередЗаписью.ОбъемПродукцииРаботДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.КоэффициентАмортизации <> ТаблицаПередЗаписью.КоэффициентАмортизации
	|				ИЛИ ТаблицаПриЗаписи.КоэффициентУскорения <> ТаблицаПередЗаписью.КоэффициентУскорения
	|				ИЛИ ТаблицаПередЗаписью.Период ЕСТЬ NULL)
	|			И ТаблицаПриЗаписи.Регистратор = &Регистратор
	|
	|	) КАК Таблица
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПараметрыАмортизацииОСБухгалтерскийУчетПередЗаписью";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("ПараметрыАмортизацииОСБухгалтерскийУчетИзменение", Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
