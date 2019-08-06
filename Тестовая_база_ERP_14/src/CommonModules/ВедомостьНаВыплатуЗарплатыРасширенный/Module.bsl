
#Область СлужебныеПроцедурыИФункции

/// Печать

Процедура ДобавитьКомандыПечатиПриВыплатеНаКарточки(КомандыПечати) Экспорт
	
	ВедомостьНаВыплатуЗарплатыБазовый.ДобавитьКомандыПечатиПриВыплатеНаКарточки(КомандыПечати);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ВедомостьНаВыплатуЗарплатыБюджетныхУчреждений");
		Модуль.ДобавитьКомандыПечатиПриВыплатеНаКарточки(КомандыПечати);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		УчетНДФЛРасширенный.ДобавитьКомандуПечатиРеестраПеречисленногоНалога(КомандыПечати)
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПечатьПриВыплатеНаКарточки(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ВедомостьНаВыплатуЗарплатыБазовый.ПечатьПриВыплатеНаКарточки(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ВедомостьНаВыплатуЗарплатыБюджетныхУчреждений");
		Модуль.ПечатьПриВыплатеНаКарточки(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УчетНДФЛРасширенный.НужноПечататьРеестрПеречисленногоНалога(КоллекцияПечатныхФорм) Тогда
		УчетНДФЛРасширенный.ВывестиРеестрПеречисленногоНалогаПоПлатежномуДокументу(КоллекцияПечатныхФорм, МассивОбъектов, ОбъектыПечати);	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКомандыПечатиПриВыплатеНаличными(КомандыПечати) Экспорт
	
	// Расчетно-платежная ведомость (Т-49).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "Т49";
	КомандаПечати.Представление = НСтр("ru = 'Расчетно-платежная ведомость (Т-49)';
										|en = 'Pay statement (T-49) '");
	КомандаПечати.Порядок = 30;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ФункциональныеОпции = "РаботаВХозрасчетнойОрганизации";
	
	// Платежная ведомость (Т-53)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "Т53";
	КомандаПечати.Представление = НСтр("ru = 'Платежная ведомость (Т-53)';
										|en = 'Paysheet (T-53)'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ВедомостьНаВыплатуЗарплатыБюджетныхУчреждений");
		Модуль.ДобавитьКомандыПечатиПриВыплатеНаличными(КомандыПечати);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		УчетНДФЛРасширенный.ДобавитьКомандуПечатиРеестраПеречисленногоНалога(КомандыПечати)
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПечатьПриВыплатеНаличными(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Т49") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Т49",
			НСтр("ru = 'Расчетно-платежная ведомость (Т-49)';
				|en = 'Pay statement (T-49) '"), ПечатьТ49(МассивОбъектов, ОбъектыПечати));
		
	Иначе
		ВедомостьНаВыплатуЗарплатыБазовый.ПечатьПриВыплатеНаличными(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ВедомостьНаВыплатуЗарплатыБюджетныхУчреждений");
		Модуль.ПечатьПриВыплатеНаличными(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УчетНДФЛРасширенный.НужноПечататьРеестрПеречисленногоНалога(КоллекцияПечатныхФорм) Тогда
		УчетНДФЛРасширенный.ВывестиРеестрПеречисленногоНалогаПоПлатежномуДокументу(КоллекцияПечатныхФорм, МассивОбъектов, ОбъектыПечати);	
	КонецЕсли;

КонецПроцедуры

Функция ПечатьТ49(МассивОбъектов, ОбъектыПечати)
	
	СпособыВыплатыВедомостей = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивОбъектов, "СпособВыплаты");
	ПорядокВыплаты = 
		ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
			ОбщегоНазначения.ВыгрузитьКолонку(СпособыВыплатыВедомостей, "Значение", Истина), 
			"ХарактерВыплаты");
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ПервыйДокумент = Истина;
	Для Каждого ДокументСсылка Из МассивОбъектов Цикл
		
		Если ПорядокВыплаты[СпособыВыплатыВедомостей[ДокументСсылка]] = Перечисления.ХарактерВыплатыЗарплаты.Аванс Тогда
			ПечатнаяФормаДокумента = Отчеты.АнализНачисленийИУдержанийАвансом.ПечатьТ49(ДокументСсылка);
		Иначе
			ПечатнаяФормаДокумента = Отчеты.АнализНачисленийИУдержаний.ПечатьТ49(ДокументСсылка);
		КонецЕсли;
		
		Если ПервыйДокумент Тогда
			ДокументРезультат = ПечатнаяФормаДокумента;
			НомерСтрокиНачало = 1;
			ПервыйДокумент = Ложь;
		Иначе
			// Все документы нужно выводить на разных страницах.
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			// Запомним номер строки, с которой начали выводить текущий документ.
			НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
			// Добавим очередную ведомость к результирующему табличному документу
			ДокументРезультат.Вывести(ПечатнаяФормаДокумента);
		КонецЕсли;
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НомерСтрокиНачало, ОбъектыПечати, ДокументСсылка);
		
	КонецЦикла;
	
	Возврат ДокументРезультат;
	
КонецФункции

/// Места выплаты

Функция МестоВыплатыКасса(Ведомость) Экспорт
	
	МестоВыплаты = ВедомостьНаВыплатуЗарплаты.МестоВыплаты();
	
	СтандартнаяОбработка = Истина;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ВзаиморасчетыССотрудникамиУправленческий");
		Модуль.ПриПолученииМестаВыплатыВедомостиВКассу(Ведомость, МестоВыплаты, СтандартнаяОбработка);
	КонецЕсли;
	Если Не СтандартнаяОбработка Тогда
		Возврат МестоВыплаты
	КонецЕсли;
	
	МестоВыплаты.Вид      = Перечисления.ВидыМестВыплатыЗарплаты.Касса;
	МестоВыплаты.Значение = Ведомость.Касса;
	
	Возврат МестоВыплаты
	
КонецФункции

Процедура УстановитьМестоВыплатыКасса(Ведомость, Значение) Экспорт
	Ведомость.Касса = Значение;
КонецПроцедуры

//// Заполнение и расчет документа.

Функция МожноЗаполнитьЗарплату(Ведомость) Экспорт
	
	МожноЗаполнитьЗарплату = ВедомостьНаВыплатуЗарплатыБазовый.МожноЗаполнитьЗарплату(Ведомость);

	ПравилаПроверки = Новый Структура;
	ПравилаПроверки.Вставить("ПроцентВыплаты", НСтр("ru = 'Не задан размер выплаты в параметрах расчета';
													|en = 'Payment amount is not specified in the settlement parameters'"));
	
	Если ПолучитьФункциональнуюОпцию("ПроверятьЗаполнениеФинансированияВВедомостях") Тогда
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Ведомость.Метаданные().Реквизиты.СтатьяФинансирования) Тогда
			ПравилаПроверки.Вставить("СтатьяФинансирования", НСтр("ru = 'Не указана статья финансирования';
																	|en = 'Financing item is not specified'"));
		КонецЕсли;
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Ведомость.Метаданные().Реквизиты.СтатьяРасходов) Тогда
			ПравилаПроверки.Вставить("СтатьяРасходов",       НСтр("ru = 'Не указана статья расходов';
																	|en = 'Expense item is not specified'"));
		КонецЕсли;
	КонецЕсли;	
	
	МожноЗаполнитьЗарплату = 
		ЗарплатаКадрыКлиентСервер.СвойстваЗаполнены(Ведомость, ПравилаПроверки, Истина)
		И МожноЗаполнитьЗарплату;

	ВидДокументаОснования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ведомость.СпособВыплаты, "ВидДокументаОснования");
	Если ЗначениеЗаполнено(ВидДокументаОснования) И Ведомость.Основания.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не выбраны документы-основания';
				|en = 'Base documents are not selected'"), 
			Ведомость, 
			"Основания");
		МожноЗаполнитьЗарплату = Ложь;	
	КонецЕсли;	
	
	Возврат МожноЗаполнитьЗарплату;

КонецФункции

Функция ПараметрыЗаполненияПоОбъекту(Объект) Экспорт
	ПараметрыЗаполнения = ВедомостьНаВыплатуЗарплатыБазовый.ПараметрыЗаполненияПоОбъекту(Объект);
	
	ПараметрыЗаполнения.ОписаниеОперации.ДокументыОснования = 
		Объект.Основания.Выгрузить(, "Документ").ВыгрузитьКолонку("Документ");	
		
	ПараметрыЗаполнения.ОтборСотрудников.ВидыДоговоров = Объект.СпособВыплаты.ГруппаВидовДоговоров;
	
	ПараметрыЗаполнения.ПараметрыРасчетаЗарплаты.ПроцентВыплаты = Объект.ПроцентВыплаты;
	
	ПараметрыЗаполнения.Финансирование.СтатьяФинансирования = Объект.СтатьяФинансирования;	
	ПараметрыЗаполнения.Финансирование.СтатьяРасходов       = Объект.СтатьяРасходов;	
	
	Возврат ПараметрыЗаполнения
КонецФункции

Процедура СоздатьВТСотрудникиДляВедомостиПоШапке(МенеджерВременныхТаблиц, ОписаниеОперации, ОтборСотрудников) Экспорт
	
	ИмяВТСотрудники = "";
	
	// Отбор сотрудников по документам-основаниям.
	СоздатьВТСотрудникиДляВедомостиПоОснованиям(МенеджерВременныхТаблиц, ОписаниеОперации, ИмяВТСотрудники);
	
	// Отбор сотрудников по организации и подразделению.
	СоздатьВТСотрудникиДляВедомостиПоМестуРаботы(МенеджерВременныхТаблиц, ОписаниеОперации, ОтборСотрудников, ИмяВТСотрудники);
	
	// Отбор по месту выплаты зарплаты.
	СоздатьВТСотрудникиДляВедомостиПоМестуВыплаты(МенеджерВременныхТаблиц, ОписаниеОперации, ОтборСотрудников, ИмяВТСотрудники);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДатаДляКадровыхДанных", ОписаниеОперации.Дата);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	&ДатаДляКадровыхДанных КАК Период
	|ПОМЕСТИТЬ ВТСотрудникиДляВедомости
	|ИЗ
	|	#ВТСотрудники КАК Сотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ #ВТСотрудники";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудники", ИмяВТСотрудники);
	
	Запрос.Выполнить();
	
КонецПроцедуры	

Процедура СоздатьВТСотрудникиДляВедомостиПоОснованиям(МенеджерВременныхТаблиц, ОписаниеОперации, ИмяВТСотрудники = "")
	
	Если ОписаниеОперации.ДокументыОснования.Количество() > 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("Основания", ОписаниеОперации.ДокументыОснования);	

		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ЗарплатаКВыплате.Сотрудник КАК Сотрудник,
		|	ЗарплатаКВыплате.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТСотрудникиПоОснованию
		|ИЗ
		|	РегистрНакопления.ЗарплатаКВыплате КАК ЗарплатаКВыплате
		|ГДЕ
		|	ЗарплатаКВыплате.Регистратор В(&Основания)";
		
		Запрос.Выполнить();
		
		ИмяВТСотрудники	= "ВТСотрудникиПоОснованию"
		
	Иначе
		
		ИмяВТСотрудники	= ""
		
	КонецЕсли
	
КонецПроцедуры

Процедура СоздатьВТСотрудникиДляВедомостиПоМестуРаботы(МенеджерВременныхТаблиц, ОписаниеОперации, ОтборСотрудников, ИмяВТСотрудники)
	
	ПараметрыПолученияСотрудников = ПараметрыПолученияСотрудниковПоШапкеВедомости(ОписаниеОперации, ОтборСотрудников);

	КадровыйУчет.СоздатьВТСотрудникиОрганизации(
		МенеджерВременныхТаблиц, Истина, 
		ПараметрыПолученияСотрудников, 
		"ВТСотрудникиПоМестуРаботыПоШапкеВедомости");
		
	ИмяВТСотрудникиПоМестуРаботы = "ВТСотрудникиПоМестуРаботыПоШапкеВедомости";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	// при отборе по подразделениям	берем относящихся к нему на конец периода
	Если ЗначениеЗаполнено(ПараметрыПолученияСотрудников.Подразделение) Тогда
		
		Запрос.УстановитьПараметр("Подразделение", ПараметрыПолученияСотрудников.Подразделение);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Сотрудник КАК Сотрудник,
		|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Сотрудники.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ ВТСотрудникиОтносящиесяКПодразделению
		|ИЗ
		|	#ВТСотрудникиПоМестуРаботы КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Подразделение В ИЕРАРХИИ(&Подразделение)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ #ВТСотрудникиПоМестуРаботы";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудникиПоМестуРаботы", ИмяВТСотрудникиПоМестуРаботы);
		
		Запрос.Выполнить();

		ИмяВТСотрудникиПоМестуРаботы = "ВТСотрудникиОтносящиесяКПодразделению";
		
	КонецЕсли;	
	
	// аванс не работающим на дату ведомости не выплачивается
	Если ОписаниеОперации.ПорядокВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Аванс Тогда
		
		ПараметрыПолученияСотрудников.НачалоПериода 	= НачалоДня(ОписаниеОперации.Дата);
		ПараметрыПолученияСотрудников.ОкончаниеПериода	= КонецДня(ОписаниеОперации.Дата);
		КадровыйУчет.СоздатьВТСотрудникиОрганизации(
			МенеджерВременныхТаблиц, Истина, 
			ПараметрыПолученияСотрудников, 
			"ВТСотрудникиПоМестуРаботыНаДатуВедомости");
			
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Сотрудник КАК Сотрудник,
		|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Сотрудники.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ ВТРаботающиеСотрудникиПоМестуРаботы
		|ИЗ
		|	#ВТСотрудникиПоМестуРаботы КАК Сотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиПоМестуРаботыНаДатуВедомости КАК РаботающиеСотрудники
		|		ПО Сотрудники.Сотрудник = РаботающиеСотрудники.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ #ВТСотрудникиПоМестуРаботы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТСотрудникиПоМестуРаботыНаДатуВедомости";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудникиПоМестуРаботы", ИмяВТСотрудникиПоМестуРаботы);
		
		Запрос.Выполнить();

		ИмяВТСотрудникиПоМестуРаботы = "ВТРаботающиеСотрудникиПоМестуРаботы";
		
	КонецЕсли;	
	
	// если передан список сотрудников, берем только присутствующих в нем
	Если ЗначениеЗаполнено(ИмяВТСотрудники) Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Сотрудник КАК Сотрудник,
		|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Сотрудники.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ ВТВходящиеСотрудникиПоМестуРаботы
		|ИЗ
		|	#ВТСотрудникиПоМестуРаботы КАК Сотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ #ВТСотрудники КАК ВходящиеСотрудники
		|		ПО Сотрудники.Сотрудник = ВходящиеСотрудники.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ #ВТСотрудникиПоМестуРаботы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ #ВТСотрудники";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудникиПоМестуРаботы", ИмяВТСотрудникиПоМестуРаботы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудники", ИмяВТСотрудники);
		
		Запрос.Выполнить();

		ИмяВТСотрудникиПоМестуРаботы = "ВТВходящиеСотрудникиПоМестуРаботы";
		
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Сотрудники.Подразделение
	|ПОМЕСТИТЬ ВТСотрудникиПоМестуРаботы
	|ИЗ
	|	#ВТСотрудникиПоМестуРаботы КАК Сотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ #ВТСотрудникиПоМестуРаботы";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудникиПоМестуРаботы", ИмяВТСотрудникиПоМестуРаботы);
	
	Запрос.Выполнить();
	
	ИмяВТСотрудники = "ВТСотрудникиПоМестуРаботы"
	
КонецПроцедуры	

Процедура СоздатьВТСотрудникиДляВедомостиПоМестуВыплаты(МенеджерВременныхТаблиц, ОписаниеОперации, ОтборСотрудников, ИмяВТСотрудники)
	
	МестоВыплаты = ОтборСотрудников.МестоВыплаты;
	
	Если НЕ ЗначениеЗаполнено(МестоВыплаты.Вид) Тогда
		Возврат
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация",	ОписаниеОперации.Организация);
	Запрос.УстановитьПараметр("ВидМестаВыплаты",МестоВыплаты.Вид);
	Запрос.УстановитьПараметр("ВсеМестаВыплаты",НЕ ЗначениеЗаполнено(МестоВыплаты.Значение));
	Запрос.УстановитьПараметр("МестоВыплаты",	МестоВыплаты.Значение);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Сотрудники.Сотрудник,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Сотрудники.Подразделение
	|ПОМЕСТИТЬ ВТСотрудникиПоМестуВыплаты
	|ИЗ
	|	#ВТСотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестаВыплатыЗарплатыОрганизаций КАК МестаВыплатыЗарплатыОрганизаций
	|		ПО (МестаВыплатыЗарплатыОрганизаций.Организация = &Организация)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестаВыплатыЗарплатыПодразделений КАК МестаВыплатыЗарплатыПодразделений
	|		ПО (МестаВыплатыЗарплатыПодразделений.Подразделение = Сотрудники.Подразделение)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестаВыплатыЗарплатыСотрудников КАК МестаВыплатыЗарплатыСотрудников
	|		ПО (МестаВыплатыЗарплатыСотрудников.Сотрудник = Сотрудники.Сотрудник)
	|ГДЕ
	|	ВЫБОР
	|			КОГДА МестаВыплатыЗарплатыСотрудников.Вид ЕСТЬ НЕ NULL 
	|				ТОГДА МестаВыплатыЗарплатыСотрудников.Вид
	|			КОГДА МестаВыплатыЗарплатыПодразделений.Вид ЕСТЬ НЕ NULL 
	|				ТОГДА МестаВыплатыЗарплатыПодразделений.Вид
	|			КОГДА МестаВыплатыЗарплатыОрганизаций.Вид ЕСТЬ НЕ NULL 
	|				ТОГДА МестаВыплатыЗарплатыОрганизаций.Вид
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыМестВыплатыЗарплаты.Касса)
	|		КОНЕЦ = &ВидМестаВыплаты
	|	И (&ВсеМестаВыплаты
	|			ИЛИ ВЫБОР
	|				КОГДА МестаВыплатыЗарплатыСотрудников.МестоВыплаты ЕСТЬ НЕ NULL 
	|						И МестаВыплатыЗарплатыСотрудников.МестоВыплаты <> НЕОПРЕДЕЛЕНО
	|					ТОГДА ВЫБОР
	|							КОГДА МестаВыплатыЗарплатыСотрудников.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыМестВыплатыЗарплаты.БанковскийСчет)
	|								ТОГДА МестаВыплатыЗарплатыСотрудников.МестоВыплаты.Банк
	|							ИНАЧЕ МестаВыплатыЗарплатыСотрудников.МестоВыплаты
	|						КОНЕЦ
	|				КОГДА МестаВыплатыЗарплатыПодразделений.МестоВыплаты ЕСТЬ НЕ NULL 
	|						И МестаВыплатыЗарплатыПодразделений.МестоВыплаты <> НЕОПРЕДЕЛЕНО
	|					ТОГДА МестаВыплатыЗарплатыПодразделений.МестоВыплаты
	|				КОГДА МестаВыплатыЗарплатыОрганизаций.МестоВыплаты ЕСТЬ НЕ NULL 
	|						И МестаВыплатыЗарплатыОрганизаций.МестоВыплаты <> НЕОПРЕДЕЛЕНО
	|					ТОГДА МестаВыплатыЗарплатыОрганизаций.МестоВыплаты
	|			КОНЕЦ = &МестоВыплаты)";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудники", ИмяВТСотрудники);
	
	Запрос.Выполнить();
	
	ИмяВТСотрудники = "ВТСотрудникиПоМестуВыплаты"
		
КонецПроцедуры	

Процедура СоздатьВТСотрудникиДляВедомостиПоФизическимЛицам(МенеджерВременныхТаблиц, ФизическиеЛица, ОписаниеОперации, ОтборСотрудников) Экспорт
	
	ПараметрыПолученияСотрудников = ПараметрыПолученияСотрудниковПоШапкеВедомости(ОписаниеОперации, ОтборСотрудников);
	
	ПараметрыПолученияСотрудников.СписокФизическихЛиц = ФизическиеЛица;
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(
		МенеджерВременныхТаблиц, Истина, 
		ПараметрыПолученияСотрудников, 
		"ВТСотрудникиДляВедомости");
		
КонецПроцедуры	

Функция ПараметрыПолученияСотрудниковПоШапкеВедомости(ОписаниеОперации, ОтборСотрудников)
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	
	Перечисления.ГруппыВидовДоговоровССотрудникамДляВыплатыЗарплаты.ЗаполнитьПараметрыПолученияСотрудниковОрганизаций(
		ПараметрыПолученияСотрудников,
		ОтборСотрудников.ВидыДоговоров);
	
	Если ОписаниеОперации.ПорядокВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Аванс Тогда 
		НачалоПериода 		= НачалоМесяца(ОписаниеОперации.ПериодРегистрации);
		ОкончаниеПериода	= МИН(Дата(Год(ОписаниеОперации.ПериодРегистрации), Месяц(ОписаниеОперации.ПериодРегистрации), 15), ОписаниеОперации.Дата);
		ПараметрыПолученияСотрудников.РаботникиПоДоговорамГПХ = Неопределено;
	ИначеЕсли ОписаниеОперации.ПорядокВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Межрасчет Тогда 
		НачалоПериода 		=  '00010101';
		ОкончаниеПериода	=  МИН(КонецМесяца(ОписаниеОперации.ПериодРегистрации), ОписаниеОперации.Дата);
	Иначе
		НачалоПериода 		=  '00010101';
		ОкончаниеПериода	=  КонецМесяца(ОписаниеОперации.ПериодРегистрации);
	КонецЕсли;	
	
	ПараметрыПолученияСотрудников.Организация	= ОписаниеОперации.Организация;
	ПараметрыПолученияСотрудников.Подразделение	= ОтборСотрудников.Подразделение;
	ПараметрыПолученияСотрудников.НачалоПериода 	= НачалоПериода;
	ПараметрыПолученияСотрудников.ОкончаниеПериода	= ОкончаниеПериода;
	
	ПараметрыПолученияСотрудников.КадровыеДанные = "Подразделение";	
	
	КадровыйУчетРасширенный.ПрименитьОтборПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(ПараметрыПолученияСотрудников);
	
	Возврат ПараметрыПолученияСотрудников
	
КонецФункции

Функция НалогиКУдержанию(ЗарплатаКВыплате, ОписаниеОперации, ПараметрыРасчета, Финансирование = Неопределено, Регистратор = Неопределено) Экспорт
	
	НДФЛ = ВедомостьНаВыплатуЗарплатыБазовый.НалогиКУдержанию(ЗарплатаКВыплате, ОписаниеОперации, ПараметрыРасчета, Финансирование, Регистратор);
	
	// При постатейной выплате оставляем только налоги с заказанных статей 
	Если Финансирование <> Неопределено 
		И (ЗначениеЗаполнено(Финансирование.СтатьяФинансирования) Или ЗначениеЗаполнено(Финансирование.СтатьяРасходов)) Тогда
		
		КолонкиОтбораНДФЛ = "ФизическоеЛицо, МесяцНалоговогоПериода, Подразделение, ДокументОснование, КатегорияДохода";
		ТаблицаОтбораБухучетаНДФЛ = НДФЛ.Скопировать(, КолонкиОтбораНДФЛ);
		ТаблицаОтбораБухучетаНДФЛ.Свернуть(КолонкиОтбораНДФЛ);
		
		БухучетНДФЛ = ОтражениеЗарплатыВБухучетеРасширенный.БухучетНДФЛСотрудниковПоДокументамОснованиям(ТаблицаОтбораБухучетаНДФЛ, Регистратор);
		БухучетНДФЛ.Индексы.Добавить(КолонкиОтбораНДФЛ);
		
		УдаляемыеСтрокиНДФЛ = Новый Массив;
		ПараметрыОтбораНДФЛ = Новый Структура(КолонкиОтбораНДФЛ);
		Для Каждого СтрокаНДФЛ Из НДФЛ Цикл
			ЗаполнитьЗначенияСвойств(ПараметрыОтбораНДФЛ, СтрокаНДФЛ); 
			БухучетПоСтрокеНДФЛ = БухучетНДФЛ.НайтиСтроки(ПараметрыОтбораНДФЛ);
			СуммаИтого = 0;
			СуммаПоИсточнику = 0;
			Для Каждого СтрокаБухучета Из БухучетПоСтрокеНДФЛ Цикл
				СуммаИтого = СуммаИтого + СтрокаБухучета.Сумма;
				Если (Не ЗначениеЗаполнено(Финансирование.СтатьяФинансирования) Или Финансирование.СтатьяФинансирования = СтрокаБухучета.СтатьяФинансирования)
					И (Не ЗначениеЗаполнено(Финансирование.СтатьяРасходов) Или Финансирование.СтатьяРасходов = СтрокаБухучета.СтатьяРасходов) Тогда
					СуммаПоИсточнику = СуммаПоИсточнику + СтрокаБухучета.Сумма
				КонецЕсли;
			КонецЦикла;	
			Если СуммаПоИсточнику <> 0 И СуммаИтого <> 0 Тогда
				СтрокаНДФЛ.Сумма = МИН(СтрокаНДФЛ.НачисленоНалога * СуммаПоИсточнику / СуммаИтого, СтрокаНДФЛ.Сумма);
			Иначе
				УдаляемыеСтрокиНДФЛ.Добавить(СтрокаНДФЛ);
			КонецЕсли;	
		КонецЦикла;	
		
		Для Каждого СтрокаНДФЛ Из УдаляемыеСтрокиНДФЛ Цикл
			НДФЛ.Удалить(СтрокаНДФЛ)
		КонецЦикла;	
		
	КонецЕсли;			
	
	// Сортируем НДФЛ для воспроизводимости результатов.
	КолонкиСортировки = 
	"ФизическоеЛицо,
	|МесяцНалоговогоПериода,
	|КатегорияДохода,
	|СтавкаНалогообложенияРезидента,
	|КодДохода,
	|Сумма,
	|Подразделение,
	|ДокументОснование,
	|РегистрацияВНалоговомОргане";
	НДФЛ.Сортировать(КолонкиСортировки, Новый СравнениеЗначений);
	
	Возврат НДФЛ

КонецФункции

///// Обработчики событий модуля объекта документов Ведомости.

Процедура ОбработкаЗаполнения(Ведомость, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	ВедомостьНаВыплатуЗарплатыБазовый.ОбработкаЗаполнения(Ведомость, ДанныеЗаполнения, СтандартнаяОбработка)
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ПроверятьЗаполнениеФинансированияВВедомостях") Тогда
		
		ПоляСтатей = Новый Массив;
		ПоляСтатей.Добавить("СтатьяФинансирования");
		ПоляСтатей.Добавить("СтатьяРасходов");
		КолонкиСтатей = СтрСоединить(ПоляСтатей, ",");
		
		Для Каждого СтрокаСостава Из ДокументОбъект.Состав Цикл
			ЗарплатаСтроки = ДокументОбъект.Зарплата.Выгрузить(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки), КолонкиСтатей);
			ОшибкаФинансированияСтроки = Ложь;
			Для Каждого ПолеСтатьи Из ПоляСтатей Цикл
				Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ДокументОбъект.Метаданные().Реквизиты[ПолеСтатьи]) И ЗначениеЗаполнено(ДокументОбъект[ПолеСтатьи]) Тогда
					СтатьиСтроки = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ЗарплатаСтроки.ВыгрузитьКолонку(ПолеСтатьи));
					Если СтатьиСтроки.Количество() > 1 Или СтатьиСтроки[0] <> ДокументОбъект[ПолеСтатьи] Тогда
						ОшибкаФинансированияСтроки = Истина;
						Прервать;
					КонецЕсли	
				КонецЕсли;	
			КонецЦикла;	
			Если ОшибкаФинансированияСтроки Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'У сотрудника %1 финансирование не совпадает с ведомостью';
								|en = 'Employee %1 financing does not correspond to one in the paysheet'"),
							СтрокаСостава.ФизическоеЛицо);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДокументОбъект, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Состав[%1].ФизическоеЛицо", СтрокаСостава.НомерСтроки-1),, Отказ);
			КонецЕсли;	
		КонецЦикла;
		
		
	Иначе	
		ИсключаемыеРеквизиты = Новый Массив;
		ИсключаемыеРеквизиты.Добавить("СтатьяФинансирования");
		ИсключаемыеРеквизиты.Добавить("СтатьяРасходов");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	КонецЕсли;	
	
	Если НачалоДня(ДокументОбъект.Дата) > ВедомостьНаВыплатуЗарплатыКлиентСервер.ДатаВыплаты(ДокументОбъект) Тогда
		ТекстОшибки = НСтр("ru = 'Дата выплаты не может быть меньше даты документа';
							|en = 'Payment date cannot be less than the document date'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДокументОбъект, "ДатаВыплаты",, Отказ);
	КонецЕсли;
	
	ВедомостьНаВыплатуЗарплатыБазовый.ОбработкаПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ЗарегистрироватьВыплату(Ведомость, Отказ) Экспорт
	
	ВедомостьНаВыплатуЗарплатыБазовый.ЗарегистрироватьВыплату(Ведомость, Отказ);
	
	// Регистрация выдачи зарплаты.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		
		ЗарегистрироватьВыданнуюЗарплату(Ведомость, Отказ);
		
		ЗарегистрироватьУдержанныеНалоги(Ведомость, Отказ);
		
		Если Ведомость.ПеречислениеНДФЛВыполнено Тогда
			ЗарегистрироватьПеречислениеНДФЛ(Ведомость, Отказ);
		КонецЕсли;
		
	КонецЕсли
	
КонецПроцедуры

Процедура ЗарегистрироватьВыданнуюЗарплату(Ведомость, Отказ = Ложь)
	
	// Выданную зарплату берем по движениям в р.н. ВзаиморасчетыССотрудниками
	Зарплата = ВзаиморасчетыССотрудниками.НоваяТаблицаВыданнойЗарплаты();
	Для Каждого Запись Из Ведомость.Движения.ВзаиморасчетыССотрудниками Цикл
		СтрокаЗарплаты = Зарплата.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЗарплаты, Запись);
		СтрокаЗарплаты.Сумма = Запись.СуммаВзаиморасчетов
	КонецЦикла;	
	
	ПорядокВыплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ведомость.СпособВыплаты, "ХарактерВыплаты");
	
	ВзаиморасчетыССотрудниками.ЗарегистрироватьВыданнуюЗарплату(Ведомость.Движения, Отказ, Ведомость.Организация, ВедомостьНаВыплатуЗарплатыКлиентСервер.ДатаВыплаты(Ведомость), Зарплата, ПорядокВыплаты); 
	
КонецПроцедуры
	
Процедура ЗарегистрироватьУдержанныеНалоги(Ведомость, Отказ = Ложь)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ВедомостьНаВыплатуЗарплаты.СоздатьВТСписокСотрудниковПоТаблицеЗарплат(
		МенеджерВременныхТаблиц, 
		Ведомость.Зарплата, 
		Ведомость.Организация, 
		Ведомость.ПериодРегистрации, 
		Ведомость.Ссылка);
	
	ЗапросНДФЛ = Новый Запрос;
	ЗапросНДФЛ.УстановитьПараметр("Ссылка", Ведомость.Ссылка);
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	// ФизическоеЛицо, СтавкаНалогообложенияРезидента, МесяцНалоговогоПериода, Подразделение, КодДохода, РегистрацияВНалоговомОргане, ВключатьВДекларациюПоНалогуНаПрибыль, ДокументОснование и др. поля
	|	*
	|ИЗ
	|	#ВедомостьНДФЛ КАК ВедомостьНДФЛ
	|ГДЕ
	|	ВедомостьНДФЛ.Ссылка = &Ссылка";
	ЗапросНДФЛ.Текст = СтрЗаменить(ТекстЗапроса, "#ВедомостьНДФЛ", Ведомость.Метаданные().ПолноеИмя() + ".НДФЛ");
	
	УчетФактическиПолученныхДоходов.СоздатьВТНалогУдержанный(МенеджерВременныхТаблиц, ЗапросНДФЛ, ВедомостьНаВыплатуЗарплатыКлиентСервер.ДатаВыплаты(Ведомость)); 
	
	ВедомостьНаВыплатуЗарплаты.ЗарегистрироватьУдержанныйНалогПоВременнымТаблицам(Ведомость, Отказ, Ведомость.Организация, Ведомость.Дата, ВедомостьНаВыплатуЗарплатыКлиентСервер.ДатаВыплаты(Ведомость), МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура ЗарегистрироватьПеречислениеНДФЛ(Ведомость, Отказ = Ложь)
	
	УчетНДФЛРасширенный.ЗарегистрироватьНДФЛПеречисленныйПоПлатежномуДокументу(Ведомость.Движения, Отказ, Ведомость.Организация, ВедомостьНаВыплатуЗарплатыКлиентСервер.ДатаВыплаты(Ведомость), Ведомость.ПеречислениеНДФЛРеквизиты);
	
КонецПроцедуры

#КонецОбласти
