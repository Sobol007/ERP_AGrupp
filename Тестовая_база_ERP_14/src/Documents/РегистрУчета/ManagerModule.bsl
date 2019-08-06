#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьОписаниеРегистра(ВидРегистра, НачалоПериода, КонецПериода, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	ОписаниеРегистра = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра, "Наименование") 
		+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоПериода, КонецПериода);

	ОписаниеРегистра = ОписаниеРегистра + " " 
		+ БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Организация, ВключатьОбособленныеПодразделения);
	
	Возврат ОписаниеРегистра;
	
КонецФункции

Функция ПолучитьФорматСохраненияРегистров() Экспорт
	
	ФорматРегистра = Константы.ФорматСохраненияРегистровУчета.Получить();
	Возврат ?(ЗначениеЗаполнено(ФорматРегистра), ФорматРегистра, Перечисления.ФорматыСохраненияОтчетов.PDF);
	
КонецФункции

Функция ПолучитьСвойстваПрисоединенногоФайлаРегистра(РегистрУчета, ПолучитьДанныеФайла) Экспорт
	
	СвойстваФайла = Новый Структура("ПрисоединенныйФайл, ПодписанЭП, ФайлРегистраУчетаПрисоединен");
	
	СвойстваФайла.ПрисоединенныйФайл           = Справочники.РегистрУчетаПрисоединенныеФайлы.ПустаяСсылка();
	СвойстваФайла.ПодписанЭП                   = Ложь;
	СвойстваФайла.ФайлРегистраУчетаПрисоединен = Ложь;
	
	Если НЕ ЗначениеЗаполнено(РегистрУчета) Тогда
		Возврат СвойстваФайла;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("ВладелецФайла", РегистрУчета);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрУчетаПрисоединенныеФайлы.Ссылка КАК ПрисоединенныйФайл,
	|	РегистрУчетаПрисоединенныеФайлы.ПодписанЭП
	|ИЗ
	|	Справочник.РегистрУчетаПрисоединенныеФайлы КАК РегистрУчетаПрисоединенныеФайлы
	|ГДЕ
	|	РегистрУчетаПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(СвойстваФайла, Выборка);
		
		СвойстваФайла.ФайлРегистраУчетаПрисоединен = Истина;
		
		Если ПолучитьДанныеФайла Тогда
			СвойстваФайла.Вставить("ДанныеФайла",
				РаботаСФайлами.ДанныеФайла(Выборка.ПрисоединенныйФайл, Новый УникальныйИдентификатор));
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СвойстваФайла;
	
КонецФункции

#КонецОбласти

#КонецЕсли