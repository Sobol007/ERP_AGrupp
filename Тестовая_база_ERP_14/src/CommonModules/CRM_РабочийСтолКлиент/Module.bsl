
#Область ПрограммныйИнтерфейс

// Обработчик события ПередНачаломРаботыСистемы.
//
Процедура ПередНачаломРаботыСистемы() Экспорт

	#Если Не ТолстыйКлиентОбычноеПриложение Тогда
		Если CRM_ЛицензированиеСервер.РабочийСтолCRMИспользуется() Тогда	
			ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
			Если ПараметрыРаботыКлиентаПриЗапуске.Свойство("ЗапускатьРабочийСтолМенеджера")
				И ПараметрыРаботыКлиентаПриЗапуске.ЗапускатьРабочийСтолМенеджера Тогда
				КлиентскоеПриложение.УстановитьРежимОсновногоОкна(РежимОсновногоОкнаКлиентскогоПриложения.РабочееМесто);
				
			КонецЕсли;
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

// Обработчик события ПриНачалеРаботыСистемы.
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	Если CRM_ЛицензированиеСервер.РабочийСтолCRMИспользуется() Тогда
		НастройкиОткрытия = CRM_РабочийСтолСервер.ПолучитьНастройкиОткрытия();
		ЗапускатьРабочийСтолМенеджера = НастройкиОткрытия.ОкрыватьРабочийСтол или НастройкиОткрытия.БлокироватьИнтерфейс;	
		Если ЗапускатьРабочийСтолМенеджера Тогда
			ИнициализироватьРабочийСтолКлиент();	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Обработчик события нажатие гипперссылки.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма.
//  Элемент	 - ЭлементФормы - Элемент формы.
//
Процедура ОбработкаГипперссылкиДействийНажатие(Форма, Элемент) Экспорт

	Если Элемент.Имя = "скИндикаторНапоминаний" Тогда
		Если Форма.Элементы.скОбластьНапоминания.Видимость Тогда
			Форма.Элементы.скОбластьНапоминания.Видимость = Ложь;
		Иначе
			СформироватьПанельНапоминаний(Форма);	
		КонецЕсли;
		
	ИначеЕсли Элемент.Имя = "CRM_ОткрытьЗаметки" Тогда
		СформироватьПанельЗаметок(Форма);
		
	КонецЕсли;
	
	Если Элемент.Имя = "скЗакрытьНапоминания" Тогда
		Форма.Элементы.скОбластьНапоминания.Видимость = Ложь;
	КонецЕсли;	
	
	Если Элемент.Имя = "скЗакрытьЗаметки" Тогда
		Форма.Элементы.скОбластьЗаметки.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#Область Напоминания

// Обновляет таблицу напоминаний.
//
// Параметры:
//  Форма				 - УправляемаяФорма - Форма.
//  МассивНапоминаний	 - Массив - Массив напоминаний.
// 
Процедура ОбновитьТаблицуНапоминаний(Форма, МассивНапоминаний) Экспорт
	
	ТаблицаНапоминаний = Форма.CRM_НастройкиРабочегоСтолаТаблицаНапоминаний;
	НовыеНапоминания   = МассивНапоминаний;
	
	НапоминанияОВходящихПисьмах = Ложь;
	ПрочиеНапоминания 			= Истина;
	
	НовыеНапоминанияСписокЗначений	= Новый СписокЗначений;
	СтарыеНапоминанияСписокЗначений	= Новый СписокЗначений;
	Если НЕ (НовыеНапоминания = Неопределено) И НовыеНапоминания.Количество() > 0 Тогда
		Для Каждого Строка Из НовыеНапоминания Цикл
			КлючЗаписи = CRM_НапоминанияКлиент.СформироватьКлючЗаписиПоСтроке(Строка);
			Строки = ТаблицаНапоминаний.НайтиСтроки(КлючЗаписи);
			Если Строки.Количество() = 0 Тогда
				НовыеНапоминанияСписокЗначений.Добавить(Строка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если НапоминанияОВходящихПисьмах И ПрочиеНапоминания Тогда
		ТаблицаНапоминаний.Очистить();
		
	Иначе		
		ВидОповещенияОповещатьОНовыхВходящихПисьмах = ПредопределенноеЗначение("Справочник.CRM_ВидыОповещений.ОповещатьОНовыхВходящихПисьмах");
		
		ТаблицаНапоминанийИндексЭлемента = 0;
		Пока ТаблицаНапоминанийИндексЭлемента < ТаблицаНапоминаний.Количество() Цикл
			ТекущаяСтрокаНапоминаний = ТаблицаНапоминаний[ТаблицаНапоминанийИндексЭлемента];
			
			ТекущееОповещениеОВходящихПисьмах = ТекущаяСтрокаНапоминаний.ВидОповещения = ВидОповещенияОповещатьОНовыхВходящихПисьмах;
			Если (НапоминанияОВходящихПисьмах И ТекущееОповещениеОВходящихПисьмах)
			  ИЛИ (ПрочиеНапоминания И НЕ ТекущееОповещениеОВходящихПисьмах) Тогда
				ТаблицаНапоминаний.Удалить(ТаблицаНапоминанийИндексЭлемента);				
				
			Иначе
				ТаблицаНапоминанийИндексЭлемента = ТаблицаНапоминанийИндексЭлемента + 1;
				
			КонецЕсли;			
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ (НовыеНапоминания = Неопределено) И НовыеНапоминания.Количество() > 0 Тогда
		Для Каждого Строка Из НовыеНапоминания Цикл
			СтрокаНапоминания = ТаблицаНапоминаний.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНапоминания, Строка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	//Если ТаблицаНапоминаний.Количество() = 0 Тогда
	//	Форма.Элементы.скОбластьНапоминания.Видимость = Ложь;
	//КонецЕсли;
	
	ПанельОткрыта = Форма.Элементы.скОбластьНапоминания.Видимость;
	//Форма.Элементы.скИндикаторНапоминаний.Видимость =  Не ПанельОткрыта;
	ИндексКартинки = Мин(ТаблицаНапоминаний.Количество(), 10);
	Попытка
		Форма.Элементы.скИндикаторНапоминаний.Картинка	   = БиблиотекаКартинок["CRM_Оповещения_"+ИндексКартинки];
	Исключение
	КонецПопытки;	
	Если ПанельОткрыта Тогда
		СформироватьПанельНапоминаний(Форма);	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьПанельНапоминаний(Форма)
	
		
	ТаблицаНапоминаний = Форма.CRM_НастройкиРабочегоСтолаТаблицаНапоминаний;
	
	СоответствиеКартинок = Новый Соответствие;
	СоответствиеКартинок.Вставить(0, БиблиотекаКартинок.CRM_НапоминаниеНизкая);
	СоответствиеКартинок.Вставить(1, БиблиотекаКартинок.CRM_НапоминаниеОбычая);
	СоответствиеКартинок.Вставить(2, БиблиотекаКартинок.CRM_НапоминаниеВысокая);
	
	МассивЭлементов = Новый Массив;
	Для каждого СтрокаТаблицы Из ТаблицаНапоминаний Цикл
		СтруктураЭлемента = Новый Структура;
		СтруктураЭлемента.Вставить("Картинка"     		 , СоответствиеКартинок.Получить(СтрокаТаблицы.Важность));
		СтруктураЭлемента.Вставить("Партнер"	  		 , СтрокаТаблицы.Партнер);       
		СтруктураЭлемента.Вставить("КонтактноеЛицо"	  	 , СтрокаТаблицы.КонтактноеЛицо);       		
		СтруктураЭлемента.Вставить("СрокИсполнения"		 , СтрокаТаблицы.СрокИсполнения);
		СтруктураЭлемента.Вставить("Содержание"   		 , СтрокаТаблицы.Содержание);
		СтруктураЭлемента.Вставить("Счетчик"	  		 , СтрокаТаблицы.Счетчик);
		СтруктураЭлемента.Вставить("Предмет"			 , СтрокаТаблицы.Предмет);
		СтруктураЭлемента.Вставить("ПредметПредставление", СтрокаТаблицы.ПредметПредставление);
		СтруктураЭлемента.Вставить("Индекс"				 , ТаблицаНапоминаний.Индекс(СтрокаТаблицы));
		
		МассивЭлементов.Добавить(СтруктураЭлемента);
		
	КонецЦикла;
	
	Форма.скПолеHTMLНапоминаний = HTMLПредставлениеСпискаНапоминаний(МассивЭлементов);
	Форма.Элементы.скОбластьНапоминания.Видимость = Истина;	
	//Форма.Элементы.скИндикаторНапоминаний.Видимость = Не Форма.Элементы.скОбластьНапоминания.Видимость; 
	
	Форма.ТекущийЭлемент = Форма.Элементы.скПолеHTMLНапоминаний;
КонецПроцедуры

Процедура ОткрытьПредметНапоминания(ВыделеннаяСтрока)

	ПоследняяУчетнаяЗапись = Неопределено;
	ПерейтиКЧерновикам		= Ложь;

	Если ТипЗнч(ВыделеннаяСтрока.Предмет) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
		ПоследняяУчетнаяЗапись = ВыделеннаяСтрока.Предмет;
		ПерейтиКЧерновикам = (Найти(ВыделеннаяСтрока.Содержание,"Письма перенесены в ""Черновики""") > 0);
	Иначе
		
		//ПолучитьФормуОткрытьПредмет(ВыделеннаяСтрока.Предмет);
		ПоказатьЗначение(, ВыделеннаяСтрока.Предмет); 

	КонецЕсли;

	Если Не ПоследняяУчетнаяЗапись = Неопределено Тогда

		ОткрытьМенеджерПочты(ПоследняяУчетнаяЗапись, ПерейтиКЧерновикам);

	КонецЕсли;
	
КонецПроцедуры

Процедура ПрекратитьНапоминание(Форма, ВыделеннаяСтрока)
	
	БылиИзмененыОповещенияОВходящихПисьмах = Ложь;
	Если ВыделеннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураСтроки = CRM_НапоминанияКлиент.СформироватьКлючЗаписиПоСтроке(ВыделеннаяСтрока);
	СтруктураНапоминания = CRM_РабочийСтолСервер.ПрекратитьНапоминание(СтруктураСтроки);
	Если НЕ СтруктураНапоминания.Выбран Тогда
		ПоказатьПредупреждение(, НСтр("ru='Напоминание удалено или модифицировано!';en='The reminder is deleted or modified!'"));
		Возврат;
	КонецЕсли;
	Если СтруктураНапоминания.ЭтоНапоминаниеОВходящихПисьмах Тогда
		БылиИзмененыОповещенияОВходящихПисьмах = Истина;
	КонецЕсли; 
	
	//Форма.Подключаемый_ОбновитьТаблицуНапоминаний(CRM_НапоминанияСервер.ПолучитьНапоминания());
	ОбновитьТаблицуНапоминаний(Форма, CRM_НапоминанияСервер.ПолучитьНапоминания());
КонецПроцедуры

Процедура ПеренестиНапоминание(Форма, ВыделеннаяСтрока)
	
	СписокВариантов = CRM_РабочийСтолКлиентПовтИсп.СписокВариантовОтложенногоВремени();	
	Оповещение = Новый ОписаниеОповещения("ПеренестиНапоминаниеЗавершение", 
		ЭтотОбъект, Новый Структура("Форма, ВыделеннаяСтрока", Форма, ВыделеннаяСтрока));
		
	СписокВариантов.ПоказатьВыборЭлемента(Оповещение, НСтр("ru='Нажмите ""Отложить"", чтобы получить оповещение через';en='Click ""Snooze"" to get notified via'"));
		
КонецПроцедуры

// Переносит завершение напоминания.
//
// Параметры:
//  Результат				 - Структура - Результат.
//  ДополнительныеПараметры	 - Структура - Дополнительные параметры.
//
Процедура ПеренестиНапоминаниеЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	аэлемент = 0;
	
	БылиИзмененыОповещенияОВходящихПисьмах = Ложь;
	
	ТекущаяСтрока = ДополнительныеПараметры.ВыделеннаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	СтруктураСтроки = CRM_НапоминанияКлиент.СформироватьКлючЗаписиПоСтроке(ТекущаяСтрока);
	СтруктураНапоминания = CRM_РабочийСтолСервер.ПеренестиНапоминание(СтруктураСтроки, Результат.Значение, аэлемент);
	Если НЕ СтруктураНапоминания.Выбран Тогда
		аэлемент = аэлемент + 1; 
		ПоказатьПредупреждение(, НСтр("ru='Напоминание удалено или модифицировано!';en='The reminder is deleted or modified!'"));
		Возврат;
	КонецЕсли;
	Если СтруктураНапоминания.ЭтоНапоминаниеОВходящихПисьмах Тогда
		БылиИзмененыОповещенияОВходящихПисьмах = Истина;
	КонецЕсли; 
	аэлемент = аэлемент + 1;
	ОбновитьТаблицуНапоминаний(ДополнительныеПараметры.Форма, CRM_НапоминанияСервер.ПолучитьНапоминания());	

КонецПроцедуры

Процедура ПрекратитьВсеНапоминания(Форма)
	
	Для Каждого Строка Из Форма.CRM_НастройкиРабочегоСтолаТаблицаНапоминаний Цикл
		СтруктураСтроки = CRM_НапоминанияКлиент.СформироватьКлючЗаписиПоСтроке(Строка);
		СтруктураНапоминания = CRM_РабочийСтолСервер.ПрекратитьНапоминание(СтруктураСтроки);
		Если НЕ СтруктураНапоминания.Выбран Тогда
			ПоказатьПредупреждение(, НСтр("ru='Напоминание удалено или модифицировано!';en='The reminder is deleted or modified!'"));
			Продолжить;
		КонецЕсли;

	КонецЦикла;
	
	ОбновитьТаблицуНапоминаний(Форма, CRM_НапоминанияСервер.ПолучитьНапоминания());
КонецПроцедуры

// Скрывает напоминания.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма.
//
Процедура СкрытьНапоминания(Форма) Экспорт
	
	Форма.Элементы.скОбластьНапоминания.Видимость = Ложь;
	Форма.скПолеHTMLНапоминаний 				  = "";
	ОбновитьТаблицуНапоминаний(Форма, CRM_НапоминанияСервер.ПолучитьНапоминания());
	
КонецПроцедуры

Процедура ПеренестиВсеНапоминания(Форма)
	
	СписокВариантов = CRM_РабочийСтолКлиентПовтИсп.СписокВариантовОтложенногоВремени();	
	Оповещение = Новый ОписаниеОповещения("ПеренестиВсеНапоминанияЗавершение", 
		ЭтотОбъект, Новый Структура("Форма", Форма));
		
	СписокВариантов.ПоказатьВыборЭлемента(Оповещение, НСтр("ru='Нажмите ""Отложить"", чтобы получить оповещение через';en='Click ""Snooze"" to get notified via'"));
			
КонецПроцедуры

// Переносит все напоминания завершение.
//
// Параметры:
//  Результат				 - Структура - Результат.
//  ДополнительныеПараметры	 - Структура - Дополнительные параметры.
//
Процедура ПеренестиВсеНапоминанияЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;	
	КонецЕсли;

	аэлемент = 0;
	
	Для Каждого Строка Из ДополнительныеПараметры.Форма.CRM_НастройкиРабочегоСтолаТаблицаНапоминаний Цикл
		СтруктураСтроки = CRM_НапоминанияКлиент.СформироватьКлючЗаписиПоСтроке(Строка);
		СтруктураНапоминания = CRM_РабочийСтолСервер.ПеренестиНапоминание(СтруктураСтроки, Результат.Значение, аэлемент);
		Если НЕ СтруктураНапоминания.Выбран Тогда
			аэлемент = аэлемент + 1; 
			ПоказатьПредупреждение(, НСтр("ru='Напоминание удалено или модифицировано!';en='The reminder is deleted or modified!'"));
			Продолжить;
		КонецЕсли;
		Если СтруктураНапоминания.ЭтоНапоминаниеОВходящихПисьмах Тогда
			БылиИзмененыОповещенияОВходящихПисьмах = Истина;
		КонецЕсли; 
		аэлемент = аэлемент + 1;
		
	КонецЦикла;
	
	ОбновитьТаблицуНапоминаний(ДополнительныеПараметры.Форма, CRM_НапоминанияСервер.ПолучитьНапоминания());
	
КонецПроцедуры

// Прекращает все напоминания.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма.
//  Команда	 - КомандаФормы	 - Команда.
//
Процедура КомандаНапоминанийПрекратитьВсе(Форма, Команда) Экспорт
	ПрекратитьВсеНапоминания(Форма);
КонецПроцедуры

// Переносит все напоминания.
//
// Параметры:
//   Форма	 - УправляемаяФорма - Форма.
//   Команда - КомандаФормы	 - Команда.
//
Процедура КомандаНапоминанийПеренестиВсе(Форма, Команда) Экспорт
	ПеренестиВсеНапоминания(Форма);
КонецПроцедуры

#КонецОбласти

#Область Заметки

Процедура СформироватьПанельЗаметок(Форма, ЗакрыватьПанель = Истина)
	Попытка
		ПоддерживаетРабочийСтол = Форма.ПоддерживаетРабочийСтол;
		Если Форма.Элементы.скОбластьЗаметки.Видимость И ЗакрыватьПанель Тогда
			Форма.Элементы.скОбластьЗаметки.Видимость = Ложь;
		Иначе	
			
			МассивЭлементов = CRM_РабочийСтолСервер.ЗаметкиПользователя();
			
			Форма.скПолеHTMLЗаметок = HTMLПредставлениеСпискаЗаметок(МассивЭлементов);	
			Форма.Элементы.скОбластьЗаметки.Видимость = Истина;
			//Форма.Элементы.CRM_ОткрытьЗаметки.Видимость = Не Форма.Элементы.скОбластьЗаметки.Видимость; 
			
			Форма.ТекущийЭлемент = Форма.Элементы.скПолеHTMLЗаметок;
		КонецЕсли;
	Исключение
	КонецПопытки;
КонецПроцедуры

// Скрывает заметки.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма.
//
Процедура СкрытьЗаметки(Форма) Экспорт
	
	Форма.Элементы.скОбластьЗаметки.Видимость = Ложь;
	Форма.Элементы.CRM_ОткрытьЗаметки.Видимость = Истина; 
	Форма.скПолеHTMLЗаметок 				  = "";
		
КонецПроцедуры

// Открывает форму всех заметок.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма.
//  Команда	 - КомандаФормы	 - Команда.
//
Процедура КомандаЗаметкиВсе(Форма, Команда) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеРедактированияЗаметок", 
		ЭтотОбъект, Новый Структура("Форма", Форма));
	
	ОткрытьФорму("Справочник.Заметки.Форма.ВсеЗаметки",, 
		Форма,
		Форма.УникальныйИдентификатор,,,
		Оповещение);	
	
КонецПроцедуры

// Добавляет заметки.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма.
//  Команда	 - КомандаФормы	 - Команда.
//
Процедура КомандаЗаметкиДобавить(Форма, Команда) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеРедактированияЗаметок", 
		ЭтотОбъект, Новый Структура("Форма", Форма));
		
	ОткрытьФорму("Справочник.Заметки.ФормаОбъекта",, 
		Форма,
		Форма.УникальныйИдентификатор,,, 
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);	
	
КонецПроцедуры

// Выполняет действия после редактирования заметок.
//
// Параметры:
//  Результат	 - Структура - Результат.
//  Контекст	 - ЛюбойТип - Контекст.
//
Процедура ПослеРедактированияЗаметок(Результат, Контекст) Экспорт
	СформироватьПанельЗаметок(Контекст.Форма, Ложь);	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ТумблерРабочегоСтолаПриИзменении(Форма, Элемент) Экспорт
	
	ИндексФормы = Число(СтрЗаменить(Элемент.Имя,"crm_КнопкаТумблера_",""));
	
	Если  Форма.CRM_НастройкиРабочегоСтола.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	ЭлементРабочегоСтола = Форма.CRM_НастройкиРабочегоСтола[ИндексФормы];	
	Если ск_глСтекФормРабочегоСтола = Неопределено Тогда
		ск_глСтекФормРабочегоСтола = Новый Соответствие;	
	КонецЕсли;
	
	ПолученнаяФорма = ск_глСтекФормРабочегоСтола.Получить(ЭлементРабочегоСтола.Идентификатор);
	Если ПолученнаяФорма <> Неопределено И НЕ ПолученнаяФорма.Открыта() Тогда
		#Если ВебКлиент Тогда
			ПолученнаяФорма = Неопределено;
			ск_глСтекФормРабочегоСтола.Удалить(ЭлементРабочегоСтола.Идентификатор);
		#Иначе
			Если ПолученнаяФорма.ИмяФормы = "Обработка.CRM_КалендарьМенеджера.Форма.Форма" Тогда
				СистемнаяИнформация = Новый СистемнаяИнформация();
				ВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
				
				Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияПлатформы, "8.3.14.0") < 0 Тогда
					ПолученнаяФорма = Неопределено;
					ск_глСтекФормРабочегоСтола.Удалить(ЭлементРабочегоСтола.Идентификатор);
				КонецЕсли;
			КонецЕсли;
		#КонецЕсли
	КонецЕсли;
	Если ПолученнаяФорма <> Неопределено Тогда
		СкопироватьСвойстваФормы(Форма, ПолученнаяФорма);
		
	Иначе
		ОбщиеПараметры = Новый Структура;
		ТаблицаНастроекРабочегоСтола = CRM_РабочийСтолСервер.ПолучитьТаблицуНастроекРабочегоСтола();
		ПараметрыФормы = Новый Структура("CRM_НастройкиРабочегоСтола, скОбщиеПараметры",
				ТаблицаНастроекРабочегоСтола, ОбщиеПараметры);
			
		Попытка
			Выполнить(ЭлементРабочегоСтола.Параметры);
		Исключение
		КонецПопытки;
		
		Попытка
			ПолученнаяФорма = ПолучитьФорму(ЭлементРабочегоСтола.ИмяФормы, ПараметрыФормы);
		Исключение
			ПолученнаяФорма = Неопределено;
		КонецПопытки;
		Если ПолученнаяФорма = Неопределено Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Форма """+ЭлементРабочегоСтола.Наименование+""" недоступна для использования.";
			СообщениеПользователю.Сообщить();
			Возврат;
		КонецЕсли;	
		ПолученнаяФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
		ПолученнаяФорма.Заголовок = ЭлементРабочегоСтола.Наименование; 
		ск_глСтекФормРабочегоСтола.Вставить(ЭлементРабочегоСтола.Идентификатор, ПолученнаяФорма);
		
	КонецЕсли;
	
	Для каждого ФормаРабочегоСтола из ск_глСтекФормРабочегоСтола Цикл
		Если ФормаРабочегоСтола.Значение = Форма Тогда
			//Форма.скТумблерРабочегоСтола = ФормаРабочегоСтола.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПолученнаяФорма.Открыта() Тогда
		ПолученнаяФорма.Активизировать();	
	Иначе	
		ПолученнаяФорма.Открыть();
	КонецЕсли;
	ОбработкаПриСменеВкладки(ПолученнаяФорма, ЭлементРабочегоСтола, CRM_НапоминанияСервер.ПолучитьНапоминания());
	
КонецПроцедуры

Процедура ВыборИзСпискаСкрытыхФорм(Форма, Элемент) Экспорт
	ЭлементыРабочегоСтола = CRM_РабочийСтолСервер.ПолучитьТаблицуСкрытыхНастроекРабочегоСтола();
	Если ЭлементыРабочегоСтола.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	ИндексФормы = Число(СтрЗаменить(Элемент.Имя,"crm_СкрытаяКнопкаТумблера_",""));
	Если ск_глСтекФормРабочегоСтола = Неопределено Тогда
		ск_глСтекФормРабочегоСтола = Новый Соответствие;	
	КонецЕсли;
	ЭлементРабочегоСтола = ЭлементыРабочегоСтола[ИндексФормы];
	ПолученнаяФорма = ск_глСтекФормРабочегоСтола.Получить(ЭлементРабочегоСтола.Идентификатор);
	Если ПолученнаяФорма <> Неопределено И НЕ ПолученнаяФорма.Открыта() Тогда
		#Если ВебКлиент Тогда
			ПолученнаяФорма = Неопределено;
			ск_глСтекФормРабочегоСтола.Удалить(ЭлементРабочегоСтола.Идентификатор);
		#КонецЕсли
	КонецЕсли;
	Если ПолученнаяФорма <> Неопределено Тогда
		СкопироватьСвойстваФормы(Форма, ПолученнаяФорма);
		
	Иначе
		ОбщиеПараметры = Новый Структура;
		ТаблицаНастроекРабочегоСтола = CRM_РабочийСтолСервер.ПолучитьТаблицуНастроекРабочегоСтола();
		ПараметрыФормы = Новый Структура("CRM_НастройкиРабочегоСтола, скОбщиеПараметры",
		ТаблицаНастроекРабочегоСтола, ОбщиеПараметры);
		
		Попытка
			Выполнить(ЭлементРабочегоСтола.Параметры);
		Исключение
		КонецПопытки;
		
		Попытка
			ПолученнаяФорма = ПолучитьФорму(ЭлементРабочегоСтола.ИмяФормы, ПараметрыФормы);
		Исключение
			ПолученнаяФорма = Неопределено;
		КонецПопытки;
		Если ПолученнаяФорма = Неопределено Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Форма """+ЭлементРабочегоСтола.Наименование+""" недоступна для использования.";
			СообщениеПользователю.Сообщить();
			Возврат;
		КонецЕсли;	
		ПолученнаяФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
		ПолученнаяФорма.Заголовок = ЭлементРабочегоСтола.Наименование; 
		ск_глСтекФормРабочегоСтола.Вставить(ЭлементРабочегоСтола.Идентификатор, ПолученнаяФорма);
		
	КонецЕсли;
	
	Для каждого ФормаРабочегоСтола из ск_глСтекФормРабочегоСтола Цикл
		Если ФормаРабочегоСтола.Значение = Форма Тогда
			//Форма.скТумблерРабочегоСтола = ФормаРабочегоСтола.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПолученнаяФорма.Открыта() Тогда
		ПолученнаяФорма.Активизировать();	
	Иначе	
		ПолученнаяФорма.Открыть();
	КонецЕсли;
	ЭлементКнопка = ПолученнаяФорма.Элементы.Найти("ЭлементГруппаКнопокПодменю");
	Если ЭлементКнопка <> Неопределено Тогда
		ЭлементКнопка.Заголовок = ЭлементРабочегоСтола.Наименование;
		#Если НЕ ВебКлиент Тогда
			ЭлементКнопка.ЦветФона = Новый Цвет(0, 160, 242);
		#КонецЕсли
		ЭлементКнопка = ПолученнаяФорма.Элементы[Элемент.Имя];
		ЭлементКнопка.Пометка = Истина;
	КонецЕсли;
	ОбработкаПриСменеВкладки(ПолученнаяФорма, ЭлементРабочегоСтола, CRM_НапоминанияСервер.ПолучитьНапоминания());
КонецПроцедуры


Процедура ОткрытьФормуНастроек(Форма, Элемент) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.CRM_НастройкиРабочегоСтола");
	
КонецПроцедуры

Процедура ОткрытьФормуПоддержки(Форма, Элемент) Экспорт
	
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ИнформационныйЦентр");
	
КонецПроцедуры


Процедура СкопироватьСвойстваФормы(ФормаИсточник, ФормаПриемник)

	//МассивИменЭлементовВидимости = Новый Массив;	
	//МассивИменЭлементовВидимости.Добавить("скОбластьНапоминания");
	//МассивИменЭлементовВидимости.Добавить("CRM_ОткрытьЗаметки");
	//МассивИменЭлементовВидимости.Добавить("скОбластьЗаметки");
	//Для каждого ИмяЭлементаВидимости Из МассивИменЭлементовВидимости Цикл
	//	ФормаПриемник.Элементы[ИмяЭлементаВидимости].Видимость = ФормаИсточник.Элементы[ИмяЭлементаВидимости].Видимость;
	//
	//КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПриСменеВкладки(Форма, ЭлементРабочегоСтола, МассивНапоминаний = Неопределено) Экспорт
	
	ск_глТекущийИдентификатор    = ЭлементРабочегоСтола.Идентификатор;
	//Форма.скТумблерРабочегоСтола = ЭлементРабочегоСтола.Идентификатор;
	
	Обновить(Форма, МассивНапоминаний);
	
КонецПроцедуры // ОбработкаПриСменеВкладки()

Процедура Обновить(Форма, МассивНапоминаний)
	
	//Напоминания
	Если МассивНапоминаний <> Неопределено И Форма.Элементы.Найти("скПолеHTMLНапоминаний")<>Неопределено Тогда
		ОбновитьТаблицуНапоминаний(Форма, МассивНапоминаний);
	КонецЕсли; 
	
	//Заметки
	Если Форма.Элементы.скОбластьЗаметки.Видимость Тогда
		СформироватьПанельЗаметок(Форма);	
	
	КонецЕсли;
	
КонецПроцедуры


#Область ВспомогательныеПроцедурыФункции

#Область Напоминания

// Вызов заблокирован.

//Процедура ПолучитьФормуОткрытьПредмет(ТекущийПредмет)
//	
//	ИмяОбъектаМетаданных				= CRM_РабочийСтолСервер.ПолучитьИмяОбъектаМетаданныхДляОткрытияФормы(ТекущийПредмет);
//	ИмяОсновнойФормыОбъектаМетаданных	= CRM_РабочийСтолСервер.ПолучитьИмяОсновнойФормыОбъектаМетаданных(ТекущийПредмет);
//	Если ЗначениеЗаполнено(ИмяОсновнойФормыОбъектаМетаданных) Тогда
//		Если ТипЗнч(ТекущийПредмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
//			Если CRM_РабочийСтолСервер.ЭтоЛичнаяЗадача(ТекущийПредмет) Тогда
//				ФормаОбъектаМетаданных = ПолучитьФорму(ИмяОбъектаМетаданных + ".Форма.CRM_ФормаЛичнойЗадачи", Новый Структура("Ключ", ТекущийПредмет));
//			Иначе
//				Если CRM_РабочийСтолСервер.ЭтоНезависимыйПроцесс(ТекущийПредмет) Тогда
//					ФормаОбъектаМетаданных = ПолучитьФорму("БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаЗадачиНезависимыйПроцесс", Новый Структура("Ключ", ТекущийПредмет));
//				Иначе
//					ФормаОбъектаМетаданных = ПолучитьФорму("БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаЗадачи", Новый Структура("Ключ", ТекущийПредмет));
//				КонецЕсли;
//			КонецЕсли;
//		ИначеЕсли ТипЗнч(ТекущийПредмет) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
//			ФормаОбъектаМетаданных = ПолучитьФорму("Документ.ЭлектронноеПисьмоИсходящее.Форма.CRM_ФормаДокумента", 
//				Новый Структура("Ключ, ОткрытиеИзФормы", ТекущийПредмет, Истина),ЭтотОбъект);
//		ИначеЕсли ТипЗнч(ТекущийПредмет) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
//			ФормаОбъектаМетаданных = ПолучитьФорму("Документ.ЭлектронноеПисьмоВходящее.Форма.CRM_ФормаДокумента", 
//				Новый Структура("Ключ, ОткрытиеИзФормы", ТекущийПредмет, Истина),ЭтотОбъект);
//		ИначеЕсли ТипЗнч(ТекущийПредмет) = Тип("ДокументСсылка.CRM_Взаимодействие") Тогда
//			ПоказатьЗначение(, ТекущийПредмет); 
//			Возврат;
//		Иначе
//			ФормаОбъектаМетаданных = ПолучитьФорму(ИмяОбъектаМетаданных + ".Форма." + ИмяОсновнойФормыОбъектаМетаданных, Новый Структура("Ключ", ТекущийПредмет));
//		КонецЕсли;
//		
//		Если ФормаОбъектаМетаданных <> Неопределено Тогда
//			Если ФормаОбъектаМетаданных.Открыта() Тогда
//				ФормаОбъектаМетаданных.Активизировать();
//			Иначе
//				ФормаОбъектаМетаданных.Открыть();
//			КонецЕсли;
//		КонецЕсли;
//	Иначе
//		ПоказатьЗначение(, ТекущийПредмет); 
//	КонецЕсли;
//	
//КонецПроцедуры

Процедура ОткрытьМенеджерПочты(УчетнаяЗапись,ПерейтиКЧерновикам)

	ФормаПочтовогоМенеджера = ПолучитьФорму("Обработка.CRM_МенеджерПочты.Форма");
	
	ВидПапки = ?(ПерейтиКЧерновикам,ПредопределенноеЗначение("Перечисление.CRM_ВидыПапокЭлектроннойПочты.Черновики"),ПредопределенноеЗначение("Перечисление.CRM_ВидыПапокЭлектроннойПочты.Входящие"));
	
	Если ФормаПочтовогоМенеджера.Открыта() Тогда
		ФормаПочтовогоМенеджера.УстановитьПапкуВходящиеУчетнойЗаписи(УчетнаяЗапись, ВидПапки);
		ФормаПочтовогоМенеджера.Активизировать();
	Иначе
		ФормаПочтовогоМенеджера.УчетнаяЗаписьВыбранная	= УчетнаяЗапись;
		ФормаПочтовогоМенеджера.ВидПапкиВыбранный		= ВидПапки;
		ФормаПочтовогоМенеджера.Открыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область РаботаСHTML

#Область Напоминания

Функция HTMLПредставлениеСпискаНапоминаний(МассивЭлементовНапоминаний)
	
	HTMLТекст = "<html><body>";
	Для каждого ЭлементНапоминания Из МассивЭлементовНапоминаний Цикл
		HTMLТекст = HTMLТекст + 
		"<div class=block_1 style=""float: left; padding-right: 5px"">
		|" + ДобавитьКартинку(ЭлементНапоминания.Картинка) + "
		|</div>";
		
		HTMLТекст = HTMLТекст + 
		"<div class=block_2><font size=1 face=Arial>" + ЭлементНапоминания.СрокИсполнения + "</font>
		|</div>";
		
		HTMLТекст = HTMLТекст + 
		"<div class=block_2><b><font size=1 face=Arial>" + ЭлементНапоминания.ПредметПредставление + "</font></b>
		|</div>
		|<hr>";
		
		HTMLТекст = HTMLТекст + 
		"<div class=block_3><font size=1 face=Arial>" + ЭлементНапоминания.Содержание + "</font>
		|</div>
		|<hr>";
		
		HTMLТекст = HTMLТекст + 
		"<div class=block_4 align=right>";
		Если ЗначениеЗаполнено(ЭлементНапоминания.Предмет) Тогда
			HTMLТекст = HTMLТекст + "
			|" + ДобавитьКартинку(БиблиотекаКартинок.Найти) + "<a href=""Открыть_" + ЭлементНапоминания.Индекс + """><font size=1 face=Arial>Открыть</font></a>";
		
		КонецЕсли;
		HTMLТекст = HTMLТекст + "
		|" + ДобавитьКартинку(БиблиотекаКартинок.CRM_ВиджетыДинамикаНет) + "<a href=""Отложить_" + ЭлементНапоминания.Индекс + """><font size=1 face=Arial>Отложить</font></a> 
		|" + ДобавитьКартинку(БиблиотекаКартинок.ПиктограммаПоказателяПриемлемоеЗначение) + "<a href=""Завершить_" + ЭлементНапоминания.Индекс + """><font size=1 face=Arial>Завершить</font></a> 
		|</div>
		|<hr>";
		
	КонецЦикла;
	HTMLТекст = HTMLТекст + "</body></html>";
	
	Возврат HTMLТекст;
	
КонецФункции

Функция ПолеHTMLНапоминанийПриНажатии(Форма, Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
// Функция необходима для вычисления выражения в СофтФоне
	СтандартнаяОбработка = Ложь;
		
	МассивСсылки = СтрРазделить(ДанныеСобытия.Href, "/", Ложь);
	Если МассивСсылки.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИмяКоманды = МассивСсылки[МассивСсылки.ВГраница()];
	СтрокаТаблицы = Форма.CRM_НастройкиРабочегоСтолаТаблицаНапоминаний[ПолучитьИндексСтроки(ИмяКоманды)];
	Если СтрНайти(ИмяКоманды, "Открыть") > 0 Тогда
		ОткрытьПредметНапоминания(СтрокаТаблицы);	
		
	ИначеЕсли СтрНайти(ИмяКоманды, "Отложить") > 0 Тогда
		ПеренестиНапоминание(Форма, СтрокаТаблицы);
		
	ИначеЕсли СтрНайти(ИмяКоманды, "Завершить") > 0 Тогда
		ПрекратитьНапоминание(Форма, СтрокаТаблицы);
		
	КонецЕсли;
	Оповестить("ОбновитьНапоминания", Новый Структура("ОткрыватьАктивизироватьФормуНапоминаний", Ложь));
	
	Возврат Истина;
КонецФункции

Функция ПолучитьИндексСтроки(ИмяКоманды)

	МассивИмени = СтрРазделить(ИмяКоманды, "_", Ложь);
	Возврат Число(МассивИмени[МассивИмени.ВГраница()]);

КонецФункции // ПолучитьИндексСтроки()

#КонецОбласти

#Область Заметки

Функция СтильЗаметокHTML()
	
	Возврат
		"<style type=""text/css"">
		|.wrapper_red{
		|border: 1px solid grey;
		|text-decoration:none;
		|color:#000;
		|background:#F78181;
		|display:block;
		|height:3.4em;
		|padding:10px;
		|overflow: hidden;
		|text-overflow:ellipsis;
		|margin:10px;
		|}
		|.wrapper_orange{
		|border: 1px solid grey;
		|text-decoration:none;
		|color:#000;
		|background:#FAAC58;
		|display:block;
		|height:3.4em;
		|padding:10px;
		|overflow: hidden;
		|text-overflow:ellipsis;
		|margin:10px;
		|}
		|.wrapper_yellow{
		|border: 1px solid grey;
		|text-decoration:none;
		|color:#000;
		|background:#F4FA58;
		|display:block;
		|height:3.4em;
		|padding:10px;
		|overflow: hidden;
		|text-overflow:ellipsis;
		|margin:10px;
		|}
		|.wrapper_green{
		|border: 1px solid grey;
		|text-decoration:none;
		|color:#000;
		|background:#40FF00;
		|display:block;
		|height:3.4em;
		|padding:10px;
		|overflow: hidden;
		|text-overflow:ellipsis;
		|margin:10px;
		|}
		|.wrapper_lightblue{
		|border: 1px solid grey;
		|text-decoration:none;
		|color:#000;
		|background:#81BEF7;
		|display:block;
		|height:3.4em;
		|padding:10px;
		|overflow: hidden;
		|text-overflow:ellipsis;
		|margin:10px;
		|}
		|.wrapper_blue{
		|border: 1px solid grey;
		|text-decoration:none;
		|color:#000;
		|background:#5858FA;
		|display:block;
		|height:3.4em;
		|padding:10px;
		|overflow: hidden;
		|text-overflow:ellipsis;
		|margin:10px;
		|}
		|.wrapper_violet{
		|border: 1px solid grey;
		|text-decoration:none;
		|color:#000;
		|background:#9A2EFE;
		|display:block;
		|height:3.4em;
		|padding:10px;
		|overflow: hidden;
		|text-overflow:ellipsis;
		|margin:10px;
		|}
		|a{ 
		|text-decoration:none;
		|color:#000;
		|} 
		|p{
		|font-size:70%;
		|font-style:normal;
		|text-align:justify;
		|font-family:sans-serif, arial;
		|}
		|.button{
		|display: block;
		|align:right;
		|position:relative;
		|}
		|</style>";
		
КонецФункции

Функция HTMLПредставлениеСпискаЗаметок(МассивЭлементовЗаметок)
	
	HTMLТекст = "<html><body>" + СтильЗаметокHTML();	
	Если МассивЭлементовЗаметок.Количество() = 0 Тогда
		HTMLТекст = HTMLТекст + 		
		"<div class=textcentr>нет заметок</div>";
	Иначе	
		Для каждого ЭлементНапоминания Из МассивЭлементовЗаметок Цикл
			HTMLТекст = HTMLТекст + 		
			"<div class=wrapper_" + ЭлементНапоминания.ЦветСтиля + ">
			|<div class=button>
			|<a href=""Скрыть_" + ЭлементНапоминания.ИдентификаторСсылки + """>" + ДобавитьКартинку(БиблиотекаКартинок.Очистить, "right") + "</a>  
			|</div>
			|<a href=""Открыть_" + ЭлементНапоминания.ИдентификаторСсылки + """>
			|<p>" + ЭлементНапоминания.ТекстСодержания +"</p>
			|</a>
			|</div>";
			
		КонецЦикла;
		
	КонецЕсли;
	HTMLТекст = HTMLТекст + "</body></html>";
	
	Возврат HTMLТекст;
	
КонецФункции

Функция ПолеHTMLЗаметокПриНажатии(Форма, Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
// Функция необходима для вычисления выражения в СофтФоне
	МассивСсылки = СтрРазделить(ДанныеСобытия.Href, "/", Ложь);
	Если МассивСсылки.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ИмяКоманды = МассивСсылки[МассивСсылки.ВГраница()];
	МассивКоманды = СтрРазделить(ИмяКоманды, "_", Ложь);
	Если СтрНайти(ИмяКоманды, "Скрыть") > 0 Тогда
		Если CRM_РабочийСтолСервер.СкрытьЭлементЗаметки(МассивКоманды[МассивКоманды.ВГраница()]) Тогда
			СформироватьПанельЗаметок(Форма);
		
		КонецЕсли;
		
	ИначеЕсли СтрНайти(ИмяКоманды, "Открыть") > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеРедактированияЗаметок", 
			ЭтотОбъект, Новый Структура("Форма", Форма));
			
		ОткрытьФорму("Справочник.Заметки.ФормаОбъекта", 
			Новый Структура("Ключ", CRM_РабочийСтолСервер.СсылкаЭлемента(МассивКоманды[МассивКоманды.ВГраница()], "Справочник.Заметки")), 
			Форма,
			Форма.УникальныйИдентификатор,,, 
			Оповещение,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
		);	
		
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

#КонецОбласти

Функция ДобавитьКартинку(Картинка, Положение = "middle", Ссылка = "") Экспорт
	
	HTMLТекст = "";
	
	#Если ВебКлиент Тогда
		СтруктураДанныхКартинки = CRM_РабочийСтолСервер.ПолучитьBase64ДанныеКартинки(Картинка);	
	#Иначе
		ДвоичныеДанныеКартинки = Картинка.ПолучитьДвоичныеДанные();
		Base64ДанныеКартинки = Base64Строка(ДвоичныеДанныеКартинки);
		СтруктураДанныхКартинки = Новый Структура("Base64ДанныеКартинки, Формат", Base64ДанныеКартинки, Картинка.Формат());
	#КонецЕсли
	Если ЗначениеЗаполнено(Ссылка) Тогда
		HTMLТекст = HTMLТекст + "<a href=" + Ссылка + ">";
	КонецЕсли;
	
	HTMLТекст = HTMLТекст
		+ "<img border=0 src='data:image/"
		+ СтруктураДанныхКартинки.Формат
		+ ";base64,"
		+ СтруктураДанныхКартинки.Base64ДанныеКартинки + "' align="+ Положение + ">";
		
	Если ЗначениеЗаполнено(Ссылка) Тогда
		HTMLТекст = HTMLТекст + "</a>";
	КонецЕсли;
	
	Возврат HTMLТекст;
	
КонецФункции

#КонецОбласти

Процедура ВопросОткрытьНастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Пользователь", Пользователь);
		ОткрытьФорму("ОбщаяФорма.CRM_НастройкиРабочегоСтола", СтруктураПараметров);
	КонецЕсли;	
КонецПроцедуры	

Процедура ИнициализироватьРабочийСтолКлиент(ОткрытьФорму=Неопределено, ПараметрыФормы = Неопределено) Экспорт
	Перем ПерваяФорма;
	
	Если НЕ CRM_ЛицензированиеСервер.РабочийСтолCRMИспользуется() Тогда
		Возврат;
	КонецЕсли;	
	ЭлементыРабочегоСтола = CRM_РабочийСтолСервер.ПолучитьТаблицуНастроекРабочегоСтола(Истина);
	Если ЭлементыРабочегоСтола.Количество() = 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОткрытьНастройкиЗавершение", ЭтотОбъект, Новый Структура); 
		ПоказатьВопрос(ОписаниеОповещения, "Отсутствуют настройки рабочего стола.
		|Открыть настройки ?", РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;	
	ОткрытыеОкна = ПолучитьОкна(); // получим список открытых окон для проверки.
	Для Каждого ОткрытоеОкно Из ОткрытыеОкна Цикл
		Для Каждого ОткрытаяФорма Из ОткрытоеОкно.Содержимое Цикл
			Для Каждого ОткрываемыеОкна Из ЭлементыРабочегоСтола Цикл
				#Если ВебКлиент Тогда
					Если ОткрытаяФорма.ИмяФормы = ОткрываемыеОкна.ИмяФормы И НЕ ОткрытоеОкно.НачальнаяСтраница Тогда
						ОткрытаяФорма.Закрыть();	
					КонецЕсли;	
				#Иначе
					Если ОткрытаяФорма.ИмяФормы = ОткрываемыеОкна.ИмяФормы Тогда
						ОткрытаяФорма.Закрыть();	
					КонецЕсли;
				#КонецЕсли
			КонецЦикла;
		КонецЦикла;	
	КонецЦикла;
	
	ОбщиеПараметры = Новый Структура;
		
	ЭлементыРабочегоСтола = CRM_РабочийСтолСервер.ПолучитьТаблицуНастроекРабочегоСтола();
	
	Если ск_глСтекФормРабочегоСтола = Неопределено Тогда
		ск_глСтекФормРабочегоСтола = Новый Соответствие;	
	КонецЕсли;
	
	Для каждого ЭлементРабочегоСтола Из ЭлементыРабочегоСтола Цикл
		Если ЗначениеЗаполнено(ОткрытьФорму) И ЭлементРабочегоСтола.ИмяФормы<>ОткрытьФорму Тогда
			Продолжить;
		КонецЕсли;
		Если Не CRM_РабочийСтолСервер.ФормаДоступнаПоФункциональнымОпциям(ЭлементРабочегоСтола.ИмяФормы) Тогда
			Продолжить;
		КонецЕсли;
		
		Форма = ск_глСтекФормРабочегоСтола.Получить(ЭлементРабочегоСтола.Идентификатор);
		Если Форма = Неопределено Тогда		
			Если ПараметрыФормы = Неопределено Тогда
				ПараметрыФормы = Новый Структура;
			КонецЕсли;
			ПараметрыФормы.Вставить("CRM_НастройкиРабочегоСтола", ЭлементыРабочегоСтола);
			ПараметрыФормы.Вставить("скОбщиеПараметры", ОбщиеПараметры);
			
			Попытка
				Выполнить(ЭлементРабочегоСтола.Параметры);
			Исключение
			КонецПопытки;
			
			Попытка
				Форма = ПолучитьФорму(ЭлементРабочегоСтола.ИмяФормы, ПараметрыФормы);
			Исключение
				Форма = Неопределено;
			КонецПопытки;
			Если Форма = Неопределено Тогда
				СообщениеПользователю = Новый СообщениеПользователю;
				СообщениеПользователю.Текст = "Форма """+ЭлементРабочегоСтола.Наименование+""" недоступна для использования.";
				СообщениеПользователю.Сообщить();
				Продолжить;
			КонецЕсли;	
			Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
			Форма.Заголовок = ЭлементРабочегоСтола.Наименование; 
			ск_глСтекФормРабочегоСтола.Вставить(ЭлементРабочегоСтола.Идентификатор, Форма);
			
			CRM_РабочийСтолКлиент.ОбработкаПриСменеВкладки(Форма, ЭлементРабочегоСтола);
			
		КонецЕсли;
		ПерваяФорма = Форма;
		
		Прервать;
		
	КонецЦикла;  
	Если ПерваяФорма<>Неопределено Тогда
		ПерваяФорма.Открыть();
		Если ПерваяФорма.Открыта() И ПерваяФорма.Элементы.Найти("скПолеHTMLНапоминаний")<>Неопределено Тогда
			CRM_РабочийСтолКлиент.ОбновитьТаблицуНапоминаний(ПерваяФорма, CRM_НапоминанияСервер.ПолучитьНапоминания());
		КонецЕсли;
		ОткрытыеОкна = ПолучитьОкна(); // получим список открытых окон для проверки.
		Для Каждого ОткрытоеОкно Из ОткрытыеОкна Цикл
			Для Каждого ОткрытаяФорма Из ОткрытоеОкно.Содержимое Цикл
				Для Каждого ОткрываемыеОкна Из ЭлементыРабочегоСтола Цикл
					Если ОткрытаяФорма.ИмяФормы = ПерваяФорма.ИмяФормы Тогда
						ОткрытаяФорма.Активизировать();	
					КонецЕсли;	
				КонецЦикла;
			КонецЦикла;	
		КонецЦикла;
	КонецЕсли;
	
	
КонецПроцедуры // ИнициализироватьРабочийСтолКлиент()

Функция ПереинициализироватьРабочийСтолКлиент(ОткрытьФорму=Неопределено, ПараметрыФормы=Неопределено) Экспорт
// Функция необходима для вычисления выражения в СофтФоне
	Если ск_глСтекФормРабочегоСтола <> Неопределено Тогда
		Для Каждого Элемент Из ск_глСтекФормРабочегоСтола Цикл
			Если Элемент.Значение.Открыта() Тогда
				Элемент.Значение.Закрыть();
			КонецЕсли;	
		КонецЦикла;
		ск_глСтекФормРабочегоСтола = Неопределено;

	КонецЕсли;
	ОбновитьИнтерфейс();
	CRM_РабочийСтолКлиент.ИнициализироватьРабочийСтолКлиент(ОткрытьФорму, ПараметрыФормы);
	
	Возврат Истина;
КонецФункции
#КонецОбласти
