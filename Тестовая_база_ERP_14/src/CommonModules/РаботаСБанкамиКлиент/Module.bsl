///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("Банки") И ПараметрыКлиента.Банки.ВыводитьОповещениеОНеактуальности Тогда
		ПодключитьОбработчикОжидания("РаботаСБанкамиВывестиОповещениеОНеактуальности", 45, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление классификатора банков.

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКлассификаторУстарел() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Классификатор банков устарел';
			|en = 'Bank classifier is outdated'"),
		НавигационнаяСсылкаФормыЗагрузки(),
		НСтр("ru = 'Обновить классификатор банков';
			|en = 'Update bank classifier'"),
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКлассификаторУспешноОбновлен() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Классификатор банков успешно обновлен';
			|en = 'Bank classifier is successfully updated'"),
		НавигационнаяСсылкаФормыЗагрузки(),
		НСтр("ru = 'Классификатор банков обновлен';
			|en = 'Bank classifier is updated'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Выводит соответствующее оповещение.
//
Процедура ОповеститьКлассификаторАктуален() Экспорт
	
	ПоказатьПредупреждение(,НСтр("ru = 'Классификатор банков актуален.';
								|en = 'Bank classifier is up-to-date.'"));
	
КонецПроцедуры

// Возвращает навигационную ссылку для оповещений.
//
Функция НавигационнаяСсылкаФормыЗагрузки()
	Возврат "e1cib/data/Обработка.ЗагрузкаКлассификатораБанков.Форма.ЗагрузкаКлассификатора";
КонецФункции

Процедура ОткрытьФормуЗагрузкиКлассификатора(Владелец, ОткрытиеИзСписка = Ложь) Экспорт
	Если ОткрытиеИзСписка Тогда
		ПараметрыФормы = Новый Структура("ОткрытиеИзСписка");
	КонецЕсли;
	ИмяФормы = "Обработка.ЗагрузкаКлассификатораБанков.Форма.ЗагрузкаКлассификатора";
	ОткрытьФорму(ИмяФормы, ПараметрыФормы, Владелец);
КонецПроцедуры

#КонецОбласти
