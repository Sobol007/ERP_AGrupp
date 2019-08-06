////////////////////////////////////////////////////////////////////////////////
// Переопределяемые процедуры, вызываемые из обработчиков форм, таких как:
// "ПриСозданииНаСервере", "ПриЧтенииНаСервере", "ПередЗаписьюНаСервере", 
// "ПослеЗаписи", а также при изменении некоторых реквизитов табличной части,
// таких как "Номенклатура", "Характеристика".
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ЗаполнениеОбработчиковФормы

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - УправляемаяФорма - Форма, из обработчика события которой происходит вызов процедуры.
//	Отказ - Булево - признак отказа.
//	СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - УправляемаяФорма - Форма, из обработчика события которой происходит вызов процедуры.
//	ТекущийОбъект - Объект - Обрабатываемый объект.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - УправляемаяФорма - Форма, из обработчика события которой происходит вызов процедуры.
//	Отказ - Булево - признак отказа.
//	ТекущийОбъект - Объект - Обрабатываемый объект.
//	ПараметрыЗаписи - Структура - Параметры записи.
//
Процедура ПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - УпрпавляемаяФорма - Форма, из обработчика события которой происходит вызов процедуры.
//  ТекущийОбъект - Объект - Записанный объект.
//	ПараметрыЗаписи - Структура - Параметры записи.
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеНоменклатуры

// Переопределяемая процедура, вызываемая из обработчика реквизита "Номенклатура" табличной части.
//
// Параметры:
// 	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - текущая строка табличной части.
// 	ПараметрыДействия - Структура - допустимые действия для табличной части.
//	КэшированныеЗначения - Структура - Кэшированные значения табличной части.
Процедура НоменклатураПриИзмененииПереопределяемый(ТекущаяСтрока, ПараметрыДействия, КэшированныеЗначения)Экспорт


КонецПроцедуры

#КонецОбласти 

#Область ЗаполнениеХарактеристики

// Переопределяемая процедура, вызываемая из обработчика реквизита "Характеристика" табличной части.
//
// Параметры:
// 	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - текущая строка табличной части.
// 	ПараметрыДействия - Структура - допустимые действия для табличной части.
//	КэшированныеЗначения - Структура - Кэшированные значения табличной части.
Процедура ХарактеристикаПриИзмененииПереопределяемый(ТекущаяСтрока, ПараметрыДействия, КэшированныеЗначения)Экспорт


КонецПроцедуры
	
#КонецОбласти 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
