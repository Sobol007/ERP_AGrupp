///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ТипСтрока            = Тип("Строка");
	ТипКатегорияНовостей = Тип("ПланВидовХарактеристикСсылка.КатегорииНовостей");

	// Список может быть либо типа ПланВидовХарактеристик,
	//  либо строка с определенными значениями ("Список категорий новостей", "Список лент новостей").

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если ТипЗнч(ТекущаяЗапись.Список) = ТипКатегорияНовостей Тогда
			Если ТекущаяЗапись.Список.Пустая() Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.УстановитьДанные(ТекущаяЗапись);
				Сообщение.Поле = "Список";
				Сообщение.ПутьКДанным = "Запись";
				Сообщение.Текст = НСтр("ru = 'Значение обновляемой категории должно быть заполнено.';
										|en = 'Value of the updated category is required.'");
				Сообщение.Сообщить();
			КонецЕсли;
		ИначеЕсли ТипЗнч(ТекущаяЗапись.Список) = ТипСтрока Тогда
			Если ТекущаяЗапись.Список = "Список категорий новостей" Тогда
				// Разрешенное значение
			ИначеЕсли ТекущаяЗапись.Список = "Список лент новостей" Тогда
				// Разрешенное значение
			ИначеЕсли СтрНайти(ВРег(ТекущаяЗапись.Список), ВРег("Значения категории новостей:")) = 1 Тогда
				// Разрешенное значение
			Иначе
				// Неразрешенное значение
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.УстановитьДанные(ТекущаяЗапись);
				Сообщение.Поле = "Список";
				Сообщение.ПутьКДанным = "Запись";
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неправильное значение %1.
						|Разрешено только:
						|- Список категорий новостей
						|- Список лент новостей
						|- Код категории новостей (начинается с [Значения категории новостей:])';
						|en = 'Incorrect value %1.
						|Allowed only:
						|- News category list
						|- News feed list
						|- News category code (begins with [News category values:])'"),
					ТекущаяЗапись.Список);
				Сообщение.Сообщить();
			КонецЕсли;
		Иначе
			// Неразрешенное значение
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ТекущаяЗапись);
			Сообщение.Поле = "Список";
			Сообщение.ПутьКДанным = "Запись";
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Неправильное значение %1.
					|Разрешено только:
					|- Список категорий новостей
					|- Список лент новостей
					|- Код категории новостей (начинается с [Значения категории новостей:])
					|- Ссылка на план видов характеристик КатегорииНовостей';
					|en = 'Incorrect value %1.
					|Allowed only:
					|- News category list
					|- News feed list
					|- News category code (begins with [News category values:])
					|- Ref to chart of characteristic types of КатегорииНовостей'"),
				ТекущаяЗапись.Список);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли