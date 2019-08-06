#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Макет = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ПолучитьМакет("ПодробнаяИнформацияЗУП3");
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = НСтр("ru = 'Информация о синхронизации данных';
					|en = 'Data synchronization information'");

КонецПроцедуры

#КонецОбласти