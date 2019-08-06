///////////////////////////////////////////////////////////
// Тестирование - Модуль тестирования конфигурации       //
//                                                       //
///////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Метод выполняет помещение во временные таблицы данных по указанным регистрам и указанный месяц
// Создается временная таблица ЭталонИмяОбъектаМетаданных, 
// где ИмяОбъектаМетаданных - это имя регистра. 
// Пример: ЭталонСебестоимостьТоваров.
// Параметры:
//		КонтрольныеРегистры - Массив - Список регистров по которым сохраняются данные.
//		Месяц - Дата - Начало месяца, за который необходимо считать данные.
//		МассивРегистраторов - Массив - Список документов по которым сохраняются движения.
//										Если используется данный параметр, то Месяц не используется.
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - Содержит временные таблицы с выборками по указанным регистрам.
Функция СохранитьЭталонныеДанные(КонтрольныеРегистры, ПараметрыЗапроса = Неопределено, МассивРегистраторов = Неопределено) Экспорт
	
	ТекстЗапроса = "";
	СохранитьЭталонныеДанные = Истина;
	ВременныеТаблицы = Новый МенеджерВременныхТаблиц;
	Если ТипЗнч(ПараметрыЗапроса) = Тип("Дата") Или ПараметрыЗапроса = Неопределено Тогда
		// Поддержим старый интерфейс, когда вторым параметром передавался месяц расчета:
		ПараметрыЗапроса = ПараметрыЗапроса(ПараметрыЗапроса, МассивРегистраторов);
	КонецЕсли;
	
	Для каждого КонтрольныйРегистр Из КонтрольныеРегистры Цикл
		ТекстЗапроса = ТекстЗапроса + СформироватьЗапрос(КонтрольныйРегистр, СохранитьЭталонныеДанные, ПараметрыЗапроса.ОтборПоРегистраторам);
	КонецЦикла;
	
	ЗапросДанных = Новый Запрос(ТекстЗапроса);
	ЗапросДанных.МенеджерВременныхТаблиц = ВременныеТаблицы;
	ЗапросДанных.УстановитьПараметр("МассивРегистраторов", ПараметрыЗапроса.МассивРегистраторов);
	ЗапросДанных.УстановитьПараметр("НачалоПериода", ПараметрыЗапроса.НачалоПериода);
	ЗапросДанных.УстановитьПараметр("КонецПериода", ПараметрыЗапроса.КонецПериода);
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Тестирование.Начато сохранение эталонных данных';
									|en = 'Testing.Started saving reference data'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	ЗапросДанных.ВыполнитьПакет();
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Тестирование.Завершено сохранение эталонных данных';
									|en = 'Testing.Finished saving reference data'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	
	Возврат ВременныеТаблицы;
КонецФункции

