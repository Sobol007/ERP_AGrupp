////////////////////////////////////////////////////////////////////////////////
// Процедуры, используемые для локализации документа "Переоценка НМА".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ФормаДокумента

Процедура ПриИзмененииРеквизита(Элемент, Форма) Экспорт

	ДополнительныеПараметры = Неопределено;
	ТребуетсяВызовСервера = Ложь;
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	ПродолжитьИзменениеРеквизита = Истина;
	
	//++ Локализация
	
	Если Элемент.Имя = Элементы.ДокументНаОсновании.Имя Тогда
		
		ДокументНаОснованииПриИзменении(Объект, Форма);
		
	КонецЕсли; 
	
	//-- Локализация
	
	Если ПродолжитьИзменениеРеквизита Тогда
		
		ОбщегоНазначенияУТКлиент.ПродолжитьИзменениеРеквизита(
			Форма, 
			Элемент.Имя, 
			ДополнительныеПараметры,
			ТребуетсяВызовСервера);
			
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

//++ Локализация

#Область СлужебныеПроцедурыИФункции

#Область ФормаДокумента

Процедура ДокументНаОснованииПриИзменении(Объект, Форма)
	
	Если Объект.ДокументНаОсновании Тогда
		
		ОтборСписка = Новый Структура;
		ОтборСписка.Вставить("Проведен", Истина);
		
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			ОтборСписка.Вставить("Организация", Объект.Организация);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
			ОтборСписка.Вставить("Подразделение", Объект.Подразделение);
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", ОтборСписка);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("ИмяРеквизита", Форма.Элементы.ДокументНаОсновании.Имя);
		ОписаниеОповещения = Новый ОписаниеОповещения("ДокументНаОснованииПриИзмененииЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("Документ.ИнвентаризацияНМА.ФормаВыбора", ПараметрыФормы,,,,, ОписаниеОповещения);
		
	Иначе
		Объект.ДокументОснование = Неопределено;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДокументНаОснованииПриИзмененииЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Объект = ДополнительныеПараметры.Форма.Объект;
	
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Объект.ДокументОснование = РезультатЗакрытия;
	Иначе
		Объект.ДокументНаОсновании = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ТекстВопроса = НСтр("ru = 'Заполнить документ по инвентаризации?';
							|en = 'Fill in the stocktaking document?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоДаннымОснованияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет); 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьПоДаннымОснованияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОбщегоНазначенияУТКлиент.ПродолжитьИзменениеРеквизита(
			ДополнительныеПараметры.Форма, ДополнительныеПараметры.ИмяРеквизита,, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

//-- Локализация