
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("УчетнаяПолитика", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета.Форма.ФормаСписка",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти