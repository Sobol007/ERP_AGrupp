#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Переносит сведения о статусах застрахованных физических лиц из регистра сведений
// УдалитьСтатусыЗастрахованныхФизическихЛиц, в связи с изменением периодичности регистра.
// Определяет периоды, за которые пользователями вводились данные интерактивно, определяет
// значения сведений на конец месяца этих периода, сохраняет эти значения с новой периодичностью.
//
Функция ПеренестиСведенияОСтатусахЗастрахованныхФизическихЛиц() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтатусыЗастрахованныхФизическихЛиц.ФизическоеЛицо
		|ИЗ
		|	РегистрСведений.СтатусыЗастрахованныхФизическихЛиц КАК СтатусыЗастрахованныхФизическихЛиц";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Запрос.УстановитьПараметр("Период", ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений());
		ЗаписьПоУмолчанию = РегистрыСведений.СтатусыЗастрахованныхФизическихЛиц.СоздатьМенеджерЗаписи();
		Запрос.УстановитьПараметр("ПериодПоУмолчанию", ЗаписьПоУмолчанию.Период);
		Запрос.УстановитьПараметр("ВидЗастрахованногоЛицаПоУмолчанию", ЗаписьПоУмолчанию.ВидЗастрахованногоЛица);
		
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	УдалитьСтатусыЗастрахованныхФизическихЛиц.Период,
			|	УдалитьСтатусыЗастрахованныхФизическихЛиц.ФизическоеЛицо
			|ПОМЕСТИТЬ ВТСтатусыДневные
			|ИЗ
			|	РегистрСведений.УдалитьСтатусыЗастрахованныхФизическихЛиц КАК УдалитьСтатусыЗастрахованныхФизическихЛиц
			|ГДЕ
			|	УдалитьСтатусыЗастрахованныхФизическихЛиц.Период > &Период
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КОНЕЦПЕРИОДА(СтатусыДневные.Период, МЕСЯЦ) КАК Период,
			|	СтатусыДневные.ФизическоеЛицо
			|ПОМЕСТИТЬ ВТИзмеренияДаты
			|ИЗ
			|	ВТСтатусыДневные КАК СтатусыДневные";
			
		Запрос.Выполнить();
		
		ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
			"УдалитьСтатусыЗастрахованныхФизическихЛиц",
			Запрос.МенеджерВременныхТаблиц,
			Ложь,
			ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
				"ВТИзмеренияДаты",
				"ФизическоеЛицо"));
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо,
			|	ЕСТЬNULL(УдалитьСтатусыЗастрахованныхФизическихЛиц.Период, &ПериодПоУмолчанию) КАК Период,
			|	ЕСТЬNULL(УдалитьСтатусыЗастрахованныхФизическихЛиц.ВидЗастрахованногоЛица, &ВидЗастрахованногоЛицаПоУмолчанию) КАК ВидЗастрахованногоЛица
			|ИЗ
			|	Справочник.ФизическиеЛица КАК ФизическиеЛица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТУдалитьСтатусыЗастрахованныхФизическихЛицСрезПоследних КАК УдалитьСтатусыЗастрахованныхФизическихЛиц
			|		ПО (УдалитьСтатусыЗастрахованныхФизическихЛиц.ФизическоеЛицо = ФизическиеЛица.Ссылка)
			|ГДЕ
			|	НЕ ФизическиеЛица.ЭтоГруппа";
			
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			НаборЗаписей = РегистрыСведений.СтатусыЗастрахованныхФизическихЛиц.СоздатьНаборЗаписей();
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, Выборка);
				
			КонецЦикла;
			
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.Записать();
			
		КонецЕсли; 
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли