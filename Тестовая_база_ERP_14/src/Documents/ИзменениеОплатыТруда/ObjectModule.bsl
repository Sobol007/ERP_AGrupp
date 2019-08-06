#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.СотрудникиДаты, Ссылка);
	
	РазрядыКатегорииДолжностей.СформироватьДвиженияРазрядовКатегорийСотрудников(Движения, ДанныеДляПроведения.РазрядыКатегорииСотрудников);
	РазрядыКатегорииДолжностей.СформироватьДвиженияПКУСотрудников(Движения, ДанныеДляПроведения.ПКУСотрудников);
	
	УчетСреднегоЗаработка.ЗарегистрироватьДанныеКоэффициентовИндексации(Движения, ДанныеДляПроведения.КоэффициентыИндексации);
	
	Если ИзменитьНачисления Тогда
		
		СтруктураПлановыхНачислений = Новый Структура;
		СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
		СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
		СтруктураПлановыхНачислений.Вставить("ПрименениеДополнительныхПоказателей", ДанныеДляПроведения.ПрименениеДополнительныхПоказателей);
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
		РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок(Движения, ДанныеДляПроведения.ПорядокПересчетаТарифнойСтавки);
		
	КонецЕсли;
	
	Если ИзменитьАванс Тогда
		РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат(Движения, ДанныеДляПроведения.ПлановыеАвансы)
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		Модуль.СформироватьДвиженияГрейдовСотрудников(Движения, ДанныеДляПроведения.ДанныеГрейдовСотрудников);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаИзменения, "Объект.ДатаИзменения", Отказ, НСтр("ru = 'Дата изменения';
																										|en = 'Change date'"), , , Ложь);
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
	
	КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(ЭтотОбъект, ДатаИзменения, "Начисления", "Показатели", Отказ, Истина);
	
	Если ИзменитьНачисления Тогда 
		РасчетЗарплатыРасширенный.ПроверитьМножественностьОплатыВремениРаботникВШапке(ДатаИзменения, Сотрудник, Начисления, Ссылка, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Необходимо получить данные для формирования движений
//		кадровой истории - см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения
//		плановых начислений - см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений
//		плановых выплат (авансы) - см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
// 
Функция ПолучитьДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура; 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если ИзменитьНачисления Тогда
			
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ИзменениеОплатыТрудаНачисления.Ссылка,
			|	ИзменениеОплатыТрудаНачисления.ИдентификаторСтрокиВидаРасчета
			|ПОМЕСТИТЬ ВТИспользуемыеНачисления
			|ИЗ
			|	Документ.ИзменениеОплатыТруда.Начисления КАК ИзменениеОплатыТрудаНачисления
			|ГДЕ
			|	ИзменениеОплатыТрудаНачисления.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ИзменениеОплатыТрудаПоказатели.Ссылка,
			|	ИзменениеОплатыТрудаПоказатели.Показатель
			|ПОМЕСТИТЬ ВТПоказателиНачислений
			|ИЗ
			|	ВТИспользуемыеНачисления КАК ИспользуемыеНачисления
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеОплатыТруда.Показатели КАК ИзменениеОплатыТрудаПоказатели
			|		ПО ИспользуемыеНачисления.Ссылка = ИзменениеОплатыТрудаПоказатели.Ссылка
			|			И ИспользуемыеНачисления.ИдентификаторСтрокиВидаРасчета = ИзменениеОплатыТрудаПоказатели.ИдентификаторСтрокиВидаРасчета";
		
		Запрос.Выполнить();
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
			|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
			|	ИзменениеОплатыТрудаНачисления.Начисление КАК Начисление,
			|	ИзменениеОплатыТрудаНачисления.ДокументОснование КАК ДокументОснование,
			|	ВЫБОР
			|		КОГДА ИзменениеОплатыТрудаНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК Используется,
			|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИзменениеОплатыТруда.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	ИзменениеОплатыТрудаНачисления.Размер КАК Размер,
			|	ИзменениеОплатыТрудаНачисления.ХарактерНачисления КАК ХарактерНачисления
			|ИЗ
			|	Документ.ИзменениеОплатыТруда.Начисления КАК ИзменениеОплатыТрудаНачисления
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
			|		ПО ИзменениеОплатыТрудаНачисления.Ссылка = ИзменениеОплатыТруда.Ссылка
			|ГДЕ
			|	ИзменениеОплатыТруда.Ссылка = &Ссылка
			|	И ВЫБОР
			|			КОГДА ИзменениеОплатыТрудаНачисления.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.ПустаяСсылка)
			|				ТОГДА ИСТИНА
			|			КОГДА НЕ ИзменениеОплатыТрудаНачисления.Начисление.ФОТНеРедактируется
			|				ТОГДА ИСТИНА
			|			КОГДА НЕ ИзменениеОплатыТрудаНачисления.Начисление.Рассчитывается
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ЛОЖЬ
			|		КОНЕЦ";
		
		// Таблица для формирования плановых начислений.
		// См. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
		ПлановыеНачисления = Запрос.Выполнить().Выгрузить();
		ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
			|	ИзменениеОплатыТруда.Организация КАК Организация,
			|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
			|	ИзменениеОплатыТрудаПоказатели.Показатель КАК Показатель,
			|	ИзменениеОплатыТрудаНачисления.ДокументОснование КАК ДокументОснование,
			|	ИзменениеОплатыТрудаПоказатели.Значение КАК Значение,
			|	ИзменениеОплатыТрудаНачисления.ХарактерНачисления КАК ХарактерНачисления,
			|	ИзменениеОплатыТрудаНачисления.Действие КАК Действие
			|ПОМЕСТИТЬ ВТПоказатели
			|ИЗ
			|	Документ.ИзменениеОплатыТруда.Показатели КАК ИзменениеОплатыТрудаПоказатели
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеОплатыТруда.Начисления КАК ИзменениеОплатыТрудаНачисления
			|		ПО ИзменениеОплатыТрудаПоказатели.Ссылка = ИзменениеОплатыТрудаНачисления.Ссылка
			|			И ИзменениеОплатыТрудаПоказатели.ИдентификаторСтрокиВидаРасчета = ИзменениеОплатыТрудаНачисления.ИдентификаторСтрокиВидаРасчета
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
			|		ПО ИзменениеОплатыТрудаПоказатели.Ссылка = ИзменениеОплатыТруда.Ссылка
			|ГДЕ
			|	ИзменениеОплатыТруда.Ссылка = &Ссылка
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	ИзменениеОплатыТрудаПоказатели.Ссылка.ДатаИзменения,
			|	ИзменениеОплатыТрудаПоказатели.Ссылка.Организация,
			|	ИзменениеОплатыТрудаПоказатели.Ссылка.ФизическоеЛицо,
			|	ИзменениеОплатыТрудаПоказатели.Ссылка.Сотрудник,
			|	ИзменениеОплатыТрудаПоказатели.Показатель,
			|	НЕОПРЕДЕЛЕНО,
			|	ИзменениеОплатыТрудаПоказатели.Значение,
			|	NULL,
			|	ИзменениеОплатыТрудаПоказатели.Действие
			|ИЗ
			|	Документ.ИзменениеОплатыТруда.Показатели КАК ИзменениеОплатыТрудаПоказатели
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачислений КАК ПоказателиНачислений
			|		ПО ИзменениеОплатыТрудаПоказатели.Ссылка = ПоказателиНачислений.Ссылка
			|			И ИзменениеОплатыТрудаПоказатели.Показатель = ПоказателиНачислений.Показатель
			|ГДЕ
			|	ИзменениеОплатыТрудаПоказатели.Ссылка = &Ссылка
			|	И ИзменениеОплатыТрудаПоказатели.ИдентификаторСтрокиВидаРасчета = 0
			|	И ИзменениеОплатыТрудаПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
			|	И ПоказателиНачислений.Показатель ЕСТЬ NULL
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Показатели.ДатаСобытия КАК ДатаСобытия,
			|	Показатели.Организация КАК Организация,
			|	Показатели.ФизическоеЛицо КАК ФизическоеЛицо,
			|	Показатели.Сотрудник КАК Сотрудник,
			|	Показатели.Показатель КАК Показатель,
			|	Показатели.ДокументОснование КАК ДокументОснование,
			|	МАКСИМУМ(Показатели.Значение) КАК Значение,
			|	Показатели.ХарактерНачисления КАК ХарактерНачисления
			|ИЗ
			|	ВТПоказатели КАК Показатели
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказатели КАК ПоказателиДействующие
			|		ПО Показатели.Показатель = ПоказателиДействующие.Показатель
			|			И Показатели.ДокументОснование = ПоказателиДействующие.ДокументОснование
			|			И (Показатели.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить))
			|			И (ПоказателиДействующие.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить))
			|ГДЕ
			|	ПоказателиДействующие.Показатель ЕСТЬ NULL
			|
			|СГРУППИРОВАТЬ ПО
			|	Показатели.ДатаСобытия,
			|	Показатели.Организация,
			|	Показатели.ФизическоеЛицо,
			|	Показатели.Сотрудник,
			|	Показатели.Показатель,
			|	Показатели.ДокументОснование,
			|	Показатели.ХарактерНачисления";
		
		// Таблица значений показателей расчета зарплаты.
		// См. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
		ЗначенияПоказателей = Запрос.Выполнить().Выгрузить();
		ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ИзменениеОплатыТрудаПоказатели.Ссылка.ДатаИзменения КАК ДатаСобытия,
			|	ИзменениеОплатыТрудаПоказатели.Ссылка.Организация КАК Организация,
			|	ИзменениеОплатыТрудаПоказатели.Ссылка.Сотрудник КАК Сотрудник,
			|	ИзменениеОплатыТрудаПоказатели.Ссылка.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИзменениеОплатыТрудаПоказатели.Показатель КАК Показатель,
			|	ВЫБОР
			|		КОГДА ИзменениеОплатыТрудаПоказатели.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК Применение
			|ИЗ
			|	Документ.ИзменениеОплатыТруда.Показатели КАК ИзменениеОплатыТрудаПоказатели
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачислений КАК ПоказателиНачислений
			|		ПО ИзменениеОплатыТрудаПоказатели.Ссылка = ПоказателиНачислений.Ссылка
			|			И ИзменениеОплатыТрудаПоказатели.Показатель = ПоказателиНачислений.Показатель
			|ГДЕ
			|	ИзменениеОплатыТрудаПоказатели.Ссылка = &Ссылка
			|	И ИзменениеОплатыТрудаПоказатели.ИдентификаторСтрокиВидаРасчета = 0
			|	И ИзменениеОплатыТрудаПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
			|	И ПоказателиНачислений.Показатель ЕСТЬ NULL ";
		
		// Таблица применения дополнительных показателей.
		// См. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
		ПрименениеДополнительныхПоказателей = Запрос.Выполнить().Выгрузить();
		ДанныеДляПроведения.Вставить("ПрименениеДополнительныхПоказателей", ПрименениеДополнительныхПоказателей);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
			|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
			|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИзменениеОплатыТруда.ПорядокРасчетаСтоимостиЕдиницыВремени КАК ПорядокРасчета,
			|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
			|ИЗ
			|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
			|ГДЕ
			|	ИзменениеОплатыТруда.Ссылка = &Ссылка";
		
		// Таблица значений порядка пересчета тарифной ставки.
		// См. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок.
		ПорядокПересчетаТарифнойСтавки = Запрос.Выполнить().Выгрузить();
		ДанныеДляПроведения.Вставить("ПорядокПересчетаТарифнойСтавки", ПорядокПересчетаТарифнойСтавки);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
			|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
			|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИзменениеОплатыТруда.СовокупнаяТарифнаяСтавка КАК Значение,
			|	ВЫБОР
			|		КОГДА ИзменениеОплатыТруда.СовокупнаяТарифнаяСтавка = 0
			|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
			|		ИНАЧЕ ИзменениеОплатыТруда.ВидТарифнойСтавки
			|	КОНЕЦ КАК ВидТарифнойСтавки,
			|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
			|ИЗ
			|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
			|ГДЕ
			|	ИзменениеОплатыТруда.Ссылка = &Ссылка";
		
		// Таблица значений совокупной тарифной ставки.
		// См. описание РасчетЗарплатыРасширенный.СформироватьДвиженияЗначенийСовокупныхТарифныхСтавок.
		ДанныеСовокупныхТарифныхСтавок = Запрос.Выполнить().Выгрузить();
		ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", ДанныеСовокупныхТарифныхСтавок);
		
	КонецЕсли;
	
	Если ИзменитьАванс Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
			|	ИзменениеОплатыТруда.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыКадровыхСобытий.Перемещение) КАК ВидСобытия,
			|	ИзменениеОплатыТруда.СпособРасчетаАванса КАК СпособРасчетаАванса,
			|	ИзменениеОплатыТруда.Аванс КАК Аванс,
			|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
			|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
			|ИЗ
			|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
			|ГДЕ
			|	ИзменениеОплатыТруда.Ссылка = &Ссылка";
		
		// Таблица значений формирования движений по авансам.
		// См. описание РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
		ПлановыеАвансы = Запрос.Выполнить().Выгрузить();
		ДанныеДляПроведения.Вставить("ПлановыеАвансы", ПлановыеАвансы);
		
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.РазрядКатегория КАК РазрядКатегория,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка";
	
	// Таблица значений разряда сотрудника.
	// См. описание РазрядыКатегорииДолжностей.СформироватьДвиженияРазрядовКатегорийСотрудников.
	РазрядыКатегорииСотрудников = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("РазрядыКатегорииСотрудников", РазрядыКатегорииСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка";
	
	// Таблица для формирования времени регистрации документа.
	// См. описание ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента.
	СотрудникиДаты = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.ПКУ КАК ПКУ,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка";
	
	// Таблица значений ПКУ сотрудника.
	// См. описание РазрядыКатегорииДолжностей.СформироватьДвиженияПКУСотрудников.
	ПКУСотрудников = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ПКУСотрудников", ПКУСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК Период,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.КоэффициентИндексации КАК Коэффициент
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|	И ИзменениеОплатыТруда.УчитыватьКакИндексациюЗаработка";
	
	КоэффициентыИндексации = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("КоэффициентыИндексации", КоэффициентыИндексации);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		ДанныеГрейдовСотрудников = Модуль.ДанныеДляПроведенияГрейдыСотрудников(Ссылка, "ДатаИзменения");
		ДанныеДляПроведения.Вставить("ДанныеГрейдовСотрудников", ДанныеГрейдовСотрудников);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#КонецЕсли