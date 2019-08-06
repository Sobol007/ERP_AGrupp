
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("ДатаОкончанияПериода") Тогда
		ДатаОкончанияПериода = Параметры.ДатаОкончанияПериода;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
		ОрганизацияПриИзмененииСервер();
	Иначе
		ПолучитьСостояниеРегламентногоЗадания();
		ОбновитьПредставлениеУчетнойПолитики();
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ИнтеграцияССППР.ДобавитьРазмещениеКомандСППРВДополнительныеПараметры(Элементы.ГруппаСППР, ДополнительныеПараметры);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);
	
	УправлениеЭлементамиФормыПриИзмененииАвтоматическогоОтраженияВУчете();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПредставлениеРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ВнешниеСобытия = Новый Массив;
	ВнешниеСобытия.Добавить("Запись_ОтражениеДокументовВМеждународномУчете");
	ВнешниеСобытия.Добавить("ЗакрытаФормаНастроек");
	ВнешниеСобытия.Добавить("ЗакрытаФормаНастройкиНеобходимыхПравилОтраженияВУчете");
	ВнешниеСобытия.Добавить("ИзмененаДатаЗапретаФормированияПроводок");
	
	Если ВнешниеСобытия.Найти(ИмяСобытия) <> Неопределено Тогда
		ОбработкаОповещенияСервер(ИмяСобытия);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.Свойство("ДатаОкончанияПериода") Тогда
		ДатаОкончанияПериода = Параметры.ДатаОкончанияПериода;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	Иначе
		ОрганизацияПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПериодаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ДатаОкончанияПериода) Тогда
		ДатаОкончанияПериода = КонецДня(ДатаОкончанияПериода);
	КонецЕсли;
	ОбновитьДанныеОСостоянииДокументовИНастройкахУчетнойПолитики();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусКОтражениюВУчетеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = ИнициализироватьПараметрыФормыСпискаДокументов();
	ОткрытьФорму("Обработка.ОтражениеДокументовВМеждународномУчете.Форма.ДокументыОжидающиеОтраженияВУчете", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтсутствуютПравилаОтраженияВУчетеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = ИнициализироватьПараметрыФормыСпискаДокументов();
	ОткрытьФорму("Обработка.ОтражениеДокументовВМеждународномУчете.Форма.ДокументыНеОтраженныеВУчетеОтсутствуютПравилаОтражения", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СтатусОжидаетсяОтражениеВРеглУчетеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = ИнициализироватьПараметрыФормыСпискаДокументов();
	ОткрытьФорму("Обработка.ОтражениеДокументовВМеждународномУчете.Форма.ДокументыНеОтраженныеВУчетеОжидаютОтраженияВРеглУчете", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяНастроитьПравилаОтраженияВУчетеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("АдресРезультатаПроверки", АдресРезультатаПроверки);
	ОткрытьФорму("Обработка.ОтражениеДокументовВМеждународномУчете.Форма.НеобходимыеПравилаОтраженияВУчете", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтраженоВУчетеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = ИнициализироватьПараметрыФормыСпискаДокументов();
	ОткрытьФорму("Обработка.ОтражениеДокументовВМеждународномУчете.Форма.ДокументыОтраженныеВУчете", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусКОтражениюВЗакрытомПериодеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = ИнициализироватьПараметрыФормыСпискаДокументов();
	ПараметрыФормы.Вставить("ДатаЗапрета", ДатаЗапрета);
	ОткрытьФорму("Обработка.ОтражениеДокументовВМеждународномУчете.Форма.ДокументыОжидающиеОтраженияВУчете", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусКОтражениюВУчетеВручнуюНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = ИнициализироватьПараметрыФормыСпискаДокументов();
	ОткрытьФорму("Обработка.ОтражениеДокументовВМеждународномУчете.Форма.ДокументыОжидающиеОтраженияВУчетеВручную", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтраженоВУчетеВручнуюНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = ИнициализироватьПараметрыФормыСпискаДокументов();
	ОткрытьФорму("Обработка.ОтражениеДокументовВМеждународномУчете.Форма.ДокументыОтраженныеВУчетеВручную", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтоматическоеОтражениеВУчетеПриИзменении(Элемент)
	
	СохранитьРеквизитыРегламентногоЗадания();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРасписанияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РедактированиеРасписанияРегламентногоЗадания();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУчетныеПолитикиОрганизации

&НаКлиенте
Процедура УчетныеПолитикиОрганизацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.УчетныеПолитикиОрганизации.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;       
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.УчетнаяПолитика);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСостояние(Команда)
	
	ОбновитьДанныеОСостоянииДокументовИНастройкахУчетнойПолитики();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьДокументыВМеждународномУчете(Команда)
	
	ОтразитьДокументыВМеждународномУчетеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
 
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
 
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатуЗапрета(Команда)
	
	ОткрытьФорму("РегистрСведений.ДатыЗапретаФормированияПроводокМеждународныйУчет.Форма.ДатыЗапретаФормирования", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУчетнойПолитикиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДействующаяУчетнаяПолитика = ДействующаяУчетнаяПолитика();
	ПоказатьЗначение(, ДействующаяУчетнаяПолитика.УчетнаяПолитика);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьШаблоныПроводок(Команда)
	
	ДействующаяУчетнаяПолитика = ДействующаяУчетнаяПолитика();
	ПараметрыФормы = Новый Структура("УчетнаяПолитика", ДействующаяУчетнаяПолитика.УчетнаяПолитика);
	ОткрытьФорму("Обработка.НастройкаШаблоновПроводокДляМеждународногоУчета.Форма.НастройкаШаблоновПроводок", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСоответствиеСчетовИОборотов(Команда)
	
	ДействующаяУчетнаяПолитика = ДействующаяУчетнаяПолитика();
	ПараметрыФормы = Новый Структура("УчетнаяПолитика", ДействующаяУчетнаяПолитика.УчетнаяПолитика);
	ОткрытьФорму("Обработка.НастройкаСоответствияСчетовИОборотовМеждународногоУчета.Форма.Форма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Общие

&НаСервере
Процедура ОтразитьДокументыВМеждународномУчетеСервер()
	
	МеждународныйУчетПроведениеСервер.ОтразитьВМеждународномУчете(Организация, ДатаОкончанияПериода);
	
	ПолучитьСостояниеОтраженияДокументов();
	
	ПолучитьОперацииТребующиеНастройкиШаблонов();

КонецПроцедуры

&НаСервере
Процедура ПолучитьСостояниеОтраженияДокументов()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтражениеДокументов.ДатаОтражения КАК ДатаОтражения,
	|	ОтражениеДокументов.Регистратор КАК Регистратор,
	|	ОтражениеДокументов.Статус КАК Статус
	|ПОМЕСТИТЬ ОтражениеДокументов
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Организация = &Организация
	|	И ОтражениеДокументов.ДатаОтражения <= &ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ОтражениеДокументов.ДатаОтражения) КАК ДатаНачала
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчетеВручную)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ОтражениеДокументов.ДатаОтражения) КАК ДатаНачала,
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) КАК Количество
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчетеВручную)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ОтражениеДокументов.ДатаОтражения) КАК ДатаНачала
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчете)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ОтражениеДокументов.ДатаОтражения) КАК ДатаНачала,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтражениеДокументов.Регистратор) КАК Количество
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчете)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ОтражениеДокументов.ДатаОтражения) КАК ДатаНачала,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтражениеДокументов.Регистратор) КАК Количество
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.ОжидаетсяОтражениеВРеглУчете)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ОтражениеДокументов.ДатаОтражения) КАК ДатаНачала,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтражениеДокументов.Регистратор) КАК Количество
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.ОтсутствуютПравилаОтраженияВУчете)
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ОтражениеДокументов.Регистратор) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ОтражениеДокументов.ДатаОтражения) КАК ДатаНачала,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтражениеДокументов.Регистратор) КАК Количество
	|ИЗ
	|	ОтражениеДокументов КАК ОтражениеДокументов
	|ГДЕ
	|	ОтражениеДокументов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчете)
	|	И ОтражениеДокументов.ДатаОтражения <= &ДатаЗапрета
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтражениеДокументов.Регистратор) > 0
	|";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаОкончания", ?(ЗначениеЗаполнено(ДатаОкончанияПериода), ДатаОкончанияПериода, Дата(2399, 1, 1)));
	Запрос.УстановитьПараметр("ДатаЗапрета", ДатаЗапрета);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[1].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСтатуса = НСтр("ru = 'Документы, отраженные в учете вручную, по %Дата%';
							|en = 'Documents recorded in international accounting manually before %Дата%'");
		СтатусОтраженоВУчетеВручную = СтрЗаменить(ТекстСтатуса, "%Дата%", Формат(Выборка.ДатаНачала, "ДЛФ=Д"));
		Элементы.СтатусОтраженоВУчетеВручную.ЦветТекста = ЦветаСтиля.ЦветГиперссылки;
		Элементы.СтатусОтраженоВУчетеВручную.Гиперссылка = Истина;
	Иначе
		СтатусОтраженоВУчетеВручную = НСтр("ru = 'Нет документов, отраженных в международном учете вручную.';
											|en = 'No documents which are manually recorded in international accounting.'");
		Элементы.СтатусОтраженоВУчетеВручную.ЦветТекста = ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента;
		Элементы.СтатусОтраженоВУчетеВручную.Гиперссылка = Ложь;
	КонецЕсли;
	
	Выборка = МассивРезультатов[2].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСтатуса = НСтр("ru = 'Документы, ожидающие ручного отражения в международном учете (%Количество%), с %Дата%';
							|en = 'Documents awaiting manual recording in international accounting (%Количество%), from %Дата%'");
		ТекстСтатуса = СтрЗаменить(ТекстСтатуса, "%Количество%", Выборка.Количество);
		СтатусКОтражениюВУчетеВручную = СтрЗаменить(ТекстСтатуса, "%Дата%", Формат(Выборка.ДатаНачала, "ДЛФ=Д"));
		Элементы.СтатусКОтражениюВУчетеВручную.ЦветТекста = ЦветаСтиля.ЦветГиперссылки;
		Элементы.СтатусКОтражениюВУчетеВручную.Гиперссылка = Истина;
	Иначе
		СтатусКОтражениюВУчетеВручную = НСтр("ru = 'Нет документов, ожидающих ручного отражения в международном учете.';
											|en = 'No documents which are awaiting manual recording in international accounting.'");
		Элементы.СтатусКОтражениюВУчетеВручную.ЦветТекста = ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента;
		Элементы.СтатусКОтражениюВУчетеВручную.Гиперссылка = Ложь;
	КонецЕсли;
	
	Выборка = МассивРезультатов[3].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСтатуса = НСтр("ru = 'Отраженные в учете документы, по %Дата%';
							|en = 'Documents recorded in accounting, up to %Дата%'");
		СтатусОтраженоВУчете = СтрЗаменить(ТекстСтатуса, "%Дата%", Формат(Выборка.ДатаНачала, "ДЛФ=Д"));
		Элементы.СтатусОтраженоВУчете.ЦветТекста = ЦветаСтиля.ЦветГиперссылки;
		Элементы.СтатусОтраженоВУчете.Гиперссылка = Истина;
	Иначе
		СтатусОтраженоВУчете = НСтр("ru = 'Нет документов, отраженных в международном учете.';
									|en = 'No documents recorded in international accounting.'");
		Элементы.СтатусОтраженоВУчете.ЦветТекста = ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента;
		Элементы.СтатусОтраженоВУчете.Гиперссылка = Ложь;
	КонецЕсли;
	
	Выборка = МассивРезультатов[4].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСтатуса = НСтр("ru = 'Документы, ожидающие автоматического отражения в международном учете (%Количество%), с %Дата%';
							|en = 'Documents awaiting automatic recording in international accounting (%Количество%), from %Дата%'");
		ТекстСтатуса = СтрЗаменить(ТекстСтатуса, "%Количество%", Выборка.Количество);
		СтатусКОтражениюВУчете = СтрЗаменить(ТекстСтатуса, "%Дата%", Формат(Выборка.ДатаНачала, "ДЛФ=Д"));
		Элементы.СтатусКОтражениюВУчете.ЦветТекста = ЦветаСтиля.ЦветГиперссылки;
		Элементы.СтатусКОтражениюВУчете.Гиперссылка = Истина;
	Иначе
		СтатусКОтражениюВУчете = НСтр("ru = 'Нет документов, ожидающих автоматического отражения в международном учете.';
										|en = 'No documents which are awaiting automatic recording in international accounting.'");
		Элементы.СтатусКОтражениюВУчете.ЦветТекста = ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента;
		Элементы.СтатусКОтражениюВУчете.Гиперссылка = Ложь;
	КонецЕсли;
	
	Выборка = МассивРезультатов[5].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСтатуса = НСтр("ru = 'Документы не отраженные в учете из-за ожидания отражения в регл. учете (%Количество%), с %Дата%';
							|en = 'Documents not recorded in accounting due to awaiting recording in compl. accounting (%Количество%), from %Дата% '");
		ТекстСтатуса = СтрЗаменить(ТекстСтатуса, "%Количество%", Выборка.Количество);
		СтатусОжидаетсяОтражениеВРеглУчете = СтрЗаменить(ТекстСтатуса, "%Дата%", Формат(Выборка.ДатаНачала, "ДЛФ=Д"));
		Элементы.СтатусОжидаетсяОтражениеВРеглУчете.ЦветТекста = ЦветаСтиля.ЦветГиперссылки;
		Элементы.СтатусОжидаетсяОтражениеВРеглУчете.Гиперссылка = Истина;
		Элементы.СтатусОжидаетсяОтражениеВРеглУчете.Видимость = Истина;
	Иначе
		Элементы.СтатусОжидаетсяОтражениеВРеглУчете.Видимость = Ложь;
	КонецЕсли;
	
	Выборка = МассивРезультатов[6].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСтатуса = НСтр("ru = 'Документы не отраженные в учете из-за ошибок (%Количество%), с %Дата%';
							|en = 'Documents not recorded in accounting due to errors (%Количество%), from %Дата%'");
		ТекстСтатуса = СтрЗаменить(ТекстСтатуса, "%Количество%", Выборка.Количество);
		СтатусОтсутствуютПравилаОтраженияВУчете = СтрЗаменить(ТекстСтатуса, "%Дата%", Формат(Выборка.ДатаНачала, "ДЛФ=Д"));
		Элементы.СтатусОтсутствуютПравилаОтраженияВУчете.ЦветТекста = ЦветаСтиля.ПросроченныеДанныеЦвет;
		Элементы.СтатусОтсутствуютПравилаОтраженияВУчете.Гиперссылка = Истина;
		Элементы.СтатусОтсутствуютПравилаОтраженияВУчете.Видимость = Истина;
	Иначе
		Элементы.СтатусОтсутствуютПравилаОтраженияВУчете.Видимость = Ложь;
	КонецЕсли;

	Выборка = МассивРезультатов[7].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСтатуса = НСтр("ru = 'в том числе в закрытом периоде (%Количество%)';
							|en = 'including in the closed period (%Количество%)'");
		ТекстСтатуса = СтрЗаменить(ТекстСтатуса, "%Количество%", Выборка.Количество);
		ТекстСтатуса = СтрЗаменить(ТекстСтатуса, "%Дата%", Формат(ДатаЗапрета, "ДЛФ=Д"));
		СтатусКОтражениюВЗакрытомПериоде = ТекстСтатуса;
		Элементы.СтатусКОтражениюВЗакрытомПериоде.ЦветТекста = ЦветаСтиля.ПросроченныеДанныеЦвет;
		Элементы.ГруппаЗакрытыйПериод.Видимость = Истина;
	Иначе
		Элементы.ГруппаЗакрытыйПериод.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура ПолучитьОперацииТребующиеНастройкиШаблонов()
	
	Результат = Обработки.ОтражениеДокументовВМеждународномУчете.ПроверитьНастройкуПравилОтраженияУчете(Организация);
	
	АдресРезультатаПроверки = ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	
	КоличествоОшибок = 
		Результат.ХозяйственныеОперацииБезПравилОтражения.Количество() + Результат.СчетаБезПравилОтражения.Количество();
	
	Если КоличествоОшибок > 0 Тогда
		ТекстСтатуса = НСтр("ru = 'Требуется настроить правила отражения в учете (%Количество%)';
							|en = 'Configure rules of recording in accounting (%Количество%)'");
		ТекстСтатуса = СтрЗаменить(ТекстСтатуса, "%Количество%", КоличествоОшибок);
		ТребуетсяНастроитьПравилаОтраженияВУчете = ТекстСтатуса;
		Элементы.ТребуетсяНастроитьПравилаОтраженияВУчете.Видимость = Истина;
		Элементы.ТребуетсяНастроитьПравилаОтраженияВУчете.ЦветТекста = ЦветаСтиля.ПросроченныеДанныеЦвет;
	Иначе
		Элементы.ТребуетсяНастроитьПравилаОтраженияВУчете.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОСостоянииДокументовИНастройкахУчетнойПолитики()
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьДатуЗапретаОтраженияНаСервере();
	ПолучитьСостояниеОтраженияДокументов();
	
	ОбновитьИнформациюОбУчетнойПолитике();
	
	ПолучитьСостояниеРегламентногоЗадания();
	
КонецПроцедуры

&НаКлиенте
Функция ИнициализироватьПараметрыФормыСпискаДокументов()

	Отбор = Новый Структура("Организация", Организация);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ПараметрыФормы.Вставить("ДатаОкончанияПериода", ?(ЗначениеЗаполнено(ДатаОкончанияПериода), ДатаОкончанияПериода, '39991231'));
	
	Возврат ПараметрыФормы;

КонецФункции

&НаСервере
Процедура ОбработкаОповещенияСервер(ИмяСобытия)

	Если ИмяСобытия = "Запись_ОтражениеДокументовВМеждународномУчете" Тогда
		ПолучитьСостояниеОтраженияДокументов();
		ПолучитьОперацииТребующиеНастройкиШаблонов();
	ИначеЕсли ИмяСобытия = "ЗакрытаФормаНастроек"
		ИЛИ ИмяСобытия = "ЗакрытаФормаНастройкиНеобходимыхПравилОтраженияВУчете" Тогда
		ОбновитьИнформациюОбУчетнойПолитике();
		ПолучитьОперацииТребующиеНастройкиШаблонов();
	ИначеЕсли ИмяСобытия = "ИзмененаДатаЗапретаФормированияПроводок" Тогда
		ОбновитьДанныеЗакрытогоПериода();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область АвтоматическоеОтражениеВУчете

&НаКлиенте
Процедура ОбновитьПредставлениеРасписания()
	
	ПредставлениеРасписания = Строка(РасписаниеРегламентногоЗадания);
	Если ПредставлениеРасписания = Строка(Новый РасписаниеРегламентногоЗадания) Тогда
		ПредставлениеРасписания = НСтр("ru = 'Расписание не задано';
										|en = 'Schedule is not set'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСостояниеРегламентногоЗадания()

	УстановитьПривилегированныйРежим(Истина);
	
	Задание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ОтражениеДокументовВМеждународномУчете);
	Если ОбщегоНазначения.РазделениеВключено() И ЗначениеЗаполнено(Задание.Шаблон) Тогда
		РасписаниеРегламентногоЗадания = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Задание.Шаблон, "Расписание").Получить();
	Иначе
		РасписаниеРегламентногоЗадания	= Задание.Расписание;
	КонецЕсли;
	ИспользоватьАвтоматическоеОтражениеВУчете = Задание.Использование;
	
	СвойстваПоследнегоФоновогоЗадания = ОбщегоНазначенияУТ.ПолучитьСостояниеПоследнегоЗадания(Задание);
	Если СвойстваПоследнегоФоновогоЗадания = Неопределено
		ИЛИ НЕ ЗначениеЗаполнено(СвойстваПоследнегоФоновогоЗадания.ДатаЗавершения) Тогда
		СостояниеАвтоматическогоОтраженияВУчете = НСтр("ru = 'Не выполнялось';
														|en = 'Not executed'");
	Иначе
		СостояниеАвтоматическогоОтраженияВУчете = Строка(СвойстваПоследнегоФоновогоЗадания.Состояние) + ": "
			+ Строка(СвойстваПоследнегоФоновогоЗадания.ДатаЗавершения);
	КонецЕсли;
	
	Элементы.ИспользоватьАвтоматическоеОтражениеВУчете.Видимость = НЕ ОбщегоНазначения.РазделениеВключено();
	Элементы.ПредставлениеРасписания.Гиперссылка = НЕ ОбщегоНазначения.РазделениеВключено();
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗадания()
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(Новый ОписаниеОповещения("ОбработкаВыбораРасписания", ЭтотОбъект, Новый Структура("Диалог", Диалог)));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораРасписания(Расписание, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	Если Расписание <> Неопределено Тогда
		РасписаниеРегламентногоЗадания = Расписание;
		СохранитьРеквизитыРегламентногоЗадания();
	КонецЕсли;
	ОбновитьПредставлениеРасписания();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРеквизитыРегламентногоЗадания()

	УстановитьПривилегированныйРежим(Истина);
	
	Задание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ОтражениеДокументовВМеждународномУчете);
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", ИспользоватьАвтоматическоеОтражениеВУчете);
	ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	УправлениеЭлементамиФормыПриИзмененииАвтоматическогоОтраженияВУчете();
	
КонецПроцедуры

#КонецОбласти

#Область УчетныеПолитики

&НаСервере
Процедура ПолучитьУчетныеПолитикиОрганизации()
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетныеПолитики.УчетнаяПолитика КАК УчетнаяПолитика,
	|	УчетныеПолитики.Период КАК Период,
	|	ВЫБОР
	|		КОГДА УчетныеПолитикиНаДату.УчетнаяПолитика ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Действующая
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета КАК УчетныеПолитики
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета.СрезПоследних(&ДатаОкончания,
	|			Организация = &Организация) КАК УчетныеПолитикиНаДату
	|	ПО
	|		УчетныеПолитики.УчетнаяПолитика = УчетныеПолитикиНаДату.УчетнаяПолитика
	|ГДЕ
	|	УчетныеПолитики.Организация = &Организация
	|	И УчетныеПолитики.Период <= &ДатаОкончания
	|";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаОкончания", ?(ЗначениеЗаполнено(ДатаОкончанияПериода), ДатаОкончанияПериода, Дата(2399, 1, 1)));
	
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "УчетныеПолитикиОрганизации");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОбУчетнойПолитике()

	ПолучитьУчетныеПолитикиОрганизации();
	ОбновитьПредставлениеУчетнойПолитики();

КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеУчетнойПолитики()
	
	Если УчетныеПолитикиОрганизации.Количество() = 0 Тогда
		СостояниеНастройкиУчетнойПолитики = НСтр("ru = 'Для выбранной организации не настроены учетные политики.';
												|en = 'Accounting policies are not configured for the selected company.'");
		Элементы.СостояниеНастройкиУчетнойПолитики.Видимость = Истина;
		Элементы.ГруппаНастройкаУчетнойПолитики.Видимость = Ложь;
		Элементы.ГруппаСписокУчетныхПолитик.Видимость = Ложь;
	Иначе
		Если УчетныеПолитикиОрганизации.Количество() = 1 Тогда
			Элементы.ГруппаСписокУчетныхПолитик.Видимость = Ложь;
		Иначе
			Элементы.ГруппаСписокУчетныхПолитик.Видимость = Истина;
		КонецЕсли;
		Элементы.СостояниеНастройкиУчетнойПолитики.Видимость = Ложь;
		Элементы.ГруппаНастройкаУчетнойПолитики.Видимость = Истина;
		ДействующаяУчетнаяПолитика = ДействующаяУчетнаяПолитика();
		ПредставлениеУчетнойПолитики = НСтр("ru = '%УчетнаяПолитика%, действует с %Период%';
											|en = '%УчетнаяПолитика%, valid from %Период%'");
		ПредставлениеУчетнойПолитики = СтрЗаменить(ПредставлениеУчетнойПолитики,
			"%УчетнаяПолитика%",
			ДействующаяУчетнаяПолитика.УчетнаяПолитика);
		ПредставлениеУчетнойПолитики = СтрЗаменить(ПредставлениеУчетнойПолитики,
			"%Период%",
			Формат(ДействующаяУчетнаяПолитика.Период, "Л=ru; ДЛФ=D"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДействующаяУчетнаяПолитика()
	
	ПараметрыОтбора = Новый Структура("Действующая", Истина);
	СтрокаУчетнойПолитики = УчетныеПолитикиОрганизации.НайтиСтроки(ПараметрыОтбора)[0];
	
	ДействующаяУчетнаяПолитика = Новый Структура("УчетнаяПолитика, Период");
	ЗаполнитьЗначенияСвойств(ДействующаяУчетнаяПолитика, СтрокаУчетнойПолитики);
	
	Возврат ДействующаяУчетнаяПолитика;
	
КонецФункции

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	УправлениеЭлементамиФормыПриИзмененииОрганизации();
	ОбновитьДанныеОСостоянииДокументовИНастройкахУчетнойПолитики();

КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормыПриИзмененииОрганизации()

	Если Не ЗначениеЗаполнено(Организация) Тогда
		СтатусКОтражениюВУчете = НСтр("ru = 'Для просмотра документов выберите организацию';
										|en = 'To view documents, select a company'");
		Элементы.СтатусКОтражениюВУчете.Гиперссылка = Ложь;
		Элементы.СтатусКОтражениюВУчете.ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
		ТребуетсяНастроитьПравилаОтраженияВУчете = "";
		
		СтатусОтраженоВУчете = НСтр("ru = 'Для просмотра документов выберите организацию';
									|en = 'To view documents, select a company'");
		Элементы.СтатусОтраженоВУчете.Гиперссылка = Ложь;
		Элементы.СтатусОтраженоВУчете.ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
		
		СостояниеНастройкиУчетнойПолитики = НСтр("ru = 'Для настройки учетной политики выберите организацию';
												|en = 'To configure the accounting policy, select a company'");
		СостояниеНастройкиШаблоновПроводок = "";
		СостояниеУточненияСчетов = "";
		Элементы.СостояниеНастройкиУчетнойПолитики.Видимость = Истина;
		Элементы.ГруппаНастройкаУчетнойПолитики.Видимость = Ложь;
		
		Элементы.ГруппаЗакрытыйПериод.Видимость = Ложь;
		ОбновитьДатуЗапретаОтраженияНаСервере();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормыПриИзмененииАвтоматическогоОтраженияВУчете()

	Элементы.ПредставлениеРасписания.Доступность = ИспользоватьАвтоматическоеОтражениеВУчете;
	Элементы.ПредставлениеРасписания.Гиперссылка = НЕ ОбщегоНазначения.РазделениеВключено();
	Элементы.СостояниеАвтоматическогоОтраженияВУчете.Доступность = ИспользоватьАвтоматическоеОтражениеВУчете;

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеЗакрытогоПериода()
	
	ОбновитьДатуЗапретаОтраженияНаСервере();
	Если ЗначениеЗаполнено(Организация) Тогда
		ПолучитьСостояниеОтраженияДокументов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДатуЗапретаОтраженияНаСервере()
	
	ДатаЗапрета = МеждународныйУчетОбщегоНазначения.ДатаЗапретаФормированияПроводок(Организация);
	Элементы.УстановитьДатуЗапрета.Заголовок = МеждународныйУчетОбщегоНазначения.ПредставлениеКомандыУстановитьДатуЗапрета(ДатаЗапрета);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
