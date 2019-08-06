#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует массив ссылок на перечисление по заданным ключам
//
// Параметры:
// 		Действия - Строка - Строка перечисленнных через запятую ключей перечисления.
//
// Возвращаемое значение:
// 		Массив - Массив ссылок на элементы перечисления.
//
Функция МассивЗначенийПоЗаданнымИменам(Действия) Экспорт
	
	Массив = Новый Массив;
	
	Структура = Новый Структура(Действия);
	Для Каждого КлючИЗначение Из Структура Цикл
		ЗначениеПеречисления = Перечисления.ДействияНаОснованииИнвентаризации[КлючИЗначение.Ключ];
		Если ЗначениеЗаполнено(ЗначениеПеречисления) Тогда
			Массив.Добавить(ЗначениеПеречисления);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#КонецЕсли
