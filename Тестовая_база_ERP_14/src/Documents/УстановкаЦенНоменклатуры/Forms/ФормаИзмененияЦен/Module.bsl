
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЗагрузитьВидыЦен();
	
	ТолькоВыделенныеСтроки = Параметры.ТолькоВыделенные;
	ПрименятьОкругление    = Истина;
	
	Элементы.ТолькоВыделенныеСтроки.Заголовок = НСтр("ru = 'Пересчитать строки документа';
													|en = 'Recalculate document lines'");

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыЦен

&НаКлиенте
Процедура ВидыЦенПроцентИзмененияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыЦен.ТекущиеДанные;
	ТекущиеДанные.Пересчитать = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	МассивВидовЦен = Новый Массив();
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если ВидЦены.Пересчитать Тогда
			МассивВидовЦен.Добавить(Новый Структура("ВидЦены, Цена", ВидЦены.Ссылка, ВидЦены.Цена));
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура();
	Результат.Вставить("ВидыЦен",                        МассивВидовЦен);
	Результат.Вставить("ТолькоВыделенныеСтроки",         ТолькоВыделенныеСтроки = 1);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенВыбратьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если Не ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенИсключитьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Процедура загружает виды цен в таблицу ВидыЦен в порядке,
// соответвующим порядку в документе.
&НаСервере
Процедура ЗагрузитьВидыЦен()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
		|	ВидыЦен.Ссылка            КАК Ссылка,
		|	ВидыЦен.СпособЗаданияЦены КАК СпособЗаданияЦены,
		|	ВЫБОР
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.Вручную)
		|		ТОГДА
		|			0
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ)
		|		ТОГДА
		|			1
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.РассчитыватьПоФормуламОтДругихВидовЦен)
		|		ТОГДА
		|			2
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|ГДЕ
		|	ВидыЦен.Ссылка В(&МассивВидовЦен)";
		
	Запрос.УстановитьПараметр("МассивВидовЦен", Параметры.ВсеВидыЦен);
	ТаблицаВидовЦен = Запрос.Выполнить().Выгрузить();
	
	// Для того, чтобы виды цен в списке были в том же порядке, как и на форме документа,
	// загружаем их вручную.
	Для Каждого ВидЦен Из Параметры.ВсеВидыЦен Цикл
		
		НайденныйВидЦен = ТаблицаВидовЦен.Найти(ВидЦен, "Ссылка");
		
		СтрокаВидаЦен                   = ВидыЦен.Добавить();
		СтрокаВидаЦен.Ссылка            = ВидЦен;
		СтрокаВидаЦен.СпособЗаданияЦены = НайденныйВидЦен.СпособЗаданияЦены;
		СтрокаВидаЦен.Пересчитать       = Ложь;
		СтрокаВидаЦен.ИндексКартинки    = НайденныйВидЦен.ИндексКартинки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
