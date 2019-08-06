#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Создает или обновляет запись регистра после отправки запроса на предоставление реестра счетов-фактур поставщику.
//
// Параметры:
//  Параметры - Структура - ключи структуры соответствуют измерениям и ресурсам регистра, за исключением:
//    * СоздаватьЗапись - Булево - Истина - будет создана новая запись регистра, иначе обновлена существующая.
//
Процедура СоздатьЗаписьПослеОтправкиЗапроса(Параметры) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		Запись = СоздатьМенеджерЗаписи();
		
		Блокировка = ОписаниеБлокировки(Параметры);
		Блокировка.Заблокировать();
		
		УстановитьЗначенияКлючевыхПолейЗаписи(Запись, Параметры);
		Запись.ИдентификаторЗапроса = Параметры.ИдентификаторОтправленногоЗапроса;
		Запись.Прочитать();
		
		Если Запись.Выбран() Тогда
			Запись.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.Игнорируется;
			Запись.Записать();
			Запись = СоздатьМенеджерЗаписи();
			ИдентификаторЗапроса = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Запись, Параметры);
		
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СверкаДанныхУчетаНДС.ИмяСобытияЗаписиЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Обновляет записи регистра после загрузки новых запросов на предоставление реестров счетов-фактур из электронной почты.
//
// Параметры:
//  ТаблицаЗапросовРеестров - ТаблицаЗначений - Таблица загружаемых запросов.
//       Состав колонок соответствует измерениям и ресурсам регистра.
//
// Возвращаемое значение:
//  Число - Количество обновленных записей регистра.
//
Функция ОбновитьЗаписиЗапросовРеестровПослеЗагрузкиПочты(ТаблицаЗапросовРеестров) Экспорт
	
	КоличествоЗаписей = 0;
	
	Блокировка = ОписаниеБлокировки(ТаблицаЗапросовРеестров);
	НачатьТранзакцию();
	
	Попытка
		Блокировка.Заблокировать();
		
		Для Каждого ЗапросРеестра Из ТаблицаЗапросовРеестров Цикл
			Запись = Неопределено;
			ЗапросРеестра.Отметка = Истина;
			
			Запись = СоздатьМенеджерЗаписи();
			УстановитьЗначенияКлючевыхПолейЗаписи(Запись, ЗапросРеестра);
			Запись.Прочитать();
			
			Если Запись.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.Отвечено
				ИЛИ Запись.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.Игнорируется Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(Запись, ЗапросРеестра);
			Запись.Записать();
			
			КоличествоЗаписей = КоличествоЗаписей + 1;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СверкаДанныхУчетаНДС.ИмяСобытияЗаписиЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат КоличествоЗаписей;
	
КонецФункции

// Обновляет записи регистра после загрузки новых реестров счетов-фактур поставщиков из электронной почты.
//
// Параметры:
//  ТаблицаРеестров - ТаблицаЗначений - Таблица загружаемых реестров.
//         Состав колонок соответствует измерениям и ресурсам регистра.
//
// Возвращаемое значение:
//  Число - Количество обновленных записей регистра.
//
Функция ОбновитьЗаписиРеестровПослеЗагрузкиПочты(ТаблицаРеестров) Экспорт
	
	КоличествоЗаписей = 0;
	
	Блокировка = ОписаниеБлокировки(ТаблицаРеестров);
	НачатьТранзакцию();
	
	Попытка
		Блокировка.Заблокировать();
		
		Для Каждого Реестр Из ТаблицаРеестров Цикл
			Запись = Неопределено;
			Записи = Неопределено;
			Реестр.Отметка = Истина;
			
			Запись = СоздатьМенеджерЗаписи();
			УстановитьЗначенияКлючевыхПолейЗаписи(Запись, Реестр);
			Запись.Прочитать();
			
			// Нашли запись запроса по всем ключевым полям, обновляем данные.
			Если Запись.Выбран() Тогда
				
				Если Запись.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.ГотовКСверке
					ИЛИ Запись.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.Игнорируется Тогда
					Продолжить;
				КонецЕсли;
				
				ИсключаемыеПоля = "ДатаЗапроса, Сумма, СуммаНДС, ЭлектроннаяПочта";
				ЗаполнитьЗначенияСвойств(Запись, Реестр, , ИсключаемыеПоля);
				Запись.Записать();
				КоличествоЗаписей = КоличествоЗаписей + 1;
				Продолжить;
			КонецЕсли;
			
			// Реестр не найден по ключевым полям, но у него есть идентификатор.
			// Загружаем со статусом "Игнорируется".
			Если ЗначениеЗаполнено(Реестр.ИдентификаторЗапроса) Тогда
				ЗаполнитьЗначенияСвойств(Запись, Реестр);
				Запись.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.Игнорируется;
				Запись.Отметка = Ложь;
				Запись.Записать();
				Продолжить;
			КонецЕсли;
			
			// По ключевым полям ничего не нашли, ищем без ИдентификатораЗапроса.
			Записи = СоздатьНаборЗаписей();
			Записи.Отбор.Организация.Установить(Реестр.Организация);
			Записи.Отбор.Контрагент.Установить(Реестр.Контрагент);
			Записи.Отбор.НалоговыйПериод.Установить(Реестр.НалоговыйПериод);
			Записи.Прочитать();
			
			// Запрос был отправлен, но реестр пришел без идентификатора. Это допустимо, регистрируем запись.
			ЗаписьОбновлена = Ложь;
			Для Каждого ЗаписьНабора Из Записи Цикл
				Если ЗаписьНабора.ТипЗапроса = Перечисления.ТипыЗапросовРеестровСчетовФактур.ЗапросПоставщику
					И ЗаписьНабора.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.Запрошен Тогда
					ЗаполнитьЗначенияСвойств(ЗаписьНабора, Реестр, , "ЭлектроннаяПочта");
					ЗаписьНабора.ДатаЗапроса = '00010101';
					ЗаписьНабора.ИдентификаторЗапроса = Строка(Новый УникальныйИдентификатор);
					Записи.Записать();
					КоличествоЗаписей = КоличествоЗаписей + 1;
					ЗаписьОбновлена = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если НЕ ЗаписьОбновлена Тогда
				// Реестр пришел без запроса и идентификатора. Это допустимо, регистрируем запись.
				ЗаполнитьЗначенияСвойств(Запись, Реестр);
				Запись.ДатаЗапроса = '00010101';
				Запись.ИдентификаторЗапроса = Строка(Новый УникальныйИдентификатор);
				Запись.Записать();
				КоличествоЗаписей = КоличествоЗаписей + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СверкаДанныхУчетаНДС.ИмяСобытияЗаписиЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат КоличествоЗаписей;
	
КонецФункции

// Обновляет записи регистра после отправки реестра счетов-фактур в ответ на запрос покупателя.
//
// Параметры:
//  Параметры - Структура - ключи структуры соответствуют измерениям и ресурсам регистра.
//
Процедура ОбновитьЗаписьПослеОтправкиРеестра(Параметры) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		Блокировка = ОписаниеБлокировки(Параметры);
		Блокировка.Заблокировать();
		
		Запись = СоздатьМенеджерЗаписи();
		УстановитьЗначенияКлючевыхПолейЗаписи(Запись, Параметры);
		Запись.Прочитать();
		Запись.Отметка = Ложь;
		ЗаполнитьЗначенияСвойств(Запись, Параметры);
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СверкаДанныхУчетаНДС.ИмяСобытияЗаписиЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Обновляет записи регистра после загрузки реестров в документ "РеестрыСчетовФактурПоставщиков".
//
// Параметры:
//  ТаблицаРеестров - ТаблицаЗначений - Таблица загружаемых реестров.
//         Состав колонок соответствует измерениям и ресурсам регистра.
//
Процедура ОбновитьЗаписиПослеЗагрузкиРеестров(ТаблицаРеестров) Экспорт
	
	Блокировка = ОписаниеБлокировки(ТаблицаРеестров);
	НачатьТранзакцию();
	
	Попытка
		Блокировка.Заблокировать();
		
		Для Каждого Реестр Из ТаблицаРеестров Цикл
			Запись = СоздатьМенеджерЗаписи();
			УстановитьЗначенияКлючевыхПолейЗаписи(Запись, Реестр);
			Запись.Прочитать();
			Запись.ДатаЗаписи = ТекущаяДатаСеанса();
			Запись.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.ГотовКСверке;
			Запись.Отметка = Ложь;
			Запись.ДанныеРеестра = Неопределено;
			Запись.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СверкаДанныхУчетаНДС.ИмяСобытияЗаписиЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Обновляет запись регистра после установки пометки удаления в документы "РеестрыСчетовФактурПоставщиков".
//
// Параметры:
//  ИдентификаторЗапроса - Строка - Идентификатор запроса по которому был загружен реестр счетов-фактур.
//
Процедура ПослеУстановкиПометкиУдаленияНаРеестрСчетовФактур(ИдентификаторЗапроса) Экспорт
	
	Записи = СоздатьНаборЗаписей();
	Записи.Отбор.ИдентификаторЗапроса.Установить(ИдентификаторЗапроса);
	Записи.Прочитать();
	
	Если Записи.Количество() = 1 Тогда
		Запись = Записи[0];
		НачатьТранзакцию();
		Попытка
			Блокировка = ОписаниеБлокировки(Запись);
			Блокировка.Заблокировать();
			Запись.СтатусЗапроса = Перечисления.СтатусыРеестровСчетовФактур.Игнорируется;
			Записи.Записать();
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(СверкаДанныхУчетаНДС.ИмяСобытияЗаписиЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , ,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
			
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗначенияКлючевыхПолейЗаписи(Запись, Параметры)
	
	Запись.Организация          = Параметры.Организация;
	Запись.Контрагент           = Параметры.Контрагент;
	Запись.НалоговыйПериод      = Параметры.НалоговыйПериод;
	Запись.ИдентификаторЗапроса = Параметры.ИдентификаторЗапроса;
	
КонецПроцедуры

Функция ОписаниеБлокировки(Параметры)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СтатусыЗапросовРеестровСчетовФактур");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	Если ТипЗнч(Параметры) = Тип("ТаблицаЗначений") Тогда
		ЭлементБлокировки.ИсточникДанных = Параметры;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Контрагент" , "Контрагент");
		
	ИначеЕсли ТипЗнч(Параметры) = Тип("Структура") Тогда
		Если Параметры.Свойство("Организация") Тогда
			ЭлементБлокировки.УстановитьЗначение("Организация", Параметры.Организация);
		КонецЕсли;
		
		Если Параметры.Свойство("Контрагент") Тогда
			ЭлементБлокировки.УстановитьЗначение("Контрагент", Параметры.Контрагент);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Параметры) = Тип("РегистрСведенийЗапись.СтатусыЗапросовРеестровСчетовФактур") Тогда
		ЭлементБлокировки.УстановитьЗначение("ИдентификаторЗапроса", Параметры.ИдентификаторЗапроса);
		
	КонецЕсли;
	
	Возврат Блокировка;
	
КонецФункции

#КонецОбласти

#КонецЕсли

