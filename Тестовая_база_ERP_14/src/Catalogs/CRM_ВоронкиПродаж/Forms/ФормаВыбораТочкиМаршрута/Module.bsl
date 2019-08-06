
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ТочкиМаршрутов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.CRM_ТочкиМаршрутов КАК ТочкиМаршрутов
		|ГДЕ
		|	ТочкиМаршрутов.Владелец = &Владелец
		|	И НЕ ТочкиМаршрутов.ПометкаУдаления
		|	И ТочкиМаршрутов.Вид = ЗНАЧЕНИЕ(Перечисление.CRM_ВидыТочекМаршрута.Старт)
		|УПОРЯДОЧИТЬ ПО
		|	ТочкиМаршрутов.Ссылка
		|");
		Запрос.УстановитьПараметр("Владелец", Параметры.Отбор.Владелец);
		Выборка = Запрос.Выполнить().Выбрать();
		СписокЗапрещенныхТочекСтарта = Новый Массив();
		Выборка.Следующий();
		Пока Выборка.Следующий() Цикл
			СписокЗапрещенныхТочекСтарта.Добавить(Выборка.Ссылка);
		КонецЦикла;
		ПараметрСписокЗапрещенныхТочекСтарта = Список.Параметры.Элементы.Найти("СписокЗапрещенныхТочекСтарта");
		Если ПараметрСписокЗапрещенныхТочекСтарта <> Неопределено Тогда
			ПараметрСписокЗапрещенныхТочекСтарта.Значение = СписокЗапрещенныхТочекСтарта;
			ПараметрСписокЗапрещенныхТочекСтарта.Использование = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти
