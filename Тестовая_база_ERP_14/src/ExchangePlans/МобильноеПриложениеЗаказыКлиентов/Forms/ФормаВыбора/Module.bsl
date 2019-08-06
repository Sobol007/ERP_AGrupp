#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Ссылка") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Ссылка", Параметры.Ссылка);
	КонецЕсли;
	
	Заголовок = Нстр("ru = 'Выберите устройство с индивидуальными настройками для синхронизации';
					|en = 'Select a device with custom settings for synchronization'");
КонецПроцедуры

#КонецОбласти
