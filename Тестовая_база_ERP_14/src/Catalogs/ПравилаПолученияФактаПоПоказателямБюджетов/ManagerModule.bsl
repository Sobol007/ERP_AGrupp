#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	//++ НЕ УТ
	Отчеты.РезультатРаботыПравилПолученияФактическихДанных.ДобавитьКомандуОтчетаПоПоказателюБюджетов(КомандыОтчетов);
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли