
#Область ПрограммныйИнтерфейс
    
#Область КодыСостояний

// Возвращает код состояния ожидания.
// 
// Возвращаемое значение:
//   Число - код состояния по имени метода. 
//
Функция КодСостоянияОжидание() Экспорт
	
	Возврат 10202;
	
КонецФункции

// Возвращает код состояния успешного выполнения.
// 
// Возвращаемое значение:
//   Число - код состояния по имени метода. 
//
Функция КодСостоянияВыполнено() Экспорт
	
	Возврат 10200;
	
КонецФункции

//  Возвращает код состояния выполнения с предупреждениями.
// 
// Возвращаемое значение:
//   Число - код состояния по имени метода. 
//
Функция КодСостоянияВыполненоСПредупреждениями() Экспорт
	
	Возврат 10240;
    
КонецФункции
    
// Возвращает код состояния ошибки данных.
// 
// Возвращаемое значение:
//   Число - код состояния по имени метода. 
//
Функция КодСостоянияОшибкаДанных() Экспорт
	
	Возврат 10400;
    
КонецФункции

// Возвращает код состояния отсутствия данных.
// 
// Возвращаемое значение:
//   Число - код состояния по имени метода. 
//
Функция КодСостоянияНеНайдено() Экспорт
	
	Возврат 10404;
	
КонецФункции

// Возвращает код состояния внутренней ошибки.
// 
// Возвращаемое значение:
//   Число - код состояния по имени метода. 
//
Функция КодСостоянияВнутренняяОшибка() Экспорт
	
	Возврат 10500;
    
КонецФункции

#КонецОбласти 

#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс

#Область ПоляДанных

Функция ПолеОсновнойРаздел() Экспорт
	
	Возврат "general";
	
КонецФункции

Функция ПолеКодСостояния() Экспорт
	
	Возврат "response";
	
КонецФункции

Функция ПолеОшибка() Экспорт
	
	Возврат "error";
	
КонецФункции

Функция ПолеСообщениеОбОшибке() Экспорт
	
	Возврат "message";
	
КонецФункции

Функция ПолеРезультат() Экспорт
	
	Возврат "result";
	
КонецФункции

#КонецОбласти

#Область СообщенияОбОшибках
    
Функция МетодНеПоддерживается() Экспорт
    Возврат НСтр("ru = 'Метод не поддерживается.';
				|en = 'Method is not supported.'");
КонецФункции

Функция ЗаданиеНеНайдено() Экспорт
    Возврат НСтр("ru = 'Задание по идентификатору ''%1'' не найдено.';
				|en = 'Job was not found by ID ""%1"".'");
КонецФункции

Функция ЗаданиеПоКлючуНеНайдено() Экспорт
    Возврат НСтр("ru = 'Задание по ключу ''%1'' не найдено.';
				|en = 'Job was not found by ""%1"" key.'");
КонецФункции

Функция ФайлНеНайден() Экспорт
    Возврат НСтр("ru = 'Не найден файл ''%1''';
				|en = 'The ''%1'' file is not found'");
КонецФункции

#КонецОбласти 

#КонецОбласти 
