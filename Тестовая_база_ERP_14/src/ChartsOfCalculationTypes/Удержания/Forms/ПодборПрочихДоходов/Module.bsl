
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИсходныеДанные(Параметры.ПрочиеДоходы);
	
	УстановитьПараметрыСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыВыплатБывшимСотрудникам

&НаКлиенте
Процедура ВидыВыплатБывшимСотрудникамВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ВидыВыплатБывшимСотрудникамВыборНаСервере(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыПрочихДоходов

&НаКлиенте
Процедура ВидыПрочихДоходовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ВидыПрочихДоходовВыборНаСервере(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПрочиеДоходы = Новый Структура;
	ПрочиеДоходы.Вставить("ВидыВыплат", ВыбранныеВидыВыплат.ВыгрузитьЗначения());
	ПрочиеДоходы.Вставить("ВидыПрочихДоходов", ВыбранныеВидыПрочихДоходов.ВыгрузитьЗначения());
	
	ОповеститьОВыборе(ПрочиеДоходы);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьИсходныеДанные(ПрочиеДоходы)
	
	Для Каждого ВидДохода Из ПрочиеДоходы Цикл 
		Если ТипЗнч(ВидДохода) = Тип("СправочникСсылка.ВидыВыплатБывшимСотрудникам") Тогда 
			ВыбранныеВидыВыплат.Добавить(ВидДохода);
		Иначе 
			ВыбранныеВидыПрочихДоходов.Добавить(ВидДохода);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСписков()

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ВидыВыплатБывшимСотрудникам, "ВидыВыплат", ВыбранныеВидыВыплат.ВыгрузитьЗначения());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ВидыПрочихДоходов, "ВидыПрочихДоходов", ВыбранныеВидыПрочихДоходов.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаСервере
Процедура ВидыВыплатБывшимСотрудникамВыборНаСервере(ВидВыплаты)
	
	ЭлементСписка = ВыбранныеВидыВыплат.НайтиПоЗначению(ВидВыплаты);
	Если ЭлементСписка <> Неопределено Тогда
		ВыбранныеВидыВыплат.Удалить(ЭлементСписка);
	Иначе 
		ВыбранныеВидыВыплат.Добавить(ВидВыплаты);
	КонецЕсли;
	
	УстановитьПараметрыСписков();
	
КонецПроцедуры

&НаСервере
Процедура ВидыПрочихДоходовВыборНаСервере(ВидДохода)
	
	ЭлементСписка = ВыбранныеВидыПрочихДоходов.НайтиПоЗначению(ВидДохода);
	Если ЭлементСписка <> Неопределено Тогда
		ВыбранныеВидыПрочихДоходов.Удалить(ЭлементСписка);
	Иначе 
		ВыбранныеВидыПрочихДоходов.Добавить(ВидДохода);
	КонецЕсли;
	
	УстановитьПараметрыСписков();
	
КонецПроцедуры

#КонецОбласти

