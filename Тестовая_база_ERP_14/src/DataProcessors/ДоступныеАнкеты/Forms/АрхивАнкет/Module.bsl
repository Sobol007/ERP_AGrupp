///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Респондент") Тогда
		Объект.Респондент = Параметры.Респондент;
	Иначе
		УстановитьРеспондентаСогласноТекущемуВнешнемуПользователю();
	КонецЕсли;
	УстановитьПараметрыДинамическогоСпискаДереваАнкет();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтвеченныеАнкетыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ОтвеченныеАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",ТекущиеДанные.Анкета);
	СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
	СтруктураПараметров.Вставить("ТолькоПросмотр",Истина);
	
	ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСпискаДереваАнкет()
	
	Для каждого ДоступныйПараметр Из ОтвеченныеАнкеты.Параметры.ДоступныеПараметры.Элементы Цикл
		
		Если ДоступныйПараметр.Заголовок = "Респондент" Тогда
			ОтвеченныеАнкеты.Параметры.УстановитьЗначениеПараметра(ДоступныйПараметр.Параметр,Объект.Респондент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьРеспондентаСогласноТекущемуВнешнемуПользователю()
	
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	Если ТипЗнч(ТекущийПользователь) <> Тип("СправочникСсылка.ВнешниеПользователи") Тогда 
		Объект.Респондент = ТекущийПользователь;
	Иначе	
		Объект.Респондент = ВнешниеПользователи.ПолучитьОбъектАвторизацииВнешнегоПользователя(ТекущийПользователь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ОтвеченныеАнкеты.ДатаЗаполнения", Элементы.ДатаЗаполнения.Имя);
	
КонецПроцедуры

#КонецОбласти
