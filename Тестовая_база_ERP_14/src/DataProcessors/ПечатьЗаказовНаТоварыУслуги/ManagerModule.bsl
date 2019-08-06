#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
// 		ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
// 		МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
// 		ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
// 		КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
// 		ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказКлиента") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаказКлиента",
			НСтр("ru = 'Заказ клиента';
				|en = 'Sales order'"),
			СформироватьПечатнуюФормуЗаказаКлиента(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказПоставщику") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаказПоставщику",
			НСтр("ru = 'Заказ поставщику';
				|en = 'Purchase order'"),
			СформироватьПечатнуюФормуЗаказаПоставщику(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	//++ НЕ УТКА
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказДавальцуНаСырье") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаказДавальцуНаСырье",
			НСтр("ru = 'Заказ давальцу на сырье и материалы';
				|en = 'Material provider order for materials'"),
			СформироватьПечатнуюФормуЗаказаДавальцуНаСырье(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказДавальцаНаУслуги") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаказДавальцаНаУслуги",
			НСтр("ru = 'Заказ давальца на услуги по выпуску продукции';
				|en = 'Material provider order for product release services'"),
			СформироватьПечатнуюФормуЗаказаДавальцаНаУслуги(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	//-- НЕ УТКА
	//++ НЕ УТ
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказПереработчикаНаСырье") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаказПереработчикаНаСырье",
			НСтр("ru = 'Заказ переработчика на сырье и материалы';
				|en = 'Tolling order for materials'"),
			СформироватьПечатнуюФормуЗаказаПереработчикаНаСырье(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказПереработчикуНаУслуги") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаказПереработчикуНаУслуги",
			НСтр("ru = 'Заказ переработчику на услуги по выпуску продукции';
				|en = 'Tolling order for product release services'"),
			СформироватьПечатнуюФормуЗаказаПереработчикуНаУслуги(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
		
	//-- НЕ УТ
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, СтруктураТипов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуЗаказаКлиента(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказКлиента";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		// Данные для массива объектов
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыЗаказаНаТоварыУслуги(
			СтруктураОбъектов.Значение,
			ПараметрыПечати);
		
		// Сформированный тбаличный документ
		ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			"Обработка.ПечатьЗаказовНаТоварыУслуги.ПФ_MXL_ЗаказКлиента");
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуЗаказаПоставщику(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПоставщику";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		// Данные для массива объектов
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыЗаказаНаТоварыУслуги(
			СтруктураОбъектов.Значение,
			ПараметрыПечати);
		
		// Сформированный тбаличный документ
		ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			"Обработка.ПечатьЗаказовНаТоварыУслуги.ПФ_MXL_ЗаказПоставщику");
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

//++ НЕ УТКА

Функция СформироватьПечатнуюФормуЗаказаДавальцуНаСырье(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказДавальцуНаСырье";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		// Данные для массива объектов
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыЗаказаНаСырьеИМатериалы(
			СтруктураОбъектов.Значение,
			ПараметрыПечати);
		
		// Сформированный тбаличный документ
		ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			"Документ.ЗаказДавальца.ПФ_MXL_ЗаказДавальца");
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуЗаказаДавальцаНаУслуги(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказДавальцаНаУслуги";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		// Данные для массива объектов
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыЗаказаНаУслуги(
			СтруктураОбъектов.Значение,
			ПараметрыПечати);
		
		// Сформированный тбаличный документ
		ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			"Документ.ЗаказДавальца.ПФ_MXL_ЗаказДавальца");
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

//-- НЕ УТКА

//++ НЕ УТ

Функция СформироватьПечатнуюФормуЗаказаПереработчикаНаСырье(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПереработчикаНаСырье";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		// Данные для массива объектов
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыЗаказаНаСырьеИМатериалы(
			СтруктураОбъектов.Значение,
			ПараметрыПечати);
		
		// Сформированный тбаличный документ
		ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			"Документ.ЗаказПереработчику.ПФ_MXL_ЗаказПереработчику");
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуЗаказаПереработчикуНаУслуги(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПереработчикуНаУслуги";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		// Данные для массива объектов
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыЗаказаНаУслуги(
			СтруктураОбъектов.Значение,
			ПараметрыПечати);
		
		// Сформированный тбаличный документ
		ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			"Документ.ЗаказПереработчику.ПФ_MXL_ЗаказПереработчикуНаУслуги");
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти

#Область ПечатьЗаказаПартнеруОтПартнераНаТоварыРаботыИлиУслуги

Процедура ЗаполнитьТабличныйДокументЗаказаНаТоварыУслуги(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ИмяМакета)
	
	ШаблонОшибкиТовары	= НСтр("ru = 'В документе %1 отсутствуют товары. Печать %2 не требуется';
								|en = 'Goods are missing in document %1. Printing of %2 is not required'");
	ШаблонОшибкиЭтапы	= НСтр("ru = 'В документе %1 отсутствуют этапы оплаты. Печать %2 не требуется';
								|en = 'Payment steps are missing in document %1. Printing of %2 is not required'");
	
	ИспользоватьРучныеСкидки			= ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьАвтоматическиеСкидки	= ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	
	ДанныеПечати	= ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ЭтапыОплаты		= ДанныеДляПечати.РезультатПоЭтапамОплаты.Выгрузить();
	Товары			= ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
	
	ПервыйДокумент	= Истина;
	КолонкаКодов	= ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	ВыводитьКоды	= Не ПустаяСтрока(КолонкаКодов);
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы(ИмяМакета);
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		
		ТаблицаТовары = Товары.НайтиСтроки(СтруктураПоиска);
		
		Если ТаблицаТовары.Количество() = 0 Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибкиТовары,
				ДанныеПечати.Ссылка,
				ДанныеПечати.ПредставлениеВОшибке);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДанныеПечати.Ссылка);
			Продолжить;
			
		КонецЕсли;
		
		ТаблицаЭтапыОплаты = ЭтапыОплаты.НайтиСтроки(СтруктураПоиска);
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВыводитьВидЦены = Ложь;
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			
			Если ЗначениеЗаполнено(СтрокаТовары.ВидЦеныИсполнителя) Тогда
				ВыводитьВидЦены = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		ЗаголовокСкидки	= ФормированиеПечатныхФорм.НужноВыводитьСкидки(ТаблицаТовары, ДанныеПечати.ИспользоватьАвтоСкидки);
		ЕстьСкидки		= ЗаголовокСкидки.ЕстьСкидки;
		ПоказыватьНДС	= ДанныеПечати.ПоказыватьНДСВСтроках И ДанныеПечати.УчитыватьНДС;
		
#Область ОпределениеИменЗаголовковОбластей
		
		ЕстьДопПараметр		= ЕстьСкидки Или ВыводитьВидЦены Или ПоказыватьНДС;
		ДвойнойДопПараметр	= (ЕстьСкидки И ВыводитьВидЦены) Или (ЕстьСкидки И ПоказыватьНДС);
		
		Если ДвойнойДопПараметр Тогда
			ПостфиксКолонок = "СДвумяПараметрами";
		ИначеЕсли ЕстьДопПараметр Тогда
			ПостфиксКолонок = "СОднимПараметром";
		Иначе
			ПостфиксКолонок = "";
		КонецЕсли;
		
		ОбластьКолонкаТовар = Макет.Область("Товар" + ПостфиксКолонок);
		
		Если Не ВыводитьКоды Тогда
			
			Если ДвойнойДопПараметр Тогда
				ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 1.35;
			ИначеЕсли ЕстьДопПараметр Тогда
				ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 1.2;
			Иначе
				ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 1.14;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЕстьСкидки И ВыводитьВидЦены Тогда
			ПостфиксСтрок = "СУсловиемСоСкидкой";
		ИначеЕсли ЕстьСкидки И ПоказыватьНДС Тогда
			ПостфиксСтрок = "СНДССоСкидкой";
		ИначеЕсли ПоказыватьНДС Тогда
			ПостфиксСтрок = "СНДС";
		ИначеЕсли ЕстьСкидки Тогда
			ПостфиксСтрок = "СоСкидкой";
		ИначеЕсли ВыводитьВидЦены Тогда
			ПостфиксСтрок = "СУсловием";
		Иначе
			ПостфиксСтрок = "";
		КонецЕсли;
		
#КонецОбласти
		
#Область ОбластиМакета
		
		// ОБЛАСТЕЙ ТАБЛИЦЫ "ТОВАРЫ"
		
		ОбластьНомераШапки		= Макет.ПолучитьОбласть("ШапкаТаблицы" + ПостфиксСтрок + "|НомерСтроки");
		ОбластьКодовШапки		= Макет.ПолучитьОбласть("ШапкаТаблицы" + ПостфиксСтрок + "|КолонкаКодов");
		ОбластьТоварШапки		= Макет.ПолучитьОбласть("ШапкаТаблицы" + ПостфиксСтрок + "|Товар"  + ПостфиксКолонок);
		ОбластьДанныхШапки		= Макет.ПолучитьОбласть("ШапкаТаблицы" + ПостфиксСтрок + "|Данные" + ПостфиксКолонок);
		
		ОбластьНомераСтрокиСтандарт = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "|НомерСтроки");
		ОбластьКодовСтрокиСтандарт  = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "|КолонкаКодов");
		ОбластьТоварСтрокиСтандарт  = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "|Товар"  + ПостфиксКолонок);
		ОбластьДанныхСтрокиСтандарт = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "|Данные" + ПостфиксКолонок);
		
		ИспользоватьНаборы = Ложь;
		Если Товары.Колонки.Найти("ЭтоНабор") <> Неопределено Тогда
			ИспользоватьНаборы = Истина;
			ОбластьНомераСтрокиНабор         = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Набор"         + "|НомерСтроки");
			ОбластьНомераСтрокиКомплектующие = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Комплектующие" + "|НомерСтроки");
			ОбластьКодовСтрокиНабор          = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Набор"         + "|КолонкаКодов");
			ОбластьКодовСтрокиКомплектующие  = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Комплектующие" + "|КолонкаКодов");
			ОбластьТоварСтрокиНабор          = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Набор"         + "|Товар"  + ПостфиксКолонок);
			ОбластьТоварСтрокиКомплектующие  = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Комплектующие" + "|Товар"  + ПостфиксКолонок);
			ОбластьДанныхСтрокиНабор         = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Набор"         + "|Данные" + ПостфиксКолонок);
			ОбластьДанныхСтрокиКомплектующие = Макет.ПолучитьОбласть("СтрокаТаблицы" + ПостфиксСтрок + "Комплектующие" + "|Данные" + ПостфиксКолонок);
		КонецЕсли;
		
		ОбластьНомераПодвала	= Макет.ПолучитьОбласть("ПодвалТаблицы" + ПостфиксСтрок + "|НомерСтроки");
		ОбластьКодовПодвала		= Макет.ПолучитьОбласть("ПодвалТаблицы" + ПостфиксСтрок + "|КолонкаКодов");
		ОбластьТоварПодвала		= Макет.ПолучитьОбласть("ПодвалТаблицы" + ПостфиксСтрок + "|Товар"  + ПостфиксКолонок);
		ОбластьДанныхПодвала	= Макет.ПолучитьОбласть("ПодвалТаблицы" + ПостфиксСтрок + "|Данные" + ПостфиксКолонок);
		
		ОбластьНомераНДС		= Макет.ПолучитьОбласть("ПодвалТаблицыНДС|НомерСтроки");
		ОбластьКодовНДС			= Макет.ПолучитьОбласть("ПодвалТаблицыНДС|КолонкаКодов");
		ОбластьТоварНДС			= Макет.ПолучитьОбласть("ПодвалТаблицыНДС|Товар"  + ПостфиксКолонок);
		ОбластьДанныхНДС		= Макет.ПолучитьОбласть("ПодвалТаблицыНДС|Данные" + ПостфиксКолонок);
		
		ОбластьСуммаПрописью = Макет.ПолучитьОбласть("СуммаПрописью");
		
#КонецОбласти
		
#Область ВыводШапки
		
		// ШАПКА - ЗАГОЛОВОК
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ФормированиеПечатныхФорм.ВывестиЛоготипВТабличныйДокумент(Макет, ОбластьМакета, "Заголовок", ДанныеПечати.Организация);
		
		УстановитьПараметр(ОбластьМакета, "ТекстЗаголовка", ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(
			ДанныеПечати,
			ДанныеПечати.ПредставлениеДокумента));
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(
			ТабличныйДокумент,
			Макет,
			ОбластьМакета,
			ДанныеПечати.Ссылка);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// ШАПКА - ИСПОЛНИТЕЛЬ
		
		ОбластьМакета = Макет.ПолучитьОбласть("Исполнитель");
		УстановитьПараметр(ОбластьМакета, "ПредставлениеИсполнителя", ОписаниеОрганизации(ДанныеПечати, "Исполнитель"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// ШАПКА - ЗАКАЗЧИК
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заказчик");
		УстановитьПараметр(ОбластьМакета, "ПредставлениеЗаказчика", ОписаниеОрганизации(ДанныеПечати, "Заказчик"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// ШАПКА - ГРУЗООТПРАВИТЕЛЬ
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузоотправитель) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Грузоотправитель");
			УстановитьПараметр(ОбластьМакета, "ПредставлениеГрузоотправителя", ОписаниеОрганизации(ДанныеПечати, "Грузоотправитель"));
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// ШАПКА - ГРУЗОПОЛУЧАТЕЛЬ
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузополучатель) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Грузополучатель");
			УстановитьПараметр(ОбластьМакета, "ПредставлениеГрузополучателя", ОписаниеОрганизации(ДанныеПечати, "Грузополучатель"));
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// ШАПКА - АДРЕС ДОСТАВКИ
		
		Если ЗначениеЗаполнено(ДанныеПечати.АдресДоставки) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("АдресДоставки");
			УстановитьПараметр(ОбластьМакета, "АдресДоставки", ДанныеПечати.АдресДоставки);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
#КонецОбласти
		
#Область ВыводТаблицыТовары
		
		// ТАБЛИЦА ТОВАРЫ - ШАПКА
		
		Если ЕстьСкидки Тогда
			УстановитьПараметр(ОбластьДанныхШапки, "Скидка", ЗаголовокСкидки.Скидка);
			УстановитьПараметр(ОбластьДанныхШапки, "СуммаБезСкидки", ЗаголовокСкидки.СуммаСкидки);
		КонецЕсли; 
		
		Если ВыводитьКоды Тогда
			УстановитьПараметр(ОбластьКодовШапки, "ИмяКолонкиКодов", КолонкаКодов);
		КонецЕсли;
		
		// ТАБЛИЦА ТОВАРЫ - СТРОКИ
		
		МассивПроверкиВывода = Новый Массив;
		МассивПроверкиВывода.Добавить(ОбластьНомераШапки);
		МассивПроверкиВывода.Добавить(ОбластьНомераПодвала);
		Если ПоказыватьНДС Тогда
			МассивПроверкиВывода.Добавить(ОбластьНомераНДС);
		КонецЕсли;
		МассивПроверкиВывода.Добавить(ОбластьСуммаПрописью);
		
		Сумма			= 0;
		СуммаНДС		= 0;
		ВсегоСкидок		= 0;
		ВсегоБезСкидок	= 0;
		
		НомерСтроки = 0;
		
		ПустыеДанные = НаборыСервер.ПустыеДанные();
		ВыводШапки = 0;
		
		СоответствиеСтавокНДС = Новый Соответствие;
		
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			
			Если НаборыСервер.ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьКодовСтроки   = ОбластьКодовСтрокиНабор;
				ОбластьНомераСтроки  = ОбластьНомераСтрокиНабор;
				ОбластьДанныхСтроки  = ОбластьДанныхСтрокиНабор;
				ОбластьТоварСтроки   = ОбластьТоварСтрокиНабор;
			ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьКодовСтроки   = ОбластьКодовСтрокиКомплектующие;
				ОбластьНомераСтроки  = ОбластьНомераСтрокиКомплектующие;
				ОбластьДанныхСтроки  = ОбластьДанныхСтрокиКомплектующие;
				ОбластьТоварСтроки   = ОбластьТоварСтрокиКомплектующие;
			Иначе
				ОбластьКодовСтроки   = ОбластьКодовСтрокиСтандарт;
				ОбластьНомераСтроки  = ОбластьНомераСтрокиСтандарт;
				ОбластьДанныхСтроки  = ОбластьДанныхСтрокиСтандарт;
				ОбластьТоварСтроки   = ОбластьТоварСтрокиСтандарт;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				УстановитьПараметр(ОбластьНомераСтроки, "НомерСтроки", Неопределено);
			Иначе
				НомерСтроки = НомерСтроки + 1;
				УстановитьПараметр(ОбластьНомераСтроки, "НомерСтроки", НомерСтроки);
			КонецЕсли;
			
			Если НомерСтроки = 0 И ВыводШапки <> 2 Тогда
				ВыводШапки = 1;
			КонецЕсли;
			
			МассивПроверкиВывода.Добавить(ОбластьНомераСтроки);
			
			Если ТабличныйДокумент.ПроверитьВывод(МассивПроверкиВывода) Тогда
				
				Если (НомерСтроки = 1 И ВыводШапки = 0) ИЛИ (НомерСтроки = 0 И ВыводШапки = 1) Тогда
					
					ВыводШапки = 2;
					
					ВывестиШапку(ТабличныйДокумент, ОбластьНомераШапки, ОбластьКодовШапки, ОбластьТоварШапки, ОбластьДанныхШапки, ВыводитьКоды);
					МассивПроверкиВывода.Удалить(0);
					
				КонецЕсли;
				
			Иначе
				
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВывестиШапку(ТабличныйДокумент, ОбластьНомераШапки, ОбластьКодовШапки, ОбластьТоварШапки, ОбластьДанныхШапки, ВыводитьКоды);
				
			КонецЕсли;
			
			МассивПроверкиВывода.Удалить(МассивПроверкиВывода.ВГраница());
			
			УстановитьПараметр(ОбластьНомераСтроки, "НомерСтроки", НомерСтроки);
			ТабличныйДокумент.Вывести(ОбластьНомераСтроки);
			
			Если ВыводитьКоды Тогда
				
				ИмяКолонки = КолонкаКодов;
				Если ДанныеПечати.Тип = "ЗаказПоставщикуПоДаннымПоставщика" Тогда
					ИмяКолонки = ИмяКолонки + "Исполнителя";
				КонецЕсли;
				
				УстановитьПараметр(ОбластьКодовСтроки, "Артикул", СтрокаТовары[ИмяКолонки]);
				ТабличныйДокумент.Присоединить(ОбластьКодовСтроки);
				
			КонецЕсли;
			
			Если ДанныеПечати.Тип = "ЗаказПоставщикуПоДаннымПоставщика" Тогда
				
				ПредставлениеНоменклатурыДляПечати = СтрокаТовары.НаименованиеНоменклатурыИсполнителя;
				
			Иначе
				ДополнительныеПараметрыПолученияНаименованияДляПечати = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
				ДополнительныеПараметрыПолученияНаименованияДляПечати.ВозвратнаяТара = СтрокаТовары.ЭтоВозвратнаяТара;				
				ДополнительныеПараметрыПолученияНаименованияДляПечати.Содержание = СтрокаТовары.Содержание;				
				
				ПредставлениеНоменклатурыДляПечати = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
					СтрокаТовары.НаименованиеПолное,
					СтрокаТовары.Характеристика,
					,
					,
					ДополнительныеПараметрыПолученияНаименованияДляПечати);
				
			КонецЕсли;
			
			ПрефиксИПостфикс = НаборыСервер.ПолучитьПрефиксИПостфикс(СтрокаТовары, ИспользоватьНаборы);
			УстановитьПараметр(ОбластьТоварСтроки, "Товар", ПрефиксИПостфикс.Префикс + ПредставлениеНоменклатурыДляПечати + ПрефиксИПостфикс.Постфикс);
			
			ТабличныйДокумент.Присоединить(ОбластьТоварСтроки);
			ОбластьДанныхСтроки.Параметры.Заполнить(СтрокаТовары);
			
			Если ЗаголовокСкидки.ЕстьСкидки Тогда
				УстановитьПараметр(ОбластьДанныхСтроки, "СуммаСкидки", ?(ЗаголовокСкидки.ТолькоНаценка, - СтрокаТовары.СуммаСкидки, СтрокаТовары.СуммаСкидки));
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьДанныхСтроки.Параметры.Заполнить(ПустыеДанные);
			Иначе
				ОбластьДанныхСтроки.Параметры.Заполнить(СтрокаТовары);
			КонецЕсли;
			
			ТабличныйДокумент.Присоединить(ОбластьДанныхСтроки);
			
			Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				Сумма    = Сумма    + СтрокаТовары.Сумма;
				СуммаНДС = СуммаНДС + СтрокаТовары.СуммаНДС;
				
				Если ЕстьСкидки Тогда
					ВсегоСкидок    = ВсегоСкидок    + СтрокаТовары.СуммаСкидки;
					ВсегоБезСкидок = ВсегоБезСкидок + СтрокаТовары.СуммаБезСкидки;
				КонецЕсли;
			
				Если ДанныеПечати.УчитыватьНДС Тогда
					
					СуммаНДСПоСтавке = СоответствиеСтавокНДС[СтрокаТовары.СтавкаНДС];
					
					Если СуммаНДСПоСтавке = Неопределено Тогда
						СуммаНДСПоСтавке = 0;
					КонецЕсли;
					
					СоответствиеСтавокНДС.Вставить(СтрокаТовары.СтавкаНДС, СуммаНДСПоСтавке + СтрокаТовары.СуммаНДС);
					
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		// ТАБЛИЦА ТОВАРЫ - ПОДВАЛ
		
		ТабличныйДокумент.Вывести(ОбластьНомераПодвала);
		
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьКодовПодвала);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьТоварПодвала);
		
		Если ЕстьСкидки Тогда
			УстановитьПараметр(ОбластьДанныхПодвала, "ВсегоСкидок", ?(ЗаголовокСкидки.ТолькоНаценка, -ВсегоСкидок, ВсегоСкидок));
			УстановитьПараметр(ОбластьДанныхПодвала, "ВсегоБезСкидок", ВсегоБезСкидок);
		КонецЕсли;
		
		УстановитьПараметр(ОбластьДанныхПодвала, "Всего", ФормированиеПечатныхФорм.ФорматСумм(Сумма));
		ТабличныйДокумент.Присоединить(ОбластьДанныхПодвала);
		
		// ТАБЛИЦА ТОВАРЫ - ИТОГО НДС
		
		Если Не ДанныеПечати.УчитыватьНДС Тогда
			
			ТабличныйДокумент.Вывести(ОбластьНомераНДС);
			
			Если ВыводитьКоды Тогда
				ТабличныйДокумент.Присоединить(ОбластьКодовНДС);
			КонецЕсли;
			
			ТабличныйДокумент.Присоединить(ОбластьТоварНДС);
			
			УстановитьПараметр(ОбластьДанныхНДС, "НДС", НСтр("ru = 'Без налога (НДС)';
															|en = 'Without tax (VAT)'"));
			УстановитьПараметр(ОбластьДанныхНДС, "ВсегоНДС", "-");
			
			ТабличныйДокумент.Присоединить(ОбластьДанныхНДС);
			
		Иначе
			
			Для Каждого ТекСтавкаНДС Из СоответствиеСтавокНДС Цикл
				
				ТабличныйДокумент.Вывести(ОбластьНомераНДС);
				
				Если ВыводитьКоды Тогда
					ТабличныйДокумент.Присоединить(ОбластьКодовНДС);
				КонецЕсли;
				
				ТабличныйДокумент.Присоединить(ОбластьТоварНДС);
				
				УстановитьПараметр(ОбластьДанныхНДС, "НДС", ФормированиеПечатныхФорм.ТекстНДСПоСтавке(ТекСтавкаНДС.Ключ, ДанныеПечати.ЦенаВключаетНДС));
				УстановитьПараметр(ОбластьДанныхНДС, "ВсегоНДС", ФормированиеПечатныхФорм.ФорматСумм(ТекСтавкаНДС.Значение, , "-"));
				
				ТабличныйДокумент.Присоединить(ОбластьДанныхНДС);
				
			КонецЦикла;
			
		КонецЕсли;
		
#КонецОбласти
		
#Область ВыводПодвала
		
		// ПОДВАЛ - СУММА ПРОПИСЬЮ
		
		СуммаКПрописи = Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СуммаНДС);
		
		//++ НЕ УТ
		Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.ЗаказПереработчику") Тогда
			ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %1';
										|en = 'Total items %1'");
		Иначе
		//-- НЕ УТ
			ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %1, на сумму %2';
										|en = 'Total items %1 to the amount of %2'");
		//++ НЕ УТ
		КонецЕсли;
		//-- НЕ УТ
		
		ИтоговаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстИтоговойСтроки,
			НомерСтроки, // Количество
			ФормированиеПечатныхФорм.ФорматСумм(СуммаКПрописи, ДанныеПечати.Валюта)); // Сумма
		
		УстановитьПараметр(ОбластьСуммаПрописью, "ИтоговаяСтрока", ИтоговаяСтрока);
		УстановитьПараметр(ОбластьСуммаПрописью, "СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(
			СуммаКПрописи,
			ДанныеПечати.Валюта));
		
		ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
		
		// ПОДВАЛ - ЭТАПЫ ГРАФИКА ОПЛАТЫ
		
		Если ТаблицаЭтапыОплаты.Количество() > 1 Тогда
			
			ОбластьШапкиТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицыЭтапыОплаты");
			ОбластьПодвалаТаблицы = Макет.ПолучитьОбласть("ИтогоЭтапыОплаты");
			
			МассивПроверкиВывода.Очистить();
			МассивПроверкиВывода.Добавить(ОбластьШапкиТаблицы);
			МассивПроверкиВывода.Добавить(ОбластьПодвалаТаблицы);
			
			ОбластьСтрокиТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицыЭтапыОплаты");
			
			НомерЭтапа = 1;
			Для Каждого ТекЭтап Из ТаблицаЭтапыОплаты Цикл
				
				ПараметрыСтроки = НовыеПараметрыСтрокиЭтапа();
				ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ТекЭтап);
				ПараметрыСтроки.НомерСтроки = НомерЭтапа;
				Если Не ПараметрыСтроки.ЭтоЗалогЗаТару Тогда
					ПараметрыСтроки.ТекстНДС = ФормированиеПечатныхФорм.СформироватьТекстНДСЭтапаОплаты(
						СоответствиеСтавокНДС,
						ТекЭтап.ПроцентПлатежа);
				Иначе
					ПараметрыСтроки.ВариантОплаты = Строка(ТекЭтап.ВариантОплаты) + " " + НСтр("ru = '(залог за тару)';
																								|en = '(deposit for package)'");
					ПараметрыСтроки.ПроцентПлатежа = "-";
					ПараметрыСтроки.ТекстНДС = НСтр("ru = 'Без налога (НДС)';
													|en = 'Without tax (VAT)'");
				КонецЕсли;
				
				ОбластьСтрокиТаблицы.Параметры.Заполнить(ПараметрыСтроки);
				
				МассивПроверкиВывода.Добавить(ОбластьСтрокиТаблицы);
				
				Если ТабличныйДокумент.ПроверитьВывод(МассивПроверкиВывода) Тогда
					
					Если НомерЭтапа=1 Тогда
						ТабличныйДокумент.Вывести(ОбластьШапкиТаблицы);
						МассивПроверкиВывода.Удалить(0);
					КонецЕсли;
					
				Иначе
					
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабличныйДокумент.Вывести(ОбластьШапкиТаблицы);
					
				КонецЕсли;
				
				МассивПроверкиВывода.Удалить(МассивПроверкиВывода.ВГраница());
				
				ТабличныйДокумент.Вывести(ОбластьСтрокиТаблицы);
				
				НомерЭтапа = НомерЭтапа + 1;
				
			КонецЦикла;
			
			ТабличныйДокумент.Вывести(ОбластьПодвалаТаблицы);
			
		КонецЕсли;
		
		// ПОДВАЛ - ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ
		
		Если ЗначениеЗаполнено(ДанныеПечати.ДополнительнаяИнформация) Тогда
			
			ОбластьМакета = Макет.ПолучитьОбласть("ДополнительнаяИнформация");
			УстановитьПараметр(ОбластьМакета, "ДополнительнаяИнформация", ДанныеПечати.ДополнительнаяИнформация);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		// ПОДВАЛ - ПОДПИСИ
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалЗаказа");
		УстановитьПараметр(ОбластьМакета, "ФИОМенеджер", ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Менеджер, ДанныеПечати.Дата));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
#КонецОбласти
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

// Прочее

Процедура УстановитьПараметр(ОбластьМакета, ИмяПараметра, ЗначениеПараметра)
	ОбластьМакета.Параметры.Заполнить(Новый Структура(ИмяПараметра, ЗначениеПараметра));
КонецПроцедуры

Функция ОписаниеОрганизации(ДанныеПечати, ИмяОрганизации)
	
	Сведения = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати[ИмяОрганизации], ДанныеПечати.Дата);
	Реквизиты = "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,";
	
	Возврат ФормированиеПечатныхФорм.ОписаниеОрганизации(Сведения, Реквизиты);
	
КонецФункции

Процедура ВывестиШапку(ТабличныйДокумент, ОбластьНомераШапки, ОбластьКодовШапки, ОбластьТоварШапки, ОбластьДанныхШапки, ВыводитьКоды)
	
	ТабличныйДокумент.Вывести(ОбластьНомераШапки);
	Если ВыводитьКоды Тогда
		ТабличныйДокумент.Присоединить(ОбластьКодовШапки);
	КонецЕсли;
	ТабличныйДокумент.Присоединить(ОбластьТоварШапки);
	ТабличныйДокумент.Присоединить(ОбластьДанныхШапки);
	
КонецПроцедуры

Функция НовыеПараметрыСтрокиЭтапа()
	
	СтруктураСтрокиЭтапа = Новый Структура;
	СтруктураСтрокиЭтапа.Вставить("НомерСтроки", 0);
	СтруктураСтрокиЭтапа.Вставить("ВариантОплаты", "");
	СтруктураСтрокиЭтапа.Вставить("ДатаПлатежа", '00010101');
	СтруктураСтрокиЭтапа.Вставить("ПроцентПлатежа", 0);
	СтруктураСтрокиЭтапа.Вставить("СуммаПлатежа", 0);
	СтруктураСтрокиЭтапа.Вставить("ТекстНДС", "");
	СтруктураСтрокиЭтапа.Вставить("ЭтоЗалогЗаТару", Ложь);
	
	Возврат СтруктураСтрокиЭтапа;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
