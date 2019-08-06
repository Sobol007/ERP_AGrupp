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
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Списание ОС (международный учет)".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.СписаниеОСМеждународныйУчет)
		И ПолучитьФункциональнуюОпцию("ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет") Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.СписаниеОСМеждународныйУчет.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.СписаниеОСМеждународныйУчет);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ОтображатьВнеоборотныеАктивыМеждународныйУчет2_2";
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

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.СписаниеОСМеждународныйУчет";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	ИначеЕсли ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов"
		ИЛИ ИмяРегистра = "ДокументыПоОС" Тогда
		
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
	
	Если Регистры = Неопределено Тогда
		ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru = 'Списание ОС (международный учет)';
																|en = 'FA retirement (international accounting)'"));
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	МеждународныйУчетВнеоборотныеАктивы.ОтражениеДокументовВМеждународномУчете(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.ПрочиеРасходы(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.ПартииПрочихРасходов(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.ПрочиеАктивыПассивы(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.Международный(ТекстыЗапроса, Регистры, Международный(ТекстыЗапроса, Регистры));
	ОсновныеСредстваМеждународныйУчет(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.ПометкаУдаления,
	|	ДанныеДокумента.Проведен,
	|	ДанныеДокумента.Комментарий,
	|	ДанныеДокумента.Ответственный,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоОбъектаАмортизации,
	|	ДанныеДокумента.СчетРасходов,
	|	ДанныеДокумента.СчетРасходовСубконто1,
	|	ДанныеДокумента.СчетРасходовСубконто2,
	|	ДанныеДокумента.СчетРасходовСубконто3,
	|	ДанныеДокумента.ОсновныеСредства.(
	|		ОсновноеСредство
	|	)
	|ИЗ
	|	Документ.СписаниеОСМеждународныйУчет КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	ОсновныеСредства = Реквизиты.ОсновныеСредства.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
	
	Если НачалоДня(Реквизиты.Период) = НачалоМесяца(Реквизиты.Период) Тогда
		ТаблицаАмортизационныеРасходы = МеждународныйУчетВнеоборотныеАктивы.ТаблицаАмортизационныхРасходов();
	Иначе
		ТаблицаАмортизационныеРасходы = МеждународныйУчетВнеоборотныеАктивы.АмортизационныеРасходыПоОС(
			Реквизиты.Период,
			Реквизиты.Организация,
			ОсновныеСредства);
	КонецЕсли;
	ОшибкиШаблоновПроводок = МеждународныйУчетВнеоборотныеАктивы.ОшибкиЗаполненияШаблоновПроводокАмортизации(
		Реквизиты.Период,
		Реквизиты.Организация,
		ТаблицаАмортизационныеРасходы.ВыгрузитьКолонку("СтатьяРасходов"));
	
	Если ОшибкиШаблоновПроводок <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ОшибкиШаблоновПроводок);
		ВызватьИсключение НСтр("ru = 'Требуется настроить счета расходов амортизации в шаблоне проводок для операции ""Амортизация внеоборотных активов""';
								|en = 'Set depreciation expense accounts in a posting template for the ""Capital asset depreciation"" transaction'");
	КонецЕсли;
	
	МеждународныйУчетВнеоборотныеАктивы.ИнициализироватьПараметрыЗапросаПриОтраженииАмортизации(Запрос);
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(Реквизиты.Период));
	Запрос.УстановитьПараметр("Граница", Новый Граница(Реквизиты.Период, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ТаблицаАмортизации", ТаблицаАмортизационныеРасходы);
	Запрос.УстановитьПараметр("ОсновныеСредства", ОсновныеСредства);
	Запрос.УстановитьПараметр("СписаниеОстаточнойСтоимости", Истина);
	
	Если ТипЗнч(Реквизиты.СчетРасходовСубконто1) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		Запрос.УстановитьПараметр("СтатьяРасходов", Реквизиты.СчетРасходовСубконто1);
	ИначеЕсли ТипЗнч(Реквизиты.СчетРасходовСубконто2) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		Запрос.УстановитьПараметр("СтатьяРасходов", Реквизиты.СчетРасходовСубконто2);
	ИначеЕсли ТипЗнч(Реквизиты.СчетРасходовСубконто3) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		Запрос.УстановитьПараметр("СтатьяРасходов", Реквизиты.СчетРасходовСубконто3);
	КонецЕсли;
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СписаниеОСМеждународныйУчет"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.СписаниеОС);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса)
	
	ИмяТаблицы = "втОбъектыДокумента";
	
	Если ПроведениеСерверУТ.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица втОбъектыДокумента
	|"+
	"ВЫБРАТЬ
	|	Состояния.ОсновноеСредство,
	|	Состояния.ОсновноеСредство.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Состояния.СчетУчета,
	|	Состояния.СчетАмортизации
	|ПОМЕСТИТЬ втОбъектыДокумента
	|ИЗ
	|	РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(
	|			&Граница,
	|			ОсновноеСредство В (&ОсновныеСредства)
	|				И Регистратор <> &Ссылка) КАК Состояния";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы);
	
КонецПроцедуры

Процедура ВременнаяТаблицаВидыСубконтоСчетаРасходов(ТекстыЗапроса)
	
	ИмяТаблицы = "втВидыСубконтоСчетаРасходов";
	
	Если ПроведениеСерверУТ.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица втВидыСубконтоСчетаРасходов
	|"+
	"ВЫБРАТЬ
	|	ЕСТЬNULL(Субконто1.ВидСубконто, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто1,
	|	ВЫБОР
	|		КОГДА Субконто1.ВидСубконто ЕСТЬ NULL 
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ &СчетРасходовСубконто1
	|	КОНЕЦ КАК Субконто1,
	|	ЕСТЬNULL(Субконто2.ВидСубконто, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто2,
	|	ВЫБОР
	|		КОГДА Субконто2.ВидСубконто ЕСТЬ NULL 
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ &СчетРасходовСубконто2
	|	КОНЕЦ КАК Субконто2,
	|	ЕСТЬNULL(Субконто3.ВидСубконто, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто3,
	|	ВЫБОР
	|		КОГДА Субконто3.ВидСубконто ЕСТЬ NULL 
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ &СчетРасходовСубконто3
	|	КОНЕЦ КАК Субконто3
	|ПОМЕСТИТЬ втВидыСубконтоСчетаРасходов
	|ИЗ
	|	ПланСчетов.Международный КАК СчетРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Международный.ВидыСубконто КАК Субконто1
	|		ПО СчетРасходов.Ссылка = Субконто1.Ссылка
	|			И (Субконто1.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Международный.ВидыСубконто КАК Субконто2
	|		ПО СчетРасходов.Ссылка = Субконто2.Ссылка
	|			И (Субконто2.НомерСтроки = 2)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Международный.ВидыСубконто КАК Субконто3
	|		ПО СчетРасходов.Ссылка = Субконто3.Ссылка
	|			И (Субконто3.НомерСтроки = 3)
	|ГДЕ
	|	СчетРасходов.Ссылка = &СчетРасходов";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы);
	
КонецПроцедуры

Процедура ОсновныеСредстваМеждународныйУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОсновныеСредстваМеждународныйУчет";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ОсновныеСредстваМеждународныйУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.СнятоСУчета) КАК Состояние
	|ИЗ
	|	втОбъектыДокумента КАК ТаблицаДокумента";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Функция Международный(ТекстыЗапроса, Регистры)
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений("Международный", Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса);
	ВременнаяТаблицаВидыСубконтоСчетаРасходов(ТекстыЗапроса);
	МеждународныйУчетВнеоборотныеАктивы.ВременнаяТаблицаНачисленнаяАмортизация(ТекстыЗапроса);
	
	Возврат
	"ВЫБРАТЬ // Списание стоимости объекта со счета учета
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	
	|	&Организация КАК Организация,
	|	
	|	&Подразделение КАК ПодразделениеДт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	&СчетРасходов КАК СчетДт,
	|	ВидыСубконто.ВидСубконто1 КАК ВидСубконтоДт1,
	|	ВидыСубконто.Субконто1 КАК СубконтоДт1,
	|	ВидыСубконто.ВидСубконто2 КАК ВидСубконтоДт2,
	|	ВидыСубконто.Субконто2 КАК СубконтоДт2,
	|	ВидыСубконто.ВидСубконто3 КАК ВидСубконтоДт3,
	|	ВидыСубконто.Субконто3 КАК СубконтоДт3,
	|	
	|	&Подразделение КАК ПодразделениеКт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	СтрокиДокумента.СчетУчета КАК СчетКт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоКт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаОстаток, 0) КАК Сумма,
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаПредставленияОстаток, 0) КАК СуммаПредставления,
	|	0 КАК ВалютнаяСумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК Содержание,
	|	НЕОПРЕДЕЛЕНО КАК ШаблонПроводки,
	|	НЕОПРЕДЕЛЕНО КАК ТипПроводки
	|ИЗ
	|	втОбъектыДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				&Граница,
	|				Счет В
	|					(ВЫБРАТЬ
	|						втОбъектыДокумента.СчетУчета
	|					ИЗ
	|						втОбъектыДокумента),
	|				,
	|				Организация = &Организация
	|					И Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							втОбъектыДокумента.ОсновноеСредство
	|						ИЗ
	|							втОбъектыДокумента)) КАК ДанныеСчетУчета
	|		ПО СтрокиДокумента.ОсновноеСредство = ДанныеСчетУчета.Субконто1
	|			И СтрокиДокумента.СчетУчета = ДанныеСчетУчета.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ втВидыСубконтоСчетаРасходов КАК ВидыСубконто
	|		ПО (ИСТИНА)
	|ГДЕ
	|	НЕ ДанныеСчетУчета.Счет ЕСТЬ NULL
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ // Вычитание начисленной амортизации со счета списания
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	
	|	&Организация КАК Организация,
	|	
	|	&Подразделение КАК ПодразделениеДт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	СтрокиДокумента.СчетАмортизации КАК СчетДт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоДт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	&Подразделение КАК ПодразделениеКт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	&СчетРасходов КАК СчетКт,
	|	ВидыСубконто.ВидСубконто1 КАК ВидСубконтоКт1,
	|	ВидыСубконто.Субконто1 КАК СубконтоКт1,
	|	ВидыСубконто.ВидСубконто2 КАК ВидСубконтоКт2,
	|	ВидыСубконто.Субконто2 КАК СубконтоКт2,
	|	ВидыСубконто.ВидСубконто3 КАК ВидСубконтоКт3,
	|	ВидыСубконто.Субконто3 КАК СубконтоКт3,
	|	
	|	(-ЕСТЬNULL(ДанныеСчетАмортизации.СуммаОстаток,0))
	|		+ ЕСТЬNULL(СтрокиАмортизации.Сумма,0) КАК Сумма,
	|	(-ЕСТЬNULL(ДанныеСчетАмортизации.СуммаПредставленияОстаток,0))
	|		+ ЕСТЬNULL(СтрокиАмортизации.СуммаПредставления,0) КАК СуммаПредставления,
	|	0 КАК ВалютнаяСумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК Содержание,
	|	НЕОПРЕДЕЛЕНО КАК ШаблонПроводки,
	|	НЕОПРЕДЕЛЕНО КАК ТипПроводки
	|ИЗ
	|	втОбъектыДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНачисленнаяАмортизация КАК СтрокиАмортизации
	|		ПО СтрокиДокумента.ОсновноеСредство = СтрокиАмортизации.ОбъектУчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				&Граница,
	|				Счет В
	|					(ВЫБРАТЬ
	|						втОбъектыДокумента.СчетАмортизации
	|					ИЗ
	|						втОбъектыДокумента),
	|				,
	|				Организация = &Организация
	|					И Подразделение = &Подразделение
	|					И Субконто1 В
	|						(ВЫБРАТЬ
	|							втОбъектыДокумента.ОсновноеСредство
	|						ИЗ
	|							втОбъектыДокумента)) КАК ДанныеСчетАмортизации
	|		ПО СтрокиДокумента.ОсновноеСредство = ДанныеСчетАмортизации.Субконто1
	|			И СтрокиДокумента.СчетАмортизации = ДанныеСчетАмортизации.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ втВидыСубконтоСчетаРасходов КАК ВидыСубконто
	|		ПО (ИСТИНА)
	|ГДЕ
	|	НЕ (ДанныеСчетАмортизации.Счет ЕСТЬ NULL И СтрокиАмортизации.ОбъектУчета ЕСТЬ NULL)";
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&Подразделение                          КАК Подразделение,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	&Период   КАК ДатаОтраженияВУчете";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоОС";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОС.НомерСтроки-1, 0)    КАК НомерЗаписи,
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК Дата,
	|	&Организация                            КАК Организация,
	|	&Подразделение                          КАК Подразделение,
	|	&Проведен                               КАК Проведен,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство
	|ИЗ
	|	Документ.СписаниеОСМеждународныйУчет КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеОСМеждународныйУчет.ОсновныеСредства КАК ТаблицаОС
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОС.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	ВходящиеДанные.Вставить(Метаданные.Документы.ПринятиеКУчетуНМАМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыБухгалтерии.Международный);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ВыработкаНМА);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочиеРасходы);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.НаработкиОбъектовЭксплуатации);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.НематериальныеАктивыМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ОсновныеСредстваМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПравилаОтраженияВМеждународномУчете);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПравилаУточненияСчетовВМеждународномУчете);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета);
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли