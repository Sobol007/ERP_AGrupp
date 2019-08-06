////////////////////////////////////////////////////////////////////////////////
// ОбменССайтомПовтИсп: механизм обмена с сайтом
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Получает предопределенный узел плана обмена
//
// Параметры:
//  УзелОбмена - ПланОбменаСсылка - Ссылка на план обмена.
// 
// Возвращаемое значение:
//  Булево - признак равенства узла обмена предопределенному значению.
//
Функция ПолучитьЭтотУзелПланаОбмена(Знач УзелОбмена) Экспорт
	
	Возврат (УзелОбмена = ПланыОбмена.ОбменССайтом.ЭтотУзел());
	
КонецФункции

// Возвращает имя прикладного документа по имени библиотечного документа.
//
// Параметры:
//  ИмяДокумента - строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  ИмяПрикладногоДокумента - строковое имя прикладного справочника.
//
Функция ИмяПрикладногоДокумента(ИмяДокумента) Экспорт
	
	СоответствиеДокументов = Новый Соответствие;
	ОбменССайтомПереопределяемый.ПолучитьСоответствиеДокументов(СоответствиеДокументов);
	
	ИмяПрикладногоДокумента = СоответствиеДокументов.Получить(ИмяДокумента);
	Если ИмяПрикладногоДокумента = Неопределено Тогда // не задано соответствие
		ШаблонСообщения = НСтр("ru = 'В коде прикладного решения необходимо указать соответствие для документа %1.';
								|en = 'Specify mapping for document %1 in the applied solution  code.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяДокумента);
		ЗаписьЖурналаРегистрации(ТекстовоеПредставлениеПодсистемыДляЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
	КонецЕсли;
	
	Возврат ИмяПрикладногоДокумента;
	
КонецФункции

// Возвращает имя прикладного документа по имени библиотечного документа.
//
// Параметры:
//  ИмяСправочника - Строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  Строка - имя прикладного справочника.
//
Функция ИмяПрикладногоСправочника(ИмяСправочника) Экспорт
	
	СоответствиеСправочников = Новый Соответствие;
	ОбменССайтомПереопределяемый.ПолучитьСоответствиеСправочников(СоответствиеСправочников);
	
	ИмяПрикладногоСправочника = СоответствиеСправочников.Получить(ИмяСправочника);
	Если ИмяПрикладногоСправочника = Неопределено Тогда // не задано соответствие
		ШаблонСообщения = НСтр("ru = 'В коде прикладного решения необходимо указать соответствие для справочника %1.';
								|en = 'In the applied solution code, specify a matching for the %1 catalog.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяСправочника);
		ЗаписьЖурналаРегистрации(ТекстовоеПредставлениеПодсистемыДляЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
	КонецЕсли;
	
	Возврат ИмяПрикладногоСправочника;
	
КонецФункции

// Возвращает имя прикладного документа по имени библиотечного документа.
//
// Параметры:
//  ИмяПВХ - Строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  Строка - строковое имя прикладного справочника.
//
Функция ИмяПрикладногоПВХ(ИмяПВХ) Экспорт
	
	СоответствиеПВХ = Новый Соответствие;
	ОбменССайтомПереопределяемый.ПолучитьСоответствиеПВХ(СоответствиеПВХ);
	
	ИмяПрикладногоПВХ = СоответствиеПВХ.Получить(ИмяПВХ);
	Если ИмяПрикладногоПВХ = Неопределено Тогда // не задано соответствие.
		ШаблонСообщения = НСтр("ru = 'В коде прикладного решения необходимо указать соответствие для плана видов характеристик %1.';
								|en = 'Specify mapping for the %1 chart of characteristic types in the applied solution code.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяПВХ);
		ЗаписьЖурналаРегистрации(ТекстовоеПредставлениеПодсистемыДляЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
	КонецЕсли;
	
	Возврат ИмяПрикладногоПВХ;
	
КонецФункции

// Возвращает имя прикладного документа по имени библиотечного документа.
//
// Параметры:
//  ИмяФормы - Строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  ИмяПрикладногоДокумента - строковое имя прикладного справочника.
//
Функция ИмяПрикладнойФормы(ИмяФормы) Экспорт
	
	СоответствиеФорм= Новый Соответствие;
	ОбменССайтомПереопределяемый.ПолучитьСоответствиеФорм(СоответствиеФорм);
	
	ИмяПрикладнойФормы = СоответствиеФорм.Получить(ИмяФормы);
	Если ИмяПрикладнойФормы = Неопределено Тогда // не задано соответствие
		ШаблонСообщения = НСтр("ru = 'В коде прикладного решения необходимо указать соответствие для формы %1.';
								|en = 'Specify mapping for form %1 in the applied solution code.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяФормы);
		ЗаписьЖурналаРегистрации(ТекстовоеПредставлениеПодсистемыДляЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
	КонецЕсли;
	
	Возврат ИмяПрикладнойФормы;
	
КонецФункции

// Возвращает список узлов плана обмена в которых будут регистрироваться товары, заказы.
//
// Параметры:
//  ОбменТоварами - Булево - признак обмена товарами узла плана обмена.
//  ОбменЗаказами - Булево - признак обмена заказами узла плана обмена.
// 
// Возвращаемое значение:
//  Массив - список узлов планов обмена.
//
Функция МассивУзловДляРегистрации(ОбменТоварами = Ложь, ОбменЗаказами = Ложь) Экспорт
	
	МассивУзлов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбменССайтом.Ссылка КАК Узел
	|ИЗ
	|	ПланОбмена.ОбменССайтом КАК ОбменССайтом
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ОбменТоварами
	|				ТОГДА ОбменССайтом.ОбменТоварами
	|			КОГДА &ОбменЗаказами
	|				ТОГДА ОбменССайтом.ОбменЗаказами
	|		КОНЕЦ
	|	И НЕ ОбменССайтом.Ссылка = &ЭтотУзел";
	Запрос.УстановитьПараметр("ОбменТоварами", ОбменТоварами);
	Запрос.УстановитьПараметр("ОбменЗаказами", ОбменЗаказами);
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменССайтом.ЭтотУзел());
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивУзлов.Добавить(Выборка.Узел);
	КонецЦикла;
	
	Возврат МассивУзлов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстовоеПредставлениеПодсистемыДляЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Обмен с сайтом.';
				|en = 'Exchange with website.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти