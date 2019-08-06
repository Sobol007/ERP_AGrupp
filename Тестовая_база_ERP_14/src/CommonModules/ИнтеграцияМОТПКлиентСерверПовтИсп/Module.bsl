
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает дату обязательной маркировки табачных изделий.
// 
// Параметры:
// Возвращаемое значение:
// 	Дата - дата обязательной маркировки табачных изделий.
//
Функция ДатаОбязательнойМаркировкиТабачнойПродукции() Экспорт
	
	Возврат ИнтеграцияМОТПВызовСервера.ДатаОбязательнойМаркировкиТабачнойПродукции();

КонецФункции

// Возвращает признак необходимости контроля статусов кодов маркировок.
// 
// Параметры:
// Возвращаемое значение:
// 	Булево - Истина, в случае необходимости контроля статусов.
//
Функция КонтролироватьСтатусыКодовМаркировки() Экспорт
	
	Возврат ИнтеграцияМОТПВызовСервера.КонтролироватьСтатусыКодовМаркировки();

КонецФункции

// Возвращает признак необходимости контроля статусов кодов маркировок при розничной торговле.
// 
// Параметры:
// Возвращаемое значение:
// 	Булево - Истина, в случае необходимости контроля статусов.
//
Функция КонтролироватьСтатусыКодовМаркировкиВРознице() Экспорт
	
	Возврат ИнтеграцияМОТПВызовСервера.КонтролироватьСтатусыКодовМаркировкиВРознице();

КонецФункции

#КонецОбласти
