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
	
	ИзменениеПараметровНМАЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Изменение параметров НМА".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ИзменениеПараметровНМА2_4) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ИзменениеПараметровНМА2_4.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ИзменениеПараметровНМА2_4);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьВнеоборотныеАктивы2_4";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ИзменениеПараметровНМАЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ИзменениеПараметровНМАЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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

#Область СлужебныйПрограммныйИнтерфейс

// Формирует таблицы движений при отложенном проведении.
//
// Параметры:
//  ДокументСсылка			 - ДокументСсылка.ИзменениеПараметровНМА2_4 - Документ, для которого формируются движения
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц - Содержит вспомогательные временные таблицы, которые могут использоваться для формирования движений.
//
Функция ТаблицыОтложенногоФормированияДвижений(ДокументСсылка, МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаСтоимостьНМА(ТекстыЗапроса);
	ТекстЗапросаТаблицаАмортизацияНМА(ТекстыЗапроса);
	ТекстЗапросаДвиженияДоходыРасходыПрочиеАктивыПассивы(ТекстыЗапроса);
	
	ТаблицыДляДвижений = Новый Структура;
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ТаблицыДляДвижений, Истина);
	
	Возврат ТаблицыДляДвижений;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ИзменениеПараметровНМА2_4";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров);
	Иначе
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
	
	ТекстЗапросаТаблицаПорядокУчетаНМА(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПорядокУчетаНМАУУ(ТекстыЗапроса, Регистры);
	
	ТекстЗапросаТаблицаПараметрыАмортизацииНМАУУ(ТекстыЗапроса, Регистры);
	
	ИзменениеПараметровНМАЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИзменениеПараметровНМА) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.ОтражатьВУпрУчете КАК ОтражатьВУпрУчете,
	|	ДанныеДокумента.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ПорядокУчета КАК ПорядокУчета,
	|	ДанныеДокумента.ПорядокУчетаФлаг КАК ПорядокУчетаФлаг,
	|	ДанныеДокумента.СпособНачисленияАмортизацииУУ КАК СпособНачисленияАмортизацииУУ,
	|	ДанныеДокумента.СпособНачисленияАмортизацииУУФлаг КАК СпособНачисленияАмортизацииУУФлаг,
	|	ДанныеДокумента.СрокИспользованияУУ КАК СрокИспользованияУУ,
	|	ДанныеДокумента.СрокИспользованияУУФлаг КАК СрокИспользованияУУФлаг,
	|	ДанныеДокумента.ОбъемНаработки КАК ОбъемНаработки,
	|	ДанныеДокумента.ОбъемНаработкиФлаг КАК ОбъемНаработкиФлаг,
	|	ДанныеДокумента.КоэффициентУскоренияУУ КАК КоэффициентУскоренияУУ,
	|	ДанныеДокумента.КоэффициентУскоренияУУФлаг КАК КоэффициентУскоренияУУФлаг,
	|	ДанныеДокумента.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
	|	ДанныеДокумента.ЛиквидационнаяСтоимостьФлаг КАК ЛиквидационнаяСтоимостьФлаг,
	|	ДанныеДокумента.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ДанныеДокумента.ГруппаФинансовогоУчетаФлаг КАК ГруппаФинансовогоУчетаФлаг,
	|	ДанныеДокумента.АмортизационныеРасходыФлаг КАК АмортизационныеРасходыФлаг,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	&ИзменениеПараметровНМА_РеквизитыДокумента
	|ИЗ
	|	Документ.ИзменениеПараметровНМА2_4 КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ИзменениеПараметровНМАЛокализация.ДобавитьВТекстЗапросаРеквизитыДокумента(Запрос.Текст, "ДанныеДокумента");
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)
	
	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ИзменениеПараметровНМА2_4"));
	ЗначенияПараметровПроведения.Вставить("СтатьяАП_НМА", ПланыВидовХарактеристик.СтатьиАктивовПассивов.НематериальныеАктивы);
	ЗначенияПараметровПроведения.Вставить("НазваниеДокумента", НСтр("ru = 'Изменение параметров НМА';
																	|en = 'Change of IA parameters'"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ИзменениеПараметровНМА);
	ЗначенияПараметровПроведения.Вставить("ДатаНачалаУчета", ВнеоборотныеАктивыЛокализация.ДатаНачалаУчетаВнеоборотныхАктивов2_4());
	
	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли;
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоНМА";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаНМА.НомерСтроки-1, 0) КАК НомерЗаписи,
	|	&Ссылка                          КАК Ссылка,
	|	ТаблицаНМА.НематериальныйАктив   КАК НематериальныйАктив,
	|	&ХозяйственнаяОперация           КАК ХозяйственнаяОперация,
	|	&Организация                     КАК Организация,
	|	НЕОПРЕДЕЛЕНО                     КАК Подразделение,
	|	&Период                          КАК Дата,
	|	&ИдентификаторМетаданных         КАК ТипСсылки,
	|	&Проведен                        КАК Проведен,
	|	&ОтражатьВУпрУчете               КАК ОтражатьВУпрУчете,
	|	&ОтражатьВРеглУчете              КАК ОтражатьВРеглУчете
	|ИЗ
	|	Документ.ИзменениеПараметровНМА2_4 КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеПараметровНМА2_4.НМА КАК ТаблицаНМА
	|		ПО ТаблицаНМА.Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Ссылка                        КАК Ссылка,
	|	&Период                        КАК ДатаДокументаИБ,
	|	&Номер                         КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных       КАК ТипСсылки,
	|	&Организация                   КАК Организация,
	|	&ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                   КАК НаправлениеДеятельности,
	|	&Ответственный                 КАК Ответственный,
	|	&Комментарий                   КАК Комментарий,
	|	&Проведен                      КАК Проведен,
	|	&ПометкаУдаления               КАК ПометкаУдаления,
	|	ЛОЖЬ                           КАК ДополнительнаяЗапись,
	|	&Период                        КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                 КАК НомерПервичногоДокумента,
	|	&Период    КАК ДатаОтраженияВУчете
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПорядокУчетаНМА(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПорядокУчетаНМА";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаПорядокУчетаНМА(ТекстыЗапроса, "Документ.ИзменениеПараметровНМА2_4");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	&Организация КАК Организация,
	|	
	|	ВЫБОР
	|		КОГДА &ГруппаФинансовогоУчетаФлаг
	|			ТОГДА &ГруппаФинансовогоУчета
	|		ИНАЧЕ ПорядокУчетаНМА.ГруппаФинансовогоУчета
	|	КОНЕЦ КАК ГруппаФинансовогоУчета,
	|	ВЫБОР
	|		КОГДА &ОбъемНаработкиФлаг
	|			ТОГДА &ОбъемНаработки
	|		ИНАЧЕ ПорядокУчетаНМА.ОбъемНаработки
	|	КОНЕЦ КАК ОбъемНаработки,
	|	ПорядокУчетаНМА.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	
	|	&ОтражатьВУпрУчете КАК ОтражатьВУпрУчете,
	|	&ОтражатьВРеглУчете КАК ОтражатьВРеглУчете
	|ИЗ
	|	Документ.ИзменениеПараметровНМА2_4.НМА КАК ТаблицаНМА
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПорядокУчетаНМА КАК ПорядокУчетаНМА
	|		ПО ПорядокУчетаНМА.НематериальныйАктив = ТаблицаНМА.НематериальныйАктив
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|	И (&ГруппаФинансовогоУчетаФлаг
	|		ИЛИ &ОбъемНаработкиФлаг)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаПорядокУчетаНМАУУ(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПорядокУчетаНМАУУ";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаПорядокУчетаНМАУУ(ТекстыЗапроса, "Документ.ИзменениеПараметровНМА2_4");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	&Организация КАК Организация,
	|	
	|	ПорядокУчета.Состояние КАК Состояние,
	|	ВЫБОР
	|		КОГДА &ПорядокУчетаФлаг
	|			ТОГДА &ПорядокУчета = ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию)
	|		ИНАЧЕ ПорядокУчета.НачислятьАмортизациюУУ
	|	КОНЕЦ КАК НачислятьАмортизациюУУ,
	|	ВЫБОР
	|		КОГДА &АмортизационныеРасходыФлаг
	|			ТОГДА &Ссылка
	|		ИНАЧЕ ПорядокУчета.СпособОтраженияРасходов
	|	КОНЕЦ КАК СпособОтраженияРасходов,
	|	ВЫБОР
	|		КОГДА &АмортизационныеРасходыФлаг
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ПорядокУчета.СтатьяРасходов
	|	КОНЕЦ КАК СтатьяРасходов,
	|	ВЫБОР
	|		КОГДА &АмортизационныеРасходыФлаг
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ПорядокУчета.АналитикаРасходов
	|	КОНЕЦ КАК АналитикаРасходов,
	|	ВЫБОР
	|		КОГДА &АмортизационныеРасходыФлаг
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ПорядокУчета.ПередаватьРасходыВДругуюОрганизацию
	|	КОНЕЦ КАК ПередаватьРасходыВДругуюОрганизацию,
	|	ВЫБОР
	|		КОГДА &АмортизационныеРасходыФлаг
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|		ИНАЧЕ ПорядокУчета.ОрганизацияПолучательРасходов
	|	КОНЕЦ КАК ОрганизацияПолучательРасходов
	|ИЗ
	|	Документ.ИзменениеПараметровНМА2_4.НМА КАК ТаблицаНМА
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПорядокУчетаНМАУУ КАК ПорядокУчета
	|		ПО ПорядокУчета.НематериальныйАктив = ТаблицаНМА.НематериальныйАктив
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|	И &ОтражатьВУпрУчете
	|	И (&ПорядокУчетаФлаг
	|		ИЛИ &АмортизационныеРасходыФлаг)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаПараметрыАмортизацииНМАУУ(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПараметрыАмортизацииНМАУУ";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаПараметрыАмортизацииНМАУУ(ТекстыЗапроса, "Документ.ИзменениеПараметровНМА2_4");
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	&Организация КАК Организация,
	|	
	|	ВЫБОР
	|		КОГДА &СрокИспользованияУУФлаг
	|			ТОГДА &СрокИспользованияУУ
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.СрокИспользования, 0)
	|	КОНЕЦ КАК СрокИспользования,
	|	ВЫБОР
	|		КОГДА &КоэффициентУскоренияУУФлаг
	|			ТОГДА &КоэффициентУскоренияУУ
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.КоэффициентУскорения, 0)
	|	КОНЕЦ КАК КоэффициентУскорения,
	|	ВЫБОР
	|		КОГДА &СпособНачисленияАмортизацииУУФлаг
	|			ТОГДА &СпособНачисленияАмортизацииУУ
	|		ИНАЧЕ ПараметрыАмортизацииНМАУУ.МетодНачисленияАмортизации
	|	КОНЕЦ КАК МетодНачисленияАмортизации,
	|	ВЫБОР
	|		КОГДА &ЛиквидационнаяСтоимостьФлаг
	|			ТОГДА &ЛиквидационнаяСтоимость
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.ЛиквидационнаяСтоимость, 0)
	|	КОНЕЦ КАК ЛиквидационнаяСтоимость
	|ИЗ
	|	Документ.ИзменениеПараметровНМА2_4.НМА КАК ТаблицаНМА
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПараметрыАмортизацииНМАУУ КАК ПараметрыАмортизацииНМАУУ
	|		ПО ПараметрыАмортизацииНМАУУ.НематериальныйАктив = ТаблицаНМА.НематериальныйАктив
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|	И &ОтражатьВУпрУчете
	|	И (&СрокИспользованияУУФлаг
	|		ИЛИ &КоэффициентУскоренияУУФлаг
	|		ИЛИ &СпособНачисленияАмортизацииУУФлаг
	|		ИЛИ &ЛиквидационнаяСтоимостьФлаг)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаСтоимостьНМА(ТекстыЗапроса)

	ИмяРегистра = "СтоимостьНМА";
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаНМА(ТекстыЗапроса, "Документ.ИзменениеПараметровНМА2_4");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
	|	&Ссылка                                 КАК Регистратор,
	|	&Период                                 КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИзменениеПараметровСтоимостиНМА) КАК ХозяйственнаяОперация,
	|	&Организация                            КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив          КАК НематериальныйАктив,
	|	ТаблицаНМА.Подразделение                КАК Подразделение,
	|	ТаблицаНМА.ГруппаФинансовогоУчета       КАК ГруппаФинансовогоУчета,
	|	ТаблицаНМА.НаправлениеДеятельности      КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                            КАК Контрагент,
	|	СтоимостьНМА.Стоимость                  КАК Стоимость,
	|	СтоимостьНМА.СтоимостьРегл              КАК СтоимостьРегл,
	|	СтоимостьНМА.СтоимостьНУ                КАК СтоимостьНУ,
	|	СтоимостьНМА.СтоимостьПР                КАК СтоимостьПР,
	|	СтоимостьНМА.СтоимостьВР                КАК СтоимостьВР,
	|	СтоимостьНМА.СтоимостьЦФ                КАК СтоимостьЦФ,
	|	СтоимостьНМА.СтоимостьНУЦФ              КАК СтоимостьНУЦФ,
	|	СтоимостьНМА.СтоимостьПРЦФ              КАК СтоимостьПРЦФ,
	|	СтоимостьНМА.СтоимостьВРЦФ              КАК СтоимостьВРЦФ,
	|	СтоимостьНМА.ПредварительнаяСтоимость   КАК ПредварительнаяСтоимость,
	|	СтоимостьНМА.РезервПереоценкиСтоимости  КАК РезервПереоценкиСтоимости,
	|	&Организация                            КАК КорОрганизация,
	|	ТаблицаНМА.Подразделение                КАК КорПодразделение,
	|	ТаблицаНМА.НаправлениеДеятельности      КАК КорНаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                            КАК КорСтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО                            КАК КорАналитикаРасходов,
	|	&ГруппаФинансовогоУчета                 КАК КорГруппаФинансовогоУчета
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СтоимостьВНА КАК СтоимостьНМА
	|		ПО СтоимостьНМА.ОбъектУчета = ТаблицаНМА.НематериальныйАктив
	|			И СтоимостьНМА.Ссылка = &Ссылка
	|ГДЕ
	|	&ГруппаФинансовогоУчетаФлаг
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)  КАК ВидДвижения,
	|	&Ссылка                                 КАК Регистратор,
	|	&Период                                 КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИзменениеПараметровСтоимостиНМА) КАК ХозяйственнаяОперация,
	|	&Организация                            КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив          КАК НематериальныйАктив,
	|	ТаблицаНМА.Подразделение                КАК Подразделение,
	|	&ГруппаФинансовогоУчета                 КАК ГруппаФинансовогоУчета,
	|	ТаблицаНМА.НаправлениеДеятельности      КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                            КАК Контрагент,
	|	СтоимостьНМА.Стоимость                  КАК Стоимость,
	|	СтоимостьНМА.СтоимостьРегл              КАК СтоимостьРегл,
	|	СтоимостьНМА.СтоимостьНУ                КАК СтоимостьНУ,
	|	СтоимостьНМА.СтоимостьПР                КАК СтоимостьПР,
	|	СтоимостьНМА.СтоимостьВР                КАК СтоимостьВР,
	|	СтоимостьНМА.СтоимостьЦФ                КАК СтоимостьЦФ,
	|	СтоимостьНМА.СтоимостьНУЦФ              КАК СтоимостьНУЦФ,
	|	СтоимостьНМА.СтоимостьПРЦФ              КАК СтоимостьПРЦФ,
	|	СтоимостьНМА.СтоимостьВРЦФ              КАК СтоимостьВРЦФ,
	|	СтоимостьНМА.ПредварительнаяСтоимость   КАК ПредварительнаяСтоимость,
	|	СтоимостьНМА.РезервПереоценкиСтоимости  КАК РезервПереоценкиСтоимости,
	|	&Организация                            КАК КорОрганизация,
	|	ТаблицаНМА.Подразделение                КАК КорПодразделение,
	|	ТаблицаНМА.НаправлениеДеятельности      КАК КорНаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                            КАК КорСтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО                            КАК КорАналитикаРасходов,
	|	ТаблицаНМА.ГруппаФинансовогоУчета       КАК КорГруппаФинансовогоУчета
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СтоимостьВНА КАК СтоимостьНМА
	|		ПО СтоимостьНМА.ОбъектУчета = ТаблицаНМА.НематериальныйАктив
	|			И СтоимостьНМА.Ссылка = &Ссылка
	|ГДЕ
	|	&ГруппаФинансовогоУчетаФлаг";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаАмортизацияНМА(ТекстыЗапроса)

	ИмяРегистра = "АмортизацияНМА";
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаНМА(ТекстыЗапроса, "Документ.ИзменениеПараметровНМА2_4");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)     КАК ВидДвижения,
	|	&Ссылка                                    КАК Регистратор,
	|	&Период                                    КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИзменениеПараметровАмортизацииНМА) КАК ХозяйственнаяОперация,
	|	&Организация                               КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив             КАК НематериальныйАктив,
	|	ТаблицаНМА.Подразделение                   КАК Подразделение,
	|	ТаблицаНМА.ГруппаФинансовогоУчета          КАК ГруппаФинансовогоУчета,
	|	ТаблицаНМА.НаправлениеДеятельности         КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                               КАК Контрагент,
	|	АмортизацияНМА.Амортизация                 КАК Амортизация,
	|	АмортизацияНМА.АмортизацияРегл             КАК АмортизацияРегл,
	|	АмортизацияНМА.АмортизацияНУ               КАК АмортизацияНУ,
	|	АмортизацияНМА.АмортизацияПР               КАК АмортизацияПР,
	|	АмортизацияНМА.АмортизацияВР               КАК АмортизацияВР,
	|	АмортизацияНМА.АмортизацияЦФ               КАК АмортизацияЦФ,
	|	АмортизацияНМА.АмортизацияНУЦФ             КАК АмортизацияНУЦФ,
	|	АмортизацияНМА.АмортизацияПРЦФ             КАК АмортизацияПРЦФ,
	|	АмортизацияНМА.АмортизацияВРЦФ             КАК АмортизацияВРЦФ,
	|	АмортизацияНМА.РезервПереоценкиАмортизации КАК РезервПереоценкиАмортизации,
	|	&Организация                               КАК КорОрганизация,
	|	ТаблицаНМА.Подразделение                   КАК КорПодразделение,
	|	ТаблицаНМА.НаправлениеДеятельности         КАК КорНаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                               КАК КорСтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО                               КАК КорАналитикаРасходов,
	|	&ГруппаФинансовогоУчета                    КАК КорГруппаФинансовогоУчета
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АмортизацияВНА КАК АмортизацияНМА
	|		ПО АмортизацияНМА.ОбъектУчета = ТаблицаНМА.НематериальныйАктив
	|			И АмортизацияНМА.Ссылка = &Ссылка
	|ГДЕ
	|	&ГруппаФинансовогоУчетаФлаг
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)     КАК ВидДвижения,
	|	&Ссылка                                    КАК Регистратор,
	|	&Период                                    КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИзменениеПараметровАмортизацииОС) КАК ХозяйственнаяОперация,
	|	&Организация                               КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив             КАК НематериальныйАктив,
	|	ТаблицаНМА.Подразделение                   КАК Подразделение,
	|	&ГруппаФинансовогоУчета                    КАК ГруппаФинансовогоУчета,
	|	ТаблицаНМА.НаправлениеДеятельности         КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                               КАК Контрагент,
	|	АмортизацияНМА.Амортизация                 КАК Амортизация,
	|	АмортизацияНМА.АмортизацияРегл             КАК АмортизацияРегл,
	|	АмортизацияНМА.АмортизацияНУ               КАК АмортизацияНУ,
	|	АмортизацияНМА.АмортизацияПР               КАК АмортизацияПР,
	|	АмортизацияНМА.АмортизацияВР               КАК АмортизацияВР,
	|	АмортизацияНМА.АмортизацияЦФ               КАК АмортизацияЦФ,
	|	АмортизацияНМА.АмортизацияНУЦФ             КАК АмортизацияНУЦФ,
	|	АмортизацияНМА.АмортизацияПРЦФ             КАК АмортизацияПРЦФ,
	|	АмортизацияНМА.АмортизацияВРЦФ             КАК АмортизацияВРЦФ,
	|	АмортизацияНМА.РезервПереоценкиАмортизации КАК РезервПереоценкиАмортизации,
	|	&Организация                               КАК КорОрганизация,
	|	ТаблицаНМА.Подразделение                   КАК КорПодразделение,
	|	ТаблицаНМА.НаправлениеДеятельности         КАК КорНаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                               КАК КорСтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО                               КАК КорАналитикаРасходов,
	|	ТаблицаНМА.ГруппаФинансовогоУчета          КАК КорГруппаФинансовогоУчета
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АмортизацияВНА КАК АмортизацияНМА
	|		ПО АмортизацияНМА.ОбъектУчета = ТаблицаНМА.НематериальныйАктив
	|			И АмортизацияНМА.Ссылка = &Ссылка
	|ГДЕ
	|	&ГруппаФинансовогоУчетаФлаг";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаДвиженияДоходыРасходыПрочиеАктивыПассивы(ТекстыЗапроса)

	ИмяРегистра = "ДвиженияДоходыРасходыПрочиеАктивыПассивы";
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаНМА(ТекстыЗапроса, "Документ.ИзменениеПараметровНМА2_4");
	
	ТекстЗапроса =
	// Перемещение амортизации
	"ВЫБРАТЬ
	|	&Период                                      КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИзменениеПараметровАмортизацииНМА) КАК ХозяйственнаяОперация,
	|	&Организация                                 КАК Организация,
	|
	|	ТаблицаНМА.Подразделение                     КАК Подразделение,
	|	ТаблицаНМА.НаправлениеДеятельности           КАК НаправлениеДеятельности,
	|	&СтатьяАП_НМА                                КАК Статья,
	|	НЕОПРЕДЕЛЕНО                                 КАК АналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО                                 КАК АналитикаРасходов,
	|	ТаблицаНМА.НематериальныйАктив               КАК АналитикаАктивовПассивов,
	|	ТаблицаНМА.ГруппаФинансовогоУчета            КАК ГруппаФинансовогоУчета,
	|
	|	ТаблицаНМА.Подразделение                     КАК КорПодразделение,
	|	ТаблицаНМА.НаправлениеДеятельности           КАК КорНаправлениеДеятельности,
	|	&СтатьяАП_НМА                                КАК КорСтатья,
	|	НЕОПРЕДЕЛЕНО                                 КАК КорАналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО                                 КАК КорАналитикаРасходов,
	|	ТаблицаНМА.НематериальныйАктив               КАК КорАналитикаАктивовПассивов,
	|	&ГруппаФинансовогоУчета                      КАК КорГруппаФинансовогоУчета,
	|
	|	&Организация                                 КАК КорОрганизация,
	|
	|	АмортизацияНМА.Амортизация                   КАК Сумма,
	|	АмортизацияНМА.Амортизация                   КАК СуммаУпр,
	|	АмортизацияНМА.АмортизацияРегл + АмортизацияНМА.АмортизацияЦФ КАК СуммаРегл
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АмортизацияВНА КАК АмортизацияНМА
	|		ПО АмортизацияНМА.ОбъектУчета = ТаблицаНМА.НематериальныйАктив
	|			И АмортизацияНМА.Ссылка = &Ссылка
	|ГДЕ
	|	&ГруппаФинансовогоУчетаФлаг
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	// Перемещение стоимости
	|ВЫБРАТЬ
	|	&Период                                      КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИзменениеПараметровСтоимостиНМА) КАК ХозяйственнаяОперация,
	|	&Организация                                 КАК Организация,
	|
	|	ТаблицаНМА.Подразделение                     КАК Подразделение,
	|	ТаблицаНМА.НаправлениеДеятельности           КАК НаправлениеДеятельности,
	|	&СтатьяАП_НМА                                КАК Статья,
	|	НЕОПРЕДЕЛЕНО                                 КАК АналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО                                 КАК АналитикаРасходов,
	|	ТаблицаНМА.НематериальныйАктив               КАК АналитикаАктивовПассивов,
	|	ТаблицаНМА.ГруппаФинансовогоУчета            КАК ГруппаФинансовогоУчета,
	|
	|	ТаблицаНМА.Подразделение                     КАК КорПодразделение,
	|	ТаблицаНМА.НаправлениеДеятельности           КАК КорНаправлениеДеятельности,
	|	&СтатьяАП_НМА                                КАК КорСтатья,
	|	НЕОПРЕДЕЛЕНО                                 КАК КорАналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО                                 КАК КорАналитикаРасходов,
	|	ТаблицаНМА.НематериальныйАктив               КАК КорАналитикаАктивовПассивов,
	|	&ГруппаФинансовогоУчета                      КАК КорГруппаФинансовогоУчета,
	|
	|	&Организация                                 КАК КорОрганизация,
	|
	|	СтоимостьНМА.Стоимость                       КАК Сумма,
	|	СтоимостьНМА.Стоимость                       КАК СуммаУпр,
	|	СтоимостьНМА.СтоимостьРегл + СтоимостьНМА.СтоимостьЦФ КАК СуммаРегл
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СтоимостьВНА КАК СтоимостьНМА
	|		ПО СтоимостьНМА.ОбъектУчета = ТаблицаНМА.НематериальныйАктив
	|			И СтоимостьНМА.Ссылка = &Ссылка
	|ГДЕ
	|	&ГруппаФинансовогоУчетаФлаг";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ИзменениеПараметровНМАЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ИзменениеПараметровНМАЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
