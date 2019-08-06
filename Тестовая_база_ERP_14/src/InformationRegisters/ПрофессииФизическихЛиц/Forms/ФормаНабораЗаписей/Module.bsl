
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Отбор.Свойство("ФизическоеЛицо", ФизическоеЛицоСсылка);
	
	СотрудникиФормыРасширенный.ПрочитатьНаборЗаписей(ЭтаФорма, "ПрофессииФизическихЛиц");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПредставлениеПрофессии = 
		РегистрыСведений.ПрофессииФизическихЛиц.ПредставлениеПрофессийПоКоллекцииЗаписей(ПрофессииФизическихЛиц);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("ИзмененыПрофессииФизическихЛиц", ПредставлениеПрофессии, ВладелецФормы);
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ФизическоеЛицо = ФизическоеЛицоСсылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти
