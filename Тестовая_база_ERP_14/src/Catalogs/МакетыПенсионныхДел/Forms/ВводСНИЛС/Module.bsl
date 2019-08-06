#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сотрудник = Параметры.Сотрудник;
	СНИЛС = Параметры.СНИЛС;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если СтрДлина(СтрЗаменить(СтрЗаменить(СНИЛС, "-", ""), " ", "")) <> 11 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'СНИЛС не соответствует формату 999-999-999 99';
				|en = 'СНИЛС не соответствует формату 999-999-999 99'"),,
			"СНИЛС",,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		Закрыть(Новый Структура("Сотрудник,СНИЛС", Сотрудник, СНИЛС));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
