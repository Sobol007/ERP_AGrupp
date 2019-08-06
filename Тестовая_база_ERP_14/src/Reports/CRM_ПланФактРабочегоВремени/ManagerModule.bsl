#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки вариантов этого отчета.
//  Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
// Параметры:
//  Настройки		 -  Коллекция - Используется для описания настроек отчетов и вариантов.
//       Передается "как есть" из процедур НастроитьВариантыОтчетов и НастроитьВариантыОтчета. 
//  ОписаниеОтчета	 -  СтрокаДерева, ОбъектМетаданных - Описание настроек, метаданные или ссылка отчета. 
// 
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	// Настройка размещения, видимости по умолчанию, важности.
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "Основной");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Истина;
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ПоМесяцам");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецЕсли