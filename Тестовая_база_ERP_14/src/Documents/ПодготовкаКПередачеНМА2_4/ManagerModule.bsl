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
	
	Документы.РеализацияУслугПрочихАктивов.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	ПодготовкаКПередачеНМАЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Подготовка к передаче НМА".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПодготовкаКПередачеНМА2_4) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПодготовкаКПередачеНМА2_4.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПодготовкаКПередачеНМА2_4);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьВнеоборотныеАктивы2_4";
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
	
	
	
	ПодготовкаКПередачеНМАЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

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
//  ДокументСсылка			 - ДокументСсылка.ПеремещениеНМА2_4 - Документ, для которого формируются движения
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц - Содержит вспомогательные временные таблицы, которые могут использоваться для формирования движений.
//
Функция ТаблицыОтложенногоФормированияДвижений(ДокументСсылка, МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаСтоимостьНМА(ТекстыЗапроса);
	ТекстЗапросаТаблицаАмортизацияНМА(ТекстыЗапроса);
	ТекстЗапросаТаблицаДвиженияДоходыРасходыПрочиеАктивыПассивы(ТекстыЗапроса);
	
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

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ПодготовкаКПередачеНМА2_4";
	
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
	ТекстЗапросаТаблицаПорядокУчетаНМАУУ(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПервоначальныеСведенияНМА(ТекстыЗапроса, Регистры);
	
	ПодготовкаКПередачеНМАЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                 КАК Ссылка,
	|	ДанныеДокумента.ОтражатьВУпрУчете      КАК ОтражатьВУпрУчете,
	|	ДанныеДокумента.ОтражатьВРеглУчете     КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.Дата                   КАК Период,
	|	ДанныеДокумента.Номер                  КАК Номер,
	|	ДанныеДокумента.Организация            КАК Организация,
	|	ДанныеДокумента.Подразделение          КАК Подразделение,
	|	ДанныеДокумента.Ответственный          КАК Ответственный,
	|	ДанныеДокумента.Комментарий            КАК Комментарий,
	|	ДанныеДокумента.Проведен               КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления        КАК ПометкаУдаления,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПодготовкаКПередачеНМА) КАК ХозяйственнаяОперация
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА2_4 КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("КонецДня", Новый Граница(КонецДня(Реквизиты.Период), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("НазваниеДокумента", НСтр("ru = 'Подготовка к передаче НМА';
														|en = 'Preparation for IA handover'"));
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	

КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)
	
	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПодготовкаКПередачеНМА2_4"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПодготовкаКПередачеНМА);
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперацияСтоимость", Перечисления.ХозяйственныеОперации.СписаниеСтоимостиНМА);
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперацияАмортизация", Перечисления.ХозяйственныеОперации.СписаниеАмортизацииНМА);
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперацияРезервСтоимость", Перечисления.ХозяйственныеОперации.СписаниеРезерваПереоценкиСтоимостиНМА);
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперацияРезервАмортизация", Перечисления.ХозяйственныеОперации.СписаниеРезерваПереоценкиАмортизацииНМА);
	ЗначенияПараметровПроведения.Вставить("СтатьяАП_НМА", ПланыВидовХарактеристик.СтатьиАктивовПассивов.НематериальныеАктивы);
	
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
	|	&Подразделение                   КАК Подразделение,
	|	&Период                          КАК Дата,
	|	&ИдентификаторМетаданных         КАК ТипСсылки,
	|	&Проведен                        КАК Проведен,
	|	&ОтражатьВУпрУчете               КАК ОтражатьВУпрУчете,
	|	&ОтражатьВРеглУчете              КАК ОтражатьВРеглУчете
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА2_4 КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			Документ.ПодготовкаКПередачеНМА2_4.НМА КАК ТаблицаНМА
	|		ПО
	|			ТаблицаНМА.Ссылка = ДанныеДокумента.Ссылка
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
	|	&Подразделение                 КАК Подразделение,
	|	&Ответственный                 КАК Ответственный,
	|	&Комментарий                   КАК Комментарий,
	|	&Проведен                      КАК Проведен,
	|	&ПометкаУдаления               КАК ПометкаУдаления,
	|	ЛОЖЬ                           КАК ДополнительнаяЗапись,
	|	&Период                        КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                 КАК НомерПервичногоДокумента,
	|	&Период   КАК ДатаОтраженияВУчете
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПорядокУчетаНМАУУ(ТекстыЗапроса, Регистры)

	ИмяРегистра = "ПорядокУчетаНМАУУ";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтСписокНМА(ТекстыЗапроса, ПолноеИмяОбъекта());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период                          КАК Период,
	|	&Организация                     КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив   КАК НематериальныйАктив,
	|	ЛОЖЬ                             КАК НачислятьАмортизациюУУ,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.Списан) КАК Состояние
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА2_4.НМА КАК ТаблицаНМА
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАУУ.СрезПоследних(
	|		&КонецДня,
	|		Регистратор <> &Ссылка 
	|		И (НематериальныйАктив, Организация) В (ВЫБРАТЬ СписокНМА.НематериальныйАктив, СписокНМА.Организация ИЗ втСписокНМА КАК СписокНМА)) КАК ПорядокУчета
	|	ПО ТаблицаНМА.НематериальныйАктив = ПорядокУчета.НематериальныйАктив
	|		И ПорядокУчета.Организация = &Организация
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|	И &ОтражатьВУпрУчете";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаПервоначальныеСведенияНМА(ТекстыЗапроса, Регистры)

	ИмяРегистра = "ПервоначальныеСведенияНМА";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтСписокНМА(ТекстыЗапроса, ПолноеИмяОбъекта());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период                                                     КАК Период,
	|	&Организация                                                КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив                              КАК НематериальныйАктив,
	|	ПервоначальныеСведения.СпособПоступления                    КАК СпособПоступления,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьБУ            КАК ПервоначальнаяСтоимостьБУ,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьНУ            КАК ПервоначальнаяСтоимостьНУ,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьПР            КАК ПервоначальнаяСтоимостьПР,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьВР            КАК ПервоначальнаяСтоимостьВР,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьУУ            КАК ПервоначальнаяСтоимостьУУ,
	|	ПервоначальныеСведения.МетодНачисленияАмортизацииБУ         КАК МетодНачисленияАмортизацииБУ,
	|	ПервоначальныеСведения.МетодНачисленияАмортизацииНУ         КАК МетодНачисленияАмортизацииНУ,
	|	ПервоначальныеСведения.Коэффициент                          КАК Коэффициент,
	|	ПервоначальныеСведения.АмортизацияДо2002                    КАК АмортизацияДо2002,
	|	ПервоначальныеСведения.АмортизацияДо2009                    КАК АмортизацияДо2009,
	|	ПервоначальныеСведения.СтоимостьДо2002                      КАК СтоимостьДо2002,
	|	ПервоначальныеСведения.ФактическийСрокИспользованияДо2009   КАК ФактическийСрокИспользованияДо2009,
	|	ПервоначальныеСведения.ДатаПриобретения                     КАК ДатаПриобретения,
	|	ПервоначальныеСведения.ДатаПринятияКУчетуУУ                 КАК ДатаПринятияКУчетуУУ,
	|	ПервоначальныеСведения.ДатаПринятияКУчетуБУ                 КАК ДатаПринятияКУчетуБУ,
	|	ПервоначальныеСведения.ДокументПринятияКУчетуУУ             КАК ДокументПринятияКУчетуУУ,
	|	ПервоначальныеСведения.ДокументПринятияКУчетуБУ             КАК ДокументПринятияКУчетуБУ,
	|	ПервоначальныеСведения.ПорядокУчетаНУ             			КАК ПорядокУчетаНУ,
	|	&Ссылка                                                     КАК ДокументСписания
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА2_4.НМА КАК ТаблицаНМА
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА.СрезПоследних(
	|		&КонецДня,
	|		Регистратор <> &Ссылка 
	|		И (НематериальныйАктив, Организация) В (ВЫБРАТЬ СписокНМА.НематериальныйАктив, СписокНМА.Организация ИЗ втСписокНМА КАК СписокНМА)) КАК ПервоначальныеСведения
	|	ПО ТаблицаНМА.НематериальныйАктив = ПервоначальныеСведения.НематериальныйАктив
	|		И ПервоначальныеСведения.Организация = &Организация
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|	И &ОтражатьВРеглУчете";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаСтоимостьНМА(ТекстыЗапроса)

	ИмяРегистра = "СтоимостьНМА";
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаНМА(ТекстыЗапроса, ПолноеИмяОбъекта());
	
	ТекстЗапроса =
	"// Списание амортизации
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	&Организация                           КАК Организация,
	|	&Подразделение                         КАК Подразделение,
	|	АмортизацияВНА.ОбъектУчета             КАК НематериальныйАктив,
	|
	|	АмортизацияВНА.Амортизация             КАК Стоимость,
	|	АмортизацияВНА.АмортизацияРегл         КАК СтоимостьРегл,
	|	АмортизацияВНА.АмортизацияНУ           КАК СтоимостьНУ,
	|	АмортизацияВНА.АмортизацияПР           КАК СтоимостьПР,
	|	АмортизацияВНА.АмортизацияВР           КАК СтоимостьВР,
	|	АмортизацияВНА.АмортизацияЦФ           КАК СтоимостьЦФ,
	|	АмортизацияВНА.АмортизацияНУЦФ         КАК СтоимостьНУЦФ,
	|	АмортизацияВНА.АмортизацияПРЦФ         КАК СтоимостьПРЦФ,
	|	АмортизацияВНА.АмортизацияВРЦФ         КАК СтоимостьВРЦФ,
	|	0                                      КАК РезервПереоценкиСтоимости,
	|	0                                      КАК РезервПереоценкиСтоимостиРегл,
	|	
	|	ТаблицаНМА.ГруппаФинансовогоУчета      КАК ГруппаФинансовогоУчета,
	|	ТаблицаНМА.НаправлениеДеятельности     КАК НаправлениеДеятельности,
	|	&ХозяйственнаяОперацияАмортизация      КАК ХозяйственнаяОперация,
	|	&ОтражатьВРеглУчете                    КАК ОтражатьВРеглУчете,
	|	&ОтражатьВУпрУчете                     КАК ОтражатьВУпрУчете
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АмортизацияВНА КАК АмортизацияВНА
	|		ПО ТаблицаНМА.НематериальныйАктив = АмортизацияВНА.ОбъектУчета
	|			И АмортизацияВНА.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Списание резерва доценки
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	&Организация                           КАК Организация,
	|	&Подразделение                         КАК Подразделение,
	|	СтоимостьВНА.ОбъектУчета               КАК НематериальныйАктив,
	|
	|	0                                      КАК Стоимость,
	|	0                                      КАК СтоимостьРегл,
	|	0                                      КАК СтоимостьНУ,
	|	0                                      КАК СтоимостьПР,
	|	0                                      КАК СтоимостьВР,
	|	0                                      КАК СтоимостьЦФ,
	|	0                                      КАК СтоимостьНУЦФ,
	|	0                                      КАК СтоимостьПРЦФ,
	|	0                                      КАК СтоимостьВРЦФ,
	|	СтоимостьВНА.РезервПереоценкиСтоимости       КАК РезервПереоценкиСтоимости,
	|	СтоимостьВНА.РезервПереоценкиСтоимостиРегл   КАК РезервПереоценкиСтоимостиРегл,
	|	
	|	ТаблицаНМА.ГруппаФинансовогоУчета      КАК ГруппаФинансовогоУчета,
	|	ТаблицаНМА.НаправлениеДеятельности     КАК НаправлениеДеятельности,
	|	&ХозяйственнаяОперацияРезервСтоимость  КАК ХозяйственнаяОперация,
	|	&ОтражатьВРеглУчете                    КАК ОтражатьВРеглУчете,
	|	&ОтражатьВУпрУчете                     КАК ОтражатьВУпрУчете
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СтоимостьВНА КАК СтоимостьВНА
	|		ПО ТаблицаНМА.НематериальныйАктив = СтоимостьВНА.ОбъектУчета
	|			И СтоимостьВНА.Ссылка = &Ссылка
	|
	|ГДЕ
	|	(СтоимостьВНА.РезервПереоценкиСтоимости <> 0
	|		ИЛИ СтоимостьВНА.РезервПереоценкиСтоимостиРегл <> 0)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаАмортизацияНМА(ТекстыЗапроса)

	ИмяРегистра = "АмортизацияНМА";
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаНМА(ТекстыЗапроса, ПолноеИмяОбъекта());
	
	ТекстЗапроса =
	// Списание амортизации
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	&Организация                           КАК Организация,
	|	&Подразделение                         КАК Подразделение,
	|	АмортизацияВНА.ОбъектУчета             КАК НематериальныйАктив,
	|
	|	АмортизацияВНА.Амортизация             КАК Амортизация,
	|	АмортизацияВНА.АмортизацияРегл         КАК АмортизацияРегл,
	|	АмортизацияВНА.АмортизацияНУ           КАК АмортизацияНУ,
	|	АмортизацияВНА.АмортизацияПР           КАК АмортизацияПР,
	|	АмортизацияВНА.АмортизацияВР           КАК АмортизацияВР,
	|	АмортизацияВНА.АмортизацияЦФ           КАК АмортизацияЦФ,
	|	АмортизацияВНА.АмортизацияНУЦФ         КАК АмортизацияНУЦФ,
	|	АмортизацияВНА.АмортизацияПРЦФ         КАК АмортизацияПРЦФ,
	|	АмортизацияВНА.АмортизацияВРЦФ         КАК АмортизацияВРЦФ,
	|	АмортизацияВНА.РезервПереоценкиАмортизации     КАК РезервПереоценкиАмортизации,
	|	АмортизацияВНА.РезервПереоценкиАмортизацииРегл КАК РезервПереоценкиАмортизацииРегл,
	|	
	|	ТаблицаНМА.ГруппаФинансовогоУчета      КАК ГруппаФинансовогоУчета,
	|	ТаблицаНМА.НаправлениеДеятельности     КАК НаправлениеДеятельности,
	|	&ХозяйственнаяОперацияАмортизация      КАК ХозяйственнаяОперация,
	|	&ОтражатьВРеглУчете                    КАК ОтражатьВРеглУчете,
	|	&ОтражатьВУпрУчете                     КАК ОтражатьВУпрУчете
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АмортизацияВНА КАК АмортизацияВНА
	|		ПО ТаблицаНМА.НематериальныйАктив = АмортизацияВНА.ОбъектУчета
	|			И АмортизацияВНА.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаДвиженияДоходыРасходыПрочиеАктивыПассивы(ТекстыЗапроса)

	ИмяРегистра = "ДвиженияДоходыРасходыПрочиеАктивыПассивы";
	
	Если ПроведениеСерверУТ.ЕстьТаблицаЗапроса(ИмяРегистра, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаНМА(ТекстыЗапроса, ПолноеИмяОбъекта());
	
	ТекстЗапроса =
	"// Списание амортизации
	|ВЫБРАТЬ
	|	&Период                             КАК Период,
	|	&ХозяйственнаяОперацияАмортизация   КАК ХозяйственнаяОперация,
	|	&Организация                        КАК Организация,
	|
	|	&Подразделение                      КАК Подразделение,
	|	ТаблицаНМА.НаправлениеДеятельности  КАК НаправлениеДеятельности,
	|	&СтатьяАП_НМА                       КАК Статья,
	|	НЕОПРЕДЕЛЕНО                        КАК АналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО                        КАК АналитикаРасходов,
	|	ТаблицаНМА.НематериальныйАктив      КАК АналитикаАктивовПассивов,
	|	ТаблицаНМА.ГруппаФинансовогоУчета   КАК ГруппаФинансовогоУчета,
	|
	|	&Подразделение                      КАК КорПодразделение,
	|	ТаблицаНМА.НаправлениеДеятельности  КАК КорНаправлениеДеятельности,
	|	&СтатьяАП_НМА                       КАК КорСтатья,
	|	НЕОПРЕДЕЛЕНО                        КАК КорАналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО                        КАК КорАналитикаРасходов,
	|	ТаблицаНМА.НематериальныйАктив      КАК КорАналитикаАктивовПассивов,
	|	ТаблицаНМА.ГруппаФинансовогоУчета   КАК КорГруппаФинансовогоУчета,
	|
	|	АмортизацияВНА.Амортизация          КАК Сумма,
	|	АмортизацияВНА.Амортизация          КАК СуммаУпр,
	|	АмортизацияВНА.АмортизацияРегл 
	|		+ АмортизацияВНА.АмортизацияЦФ  КАК СуммаРегл
	|ИЗ
	|	втТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АмортизацияВНА КАК АмортизацияВНА
	|		ПО ТаблицаНМА.НематериальныйАктив = АмортизацияВНА.ОбъектУчета
	|			И АмортизацияВНА.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Функция ПолноеИмяОбъекта()

	Возврат "Документ.ПодготовкаКПередачеНМА2_4";

КонецФункции

#КонецОбласти

#Область ПроведениеРеглУчет

Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ПодготовкаКПередачеНМАЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

Функция ТекстОтраженияВРеглУчете() Экспорт
	Возврат ПодготовкаКПередачеНМАЛокализация.ТекстОтраженияВРеглУчете();


	Возврат ПодготовкаКПередачеНМАЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

#КонецОбласти

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ПодготовкаКПередачеНМАЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
