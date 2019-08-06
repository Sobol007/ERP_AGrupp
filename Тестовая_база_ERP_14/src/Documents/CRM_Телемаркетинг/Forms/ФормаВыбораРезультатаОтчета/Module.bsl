
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьЗаписи	= Параметры.ЕстьЗаписи;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Элемент.СписокВыбора.Очистить();
	Список = ПолучитьСписокДоступныхРезультатов();
	Для Каждого ЭлементСписка Из Список Цикл
		Элемент.СписокВыбора.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ЗаполнитьСписокСсылок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("СписокСсылок" ,СписокСсылок);
	СтруктураВозврата.Вставить("ВидКонтактнойИнформации",ВидКонтактнойИнформации);
	СтруктураВозврата.Вставить("НеЗаполнятьСПустымиТелефонами",НеЗаполнятьСПустымиТелефонами);
	СтруктураВозврата.Вставить("ОчищатьТЧ",Ложь);
	
	Если ЕстьЗаписи Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОКЗавершение", ЭтотОбъект, СтруктураВозврата);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Табличная часть уже содержит записи. 
								|Очистить табличную часть?'"), РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	Иначе
		ОКЗавершение(Неопределено, СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОКЗавершение(Ответ, СтруктураВозврата) Экспорт
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		СтруктураВозврата.ОчищатьТЧ = Истина;
	КонецЕсли;
	Закрыть(СтруктураВозврата);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСписокДоступныхРезультатов()
	
	Список = Новый СписокЗначений;
	СписокСуществующихРезультатов = CRM_ОбщегоНазначенияСервер.ПолучитьСписокВыбораНаименованийСохраненныхРезультатовОтчетов();
	
	Если СписокСуществующихРезультатов.Количество() > 0 Тогда
		Для Каждого ЭлементСписка Из СписокСуществующихРезультатов Цикл
			СохраненныйСписок = CRM_ОбщегоНазначенияСервер.ПолучитьСохраненныйРезультатОтчетаПоНаименованию(ЭлементСписка.Значение);
			Если (СохраненныйСписок.Количество() > 0)
			И (ТипЗнч(СохраненныйСписок[0].Значение) = Тип("СправочникСсылка.Партнеры")
			ИЛИ (ТипЗнч(СохраненныйСписок[0].Значение) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров")))Тогда
				Список.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Список;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокСсылок()
	
	СписокСсылок.Очистить();
	Если ЗначениеЗаполнено(Наименование) Тогда
		
		СписокСсылок = CRM_ОбщегоНазначенияСервер.ПолучитьСохраненныйРезультатОтчетаПоНаименованию(Наименование);
		
		Для Каждого ЭлементСписка Из СписокСсылок Цикл
			ЭлементСписка.Пометка = Истина;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

