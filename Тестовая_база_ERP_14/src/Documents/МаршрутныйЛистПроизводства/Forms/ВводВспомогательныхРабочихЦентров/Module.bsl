
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Подразделение") Тогда
		Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
	Если Параметры.Свойство("ВспомогательныеРабочиеЦентры") Тогда
		Для каждого Элемент Из Параметры.ВспомогательныеРабочиеЦентры Цикл
			НоваяСтрока = ВспомогательныеРабочиеЦентры.Добавить();
			НоваяСтрока.РабочийЦентр = Элемент.Значение;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый СписокЗначений;
	
	Для каждого Строка Из ВспомогательныеРабочиеЦентры Цикл
		
		Если ЗначениеЗаполнено(Строка.РабочийЦентр) Тогда
			
			Результат.Добавить(Строка.РабочийЦентр);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
