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
		КомандыСозданияДокументов, Метаданные.Документы.ИзменениеКвалификационногоРазряда);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о присвоении разряда.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОПрисвоенииРазряда";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о присвоении разряда';
										|en = 'Category conferment order'");
	КомандаПечати.Порядок = 10;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказОПрисвоенииРазряда") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм, 
						"ПФ_MXL_ПриказОПрисвоенииРазряда", 
						НСтр("ru = 'Приказ о присвоении разряда';
							|en = 'Category conferment order'"), 
						ПечатнаяФормаПриказаОПрисвоенииРазряда(МассивОбъектов, ОбъектыПечати), ,
						"Документ.РаботаСверхурочно.ПФ_MXL_ПриказОПрисвоенииРазряда");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаПриказаОПрисвоенииРазряда(МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриказОПрисвоенииРазряда";
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИзменениеКвалификационногоРазряда.ПФ_MXL_ПриказОПрисвоенииРазряда");
	
	ОбластьШапка 	  = Макет.ПолучитьОбласть("Шапка");
	ОбластьРаботник   = Макет.ПолучитьОбласть("Работник");
	ОбластьПодвал 	  = Макет.ПолучитьОбласть("Подвал");
	
	ДанныеДляПечати = ДанныеДляПечатиПриказаОПрисвоенииРазряда(МассивОбъектов);
	
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	
	Пока ВыборкаПоДокументам.Следующий() Цикл  
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Параметры = ПолучитьСтруктуруПараметровПриказаОПрисвоенииРазряда();
		КадровыйУчет.ЗаполнитьПараметрыКадровогоПриказа(Параметры, ВыборкаПоДокументам);
		
		Параметры.ДатаИзменения = Формат(Параметры.ДатаИзменения, "ДЛФ=ДД");
		Параметры.ДатаДок = Формат(Параметры.ДатаДок, "ДЛФ=Д");
		
		Параметры.Должность = СклонениеПредставленийОбъектов.ПросклонятьПредставление(Строка(Параметры.Должность), 3, Параметры.Должность);
		
		ФИОВПадеже = Параметры.ФИОПолные;
		ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(Параметры.ФИОПолные), 3, ФИОВПадеже, ВыборкаПоДокументам.Пол);
		Параметры.ФИОПолные = ФИОВПадеже;		
		
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, Параметры);
		ЗаполнитьЗначенияСвойств(ОбластьРаботник.Параметры, Параметры);
		ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, Параметры);
		
		ОбластьПодвал.Параметры.ФИО = ВыборкаПоДокументам.ФамилияИО;
		
		ТабДокумент.Вывести(ОбластьШапка);
		ТабДокумент.Вывести(ОбластьРаботник);
		ТабДокумент.Вывести(ОбластьПодвал);
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции	

Функция ДанныеДляПечатиПриказаОПрисвоенииРазряда(МассивОбъектов)
	
	// Запрос по шапкам документов.
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИзменениеКвалификационногоРазряда.Ссылка КАК Ссылка,
	|	ИзменениеКвалификационногоРазряда.Дата КАК Дата,
	|	ИзменениеКвалификационногоРазряда.Номер КАК Номер,
	|	ИзменениеКвалификационногоРазряда.Сотрудник КАК Сотрудник,
	|	ИзменениеКвалификационногоРазряда.РазрядКатегория.Наименование КАК Разряд,
	|	ИзменениеКвалификационногоРазряда.ДатаИзменения КАК ДатаИзменения,
	|	ИзменениеКвалификационногоРазряда.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ИзменениеКвалификационногоРазряда.Организация.НаименованиеПолное, 1, 10) = """"
	|			ТОГДА ИзменениеКвалификационногоРазряда.Организация.Наименование
	|		ИНАЧЕ ИзменениеКвалификационногоРазряда.Организация.НаименованиеПолное
	|	КОНЕЦ КАК НазваниеОрганизации,
	|	ИзменениеКвалификационногоРазряда.Руководитель КАК Руководитель,
	|	ИзменениеКвалификационногоРазряда.ДолжностьРуководителя КАК ДолжностьРуководителя
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ИзменениеКвалификационногоРазряда КАК ИзменениеКвалификационногоРазряда
	|ГДЕ
	|	ИзменениеКвалификационногоРазряда.Ссылка В(&МассивОбъектов)";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТДанныеДокументов", "Сотрудник,ДатаИзменения");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "ФИОПолные, ФамилияИО, Должность, Пол");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Номер КАК НомерДок,
	|	ДанныеДокументов.Дата КАК ДатаДок,
	|	ДанныеДокументов.Сотрудник КАК Сотрудник,
	|	КадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные,
	|	КадровыеДанныеСотрудников.ФамилияИО КАК ФамилияИО,
	|	КадровыеДанныеСотрудников.Должность КАК Должность,
	|	КадровыеДанныеСотрудников.Пол КАК Пол,
	|	ДанныеДокументов.Разряд КАК Разряд,
	|	ДанныеДокументов.ДатаИзменения КАК ДатаИзменения,
	|	ДанныеДокументов.Организация КАК Организация,
	|	ДанныеДокументов.НазваниеОрганизации КАК НазваниеОрганизации,
	|	ДанныеДокументов.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителя,
	|	ФИООтветственныхЛиц.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИООтветственныхЛиц
	|		ПО ДанныеДокументов.Руководитель = ФИООтветственныхЛиц.ФизическоеЛицо
	|			И ДанныеДокументов.Ссылка = ФИООтветственныхЛиц.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ДанныеДокументов.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|			И ДанныеДокументов.ДатаИзменения = КадровыеДанныеСотрудников.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДок";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПечати = Новый Структура;
	ДанныеДляПечати.Вставить("РезультатПоШапке", РезультатЗапроса);
	
	Возврат ДанныеДляПечати;
	
КонецФункции

Функция ПолучитьСтруктуруПараметровПриказаОПрисвоенииРазряда()
	
	Параметры = КадровыйУчет.ПараметрыКадровогоПриказа();
	
	Параметры.Вставить("Сотрудник");
	Параметры.Вставить("ФИОПолные");
	Параметры.Вставить("Должность");
	Параметры.Вставить("Разряд");
	Параметры.Вставить("ДатаИзменения");
	
	Возврат Параметры;
	
КонецФункции

#Область ПроцедурыИФункцииМеханизмаМногофункциональныхДокументов

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	ФизическоеЛицо = ?(ЗначениеЗаполнено(Объект.Сотрудник), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Сотрудник, "ФизическоеЛицо"), Справочники.ФизическиеЛица.ПустаяСсылка());
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли	