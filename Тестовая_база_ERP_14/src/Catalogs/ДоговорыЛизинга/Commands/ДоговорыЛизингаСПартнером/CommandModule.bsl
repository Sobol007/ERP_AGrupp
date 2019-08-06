
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Партнер, Заголовок", ПараметрКоманды, НСтр("ru = 'Договоры с партнером';
																				|en = 'Contracts with partner'"));
	
	ОткрытьФорму("Справочник.ДоговорыЛизинга.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
