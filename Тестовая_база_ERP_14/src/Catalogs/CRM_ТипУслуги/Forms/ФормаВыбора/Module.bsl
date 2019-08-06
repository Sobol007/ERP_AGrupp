
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("МассивСвоихТиповУслуг") Тогда
		// Устанавливаем отбор по переданному массиву.
		СписокСвоихТиповУслуг	= Новый СписокЗначений;
		СписокСвоихТиповУслуг.ЗагрузитьЗначения(Параметры.МассивСвоихТиповУслуг);
		ЭлементОтбораДанных						= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбораДанных.ВидСравнения		= ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбораДанных.ПравоеЗначение		= СписокСвоихТиповУслуг;
		ЭлементОтбораДанных.РежимОтображения	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбораДанных.Использование		= Истина;
	КонецЕсли;	
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		Элементы.Список.ТекущаяСтрока = Параметры.ТекущаяСтрока;
	КонецЕсли;	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти
