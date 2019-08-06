
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ТабЗнач = Параметры.ЗначенияЗаполнения.Объект.ПоляФайла.Выгрузить();
		Для Каждого СтрокаТЧ Из ТабЗнач Цикл
			Если СтрокаТЧ.НаименованиеРеквизита = СтрокаОтбора Тогда
				НоваяСтрока = Объект.ПоляФайла.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	Если Параметры.Свойство("НаименованиеРеквизита") Тогда
		СтрокаОтбора = Параметры.НаименованиеРеквизита;
	КонецЕсли;	
	Если Параметры.Свойство("СписокПолейФайла") Тогда
		СписокПолейФайла = Параметры.СписокПолейФайла;
		СписокПолейФайла.Удалить(0);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоляФайла

&НаКлиенте
Процедура ПоляФайлаНаименованиеПоляНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокПолейФайла.Скопировать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоляФайлаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.НаименованиеРеквизита = СтрокаОтбора;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(Объект.ПоляФайла);
	
КонецПроцедуры

#КонецОбласти

