
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Версия = "   " + Константы.РЭЙ_НомерВерсииПодсистемыВЭД.Получить();
	
	
	Макет = Обработки.РЭЙ_ОбновлениеПодсистемыВЭД.ПолучитьМакет("ОписаниеОбновлений");
	ИсторияИзменений.Вывести(Макет);
КонецПроцедуры
