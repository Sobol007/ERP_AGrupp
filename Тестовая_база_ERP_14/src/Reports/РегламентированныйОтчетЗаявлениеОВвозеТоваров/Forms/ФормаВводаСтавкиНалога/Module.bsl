
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Модифицированность = Ложь;
	
	СтруктураСтавокМодиф = Новый Структура;
	
	СтруктураСтавокМодиф.Вставить("Ст21", "");
	
	Если СтавкаНалогаНДС = 1 Тогда 
		СтруктураСтавокМодиф.Вставить("Ст18", Формат(СтавкаНДС, "ЧЦ=15; ЧДЦ=2; ЧН=; ЧГ=0"));
	Иначе
		СтруктураСтавокМодиф.Вставить("Ст18","Льгота");
	КонецЕсли;
	
	Если Твердые = 1 Тогда
		Если СтавкаНалогаАкциза = 1 Тогда
			СтруктураСтавокМодиф.Вставить("Ст16", Формат(СтавкаАкциз, "ЧЦ=15; ЧДЦ=2; ЧН=; ЧГ=0"));
			СтруктураСтавокМодиф.Вставить("Ст17", Формат(0, "ЧЦ=15; ЧДЦ=2; ЧН=; ЧГ=0"));
			СтруктураСтавокМодиф.Вставить("ПредставлениеПрочерк", Ложь);
		ИначеЕсли СтавкаНалогаАкциза = 2 Тогда
			СтруктураСтавокМодиф.Вставить("Ст16", "Льгота");
			СтруктураСтавокМодиф.Вставить("Ст17", Формат(0, "ЧЦ=15; ЧДЦ=2; ЧН=; ЧГ=0"));
			СтруктураСтавокМодиф.Вставить("ПредставлениеПрочерк", Ложь);
		Иначе 
			СтруктураСтавокМодиф.Вставить("Ст16", "-");
			СтруктураСтавокМодиф.Вставить("Ст17", "-");
			СтруктураСтавокМодиф.Вставить("ПредставлениеПрочерк", Истина);
			
			Если СтавкаНалогаАкциза = 4 Тогда
				СтруктураСтавокМодиф.Вставить("Ст21", " ");
			КонецЕсли;
			
		КонецЕсли;
	Иначе
		Если СтавкаНалогаАкциза = 1 Тогда
			СтруктураСтавокМодиф.Вставить("Ст17", Формат(СтавкаАкциз, "ЧЦ=15; ЧДЦ=2; ЧН=; ЧГ=0"));
			СтруктураСтавокМодиф.Вставить("Ст16", Формат(0, "ЧЦ=15; ЧДЦ=2; ЧН=; ЧГ=0"));
			СтруктураСтавокМодиф.Вставить("ПредставлениеПрочерк", Ложь);
		ИначеЕсли СтавкаНалогаАкциза = 2 Тогда
			СтруктураСтавокМодиф.Вставить("Ст17", "Льгота");
			СтруктураСтавокМодиф.Вставить("Ст16", Формат(0, "ЧЦ=15; ЧДЦ=2; ЧН=; ЧГ=0"));
			СтруктураСтавокМодиф.Вставить("ПредставлениеПрочерк", Ложь);
		Иначе 
			СтруктураСтавокМодиф.Вставить("Ст16", "-");
			СтруктураСтавокМодиф.Вставить("Ст17", "-");
			СтруктураСтавокМодиф.Вставить("ПредставлениеПрочерк", Истина);
			
			Если СтавкаНалогаАкциза = 4 Тогда
				СтруктураСтавокМодиф.Вставить("Ст21", " ");
			КонецЕсли;
			
		КонецЕсли;

	КонецЕсли;
	
	Закрыть(СтруктураСтавокМодиф);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтавкаНалогаНДС    = Параметры.Переключатель1;
	Твердые            = Параметры.Переключатель2;
	СтавкаНалогаАкциза = Параметры.Переключатель3;
	СтавкаНДС          = Параметры.СтавкаНДС;
	СтавкаАкциз        = Параметры.СтавкаАкциза;  
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	 
	 Если СтавкаНалогаНДС <> 1 Тогда
		 СтавкаНДС = 0;
		 Элементы.СтавкаНДС.Доступность = Ложь;
	 Иначе
		 Элементы.СтавкаНДС.Доступность = Истина;
	 КонецЕсли;
	 
	 Если СтавкаНалогаАкциза <> 1 Тогда
		 СтавкаАкциз = 0;
		 Элементы.СтавкаАкциз.Доступность = Ложь;
	 Иначе	 
		 Элементы.СтавкаАкциз.Доступность = Истина;
	 КонецЕсли;
	 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	 УстановитьВидимость();
	 
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНалогаНДСПриИзменении(Элемент)
	
	 УстановитьВидимость();
	 
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНалогаАкцизаПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти