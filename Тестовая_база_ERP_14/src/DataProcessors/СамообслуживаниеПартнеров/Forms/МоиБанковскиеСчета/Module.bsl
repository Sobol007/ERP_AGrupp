
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПартнерыИКонтрагентыВызовСервера.ДанныеАвторизовавшегосяВнешнегоПользователя());
	
	Если Партнер = Неопределено ИЛИ Партнер.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Контрагент = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Партнер);
	
	Список.Параметры.УстановитьЗначениеПараметра("Владелец",Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	СтруктураЗначенияЗаполнения = Новый Структура("Владелец",Контрагент);
	ОткрытьФорму("Справочник.БанковскиеСчетаКонтрагентов.Форма.ФормаЭлемента",
	             Новый Структура("ЗначенияЗаполнения", СтруктураЗначенияЗаполнения),
	             ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
