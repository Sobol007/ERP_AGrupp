
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Параметры.Документ;
	ОписаниеОшибки = ИнтеграцияВЕТИСВызовСервера.ТекстОшибкиИзПротокола(Параметры.Документ);
	
КонецПроцедуры

#КонецОбласти
