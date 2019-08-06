
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ФормироватьРезервОтпусковБУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияРезерваОтпусков");
	КонецЕсли;
	
	//++ НЕ УТ
	Если (Не ФормироватьРезервОтпусковБУ Или
		ФормироватьРезервОтпусковБУ И МетодНачисленияРезерваОтпусков <> Перечисления.МетодыНачисленияРезервовОтпусков.НормативныйМетод)
		И Не ФормироватьРезервОтпусковНУ Тогда
	//-- НЕ УТ
		МассивНепроверяемыхРеквизитов.Добавить("НормативОтчисленийВРезервОтпусков");
		МассивНепроверяемыхРеквизитов.Добавить("ПредельнаяВеличинаОтчисленийВРезервОтпусков");
	//++ НЕ УТ
	КонецЕсли;
	//-- НЕ УТ
	
	//++ НЕ УТ
	Если Не ПрименяетсяЕНВД ИЛИ Не СистемаНалогообложения = Перечисления.СистемыНалогообложения.Общая Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияКосвенныхРасходовПоВидамДеятельности");
	КонецЕсли;
	//-- НЕ УТ
	
	Если Не ПрименяетсяЕНВД Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовЕНВД");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовЕНВД");
	КонецЕсли;
	
	Если НЕ РаздельныйУчетТоваровПоНалогообложениюНДС
	 ИЛИ ВариантУчетаНДСПриИзмененииВидаДеятельности = Перечисления.ВариантыУчетаНДСПриИзмененииВидаДеятельностиНаНеоблагаемую.ВключатьВСтоимость
	 ИЛИ СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовНеНДС");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовНеНДС");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовЕНВД");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовЕНВД");
	Иначе
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтатьяРасходовЕНВД, "КонтролироватьЗаполнениеАналитики") <> Истина Тогда
			МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовЕНВД");
		КонецЕсли;
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтатьяРасходовНеНДС, "КонтролироватьЗаполнениеАналитики") <> Истина Тогда
			МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовНеНДС");
		КонецЕсли;
	КонецЕсли;
	
	Если СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовСписаниеНДС");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовСписаниеНДС");
	Иначе
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтатьяРасходовСписаниеНДС, "КонтролироватьЗаполнениеАналитики") <> Истина Тогда
			МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовСписаниеНДС");
		КонецЕсли;
	КонецЕсли;
	
	Если Не ФормироватьРезервыПоСомнительнымДолгамБУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПериодичностьРезервовПоСомнительнымДолгамБУ");
	КонецЕсли;
	
	Если Не ФормироватьРезервыПоСомнительнымДолгамНУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПериодичностьРезервовПоСомнительнымДолгамНУ");
	КонецЕсли;
	
	Если
		(Не ФормироватьРезервыПоСомнительнымДолгамБУ И Не ФормироватьРезервыПоСомнительнымДолгамБУ) Или
		Не ПрименяетсяПБУ18
	Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидРазницПБУ18РезервовПоСомнительнымДолгам");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	РегистрыСведений.УчетнаяПолитикаОрганизаций.СкорректироватьЗависимыеПараметрыУчетнойПолитики(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Запись настроек в регистр УчетнаяПолитикаОрганизаций
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетнаяПолитикаОрганизаций.Организация КАК Организация,
	|	УчетнаяПолитикаОрганизаций.Организация.ЮрФизЛицо КАК ЮрФизЛицо,
	|	УчетнаяПолитикаОрганизаций.Период КАК Период
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних КАК УчетнаяПолитикаОрганизаций
	|ГДЕ
	|	УчетнаяПолитикаОрганизаций.УчетнаяПолитика = &УчетнаяПолитика";
	
	Запрос.УстановитьПараметр("УчетнаяПолитика", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		//++ НЕ УТ
		
		Набор = РегистрыСведений.НастройкиРасчетаРезервовОтпусков.СоздатьНаборЗаписей();
		Набор.Отбор.Организация.Установить(Выборка.Организация);
		Набор.Отбор.Период.Установить(НачалоГода(Выборка.Период));
		
		СтрокаНабора = Набор.Добавить();
		СтрокаНабора.Организация             = Выборка.Организация;
		СтрокаНабора.Период                  = НачалоГода(Выборка.Период);
		
		// настройки резервов
		ЗаполнитьЗначенияСвойств(СтрокаНабора, ЭтотОбъект,
			"ФормироватьРезервОтпусковБУ, ФормироватьРезервОтпусковНУ, МетодНачисленияРезерваОтпусков, НормативОтчисленийВРезервОтпусков, ПредельнаяВеличинаОтчисленийВРезервОтпусков");
		СтрокаНабора.ОпределятьИзлишкиЕжемесячно = ЭтотОбъект.ОпределятьИзлишкиРезервовОтпусковЕжемесячно;
		
		Набор.Записать(Истина);
		
		//-- НЕ УТ
		
		Набор = РегистрыСведений.УчетнаяПолитикаОрганизаций.СоздатьНаборЗаписей();
		Набор.Отбор.Организация.Установить(Выборка.Организация);
		Набор.Отбор.Период.Установить(Выборка.Период);
		
		СтрокаНабора = Набор.Добавить();
		СтрокаНабора.Организация             = Выборка.Организация;
		СтрокаНабора.Период                  = Выборка.Период;
		СтрокаНабора.УчетнаяПолитика         = ЭтотОбъект.Ссылка;
		
		// кэшируемые параметры учетной политики
		ПараметрыУчетнойПолитики = РегистрыСведений.УчетнаяПолитикаОрганизаций.СформироватьКэшируемыеПараметрыУчетнойПолитики(ЭтотОбъект, Выборка);
		ЗаполнитьЗначенияСвойств(СтрокаНабора, ПараметрыУчетнойПолитики);
		
		Набор.Записать(Истина);
		
	КонецЦикла;
	
	Справочники.УчетныеПолитикиОрганизаций.УстановитьЗначенияЗависимыхКонстант();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли

