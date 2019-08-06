
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// +Google
	Если ЭтоСервисGoogle Тогда
		Константы.CRM_ИдентификацияПриложенияGoogle.Установить(СокрЛП(ИдентификацияПриложенияGoogle));
	КонецЕсли;
	// -Google
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// +Google
	Если ЭтоСервисGoogle И Не ПустаяСтрока(ИдентификацияПриложенияGoogle) Тогда
		ТекстОшибки = CRM_ОбменСGoogle.ИдентификацияПриложенияGoogleКорректна(ИдентификацияПриложенияGoogle);
		Если Не ПустаяСтрока(ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка,
				"ИдентификацияПриложенияGoogle",, Отказ);
		КонецЕсли;
	КонецЕсли;
	// -Google
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область Google

&НаКлиенте
Процедура GoogleДекорацияУзнатьБольшеНажатие(Элемент)
	ПерейтиПоНавигационнойСсылке("https://daclouds.ru/#order_subscribe");
КонецПроцедуры

&НаКлиенте
Процедура GoogleДекорацияПолучитьПлатныйАккаунтНажатие(Элемент)
	ПерейтиПоНавигационнойСсылке("https://daclouds.ru/?ConnectApps=yes#Order_apps");
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область Google

&НаКлиенте
Процедура GoogleОткрытьСправку(Команда)
	ПерейтиПоНавигационнойСсылке(CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуНаРазделСправки("ИнтеграцияGoogleCalendar"));
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	// +Google
	ЭтоСервисGoogle = (Объект.Ссылка = Справочники.CRM_СервисыКалендарей.Google);
	Элементы.ПараметрыGoogle.Видимость = ЭтоСервисGoogle;
	Если ЭтоСервисGoogle Тогда
		ИдентификацияПриложенияGoogle = Константы.CRM_ИдентификацияПриложенияGoogle.Получить();
	КонецЕсли;
	// -Google
КонецПроцедуры

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

