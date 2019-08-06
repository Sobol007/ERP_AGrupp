///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	// Для категорий "Product", "ProductVersion", "PlatformVersion" должно быть одно из: eq ne lt le gt ge.
	// Во всех остальных случаях установить eq.
	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("Product")
				ИЛИ ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("ProductVersion")
				ИЛИ ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("PlatformVersion") Тогда
			Если НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("eq")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("ne")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("lt")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("le")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("gt")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("ge") Тогда
				// Все нормально.
			Иначе
				ТекущаяЗапись.УсловиеОтбора = "eq";
			КонецЕсли;
		Иначе
			ТекущаяЗапись.УсловиеОтбора = "eq";
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл

		// Для категорий "Product", "ProductVersion", "PlatformVersion" должно быть одно из: eq ne lt le gt ge.
		// Во всех остальных случаях установить eq.
		Если ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("Product") Тогда
			Если НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("eq")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("ne")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("lt")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("le")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("gt")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("ge") Тогда
				// Все нормально.
			Иначе
				ТекущаяЗапись.УсловиеОтбора = "eq";
			КонецЕсли;
		Иначе
			ТекущаяЗапись.УсловиеОтбора = "eq";
		КонецЕсли;

		// В простых категориях не должно быть "ProductVersion", "PlatformVersion".
		Если ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("ProductVersion")
				ИЛИ ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("PlatformVersion") Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В простых категориях не должно быть категории с кодом %1 - она должна быть в категориях интервалов версий.';
					|en = 'Simple categories cannot have a category with code %1  - it must belong to version interval categories.'"),
				ТекущаяЗапись.КатегорияНовостей.Код);
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Сообщить();
			Отказ = Истина;
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли