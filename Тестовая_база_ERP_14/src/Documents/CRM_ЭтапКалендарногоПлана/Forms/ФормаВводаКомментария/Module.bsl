
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТипОбъекта") Тогда
		Если Параметры.ТипОбъекта = Перечисления.CRM_ТипыЭтапов.КонтрольнаяТочка Тогда
			ЭтаФорма.Заголовок = "Введите причину отмены контрольной точки"; 
		ИначеЕсли Параметры.ТипОбъекта = Перечисления.CRM_ТипыЭтапов.Этап Тогда	  
			ЭтаФорма.Заголовок = "Введите причину отмены задачи";
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если ЗначениеЗаполнено(ПричинаОтмены) Тогда
		Закрыть(ПричинаОтмены);
	Иначе
		Сообщить(НСтр("ru = 'Необходимо указать причину отказа!'"));
	КонецЕсли;
	
КонецПроцедуры

