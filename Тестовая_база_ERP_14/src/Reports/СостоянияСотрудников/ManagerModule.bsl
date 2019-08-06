#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализСостоянийПоПодразделениямИСотрудникам");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Потери рабочего времени в днях и процентах по подразделениям и сотрудникам.
		|Учитываются потери в связи с отпусками всех видов и болезнью работников';
		|en = 'Lost working hours in days and percents by departments and employees.
		|Losses due to leaves of all kinds and employees'' sickness are recorded'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОтсутствияСотрудников");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Список периодов отсутствия сотрудников с указанием причины, количества 
		|календарных и рабочих дней';
		|en = 'List of absence periods of employees with reasons, number
		|of calendar and workdays '");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли