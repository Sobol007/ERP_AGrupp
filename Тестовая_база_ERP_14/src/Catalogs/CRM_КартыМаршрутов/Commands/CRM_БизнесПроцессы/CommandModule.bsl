
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Отбор = Новый Структура("КартаМаршрута", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ПараметрыФормы.Вставить("СкрытьПодменюВидСписка");
	ПараметрыФормы.Вставить("СкрытьБыстрыеОтборы");
	ПараметрыФормы.Вставить("СкрытьПоказКартыМаршрута");
	
	ОткрытьФорму("БизнесПроцесс.CRM_БизнесПроцесс.ФормаСписка",ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти

