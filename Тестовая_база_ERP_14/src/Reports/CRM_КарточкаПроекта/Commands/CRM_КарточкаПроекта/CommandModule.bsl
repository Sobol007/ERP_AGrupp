
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Форма = ПолучитьФорму("Отчет.CRM_КарточкаПроекта.Форма", Новый Структура("Проект",ПараметрКоманды),
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	//
	Если Форма <> Неопределено Тогда
		Форма.Открыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

