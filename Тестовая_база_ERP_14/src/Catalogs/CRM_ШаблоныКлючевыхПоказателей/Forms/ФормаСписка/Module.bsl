
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Функция СписокПередНачаломДобавленияНаСервере()
	Если НЕ CRM_ЛицензированиеСервер.ВариантПоставкиКОРП() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Функция доступна только для ""КОРП"" поставки конфигурации!';en='The function is only available for ""CORP"" configuration delivery!'");
		Сообщение.Сообщить();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = СписокПередНачаломДобавленияНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПредопределенныеПоказателиНаСервере()
	Справочники.CRM_ШаблоныКлючевыхПоказателей.ЗаполнитьПредопределенныеПоказатели();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтвета(Знач Результат, Знач Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПредопределенныеПоказателиНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПредопределенныеПоказатели(Команда)
	ПараметрыОповещения = Новый Структура;
	Оповещение = Новый ОписаниеОповещения("ОбработкаОтвета", ЭтотОбъект, ПараметрыОповещения);
	ПоказатьВопрос(Оповещение, "Текущие настройки будут заменены стандартными.
	|Продолжить ?", РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти



