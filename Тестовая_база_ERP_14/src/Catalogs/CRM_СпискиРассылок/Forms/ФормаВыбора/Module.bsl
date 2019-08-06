
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПрограммноеОткрытие") И Параметры.ПрограммноеОткрытие Тогда
		Элементы.ВыбратьПрограммно.Видимость	= Истина;		
	Иначе
		Элементы.ВыбратьПрограммно.Видимость	= Ложь;
		Элементы.ФормаВыбрать.Видимость			= Истина;
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	РезультатВыбора = ПодготовитьРезультатВыбора();
	ОповеститьОВыборе(РезультатВыбора);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьРезультатВыбора()
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки = Неопределено ИЛИ ВыделенныеСтроки.Количество() <= 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивВыбора = Новый массив;
	
	Для Каждого ЭлементМассива Из ВыделенныеСтроки Цикл
		МассивВыбора.Добавить(ЭлементМассива);
	КонецЦикла;		
	
	Возврат МассивВыбора;
	
КонецФункции	

#КонецОбласти
