
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьУчет2_4 = ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4();
	ИспользоватьРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
							
	УстановитьТекстЗапросаСписок();
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоОрганизации", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ОтборОрганизация", Неопределено);
	
	Если ИспользоватьУчет2_4 Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Состояние", Перечисления.СостоянияОС.ПустаяСсылка());
	КонецЕсли; 
	
	Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведенияНеВыбраноОС;
	
	Если ИспользоватьУчет2_4 Тогда
		
		ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
		ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
		
		ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
		
		Если НЕ ВедетсяРегламентированныйУчетВНА Тогда
			Элементы.СписокСостояниеУпр.Заголовок = НСтр("ru = 'Состояние';
														|en = 'State'");
			Элементы.СписокСостояниеРегл.Видимость = Ложь;
			Элементы.СведенияГруппаОС.Видимость = Ложь;
			Элементы.СведенияКодПоОКОФ.Видимость = Ложь;
			Элементы.СведенияАмортизационнаяГруппа.Видимость = Ложь;
			Элементы.СведенияТаблицаСумм2_4Учет.Видимость = Ложь;
			Элементы.СписокДатаПринятияКУчетуУпр.Заголовок = НСтр("ru = 'Принято к учету';
																	|en = 'Entered in the books'");
			Элементы.СписокДатаПринятияКУчетуРегл.Видимость = Ложь;
		Иначе
			Элементы.СведенияОстаточнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияНакопленнаяАмортизация.Видимость = Ложь;
			Элементы.СведенияВосстановительнаяСтоимость.Видимость = Ложь;
		КонецЕсли;
		
		Если НЕ ВедетсяРегламентированныйУчетВНА
			И ВалютаУпр = ВалютаРегл Тогда
			Элементы.СведенияТаблицаСумм2_4.Видимость = Ложь;
		КонецЕсли;
		
		Заголовок = НСтр("ru = 'Основные средства';
						|en = 'Fixed assets'");
	
		Если Константы.ВалютаРегламентированногоУчета.Получить() = Константы.ВалютаУправленческогоУчета.Получить() Тогда
			Элементы.СведенияТаблицаСумм2_4Валюта.Видимость = Ложь;
		КонецЕсли;
	
	Иначе
		Элементы.СписокСостояниеРегл.Заголовок = НСтр("ru = 'Состояние';
														|en = 'State'");
		Элементы.СписокСостояниеУпр.Видимость = Ложь;
		Элементы.СписокДатаПринятияКУчетуРегл.Заголовок = НСтр("ru = 'Принято к учету';
																|en = 'Entered in the books'");
		Элементы.СписокДатаПринятияКУчетуУпр.Видимость = Ложь;
		Заголовок = НСтр("ru = 'ОС и объекты строительства';
						|en = 'FA and construction objects'");
	КонецЕсли;
	
	ВнеоборотныеАктивыКлиентСервер.УстановитьВидимостьЗначенияСпискаВыбора(
		Элементы.ОтборСостояние.СписокВыбора,
		ИспользоватьРеглУчет,
		Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету);
	
	ПоказатьСведения = Ложь;
	ЗаполнитьСвойстваЭлементовСведений();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СохраненноеЗначение = Настройки.Получить("ПоказатьСведения");
	ПоказатьСведения = ?(ЗначениеЗаполнено(СохраненноеЗначение), СохраненноеЗначение, Истина);
	ЗаполнитьСвойстваЭлементовСведений();
	
	ОтборСостояние = Настройки.Получить("ОтборСостояние");
	УстановитьОтборПоСостоянию(ЭтаФорма);
	
	ОтборОрганизация = Настройки.Получить("ОтборОрганизация");
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоОрганизации", ЗначениеЗаполнено(ОтборОрганизация));
	Список.Параметры.УстановитьЗначениеПараметра("ОтборОрганизация", ОтборОрганизация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
	ОтборПодразделение = Настройки.Получить("ОтборПодразделение");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборПодразделение));
	
	ОтборМОЛ = Настройки.Получить("ОтборМОЛ");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"МОЛ",
		ОтборМОЛ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборМОЛ));
	
	ОтборАмортизационнаяГруппа = Настройки.Получить("ОтборАмортизационнаяГруппа");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"АмортизационнаяГруппа",
		ОтборАмортизационнаяГруппа,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборАмортизационнаяГруппа));
		
	ЗаполнитьСведения(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПринятиеКУчетуОС2_4"
		ИЛИ ИмяСобытия = "Запись_ПеремещениеОС2_4"
		ИЛИ ИмяСобытия = "Запись_СписаниеОС2_4"
		ИЛИ ИмяСобытия = "Запись_АмортизацияОС2_4"
		ИЛИ ИмяСобытия = "Запись_РасчетСтоимостиОС" Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	УстановитьОтборПоСостоянию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоОрганизации", ЗначениеЗаполнено(ОтборОрганизация));
	Список.Параметры.УстановитьЗначениеПараметра("ОтборОрганизация", ОтборОрганизация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
	ЗаполнитьСведения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборПодразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМОЛПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"МОЛ",
		ОтборМОЛ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборМОЛ));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАмортизационнаяГруппаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"АмортизационнаяГруппа",
		ОтборАмортизационнаяГруппа,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборАмортизационнаяГруппа));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// Из-за серверного вызова активизация строки выполняется два раза.
	Если ПредыдущаяТекущаяСтрока <> Элементы.Список.ТекущаяСтрока Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	КонецЕсли;
	
	ПредыдущаяТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияПринятКУчетуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "#Создать") <> 0 Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Основание", Элементы.Список.ТекущаяСтрока);
		ОткрытьФорму("Документ.ПринятиеКУчетуОС2_4.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияМестонахождениеАдресОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УправлениеКонтактнойИнформациейКлиент.ПоказатьАдресНаКарте(НавигационнаяСсылкаФорматированнойСтроки, "Яндекс.Карты");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сведения(Команда)
	
	ПоказатьСведения = Не ПоказатьСведения;
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Скрыть сведения';
												|en = 'Hide information'");
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Показать сведения';
												|en = 'Show details'");
	КонецЕсли;
	
КонецПроцедуры

#Область СтандартныеПодсистемы

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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТекстЗапросаСписок()

	ТекстЗапроса = ОбъектыЭксплуатацииЛокализация.ТекстЗапросаФормыСписка();
	
	Если ТекстЗапроса = Неопределено Тогда
			
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	СправочникОбъектыЭксплуатации.Ссылка,
		|	СправочникОбъектыЭксплуатации.ПометкаУдаления,
		|	СправочникОбъектыЭксплуатации.Родитель,
		|	СправочникОбъектыЭксплуатации.ЭтоГруппа,
		|	СправочникОбъектыЭксплуатации.Код,
		|	СправочникОбъектыЭксплуатации.Наименование,
		|	СправочникОбъектыЭксплуатации.НаименованиеПолное,
		|	СправочникОбъектыЭксплуатации.Изготовитель,
		|	СправочникОбъектыЭксплуатации.ЗаводскойНомер,
		|	СправочникОбъектыЭксплуатации.НомерПаспорта,
		|	СправочникОбъектыЭксплуатации.ДатаВыпуска,
		|	NULL КАК КодПоОКОФ,
		|	NULL КАК ГруппаОС,
		|	NULL КАК АмортизационнаяГруппа,
		|	NULL КАК ШифрПоЕНАОФ,
		|	СправочникОбъектыЭксплуатации.Комментарий,
		|	СправочникОбъектыЭксплуатации.Расположение,
		|	СправочникОбъектыЭксплуатации.Модель,
		|	СправочникОбъектыЭксплуатации.СерийныйНомер,
		|	МестонахождениеОС.АдресМестонахождения,
		|	ЕСТЬNULL(МестонахождениеОС.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету) КАК СостояниеРегл,
		|	ВЫБОР 
		|		КОГДА СправочникОбъектыЭксплуатации.ЭтоГруппа
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(ПорядокУчетаОСУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) 
		|	КОНЕЦ КАК СостояниеУпр,
		|	СправочникОбъектыЭксплуатации.ИнвентарныйНомер,
		|	ЕСТЬNULL(ПервоначальныеСведенияОС.ДатаВводаВЭксплуатациюБУ, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПринятияКУчетуРегл,
		|	ЕСТЬNULL(ПервоначальныеСведенияОС.ДатаВводаВЭксплуатациюУУ, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПринятияКУчетуУпр,
		|	ЕСТЬNULL(МестонахождениеОС.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК МОЛ,
		|	ЕСТЬNULL(МестонахождениеОС.Местонахождение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) КАК Подразделение,
		|	ВЫБОР
		|		КОГДА НаличиеФайлов.ЕстьФайлы ЕСТЬ NULL ТОГДА 0
		|		КОГДА НаличиеФайлов.ЕстьФайлы ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ЕстьФайлы
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК СправочникОбъектыЭксплуатации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеФайлов КАК НаличиеФайлов
		|		ПО СправочникОбъектыЭксплуатации.Ссылка = НаличиеФайлов.ОбъектСФайлами
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОС
		|		ПО (МестонахождениеОС.ОсновноеСредство = СправочникОбъектыЭксплуатации.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОС.СрезПоследних КАК ПервоначальныеСведенияОС
		|		ПО СправочникОбъектыЭксплуатации.Ссылка = ПервоначальныеСведенияОС.ОсновноеСредство
		|			И ПервоначальныеСведенияОС.Организация = МестонахождениеОС.Организация
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСУУ.СрезПоследних(
		|				,
		|				НЕ &ОтборПоОрганизации
		|					ИЛИ Организация = &ОтборОрганизация) КАК ПорядокУчетаОСУУ
		|		ПО (ПервоначальныеСведенияОС.ОсновноеСредство = ПорядокУчетаОСУУ.ОсновноеСредство)
		|			И (ПервоначальныеСведенияОС.Организация = ПорядокУчетаОСУУ.Организация)
		|ГДЕ
		|	(&Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|		ИЛИ ЕСТЬNULL(ПорядокУчетаОСУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) = &Состояние)";
		
			
	КонецЕсли; 
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваЭлементовСведений()
	
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Скрыть сведения';
												|en = 'Hide information'");
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Показать сведения';
												|en = 'Show details'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаБУ1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'БУ';
																|en = 'BKG'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаНУ1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'НУ';
																|en = 'TA'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаПР1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ПР';
																|en = 'PD'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаВР1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ВР';
																|en = 'TD'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаполнитьСведения()

	ЗаполнитьСведения(ЭтаФорма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСведения(Форма)
	
	Если НЕ Форма.ПоказатьСведения Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	ТекущиеДанные = Неопределено;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.Список.ДанныеСтроки(ТекущаяСтрока);
		Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ЭтоГруппа Тогда
			ТекущиеДанные = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведенияНеВыбраноОС;
		Возврат;
	КонецЕсли;
	
	Если Форма.ИспользоватьУчет2_4 Тогда
		
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведения2_4;
		
		Форма.СведенияТаблицаСумм2_4.Очистить();
		ПредставлениеСведений = Неопределено;
		
		ТекущаяСтрока = Форма.Элементы.Список.ТекущаяСтрока;
		Сведения2_4 = ПолучитьСведения2_4(ТекущиеДанные.Ссылка);
	
		Для Каждого ЭлМассива Из Сведения2_4.Суммы Цикл
			ЗаполнитьЗначенияСвойств(Форма.СведенияТаблицаСумм2_4.Добавить(), ЭлМассива);
		КонецЦикла;
		
		ПредставлениеСведений = Сведения2_4.ПредставлениеСведений;
		Если ПредставлениеСведений <> Неопределено Тогда
			
			Элементы.ОбщаяКомандаДокументыПоОсновномуСредству.Видимость = ПредставлениеСведений.Период <> '000101010000';
			
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияПринятКУчету1, ПредставлениеСведений.СведенияПринятКУчету1);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеОрганизация, ПредставлениеСведений.СведенияМестонахождениеОрганизация);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеПодразделение, ПредставлениеСведений.СведенияМестонахождениеПодразделение);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеМОЛ, ПредставлениеСведений.СведенияМестонахождениеМОЛ);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеАдрес, ПредставлениеСведений.СведенияМестонахождениеАдрес);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияСрокИспользования1, ПредставлениеСведений.СведенияСрокИспользования1);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияВосстановительнаяСтоимость, ПредставлениеСведений.СведенияВосстановительнаяСтоимость);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияНакопленнаяАмортизация, ПредставлениеСведений.СведенияНакопленнаяАмортизация);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияОстаточнаяСтоимость, ПредставлениеСведений.СведенияОстаточнаяСтоимость);
			
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияЛиквидационнаяСтоимость, ПредставлениеСведений.СведенияЛиквидационнаяСтоимость);
		Иначе
			
			Элементы.ОбщаяКомандаДокументыПоОсновномуСредству.Видимость = Ложь;
			Элементы.СведенияПринятКУчету1.Видимость = Ложь;
			Элементы.СведенияМестонахождениеОрганизация.Видимость = Ложь;
			Элементы.СведенияМестонахождениеПодразделение.Видимость = Ложь;
			Элементы.СведенияМестонахождениеМОЛ.Видимость = Ложь;
			Элементы.СведенияМестонахождениеАдрес.Видимость = Ложь;
			Элементы.СведенияСрокИспользования1.Видимость = Ложь;
			Элементы.СведенияВосстановительнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияНакопленнаяАмортизация.Видимость = Ложь;
			Элементы.СведенияОстаточнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияЛиквидационнаяСтоимость.Видимость = Ложь;
			
		КонецЕсли; 
		
	Иначе
		
		Сведения2_2 = ПолучитьСведения2_2(Элементы.Список.ТекущаяСтрока, Форма.ОтборОрганизация);
		
	КонецЕсли;
	
	ВнеоборотныеАктивыКлиентСерверЛокализация.ЗаполнитьСведенияВФормеСпискаОС(Форма, Сведения2_4, Сведения2_2);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСведения2_2(Знач ВнеоборотныйАктив, Знач ОтборОрганизация)
	
	Сведения2_2 = ОбъектыЭксплуатацииЛокализация.ПолучитьСведения2_2(ВнеоборотныйАктив, ОтборОрганизация);
	
	Возврат Сведения2_2;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСведения2_4(Знач ВнеоборотныйАктив)

	СведенияОбУчете = Справочники.ОбъектыЭксплуатации.СведенияОбУчете(ВнеоборотныйАктив);
	СтоимостьИАмортизация = ВнеоборотныеАктивы.СтоимостьИАмортизацияОС(ВнеоборотныйАктив);

	МассивСумм = Новый Массив;
	
	ВалютаУпр  = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Сведения2_4 = Новый Структура;
	
	ОбъектыЭксплуатацииЛокализация.ДополнитьСведения2_4(
		ВнеоборотныйАктив, СведенияОбУчете, СтоимостьИАмортизация, МассивСумм, Сведения2_4);
		
	Если НЕ ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА()
		И ВалютаУпр <> ВалютаРегл Тогда
	
		// БУ
		ДанныеУчета = Новый Структура;
		ДанныеУчета.Вставить("Учет", "БУ");
		ДанныеУчета.Вставить("Валюта", ВалютаРегл);
		ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.СтоимостьРегл);
		ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.АмортизацияРегл);
		ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.СтоимостьРегл - СтоимостьИАмортизация.АмортизацияРегл);
		МассивСумм.Добавить(ДанныеУчета);
		
	КонецЕсли; 
	
	// УУ
	ДанныеУчета = Новый Структура;
	ДанныеУчета.Вставить("Учет", "УУ");
	ДанныеУчета.Вставить("Валюта", ВалютаУпр);
	ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.Стоимость);
	ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.Амортизация);
	ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.Стоимость - СтоимостьИАмортизация.Амортизация);
	МассивСумм.Добавить(ДанныеУчета);
	
	ПредставлениеСведений = Справочники.ОбъектыЭксплуатации.ПредставлениеСведенийОбУчете(СведенияОбУчете, СтоимостьИАмортизация, Ложь);
	
	Сведения2_4.Вставить("ПредставлениеСведений", ПредставлениеСведений);
	Сведения2_4.Вставить("Суммы", МассивСумм);
	
	Возврат Сведения2_4;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСостоянию(Форма)

	Если Форма.ИспользоватьУчет2_4 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Форма.Список,
			"Состояние",
			Форма.ОтборСостояние);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.Список,
			"СостояниеРегл",
			Форма.ОтборСостояние,
			ВидСравненияКомпоновкиДанных.Равно,,
			ЗначениеЗаполнено(Форма.ОтборСостояние));
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
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.ОбъектыЭксплуатации.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти