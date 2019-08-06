#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Для каждого Состояние Из Перечисления.СостоянияВыполненияОпераций Цикл
		СостоянияВыполнения.Добавить(Состояние);
	КонецЦикла;
	
	Если Параметры.Свойство("ВыбранныеЗначения") И ЗначениеЗаполнено(Параметры.ВыбранныеЗначения) Тогда
		Для каждого Элемент Из СостоянияВыполнения Цикл
			Если НЕ Параметры.ВыбранныеЗначения.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
				Элемент.Пометка = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый СписокЗначений;
	Для каждого Элемент Из СостоянияВыполнения Цикл
		Если Элемент.Пометка Тогда
			Результат.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти