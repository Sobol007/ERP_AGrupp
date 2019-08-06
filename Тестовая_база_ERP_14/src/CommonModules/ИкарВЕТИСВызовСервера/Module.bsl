/////////////////////////////////////////////////////////////////////
//
// Запросы к сервису Икар (адресные элементы ВетИС): 
//  * Формирование и выполнение запросов к сервису
//  * Возврат полученных ответов
// Справочная информация по внешней системе:
//    http://help.vetrf.ru/wiki/Автоматизированная_система_Икар
//

#Область ПрограммныйИнтерфейс

#Область Страны

// Возвращает страну мира по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция СтранаПоGUID(Идентификатор) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораСтранПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает страну мира по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция СтранаПоUUID(Идентификатор) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораСтранПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список стран мира.
//
// Параметры:
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокСтран(НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораСтранXML(НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период стран мира.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
//   * НачалоПериода - Дата - Дата начала периода.
//   * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция ИсторияИзмененийСтран(Интервал, НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораСтранXML(Интервал, НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#Область Регионы

// Возвращает регион страны по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция РегионПоGUID(Идентификатор) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораРегионовПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает регион страны по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция РегионПоUUID(Идентификатор) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораРегионовПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список регионов страны.
//
// Параметры:
//  GUIDСтраны - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор страны.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокРегионовСтраны(GUIDСтраны, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораРегионовСтраныXML(GUIDСтраны, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период регионов.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
//   * НачалоПериода - Дата - Дата начала периода.
//   * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция ИсторияИзмененийРегионов(Интервал, НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораРегионовXML(Интервал, НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#Область Районы

// Возвращает район страны по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция РайонПоGUID(Идентификатор) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораРайоновПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает район страны по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция РайонПоUUID(Идентификатор) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораРайоновПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список районов региона.
//
// Параметры:
//  GUIDРегиона - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор региона.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокРайоновРегиона(GUIDРегиона, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораРайоновРегионаXML(GUIDРегиона, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период районов.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
//   * НачалоПериода - Дата - Дата начала периода.
//   * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция ИсторияИзмененийРайонов(Интервал, НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораРайоновXML(Интервал, НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#Область НаселенныеПункты

// Возвращает список населенных пунктов района.
//
// Параметры:
//  GUIDРегиона - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор региона.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокНаселенныхПунктовРегиона(GUIDРегиона, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораНаселенныхПунктовРегионаXML(GUIDРегиона, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список населенных пунктов района с отбором по наименованию.
//
// Параметры:
//  GUIDРегиона - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор региона.
//  Наименование - Строка - Часть наименования населенного пункта.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокНаселенныхПунктовРегионаСОтборомПоНаименованию(GUIDРегиона, Наименование, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораНаселенныхПунктовРегионаПоНаименованиюXML(GUIDРегиона, Наименование, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список населенных пунктов района.
//
// Параметры:
//  GUIDРегиона - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор региона.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокНаселенныхПунктовРайона(GUIDРайона, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораНаселенныхПунктовРайонаXML(GUIDРайона, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список населенных пунктов района.
//
// Параметры:
//  GUIDРегиона - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор региона.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокНаселенныхПунктовНаселенногоПункта(GUIDНаселенногоПункта, НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораНаселенныхПунктовНаселенногоПунктаXML(GUIDНаселенногоПункта, НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период населенных пунктов.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
//   * НачалоПериода - Дата - Дата начала периода.
//   * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция ИсторияИзмененийНаселенныхПунктов(Интервал, НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораНаселенныхПунктовXML(Интервал, НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#Область Улицы

// Возвращает список улиц населенного пункта.
//
// Параметры:
//  GUIDНаселенногоПункта - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор населенного пункта.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокУлицНаселенногоПункта(GUIDНаселенногоПункта, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = ЗапросЭлементовКлассификатораУлицНаселенногоПунктаXML(
		GUIDНаселенногоПункта,
		НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список улиц населенного пункта с отбором по наименованию.
//
// Параметры:
//  GUIDНаселенногоПункта - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор населенного пункта.
//  Наименование - Строка - Часть наименования улицы.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокУлицНаселенногоПунктаСОтборомПоНаименованию(GUIDНаселенногоПункта, Наименование, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = ЗапросЭлементовКлассификатораУлицНаселенногоПунктаПоНаименованиюXML(GUIDНаселенногоПункта, Наименование, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период улиц.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
//   * НачалоПериода - Дата - Дата начала периода.
//   * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция ИсторияИзмененийУлиц(Интервал, НомерСтраницы = 1) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораУлицXML(Интервал, НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗапросЭлементаКлассификатораСтранПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getCountryBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.ИмяЭлемента      = "country";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос страны по идентификатору %1 %2';
														|en = 'запрос страны по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораСтранXML(НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getAllCountryList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "country";
	ПараметрыЗапроса.ИмяСписка        = "countryList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка стран';
											|en = 'запрос списка стран'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораСтранXML(Интервал, НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getCountryChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "country";
	ПараметрыЗапроса.ИмяСписка        = "countryList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов списка стран';
											|en = 'запрос измененных элементов списка стран'");
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции


Функция ЗапросЭлементаКлассификатораРегионовПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getRegionBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.ИмяЭлемента      = "region";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос региона по идентификатору %1 %2';
														|en = 'запрос региона по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораРегионовСтраныXML(GUIDСтраны, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getRegionListByCountry";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "region";
	ПараметрыЗапроса.ИмяСписка        = "regionList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка регионов страны';
											|en = 'запрос списка регионов страны'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	Запрос.countryGuid = GUIDСтраны;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораРегионовXML(Интервал, НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getRegionChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "region";
	ПараметрыЗапроса.ИмяСписка        = "regionList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов списка регионов';
											|en = 'запрос измененных элементов списка регионов'");
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции


Функция ЗапросЭлементаКлассификатораРайоновПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getDistrictBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.ИмяЭлемента      = "district";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос района по идентификатору %1 %2';
														|en = 'запрос района по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораРайоновРегионаXML(GUIDРегиона, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getDistrictListByRegion";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "district";
	ПараметрыЗапроса.ИмяСписка        = "districtList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка районов региона';
											|en = 'запрос списка районов региона'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	Запрос.regionGUID = GUIDРегиона;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораРайоновXML(Интервал, НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getDistrictChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "district";
	ПараметрыЗапроса.ИмяСписка        = "districtList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов списка районов региона';
											|en = 'запрос измененных элементов списка районов региона'");
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции


Функция ЗапросЭлементовКлассификатораНаселенныхПунктовРегионаXML(GUIDРегиона, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getLocalityListByRegion";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "locality";
	ПараметрыЗапроса.ИмяСписка        = "localityList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка стран';
											|en = 'запрос списка стран'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	Запрос.regionGuid = GUIDРегиона;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораНаселенныхПунктовРегионаПоНаименованиюXML(GUIDРегиона, Наименование, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "findLocalityListByName";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "locality";
	ПараметрыЗапроса.ИмяСписка        = "localityList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка стран';
											|en = 'запрос списка стран'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	Запрос.regionGuid = GUIDРегиона;
	Запрос.pattern    = Наименование;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораНаселенныхПунктовРайонаXML(GUIDРайона, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getLocalityListByDistrict";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "locality";
	ПараметрыЗапроса.ИмяСписка        = "localityList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка стран';
											|en = 'запрос списка стран'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	Запрос.districtGUID = GUIDРайона;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораНаселенныхПунктовНаселенногоПунктаXML(GUIDНаселенногоПункта, НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getLocalityListByLocality";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "locality";
	ПараметрыЗапроса.ИмяСписка        = "localityList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка стран';
											|en = 'запрос списка стран'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	Запрос.localityGUID = GUIDНаселенногоПункта;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораНаселенныхПунктовXML(Интервал, НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getLocalityChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "locality";
	ПараметрыЗапроса.ИмяСписка        = "localityList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов списка населенных пунктов';
											|en = 'запрос измененных элементов списка населенных пунктов'");
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции


Функция ЗапросЭлементовКлассификатораУлицНаселенногоПунктаXML(GUIDНаселенногоПункта, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getStreetListByLocality";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "street";
	ПараметрыЗапроса.ИмяСписка        = "streetList";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос списка улиц населенного пункта %1';
														|en = 'запрос списка улиц населенного пункта %1'"), GUIDНаселенногоПункта);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	Запрос.localityGuid = GUIDНаселенногоПункта;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораУлицНаселенногоПунктаПоНаименованиюXML(GUIDНаселенногоПункта, Наименование, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getAllCountryList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "street";
	ПараметрыЗапроса.ИмяСписка        = "streetList";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос списка улиц населенного пункта %1 по шаблону ""%2""';
														|en = 'запрос списка улиц населенного пункта %1 по шаблону ""%2""'"), GUIDНаселенногоПункта, Наименование);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	Запрос.localityGuid = GUIDНаселенногоПункта;
	Запрос.pattern      = Наименование;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораУлицXML(Интервал, НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getStreetChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.Икар;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "street";
	ПараметрыЗапроса.ИмяСписка        = "streetList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов списка улиц';
											|en = 'запрос измененных элементов списка улиц'");
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

#КонецОбласти