
#Область ПрограммныйИнтерфейс

// Процедура создает партнера с 
// наименованием "Держатель карты лояльности" на основании
// переданной структуры с данными карты лояльности.
//
// Параметры:
//  СтруктураДанныхКарты - Данные карты лояльности, см. функцию КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности().
//
// Возвращаемое значение:
//  СправочникСсылка.Партнеры - Партнер.
//
Функция СоздатьПартнераДержателяКартыЛояльности(СтруктураДанныхКарты) Экспорт
	
	ПартнерОбъект = Справочники.Партнеры.СоздатьЭлемент();
	ПартнерОбъект.Наименование = НСтр("ru = 'Держатель карты лояльности';
										|en = 'Loyalty card holder'")
	                             + ?(ЗначениеЗаполнено(СтруктураДанныхКарты.Штрихкод), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ', Штрихкод: %1';
																																					|en = ', Barcode: %1'"), СтруктураДанныхКарты.Штрихкод), "")
	                             + ?(ЗначениеЗаполнено(СтруктураДанныхКарты.МагнитныйКод), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ', Магнитный код: %1';
																																						|en = ', Magnetic code: %1'"), СтруктураДанныхКарты.МагнитныйКод), "");
	ПартнерОбъект.НаименованиеПолное = ПартнерОбъект.Наименование;
	ПартнерОбъект.ЮрФизЛицо          = Перечисления.КомпанияЧастноеЛицо.ЧастноеЛицо;
	ПартнерОбъект.Комментарий        = НСтр("ru = 'Данные о клиенте необходимо заполнить при помощи регистрационной анкеты.';
											|en = 'Use an application form to fill out the customer data.'");
	ПартнерОбъект.Клиент             = Истина;
	ПартнерОбъект.ОсновнойМенеджер   = Пользователи.ТекущийПользователь();
	ПартнерОбъект.ДатаРегистрации    = ТекущаяДатаСеанса();
	
	Если УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() 
		И ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаПартнеров") Тогда
		
		РазрешенныеГруппы = УправлениеДоступом.ГруппыЗначенийДоступаРазрешающиеИзменениеЗначенийДоступа(Тип("СправочникСсылка.Партнеры"), Истина);
		Если РазрешенныеГруппы.Количество() > 0 Тогда
			ПартнерОбъект.ГруппаДоступа = РазрешенныеГруппы[0];
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерОбъект.Записать();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		
		КонтрагентОбъект = Справочники.Контрагенты.СоздатьЭлемент();
		КонтрагентОбъект.Наименование       = ПартнерОбъект.Наименование;
		КонтрагентОбъект.НаименованиеПолное = ПартнерОбъект.Наименование;
		КонтрагентОбъект.ЮрФизЛицо          = Перечисления.ЮрФизЛицо.ФизЛицо;
		КонтрагентОбъект.Партнер            = ПартнерОбъект.Ссылка;
		
		КонтрагентОбъект.Записать();
		
	КонецЕсли;
	
	Возврат ПартнерОбъект.Ссылка;
	
КонецФункции

// Процедура записывает в базу данных карту лояльности на основании
// переданной структуры с данными карты лояльности, а также создает партнера с 
// наименованием "Держатель карты лояльности".
//
// Параметры:
//  СтруктураДанныхКарты - Данные карты лояльности, см. функцию КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности().
//
// Возвращаемое значение:
//  СправочникСсылка.КартыЛояльности - Карта лояльности.
//
Функция СоздатьПартнераИЗарегистрироватьКартуЛояльности(СтруктураДанныхКарты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураДанныхКарты.Партнер    = СоздатьПартнераДержателяКартыЛояльности(СтруктураДанныхКарты);
	СтруктураДанныхКарты.Контрагент = Неопределено;
	СтруктураДанныхКарты.Соглашение = Неопределено;
	
	Возврат ЗарегистрироватьКартуЛояльности(СтруктураДанныхКарты)
	
КонецФункции

// Аннулировать карту лояльности.
//
// Параметры:
//  КартаЛояльности - СправочникСсылка.КартыЛояльности - Карта лояльности.
//
Процедура АннулироватьКартуЛояльности(КартаЛояльности) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КартаОбъект = КартаЛояльности.ПолучитьОбъект();
	КартаОбъект.Статус = Перечисления.СтатусыКартЛояльности.Аннулирована;
	КартаОбъект.Записать();
	
КонецПроцедуры

// Процедура записывает в базу данных карту лояльности на основании
// переданной структуры с данными карты лояльности.
//
// Параметры:
//  СтруктураДанныхКарты - Данные карты лояльности, см. функцию КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности().
//
// Возвращаемое значение:
//  СправочникСсылка.КартыЛояльности - Карта лояльности.
//
Функция ЗарегистрироватьКартуЛояльности(СтруктураДанныхКарты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КартаОбъект = Справочники.КартыЛояльности.СоздатьЭлемент();
	
	КартаОбъект.Штрихкод     = СтруктураДанныхКарты.Штрихкод;
	КартаОбъект.МагнитныйКод = СтруктураДанныхКарты.МагнитныйКод;
	
	КартаОбъект.Владелец   = СтруктураДанныхКарты.ВидКарты;
	
	КартаОбъект.Партнер    = СтруктураДанныхКарты.Партнер;
	КартаОбъект.Контрагент = СтруктураДанныхКарты.Контрагент;
	КартаОбъект.Соглашение = СтруктураДанныхКарты.Соглашение;
	
	КартаОбъект.Статус = Перечисления.СтатусыКартЛояльности.Действует;
	
	КартаОбъект.Наименование = Строка(КартаОбъект.Владелец)
	                         + ?(ЗначениеЗаполнено(КартаОбъект.Штрихкод), " " + Строка(КартаОбъект.Штрихкод), "")
	                         + ?(ЗначениеЗаполнено(КартаОбъект.МагнитныйКод), " " + Строка(КартаОбъект.МагнитныйКод), "");
	КартаОбъект.Записать();
	
	Возврат КартаОбъект.Ссылка;
	
КонецФункции

// Функция возвращает пустую структуру данных карт лояльности
//
// Возвращаемое значение:
//  СправочникСсылка.КартыЛояльности - Карта лояльности.
//
Функция ИнициализироватьДанныеКартыЛояльности() Экспорт
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Штрихкод");
	СтруктураДанных.Вставить("МагнитныйКод");
	СтруктураДанных.Вставить("Ссылка");
	СтруктураДанных.Вставить("ВидКарты");
	СтруктураДанных.Вставить("ТипКарты");
	СтруктураДанных.Вставить("Персонализирована");
	СтруктураДанных.Вставить("АвтоматическаяРегистрацияПриПервомСчитывании");
	СтруктураДанных.Вставить("Партнер");
	СтруктураДанных.Вставить("Контрагент");
	СтруктураДанных.Вставить("Соглашение");
	СтруктураДанных.Вставить("Статус");
	СтруктураДанных.Вставить("ДатаНачалаДействия");
	СтруктураДанных.Вставить("ДатаОкончанияДействия");
	СтруктураДанных.Вставить("Организация");
	
	// Данные РЛС
	СтруктураДанных.Вставить("ПартнерДоступен",    Истина);
	СтруктураДанных.Вставить("СоглашениеДоступно", Истина);
	СтруктураДанных.Вставить("КонтрагентДоступен", Истина);
	
	// Справочная информация по виду карты
	СтруктураДанных.Вставить("СтатусВидаКарты");
	
	// Справочная информация по партнеру
	СтруктураДанных.Вставить("ЮрФизЛицо");
	СтруктураДанных.Вставить("ФИОПартнера");
	СтруктураДанных.Вставить("ДатаРожденияПартнера");
	СтруктураДанных.Вставить("ПолПартнера");
	
	Возврат СтруктураДанных;
	
КонецФункции

// Функция возвращает тип кода карты лояльности, если только он
// используется в видах карт лояльности.
//
// Возвращаемое значение:
//  Перечисление.ТипыКодовКарт, Неопределено - Основной тип кода карты лояльности.
//
Функция ПолучитьОсновнойТипКодаКартыЛояльности() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыКартЛояльности.ТипКарты КАК ТипКарты
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКартЛояльности");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Количество = Выборка.Количество();
	Если Количество = 0 Тогда
		Возврат Неопределено;
	ИначеЕсли Количество = 1 Тогда
		Выборка.Следующий();
		Если Выборка.ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
			Возврат Перечисления.ТипыКодовКарт.Штрихкод;
		ИначеЕсли Выборка.ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
			Возврат Перечисления.ТипыКодовКарт.МагнитныйКод;
		ИначеЕсли Выборка.ТипКарты = Перечисления.ТипыКарт.Смешанная Тогда
			Возврат Неопределено;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#Область ПоискКартЛояльности

// Процедура возвращает карту лояльности партнера, если она у него одна.
//
// Параметры:
//  Партнер - СправочникСсылка.Партнеры - Партнер.
//
// Возвращаемое значение:
//  СправочникСсылка.КартыЛояльности, Неопределено - Карта лояльности.
//
Функция ПолучитьКартуПоУмолчаниюДляПартнера(Партнер) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	КартыЛояльности.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КартыЛояльности КАК КартыЛояльности
	|ГДЕ
	|	КартыЛояльности.Партнер = &Партнер");
	
	Запрос.УстановитьПараметр("Партнер", Партнер);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ЗаменяемаяКарта = Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Функция выполняет поиск видов карт лояльности, которые могут иметь заданный код и тип кода.
//
// Параметры:
//  КодКарты - Строка - Код карты.
//  ТипКода - Перечисление.ТипыКодовКарт - Тип кода карты.
//
// Возвращаемое значение:
//  Массив - Массив ссылок на виды карт лояльности.
//
Функция ПолучитьВозможныеВидыКартыЛояльностиПоКодуКарты(КодКарты, ТипКода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВидыКарт = Новый Массив;
	
	Если ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ШаблоныКодовКартЛояльности.Ссылка КАК ВидКарты
		|ИЗ
		|	Справочник.ВидыКартЛояльности.ШаблоныКодовКартЛояльности КАК ШаблоныКодовКартЛояльности
		|ГДЕ
		|	  ШаблоныКодовКартЛояльности.НачалоДиапазонаМагнитногоКода <= &КодКарты
		|	И ШаблоныКодовКартЛояльности.КонецДиапазонаМагнитногоКода  >= &КодКарты
		|	И ШаблоныКодовКартЛояльности.ДлинаМагнитногоКода = &ДлинаКода
		|	И ШаблоныКодовКартЛояльности.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВидовКартЛояльности.Действует)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НачалоДиапазонаМагнитногоКода");
	Иначе
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ШаблоныКодовКартЛояльности.Ссылка КАК ВидКарты
		|ИЗ
		|	Справочник.ВидыКартЛояльности.ШаблоныКодовКартЛояльности КАК ШаблоныКодовКартЛояльности
		|ГДЕ
		|	ШаблоныКодовКартЛояльности.НачалоДиапазонаШтрихкода <= &КодКарты
		|	И ШаблоныКодовКартЛояльности.КонецДиапазонаШтрихкода >= &КодКарты
		|	И ШаблоныКодовКартЛояльности.ДлинаШтрихкода = &ДлинаКода
		|	И ШаблоныКодовКартЛояльности.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВидовКартЛояльности.Действует)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ШаблоныКодовКартЛояльности.НачалоДиапазонаШтрихкода");
	КонецЕсли;

	Запрос.УстановитьПараметр("КодКарты",  Строка(КодКарты));
	Запрос.УстановитьПараметр("ДлинаКода", СтрДлина(Строка(КодКарты)));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВидыКарт.Добавить(Выборка.ВидКарты);
	КонецЦикла;
	
	Возврат ВидыКарт;
	
КонецФункции

// Функция выполняет поиск карт лояльности.
//
// Параметры:
//  КодКарты - Строка
//  ТипКода - Перечисление.ТипыКодовКарт.
//
// Возвращаемое значение:
//  Структура со свойствами:
//   * ЗарегистрированныеКартыЛояльности   - ТаблицаЗначений - Данные зарегистрированных карт лояльности,
//                                           см. функцию КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности().
//   * НеЗарегистрированныеКартыЛояльности - ТаблицаЗначений - Данные незарегистрированных карт лояльности,
//                                           см. функцию КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности().
//
Функция НайтиКартыЛояльности(КодКарты, ТипКода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗарегистрированныеКартыЛояльности = Новый Массив;
	НеЗарегистрированныеКартыЛояльности = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ШаблоныКодовКартЛояльности.Ссылка                                              КАК Ссылка,
	|	ШаблоныКодовКартЛояльности.Ссылка.Статус                                       КАК Статус,
	|	ШаблоныКодовКартЛояльности.Ссылка.Персонализирована                            КАК Персонализирована,
	|	ШаблоныКодовКартЛояльности.Ссылка.ТипКарты                                     КАК ТипКарты,
	|	ШаблоныКодовКартЛояльности.Ссылка.АвтоматическаяРегистрацияПриПервомСчитывании КАК АвтоматическаяРегистрацияПриПервомСчитывании,
	|	ШаблоныКодовКартЛояльности.Ссылка.ДатаНачалаДействия                           КАК ДатаНачалаДействия,
	|	ШаблоныКодовКартЛояльности.Ссылка.ДатаОкончанияДействия                        КАК ДатаОкончанияДействия,
	|	ШаблоныКодовКартЛояльности.Ссылка.Организация                                  КАК Организация
	|ПОМЕСТИТЬ ВидыКарт
	|ИЗ
	|	Справочник.ВидыКартЛояльности.ШаблоныКодовКартЛояльности КАК ШаблоныКодовКартЛояльности
	|ГДЕ
	|	&УсловиеНачалоДиапазона                    <= &КодКарты
	|	И &УсловиеКонецДиапазона                   >= &КодКарты
	|	И &УсловиеДлинаКода                         = &ДлинаКода
	|	И ШаблоныКодовКартЛояльности.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыВидовКартЛояльности.НеДействует)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КартыЛояльности.Ссылка       КАК Ссылка,
	|	КартыЛояльности.Наименование КАК Наименование,
	|	КартыЛояльности.Штрихкод     КАК Штрихкод,
	|	КартыЛояльности.МагнитныйКод КАК МагнитныйКод,
	|	КартыЛояльности.Партнер      КАК Партнер,
	|	КартыЛояльности.Контрагент   КАК Контрагент,
	|	КартыЛояльности.Соглашение   КАК Соглашение,
	|	КартыЛояльности.Статус       КАК Статус,
	|	
	|	КартыЛояльности.Владелец                                              КАК ВидКарты,
	|	КартыЛояльности.Владелец.Статус                                       КАК СтатусВидаКарты,
	|	КартыЛояльности.Владелец.ДатаНачалаДействия                           КАК ДатаНачалаДействия,
	|	КартыЛояльности.Владелец.ДатаОкончанияДействия                        КАК ДатаОкончанияДействия,
	|	КартыЛояльности.Владелец.Персонализирована                            КАК Персонализирована,
	|	КартыЛояльности.Владелец.ТипКарты                                     КАК ТипКарты,
	|	КартыЛояльности.Владелец.АвтоматическаяРегистрацияПриПервомСчитывании КАК АвтоматическаяРегистрацияПриПервомСчитывании,
	|	ВидыКарт.Организация                                                  КАК Организация
	|ПОМЕСТИТЬ КартыЛояльности
	|ИЗ
	|	Справочник.КартыЛояльности КАК КартыЛояльности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВидыКарт
	|		ПО ВидыКарт.Ссылка  = КартыЛояльности.Владелец
	|		 И &ИмяПоляКодКарты = &КодКарты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1                            КАК Порядок,
	|	КартыЛояльности.Ссылка       КАК Ссылка,
	|	КартыЛояльности.Наименование КАК Наименование,
	|	КартыЛояльности.Штрихкод     КАК Штрихкод,
	|	КартыЛояльности.МагнитныйКод КАК МагнитныйКод,
	|	КартыЛояльности.Партнер      КАК Партнер,
	|	КартыЛояльности.Контрагент   КАК Контрагент,
	|	КартыЛояльности.Соглашение   КАК Соглашение,
	|	КартыЛояльности.Статус       КАК Статус,
	|	
	|	КартыЛояльности.ВидКарты                                     КАК ВидКарты,
	|	КартыЛояльности.СтатусВидаКарты                              КАК СтатусВидаКарты,
	|	КартыЛояльности.ДатаНачалаДействия                           КАК ДатаНачалаДействия,
	|	КартыЛояльности.ДатаОкончанияДействия                        КАК ДатаОкончанияДействия,
	|	КартыЛояльности.Персонализирована                            КАК Персонализирована,
	|	КартыЛояльности.ТипКарты                                     КАК ТипКарты,
	|	КартыЛояльности.АвтоматическаяРегистрацияПриПервомСчитывании КАК АвтоматическаяРегистрацияПриПервомСчитывании,
	|	КартыЛояльности.Организация                                  КАК Организация
	|ИЗ
	|	КартыЛояльности
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2                                                         КАК Порядок,
	|	ЗНАЧЕНИЕ(Справочник.КартыЛояльности.ПустаяСсылка)         КАК Ссылка,
	|	""""                                                      КАК Наименование,
	|	&Штрихкод                                                 КАК Штрихкод,
	|	&МагнитныйКод                                             КАК МагнитныйКод,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)                КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)             КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСКлиентами.ПустаяСсылка)    КАК Соглашение,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыКартЛояльности.ПустаяСсылка) КАК Статус,
	|	
	|	ВидыКарт.Ссылка                                       КАК ВидКарты,
	|	ВидыКарт.Статус                                       КАК СтатусВидаКарты,
	|	ВидыКарт.ДатаНачалаДействия                           КАК ДатаНачалаДействия,
	|	ВидыКарт.ДатаОкончанияДействия                        КАК ДатаОкончанияДействия,
	|	ВидыКарт.Персонализирована                            КАК Персонализирована,
	|	ВидыКарт.ТипКарты                                     КАК ТипКарты,
	|	ВидыКарт.АвтоматическаяРегистрацияПриПервомСчитывании КАК АвтоматическаяРегистрацияПриПервомСчитывании,
	|	ВидыКарт.Организация                                  КАК Организация
	|ИЗ
	|	ВидыКарт КАК ВидыКарт
	|ГДЕ
	|	(НЕ ВидыКарт.Ссылка В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					Т.ВидКарты
	|				ИЗ
	|					КартыЛояльности КАК Т))
	|УПОРЯДОЧИТЬ ПО
	|	Порядок ВОЗР
	|");
	
	Если ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеНачалоДиапазона", "ШаблоныКодовКартЛояльности.НачалоДиапазонаМагнитногоКода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеКонецДиапазона",  "ШаблоныКодовКартЛояльности.КонецДиапазонаМагнитногоКода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеДлинаКода",       "ШаблоныКодовКартЛояльности.ДлинаМагнитногоКода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&ИмяПоляКодКарты",        "КартыЛояльности.МагнитныйКод");
		
		Запрос.УстановитьПараметр("Штрихкод",     "");
		Запрос.УстановитьПараметр("МагнитныйКод", КодКарты);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеНачалоДиапазона", "ШаблоныКодовКартЛояльности.НачалоДиапазонаШтрихкода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеКонецДиапазона",  "ШаблоныКодовКартЛояльности.КонецДиапазонаШтрихкода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеДлинаКода",       "ШаблоныКодовКартЛояльности.ДлинаШтрихкода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&ИмяПоляКодКарты",        "КартыЛояльности.Штрихкод");
		
		Запрос.УстановитьПараметр("Штрихкод",     КодКарты);
		Запрос.УстановитьПараметр("МагнитныйКод", "");
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("КодКарты",  КодКарты);
	Запрос.УстановитьПараметр("ДлинаКода", СтрДлина(КодКарты));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
	
		Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
			НоваяСтрока = ИнициализироватьДанныеКартыЛояльности();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			ЗарегистрированныеКартыЛояльности.Добавить(НоваяСтрока);
		Иначе
			НоваяСтрока = ИнициализироватьДанныеКартыЛояльности();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НеЗарегистрированныеКартыЛояльности.Добавить(НоваяСтрока);
		КонецЕсли;
	
	КонецЦикла;
	
	ВозвращаемоеЗначение = Новый Структура("ЗарегистрированныеКартыЛояльности, НеЗарегистрированныеКартыЛояльности");
	ВозвращаемоеЗначение.ЗарегистрированныеКартыЛояльности   = ЗарегистрированныеКартыЛояльности;
	ВозвращаемоеЗначение.НеЗарегистрированныеКартыЛояльности = НеЗарегистрированныеКартыЛояльности;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Функция выполняет поиск карт лояльности по магнитному коду.
//
// Параметры:
//  Магнитный код - Строка - Магнитный код.
//
// Возвращаемое значение:
//  Структура со свойствами:
//   * ЗарегистрированныеКартыЛояльности   - ТаблицаЗначений - Данные зарегистрированных карт лояльности,
//                                           см. функцию КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности().
//   * НеЗарегистрированныеКартыЛояльности - ТаблицаЗначений - Данные незарегистрированных карт лояльности,
//                                           см. функцию КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности().
//
Функция НайтиКартыЛояльностиПоМагнитномуКоду(МагнитныйКод) Экспорт
	
	Возврат НайтиКартыЛояльности(МагнитныйКод, Перечисления.ТипыКодовКарт.МагнитныйКод);
	
КонецФункции

#КонецОбласти

#КонецОбласти 
