#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	РасчетКурсовыхРазницЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации("ПроведениеРасчетКурсовыхРазниц");
	ДополнительныеСвойства.Вставить("ОписаниеЗамера", ОписаниеЗамера);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	Если РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения И НЕ ПометкаУдаления Тогда
		ПроверитьДублиДокументовТекущегоПериода(Отказ);
	КонецЕсли;

	РасчетКурсовыхРазницЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Если НЕ ДополнительныеСвойства.Свойство("ВыполненРасчет") Тогда
		ОчиститьНаборыЗаписейДвижений(ЭтотОбъект);
	КонецЕсли;
	
	Документы.РасчетКурсовыхРазниц.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЭтотОбъект.Движения.РасчетыСПоставщикамиПоДокументам.Записывать = Ложь;
	ЭтотОбъект.Движения.РасчетыСКлиентамиПоДокументам.Записывать    = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваБезналичные.Записывать      = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваНаличные.Записывать         = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваВКассахККМ.Записывать       = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваВПути.Записывать            = Ложь;
	ЭтотОбъект.Движения.ДенежныеСредстваУПодотчетныхЛиц.Записывать  = Ложь;
	ЭтотОбъект.Движения.РасчетыПоФинансовымИнструментам.Записывать  = Ложь;
	//++ НЕ УТ
	ЭтотОбъект.Движения.ДенежныеДокументы.Записывать                = Ложь;
	ЭтотОбъект.Движения.РезервыПоСомнительнымДолгам.Записывать      = Ложь;
	//-- НЕ УТ
	
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	РасчетКурсовыхРазницЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

	ОписаниеЗамера = Неопределено;
	Если ДополнительныеСвойства.Свойство("ОписаниеЗамера", ОписаниеЗамера) Тогда
		ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, 1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
 
	ЭтоРасчеты = ЭтотОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовСПоставщиками
		ИЛИ ЭтотОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовСКлиентами;
	Если ЭтоРасчеты И ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") И ЕстьДвиженияПоСрокам() Тогда
		
		ТекстОшибки = НСтр("ru = 'Для отмены проведения ""%1"" необходимо
		|снять с проведения все документы движений по взаиморасчетам в валютах отличных от валют регл. или упр.
		|за месяц %2 по организации ""%3""';
		|en = 'To cancel the %1 posting, 
		|remove from the posting all documents of records by mutual settlements in currencies different from compl. or man. accounting currencies
		| for month %2 for the %3 company.'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Ссылка, Формат(Дата, "ДФ=ММ.yyyy"), Организация);
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	РасчетКурсовыхРазницЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ПроверитьДублиДокументовТекущегоПериода(Отказ)
	
	Если ДополнительныеСвойства.Свойство("ОтключитьПроверкуДублей") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка
	|ИЗ
	|	Документ.РасчетКурсовыхРазниц КАК Т
	|ГДЕ
	|	Т.Проведен
	|	И Т.Организация = &Организация
	|	И Т.Дата МЕЖДУ &ПериодНачало И &ПериодОкончание
	|	И НЕ Т.Ссылка = &ТекущийДокумент
	|	И Т.ХозяйственнаяОперация = &Операция");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	Запрос.УстановитьПараметр("ПериодНачало", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ПериодОкончание", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Операция", ХозяйственнаяОперация);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		ТекстОшибки = НСтр("ru = 'Для организации ""%1"" в текущем месяце %2 уже существует аналогичный документ ""%3"".
							|Пометьте на удаление все непроведенные документы расчета курсовых разниц.';
							|en = 'Similar document %3 already exists for company %1 in the current month %2. 
							|Mark for deletion all unposted documents of exchange rate difference calculation.'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Организация, Формат(Дата, "ДФ=ММ.yyyy"), ХозяйственнаяОперация);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьНаборыЗаписейДвижений(ЭтотОбъект)

	НаборыДвижений = Новый Массив;
	НаборыДвижений.Добавить("РасчетыСПоставщикамиПоДокументам");
	НаборыДвижений.Добавить("РасчетыСКлиентамиПоДокументам");
	НаборыДвижений.Добавить("ДенежныеСредстваБезналичные");
	НаборыДвижений.Добавить("ДенежныеСредстваНаличные");
	НаборыДвижений.Добавить("ДенежныеСредстваВКассахККМ");
	НаборыДвижений.Добавить("ДенежныеСредстваВПути");
	НаборыДвижений.Добавить("ДенежныеСредстваУПодотчетныхЛиц");
	НаборыДвижений.Добавить("РасчетыПоФинансовымИнструментам");
	//++ НЕ УТ
	НаборыДвижений.Добавить("ДенежныеДокументы");
	НаборыДвижений.Добавить("РезервыПоСомнительнымДолгам");
	//-- НЕ УТ
	
	Для Каждого ИмяНабора Из НаборыДвижений Цикл
		Набор = ЭтотОбъект.Движения[ИмяНабора];
		Набор.Очистить();
		Набор.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция ЕстьДвиженияПоСрокам()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасчетыПоСрокам.ДокументРегистратор КАК ДокументРегистратор
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам КАК РасчетыПоСрокам
	|ГДЕ
	|	РасчетыПоСрокам.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И РасчетыПоСрокам.ДокументРегистратор = &ДокументРегистратор";
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовСКлиентами Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "РасчетыСПоставщиками", "РасчетыСКлиентами");
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("ДокументРегистратор", Ссылка);
	
	НаборДвижений = Запрос.Выполнить();
	
	Возврат НЕ НаборДвижений.Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли
