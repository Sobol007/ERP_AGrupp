#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
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
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаФизическоеЛицоВШапке();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
	
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Договор подряда
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.ДоговорАвторскогоЗаказа";
	КомандаПечати.Идентификатор = "ПФ_MXL_ДоговорАвторскогоЗаказа";
	КомандаПечати.Представление = НСтр("ru = 'Договор авторского заказа';
										|en = 'Copyright agreement'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	
	// Акт приема-передачи выполненных работ (услуг).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_АктСдачиПриемкиВыполненныхРаботУслуг";
	КомандаПечати.Представление = НСтр("ru = 'Акт приема-передачи выполненных работ (услуг)';
										|en = 'Certificate of acceptance and transfer of performed works (rendered services)'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьСоглашение = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ДоговорАвторскогоЗаказа");
	
	Если НужноПечататьСоглашение Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ПФ_MXL_ДоговорАвторскогоЗаказа",
			НСтр("ru = 'Договор авторского заказа';
				|en = 'Copyright agreement'"), ПечатьДоговора(МассивОбъектов, ОбъектыПечати), ,
			"Документ.ДоговорАвторскогоЗаказа.ПФ_MXL_ДоговорАвторскогоЗаказа");
	КонецЕсли;
						
КонецПроцедуры								

Функция ПечатьДоговора(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДоговорАвторскогоЗаказа_ДоговорАвторскогоЗаказа";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДоговорАвторскогоЗаказа.ПФ_MXL_ДоговорАвторскогоЗаказа");
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;		
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет.Параметры.Заполнить(ДанныеПечати.Значение);
		
		ТабличныйДокумент.Вывести(Макет);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Значение.Ссылка);
		
	КонецЦикла;	
						
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ДанныеПечатиДокументов(МассивОбъектов)
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорАвторскогоЗаказа.Ссылка,
	|	ДоговорАвторскогоЗаказа.Номер,
	|	ДоговорАвторскогоЗаказа.Дата,
	|	ДоговорАвторскогоЗаказа.Организация,
	|	ДоговорАвторскогоЗаказа.Организация.НаименованиеПолное КАК НазваниеОрганизации,
	|	ДоговорАвторскогоЗаказа.Сотрудник,
	|	ДоговорАвторскогоЗаказа.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВЫБОР
	|		КОГДА ДоговорАвторскогоЗаказа.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот)
	|				ИЛИ ДоговорАвторскогоЗаказа.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами)
	|			ТОГДА &ОплатаПоАктам
	|		ИНАЧЕ &ОплатаПоДоговору
	|	КОНЕЦ КАК ЧастотаВыплат,
	|	ДоговорАвторскогоЗаказа.ДатаНачала,
	|	ДоговорАвторскогоЗаказа.ДатаОкончания,
	|	ДоговорАвторскогоЗаказа.Сумма КАК СуммаЗаРаботу,
	|	ДоговорАвторскогоЗаказа.Руководитель КАК Руководитель,
	|	ДоговорАвторскогоЗаказа.ДолжностьРуководителя КАК ДолжностьРуководителя
	|ИЗ
	|	Документ.ДоговорАвторскогоЗаказа КАК ДоговорАвторскогоЗаказа
	|ГДЕ
	|	ДоговорАвторскогоЗаказа.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ОплатаПоАктам", НСтр("ru = 'ежемесячно';
													|en = 'monthly'"));
	Запрос.УстановитьПараметр("ОплатаПоДоговору", НСтр("ru = 'однократно в конце срока';
														|en = 'once at the end of the period'"));
	РезультатыЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ДокументДляПечати Из РезультатыЗапроса Цикл
		
		ДанныеПечати = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ДокументДляПечати);
		ДанныеПечати.Вставить("ФИОРуководителяСклоняемое", "");
		ДанныеПечати.Дата = Формат(ДанныеПечати.Дата, "ДЛФ=D");
		ДанныеПечати.ДатаНачала = Формат(ДанныеПечати.ДатаНачала, "ДЛФ=DD");
		ДанныеПечати.ДатаОкончания = Формат(ДанныеПечати.ДатаОкончания, "ДЛФ=DD");
		
		// Подготовка номера документа.
		ДанныеПечати.Номер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер, Ложь, Ложь);

		Если ЗначениеЗаполнено(ДанныеПечати.Руководитель) Тогда
				
			ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
				Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеПечати.Руководитель), 
				"Пол,Фамилия,Имя,Отчество", ДанныеПечати.Дата);
				
			Если ДанныеФизическогоЛица[0].Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
				ДанныеПечати.Вставить("Действующего", НСтр("ru = 'действующего';
															|en = 'valid'"));
			Иначе
				ДанныеПечати.Вставить("Действующего", НСтр("ru = 'действующей';
															|en = 'valid'"));
			КонецЕсли;
			
			Если ДанныеФизическогоЛица.Количество() > 0 Тогда			
				
				ДанныеРуководителя = ДанныеФизическогоЛица[0];
				ФИОРуководителя = Новый Структура("Фамилия,Имя,Отчество");
				ЗаполнитьЗначенияСвойств(ФИОРуководителя, ДанныеРуководителя);
				
				ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ФИОРуководителя.Фамилия),
					2, ФИОРуководителя.Фамилия, ДанныеРуководителя.Пол);
					
				ДанныеПечати.ФИОРуководителяСклоняемое = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИОРуководителя);
				
			КонецЕсли;
				
		КонецЕсли;
		
		ДанныеПечати.ДолжностьРуководителя = СклонениеПредставленийОбъектов.ПросклонятьПредставление(Строка(ДанныеПечати.ДолжностьРуководителя), 2);
		
		// Юридический адрес организации.
		ДанныеПечати.Вставить("АдресОрганизации", УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			ДанныеПечати.Организация,
			Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
			ДокументДляПечати.Дата,
			Истина));
		
		// Данные физического лица
		ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
			Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументДляПечати.ФизическоеЛицо), 
			"ФИОПолные, ФамилияИО, АдресПоПрописке, ДокументВид, ДокументСерия, ДокументНомер", ДокументДляПечати.Дата);
			
		Если ДанныеФизическогоЛица.Количество() > 0 Тогда
				
			СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(
					ДанныеФизическогоЛица[0].АдресПоПрописке, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
			АдресПоПрописке = "";
			УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеАдреса(СтруктураАдреса, АдресПоПрописке);
			
			ДанныеПечати.Вставить("РаботникНаименование", ДанныеФизическогоЛица[0].ФамилияИО);
			ДанныеПечати.Вставить("АдресСотрудника", АдресПоПрописке);
			ДанныеПечати.Вставить("ДокументВид", ДанныеФизическогоЛица[0].ДокументВид);
			ДанныеПечати.Вставить("ДокументСерия", ДанныеФизическогоЛица[0].ДокументСерия);
			ДанныеПечати.Вставить("ДокументНомер", ДанныеФизическогоЛица[0].ДокументНомер);
			
		КонецЕсли;
		
		// Сумма договора и валюта
		ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
		ДанныеПечати.Вставить("ВалютаДокумента", ВалютаУчета.НаименованиеПолное);
		
		// Заполнение соответствия
		ДанныеПечатиОбъектов.Вставить(ДокументДляПечати.Ссылка, ДанныеПечати);

	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорАвторскогоЗаказа.Сотрудник,
	|	ДоговорАвторскогоЗаказа.ДатаНачала,
	|	ДоговорАвторскогоЗаказа.ДатаНачалаПФР,
	|	ДоговорАвторскогоЗаказа.ДатаОкончания,
	|	ДоговорАвторскогоЗаказа.Ссылка,
	|	ДоговорАвторскогоЗаказа.Организация,
	|	ДоговорАвторскогоЗаказа.Подразделение,
	|	ДоговорАвторскогоЗаказа.Территория
	|ИЗ
	|	Документ.ДоговорАвторскогоЗаказа КАК ДоговорАвторскогоЗаказа
	|ГДЕ
	|	ДоговорАвторскогоЗаказа.Ссылка В(&МассивСсылок)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииДоговоровГПХВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу); 
		
		ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
		ОписаниеПериода.Сотрудник = Выборка.Сотрудник;	
		ОписаниеПериода.ДатаНачалаПериода = Макс(Выборка.ДатаНачала, Выборка.ДатаНачалаПФР);
		ОписаниеПериода.ДатаОкончанияПериода = Выборка.ДатаОкончания;
		ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;

		РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
		
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Территория", Выборка.Территория);
	КонецЦикла;	
		
	Возврат ДанныеДляРегистрацииВУчете;
															
КонецФункции	


#КонецОбласти

#КонецОбласти

#КонецЕсли