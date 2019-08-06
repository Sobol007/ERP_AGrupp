#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТоварныйЧек") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ТоварныйЧек",
		НСтр("ru = 'Товарный чек';
			|en = 'Receipt'"),
		СформироватьПечатнуюФормуТоварныйЧек(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуТоварныйЧек(СтруктураТипов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТоварныйЧек";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		Если НЕ (СтруктураОбъектов.Ключ = "Документ.ЧекККМ"
			Или СтруктураОбъектов.Ключ = "Документ.ОтчетОРозничныхПродажах"
			Или СтруктураОбъектов.Ключ = "Документ.ЧекККМВозврат") Тогда
			Продолжить;
		КонецЕсли;
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыТоварныйЧек(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументТоварныйЧек(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументТоварныйЧек(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ШаблонОшибкиТовары = НСтр("ru = 'В документе %1 отсутствуют товары. Печать товарного чека не требуется';
								|en = 'Goods are missing in document %1. It is not required to print the receipt'");
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТоварногоЧека.ПФ_MXL_ТоварныйЧек");
	ПоказыватьНДС = Константы.ВыводитьДопКолонкиНДС.Получить();
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	Товары       = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ТаблицаТовары = Товары.НайтиСтроки(СтруктураПоиска);
		
		Если ТаблицаТовары.Количество() = 0 Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибкиТовары,
				ДанныеПечати.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДанныеПечати.Ссылка);
			Продолжить;
			
		КонецЕсли;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной.
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ФормированиеПечатныхФорм.ВывестиЛоготипВТабличныйДокумент(Макет, ОбластьМакета, "Заголовок", ДанныеПечати.Организация);
		
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(ДанныеПечати, ДанныеДляПечати.ЗаголовокДокумента);
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ПредставлениеПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата), "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны");
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ПредставлениеПоставщика;
		ОбластьМакета.Параметры.Поставщик = ДанныеПечати.Организация;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ЗначениеЗаполнено(ДанныеПечати.Подразделение) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Подразделение");
			ОбластьМакета.Параметры.Подразделение = ДанныеПечати.Подразделение;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		ЕстьСкидки = Ложь;
		ЕстьНДС = Ложь;
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			Если СтрокаТовары.СуммаСкидки <> 0 Тогда
				ЕстьСкидки = Истина;
			КонецЕсли;
			Если СтрокаТовары.СуммаНДС <> 0 Тогда
				ЕстьНДС = Истина;
			КонецЕсли;
		КонецЦикла;
		
		ЗаголовокСкидки = ЗаголовокСкидки(ТаблицаТовары, ЕстьСкидки);
		
		ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
		Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
			ВыводитьКоды = Истина;
			Колонка = "Артикул";
		ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
			ВыводитьКоды = Истина;
			Колонка = "Код";
		Иначе
			ВыводитьКоды = Ложь;
		КонецЕсли;
		
		ВыводитьПомещения = Ложь;
		
		ПервоеПомещение = Неопределено;
		Для Каждого СтрокаТовара Из ТаблицаТовары Цикл
			Если ЗначениеЗаполнено(СтрокаТовара.Помещение) Тогда
				ВыводитьПомещения = Истина;
			КонецЕсли;
		КонецЦикла;
		
		ОбластьНомера    = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
		ОбластьКодов     = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
		ОбластьПомещение = Макет.ПолучитьОбласть("ШапкаТаблицы|Помещение");
		ОбластьДанных    = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
		ОбластьСкидок    = Макет.ПолучитьОбласть("ШапкаТаблицы|Скидка");
		ОбластьСуммыНДС  = Макет.ПолучитьОбласть("ШапкаТаблицы|СуммаНДС");
		ОбластьСуммы     = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");
		
		ТабличныйДокумент.Вывести(ОбластьНомера);
		Если ВыводитьПомещения Тогда
			ТабличныйДокумент.Присоединить(ОбластьПомещение);
		КонецЕсли;
		Если ВыводитьКоды Тогда
			ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
			ТабличныйДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьДанных);
		Если ЕстьСкидки Тогда
			ОбластьСкидок.Параметры.Скидка = ЗаголовокСкидки.Скидка;
			ОбластьСкидок.Параметры.СуммаБезСкидки = ЗаголовокСкидки.СуммаСкидки;
			ТабличныйДокумент.Присоединить(ОбластьСкидок);
		КонецЕсли;
		Если ЕстьНДС И ПоказыватьНДС Тогда
			ТабличныйДокумент.Присоединить(ОбластьСуммыНДС);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьСуммы);
		
		ОбластьКолонкаТовар = Макет.Область("Товар");
		Если Не ВыводитьКоды Тогда
			ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки
			                                  + Макет.Область("КолонкаКодов").ШиринаКолонки;
		КонецЕсли;
		Если ВыводитьПомещения Тогда
			ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки
			                                  + Макет.Область("Помещение").ШиринаКолонки;
		КонецЕсли;
		Если Не ЕстьСкидки Тогда
			ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки
			                                  + Макет.Область("СуммаБезСкидки").ШиринаКолонки
			                                  + Макет.Область("СуммаСкидки").ШиринаКолонки;
		КонецЕсли;
		
		ОбластьНомераСтандарт    = Макет.ПолучитьОбласть("Строка|НомерСтроки");
		ОбластьКодовСтандарт     = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
		ОбластьПомещениеСтандарт = Макет.ПолучитьОбласть("Строка|Помещение");
		ОбластьДанныхСтандарт    = Макет.ПолучитьОбласть("Строка|Данные");
		ОбластьСкидокСтандарт    = Макет.ПолучитьОбласть("Строка|Скидка");
		ОбластьСуммыНДССтандарт  = Макет.ПолучитьОбласть("Строка|СуммаНДС");
		ОбластьСуммыСтандарт     = Макет.ПолучитьОбласть("Строка|Сумма");
		
		ИспользоватьНаборы = Ложь;
		Если Товары.Колонки.Найти("ЭтоНабор") <> Неопределено Тогда
			ИспользоватьНаборы = Истина;
			
			ОбластьНомераНабор    = Макет.ПолучитьОбласть("Строка" + "Набор" + "|НомерСтроки");
			ОбластьКодовНабор     = Макет.ПолучитьОбласть("Строка" + "Набор" + "|КолонкаКодов");
			ОбластьПомещениеНабор = Макет.ПолучитьОбласть("Строка" + "Набор" + "|Помещение");
			ОбластьДанныхНабор    = Макет.ПолучитьОбласть("Строка" + "Набор" + "|Данные");
			ОбластьСкидокНабор    = Макет.ПолучитьОбласть("Строка" + "Набор" + "|Скидка");
			ОбластьСуммыНДСНабор  = Макет.ПолучитьОбласть("Строка" + "Набор" + "|СуммаНДС");
			ОбластьСуммыНабор     = Макет.ПолучитьОбласть("Строка" + "Набор" + "|Сумма");
			
			ОбластьНомераКомплектующие    = Макет.ПолучитьОбласть("Строка" + "Комплектующие" + "|НомерСтроки");
			ОбластьКодовКомплектующие     = Макет.ПолучитьОбласть("Строка" + "Комплектующие" + "|КолонкаКодов");
			ОбластьПомещениеКомплектующие = Макет.ПолучитьОбласть("Строка" + "Комплектующие" + "|Помещение");
			ОбластьДанныхКомплектующие    = Макет.ПолучитьОбласть("Строка" + "Комплектующие" + "|Данные");
			ОбластьСкидокКомплектующие    = Макет.ПолучитьОбласть("Строка" + "Комплектующие" + "|Скидка");
			ОбластьСуммыНДСКомплектующие  = Макет.ПолучитьОбласть("Строка" + "Комплектующие" + "|СуммаНДС");
			ОбластьСуммыКомплектующие     = Макет.ПолучитьОбласть("Строка" + "Комплектующие" + "|Сумма");
			
		КонецЕсли;
		
		Сумма          = 0;
		СуммаНДС       = 0;
		ВсегоСкидок    = 0;
		ВсегоБезСкидок = 0;
		НомерСтроки    = 0;
		ПустыеДанные   = НаборыСервер.ПустыеДанные();
		
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			
			Если НаборыСервер.ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьНомера    = ОбластьНомераНабор;
				ОбластьКодов     = ОбластьКодовНабор;
				ОбластьПомещение = ОбластьПомещениеНабор;
				ОбластьДанных    = ОбластьДанныхНабор;
				ОбластьСкидок    = ОбластьСкидокНабор;
				ОбластьСуммыНДС  = ОбластьСуммыНДСНабор;
				ОбластьСуммы     = ОбластьСуммыНабор;
			ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьНомера    = ОбластьНомераКомплектующие;
				ОбластьКодов     = ОбластьКодовКомплектующие;
				ОбластьПомещение = ОбластьПомещениеКомплектующие;
				ОбластьДанных    = ОбластьДанныхКомплектующие;
				ОбластьСкидок    = ОбластьСкидокКомплектующие;
				ОбластьСуммыНДС  = ОбластьСуммыНДСКомплектующие;
				ОбластьСуммы     = ОбластьСуммыКомплектующие;
			Иначе
				ОбластьНомера    = ОбластьНомераСтандарт;
				ОбластьКодов     = ОбластьКодовСтандарт;
				ОбластьПомещение = ОбластьПомещениеСтандарт;
				ОбластьДанных    = ОбластьДанныхСтандарт;
				ОбластьСкидок    = ОбластьСкидокСтандарт;
				ОбластьСуммыНДС  = ОбластьСуммыНДССтандарт;
				ОбластьСуммы     = ОбластьСуммыСтандарт;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				УстановитьПараметр(ОбластьНомера, "НомерСтроки", Неопределено);
			Иначе
				НомерСтроки = НомерСтроки + 1;
				УстановитьПараметр(ОбластьНомера, "НомерСтроки", НомерСтроки);
			КонецЕсли;
			ТабличныйДокумент.Вывести(ОбластьНомера);
			
			Если ВыводитьПомещения Тогда
				ОбластьПомещение.Параметры.Заполнить(СтрокаТовары);
				ТабличныйДокумент.Присоединить(ОбластьПомещение);
			КонецЕсли;
			
			Если ВыводитьКоды Тогда
				Если Колонка = "Артикул" Тогда
					УстановитьПараметр(ОбластьКодов, "Артикул", СтрокаТовары.Артикул);
				Иначе
					УстановитьПараметр(ОбластьКодов, "Артикул", СтрокаТовары.Код);
				КонецЕсли;
				ТабличныйДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьДанных.Параметры.Заполнить(ПустыеДанные);
			Иначе
				ОбластьДанных.Параметры.Заполнить(СтрокаТовары);
			КонецЕсли;
			
			ПрефиксИПостфикс = НаборыСервер.ПолучитьПрефиксИПостфикс(СтрокаТовары, ИспользоватьНаборы);
			
			УстановитьПараметр(ОбластьДанных, "Товар", ПрефиксИПостфикс.Префикс + НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СтрокаТовары.ПолноеНаименованиеНоменклатуры,
				СтрокаТовары.ПолноеНаименованиеХарактеристики) + ПрефиксИПостфикс.Постфикс);
			
			ТабличныйДокумент.Присоединить(ОбластьДанных);
			
			Если ЕстьСкидки Тогда
				
				Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
					ОбластьСкидок.Параметры.Заполнить(ПустыеДанные);
				Иначе
					УстановитьПараметр(ОбластьСкидок, "Скидка",         ?(ЗаголовокСкидки.ТолькоНаценка,-СтрокаТовары.СуммаСкидки, СтрокаТовары.СуммаСкидки));
					УстановитьПараметр(ОбластьСкидок, "СуммаБезСкидки", СтрокаТовары.Сумма + СтрокаТовары.СуммаСкидки);
				КонецЕсли;
				
				ТабличныйДокумент.Присоединить(ОбластьСкидок);
				
			КонецЕсли;
			
			Если ЕстьНДС И ПоказыватьНДС Тогда
				
				Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
					ОбластьСуммыНДС.Параметры.Заполнить(ПустыеДанные);
				Иначе
					ОбластьСуммыНДС.Параметры.Заполнить(СтрокаТовары);
				КонецЕсли;
				
				ТабличныйДокумент.Присоединить(ОбластьСуммыНДС);
			КонецЕсли;
			
			Если Не ДанныеПечати.ЦенаВключаетНДС Тогда
				СуммаСНДС = СтрокаТовары.Сумма + СтрокаТовары.СуммаНДС;
			Иначе
				СуммаСНДС = СтрокаТовары.Сумма;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьСуммы.Параметры.Заполнить(ПустыеДанные);
			Иначе
				УстановитьПараметр(ОбластьСуммы, "Сумма", СуммаСНДС);
			КонецЕсли;
			
			ТабличныйДокумент.Присоединить(ОбластьСуммы);
			
			Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				Сумма    = Сумма    + СтрокаТовары.Сумма;
				СуммаНДС = СуммаНДС + СтрокаТовары.СуммаНДС;
				
				Если ЕстьСкидки Тогда
					ВсегоСкидок    = ВсегоСкидок    + СтрокаТовары.СуммаСкидки;
					ВсегоБезСкидок = ВсегоБезСкидок + СтрокаТовары.Сумма + СтрокаТовары.СуммаСкидки;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		// Вывести Итого.
		ОбластьНомера    = Макет.ПолучитьОбласть("Итого|НомерСтроки");
		ОбластьКодов     = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
		ОбластьПомещение = Макет.ПолучитьОбласть("Итого|Помещение");
		ОбластьДанных    = Макет.ПолучитьОбласть("Итого|Данные");
		ОбластьСкидок    = Макет.ПолучитьОбласть("Итого|Скидка");
		ОбластьСуммы     = Макет.ПолучитьОбласть("Итого|Сумма");
		ОбластьСуммыНДС  = Макет.ПолучитьОбласть("Итого|СуммаНДС");
		
		ТабличныйДокумент.Вывести(ОбластьНомера);
		Если ВыводитьПомещения Тогда
			ТабличныйДокумент.Присоединить(ОбластьПомещение);
		КонецЕсли;
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьДанных);
		Если ЕстьСкидки Тогда
			ОбластьСкидок.Параметры.ВсегоСкидок    = ?(ЗаголовокСкидки.ТолькоНаценка,-ВсегоСкидок, ВсегоСкидок);
			ОбластьСкидок.Параметры.ВсегоБезСкидок = ВсегоБезСкидок;
			ТабличныйДокумент.Присоединить(ОбластьСкидок);
		КонецЕсли;
		
		Если ЕстьНДС И ПоказыватьНДС Тогда
			ОбластьСуммыНДС.Параметры.СуммаНДС = СуммаНДС;
			ТабличныйДокумент.Присоединить(ОбластьСуммыНДС);
		КонецЕсли;
		
		Если Не ДанныеПечати.ЦенаВключаетНДС Тогда
			СуммаДокумента = Сумма + СуммаНДС;
		Иначе
			СуммаДокумента = Сумма;
		КонецЕсли;
		
		ОбластьСуммы.Параметры.Сумма = СуммаДокумента;
		ТабличныйДокумент.Присоединить(ОбластьСуммы);
		
		// Вывести Сумму прописью.
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		
		ИтоговаяСтрока = НСтр("ru = 'Всего наименований %1, на сумму %2';
								|en = 'Total items %1 to the amount of %2'");
		ОбластьМакета.Параметры.ИтоговаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ИтоговаяСтрока,
			НомерСтроки,
			ФормированиеПечатныхФорм.ФорматСумм(ДанныеПечати.СуммаДокумента));
		
		ОбластьМакета.Параметры.СуммаПрописью  = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеПечати.СуммаДокумента, ДанныеПечати.Валюта);
		ТабличныйДокумент.Вывести(ОбластьМакета);
	
		// Вывести подписи.
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ОбластьМакета.Параметры.ОтветственныйПредставление = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Ответственный, ДанныеПечати.Дата);

		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТабличныйДокументТоварныйЧек()

// Функция возвращает структуру с заголовками Скидка или Наценка для таблицы печатной формы,
// а также с флагами ЕстьСкидки и ТолькоНаценка.
//
Функция ЗаголовокСкидки(ТаблицаТовары, ИспользоватьСкидки) Экспорт
	
	ЕстьНаценки = Ложь;
	ЕстьСкидки  = Ложь;
	
	СтруктураШапки = Новый Структура("Скидка, СуммаСкидки, ТолькоНаценка");
	
	Если ИспользоватьСкидки Тогда
		
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			Если СтрокаТовары.СуммаСкидки > 0 Тогда
				ЕстьСкидки = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			Если СтрокаТовары.СуммаСкидки < 0 Тогда
				ЕстьНаценки = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьНаценки И ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", НСтр("ru = 'Скидка (Наценка)';
													|en = 'Discount (Markup)'"));
			СтруктураШапки.Вставить("СуммаСкидки", НСтр("ru = 'Сумма';
														|en = 'Amount'") + Символы.ПС + НСтр("ru = 'без скидки (наценки)';
																							|en = 'without discount (markups)'"));
		ИначеЕсли ЕстьНаценки И НЕ ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", НСтр("ru = 'Наценка';
													|en = 'Markup'"));
			СтруктураШапки.Вставить("СуммаСкидки", НСтр("ru = 'Сумма';
														|en = 'Amount'") + Символы.ПС + НСтр("ru = 'без наценки';
																							|en = 'without markup'"));
		ИначеЕсли ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", НСтр("ru = 'Скидка';
													|en = 'Discount'"));
			СтруктураШапки.Вставить("СуммаСкидки", НСтр("ru = 'Сумма';
														|en = 'Amount'") + Символы.ПС + НСтр("ru = 'без скидки';
																							|en = 'without discount'"));
		КонецЕсли;
		
		СтруктураШапки.Вставить("ТолькоНаценка", ЕстьНаценки);
		
	КонецЕсли;
	
	Возврат СтруктураШапки;
	
КонецФункции

Процедура УстановитьПараметр(ОбластьМакета, ИмяПараметра, ЗначениеПараметра)
	ОбластьМакета.Параметры.Заполнить(Новый Структура(ИмяПараметра, ЗначениеПараметра));
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
