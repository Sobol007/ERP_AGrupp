
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ВидСобытия") И ЗначениеЗаполнено(Параметры.ВидСобытия) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ВидСобытия", Параметры.ВидСобытия, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("СостояниеИнтереса") Тогда
		СписокСостояний = новый СписокЗначений;
		СписокСостояний.Добавить(Параметры.Отбор.СостояниеИнтереса);
		СписокСостояний.Добавить(Справочники.CRM_СостоянияИнтересов.ПустаяСсылка());
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СостояниеИнтереса", СписокСостояний, ВидСравненияКомпоновкиДанных.ВСписке);
		Параметры.Отбор.Удалить("СостояниеИнтереса");
	КонецЕсли;
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Направление") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Направление", Параметры.Отбор.Направление, ВидСравненияКомпоновкиДанных.Равно);
		Параметры.Отбор.Удалить("Направление");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
