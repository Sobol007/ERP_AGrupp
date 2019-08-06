
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заколовок = НСтр("ru = 'Характеристики номенклатуры: %1';
					|en = 'Product characteristics: %1'");
	Заголовок = СтрЗаменить(Заколовок, "%1", Параметры.Номенклатура);

	ХарактеристикиИсключения = Параметры.СписокХарактеристикиИсключения.ВыгрузитьЗначения();
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика,
	|	ВЫБОР
	|		КОГДА НЕ &ЕстьИсключения
	|				ИЛИ ХарактеристикиНоменклатуры.Ссылка В (&ХарактеристикиИсключения)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Выбрана
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО (ВЫБОР
	|				КОГДА Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|					ТОГДА Номенклатура.Ссылка
	|				КОГДА Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры)
	|					ТОГДА Номенклатура.ВладелецХарактеристик
	|				КОГДА Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры)
	|					ТОГДА Номенклатура.ВидНоменклатуры
	|				ИНАЧЕ НЕОПРЕДЕЛЕНО
	|			КОНЕЦ = ХарактеристикиНоменклатуры.Владелец)
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|	И Номенклатура.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
	|	И НЕ ХарактеристикиНоменклатуры.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Номенклатура",                   Параметры.Номенклатура);
	Запрос.УстановитьПараметр("ХарактеристикиИсключения",       ХарактеристикиИсключения);
	Запрос.УстановитьПараметр("ЕстьИсключения",                 ХарактеристикиИсключения.Количество()>0);
	ТаблицаХарактеристик.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыХарактеристик

&НаКлиенте
Процедура ТаблицаХарактеристикВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТаблицаХарактеристик.ТекущиеДанные;
	
	Если Поле = Элементы.ТаблицаХарактеристикХарактеристика Тогда
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.Характеристика) Тогда
			ПоказатьЗначение(Неопределено, ТекущаяСтрока.Характеристика);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	МассивСтрок = Элементы.ТаблицаХарактеристик.ВыделенныеСтроки;
	ВыбратьВыделенныеСтрокиНаСервере(МассивСтрок);
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	МассивСтрок = Элементы.ТаблицаХарактеристик.ВыделенныеСтроки;
	ВыбратьВыделенныеСтрокиНаСервере(МассивСтрок, Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыбратьВыделенныеСтрокиНаСервере(МассивСтрок, ЗначениеВыбора = Истина)
	
	Для Каждого ИдентификаторСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаХарактеристик.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если СтрокаТаблицы.Выбрана = (Не ЗначениеВыбора) Тогда
			СтрокаТаблицы.Выбрана = ЗначениеВыбора;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	ОчиститьСообщения();
	Если ТаблицаХарактеристик.НайтиСтроки(Новый Структура("Выбрана", Истина)).Количество()= 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выберите хотя бы одну характеристику.';
				|en = 'Select at least one characteristic.'"),
			,
			"ТаблицаХарактеристик");
		Возврат
	КонецЕсли;
	Закрыть();
	ОповеститьОВыборе(СтруктураВозвращаемыхХарактеристик());
КонецПроцедуры

&НаСервере
Функция СтруктураВозвращаемыхХарактеристик()
	СписокИсключений = Новый СписокЗначений();
	СписокИсключений.ЗагрузитьЗначения(ТаблицаХарактеристик.Выгрузить(Новый Структура("Выбрана", Истина), "Характеристика").ВыгрузитьКолонку("Характеристика"));
	
	ВыбраныВсеХарактеристики = СписокИсключений.Количество() = ТаблицаХарактеристик.Количество();
	
	СтруктураВозвращаемыхХарактеристик = Новый Структура; 
	СтруктураВозвращаемыхХарактеристик.Вставить("ХарактеристикиИсключения", СписокИсключений);
	СтруктураВозвращаемыхХарактеристик.Вставить("КоличествоИсключений", ?(ВыбраныВсеХарактеристики,0,СписокИсключений.Количество()));
	СтруктураВозвращаемыхХарактеристик.Вставить("ТипЗаписи", ?(ВыбраныВсеХарактеристики, 1, 2));
	
	Возврат СтруктураВозвращаемыхХарактеристик
КонецФункции

#КонецОбласти
