
#Область ПрограммныйИнтерфейс

// Получает "заказанные" значения по умолчанию.
// Параметры: 
//		ПолучаемыеЗначения - структура элементы которой имеют 
//			имена, идентифицирующие получаемые значения.
//			Могут быть переданы имена значений:
//				Организация - организация по умолчанию.
//				Руководитель - руководитель организации.
//				ГлавныйБухгалтер - главбух организации.
//				ДолжностьРуководителя - должность руководителя организации.
//				Подразделение - подразделение по умолчанию.
//		
//		ДатаЗначений - Дата, на которую получаются значения по умолчанию.
//		
// В процедуре значения элементов структуры ПолучаемыеЗначения должны быть заполнены 
// значениями, если это возможно. Если невозможно, то остается то значение, которое 
// было передано в структуре.
Процедура ПолучитьЗначенияПоУмолчанию(ПолучаемыеЗначения, ДатаЗначений) Экспорт
	
	Если ПолучаемыеЗначения.Свойство("Организация") И НЕ ЗначениеЗаполнено(ПолучаемыеЗначения.Организация) Тогда
		ПолучаемыеЗначения.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	Если Не ПолучаемыеЗначения.Свойство("Организация") Тогда
		Возврат;
	КонецЕсли;
	ОтветственныеЛицаСервер.СведенияОбОтветственныхЛицахЗарплатаИКадры(
		ПолучаемыеЗначения.Организация,
		ПолучаемыеЗначения,
		ДатаЗначений);
	
КонецПроцедуры

// Возвращает признак того, что организация применяет УСН.
//
// Параметры:
//			Организация
//
// Возвращаемое значение:
//			Булево - Истина, если применяется упрощенная система налогообложения.
//
Функция ОрганизацияНаУпрощеннойСистемеНалогообложения(Организация, Период = Неопределено) Экспорт
	
	Если Период = Неопределено Тогда
		
		Сведения = Новый СписокЗначений;
		Сведения.Добавить("", "ДатаПереходаНаУСН");
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
		Организация, ТекущаяДатаСеанса(), Сведения);
		
		Возврат ЗначениеЗаполнено(СведенияОбОрганизации.ДатаПереходаНаУСН);
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

// Предназначена для заполнения в документах реквизита Организация единственной организацией при однофирменном учете.
//
Процедура ЗаполнитьРеквизитОрганизацияПриОднофирменномУчете(Источник, СтандартнаяОбработка, ИмяРеквизитаОрганизация) Экспорт 
	
КонецПроцедуры	

// Позволяет запретить изменение признака «Это обособленное подразделение» в форме подразделения.
//
// Параметры:
// 	ДоступностьИзменения - булево, если в теле процедуры установить значение Ложь, 
// 		установка признака станет недоступна в форме подразделения.
// 
Процедура УстановитьДоступностьИзмененияЭтоОбособленноеПодразделениеВФормеПодразделения(ДоступностьИзменения) Экспорт
	ДоступностьИзменения = Ложь;
КонецПроцедуры

// Дополняет коллекцию соответствий видов контактной информации с типом Адрес, в
// зависимости от типа объекта, содержащего контактную информацию.
//
// Параметры:
//		СоответствиеАдресовОрганизаций	- Соответствие
//			* Ключ 		- Тип, тип владельца контактной информации.
//			* Значение	- Соответствие.
//				* Ключ		- СправочникСсылка.ВидыКонтактнойИнформации
//				* Значение	- СправочникСсылка.ВидыКонтактнойИнформации
//						(значение выбирается из видов контактной информации организаций:
//							ФактАдресОрганизации или ЮрАдресОрганизации).
// Пример:
//		СоответствиеВидов = Новый Соответствие;
//		СоответствиеВидов.Вставить(Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица, Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
//		СоответствиеВидов.Вставить(Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
//		СоответствиеАдресовОрганизаций.Вставить(Тип("СправочникСсылка.ФизическиеЛица"), СоответствиеВидов);
//
Процедура ДополнитьСоответствиеАдресовОрганизаций(СоответствиеАдресовОрганизаций) Экспорт
	
	СоответствиеВидов = Новый Соответствие;
	СоответствиеВидов.Вставить(Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица, Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	СоответствиеВидов.Вставить(Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	
	СоответствиеАдресовОрганизаций.Вставить(Тип("СправочникСсылка.ФизическиеЛица"), СоответствиеВидов);
	
КонецПроцедуры

// Переопределяет коллекции ссылок на объекты содержащие контактную информацию организаций.
// При переопределении объектов, переопределяемые объекты:
//		1. должны быть исключены из коллекции с типом справочника Организации
//		2. поделены на коллекции (соответствия) где ключ - ссылка на объект с контактной информацией,
//			а значение СправочникСсылка.Организация
//		3. полученные коллекции должны быть добавлены в КоллекцияПоТипам с ключом
//			соответствующим типу содержащихся в коллекции объектов.
//
// Параметры:
//		КоллекцияПоТипам - Соответствие - содержит единственный элемент КлючИЗначение
//			с ключем тип СправочникСсылка.Организации и значением - массив ссылок
//			на организации.
//
//
Процедура ОпределитьТипыВладельцевАдресовОрганизаций(КоллекцияПоТипам) Экспорт
	
	Организации = КоллекцияПоТипам.Получить(Тип("СправочникСсылка.Организации"));
	
	СписокИндивидуальныхПредпринимателей = Новый Массив;
	СоотвествиеИндивидуальныхПредпринимателейОрганизациям = Новый Соответствие;
	
	РеквизитыОрганизаций = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Организации, "ЮридическоеФизическоеЛицо,ИндивидуальныйПредприниматель");
	Для каждого ОписаниеОрганизации Из РеквизитыОрганизаций Цикл
		
		Если ОписаниеОрганизации.Значение.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
			
			СписокИндивидуальныхПредпринимателей.Добавить(ОписаниеОрганизации.Ключ);
			СоотвествиеИндивидуальныхПредпринимателейОрганизациям.Вставить(ОписаниеОрганизации.Значение.ИндивидуальныйПредприниматель, ОписаниеОрганизации.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если СписокИндивидуальныхПредпринимателей.Количество() > 0 Тогда
		
		КоллекцияПоТипам.Вставить(Тип("СправочникСсылка.ФизическиеЛица"), СоотвествиеИндивидуальныхПредпринимателейОрганизациям);
		Для каждого ИндифидуальныйПредприниматель Из СписокИндивидуальныхПредпринимателей Цикл
			ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(Организации, ИндифидуальныйПредприниматель);
		КонецЦикла;
		
		Если Организации.Количество() = 0 Тогда
			КоллекцияПоТипам.Удалить(Тип("СправочникСсылка.Организации"));
		Иначе
			КоллекцияПоТипам.Вставить(Тип("СправочникСсылка.Организации"), Организации);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Переопределяет основной режим выполнения обработчиков Зарплатно-кадровой библиотеки.
// По умолчанию основной режим обработчиков Зарплатно-кадровой библиотеки - "Монопольно".
//
// Параметры:
//	РежимОбновления - строка, см. описание ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//					Значения, допустимые для установки параметру: "Монопольно", "Отложенно".
// 
//
Процедура УстановитьОсновнойРежимВыполненияОбновления(РежимОбновления) Экспорт
	
КонецПроцедуры

// Переопределяет имя клиентского приложения, используемое в запросах к веб-сервисам.
// Подробнее см. ЗарплатаКадры.ИмяКлиентскогоПриложения.
//
// Параметры:
//	ИмяПриложения - Строка - имя клиентского приложения, User-Agent,
//	СтандартнаяОбработка - Булево - признак формирования имени по умолчанию.
//
Процедура ПриОпределенииИмениКлиентскогоПриложения(ИмяПриложения, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Варианты отчетов

// Определяет разделы, в которых доступна панель отчетов.
//
// Параметры:
//   Разделы (Массив) из (ОбъектМетаданных)
//
// Описание:
//   В Разделы необходимо добавить метаданные подсистем тех разделов,
//   в которых размещены команды вызова панелей отчетов.
//
// Например:
//	Разделы.Добавить(Метаданные.Подсистемы.ИмяПодсистемы);
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Кадры, НСтр("ru = 'Кадровые отчеты';
														|en = 'Personnel reports'"));
	Разделы.Добавить(Метаданные.Подсистемы.Зарплата, НСтр("ru = 'Отчеты по зарплате';
															|en = 'Payroll reports'"));
	Разделы.Добавить(Метаданные.Подсистемы.Зарплата.Подсистемы.ВыплатыПеречисления, НСтр("ru = 'Отчеты по выплатам';
																						|en = 'Payment reports'"));
	Разделы.Добавить(Метаданные.Подсистемы.Зарплата.Подсистемы.НалогиИВзносы, НСтр("ru = 'Отчеты по налогам и взносам';
																					|en = 'Tax and contribution reports'"));
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадрыРасширенная") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("КонфигурацииЗарплатаКадрыРасширенный");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
