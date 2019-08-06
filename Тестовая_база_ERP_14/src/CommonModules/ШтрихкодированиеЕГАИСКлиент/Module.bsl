
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗавершитьОбработкуВводаШтрихкода(ПараметрыЗавершенияВводаШтрихкода) Экспорт
	
	Форма                       = ПараметрыЗавершенияВводаШтрихкода.Форма;
	РезультатОбработкиШтрихкода = ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода;
	
	Если ЗначениеЗаполнено(РезультатОбработкиШтрихкода.ТекстОшибки)
		И Не РезультатОбработкиШтрихкода.ТребуетсяВыборНоменклатуры Тогда
		
		ДанныеШтрихкода = Новый Структура;
		ДанныеШтрихкода.Вставить("АлкогольнаяПродукция", РезультатОбработкиШтрихкода.АлкогольнаяПродукция);
		ДанныеШтрихкода.Вставить("Штрихкод",             РезультатОбработкиШтрихкода.Штрихкод);
		ДанныеШтрихкода.Вставить("ТекстОшибки",          РезультатОбработкиШтрихкода.ТекстОшибки);
		ДанныеШтрихкода.Вставить("ТипШтрихкода",         РезультатОбработкиШтрихкода.ТипШтрихкода);
		ДанныеШтрихкода.Вставить("ВидыПродукции",        РезультатОбработкиШтрихкода.ВидыПродукции);
		
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ДанныеШтрихкода);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ЕстьОшибкиВДеревеУпаковок Тогда
		
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, РезультатОбработкиШтрихкода.АдресДереваУпаковок);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ТребуетсяВыборНоменклатуры Тогда
		
		ОткрытьФорму(
			"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
			РезультатОбработкиШтрихкода.ПараметрыВыбораНоменклатуры,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборНоменклатурыЗавершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли РезультатОбработкиШтрихкода.ТребуетсяВыборСправки2 Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Ссылка", РезультатОбработкиШтрихкода.Справки2);
		
		ПараметрыВыбораСправки2 = Новый Структура;
		ПараметрыВыбораСправки2.Вставить("РежимВыбора",        Истина);
		ПараметрыВыбораСправки2.Вставить("ЗакрыватьПриВыборе", Истина);
		ПараметрыВыбораСправки2.Вставить("Отбор",              Отбор);
		
		ОткрытьФорму(
			"Справочник.Справки2ЕГАИС.ФормаВыбора",
			ПараметрыВыбораСправки2,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборСправки2Завершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
		
		ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(Форма);
		
		Если ПараметрыСканирования.ВозможнаЗагрузкаТСД
			И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Функция ТребуетсяУточнениеДанныхУПользователя(РезультатОбработки) Экспорт

	Возврат РезультатОбработки.ТребуетсяВыборСправки2;

КонецФункции

Процедура ВыборНоменклатурыЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если РезультатВыбора = Неопределено Тогда
		
		ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(Форма);
		
		Если ПараметрыСканирования.ВозможнаЗагрузкаТСД
			И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
			
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора.Номенклатура) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана номенклатура';
																|en = 'Не указана номенклатура'"));
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
		Действие = "ОбработатьВыборНоменклатуры";
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ВыполнитьДействие(
			Действие,
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
		
		ПараметрыЗавершенияВводаШтрихкода = ШтрихкодированиеИСКлиент.ПараметрыЗавершенияОбработкиВводаШтрихкода();
		ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода = РезультатОбработкиШтрихкода;
		ПараметрыЗавершенияВводаШтрихкода.КэшированныеЗначения        = ДополнительныеПараметры.КэшированныеЗначения;
		ПараметрыЗавершенияВводаШтрихкода.Форма                       = Форма;
		 
		ЗавершитьОбработкуВводаШтрихкода(ПараметрыЗавершенияВводаШтрихкода);
		
	Иначе
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборСправки2Завершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Действие = "ОбработатьВыборСправки2";
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ВыполнитьДействие(
			Действие,
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
		
		ПараметрыЗавершенияВводаШтрихкода = ШтрихкодированиеИСКлиент.ПараметрыЗавершенияОбработкиВводаШтрихкода();
		ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода = РезультатОбработкиШтрихкода;
		ПараметрыЗавершенияВводаШтрихкода.КэшированныеЗначения        = ДополнительныеПараметры.КэшированныеЗначения;
		ПараметрыЗавершенияВводаШтрихкода.Форма                       = Форма;
		
		ЗавершитьОбработкуВводаШтрихкода(ПараметрыЗавершенияВводаШтрихкода);
	Иначе
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораСправки2(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ДанныеОПроблеме) Экспорт
	
	Если ТипЗнч(ДанныеОПроблеме) = Тип("Структура") Тогда
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ДанныеШтрихкода", ДанныеОПроблеме);
	Иначе
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресХранилищаДереваУпаковки", ДанныеОПроблеме);
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.Форма.ИнформацияОНевозможностиДобавленияОтсканированного",
		ПараметрыОткрытияФормы,
		Форма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	
КонецПроцедуры

#КонецОбласти
