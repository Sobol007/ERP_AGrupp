#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в возврате товаров поставщику
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияЗакупок.Валюта;
	ВалютаВзаиморасчетов = УсловияЗакупок.ВалютаВзаиморасчетов;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация <> Организация Тогда
		Организация = УсловияЗакупок.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	ХозяйственнаяОперацияДоговора = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");
	ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
	ДопПараметры.ВалютаВзаиморасчетов = Валюта;
	Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(ЭтотОбъект, ХозяйственнаяОперацияДоговора, ДопПараметры);
	
	Если НЕ ЗначениеЗаполнено(УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов) 
		ИЛИ НЕ УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
		ПорядокОплаты = УсловияЗакупок.ПорядокОплаты;
	Иначе
		ПорядокОплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокОплаты");
	КонецЕсли;
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);

КонецПроцедуры

// Заполняет условия закупок по умолчанию в возврате товаров поставщику
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Соглашение) Тогда
		Соглашение = Справочники.СоглашенияСПоставщиками.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(Партнер);
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			
			Если Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
				И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
				
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
				
			Иначе
				
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				
			КонецЕсли;
				
		Иначе
			
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в возврате товаров поставщику
//
Процедура ЗаполнитьУсловияЗакупокПоСоглашению() Экспорт
	
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Соглашение);
	ЗаполнитьУсловияЗакупок(УсловияЗакупок);
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ИнициализироватьДокумент(ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнитьРеквизитыЗначениямиПоУмолчанию();
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ПоступлениеДенежныхДокументов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) Или Не Документы.ПоступлениеДенежныхДокументов.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПодотчетника Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
		
		ДенежныеСредстваСервер.ПроверитьДокументыЗакупкиАвансовогоОтчета(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Т.НомерСтроки КАК НомерСтроки,
	|	Т.НаименованиеДенежногоДокумента КАК Наименование,
	|	Т.Валюта КАК Валюта,
	|	Т.Цена КАК Цена
	|ПОМЕСТИТЬ ВтДД
	|ИЗ
	|	&ДенДокументы КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(Т.НомерСтроки) КАК НомерСтроки,
	|	Т.Наименование КАК Наименование,
	|	Т.Валюта КАК Валюта,
	|	Т.Цена КАК Цена
	|ИЗ
	|	ВтДД КАК Т
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Наименование,
	|	Т.Валюта,
	|	Т.Цена
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Т.НомерСтроки) > 1
	|
	|УПОРЯДОЧИТЬ ПО
	|	МИНИМУМ(Т.НомерСтроки)";
	
	КолонкиТЧ = "НомерСтроки, НаименованиеДенежногоДокумента, Валюта, Цена";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДенДокументы", ДенежныеДокументы.Выгрузить(, КолонкиТЧ));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru = 'Для данных денежного документа, указанных в строке %1 списка ""Денежные документы"" найдены дубли в последующих строках.';
							|en = 'Duplicates are found in the following lines for financial document data specified in the %1 line of the ""Financial documents"" list. '");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Выборка.НомерСтроки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДенежныеДокументы", Выборка.НомерСтроки, "НаименованиеДенежногоДокумента"),
			,
			Отказ);
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОтПоставщика = (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПоставщика);
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ПоступлениеДенежныхДокументов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	Если ОтПоставщика Тогда
		СуммаДокумента = ДенежныеДокументы.Итог("Сумма");
		ЗаполнитьВалютуВТаблицеВалютойИзШапки();
	Иначе
		СуммаДокумента = 0;
	КонецЕсли;
	
	СтруктураКурса = РаботаСКурсамиВалютУТ.СтруктураКурсаВалюты(Курс, Кратность);
	
	ЗаполнитьСуммуВзаиморасчетовВПоступлении(СтруктураКурса);
	РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(СтруктураКурса);

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьДенежныеДокументы();
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ДенежныеДокументы);
		
		// Уникальность строки для суммы разницы между возвратом и ценой денежного документа.
		Если ОтПоставщика Тогда
			
			РасшифровкаПлатежа.Очистить();
			Если СуммаВзаиморасчетов <> 0 Тогда
				НоваяСтрока = РасшифровкаПлатежа.Добавить();
				НоваяСтрока.Сумма = СуммаВзаиморасчетов;
			КонецЕсли;
			
			ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВТабличнойЧасти(
				ВалютаВзаиморасчетов,
				Дата,
				РасшифровкаПлатежа);
		Иначе
			РасшифровкаПлатежа.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПодотчетника Тогда
		ТаблицаДенежныеДокументы = ДенежныеДокументы.Выгрузить(,"Валюта, Сумма");
		ТаблицаДенежныеДокументы.Свернуть("Валюта", "Сумма");
		Если ТаблицаДенежныеДокументы.Количество() = 1 Тогда
			Если ЗначениеЗаполнено(ТаблицаДенежныеДокументы[0].Валюта) Тогда
				Валюта = ТаблицаДенежныеДокументы[0].Валюта;
			КонецЕсли;
			СуммаДокумента = ТаблицаДенежныеДокументы[0].Сумма;
		Иначе
			Валюта = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АвансовыйОтчет)
		И Не ДополнительныеСвойства.Свойство("НеОбновлятьАвансовыйОтчет") Тогда
		
		ДопСвойства = Новый Структура;
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(АвансовыйОтчет, ДопСвойства);
		МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(АвансовыйОтчет);
		МенеджерДокумента.ИнициализироватьДанныеДокумента(АвансовыйОтчет, ДопСвойства, "РеестрДокументов");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(АвансовыйОтчет, ДопСвойства, Отказ);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("АвансовыйОтчет")
		И Не ДополнительныеСвойства.Свойство("НеОбновлятьАвансовыйОтчет")
		И ЗначениеЗаполнено(ДополнительныеСвойства.АвансовыйОтчет)
		И ДополнительныеСвойства.АвансовыйОтчет <> АвансовыйОтчет Тогда
		
		ДопСвойства = Новый Структура;
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства.АвансовыйОтчет, ДопСвойства);
		МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДополнительныеСвойства.АвансовыйОтчет);
		МенеджерДокумента.ИнициализироватьДанныеДокумента(ДополнительныеСвойства.АвансовыйОтчет, ДопСвойства, "РеестрДокументов");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(ДополнительныеСвойства.АвансовыйОтчет, ДопСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(СтруктураКурса) Экспорт
	
	ТабличнаяЧасть = ДенежныеДокументы;
	
	СуммаВзаиморасчетовПоТЧ = ТабличнаяЧасть.Итог("СуммаВзаиморасчетов");
	
	Если СуммаВзаиморасчетов = СуммаВзаиморасчетовПоТЧ
		ИЛИ СуммаВзаиморасчетов < СуммаВзаиморасчетовПоТЧ Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаДокумента = Валюта;
	ВалютаЗаказа = ВалютаВзаиморасчетов;
	
	Если ВалютаДокумента = ВалютаЗаказа Тогда
		
		Для Индекс = 0 По ТабличнаяЧасть.Количество()-1 Цикл
			Если Не ЗначениеЗаполнено(ТабличнаяЧасть[Индекс].СуммаВзаиморасчетов) Тогда
				ТабличнаяЧасть[Индекс].СуммаВзаиморасчетов = ТабличнаяЧасть[Индекс].Сумма;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		// Получение кооэффициента пересчета в валюту заказа
		КоэффициентПересчетаВВалютуЗаказа = 1;
		Если ЗначениеЗаполнено(СтруктураКурса) И ТипЗнч(СтруктураКурса) = Тип("Структура") Тогда
			ВалютаРегУчета = Константы.ВалютаРегламентированногоУчета.Получить();
			
			Если НЕ ВалютаДокумента = ВалютаРегУчета И ВалютаЗаказа = ВалютаРегУчета Тогда
				КоэффициентПересчетаВВалютуЗаказа = СтруктураКурса.Кратность/СтруктураКурса.Курс;
			Иначе
				КоэффициентПересчетаВВалютуЗаказа = СтруктураКурса.Курс*СтруктураКурса.Кратность;
			КонецЕсли;
			
		Иначе
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ЕСТЬNULL(КурсВалютыДокумента.Курс, 1) *
			|	ЕСТЬNULL(КурсВалютыЗаказа.Кратность, 1) /
			|	(ЕСТЬNULL(КурсВалютыЗаказа.Курс, 1) *
			|	ЕСТЬNULL(КурсВалютыДокумента.Кратность, 1)) КАК КоэффициентПересчета
			|ИЗ
			|	РегистрСведений.КурсыВалют.СрезПоследних(&НаДату, Валюта = &ВалютаДокумента) КАК КурсВалютыДокумента
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&НаДату, Валюта = &ВалютаЗаказа) КАК КурсВалютыЗаказа
			|		ПО (ИСТИНА)");
			Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
			Запрос.УстановитьПараметр("ВалютаЗаказа", ВалютаЗаказа);
			Запрос.УстановитьПараметр("НаДату", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				КоэффициентПересчетаВВалютуЗаказа = Выборка.КоэффициентПересчета;
			КонецЕсли;
		КонецЕсли;
		
		// Сумму, которая должна быть распределена по табличной части,
		// 		получим из разности общей суммы взаиморасчетов
		// 		и итога по заполненным значениям колонки "СуммаВзаиморасчетов".
		СуммаКРаспределению = СуммаВзаиморасчетов - СуммаВзаиморасчетовПоТЧ;
		МассивСумм = Новый Массив;
		Для Индекс = 0 По ТабличнаяЧасть.Количество() - 1 Цикл
			Если Не ЗначениеЗаполнено(ТабличнаяЧасть[Индекс].СуммаВзаиморасчетов) Тогда
				МассивСумм.Добавить(Окр(ТабличнаяЧасть[Индекс].Сумма * КоэффициентПересчетаВВалютуЗаказа, 2));
			КонецЕсли;
		КонецЦикла;
		
		МассивСумм = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаКРаспределению, МассивСумм);
		
		ИндексМассиваСумм = 0;
		Для Индекс = 0 По ТабличнаяЧасть.Количество() - 1 Цикл
			Если Не ЗначениеЗаполнено(ТабличнаяЧасть[Индекс].СуммаВзаиморасчетов) Тогда
				ТабличнаяЧасть[Индекс].СуммаВзаиморасчетов = МассивСумм[ИндексМассиваСумм];
				ИндексМассиваСумм = ИндексМассиваСумм + 1;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ПоступлениеДенежныхДокументов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваУПодотчетныхЛиц(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДвижениеДенежныхДокументов(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);

	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныхСредств(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваКонтрагент(ДополнительныеСвойства, Движения, Отказ);
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	АвансовыйОтчет = Неопределено;
	НомерВходящегоДокумента = "";
	ДатаВходящегоДокумента = Неопределено;
	НаименованиеВходящегоДокумента = "";
	
	ЗаполнитьРеквизитыЗначениямиПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Инициализация

Процедура ИнициализироватьДокумент(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	Если ДанныеЗаполнения.Свойство("ДенежныеДокументы") Тогда
		
		ДенежныеСредстваСервер.ЗаполнитьПоОстаткамДД(ДанныеЗаполнения, ДенежныеДокументы);
		
		ЭтоВозврат = (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхДокументовПоставщику);
		Если Валюта.Пустая() И ЭтоВозврат И ДенежныеДокументы.Количество() > 0 Тогда
			Валюта = ДенежныеДокументы[0].Валюта;
		КонецЕсли;
		
	КонецЕсли;
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);
	
	ПорядокОплаты   = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов,,ВалютаВзаиморасчетов);

КонецПроцедуры

Процедура ЗаполнитьРеквизитыЗначениямиПоУмолчанию()
	
	Ответственный = Пользователи.ТекущийПользователь();
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	Валюта                    = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	ВалютаВзаиморасчетов      = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаВзаиморасчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаполнитьСуммуВзаиморасчетовВПоступлении(СтруктураКурса)
	
	Если ДенежныеДокументы.НайтиСтроки(Новый Структура("СуммаВзаиморасчетов", 0)).Количество() = 0 Тогда
		
		СуммаВзаиморасчетов = ДенежныеДокументы.Итог("СуммаВзаиморасчетов");
		
	Иначе
		
		Если ЗначениеЗаполнено(СтруктураКурса) И ТипЗнч(СтруктураКурса) = Тип("Структура") Тогда
			
			ВалютаРегУчета = Константы.ВалютаРегламентированногоУчета.Получить();
			
			Если НЕ ЭтотОбъект.Валюта = ВалютаРегУчета И ЭтотОбъект.ВалютаВзаиморасчетов = ВалютаРегУчета Тогда
				КурсВалютыДокумента = СтруктураКурса.Курс;
				КратностьВалютыДокумента = СтруктураКурса.Кратность;
				КурсВалютыВзаиморасчетов = 1;
				КратностьВалютыВзаиморасчетов = 1;
			Иначе
				КурсВалютыДокумента = 1;
				КратностьВалютыДокумента = 1;
				КурсВалютыВзаиморасчетов = СтруктураКурса.Курс;
				КратностьВалютыВзаиморасчетов = СтруктураКурса.Кратность;
			КонецЕсли;
			
			ЭтотОбъект.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СуммаДокумента,
					ЭтотОбъект.Валюта, 
					ЭтотОбъект.ВалютаВзаиморасчетов,
					КурсВалютыДокумента,
					КурсВалютыВзаиморасчетов,
					КратностьВалютыДокумента,
					КратностьВалютыВзаиморасчетов);
		Иначе
					
			Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	(&СуммаДокумента *
			|	ЕСТЬNULL(КурсыВалютДокумента.Курс, 1) * 
			|	ЕСТЬNULL(КурсыВалют.Кратность, 1)
			|	) / (
			|	ЕСТЬNULL(КурсыВалют.Курс, 1) * 
			|	ЕСТЬNULL(КурсыВалютДокумента.Кратность, 1)
			|	) КАК СуммаВзаиморасчетов
			|	
			|ИЗ	
			|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата,
			|		Валюта = &ВалютаДокумента
			|	) КАК КурсыВалютДокумента
			|	
			|	// Определим курс валюты взаиморасчетов.
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		РегистрСведений.КурсыВалют.СрезПоследних(&Дата, 
			|			Валюта = &ВалютаВзаиморасчетов
			|	) КАК КурсыВалют ПО ИСТИНА
			|");
			
			Запрос.УстановитьПараметр("Дата", Дата);
			Запрос.УстановитьПараметр("ВалютаДокумента", Валюта);
			Запрос.УстановитьПараметр("ВалютаВзаиморасчетов", ВалютаВзаиморасчетов);
			Запрос.УстановитьПараметр("СуммаДокумента", СуммаДокумента);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Если СуммаВзаиморасчетов <> Выборка.СуммаВзаиморасчетов Тогда
					СуммаВзаиморасчетов = Выборка.СуммаВзаиморасчетов;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДенежныеДокументы()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Т.НомерСтроки КАК НомерСтроки,
	|	Т.НаименованиеДенежногоДокумента КАК Наименование,
	|	ВЫБОР КОГДА Т.Валюта = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) ТОГДА
	|		&Валюта
	|	ИНАЧЕ
	|		Т.Валюта
	|	КОНЕЦ КАК Валюта,
	|	Т.Цена КАК Цена
	|ПОМЕСТИТЬ ВтДД
	|ИЗ
	|	&ДенДокументы КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	(ТаблицаДокумента.НомерСтроки - 1) КАК ИндексСтроки,
	|	МАКСИМУМ(ЕСТЬNULL(ДД.Ссылка, ЗНАЧЕНИЕ(Справочник.ДенежныеДокументы.ПустаяСсылка))) КАК ДД
	|ИЗ
	|	ВтДД КАК ТаблицаДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.ДенежныеДокументы КАК ДД
	|	ПО
	|		ТаблицаДокумента.Наименование = ДД.Наименование
	|		И ТаблицаДокумента.Валюта = ДД.Валюта
	|		И ТаблицаДокумента.Цена = ДД.Цена
	|		И (НЕ ДД.ПометкаУдаления)
	|
	|СГРУППИРОВАТЬ ПО
	|	(ТаблицаДокумента.НомерСтроки - 1)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИндексСтроки";
	
	КолонкиТЧ = "НомерСтроки, НаименованиеДенежногоДокумента, Валюта, Цена";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДенДокументы", ДенежныеДокументы.Выгрузить(, КолонкиТЧ));
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТЧ = ДенежныеДокументы[Выборка.ИндексСтроки];
		// Если подобран подходящий денежный документ, то будет выбран именно он,
		// иначе будет создан новый элемент справочника.
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Валюта) Тогда
			СтрокаТЧ.Валюта = Валюта;
		КонецЕсли;
		СтрокаТЧ.ДенежныйДокумент = ?(Выборка.ДД.Пустая(), СоздатьДенежныйДокумент(СтрокаТЧ), Выборка.ДД);
	КонецЦикла;
	
