////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает текст сообщения пользователю о необходимости  настройки системы.
//
// Параметры:
//  ВидОперации - Строка - признак выполняемой операции.
//
// Возвращаемое значение:
//  ТекстСообщения - Строка - Строка сообщения.
//
Функция ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации) Экспорт
	
	Возврат ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации);
	
КонецФункции

// Возвращает имя прикладного справочника по имени библиотечного справочника.
//
// Параметры:
//  ИмяСправочника - строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  ИмяПрикладногоСправочника - строковое имя прикладного справочника.
//
Функция ИмяПрикладногоСправочника(ИмяСправочника) Экспорт
	
	Возврат ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ИмяПрикладногоСправочника(ИмяСправочника);
	
КонецФункции

// Возвращает текст сообщения пользователю по коду ошибки.
//
// Параметры:
//  КодОшибки - Строка - код ошибки;
//  СтороннееОписаниеОшибки - Строка - описание ошибки переданное другой системой.
//
// Возвращаемое значение:
//  ТекстСообщения - Строка - переопределенное описание ошибки.
//
Функция ПолучитьСообщениеОбОшибке(КодОшибки, СтороннееОписаниеОшибки = "") Экспорт
	
	Возврат ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ПолучитьСообщениеОбОшибке(КодОшибки, СтороннееОписаниеОшибки);
	
КонецФункции

#КонецОбласти