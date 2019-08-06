#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОтпускаСотрудников", Сотрудники.Выгрузить());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОтпускаСотрудниковСотрудники.Сотрудник,
		|	ОтпускаСотрудниковСотрудники.ВидОтпуска,
		|	ОтпускаСотрудниковСотрудники.НомерСтроки,
		|	ОтпускаСотрудниковСотрудники.ДатаНачала,
		|	ОтпускаСотрудниковСотрудники.ДатаОкончания,
		|	ОтпускаСотрудниковСотрудники.НачалоПериодаЗаКоторыйПредоставляетсяОтпуск,
		|	ОтпускаСотрудниковСотрудники.КонецПериодаЗаКоторыйПредоставляетсяОтпуск
		|ПОМЕСТИТЬ ВТОтпускаСотрудников
		|ИЗ
		|	&ОтпускаСотрудников КАК ОтпускаСотрудниковСотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтпускаСотрудников.Сотрудник,
		|	ОтпускаСотрудников.НомерСтроки
		|ПОМЕСТИТЬ ВТСтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска
		|ИЗ
		|	ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|ГДЕ
		|	ВЫРАЗИТЬ(ОтпускаСотрудников.ВидОтпуска КАК Справочник.ВидыОтпусков).ОтпускЯвляетсяЕжегодным
		|	И (ОтпускаСотрудников.НачалоПериодаЗаКоторыйПредоставляетсяОтпуск = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ ОтпускаСотрудников.КонецПериодаЗаКоторыйПредоставляетсяОтпуск = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ ОтпускаСотрудников.НачалоПериодаЗаКоторыйПредоставляетсяОтпуск >= ОтпускаСотрудников.КонецПериодаЗаКоторыйПредоставляетсяОтпуск)
		|	И ОтпускаСотрудников.ДатаНачала <= ОтпускаСотрудников.ДатаОкончания
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОтпускаСотрудников.Сотрудник,
		|	ОтпускаСотрудников.НомерСтроки
		|ИЗ
		|	ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|ГДЕ
		|	ОтпускаСотрудников.ДатаНачала > ОтпускаСотрудников.ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтпускаСотрудников.Сотрудник,
		|	МАКСИМУМ(ОтпускаСотрудниковДругие.НомерСтроки) КАК НомерСтроки
		|ПОМЕСТИТЬ ВТПересекаютсяПериодыОтпусков
		|ИЗ
		|	ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОтпускаСотрудников КАК ОтпускаСотрудниковДругие
		|		ПО ОтпускаСотрудников.Сотрудник = ОтпускаСотрудниковДругие.Сотрудник
		|			И ОтпускаСотрудников.ВидОтпуска <> ОтпускаСотрудниковДругие.ВидОтпуска
		|			И ОтпускаСотрудников.ДатаОкончания >= ОтпускаСотрудниковДругие.ДатаНачала
		|			И ОтпускаСотрудников.ДатаОкончания <= ОтпускаСотрудниковДругие.ДатаОкончания
		|			И (ОтпускаСотрудников.ДатаНачала <> ДАТАВРЕМЯ(1, 1, 1))
		|			И (ОтпускаСотрудников.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1))
		|
		|СГРУППИРОВАТЬ ПО
		|	ОтпускаСотрудников.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПересекаютсяПериодыОтпусков.Сотрудник,
		|	ПересекаютсяПериодыОтпусков.НомерСтроки КАК НомерСтроки,
		|	ОтпускаСотрудников.ВидОтпуска КАК ВидОтпуска,
		|	ИСТИНА КАК ПересекаютсяПериоды,
		|	ЛОЖЬ КАК НекорректныйПериодПредоставления
		|ПОМЕСТИТЬ ВТСводный
		|ИЗ
		|	ВТПересекаютсяПериодыОтпусков КАК ПересекаютсяПериодыОтпусков
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|		ПО ПересекаютсяПериодыОтпусков.НомерСтроки = ОтпускаСотрудников.НомерСтроки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска.Сотрудник,
		|	СтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска.НомерСтроки,
		|	ОтпускаСотрудников.ВидОтпуска,
		|	ЛОЖЬ,
		|	ИСТИНА
		|ИЗ
		|	ВТСтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска КАК СтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтпускаСотрудников КАК ОтпускаСотрудников
		|		ПО СтрокиСНекорректноЗаполненнымПериодомПредоставленияОтпуска.НомерСтроки = ОтпускаСотрудников.НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сводный.Сотрудник,
		|	Сводный.НомерСтроки КАК НомерСтроки,
		|	Сводный.ВидОтпуска,
		|	МАКСИМУМ(Сводный.ПересекаютсяПериоды) КАК ПересекаютсяПериоды,
		|	МАКСИМУМ(Сводный.НекорректныйПериодПредоставления) КАК НекорректныйПериодПредоставления
		|ИЗ
		|	ВТСводный КАК Сводный
		|
		|СГРУППИРОВАТЬ ПО
		|	Сводный.Сотрудник,
		|	Сводный.НомерСтроки,
		|	Сводный.ВидОтпуска
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();       
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.НекорректныйПериодПредоставления Тогда
				ТекстСообщения = ?(ПустаяСтрока(ТекстСообщения), "", ТекстСообщения +", ") +
					НСтр("ru = 'некорректно задан период предоставления отпуска';
						|en = 'leave period is invalid'");
			КонецЕсли; 
			
			Если Выборка.ПересекаютсяПериоды Тогда
				ТекстСообщения = ?(ПустаяСтрока(ТекстСообщения), "", ТекстСообщения +", ") +
					НСтр("ru = 'пересекается период нахождения в отпуске';
						|en = 'leave periods overlap'");
			КонецЕсли; 
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По сотруднику %1';
					|en = 'By employee %1'"),
				Выборка.Сотрудник)
				+ " " + ТекстСообщения;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"Сотрудники[" + (Выборка.НомерСтроки - 1) + "].Сотрудник",
				"Объект",
				Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаСотрудника.КоличествоДнейКомпенсации)
			И (Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаНачала)
				Или Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаОкончания)) Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаНачала)
				И Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаОкончания) Тогда
			
				ТекстСообщения = НСтр("ru = 'не задан период отпуска';
										|en = 'leave period is not set'");
				ИмяРеквизита = "ДатаНачала";
				
			Иначе
				
				ТекстСообщения = НСтр("ru = 'неверно задан период отпуска';
										|en = 'leave period is invalid'");
				Если Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаНачала) Тогда
					ИмяРеквизита = "ДатаНачала";
				Иначе
					ИмяРеквизита = "ДатаОкончания";
				КонецЕсли;
					
			КонецЕсли;
				
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По сотруднику %1';
					|en = 'By employee %1'"),СтрокаСотрудника.Сотрудник)
				+ " " + ТекстСообщения;
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"Сотрудники[" + (Выборка.НомерСтроки - 1) + "]." + ИмяРеквизита,
				"Объект",
				Отказ);
				
		КонецЕсли; 
		
	КонецЦикла;
	
	Документы.ОтпускаСотрудников.ПроверитьРаботающих(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПериодПринадлежности = Дата;
	Документы.ОтпускаСотрудников.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьИзОбучения" Тогда
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда 
				
				СтандартнаяОбработка = Ложь;
				Модуль = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
				Модуль.ЗаполнитьОтпускаСотрудниковИзДокументаОбучения(ЭтотОбъект, ДанныеЗаполнения);
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
