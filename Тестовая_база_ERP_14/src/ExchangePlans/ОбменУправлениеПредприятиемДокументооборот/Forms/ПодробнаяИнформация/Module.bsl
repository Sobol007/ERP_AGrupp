#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Заголовок = НСтр("ru = 'Информация о синхронизации данных с 1С:Документооборот';
					|en = 'Information about data synchronization with 1C:Document Management'");
	
	Макет = ПланыОбмена.ОбменУправлениеПредприятиемДокументооборот.ПолучитьМакет("ПодробнаяИнформация");
	ПолеHTMLДокумента = Макет.ПолучитьТекст();

КонецПроцедуры

#КонецОбласти