
#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияСканыНажатие(Элемент)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПерейтиПоСсылке("https://its.1c.ru/bmk/elreps/load_scans");
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияXMLНажатие(Элемент)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПерейтиПоСсылке("https://its.1c.ru/bmk/elreps/load_docs");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьXML(Команда)
	Закрыть("xml");
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСкан(Команда)
	Закрыть("сканы");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

