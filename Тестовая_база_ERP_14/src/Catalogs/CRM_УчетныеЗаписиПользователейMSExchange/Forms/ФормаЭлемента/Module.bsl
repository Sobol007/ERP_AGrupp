
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Пользователи.РолиДоступны("ПолныеПрава") Тогда
		Элементы.Пользователь.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	РезультатПроверки = CRM_ОбщегоНазначенияКлиентСервер.АнализАдресаЭП(СокрЛП(Объект.АдресEMail));
	Если РезультатПроверки.КодОшибки<>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.Сообщение,, "Объект.АдресEMail");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресEMailПриИзменении(Элемент)
	РезультатПроверки = CRM_ОбщегоНазначенияКлиентСервер.АнализАдресаЭП(СокрЛП(Объект.АдресEMail));
	Если РезультатПроверки.КодОшибки<>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.Сообщение,, "Объект.АдресEMail");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

