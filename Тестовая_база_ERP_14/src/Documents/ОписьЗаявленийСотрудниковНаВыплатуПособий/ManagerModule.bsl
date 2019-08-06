#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	ОписаниеСостава = ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента();
	ОписаниеСостава.ЗаполнятьФизическиеЛицаПоСотрудникам = Ложь;
	ОписаниеСостава.ИспользоватьКраткийСостав = Ложь;
	ОписаниеСостава.ЗаполнятьТабличнуюЧастьФизическиеЛицаДокумента = Ложь;
	
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		"ФизическиеЛица",
		"ФизическоеЛицо");
		
	Возврат ОписаниеСостава;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьТабличнуюЧастьФизическихЛицИНаборыЗначенийДоступа() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОписьФизическиеЛица.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ОписиСФизическимиЛицами
	|ИЗ
	|	Документ.ОписьЗаявленийСотрудниковНаВыплатуПособий.ФизическиеЛица КАК ОписьФизическиеЛица
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОписьЗаявления.Ссылка КАК Ссылка,
	|	ЗаявлениеСотрудника.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	Документ.ОписьЗаявленийСотрудниковНаВыплатуПособий.Заявления КАК ОписьЗаявления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК ЗаявлениеСотрудника
	|		ПО ОписьЗаявления.Заявление = ЗаявлениеСотрудника.Ссылка
	|ГДЕ
	|	НЕ ОписьЗаявления.Ссылка В
	|				(ВЫБРАТЬ
	|					ОписиСФизическимиЛицами.Ссылка
	|				ИЗ
	|					ОписиСФизическимиЛицами)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	ФизическоеЛицо";
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
			Документ = Выборка.Ссылка.ПолучитьОбъект();
			Пока Выборка.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(Документ.ФизическиеЛица.Добавить(), Выборка, "ФизическоеЛицо");			
			КонецЦикла;
			Документ.ОбменДанными.Загрузка = Истина;
			Документ.ДополнительныеСвойства.Вставить("ЗаписатьНаборыЗначенийДоступа", Истина);
			Документ.Записать(РежимЗаписиДокумента.Запись);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать описи заявлений сотрудников о выплате пособий.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ОписьЗаявленийСотрудниковНаВыплатуПособий";
	КомандаПечати.Представление = НСтр("ru = 'Опись заявлений сотрудников на выплату пособий';
										|en = 'List of employee applications for allowance payment'");
	
КонецПроцедуры

Процедура Печать(МассивСсылок, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОписьЗаявленийСотрудниковНаВыплатуПособий") Тогда
		ТабличныйДокумент = ПечатьОписиЗаявленийСотрудниковНаВыплатуПособий(МассивСсылок, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ОписьЗаявленийСотрудниковНаВыплатуПособий",
			НСтр("ru = 'Опись заявлений сотрудников на выплату пособий';
				|en = 'List of employee applications for allowance payment'"),
			ТабличныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьОписиЗаявленийСотрудниковНаВыплатуПособий(МассивСсылок, ОбъектыПечати)
	// Создаем табличный документ и устанавливаем имя параметров печати.
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ОписьЗаявленийСотрудниковНаВыплатуПособий";
	ТабличныйДокумент.ПолеСлева = 0;
	ТабличныйДокумент.ПолеСправа = 0;
	ТабличныйДокумент.ПолеСнизу = 0;
	ТабличныйДокумент.ПолеСверху = 0;
	
	ДатаФорм2017 = ПрямыеВыплатыПособийСоциальногоСтрахования.ДатаВступленияВСилуФорм2017Года();
	
	// Получаем запросом необходимые данные.
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("ДатаФорм2017", ДатаФорм2017);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокументОпись.Ссылка КАК Ссылка,
	|	ДокументОпись.Дата КАК Дата,
	|	ВЫБОР
	|		КОГДА ДокументОпись.Дата < &ДатаФорм2017
	|			ТОГДА ""ПФ_MXL_ОписьЗаявленийИДокументовВФСС_2012""
	|		ИНАЧЕ ""ПФ_MXL_ОписьЗаявленийИДокументовВФСС_2017""
	|	КОНЕЦ КАК ИмяМакета,
	|	ТаблицаЗаявленияДокументаОпись.Заявление,
	|	ТаблицаЗаявленияДокументаОпись.КраткоеНаименованиеДокументов КАК ДокументыОснования,
	|	ТаблицаЗаявленияДокументаОпись.КоличествоСтраниц,
	|	ДокументОпись.НаименованиеОрганизации КАК НаименованиеОрганизации,
	|	ДокументОпись.РегистрационныйНомерФСС КАК РегистрационныйНомерФСС,
	|	ДокументОпись.КодПодчиненностиФСС КАК КодПодчиненностиФСС,
	|	ДокументОпись.ИНН КАК ИНН,
	|	ДокументОпись.КПП КАК КПП,
	|	ДокументОпись.ДополнительныйКодФСС КАК ДополнительныйКодФСС,
	|	ДокументОпись.НаименованиеТерриториальногоОрганаФСС КАК НаименованиеТерриториальногоОрганаФСС,
	|	ДокументОпись.ТелефонУполномоченногоПредставителя КАК ТелефонУполномоченногоПредставителя,
	|	ДокументОпись.ДолжностьУполномоченногоПоПрямымВыплатамФСС КАК ДолжностьУполномоченногоПоПрямымВыплатамФСС,
	|	ДокументОпись.УдалитьФИОУполномоченного КАК УдалитьФИОУполномоченного,
	|	ВЫБОР
	|		КОГДА ДокументЗаявление.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПособияНазначаемыеФСС.ПособиеПоБеременностиИРодам)
	|			ТОГДА 2
	|		КОГДА ДокументЗаявление.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПособияНазначаемыеФСС.ПособиеВставшимНаУчетВРанниеСроки)
	|			ТОГДА 3
	|		КОГДА ДокументЗаявление.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПособияНазначаемыеФСС.ЕдиновременноеПособиеПриРожденииРебенка)
	|			ТОГДА 4
	|		КОГДА ДокументЗаявление.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПособияНазначаемыеФСС.ЕжемесячноеПособиеПоУходуЗаРебенком)
	|			ТОГДА 5
	|		КОГДА ДокументЗаявление.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПособияНазначаемыеФСС.ПособиеВСвязиСНесчастнымСлучаемНаПроизводстве)
	|			ТОГДА 6
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ВидПособия,
	|	ДокументЗаявление.ФамилияЗаявителя,
	|	ДокументЗаявление.ИмяЗаявителя,
	|	ДокументЗаявление.ОтчествоЗаявителя
	|ИЗ
	|	Документ.ОписьЗаявленийСотрудниковНаВыплатуПособий КАК ДокументОпись
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОписьЗаявленийСотрудниковНаВыплатуПособий.Заявления КАК ТаблицаЗаявленияДокументаОпись
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК ДокументЗаявление
	|			ПО ТаблицаЗаявленияДокументаОпись.Заявление = ДокументЗаявление.Ссылка
	|		ПО (ТаблицаЗаявленияДокументаОпись.Ссылка = ДокументОпись.Ссылка)
	|ГДЕ
	|	ДокументОпись.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ИмяМакета") Цикл
		Если Выборка.ИмяМакета = "ПФ_MXL_ОписьЗаявленийИДокументовВФСС_2012" Тогда
			КоличествоСтрокВМакете = 15;
		Иначе
			КоличествоСтрокВМакете = 13;
		КонецЕсли;
		
		Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
			Макет = Неопределено;
			ВыведеноСтрок = 0;
			Пока Выборка.Следующий() Цикл
				Если Не ЗначениеЗаполнено(Выборка.Заявление) Тогда
					Продолжить;
				КонецЕсли;
				ВыведеноСтрок = (ВыведеноСтрок + 1) % КоличествоСтрокВМакете;
				НомерСтроки = ?(ВыведеноСтрок = 0, КоличествоСтрокВМакете, ВыведеноСтрок);
				
				Если ВыведеноСтрок = 1 Тогда
					Если Макет <> Неопределено Тогда
						Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
							ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						КонецЕсли;
						ТабличныйДокумент.Вывести(Макет);
					КонецЕсли;
					Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОписьЗаявленийСотрудниковНаВыплатуПособий." + Выборка.ИмяМакета);
					Если Выборка.ИмяМакета = "ПФ_MXL_ОписьЗаявленийИДокументовВФСС_2012" Тогда
						ВывестиШапкуИПодвалОписиЗаявлений_2012(Макет, Выборка);
					Иначе
						ВывестиШапкуИПодвалОписиЗаявлений_2017(Макет, Выборка);
					КонецЕсли;
				КонецЕсли;
				
				Если Выборка.ИмяМакета = "ПФ_MXL_ОписьЗаявленийИДокументовВФСС_2012" Тогда
					ВывестиСтрокуОписиЗаявлений_2012(Макет, Выборка, НомерСтроки);
				Иначе
					ВывестиСтрокуОписиЗаявлений_2017(Макет, Выборка, НомерСтроки);
				КонецЕсли;
			КонецЦикла;
			Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			ТабличныйДокумент.Вывести(Макет);
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

Процедура ВывестиСтрокуОписиЗаявлений_2012(Макет, Выборка, НомерСтроки)
	
	ПрефиксСтроки = "ФИО_" + Формат(НомерСтроки,"ЧЦ=2; ЧВН=") + "_";
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.ФамилияЗаявителя),  Макет, ПрефиксСтроки, 20);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.ИмяЗаявителя),      Макет, ПрефиксСтроки, 20, 21);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.ОтчествоЗаявителя), Макет, ПрефиксСтроки, 20, 41);
	
	Макет.Области["ВидВыплаты" + НомерСтроки].Текст = Выборка.ВидПособия;
	Макет.Области["Документы_" + НомерСтроки].Текст = Лев(Выборка.ДокументыОснования, 105);
	
	Если Выборка.КоличествоСтраниц < 10 Тогда
		Макет.Области["Страниц" + НомерСтроки].Текст = "      " + Выборка.КоличествоСтраниц;
	Иначе
		КоличествоСтраниц = Формат(Выборка.КоличествоСтраниц, "ЧЦ=2");
		КоличествоСтраниц = Лев("    ", 2 - СтрДлина(КоличествоСтраниц)) + КоличествоСтраниц;
		Макет.Области["Страниц" + НомерСтроки].Текст = Лев(КоличествоСтраниц, 1) + "    " + Прав(КоличествоСтраниц, 1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиСтрокуОписиЗаявлений_2017(Макет, Выборка, НомерСтроки)
	
	Макет.Параметры["Фамилия"           + НомерСтроки] = Выборка.ФамилияЗаявителя;
	Макет.Параметры["Имя"               + НомерСтроки] = Выборка.ИмяЗаявителя;
	Макет.Параметры["Отчество"          + НомерСтроки] = Выборка.ОтчествоЗаявителя;
	Макет.Параметры["ВидВыплаты"        + НомерСтроки] = Выборка.ВидПособия;
	Макет.Параметры["Документы"         + НомерСтроки] = Лев(Выборка.ДокументыОснования, 290);
	Макет.Параметры["КоличествоСтраниц" + НомерСтроки] = Выборка.КоличествоСтраниц;
	
КонецПроцедуры

Процедура ВывестиШапкуИПодвалОписиЗаявлений_2012(Макет, Выборка)
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.РегистрационныйНомерФСС, Макет, "РегистрационныйНомер_", 10);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.ДополнительныйКодФСС, Макет, "ДополнительныйКод_", 10);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КодПодчиненностиФСС, Макет, "КодПодчиненности_", 5);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.ИНН, Макет, "ИНН_", 12);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КПП, Макет, "КПП_", 9);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.НаименованиеОрганизации), Макет, "Страхователь_", 30);
	ДлиныСтрок = Новый Массив();
	ДлиныСтрок.Добавить(35);
	ДлиныСтрок.Добавить(39);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ВРег(Выборка.НаименованиеТерриториальногоОрганаФСС), ДлиныСтрок), Макет, "Фонд_", 74);
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(КраткоеПредставлениеТелефона(Выборка.ТелефонУполномоченногоПредставителя), Макет, "ТелефонСоставителя_", 10);
	
	Макет.Параметры.ДолжностьРуководителя = "" + Выборка.ДолжностьУполномоченногоПоПрямымВыплатамФСС;
	Макет.Параметры.ФИОРуководителя       = "" + Выборка.УдалитьФИОУполномоченного;
	
КонецПроцедуры

Процедура ВывестиШапкуИПодвалОписиЗаявлений_2017(Макет, Выборка)
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.РегистрационныйНомерФСС, Макет, "РегистрационныйНомер_", 10);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.ДополнительныйКодФСС, Макет, "ДополнительныйКод_", 10);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КодПодчиненностиФСС, Макет, "КодПодчиненности_", 5);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.ИНН, Макет, "ИНН_", 12);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КПП, Макет, "КПП_", 9);
	Макет.Параметры.Страхователь = Выборка.НаименованиеОрганизации;
	Макет.Параметры.Фонд         = Выборка.НаименованиеТерриториальногоОрганаФСС;
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(КраткоеПредставлениеТелефона(Выборка.ТелефонУполномоченногоПредставителя), Макет, "ТелефонСоставителя_", 10);
	
	Макет.Параметры.ДолжностьРуководителя = "" + Выборка.ДолжностьУполномоченногоПоПрямымВыплатамФСС;
	Макет.Параметры.ФИОРуководителя       = "" + Выборка.УдалитьФИОУполномоченного;
	
КонецПроцедуры

Функция КраткоеПредставлениеТелефона(ПредставлениеТелефона)
	Телефон = ПредставлениеТелефона;
	Если Лев(Телефон,3) = "+7 " Тогда
		Телефон = Сред(Телефон,4)
	ИначеЕсли Лев(Телефон,2) = "8 " Тогда
		Телефон = Сред(Телефон,3)
	КонецЕсли;
	Телефон = СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрЗаменить(Телефон,"(",""),")","")," ",""),"-",""),",","");
	Возврат Телефон;
КонецФункции

#КонецОбласти

#КонецЕсли
