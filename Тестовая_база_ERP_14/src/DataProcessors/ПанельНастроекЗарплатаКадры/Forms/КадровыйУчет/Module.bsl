#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Определяем показывать ли глобальную настройку по отключению и кадрами, и зарплатой.
	ДоступностьУстановкиИспользованияКадровогоУчетаИРасчетаЗарплаты = Ложь;
	ЗарплатаКадрыРасширенныйПереопределяемый.ОпределитьДоступностьУстановкиИспользованияЗарплатаКадры(ДоступностьУстановкиИспользованияКадровогоУчетаИРасчетаЗарплаты);
	Элементы.ГруппаИспользоватьКадровыйУчетИРасчетЗарплаты.Видимость = ДоступностьУстановкиИспользованияКадровогоУчетаИРасчетаЗарплаты;
	
	ПрочитатьНастройки();
	ОбновитьОписаниеНастроекШтатногоРасписания(ЭтаФорма);
	// Установка доступности элементов формы в зависимости от текущих настроек.
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	УстановитьВидимостьЭлементовФормы(ЭтаФорма);
	УстановитьТекстПояснениеИспользоватьПереносОстатковОтпуска(ЭтотОбъект);
	
	Если ЗарплатаКадры.ЭтоБазоваяВерсияКонфигурации() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаИспользоватьПодработки",
			"Видимость",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаПереносОстатковОтпуска",
			"Видимость",
			Ложь);
			
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ИспользоватьУниверсальнуюФормуСпискаСотрудниковГруппа",
		"Видимость",
		ИспользоватьПодробныеФормыСотрудников());
		
	//ERP начало
	Элементы.НастройкиКадровогоУчета.Видимость = Ложь;
	//ERP конец
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтаФорма.ТребуетсяОбновлениеИнтерфейса Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНастройкиШтатногоРасписания" Тогда
		ПрочитатьНастройкиШтатногоРасписания();
		ОбновитьОписаниеНастроекШтатногоРасписания(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьКадровыйУчетИРасчетЗарплатыПриИзменении(Элемент)
	
	// ERP начало: 00-00052344
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	Оповестить("ИспользоватьКадровыйУчетИРасчетЗарплаты", ИспользоватьКадровыйУчетИРасчетЗарплаты);
	ЗаписатьНастройкиНаКлиенте("КадровыйУчетИРасчетЗарплаты");
	// ERP конец
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчетаКонтролироватьУникальностьТабельныхНомеровПриИзменении(Элемент)
	
	НастройкиКадровогоУчетаПрежняя.КонтролироватьУникальностьТабельныхНомеров = НастройкиКадровогоУчета.КонтролироватьУникальностьТабельныхНомеров;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчетаПечататьТ6ДляОтпусковПоБеременностиИРодамПриИзменении(Элемент)
	
	НастройкиКадровогоУчетаПрежняя.ПечататьТ6ДляОтпусковПоБеременностиИРодам = НастройкиКадровогоУчета.ПечататьТ6ДляОтпусковПоБеременностиИРодам;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчетаОтображатьИзмененияОплатыТрудаВЛичнойКарточкеПриИзменении(Элемент)
	
	НастройкиКадровогоУчетаПрежняя.ОтображатьИзмененияОплатыТрудаВЛичнойКарточке = НастройкиКадровогоУчета.ОтображатьИзмененияОплатыТрудаВЛичнойКарточке;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчетаПравилоФормированияПредставленияЭлементовСправочникаСотрудникиПриИзменении(Элемент)
	
	ОбновитьПравилоФормированияПредставленияЭлементовСправочникаСотрудники = Истина;
	НастройкиКадровогоУчетаПрежняя.ПравилоФормированияПредставленияЭлементовСправочникаСотрудники = НастройкиКадровогоУчета.ПравилоФормированияПредставленияЭлементовСправочникаСотрудники;
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРаботуНаНеполнуюСтавкуПриИзменении(Элемент)
	
	НастройкиКадровогоУчетаПрежняя.ИспользоватьРаботуНаНеполнуюСтавку = НастройкиКадровогоУчета.ИспользоватьРаботуНаНеполнуюСтавку;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиКадровогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПодработкиПриИзменении(Элемент)
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьПодработки");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУниверсальнуюФормуСпискаСотрудниковПриИзменении(Элемент)
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьУниверсальнуюФормуСпискаСотрудников");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьПрерываниеСтажейАвтоматическиПриИзменении(Элемент)
	
	Если НЕ ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АвтоматическийРасчетСтажейФизическихЛиц") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьНастройкиНаКлиенте("УчитыватьПрерываниеСтажейАвтоматически");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВоинскийУчетПриИзменении(Элемент)
	
	Если НастройкиВоинскогоУчета.ИспользоватьВоинскийУчет Тогда
		НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан = НастройкиВоинскогоУчетаПрежняя.ИспользоватьБронированиеГраждан;
		НастройкиВоинскогоУчета.ИспользуетсяТрудЛетноПодъемногоСостава = НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудЛетноПодъемногоСостава;
		НастройкиВоинскогоУчета.ИспользуетсяТрудПлавсостава = НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудПлавсостава;
	Иначе
		НастройкиВоинскогоУчетаПрежняя.ИспользоватьБронированиеГраждан = НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан;
		НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудЛетноПодъемногоСостава = НастройкиВоинскогоУчета.ИспользуетсяТрудЛетноПодъемногоСостава;
		НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудПлавсостава = НастройкиВоинскогоУчета.ИспользуетсяТрудПлавсостава;
		НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан = Ложь;
		НастройкиВоинскогоУчета.ИспользуетсяТрудЛетноПодъемногоСостава = Ложь;
		НастройкиВоинскогоУчета.ИспользуетсяТрудПлавсостава = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормыНастройкиВоинскогоУчета(Элементы, НастройкиВоинскогоУчета);
	
	ЗаписатьНастройкиНаКлиенте("НастройкиВоинскогоУчета");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
		
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБронированиеГражданПриИзменении(Элемент)
	
	Элементы.ГруппаВоинскийУчетСоставы.Доступность = НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан;
	
	Если НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан Тогда
		НастройкиВоинскогоУчета.ИспользуетсяТрудЛетноПодъемногоСостава = НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудЛетноПодъемногоСостава;
		НастройкиВоинскогоУчета.ИспользуетсяТрудПлавсостава = НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудПлавсостава;
	Иначе
		НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудЛетноПодъемногоСостава = НастройкиВоинскогоУчета.ИспользуетсяТрудЛетноПодъемногоСостава;
		НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудПлавсостава = НастройкиВоинскогоУчета.ИспользуетсяТрудПлавсостава;
		НастройкиВоинскогоУчета.ИспользуетсяТрудЛетноПодъемногоСостава = Ложь;
		НастройкиВоинскогоУчета.ИспользуетсяТрудПлавсостава = Ложь;
	КонецЕсли;
	
	НастройкиВоинскогоУчетаПрежняя.ИспользоватьБронированиеГраждан = НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиВоинскогоУчета");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяТрудЛетноПодъемногоСоставаПриИзменении(Элемент)
	
	НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудЛетноПодъемногоСостава = НастройкиВоинскогоУчета.ИспользуетсяТрудЛетноПодъемногоСостава;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиВоинскогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяТрудПлавсоставаПриИзменении(Элемент)
	
	НастройкиВоинскогоУчетаПрежняя.ИспользуетсяТрудПлавсостава = НастройкиВоинскогоУчета.ИспользуетсяТрудПлавсостава;
	
	ЗаписатьНастройкиНаКлиенте("НастройкиВоинскогоУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаШтатногоРасписания(Команда)
	ОткрытьФорму("Обработка.ПанельНастроекЗарплатаКадры.Форма.НастройкаШтатногоРасписания");
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАттестацииСотрудниковПриИзменении(Элемент)
	
	Если НЕ ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Возврат;
	КонецЕсли;
	
	Если РаботаВБюджетномУчреждении И ИспользоватьАттестацииСотрудников Тогда
		ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = 1;
	КонецЕсли;
		
	Если ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = 1
		И Не ИспользоватьАттестацииСотрудников Тогда
		ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = 0;
	КонецЕсли;
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьАттестацииСотрудников,ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии");
	УстановитьДоступностьЭлементовФормыАттестацииСотрудников(ЭтотОбъект);
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьМедицинскоеСтрахованиеСотрудниковПриИзменении(Элемент)
	
	Если НЕ ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.МедицинскоеСтрахование") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьМедицинскоеСтрахованиеСотрудников");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеДокументаФормированиеАттестационнойКомиссииПриИзменении(Элемент)
	
	Если НЕ ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСпециальностиФизическихЛицПриИзменении(Элемент)
	
	ЗаписатьНастройкиНаКлиенте("ИспользоватьСпециальностиФизическихЛиц");
	ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКадровогоУчета(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ПолеСортировкиРазделов", 3); 
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	ПараметрыФормы.Вставить("КлючВарианта", "НастройкиПоРазделам");
	
	ОткрытьФорму("Отчет.НастройкиПрограммыЗарплатаКадры.Форма", ПараметрыФормы, ЭтотОбъект, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОписаниеНастроекШтатногоРасписания(Форма)

	Настройки = Форма.НастройкиШтатногоРасписания;
	ИспользоватьШтатноеРасписание = Настройки.ИспользоватьШтатноеРасписание;
	Если Не ИспользоватьШтатноеРасписание Тогда
		Описание = НСтр("ru = 'Возможность ведения штатного расписания отключена';
						|en = 'Keeping a staff list is disabled'");
	Иначе
		
		РаботаВБюджетномУчреждении = Форма.РаботаВБюджетномУчреждении;
		ИспользоватьНачислениеЗарплаты = Форма.ИспользоватьНачислениеЗарплаты;
		ШтатноеРасписаниеВсегдаИспользуется = Форма.ШтатноеРасписаниеВсегдаИспользуется;
		
		Автопроверка = Настройки.ПроверятьНаСоответствиеШтатномуРасписаниюАвтоматически;
		ИспользоватьИсторию = Настройки.ИспользоватьИсториюИзмененияШтатногоРасписания;
		ИспользоватьВилку = Настройки.ИспользоватьВилкуСтавокВШтатномРасписании;
		ИспользоватьРазрядыКатегории = Настройки.ИспользоватьРазрядыКатегорииКлассыДолжностейИПрофессийВШтатномРасписании;
		ИспользоватьБронированиеПозиций = Настройки.ИспользоватьБронированиеПозиций;
		ТекстАвтопроверка = ?(Автопроверка, НСтр("ru = 'Выполняется';
												|en = 'Active'"), НСтр("ru = 'Не выполняется';
																			|en = 'Not completed'"));
		ТекстИспользоватьИсторию = ?(ИспользоватьИсторию, НСтр("ru = 'Ведется';
																|en = 'Kept'"), НСтр("ru = 'Не ведется';
																						|en = 'Not kept'"));
		ТекстИспользоватьРазрядыКатегории = ?(РаботаВБюджетномУчреждении,"",?(ИспользоватьРазрядыКатегории, НСтр("ru = 'Используются';
																												|en = 'Used'"), НСтр("ru = 'Не используются';
																																				|en = 'Not used'")));
		ТекстИспользоватьВилку = ?(ИспользоватьНачислениеЗарплаты,?(ИспользоватьВилку, НСтр("ru = 'Используется';
																							|en = 'Used'"), НСтр("ru = 'Не используется';
																														|en = 'Not used'")),"");
		ТекстПредставлениеТарифовИНадбавок = ?(ИспользоватьНачислениеЗарплаты, Настройки.ПредставлениеТарифовИНадбавок,"");
		ТекстИспользоватьБронирование = ?(ИспользоватьБронированиеПозиций, НСтр("ru = 'Используется';
																				|en = 'Used'"), НСтр("ru = 'Не используется';
																											|en = 'Not used'"));

		Описание = ?(ШтатноеРасписаниеВсегдаИспользуется, "", НСтр("ru = 'Ведется штатное расписание.';
																	|en = 'Staff list is kept.'") + Символы.ПС);
		
		Описание = Описание + 
		НСтр("ru = '%1 автоматическая проверка кадровых документов на соответствие штатному расписанию.
		|%2 история изменения штатного расписания.';
		|en = '%1 automated check of HR documents for compliance with the staff list.
		|%2 change history of the staff list.'");
		
		Описание = ?(Не РаботаВБюджетномУчреждении, Описание + " 
		|" + НСтр("ru = '%3 разряды и категории в позиции штатного расписания.';
					|en = '%3 categories in the staff list position.'"), Описание);
		
		Описание = ?(ИспользоватьНачислениеЗарплаты, Описание + "
		|" + НСтр("ru = '%4 ""вилка"" окладов и надбавок.';
					|en = '%4 range of base salary and standard bonuses.'"), Описание);
		
			
		Описание = ?(ИспользоватьНачислениеЗарплаты, Описание + "
		|" + НСтр("ru = 'Надбавки в форме Т-3 отображаются как: %5';
					|en = 'Standard bonus is displayed in T-Z form as: %5'"), Описание);
		
		
		Описание = ?(ИспользоватьБронированиеПозиций, Описание + " 
		|" + НСтр("ru = '%6 бронирование позиций штатного расписания.';
					|en = '%6 reserve staff list positions.'"), Описание);

		
		Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Описание,
			ТекстАвтопроверка,
			ТекстИспользоватьИсторию,
			ТекстИспользоватьРазрядыКатегории,
			ТекстИспользоватьВилку,
			ТекстПредставлениеТарифовИНадбавок,
			ТекстИспользоватьБронирование);
		
	КонецЕсли;
	
	Форма.ОписаниеНастроекШтатногоРасписания = Описание;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройки()
	
	РаботаВБюджетномУчреждении = ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
	ИспользоватьНачислениеЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты");
	ШтатноеРасписаниеВсегдаИспользуется = ЗарплатаКадрыРасширенный.ШтатноеРасписаниеВсегдаИспользуется();
	
	ИспользоватьКадровыйУчетИРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") И ИспользоватьНачислениеЗарплаты;
	
	Настройки = РегистрыСведений.НастройкиКадровогоУчета.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	ЗначениеВРеквизитФормы(Настройки, "НастройкиКадровогоУчета");
	ЗначениеВРеквизитФормы(Настройки, "НастройкиКадровогоУчетаПрежняя");
	
	Настройки = РегистрыСведений.НастройкиВоинскогоУчета.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	ЗначениеВРеквизитФормы(Настройки, "НастройкиВоинскогоУчета");
	ЗначениеВРеквизитФормы(Настройки, "НастройкиВоинскогоУчетаПрежняя");
	
	ПрочитатьНастройкиШтатногоРасписания();
	
	ПрочитатьНастройкиАттестацииСотрудников();
	ПрочитатьНастройкиМедицинскогоСтрахованияСотрудников();
	ПрочитатьУчитыватьПрерываниеСтажейАвтоматически();
	
	ИспользоватьСпециальностиФизическихЛиц = Константы.ИспользоватьСпециальностиФизическихЛиц.Получить();
	ИспользоватьПодработки = Константы.ИспользоватьПодработки.Получить();
	
	Если ИспользоватьПодробныеФормыСотрудников() Тогда
		
		МодульСпискиСотрудников = ОбщегоНазначения.ОбщийМодуль("СпискиСотрудников");
		ИспользоватьУниверсальнуюФормуСпискаСотрудников = МодульСпискиСотрудников.ИспользоватьУниверсальнуюФормуСпискаСотрудников();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиШтатногоРасписания()

	Настройки = РегистрыСведений.НастройкиШтатногоРасписания.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	ЗначениеВРеквизитФормы(Настройки, "НастройкиШтатногоРасписания");

КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиАттестацииСотрудников()
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Возврат;	
	КонецЕсли;
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("АттестацииСотрудников");
	
	ИспользоватьАттестацииСотрудников = Модуль.ИспользуетсяАттестацияСотрудников();
	
	Если Модуль.ГрафикАттестацииИКомиссияУтверждаютсяОднимДокументом() Тогда
		ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = 0;
	Иначе 
		ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = 1	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиМедицинскогоСтрахованияСотрудников()
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.МедицинскоеСтрахование") Тогда
		Возврат;
	КонецЕсли;
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("МедицинскоеСтрахование");
	
	ИспользоватьМедицинскоеСтрахованиеСотрудников = Модуль.ИспользуетсяМедицинскоеСтрахованиеСотрудников();
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНастройкиНаСервере(ИмяНастройки)
	
	// ERP начало: 00-00052344
	Если СтрНайти(ИмяНастройки, "КадровыйУчетИРасчетЗарплаты") > 0 Тогда
		ПараметрыНастроек = Новый Структура;
		ПараметрыНастроек.Вставить("КадровыйУчетИРасчетЗарплаты", ИспользоватьКадровыйУчетИРасчетЗарплаты);
	Иначе
		
		ПараметрыНастроек = Обработки.ПанельНастроекЗарплатаКадры.ЗаполнитьСтруктуруПараметровНастроек(ИмяНастройки);
		ПараметрыНастроек.НастройкиКадровогоУчета = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(НастройкиКадровогоУчета, Метаданные.РегистрыСведений.НастройкиКадровогоУчета);
		ПараметрыНастроек.НастройкиВоинскогоУчета = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(НастройкиВоинскогоУчета, Метаданные.РегистрыСведений.НастройкиВоинскогоУчета);
		ПараметрыНастроек.НастройкиШтатногоРасписания = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(НастройкиШтатногоРасписания, Метаданные.РегистрыСведений.НастройкиШтатногоРасписания);
		ПараметрыНастроек.ИспользоватьКадровыйУчет = ИспользоватьКадровыйУчет;
		ПараметрыНастроек.ИспользоватьНачислениеЗарплаты = ИспользоватьНачислениеЗарплаты;
		ПараметрыНастроек.ИспользоватьАттестацииСотрудников = ИспользоватьАттестацииСотрудников;
		ПараметрыНастроек.ИспользоватьМедицинскоеСтрахованиеСотрудников = ИспользоватьМедицинскоеСтрахованиеСотрудников;
		ПараметрыНастроек.ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии = ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии > 0;
		ПараметрыНастроек.ИспользоватьСпециальностиФизическихЛиц = ИспользоватьСпециальностиФизическихЛиц;
		ПараметрыНастроек.ИспользоватьПодработки = ИспользоватьПодработки;
		ПараметрыНастроек.УчитыватьПрерываниеСтажейАвтоматически = УчитыватьПрерываниеСтажейАвтоматически;
		
		Если ИспользоватьПодробныеФормыСотрудников() Тогда
			ПараметрыНастроек.ИспользоватьУниверсальнуюФормуСпискаСотрудников = ИспользоватьУниверсальнуюФормуСпискаСотрудников;
		КонецЕсли;
		
	КонецЕсли;
	// ERP конец

	НаименованиеЗадания = НСтр("ru = 'Сохранение настроек кадрового учета';
								|en = 'Save HR recordkeeping settings '");
	Если ИмяНастройки = "НастройкиВоинскогоУчета" Тогда
		НаименованиеЗадания = НСтр("ru = 'Сохранение настроек воинского учета';
									|en = 'Save military registration settings'");
	КонецЕсли;
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.ПанельНастроекЗарплатаКадры.ЗаписатьНастройки",
		ПараметрыНастроек,
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьНастройкиНаКлиенте(ИмяНастройки)
	
	Результат = ЗаписатьНастройкиНаСервере(ИмяНастройки);
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ОбновитьПравилоФормированияПредставленияСправочникаСотрудникиНаКлиенте();
		
		// ERP начало: 00-00052344
		ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
		// ERP конец
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстПояснениеИспользоватьПереносОстатковОтпуска(Форма)
	Текст = Нстр("ru = 'На предприятии разрешается переносить остатки отпусков при переводе сотрудников между организациями';
				|en = 'It is allowed to transfer remaining leaves when employees are transferred between the companies.'");
	Форма.ПояснениеИспользоватьПереносОстатковОтпускаПриУвольненииПереводом = Текст;	
КонецПроцедуры

#Область ОбновлениеИнтерфейса

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияОбновленияИнтерфейса()
	
	ТребуетсяОбновлениеИнтерфейса = Истина;
	
	#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОбновленияИнтерфейса", 1, Истина);
	#КонецЕсли 
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбработчикОжиданияОбновленияИнтерфейса()
	
	ЗарплатаКадрыРасширенныйВызовСервера.ПередОбновлениемИнтерфейса();
	
	ОбновитьИнтерфейс();
		
	ЭтаФорма.ТребуетсяОбновлениеИнтерфейса = Ложь;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма)
	
	ДоступностьНастроек = Форма.ИспользоватьКадровыйУчетИРасчетЗарплаты;
	
	Форма.Элементы.НастройкаШтатногоРасписания.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаНеполнаяСтавка.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаПереносОстатковОтпуска.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаВоинскийУчет.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаАттестацииСотрудников.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаМедицинскоеСтрахованиеСотрудников.Доступность = ДоступностьНастроек;
	УстановитьДоступностьЭлементовФормыНастройкиВоинскогоУчета(Форма.Элементы, Форма.НастройкиВоинскогоУчета);
	УстановитьДоступностьЭлементовФормыАттестацииСотрудников(Форма);
	
	// ERP начало
	Форма.Элементы.ГруппаКонтролироватьУникальностьТабельныхНомеров.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаИспользоватьПодработки.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаПечататьТ6ДляОтпусковПоБеременностиИРодам.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаИспользоватьСпециальностиФизическихЛиц.Доступность = ДоступностьНастроек;
	Форма.Элементы.ГруппаНастройкиКадровогоУчетаПравилоФормированияПредставленияЭлементовСправочникаСотрудники.Доступность = ДоступностьНастроек;
	// Конец
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы(Форма)
	
	УстановитьВидимостьЭлементовФормыАттестацииСотрудников(Форма);
	УстановитьВидимостьЭлементовФормыМедицинскогоСтрахованияСотрудников(Форма);
	УстановитьВидимостьЭлементовФормыУчитыватьПрерываниеСтажейАвтоматически(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормыНастройкиВоинскогоУчета(Элементы, НастройкиВоинскогоУчета)

	Элементы.ГруппаНастройкиВоинскогоУчета.Доступность = НастройкиВоинскогоУчета.ИспользоватьВоинскийУчет;
	Элементы.ГруппаВоинскийУчетСоставы.Доступность     = НастройкиВоинскогоУчета.ИспользоватьБронированиеГраждан;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормыАттестацииСотрудников(Форма)
	
	Если НЕ ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Возврат;	
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ИспользоватьОтдельныйДокументДляФормированияАттестационнойКомиссии", "Доступность", Форма.ИспользоватьАттестацииСотрудников);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьУчитыватьПрерываниеСтажейАвтоматически()
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АвтоматическийРасчетСтажейФизическихЛиц") Тогда
		Возврат;
	КонецЕсли;
	
	МодульАвтоматическийРасчетСтажейФизическихЛиц = ОбщегоНазначения.ОбщийМодуль("АвтоматическийРасчетСтажейФизическихЛиц");
	УчитыватьПрерываниеСтажейАвтоматически = МодульАвтоматическийРасчетСтажейФизическихЛиц.УчитыватьПрерываниеСтажейАвтоматически();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьЭлементовФормыУчитыватьПрерываниеСтажейАвтоматически(Форма)
	
	Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АвтоматическийРасчетСтажейФизическихЛиц") Тогда
		ВидимостьНастроек = Истина;
	Иначе
		ВидимостьНастроек = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаУчитыватьПрерываниеСтажейАвтоматически",
		"Видимость",
		ВидимостьНастроек);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормыАттестацииСотрудников(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ГруппаАттестацииСотрудников", "Видимость", ДоступныАттестацииСотрудников());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормыМедицинскогоСтрахованияСотрудников(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ГруппаМедицинскоеСтрахованиеСотрудников", "Видимость", ДоступноМедицинскоеСтрахованиеСотрудников());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ОбновитьПовторноИспользуемыеЗначения();
				ОбновитьПравилоФормированияПредставленияСправочникаСотрудникиНаКлиенте();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				// ERP начало: 00-00052344
				ПодключитьОбработчикОжиданияОбновленияИнтерфейса();
				// конец
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбновитьПравилоФормированияПредставленияСправочникаСотрудникиНаКлиенте()
	
	Если ОбновитьПравилоФормированияПредставленияЭлементовСправочникаСотрудники Тогда
			
		ОбновитьПравилоФормированияПредставленияСправочникаСотрудники();
		ОбновитьПравилоФормированияПредставленияЭлементовСправочникаСотрудники = Ложь;
			
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьПравилоФормированияПредставленияСправочникаСотрудники()
	
	КадровыйУчетРасширенный.УстановитьПараметрСеансаПравилоФормированияПредставленияЭлементовСправочникаСотрудники();
		
КонецПроцедуры

&НаСервере
Функция ДоступныАттестацииСотрудников()
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников")
		И (ПолучитьФункциональнуюОпцию("ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы") 
		ИЛИ ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении"));
	
КонецФункции

&НаСервере
Функция ДоступноМедицинскоеСтрахованиеСотрудников()
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.МедицинскоеСтрахование")
		И ПолучитьФункциональнуюОпцию("ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы");
	
КонецФункции

&НаСервере
Функция ИспользоватьПодробныеФормыСотрудников()
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы")
		И ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КадровыйУчет.СпискиСотрудников");
	
КонецФункции

#КонецОбласти
