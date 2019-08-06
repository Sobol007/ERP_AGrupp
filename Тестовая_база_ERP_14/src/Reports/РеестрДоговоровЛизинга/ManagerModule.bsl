#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру вариантов настроек
//
// Возвращаемое значение:
// 		Структура - Структура вариантов настроек.
Функция ВариантыНастроек() Экспорт
	
	Результат = Новый Массив;
	
	Вариант = Новый Структура;
	Вариант.Вставить("Имя", "РеестрДоговоровЛизинга");
	Вариант.Вставить("Представление", НСтр("ru = 'Реестр договоров лизинга';
											|en = 'Lease agreement registry'"));
	Результат.Добавить(Вариант);
	
	Вариант = Новый Структура;
	Вариант.Вставить("Имя", "РасчетыПоДоговоруЛизинга");
	Вариант.Вставить("Представление", НСтр("ru = 'Расчеты по договору лизинга';
											|en = 'Lease agreement settlements'"));
	Результат.Добавить(Вариант);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли