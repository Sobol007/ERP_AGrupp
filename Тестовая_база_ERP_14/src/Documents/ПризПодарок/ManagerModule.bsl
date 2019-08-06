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


// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.ПризПодарок - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.ПризПодарок - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа.
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ); 
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(ДокументСсылка, Движения, РежимПроведения, Отказ, РеквизитыДляПроведения, СтруктураВидовУчета, Объект);
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		ДатаОперацииПоНалогам = УчетНДФЛРасширенный.ДатаОперацииПоДокументу(РеквизитыДляПроведения.Дата, НачалоМесяца(РеквизитыДляПроведения.ПериодРегистрации));
		УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперацииПоНалогам, ДанныеДляПроведения.ДанныеДляНДФЛ, Ложь, Ложь, ДокументСсылка);
		УчетНДФЛ.СформироватьИсчисленныйНалогПоТаблицеЗначений(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперацииПоНалогам, ДанныеДляПроведения.ДанныеДляРасчетовСБюджетомПоНДФЛ, , , , Ложь, РеквизитыДляПроведения.ДатаПолученияДохода);
		УчетНДФЛ.СформироватьДокументыУчтенныеПриРасчетеДляМежрасчетногоДокументаПоВременнойТаблице(Движения, Отказ, РеквизитыДляПроведения.Организация, ДанныеДляПроведения.МенеджерВременныхТаблиц, РеквизитыДляПроведения.Ссылка); 	
		
		// Заполним описание данных для проведения в учете начисленной зарплаты.
		ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
		ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
		ДанныеДляПроведенияУчетЗарплаты.Организация 			= РеквизитыДляПроведения.Организация;
		ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= РеквизитыДляПроведения.ПериодРегистрации;
		ДанныеДляПроведенияУчетЗарплаты.ПорядокВыплаты 			= Перечисления.ХарактерВыплатыЗарплаты.Межрасчет;
		ДанныеДляПроведенияУчетЗарплаты.МенеджерВременныхТаблиц = ДанныеДляПроведения.МенеджерВременныхТаблиц;
		
		// - Регистрация начислений в учете начислений и удержаний.
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисления(ДанныеДляПроведенияУчетЗарплаты, Отказ, Неопределено, ДанныеДляПроведения.Начисления);
			
		// Подготовка данных для регистрации удержаний, НДФЛ и Корректировок выплаты в учете начисленной зарплаты.
		УчетНачисленнойЗарплатыРасширенный.СоздатьВТРаспределениеНачисленийТекущегоДокумента(ДанныеДляПроведенияУчетЗарплаты);
			
		// Учет исчисленного налога в "зарплате".
		УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.НДФЛ, РеквизитыДляПроведения.Организация,ДатаОперацииПоНалогам);
		УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНДФЛИКорректировкиВыплаты(ДанныеДляПроведенияУчетЗарплаты, Отказ,
			ДанныеДляПроведения.НДФЛ, Неопределено);
		
		// - Регистрация начислений и удержаний.
		ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьНачисленияУдержания(ДанныеДляПроведенияУчетЗарплаты, Отказ,
					ДанныеДляПроведения.Начисления, Неопределено, ДанныеДляПроведения.НДФЛ);
					
		УчетСтраховыхВзносов.СформироватьДоходыСтраховыеВзносы(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.ДанныеДляВзносов, Истина);
		
		РасчетЗарплатыРасширенный.СформироватьДополнениеРасчетнойБазыУдержаний(Движения, ДанныеДляПроведения.ДополнениеРасчетнойБазыУдержаний);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда

		// Средний заработок ФСС.
		УчетПособийСоциальногоСтрахованияРасширенный.ЗарегистрироватьДанныеСреднегоЗаработкаФССРазовыхВыплат(Движения, Отказ, ДанныеДляПроведения.МенеджерВременныхТаблиц, "ВТНачисленияДокумента");
		
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, СтруктураВидовУчета);
	
КонецПроцедуры

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОтменаДокумента Тогда
		
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			УчетПособийСоциальногоСтрахованияРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		КонецЕсли;
		
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
			
			УчетСтраховыхВзносовРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
			УчетНДФЛРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
			ОтражениеЗарплатыВБухучетеРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			УчетНачисленнойЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			
			ИсправлениеДокументовЗарплатаКадры.СторнироватьДвиженияБезСпецификиУчетов(
				Движения, ИсправленныйДокумент, ДополнительныеПараметры);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

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

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаТ11";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т11а";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о поощрении сотрудников (Т-11а)';
										|en = 'Employee recognition order (T-11a)'");
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаТ11";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т11";
	КомандаПечати.СписокФорм = "ФормаДокумента";
	КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВсехПриказов", Истина);
	КомандаПечати.Представление = НСтр("ru = 'Приказы на каждого сотрудника в отдельности (Т-11)';
										|en = 'Orders for each employee individually (T-11)'");
	
КонецПроцедуры

Функция ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект) Экспорт

	ДанныеДляБухучета = Новый Структура;
	ДанныеДляБухучета.Вставить("ДокументОснование", Объект.Ссылка);
	
	СтатьяРасходов = Объект.СтатьяРасходов;
	Если ПолучитьФункциональнуюОпцию("РаботаВХозрасчетнойОрганизации") Тогда
		СтатьяРасходов = ОтражениеЗарплатыВБухучетеРасширенный.СтатьяОплатаТруда();
	КонецЕсли;
	
	ТаблицаБухучетЗарплаты = ОтражениеЗарплатыВБухучетеРасширенный.НоваяТаблицаБухучетЗарплатыПервичныхДокументов();
	НоваяСтрока = ТаблицаБухучетЗарплаты.Добавить();
	НоваяСтрока.ДокументОснование = Объект.Ссылка;
	НоваяСтрока.НачислениеУдержание = Перечисления.ВидыОсобыхНачисленийИУдержаний.СтоимостьПодарковПризов;
	НоваяСтрока.СпособОтраженияЗарплатыВБухучете = Объект.СпособОтраженияЗарплатыВБухучете;
	НоваяСтрока.ОтношениеКЕНВД = Объект.ОтношениеКЕНВД;
	НоваяСтрока.СтатьяФинансирования = Объект.СтатьяФинансирования;
	НоваяСтрока.СтатьяРасходов = СтатьяРасходов;
	
	ДанныеДляБухучета.Вставить("ТаблицаБухучетЗарплаты", ТаблицаБухучетЗарплаты);
	
	Возврат ДанныеДляБухучета;
	
