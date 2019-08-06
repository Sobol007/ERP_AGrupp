
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	ЗначенияОтбораДанных = ПолучитьЗначенияОтбораДанных(НастройкиОсновнойСхемы);
	
	ТекстСообщения = НСтр("ru = 'Отчет не поддерживает получение данных до даты начала учета внеоборотных активов версии 2.4 - %1.
                           |Необходимо воспользоваться аналогичным отчетом в разделе ""Регламентированный учет"".';
                           |en = 'Report does not support data retrieval prior to the commencement date of accounting of non-current assets 2.4 -%1.
                           | You need to use the similar report in ""Regulated Accounting"" section.'");

	ВнеоборотныеАктивыСлужебный.ПроверитьПериодОтчетаВерсии24(
		ЗначенияОтбораДанных.НачалоПериода, 
		ЗначенияОтбораДанных.ОкончаниеПериода, 
		ТекстСообщения,
		Отказ); 
	
КонецПроцедуры
 
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	УстановитьПараметрыОтчета(НастройкиОсновнойСхемы);
	
	ЗначенияОтбораДанных = ПолучитьЗначенияОтбораДанных(НастройкиОсновнойСхемы);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);	
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, Неопределено, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	ОформитьШапкуОтчета(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФормированиеОтчета
 
Процедура ОформитьШапкуОтчета(ТабДок)
	
	СписокГруппЯчеек = Новый Массив;
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Показатели';
									|en = 'Indicators'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Дата принятия к учету';
									|en = 'Date of recognition'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Первоначальная стоимость';
									|en = 'Initial cost'"));
	
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Стоимость';
									|en = 'Cost'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Амортизация';
									|en = 'Depreciation'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Остаточная стоимость';
									|en = 'Residual value'"));
	
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Увеличение стоимости';
									|en = 'Cost increase '"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Начисление амортизации';
									|en = 'Depreciation accrual'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Уменьшение стоимости';
									|en = 'Cost reduction'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Списание амортизации';
									|en = 'Depreciation write-off'"));
	
	СписокПодчиненныхЯчеек = Новый Массив;
	СписокПодчиненныхЯчеек.Добавить(НСтр("ru = 'БУ';
										|en = 'BKG'"));
	СписокПодчиненныхЯчеек.Добавить(НСтр("ru = 'НУ';
										|en = 'TA'"));
	СписокПодчиненныхЯчеек.Добавить(НСтр("ru = 'ПР';
										|en = 'PD'"));
	СписокПодчиненныхЯчеек.Добавить(НСтр("ru = 'ВР';
										|en = 'TD'"));
	СписокПодчиненныхЯчеек.Добавить(НСтр("ru = 'УУ';
										|en = 'MA'"));
	
	ВнеоборотныеАктивыСлужебный.ОбъединитьПодчиненныеЯчейки(ТабДок, СписокГруппЯчеек, СписокПодчиненныхЯчеек);
	
КонецПроцедуры

Процедура УстановитьПараметрыОтчета(НастройкиОсновнойСхемы)

	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ПоказательБУ", НСтр("ru = 'БУ';
																								|en = 'BKG'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ПоказательНУ", НСтр("ru = 'НУ';
																								|en = 'TA'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ПоказательПР", НСтр("ru = 'ПР';
																								|en = 'PD'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ПоказательВР", НСтр("ru = 'ВР';
																								|en = 'TD'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ПоказательУУ", НСтр("ru = 'УУ';
																								|en = 'MA'"));
	
	// ТипыДокументовСписаниеАмортизации
	ТипыДокументов = Новый СписокЗначений;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПереоценкаОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.СписаниеОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПодготовкаКПередачеОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РазукомплектацияОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РеализацияУслугПрочихАктивов"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ТипыДокументовСписаниеАмортизации", ТипыДокументов);
	
	// ТипыДокументовНачислениеАмортизации
	ТипыДокументов = Новый СписокЗначений;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.АмортизацияОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПереоценкаОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РаспределениеНДС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ТипыДокументовНачислениеАмортизации", ТипыДокументов);
	
	// ТипыДокументовУвеличениеСтоимости
	ТипыДокументов = Новый СписокЗначений;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПереоценкаОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РаспределениеНДС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.МодернизацияОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПоступлениеАрендованныхОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РазукомплектацияОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ТипыДокументовУвеличениеСтоимости", ТипыДокументов);
	
	// ТипыДокументовУменьшениеСтоимости
	ТипыДокументов = Новый СписокЗначений;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.АмортизацияОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПереоценкаОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПодготовкаКПередачеОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РеализацияУслугПрочихАктивов"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.СписаниеОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РаспределениеНДС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РазукомплектацияОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ТипыДокументовУменьшениеСтоимости", ТипыДокументов);
	
КонецПроцедуры
 
#КонецОбласти

#Область Прочее

Функция ПолучитьЗначенияОтбораДанных(НастройкиОсновнойСхемы)

	ЗначенияОтбораДанных = Новый Структура;
	
	ВнеоборотныеАктивыСлужебный.ПериодОтчета(НастройкиОсновнойСхемы, ЗначенияОтбораДанных);
	
	Возврат ЗначенияОтбораДанных;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли