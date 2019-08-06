#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует отчет по документу заказа в табличном документе
//
// Параметры:
//	ТаблицаОтчета - ТабличныйДокумент
//	ДокументЗаказа - ДокументСсылка.ЗаказПоставщику
//
Процедура СформироватьОтчет(ТаблицаОтчета, ДокументЗаказа) Экспорт
	
	ПартнерДокументаЗаказа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументЗаказа, "Партнер");
	
	Если Не ЗначениеЗаполнено(ПартнерДокументаЗаказа) Тогда
		
		ТекстСообщения = НСтр("ru = 'В документе ""%1"" не заполнен реквизит ""Партнер""';
								|en = 'The ""partner"" attribute is not populated in document ""%1"".'");
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ДокументЗаказа);
		
	КонецЕсли;
	
	// Получаем макет
	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.АнализПричинОтменыЗаказовПоставщикамПоДокументу.АнализПричиныОтмены");
	
	// Получаем области макета
	ОбластьШапки = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокиШапки = Макет.ПолучитьОбласть("СтрокаШапки");
	ОбластьШапкиТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрокиПричиныОтмены = Макет.ПолучитьОбласть("СтрокаПричиныОтмены");
	ОбластьПустойОтчет = Макет.ПолучитьОбласть("ПустойОтчет");
	ОбластьВсеЗаказы = Макет.ПолучитьОбласть("ВсеЗаказы");
	ОбластьПодвалаТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьПодвалаТаблицыПустой = Макет.ПолучитьОбласть("ПодвалТаблицыПустой");
	
	МассивОбластейПозиций = Новый Массив;
	МассивОбластейПозиций.Добавить(Макет.ПолучитьОбласть("СтрокаПозиции"));
	МассивОбластейПозиций.Добавить(Макет.ПолучитьОбласть("СтрокаПозицииБольше10"));
	
	ОбластьПозицииОтменНет = Макет.ПолучитьОбласть("СтрокаПозицииОтменНет");
	
	// Формируем пакет запросов
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаказПоставщику", ДокументЗаказа);
	Запрос.УстановитьПараметр("Партнер", ПартнерДокументаЗаказа);
	СформироватьЗапросПоДокументуЗаказа(Запрос.Текст);
	
	УстановитьПривилегированныйРежим(Истина);
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	// Вычисляем индексы запросов в пакете документов
	КоличествоЗапросовВПакете = ПакетРезультатов.Количество();
	ИндексЗапросаАнализаПоДокументам = КоличествоЗапросовВПакете - 3;
	ИндексЗапросаПричиныОтменыПоВсемСтрокам = КоличествоЗапросовВПакете - 2;
	ИндексЗапросаПоНоменклатуре = КоличествоЗапросовВПакете - 1;
	
	// Заполняем шапку
	СтруктураПараметровШапки = Новый Структура();
	СтруктураПараметровШапки.Вставить("НаименованиеПоставщика", ПартнерДокументаЗаказа);
	
	ВывестиОбластьПустогоОтчета = Ложь;
	
	ВыборкаИтоговПоДокументам = ПакетРезультатов[ИндексЗапросаАнализаПоДокументам].Выбрать();
	Если ВыборкаИтоговПоДокументам.Следующий() Тогда
		
		Если ВыборкаИтоговПоДокументам.КоличествоЗаказов = 0 Тогда
			
			ВывестиОбластьПустогоОтчета = Истина;
			
		ИначеЕсли ВыборкаИтоговПоДокументам.КоличествоОтменыЗаказов = 0 Тогда
			
			СтруктураПараметровШапки.Вставить("КоличествоЗаказов", ВыборкаИтоговПоДокументам.КоличествоЗаказов);
			ОбластьВсеЗаказы.Параметры.Заполнить(СтруктураПараметровШапки);
			ТаблицаОтчета.Вывести(ОбластьВсеЗаказы);
			Возврат;
			
		КонецЕсли;
		
	Иначе // Результат анализа по всем документам пустой
		
		ВывестиОбластьПустогоОтчета = Истина;
		
	КонецЕсли;
	
	Если ВывестиОбластьПустогоОтчета Тогда
		ОбластьПустойОтчет.Параметры.Заполнить(СтруктураПараметровШапки);
		ТаблицаОтчета.Вывести(ОбластьПустойОтчет);
		
		Возврат;
	КонецЕсли;
	
	ПустаяСсылкаПричиныОтмены = ПредопределенноеЗначение("Справочник.ПричиныОтменыЗаказовПоставщикам.ПустаяСсылка");
	
	СтруктураПараметровШапки.Вставить("КоличествоОтменыЗаказов", ВыборкаИтоговПоДокументам.КоличествоОтменыЗаказов);
	СтруктураПараметровШапки.Вставить("КоличествоЗаказов", ВыборкаИтоговПоДокументам.КоличествоЗаказов);
	СтруктураПараметровШапки.Вставить("ПроцентОтменыЗаказов", ПолучитьПроцентВФорматеВывода(СтруктураПараметровШапки.КоличествоОтменыЗаказов, СтруктураПараметровШапки.КоличествоЗаказов));
	
	ВыборкаИтоговПоПричинамОтмены = ПакетРезультатов[ИндексЗапросаПричиныОтменыПоВсемСтрокам].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаИтоговПоПричинамОтмены.Следующий() Тогда
	
		СтруктураПараметровШапки.Вставить("КоличествоОтмены", ВыборкаИтоговПоПричинамОтмены.КоличествоОтмены);
		СтруктураПараметровШапки.Вставить("Количество", ВыборкаИтоговПоПричинамОтмены.Количество);
		СтруктураПараметровШапки.Вставить("ПроцентОтмены", ПолучитьПроцентВФорматеВывода(СтруктураПараметровШапки.КоличествоОтмены, СтруктураПараметровШапки.Количество));
		
		ОбластьШапки.Параметры.Заполнить(СтруктураПараметровШапки);
		ТаблицаОтчета.Вывести(ОбластьШапки);
		
		// Заполняем строки в шапке
		ВыборкаПоПричинамОтмены = ВыборкаИтоговПоПричинамОтмены.Выбрать();
		
		СтруктураПараметровСтроки = Новый Структура("ПричинаОтмены, КоличествоОтмены, Количество, ПроцентОтмены");
		Пока ВыборкаПоПричинамОтмены.Следующий() Цикл
			
			Если ВыборкаПоПричинамОтмены.ПричинаОтмены = ПустаяСсылкаПричиныОтмены Тогда
				Продолжить;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(СтруктураПараметровСтроки, ВыборкаПоПричинамОтмены);
			СтруктураПараметровСтроки.Количество = СтруктураПараметровШапки.Количество;
			СтруктураПараметровСтроки.ПроцентОтмены = ПолучитьПроцентВФорматеВывода(СтруктураПараметровСтроки.КоличествоОтмены, СтруктураПараметровСтроки.Количество);
			
			ОбластьСтрокиШапки.Параметры.Заполнить(СтруктураПараметровСтроки);
			ТаблицаОтчета.Вывести(ОбластьСтрокиШапки);
		КонецЦикла;
		
	КонецЕсли;
	
	// Заполняем шапку табличной части
	ТаблицаОтчета.Вывести(ОбластьШапкиТаблицы);
	КоличествоДействующихСтрок = 0;
	ОбщееКоличествоСтрок = 0;
	
	// Заполняем строки таблицы
	ВыборкаПоОбщимИтогам = ПакетРезультатов[ИндексЗапросаПоНоменклатуре].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если НЕ ВыборкаПоОбщимИтогам.Следующий() ИЛИ ВыборкаПоОбщимИтогам.КоличествоОтмены = 0 Тогда
		
		ТаблицаОтчета.Вывести(ОбластьПозицииОтменНет);
		
	Иначе
	
		ВыборкаПоНоменклатуре = ВыборкаПоОбщимИтогам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоНоменклатуре.Следующий() Цикл
			
			ВыборкаПоХарактеристикам = ВыборкаПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоХарактеристикам.Следующий() Цикл
				
				ОбщееКоличествоСтрок = ОбщееКоличествоСтрок + 1;
				
				Если ВыборкаПоХарактеристикам.КоличествоОтмены = 0 Тогда
					КоличествоДействующихСтрок = КоличествоДействующихСтрок + 1;
					Продолжить;
				КонецЕсли;
				
				СтруктураСтрокиПозиции = Новый Структура;
				СтруктураСтрокиПозиции.Вставить("ПредставлениеНоменклатуры", НоменклатураКлиентСервер.ПредставлениеНоменклатуры(ВыборкаПоНоменклатуре.Номенклатура,
																																ВыборкаПоХарактеристикам.Характеристика));
				СтруктураСтрокиПозиции.Вставить("КоличествоОтмены", ВыборкаПоХарактеристикам.КоличествоОтмены);
				СтруктураСтрокиПозиции.Вставить("Количество", ВыборкаПоХарактеристикам.Количество);
				СтруктураСтрокиПозиции.Вставить("ПроцентОтмены", ПолучитьПроцентВФорматеВывода(СтруктураСтрокиПозиции.КоличествоОтмены, СтруктураСтрокиПозиции.Количество));
				
				ИндексОбласти = ИндексОбластиПоПроценту(СтруктураСтрокиПозиции.КоличествоОтмены, СтруктураСтрокиПозиции.Количество);
				ОбластьСтрокиПозиции = МассивОбластейПозиций[ИндексОбласти];
				ОбластьСтрокиПозиции.Параметры.Заполнить(СтруктураСтрокиПозиции);
				ТаблицаОтчета.Вывести(ОбластьСтрокиПозиции);
				
				ВыборкаПоПричинамОтмены = ВыборкаПоХарактеристикам.Выбрать();
				Пока ВыборкаПоПричинамОтмены.Следующий() Цикл
					
					Если ВыборкаПоПричинамОтмены.ПричинаОтмены = ПустаяСсылкаПричиныОтмены Тогда
						Продолжить;
					КонецЕсли;
					
					СтруктураСтрокиПричины = Новый Структура;
					СтруктураСтрокиПричины.Вставить("ПричинаОтмены", ВыборкаПоПричинамОтмены.ПричинаОтмены);
					СтруктураСтрокиПричины.Вставить("КоличествоОтмены", ВыборкаПоПричинамОтмены.КоличествоОтмены);
					СтруктураСтрокиПричины.Вставить("Количество", СтруктураСтрокиПозиции.Количество);
					СтруктураСтрокиПричины.Вставить("ПроцентОтмены", ПолучитьПроцентВФорматеВывода(СтруктураСтрокиПричины.КоличествоОтмены, СтруктураСтрокиПричины.Количество));
					
					ОбластьСтрокиПричиныОтмены.Параметры.Заполнить(СтруктураСтрокиПричины);
					ТаблицаОтчета.Вывести(ОбластьСтрокиПричиныОтмены);
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Заполняем подвал таблицы
	СтруктураПараметровПодвала = Новый Структура("Количество, ОбщееКоличество", КоличествоДействующихСтрок, ОбщееКоличествоСтрок);
	
	Если КоличествоДействующихСтрок = 0 Тогда
		ТаблицаОтчета.Вывести(ОбластьПодвалаТаблицыПустой);
	Иначе
		ТаблицаОтчета.Вывести(ОбластьПодвалаТаблицы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИндексОбластиПоПроценту(Количество, ОбщееКоличество)
	
	Доля = Количество/ОбщееКоличество;
	
	Если Доля < 0.1 Тогда
		Возврат 0;
	Иначе
		Возврат 1;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПроцентВФорматеВывода(Количество, ОбщееКоличество)
	
	Возврат Формат((Количество / ОбщееКоличество) * 100, "ЧДЦ=2; ЧН=0");
	
КонецФункции

Процедура СформироватьЗапросПоДокументуЗаказа(ТекстЗапроса)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПричиныОтменыЗаказовПоставщикам.Ссылка КАК ПричинаОтмены
	|ПОМЕСТИТЬ ПричиныДляАнализа
	|ИЗ
	|	Справочник.ПричиныОтменыЗаказовПоставщикам КАК ПричиныОтменыЗаказовПоставщикам
	|ГДЕ
	|	ПричиныОтменыЗаказовПоставщикам.ИнициаторОтменыЗаказовПоставщикам = ЗНАЧЕНИЕ(Перечисление.ИнициаторОтменыЗаказовПоставщикам.Поставщик)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПричинаОтмены
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказПоставщикуТовары.Номенклатура КАК Номенклатура,
	|	ЗаказПоставщикуТовары.Характеристика КАК Характеристика,
	|	МИНИМУМ(ЗаказПоставщикуТовары.НомерСтроки) КАК Порядок
	|ПОМЕСТИТЬ СтрокиДокумента
	|ИЗ
	|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
	|ГДЕ
	|	ЗаказПоставщикуТовары.Ссылка = &ЗаказПоставщику
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПоставщикуТовары.Номенклатура,
	|	ЗаказПоставщикуТовары.Характеристика
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыПоставщикам.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ЗаказыПоставщикам.Номенклатура КАК Номенклатура,
	|	ЗаказыПоставщикам.Характеристика КАК Характеристика,
	|	ЗаказыПоставщикам.КодСтроки КАК КодСтроки,
	|	МАКСИМУМ(ПричиныДляАнализа.ПричинаОтмены) КАК ПричинаОтмены
	|ПОМЕСТИТЬ ДанныеДляАнализа
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ДокументыЗаказПоставщику
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикам
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПричиныДляАнализа КАК ПричиныДляАнализа
	|			ПО ЗаказыПоставщикам.ПричинаОтмены = ПричиныДляАнализа.ПричинаОтмены
	|		ПО (ЗаказыПоставщикам.ЗаказПоставщику = ДокументыЗаказПоставщику.Ссылка)
	|ГДЕ
	|	ДокументыЗаказПоставщику.Партнер = &Партнер
	|	И ДокументыЗаказПоставщику.Ссылка <> &ЗаказПоставщику
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказыПоставщикам.ЗаказПоставщику,
	|	ЗаказыПоставщикам.Номенклатура,
	|	ЗаказыПоставщикам.Характеристика,
	|	ЗаказыПоставщикам.КодСтроки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаказПоставщику,
	|	Номенклатура,
	|	Характеристика,
	|	ПричинаОтмены
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДляАнализа.ЗаказПоставщику КАК ЗаказПоставщику,
	|	МАКСИМУМ(ДанныеДляАнализа.ПричинаОтмены) КАК ПричинаОтмены
	|ПОМЕСТИТЬ ДокументыДляАнализа
	|ИЗ
	|	ДанныеДляАнализа КАК ДанныеДляАнализа
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляАнализа.ЗаказПоставщику
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаказПоставщику
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДокументыДляАнализа.ЗаказПоставщику) КАК КоличествоЗаказов,
	|	СУММА(ВЫБОР
	|			КОГДА ДокументыДляАнализа.ПричинаОтмены ЕСТЬ NULL 
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК КоличествоОтменыЗаказов
	|ИЗ
	|	ДокументыДляАнализа КАК ДокументыДляАнализа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ДанныеДляАнализа.ПричинаОтмены, ЗНАЧЕНИЕ(Справочник.ПричиныОтменыЗаказовПоставщикам.ПустаяСсылка)) КАК ПричинаОтмены,
	|	СУММА(ВЫБОР
	|			КОГДА ДанныеДляАнализа.ПричинаОтмены ЕСТЬ NULL 
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК КоличествоОтмены,
	|	СУММА(1) КАК Количество
	|ИЗ
	|	ДанныеДляАнализа КАК ДанныеДляАнализа
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(ДанныеДляАнализа.ПричинаОтмены, ЗНАЧЕНИЕ(Справочник.ПричиныОтменыЗаказовПоставщикам.ПустаяСсылка))
	|
	|УПОРЯДОЧИТЬ ПО
	|	КоличествоОтмены УБЫВ
	|ИТОГИ ПО
	|	ОБЩИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(ДанныеДляАнализа.Номенклатура) КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ДанныеДляАнализа.Характеристика) КАК Характеристика,
	|	ЕСТЬNULL(ДанныеДляАнализа.ПричинаОтмены, ЗНАЧЕНИЕ(Справочник.ПричиныОтменыЗаказовПоставщикам.ПустаяСсылка)) КАК ПричинаОтмены,
	|	СУММА(1) КАК Количество,
	|	СУММА(ВЫБОР
	|			КОГДА ДанныеДляАнализа.ПричинаОтмены ЕСТЬ NULL 
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК КоличествоОтмены,
	|	МИНИМУМ(СтрокиДокумента.Порядок) КАК Порядок
	|ИЗ
	|	СтрокиДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеДляАнализа КАК ДанныеДляАнализа
	|		ПО СтрокиДокумента.Номенклатура = ДанныеДляАнализа.Номенклатура
	|			И СтрокиДокумента.Характеристика = ДанныеДляАнализа.Характеристика
	|ГДЕ
	|	ДанныеДляАнализа.ЗаказПоставщику В
	|			(ВЫБРАТЬ
	|				ДокументыДляАнализа.ЗаказПоставщику
	|			ИЗ
	|				ДокументыДляАнализа
	|			СГРУППИРОВАТЬ ПО
	|						ДокументыДляАнализа.ЗаказПоставщику)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(ДанныеДляАнализа.ПричинаОтмены, ЗНАЧЕНИЕ(Справочник.ПричиныОтменыЗаказовПоставщикам.ПустаяСсылка)),
	|	ПРЕДСТАВЛЕНИЕ(ДанныеДляАнализа.Номенклатура),
	|	ПРЕДСТАВЛЕНИЕ(ДанныеДляАнализа.Характеристика)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	КоличествоОтмены УБЫВ
	|ИТОГИ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПричинаОтмены),
	|	СУММА(Количество),
	|	СУММА(КоличествоОтмены),
	|	МИНИМУМ(Порядок)
	|ПО
	|	ОБЩИЕ,
	|	Номенклатура,
	|	Характеристика";

КонецПроцедуры

#КонецОбласти

#КонецЕсли