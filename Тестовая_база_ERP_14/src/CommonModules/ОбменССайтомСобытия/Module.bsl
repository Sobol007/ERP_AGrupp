#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаписатьОшибку(ТекстСообщения, УзелОбмена) Экспорт
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтами';
									|en = 'Exchange with sites'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Предупреждение,
				УзелОбмена.Метаданные(),
				УзелОбмена,
				ТекстСообщения + НСтр("ru = 'Обмен отменен.';
										|en = 'The exchange has been canceled.'"));
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

// Обработчик подписки на событие "ОбменССайтомПередЗаписьюРегистра".
// Выполняет регистрацию изменений для узлов плана обмена с сайтом. 
//
Процедура ОбменССайтомПередЗаписьюРегистраПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	ЗарегистрироватьИзменения(Источник, Замещение);
	
КонецПроцедуры

// Обработчик подписки на событие "ОбменССайтомПриЗаписиСправочника".
// Выполняет регистрацию изменений для узлов плана обмена с сайтом. 
//
Процедура ОбменССайтомПриЗаписиОбъектаПриЗаписи(Источник, Отказ) Экспорт
	
	ЗарегистрироватьИзменения(Источник);
	
КонецПроцедуры

// Записывает в структуру ссылки на измененные объекты по узлу плана обмена.
//
// Параметры:
//  УзелПланаОбмена - планОбменаСсылка - узел плана обмена "Обмен с сайтом".
//  СтруктураВозврата - структура - зарегистрированные объекты для обмена.
//
Процедура ЗаполнитьСтруктуруИзмененийДляУзла(УзелПланаОбмена, СтруктураВозврата) Экспорт
	
	СтруктураВозврата.Вставить("Товары", Новый Массив);
	СтруктураВозврата.Вставить("Заказы", Новый Массив);
	
	ПолучитьИзмененияУзла(СтруктураВозврата, УзелПланаОбмена);
	
КонецПроцедуры

// Удаляет регистрацию у тех заказов, которые были загружены с сайта
//
Процедура ОтменитьРегистрацию(ЗаказСсылка) Экспорт
	
	МассивУзлов = ОбменССайтомПовтИсп.МассивУзловДляРегистрации(, Истина);
	ПланыОбмена.УдалитьРегистрациюИзменений(МассивУзлов, ЗаказСсылка);
	
КонецПроцедуры

// Выполняет запуск обмена с сайтом из регламентного задания.
//
// Параметры:
//  КодУзлаОбмена		- строка с кодом узла плана обмена.
Процедура ЗаданиеВыполнитьОбмен(КодУзлаОбмена) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбменССайтом);
	
	УзелОбмена = ПланыОбмена.ОбменССайтом.НайтиПоКоду(КодУзлаОбмена);
	
	Если Не ЗначениеЗаполнено(УзелОбмена) Тогда
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтами';
										|en = 'Exchange with sites'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			УзелОбмена.Метаданные(),
			УзелОбмена,
			НСтр("ru = 'Не найден узел обмена с кодом';
				|en = 'Exchange node with code is not found'") + " " + КодУзлаОбмена);
		
		Возврат;
		
	КонецЕсли;
	
	Если УзелОбмена.ПометкаУдаления Тогда
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтами';
										|en = 'Exchange with sites'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,
			УзелОбмена.Метаданные(),
			УзелОбмена,
			НСтр("ru = 'Настройка обмена помечена на удаление. Обмен отменен.';
				|en = 'The exchange setting is marked for deletion. Exchange is canceled.'"));
		
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбмен(УзелОбмена, НСтр("ru = 'Фоновый обмен';
									|en = 'Background exchange'"));
	
КонецПроцедуры

// Запускает процедуру обмена с сайтом.
// Параметры
//  УзелОбмена - Ссылка на план обмена с сайтом.
//  РежимЗапускаОбмена - строка - поясняющая был ли обмен запущен интерактивно
//						или через регл. задание.
//  ВыгружатьТолькоИзменения - Булево - определяет будут выгружаться все данные
// 						или только зарегистрированные.
Процедура ВыполнитьОбмен(УзелОбмена, РежимЗапускаОбмена, ВыгружатьТолькоИзменения = Истина, ПараметрыОбновления = Неопределено) Экспорт
	
	Отказ = Ложь;
	ОписаниеОшибки = "";
	
	// Перед обменом необходимо убедиться что есть доступ на сайт или к каталогу.
	ТекстСообщения = "";
	СвойстваНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УзелОбмена, 
		"ВыгружатьНаСайт, ФайлЗагрузки, КаталогВыгрузки, ОбменТоварами, ОбменЗаказами,
		|РазмерПорции, КоличествоПовторений, ВладелецКаталога, ОбменЗаказами, ОбменТоварами, ВидОтбораПоНоменклатуре,
		|ВыгружатьКартинки, ВыгружатьТовары, ВыгружатьЦеныОстатки, ВыгружатьОбновленияЦенИОстатков");
	Если СвойстваНастройки.ВыгружатьНаСайт Тогда
		
		ДоступноПодключениеКСайту = Ложь;
		
		ПроверитьПодключениеКСайту(ДоступноПодключениеКСайту, УзелОбмена, ТекстСообщения);
		Если Не ДоступноПодключениеКСайту Тогда
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтами';
											|en = 'Exchange with sites'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Предупреждение,
				УзелОбмена.Метаданные(),
				УзелОбмена,
				ТекстСообщения + " " + НСтр("ru = 'Обмен отменен.';
											|en = 'The exchange has been canceled.'"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		Отказ = Ложь;
		Если СвойстваНастройки.ОбменТоварами Тогда
			ТекстСообщения = "";

			КаталогВыгрузки = СвойстваНастройки.КаталогВыгрузки;
			КаталогДоступен = Ложь;
			ПроверитьДоступностьКаталогаВыгрузки(КаталогДоступен, КаталогВыгрузки, ТекстСообщения);
			Если Не КаталогДоступен Тогда
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтами';
												|en = 'Exchange with sites'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Предупреждение,
				УзелОбмена.Метаданные(),
				УзелОбмена,
				ТекстСообщения + " " + НСтр("ru = 'Обмен отменен.';
											|en = 'The exchange has been canceled.'"));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				
				Отказ = Истина;
				
			КонецЕсли;
		КонецЕсли;
		
		Если СвойстваНастройки.ОбменЗаказами Тогда
			ТекстСообщения = "";

			ФайлЗагрузки = СвойстваНастройки.ФайлЗагрузки;
			ФайлЗагрузкиДоступен = Истина;
			ПроверитьДоступностьФайлаЗагрузки(ФайлЗагрузкиДоступен, ФайлЗагрузки, ТекстСообщения);
			Если Не ФайлЗагрузкиДоступен Тогда
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтами';
												|en = 'Exchange with sites'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Предупреждение,
					УзелОбмена.Метаданные(),
					УзелОбмена,
					ТекстСообщения + " " + НСтр("ru = 'Обмен отменен.';
												|en = 'The exchange has been canceled.'"));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				
				Отказ = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ТаблицаИнформации = РегистрыСведений.СостоянияОбменовССайтом.СоздатьНаборЗаписей().Выгрузить();
	ТаблицаИнформации.Колонки.Добавить("Описание", Новый ОписаниеТипов("Строка"));
	
	НастройкиПодключения = Новый Структура;
	ЗаполнитьНастройкиПодключения(НастройкиПодключения, УзелОбмена);
	
	РазрешенныеТипыКартинок = Новый Массив;
	РазрешенныеТипыКартинок.Добавить("gif");
	РазрешенныеТипыКартинок.Добавить("jpg");
	РазрешенныеТипыКартинок.Добавить("jpeg");
	РазрешенныеТипыКартинок.Добавить("png");

	
	ПараметрыОбмена = Новый Структура;
	ПараметрыОбмена.Вставить("УзелОбмена", УзелОбмена);
	ПараметрыОбмена.Вставить("НастройкиПодключения", НастройкиПодключения);
	
	Если ВыгружатьТолькоИзменения Тогда
		ВыгружатьИзменения = УзелОбмена.ВыгружатьИзменения;
	Иначе
		ВыгружатьИзменения = Ложь;
	КонецЕсли;
	ПараметрыОбмена.Вставить("ВыгружатьИзменения", ВыгружатьИзменения);
	
	ПараметрыОбмена.Вставить("ВидОтбораПоНоменклатуре", СвойстваНастройки.ВидОтбораПоНоменклатуре);
	ПараметрыОбмена.Вставить("РазмерПорции", СвойстваНастройки.РазмерПорции);
	ПараметрыОбмена.Вставить("КоличествоПовторов",СвойстваНастройки.КоличествоПовторений);
	ПараметрыОбмена.Вставить("ВладелецКаталога", СвойстваНастройки.ВладелецКаталога);
	ПараметрыОбмена.Вставить("ОбменЗаказами", СвойстваНастройки.ОбменЗаказами);
	ПараметрыОбмена.Вставить("ОбменТоварами", СвойстваНастройки.ОбменТоварами);
	
	ПараметрыОбмена.Вставить("ВыгружатьТовары", СвойстваНастройки.ВыгружатьТовары);
	ПараметрыОбмена.Вставить("ВыгружатьЦеныОстатки", СвойстваНастройки.ВыгружатьЦеныОстатки);
	ПараметрыОбмена.Вставить("ВыгружатьОбновленияЦенИОстатков", СвойстваНастройки.ВыгружатьОбновленияЦенИОстатков);
	
	ПараметрыОбмена.Вставить("КаталогВыгрузки", СвойстваНастройки.КаталогВыгрузки);
	ПараметрыОбмена.Вставить("ВыгружатьНаСайт", СвойстваНастройки.ВыгружатьНаСайт);
	ПараметрыОбмена.Вставить("ВыгружатьКартинки", СвойстваНастройки.ВыгружатьКартинки);
	
	ПараметрыОбмена.Вставить("РазрешенныеТипыКартинок",РазрешенныеТипыКартинок);
	ПараметрыОбмена.Вставить("НаименованиеНалога", НСтр("ru = 'НДС';
														|en = 'VAT'"));
	
	ИспользоватьХарактеристики = Истина;
	
	ОбменССайтомПереопределяемый.УстановитьПризнакИспользоватьХарактеристики(ИспользоватьХарактеристики);
	ПараметрыОбмена.Вставить("ИспользоватьХарактеристики", ИспользоватьХарактеристики);
	
	ПараметрыОбмена.Вставить("РежимЗапускаОбмена", РежимЗапускаОбмена);
	
	ПрикладныеПараметры = ПараметрыПрикладногоРешения(УзелОбмена);
	
	ПараметрыОбмена.Вставить("ПрикладныеПараметры", ПрикладныеПараметры);
	
	ФайлЗагрузки = УзелОбмена.ФайлЗагрузки;
	ФайлЗагрузки = ОбменССайтом.ПодготовитьПутьДляПлатформы(ОбменССайтом.ПлатформаWindows(), ФайлЗагрузки);
	
	ПараметрыОбмена.Вставить("ФайлЗагрузки", ФайлЗагрузки);
	
	ПараметрыОбмена.Вставить("МассивКаталогов", Новый Массив);
	ПараметрыОбмена.Вставить("ДанныеОЗаказах", Неопределено);
	
	СтруктураИзменений = Новый Структура;
	СтруктураИзменений.Вставить("Заказы", Новый Массив);
	Если ВыгружатьТолькоИзменения Тогда
		СтруктураИзменений.Вставить("Товары", Новый Массив);
	КонецЕсли;
	ПолучитьИзмененияУзла(СтруктураИзменений, УзелОбмена);
	
	ПараметрыОбмена.Вставить("СтруктураИзменений",СтруктураИзменений);
	
	ОбменССайтомПереопределяемый.ИзменитьПараметрыОбмена(ПараметрыОбмена, УзелОбмена);
	
	РезультатОбмена = Новый Структура;
	
	ОбменССайтом.ВыполнитьОбменССайтом(ПараметрыОбмена, РезультатОбмена, ТаблицаИнформации);
	
	Ошибка = (Не РезультатОбмена.ТоварыВыгружены) Или (Не РезультатОбмена.ВыполненОбменЗаказами);
	
	Если ПараметрыОбмена.Свойство("СтруктураСтатистики")
		И ПараметрыОбмена.СтруктураСтатистики.Загружено.Количество() > 0 Тогда
		ИмяДокументаЗаказ = ОбменССайтомПовтИсп.ИмяПрикладногоДокумента("ЗаказПокупателя");
		Если Не ИмяДокументаЗаказ = Неопределено Тогда
			ПараметрыОбновления.Обновить = Истина;
			ПараметрыОбновления.ИмяДокументаЗаказ = ИмяДокументаЗаказ;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьДействияПриЗавершенииОбмена(ПараметрыОбмена, ТаблицаИнформации, Ошибка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет доступно ли подключение к сайту.
// Параметры:
//  Результат - результат проверки подключения.
//  УзелОбмена - ссылка на узел обмена.
//  ТекстСообщения - строка - описание ошибки.
//
Процедура ПроверитьПодключениеКСайту(Результат, УзелОбмена, ТекстСообщения)
	
	НастройкиПодключения = Новый Структура;
	ЗаполнитьНастройкиПодключения(НастройкиПодключения, УзелОбмена);
	
	ТекстСообщения = "";
	Если ОбменССайтом.ВыполнитьТестовоеПодключениеКСайту(НастройкиПодключения, ТекстСообщения) Тогда
		Результат = Истина;
	Иначе
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтами';
										|en = 'Exchange with sites'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение,
			УзелОбмена.Метаданные(),
			УзелОбмена,
			ТекстСообщения + " " + НСтр("ru = 'Обмен отменен.';
										|en = 'The exchange has been canceled.'"));
			
		Результат = Ложь;
		
	КонецЕсли;
	

КонецПроцедуры

Процедура ПроверитьДоступностьФайлаЗагрузки(ФайлДоступен, ФайлЗагрузки, ТестСообщения)
	
	ФайлОбмена = Новый Файл(ФайлЗагрузки);
	Если Не ФайлОбмена.Существует() Тогда
		
		Попытка
			ТестовыйДокумент = Новый ТекстовыйДокумент;
			ТестовыйДокумент.ВставитьСтроку(1, "Test");
			ТестовыйДокумент.Записать(ФайлЗагрузки);
			
			УдалитьФайлы(ФайлЗагрузки);
			
		Исключение
			ОписаниеИсключительнойОшибки = ОбменССайтом.ОписаниеИсключительнойОшибки(
												НСтр("ru = 'Нет доступа к файлу обмена заказами:';
													|en = 'No access to the order exchange file:'")
												+ " "+ ФайлЗагрузки);
			ОбменССайтом.ДобавитьОписаниеОшибки(ТестСообщения, ОписаниеИсключительнойОшибки);
			ФайлДоступен = Ложь;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДоступностьКаталогаВыгрузки(КаталогДоступен, КаталогВыгрузки, ТекстСообщения)
	
	КаталогДоступен = Истина;
		
	Если ПустаяСтрока(КаталогВыгрузки) Тогда
		
		КаталогВыгрузки = ЭлектронноеВзаимодействиеСлужебный.РабочийКаталог();
		
	Иначе
		
		ПоследнийСимвол = Прав(КаталогВыгрузки, 1);
		
		Если НЕ ПоследнийСимвол = "\" Тогда
			КаталогВыгрузки = КаталогВыгрузки + "\";
		КонецЕсли;
		
	КонецЕсли;
	
	ПодкаталогБезопасностиКаталогаВыгрузки = "webdata";
	КаталогНаДиске = КаталогВыгрузки + ПодкаталогБезопасностиКаталогаВыгрузки;
	КаталогНаДиске = ОбменССайтом.ПодготовитьПутьДляПлатформы(ОбменССайтом.ПлатформаWindows(), КаталогНаДиске);
	
	Попытка
		
		СоздатьКаталог(КаталогНаДиске);
		
	Исключение
		
		ОписаниеОшибки = "";
		ШаблонОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка доступа к каталогу обмена %1';
																					|en = 'An error occurred when accessing the %1 exchange directory'")
			, КаталогНаДиске);
		ТекстСообщения = ОбменССайтом.ОписаниеИсключительнойОшибки(ОписаниеОшибки, ШаблонОшибки);
		КаталогДоступен = Ложь;
		
		Возврат;
		
	КонецПопытки;
	
	ОписаниеОшибки = "";
	Если НЕ ОчиститьКаталог(КаталогНаДиске, ОписаниеОшибки) Тогда
		
		ТекстСообщения = ОписаниеОшибки;
		КаталогДоступен = Ложь;
		
		Возврат;
	
	КонецЕсли;
	
КонецПроцедуры

// Выборочно регистрирует изменения для узлов плана обмена с сайтом.
//
// Параметры:
//	Объект		- Объект метаданных - источник события
//	Замещение - режим записи набора записей регистра.
//
Процедура ЗарегистрироватьИзменения(Объект, Замещение = Ложь)
	
	Если СтандартныеПодсистемыСервер.ЭтоИдентификаторОбъектаМетаданных(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипОбъекта = ТипЗнч(Объект);
	МассивУзловТовары = ОбменССайтомПовтИсп.МассивУзловДляРегистрации(Истина);
	МассивУзловЗаказы = ОбменССайтомПовтИсп.МассивУзловДляРегистрации(,Истина);
	ОбменССайтомПереопределяемый.ЗарегистрироватьИзмененияВУзлах(Объект, МассивУзловТовары, МассивУзловЗаказы, Замещение);
	
КонецПроцедуры

Процедура ЗаполнитьНастройкиПодключения(НастройкиПодключения, УзелОбмена)
	
	НастройкиПодключения.Вставить("Пользователь", УзелОбмена.ИмяПользователя);
	НастройкиПодключения.Вставить("АдресСайта", УзелОбмена.АдресСайта);
	
	УстановитьПривилегированныйРежим(Истина);
	ПарольИзХранилища = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УзелОбмена, "Пароль");
	УстановитьПривилегированныйРежим(Ложь);
	
	НастройкиПодключения.Вставить("Пароль", ПарольИзХранилища);

КонецПроцедуры

Функция ОчиститьКаталог(Каталог, ОписаниеОшибки)
	
	Попытка
		
		УдалитьФайлы(Каталог, "*.*");
		
	Исключение
		
		ОписаниеИсключительнойОшибки = ОбменССайтом.ОписаниеИсключительнойОшибки(
											НСтр("ru = 'Не удалось очистить каталог обмена:';
												|en = 'Cannot clear an exchange directory:'")
											+ " "+ "(" + Каталог + ")");
		
		ОбменССайтом.ДобавитьОписаниеОшибки(ОписаниеОшибки, ОписаниеИсключительнойОшибки);
			
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Выполняет необходимые действия при завершении обмена.
//
// Параметры:
//	Параметры - Структура основных параметров
//	ТаблицаИнформации - Таблица значений, состояние текущего сеанса обмена
//	Ошибка - Булево, Истина, если необходимо зафиксировать завершение обмена с ошибками.
//
Процедура ВыполнитьДействияПриЗавершенииОбмена(Параметры, ТаблицаИнформации, Ошибка = Ложь)
	
	ТаблицаИнформации.ЗаполнитьЗначения(Параметры.УзелОбмена, "НастройкаОбменаССайтом");
	
	// Записываем информацию по каждому действию в журнал регистрации.
	
	Для Каждого СтрокаТаблицыИнформации Из ТаблицаИнформации Цикл
		
		СобытиеЖурнала = ПолучитьКлючСообщенияЖурналаРегистрации(Параметры.УзелОбмена,
			СтрокаТаблицыИнформации.ДействиеПриОбмене);
		
		Если СтрокаТаблицыИнформации.РезультатВыполненияОбмена = Перечисления.РезультатыОбменаССайтом.Выполнено Тогда
			УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
		Иначе
			УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
		КонецЕсли;
		
		Если Ошибка Тогда
			УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(СобытиеЖурнала,
			УровеньЖурнала,
			Параметры.УзелОбмена.Метаданные(),
			Параметры.УзелОбмена,
			Параметры.РежимЗапускаОбмена + Символы.ПС+СтрокаТаблицыИнформации.Описание);
			
	КонецЦикла;

	// Объединяем 2 строки информации по выгрузке (товары и заказы) в одну (ВыгрузкаДанных).
	
	СтрокиВыгрузки = ТаблицаИнформации.НайтиСтроки(Новый Структура("ДействиеПриОбмене",
		Перечисления.ДействияПриОбменеССайтом.ВыгрузкаДанных));
	
	Если СтрокиВыгрузки.Количество() = 2 Тогда
		
		Если СтрокиВыгрузки[1].РезультатВыполненияОбмена = Перечисления.РезультатыОбменаССайтом.Ошибка Тогда
			СтрокиВыгрузки[0].РезультатВыполненияОбмена = Перечисления.РезультатыОбменаССайтом.Ошибка;
		КонецЕсли;
		
		ТаблицаИнформации.Удалить(СтрокиВыгрузки[1]);
		
	КонецЕсли;
	
	// Записываем состояния обмена.
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СтрокаТаблицыИнформации Из ТаблицаИнформации Цикл
		
		ЗаписьСостояния = РегистрыСведений.СостоянияОбменовССайтом.СоздатьМенеджерЗаписи();
		
		ЗаполнитьЗначенияСвойств(ЗаписьСостояния, СтрокаТаблицыИнформации);
		
		// Даты записываем по границам сеанса, чтобы работал отбор журнала.
		
		ЗаписьСостояния.ДатаНачала = Параметры.ДатаФормирования;
		ЗаписьСостояния.ДатаОкончания = ТекущаяДатаСеанса();
		
		ЗаписьСостояния.Записать();
		
		Если ЗначениеЗаполнено(ЗаписьСостояния.ДействиеПриОбмене)
			И (ЗаписьСостояния.РезультатВыполненияОбмена = Перечисления.РезультатыОбменаССайтом.Выполнено
			ИЛИ ЗаписьСостояния.РезультатВыполненияОбмена
				= Перечисления.РезультатыОбменаССайтом.ВыполненоСПредупреждениями) Тогда
			
			ЗаписьУспешногоСостояния = РегистрыСведений.УспешныеОбменыССайтом.СоздатьМенеджерЗаписи();
			
			ЗаполнитьЗначенияСвойств(ЗаписьУспешногоСостояния, ЗаписьСостояния);
			
			ЗаписьУспешногоСостояния.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьКлючСообщенияЖурналаРегистрации(УзелПланаОбмена, ДействиеПриОбмене)
	
	ИмяПланаОбмена     = УзелПланаОбмена.Метаданные().Имя;
	КодУзлаПланаОбмена = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелПланаОбмена, "Код"));
	
	КлючСообщения = НСтр("ru = 'Обмен данными.[ИмяПланаОбмена].Узел [КодУзла].[ДействиеПриОбмене]';
						|en = 'Data exchange.[ИмяПланаОбмена].Node [КодУзла].[ДействиеПриОбмене]'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	КлючСообщения = СтрЗаменить(КлючСообщения, "[ИмяПланаОбмена]",    ИмяПланаОбмена);
	КлючСообщения = СтрЗаменить(КлючСообщения, "[КодУзла]",           КодУзлаПланаОбмена);
	КлючСообщения = СтрЗаменить(КлючСообщения, "[ДействиеПриОбмене]", ДействиеПриОбмене);
	
	Возврат КлючСообщения;
	
КонецФункции

Функция ПараметрыПрикладногоРешения(УзелОбмена)
	
	ПрикладныеПараметры  = Новый Структура;
	РеквизитыПланаОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УзелОбмена, "ПараметрыПрикладногоРешения, ВыгружатьКартинки");
	СохраненныеНастройки	 = РеквизитыПланаОбмена.ПараметрыПрикладногоРешения.Получить();
	Если Не ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
		Возврат ПрикладныеПараметры;
	КонецЕсли;
	
	Если Не СохраненныеНастройки.Свойство("ПараметрыПрикладногоРешения") Тогда
		Возврат ПрикладныеПараметры;
	КонецЕсли;
	
	ПрикладныеПараметры = СохраненныеНастройки.ПараметрыПрикладногоРешения;
	ПрикладныеПараметры.Вставить("ВыгружатьКартинки", РеквизитыПланаОбмена.ВыгружатьКартинки);
	
	ОбменССайтомПереопределяемый.ДополнитьПараметрыПрикладногоРешения(ПрикладныеПараметры);
	
	Возврат ПрикладныеПараметры;
	
КонецФункции

// Записывает в лог информацию об обмене с сайтом
//
// Параметры:
//  ТаблицаИнформации - таблицаЗначений, соответствующая регистру СостоянияОбменовДанными.
//  Параметры - структура - данные и настройки для обмена.
//  ДатаНачала - дата -время события (загрузка или выгрузка заказов).
//  Загрузка - булево - флаг, указывающий происходила загрузка или выгрузка.
//  Успех - булево - результат загрузки/выгрузки.
//  СтруктураСтатистики - структура -  хранятся значения количества созданных документов, обновленных и пр.
//  ОписаниеОшибки - строка - текстовая информация об ошибке.
//
Процедура ЗаписатьИнформациюПоЗаказамВТаблицуИнформации(ТаблицаИнформации, Параметры, ДатаНачала, Загрузка, Успех,
		СтруктураСтатистики, ОписаниеОшибки) Экспорт
	
	СтрокаТаблицыИнформации = ТаблицаИнформации.Добавить();
	СтрокаТаблицыИнформации.ДатаНачала = ДатаНачала;
	СтрокаТаблицыИнформации.ДатаОкончания = ТекущаяДатаСеанса();
	Если Загрузка Тогда
		Действие = Перечисления.ДействияПриОбменеССайтом.ЗагрузкаДанных;
	Иначе
		Действие = Перечисления.ДействияПриОбменеССайтом.ВыгрузкаДанных;
	КонецЕсли;
	
	СтрокаТаблицыИнформации.ДействиеПриОбмене = Действие;
	
	Если Действие = Перечисления.ДействияПриОбменеССайтом.ЗагрузкаДанных Тогда
		
		Описание = Строка(ДатаНачала) + " " + НСтр("ru = 'Запуск загрузки заказов';
													|en = 'Run order import'")
			+ Символы.ПС + НСтр("ru = 'Обработано:';
								|en = 'Processed:'")+ " " + СтруктураСтатистики.ОбработаноНаЗагрузке
			+ Символы.ПС + НСтр("ru = 'Загружено:';
								|en = 'Imported:'")+ " " + СтруктураСтатистики.Загружено.Количество();
		
		ВывестиСписокДокументовДляПротокола(Описание, Параметры,СтруктураСтатистики.Загружено);
		
		Описание = Описание
			+ Символы.ПС + НСтр("ru = 'Пропущено:';
								|en = 'Skipped:'") + " " + СтруктураСтатистики.Пропущено.Количество();
		
		ВывестиСписокДокументовДляПротокола(Описание, Параметры,СтруктураСтатистики.Пропущено);
		
		Описание = Описание
			+ Символы.ПС + НСтр("ru = 'Обновлено:';
								|en = 'Updated:'") + " " + СтруктураСтатистики.Обновлено.Количество();
		
		ВывестиСписокДокументовДляПротокола(Описание, Параметры, СтруктураСтатистики.Обновлено);
		
		Описание = Описание
			+ Символы.ПС + НСтр("ru = 'Создано:';
								|en = 'Created:'") + " " + СтруктураСтатистики.Создано.Количество();
		
		ВывестиСписокДокументовДляПротокола(Описание, Параметры,СтруктураСтатистики.Создано);
		
		Описание = Описание
			+ Символы.ПС
			+ СтрокаТаблицыИнформации.ДатаОкончания
			+ " "
			+ НСтр("ru = 'Завершена загрузка заказов';
					|en = 'Order import is completed'");
			
	Иначе
		
		Описание = Строка(ДатаНачала) + " " + НСтр("ru = 'Запуск выгрузки заказов';
													|en = 'Run order export'")
			+ Символы.ПС + НСтр("ru = 'Выгружено:';
								|en = 'Exported:'")+ " " + СтруктураСтатистики.Выгружено.Количество();
		
		ВывестиСписокДокументовДляПротокола(Описание, Параметры, СтруктураСтатистики.Выгружено);
		
		Описание = Описание
			+ Символы.ПС
			+ СтрокаТаблицыИнформации.ДатаОкончания
			+ " "
			+ НСтр("ru = 'Завершена выгрузка заказов';
					|en = 'Order export is completed'");
	
	КонецЕсли;
	
	СтрокаТаблицыИнформации.Описание = Описание;
	
	Если Успех Тогда
		СтрокаТаблицыИнформации.РезультатВыполненияОбмена = Перечисления.РезультатыОбменаССайтом.Выполнено;
	Иначе
		СтрокаТаблицыИнформации.РезультатВыполненияОбмена = Перечисления.РезультатыОбменаССайтом.Ошибка;
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицыИнформации.Описание = СтрокаТаблицыИнформации.Описание
		+ Символы.ПС + НСтр("ru = 'Дополнительная информация:';
							|en = 'Additional information:'") + Символы.ПС + ОписаниеОшибки;

	
КонецПроцедуры
	
Процедура ВывестиСписокДокументовДляПротокола(Описание, Параметры, МассивДокументов)
	
	Если МассивДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Описание = Описание + ". " + НСтр("ru = 'Список документов:';
										|en = 'Document list:'");
	
	Для Каждого Док Из МассивДокументов Цикл
		
		
		СтруктураРеквизитовЗаказаНаСайте = Неопределено;
				
		ОбменССайтомПереопределяемый.РеквизитыЗаказаНаСайте(Док.Ссылка, Параметры.УзелОбмена, СтруктураРеквизитовЗаказаНаСайте);
		Если СтруктураРеквизитовЗаказаНаСайте = Неопределено Тогда
			НомерЗаказаНаСайте = "";
			ДатаЗаказаНаСайте = "";
		Иначе
			
			НомерЗаказаНаСайте = СтруктураРеквизитовЗаказаНаСайте.НомерЗаказаНаСайте;
			ДатаЗаказаНаСайте = СтруктураРеквизитовЗаказаНаСайте.ДатаЗаказаНаСайте;
		КонецЕсли;
		
		Описание = Описание + Символы.ПС + Символы.НПП + Символы.НПП
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '№ %1 от %2 (№ %3 от %4 на сайте)';
					|en = 'No. %1 from %2 (No. %3 from %4 on the website)'"),
				Док.Номер,
				Док.Дата,
				НомерЗаказаНаСайте,
				ДатаЗаказаНаСайте);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПолучитьИзмененияУзла(СтруктураВозврата, УзелПланаОбмена)
	
	ИмяСправочникаТовары = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("Номенклатура");
	ИмяСправочникаФайлы = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("НоменклатураПрисоединенныеФайлы");
	ИмяДокументаЗаказы = ОбменССайтомПовтИсп.ИмяПрикладногоДокумента("ЗаказПокупателя");
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗаказыИзменения.Ссылка КАК Ссылка,
	|	""Заказы"" КАК ТипСсылки
	|ИЗ
	|	Документ." + ИмяДокументаЗаказы + ".Изменения КАК ЗаказыИзменения
	|ГДЕ
	|	ЗаказыИзменения.Узел = &Узел";
	
	Если СтруктураВозврата.Свойство("Товары") Тогда 
		ТекстЗапроса = ТекстЗапроса + 
		"
		|
		|ОБЪЕДИНИТЬ ВСЕ	
		|
		|ВЫБРАТЬ
		|	НоменклатураИзменения.Ссылка,
		|	""Товары"" 
		|ИЗ
		|	Справочник." + ИмяСправочникаТовары + ".Изменения КАК НоменклатураИзменения
		|ГДЕ
		|	НоменклатураИзменения.Узел = &Узел";

	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Узел", УзелПланаОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураВозврата[Выборка.ТипСсылки].Добавить(Выборка.Ссылка);
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