КонецФункции

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ПризПодарок;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета) 

	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
		
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", РеквизитыДляПроведения.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьШтатноеРасписание", ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПризПодарок.Ссылка КАК Ссылка,
	|	ПризПодарок.Ссылка.Дата КАК Дата,
	|	ПризПодарок.Ссылка.ДатаПолученияДохода КАК ДатаДействия,
	|	НАЧАЛОПЕРИОДА(ПризПодарок.Ссылка.ДатаПолученияДохода, МЕСЯЦ) КАК ПериодДействия,
	|	ПризПодарок.Ссылка.Организация КАК Организация,
	|	ПризПодарок.Сотрудник КАК Сотрудник,
	|	ПризПодарок.Подразделение КАК Подразделение,
	|	ПризПодарок.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПризПодарок.Ссылка.ДатаПолученияДохода КАК ПланируемаяДатаВыплаты,
	|	НАЧАЛОПЕРИОДА(ПризПодарок.Ссылка.ДатаПолученияДохода, МЕСЯЦ) КАК МесяцНалоговогоПериода,
	|	НАЧАЛОПЕРИОДА(ПризПодарок.Ссылка.ДатаПолученияДохода, МЕСЯЦ) КАК ПериодРегистрации,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.СтоимостьПодарковПризов) КАК Начисление,
	|	ПризПодарок.Результат КАК Сумма,
	|	ПризПодарок.Ссылка.КодДоходаНДФЛ КАК КодДохода,
	|	ПризПодарок.Ссылка.КодДоходаНДФЛ.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	|	ПризПодарок.Ссылка.ВидДоходаСтраховыеВзносы КАК ВидДохода,
	|	ПризПодарок.КодВычета КАК КодВычета,
	|	ПризПодарок.СуммаНДФЛ КАК НДФЛ,
	|	ПризПодарок.СуммаВычета КАК СуммаВычета,
	|	ПризПодарок.Ссылка.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ПризПодарок.Ссылка.СтатьяРасходов КАК СтатьяРасходов,
	|	ПризПодарок.Ссылка.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ПризПодарок.Ссылка.ОтношениеКЕНВД КАК ОтношениеКЕНВД,
	|	ПризПодарок.Ссылка.ПериодРегистрации КАК ПериодРегистрацииДокумента,
	|	ПризПодарок.Ссылка.ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов КАК ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов,
	|	ПризПодарок.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВТДанныеДокументаПредварительно
	|ИЗ
	|	Документ.ПризПодарок.Начисления КАК ПризПодарок
	|ГДЕ
	|	ПризПодарок.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПризПодарок.Ссылка,
	|	ПризПодарок.Ссылка.Дата,
	|	ПризПодарок.Ссылка.ДатаПолученияДохода,
	|	НАЧАЛОПЕРИОДА(ПризПодарок.Ссылка.ДатаПолученияДохода, МЕСЯЦ),
	|	ПризПодарок.Ссылка.Организация,
	|	ПризПодарок.Сотрудник,
	|	ПризПодарок.Подразделение,
	|	ПризПодарок.Сотрудник.ФизическоеЛицо,
	|	ПризПодарок.Ссылка.ДатаПолученияДохода,
	|	НАЧАЛОПЕРИОДА(ПризПодарок.Ссылка.ДатаПолученияДохода, МЕСЯЦ),
	|	НАЧАЛОПЕРИОДА(ПризПодарок.Ссылка.ДатаПолученияДохода, МЕСЯЦ),
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.СтоимостьПодарковПризов),
	|	ВЫБОР
	|		КОГДА ПризПодарок.Сторно
	|			ТОГДА -ПризПодарок.Результат
	|		ИНАЧЕ ПризПодарок.Результат
	|	КОНЕЦ,
	|	ПризПодарок.Ссылка.КодДоходаНДФЛ,
	|	ПризПодарок.Ссылка.КодДоходаНДФЛ.СтавкаНалогообложенияРезидента,
	|	ПризПодарок.Ссылка.ВидДоходаСтраховыеВзносы,
	|	ПризПодарок.КодВычета,
	|	ВЫБОР
	|		КОГДА ПризПодарок.Сторно
	|			ТОГДА -ПризПодарок.СуммаНДФЛ
	|		ИНАЧЕ ПризПодарок.СуммаНДФЛ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ПризПодарок.Сторно
	|			ТОГДА -ПризПодарок.СуммаВычета
	|		ИНАЧЕ ПризПодарок.СуммаВычета
	|	КОНЕЦ,
	|	ПризПодарок.Ссылка.СтатьяФинансирования,
	|	ПризПодарок.Ссылка.СтатьяРасходов,
	|	ПризПодарок.Ссылка.СпособОтраженияЗарплатыВБухучете,
	|	ПризПодарок.Ссылка.ОтношениеКЕНВД,
	|	ПризПодарок.Ссылка.ПериодРегистрации,
	|	ПризПодарок.Ссылка.ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов,
	|	ПризПодарок.НомерСтроки
	|ИЗ
	|	Документ.ПризПодарок.НачисленияПерерасчет КАК ПризПодарок
	|ГДЕ
	|	ПризПодарок.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	ВТДанныеДокументаПредварительно КАК ДанныеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеДокумента.КодДохода КАК КодДохода,
	|	ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы) КАК КатегорияДохода,
	|	ДанныеДокумента.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	|	ДанныеДокумента.ПланируемаяДатаВыплаты КАК Период
	|ПОМЕСТИТЬ ВТДоходыФизическихЛиц
	|ИЗ
	|	ВТДанныеДокументаПредварительно КАК ДанныеДокумента";
	
	Запрос.Выполнить();
	
	// Территория Сотрудников
	Запрос.УстановитьПараметр("ИспользоватьРаспределениеПоТерриториямУсловиямТруда", ЗарплатаКадрыРасширенный.ИспользоватьРаспределениеПоТерриториямУсловиямТруда(РеквизитыДляПроведения.Организация));
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТДанныеДокументаПредварительно", "Сотрудник,ДатаДействия");
	ОписательВременныхТаблиц.ИмяВТКадровыеДанныеСотрудников = "ВТТерриторииСотрудников";
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Ложь, "Территория");
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.ДатаДействия КАК ДатаДействия,
	|	ДанныеДокумента.ПериодДействия КАК ПериодДействия,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Сотрудник КАК Сотрудник,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ВЫБОР
	|		КОГДА &ИспользоватьРаспределениеПоТерриториямУсловиямТруда = ИСТИНА
	|			ТОГДА ЕСТЬNULL(ТерриторииСотрудников.Территория, ДанныеДокумента.Подразделение)
	|		ИНАЧЕ ДанныеДокумента.Подразделение
	|	КОНЕЦ КАК ТерриторияВыполненияРаботВОрганизации,
	|	ДанныеДокумента.Подразделение КАК ПодразделениеСотрудника,
	|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеДокумента.ПланируемаяДатаВыплаты КАК ПланируемаяДатаВыплаты,
	|	ДанныеДокумента.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	ДанныеДокумента.ПериодРегистрации КАК ПериодРегистрации,
	|	ДанныеДокумента.Начисление КАК Начисление,
	|	ДанныеДокумента.Сумма КАК Сумма,
	|	ДанныеДокумента.КодДохода КАК КодДохода,
	|	ДанныеДокумента.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	|	ДанныеДокумента.ВидДохода КАК ВидДохода,
	|	ДанныеДокумента.КодВычета КАК КодВычета,
	|	ДанныеДокумента.НДФЛ КАК НДФЛ,
	|	ДанныеДокумента.СуммаВычета КАК СуммаВычета,
	|	ДанныеДокумента.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ДанныеДокумента.ОтношениеКЕНВД КАК ОтношениеКЕНВД,
	|	ДанныеДокумента.ПериодРегистрацииДокумента КАК ПериодРегистрацииДокумента,
	|	ДанныеДокумента.ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов КАК ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов,
	|	ДанныеДокумента.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	ВТДанныеДокументаПредварительно КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТерриторииСотрудников КАК ТерриторииСотрудников
	|		ПО ДанныеДокумента.Сотрудник = ТерриторииСотрудников.Сотрудник
	|			И ДанныеДокумента.ДатаДействия = ТерриторииСотрудников.Период";
	Запрос.Выполнить();
	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеДокумента.ПериодРегистрации КАК ПериодРегистрации,
		|	ДанныеДокумента.ДатаДействия КАК ДатаДействия,
		|	ДанныеДокумента.ПериодДействия КАК ПериодДействия,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.Подразделение КАК Подразделение,
		|	ДанныеДокумента.ПодразделениеСотрудника КАК ПодразделениеСотрудника,
		|	ДанныеДокумента.ТерриторияВыполненияРаботВОрганизации КАК ТерриторияВыполненияРаботВОрганизации,
		|	ДанныеДокумента.Начисление КАК Начисление,
		|	ДанныеДокумента.ВидДохода КАК ВидДохода,
		|	ДанныеДокумента.ПериодРегистрацииДокумента КАК ПериодРегистрацииДокумента,
		|	ДанныеДокумента.ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов КАК ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоЗарплате.ПустаяСсылка) КАК ВидОперации,
		|	НАЧАЛОПЕРИОДА(ДанныеДокумента.ПериодРегистрации, МЕСЯЦ) КАК ДатаНачала,
		|	КОНЕЦПЕРИОДА(ДанныеДокумента.ПериодРегистрации, МЕСЯЦ) КАК ДатаОкончания,
		|	ДанныеДокумента.НомерСтроки КАК ИдентификаторСтроки,
		|	ДанныеДокумента.Сумма КАК Сумма,
		|	ДанныеДокумента.СуммаВычета КАК СуммаВычета,
		|	ДанныеДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТНачисленияДляРаспределения
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента";
		
		Запрос.Выполнить();
		
		ИсходныеДанные = ОтражениеЗарплатыВБухучетеРасширенный.ОписаниеИсходныхДанныхДляОтраженияНачисленийВБухучете();
		ИсходныеДанные.МенеджерВременныхТаблиц    = Запрос.МенеджерВременныхТаблиц;
		ИсходныеДанные.Организация    			  = РеквизитыДляПроведения.Организация;
		ИсходныеДанные.МесяцНачисления 			  = РеквизитыДляПроведения.ПериодРегистрации;  
		ИсходныеДанные.ИсключаемыйРегистратор     = РеквизитыДляПроведения.Ссылка;
		ИсходныеДанные.БухучетПервичногоДокумента = Документы.ПризПодарок.ДанныеДляБухучетаЗарплатыПервичныхДокументов(РеквизитыДляПроведения).ТаблицаБухучетЗарплаты;
		ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТБухучетНачисленийБезДоговоровГПХ(ИсходныеДанные, "ВТБухучетНачислений");
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Начисления.ПериодРегистрации КАК ПериодРегистрации,
		|	Начисления.ПериодРегистрации КАК МесяцНачисления,
		|	Начисления.ДатаДействия КАК ДатаДействия,
		|	Начисления.ДатаДействия КАК ДатаДохода,
		|	Начисления.ПериодДействия КАК ПериодДействия,
		|	Начисления.Организация КАК Организация,
		|	Начисления.Сотрудник КАК Сотрудник,
		|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Начисления.Подразделение КАК Подразделение,
		|	Начисления.ПодразделениеСотрудника КАК ПодразделениеСотрудника,
		|	Начисления.ТерриторияВыполненияРаботВОрганизации КАК ТерриторияВыполненияРаботВОрганизации,
		|	Начисления.Начисление КАК Начисление,
		|	Начисления.ВидДохода КАК ВидДохода,
		|	Начисления.ПериодРегистрацииДокумента КАК ПериодРегистрацииДокумента,
		|	Начисления.ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов КАК ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов,
		|	Начисления.ДатаНачала КАК ДатаНачала,
		|	Начисления.ДатаОкончания КАК ДатаОкончания,
		|	Начисления.ДокументОснование КАК ДокументОснование,
		|	Начисления.ДокументОснование КАК ДокументСсылка,
		|	БухучетНачислений.СтатьяФинансирования КАК СтатьяФинансирования,
		|	БухучетНачислений.СтатьяРасходов КАК СтатьяРасходов,
		|	БухучетНачислений.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
		|	БухучетНачислений.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
		|	БухучетНачислений.Сумма КАК Сумма,
		|	ВЫБОР
		|		КОГДА Начисления.Сумма = 0
		|			ТОГДА Начисления.СуммаВычета
		|		КОГДА БухучетНачислений.ОблагаетсяЕНВД
		|			ТОГДА ВЫРАЗИТЬ(Начисления.СуммаВычета * БухучетНачислений.Сумма / Начисления.Сумма КАК ЧИСЛО(15, 2))
		|		ИНАЧЕ Начисления.СуммаВычета - (ВЫРАЗИТЬ(Начисления.СуммаВычета * (Начисления.Сумма - БухучетНачислений.Сумма) / Начисления.Сумма КАК ЧИСЛО(15, 2)))
		|	КОНЕЦ КАК СуммаВычета
		|ПОМЕСТИТЬ ВТНачисленияДокумента
		|ИЗ
		|	ВТНачисленияДляРаспределения КАК Начисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБухучетНачислений КАК БухучетНачислений
		|		ПО Начисления.ИдентификаторСтроки = БухучетНачислений.ИдентификаторСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТНачисленияДляРаспределения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТБухучетНачислений";
		Запрос.Выполнить();
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Начисления.ПериодРегистрации КАК ПериодРегистрации,
		|	Начисления.ПериодРегистрации КАК МесяцНачисления,
		|	Начисления.ДатаДействия КАК ДатаДействия,
		|	Начисления.ДатаДействия КАК ДатаДохода,
		|	Начисления.ПериодДействия КАК ПериодДействия,
		|	Начисления.Организация КАК Организация,
		|	Начисления.Сотрудник КАК Сотрудник,
		|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Начисления.Подразделение КАК Подразделение,
		|	Начисления.ПодразделениеСотрудника КАК ПодразделениеСотрудника,
		|	Начисления.ТерриторияВыполненияРаботВОрганизации КАК ТерриторияВыполненияРаботВОрганизации,
		|	Начисления.Начисление КАК Начисление,
		|	Начисления.ВидДохода КАК ВидДохода,
		|	Начисления.ПериодРегистрацииДокумента КАК ПериодРегистрацииДокумента,
		|	Начисления.ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов КАК ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов,
		|	НАЧАЛОПЕРИОДА(Начисления.ПериодРегистрации, МЕСЯЦ) КАК ДатаНачала,
		|	КОНЕЦПЕРИОДА(Начисления.ПериодРегистрации, МЕСЯЦ) КАК ДатаОкончания,
		|	Начисления.Ссылка КАК ДокументОснование,
		|	Начисления.Ссылка КАК ДокументСсылка,
		|	ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка) КАК СтатьяФинансирования,
		|	ЗНАЧЕНИЕ(Справочник.СтатьиРасходовЗарплата.ПустаяСсылка) КАК СтатьяРасходов,
		|	Начисления.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
		|	ЛОЖЬ КАК ОблагаетсяЕНВД,
		|	Начисления.Сумма КАК Сумма,
		|	Начисления.СуммаВычета КАК СуммаВычета
		|ПОМЕСТИТЬ ВТНачисленияДокумента
		|ИЗ
		|	ВТДанныеДокумента КАК Начисления";
		Запрос.Выполнить();
	КонецЕсли;
	
	УчетНДФЛ.СоздатьВТСтавкаНДФЛПоСтавкеРезидента(Запрос.МенеджерВременныхТаблиц,"ВТДоходыФизическихЛиц");
	
	КадровыеДанные = "Должность,
	|ДолжностьПоШтатномуРасписанию, 
	|ЯвляетсяРаботникомСДосрочнойПенсией,
	|ЯвляетсяФармацевтом,
	|ПрименяемыйЛьготныйТерриториальныйТариф,
	|ЯвляетсяРаботникомСДосрочнойПенсией,
	|ЯвляетсяПрокурором,
	|ЯвляетсяВоеннослужащим,
	|РаботаетВСтуденческомОтряде,
	|ЯвляетсяЧленомЛетногоЭкипажа,
	|ЯвляетсяШахтером";
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТНачисленияДокумента", "Сотрудник,ДатаНачала");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Ложь, КадровыеДанные);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
		|	ВЫБОР
		|		КОГДА &ИспользоватьШтатноеРасписание
		|			ТОГДА КадровыеДанныеСотрудников.ДолжностьПоШтатномуРасписанию
		|		ИНАЧЕ КадровыеДанныеСотрудников.Должность
		|	КОНЕЦ КАК Должность,
		|	КадровыеДанныеСотрудников.ЯвляетсяРаботникомСДосрочнойПенсией КАК ЯвляетсяРаботникомСДосрочнойПенсией,
		|	КадровыеДанныеСотрудников.ЯвляетсяФармацевтом,
		|	КадровыеДанныеСотрудников.ПрименяемыйЛьготныйТерриториальныйТариф,
		|	КадровыеДанныеСотрудников.ЯвляетсяПрокурором,
		|	КадровыеДанныеСотрудников.ЯвляетсяВоеннослужащим,
		|	КадровыеДанныеСотрудников.РаботаетВСтуденческомОтряде,
		|	КадровыеДанныеСотрудников.ЯвляетсяЧленомЛетногоЭкипажа,
		|	КадровыеДанныеСотрудников.ЯвляетсяШахтером,
		|	КадровыеДанныеСотрудников.Период КАК Период
		|ПОМЕСТИТЬ ВТКадровыеДанные
		|ИЗ
		|	ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КадровыеДанные.Должность КАК Должность,
		|	КадровыеДанные.Период КАК Период
		|ПОМЕСТИТЬ ВТДолжности
		|ИЗ
		|	ВТКадровыеДанные КАК КадровыеДанные";
		
	Запрос.Выполнить();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроения.ВсеЗаписи = Истина;
	УчетСтраховыхВзносов.ДобавитьОтборПриЧтенииПериодическихДанных(ПараметрыПостроения, КонецМесяца(РеквизитыДляПроведения.ДатаПолученияДохода), Ложь);

	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"КлассыУсловийТрудаПоДолжностям",
		Запрос.МенеджерВременныхТаблиц,
		Ложь,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТДолжности",
			"Должность"),
		ПараметрыПостроения);
		
		
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НачисленияДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НачисленияДокумента.СтатьяФинансирования КАК СтатьяФинансирования,
		|	НачисленияДокумента.СтатьяРасходов КАК СтатьяРасходов
		|ПОМЕСТИТЬ ВТБухучетФизическихЛиц
		|ИЗ
		|	ВТНачисленияДокумента КАК НачисленияДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы) КАК КатегорияДохода,
		|	ДанныеДокумента.КодДохода КАК КодДохода,
		|	ДанныеДокумента.КодВычета КАК КодВычета,
		|	ДанныеДокумента.ПланируемаяДатаВыплаты КАК ДатаПолученияДохода,
		|	ДанныеДокумента.Сумма КАК СуммаДохода,
		|	ДанныеДокумента.СуммаВычета КАК СуммаВычета,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.СтавкаНалогообложенияРезидента = ЗНАЧЕНИЕ(Перечисление.НДФЛСтавкиНалогообложенияРезидента.Ставка13)
		|			ТОГДА ДанныеДокумента.НДФЛ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НалогПоСтавке13,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.СтавкаНалогообложенияРезидента = ЗНАЧЕНИЕ(Перечисление.НДФЛСтавкиНалогообложенияРезидента.Ставка09)
		|			ТОГДА ДанныеДокумента.НДФЛ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НалогПоСтавке09,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.СтавкаНалогообложенияРезидента = ЗНАЧЕНИЕ(Перечисление.НДФЛСтавкиНалогообложенияРезидента.Ставка35)
		|			ТОГДА ДанныеДокумента.НДФЛ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НалогПоСтавке35,
		|	ДанныеДокумента.НДФЛ КАК Сумма,
		|	ДанныеДокумента.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
		|	ДанныеДокумента.ТерриторияВыполненияРаботВОрганизации КАК Подразделение,
		|	ДанныеДокумента.ПодразделениеСотрудника КАК ПодразделениеСотрудника,
		|	ДанныеДокумента.Начисление КАК Начисление,
		|	ДанныеДокумента.ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов КАК ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов,
		|	ДанныеДокумента.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
		|	СтавкаНДФЛПоСтавкеРезидента.СтавкаНДФЛ КАК Ставка
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтавкаНДФЛПоСтавкеРезидента КАК СтавкаНДФЛПоСтавкеРезидента
		|		ПО ДанныеДокумента.ФизическоеЛицо = СтавкаНДФЛПоСтавкеРезидента.ФизическоеЛицо
		|			И ДанныеДокумента.ПланируемаяДатаВыплаты = СтавкаНДФЛПоСтавкеРезидента.Период
		|ГДЕ
		|	ДанныеДокумента.КодДохода <> ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.КодДохода КАК КодДохода,
		|	ДанныеДокумента.КодВычета КАК КодВычета,
		|	ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы) КАК КатегорияДохода,
		|	ДанныеДокумента.ПланируемаяДатаВыплаты КАК МесяцНалоговогоПериода,
		|	ДанныеДокумента.НДФЛ КАК Сумма,
		|	ДанныеДокумента.ТерриторияВыполненияРаботВОрганизации КАК Подразделение,
		|	ДанныеДокумента.ПодразделениеСотрудника КАК ПодразделениеСотрудника,
		|	ДанныеДокумента.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.КодДохода <> ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.ПодразделениеСотрудника КАК Подразделение,
		|	ДанныеДокумента.ВидДохода КАК ВидДохода,
		|	ДанныеДокумента.Начисление КАК Начисление,
		|	ДанныеДокумента.ДатаНачала КАК ДатаНачала,
		|	ДанныеДокумента.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
		|	ДанныеДокумента.Сумма КАК Сумма,
		|	КадровыеДанные.ЯвляетсяРаботникомСДосрочнойПенсией КАК ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
		|	КадровыеДанные.ЯвляетсяФармацевтом КАК ЯвляетсяДоходомФармацевта,
		|	КадровыеДанные.ПрименяемыйЛьготныйТерриториальныйТариф КАК ЛьготныйТерриториальныйТариф,
		|	КадровыеДанные.ЯвляетсяЧленомЛетногоЭкипажа КАК ОблагаетсяВзносамиНаДоплатуЛетчикам,
		|	КадровыеДанные.ЯвляетсяШахтером КАК ОблагаетсяВзносамиНаДоплатуШахтерам,
		|	КлассыУсловийТрудаПоДолжностям.КлассУсловийТруда КАК КлассУсловийТруда
		|ИЗ
		|	ВТНачисленияДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанные КАК КадровыеДанные
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВТКлассыУсловийТрудаПоДолжностямСрезПоследних КАК КлассыУсловийТрудаПоДолжностям
		|			ПО КадровыеДанные.Должность = КлассыУсловийТрудаПоДолжностям.Должность
		|				И КадровыеДанные.Период = КлассыУсловийТрудаПоДолжностям.Период
		|		ПО ДанныеДокумента.Сотрудник = КадровыеДанные.Сотрудник
		|			И ДанныеДокумента.ДатаНачала = КадровыеДанные.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.ПодразделениеСотрудника КАК Подразделение,
		|	ДанныеДокумента.ТерриторияВыполненияРаботВОрганизации КАК ТерриторияВыполненияРаботВОрганизации,
		|	ДанныеДокумента.Сумма КАК Сумма,
		|	ДанныеДокумента.Начисление КАК Начисление,
		|	ДанныеДокумента.ДатаНачала КАК ДатаНачала,
		|	ДанныеДокумента.ДатаОкончания КАК ДатаОкончания,
		|	ДанныеДокумента.ДокументОснование КАК ДокументОснование,
		|	ДанныеДокумента.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
		|	ДанныеДокумента.СтатьяФинансирования КАК СтатьяФинансирования,
		|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
		|	ДанныеДокумента.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете
		|ИЗ
		|	ВТНачисленияДокумента КАК ДанныеДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.ТерриторияВыполненияРаботВОрганизации КАК Подразделение,
		|	ДанныеДокумента.Подразделение КАК ПодразделениеСотрудника,
		|	ДанныеДокумента.НДФЛ КАК Сумма,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛРасчетыСБывшимиСотрудниками) КАК НачислениеУдержание,
		|	ДанныеДокумента.Ссылка КАК ДокументОснование,
		|	БухучетФизическихЛиц.СтатьяФинансирования КАК СтатьяФинансирования,
		|	БухучетФизическихЛиц.СтатьяРасходов КАК СтатьяРасходов,
		|	ДанныеДокумента.ПланируемаяДатаВыплаты КАК МесяцНалоговогоПериода
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБухучетФизическихЛиц КАК БухучетФизическихЛиц
		|		ПО ДанныеДокумента.ФизическоеЛицо = БухучетФизическихЛиц.ФизическоеЛицо";
	
	Результат = Запрос.ВыполнитьПакет();
	КоличествоРезультатов = Результат.ВГраница();
	
	ДанныеДляПроведения.Вставить("ДанныеДляНДФЛ", Результат[КоличествоРезультатов-4].Выгрузить());
	ДанныеДляПроведения.Вставить("ДанныеДляРасчетовСБюджетомПоНДФЛ", Результат[КоличествоРезультатов-3].Выгрузить());
	ДанныеДляПроведения.Вставить("ДанныеДляВзносов", Результат[КоличествоРезультатов-2].Выгрузить());
	ДанныеДляПроведения.Вставить("Начисления", Результат[КоличествоРезультатов-1].Выгрузить());
	ДанныеДляПроведения.Вставить("НДФЛ", Результат[КоличествоРезультатов].Выгрузить());
	ДанныеДляПроведения.Вставить("МенеджерВременныхТаблиц", Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Организации.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	               |	ДанныеДокумента.ПериодРегистрацииДокумента КАК Период,
	               |	ДанныеДокумента.Организация КАК Организация,
	               |	ДанныеДокумента.Сотрудник КАК Сотрудник,
	               |	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ДанныеДокумента.Начисление КАК Начисление,
	               |	СУММА(ДанныеДокумента.Сумма) КАК Сумма
	               |ИЗ
	               |	ВТНачисленияДокумента КАК ДанныеДокумента
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	               |		ПО ДанныеДокумента.Организация = Организации.Ссылка
	               |			И (НЕ ДанныеДокумента.ИсключаетсяИзРасчетнойБазыИсполнительныхЛистов)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Организации.ГоловнаяОрганизация,
	               |	ДанныеДокумента.ПериодРегистрацииДокумента,
	               |	ДанныеДокумента.Организация,
	               |	ДанныеДокумента.Сотрудник,
	               |	ДанныеДокумента.ФизическоеЛицо,
	               |	ДанныеДокумента.Начисление";
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеДляПроведения.Вставить("ДополнениеРасчетнойБазыУдержаний", РезультатЗапроса.Выгрузить());
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПризПодарок.Ссылка,
	|	ПризПодарок.Организация,
	|	ПризПодарок.ПериодРегистрации,
	|	ПризПодарок.ДатаПолученияДохода,
	|	ПризПодарок.ИсправленныйДокумент,
	|	ПризПодарок.Дата,
	|	ПризПодарок.СтатьяФинансирования,
	|	ПризПодарок.СтатьяРасходов,
	|	ПризПодарок.СпособОтраженияЗарплатыВБухучете,
	|	ПризПодарок.ОтношениеКЕНВД
	|ИЗ
	|	Документ.ПризПодарок КАК ПризПодарок
	|ГДЕ
	|	ПризПодарок.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура(
		"Ссылка,
		|Организация,
		|ПериодРегистрации,
		|ДатаПолученияДохода,
		|ИсправленныйДокумент,
		|Дата,
		|СтатьяФинансирования,
		|СтатьяРасходов,
		|СпособОтраженияЗарплатыВБухучете,
		|ОтношениеКЕНВД");	
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

#КонецОбласти

#КонецЕсли
