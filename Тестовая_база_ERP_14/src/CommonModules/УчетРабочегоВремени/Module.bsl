#Область ПрограммныйИнтерфейс

// Регистрирует рабочее время в переданной коллекции движений.
//
// 	Параметры: 
//		Движения - коллекция движений, обязательно содержащая набор записей
//				   регистра накопления ДанныеОперативногоУчетаРабочегоВремениСотрудников.
//		ДанныеОВремени - таблица значений с колонками.
//			Дата  - конкретная дата на которую регистрируется время или любая 
//					(например, первое число) дата месяца в том случае, если 
//					регистрируются данные в целом за месяц (ВЦеломЗаПериод - истина).
//			Сотрудник
//			ВидВремени (не обязательно) - если колонки нет, то считается, что это - Явка.
//			Дней (не обязательно) - требуется только если ВЦеломЗаПериод - истина.
//			Часов (не обязательно)
//			План (не обязательно) - булево, признак того, что регистрируется плановое время
//									если колонки нет, то считается, что регистрируется 
//									фактическое время.
//			Внутрисменное (не обязательно) - булево, признак того, что регистрируется 
//											 внутрисменное время. Если колонки нет, то 
//											 считается, что регистрируется целосменное время.
//			ВЦеломЗаПериод (не обязательно) - булево, признак того, что регистрируется время в
//							 				  целом за месяц. Если колонки нет, то регистрируются 
//											  данные на переданную дату. Если ВЦеломЗаПериод 
//											  не передано или Ложь, то колонка Дней не может быть больше 1.
//		ПериодРегистрации - месяц в котором регистрируются данные, если не указан то считается что данные 
//							регистрируются в том же месяце за который вводятся.
//
// Например, 
// - Если переданы только колонки Дата и Сотрудник, то это значит, что 
//   переданные даты - целые, полностью отработанные, рабочие дни.
// - Если переданы колонки Дата, Сотрудник, Дней и ВЦеломЗаПериод заполнена как Истина, то это 
//   значит, что передано количество полностью отработанных дней в том месяце, который 
//	 соответствует переданной дате.
Процедура ЗарегистрироватьРабочееВремяСотрудников(Движения, ДанныеОВремени, ПериодРегистрации = '00010101') Экспорт
	
	УчетРабочегоВремениВнутренний.ЗарегистрироватьРабочееВремяСотрудников(Движения, ДанныеОВремени, ПериодРегистрации);
	
КонецПроцедуры

// Возвращает пустую таблицы, необходимой для метода ЗарегистрироватьРабочееВремяСотрудников структуры.
//
// Возвращаемое значение
//	Таблица значений с полями:
// 		Дата
//		Сотрудник
//	    ВидВремени
//		ВидВремениВытесняемый
//		Дней
//		Часов
//		План
//		Внутрисменное
//		ВЦеломЗаПериод
Функция ТаблицаДляРегистрацииВремени() Экспорт
	
	Возврат УчетРабочегоВремениВнутренний.ТаблицаДляРегистрацииВремени();
	
КонецФункции

// Проверяет регистрируемые данные о фактическом времени времени. 
//  Данный метод должен вызваться в обработчике ОбработкаПроверкиЗаполнения	
//  документа-регистратора данных о времени.
//
// 	Параметры:
//		Регистратор - ссылка на документ регистратор.
//		ДанныеОВремени - таблица значений с колонками.
//			Дата  - конкретная дата на которую регистрируется время или любая 
//					(например, первое число) дата месяца в том случае, если 
//					регистрируются данные в целом за месяц (ВЦеломЗаПериод - истина).
//			Сотрудник
//			ВидВремени (не обязательно) - если колонки нет, то считается, что это - Явка.
//			Дней (не обязательно) - если не задано, то считается что на каждую дату регистрируется по одному дню.
//			Часов (не обязательно)
//			ВЦеломЗаПериод -  (не обязательный, по умолчанию ложь).
//		Отказ - булево, признак наличия ошибок.
//		ВыводитьОшибкиПользователю - булево, необязательный. Признак необходимости выводить ошибки в виде сообщений
//		                             пользователю.
//		ПериодРегистрации - необязательный. Период регистрации данных о времени.
//
//	Возвращаемое значение:
//		Массив структур с полями:  
//			Сотрудник - сотрудник, по которому регистрируется время.
//			Дата - дата, за которую введено некорректное значение.
//			ВидВремени - не корректно введенный вид времени (может быть пустым).
//			Документ - ссылка на документ, записи которого противоречат вводимым данным (может быть пустым).
//			ТекстОшибки - текст ошибки.
//			
Функция ПроверитьРегистрируемыеДанныхОВремени(Регистратор, ДанныеОВремени, Отказ = Ложь, ВыводитьОшибкиПользователю = Ложь, ПериодРегистрации = Неопределено) Экспорт
	
	Возврат УчетРабочегоВремениВнутренний.ПроверитьРегистрируемыеДанныхОВремени(Регистратор, ДанныеОВремени, Отказ, ВыводитьОшибкиПользователю, ПериодРегистрации);
	
КонецФункции

// Регистрирует сторно записи в регистре накопления учета времени.
//
//	 Параметры: 
//		Движения - КоллекцияДвижений - наборы записей регистров учета времени.
//		ПериодРегистрации - Дата - период регистрации сторно записей (начало месяца).
//		ИсправляемыйДокумент - документ по которому регистрируются сторно записи.
//      Сотрудники - Массив - Сотрудники, по которым необходимо зарегистрировать сторно-записи. 
//                            Если параметр не передан, то будут сторнированы все движения исправляемого документа
//                            по регистру накопления учета рабочего времени.
//    	Записывать - Булево - Если Истина, то наборы будут записаны сразу. 
//					          Если Ложь - наборам будет установлен признак Записывать = Истина.
//                            По умолчанию Ложь.
//				
//
Процедура ЗарегистрироватьСторноЗаписиПоДокументу(Движения, ПериодРегистрации, ИсправляемыйДокумент, Сотрудники = Неопределено, Записывать = Ложь) Экспорт
	
	УчетРабочегоВремениВнутренний.ЗарегистрироватьСторноЗаписиПоДокументу(Движения, ПериодРегистрации, ИсправляемыйДокумент, Сотрудники, Записывать);
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ВидыИспользованияРабочегоВремениОбработкаПроверкиЗаполнения(ПроверяемыйОбъект, Отказ, ПроверяемыеРеквизиты, СтандартнаяОбработка) Экспорт
	
	УчетРабочегоВремениВнутренний.ВидыИспользованияРабочегоВремениОбработкаПроверкиЗаполнения(ПроверяемыйОбъект, Отказ, ПроверяемыеРеквизиты, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ВидыИспользованияРабочегоВремениОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	УчетРабочегоВремениВнутренний.ВидыИспользованияРабочегоВремениОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ВидыИспользованияРабочегоВремениУстановитьДоступностьЭлементов(Форма) Экспорт
	
	УчетРабочегоВремениВнутренний.ВидыИспользованияРабочегоВремениУстановитьДоступностьЭлементов(Форма);
	
КонецПроцедуры

Функция СоздатьОписаниеВидаВремени() Экспорт
	
	Возврат Новый Структура("ИмяПредопределенныхДанных, БуквенныйКод, БуквенныйКодБюджетный, БуквенныйКодБюджетный2009, Наименование, ЦифровойКод, ПолноеНаименование, РабочееВремя, Целосменное, ОсновноеВремя");	
	
КонецФункции

Функция НовыйВидИспользованияРабочегоВремени(ОписаниеВидаВремени) Экспорт
	
	ВидВремени = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени." + ОписаниеВидаВремени.ИмяПредопределенныхДанных);
	
	Если ЗначениеЗаполнено(ВидВремени) Тогда
		ВидВремениОбъект = ВидВремени.ПолучитьОбъект();
		ВидВремениОбъект.НеИспользуется = Ложь;
		ВидВремениСсылка = ВидВремениОбъект.Ссылка;
	Иначе
		ВидВремениОбъект = Справочники.ВидыИспользованияРабочегоВремени.СоздатьЭлемент();
		ВидВремениСсылка = Справочники.ВидыИспользованияРабочегоВремени.ПолучитьСсылку();
		ВидВремениОбъект.УстановитьСсылкуНового(ВидВремениСсылка);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ВидВремениОбъект, ОписаниеВидаВремени);
	
	Если Не ЗначениеЗаполнено(ВидВремениОбъект.ОсновноеВремя) Тогда
		ВидВремениОбъект.ОсновноеВремя = ВидВремениСсылка;
	КонецЕсли;
	
	ВидВремениОбъект.Записать();
	
	Возврат ВидВремениОбъект;

КонецФункции

Процедура ОтключитьИспользованиеПредопределенногоЭлемента(ИмяПредопределенныхДанных) Экспорт
	
	Ссылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени." + ИмяПредопределенныхДанных);
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		Объект = Ссылка.ПолучитьОбъект();
		
		Попытка
			Объект.Заблокировать();
		Исключение
			
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно изменить Виды использования рабочего времени """"%2"""". Возможно, объект редактируется другим пользователем';
					|en = 'Cannot change """"%2"""" Working time usage kinds. Maybe, the object is being edited by another user'"),
				Объект.Наименование);
			
			ВызватьИсключение ТекстИсключения;
			
		КонецПопытки;
		Объект.НеИспользуется = Истина;
		Объект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриСозданииФормыСпискаСправочникаВидыИспользованияРабочегоВремени(Форма, Параметры) Экспорт
	
	УчетРабочегоВремениВнутренний.ПриСозданииФормыСпискаСправочникаВидыИспользованияРабочегоВремени(Форма, Параметры);
	
КонецПроцедуры

#Область ВыводУнифицированнойФормыТ13

Процедура ВывестиУнифицированнуюФормуТ13(ДокументРезультат, ДанныеТ13) Экспорт
	
	ИмяМакета = "ОбщийМакет.ПФ_MXL_УнифицированнаяФормаТ13";
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	НастройкиПечатныхФорм  = ЗарплатаКадры.НастройкиПечатныхФорм();
	РеквизитыВидовРабочегоВремени = ДанныеОВидахИспользованияРабочегоВремени();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы(ИмяМакета);
	
	ДанныеПечати = УправлениеПечатьюБЗК.ПараметрыОбластейСтандартногоМакета(ИмяМакета);
	
	Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	// Шапка отчета
	МакетШапки   = Макет.ПолучитьОбласть("Шапка");
	МакетПодвала = Макет.ПолучитьОбласть("Подвал");

	ДанныеПечати.Шапка.ДатаЗаполнения = ДанныеТ13.ДатаДокумента;
	
	Если ДанныеТ13.ВыводитьСообщениеОНеприменимостиПечатнойФормы Тогда
		
		ДанныеПечати.Шапка.СообщениеОНеприменимостиПечатнойФормы = 
			ЗарплатаКадры.СообщениеОНеприменимостиПечатнойФормы(
				ДанныеТ13.ДатаДокумента,
				'20150619',
				НСтр("ru = 'Приказа Минфина РФ';
					|en = 'Order of the Ministry of Finance of the Russian Federation'"),
				'20150330',
				"52н");
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(ДанныеТ13.Организация) Тогда
		
		СведенияОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеТ13.Организация, "НаименованиеПолное, КодПоОКПО");
		ДанныеПечати.Шапка.ОрганизацияНаименование = СведенияОрганизации.НаименованиеПолное;
		ДанныеПечати.Шапка.ОрганизацияКодПоОКПО    = СведенияОрганизации.КодПоОКПО;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеТ13.Подразделение) Тогда
		
		Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений Тогда
			ДанныеПечати.Шапка.ПодразделениеНаименование = ДанныеТ13.Подразделение.ПолноеНаименование();
		Иначе
			ДанныеПечати.Шапка.ПодразделениеНаименование = Строка(ДанныеТ13.Подразделение);
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ДанныеПечати.Шапка.ДатаНачала = ДанныеТ13.Месяц;
	ДанныеПечати.Шапка.ДатаОкончания = КонецМесяца(ДанныеТ13.Месяц);
	
	Если ЗначениеЗаполнено(ДанныеТ13.НомерДокумента) Тогда
		
		Если НастройкиПечатныхФорм.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов Тогда
			ДанныеПечати.Шапка.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеТ13.НомерДокумента, Истина, Истина);
		Иначе
			ДанныеПечати.Шапка.НомерДокумента = ДанныеТ13.НомерДокумента;
		КонецЕсли;
		
	КонецЕсли;
	
	МакетШапки.Параметры.Заполнить(ДанныеПечати.Шапка);
	ДокументРезультат.Вывести(МакетШапки);
	
	МакетШапкиТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	
	ДокументРезультат.Вывести(МакетШапкиТаблицы);
	
	// Сбор сведений о сотрудниках
	СписокСотрудников = Новый Массив;
	Для каждого ДанныеСотрудника Из ДанныеТ13.ДанныеСотрудников Цикл
		СписокСотрудников.Добавить(ДанныеСотрудника.Сотрудник);
	КонецЦикла;
	
	Если НастройкиПечатныхФорм.ВыводитьПолныеФИОВСписочныхПечатныхФормах Тогда
		КадровыеДанные = "ФИОПолные";
	Иначе
		КадровыеДанные = "Фамилия,Имя,Отчество";
	КонецЕсли;
	
	КадровыеДанные = КадровыеДанные + ",ТабельныйНомер";
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СписокСотрудников, КадровыеДанные, ДанныеТ13.ДатаДокумента);
	
	НомерПП = 1;
	Для каждого ДанныеСотрудника Из ДанныеТ13.ДанныеСотрудников Цикл
		
		МакетСтроки = Макет.ПолучитьОбласть("Строка");
		
		ОбщегоНазначенияБЗККлиентСервер.ОчиститьЗначенияСтруктуры(ДанныеПечати.Строка);
		
		// Вывод строки сотрудника
		ДанныеПечати.Строка.НомерПП = НомерПП;
		
		КадровыеДанныеСотрудника = КадровыеДанные.Найти(ДанныеСотрудника.Сотрудник, "Сотрудник");
		Если КадровыеДанныеСотрудника <> Неопределено Тогда
			
			ДанныеПечати.Строка.ТабельныйНомер = ЗарплатаКадрыОтчеты.ТабельныйНомерНаПечать(КадровыеДанныеСотрудника.ТабельныйНомер);
			
			Если НастройкиПечатныхФорм.ВыводитьПолныеФИОВСписочныхПечатныхФормах Тогда
				ДанныеПечати.Строка.Сотрудник = КадровыеДанныеСотрудника.ФИОПолные;
			Иначе
				
				ФИО = Новый Структура("Фамилия,Имя,Отчество");
				ЗаполнитьЗначенияСвойств(ФИО, КадровыеДанныеСотрудника);
				ДанныеПечати.Строка.Сотрудник = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИО);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеСотрудника.Должность) Тогда
			ДанныеПечати.Строка.Сотрудник = Строка(ДанныеПечати.Строка.Сотрудник) + Символы.ПС + "(" + ДанныеСотрудника.Должность + ")";
		КонецЕсли;
		
		// Сбор сведений и вывод информации о календарных днях
		ДниЗаМесяц = 0;
		ЧасыЗаМесяц = 0;
		ДниПерваяПоловина = 0;
		ЧасыПерваяПоловина = 0;
		ДниВтораяПоловина = 0;
		ЧасыВтораяПоловина = 0;
		
		ОтклоненияПоСотруднику = Новый ТаблицаЗначений;
		ОтклоненияПоСотруднику.Колонки.Добавить("ВидВремени");
		ОтклоненияПоСотруднику.Колонки.Добавить("БуквенныйКод");
		ОтклоненияПоСотруднику.Колонки.Добавить("Часов");
		ОтклоненияПоСотруднику.Колонки.Добавить("Дней");
		
		Дни = Новый Соответствие;
		Для каждого ДанныеОВремени Из ДанныеСотрудника.ДанныеКалендарныхДней Цикл
			
			ДанныеОДне = Дни.Получить(День(ДанныеОВремени.Дата));
			Если ДанныеОДне = Неопределено Тогда
				ДанныеОДне = Новый Массив;
			КонецЕсли;
			
			ДанныеОДне.Добавить(Новый Структура("ВидРабочегоВремени,Часы", ДанныеОВремени.ВидРабочегоВремени, ДанныеОВремени.Часы));
			
			Дни.Вставить(День(ДанныеОВремени.Дата), ДанныеОДне);
			
		КонецЦикла;
		
		Для НомерДня = 1 По 31 Цикл
			
			ДанныеДня = Дни.Получить(НомерДня);
			Если ДанныеДня <> Неопределено Тогда
				
				Символ = "";
				ДополнительноеЗначение = "";
				ДобавитьРазделитель = Ложь;
				
				Для каждого ДанныеВремени Из ДанныеДня Цикл
					
					Если ДобавитьРазделитель Тогда
						Символ = Символ + "/";
						ДополнительноеЗначение = ДополнительноеЗначение + "/";
					Иначе
						ДобавитьРазделитель = Истина;
					КонецЕсли;
					
					БуквенныйКод = РеквизитыВидовРабочегоВремени.Получить(ДанныеВремени.ВидРабочегоВремени).БуквенныйКод;
					Символ = Символ + БуквенныйКод;
					
					ДополнительноеЗначение = ДополнительноеЗначение + Формат(ДанныеВремени.Часы, "");
					
					Если ЗначениеЗаполнено(ДанныеВремени.ВидРабочегоВремени)
						И ДанныеВремени.ВидРабочегоВремени <> Справочники.ВидыИспользованияРабочегоВремени.ВыходныеДни
						И Не РеквизитыВидовРабочегоВремени.Получить(ДанныеВремени.ВидРабочегоВремени).РабочееВремя Тогда
						
						ОтклоненияПоВидуВремени = ОтклоненияПоСотруднику.Добавить();
						
						ОтклоненияПоВидуВремени.ВидВремени = ДанныеВремени.ВидРабочегоВремени;
						ОтклоненияПоВидуВремени.БуквенныйКод = БуквенныйКод;
						ОтклоненияПоВидуВремени.Дней = 1;
						
						ОтклоненияПоВидуВремени.Часов = ДанныеВремени.Часы;
						
					КонецЕсли;
					
					Если ДанныеВремени.Часы > 0 Тогда
						
						ДниЗаМесяц = ДниЗаМесяц + 1;
						ЧасыЗаМесяц = ЧасыЗаМесяц + ДанныеВремени.Часы;
						
						Если НомерДня < 16 Тогда
							
							ДниПерваяПоловина = ДниПерваяПоловина + 1;
							ЧасыПерваяПоловина = ЧасыПерваяПоловина + ДанныеВремени.Часы;
							
						Иначе
							
							ДниВтораяПоловина = ДниВтораяПоловина + 1;
							ЧасыВтораяПоловина = ЧасыВтораяПоловина + ДанныеВремени.Часы;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
				ДанныеПечати.Строка["Символ" + НомерДня]                 = Символ;
				ДанныеПечати.Строка["ДополнительноеЗначение" + НомерДня] = ДополнительноеЗначение;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ДанныеПечати.Строка.ДниПерваяПоловина = ДниПерваяПоловина;
		ДанныеПечати.Строка.ЧасыПерваяПоловина = ЧасыПерваяПоловина;
		ДанныеПечати.Строка.ДниВтораяПоловина = ДниВтораяПоловина;
		ДанныеПечати.Строка.ЧасыВтораяПоловина = ЧасыВтораяПоловина;
		ДанныеПечати.Строка.ДниЗаМесяц = ДниЗаМесяц;
		ДанныеПечати.Строка.ЧасыЗаМесяц = ЧасыЗаМесяц;
		
		// СборИнформации и вывод сведений о неявках
		
		ОтклоненияПоСотруднику.Свернуть("ВидВремени, БуквенныйКод", "Дней, Часов");
		
		СчетчикОтклонений = 1;
		Для Каждого ОтклонениеПоВидуВремени Из ОтклоненияПоСотруднику Цикл
			
			Если СчетчикОтклонений > 8 Тогда
				Прервать;
			КонецЕсли;
			
			ДанныеПечати.Строка["НеявкаКод" + СчетчикОтклонений]     = ОтклонениеПоВидуВремени.БуквенныйКод;
			ДанныеПечати.Строка["НеявкаДниЧасы" + СчетчикОтклонений] = Формат(ОтклонениеПоВидуВремени.Дней, "ЧГ=") + 
				?(ОтклонениеПоВидуВремени.Часов > 0, "(" + Формат(ОтклонениеПоВидуВремени.Часов, "ЧГ=") + ")", "");
			
			СчетчикОтклонений = СчетчикОтклонений + 1;
			
		КонецЦикла;
		
		МакетСтроки.Параметры.Заполнить(ДанныеПечати.Строка);
		ДокументРезультат.Вывести(МакетСтроки);
		
		НомерПП = НомерПП + 1;
		
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ДанныеПечати.Подвал, ДанныеТ13);
	
	СписокОтветственных = Новый Массив;
	Если ЗначениеЗаполнено(ДанныеТ13.Ответственный) Тогда
		СписокОтветственных.Добавить(ДанныеТ13.Ответственный);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеТ13.Руководитель) Тогда
		СписокОтветственных.Добавить(ДанныеТ13.Руководитель);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеТ13.Кадровик) Тогда
		СписокОтветственных.Добавить(ДанныеТ13.Кадровик);
	КонецЕсли;
	
	Если СписокОтветственных.Количество() > 0 Тогда
		
		ПредставленияПодписантов = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, СписокОтветственных, "ИОФамилия");
		Для каждого ПредставлениеПодписанта Из ПредставленияПодписантов Цикл
			
			Если ПредставлениеПодписанта.ФизическоеЛицо = ДанныеТ13.Ответственный Тогда
				ДанныеПечати.Подвал.ФИООтветственного = ПредставлениеПодписанта.ИОФамилия;
			КонецЕсли;
			
			Если ПредставлениеПодписанта.ФизическоеЛицо = ДанныеТ13.Руководитель Тогда
				ДанныеПечати.Подвал.ФИОРуководителя = ПредставлениеПодписанта.ИОФамилия;
			КонецЕсли;
			
			Если ПредставлениеПодписанта.ФизическоеЛицо = ДанныеТ13.Кадровик Тогда
				ДанныеПечати.Подвал.ФИОКадровика = ПредставлениеПодписанта.ИОФамилия;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	МакетПодвала.Параметры.Заполнить(ДанныеПечати.Подвал);
	ДокументРезультат.Вывести(МакетПодвала);
	
