
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.ОтборПоЭтапу.Пустая() Тогда
		НастроитьОтборПоЭтапу(Параметры.ОтборПоЭтапу);
	КонецЕсли;
	
	#Область УниверсальныеМеханизмы
	
	ТекущиеДелаПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Список);
	
	// ПодключаемоеОборудование
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	#КонецОбласти
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнформационноеСообщениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтключитьОтборПоЭтапу" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		НастроитьОтборПоЭтапу(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");

КонецПроцедуры

&НаСервере
Процедура НастроитьОтборПоЭтапу(Этап)
	
	Если Этап = Неопределено Тогда
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ДокументПереопределяемый.Ссылка        КАК Ссылка,
			|	ДокументПереопределяемый.Номер         КАК Номер,
			|	ДокументПереопределяемый.Дата          КАК Дата,
			|	ДокументПереопределяемый.Статус        КАК Статус,
			|	ДокументПереопределяемый.Подразделение КАК Подразделение,
			|	ДокументПереопределяемый.Участок       КАК Участок,
			|	ДокументПереопределяемый.Комментарий   КАК Комментарий
			|ИЗ
			|	Документ.СменноеЗадание КАК ДокументПереопределяемый";
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
		
		Элементы.ИнформационноеСообщение.Видимость = Ложь;
		
	Иначе
		
		// Настройка списка
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ДокументПереопределяемый.Ссылка        КАК Ссылка,
			|	ДокументПереопределяемый.Номер         КАК Номер,
			|	ДокументПереопределяемый.Дата          КАК Дата,
			|	ДокументПереопределяемый.Статус        КАК Статус,
			|	ДокументПереопределяемый.Подразделение КАК Подразделение,
			|	ДокументПереопределяемый.Участок       КАК Участок,
			|	ДокументПереопределяемый.Комментарий   КАК Комментарий
			|ИЗ
			|	Документ.СменноеЗадание КАК ДокументПереопределяемый
			|ГДЕ
			|	(ИСТИНА В
			|		(ВЫБРАТЬ ПЕРВЫЕ 1
			|			ИСТИНА
			|		ИЗ
			|			РегистрСведений.ОперацииКСозданиюСменныхЗаданий КАК Операции
			|		ГДЕ
			|			Операции.СменноеЗадание = ДокументПереопределяемый.Ссылка
			|			И Операции.Этап = &Этап)
			|	ИЛИ ИСТИНА В
			|		(ВЫБРАТЬ ПЕРВЫЕ 1
			|			ИСТИНА
			|		ИЗ
			|			Документ.ПроизводственнаяОперация2_2 КАК Операции
			|		ГДЕ
			|			Операции.СменноеЗадание = ДокументПереопределяемый.Ссылка
			|			И Операции.Этап = &Этап
			|			И Операции.Проведен))";
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
		Список.Параметры.УстановитьЗначениеПараметра("Этап", Этап);
		
		// Настройка информационного сообщения
		МассивСтрок = Новый Массив;
		
		ПредставлениеЭтапа = Документы.ЭтапПроизводства2_2.ПредставлениеЭтапа(
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Этап, "Номер, НаименованиеЭтапа"));
				
		МассивСтрок.Добавить(НСтр("ru = 'Установлен отбор по этапу';
									|en = 'Stage filter is set'"));
		МассивСтрок.Добавить(" ");
				
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			ПредставлениеЭтапа,
			,
			,
			,
			ПолучитьНавигационнуюСсылку(Этап)));
					
		МассивСтрок.Добавить(" (");
				
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'отключить';
																|en = 'disable'"),,,, "ОтключитьОтборПоЭтапу"));
				
		МассивСтрок.Добавить(") ");
				
		ИнформационноеСообщение = Новый ФорматированнаяСтрока(МассивСтрок);
			
		Элементы.ИнформационноеСообщение.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СменноеЗадание.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти
