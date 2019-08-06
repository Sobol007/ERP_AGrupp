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
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		СформироватьПараметрыОтчета(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
	КонецЕсли;
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	
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

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрДанныеОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета,"ДанныеОтчета");
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса(ПараметрДанныеОтчета.Значение);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	КомпоновкаДанныхСервер.УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
КонецПроцедуры

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
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.Курс * КурсВалютыОтчета.Кратность / (КурсВалюты.Кратность * КурсВалютыОтчета.Курс) КАК Коэффициент
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних({&КонецПериода}, ) КАК КурсВалюты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних({&КонецПериода}, Валюта = &Валюта) КАК КурсВалютыОтчета
	|		ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.Кратность <> 0
	|	И КурсВалютыОтчета.Курс <> 0
	|;
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Расчеты.Организация                 КАК Организация,
	|	Расчеты.Партнер                     КАК Партнер,
	|	Расчеты.Контрагент                  КАК Контрагент,
	|	Расчеты.Договор                     КАК Договор,
	|	Расчеты.НаправлениеДеятельности     КАК НаправлениеДеятельности,
	|	Расчеты.ОбъектРасчетов              КАК ОбъектРасчетов,
	|	Расчеты.Валюта                      КАК Валюта,
	|	Расчеты.РасчетныйДокумент           КАК РасчетныйДокумент,
	|	Расчеты.ДокументРегистратор         КАК ДокументРегистратор,
	|	Расчеты.ДатаВозникновения           КАК ДатаВозникновения,
	|	Расчеты.ДатаПлановогоПогашения      КАК ДатаПлановогоПогашения,
	|	НАЧАЛОПЕРИОДА(Расчеты.Период, ДЕНЬ) КАК Период,
	|	Расчеты.ПорядокОперации             КАК ПорядокОперации,
	|	
	|	СУММА(Расчеты.ДолгКлиента)          КАК ДолгКлиента,
	|	СУММА(Расчеты.НашДолг)              КАК НашДолг,
	|	СУММА(Расчеты.ПлановаяОплата)       КАК ПлановаяОплата,
	|	СУММА(Расчеты.ПлановаяОтгрузка)     КАК ПлановаяОтгрузка,
	|	ВЫБОР КОГДА СУММА(Расчеты.Оплачено)+СУММА(Расчеты.Отгружено) = 0 
	|		ТОГДА ВЫБОР КОГДА СУММА(Расчеты.Зачтено)+СУММА(Расчеты.ПлановаяОтгрузка) = 0 
	|				ТОГДА СУММА(Расчеты.ПлановаяОплата)
	|				ИНАЧЕ СУММА(Расчеты.Зачтено)+СУММА(Расчеты.ПлановаяОтгрузка)
	|			КОНЕЦ
	|		ИНАЧЕ СУММА(Расчеты.Оплачено)+СУММА(Расчеты.Отгружено)
	|	КОНЕЦ                               КАК СуммаПоДокументу
	|ИЗ (
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                                     КАК Организация,
	|		АналитикаУчета.Партнер                                         КАК Партнер,
	|		АналитикаУчета.Контрагент                                      КАК Контрагент,
	|		АналитикаУчета.Договор                                         КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности                         КАК НаправлениеДеятельности,
	|		РасчетыПоСрокамОстатки.ОбъектРасчетов                          КАК ОбъектРасчетов,
	|		РасчетыПоСрокамОстатки.Валюта                                  КАК Валюта,
	|		РасчетыПоСрокамОстатки.РасчетныйДокумент                       КАК РасчетныйДокумент,
	|		ВЫРАЗИТЬ(&ТекстНачальныйОстаток КАК СТРОКА(17))                КАК ДокументРегистратор,
	|		РасчетыПоСрокамОстатки.ДатаПлановогоПогашения                  КАК ДатаПлановогоПогашения,
	|		РасчетыПоСрокамОстатки.ДатаВозникновения                       КАК ДатаВозникновения,
	|		&НачалоПериода                                                 КАК Период,
	|		""""                                                           КАК ПорядокОперации,
	|		
	|		0                                                              КАК Заказано,
	|		0                                                              КАК Отгружено,
	|		0                                                              КАК Зачтено,
	|		0                                                              КАК Оплачено,
	|		РасчетыПоСрокамОстатки.ДолгРеглНачальныйОстаток                КАК ДолгКлиента,
	|		РасчетыПоСрокамОстатки.ПредоплатаРеглНачальныйОстаток          КАК НашДолг,
	|		0                                                              КАК ПлановаяОплата,
	|		0                                                              КАК ПлановаяОтгрузка
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПоСрокам.ОстаткиИОбороты({&НачалоПериода},{&КонецПериода}) КАК РасчетыПоСрокамОстатки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПоСрокамОстатки.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров)),
	|		&НачалоПериода <> ДАТАВРЕМЯ(1,1,1)}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                        КАК Организация,
	|		АналитикаУчета.Партнер                            КАК Партнер,
	|		АналитикаУчета.Контрагент                         КАК Контрагент,
	|		АналитикаУчета.Договор                            КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности            КАК НаправлениеДеятельности,
	|		РасчетыПланОплатОстатки.ОбъектРасчетов            КАК ОбъектРасчетов,
	|		РасчетыПланОплатОстатки.Валюта                    КАК Валюта,
	|		РасчетыПланОплатОстатки.ДокументПлан              КАК ДокументПлан,
	|		ВЫРАЗИТЬ(&ТекстНачальныйОстаток КАК СТРОКА(17))   КАК ДокументРегистратор,
	|		РасчетыПланОплатОстатки.ДатаПлановогоПогашения    КАК ДатаПлановогоПогашения,
	|		РасчетыПланОплатОстатки.ДатаВозникновения         КАК ДатаВозникновения,
	|		&НачалоПериода                                    КАК Период,
	|		""""                                              КАК ПорядокОперации,
	|		
	|		0                                                 КАК Заказано,
	|		0                                                 КАК Отгружено,
	|		0                                                 КАК Зачтено,
	|		0                                                 КАК Оплачено,
	|		
	|		0                                                 КАК ДолгКлиента,
	|		0                                                 КАК НашДолг,
	|		РасчетыПланОплатОстатки.КОплатеНачальныйОстаток
	|			* ЕСТЬNULL(Курсы.Коэффициент,1)               КАК ПлановаяОплата,
	|		0                                                 КАК ПлановаяОтгрузка
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПланОплат.ОстаткиИОбороты({&НачалоПериода},{&КонецПериода}) КАК РасчетыПланОплатОстатки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПланОплатОстатки.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|			ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|				ПО Курсы.Валюта = РасчетыПланОплатОстатки.Валюта
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                        КАК Организация,
	|		АналитикаУчета.Партнер                            КАК Партнер,
	|		АналитикаУчета.Контрагент                         КАК Контрагент,
	|		АналитикаУчета.Договор                            КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности            КАК НаправлениеДеятельности,
	|		РасчетыПланОтгрузокОстатки.ОбъектРасчетов         КАК ОбъектРасчетов,
	|		РасчетыПланОтгрузокОстатки.Валюта                 КАК Валюта,
	|		РасчетыПланОтгрузокОстатки.ДокументПлан           КАК ДокументПлан,
	|		ВЫРАЗИТЬ(&ТекстНачальныйОстаток КАК СТРОКА(17))   КАК ДокументРегистратор,
	|		РасчетыПланОтгрузокОстатки.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|		РасчетыПланОтгрузокОстатки.ДатаВозникновения      КАК ДатаВозникновения,
	|		&НачалоПериода                                    КАК Период,
	|		""""                                              КАК ПорядокОперации,
	|		
	|		0                                                 КАК Заказано,
	|		0                                                 КАК Отгружено,
	|		0                                                 КАК Зачтено,
	|		0                                                 КАК Оплачено,
	|		0                                                 КАК ДолгКлиента,
	|		0                                                 КАК НашДолг,
	|		0                                                 КАК ПлановаяОплата,
	|		РасчетыПланОтгрузокОстатки.СуммаНачальныйОстаток
	|			* ЕСТЬNULL(Курсы.Коэффициент,1)               КАК ПлановаяОтгрузка
	|	ИЗ
	|		РегистрНАкопления.РасчетыСКлиентамиПланОтгрузок.ОстаткиИОбороты({&НачалоПериода},{&КонецПериода}) КАК РасчетыПланОтгрузокОстатки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПланОтгрузокОстатки.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|			ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|				ПО Курсы.Валюта = РасчетыПланОтгрузокОстатки.Валюта
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                                     КАК Организация,
	|		АналитикаУчета.Партнер                                         КАК Партнер,
	|		АналитикаУчета.Контрагент                                      КАК Контрагент,
	|		АналитикаУчета.Договор                                         КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности                         КАК НаправлениеДеятельности,
	|		РасчетыПоСрокам.ОбъектРасчетов                                 КАК ОбъектРасчетов,
	|		РасчетыПоСрокам.Валюта                                         КАК Валюта,
	|		РасчетыПоСрокам.РасчетныйДокумент                              КАК РасчетныйДокумент,
	|		РасчетыПоСрокам.ДокументРегистратор                            КАК ДокументРегистратор,
	|		РасчетыПоСрокам.ДатаВозникновения                              КАК ДатаВозникновения,
	|		РасчетыПоСрокам.ДатаПлановогоПогашения                         КАК ДатаПлановогоПогашения,
	|		РасчетыПоСрокам.Период                                         КАК Период,
	|		РасчетыПоСрокам.ПорядокОперации                                КАК ПорядокОперации,
	|		
	|		0                                                              КАК Заказано,
	|		&ОтгруженоКлиенту                                              КАК Отгружено,
	|		&ЗачтеноКлиенту                                                КАК Зачтено,
	|		&ОплаченоКлиентом                                              КАК Оплачено,
	|		
	|		ВЫБОР КОГДА РасчетыПоСрокам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА РасчетыПоСрокам.ДолгРегл
	|			ИНАЧЕ -РасчетыПоСрокам.ДолгРегл
	|		КОНЕЦ                                                          КАК ДолгКлиента,
	|		ВЫБОР КОГДА РасчетыПоСрокам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА РасчетыПоСрокам.ПредоплатаРегл
	|			ИНАЧЕ -РасчетыПоСрокам.ПредоплатаРегл
	|		КОНЕЦ                                                          КАК НашДолг,
	|		0                                                              КАК ПлановаяОплата,
	|		0                                                              КАК ПлановаяОтгрузка
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК РасчетыПоСрокам
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПоСрокам.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|		И (РасчетыПоСрокам.ДолгРегл <> 0 ИЛИ РасчетыПоСрокам.ПредоплатаРегл <> 0)
	|	{ГДЕ
	|		РасчетыПоСрокам.Период МЕЖДУ &НачалоПериода И &КонецПериода,
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация               КАК Организация,
	|		АналитикаУчета.Партнер                   КАК Партнер,
	|		АналитикаУчета.Контрагент                КАК Контрагент,
	|		АналитикаУчета.Договор                   КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности   КАК НаправлениеДеятельности,
	|		РасчетыПланОплат.ОбъектРасчетов          КАК ОбъектРасчетов,
	|		РасчетыПланОплат.Валюта                  КАК Валюта,
	|		РасчетыПланОплат.ДокументПлан            КАК ДокументПлан,
	|		РасчетыПланОплат.ДокументРегистратор     КАК ДокументРегистратор,
	|		РасчетыПланОплат.ДатаВозникновения       КАК ДатаВозникновения,
	|		РасчетыПланОплат.ДатаПлановогоПогашения  КАК ДатаПлановогоПогашения,
	|		РасчетыПланОплат.Период                  КАК Период,
	|		РасчетыПланОплат.ПорядокОперации         КАК ПорядокОперации,
	|		
	|		0                                        КАК Заказано,
	|		0                                        КАК Отгружено,
	|		0                                        КАК Зачтено,
	|		0                                        КАК Оплачено,
	|		
	|		0                                        КАК ДолгКлиента,
	|		0                                        КАК НашДолг,
	|		ВЫБОР КОГДА РасчетыПланОплат.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА РасчетыПланОплат.КОплате
	|			ИНАЧЕ -РасчетыПланОплат.КОплате
	|		КОНЕЦ * ЕСТЬNULL(Курсы.Коэффициент,1)    КАК ПлановаяОплата,
	|		0                                        КАК ПлановаяОтгрузка
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентамиПланОплат КАК РасчетыПланОплат
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПланОплат.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|			ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|				ПО Курсы.Валюта = РасчетыПланОплат.Валюта
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		РасчетыПланОплат.Период МЕЖДУ &НачалоПериода И &КонецПериода,
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АналитикаУчета.Организация                  КАК Организация,
	|		АналитикаУчета.Партнер                      КАК Партнер,
	|		АналитикаУчета.Контрагент                   КАК Контрагент,
	|		АналитикаУчета.Договор                      КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности      КАК НаправлениеДеятельности,
	|		РасчетыПланОтгрузок.ОбъектРасчетов          КАК ОбъектРасчетов,
	|		РасчетыПланОтгрузок.Валюта                  КАК Валюта,
	|		РасчетыПланОтгрузок.ДокументПлан            КАК ДокументПлан,
	|		РасчетыПланОтгрузок.ДокументРегистратор     КАК ДокументРегистратор,
	|		РасчетыПланОтгрузок.ДатаВозникновения       КАК ДатаВозникновения,
	|		РасчетыПланОтгрузок.ДатаПлановогоПогашения  КАК ДатаПлановогоПогашения,
	|		РасчетыПланОтгрузок.Период                  КАК Период,
	|		РасчетыПланОтгрузок.ПорядокОперации         КАК ПорядокОперации,
	|		
	|		ВЫБОР КОГДА РасчетыПланОтгрузок.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА РасчетыПланОтгрузок.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ * ЕСТЬNULL(Курсы.Коэффициент,1)       КАК Заказано,
	|		0                                           КАК Отгружено,
	|		0                                           КАК Зачтено,
	|		0                                           КАК Оплачено,
	|		0                                           КАК ДолгКлиента,
	|		0                                           КАК НашДолг,
	|		0                                           КАК ПлановаяОплата,
	|		ВЫБОР КОГДА РасчетыПланОтгрузок.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА РасчетыПланОтгрузок.Сумма
	|			ИНАЧЕ -РасчетыПланОтгрузок.Сумма
	|		КОНЕЦ * ЕСТЬNULL(Курсы.Коэффициент,1)       КАК ПлановаяОтгрузка
	|	ИЗ
	|		РегистрНАкопления.РасчетыСКлиентамиПланОтгрузок КАК РасчетыПланОтгрузок
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|				ПО РасчетыПланОтгрузок.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|			ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|				ПО Курсы.Валюта = РасчетыПланОтгрузок.Валюта
	|	ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	{ГДЕ
	|		РасчетыПланОтгрузок.Период МЕЖДУ &НачалоПериода И &КонецПериода,
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}) КАК Расчеты
	|СГРУППИРОВАТЬ ПО
	|	Расчеты.Организация,
	|	Расчеты.Партнер,
	|	Расчеты.Контрагент,
	|	Расчеты.Договор,
	|	Расчеты.НаправлениеДеятельности,
	|	Расчеты.ОбъектРасчетов,
	|	Расчеты.Валюта,
	|	Расчеты.РасчетныйДокумент,
	|	Расчеты.ДокументРегистратор,
	|	Расчеты.ДатаВозникновения,
	|	Расчеты.ДатаПлановогоПогашения,
	|	НАЧАЛОПЕРИОДА(Расчеты.Период, ДЕНЬ),
	|	Расчеты.ПорядокОперации
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ОтгруженоКлиенту", ВзаиморасчетыСервер.ШаблонПоляОтгруженоКлиенту());
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ЗачтеноКлиенту", ВзаиморасчетыСервер.ШаблонПоляЗачтеноКлиенту());
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ОплаченоКлиентом", ВзаиморасчетыСервер.ШаблонПоляОплаченоКлиентом());
	
	Если ВалютаОтчета = 4 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"Регл","");
	ИначеЕсли ВалютаОтчета = 2 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"Регл","Упр");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
КонецФункции

Процедура СформироватьПараметрыОтчета(ПараметрКоманды, ПараметрыФормы, Параметры)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЭтоМассив = Истина;
		Если ПараметрКоманды.Количество() > 0 Тогда
			ПервыйЭлемент = ПараметрКоманды[0];
		Иначе
			ПервыйЭлемент = Неопределено;
		КонецЕсли;
	Иначе
		ЭтоМассив = Ложь;
		ПервыйЭлемент = ПараметрКоманды;
	КонецЕсли;
	
	Если ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.Партнеры") Тогда
		Если ЭтоМассив Тогда
			ЕстьПодчиненныеПартнеры = Ложь;
			Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
				Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
					ЕстьПодчиненныеПартнеры = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ПараметрКоманды);
		КонецЕсли;
		
		Если ЕстьПодчиненныеПартнеры Тогда
			ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
			ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
			ЗначениеОтбора = ПараметрКоманды;
			Если ЭтоМассив Тогда
				ЗначениеОтбора = Новый СписокЗначений;
				ЗначениеОтбора.ЗагрузитьЗначения(ПараметрКоманды);
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			Иначе
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			КонецЕсли;
			ЭлементОтбора.ПравоеЗначение = ЗначениеОтбора;
			ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
			Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
			ПараметрыФормы.КлючНазначенияИспользования = "ГруппаПартнеров";
			Параметры.КлючНазначенияИспользования = "ГруппаПартнеров";
		Иначе
			ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
			ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
			Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.ДоговорыКонтрагентов") 
		ИЛИ ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
		ПараметрыФормы.Отбор = Новый Структура("Договор", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
	Иначе
		ОбъектРасчетов = ВзаиморасчетыСервер.ОбъектРасчетовПоСсылке(ПервыйЭлемент);
		ПараметрыФормы.Отбор = Новый Структура("ОбъектРасчетов", ОбъектРасчетов);
		ПараметрыФормы.КлючНазначенияИспользования = ОбъектРасчетов;
		Параметры.КлючНазначенияИспользования = ОбъектРасчетов;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли