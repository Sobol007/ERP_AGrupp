
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Подразделение", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.CRM_ВесаПоказателейПотенциала.Форма.ФормаНастройкиПотенциала", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Источник, , , , РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры

#КонецОбласти
