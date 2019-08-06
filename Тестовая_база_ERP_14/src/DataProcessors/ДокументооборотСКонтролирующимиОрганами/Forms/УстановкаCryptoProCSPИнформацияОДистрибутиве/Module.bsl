#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КонтрольнаяСумма", КонтрольнаяСумма);
	Параметры.Свойство("Дистрибутив", Дистрибутив);
	Параметры.Свойство("Версия", Версия);
	
	Элементы.Дистрибутив.Подсказка = СтрШаблон(НСтр("ru = 'Версия: %1';
													|en = 'Version: %1'"), Версия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Установить(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти