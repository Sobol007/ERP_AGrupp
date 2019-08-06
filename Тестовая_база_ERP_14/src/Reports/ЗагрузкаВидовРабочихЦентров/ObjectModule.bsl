#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	ЗначенияОтбораДанных = ПолучитьЗначенияОтбораДанных(НастройкиОсновнойСхемы);
	
	Если ЗначенияОтбораДанных.НачалоПериода = '000101010000' 
		ИЛИ ЗначенияОтбораДанных.ОкончаниеПериода = '000101010000' Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Период"" не заполнено.';
								|en = 'Period is not filled in.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборыДанных = СформироватьВнешниеНаборыДанных(НастройкиОсновнойСхемы);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);	
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьВнешниеНаборыДанных(НастройкиОсновнойСхемы)
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ЭтапПроизводства2_2"));
	ОТРаспоряжение = Новый ОписаниеТипов(МассивТипов);
	
	ДанныеОЗагрузке = Новый ТаблицаЗначений;
	ДанныеОЗагрузке.Колонки.Добавить("Подразделение",              Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
	ДанныеОЗагрузке.Колонки.Добавить("ВидРабочегоЦентра",          Новый ОписаниеТипов("СправочникСсылка.ВидыРабочихЦентров"));
	ДанныеОЗагрузке.Колонки.Добавить("ВариантНаладки",             Новый ОписаниеТипов("СправочникСсылка.ВариантыНаладки"));
	ДанныеОЗагрузке.Колонки.Добавить("ДоступноСекунд",             Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15)));
	ДанныеОЗагрузке.Колонки.Добавить("ЗанятоСекунд",               Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15)));
	ДанныеОЗагрузке.Колонки.Добавить("Номенклатура",               Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДанныеОЗагрузке.Колонки.Добавить("Характеристика",             Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ДанныеОЗагрузке.Колонки.Добавить("Количество",                 Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3)));
	ДанныеОЗагрузке.Колонки.Добавить("ПериодГрафика",              Новый ОписаниеТипов("Дата"));
	ДанныеОЗагрузке.Колонки.Добавить("ПериодГрафикаПредставление", Новый ОписаниеТипов("Строка"));
	ДанныеОЗагрузке.Колонки.Добавить("Распоряжение",        	   ОТРаспоряжение);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	//0
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоступностьВидовРабочихЦентровОбороты.ВидРабочегоЦентра КАК ВидРабочегоЦентра,
	|	ВЫБОР
	|		КОГДА ДоступностьВидовРабочихЦентровОбороты.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Час)
	|			ТОГДА НАЧАЛОПЕРИОДА(ДоступностьВидовРабочихЦентровОбороты.ДатаИнтервала, ДЕНЬ)
	|		ИНАЧЕ ДоступностьВидовРабочихЦентровОбороты.ДатаИнтервала
	|	КОНЕЦ КАК ПериодГрафика,
	|	СУММА(ВЫБОР
	|			КОГДА ДоступностьВидовРабочихЦентровОбороты.ВидРабочегоЦентра.ВводитьДоступностьДляВидаРЦ
	|				ТОГДА ДоступностьВидовРабочихЦентровОбороты.ДоступностьПоВидуРЦОборот
	|			ИНАЧЕ ДоступностьВидовРабочихЦентровОбороты.ДоступностьПоРЦОборот
	|		КОНЕЦ) КАК ДоступноСекунд
	|ИЗ
	|	РегистрНакопления.ДоступностьВидовРабочихЦентров.Обороты(
	|			,
	|			,
	|			,
	|			ДатаИнтервала МЕЖДУ &НачалоМесяца И &КонецМесяца
	|				И (&ЛюбойВидРабочегоЦентра
	|					ИЛИ ВидРабочегоЦентра В (&СписокВидовРабочихЦентров))) КАК ДоступностьВидовРабочихЦентровОбороты
	|ГДЕ
	|	(&ЛюбоеПодразделение
	|			ИЛИ ДоступностьВидовРабочихЦентровОбороты.ВидРабочегоЦентра.Подразделение В (&СписокПодразделений))
	|
	|СГРУППИРОВАТЬ ПО
	|	ДоступностьВидовРабочихЦентровОбороты.ВидРабочегоЦентра,
	|	ВЫБОР
	|		КОГДА ДоступностьВидовРабочихЦентровОбороты.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Час)
	|			ТОГДА НАЧАЛОПЕРИОДА(ДоступностьВидовРабочихЦентровОбороты.ДатаИнтервала, ДЕНЬ)
	|		ИНАЧЕ ДоступностьВидовРабочихЦентровОбороты.ДатаИнтервала
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА ТаблицаЗанятостьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.ЗаказНаПроизводство
	|				ИЛИ ТаблицаЗанятостьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.ЭтапПроизводства2_2
	|			ТОГДА ТаблицаЗанятостьВидовРабочихЦентров.Регистратор
	|		ИНАЧЕ ВЫРАЗИТЬ(ТаблицаЗанятостьВидовРабочихЦентров.Регистратор КАК Документ.МаршрутныйЛистПроизводства).Распоряжение
	|	КОНЕЦ КАК Распоряжение,
	|	ТаблицаЗанятостьВидовРабочихЦентров.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра КАК ВидРабочегоЦентра,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВариантНаладки КАК ВариантНаладки,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала КАК ДатаИнтервала,
	|	СУММА(ТаблицаЗанятостьВидовРабочихЦентров.Занято) КАК ЗанятоСекунд
	|ПОМЕСТИТЬ ЗанятостьВидовРабочихЦентров
	|ИЗ
	|	РегистрНакопления.ДоступностьВидовРабочихЦентров КАК ТаблицаЗанятостьВидовРабочихЦентров
	|ГДЕ
	|	(ТаблицаЗанятостьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.ЗаказНаПроизводство
	|			ИЛИ ТаблицаЗанятостьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.ЭтапПроизводства2_2
	|			ИЛИ ТаблицаЗанятостьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.МаршрутныйЛистПроизводства)
	|	И (&ЛюбойВидРабочегоЦентра
	|			ИЛИ ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра В (&СписокВидовРабочихЦентров))
	|	И ВЫБОР
	|			КОГДА (ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Час)
	|					ИЛИ ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.День))
	|					И (ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала МЕЖДУ &НачалоДня И &КонецДня)
	|				ТОГДА ИСТИНА
	|			КОГДА ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Неделя)
	|					И (ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала МЕЖДУ &НачалоНедели И &КонецНедели)
	|				ТОГДА ИСТИНА
	|			КОГДА ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Месяц)
	|					И (ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала МЕЖДУ &НачалоМесяца И &КонецМесяца)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА ТаблицаЗанятостьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.ЗаказНаПроизводство
	|				ИЛИ ТаблицаЗанятостьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.ЭтапПроизводства2_2
	|			ТОГДА ТаблицаЗанятостьВидовРабочихЦентров.Регистратор
	|		ИНАЧЕ ВЫРАЗИТЬ(ТаблицаЗанятостьВидовРабочихЦентров.Регистратор КАК Документ.МаршрутныйЛистПроизводства).Распоряжение
	|	КОНЕЦ,
	|	ТаблицаЗанятостьВидовРабочихЦентров.КодСтрокиПродукция,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВариантНаладки,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаЗанятостьВидовРабочихЦентров.Распоряжение КАК Распоряжение,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра КАК ВидРабочегоЦентра,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВариантНаладки КАК ВариантНаладки,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение КАК Подразделение,
	|	ВЫБОР
	|		КОГДА ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Час)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.День)
	|		ИНАЧЕ ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования
	|	КОНЕЦ КАК ИнтервалПланирования,
	|	ВЫБОР
	|		КОГДА ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Час)
	|			ТОГДА НАЧАЛОПЕРИОДА(ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала, ДЕНЬ)
	|		ИНАЧЕ ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала
	|	КОНЕЦ КАК ПериодГрафика,
	|	ТаблицаПродукция.Номенклатура КАК Номенклатура,
	|	ТаблицаПродукция.Характеристика КАК Характеристика,
	|	ТаблицаПродукция.Количество КАК Количество,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ЗанятоСекунд КАК ЗанятоСекунд
	|ИЗ
	|	ЗанятостьВидовРабочихЦентров КАК ТаблицаЗанятостьВидовРабочихЦентров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК ТаблицаПродукция
	|		ПО ((ВЫРАЗИТЬ(ТаблицаЗанятостьВидовРабочихЦентров.Распоряжение КАК Документ.ЗаказНаПроизводство)) = ТаблицаПродукция.Ссылка)
	|			И ТаблицаЗанятостьВидовРабочихЦентров.КодСтрокиПродукция = ТаблицаПродукция.КодСтроки
	|ГДЕ
	|	ТаблицаЗанятостьВидовРабочихЦентров.Распоряжение ССЫЛКА Документ.ЗаказНаПроизводство
	|	И ТаблицаПродукция.ГрафикРассчитан
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаЗанятостьВидовРабочихЦентров.Распоряжение,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВариантНаладки,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение,
	|	ВЫБОР
	|		КОГДА ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Час)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.День)
	|		ИНАЧЕ ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаЗанятостьВидовРабочихЦентров.ВидРабочегоЦентра.Подразделение.ИнтервалПланирования = ЗНАЧЕНИЕ(Перечисление.ТочностьГрафикаПроизводства.Час)
	|			ТОГДА НАЧАЛОПЕРИОДА(ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала, ДЕНЬ)
	|		ИНАЧЕ ТаблицаЗанятостьВидовРабочихЦентров.ДатаИнтервала
	|	КОНЕЦ,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	0,
	|	ТаблицаЗанятостьВидовРабочихЦентров.ЗанятоСекунд
	|ИЗ
	|	ЗанятостьВидовРабочихЦентров КАК ТаблицаЗанятостьВидовРабочихЦентров
	|ГДЕ
	|	ТаблицаЗанятостьВидовРабочихЦентров.Распоряжение ССЫЛКА Документ.ЭтапПроизводства2_2";
	
	ЗначенияОтбораДанных = ПолучитьЗначенияОтбораДанных(НастройкиОсновнойСхемы);
	
	Запрос.УстановитьПараметр("ЛюбоеПодразделение",        ЗначенияОтбораДанных.СписокПодразделений.Количество() = 0);
	Запрос.УстановитьПараметр("ЛюбойВидРабочегоЦентра",    ЗначенияОтбораДанных.СписокВидовРабочихЦентров.Количество() = 0);
	Запрос.УстановитьПараметр("СписокПодразделений",       ЗначенияОтбораДанных.СписокПодразделений);
	Запрос.УстановитьПараметр("СписокВидовРабочихЦентров", ЗначенияОтбораДанных.СписокВидовРабочихЦентров);
	
	// В зависимости от интервала планирования используется нужный период
	Запрос.УстановитьПараметр("НачалоДня",    НачалоДня(ЗначенияОтбораДанных.НачалоПериода));
	Запрос.УстановитьПараметр("КонецДня",     КонецДня(ЗначенияОтбораДанных.ОкончаниеПериода));
	Запрос.УстановитьПараметр("НачалоНедели", НачалоНедели(ЗначенияОтбораДанных.НачалоПериода));
	Запрос.УстановитьПараметр("КонецНедели",  КонецНедели(ЗначенияОтбораДанных.ОкончаниеПериода));
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(ЗначенияОтбораДанных.НачалоПериода));
	Запрос.УстановитьПараметр("КонецМесяца",  КонецМесяца(ЗначенияОтбораДанных.ОкончаниеПериода));
	
	Результат = Запрос.ВыполнитьПакет();
	
	ДоступностьВРЦ = Результат[0].Выгрузить();
	ДоступностьВРЦ.Индексы.Добавить("ВидРабочегоЦентра,ПериодГрафика");
	
	ЗанятостьВРЦ = Результат[2].Выгрузить();
	ЗанятостьВРЦ.Индексы.Добавить("ВидРабочегоЦентра,ПериодГрафика");
	
	СписокВидовРЦ = ЗанятостьВРЦ.Скопировать(,"Подразделение,ВидРабочегоЦентра,ИнтервалПланирования");
	СписокВидовРЦ.Свернуть("Подразделение,ВидРабочегоЦентра,ИнтервалПланирования");
	
	Для каждого СтрокаВидРЦ Из СписокВидовРЦ Цикл
		
		ТекущийПериод = ПланированиеПроизводстваКлиентСервер.НачалоИнтервалаПланирования(
										ЗначенияОтбораДанных.НачалоПериода, 
										СтрокаВидРЦ.ИнтервалПланирования);
										
		Пока ТекущийПериод <= ЗначенияОтбораДанных.ОкончаниеПериода Цикл
			
			СтруктураПоиска = Новый Структура("ВидРабочегоЦентра,ПериодГрафика", СтрокаВидРЦ.ВидРабочегоЦентра, ТекущийПериод);
		 	НайденнаяЗанятостьВРЦ = ЗанятостьВРЦ.НайтиСтроки(СтруктураПоиска);
		 	НайденнаяДоступностьВРЦ = ДоступностьВРЦ.НайтиСтроки(СтруктураПоиска);
			
			Если НайденнаяЗанятостьВРЦ.Количество() <> 0 Тогда
				Для каждого ВыборкаЗанятостьВРЦ Из НайденнаяЗанятостьВРЦ Цикл
					СтрокаДанные = ДанныеОЗагрузке.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаДанные, ВыборкаЗанятостьВРЦ);
					СтрокаДанные.ПериодГрафика = ТекущийПериод;
					СтрокаДанные.ПериодГрафикаПредставление = ОперативныйУчетПроизводства.ИнтервалПланированияСтрокой(
																					СтрокаДанные.ПериодГрафика, 
																					СтрокаВидРЦ.ИнтервалПланирования);
																					
					Если НайденнаяДоступностьВРЦ.Количество() <> 0 Тогда
						СтрокаДанные.ДоступноСекунд = НайденнаяДоступностьВРЦ[0].ДоступноСекунд;
					КонецЕсли; 
				КонецЦикла;
			Иначе	
				СтрокаДанные = ДанныеОЗагрузке.Добавить();
				СтрокаДанные.ВидРабочегоЦентра = СтрокаВидРЦ.ВидРабочегоЦентра;
				СтрокаДанные.Подразделение = СтрокаВидРЦ.Подразделение;
				СтрокаДанные.ПериодГрафика = ТекущийПериод;
				
				СтрокаДанные.ПериодГрафикаПредставление = ОперативныйУчетПроизводства.ИнтервалПланированияСтрокой(
																				СтрокаДанные.ПериодГрафика, 
																				СтрокаВидРЦ.ИнтервалПланирования);
																				
				Если НайденнаяДоступностьВРЦ.Количество() <> 0 Тогда
					СтрокаДанные.ДоступноСекунд = НайденнаяДоступностьВРЦ[0].ДоступноСекунд;
				КонецЕсли; 
			КонецЕсли;
			
			ТекущийПериод = ПланированиеПроизводстваКлиентСервер.ОкончаниеИнтервалаПланирования(ТекущийПериод, СтрокаВидРЦ.ИнтервалПланирования) + 1;
		КонецЦикла;
		
	КонецЦикла;
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеОЗагрузке", ДанныеОЗагрузке);
	
	Возврат ВнешниеНаборыДанных;

КонецФункции
 
Функция ПолучитьЗначенияОтбораДанных(НастройкиОсновнойСхемы)

	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Период").Значение;
	
	ЭлементыОтбора = НастройкиОсновнойСхемы.Отбор.Элементы;
	
	СписокПодразделений = Новый СписокЗначений;
	СписокВидовРабочихЦентров = Новый СписокЗначений;
	
	Если ЭлементыОтбора <> Неопределено Тогда
		Подразделение  = ЗначениеОтбора("Подразделение", ЭлементыОтбора);
		Если Подразделение <> Неопределено И ТипЗнч(Подразделение) = Тип("СписокЗначений") Тогда
			СписокПодразделений.ЗагрузитьЗначения(Подразделение.ВыгрузитьЗначения());
		ИначеЕсли Подразделение <> Неопределено Тогда
			СписокПодразделений.Добавить(Подразделение);
		КонецЕсли;
		
		ВидРабочегоЦентра = ЗначениеОтбора("ВидРабочегоЦентра", ЭлементыОтбора);
		Если ВидРабочегоЦентра <> Неопределено И ТипЗнч(ВидРабочегоЦентра) = Тип("СписокЗначений") Тогда
			СписокВидовРабочихЦентров.ЗагрузитьЗначения(ВидРабочегоЦентра.ВыгрузитьЗначения());
		ИначеЕсли ВидРабочегоЦентра <> Неопределено Тогда
			СписокВидовРабочихЦентров.Добавить(ВидРабочегоЦентра);
		КонецЕсли;
	КонецЕсли; 
	
	ЗначенияОтбораДанных = Новый Структура;
	ЗначенияОтбораДанных.Вставить("СписокПодразделений",       СписокПодразделений);
	ЗначенияОтбораДанных.Вставить("СписокВидовРабочихЦентров", СписокВидовРабочихЦентров);
	ЗначенияОтбораДанных.Вставить("НачалоПериода",             Период.ДатаНачала);
	ЗначенияОтбораДанных.Вставить("ОкончаниеПериода",          Период.ДатаОкончания);
	
	Возврат ЗначенияОтбораДанных;
	
КонецФункции

Функция ЗначениеОтбора(ИмяПоля, ЭлементыОтбора)

	Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
	
	Для каждого ЭлементКоллекции Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементКоллекции) = Тип("ЭлементОтбораКомпоновкиДанных") 
			И ЭлементКоллекции.ЛевоеЗначение = Поле 
			И ЭлементКоллекции.Использование Тогда
			
			Возврат ЭлементКоллекции.ПравоеЗначение;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецЕсли
