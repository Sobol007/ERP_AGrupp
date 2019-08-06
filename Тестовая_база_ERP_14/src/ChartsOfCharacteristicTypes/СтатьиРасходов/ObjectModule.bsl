#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	 И НЕ ЭтоГруппа
	 И ДанныеЗаполнения.Свойство("ВариантРаспределенияРасходовРегл") Тогда
	 
		Если ДанныеЗаполнения.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Склады");
		//++ НЕ УТ
		ИначеЕсли ДанныеЗаполнения.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
		//-- НЕ УТ
		ИначеЕсли ДанныеЗаполнения.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаПрочиеАктивы Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ПрочиеРасходы");
			
		//++ НЕ УТ
		ИначеЕсли ДанныеЗаполнения.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы Тогда
			
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ОбъектыЭксплуатации");
			КонтролироватьЗаполнениеАналитики = Истина;
		//-- НЕ УТ
		КонецЕсли;
	 
	КонецЕсли;
	
	Если ТипЗначения.Типы().Количество() > 1 Тогда
		ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Партнеры");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Предопределенный Тогда
		
		ПроверяемыеСтатьи = Новый Массив;
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.КурсовыеРазницы);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.НачисленныйНДСПриВыкупеМногооборотнойТары);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ПрибыльУбытокПрошлыхЛет);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.СебестоимостьПродаж);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ФормированиеРезервовПоСомнительнымДолгам);
		Если ПроверяемыеСтатьи.Найти(Ссылка) <> Неопределено Тогда
			Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности Тогда
				ТекстСообщения = НСтр("ru = 'Необходимо выбрать вариант распределения в регл. учете ""На финансовый результат""';
										|en = 'Select allocation option in the To financial result compl. accounting'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ВариантРаспределенияРасходовРегл",
					,
					Отказ);
			КонецЕсли;
		КонецЕсли;
			
		Если Ссылка = ПланыВидовХарактеристик.СтатьиРасходов.НДСНалоговогоАгента
			И ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			
			ТекстСообщения = НСтр("ru = 'Необходимо выбрать вариант распределения ""На себестоимость товаров""';
									|en = 'Select the ""For goods cost"" allocation option'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ВариантРаспределенияРасходовРегл",
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров
	 И ВариантРаспределенияРасходовУпр <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияНаСебестоимость");
	КонецЕсли;
	
	//++ НЕ УТ
	Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты
	 И ВариантРаспределенияРасходовУпр <> Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты Тогда
	 
	 	МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("ХарактерПроизводственныхЗатрат");
		
	КонецЕсли;
	
	Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидАктива");
	КонецЕсли;
	
	// Предопределенные значения
	ВидРасходовНеУчитываемые = Перечисления.ВидыРасходовНУ.НеУчитываемыеВЦеляхНалогообложения;
	ВидРасходовИспользуется = ПланыВидовХарактеристик.СтатьиРасходов.ВидРасходовИспользуется(ЭтотОбъект);
	
	Если ЭтоГруппа ИЛИ НЕ ВидРасходовИспользуется Тогда
		
	// Вид расходов должен соответствовать флагу принятия к НУ
	ИначеЕсли Не ПринятиеКналоговомуУчету И Не ВидРасходов = ВидРасходовНеУчитываемые Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Вид расходов должен быть не принимаемым к налоговому учету.';
				|en = 'Expense kind must not be entered in tax accounting.'"),
			ЭтотОбъект,
			"ВидРасходов",
			,
			Отказ);
		
	ИначеЕсли ПринятиеКналоговомуУчету И ВидРасходов = ВидРасходовНеУчитываемые Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Вид расходов должен быть принимаемым к налоговому учету.';
				|en = 'Expense kind must be entered in tax accounting.'"),
			ЭтотОбъект,
			"ВидРасходов",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов 
		ИЛИ НЕ ПринятиеКналоговомуУчету Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ВидРБП"); 
	КонецЕсли;
	
	Если НЕ ВидРасходовИспользуется Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидРасходов"); 
	КонецЕсли;
	
	Если НЕ ПланыВидовХарактеристик.СтатьиРасходов.ВидПрочихРасходовИспользуется(ЭтотОбъект) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидПрочихРасходов"); 
	КонецЕсли;
	
	//-- НЕ УТ
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		ВариантРаспределенияРасходов = ВариантРаспределенияРасходовРегл;
		
		Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности 
			И ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НеРаспределять Тогда
			
			ВидДеятельностиРасходов = Перечисления.ВидыДеятельностиРасходов.ОсновнаяДеятельность;
			
		КонецЕсли;
			
		Если ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			ВидЦенностиНДС = Перечисления.ВидыЦенностей.Товары;
		//++ НЕ УТ
		ИначеЕсли ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы Тогда
			Если ВидЦенностиНДС.Пустая() Тогда
				ВидЦенностиНДС = Перечисления.ВидыЦенностей.ОС
			КонецЕсли;
		//-- НЕ УТ
		Иначе
			ВидЦенностиНДС = Перечисления.ВидыЦенностей.ПрочиеРаботыИУслуги;
		КонецЕсли;
		
		ПрочиеРасходы = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ПрочиеРасходы"));
		ДоговорыКредитовИДепозитов = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ДоговорыКредитовИДепозитов"));
		//++ НЕ УТ
		РасходыНаОбъектыЭксплуатации = (ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОбъектыЭксплуатации")));
		РасходыНаНМАиНИОКР = (ТипЗначения.СодержитТип(Тип("СправочникСсылка.НематериальныеАктивы")));
		РасходыНаОбъектыСтроительства = (ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОбъектыСтроительства")));
		//-- НЕ УТ
		//++ НЕ УТКА
		РасходыНаЗаказыНаРемонт = (ТипЗначения.СодержитТип(Тип("ДокументСсылка.ЗаказНаРемонт")));
		//-- НЕ УТКА
		Если Не ПустаяСтрока(КорреспондирующийСчет) Тогда
			Если ПустаяСтрока(СтрЗаменить(КорреспондирующийСчет, ".", "")) Тогда
				КорреспондирующийСчет = "";
			Иначе
				Пока Прав(СокрЛП(КорреспондирующийСчет), 1) = "." Цикл
					КорреспондирующийСчет = Лев(СокрЛП(КорреспондирующийСчет), СтрДлина(СокрЛП(КорреспондирующийСчет)) - 1);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ОграничитьИспользование
			И ДоступныеХозяйственныеОперации.Количество() > 0 Тогда
			
			ДоступныеХозяйственныеОперации.Очистить();
			ДоступныеОперации = "";
		Иначе
			СписокОпераций = Новый СписокЗначений;
			ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьСписокХозяйственныхОпераций(
				СписокОпераций,
				ВариантРаспределенияРасходовУпр,
				ВариантРаспределенияРасходовРегл);
			СтрокаДоступныеОперации = "";
			Для Каждого СтрокаТаблицы Из ДоступныеХозяйственныеОперации Цикл
				ЭлементСписка = СписокОпераций.НайтиПоЗначению(СтрокаТаблицы.ХозяйственнаяОперация);
				Если ЭлементСписка <> Неопределено Тогда
					СтрокаДоступныеОперации = СтрокаДоступныеОперации
						+ ?(Не ПустаяСтрока(СтрокаДоступныеОперации), ", ", "")
						+ ЭлементСписка.Представление;
				КонецЕсли;
			КонецЦикла;
			Если ДоступныеОперации <> СтрокаДоступныеОперации Тогда
				ДоступныеОперации = СтрокаДоступныеОперации;
			КонецЕсли;
		КонецЕсли;
		
		//++ НЕ УТ
		Если ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов Тогда
			ПринятиеКналоговомуУчету = Истина;
			ВидРасходов = Неопределено;
			ВидПрочихРасходов = Неопределено;
		КонецЕсли;
		
		Если Не ПринятиеКналоговомуУчету 
			И ВидРасходов.Пустая()
			И ПланыВидовХарактеристик.СтатьиРасходов.ВидРасходовИспользуется(ЭтотОбъект) Тогда
			ВидРасходов = Перечисления.ВидыРасходовНУ.НеУчитываемыеВЦеляхНалогообложения;
		КонецЕсли;
		//-- НЕ УТ
		Если Не ЗначениеЗаполнено(ВариантРаздельногоУчетаНДС) Тогда
			ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.ИзДокумента;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		ВидыСчетаДляОчистки = Новый Массив;
		Если ЗначениеЗаполнено(СчетУчета) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.Расходы);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетСписанияОСНО) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.СписаниеРасходовОСНО);
		КонецЕсли;
		Если ЗначениеЗаполнено(СчетСписанияЕНВД) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.СписаниеРасходовЕНВД);
		КонецЕсли;
		Если ВидыСчетаДляОчистки.Количество() Тогда
			РегистрыСведений.СчетаРеглУчетаТребующиеНастройки.ОчиститьПриЗаписиАналитикиУчета(Ссылка, ВидыСчетаДляОчистки);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