КонецПроцедуры

Функция ДанныеОбОрганизацииПодразделенииДляТ13() Экспорт
	
	ДанныеОбОрганизации = Новый Структура;
	
	ДанныеОбОрганизации.Вставить("Месяц", '00010101');
	ДанныеОбОрганизации.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	ДанныеОбОрганизации.Вставить("Подразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	ДанныеОбОрганизации.Вставить("ВыводитьСообщениеОНеприменимостиПечатнойФормы", Истина);
	ДанныеОбОрганизации.Вставить("НомерДокумента", "");
	ДанныеОбОрганизации.Вставить("ДатаДокумента", ОбщегоНазначения.ТекущаяДатаПользователя());
	ДанныеОбОрганизации.Вставить("Ответственный", Справочники.ФизическиеЛица.ПустаяСсылка());
	ДанныеОбОрганизации.Вставить("ДолжностьОтветственного", Справочники.Должности.ПустаяСсылка());
	ДанныеОбОрганизации.Вставить("Руководитель", Справочники.ФизическиеЛица.ПустаяСсылка());
	ДанныеОбОрганизации.Вставить("ДолжностьРуководителя", Справочники.Должности.ПустаяСсылка());
	ДанныеОбОрганизации.Вставить("Кадровик", Справочники.ФизическиеЛица.ПустаяСсылка());
	ДанныеОбОрганизации.Вставить("ДолжностьКадровика", Справочники.Должности.ПустаяСсылка());
	ДанныеОбОрганизации.Вставить("ДанныеСотрудников", Новый Массив);
	
	Возврат ДанныеОбОрганизации;
	
КонецФункции

Функция ДанныеОВремениСотрудникаДляТ13() Экспорт
	
	ДанныеОВремениСотрудника = Новый Структура;
	
	ДанныеОВремениСотрудника.Вставить("Сотрудник", Справочники.Сотрудники.ПустаяСсылка());
	ДанныеОВремениСотрудника.Вставить("Должность", Справочники.Должности.ПустаяСсылка());
	ДанныеОВремениСотрудника.Вставить("ДанныеКалендарныхДней", Новый Массив);
	
	Возврат ДанныеОВремениСотрудника;
	
КонецФункции

Функция ДанныеОРабочемВремениКалендарныхДней() Экспорт
	
	ДанныеОРабочемВремени = Новый Структура;
	
	ДанныеОРабочемВремени.Вставить("Дата", '00010101');
	ДанныеОРабочемВремени.Вставить("ВидРабочегоВремени", Справочники.ВидыИспользованияРабочегоВремени.ПустаяСсылка());
	ДанныеОРабочемВремени.Вставить("Часы", 0);
	
	Возврат ДанныеОРабочемВремени;
	
КонецФункции

Функция ДанныеОВидахИспользованияРабочегоВремени()
	
	ДанныеОВидахИспользованияВремени = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыИспользованияРабочегоВремени.Ссылка,
		|	ВидыИспользованияРабочегоВремени.БуквенныйКод,
		|	ВидыИспользованияРабочегоВремени.РабочееВремя
		|ИЗ
		|	Справочник.ВидыИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеВида = Новый Структура;
		ДанныеВида.Вставить("БуквенныйКод", Выборка.БуквенныйКод);
		ДанныеВида.Вставить("РабочееВремя", Выборка.РабочееВремя);
		
		ДанныеОВидахИспользованияВремени.Вставить(Выборка.Ссылка, ДанныеВида);
		
	КонецЦикла;
	
	Возврат ДанныеОВидахИспользованияВремени;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиОбновленияИнформационнойБазы

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.1.15";
	Обработчик.Процедура = "УчетРабочегоВремени.СоздатьВидыИспользованияРабочегоВремениПоНастройкам";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.1.15";
	Обработчик.Процедура = "УчетРабочегоВремени.ОтключитьНеИспользуемыеВидыИспользованияРабочегоВремени";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.9.2";
	Обработчик.Процедура = "УчетРабочегоВремени.СоздатьВидыИспользованияРабочегоВремениОтпускБезОплаты";
	Обработчик.НачальноеЗаполнение = Ложь;
	
КонецПроцедуры

// Процедура заполняет справочник показателей т.н. псевдопредопределенными элементами, 
// идентифицируемыми из кода.
//
Процедура СоздатьВидыИспользованияРабочегоВремениПоНастройкам(НастройкиРасчетаЗарплаты = Неопределено) Экспорт
	
	УчетРабочегоВремениВнутренний.СоздатьВидыИспользованияРабочегоВремениПоНастройкам(НастройкиРасчетаЗарплаты);
	
КонецПроцедуры

Процедура ОтключитьНеИспользуемыеВидыИспользованияРабочегоВремени() Экспорт
	
	УчетРабочегоВремениВнутренний.ОтключитьНеИспользуемыеВидыИспользованияРабочегоВремени();
	
КонецПроцедуры

Процедура СоздатьВидыИспользованияРабочегоВремениОтпускБезОплаты() Экспорт
	
	УчетРабочегоВремениВнутренний.СоздатьВидыИспользованияРабочегоВремениОтпускБезОплаты();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
