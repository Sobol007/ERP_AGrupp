#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми.
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",    Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	
	Возврат Результат;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	// Структура отчета.
	Структура = КомпоновщикНастроек.Настройки;
	
	// Устанавливаем параметры.
	БухгалтерскиеОтчетыВызовСервера.УстановитьПараметрОрганизация(КомпоновщикНастроек, ПараметрыОтчета.Организация);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Аналитика", ПараметрыОтчета.Детализация);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ПараметрыОтчета.НачалоПериода);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", ПараметрыОтчета.КонецПериода);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаГраница", Новый Граница(ПараметрыОтчета.НачалоПериода, ВидГраницы.Включая));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаГраница", Новый Граница(ПараметрыОтчета.КонецПериода, ВидГраницы.Включая));
	
	// Устанавливаем параметры вывода.
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "РасположениеИтогов", РасположениеИтоговКомпоновкиДанных.Начало);	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВертикальноеРасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Начало);	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьПараметрыДанных", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);	
				
	// Очищаем структуру отчета, чтобы сформировать ее исходя полученных настроек.
	Структура.Структура.Очистить();
	
	МассивОтборовГруппировок = Новый Массив();
	
	ЕстьГруппировки = Ложь;
	
	Группировка = ПараметрыОтчета.Группировка;
	
	// Добавляем группировки.
	Для Каждого ПолеВыбраннойГруппировки Из Группировка Цикл 
		
		Если ПолеВыбраннойГруппировки.Использование Тогда
			
			Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			// В отличии от обычных отчетов, в расшифровке мы хотим видеть итоги сверху.
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "РасположениеИтогов", РасположениеИтоговКомпоновкиДанных.Начало);	
			
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);	
			
			// Добавим группу или в отбор группировки, дальше в эту группу будут добавлены элементы.
			ГруппаОтборов = Структура.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
			ГруппаОтборов.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			МассивОтборовГруппировок.Добавить(ГруппаОтборов);			
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Структура.Отбор, ПолеГруппировки.Поле, "", ВидСравненияКомпоновкиДанных.Заполнено);
			
			ЕстьГруппировки = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// В конце добавляем детальную группировку
	// включим ее при необходимости.
	Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);	
	
	// Если про обходе выбранных полей обнаружатся поля не ресурсы и не группировки то нужно будет включить детальную группировку.
	Структура.Использование = НЕ ЕстьГруппировки;
	
	ГруппаОтборов = Структура.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	ГруппаОтборов.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	// Из доступных полей узнаем:
	// - можно ли использовать это поле (в данной конфигурации настроек);
	// - является ли выбранное поле ресурсом.
	ДоступныеПоля = КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.Элементы;
	
	Для Каждого Поле Из КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
		
		Если Поле.Использование Тогда
			
			СвойстваПоля = ДоступныеПоля.Найти(Поле.Поле);
			
			Если СвойстваПоля <> Неопределено Тогда
				
				Если СвойстваПоля.Ресурс Тогда
					
					// Добавим отбор во все группировки.
					// Нулевые значения ресурсов не выводим.
					Для каждого Отбор Из МассивОтборовГруппировок Цикл
						
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, Поле.Поле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
						
					КонецЦикла;
					
				Иначе
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, Поле.Поле, 0, ВидСравненияКомпоновкиДанных.Заполнено);
					
					// Если в отчете есть не только ресурсы, но и поля не вошедшие в группировки то нужно включить детальную группировку.
					ГруппировочноеПоле = Группировка.Найти(Строка(Поле.Поле), "Поле");
					
					Если ГруппировочноеПоле = Неопределено Или НЕ ГруппировочноеПоле.Использование Тогда
						
						Структура.Использование = Истина;
						
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

// В процедуре можно уточнить особенности вывода данных в отчет.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	// Найдем в макете итоговую ячейку.
	ИмяМакетаШапки = МакетКомпоновки.Тело[МакетКомпоновки.Тело.Количество() - 1].МакетШапки;
	
	МакетШапки = МакетКомпоновки.Макеты.Найти(ИмяМакетаШапки);
	
	Если МакетШапки <> Неопределено Тогда
		
		ЯчейкаИтогов = МакетШапки.Макет[0].Ячейки[0];
		
		// Установим свой текст.
		ЯчейкаИтогов.Элементы[0].Значение = "Всего";
		
		// Зададим минимальную ширину ячейки - 50.
		МинимальнаяШиринаЯчейки = ЯчейкаИтогов.Оформление.Элементы.Найти("МинимальнаяШирина");
		
		Если МинимальнаяШиринаЯчейки <> Неопределено Тогда
			
			МинимальнаяШиринаЯчейки.Значение = 50;
			МинимальнаяШиринаЯчейки.Использование = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает данные внешних наборов для отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//
// Возвращаемое значение:
//	Структура - Ключ содержит имя внешнего набора, значение - таблицу с данными.
//
Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ВнешниеНаборыДанных = Новый Структура();	
	
	ЗаполнениеФормСтатистики.ПодготовитьВнешниеДанные(МакетКомпоновки, ВнешниеНаборыДанных);
	
	Возврат ВнешниеНаборыДанных;

КонецФункции	

// Заполняет параметры расшифровки ячейки отчета.
//
// Параметры:
//	Адрес - Строка - Адрес временного хранилища с данными расшифровки отчета.
//	Расшифровка - Произвольный - Значения полей расшифровки.
//	ПараметрыРасшифровки - Структура - Коллекция параметров расшифровки, которую требуется заполнить. 
//		Подробнее см. БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки().
//
Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список пунктов меню.
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Заполним структуру полей которые мы хотим получить из данных расшифровки.
	СтруктураПолей = Новый Структура();
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	// Расшифровываться могут и настройки.
	// Для расшифровки настроек нужно знать ОбъектНаблюдения и Аналитику.
	СтруктураПолей.Вставить("ОбъектНаблюдения");
	СтруктураПолей.Вставить("Аналитика");
	
	// Укажем что открывать объект сразу не нужно.
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	КонецЕсли;
	
	// Прежде всего интересны данные группировочных полей.
	Для Каждого Группировка Из ДанныеОтчета.Объект.Группировка Цикл
		СтруктураПолей.Вставить(Группировка.Поле);	
	КонецЦикла;
	
	// Получаем структуру полей доступных в расшифровке.
	Данные_Расшифровки = ПолучитьДанныеРасшифровки(ДанныеОтчета.ДанныеРасшифровки, СтруктураПолей, Расшифровка);
	
	// Если задан объект наблюдения то это настройки.
	Если Данные_Расшифровки.Свойство("ОбъектНаблюдения") Тогда //Откроем редактирование настроек для этого объекта.
		
		// Если доступна и аналитика, то откроем настройки для конкретной аналитики.
		Если Данные_Расшифровки.Свойство("Аналитика") И ЗначениеЗаполнено(Данные_Расшифровки.Аналитика) Тогда
			
			// Подготавливаем параметры для конструктора ключа записи регистра сведений.
			ОписаниеПоказателя = Новый Структура;
			ОписаниеПоказателя.Вставить("Организация",      ДанныеОтчета.Объект.Организация);
			ОписаниеПоказателя.Вставить("ОбъектНаблюдения", Данные_Расшифровки.ОбъектНаблюдения);
			ОписаниеПоказателя.Вставить("ДетализацияОбъектаНаблюдения", Данные_Расшифровки.Аналитика);
			
			ПараметрыКонструктора = Новый Массив;
			ПараметрыКонструктора.Добавить(ОписаниеПоказателя);
			
			// Создаем ключ записи.
			КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.НастройкаЗаполненияСвободныхСтрокФормСтатистики", ПараметрыКонструктора);
			
			// Создаем параметры открытия формы регистра сведений с настройками.
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
			
			// Помещаем параметры открытия формы в параметры расшифровки.
			ПараметрыРасшифровки.Вставить("ОткрытьФорму", Истина);
			ПараметрыРасшифровки.Вставить("Форма", "РегистрСведений.НастройкаЗаполненияСвободныхСтрокФормСтатистики.ФормаЗаписи");
			ПараметрыРасшифровки.Вставить("ПараметрыФормы", ПараметрыФормы);
			
		Иначе
			
			// Подготавливаем параметры для конструктора ключа записи регистра сведений.
			ОписаниеПоказателя = Новый Структура;
			ОписаниеПоказателя.Вставить("Организация",      ДанныеОтчета.Объект.Организация);
			ОписаниеПоказателя.Вставить("ОбъектНаблюдения", Данные_Расшифровки.ОбъектНаблюдения);
			
			ПараметрыКонструктора = Новый Массив;
			ПараметрыКонструктора.Добавить(ОписаниеПоказателя);
			
			// Создаем ключ записи.
			КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.НастройкаЗаполненияФормСтатистики", ПараметрыКонструктора);
			
			// Создаем параметры открытия формы регистра сведений с настройками.
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
			
			// Помещаем параметры открытия формы в параметры расшифровки.
			ПараметрыРасшифровки.Вставить("ОткрытьФорму", Истина);
			ПараметрыРасшифровки.Вставить("Форма", "РегистрСведений.НастройкаЗаполненияФормСтатистики.ФормаЗаписи");
			ПараметрыРасшифровки.Вставить("ПараметрыФормы", ПараметрыФормы);
			
		КонецЕсли;
		
		// Расшифровывается отчет.
	ИначеЕсли Данные_Расшифровки.Количество() > 0 Тогда
		
		// Инициализируем параметры расшифровки.
		НастройкиРасшифровки = Новый Структура();
		
		// Создаем 2 комплекта пользовательских настроек:
		// ПользовательскиеНастройкиДляСчета 	- для отчетов построенных по счету (ОСВ по счету и Анализ счета);
		// ПользовательскиеНастройкиДляСубконто - для отчетов построенных по субконто (Анализ субконто и Карточка субконто).
		// 2 комплекта нужно потому что отчеты по счету в качестве указателя на субконто используют 
		// номер субконто как он задан у конкретного счета, например: Договоры это Субконто2 счета 60
		// отчеты по субконто, используют номер субконто по порядку в таблице СписокВидовСубконто.
		// Например: Договор это Субконто1 если в СписокВидовСубконто первой строкой стоит Вид субконто Договоры.
		ПользовательскиеНастройкиДляСчета 		= НовыйПользовательскиеНастройки(ДанныеОтчета);	
		ПользовательскиеНастройкиДляСубконто 	= НовыйПользовательскиеНастройки(ДанныеОтчета);	
		
		// В дополнительные свойства пользовательских настроек будут помещены Группировка и СписокВидовСубконто.
		ДополнительныеСвойстваДляСчета 			= ПользовательскиеНастройкиДляСчета.ДополнительныеСвойства;	
		ДополнительныеСвойстваДляСубконто 		= ПользовательскиеНастройкиДляСубконто.ДополнительныеСвойства;	
		
		// Инициализируем отборы.
		ПользовательскиеОтборыДляСчета = ПользовательскиеНастройкиДляСчета.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
		ПользовательскиеОтборыДляСчета.ИдентификаторПользовательскойНастройки = "Отбор";
		
		ПользовательскиеОтборыДляСубконто = ПользовательскиеНастройкиДляСубконто.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
		ПользовательскиеОтборыДляСубконто.ИдентификаторПользовательскойНастройки = "Отбор";
		
		Счет = Неопределено;
		ЕстьСчет = Ложь;
		
		// Ищем счет.
		Если Данные_Расшифровки.Свойство("Счет") И ЗначениеЗаполнено(Данные_Расшифровки.Счет) Тогда
			
			// Если есть данные счета, добавляем в открывающееся меню выбор отчетов по счету.
			Счет = Данные_Расшифровки.Счет;
			СписокПунктовМеню.Добавить("ОборотноСальдоваяВедомостьПоСчету", СтрШаблон(НСтр("ru = 'ОСВ по счету %1';
																							|en = 'Trial balance on %1 account'"), Счет));
			НастройкиРасшифровки.Вставить("ОборотноСальдоваяВедомостьПоСчету", ПользовательскиеНастройкиДляСчета);
			СписокПунктовМеню.Добавить("КарточкаСчета", СтрШаблон(НСтр("ru = 'Карточка счета %1';
																		|en = 'Account card %1'"), Счет));
			НастройкиРасшифровки.Вставить("КарточкаСчета", ПользовательскиеНастройкиДляСчета);
			
			ЕстьСчет = Истина;
			СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
			ДополнительныеСвойстваДляСчета.Вставить("Счет", Счет);
			
		КонецЕсли;	
		
		// Инициализируем настройки субконто.
		СписокВидовСубконто = Новый СписокЗначений();
		
		// Группировка передается в отчет как массив структур.
		// Элемент массива содержит структуру описывающую строку таблицы "Группировка" стандартного отчета.
		МассивГруппировокДляСчета = Новый Массив();
		МассивГруппировокДляСубконто = Новый Массив();
		
		Для Каждого Поле Из Данные_Расшифровки Цикл
			
			// Перебираем поля расшифровки в поисках субконто счета.
			Если Поле.Ключ <> "Счет" И ЕстьСчет Тогда
				Для НомерСубконто = 1 По СвойстваСчета.КоличествоСубконто Цикл
					ВидСубконто = СвойстваСчета["ВидСубконто" + НомерСубконто];
					Если ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(Поле.Значение)) Тогда
						
						// Поле расшифровки является субконто счета.
						// В отчеты по счету добавляем отбор по субконто.
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборыДляСчета, "Субконто" + НомерСубконто, Поле.Значение, ВидСравненияКомпоновкиДанных.Равно);
						// Добавляем группировку по субконто.
						
						Группировка = Новый Структура();
						Группировка.Вставить("Поле",           "Субконто" + НомерСубконто);
						Группировка.Вставить("Представление",  ВидСубконто.Наименование);
						Группировка.Вставить("Использование",  Истина);
						Группировка.Вставить("ТипГруппировки", 0);

						МассивГруппировокДляСчета.Добавить(Группировка);
						
						// Для отчетов по субконто добавляем Вид субконто в СписокВидовСубконто.
						СписокВидовСубконто.Добавить(ВидСубконто, ВидСубконто.Наименование);
						НомерСубконтоПоПорядку = СписокВидовСубконто.Количество();
						// Добавляем отбор и группировку по счету и по этому субконто.
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборыДляСубконто, "Счет", Счет, ВидСравненияКомпоновкиДанных.ВИерархии);
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборыДляСубконто, "Субконто" + НомерСубконтоПоПорядку, Поле.Значение, ВидСравненияКомпоновкиДанных.Равно);
						
						Группировка = Новый Структура();
						Группировка.Вставить("Поле",           "Субконто" + НомерСубконтоПоПорядку);
						Группировка.Вставить("Представление",  ВидСубконто.Наименование);
						Группировка.Вставить("Использование",  Истина);
						Группировка.Вставить("ТипГруппировки", 0);

						МассивГруппировокДляСубконто.Добавить(Группировка);
						
					КонецЕсли;
					
				КонецЦикла; // Для НомерСубконто = 1 По СвойстваСчета.КоличествоСубконто.
				
			КонецЕсли;	
			
		КонецЦикла;	 // Для Каждого Поле Из Данные_Расшифровки.
		
		Если Данные_Расшифровки.Количество() > 0 Тогда
			
			Если НЕ ЕстьСчет Тогда
				// Если не нашлось данных для открытия отчетов
				//  но данные есть, просто откроем значение.
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
			КонецЕсли;
			
			// Добавляем пункт "Открыть значение".
			СписокПунктовМеню.Добавить(Поле.Значение, "Открыть " + Поле.Значение);
			
			// Упаковываем параметры расшифровки.
			ПараметрыРасшифровки.Вставить("Значение",  Поле.Значение);
			
		КонецЕсли;
		
		// Если есть субконто то:
		// в отчеты добавляем описание группировок и видов субконто,
		// добавляем в список выбора отчеты по субконто.
		Если МассивГруппировокДляСчета.Количество() > 0 Тогда
			
			// Добавляем описание группировок в дополнительные свойства отчетов.
			ДополнительныеСвойстваДляСчета.Вставить("Группировка", МассивГруппировокДляСчета);
			ДополнительныеСвойстваДляСубконто.Вставить("Группировка", МассивГруппировокДляСубконто);
			ДополнительныеСвойстваДляСубконто.Вставить("СписокВидовСубконто", СписокВидовСубконто);
			
			// Получаем представление видов субконто, чтобы показать пользователю.
			ПредставлениеВидовСубконто = СтрСоединить(СписокВидовСубконто.ВыгрузитьЗначения(), ", ");  // Неявное преобразование.
			
			// Добавляем пункты меню для отчетов по субконто.
			СписокПунктовМеню.Добавить("АнализСубконто", СтрШаблон(НСтр("ru = 'Анализ субконто %1';
																		|en = 'Extra dimension analysis %1 '"), ПредставлениеВидовСубконто));
			НастройкиРасшифровки.Вставить("АнализСубконто", ПользовательскиеНастройкиДляСубконто);
			СписокПунктовМеню.Добавить("КарточкаСубконто", СтрШаблон(НСтр("ru = 'Карточка субконто %1';
																			|en = '%1 extra dimension card'"), ПредставлениеВидовСубконто));
			НастройкиРасшифровки.Вставить("КарточкаСубконто", ПользовательскиеНастройкиДляСубконто);
			
		КонецЕсли;	
		
		ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
		
	КонецЕсли;
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры	

// В процедуре можно уточнить особенности вывода заголовка в отчете.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	// Организация
	Если ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, Ложь);
		ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
		Результат.Вывести(ОбластьОрганизация);
	КонецЕсли;
	
	// Текст заголовка.
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = ПараметрыОтчета.ПредставлениеОтчета + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	Результат.Вывести(ОбластьЗаголовок);
	Результат.Вывести(ОбластьОписаниеНастроек);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Общая обработка установит параметры печати и колонтитулы.
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	// После отчета будет выведена таблица с настройками
	// отчет и настройки нужно разделить, для этого возьмем пустую строку нового табличного документа.
	ПустойТабличныйДокумент = Новый ТабличныйДокумент;
	
	ОбластьРазделитель = ПустойТабличныйДокумент.ПолучитьОбласть ("R1");
	
	// Выведем в результат пустую строку.
	Результат.Вывести(ОбластьРазделитель);
	
	// Установим фиксацию.
	Результат.ФиксацияСверху = 0;
	Результат.ФиксацияСлева = 0;	
	
КонецПроцедуры

// Задает набор показателей, которые позволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйПользовательскиеНастройки(ДанныеОтчета)
	
	// Инициализация пользовательских настроек.
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("ПоказательБУ", 	Истина);
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
	ДополнительныеСвойства.Вставить("Организация", 		ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("НачалоПериода", 	ДанныеОтчета.Объект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода", 	ДанныеОтчета.Объект.КонецПериода);
	ДополнительныеСвойства.Вставить("ПоСубсчетам", 		Истина);
	
	Возврат ПользовательскиеНастройки;
	
КонецФункции	

Функция ПолучитьЗначениеРасшифровки(Элемент, ИмяПоля)
	
	Если ТипЗнч(Элемент) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		// Ищем поля в текущем элементе.
		Поле = Элемент.ПолучитьПоля().Найти(ИмяПоля);
		Если Поле <> Неопределено Тогда
			// Возвращаем значение найденного поля.
			Возврат(Поле.Значение);
		КонецЕсли;
	КонецЕсли;
	
	// Если поле не нашлось, или текущий элемент не содержит полей.
	// Ищем поля среди родителей элемента (вышестоящие группировки).
	Родители  = Элемент.ПолучитьРодителей();
	Если Родители.Количество() > 0 Тогда
		// Вызываем рекурсивный поиск поля.
		Возврат(ПолучитьЗначениеРасшифровки(Родители[0], ИмяПоля));
	КонецЕсли;
	
	// Если ничего не нашлось.
    Возврат(Неопределено);
	
КонецФункции

Функция ПолучитьДанныеРасшифровки(ДанныеРасшифровки, СтруктураПолей, Расшифровка)
	
	// Структура возвращаемых данных.
	// Структура на случай дублирования значений.
	СтруктураДанных = Новый Структура();
		
	Если ДанныеРасшифровки <> Неопределено Тогда
		// Ищем интересующие нас поля в заданной расшифровке.
		Для каждого ЭлементДанных Из СтруктураПолей Цикл
			// Получаем элемент расшифровки, в котором нужно искать поля.
			Родитель = ДанныеРасшифровки.Элементы[Расшифровка];
			// Вызываем рекурсивный поиск поля.
			ЗначениеРасшифровки = ПолучитьЗначениеРасшифровки(Родитель, ЭлементДанных.Ключ);
			Если ЗначениеРасшифровки <> Неопределено Тогда
				// Значение нашлось, помещаем в структуру.
				СтруктураДанных.Вставить(ЭлементДанных.Ключ, ЗначениеРасшифровки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураДанных;

КонецФункции

#КонецОбласти

#КонецЕсли