#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
		
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Массив") Тогда
		
		Если ДанныеЗаполнения.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		Если ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.РесурсныеСпецификации") Тогда
			ЗаполнитьПоСпецификациям(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения[0]) = Тип("ДокументСсылка.ЗаказНаПроизводство2_2") Тогда
			ЗаполнитьПоЗаказу(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения[0]) = Тип("ДокументСсылка.ЭтапПроизводства2_2") Тогда
			ЗаполнитьПоЭтапу(ДанныеЗаполнения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "ОбъектыКалькуляции";
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(
		ЭтотОбъект,
		МассивНепроверяемыхРеквизитов,
		Отказ,
		ПараметрыПроверки);
		
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "ОбъектыКалькуляции";
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	Если ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.ЗаказНаПроизводство Тогда
		
		ТекстОшибки = НСтр("ru = 'Перед расчетом требуется запланировать %1';
							|en = 'It is required to plan %1 before calculation'");
		
		Заказы = ОбъектыКалькуляции.ВыгрузитьКолонку("Объект");
		СтатусыЗаказов = Документы.ЗаказНаПроизводство2_2.ЗаказыЗапланированы(Заказы);
		Для Каждого КлючИЗначение Из СтатусыЗаказов Цикл
			
			Если КлючИЗначение.Значение Тогда
				Продолжить;
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, КлючИЗначение.Ключ),
				Ссылка,
				
				,
				,
				Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		ЗаписатьОчередьФоновогоПроведения(Истина);
		ЗапуститьФоновуюОбработкуДвижений(Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЗаписатьОчередьФоновогоПроведения();
	
	ЗапуститьФоновуюОбработкуДвижений(Ссылка);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный 	= Пользователи.ТекущийПользователь();
	Организация 	= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	ВидЦены 		= Справочники.ВидыЦен.ВидЦеныПлановойСтоимостиТМЦ(ВидЦены);
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект);
	
КонецПроцедуры

Процедура ЗаписатьОчередьФоновогоПроведения(ОтменаПроведения = Ложь)
	
	Очередь = Новый ТаблицаЗначений;
	Очередь.Колонки.Добавить("Калькуляция", Новый ОписаниеТипов("ДокументСсылка.ПлановаяКалькуляция2_2"));
	Очередь.Колонки.Добавить("ОтменаПроведения", Новый ОписаниеТипов("Булево"));
	
	СтрокаОчередь = Очередь.Добавить();
	СтрокаОчередь.Калькуляция = Ссылка;
	СтрокаОчередь.ОтменаПроведения = ОтменаПроведения;
	
	РегистрыСведений.ОчередьРасчетаПлановыхКалькуляций.ЗаписатьОчередь(Очередь, Ссылка);
	РегистрыСведений.СостоянияПлановыхКалькуляций.УстановитьСостояние(Ссылка, "Рассчитывается");
	
КонецПроцедуры

Процедура ЗапуститьФоновуюОбработкуДвижений(Калькуляция)
	
	Документы.ПлановаяКалькуляция2_2.ЗапускВыполненияФоновогоПроведения(Калькуляция);
	
КонецПроцедуры

Процедура ЗаполнитьПоСпецификациям(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Изделия.Номенклатура КАК Номенклатура,
		|	Изделия.Характеристика КАК Характеристика,
		|	СУММА(Изделия.Количество) КАК Количество,
		|	СУММА(Изделия.КоличествоУпаковок) КАК КоличествоУпаковок,
		|	Изделия.Упаковка КАК Упаковка,
		|	Изделия.Ссылка КАК Объект
		|ИЗ
		|	Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК Изделия
		|ГДЕ
		|	Изделия.Ссылка В(&МассивОбъектов)
		|
		|СГРУППИРОВАТЬ ПО
		|	Изделия.Номенклатура,
		|	Изделия.Упаковка,
		|	Изделия.Характеристика,
		|	Изделия.Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	ОбъектыКалькуляции.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказу(ДанныеЗаполнения)
	
	ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.ЗаказНаПроизводство;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказНаПроизводство2_2Продукция.Номенклатура КАК Номенклатура,
		|	ЗаказНаПроизводство2_2Продукция.Характеристика КАК Характеристика,
		|	ЗаказНаПроизводство2_2Продукция.Упаковка КАК Упаковка,
		|	СУММА(ЗаказНаПроизводство2_2Продукция.КоличествоУпаковок) КАК КоличествоУпаковок,
		|	СУММА(ЗаказНаПроизводство2_2Продукция.Количество) КАК Количество,
		|	ЗаказНаПроизводство2_2.Ссылка КАК Объект,
		|	ЗаказНаПроизводство2_2.Подразделение КАК ПодразделениеДиспетчер,
		|	ЗаказНаПроизводство2_2Продукция.Назначение КАК Назначение,
		|	ЗаказНаПроизводство2_2.Организация КАК Организация
		|ИЗ
		|	Документ.ЗаказНаПроизводство2_2.Продукция КАК ЗаказНаПроизводство2_2Продукция
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство2_2 КАК ЗаказНаПроизводство2_2
		|		ПО ЗаказНаПроизводство2_2Продукция.Ссылка = ЗаказНаПроизводство2_2.Ссылка
		|			И (НЕ ЗаказНаПроизводство2_2Продукция.Отменено)
		|ГДЕ
		|	ЗаказНаПроизводство2_2.Ссылка В(&МассивОбъектов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказНаПроизводство2_2Продукция.Характеристика,
		|	ЗаказНаПроизводство2_2Продукция.Упаковка,
		|	ЗаказНаПроизводство2_2.Ссылка,
		|	ЗаказНаПроизводство2_2Продукция.Номенклатура,
		|	ЗаказНаПроизводство2_2Продукция.Назначение,
		|	ЗаказНаПроизводство2_2.Подразделение,
		|	ЗаказНаПроизводство2_2.Организация";
	
	Запрос.УстановитьПараметр("МассивОбъектов", ДанныеЗаполнения);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПодразделениеДиспетчер = Выборка.ПодразделениеДиспетчер;
		Организация = Выборка.Организация;
		НовыйОбъект = ОбъектыКалькуляции.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйОбъект, Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоЭтапу(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЭтапПроизводства2_2.Распоряжение
		|ИЗ
		|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
		|ГДЕ
		|	ЭтапПроизводства2_2.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", ДанныеЗаполнения);
	
	ЗаполнитьПоЗаказу(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Распоряжение"));
	
КонецПроцедуры

Процедура ПроверитьВозможностьВводаНаОсновании(Основания)
	
	Если ТипЗнч(Основания[0]) = Тип("СправочникСсылка.РесурсныеСпецификации") Тогда
		ТекстЗапроса = 
			"ВЫБРАТЬ
			|	РесурсныеСпецификации.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.РесурсныеСпецификации КАК РесурсныеСпецификации
			|ГДЕ
			|	РесурсныеСпецификации.ТипПроизводственногоПроцесса = ЗНАЧЕНИЕ(Перечисление.ТипыПроизводственныхПроцессов.Разборка)
			|	И РесурсныеСпецификации.Ссылка В(&Основания)";
	ИначеЕсли ТипЗнч(Основания[0]) = Тип("ДокументСсылка.ЗаказНаПроизводство2_2") Тогда
		ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ЗаказНаПроизводство2_2.Ссылка КАК Ссылка
			|ИЗ
			|	Документ.ЗаказНаПроизводство2_2 КАК ЗаказНаПроизводство2_2
			|ГДЕ
			|	ЗаказНаПроизводство2_2.ТипПроизводственногоПроцесса = ЗНАЧЕНИЕ(Перечисление.ТипыПроизводственныхПроцессов.Разборка)
			|	И ЗаказНаПроизводство2_2.Ссылка В(&Основания)";
	Иначе
		ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ЗаказНаПроизводство2_2.Ссылка КАК Ссылка
			|ИЗ
			|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство2_2 КАК ЗаказНаПроизводство2_2
			|		ПО ЭтапПроизводства2_2.Распоряжение = ЗаказНаПроизводство2_2.Ссылка
			|ГДЕ
			|	ЗаказНаПроизводство2_2.ТипПроизводственногоПроцесса = ЗНАЧЕНИЕ(Перечисление.ТипыПроизводственныхПроцессов.Разборка)
			|	И ЭтапПроизводства2_2.Ссылка В(&Основания)";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Основания", Основания);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстИсключения = НСтр("ru = 'Калькуляция разборки, утилизации не поддерживается.';
							|en = 'Disassembly and disposal costing is not supported.'");
	
	ВызватьИсключение ТекстИсключения;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
