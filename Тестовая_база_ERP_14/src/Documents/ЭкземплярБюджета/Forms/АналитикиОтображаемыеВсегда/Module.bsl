#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	АналитикиОтображаемыеВсегда = Параметры.АналитикиОтображаемыеВсегда;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	Если АналитикиОтображаемыеВсегда.Количество() > 6 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Максимально можно выбрать 6 аналитик';
									|en = 'You can select not more than 6 dimensions'"));
		Возврат;
	КонецЕсли;
	
	Всего = АналитикиОтображаемыеВсегда.Количество();
	Для Сч = 1 По Всего Цикл
		ЭлементСписка = АналитикиОтображаемыеВсегда[Всего - Сч];
		Если Не ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			АналитикиОтображаемыеВсегда.Удалить(ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(АналитикиОтображаемыеВсегда);
	
КонецПроцедуры

#КонецОбласти