КонецПроцедуры

Функция СоздатьДенежныйДокумент(ДанныеДокумента)
	
	Если ЗначениеЗаполнено(ДанныеДокумента.НаименованиеДенежногоДокумента)
		И ЗначениеЗаполнено(ДанныеДокумента.Валюта)
		И ЗначениеЗаполнено(ДанныеДокумента.Цена) Тогда
		
		НовыйДД = Справочники.ДенежныеДокументы.СоздатьЭлемент();
		НовыйДД.Наименование	= ДанныеДокумента.НаименованиеДенежногоДокумента;
		НовыйДД.Валюта			= ДанныеДокумента.Валюта;
		НовыйДД.Цена			= ДанныеДокумента.Цена;
		НовыйДД.Родитель		= ДанныеДокумента.ГруппаДокумента;
		НовыйДД.Записать();
		
		Возврат НовыйДД.Ссылка;
		
	Иначе
		
		Возврат Справочники.ДенежныеДокументы.ПустаяСсылка();
		
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьВалютуВТаблицеВалютойИзШапки()
	
	Если ДенежныеДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Массив = Новый Массив(ДенежныеДокументы.Количество());
	Для инд = 0 По ДенежныеДокументы.Количество() - 1 Цикл
		Массив[инд] = Валюта;
	КонецЦикла;
	
	ДенежныеДокументы.ЗагрузитьКолонку(Массив, "Валюта");
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	Если Не ЭтоНовый() Тогда
		Массив.Добавить(Движения.ДенежныеДокументы);
	КонецЕсли;
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
