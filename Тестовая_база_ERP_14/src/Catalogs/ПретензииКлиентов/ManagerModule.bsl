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

// Добавляет команду создания объекта.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Справочники.ПретензииКлиентов) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Справочники.ПретензииКлиентов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Справочники.ПретензииКлиентов);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ФиксироватьПретензииКлиентов";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Используется в механизме взаимодействий. Возвращает клиента и участников сделки
//
// Параметры:
//  Ссылка  - СправочникСсылка.ПретензииКлиентов - претензия по которой получаются контакты.
//
// Возвращаемое значение:
//   Массив   - массив, содержащий контакты.
//
Функция ПолучитьКонтакты(Ссылка) Экспорт

	Возврат СделкиСервер.ПолучитьУчастниковПоТабличнойЧастиПредметаВзаимодействия(
		Ссылка, ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка,"Партнер"));

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Партнер)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователиПартнеры
	|	ПО ВнешниеПользователиПартнеры.ОбъектАвторизации = ЭтотСписок.Партнер
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
	|	ПО КонтактныеЛицаПартнеров.Владелец = ЭтотСписок.Партнер
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователиКонтактныеЛица
	|	ПО ВнешниеПользователиКонтактныеЛица.ОбъектАвторизации = КонтактныеЛицаПартнеров.Ссылка
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ВнешниеПользователиПартнеры.Ссылка)
	|	ИЛИ ЗначениеРазрешено(ВнешниеПользователиКонтактныеЛица.Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		СтандартнаяОбработка = Ложь;
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаЭлементаСамообслуживание";
		ИначеЕсли ВидФормы = "ФормаСписка" Тогда
			ВыбраннаяФорма = "ФормаСпискаСамообслуживание";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПретензияКлиента";
	КомандаПечати.Представление = НСтр("ru = 'Претензия клиента';
										|en = 'Customer claim'");

КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПретензияКлиента") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		                                                     "ПретензияКлиента",
		                                                     НСтр("ru = 'Претензия клиента';
																	|en = 'Customer claim'"),
		                                                     СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФорму(ПретензияКлиента, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПретензииКлиентов.Ссылка,
	|	ПретензииКлиентов.Наименование,
	|	ВЫБОР
	|		КОГДА ПретензииКлиентов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПретензийКлиентов.Зарегистрирована)
	|				ИЛИ ПретензииКлиентов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПретензийКлиентов.Обрабатывается)
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(ПретензииКлиентов.Статус)
	|		ИНАЧЕ &Рассмотрена
	|	КОНЕЦ КАК ПредставлениеСтатус,
	|	ПретензииКлиентов.Статус,
	|	ПретензииКлиентов.ОписаниеПретензии,
	|	ПретензииКлиентов.РезультатыОтработки,
	|	ПретензииКлиентов.ДатаРегистрации,
	|	ПретензииКлиентов.ДатаОкончания,
	|	ПретензииКлиентов.Ответственный
	|ИЗ
	|	Справочник.ПретензииКлиентов КАК ПретензииКлиентов
	|ГДЕ
	|	ПретензииКлиентов.Ссылка = &ПретензияКлиента";
	
	Если ТипЗнч(ПретензияКлиента) = Тип("Массив") Тогда
		Запрос.УстановитьПараметр("ПретензияКлиента", ПретензияКлиента[ПретензияКлиента.Количество() - 1]);
	Иначе
		Запрос.УстановитьПараметр("ПретензияКлиента", ПретензияКлиента);
	КонецЕсли;
	Запрос.УстановитьПараметр("Рассмотрена", НСтр("ru = 'Рассмотрена';
													|en = 'Reviewed'"));
	
	ЗаполнитьТабличныйДокументПретензияКлиента(ТабличныйДокумент, Запрос, ОбъектыПечати);
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументПретензияКлиента(ТабличныйДокумент, Запрос, ОбъектыПечати) Экспорт
	
	ДанныеПечати = Запрос.Выполнить().Выбрать();
	ДанныеПечати.Следующий();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ПретензииКлиентов.ПФ_MXL_ПретензияКлиента");

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");

	ОбластьЗаголовок.Параметры.ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДанныеПечати.Наименование + " %1 " + Формат(ДанныеПечати.ДатаРегистрации,"ДЛФ=DD"),НСтр("ru = 'от';
																																																|en = 'dated'"));
	
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок, ДанныеПечати.Ссылка);
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	Если ДанныеПечати.Статус = Перечисления.СтатусыПретензийКлиентов.Удовлетворена 
		ИЛИ ДанныеПечати.Статус = Перечисления.СтатусыПретензийКлиентов.НеУдовлетворена Тогда
	
		ОбластьРассмотрение = Макет.ПолучитьОбласть("Рассмотрение");
		ЗаполнитьЗначенияСвойств(ОбластьРассмотрение.Параметры, ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьРассмотрение);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