// Метод выполняет сравнение данных из временных таблиц с данными из контрольных регистров,
//  возвращает поля по которым расходятся данные с детализацией до исходных и результирующих
//  данных.
//
// Параметры:
//  ВременныеТаблицы		 - МенеджерВременныхТаблиц	 - Содержит эталонные данные.
//  КонтрольныеРегистры		 - Массив					 - Список регистров по которым сравниваются данные.
//  Месяц					 - Дата						 - Начало месяца, за который сравниваются данные.
//  МассивРегистраторов		 - Массив					 - Список документов по которым сохраняются движения.
//  					Если используется данный параметр, то Месяц не используется.
//  ДополнительныеПараметры	 - Структура				 - см. ДополнительныеПараметрыФормированияЗапросаСравнения().
// 
// Возвращаемое значение:
//  Структура - Содержит в себе таблицы с расхождениями по контрольным регистрам.
//
Функция СравнитьСЭталоннымиДанными(ВременныеТаблицы, КонтрольныеРегистры, ПараметрыЗапроса = Неопределено, МассивРегистраторов = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ТекстЗапроса = "";
	СохранитьЭталонныеДанные = Ложь;
	Если ТипЗнч(ПараметрыЗапроса) = Тип("Дата") Или ПараметрыЗапроса = Неопределено Тогда
		// Поддержим старый интерфейс, когда третьим параметром передавался месяц расчета:
		ПараметрыЗапроса = ПараметрыЗапроса(ПараметрыЗапроса, МассивРегистраторов);
	КонецЕсли;
	
	ЗапросДанных = Новый Запрос();
	ЗапросДанных.МенеджерВременныхТаблиц = ВременныеТаблицы;
	ЗапросДанных.УстановитьПараметр("МассивРегистраторов", ПараметрыЗапроса.МассивРегистраторов);
	ЗапросДанных.УстановитьПараметр("НачалоПериода", ПараметрыЗапроса.НачалоПериода);
	ЗапросДанных.УстановитьПараметр("КонецПериода", ПараметрыЗапроса.КонецПериода);
	ЗапросДанных.УстановитьПараметр("ПартионныйУчет22", ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22"));
	ЗапросДанных.УстановитьПараметр("ДатаНачалаПУ22", УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22());
	
	Расхождения = Новый Соответствие();
	КоличествоРасхождений = 0;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Тестирование.Начато сравнение c эталонными данными';
									|en = 'Testing.Started comparison with reference data'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	
	Для каждого КонтрольныйРегистр Из КонтрольныеРегистры Цикл
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выгрузили';
										|en = 'Exported'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()) + " " + КонтрольныйРегистр);
		ДополнительныеПараметрыПоРегистру = Тестирование.ДополнительныеПараметрыФормированияЗапросаСравнения();
		Если ДополнительныеПараметры <> Неопределено Тогда
			ДополнительныеПараметрыПоРегистру = ДополнительныеПараметры[СтрЗаменить(КонтрольныйРегистр,".","_")];
		КонецЕсли;
		ЗапросДанных.Текст = СформироватьЗапрос(КонтрольныйРегистр, СохранитьЭталонныеДанные, ПараметрыЗапроса.ОтборПоРегистраторам, ДополнительныеПараметрыПоРегистру);
		Результат = ЗапросДанных.ВыполнитьПакет();
		Позиция = 2;
		Граница = Результат.Количество();
		Пока Позиция < Граница Цикл
			Если Не Результат[Позиция].Пустой() Тогда
				
				Таблица = Результат[Позиция].Выгрузить();
				СводнаяТаблица = Таблица.Скопировать(, "ТипЗаписиТестирования");
				СводнаяТаблица.Колонки.Добавить("СчетчикСтрок");
				СводнаяТаблица.ЗаполнитьЗначения(1, "СчетчикСтрок");
				СводнаяТаблица.Свернуть("ТипЗаписиТестирования", "СчетчикСтрок");
				ДоРасчета = 0;
				ПослеРасчета = 0;
				Для Каждого Строка Из СводнаяТаблица Цикл
					Если Строка.ТипЗаписиТестирования = "ЗаписиДоРасчета" Тогда
						ДоРасчета = Строка.СчетчикСтрок;
					ИначеЕсли Строка.ТипЗаписиТестирования = "ЗаписиПослеРасчета" Тогда
						ПослеРасчета = Строка.СчетчикСтрок;
					КонецЕсли;
				КонецЦикла;
				КоличествоРасхождений = КоличествоРасхождений + Макс(ДоРасчета, ПослеРасчета);
				ИмяРегистра = Таблица[0].ПолноеИмяРегистра;
				Записи = ОбщегоНазначения.ЗначениеВСтрокуXML(Таблица);
				
				СтруктураРегистра = Новый Структура("Записи, Количество", Записи, Макс(ДоРасчета, ПослеРасчета));
				
				Расхождения.Вставить(ИмяРегистра, СтруктураРегистра);
				
				Таблица.Очистить();
			КонецЕсли;
			Позиция = Позиция + 3;
		КонецЦикла;
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Тестирование.Завершено сравнение c эталонными данными';
									|en = 'Testing.Comparison with reference data finished'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	
	Расхождения.Вставить("КоличествоРасхождений", КоличествоРасхождений);
	
	Возврат Расхождения;
	
КонецФункции

// Метод формирует текст запроса по всем полям для указанного объекта метаданных.
//
// Параметры:
//  ПутьКМетаданным				 - Строка	 - Путь к объекту, по которому сохраняются данные.
//  	Пример "РегистрНакопления.СебестоимостьТоваров".
//  СохранитьВоВременнуюТаблицу	 - Булево	 - Результат запроса будет сохранен во временную таблицу вида
//  	"ЭталонИмяОбъектаМетаданных"
//  ОтборПоРегистраторам		 - Булево	 - Необязательный параметр, при установке в истина в запросе будет накладываться
//  	условие на выборку данных, где регистратор в массиве регистраторов. Отбора
//  	по периоду не будет.
//  ДополнительныеПараметры		 - Структура - см. ДополнительныеПараметрыФормированияЗапросаСравнения().
// 
// Возвращаемое значение:
//  Строка - Текст запроса.
//
Функция СформироватьЗапрос(ПутьКМетаданным,	СохранитьВоВременнуюТаблицу = Ложь, ОтборПоРегистраторам = Ложь, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = ДополнительныеПараметрыФормированияЗапросаСравнения();
	КонецЕсли;
	ИсключаемыеПоля = СписокИсключений(ДополнительныеПараметры.ИсключаемыеПоля);
	ПоляКлючиКоторыеНужноРазвернуть = ДополнительныеПараметры.ПоляКлючиКоторыеНужноРазвернуть;
	
	КоллекцияМетаданных = Метаданные.НайтиПоПолномуИмени(ПутьКМетаданным);
	ИмяРегистра = КоллекцияМетаданных.Имя;
	ЭтоБухРегистр = ОбщегоНазначения.ЭтоРегистрБухгалтерии(КоллекцияМетаданных);
	// Для бух. регистра используем виртуальную таблицу (для получения субконто):
	ПутьКМетаданнымВЗапросе = ПутьКМетаданным + ?(ЭтоБухРегистр, ".ДвиженияССубконто", "");
	// Для виртуальной таблицы бух. регистра могут встречаться значения NULL, определим их как НЕОПРЕДЕЛЕНО:
	УточнениеПоля = ИменаПолейЗапросаПоУмолчанию();
	Если ЭтоБухРегистр Тогда
		УточнениеПоля.Вставить("ВыражениеДо", "ЕСТЬNULL(");
		УточнениеПоля.Вставить("ВыражениеПосле", ", Неопределено)");
		УточнениеПоля.Вставить("Псевдоним");
	КонецЕсли;
	
	СтруктураПолей = СтруктураПолейКоллекции(КоллекцияМетаданных, ДополнительныеПараметры);
	
	Если ДополнительныеПараметры.СгруппироватьПоИзмерениям Тогда
		МассивГруппировки = СтруктураПолей.Измерения;
	Иначе
		МассивГруппировки = Новый Массив();
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивГруппировки, СтруктураПолей.Измерения, Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивГруппировки, СтруктураПолей.Ресурсы, Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивГруппировки, СтруктураПолей.Реквизиты, Истина);
	КонецЕсли;
	
	МассивГруппировкиПосле = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(МассивГруппировки);
	
	РазвернутьПоляКлючи(МассивГруппировки, ПоляКлючиКоторыеНужноРазвернуть, ИсключаемыеПоля);
	
	РазвернутьПоляКлючи(МассивГруппировкиПосле, ПоляКлючиКоторыеНужноРазвернуть, ИсключаемыеПоля, Истина);
	
	Если СохранитьВоВременнуюТаблицу Тогда
		ШаблонТекстЗапроса = "
		|ВЫБРАТЬ
		|	// ТекстИзмеренияРеквизиты //
		|	// ТекстСуммы //
		|	ИСТИНА
		|ПОМЕСТИТЬ ЭталонИмяОбъектаМетаданных
		|ИЗ
		|	ОбъектМетаданных КАК ДД
		|ГДЕ
		|	// ТекстУсловияОтбора //
		|	ИСТИНА
		|;
		|///////////////////////////////////
		|";
		
		ТекстИзмеренияРеквизиты = ДобавитьПоляВЗапрос(МассивГруппировки, УточнениеПоля);
		
		ПолныйТекстЗапроса = СтрЗаменить(ШаблонТекстЗапроса, "// ТекстИзмеренияРеквизиты //", ТекстИзмеренияРеквизиты + ",");
		
		Если СтруктураПолей.ЧисловыеПоля.Количество() > 0 Тогда
			УточнениеПоля.ВыражениеПосле = СтрЗаменить(УточнениеПоля.ВыражениеПосле, "Неопределено", "0");
			ТекстСуммы = ДобавитьПоляВЗапрос(СтруктураПолей.ЧисловыеПоля, УточнениеПоля) + ",";
		Иначе
			ТекстСуммы = "";
		КонецЕсли;
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстСуммы //", ТекстСуммы);
		
		Если ВКоллекцииЕстьПериод(КоллекцияМетаданных) И Не ОтборПоРегистраторам Тогда
			ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстУсловияОтбора //", "ДД.Период МЕЖДУ &НачалоПериода И &КонецПериода И");
		ИначеЕсли ОтборПоРегистраторам Тогда
			ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстУсловияОтбора //", "ДД.Регистратор В (&МассивРегистраторов) И");
		Иначе
			ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстУсловияОтбора //", "");
		КонецЕсли;
		
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "ИмяОбъектаМетаданных", ИмяРегистра);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "ОбъектМетаданных", ПутьКМетаданнымВЗапросе);
	Иначе
		ШаблонТекстЗапроса = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	// ТекстИзмеренияРеквизиты //
		|	ДД.ОбщееПоле
		|	, СУММА(ДД.ЗначениеПроверки)
		|ПОМЕСТИТЬ ПоляРасхожденийИмяОбъектаМетаданных
		|ИЗ
		|	(ВЫБРАТЬ
		|		// ТекстИзмеренияРеквизитыДо //
		|		// ТекстСуммыДо //
		|		Неопределено КАК ОбщееПоле,
		|		1 КАК ЗначениеПроверки
		|	ИЗ
		|		ЭталонИмяОбъектаМетаданных КАК ДД
		|	ГДЕ
		|		// ТекстУсловияОтбораДо // 
		|		ИСТИНА
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		// ТекстИзмеренияРеквизитыПосле //
		|		// ТекстСуммыПосле //
		|		Неопределено КАК ОбщееПоле,
		|		- 1 КАК ЗначениеПроверки
		|	ИЗ
		|		ОбъектМетаданных КАК ДД
		|	ГДЕ
		|		// ТекстУсловияОтбораПосле // 
		|		ИСТИНА
		|	) КАК ДД
		|СГРУППИРОВАТЬ ПО
		|	// ТекстСгруппироватьИндексировать // 
		|	ДД.ОбщееПоле
		|ИМЕЮЩИЕ 
		|	// ТекстПоляКонтроля //
		|	ЛОЖЬ // ТекстУсловияПоКоличествуЗаписей //
		|;
		|/////////////////////////////////////////
		|ВЫБРАТЬ
		|	""ЗаписиДоРасчета""      КАК ТипЗаписиТестирования,
		|	// ТекстИзмеренияРеквизиты //
		|	// ТекстСуммыРасхожденияДо //
		|	""ПолноеИмяОбъектаМетаданных"" КАК ПолноеИмяРегистра,
		|	""ИмяОбъектаМетаданных"" КАК ИмяРегистра
		|
		|ПОМЕСТИТЬ ДетальныеЗаписиИмяОбъектаМетаданных
		|ИЗ
		|	ПоляРасхожденийИмяОбъектаМетаданных КАК ДД
		|
		|	// ТекстВнутреннееСоединениеСЭталоном //
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	""ЗаписиПослеРасчета""   КАК ТипЗаписиТестирования,
		|	// ТекстИзмеренияРеквизитыПосле //
		|	// ТекстСуммыРасхожденияПосле //
		|	""ПолноеИмяОбъектаМетаданных"" КАК ПолноеИмяРегистра,
		|	""ИмяОбъектаМетаданных"" КАК ИмяРегистра
		|ИЗ ПоляРасхожденийИмяОбъектаМетаданных КАК ДД
		|
		|	// ТекстВнутреннееСоединениеСРезультатом //
		|;
		|/////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДД.ТипЗаписиТестирования,
		|	// ТекстИзмеренияРеквизиты //
		|	// ТекстСуммаСумм //
		|	ДД.ПолноеИмяРегистра,
		|	ДД.ИмяРегистра
		|ИЗ ДетальныеЗаписиИмяОбъектаМетаданных КАК ДД
		|СГРУППИРОВАТЬ ПО
		|	ДД.ТипЗаписиТестирования,
		|	// ТекстСгруппироватьИндексировать //
		|	ДД.ПолноеИмяРегистра,
		|	ДД.ИмяРегистра
		|;
		|/////////////////////////////////////////
		|";
		
		ТекстИзмеренияРеквизиты = ДобавитьПоляВЗапрос(МассивГруппировки);
		ПолныйТекстЗапроса = СтрЗаменить(ШаблонТекстЗапроса, "// ТекстИзмеренияРеквизиты //", ТекстИзмеренияРеквизиты + ",");
		
		Если Не ДополнительныеПараметры.СгруппироватьПоИзмерениям Тогда
			ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстУсловияПоКоличествуЗаписей //", "ИЛИ СУММА(ДД.ЗначениеПроверки) <> 0");
		КонецЕсли;
		
		ТекстИзмеренияРеквизитыДо = ТекстИзмеренияРеквизиты;
		ЗаменитьПоля(ТекстИзмеренияРеквизитыДо, ДополнительныеПараметры.ЗаменыПолейДо);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстИзмеренияРеквизитыДо //", ТекстИзмеренияРеквизитыДо + ",");
		
		ТекстИзмеренияРеквизитыПосле = ДобавитьПоляВЗапрос(МассивГруппировкиПосле, УточнениеПоля);
		ЗаменитьПоля(ТекстИзмеренияРеквизитыПосле, ДополнительныеПараметры.ЗаменыПолейПосле);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстИзмеренияРеквизитыПосле //", ТекстИзмеренияРеквизитыПосле + ",");
		
		Если СтруктураПолей.ЧисловыеПоля.Количество() > 0 Тогда
			ИменаПолей = ИменаПолейЗапросаПоУмолчанию();
			ИменаПолей.ВыражениеДо = "ЕСТЬNULL(";
			ИменаПолей.ВыражениеПосле = ", 0)";
			ИменаПолей.Вставить("Псевдоним");
			ТекстСуммыДо = ДобавитьПоляВЗапрос(СтруктураПолей.ЧисловыеПоля, ИменаПолей) + ",";
			ЗаменитьПоля(ТекстСуммыДо, ДополнительныеПараметры.ЗаменыПолейДо);
			
			ИменаПолей.ВыражениеДо = "-"+ИменаПолей.ВыражениеДо;
			ТекстСуммыПосле = ДобавитьПоляВЗапрос(СтруктураПолей.ЧисловыеПоля, ИменаПолей) + ",";
			ЗаменитьПоля(ТекстСуммыПосле, ДополнительныеПараметры.ЗаменыПолейПосле);
			
			ИменаПолей = ИменаПолейЗапросаПоУмолчанию();
			ИменаПолей.ИмяПоля = "Таблица";
			ТекстСуммыРасхожденияДо = ДобавитьПоляВЗапрос(СтруктураПолей.ЧисловыеПоля, ИменаПолей) + ",";
			ЗаменитьПоля(ТекстСуммыРасхожденияДо, ДополнительныеПараметры.ЗаменыПолейДо, "Таблица");
			ТекстСуммыРасхожденияПосле = ДобавитьПоляВЗапрос(СтруктураПолей.ЧисловыеПоля, ИменаПолей) + ",";
			ЗаменитьПоля(ТекстСуммыРасхожденияПосле, ДополнительныеПараметры.ЗаменыПолейПосле, "Таблица");
			
			ИменаПолей = ИменаПолейЗапросаПоУмолчанию();
			ИменаПолей.ВыражениеДо = "СУММА(";
			ИменаПолей.ВыражениеПосле = ")";
			ТекстСуммаСумм = ДобавитьПоляВЗапрос(СтруктураПолей.ЧисловыеПоля, ИменаПолей) + ",";
		Иначе
			ТекстСуммыДо = "";
			ТекстСуммыПосле = "";
			ТекстСуммыРасхожденияДо = "";
			ТекстСуммыРасхожденияПосле = "";
			ТекстСуммаСумм = "";
		КонецЕсли;
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстСуммыДо //", ТекстСуммыДо);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстСуммыПосле //", ТекстСуммыПосле);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстСуммыРасхожденияДо //", ТекстСуммыРасхожденияДо);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстСуммыРасхожденияПосле //", ТекстСуммыРасхожденияПосле);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстСуммаСумм //", ТекстСуммаСумм);
		
		ТекстУсловияОтбораДо = "";
		Если ЗначениеЗаполнено(ДополнительныеПараметры.УсловияОтбораДо) Тогда
			ТекстУсловияОтбораДо = ДополнительныеПараметры.УсловияОтбораДо + " " + "И";
		КонецЕсли;
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстУсловияОтбораДо //", ТекстУсловияОтбораДо);	
		Если ОтборПоРегистраторам Тогда
			ТекстУсловияОтбораПосле = "ДД.Регистратор В (&МассивРегистраторов) И";
		ИначеЕсли ВКоллекцииЕстьПериод(КоллекцияМетаданных) Тогда
			ТекстУсловияОтбораПосле = "ДД.Период МЕЖДУ &НачалоПериода И &КонецПериода И";
		Иначе
			ТекстУсловияОтбораПосле = "ИСТИНА И"	
		КонецЕсли;
			
		Если ЗначениеЗаполнено(ДополнительныеПараметры.УсловияОтбораПосле) Тогда
			ТекстУсловияОтбораПосле = ТекстУсловияОтбораПосле + "
				|(" + ДополнительныеПараметры.УсловияОтбораПосле + ") " + "И";
		КонецЕсли;
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстУсловияОтбораПосле //", ТекстУсловияОтбораПосле);	
		
		ИменаПолей = ИменаПолейЗапросаПоУмолчанию();
		ИменаПолей.ВыражениеДо = "СУММА(";
		ИменаПолей.ВыражениеПосле = ") <> 0 ";
		ИменаПолей.ВыражениеСоединения = "ИЛИ ";
		
		ИменаПолей = ИменаПолейЗапросаПоУмолчанию();
		ИменаПолей.ВыражениеДо = "СУММА(";
		ИменаПолей.ВыражениеСоединения = "ИЛИ"+ " ";
		ИменаПолей.ВыражениеПосле = ") > &ДопустимоеОтклонение" + " ";
		ТекстПоляКонтроля1 = ДобавитьПоляВЗапрос(СтруктураПолей.ЧисловыеПоля, ИменаПолей);
		ИменаПолей.ВыражениеПосле = ") < -&ДопустимоеОтклонение" + " ";
		ТекстПоляКонтроля2 = ДобавитьПоляВЗапрос(СтруктураПолей.ЧисловыеПоля, ИменаПолей);
		ТекстПоляКонтроля = СтрЗаменить(ТекстПоляКонтроля1 + " ИЛИ " + ТекстПоляКонтроля2, "&ДопустимоеОтклонение", ДополнительныеПараметры.ДопустимоеОтклонение);
		
		Если ЗначениеЗаполнено(ТекстПоляКонтроля1) Тогда
			ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстПоляКонтроля //", ТекстПоляКонтроля + " " + "ИЛИ");
		Иначе
			ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстПоляКонтроля //", "");
		КонецЕсли;
		
		ИменаПолей = ИменаПолейЗапросаПоУмолчанию();
		ИменаПолей.ВыражениеДо = "";
		ИменаПолей.ВыражениеПосле = " ";
		ТекстСгруппироватьИндексировать = ДобавитьПоляВЗапрос(МассивГруппировки, ИменаПолей);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстСгруппироватьИндексировать //", ТекстСгруппироватьИндексировать + ",");
		
		ВнутреннееСоединениеСЭталоном = ТекстВнутреннегоСоединения(МассивГруппировки, "ЭталонИмяОбъектаМетаданных");
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстВнутреннееСоединениеСЭталоном //", ВнутреннееСоединениеСЭталоном);
		
		
		Если ПоляКлючиКоторыеНужноРазвернуть.Количество() > 0 Тогда
			ВнутреннееСоединениеСРезультатом = ТекстВнутреннегоСоединения(МассивГруппировкиПосле, "ОбъектМетаданных", УточнениеПоля);
			Для Каждого Поле Из ПоляКлючиКоторыеНужноРазвернуть Цикл
				ВнутреннееСоединениеСРезультатом = СтрЗаменить(ВнутреннееСоединениеСРезультатом, "ДД." + Поле + ".", "ДД." + Поле);
			КонецЦикла;
		Иначе
			ВнутреннееСоединениеСРезультатом = ТекстВнутреннегоСоединения(МассивГруппировки, "ОбъектМетаданных", УточнениеПоля);
		КонецЕсли;
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "// ТекстВнутреннееСоединениеСРезультатом //", ВнутреннееСоединениеСРезультатом);
		
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "ПолноеИмяОбъектаМетаданных", ПутьКМетаданным);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "ИмяОбъектаМетаданных", ИмяРегистра);
		ПолныйТекстЗапроса = СтрЗаменить(ПолныйТекстЗапроса, "ОбъектМетаданных", ПутьКМетаданнымВЗапросе);
	КонецЕсли;
	Возврат ПолныйТекстЗапроса;
КонецФункции

Функция ДополнительныеПараметрыФормированияЗапросаСравнения() Экспорт
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИсключаемыеПоля", Новый Структура);
	ДополнительныеПараметры.Вставить("ЗаменыПолейДо", Новый Структура);
	ДополнительныеПараметры.Вставить("ЗаменыПолейПосле", Новый Структура);
	ДополнительныеПараметры.Вставить("СгруппироватьПоИзмерениям", Ложь);
	ДополнительныеПараметры.Вставить("ПоляКлючиКоторыеНужноРазвернуть", Новый Массив);
	ДополнительныеПараметры.Вставить("УсловияОтбораДо", "");
	ДополнительныеПараметры.Вставить("УсловияОтбораПосле", "");
	ДополнительныеПараметры.Вставить("ДопустимоеОтклонение", 0);
	ДополнительныеПараметры.Вставить("ПроверятьКонтрольнуюСумму", Истина);
	Возврат ДополнительныеПараметры;
КонецФункции

Функция ПараметрыЗапроса(Месяц, МассивРегистраторов = Неопределено) Экспорт
	
	ПараметрыЗапроса = Новый Структура("НачалоПериода, КонецПериода, МассивРегистраторов, ОтборПоРегистраторам");
	Если Не ЗначениеЗаполнено(МассивРегистраторов) Тогда // переинициализируем параметр, чтобы запрос не падал
		ПараметрыЗапроса.МассивРегистраторов = Новый Массив();
		ПараметрыЗапроса.ОтборПоРегистраторам = Ложь;
	Иначе
		ПараметрыЗапроса.ОтборПоРегистраторам = Истина;
		ПараметрыЗапроса.МассивРегистраторов = МассивРегистраторов;
	КонецЕсли;
	Если ЗначениеЗаполнено(Месяц) Тогда
		ПараметрыЗапроса.НачалоПериода = НачалоМесяца(Месяц);
		ПараметрыЗапроса.КонецПериода = КонецМесяца(Месяц);
	Иначе
		ПараметрыЗапроса.НачалоПериода = Дата("00010101000000");
		ПараметрыЗапроса.КонецПериода = Дата("39991212235959");
	КонецЕсли;
	
	Возврат ПараметрыЗапроса;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция СтруктураПолейКоллекции(Коллекция, ДопПараметры) Экспорт
	
	МассивЧисловыхПолей = Новый Массив;
	СписокИсключений = СписокИсключений(ДопПараметры.ИсключаемыеПоля);
	ЭтоБухРегистр = ОбщегоНазначения.ЭтоРегистрБухгалтерии(Коллекция);
	
	#Область Ресурсы
	
	МассивРесурсов = Новый Массив;
	
	Для каждого Поле Из Коллекция.Ресурсы Цикл
		Если Не СписокИсключений.Свойство(Поле.Имя) Тогда
			ПолеЧисловогоТипа = Строка(Поле.Тип) = Строка(Новый ОписаниеТипов("Число",,,Поле.Тип.КвалификаторыЧисла));
			МассивДляДобавления = ?(ПолеЧисловогоТипа, МассивЧисловыхПолей, МассивРесурсов);
			Если Поле.Тип <> Новый ОписаниеТипов("Строка") Тогда
				Если ЭтоБухРегистр И Не Поле.Балансовый Тогда
					МассивДляДобавления.Добавить(Поле.Имя+"Дт");
					МассивДляДобавления.Добавить(Поле.Имя+"Кт");
				Иначе
					МассивДляДобавления.Добавить(Поле.Имя);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	#КонецОбласти
	
	#Область Измерения
	
	МассивИзмерений = Новый Массив;
	
	Для каждого Поле Из Коллекция.Измерения Цикл
		Если Не СписокИсключений.Свойство(Поле.Имя) Тогда
			ПолеЧисловогоТипа = Строка(Поле.Тип) = Строка(Новый ОписаниеТипов("Число",,,Поле.Тип.КвалификаторыЧисла));
			МассивДляДобавления = ?(Не ДопПараметры.СгруппироватьПоИзмерениям И ПолеЧисловогоТипа, МассивЧисловыхПолей, МассивИзмерений);
			Если Поле.Тип <> Новый ОписаниеТипов("Строка") Тогда
				Если ЭтоБухРегистр И Не Поле.Балансовый Тогда
					МассивДляДобавления.Добавить(Поле.Имя+"Дт");
					МассивДляДобавления.Добавить(Поле.Имя+"Кт");
				Иначе
					МассивДляДобавления.Добавить(Поле.Имя);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	#КонецОбласти
	
	#Область СтандартныеРеквизиты
	
	ОбязательныеСтандартныеРеквизиты = СтрРазделить("Период,Регистратор,ВидДвижения,Активность", ",");
	
	Для каждого РеквизитРегистра Из Коллекция.СтандартныеРеквизиты Цикл
		
		Если ОбязательныеСтандартныеРеквизиты.Найти(РеквизитРегистра.Имя) <> Неопределено Тогда
			
			МассивИзмерений.Добавить(РеквизитРегистра.Имя);
				
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЭтоБухРегистр Тогда
		// Добавим счет и субконто:
		МассивИзмерений.Добавить("СчетДт");
		МассивИзмерений.Добавить("СчетКт");
		МассивИзмерений.Добавить("СубконтоДт1");
		МассивИзмерений.Добавить("СубконтоКт1");
		МассивИзмерений.Добавить("СубконтоДт2");
		МассивИзмерений.Добавить("СубконтоКт2");
		МассивИзмерений.Добавить("СубконтоДт3");
		МассивИзмерений.Добавить("СубконтоКт3");
	КонецЕсли;
	
	#КонецОбласти
	
	#Область Реквизиты
	
	МассивРеквизитов = Новый Массив;
	
	Для каждого Поле Из Коллекция.Реквизиты Цикл
		Если Не СписокИсключений.Свойство(Поле.Имя) Тогда
			ПолеЧисловогоТипа = Строка(Поле.Тип) = Строка(Новый ОписаниеТипов("Число",,,Поле.Тип.КвалификаторыЧисла));
			МассивДляДобавления = ?(Не ДопПараметры.СгруппироватьПоИзмерениям И ПолеЧисловогоТипа, МассивЧисловыхПолей, МассивРеквизитов);
			Если Поле.Тип <> Новый ОписаниеТипов("Строка") Тогда
				МассивДляДобавления.Добавить(Поле.Имя);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	#КонецОбласти
	
	#Область СтруктураВозврата
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Измерения", МассивИзмерений);
	СтруктураПолей.Вставить("Реквизиты", МассивРеквизитов);
	СтруктураПолей.Вставить("Ресурсы", МассивРесурсов);
	СтруктураПолей.Вставить("ЧисловыеПоля", МассивЧисловыхПолей);
	
	#КонецОбласти
	
	Возврат СтруктураПолей;
	
КонецФункции

// Возвращает массив полей, которые необходимо исключать при формировании
// текста запроса.
Функция СписокИсключений(ИсключаемыеПоля)
	СписокИсключений = Новый Структура;
	СписокИсключений.Вставить("ИдентификаторСтроки", Истина);
	СписокИсключений.Вставить("НомерСтроки", Истина);
	СписокИсключений.Вставить("Комментарий", Истина);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СписокИсключений,ИсключаемыеПоля);
	
	Возврат СписокИсключений;
КонецФункции

// Формирует текст внутреннего соединения для указанных полей и источника.
Функция ТекстВнутреннегоСоединения(МассивПолей, ИмяИсточника, ДополнительноеУточнениеПоляИсточника = Неопределено)
	
	Если ДополнительноеУточнениеПоляИсточника = Неопределено Тогда 
		ДополнительноеУточнениеПоляИсточника = ИменаПолейЗапросаПоУмолчанию();
	КонецЕсли;
	
	Шаблон = "ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИмяИсточникаДанных КАК Таблица
	|ПО ";
	ТекстВнутреннегоСоединения = СтрЗаменить(Шаблон, "ИмяИсточникаДанных", ИмяИсточника);
	
	ПерваяЗапись = Истина;
	Для Каждого Поле Из МассивПолей Цикл
		Если (Поле = "ВалютаДт" Или Поле = "ВалютаКт"
			Или Поле = "ПодразделениеДт" Или Поле = "ПодразделениеКт"
			Или Поле = "НаправлениеДеятельностиДт" Или Поле = "НаправлениеДеятельностиКт")
			И ЗначениеЗаполнено(ДополнительноеУточнениеПоляИсточника.ВыражениеПосле) Тогда
			// Обход ошибки платформы (для не валютных счетов валюта будет заполняться пустой ссылкой после реструктуризации)
			Если СтрНачинаетсяС(Поле, "Валюта") Тогда
				ВыражениеПосле = ", ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка))";
			ИначеЕсли СтрНачинаетсяС(Поле, "Подразделение") Тогда
				ВыражениеПосле = ", ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))";
			ИначеЕсли СтрНачинаетсяС(Поле, "НаправлениеДеятельности") Тогда
				ВыражениеПосле = ", ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка))";
			Иначе
				ВыражениеПосле = ДополнительноеУточнениеПоляИсточника.ВыражениеПосле;
			КонецЕсли;
		Иначе
			ВыражениеПосле = ДополнительноеУточнениеПоляИсточника.ВыражениеПосле;
		КонецЕсли;
		ПолеТаблицыИсточника = ДополнительноеУточнениеПоляИсточника.ВыражениеДо + "Таблица.ИмяПоля" + ВыражениеПосле;
		Шаблон = "ДД.ИмяПоля = " + ПолеТаблицыИсточника;
		ТекстПО = СтрЗаменить(Шаблон, "ИмяПоля", Поле);
		Если Не ПерваяЗапись Тогда
			ТекстПО = " И " + ТекстПО;
		КонецЕсли;
		ТекстВнутреннегоСоединения = ТекстВнутреннегоСоединения + "
		| " + ТекстПО;
		ПерваяЗапись = Ложь;
	КонецЦикла;
	Возврат ТекстВнутреннегоСоединения;
КонецФункции

Функция ИменаПолейЗапросаПоУмолчанию()
	ИменаПолейПоУмолчанию = Новый Структура;
	ИменаПолейПоУмолчанию.Вставить("ВыражениеДо", "");
	ИменаПолейПоУмолчанию.Вставить("ВыражениеПосле", "");
	ИменаПолейПоУмолчанию.Вставить("ВыражениеСоединения", ",");
	ИменаПолейПоУмолчанию.Вставить("ИмяПоля", "ДД");
	
	Возврат ИменаПолейПоУмолчанию;
КонецФункции

Функция ДобавитьПоляВЗапрос(МассивПолей, ИменаПолей = Неопределено)
	Если ИменаПолей = Неопределено Тогда 
		ИменаПолей = ИменаПолейЗапросаПоУмолчанию();
	КонецЕсли;
	ТекстПолей = "";
	Счетчик = 1;
	Граница = МассивПолей.Количество();
	Для Каждого Поле Из МассивПолей  Цикл
		Если (Поле = "ВалютаДт" Или Поле = "ВалютаКт"
			Или Поле = "ПодразделениеДт" Или Поле = "ПодразделениеКт"
			Или Поле = "НаправлениеДеятельностиДт" Или Поле = "НаправлениеДеятельностиКт")
			И ЗначениеЗаполнено(ИменаПолей.ВыражениеПосле) Тогда
			// Обход ошибки платформы (для не валютных счетов валюта будет заполняться пустой ссылкой после реструктуризации)
			Если СтрНачинаетсяС(Поле, "Валюта") Тогда
				ВыражениеПосле = ", ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка))";
			ИначеЕсли СтрНачинаетсяС(Поле, "Подразделение") Тогда
				ВыражениеПосле = ", ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))";
			ИначеЕсли СтрНачинаетсяС(Поле, "НаправлениеДеятельности") Тогда
				ВыражениеПосле = ", ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка))";
			Иначе
				ВыражениеПосле = ИменаПолей.ВыражениеПосле;
			КонецЕсли;
		Иначе
			ВыражениеПосле = ИменаПолей.ВыражениеПосле;
		КонецЕсли;
		ТекстПолей = ТекстПолей  + "
		|" + ИменаПолей.ВыражениеДо + ИменаПолей.ИмяПоля + "." + Поле + ВыражениеПосле;
		Если ИменаПолей.ВыражениеПосле = "" ИЛИ ИменаПолей.ВыражениеПосле = ")" ИЛИ ИменаПолей.Свойство("Псевдоним") Тогда
			ТекстПолей = ТекстПолей + " КАК "+ СтрЗаменить(Поле,".","");
		КонецЕсли;
		Если Счетчик < Граница Тогда
			ТекстПолей = ТекстПолей + ИменаПолей.ВыражениеСоединения;
		КонецЕсли;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	Возврат ТекстПолей;
КонецФункции

// проверят коллекцию на наличие поля "Период"
Функция ВКоллекцииЕстьПериод(Коллекция)
	ЕстьПериод = Ложь;
	Для Каждого Элемент Из Коллекция.СтандартныеРеквизиты Цикл
		Если Элемент.Имя = "Период" Тогда
			ЕстьПериод = Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат ЕстьПериод;
КонецФункции

Процедура РазвернутьПоляКлючи(МассивИзмерений, ПоляКлючиКоторыеНужноРазвернуть, ИсключаемыеПоля, ПолучитьПоляЧерезТочку = Ложь)
	
	Для Каждого Поле Из ПоляКлючиКоторыеНужноРазвернуть Цикл
		ИндексЭлемента = МассивИзмерений.Найти(Поле);
		Если ИндексЭлемента <> Неопределено Тогда
			МассивИзмерений.Удалить(ИндексЭлемента);
		КонецЕсли;
		Для Каждого МетаАналитика Из Метаданные.Справочники.КлючиАналитикиУчетаНоменклатуры.Реквизиты Цикл
			ПсевдонимПоля = Поле + МетаАналитика.Имя;
			Если Не ИсключаемыеПоля.Свойство(ПсевдонимПоля) Тогда
				Если ПолучитьПоляЧерезТочку Тогда
					МассивИзмерений.Добавить(Поле + "." + МетаАналитика.Имя);
				Иначе
					МассивИзмерений.Добавить(ПсевдонимПоля);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаменитьПоля(ИсходныйТекст, ЗаменыПолей, ПсевдонимТаблицы = "ДД")
	Для Каждого КлючИЗначение Из ЗаменыПолей Цикл
		 ИсходныйТекст = СтрЗаменить(ИсходныйТекст, ПсевдонимТаблицы + "." + КлючИЗначение.Ключ + " " + "КАК",СтрЗаменить(КлючИЗначение.Значение,"Т.",ПсевдонимТаблицы + ".") + " " + "КАК");
	КонецЦикла;
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции