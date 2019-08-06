
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Наборы.Количество() <= 1 Тогда
		Элементы.УдалитьВсеСтрокиНаборов.Заголовок = НСтр("ru = 'Удалить все строки набора';
															|en = 'Remove all set lines'");
		Сообщение = НСтр("ru = 'Удаляемые строки входят в набор:';
						|en = 'Removed lines are included in the set:'");
	Иначе
		Элементы.УдалитьВсеСтрокиНаборов.Заголовок = НСтр("ru = 'Удалить все строки наборов';
															|en = 'Remove all set lines'");
		Сообщение = НСтр("ru = 'Удаляемые строки входят в наборы:';
						|en = 'Removed lines are included in the sets:'");
	КонецЕсли;
	
	Если Параметры.Прочее.Количество() > 0 Тогда
		Элементы.РедактироватьНабор.Видимость         = Ложь;
		Если Параметры.Наборы.Количество() <= 1 Тогда
			Сообщение = НСтр("ru = 'Некоторые из удаляемых строк входят в состав набора:';
							|en = 'Some of the removed lines are included in the set:'");
		Иначе
			Сообщение = НСтр("ru = 'Некоторые из удаляемых строк входят в состав наборов:';
							|en = 'Some of the removed lines are included in the sets:'");
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Копирование Тогда
		Элементы.РедактироватьНабор.Видимость = Истина;
		Элементы.УдалитьВсеСтрокиНаборов.Видимость = Ложь;
		Если Параметры.Наборы.Количество() <= 1 Тогда
			Сообщение = НСтр("ru = 'Выделенная строка входит в набор:';
							|en = 'The selected line is in the set:'");
		Иначе
			Сообщение = НСтр("ru = 'Выделенная строки входят в наборы:';
							|en = 'The selected lines are in the sets:'");
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Наборы.Количество() > 1 Тогда
		Элементы.РедактироватьНабор.Видимость = Ложь;
	КонецЕсли;
	
	НомерСтроки = 0;
	Для Каждого СтрокаТЧ Из Параметры.Наборы Цикл
		НомерСтроки = НомерСтроки + 1;
		СообщениеНаборы = СообщениеНаборы
		                + ?(НомерСтроки <> 1, Символы.ПС, "")
		                + НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
							СтрокаТЧ.НоменклатураНабора,СтрокаТЧ.ХарактеристикаНабора);
	КонецЦикла;
	Элементы.СообщениеНаборы.Высота = НомерСтроки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьНабор(Команда)
	Закрыть("РедактироватьНабор");
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть("Отмена");
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеСтроки(Команда)
	Закрыть("УдалитьВесьНабор");
КонецПроцедуры

#КонецОбласти
