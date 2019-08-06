#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.СкрытыеКнопки = Истина Тогда
		Элементы.БольшеНеПоказывать.Видимость = Ложь;
		Элементы.ПоказатьПозже.Видимость = Ложь;
		КлючСохраненияПоложенияОкна = "СкрытыеКнопки";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаБольшеНеПоказывать(Команда)
	
	ЗапомнитьЧтоТребованияКИзображениямБольшеНеПоказывать();
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗапомнитьЧтоТребованияКИзображениямБольшеНеПоказывать()
	
	ХранилищеОбщихНастроек.Сохранить("ДокументооборотСКонтролирующимиОрганами_ТребованияКИзображениямБольшеНеПоказывать", , Истина);
	
КонецПроцедуры

#КонецОбласти