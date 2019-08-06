#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	УчетХозрасчетныхОрганизацийСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетХозрасчетныхОрганизаций");
	Если Не УчетХозрасчетныхОрганизацийСуществует Тогда
		Если Значение Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя установить значение РаботаВХозрасчетнойОрганизации';
									|en = 'You cannot set value РаботаВХозрасчетнойОрганизации'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетБюджетныхУчрежденийСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений");
	Если УчетХозрасчетныхОрганизацийСуществует И Не УчетБюджетныхУчрежденийСуществует И Не Значение Тогда 
		ВызватьИсключение НСтр("ru = 'Нельзя сбросить значение РаботаВХозрасчетнойОрганизации';
								|en = 'You cannot reset value РаботаВХозрасчетнойОрганизации'");
	КонецЕсли;
			
КонецПроцедуры

#КонецЕсли