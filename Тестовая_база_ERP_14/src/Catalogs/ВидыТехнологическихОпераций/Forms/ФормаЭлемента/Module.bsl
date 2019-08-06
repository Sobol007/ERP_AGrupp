
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ПравоДобавления = ПравоДоступа("Добавление", Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения);
	Элементы.НастроитьРеквизиты.Видимость = ПравоДобавления;
	Элементы.НастроитьСведения.Видимость = ПравоДобавления;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборыДополнительныхРеквизитовИСведений"
		ИЛИ ИмяСобытия = "Запись_ДополнительныеРеквизитыИСведения" Тогда
		
		ПрочитатьСвойства();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДопРеквизиты

&НаКлиенте
Процедура ДопРеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(, Элементы.ДопРеквизиты.ТекущиеДанные.Свойство);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДопРеквизиты

&НаКлиенте
Процедура ДопСведенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(, Элементы.ДопСведения.ТекущиеДанные.Свойство);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРеквизиты(Команда)
	
	Режим = "ПоказатьДополнительныеРеквизиты";
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗаписатьИОткрытьФормуПросмотраСвойствЗавершение",
			ЭтаФорма,
			Новый Структура("Режим", Режим));
			
		ТекстВопроса = НСтр("ru = 'Изменение реквизитов возможно только после записи объекта.
			|Записать и продолжить?';
			|en = 'You can change attributes only after recording the item.
			|Record and continue?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОткрытьФормуПросмотраСвойств(Режим);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСведения(Команда)
	
	Режим = "ПоказатьДополнительныеСведения";
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗаписатьИОткрытьФормуПросмотраСвойствЗавершение",
			ЭтаФорма,
			Новый Структура("Режим", Режим));
			
		ТекстВопроса = НСтр("ru = 'Изменение сведений возможно только после записи объекта.
			|Записать и продолжить?';
			|en = 'You can change the information only after recording the item.
			|Record and continue?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОткрытьФормуПросмотраСвойств(Режим);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИОткрытьФормуПросмотраСвойствЗавершение(РезультатВопроса, Параметры) Экспорт

	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Записать() Тогда
		
		ОткрытьФормуПросмотраСвойств(Параметры.Режим);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПрочитатьСвойства();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьСвойства()
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Справочники.ВидыТехнологическихОпераций.СоздатьВТСвойстваНабора(
		Объект.Ссылка,
		МенеджерВременныхТаблиц,
		Истина,
		Истина);
		
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВТСвойстваНабора.Свойство  КАК Свойство,
		|	ВТСвойстваНабора.Заголовок КАК Заголовок,
		|	3                          КАК НомерКартинки
		|ИЗ
		|	ВТСвойстваНабора КАК ВТСвойстваНабора
		|ГДЕ
		|	НЕ ВТСвойстваНабора.ЭтоДополнительноеСведение
		|	И НЕ ВТСвойстваНабора.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТСвойстваНабора.НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТСвойстваНабора.Свойство  КАК Свойство,
		|	ВТСвойстваНабора.Заголовок КАК Заголовок,
		|	3                          КАК НомерКартинки
		|ИЗ
		|	ВТСвойстваНабора КАК ВТСвойстваНабора
		|ГДЕ
		|	ВТСвойстваНабора.ЭтоДополнительноеСведение
		|	И НЕ ВТСвойстваНабора.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТСвойстваНабора.НомерСтроки");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ДопРеквизиты.Загрузить(МассивРезультатов[0].Выгрузить());
	ДопРеквизитыКоличество = ДопРеквизиты.Количество();
	
	ДопСведения.Загрузить(МассивРезультатов[1].Выгрузить());
	ДопСведенияКоличество = ДопСведения.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПросмотраСвойств(Режим)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.НаборСвойств);
	ПараметрыФормы.Вставить(Режим);
	
	ОткрытьФорму(
		"Справочник.НаборыДополнительныхРеквизитовИСведений.ФормаСписка",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

