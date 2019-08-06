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

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение сведений.
Процедура НачальноеЗаполнение() Экспорт

	ПроставитьСтавкуВзносаНаСтрахованиеОтНесчастныхСлучаев();
	
КонецПроцедуры

Процедура ПроставитьСтавкуВзносаНаСтрахованиеОтНесчастныхСлучаев() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев КАК СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев
	|		ПО Организации.Ссылка = СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.Организация
	|ГДЕ
	|	СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.Период ЕСТЬ NULL ";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.СоздатьНаборЗаписей();
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Отбор.Период.Установить('20120101');
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Ссылка);
		Запись = НаборЗаписей.Добавить();
		Запись.Период = '20120101';
		Запись.Организация = Выборка.Ссылка;
		Запись.Ставка = 0.2;
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаписьПоУмолчанию() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("Период", ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц());
	СтруктураЗаписи.Вставить("Ставка", 0.2);
	СтруктураЗаписи.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	
	Возврат СтруктураЗаписи;
	
КонецФункции

#КонецОбласти

#КонецЕсли