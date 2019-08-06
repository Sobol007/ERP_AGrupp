
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РазбиватьЗаказыПоНазначениям = Параметры.РазбиватьЗаказыПоНазначениям;
	РазбиватьЗаказыПоСкладам = Параметры.РазбиватьЗаказыПоСкладам;
	
	Элементы.РазбиватьЗаказыПоНазначениям.Видимость = Параметры.ВидимостьНазначения;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПараметрыСозданияЗаказа = Новый Структура();
	ПараметрыСозданияЗаказа.Вставить("РазбиватьЗаказыПоНазначениям", РазбиватьЗаказыПоНазначениям);
	ПараметрыСозданияЗаказа.Вставить("РазбиватьЗаказыПоСкладам", РазбиватьЗаказыПоСкладам);
	
	ОповеститьОВыборе(ПараметрыСозданияЗаказа);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
