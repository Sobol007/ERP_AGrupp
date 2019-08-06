
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

#Область АннулированиеСертификатов

// Аннулировать подарочные сертификаты при закрытии месяца
//
// Параметры:
//  МассивОрганизаций - Массив - элементы с типом СправочникСсылка.Организации
//  Период		 	  - Дата - Период.
//
Процедура АннулироватьПодарочныеСертификатыПриЗакрытииМесяца(МассивОрганизаций, Период) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодарочныеСертификаты") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru = 'Аннулирование подарочных сертификатов';
															|en = 'Gift certificate cancellation'"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаСертификатыКАннулированию() + Символы.ПС + ";" + Символы.ПС + "
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиСертификатов.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ОстаткиСертификатов.СуммаОстаток
	|ПОМЕСТИТЬ ОстаткиСертификатов
	|ИЗ
	|	РегистрНакопления.ПодарочныеСертификаты.Остатки(
	|		&КонецПериода,
	|		ПодарочныйСертификат В
	|			(ВЫБРАТЬ
	|				ПодарочныеСертификаты.ПодарочныйСертификат
	|			ИЗ
	|				СертификатыКАннулированию КАК ПодарочныеСертификаты)) КАК ОстаткиСертификатов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодарочныйСертификат
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сертификаты.Организация КАК Организация,
	|	Сертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	Сертификаты.СтатьяДоходов КАК СтатьяДоходов,
	|	Сертификаты.АналитикаДоходов КАК АналитикаДоходов,
	|	ЕСТЬNULL(ОстаткиСертификатов.СуммаОстаток, 0) КАК СуммаВВалютеСертификата
	|ИЗ
	|	СертификатыКАннулированию КАК Сертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиСертификатов КАК ОстаткиСертификатов
	|		ПО Сертификаты.ПодарочныйСертификат = ОстаткиСертификатов.ПодарочныйСертификат
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сертификаты.Организация";
	
	Запрос.УстановитьПараметр("МассивОрганизаций", МассивОрганизаций);
	Запрос.УстановитьПараметр("НачалоПериода", 	   НачалоМесяца(Период));
	Запрос.УстановитьПараметр("КонецПериода",  	   КонецМесяца(Период));
	
	ДокументыОрганизаций = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДокументОбъект = ДокументыОрганизаций.Получить(Выборка.Организация);
		Если ДокументОбъект = Неопределено Тогда
			ДокументОбъект = Документы.АннулированиеПодарочныхСертификатов.СоздатьДокумент();
			ДокументОбъект.Дата = КонецМесяца(Период);
			ДокументОбъект.ИнициализироватьДокумент();
			ДокументОбъект.Организация = Выборка.Организация;
			ДокументыОрганизаций.Вставить(Выборка.Организация, ДокументОбъект);
		КонецЕсли;
		
		НоваяСтрока = ДокументОбъект.ПодарочныеСертификаты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;
	
	Для Каждого Документ Из ДокументыОрганизаций Цикл
		
		ДокументОбъект = Документ.Значение;
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);

		Если ДокументОбъект.ПроверитьЗаполнение() Тогда
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает текст запроса создания временной таблицы СертификатыКАннулированию.
//
Функция ТекстЗапросаСертификатыКАннулированию() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ИсторияСертификатов.ПодарочныйСертификат 		КАК ПодарочныйСертификат,
	|	СправочникВидыСертификатов.СтатьяДоходов 		КАК СтатьяДоходов,
	|	СправочникВидыСертификатов.АналитикаДоходов 	КАК АналитикаДоходов,
	|	АктивацияСертификатов.Регистратор.Организация 	КАК Организация
	|ПОМЕСТИТЬ СертификатыКАннулированию
	|ИЗ
	|	РегистрСведений.ИсторияПодарочныхСертификатов.СрезПоследних(&КонецПериода, ) КАК ИсторияСертификатов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияПодарочныхСертификатов КАК АктивацияСертификатов
	|		ПО ИсторияСертификатов.ПодарочныйСертификат = АктивацияСертификатов.ПодарочныйСертификат
	|			И (АктивацияСертификатов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.Активирован))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодарочныеСертификаты КАК СправочникСертификаты
	|		ПО ИсторияСертификатов.ПодарочныйСертификат = СправочникСертификаты.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыПодарочныхСертификатов КАК СправочникВидыСертификатов
	|		ПО СправочникСертификаты.Владелец = СправочникВидыСертификатов.Ссылка
	|ГДЕ
	|	АктивацияСертификатов.Регистратор.Организация В (&МассивОрганизаций)
	|	И АктивацияСертификатов.Активность
	|	И ИсторияСертификатов.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.Аннулирован)
	|	И ВЫБОР СправочникВидыСертификатов.ПериодДействия
	|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|				ТОГДА ДОБАВИТЬКДАТЕ(АктивацияСертификатов.Период, ДЕНЬ, СправочникВидыСертификатов.КоличествоПериодовДействия)
	|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|				ТОГДА ДОБАВИТЬКДАТЕ(АктивацияСертификатов.Период, НЕДЕЛЯ, СправочникВидыСертификатов.КоличествоПериодовДействия)
	|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|				ТОГДА ДОБАВИТЬКДАТЕ(АктивацияСертификатов.Период, МЕСЯЦ, СправочникВидыСертификатов.КоличествоПериодовДействия)
	|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|				ТОГДА ДОБАВИТЬКДАТЕ(АктивацияСертификатов.Период, КВАРТАЛ, СправочникВидыСертификатов.КоличествоПериодовДействия)
	|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|				ТОГДА ДОБАВИТЬКДАТЕ(АктивацияСертификатов.Период, ГОД, СправочникВидыСертификатов.КоличествоПериодовДействия)
	|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|				ТОГДА ДОБАВИТЬКДАТЕ(АктивацияСертификатов.Период, ДЕКАДА, СправочникВидыСертификатов.КоличествоПериодовДействия)
	|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|				ТОГДА ДОБАВИТЬКДАТЕ(АктивацияСертификатов.Период, ПОЛУГОДИЕ, СправочникВидыСертификатов.КоличествоПериодовДействия)
	|			ИНАЧЕ АктивацияСертификатов.Период
	|		КОНЕЦ < &КонецПериода
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодарочныйСертификат";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

//++ НЕ УТ
#Область ПроводкиРеглУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	ТекстыОтражения = Новый Массив;
	
	#Область СписаниеАвансаОтРозничногоКлиента
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Списание аванса от розничного клиента (Дт 76.09 :: Кт 91.01)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	СуммыРегл.СуммаРегл КАК Сумма,
	|	ВЫБОР КОГДА Строки.ПодарочныйСертификат.Владелец.Валюта = &ВалютаУпрУчета
	|		ТОГДА Строки.СуммаВВалютеСертификата
	|		ИНАЧЕ Строки.СуммаВВалютеСертификата * КурсТекущейВалюты.Курс / КурсВалютыУпрУчета.Курс
	|	КОНЕЦ КАК СуммаУУ,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.РасчетыПоПодарочнымСертификатам) КАК ВидСчетаДт,
	|	Строки.ПодарочныйСертификат.Владелец КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Строки.ПодарочныйСертификат.Владелец.Валюта КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	Строки.СуммаВВалютеСертификата КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Доходы) КАК ВидСчетаКт,
	|	Строки.ПодарочныйСертификат.Владелец.СтатьяДоходов КАК АналитикаУчетаКт,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеКт,
	|	Строки.ПодарочныйСертификат.Владелец.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Списание аванса от розничного клиента"" КАК Содержание
	|ИЗ 
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.АннулированиеПодарочныхСертификатов КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|		
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.АннулированиеПодарочныхСертификатов.ПодарочныеСертификаты КАК Строки
	|	ПО
	|		ДокументыКОтражению.Ссылка = Строки.Ссылка
	|		
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПодарочныеСертификаты КАК СуммыРегл
	|	ПО
	|		СуммыРегл.Регистратор = Строки.Ссылка
	|		И СуммыРегл.ПодарочныйСертификат = Строки.ПодарочныйСертификат
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = НАЧАЛОПЕРИОДА(Операция.Дата, День)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсТекущейВалюты
	|	ПО
	|		КурсТекущейВалюты.Дата = Операция.Дата
	|		И КурсТекущейВалюты.Валюта = Строки.ПодарочныйСертификат.Владелец.Валюта
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);	
	#КонецОбласти
	
	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	ТекстЗапроса = "";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаПодарочныеСертификаты(ТекстыЗапроса, Регистры);
	ТекстЗапросаИсторияПодарочныхСертификатов(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПрочиеДоходы(ТекстыЗапроса, Регистры);
	ТекстЗапросаКонтрагентДоходыРасходы(ТекстыЗапроса, Регистры);
	//++ НЕ УТ 
	ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры);
	//-- НЕ УТ 
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата        КАК Период,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Менеджер    КАК Менеджер
	|
	|ИЗ
	|	Документ.АннулированиеПодарочныхСертификатов КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                                Реквизиты.Период);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",        Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",            Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("Организация",                           Реквизиты.Организация);
	Запрос.УстановитьПараметр("Менеджер",                              Реквизиты.Менеджер);
	Запрос.УстановитьПараметр("ИспользоватьУчетПрочихДоходовРасходов", ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов"));
	
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаПодарочныеСертификаты(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПодарочныеСертификаты";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период                                КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТабличнаяЧасть.ПодарочныйСертификат    КАК ПодарочныйСертификат,
	|	ТабличнаяЧасть.СуммаВВалютеСертификата КАК Сумма,
	|	
	|	ТабличнаяЧасть.СуммаВВалютеСертификата
	|		* ЕСТЬNULL(КурсыВалютСерт.Курс, 1) / ЕСТЬNULL(КурсыВалютСерт.Кратность, 1)
	|		/ ЕСТЬNULL(КурсВалютыРегл.Курс, 1) * ЕСТЬNULL(КурсВалютыРегл.Кратность, 1) КАК СуммаРегл
	|
	|ИЗ
	|	Документ.АннулированиеПодарочныхСертификатов.ПодарочныеСертификаты КАК ТабличнаяЧасть
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсыВалютСерт
	|	ПО
	|		КурсыВалютСерт.Валюта = ТабличнаяЧасть.ПодарочныйСертификат.Владелец.Валюта
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсВалютыРегл
	|	ПО
	|		КурсВалютыРегл.Валюта = &ВалютаРегламентированногоУчета
	|
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаИсторияПодарочныхСертификатов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ИсторияПодарочныхСертификатов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период                                                          КАК Период,
	|	ТабличнаяЧасть.ПодарочныйСертификат                              КАК ПодарочныйСертификат,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.Аннулирован) КАК Статус
	|ИЗ
	|	Документ.АннулированиеПодарочныхСертификатов.ПодарочныеСертификаты КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеДоходы(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеДоходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	ВидСертификата.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ВидСертификата.СтатьяДоходов КАК СтатьяДоходов,
	|	ВидСертификата.АналитикаДоходов КАК АналитикаДоходов,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности) КАК ХозяйственнаяОперация,
	|	
	|	ВЫБОР КОГДА ВидСертификата.Валюта = &ВалютаУправленческогоУчета ТОГДА
	|		Строки.СуммаВВалютеСертификата
	|	ИНАЧЕ
	|		Строки.СуммаВВалютеСертификата
	|			* ЕСТЬNULL(КурсыВалютСерт.Курс, 1) / ЕСТЬNULL(КурсыВалютСерт.Кратность, 1)
	|			/ ЕСТЬNULL(КурсВалютыУпр.Курс, 1) * ЕСТЬNULL(КурсВалютыУпр.Кратность, 1)
	|	КОНЕЦ КАК Сумма,
	|	
	|	(ВЫБОР
	|		КОГДА НЕ &УправленческийУчетОрганизаций ТОГДА 0
	|		КОГДА ВидСертификата.Валюта = &ВалютаУправленческогоУчета
	|			ТОГДА Строки.СуммаВВалютеСертификата
	|		ИНАЧЕ
	|			Строки.СуммаВВалютеСертификата
	|				* ЕСТЬNULL(КурсыВалютСерт.Курс, 1) / ЕСТЬNULL(КурсыВалютСерт.Кратность, 1)
	|				/ ЕСТЬNULL(КурсВалютыУпр.Курс, 1) * ЕСТЬNULL(КурсВалютыУпр.Кратность, 1)
	|		КОНЕЦ) КАК СуммаУпр,
	|	
	|	(ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрочихДоходовРасходовРегл ТОГДА 0
	|		КОГДА ВидСертификата.Валюта = &ВалютаРегламентированногоУчета
	|			ТОГДА Строки.СуммаВВалютеСертификата
	|		ИНАЧЕ
	|			Строки.СуммаВВалютеСертификата
	|				* ЕСТЬNULL(КурсыВалютСерт.Курс, 1) / ЕСТЬNULL(КурсыВалютСерт.Кратность, 1)
	|				/ ЕСТЬNULL(КурсВалютыРегл.Курс, 1) * ЕСТЬNULL(КурсВалютыРегл.Кратность, 1)
	|		КОНЕЦ) КАК СуммаРегл
	|
	|ИЗ
	|	Документ.АннулированиеПодарочныхСертификатов.ПодарочныеСертификаты КАК Строки
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.ВидыПодарочныхСертификатов КАК ВидСертификата
	|	ПО
	|		ВидСертификата.Ссылка = Строки.ПодарочныйСертификат.Владелец
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсыВалютСерт
	|	ПО
	|		КурсыВалютСерт.Валюта = ВидСертификата.Валюта
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсВалютыУпр
	|	ПО
	|		КурсВалютыУпр.Валюта = &ВалютаУправленческогоУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсВалютыРегл
	|	ПО
	|		КурсВалютыРегл.Валюта = &ВалютаРегламентированногоУчета
	|
	|ГДЕ
	|	Строки.Ссылка = &Ссылка
	|	И &ИспользоватьУчетПрочихДоходовРасходов
	|
	|УПОРЯДОЧИТЬ ПО
	|	Строки.НомерСтроки";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаКонтрагентДоходыРасходы(ТекстыЗапроса, Регистры = Неопределено)
	
	ИмяРегистра = "ДвиженияКонтрагентДоходыРасходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.АннулированиеПодарочныхСертификатов) КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК Подразделение,
	|
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКонтрагента,
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	Строки.ПодарочныйСертификат КАК ОбъектРасчетов,
	|
	|	ВидСертификата.НаправлениеДеятельности КАК НаправлениеДеятельностиСтатьи,
	|	ВидСертификата.СтатьяДоходов КАК СтатьяДоходовРасходов,
	|	ВидСертификата.АналитикаДоходов КАК АналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаРасходов,
	|
	|	ВЫБОР КОГДА ВидСертификата.Валюта = &ВалютаУправленческогоУчета ТОГДА
	|		Строки.СуммаВВалютеСертификата
	|	ИНАЧЕ
	|		Строки.СуммаВВалютеСертификата
	|			* ЕСТЬNULL(КурсыВалютСерт.Курс, 1) / ЕСТЬNULL(КурсыВалютСерт.Кратность, 1)
	|			/ ЕСТЬNULL(КурсВалютыУпр.Курс, 1) * ЕСТЬNULL(КурсВалютыУпр.Кратность, 1)
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР КОГДА ВидСертификата.Валюта = &ВалютаРегламентированногоУчета ТОГДА
	|		Строки.СуммаВВалютеСертификата
	|	ИНАЧЕ
	|		Строки.СуммаВВалютеСертификата
	|			* ЕСТЬNULL(КурсыВалютСерт.Курс, 1) / ЕСТЬNULL(КурсыВалютСерт.Кратность, 1)
	|			/ ЕСТЬNULL(КурсВалютыУпр.Курс, 1) * ЕСТЬNULL(КурсВалютыУпр.Кратность, 1)
	|	КОНЕЦ КАК СуммаРегл,
	|
	|	0 КАК СуммаБезНДС,
	|	0 КАК СуммаРеглБезНДС,
	|
	|	ВидСертификата.Валюта КАК Валюта,
	|	Строки.СуммаВВалютеСертификата КАК СуммаВВалюте,
	|	ВидСертификата.Валюта КАК ВалютаВзаиморасчетов,
	|	Строки.СуммаВВалютеСертификата КАК СуммаВВалютеВзаиморасчетов,
	|	0 КАК СуммаБезНДСВВалютеВзаиморасчетов,
	|
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУРасчетов
	|
	|ИЗ
	|	Документ.АннулированиеПодарочныхСертификатов.ПодарочныеСертификаты КАК Строки
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.ВидыПодарочныхСертификатов КАК ВидСертификата
	|	ПО
	|		ВидСертификата.Ссылка = Строки.ПодарочныйСертификат.Владелец
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсыВалютСерт
	|	ПО
	|		КурсыВалютСерт.Валюта = ВидСертификата.Валюта
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсВалютыУпр
	|	ПО
	|		КурсВалютыУпр.Валюта = &ВалютаУправленческогоУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсВалютыРегл
	|	ПО
	|		КурсВалютыРегл.Валюта = &ВалютаРегламентированногоУчета
	|
	|ГДЕ
	|	Строки.Ссылка = &Ссылка
	|	И &ИспользоватьУчетПрочихДоходовРасходов";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

//++ НЕ УТ

Функция ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры)
	ИмяРегистра = "ОтражениеДокументовВРеглУчете";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК ДатаОтражения";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПодарочныеСертификаты);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ИсторияПодарочныхСертификатов);
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
