
#Область ПрограммныйИнтерфейс

// Функция возвращает процент ставки НДС.
//
// Параметры:
//  СтавкаНДС - ПеречислениеСсылка.СтавкиНДС - Ставка НДС.
//  ПрименяютсяСтавки4и2 - Булево - Признак применения ставок 4% и 2%.
//
// Возвращаемое значение:
//	Число - Процент ставки НДС.
//
Функция ПолучитьСтавкуНДС(СтавкаНДС, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Возврат УчетНДСПереопределяемый.ПолучитьСтавкуНДС(СтавкаНДС, ПрименяютсяСтавки4и2);

КонецФункции // ПолучитьСтавкуНДС()

#КонецОбласти

