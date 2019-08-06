#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ПредставлениеПериода = Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ПолучитьПредставлениеПериода(
		ВидОтчета, ДатаНачала, ДатаОкончания);
		
	ПредставлениеВерсии = Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ПолучитьПредставлениеВидаДокумента(Версия);
	
	Наименование = Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ПолучитьНаименование(
		ВидОтчета, ДатаНачала, ДатаОкончания, Организация);

	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаЗаполнения(СообщениеОснование)
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
        Организация = Модуль.ОрганизацияПоУмолчанию();
	КонецЕсли;

	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ОбработкаЗаполненияОбъекта(ЭтотОбъект, СообщениеОснование);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипПолучателя = Перечисления.ТипыКонтролирующихОрганов.ФСРАР ИЛИ ТипПолучателя = Перечисления.ТипыКонтролирующихОрганов.РПН
		ИЛИ ТипПолучателя = Перечисления.ТипыКонтролирующихОрганов.ФТС Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Получатель");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидОтчета) 
		И Не ВидОтчета.ПринадлежитЭлементу(Справочники.ВидыОтправляемыхДокументов.Уведомления)
		И ВидОтчета <> Справочники.ВидыОтправляемыхДокументов.РеестрСведенийВФСС
		И ВидОтчета <> Справочники.ВидыОтправляемыхДокументов.УведомлениеСколковоОсвобождениеОтОбязанностейНалогоплательщика Тогда
		
		Если Не ЗначениеЗаполнено(ДатаНачала) ИЛИ Не ЗначениеЗаполнено(ДатаОкончания) ИЛИ Не ЗначениеЗаполнено(Периодичность) Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Период"" не заполнено';
									|en = 'Поле ""Период"" не заполнено'"); 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПредставлениеПериода", "Объект", Отказ);
		ИначеЕсли ДатаОкончания < ДатаНачала Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Период"" заполнено некорректно.
								   |
								   |Дата начала периода больше, чем дата его окончания.';
								   |en = 'Поле ""Период"" заполнено некорректно.
								   |
								   |Дата начала периода больше, чем дата его окончания.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПредставлениеПериода", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли