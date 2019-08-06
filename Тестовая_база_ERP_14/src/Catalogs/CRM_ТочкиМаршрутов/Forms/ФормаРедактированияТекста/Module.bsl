
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если Параметры.Свойство("ТекстОбработки") Тогда
		ТекстовыйДокумент.УстановитьТекст(Параметры.ТекстОбработки);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(ТекстовыйДокумент.ПолучитьТекст());
	
КонецПроцедуры

#КонецОбласти

