////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, что указанное событие - это событие об изменении набора свойств.
//
// Параметры:
//  Форма      - УправляемаяФорма - форма, в которой была вызвана обработка оповещения.
//  ИмяСобытия - Строка           - имя обрабатываемого события.
//  Параметр   - Произвольный     - параметры, переданные в событии.
//
// Возвращаемое значение:
//  Булево - если Истина, тогда это оповещение об изменении набора свойств и
//           его нужно обработать в форме.
//
Функция ОбрабатыватьОповещения(Форма, ИмяСобытия, Параметр) Экспорт
	
	Если НЕ Форма.Свойства_ИспользоватьСвойства
	 ИЛИ НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_НаборыДополнительныхРеквизитовИСведений" Тогда
		Если Не Параметр.Свойство("Ссылка") Тогда
			Возврат Истина;
		Иначе
			Возврат Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта.НайтиПоЗначению(Параметр.Ссылка) <> Неопределено;
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_ДополнительныеРеквизитыИСведения" Тогда
		
		Если Форма.ПараметрыСвойств.Свойство("ВыполненаОтложеннаяИнициализация")
			И Не Форма.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация
			Или Не Параметр.Свойство("Ссылка") Тогда
			Возврат Истина;
		Иначе
			Отбор = Новый Структура("Свойство", Параметр.Ссылка);
			Возврат Форма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор).Количество() > 0;
		КонецЕсли;
// +CRM
	ИначеЕсли ИмяСобытия = "ЗаписаныДопРеквизитыИзЗадачи" И (Форма.Объект.Ссылка = Параметр) Тогда
		Возврат Истина;
// -CRM
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти