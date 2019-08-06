#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	УчетБюджетныхУчрежденийСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений");
	Если Не УчетБюджетныхУчрежденийСуществует Тогда
		Если Значение Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя установить значение РаботаВБюджетномУчреждении';
									|en = 'You cannot set value РаботаВБюджетномУчреждении'");
		КонецЕсли;
	КонецЕсли;
			
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетХозрасчетныхОрганизацийСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетХозрасчетныхОрганизаций");
	Если УчетБюджетныхУчрежденийСуществует И Не УчетХозрасчетныхОрганизацийСуществует И Не Значение Тогда 
		ВызватьИсключение НСтр("ru = 'Нельзя сбросить значение РаботаВБюджетномУчреждении';
								|en = 'You cannot reset value РаботаВБюджетномУчреждении'");
	КонецЕсли;
			
КонецПроцедуры

#КонецЕсли