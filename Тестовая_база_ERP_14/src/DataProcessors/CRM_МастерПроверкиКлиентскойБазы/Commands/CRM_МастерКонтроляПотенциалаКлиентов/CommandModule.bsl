
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("ВидМастера", ПредопределенноеЗначение("Перечисление.CRM_ВидыМастераПроверкиКлиентскойБазы.КонтрольПотенциалаКлиентов"));
	ОткрытьФорму("Обработка.CRM_МастерПроверкиКлиентскойБазы.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность);
КонецПроцедуры

#КонецОбласти

