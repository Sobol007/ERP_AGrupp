#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	МогутБытьНазначенияБезЗаказа = Документы.КорректировкаНазначенияТоваров.ДопустимыНазначенияБезЗаказа();
	
	ИспользоватьУчетЗатратПоНаправлениямДеятельности = ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности");
	
	ТолькоЗаказыОрганизации = ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.ТолькоЗаказыОрганизации.Видимость = ТолькоЗаказыОрганизации;
	Элементы.ТолькоЗаказыОрганизации.Заголовок = СтрЗаменить(НСтр("ru = 'Только заказы организации ""%1""';
																	|en = 'Only orders of company ""%1""'"), "%1", Организация);
	
	Элементы.НаправлениеДеятельности.Видимость = ИспользоватьУчетЗатратПоНаправлениямДеятельности;
	Если МогутБытьНазначенияБезЗаказа Тогда
		Заголовок = НСтр("ru = 'Выбор назначения';
						|en = 'Select assignment'");
	Иначе
		Заголовок = НСтр("ru = 'Выбор заказа';
						|en = 'Select order'");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация,,, ТолькоЗаказыОрганизации);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НеИспользуется", НСтр("ru = '<не используется>';
																										|en = '<not used>'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПустойЗаказ",       НСтр("ru = '<по направлению в целом>';
																										|en = '<by direction in general>'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПустоеНаправление", НСтр("ru = '<без указания направления>';
																										|en = '<without direction indication>'"));
	
	ДопУсловиеПоТипу = "НазначенияПереопределяемый.ТипНазначения = ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.Собственное)
				|	И НазначенияПереопределяемый.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)";
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоНаСтороне") Тогда
		ДопУсловиеПоТипу = "НазначенияПереопределяемый.ТипНазначения = ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.Собственное)";
	КонецЕсли;
	//-- НЕ УТ
	//++ НЕ УТКА
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоИзДавальческогоСырья") Тогда
		ДопУсловиеПоТипу = ДопУсловиеПоТипу + " ИЛИ НазначенияПереопределяемый.ТипНазначения В 
			|(ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.Давальческое21),
			| ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.ДавальческоеПродукция22),
			| ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.ДавальческоеМатериалы22),
			| ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.ДавальческоеМатериалыПодЭтап22))";
	КонецЕсли;
	//-- НЕ УТКА
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, Список);
	СвойстваСписка.ТекстЗапроса = СтрЗаменить(СвойстваСписка.ТекстЗапроса, "&ДопУсловиеПоТипу", ДопУсловиеПоТипу);
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	УстановитьВидимостьКолонокДинамическогоСпискаПоФункциональнымОпциям();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТолькоЗаказыОрганизацииПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация,,, ТолькоЗаказыОрганизации);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Цвет недоступного текста незаполненных ячеек.
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Партнер");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Договор");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БезПартнера");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Заказ");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Организация");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БезЗаказа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НаправлениеДеятельности");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БезНаправленияДеятельности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКолонокДинамическогоСпискаПоФункциональнымОпциям()
	
	Если Не ПолучитьФункциональнуюОпцию("УправлениеПредприятием")
		Или (Не ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоНаСтороне")
				//++ НЕ УТКА
				И Не ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоИзДавальческогоСырья")
				//-- НЕ УТКА
				) Тогда
		
		Элементы.Партнер.Видимость = Ложь;
		Элементы.Договор.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
