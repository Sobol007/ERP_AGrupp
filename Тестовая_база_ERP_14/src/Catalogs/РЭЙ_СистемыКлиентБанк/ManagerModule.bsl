Функция ПолучитьСписокПечатныхФорм(ФильтрПоБанку = "") Экспорт
	Макет = Справочники.РЭЙ_СистемыКлиентБанк.ПолучитьМакет("ПечатныеФормыДокументов");
	
	СписокПечатныхФорм = Новый СписокЗначений;
	
    ТекНомСтр = 2;
	Пока Истина Цикл
		Представление = Макет.Область(ТекНомСтр, 1).Текст;
		Банк = Макет.Область(ТекНомСтр, 2).Текст;
		МестонахождениеМакета = Макет.Область(ТекНомСтр, 3).Текст;
		МакетПечатнойФормы = Макет.Область(ТекНомСтр, 4).Текст;
		ВидДокумента = Макет.Область(ТекНомСтр, 5).Текст;
		
		Если ПустаяСтрока(Представление) Тогда
			Прервать;
		КонецЕсли; 
		
		СписокПечатныхФорм.Добавить(
			Новый Структура("Представление, Банк, МестонахождениеМакета, МакетПечатнойФормы, ВидДокумента", 
				Представление, "", МестонахождениеМакета, МакетПечатнойФормы, ВидДокумента), Представление);
		
		ТекНомСтр = ТекНомСтр + 1;
	КонецЦикла; 
	
	Возврат СписокПечатныхФорм;
КонецФункции

Функция ПолучитьДанныеПечатнойФормыПоПредставлению(Представление) Экспорт
	Результат = Неопределено;
	
	СписокПечатныхФорм = ПолучитьСписокПечатныхФорм();
	Для Каждого ПечФорма Из СписокПечатныхФорм Цикл
		Если ВРег(ПечФорма.Представление) = ВРег(Представление) Тогда
			Результат = ПечФорма.Значение;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат Результат;
КонецФункции
