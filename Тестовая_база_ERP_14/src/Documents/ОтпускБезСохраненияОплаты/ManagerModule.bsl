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
//  ДокументСсылка	- ДокументСсылка.ОтпускБезСохраненияОплаты - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.ОтпускБезСохраненияОплаты - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа.
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ);
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(ДокументСсылка, Движения, РежимПроведения, Отказ, РеквизитыДляПроведения, СтруктураВидовУчета, Объект);
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		ЗарегистрироватьВнутрисменныеОтклонения(Движения, РеквизитыДляПроведения);
		
	КонецЕсли;
	
	Если РеквизитыДляПроведения.ПерерасчетВыполнен Тогда
		
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
			
			РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.ПериодРегистрации), ДанныеДляПроведения.Начисления, ДанныеДляПроведения.ПоказателиНачислений, Истина);
			
			РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
			РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияРезультатовНачислений(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеРезультатовНачислений);
			
			ПерерасчетЗарплаты.СформироватьДвиженияИсходныеДанныхПерерасчетов(Движения, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.Начисления);
			ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ);
			
			// Заполним описание данных для проведения в учете начисленной зарплаты.
			ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
			ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
			ДанныеДляПроведенияУчетЗарплаты.Организация 			= РеквизитыДляПроведения.Организация;
			ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= РеквизитыДляПроведения.ПериодРегистрации;
			ДанныеДляПроведенияУчетЗарплаты.ПорядокВыплаты 			= Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
			ДанныеДляПроведенияУчетЗарплаты.МенеджерВременныхТаблиц = ДанныеДляПроведения.МенеджерВременныхТаблиц;
			
			// - Регистрация начислений в учете начислений и удержаний.
			УчетНачисленнойЗарплаты.ЗарегистрироватьНачисления(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.НачисленияПоСотрудникам, Неопределено);
			УчетНачисленнойЗарплаты.ЗарегистрироватьОтработанноеВремя(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.ОтработанноеВремяПоСотрудникам, Истина);
			
			// - Регистрация начислений и удержаний в бухучете.
			ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьНачисленияУдержания(ДанныеДляПроведенияУчетЗарплаты, Отказ,
				ДанныеДляПроведения.НачисленияПоСотрудникам, Неопределено, Неопределено);
			
			УчетНДФЛРасширенный.СформироватьДоходыНДФЛПоНачислениям(Движения, Отказ, РеквизитыДляПроведения.Организация,
						КонецМесяца(РеквизитыДляПроведения.ПериодРегистрации), КонецМесяца(РеквизитыДляПроведения.ПериодРегистрации),
						ДанныеДляПроведения.МенеджерВременныхТаблиц, , , , , ДокументСсылка);
			
			// Дополняем доходы НДФЛ сведениями о распределении по статьям финансирования и/или статьям расходов.
			ОтражениеЗарплатыВУчетеРасширенный.ДополнитьСведенияОДоходахНДФЛСведениямиОРаспределенииПоСтатьям(Движения);
			
			// - Регистрация начислений в доходах для страховых взносов.
			УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(
				Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, Ложь, Истина, РеквизитыДляПроведения.Ссылка);
			
		КонецЕсли;
		
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			
			// Учет среднего заработка
			УчетСреднегоЗаработка.ЗарегистрироватьДанныеСреднегоЗаработка(Движения, Отказ, ДанныеДляПроведения.НачисленияДляСреднегоЗаработка);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		ПараметрыДвиженийОтпусков = ОстаткиОтпусков.ПараметрыДляСформироватьДвиженияФактическихОтпусков();
		ПараметрыДвиженийОтпусков.ДатаРегистрации = РеквизитыДляПроведения.Дата;
		ПараметрыДвиженийОтпусков.Начисления = ДанныеДляПроведения.Начисления;
		ПараметрыДвиженийОтпусков.ПериодНачисления = РеквизитыДляПроведения.ПериодРегистрации;
		ОстаткиОтпусков.СформироватьДвиженияФактическихОтпусков(Движения, Отказ, ПараметрыДвиженийОтпусков);
		
		Если Не РеквизитыДляПроведения.ОтсутствиеВТечениеЧастиСмены Тогда 
			СостоянияСотрудников.ЗарегистрироватьОтпускСотрудника(Движения, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.Сотрудник, РеквизитыДляПроведения.ВидОтпуска, РеквизитыДляПроведения.ДатаНачала, РеквизитыДляПроведения.ДатаОкончания);
			
			УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР(РеквизитыДляПроведения.Ссылка)[РеквизитыДляПроведения.Ссылка]);
		КонецЕсли;
			
		Если РеквизитыДляПроведения.ОсвобождатьСтавку Тогда
			КадровыйУчетРасширенный.ОсвободитьСтавкуВременно(Движения, ДанныеДляПроведения.ПериодыОсвобожденияСтавки);
		КонецЕсли;
		
		ПерерасчетЗарплаты.УдалитьПерерасчетыПоДополнительнымПараметрам(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
		
		КадровыйУчетРасширенный.ЗарегистрироватьВРеестреОтпусков(Движения, ДанныеДляПроведения.ДанныеРеестраОтпусков, Отказ);
		
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ВыполнитьЗапланированныеКорректировкиДвижений(Движения);
	
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
		// При отмене документа реквизиты для проведения сформированы документом СторнированиеНачислений, их структура отличается
		// от структуры реквизитов для проведения исправленного документа. Получаем реквизиты для проведения исправленного документа.
		РеквизитыДляПроведения = РеквизитыДляПроведения(ИсправленныйДокумент);
		РеквизитыДляПроведения.ПериодРегистрации = ДополнительныеПараметры.ПериодРегистрации;
		
	Иначе
		РеквизитыДляПроведения = ДополнительныеПараметры.РеквизитыДляПроведения;
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		Сотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДляПроведения.Сотрудник);
		
		Если Не РеквизитыДляПроведения.ОсвобождатьСтавку Тогда
			УправлениеШтатнымРасписанием.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		КонецЕсли;
		
		УчетРабочегоВремениРасширенный.ЗарегистрироватьСторноЗаписиПоДокументу(Движения, РеквизитыДляПроведения.ПериодРегистрации, ИсправленныйДокумент, Сотрудники);
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОтменаДокумента Или ДополнительныеПараметры.ИсправлениеВТекущемПериоде Тогда
		
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			УчетСреднегоЗаработка.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		КонецЕсли;
		
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
			РасчетЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			УчетНачисленнойЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			ОтражениеЗарплатыВБухучетеРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			УчетНДФЛРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
			УчетСтраховыхВзносовРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
			
			УправлениеШтатнымРасписанием.ИзолироватьУчетом(Движения.ЗанятыеПозицииШтатногоРасписания);
			
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

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ОтпускБезСохраненияОплаты);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтпускаБезОплаты") Тогда
		// Приказ о предоставлении отпуска (Т-6).
		КадровыйУчетРасширенный.ДобавитьКомандуПечатиПриказаОПредоставленииОтпуска(КомандыПечати);
	КонецЕсли;
КонецПроцедуры

Функция ТекстСообщенияНеЗаполненВидРасчета(ВидОтпуска, ВнутрисменныйОтпуск) Экспорт
	ТекстСообщения = НСтр("ru = 'Не найдено ни одного начисления для регистрации %1""%2""';
							|en = 'No accruals to register %1""%2"" are found'");
		
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ?(ВнутрисменныйОтпуск, НСтр("ru = 'внутрисменного ';
																												|en = 'part-shift'"), ""), ВидОтпуска);
КонецФункции

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, ЧтениеНачисленнойЗарплатыРасширенная", , Ложь);
	
КонецФункции

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	ФизическоеЛицо = ?(ЗначениеЗаполнено(Объект.Сотрудник), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Сотрудник, "ФизическоеЛицо"), Справочники.ФизическиеЛица.ПустаяСсылка());
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтпускБезСохраненияОплаты.Сотрудник,
	|	ОтпускБезСохраненияОплаты.ВидОтпуска,
	|	ОтпускБезСохраненияОплаты.ВидРасчета.ВидСтажаПФР2014 КАК ВидСтажаПФР,
	|	ОтпускБезСохраненияОплаты.ДатаНачала,
	|	ОтпускБезСохраненияОплаты.ДатаОкончания,
	|	ОтпускБезСохраненияОплаты.ОтсутствиеВТечениеЧастиСмены,
	|	ОтпускБезСохраненияОплаты.Ссылка
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплаты КАК ОтпускБезСохраненияОплаты
	|ГДЕ
	|	ОтпускБезСохраненияОплаты.Ссылка В(&МассивСсылок)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу);
		
		Если Не Выборка.ОтсутствиеВТечениеЧастиСмены Тогда
			Если ЗначениеЗаполнено(Выборка.ВидСтажаПФР) Тогда
				ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
				ОписаниеПериода.Сотрудник = Выборка.Сотрудник;
				ОписаниеПериода.ДатаНачалаПериода = Выборка.ДатаНачала;
				ОписаниеПериода.ДатаОкончанияПериода = Выборка.ДатаОкончания;
				ОписаниеПериода.Состояние = СостоянияСотрудников.СостояниеПоВидуОтпуска(Выборка.ВидОтпуска);
				
				РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
				
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Выборка.ВидСтажаПФР);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеДляРегистрацииВУчете;
	
КонецФункции

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета) 
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
	
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет,НачисленияПерерасчетНулевыеСторно", "Ссылка.ПериодРегистрации");
		Если РеквизитыДляПроведения.ПерерасчетВыполнен Тогда
			
			РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
			ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
			
		КонецЕсли;
		
		Если РеквизитыДляПроведения.ОсвобождатьСтавку Тогда
			
			КадровыйУчетРасширенный.ЗаполнитьПериодыОсвобожденияСтавки(ДанныеДляПроведения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДляПроведения.Сотрудник), РеквизитыДляПроведения.ДатаНачала, КонецДня(РеквизитыДляПроведения.ДатаОкончания) + 1);
			
			Если ЗначениеЗаполнено(РеквизитыДляПроведения.ИсправленныйДокумент) Тогда
				
				ДанныеИсправленногоДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
					РеквизитыДляПроведения.ИсправленныйДокумент, "ФизическоеЛицо,Организация,Сотрудник,ДатаНачала,ДатаОкончания,ОсвобождатьСтавку");
				
				Если ДанныеИсправленногоДокумента.ОсвобождатьСтавку Тогда
					
					КадровыйУчетРасширенный.ЗаполнитьПериодыОсвобожденияСтавки(ДанныеДляПроведения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеИсправленногоДокумента.Сотрудник),
						ДанныеИсправленногоДокумента.ДатаНачала, КонецДня(ДанныеИсправленногоДокумента.ДатаОкончания) + 1, Истина);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Данные для Реестра отпусков
		ДанныеРеестраОтпусков = КадровыйУчетРасширенный.ТаблицаРеестраОтпусков();
		
		НоваяСтрока = ДанныеРеестраОтпусков.Добавить();
		Если ЗначениеЗаполнено(РеквизитыДляПроведения.ИсправленныйДокумент) Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ДокументОснование", РеквизитыДляПроведения.ИсправленныйДокумент);
			Запрос.УстановитьПараметр("Сотрудник", РеквизитыДляПроведения.Сотрудник);
			
			Запрос.Текст =
				"ВЫБРАТЬ
				|	РеестрОтпусков.Сотрудник,
				|	РеестрОтпусков.ФизическоеЛицо,
				|	РеестрОтпусков.ДокументОснование,
				|	РеестрОтпусков.Номер,
				|	РеестрОтпусков.ВидОтпуска,
				|	РеестрОтпусков.ВидДоговора,
				|	РеестрОтпусков.Основание
				|ИЗ
				|	РегистрСведений.РеестрОтпусков КАК РеестрОтпусков
				|ГДЕ
				|	РеестрОтпусков.Регистратор = &ДокументОснование
				|	И РеестрОтпусков.Сотрудник = &Сотрудник";
			
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
		Иначе
			
			НоваяСтрока.Сотрудник = РеквизитыДляПроведения.Сотрудник;
			НоваяСтрока.ФизическоеЛицо = РеквизитыДляПроведения.ФизическоеЛицо;
			НоваяСтрока.ДокументОснование = РеквизитыДляПроведения.Ссылка;
			НоваяСтрока.Номер = 1;
			
			НоваяСтрока.ВидОтпуска = РеквизитыДляПроведения.ВидОтпуска;
			
			КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(
				Истина, РеквизитыДляПроведения.Сотрудник, "ВидДоговора", РеквизитыДляПроведения.ДатаНачала);
			
			Если КадровыеДанныеСотрудника.Количество() > 0 Тогда
				НоваяСтрока.ВидДоговора = КадровыеДанныеСотрудника[0].ВидДоговора;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(РеквизитыДляПроведения.ДокументЗаполнения) Тогда
				Основание = КадровыйУчетРасширенный.ОснованиеДляРеестра(РеквизитыДляПроведения.ДатаДокументаЗаполнения, РеквизитыДляПроведения.НомерДокументаЗаполнения);
			Иначе
				Основание = КадровыйУчетРасширенный.ОснованиеДляРеестра(РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.Номер);
			КонецЕсли;
			
			Основание = КадровыйУчетРасширенный.ОснованиеДляРеестра(РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.Номер);
			
			НоваяСтрока.Основание = Основание;
			
		КонецЕсли;
		
		НоваяСтрока.Период = РеквизитыДляПроведения.Дата;
		НоваяСтрока.КоличествоДнейОтпуска = ЗарплатаКадрыКлиентСервер.ДнейВПериоде(
			РеквизитыДляПроведения.ДатаНачала, РеквизитыДляПроведения.ДатаОкончания);
		
		НоваяСтрока.ДатаНачалаПериодаОтсутствия = РеквизитыДляПроведения.ДатаНачала;
		НоваяСтрока.ДатаОкончанияПериодаОтсутствия = РеквизитыДляПроведения.ДатаОкончания;
		
		ДанныеДляПроведения.Вставить("ДанныеРеестраОтпусков", ДанныеРеестраОтпусков);
		
	КонецЕсли;
	
	Если РеквизитыДляПроведения.ПерерасчетВыполнен И СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка();
		ДополнительныеПараметры.МесяцНачисления = "Ссылка.ПериодРегистрации";
		УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция ДанныеОВремени(РеквизитыДляПроведения) Экспорт
	
	ДанныеОВремени = УчетРабочегоВремениРасширенный.ТаблицаДляРегистрацииВремениВнутрисменныхОтлонений();
	
	Если РеквизитыДляПроведения.ОтсутствиеВТечениеЧастиСмены Тогда
		СтрокаДанныхОВремени = ДанныеОВремени.Добавить();
		СтрокаДанныхОВремени.Дата = РеквизитыДляПроведения.ДатаОтсутствия;
		СтрокаДанныхОВремени.Сотрудник = РеквизитыДляПроведения.Сотрудник;
		СтрокаДанныхОВремени.Организация = РеквизитыДляПроведения.Организация;
		СтрокаДанныхОВремени.ВидВремени = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыДляПроведения.ВидРасчета, "ОбозначениеВТабелеУчетаРабочегоВремени");
		СтрокаДанныхОВремени.ВидВремениВытесняемый = РеквизитыДляПроведения.ВидВремениЗамещаемый;
		СтрокаДанныхОВремени.Часов = РеквизитыДляПроведения.ЧасовОтпуска;
		СтрокаДанныхОВремени.Смена = РеквизитыДляПроведения.Смена;
		СтрокаДанныхОВремени.ПереходящаяЧастьПредыдущейСмены = РеквизитыДляПроведения.ПереходящаяЧастьПредыдущейСмены;
		СтрокаДанныхОВремени.ПереходящаяЧастьТекущейСмены = РеквизитыДляПроведения.ПереходящаяЧастьТекущейСмены;
	КонецЕсли;
	
	Возврат ДанныеОВремени;
	
КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтпускБезСохраненияОплаты.Ссылка КАК Ссылка,
	|	ОтпускБезСохраненияОплаты.Организация КАК Организация,
	|	ОтпускБезСохраненияОплаты.ПериодРегистрации КАК ПериодРегистрации,
	|	ОтпускБезСохраненияОплаты.Дата КАК Дата,
	|	ОтпускБезСохраненияОплаты.ПерерасчетВыполнен КАК ПерерасчетВыполнен,
	|	ОтпускБезСохраненияОплаты.ОтсутствиеВТечениеЧастиСмены КАК ОтсутствиеВТечениеЧастиСмены,
	|	ОтпускБезСохраненияОплаты.Сотрудник КАК Сотрудник,
	|	ОтпускБезСохраненияОплаты.ВидОтпуска КАК ВидОтпуска,
	|	ОтпускБезСохраненияОплаты.ДатаНачала КАК ДатаНачала,
	|	ОтпускБезСохраненияОплаты.ДатаОкончания КАК ДатаОкончания,
	|	ОтпускБезСохраненияОплаты.ОсвобождатьСтавку КАК ОсвобождатьСтавку,
	|	ОтпускБезСохраненияОплаты.ИсправленныйДокумент КАК ИсправленныйДокумент,
	|	ОтпускБезСохраненияОплаты.Номер КАК Номер,
	|	ОтпускБезСохраненияОплаты.ДатаОтсутствия КАК ДатаОтсутствия,
	|	ОтпускБезСохраненияОплаты.ВидРасчета КАК ВидРасчета,
	|	ОтпускБезСохраненияОплаты.ВидВремениЗамещаемый КАК ВидВремениЗамещаемый,
	|	ОтпускБезСохраненияОплаты.ЧасовОтпуска КАК ЧасовОтпуска,
	|	ОтпускБезСохраненияОплаты.ДокументЗаполнения КАК ДокументЗаполнения,
	|	ОтпускБезСохраненияОплаты.ДокументЗаполнения.Номер КАК НомерДокументаЗаполнения,
	|	ОтпускБезСохраненияОплаты.ДокументЗаполнения.Дата КАК ДатаДокументаЗаполнения,
	|	ОтпускБезСохраненияОплаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ОтпускБезСохраненияОплаты.Смена КАК Смена,
	|	ОтпускБезСохраненияОплаты.ПереходящаяЧастьПредыдущейСмены КАК ПереходящаяЧастьПредыдущейСмены,
	|	ОтпускБезСохраненияОплаты.ПереходящаяЧастьТекущейСмены КАК ПереходящаяЧастьТекущейСмены
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплаты КАК ОтпускБезСохраненияОплаты
	|ГДЕ
	|	ОтпускБезСохраненияОплаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.НомерСтроки КАК НомерСтроки,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.Территория КАК Территория,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.УсловияТруда КАК УсловияТруда,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения КАК ДоляРаспределения,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.Результат КАК Результат,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей КАК ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплаты.РаспределениеПоТерриториямУсловиямТруда КАК ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.Территория КАК Территория,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.СтатьяРасходов КАК СтатьяРасходов,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
	|	СУММА(ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.Результат) КАК Результат,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.ПодразделениеУчетаЗатрат КАК ПодразделениеУчетаЗатрат
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплаты.РаспределениеРезультатовНачислений КАК ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений
	|ГДЕ
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.СтатьяФинансирования,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.Территория,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.СтатьяРасходов,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.СпособОтраженияЗарплатыВБухучете,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.ОблагаетсяЕНВД,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.ПодразделениеУчетаЗатрат,
	|	ОтпускБезСохраненияОплатыРаспределениеРезультатовНачислений.ИдентификаторСтроки";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	РаспределениеПоТерриториямУсловиямТруда = Результаты[1].Выгрузить();
	РаспределениеРезультатовНачислений = Результаты[2].Выгрузить();
	РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда = РаспределениеПоТерриториямУсловиямТруда;
	РеквизитыДляПроведения.РаспределениеРезультатовНачислений = РаспределениеРезультатовНачислений;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура(
		"Ссылка,
		|Организация,
		|ПериодРегистрации,
		|Дата,
		|ПланируемаяДатаВыплаты,
		|ПерерасчетВыполнен,
		|ОтсутствиеВТечениеЧастиСмены,
		|Сотрудник,
		|ВидОтпуска,
		|ДатаНачала,
		|ДатаОкончания,
		|ОсвобождатьСтавку,
		|ИсправленныйДокумент,
		|Номер,
		|ДатаОтсутствия,
		|ВидРасчета,
		|ВидВремениЗамещаемый,
		|ЧасовОтпуска,
		|РаспределениеПоТерриториямУсловиямТруда,
		|РаспределениеРезультатовНачислений,
		|ДокументЗаполнения,
		|НомерДокументаЗаполнения,
		|ДатаДокументаЗаполнения,
		|ФизическоеЛицо, Смена, ПереходящаяЧастьПредыдущейСмены, ПереходящаяЧастьТекущейСмены");
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

Процедура ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИменаРеквизитов = 
	"ПериодРегистрации,
	|Организация,
	|ИсправленныйДокумент,
	|ВидРасчета";
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, ИменаРеквизитов);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Начисления.*
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплаты.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.Ссылка = &Ссылка";
	
	Начисления = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроверки = РасчетЗарплатыРасширенный.ПараметрыПроверкиПересеченияФактическогоПериодаДействия();
	ПараметрыПроверки.Организация = РеквизитыДокумента.Организация;
	ПараметрыПроверки.ПериодРегистрации = РеквизитыДокумента.ПериодРегистрации;
	ПараметрыПроверки.Документ = ДокументСсылка;
	ПараметрыПроверки.Начисления = Начисления;
	ПараметрыПроверки.ИсправленныйДокумент = РеквизитыДокумента.ИсправленныйДокумент;
	ПараметрыПроверки.ОсновныеНачисления = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДокумента.ВидРасчета);
	
	РасчетЗарплатыРасширенный.ПроверитьПересечениеФактическогоПериодаДействия(ПараметрыПроверки, Отказ);
	
КонецПроцедуры

// Функция возвращает структуру с описанием данного вида документа.
//
Функция ОписаниеДокумента() Экспорт 
	
	ОписаниеДокумента = ЗарплатаКадрыРасширенныйКлиентСервер.СтруктураОписанияДокумента();
	
	ОписаниеДокумента.КраткоеНазваниеИменительныйПадеж	 = НСтр("ru = 'отпуск';
																	|en = 'leave'");
	ОписаниеДокумента.КраткоеНазваниеРодительныйПадеж	 = НСтр("ru = 'отпуска';
																|en = 'leaves'");
	ОписаниеДокумента.ИмяРеквизитаСотрудник				 = "Сотрудник";
	ОписаниеДокумента.ИмяРеквизитаОтсутствующийСотрудник = "Сотрудник";
	ОписаниеДокумента.ИмяРеквизитаДатаНачалаСобытия		 = "ДатаНачала";
	ОписаниеДокумента.ИмяРеквизитаДатаОкончанияСобытия	 = "ДатаОкончания";
	
	Возврат ОписаниеДокумента;
	
КонецФункции

Процедура ЗаполнитьНастройкиМенеджераРасчета(МенеджерРасчета, Ссылка, ИсправленныйДокумент) Экспорт
	
	МенеджерРасчета.ИсключаемыйРегистратор = Ссылка;
	МенеджерРасчета.ИсправленныйДокумент = ИсправленныйДокумент;
	МенеджерРасчета.НастройкиРасчета.РассчитыватьНачисления = Истина;
	МенеджерРасчета.НастройкиРасчета.СохранятьИсправления = Истина;
	
КонецПроцедуры

Процедура РасчетЗарплатыВДанные(Объект, ДанныеМенеджераРасчета) Экспорт
	
	Если ДанныеМенеджераРасчета.Начисления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаИсточника Из ДанныеМенеджераРасчета.Начисления Цикл
		
		НоваяСтрока = Объект.Начисления.Добавить();
		СтрокаНачисленияВДанные(Объект, НоваяСтрока, СтрокаИсточника);
		НоваяСтрока.ИдентификаторСтрокиВидаРасчета = СтрокаИсточника.ИдентификаторСтроки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура РаспределениеПоТерриториямУсловиямТрудаВДанные(Объект, СтрокаИсточник)
	
	Если Не ЗарплатаКадрыРасширенный.ИспользоватьРаспределениеПоТерриториямУсловиямТруда(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаРаспределения Из СтрокаИсточник.ТерриторииУсловияТруда Цикл
		
		НоваяСтрока = Объект.РаспределениеПоТерриториямУсловиямТруда.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРаспределения);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура РезультатРаспределенияВДанные(Объект, СтрокаИсточник)
	
	Если СтрокаИсточник.РаспределениеПоСтатьям <> Неопределено Тогда
		
		Для каждого СтрокаРаспределения Из СтрокаИсточник.РаспределениеПоСтатьям Цикл
			НоваяСтрока = Объект.РаспределениеРезультатовНачислений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРаспределения);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СтрокаНачисленияВДанные(Объект, СтрокаПриемник, СтрокаИсточник) Экспорт
	
	ЗаполнитьЗначенияСвойств(СтрокаПриемник, СтрокаИсточник);
	
	РаспределениеПоТерриториямУсловиямТрудаВДанные(Объект, СтрокаИсточник);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") 
		И ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный") Тогда
		
		РезультатРаспределенияВДанные(Объект, СтрокаИсточник);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьВнутрисменныеОтклонения(Движения, РеквизитыДляПроведения)
	
	Если Не РеквизитыДляПроведения.ОтсутствиеВТечениеЧастиСмены Тогда
		Возврат;
	КонецЕсли;
	
	УчетРабочегоВремениРасширенный.ЗарегистрироватьВнутрисменныеОтклонения(Движения, ДанныеОВремени(РеквизитыДляПроведения), РеквизитыДляПроведения.ПериодРегистрации);
	
КонецПроцедуры

Процедура ЗарегистрироватьСторноЗаписиУчетаВремени(Движения, Сотрудник, ПериодРегистрации, ИсправленныйДокумент, Записывать = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(ИсправленныйДокумент) Тогда
		Возврат;
	КонецЕсли;
	
	Сотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник);
	УчетРабочегоВремениРасширенный.ЗарегистрироватьСторноЗаписиПоДокументу(Движения, ПериодРегистрации, ИсправленныйДокумент, Сотрудники, Записывать);
	
КонецПроцедуры 

// Проверяет, что сотрудник, указанный в документе работает в период отсутствия.
//
// Параметры:
//		Объект	- ДокументОбъект.ОтпускБезСохраненияОплаты
//		Отказ	- Булево
//
Процедура ПроверитьРаботающих(Объект, Отказ) Экспорт
	
	Если Объект.ОтсутствиеВТечениеЧастиСмены Тогда
		НачалоПериода 		= НачалоДня(Объект.ДатаОтсутствия);
		ОкончаниеПериода	= КонецДня(Объект.ДатаОтсутствия);
	Иначе 	
		НачалоПериода 		= Объект.ДатаНачала;
		ОкончаниеПериода	= Объект.ДатаОкончания;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Организация)
		Или Не ЗначениеЗаполнено(Объект.Сотрудник)
		Или Не ЗначениеЗаполнено(НачалоПериода)
		Или Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Объект.Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ОкончаниеПериода;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект")
	);
	
КонецПроцедуры

Процедура ЗаполнитьДокументЗаполнения(ПараметрыОбновления = НеОпределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 100
	|	ОтпускБезСохраненияОплаты.Ссылка КАК Отпуск,
	|	Отпуска.Ссылка КАК ДокументЗаполнения
	|ИЗ
	|	Документ.ОтпускаСотрудников.Сотрудники КАК Отпуска
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтпускБезСохраненияОплаты КАК ОтпускБезСохраненияОплаты
	|		ПО Отпуска.Сотрудник = ОтпускБезСохраненияОплаты.Сотрудник
	|			И Отпуска.ВидОтпуска = ОтпускБезСохраненияОплаты.ВидОтпуска
	|			И Отпуска.ДатаНачала = ОтпускБезСохраненияОплаты.ДатаНачала
	|			И Отпуска.ДатаОкончания = ОтпускБезСохраненияОплаты.ДатаОкончания
	|ГДЕ
	|	НЕ Отпуска.Ссылка.ПометкаУдаления
	|	И НЕ ОтпускБезСохраненияОплаты.Ссылка.ПометкаУдаления
	|	И ОтпускБезСохраненияОплаты.ДокументЗаполнения = ЗНАЧЕНИЕ(Документ.ОтпускаСотрудников.ПустаяСсылка)";
	
	Если ПараметрыОбновления = НеОпределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, " ПЕРВЫЕ 100", "");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	Иначе
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Отпуск = Выборка.Отпуск;
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "Документ.ОтпускБезСохраненияОплаты", "Ссылка", Отпуск) Тогда
				Продолжить;
			КонецЕсли;
			
			ДокументОбъект = Отпуск.ПолучитьОбъект();
			ДокументОбъект.ДокументЗаполнения = Выборка.ДокументЗаполнения;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
			
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьИсходныеДанныеПерерасчетов(ПараметрыОбновления) Экспорт

	ПараметрыЗаполнения = ПерерасчетЗарплаты.ПараметрыЗаполненияИсходныхДанныхПерерасчетов();
	ПерерасчетЗарплаты.ЗаполнитьИсходныеДанныеПерерасчетов(ПараметрыОбновления, Метаданные.Документы.ОтпускБезСохраненияОплаты, ПараметрыЗаполнения);

КонецПроцедуры

#Область ПараметрыВыбораНачислений

Функция ДополнительныеПараметрыВыбораНачислений(Документ, ПутьКРеквизиту) Экспорт
	Результат = Новый Соответствие;
	
	Если ПутьКРеквизиту = "ВидРасчета" Тогда
		ВидВремени = Перечисления.ВидыРабочегоВремениСотрудников.ВидВремениДокументовОтклонений(Документ.ОтсутствиеВТечениеЧастиСмены);
	КонецЕсли;
	
	Результат.Вставить("Отбор.ВидВремени", ВидВремени);
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли