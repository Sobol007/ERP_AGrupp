#Область ОбработчикиСобытий_Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Отчет.Организация = РЭЙ_Универсализация.ПолучитьОсновнуюОрганизацию();
	Отчет.Статус = "Все";
	
	ЗаполнитьДатуОтчета();
	
	УстановитьОтображение_НаправлениеДвижения();
	УстановитьОтображение_КредитЗаем();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	СформироватьОтчетНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовок(Команда)
	Элементы.ВыводитьЗаголовок.Пометка = Не Элементы.ВыводитьЗаголовок.Пометка;
	ВыводЗаголовка();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтчетаПриИзменении(Элемент)
	Отчет.ДатаОтчетаВручную = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтчетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Отчет.ДатаОтчетаВручную = Ложь;
	ЗаполнитьДатуОтчета();
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	ОтобразитьСостояниеНесформированногоОтчета();
КонецПроцедуры

&НаКлиенте
Процедура СтатусОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Отчет.Статус = "Все";
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ОтобразитьСостояниеНесформированногоОтчета();
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ОтобразитьСостояниеНесформированногоОтчета();
КонецПроцедуры

&НаКлиенте
Процедура ВидКонтрактаВЭДПриИзменении(Элемент)
	ВидКонтрактаВЭДПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВидКонтрактаВЭДПриИзмененииНаСервере()
	ОтобразитьСостояниеНесформированногоОтчета();
	
	Если Отчет.ВидКонтрактаВЭД <> "Контракт" Тогда
		Отчет.НаправлениеДвижения = "";
	КонецЕсли;
	Если Отчет.ВидКонтрактаВЭД <> "Кредитный договор" Тогда
		Отчет.КредитЗаем = "";
	КонецЕсли;
	
	УстановитьОтображение_НаправлениеДвижения();
	УстановитьОтображение_КредитЗаем();
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеДвиженияПриИзменении(Элемент)
	ОтобразитьСостояниеНесформированногоОтчета();
КонецПроцедуры

&НаКлиенте
Процедура КредитЗаемПриИзменении(Элемент)
	ОтобразитьСостояниеНесформированногоОтчета();
КонецПроцедуры

#КонецОбласти

#Область Отображение

&НаСервере
Процедура УстановитьОтображение_НаправлениеДвижения()
	Если Отчет.ВидКонтрактаВЭД = "Контракт" Тогда
		Элементы.НаправлениеДвижения.Видимость = Истина;
	Иначе
		Элементы.НаправлениеДвижения.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображение_КредитЗаем()
	Если Отчет.ВидКонтрактаВЭД = "Кредитный договор" Тогда
		Элементы.КредитЗаем.Видимость = Истина;
	Иначе
		Элементы.КредитЗаем.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДатуОтчета()
	Если Не Отчет.ДатаОтчетаВручную Тогда
		Отчет.ДатаОтчета = ТекущаяДатаСеанса();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтобразитьСостояниеНесформированногоОтчета()
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.Результат.ОтображениеСостояния.Видимость = Истина;
	Отчет.ВысотаЗаголовка = 0;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображение_СправкаВалютногоКонтроля()
	Если Отчет.ВидСправкиВалютногоКонтроля <> "СВО+СПД" Тогда
		Элементы.СправкаВалютногоКонтроля.Видимость = Истина;
	Иначе
		Элементы.СправкаВалютногоКонтроля.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ВыводЗаголовка()
	Если Отчет.ВысотаЗаголовка <> 0 Тогда
		Результат.Область(1,, Отчет.ВысотаЗаголовка).Видимость = Элементы.ВыводитьЗаголовок.Пометка;		
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеОтчета

&НаСервере
Процедура СформироватьОтчетНаСервере()
	ЗаполнитьДатуОтчета();
	
	Результат.Очистить();
	
	Макет = Отчеты.РЭЙ_РеестрКонтрактовВЭД.ПолучитьМакет("Макет");
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.ДатаОтчета = Формат(?(ЗначениеЗаполнено(Отчет.ДатаОтчета), Отчет.ДатаОтчета, ТекущаяДата()), "ДФ='dd.MM.yyyy HH:mm:ss'");
	Область.Параметры.Организация = ?(ЗначениеЗаполнено(Отчет.Организация), Отчет.Организация, "Все");
	Область.Параметры.Контрагент = ?(ЗначениеЗаполнено(Отчет.Контрагент), Отчет.Контрагент, "Все");
	Область.Параметры.ВидКонтрактаВЭД = ?(ЗначениеЗаполнено(Отчет.ВидКонтрактаВЭД), Отчет.ВидКонтрактаВЭД, "Все");
	Область.Параметры.НаправлениеДвижения = ?(ЗначениеЗаполнено(Отчет.НаправлениеДвижения), Отчет.НаправлениеДвижения, "Все");
	Область.Параметры.КредитЗаем = ?(ЗначениеЗаполнено(Отчет.КредитЗаем), Отчет.КредитЗаем, "Все");
	Область.Параметры.Статус = Отчет.Статус;
	Результат.Вывести(Область);
	Отчет.ВысотаЗаголовка = Результат.ВысотаТаблицы;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РЭЙ_КонтрактыВЭД.Ссылка КАК КонтрактВЭД,
	|	РЭЙ_КонтрактыВЭД.Контрагент КАК Контрагент,
	|	РЭЙ_КонтрактыВЭД.КонтрактПредмет КАК Предмет,
	|	РЭЙ_КонтрактыВЭД.ВидКонтрактаВЭД КАК ВидКонтрактаВЭД,
	|	РЭЙ_КонтрактыВЭД.КонтрактСумма КАК Сумма,
	|	РЭЙ_КонтрактыВЭД.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаЦены,
	|	ВЫБОР
	|		КОГДА ЛОЖЬ
	|			ТОГДА ВалютаРегламентированногоУчета.Значение
	|		ИНАЧЕ РЭЙ_КонтрактыВЭД.ДоговорКонтрагента.ВалютаВзаиморасчетов
	|	КОНЕЦ КАК ВалютаПлатежа,
	|	РЭЙ_КонтрактыВЭД.КонтрактДатаОкончания КАК ДатаОкончания,
	|	ВЫБОР
	|		КОГДА РЭЙ_КонтрактыВЭД.НеДействует
	|			ТОГДА ""Закрыт""
	|		ИНАЧЕ ""Действ.""
	|	КОНЕЦ КАК Статус
	|ИЗ
	|	Справочник.РЭЙ_КонтрактыВЭД КАК РЭЙ_КонтрактыВЭД,
	|	Константа.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета";
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.Организация = &Организация");
	КонецЕсли;
	Если ЗначениеЗаполнено(Отчет.Контрагент) Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.Контрагент = &Контрагент");
	КонецЕсли;
	//Вид контракта ВЭД
	Если Отчет.ВидКонтрактаВЭД = "Контракт" Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.КредитныйДоговор = ЛОЖЬ");
	КонецЕсли;
	Если Отчет.ВидКонтрактаВЭД = "Кредитный договор" Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.КредитныйДоговор");
	КонецЕсли;
	//Направление движения
	Если Отчет.НаправлениеДвижения = "Импорт" Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.Импорт");
	КонецЕсли;
	Если Отчет.НаправлениеДвижения = "Экспорт" Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.Экспорт");
	КонецЕсли;
	// Кредит/заем
	Если Отчет.КредитЗаем = "Полученный" Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.ПривлечениеКредитаЗайма");
	КонецЕсли;
	Если Отчет.КредитЗаем = "Выданный" Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.ПредоставлениеЗайма");
	КонецЕсли;
	// Статус
	Если Отчет.Статус = "Действующие" Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.НеДействует = ЛОЖЬ");
	КонецЕсли;
	Если Отчет.Статус = "Закрытые" Тогда
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор.Добавить("РЭЙ_КонтрактыВЭД.НеДействует");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	Запрос.УстановитьПараметр("Организация", Отчет.Организация);
	Запрос.УстановитьПараметр("Контрагент", Отчет.Контрагент);
	РезультатЗапроса = Запрос.Выполнить();
	
	Область = Макет.ПолучитьОбласть("Шапка");
	Результат.Вывести(Область);
	Результат.ФиксацияСверху = Результат.ВысотаТаблицы;
	
	НомерСтроки = 0;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НомерСтроки = НомерСтроки + 1;
		Область = Макет.ПолучитьОбласть("Строка");
		Область.Параметры.Заполнить(Выборка);
		Область.Параметры.НомерСтроки = НомерСтроки;
		
		ПаспортСделки = РЭЙ_СлужебныйСервер.ПолучитьПаспортСделкиПоКонтрактуВЭД(Выборка.КонтрактВЭД);
		Область.Параметры.НомерПС = ПаспортСделки.НомерПаспортаСделки;
		
		Область.Параметры.ВидКонтракта = Сред(Строка(Выборка.ВидКонтрактаВЭД), 1, 1);
		
		БанковскийСчет = РЭЙ_СлужебныйСервер.ПолучитьБанковскийСчетПоКонтрактуВЭД(Выборка.КонтрактВЭД);
		Область.Параметры.НомерСчета = БанковскийСчет.НомерСчета;
		Область.Параметры.СвифтБИК = БанковскийСчет.Банк.РЭЙ_СвифтБИК;
		
		Область.Параметры.Сумма = ?(Выборка.Сумма = 0, "БС", Формат(Выборка.Сумма, "ЧДЦ=2"));
		
		Результат.Вывести(Область);
	КонецЦикла;
	
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Результат.АвтоМасштаб = Истина;
	
	ВыводЗаголовка();
	
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	Элементы.Результат.ОтображениеСостояния.Видимость = Ложь;
КонецПроцедуры

#КонецОбласти
