#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	БухгалтерскиеОтчетыПереопределяемый.ПередПроверкойЗаполнения(ЭтотОбъект);
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполненияОтборов(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли