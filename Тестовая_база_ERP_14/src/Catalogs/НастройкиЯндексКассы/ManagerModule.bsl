#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция получения списка организаций по настройкам Яндекс.Кассы
//
// Параметры:
//  ТолькоСДоговором  - Булево, Неопределено - признак того, что нужно возвращать организации только по настройкам для варианта с договором и наоборот, если Неопределено будет выдано по всем.
//  ТолькоДействительные  - Булево - признак того, что нужно возвращать организации только по действующим настройкам.
//
// Возвращаемое значение:
//   Массив - Массив банковских счетов.
//
Функция СписокДоступныхОрганизаций(ТолькоСДоговором = Неопределено, ТолькоДействительные = Истина) Экспорт
	
	МассивОрганизаций = Новый Массив;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                      |	НастройкиЯндексКассы.Организация КАК Организация
	                      |ИЗ
	                      |	Справочник.НастройкиЯндексКассы КАК НастройкиЯндексКассы
	                      |ГДЕ
	                      |	НЕ НастройкиЯндексКассы.ПометкаУдаления
	                      |	И ВЫБОР
	                      |			КОГДА &ТолькоДействительные
	                      |				ТОГДА НастройкиЯндексКассы.Недействительна = ЛОЖЬ
	                      |		КОНЕЦ
	                      |	И ВЫБОР
	                      |			КОГДА &ТолькоСДоговором <> НЕОПРЕДЕЛЕНО
	                      |				ТОГДА НастройкиЯндексКассы.СДоговором = &ТолькоСДоговором
	                      |			ИНАЧЕ ИСТИНА
	                      |		КОНЕЦ");
	
	Запрос.УстановитьПараметр("ТолькоДействительные", ТолькоДействительные);
	Запрос.УстановитьПараметр("ТолькоСДоговором", ТолькоСДоговором);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		МассивОрганизаций = Результат.Выгрузить().ВыгрузитьКолонку("Организация");
	КонецЕсли;
	
	Возврат МассивОрганизаций;
	
КонецФункции

// Функция позволяющая получить настройку с Яндекс.Кассой по переданным параметрам поиска.
//
// Параметры:
//  КлючиПоиска  - Структура, ФиксированнаяСтруктура, Соответствие, ФиксированноеСоответствие - Ключи поиска по которым необходимо искать данные, поиск работает по логическому "И".
//    * Ключ - Строка - имя реквизита настройки.
//    * Значение - Произвольный - значение отбора.
//  ТолькоДействительные  - Булево - признак того, что нужно возвращать только действительные настройки.
//
// Возвращаемое значение:
//   СправочникСсылка.НастройкиЯндексКассы - Ссылка на найденную настройку, если ничего не найдено будет возвращена пустая ссылка.
//
Функция НайтиНастройку(КлючиПоиска, ТолькоДействительные = Истина) Экспорт 

	Если Не ТипЗнч(КлючиПоиска) = Тип("Структура") 
		И Не ТипЗнч(КлючиПоиска) = Тип("ФиксированнаяСтруктура")
		И Не ТипЗнч(КлючиПоиска) = Тип("Соответствие")
		И Не ТипЗнч(КлючиПоиска) = Тип("ФиксированноеСоответствие") Тогда 
		Возврат Справочники.НастройкиЯндексКассы.ПустаяСсылка();
	КонецЕсли;		
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	НастройкиЯндексКассы.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.НастройкиЯндексКассы КАК НастройкиЯндексКассы
	               |ГДЕ
	               |	НЕ НастройкиЯндексКассы.ПометкаУдаления 
                   |	И ВЫБОР
                   |			КОГДА &ТолькоДействительные
                   |				ТОГДА НастройкиЯндексКассы.Недействительна = ЛОЖЬ
                   |		КОНЕЦ
	               |	#Условия#";
				   
	Запрос.УстановитьПараметр("ТолькоДействительные", ТолькоДействительные);
			   
	ТекстУсловия = "";
	Для Каждого КлючПоиска Из КлючиПоиска Цикл  
		
		ТекстУсловия = ТекстУсловия 
			+ Символы.ПС + "И "
			+ "НастройкиЯндексКассы." + КлючПоиска.Ключ + " = &" +КлючПоиска.Ключ;
			
		Запрос.УстановитьПараметр(КлючПоиска.Ключ, КлючПоиска.Значение);
	КонецЦикла;	
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Условия#", ТекстУсловия);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.НастройкиЯндексКассы.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Функция получения юридических данных эквайера Яндекс.Кассы на дату запроса.
//
// Параметры:
//  ДатаСреза  - Дата - дата на которую требуется получить юр. данные эквайера.
//
// Возвращаемое значение:
//   Структура  - Данные эквайера, содержащие следующие реквизиты:
//    * ПолноеНаименование - Строка - полное наименование эквайера.
//    * Наименование - Строка - наименование эквайера.
//    * ИНН - Строка - ИНН эквайера.
//    * КПП - Строка - КПП эквайера.
//    * ОГРН - Строка - ОГРН эквайера.
//    * ОКВЭД - Строка - ОКВЭД эквайера.
//    * ОКПО - Строка - ОКПО эквайера.
//
Функция ДанныеЭквайераПоУмолчанию(ДатаСреза) Экспорт 
	
	Макет = Справочники.НастройкиЯндексКассы.ПолучитьМакет("Эквайеры");
	
	Макет.КодЯзыкаМакета = Метаданные.Языки.Русский.КодЯзыка;
	
	ЭквайерыXML = Макет.ПолучитьТекст();
	
	ЭквайерыXMLТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ЭквайерыXML).Данные;
	ЭквайерыXMLТаблица.Колонки.Добавить("ДатаСреза", Новый ОписаниеТипов("Дата",,,
													 Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	Для Каждого СтрокаТаблицы Из ЭквайерыXMLТаблица Цикл 
		СтрокаТаблицы.ДатаСреза = ?(ПустаяСтрока(СтрокаТаблицы.DateFrom), Дата('00010101'), Дата(СтрокаТаблицы.DateFrom));
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ЭквайерыXMLТаблица"	, ЭквайерыXMLТаблица);
	Запрос.УстановитьПараметр("ДатаСреза"			, ДатаСреза);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЭквайерыXMLТаблица.FullName,
	               |	ЭквайерыXMLТаблица.Name,
	               |	ЭквайерыXMLТаблица.INN,
	               |	ЭквайерыXMLТаблица.KPP,
	               |	ЭквайерыXMLТаблица.OGRN,
	               |	ЭквайерыXMLТаблица.OKVED,
	               |	ЭквайерыXMLТаблица.OKPO,
	               |	ЭквайерыXMLТаблица.ДатаСреза
	               |ПОМЕСТИТЬ ЭквайерыXMLТаблица
	               |ИЗ
	               |	&ЭквайерыXMLТаблица КАК ЭквайерыXMLТаблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МАКСИМУМ(ЭквайерыXMLТаблица.ДатаСреза) КАК ДатаСреза
	               |ПОМЕСТИТЬ ПолучениеПоДатеСреза
	               |ИЗ
	               |	ЭквайерыXMLТаблица КАК ЭквайерыXMLТаблица
	               |ГДЕ
	               |	ЭквайерыXMLТаблица.ДатаСреза <= &ДатаСреза
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЭквайерыXMLТаблица.FullName КАК НаименованиеПолное,
	               |	ЭквайерыXMLТаблица.Name КАК Наименование,
	               |	ЭквайерыXMLТаблица.INN КАК ИНН,
	               |	ЭквайерыXMLТаблица.KPP КАК КПП,
	               |	ЭквайерыXMLТаблица.OGRN КАК ОГРН,
	               |	ЭквайерыXMLТаблица.OKVED КАК ОКВЭД,
	               |	ЭквайерыXMLТаблица.OKPO КАК КодПоОКПО
	               |ИЗ
	               |	ЭквайерыXMLТаблица КАК ЭквайерыXMLТаблица
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПолучениеПоДатеСреза КАК ПолучениеПоДатеСреза
	               |		ПО ЭквайерыXMLТаблица.ДатаСреза = ПолучениеПоДатеСреза.ДатаСреза";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ДанныеЭквайера = Новый Структура("НаименованиеПолное, Наименование, ИНН, КПП, ОГРН, ОКВЭД, КодПоОКПО");
	ЗаполнитьЗначенияСвойств(ДанныеЭквайера, Выборка);
	
	Возврат ДанныеЭквайера;
	
КонецФункции

#Область КарточкаНастройки

// Возвращает табличный документ настройки.
// Параметры:
//  Настройка - СправочникОбъект.НастройкиЯндексКассы, ДанныеФормыСтруктура - элемент, для которого нужно отработать логику связи реквизитов.
//  ДополнительныеНастройки - ДанныеФормыКоллекция - таблица дополнительных настроек.
//   * Настройка - Строка - идентификатор настройки.
//   * Значение - ЛюбаяСсылка, Булево, Строка, Дата, Число - значение настройки.
//
// Возвращаемое значение:
//  ТабличныйДокумент - табличный документ с реквизитами.
//
Функция ПолучитьТабличныйДокументКарточкиНастройки(Настройка, ДополнительныеНастройки) Экспорт
	
	Перем Заголовок;
	
	Объект = Неопределено;
	Если ТипЗнч(Настройка) = Тип("СправочникСсылка.НастройкиЯндексКассы") Тогда
		Объект = Настройка.ПолучитьОбъект();
	ИначеЕсли ТипЗнч(Настройка) = Тип("СправочникОбъект.НастройкиЯндексКассы")
		Или ТипЗнч(Настройка) = Тип("ДанныеФормыСтруктура") 
		Или ТипЗнч(Настройка) = Тип("УправляемаяФорма") Тогда
		Объект = Настройка;
	Иначе
		Возврат Новый ТабличныйДокумент;
	КонецЕсли;
	
	ТабличныйДокументКарточка = Новый ТабличныйДокумент;
	
	Макет = ПолучитьМакет("ПФ_MXL_КарточкаНастройки");
	
	ОбластьОсновная = Макет.ПолучитьОбласть("Основная");
	ОбластьОсновная.Параметры.Организация = Объект.Организация;
	
	Вариант = ?(Объект.СДоговором = 0, НСтр("ru = 'Без договора';
											|en = 'Without contract'"), НСтр("ru = 'С договором';
																		|en = 'With contract'"));
	ОбластьОсновная.Параметры.Вариант = Вариант;
	
	Недействительна = ?(Объект.Недействительна, "НЕДЕЙСТВУЮЩАЯ", "");
	ОбластьОсновная.Параметры.НЕДЕЙСТВИТЕЛЬНА = Недействительна;
	
	ТабличныйДокументКарточка.Вывести(ОбластьОсновная);
	
	Если Объект.СДоговором Тогда 
	
		ОбластьПараметрыПодключения = Макет.ПолучитьОбласть("ПараметрыПодключения");
		ЗаполнитьЗначенияСвойств(ОбластьПараметрыПодключения.Параметры, Объект);

		ТабличныйДокументКарточка.Вывести(ОбластьПараметрыПодключения);
		
		Если ЗначениеЗаполнено(ДополнительныеНастройки) Тогда 
			ОбластьНастройкиУчетаШапка = Макет.ПолучитьОбласть("НастройкиУчетаШапка");
			ТабличныйДокументКарточка.Вывести(ОбластьНастройкиУчетаШапка);
		КонецЕсли;
		
		ДействующиеДопНастройки = ИнтеграцияСЯндексКассойСлужебный.ДополнительныеНастройкиЯндексКассы();
		Для каждого СтрокаНастроек Из ДополнительныеНастройки Цикл
			
			ОписаниеНастройки = ДействующиеДопНастройки.Найти(СтрокаНастроек.Настройка, "Настройка");
			Если ОписаниеНастройки = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ОбластьНастройкиУчетаСтрока = Макет.ПолучитьОбласть("НастройкиУчетаСтрока");
			ОбластьНастройкиУчетаСтрока.Параметры.Заполнить(СтрокаНастроек);
			ОбластьНастройкиУчетаСтрока.Параметры.Представление = ОписаниеНастройки.Представление;
			ТабличныйДокументКарточка.Вывести(ОбластьНастройкиУчетаСтрока);
			
		КонецЦикла;
	
	КонецЕсли;
	
	Если ТипЗнч(Настройка) = Тип("УправляемаяФорма") 
		И Настройка.СоздатьШаблоныАвтоматически Тогда 
				
		ОбластьШаблоныПисем = Макет.ПолучитьОбласть("ШаблоныПисем");
		ТабличныйДокументКарточка.Вывести(ОбластьШаблоныПисем);
			
	КонецЕсли;
	
	Возврат ТабличныйДокументКарточка;
	
КонецФункции

#КонецОбласти

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

#КонецЕсли