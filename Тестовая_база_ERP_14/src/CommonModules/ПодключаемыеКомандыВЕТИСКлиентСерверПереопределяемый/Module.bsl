#Область ПрограммныйИнтерфейс

Процедура ВидыПодключаемыхКоманд(Результат) Экспорт
	
	Результат = Новый Массив;
	
КонецПроцедуры

#Область КомандыДокументовВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИсходящейТранспортнойОперации(Команды) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.КомандыИсходящейТранспортнойОперации(Команды);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыВходящейТранспортнойОперации(Команды) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.КомандыВходящейТранспортнойОперации(Команды);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыПроизводственнойОперации(Команды) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.КомандыПроизводственнойОперации(Команды);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИнвентаризацииПродукции(Команды) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.КомандыИнвентаризацииПродукции(Команды);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеВидимостьюКомандВЕТИС

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИсходящейТранспортнойОперации(Форма, КомандыОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.УправлениеВидимостьюКомандИсходящейТранспортнойОперации(Форма, КомандыОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандВходящейТранспортнойОперации(Форма, КомандыОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.УправлениеВидимостьюКомандВходящейТранспортнойОперации(Форма, КомандыОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандПроизводственнойОперации(Форма, КомандыОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.УправлениеВидимостьюКомандПроизводственнойОперации(Форма, КомандыОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИнвентаризацииПродукции(Форма, КомандыОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.УправлениеВидимостьюКомандИнвентаризацииПродукции(Форма, КомандыОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти