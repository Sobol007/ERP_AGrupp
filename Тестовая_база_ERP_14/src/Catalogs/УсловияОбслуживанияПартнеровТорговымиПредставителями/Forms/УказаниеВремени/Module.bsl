
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СписокВремени = ОбщегоНазначенияУТКлиентСервер.СписокВремени();
	
	Для Каждого ЭлементСписка Из СписокВремени Цикл
		Элементы.ВремяНачала.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		Элементы.ВремяОкончания.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если (ВремяОкончания < ВремяНачала) И ЗначениеЗаполнено(ВремяОкончания) Тогда
		ТекстСообщения = НСтр("ru = 'Время указано неверно';
								|en = 'Time is incorrect'");
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура("КодВозвратаДиалога,ВремяНачала,ВремяОкончания",КодВозвратаДиалога.ОК,ВремяНачала,ВремяОкончания);
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
