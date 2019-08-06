#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПриЗаписи(Отказ)
	
	//++ НЕ УТ
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.БухгалтерскийУчетБазовый") Тогда
		// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что в расположенным ниже коде,
		// реализована логика, которая должна выполняться в том числе при установке этого свойства равным Истина.
		Модуль = ОбщегоНазначения.ОбщийМодуль("БухгалтерскийУчетБазовый");
		Модуль.ПриЗаписиКонстантыИспользоватьНачислениеЗарплаты(ЭтотОбъект);
	КонецЕсли;
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Значение = Ложь Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.РасчетЗарплатыДляНебольшихОрганизаций") Тогда
			МодульРасчетЗарплатыДляНебольшихОрганизаций = ОбщегоНазначения.ОбщийМодуль("РасчетЗарплатыДляНебольшихОрганизацийСобытия");
			МодульРасчетЗарплатыДляНебольшихОрганизаций.ПриОтключенииНачисленияЗарплаты();
		КонецЕсли;
	КонецЕсли; 
	
	УчетПособийСоциальногоСтрахования.ПриЗаписиКонстантыИспользоватьНачислениеЗарплаты(ЭтотОбъект);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы.РасчетЗарплатыРасширенная") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетЗарплатыРасширенный");
		Модуль.УстановитьПараметрыНабораСвойствВидыДокументовВводДанныхДляРасчетаЗарплаты();
	КонецЕсли;
	//-- НЕ УТ
	
	Возврат; // в УТ пустой
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
