
#Область ОписаниеПеременных

&НаКлиенте
Перем ПеретаскиваемыйРеквизит;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Заголовок = Объект.Наименование + НСтр("ru = ' (Сценарий)'");
	Иначе
		Заголовок = НСтр("ru = 'Сценарий (создание)'");
	КонецЕсли;
	
	ИдентификаторМетаданныхИнтерес = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.CRM_Интерес);
	СписокТиповУслуг.ЗагрузитьЗначения(Объект.ТипыУслуг.Выгрузить(, "ТипУслуги").ВыгрузитьКолонку("ТипУслуги"));
	Элементы.ДекорацияНастройкаСценария.Видимость = ЗначениеЗаполнено(Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ТипыУслуг.Очистить();
	Для каждого ЭлементСписка из СписокТиповУслуг Цикл
		НовТип = ТекущийОбъект.ТипыУслуг.Добавить();
		НовТип.ТипУслуги = ЭлементСписка.Значение;
	КонецЦикла;
	Элементы.ДекорацияНастройкаСценария.Видимость = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗначениеЗаполнено(Объект.Ссылка) И ОписаниеОповещенияОЗакрытии<>Неопределено И ТипЗнч(ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры) = Тип("Структура") Тогда
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Вставить("Сценарий", Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкаСценарияНажатие(Элемент)
	ПараметрыОткрытия = Новый Структура("Сценарий", Объект.Ссылка);
	ОткрытьФорму("Обработка.CRM_НастройкаСценарияПродаж.Форма.Форма", ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура ИндексЦветаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОповещениеНовое = Новый ОписаниеОповещения("ЦветНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ТекущийЦвет", Объект.ИндексЦвета);
	ФормаВыбораЦвета = ОткрытьФорму("Справочник.CRM_Категории.Форма.ФормаВыбораЦвета", ПараметрыФормы, Элемент,,,,
		ОповещениеНовое, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
КонецПроцедуры // ЦветНачалоВыбора()

&НаКлиенте
// Продолжение процедуры "ЦветНачалоВыбора"
//
Процедура ЦветНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если НЕ (Результат = Неопределено) И НЕ (Результат = КодВозвратаДиалога.Отмена) Тогда
		Объект.ИндексЦвета = Результат[0].Картинка;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

