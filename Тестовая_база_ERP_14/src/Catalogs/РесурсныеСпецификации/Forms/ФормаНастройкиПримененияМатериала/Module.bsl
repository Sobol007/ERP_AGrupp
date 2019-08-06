
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
//++ НЕ УТКА
	ЗаполнитьРеквизитыФормыПоПараметрам();
	
	УстановитьЗаголовокФормы();
//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
//++ НЕ УТКА
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		
		Если Модифицированность Тогда
			Модифицированность = Ложь;
			ОповеститьОВыборе(ЗначениеВыбора());
		Иначе
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
//-- НЕ УТКА
	Возврат; // пустой обработчик

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ НЕ УТКА

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПоПараметрам()
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Номенклатура,Характеристика,ПрименениеМатериала");
	
	РежимИспользования = Число(Параметры.Альтернативный);
	Вероятность        = ?(Параметры.Вероятность > 1 И Параметры.Вероятность < 100, Параметры.Вероятность, 100);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
	
		ТекстНоменклатура = СтрШаблон(НСтр("ru = 'Номенклатура: %1';
											|en = 'Products: %1'"), Номенклатура);
		
		Если ЗначениеЗаполнено(Характеристика) Тогда
			
			ТекстНоменклатура = ТекстНоменклатура + ", " + СтрШаблон(НСтр("ru = 'Характеристика: %1';
																			|en = 'Characteristic: %1'"), Характеристика);
			
		КонецЕсли;
		
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = СтрШаблон(НСтр("ru = 'Применение материала (%1)';
											|en = 'Material application (%1)'"), ТекстНоменклатура);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗначениеВыбора()
	
	Результат = Новый Структура;
	
	Результат.Вставить("ПрименениеМатериала", ПрименениеМатериала);
	Результат.Вставить("Альтернативный",      Булево(РежимИспользования));
	Результат.Вставить("Вероятность",         ?(Вероятность > 1 И Вероятность < 100, Вероятность, 0));
	
	Возврат Результат;
	
КонецФункции

//-- НЕ УТКА

#КонецОбласти