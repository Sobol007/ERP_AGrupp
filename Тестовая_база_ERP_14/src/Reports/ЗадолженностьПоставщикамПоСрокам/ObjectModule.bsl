#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	// Установка значений по умолчанию
	УстановитьОбязательныеНастройки(КомпоновщикНастроекФормы, Истина);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрДанныеОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета,"ДанныеОтчета");
	Если ПараметрДанныеОтчета.Значение = 2 Тогда 
		ВалютаОтчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ИначеЕсли ПараметрДанныеОтчета.Значение = 3 Тогда
		ВалютаОтчета = Константы.ВалютаУправленческогоУчета.Получить();
	Иначе
		Валюта = Неопределено;
	КонецЕсли;
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса(ПараметрДанныеОтчета.Значение);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.ОформитьДиаграммыОтчета(КомпоновщикНастроек, ДокументРезультат);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	КомпоновкаДанныхСервер.УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	УстановитьКалендарь(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
КонецПроцедуры

Процедура УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрДатаОстатков = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	ПараметрДатаОстатков.Использование = Истина;
	
	ПараметрДатаОтчетаГраница = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчетаГраница");
	ПараметрДатаОтчетаГраница.Использование = Истина;
	
	Если ТипЗнч(ПараметрДатаОстатков.Значение) = Тип("СтандартнаяДатаНачала") Тогда
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОстатков.Значение.Дата) Тогда
			ПараметрДатаОстатков.Значение.Дата = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(ПараметрДатаОстатков.Значение.Дата), ВидГраницы.Включая);
	Иначе
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОстатков.Значение) Тогда
			ПараметрДатаОстатков.Значение = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(ПараметрДатаОстатков.Значение), ВидГраницы.Включая);
	КонецЕсли;
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
КонецПроцедуры

Функция СтруктураЗаголовковПолей()
	СтруктураЗаголовковПолей = Новый Структура;
	
	СтруктураЗаголовковВалют = КомпоновкаДанныхСервер.СтруктураЗаголовковВалют(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктураЗаголовковВалют, Ложь);
	
	Возврат СтруктураЗаголовковПолей;
КонецФункции

Функция ТекстЗапроса(ВалютаОтчета)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.Курс * КурсВалютыОтчета.Кратность / (КурсВалюты.Кратность * КурсВалютыОтчета.Курс) КАК Коэффициент
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних({&КонецПериодаОтчета}, ) КАК КурсВалюты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних({&КонецПериодаОтчета}, Валюта = &Валюта) КАК КурсВалютыОтчета
	|		ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.Кратность <> 0
	|	И КурсВалютыОтчета.Курс <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаУчета.Организация                                     КАК Организация,
	|	АналитикаУчета.Партнер                                         КАК Партнер,
	|	АналитикаУчета.Контрагент                                      КАК Контрагент,
	|	АналитикаУчета.Договор                                         КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности                         КАК НаправлениеДеятельности,
	|	РасчетыПоСрокам.ОбъектРасчетов                                 КАК ОбъектРасчетов,
	|	РасчетыПоСрокам.Валюта                                         КАК Валюта,
	|	РасчетыПоСрокам.РасчетныйДокумент                              КАК РасчетныйДокумент,
	|	РасчетыПоСрокам.ДатаПлановогоПогашения                         КАК ДатаПлановогоПогашения,
	|	РасчетыПоСрокам.ДатаВозникновения                              КАК ДатаВозникновения,
	|	
	|	РасчетыПоСрокам.ДолгРеглОстаток                                КАК НашДолг,
	|	ВЫБОР 
	|		КОГДА РасчетыПоСрокам.ДатаПлановогоПогашения < &ДатаОтчета
	|			ТОГДА РасчетыПоСрокам.ДолгРеглОстаток
	|		ИНАЧЕ 0 
	|	КОНЕЦ                                                          КАК НашДолгПросрочено,
	|	РасчетыПоСрокам.ПредоплатаРеглОстаток                          КАК ДолгПоставщика,
	|	
	|	0                                                              КАК КПоступлению
	|ПОМЕСТИТЬ ТаблицаЗадолженностей
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам.Остатки(&ДатаОтчетаГраница) КАК РасчетыПоСрокам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО АналитикаУчета.КлючАналитики = РасчетыПоСрокам.АналитикаУчетаПоПартнерам
	|ГДЕ
	|	Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие) И (&ВключатьЗадолженность = 0 ИЛИ &ВключатьЗадолженность = 1)
	|{ГДЕ
	|	АналитикаУчета.Организация.* КАК Организация,
	|	АналитикаУчета.Партнер.* КАК Партнер,
	|	АналитикаУчета.Контрагент.* КАК Контрагент,
	|	АналитикаУчета.Договор.* КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(АналитикаУчета.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаУчета.Организация               КАК Организация,
	|	АналитикаУчета.Партнер                   КАК Партнер,
	|	АналитикаУчета.Контрагент                КАК Контрагент,
	|	АналитикаУчета.Договор                   КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности   КАК НаправлениеДеятельности,
	|	РасчетыПланОплат.ОбъектРасчетов          КАК ОбъектРасчетов,
	|	РасчетыПланОплат.Валюта                  КАК Валюта,
	|	РасчетыПланОплат.ДокументПлан            КАК ДокументПлан,
	|	РасчетыПланОплат.ДатаПлановогоПогашения  КАК ДатаПлановогоПогашения,
	|	РасчетыПланОплат.ДатаВозникновения       КАК ДатаВозникновения,
	|	
	|	РасчетыПланОплат.КОплатеОстаток
	|		* ЕСТЬNULL(Курсы.Коэффициент,1)      КАК НашДолг,
	|	ВЫБОР 
	|		КОГДА РасчетыПланОплат.ДатаПлановогоПогашения < &ДатаОтчета
	|			ТОГДА РасчетыПланОплат.КОплатеОстаток * ЕСТЬNULL(Курсы.Коэффициент,1)
	|		ИНАЧЕ 0 
	|	КОНЕЦ                                    КАК НашДолгПросрочено,
	|	0                                        КАК ДолгПоставщика,
	|	
	|	0                                        КАК КПоступлению
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПланОплат.Остатки(&ДатаОтчетаГраница) КАК РасчетыПланОплат
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО АналитикаУчета.КлючАналитики = РасчетыПланОплат.АналитикаУчетаПоПартнерам
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|			ПО Курсы.Валюта = РасчетыПланОплат.Валюта
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(РасчетыПланОплат.ДокументПлан) В (&ТипыДокументовПлана)
	|	И Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие) И (&ВключатьЗадолженность = 0 ИЛИ &ВключатьЗадолженность = 2)
	|{ГДЕ
	|	АналитикаУчета.Организация.* КАК Организация,
	|	АналитикаУчета.Партнер.* КАК Партнер,
	|	АналитикаУчета.Контрагент.* КАК Контрагент,
	|	АналитикаУчета.Договор.* КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(АналитикаУчета.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаУчета.Организация                  КАК Организация,
	|	АналитикаУчета.Партнер                      КАК Партнер,
	|	АналитикаУчета.Контрагент                   КАК Контрагент,
	|	АналитикаУчета.Договор                      КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности      КАК НаправлениеДеятельности,
	|	РасчетыПланПоставок.ОбъектРасчетов          КАК ОбъектРасчетов,
	|	РасчетыПланПоставок.Валюта                  КАК Валюта,
	|	РасчетыПланПоставок.ДокументПлан            КАК ДокументПлан,
	|	РасчетыПланПоставок.ДатаПлановогоПогашения  КАК ДатаПлановогоПогашения,
	|	РасчетыПланПоставок.ДатаВозникновения       КАК ДатаВозникновения,
	|	
	|	0                                           КАК НашДолг,
	|	0                                           КАК НашДолгПросрочено,
	|	0                                           КАК ДолгПоставщика,
	|	
	|	РасчетыПланПоставок.СуммаОстаток
	|		* ЕСТЬNULL(Курсы.Коэффициент,1)         КАК КПоступлению
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПланПоставок.Остатки(&ДатаОтчетаГраница) КАК РасчетыПланПоставок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО АналитикаУчета.КлючАналитики = РасчетыПланПоставок.АналитикаУчетаПоПартнерам
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|			ПО Курсы.Валюта = РасчетыПланПоставок.Валюта
	|ГДЕ
	|	Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие) И (&ВключатьЗадолженность = 0 ИЛИ &ВключатьЗадолженность = 2)
	|{ГДЕ
	|	АналитикаУчета.Организация.* КАК Организация,
	|	АналитикаУчета.Партнер.* КАК Партнер,
	|	АналитикаУчета.Контрагент.* КАК Контрагент,
	|	АналитикаУчета.Договор.* КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(АналитикаУчета.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаЗадолженностей.ДатаПлановогоПогашения КАК ДатаНачала,
	|	ГрафикиРаботы.Дата КАК ДатаОкончания,
	|	ВЫБОР
	|		КОГДА ГрафикиРаботы.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	|				ИЛИ ГрафикиРаботы.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РабочийДень
	|ПОМЕСТИТЬ Графики
	|ИЗ
	|	ТаблицаЗадолженностей КАК ТаблицаЗадолженностей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ГрафикиРаботы
	|		ПО (ГрафикиРаботы.ПроизводственныйКалендарь = &Календарь)
	|ГДЕ
	|	ГрафикиРаботы.Дата МЕЖДУ ТаблицаЗадолженностей.ДатаПлановогоПогашения И &ДатаОтчета
	|	И ТаблицаЗадолженностей.ДатаПлановогоПогашения <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.ДатаНачала КАК ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания КАК ДатаОкончания,
	|	ЕСТЬNULL(СУММА(Графики.РабочийДень), 0) КАК КоличествоДней
	|ПОМЕСТИТЬ РазностиДат
	|ИЗ
	|	Графики КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Графики КАК Графики
	|		ПО ВложенныйЗапрос.ДатаНачала = Графики.ДатаНачала
	|			И ВложенныйЗапрос.ДатаОкончания > Графики.ДатаОкончания
	|ГДЕ
	|	ВложенныйЗапрос.ДатаОкончания = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&СтрокаСостояниеВзаиморасчетов                                 КАК ГруппировкаВсего,
	|	ТаблицаЗадолженностей.Организация                              КАК Организация,
	|	ТаблицаЗадолженностей.Партнер                                  КАК Партнер,
	|	ТаблицаЗадолженностей.Контрагент                               КАК Контрагент,
	|	ТаблицаЗадолженностей.Договор                                  КАК Договор,
	|	ТаблицаЗадолженностей.НаправлениеДеятельности                  КАК НаправлениеДеятельности,
	|	ТаблицаЗадолженностей.ОбъектРасчетов                           КАК ОбъектРасчетов,
	|	ТаблицаЗадолженностей.Валюта                                   КАК Валюта,
	|	ТаблицаЗадолженностей.РасчетныйДокумент                        КАК РасчетныйДокумент,
	|	ТаблицаЗадолженностей.ДатаПлановогоПогашения                   КАК ДатаПлановогоПогашения,
	|	ТаблицаЗадолженностей.ДатаВозникновения                        КАК ДатаВозникновения,
	|	
	|	ТаблицаЗадолженностей.НашДолг                                  КАК НашДолг,
	|	ТаблицаЗадолженностей.НашДолгПросрочено                        КАК НашДолгПросрочено,
	|	ТаблицаЗадолженностей.ДолгПоставщика                           КАК ДолгПоставщика,
	|	ТаблицаЗадолженностей.КПоступлению                             КАК КПоступлению,
	|	
	|	ВЫБОР
	|		КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL 
	|			ТОГДА ВЫБОР
	|					КОГДА РазностиДат.КоличествоДней > 0
	|						ТОГДА РазностиДат.КоличествоДней
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ТаблицаЗадолженностей.НашДолг = 0 ИЛИ ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА 0
	|				ИНАЧЕ ВЫБОР
	|						КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ) > 0
	|							ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ)
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ                                                             КАК КоличествоДней,
	|	ЕСТЬNULL(Интервалы.НаименованиеИнтервала, &СтрокаДолгНеПросрочен) КАК НаименованиеИнтервала,
	|	ЕСТЬNULL(Интервалы.НомерСтроки, 0)                                КАК НомерИнтервала,
	|	ЕСТЬNULL(Интервалы.НижняяГраницаИнтервала, 0)                     КАК НижняяГраницаИнтервала
	|ИЗ
	|	ТаблицаЗадолженностей КАК ТаблицаЗадолженностей
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РазностиДат КАК РазностиДат
	|		ПО (РазностиДат.ДатаНачала = ТаблицаЗадолженностей.ДатаПлановогоПогашения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКлассификацииЗадолженности.Интервалы КАК Интервалы
	|		ПО (Интервалы.Ссылка = &ВариантКлассификацииЗадолженности)
	|			И (ВЫБОР
	|				КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL 
	|					ТОГДА ВЫБОР
	|							КОГДА РазностиДат.КоличествоДней > 0
	|								ТОГДА РазностиДат.КоличествоДней
	|							ИНАЧЕ 0
	|						КОНЕЦ
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ТаблицаЗадолженностей.НашДолг = 0 ИЛИ ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|							ТОГДА 0
	|						ИНАЧЕ ВЫБОР
	|								КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ) > 0
	|									ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ)
	|								ИНАЧЕ 0
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ МЕЖДУ Интервалы.НижняяГраницаИнтервала И Интервалы.ВерхняяГраницаИнтервала)}";
	
	Если ВалютаОтчета = 0 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"Регл","");
	ИначеЕсли ВалютаОтчета = 2 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"Регл","Упр");
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&НаДату","&ДатаОтчета");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ТипыДокументовПлана", ПолучитьТипыДокументовПлана());
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ПолучитьТипыДокументовПлана()
	ТекстТиповДокументов = ""; 
	
	//++ НЕ УТ
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ЗаказПереработчику), ";
	//-- НЕ УТ
	
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ЗаказПоставщику), ";
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ГрафикИсполненияДоговора)";
	
	Возврат ТекстТиповДокументов;
КонецФункции

Процедура УстановитьКалендарь(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрВариантКлассификацииЗадолженности = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВариантКлассификацииЗадолженности");
	ПараметрКалендарь = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Календарь");
	
	Если ПараметрВариантКлассификацииЗадолженности.Значение.Календарь.Пустая() Тогда
		ОсновнойКалендарьПредприятия = Константы.ОсновнойКалендарьПредприятия.Получить();
		Если Не ОсновнойКалендарьПредприятия.Пустая() Тогда
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Календарь", ОсновнойКалендарьПредприятия);
		
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
	Иначе
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Календарь", ПараметрВариантКлассификацииЗадолженности.Значение.Календарь);
		
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли