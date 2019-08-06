#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
		Истина, "ОбщаяКоманда.ЖурналДокументовПоТМЦВЭксплуатации");
		
	ОткрытьФорму(
		"Обработка.ЖурналДокументовПоТМЦВЭксплуатации.Форма",
		,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
