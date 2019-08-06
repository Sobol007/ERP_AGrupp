#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого ДатаПринятияНаУчет Из Параметры.ДатыПринятияНаУчет Цикл
		ЗаполнитьЗначенияСвойств(ДатыПринятияНаУчет.Добавить(), ДатаПринятияНаУчет.Значение);
	КонецЦикла;
	
	Если ТолькоПросмотр Тогда
		Элементы.ДатыПринятияНаУчет.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		Элементы.ФормаКомандаОК.Видимость = Ложь;
	КонецЕсли;
	
	РеквизитыДатПринятияНаУчет = Документы.ПоясненияКДекларацииПоНДС.РеквизитыДатПринятияНаУчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда 
		
		Если НЕ ПеренестиВДокумент Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Отменить изменения?';
										|en = 'Отменить изменения?'");
	
			ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
				ЭтотОбъект, 
				Отказ, 
				ЗавершениеРаботы,
				ТекстПредупреждения, 
				"ПеренестиВДокумент");
			
		ИначеЕсли Не Отказ Тогда
				
			Отказ = НЕ ПроверитьЗаполнениеНаКлиенте();
			Если Отказ Тогда
				ПеренестиВДокумент = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Если ПроверитьЗаполнениеНаКлиенте() Тогда 
		РезультатЗакрытия = СписокДатПринятияНаУчет();
		ОповеститьОВыборе(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ПеренестиВДокумент = Ложь;
	Модифицированность = Ложь;
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СписокДатПринятияНаУчет()
	
	СписокДатПринятияНаУчет = Новый СписокЗначений();
	
	Для Каждого ДатаПринятияНаУчет Из ДатыПринятияНаУчет Цикл
		ЗначенияРеквизитов = Новый Структура(РеквизитыДатПринятияНаУчет);
		ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, ДатаПринятияНаУчет);
		СписокДатПринятияНаУчет.Добавить(ЗначенияРеквизитов, Формат(ДатаПринятияНаУчет.ДатаПринятияНаУчет, "ДЛФ=D"));
	КонецЦикла;
	
	Возврат СписокДатПринятияНаУчет;
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	Отказ = Ложь;
	
	Для Каждого ДатаПринятияНаУчет Из ДатыПринятияНаУчет Цикл
		Если НЕ ЗначениеЗаполнено(ДатаПринятияНаУчет.ДатаПринятияНаУчет) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата принятия на учет';
																											|en = 'Дата принятия на учет'"));
			Поле = "ДатыПринятияНаУчет["+ Формат(ДатыПринятияНаУчет.Индекс(ДатаПринятияНаУчет), "ЧДЦ=; ЧГ=0") +"].ДатаПринятияНаУчет";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции

#КонецОбласти