///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Пояснение = Параметры.Пояснение;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабМакет = Обработки.ПереносФайловВТома.ПолучитьМакет("МакетОтчета");
	
	ОбластьЗаголовок = ТабМакет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.Описание = НСтр("ru = 'Файлы с ошибками:';
												|en = 'Files with errors:'");
	ТабДок.Вывести(ОбластьЗаголовок);
	
	ОбластьСтрока = ТабМакет.ПолучитьОбласть("Строка");
	
	Для Каждого Выборка Из Параметры.МассивФайловСОшибками Цикл
		ОбластьСтрока.Параметры.Название = Выборка.ИмяФайла;
		ОбластьСтрока.Параметры.Версия = Выборка.Версия;
		ОбластьСтрока.Параметры.Ошибка = Выборка.Ошибка;
		ТабДок.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	Отчет.Вывести(ТабДок);
	
КонецПроцедуры

#КонецОбласти
