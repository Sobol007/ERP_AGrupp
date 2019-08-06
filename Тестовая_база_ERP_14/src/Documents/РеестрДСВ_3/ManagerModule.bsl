
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
	|	ДляВсехСтрок( ЗначениеРазрешено(Сотрудники.Сотрудник, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
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
	
	МетаданныеДокумента = Метаданные.Документы.РеестрДСВ_3;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыгрузитьФайлыВоВременноеХранилище(Ссылка, УникальныйИдентификатор = Неопределено) Экспорт
	
	ДанныеФайла = ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);
	
	ОписаниеВыгруженногоФайла = ПерсонифицированныйУчет.ОписаниеВыгруженногоФайлаОтчетности();
	
	ОписаниеВыгруженногоФайла.Владелец = Ссылка;
	ОписаниеВыгруженногоФайла.АдресВоВременномХранилище = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
	ОписаниеВыгруженногоФайла.ИмяФайла = ДанныеФайла.ИмяФайла;
	ОписаниеВыгруженногоФайла.ПроверятьCheckXML = Истина;
	ОписаниеВыгруженногоФайла.ПроверятьCheckUFA = Истина;
	ОписаниеВыгруженногоФайла.ПроверятьПОПД = Истина;
	
	ВыгруженныеФайлы = Новый Массив;
	ВыгруженныеФайлы.Добавить(ОписаниеВыгруженногоФайла);
	
	Возврат ВыгруженныеФайлы;
	
КонецФункции

Функция ПолучитьСтруктуруПроверяемыхДанных() Экспорт
	Возврат ПерсонифицированныйУчет.ПолучитьСтруктуруПроверяемыхДанных();
КонецФункции

Функция ПолучитьПредставленияПроверяемыхРеквизитов() Экспорт
	Возврат ПерсонифицированныйУчет.ПолучитьПредставленияПроверяемыхРеквизитов();
КонецФункции

Функция ПолучитьСоответствиеРеквизитовФормеОбъекта(ДанныеДляПроверки) Экспорт
	Возврат ПерсонифицированныйУчет.ПолучитьСоответствиеРеквизитовФормеОбъекта();
КонецФункции

Функция ПолучитьСоответствиеРеквизитовПутиВФормеОбъекта() Экспорт
	
	СоответствиеРеквизитовПутиВФормеОбъекта = ПерсонифицированныйУчет.ПолучитьСоответствиеРеквизитовПутиВФормеОбъекта();
	
	Возврат СоответствиеРеквизитовПутиВФормеОбъекта;
	
КонецФункции

Функция ПолучитьСоответствиеПроверяемыхРеквизитовОткрываемымОбъектам(ДокументСсылка, ДанныеДляПроверки) Экспорт
	Возврат Новый Структура;
КонецФункции

#Область ПроцедурыПолученияДанныхДляЗаполненияИПроведенияДокумента

Функция СформироватьЗапросПоШапкеДляПечати(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.РеестрДСВ_3";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = МассивОбъектов;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеестрДСВ_3.Ссылка КАК Ссылка,
	|	РеестрДСВ_3.Организация КАК Организация,
	|	СведенияОбОрганизациях.ИНН КАК ИНН,
	|	СведенияОбОрганизациях.КПП КАК КПП,
	|	СведенияОбОрганизациях.НаименованиеСокращенное КАК Наименование,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР,
	|	РеестрДСВ_3.НомерПлатежногоПоручения,
	|	РеестрДСВ_3.ДатаПлатежногоПоручения,
	|	РеестрДСВ_3.ДатаИсполненияПлатежногоПоручения,
	|	РеестрДСВ_3.ОтчетныйПериод КАК ПериодРегистрации,
	|	РеестрДСВ_3.Руководитель,
	|	РеестрДСВ_3.ГлавныйБухгалтер,
	|	РеестрДСВ_3.ДолжностьРуководителя.Наименование КАК Должность,
	|	РеестрДСВ_3.Дата,
	|	РеестрДСВ_3.ОкончаниеОтчетногоПериода
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.РеестрДСВ_3 КАК РеестрДСВ_3
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО РеестрДСВ_3.Организация = СведенияОбОрганизациях.Организация
	|			И РеестрДСВ_3.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|ГДЕ
	|	РеестрДСВ_3.Ссылка В(&МассивСсылок)";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	ИменаПолейОтветственныхЛиц.Добавить("ГлавныйБухгалтер");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
		
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеестрДСВ_3.Ссылка КАК Документ,
	|	РеестрДСВ_3.РегистрационныйНомерПФР,
	|	РеестрДСВ_3.ИНН,
	|	РеестрДСВ_3.КПП,
	|	РеестрДСВ_3.Наименование,
	|	РеестрДСВ_3.НомерПлатежногоПоручения,
	|	РеестрДСВ_3.ДатаПлатежногоПоручения,
	|	РеестрДСВ_3.ДатаИсполненияПлатежногоПоручения,
	|	РеестрДСВ_3.ПериодРегистрации,
	|	РеестрДСВ_3.Должность КАК РуководительДолжность,
	|	ЕСТЬNULL(ВТФИОРуководителейПоследние.РасшифровкаПодписи, """") КАК Руководитель,
	|	ЕСТЬNULL(ВТФИОГлавБухПоследние.РасшифровкаПодписи, """") КАК ГлавныйБухгалтер
	|ИЗ
	|	ВТДанныеДокументов КАК РеестрДСВ_3
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОРуководителейПоследние
	|		ПО РеестрДСВ_3.Ссылка = ВТФИОРуководителейПоследние.Ссылка
	|			И РеестрДСВ_3.Руководитель = ВТФИОРуководителейПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОГлавБухПоследние
	|		ПО РеестрДСВ_3.Ссылка = ВТФИОГлавБухПоследние.Ссылка
	|			И РеестрДСВ_3.ГлавныйБухгалтер = ВТФИОГлавБухПоследние.ФизическоеЛицо";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоСотрудникамДляПечатиМассивОбъектов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеестрДСВ_3Сотрудники.Ссылка КАК Документ,
	|	РеестрДСВ_3Сотрудники.Фамилия + "" "" + РеестрДСВ_3Сотрудники.Имя + "" "" + РеестрДСВ_3Сотрудники.Отчество КАК ФИО,
	|	РеестрДСВ_3Сотрудники.СтраховойНомерПФР,
	|	РеестрДСВ_3Сотрудники.ВзносыРаботника,
	|	РеестрДСВ_3Сотрудники.ВзносыРаботодателя,
	|	РеестрДСВ_3Сотрудники.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.РеестрДСВ_3.Сотрудники КАК РеестрДСВ_3Сотрудники
	|ГДЕ
	|	РеестрДСВ_3Сотрудники.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ,
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#Область ДляОбеспеченияФормированияВыходногоФайла

// Формирует файл, который можно будет записать на дискетку.
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Строка - содержимое файла
//
Функция СформироватьВыходнойФайл(ВыборкаПоШапкеДокумента, ВыборкаПоСотрудникам) Экспорт
	
	ДеревоФорматаXML = ПолучитьОбщийМакет("ФорматПФР70XML");
	ТекстФорматаXML = ДеревоФорматаXML.ПолучитьТекст();
	
	ДеревоФормата = ЗарплатаКадры.ЗагрузитьXMLВДокументDOM(ТекстФорматаXML);
	
	ВыборкаПоШапкеДокумента.Следующий();
	
	ТекстФайла	=	"";
	НомерДокументаВПачке = 0;
	
	ДатаЗаполнения 			= ВыборкаПоШапкеДокумента.Дата;
	КоличествоДокументов 	= ВыборкаПоСотрудникам.Количество();
	
	НомерДокументаВПачке = 1;
	// Загружаем формат файла сведений.
	
	// Создаем начальное дерево
	ДеревоВыгрузки = ЗарплатаКадры.СоздатьДеревоXML();
	
	УзелПФР = ПерсонифицированныйУчет.УзелФайлаПФР(ДеревоВыгрузки);
	
	ПерсонифицированныйУчет.ЗаполнитьИмяИЗаголовокФайла(УзелПФР, ДеревоФормата, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР);
	
	// Добавляем реквизит ПачкаВходящихДокументов.
	УзелПачкаВходящихДокументов = ПерсонифицированныйУчет.ЗаполнитьНаборЗаписейВходящаяОпись(УзелПФР, ДеревоФормата, "РЕЕСТР_ДСВ_РАБОТОДАТЕЛЬ", ВыборкаПоШапкеДокумента, КоличествоДокументов, НомерДокументаВПачке,,,"ВХОДЯЩАЯ_ОПИСЬ_РЕЕСТРА");
	
	ФорматЗаявлениеДСВ = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "РЕЕСТР_ДСВ_РАБОТОДАТЕЛЬ");
	
	ОписаниеРаботодателя = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматЗаявлениеДСВ.Работодатель.Значение);
	ПерсонифицированныйУчет.ЗаполнитьСоставительПачки(ОписаниеРаботодателя, ВыборкаПоШапкеДокумента);
	
	Пока ВыборкаПоСотрудникам.Следующий() Цикл
		
		НомерДокументаВПачке = НомерДокументаВПачке + 1;
		
		НаборЗаписейЗаявлениеДСВ = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматЗаявлениеДСВ);
		
		НаборЗаписейЗаявлениеДСВ.НомерВПачке.Значение = НомерДокументаВПачке;
		НаборЗаписейЗаявлениеДСВ.СтраховойНомер.Значение = ВыборкаПоСотрудникам.СтраховойНомерПФР;
		
		НаборЗаписейФИО = НаборЗаписейЗаявлениеДСВ.ФИО.Значение;
		НаборЗаписейФИО.Фамилия = ВРег(СокрЛП(ВыборкаПоСотрудникам.Фамилия));
		НаборЗаписейФИО.Имя = ВРег(СокрЛП(ВыборкаПоСотрудникам.Имя));
		НаборЗаписейФИО.Отчество = ВРег(СокрЛП(ВыборкаПоСотрудникам.Отчество));
		
		НаборЗаписейЗаявлениеДСВ.Работодатель.Значение = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ОписаниеРаботодателя);
		
		НаборЗаписейЗаявлениеДСВ.СуммаДСВРаботника.Значение = ВыборкаПоСотрудникам.ВзносыРаботника;
		НаборЗаписейЗаявлениеДСВ.СуммаДСВРаботодателя.Значение = ВыборкаПоСотрудникам.ВзносыРаботодателя;
		
		ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, "РЕЕСТР_ДСВ_РАБОТОДАТЕЛЬ",""), НаборЗаписейЗаявлениеДСВ);
		
	КонецЦикла;
	
	// Преобразуем дерево в строковое описание XML.
	ТекстФайла = ПерсонифицированныйУчет.ПолучитьТекстФайлаИзДереваЗначений(ДеревоВыгрузки,  "Окружение=""В составе файла"" Стадия=""До обработки"" ДобровольныеПравоотношения=""ДСВ""");
	
	Возврат ТекстФайла;
	
КонецФункции

Функция СформироватьЗапросПоШапкеДокумента(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.РеестрДСВ_3";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = Ссылка;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеестрДСВ_3Сотрудники.Ссылка,
	|	СУММА(РеестрДСВ_3Сотрудники.ВзносыРаботника) КАК ВзносыРаботника,
	|	СУММА(РеестрДСВ_3Сотрудники.ВзносыРаботодателя) КАК ВзносыРаботодателя,
	|	КОЛИЧЕСТВО(РеестрДСВ_3Сотрудники.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ВТИтогиВзносы
	|ИЗ
	|	Документ.РеестрДСВ_3.Сотрудники КАК РеестрДСВ_3Сотрудники
	|ГДЕ
	|	РеестрДСВ_3Сотрудники.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РеестрДСВ_3Сотрудники.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеестрДСВ_3.Дата,
	|	РеестрДСВ_3.Номер,
	|	РеестрДСВ_3.Ссылка,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СведенияОбОрганизациях.НаименованиеСокращенное,
	|	СведенияОбОрганизациях.ИНН,
	|	СведенияОбОрганизациях.КПП,
	|	СведенияОбОрганизациях.НаименованиеПолное,
	|	СведенияОбОрганизациях.ЮридическоеФизическоеЛицо КАК ЮридическоеФизическоеЛицо,
	|	СведенияОбОрганизациях.КодПоОКПО,
	|	ГОД(РеестрДСВ_3.ОтчетныйПериод) КАК Год,
	|	РеестрДСВ_3.НомерПлатежногоПоручения КАК НомерПоручения,
	|	РеестрДСВ_3.ДатаПлатежногоПоручения КАК ДатаПоручения,
	|	РеестрДСВ_3.ДатаИсполненияПлатежногоПоручения КАК ДатаИсполненияПоручения,
	|	РеестрДСВ_3.НомерПачки,
	|	ВТИтогиВзносы.ВзносыРаботника + ВТИтогиВзносы.ВзносыРаботодателя КАК СуммаДСВОбщая,
	|	ВТИтогиВзносы.ВзносыРаботника КАК СуммаДСВРаботника,
	|	ВТИтогиВзносы.ВзносыРаботодателя КАК СуммаДСВРаботодателя,
	|	ВТИтогиВзносы.НомерСтроки КАК КоличествоСтрок,
	|	СведенияОбОрганизациях.ОГРН,
	|	РеестрДСВ_3.ИмяФайлаДляПФР
	|ИЗ
	|	Документ.РеестрДСВ_3 КАК РеестрДСВ_3
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО РеестрДСВ_3.Организация = СведенияОбОрганизациях.Организация
	|			И РеестрДСВ_3.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИтогиВзносы КАК ВТИтогиВзносы
	|		ПО РеестрДСВ_3.Ссылка = ВТИтогиВзносы.Ссылка
	|ГДЕ
	|	РеестрДСВ_3.Ссылка = &Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоСотрудникам(Ссылка)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеестрДСВ_3Сотрудники.Ссылка,
	|	РеестрДСВ_3Сотрудники.НомерСтроки,
	|	РеестрДСВ_3Сотрудники.Сотрудник,
	|	РеестрДСВ_3Сотрудники.Фамилия,
	|	РеестрДСВ_3Сотрудники.Имя,
	|	РеестрДСВ_3Сотрудники.Отчество,
	|	РеестрДСВ_3Сотрудники.СтраховойНомерПФР,
	|	РеестрДСВ_3Сотрудники.ВзносыРаботника,
	|	РеестрДСВ_3Сотрудники.ВзносыРаботодателя
	|ИЗ
	|	Документ.РеестрДСВ_3.Сотрудники КАК РеестрДСВ_3Сотрудники
	|ГДЕ
	|	РеестрДСВ_3Сотрудники.Ссылка = &Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ОбработкаФормированияФайла(Объект) Экспорт
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДокумента(Объект.Ссылка).Выбрать();
	ВыборкаПоСотрудникам = СформироватьЗапросПоСотрудникам(Объект.Ссылка).Выбрать();
	
	ТекстФайла = СформироватьВыходнойФайл(ВыборкаПоШапкеДокумента, ВыборкаПоСотрудникам);
	
	ЗарплатаКадры.ЗаписатьФайлВАрхив(Объект.Ссылка, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР, ТекстФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	// ДСВ-3, 2009 год
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'ДСВ-3, форма 2009 года';
										|en = 'DSV-3, 2009 form'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	// ДСВ-3, 2016 год
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "Реестр2016";
	КомандаПечати.Представление = НСтр("ru = 'ДСВ-3, форма 2016 года';
										|en = 'DSV-3, 2016 form'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Реестр") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Реестр", "Реестр, 2009 год", СформироватьПечатнуюФормуДСВ_3(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Реестр2016") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Реестр2016", "Реестр, 2016 год", СформироватьПечатнуюФормуДСВ_3(МассивОбъектов, ОбъектыПечати, "ПФ_MXL_Реестр2016"));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуДСВ_3(МассивОбъектов, ОбъектыПечати, ИмяМакета = "ПФ_MXL_Реестр")
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ВыборкаПоДокументам = СформироватьЗапросПоШапкеДляПечати(МассивОбъектов).Выбрать();
	
	ВыборкаПоСотрудникам = СформироватьЗапросПоСотрудникамДляПечатиМассивОбъектов(МассивОбъектов).Выбрать();
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеестрДСВ_3_Реестр";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеестрДСВ_3." + ИмяМакета);
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ПовторятьПриПечати");
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаРаботника");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");

	ВзносыРаботникаИтог = 0;
	ВзносыРаботодателяИтог = 0;

	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапка.Параметры.Заполнить(ВыборкаПоДокументам);
		
		СтруктураПоиска = Новый Структура("Документ", ВыборкаПоДокументам.Документ);
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ВыборкаПоСотрудникам.Сбросить();
		
		Если ВыборкаПоСотрудникам.НайтиСледующий(СтруктураПоиска) Тогда
			
			ВзносыРаботникаИтог = 0;
			ВзносыРаботодателяИтог = 0;
			
			ВыборкаПоСотрудникам.СледующийПоЗначениюПоля("Документ");
			
			Пока ВыборкаПоСотрудникам.СледующийПоЗначениюПоля("НомерСтроки") Цикл
				ОбластьСтрока.Параметры.Заполнить(ВыборкаПоСотрудникам);
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
				ВзносыРаботникаИтог = ВзносыРаботникаИтог + ВыборкаПоСотрудникам.ВзносыРаботника;
				ВзносыРаботодателяИтог = ВзносыРаботодателяИтог + ВыборкаПоСотрудникам.ВзносыРаботодателя;
			КонецЦикла;
		КонецЕсли;
		
		ОбластьПодвал.Параметры.Заполнить(ВыборкаПоДокументам);
		
		ОбластьПодвал.Параметры.ВзносыРаботника = ВзносыРаботникаИтог;
		ОбластьПодвал.Параметры.ВзносыРаботодателя = ВзносыРаботодателяИтог;
		
		ОбластьПодвал.Параметры.ВзносыВсего = ВзносыРаботникаИтог + ВзносыРаботодателяИтог;
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Документ);
		
	КонецЦикла;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли