
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормЕГАИСПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект, "Номенклатура");
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "Характеристика", "Объект.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "Серия", "Объект.Номенклатура");
	
	Если Не ЗначениеЗаполнено(Объект.ИсходныйКлючЗаписи) Тогда
		ПриСозданииЧтенииНаСервере();
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение, ИсточникВыбора);
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(
		Новый ОписаниеОповещения("Подключаемый_ОбработкаВыбораНоменклатуры", ЭтотОбъект), ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ХарактеристикаСоздание(ЭтотОбъект, Неопределено, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьПодборСерий(Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АлкогольнаяПродукцияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СобытияФормЕГАИСКлиент.ОткрытьФормуВыбораАлкогольнойПродукции(
		Элемент,
		ИнтеграцияЕГАИСКлиент.РеквизитыНоменклатурыДляВыбораАлкогольнойПродукции(Объект.Номенклатура),
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры(
		ЭтотОбъект,
		ИнтеграцияЕГАИСВызовСервера.РеквизитыАлкогольнойПродукцииДляСозданияНоменклатуры(Объект.АлкогольнаяПродукция));
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСозданияНоменклатуры(
		ЭтотОбъект,
		ИнтеграцияЕГАИСВызовСервера.РеквизитыАлкогольнойПродукцииДляСозданияНоменклатуры(Объект.АлкогольнаяПродукция));
	
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(
		ЭтаФорма, ПараметрыУказанияСерий, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект, "Характеристика", "ХарактеристикиИспользуются");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПризнакИспользованияСерий(Номенклатура)
	
	Возврат ИнтеграцияИС.ПризнакИспользованияСерий(Номенклатура);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ХарактеристикиИспользуются Тогда
		Элементы.Характеристика.Доступность = Истина;
		Элементы.Характеристика.ПодсказкаВвода = "";
	Иначе
		Элементы.Характеристика.Доступность = Ложь;
		Элементы.Характеристика.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>';
														|en = '<характеристики не используются>'");
	КонецЕсли;
	
	Если Форма.СерииИспользуются Тогда
		Элементы.Серия.Доступность = Истина;
		Элементы.Серия.ПодсказкаВвода = "";
	Иначе
		Элементы.Серия.Доступность = Ложь;
		Элементы.Серия.ПодсказкаВвода = НСтр("ru = '<серии не используются>';
											|en = '<серии не используются>'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	ХарактеристикиИспользуются = ИнтеграцияИС.ПризнакИспользованияХарактеристик(Объект.Номенклатура);
	СерииИспользуются = ПризнакИспользованияСерий(Объект.Номенклатура);
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(Объект, РегистрыСведений.СоответствиеНоменклатурыЕГАИС);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере()
	
	ЗаполнениеСвойствПриИзмененииНоменклатуры();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеСвойствПриИзмененииНоменклатуры()
	
	Если НЕ ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		ХарактеристикиИспользуются = Ложь;
		СерииИспользуются = Ложь;
	Иначе
		ХарактеристикиИспользуются = ИнтеграцияИС.ПризнакИспользованияХарактеристик(Объект.Номенклатура);
		СерииИспользуются = ПризнакИспользованияСерий(Объект.Номенклатура);
	КонецЕсли;
	
	Шапка = Новый Структура("Номенклатура, Характеристика, Серия, СтатусУказанияСерий, Упаковка,
		|Количество, КоличествоУпаковок, ХарактеристикиИспользуются, ТипНоменклатуры, МаркируемаяПродукция");
	ЗаполнитьЗначенияСвойств(Шапка, Объект);
	
	ПараметрыЗаполнения = ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ОбработатьУпаковки             = Ложь;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = Истина;
	ПараметрыЗаполнения.ЗаполнитьЕдиницуИзмерения      = Ложь;
	
	СобытияФормЕГАИСПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, Шапка, Неопределено, ПараметрыЗаполнения, ПараметрыУказанияСерий);
	
	ЗаполнитьЗначенияСвойств(Объект, Шапка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаВыбораНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Номенклатура = Результат;
	
	НоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти
