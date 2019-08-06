#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Массив")
		И ДанныеЗаполнения.Количество() <> 0
		И ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.ЗаписиСкладскогоЖурналаВЕТИС") Тогда
		
		ЗаполнитьНаОснованииЗаписейСкладскогоЖурналаВЕТИС(ДанныеЗаполнения);
		
	КонецЕсли; 
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("ОбъединяемыеЗаписиСкладскогоЖурнала");
	
	Если СпособОбъединения = Перечисления.СпособыОбъединенияЗаписейСкладскогоЖурналаВЕТИС.Объединить Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗаписьСкладскогоЖурнала");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаИзмерения");
		МассивНепроверяемыхРеквизитов.Добавить("ВидПродукции");
	КонецЕсли; 
	
	Если СпособОбъединения <> Перечисления.СпособыОбъединенияЗаписейСкладскогоЖурналаВЕТИС.Объединить
		ИЛИ РучнойВводПродукции Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Продукция");
	КонецЕсли; 
	
	Если СпособОбъединения <> Перечисления.СпособыОбъединенияЗаписейСкладскогоЖурналаВЕТИС.Объединить
		ИЛИ НЕ РучнойВводПродукции Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаименованиеПродукции");
	КонецЕсли; 
	
	ОбменДаннымиВЕТИС.ПроверитьОтсутствиеДублейВТабличнойЧасти(
		ЭтотОбъект, "ОбъединяемыеЗаписиСкладскогоЖурнала", Новый Структура("ЗаписьСкладскогоЖурнала"), Отказ);
		
	ТекущееСостояние = РегистрыСведений.СтатусыДокументовВЕТИС.ТекущееСостояние(Ссылка);
	Если ТекущееСостояние.Статус <> Перечисления.СтатусыОбработкиОбъединенийЗаписейСкладскогоЖурналаВЕТИС.Выполнен
		И ТекущееСостояние.Статус <> Перечисления.СтатусыОбработкиОбъединенийЗаписейСкладскогоЖурналаВЕТИС.ВыполненЧерезWeb Тогда
		Если СпособОбъединения = Перечисления.СпособыОбъединенияЗаписейСкладскогоЖурналаВЕТИС.Присоединить Тогда
			ПроверитьВозможностьПрисоединения(Отказ);
		Иначе	
			ПроверитьВозможностьОбъединения(Отказ);
		КонецЕсли; 
	КонецЕсли; 
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Идентификатор = "";
	Если СпособОбъединения = Перечисления.СпособыОбъединенияЗаписейСкладскогоЖурналаВЕТИС.Объединить Тогда
		ЗаписьСкладскогоЖурнала = Неопределено;
	КонецЕсли;
	ОбъединяемыеЗаписиСкладскогоЖурнала.Очистить();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияВЕТИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ЗаписатьСтатусДокументаВЕТИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ИнтеграцияВЕТИС.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ЗаполнитьНаОснованииЗаписейСкладскогоЖурналаВЕТИС(ДанныеЗаполнения)

	Если ДанныеЗаполнения.Количество() = 0 Тогда
		
		ТекстОшибки = НСтр("ru = 'Для объединения записей необходимо выбрать записи складского журнала';
							|en = 'Для объединения записей необходимо выбрать записи складского журнала'");
			
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Количество() > 1 Тогда
		
		Выборка = Документы.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.ЗаписиЖурналаКоторыеНельзяОбъединить(ДанныеЗаполнения);
		
		Если Выборка.Количество() <> 0 Тогда
			
			Если (ДанныеЗаполнения.Количество() - Выборка.Количество()) < 2  Тогда
				
				ТекстОшибки = Документы.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.ПричиныПоКоторымНельзяОбъединитьЗаписи(Выборка);
				
				ВызватьИсключение ТекстОшибки;
				
			Иначе
				
				ЗаголовокПричин = НСтр("ru = 'Некоторые записи журнала не были добавлены в документ по причинам:';
										|en = 'Некоторые записи журнала не были добавлены в документ по причинам:'");
				ТекстСообщения = Документы.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.ПричиныПоКоторымНельзяОбъединитьЗаписи(Выборка, ЗаголовокПричин);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект); 
				
			КонецЕсли; 
			
		КонецЕсли; 
		
		Пока Выборка.Следующий() Цикл
			
			ДанныеЗаполнения.Удалить(ДанныеЗаполнения.Найти(Выборка.Ссылка));
			
		КонецЦикла;
		
		СпособОбъединения = Перечисления.СпособыОбъединенияЗаписейСкладскогоЖурналаВЕТИС.Объединить;
		
	Иначе
		
		СпособОбъединения = Перечисления.СпособыОбъединенияЗаписейСкладскогоЖурналаВЕТИС.Присоединить;
		
	КонецЕсли; 
	
	Для каждого ЭлементКоллекции Из ДанныеЗаполнения Цикл
		НоваяСтрока = ОбъединяемыеЗаписиСкладскогоЖурнала.Добавить();
		НоваяСтрока.ЗаписьСкладскогоЖурнала = ЭлементКоллекции;
	КонецЦикла; 
	
	СписокРеквизитов = Новый Структура;
	СписокРеквизитов.Вставить("ВидПродукции", "Продукция.ВидПродукции");
	СписокРеквизитов.Вставить("НаименованиеПродукции", "Продукция.Наименование");
	СписокРеквизитов.Вставить("ХозяйствующийСубъект", "ХозяйствующийСубъект");
	СписокРеквизитов.Вставить("Предприятие", "Предприятие");
	
	ЗначенияРеквизитовОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ОбъединяемыеЗаписиСкладскогоЖурнала[0].ЗаписьСкладскогоЖурнала, 
		СписокРеквизитов);
		
	ХозяйствующийСубъект = ЗначенияРеквизитовОбъекта.ХозяйствующийСубъект;
	Предприятие = ЗначенияРеквизитовОбъекта.Предприятие;
	
	Если СпособОбъединения = Перечисления.СпособыОбъединенияЗаписейСкладскогоЖурналаВЕТИС.Объединить Тогда
		ВидПродукции = ЗначенияРеквизитовОбъекта.ВидПродукции;
		НаименованиеПродукции = ЗначенияРеквизитовОбъекта.НаименованиеПродукции;
		РучнойВводПродукции = Истина;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьВозможностьПрисоединения(Отказ)

	ЕстьОшибки = Ложь;
	
	Если НЕ ЗначениеЗаполнено(ЗаписьСкладскогоЖурнала) Тогда
		ЕстьОшибки = Истина;
	КонецЕсли; 
	
	Если ОбъединяемыеЗаписиСкладскогоЖурнала.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Для присоединения записей необходимо выбрать хотя бы одну запись складского журнала';
								|en = 'Для присоединения записей необходимо выбрать хотя бы одну запись складского журнала'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОбъединяемыеЗаписиСкладскогоЖурнала",, ЕстьОшибки);
	КонецЕсли; 
	
	Если ЕстьОшибки Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	ДанныеСтроки = ОбъединяемыеЗаписиСкладскогоЖурнала.Найти(ЗаписьСкладскогоЖурнала, "ЗаписьСкладскогоЖурнала");
	Если ДанныеСтроки <> Неопределено Тогда
		
		ТекстСообщения = НСтр("ru = 'Запись не может быть присоединена сама к себе';
								|en = 'Запись не может быть присоединена сама к себе'");
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОбъединяемыеЗаписиСкладскогоЖурнала", ДанныеСтроки.НомерСтроки, "ЗаписьСкладскогоЖурнала");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕдиницыИзмеренияПродукции.ВидПродукцииGUID КАК ВидПродукцииGUID,
	|	ЕдиницыИзмеренияПродукции.ЕдиницаИзмеренияСсылка КАК ЕдиницаИзмерения,
	|	ЕдиницыИзмеренияПродукции.ГруппаЕдиницИзмерения КАК ГруппаЕдиницИзмерения
	|ПОМЕСТИТЬ ЕдиницыИзмеренияПродукции
	|ИЗ
	|	&ЕдиницыИзмеренияПродукции КАК ЕдиницыИзмеренияПродукции
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЕдиницаИзмерения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписьИсточник.Ссылка КАК Ссылка,
	|	ЗаписьИсточник.Представление КАК СсылкаПредставление,
	|	ЗаписьИсточник.ХозяйствующийСубъект КАК Источник_ХозяйствующийСубъект,
	|	ЗаписьИсточник.Предприятие КАК Источник_Предприятие,
	|	ЗаписьИсточник.Продукция.Продукция КАК Источник_Продукция,
	|	ЗаписьИсточник.СтранаПроизводства КАК Источник_СтранаПроизводства,
	|	ЗаписьИсточник.НизкокачественнаяПродукция КАК Источник_НизкокачественнаяПродукция,
	|	ЗаписьИсточник.СкоропортящаясяПродукция КАК Источник_СкоропортящаясяПродукция,
	|	ЕСТЬNULL(ЕдиницыИзмеренияПродукции.ГруппаЕдиницИзмерения, НЕОПРЕДЕЛЕНО) КАК Источник_ГруппаЕдиницИзмерения,
	|	ЗаписьПолучатель.ХозяйствующийСубъект КАК Получатель_ХозяйствующийСубъект,
	|	ЗаписьПолучатель.ХозяйствующийСубъект.Представление КАК Получатель_ХозяйствующийСубъектПредставление,
	|	ЗаписьПолучатель.Предприятие КАК Получатель_Предприятие,
	|	ЗаписьПолучатель.Предприятие.Представление КАК Получатель_ПредприятиеПредставление,
	|	ЗаписьПолучатель.Продукция.Продукция КАК Получатель_Продукция,
	|	ЗаписьПолучатель.Продукция.Продукция.Представление КАК Получатель_ПродукцияПредставление,
	|	ЗаписьПолучатель.Продукция.ТипПродукции.Представление КАК Получатель_ТипПродукцииПредставление,
	|	ЗаписьПолучатель.СтранаПроизводства КАК Получатель_СтранаПроизводства,
	|	ЗаписьПолучатель.СтранаПроизводства.Представление КАК Получатель_СтранаПроизводстваПредставление,
	|	ЗаписьПолучатель.НизкокачественнаяПродукция КАК Получатель_НизкокачественнаяПродукция,
	|	ЗаписьПолучатель.СкоропортящаясяПродукция КАК Получатель_СкоропортящаясяПродукция,
	|	ЕСТЬNULL(Получатель_ЕдиницыИзмеренияПродукции.ГруппаЕдиницИзмерения, НЕОПРЕДЕЛЕНО) КАК Получатель_ГруппаЕдиницИзмерения,
	|	ЗаписьИсточник.КоличествоВЕТИС = 0 КАК НетОстатка
	|ИЗ
	|	Справочник.ЗаписиСкладскогоЖурналаВЕТИС КАК ЗаписьИсточник
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗаписиСкладскогоЖурналаВЕТИС КАК ЗаписьПолучатель
	|		ПО (ЗаписьПолучатель.Ссылка = &ЗаписьСкладскогоЖурнала)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЕдиницыИзмеренияПродукции КАК ЕдиницыИзмеренияПродукции
	|		ПО (ЕдиницыИзмеренияПродукции.ЕдиницаИзмерения = ЗаписьИсточник.ЕдиницаИзмеренияВЕТИС)
	|			И (ЕдиницыИзмеренияПродукции.ВидПродукцииGUID = ЗаписьИсточник.Продукция.ВидПродукции.Идентификатор)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЕдиницыИзмеренияПродукции КАК Получатель_ЕдиницыИзмеренияПродукции
	|		ПО (Получатель_ЕдиницыИзмеренияПродукции.ЕдиницаИзмерения = ЗаписьПолучатель.ЕдиницаИзмеренияВЕТИС)
	|			И (ЕдиницыИзмеренияПродукции.ВидПродукцииGUID = ЗаписьПолучатель.Продукция.ВидПродукции.Идентификатор)
	|ГДЕ
	|	ЗаписьИсточник.Ссылка В(&ОбъединяемыеЗаписиСкладскогоЖурнала)
	|	И ЗаписьИсточник.Ссылка <> &ЗаписьСкладскогоЖурнала
	|	И (ЗаписьИсточник.ХозяйствующийСубъект <> ЗаписьПолучатель.ХозяйствующийСубъект
	|			ИЛИ ЗаписьИсточник.Предприятие <> ЗаписьПолучатель.Предприятие
	|			ИЛИ ЕСТЬNULL(ЗаписьИсточник.Продукция.Продукция, НЕОПРЕДЕЛЕНО) <> ЕСТЬNULL(ЗаписьПолучатель.Продукция.Продукция, НЕОПРЕДЕЛЕНО)
	|			ИЛИ ЗаписьИсточник.СтранаПроизводства <> ЗаписьПолучатель.СтранаПроизводства
	|			ИЛИ ЗаписьИсточник.НизкокачественнаяПродукция <> ЗаписьПолучатель.НизкокачественнаяПродукция
	|			ИЛИ ЗаписьИсточник.СкоропортящаясяПродукция <> ЗаписьПолучатель.СкоропортящаясяПродукция
	|			ИЛИ ЕСТЬNULL(ЕдиницыИзмеренияПродукции.ГруппаЕдиницИзмерения, НЕОПРЕДЕЛЕНО) <> ЕСТЬNULL(Получатель_ЕдиницыИзмеренияПродукции.ГруппаЕдиницИзмерения, НЕОПРЕДЕЛЕНО)
	|			ИЛИ ЗаписьИсточник.КоличествоВЕТИС = 0)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ЗаписьСкладскогоЖурнала", ЗаписьСкладскогоЖурнала);
	Запрос.УстановитьПараметр("ОбъединяемыеЗаписиСкладскогоЖурнала", ОбъединяемыеЗаписиСкладскогоЖурнала.ВыгрузитьКолонку("ЗаписьСкладскогоЖурнала"));
	Запрос.УстановитьПараметр("ЕдиницыИзмеренияПродукции", ПрочиеКлассификаторыВЕТИСВызовСервера.ЕдиницыИзмеренияПродукции());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СообщитьОбОшибках(Выборка, Отказ);
	
КонецПроцедуры

Процедура ПроверитьВозможностьОбъединения(Отказ)

	Если ОбъединяемыеЗаписиСкладскогоЖурнала.Количество() < 2 Тогда
		ТекстСообщения = НСтр("ru = 'Для объединения записей необходимо выбрать несколько записей складского журнала';
								|en = 'Для объединения записей необходимо выбрать несколько записей складского журнала'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОбъединяемыеЗаписиСкладскогоЖурнала", "", Отказ);
		Возврат;
	КонецЕсли; 
	
	Выборка = Документы.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.ЗаписиЖурналаКоторыеНельзяОбъединить(
				ОбъединяемыеЗаписиСкладскогоЖурнала.ВыгрузитьКолонку("ЗаписьСкладскогоЖурнала"));
	
	СообщитьОбОшибках(Выборка, Отказ);
	
КонецПроцедуры

Процедура СообщитьОбОшибках(Знач Выборка, Отказ)
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеСтроки = ОбъединяемыеЗаписиСкладскогоЖурнала.Найти(Выборка.Ссылка, "ЗаписьСкладскогоЖурнала");
		
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОбъединяемыеЗаписиСкладскогоЖурнала", ДанныеСтроки.НомерСтроки, "ЗаписьСкладскогоЖурнала");
		
		Если Выборка.Источник_Продукция <> Выборка.Получатель_Продукция Тогда
			
			ТекстСообщения = НСтр("ru = 'Запись журнала ""%1"" в строке %2 должна относиться к группе продукции ""%3 > %4""';
									|en = 'Запись журнала ""%1"" в строке %2 должна относиться к группе продукции ""%3 > %4""'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, 
										Выборка.СсылкаПредставление,
										Формат(ДанныеСтроки.НомерСтроки, "ЧГ="), 
										Выборка.Получатель_ТипПродукцииПредставление,
										Выборка.Получатель_ПродукцияПредставление);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		
		КонецЕсли; 
			
		Если Выборка.Источник_СтранаПроизводства <> Выборка.Получатель_СтранаПроизводства Тогда
			
			ТекстСообщения = НСтр("ru = 'Запись журнала ""%1"" в строке %2 должна относиться к стране происхождения ""%3""';
									|en = 'Запись журнала ""%1"" в строке %2 должна относиться к стране происхождения ""%3""'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, 
										Выборка.СсылкаПредставление,
										Формат(ДанныеСтроки.НомерСтроки, "ЧГ="), 
										Выборка.Получатель_СтранаПроизводстваПредставление);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		
		КонецЕсли; 
			
		Если Выборка.Источник_НизкокачественнаяПродукция <> Выборка.Получатель_НизкокачественнаяПродукция Тогда
			
			ТекстСообщения = ?(Выборка.Получатель_НизкокачественнаяПродукция,
			НСтр("ru = 'Запись журнала ""%1"" в строке %2 должна относиться к низкокачественной продукции';
				|en = 'Запись журнала ""%1"" в строке %2 должна относиться к низкокачественной продукции'"),
			НСтр("ru = 'Запись журнала ""%1"" в строке %2 не должна относиться к низкокачественной продукции';
				|en = 'Запись журнала ""%1"" в строке %2 не должна относиться к низкокачественной продукции'"));
			
			ТекстСообщения = СтрШаблон(ТекстСообщения, 
										Выборка.СсылкаПредставление,
										Формат(ДанныеСтроки.НомерСтроки, "ЧГ="));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		
		КонецЕсли; 
			
		Если Выборка.Источник_СкоропортящаясяПродукция <> Выборка.Получатель_СкоропортящаясяПродукция Тогда
			
			ТекстСообщения = ?(Выборка.Получатель_СкоропортящаясяПродукция,
			НСтр("ru = 'Запись журнала ""%1"" в строке %2 должна относиться к скоропортящейся продукции';
				|en = 'Запись журнала ""%1"" в строке %2 должна относиться к скоропортящейся продукции'"),
			НСтр("ru = 'Запись журнала ""%1"" в строке %2 не должна относиться к скоропортящейся продукции';
				|en = 'Запись журнала ""%1"" в строке %2 не должна относиться к скоропортящейся продукции'"));
			
			ТекстСообщения = СтрШаблон(ТекстСообщения, 
										Выборка.СсылкаПредставление,
										Формат(ДанныеСтроки.НомерСтроки, "ЧГ="));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		
		КонецЕсли; 
			
		Если Выборка.Источник_ГруппаЕдиницИзмерения <> Выборка.Получатель_ГруппаЕдиницИзмерения Тогда
			
			ТекстСообщения = НСтр("ru = 'Единца измерения продукции записи журнала ""%1"" в строке %2 должна относиться к группе продукции ""%3""';
									|en = 'Единца измерения продукции записи журнала ""%1"" в строке %2 должна относиться к группе продукции ""%3""'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, 
										Выборка.СсылкаПредставление,
										Формат(ДанныеСтроки.НомерСтроки, "ЧГ="),
										Выборка.Получатель_ГруппаЕдиницИзмерения);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		
		КонецЕсли; 
		
		Если Выборка.НетОстатка Тогда
			
			ТекстСообщения = НСтр("ru = 'Для записи журнала ""%1"" в строке %2 отсутствует остаток';
									|en = 'Для записи журнала ""%1"" в строке %2 отсутствует остаток'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, 
										Выборка.СсылкаПредставление,
										Формат(ДанныеСтроки.НомерСтроки, "ЧГ="));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		
		КонецЕсли; 
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли