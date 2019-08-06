
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОтборНабораЗаписей = Параметры.Отбор;
	
	Если Не ЗначениеЗаполнено(ОтборНабораЗаписей.Организация) Или Не ЗначениеЗаполнено(ОтборНабораЗаписей.ТорговаяТочка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПараметрыТорговыхТочек) Тогда
		ТолькоПросмотр = Истина;
		Элементы.КнопкаИзменить.Доступность = Ложь;
	КонецЕсли;
	
	Для Каждого ЗаписьИстории Из НаборЗаписей Цикл
		Если ЗаписьИстории.ВидОперации = Перечисления.ВидыОперацийТорговыеТочки.Регистрация Тогда
			ПредставлениеОперации = НСтр("ru = 'Поставлена на учет';
										|en = 'Registered'");
		ИначеЕсли ЗаписьИстории.ВидОперации = Перечисления.ВидыОперацийТорговыеТочки.ИзменениеПараметров Тогда
			ПредставлениеОперации = НСтр("ru = 'Изменены параметры';
										|en = 'Parameters are changed'");
		Иначе
			ПредставлениеОперации = НСтр("ru = 'Снята с учета';
										|en = 'Deregistered'");
		КонецЕсли;
		
		ЗаписьИстории.ПредставлениеОперации = ПредставлениеОперации;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПараметрыТорговойТочки = Элементы.НаборЗаписей.ТекущиеДанные;
	
	Если ПараметрыТорговойТочки.Период < '20150701' Тогда
		ПараметрыТорговойТочки.Период = '20150701';
		ТекстСообщения = НСтр("ru = 'Дата начала использования торговой точки не может быть ранее 01 июля 2015 г.';
								|en = 'Start date of sales outlet use cannot be earlier than July 1, 2015 '");
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = ТекстСообщения;
		СообщениеПользователю.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередУдалением(Элемент, Отказ)
	
	Если НаборЗаписей.Количество() = 1 Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийТорговыеТочки.Регистрация") Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаИзменить(Команда)
	
	Элементы.НаборЗаписей.ТекущийЭлемент = Элементы.НаборЗаписей.ПодчиненныеЭлементы.Период;
	Элементы.НаборЗаписей.ИзменитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ДанныеИзменены = Модифицированность;
	Записать();
	Закрыть(ДанныеИзменены);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Модифицированность);
	
КонецПроцедуры

#КонецОбласти


