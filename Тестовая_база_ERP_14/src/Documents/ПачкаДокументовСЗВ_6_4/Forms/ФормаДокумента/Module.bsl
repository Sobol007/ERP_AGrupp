#Область ОписаниеПеременных

&НаКлиенте
Перем НомерТекущейСтроиЗаписиОСтаже;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаписиОСтажеТекст = НСтр("ru = 'Записи о стаже';
							|en = 'Records of service'");
	ПерсонифицированныйУчетФормы.ДокументыКвартальнойОтчетностиПриСозданииНаСервере(ЭтаФорма, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
	ПерсонифицированныйУчетФормы.ДокументыСЗВПриСозданииНаСервере(ЭтаФорма, ОписаниеДокумента());
	Если Параметры.Ключ.Пустая() Тогда
		Если Объект.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
			ПерсонифицированныйУчетКлиентСервер.ДокументыСведенийОВзносахИСтажеУстановитьКорректируемыйПериод(ЭтотОбъект, '20131001');
		КонецЕсли;	

		ПриПолученииДанныхНаСервере(РеквизитФормыВЗначение("Объект", Тип("ДокументОбъект.ПачкаДокументовСЗВ_6_4")));
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаПечатьПереопределенная;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПерсонифицированныйУчетФормы.ДокументыКвартальнойОтчетностиПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВТаблице(ЭтотОбъект, Объект.Сотрудники, ОписаниеКолонокЗаголовковТаблицыСотрудники());
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПерсонифицированныйУчетКлиент.ДокументыКвартальнойОтчетностиПослеЗаписи(ЭтаФорма);
	Оповестить("Запись_ПачкаДокументовСЗВ_6_4", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" Тогда
		СтруктураОтбора = Новый Структура("Сотрудник", Источник);
		СтрокиПоСотруднику = Объект.Сотрудники.НайтиСтроки(СтруктураОтбора);
		ЗарплатаКадрыКлиентСервер.ОбработкаИзмененияДанныхФизическогоЛица(Объект, Параметр, СтрокиПоСотруднику, Модифицированность);
	ИначеЕсли ИмяСобытия = "РедактированиеДанныхСЗВ6ПоСотруднику" Тогда
		ПриИзмененииДанныхДокументаПоСотруднику(Параметр.АдресВоВременномХранилище);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетныйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Отказ = Ложь;
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодРегулирование(Объект.ОтчетныйПериод, ПериодСтрока, Направление, '20130101', , Отказ);	
	Если Не Отказ Тогда 
		УстановитьКатегориюЗастрахованныхЛицЗаПериод();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КорректируемыйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Отказ = Ложь;
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодРегулирование(Объект.КорректируемыйПериод, КорректируемыйПериодСтрока, Направление, '20130101', '20131001', Отказ);
	Если Не Отказ Тогда
		УстановитьКатегориюЗастрахованныхЛицЗаПериод();	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТипСведенийПриИзменении(Элемент)
	ТипСведенийСЗВПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();		
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыСотрудники

&НаКлиенте
Процедура СотрудникПриАктивизацииСтроки(Элемент)
	ПерсонифицированныйУчетКлиент.ДокументыСЗВСотрудникиПриАктивацииСтроки(Элементы.Сотрудники, ТекущийСотрудник);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	СотрудникиСотрудникПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	ПерсонифицированныйУчетКлиентСервер.ДокументыРедактированияСтажаСотрудникиПередУдалением(Элементы.Сотрудники.ВыделенныеСтроки, Объект.Сотрудники, Объект.ЗаписиОСтаже);	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Сотрудники.ТекущийЭлемент = Элементы.СотрудникиФизическоеЛицо
		И Не ЗначениеЗаполнено(Элементы.Сотрудники.ТекущиеДанные.Сотрудник) Тогда
		
		Возврат;
	КонецЕсли;	
		
	ОткрытьФормуРедактированияКарточкиДокумента();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Оповещение = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуЗавершение", ЭтотОбъект, Команда);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуЗавершение(Результат, Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаДискЗавершение", ЭтотОбъект);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура КвартальнаяОтчетностьПФР(Команда)
	ПерсонифицированныйУчетКлиент.ОткрытьРабочееМестоКвартальнойОтчетности(Объект.Организация, Объект.ОтчетныйПериод, Комплект);
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	ОчиститьСообщения();

	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);
	
	ПроверкаСтороннимиПрограммами(Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	Если ДанныеФайла <> Неопределено Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеКолонокЗаголовковТаблицФормы()
	ОписаниеКолонокЗаголовковТаблиц = Новый Соответствие;
	
	ОписаниеКолонокЗаголовковТаблиц.Вставить("Сотрудники", ОписаниеКолонокЗаголовковТаблицыСотрудники());  
	
	Возврат ОписаниеКолонокЗаголовковТаблиц;
КонецФункции	

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеКолонокЗаголовковТаблицыСотрудники()
	ОписаниеЗаголовковКолонок = Новый Массив;
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиНачисленоСтраховая";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
		
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиДоначисленоСтраховая";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиУплаченоСтраховая";
		
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);

	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиДоуплаченоСтраховая";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиНачисленоНакопительная";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиДоначисленоНакопительная";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиУплаченоНакопительная";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиДоуплаченоНакопительная";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	Возврат ОписаниеЗаголовковКолонок;
		
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуРедактированияКарточкиДокумента()
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	
	ДанныеШапкиТекущегоДокумента = Объект;
	
	Период = Объект.ОтчетныйПериод;
	
	Если ДанныеШапкиТекущегоДокумента.ТипСведенийСЗВ <> ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ") Тогда
		
		Период = ДанныеШапкиТекущегоДокумента.КорректируемыйПериод;
	КонецЕсли;	
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда	
		ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище();
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресВоВременномХранилище", АдресДанныхТекущегоДокументаВХранилище);
		ПараметрыОткрытияФормы.Вставить("РедактируемыйДокументСсылка", ДанныеШапкиТекущегоДокумента.Ссылка);
		ПараметрыОткрытияФормы.Вставить("Сотрудник", ДанныеТекущейСтроки.Сотрудник);
		ПараметрыОткрытияФормы.Вставить("ТипСведенийСЗВ", ДанныеШапкиТекущегоДокумента.ТипСведенийСЗВ);
		ПараметрыОткрытияФормы.Вставить("Организация", ДанныеШапкиТекущегоДокумента.Организация);
		ПараметрыОткрытияФормы.Вставить("Период", Период);
		ПараметрыОткрытияФормы.Вставить("ИсходныйНомерСтроки", 0);
		ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		ПараметрыОткрытияФормы.Вставить("НеОтображатьОшибки", Истина);
		
		ОткрытьФорму("Обработка.ПодготовкаКвартальнойОтчетностиВПФР.Форма.ФормаКарточкиСЗВ6", ПараметрыОткрытияФормы, ЭтаФорма);	
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ПриИзмененииДанныхДокументаПоСотруднику(АдресВоВременномХранилище)
	ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище);
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище()
	Если Элементы.Сотрудники.ТекущаяСтрока = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;	
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;
	
	ДанныеСотрудника = Новый Структура;
	ДанныеСотрудника.Вставить("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	ДанныеСотрудника.Вставить("СтраховойНомерПФР", ДанныеТекущейСтрокиПоСотруднику.СтраховойНомерПФР);
	ДанныеСотрудника.Вставить("Фамилия", ДанныеТекущейСтрокиПоСотруднику.Фамилия);
	ДанныеСотрудника.Вставить("Имя", ДанныеТекущейСтрокиПоСотруднику.Имя);
	ДанныеСотрудника.Вставить("Отчество", ДанныеТекущейСтрокиПоСотруднику.Отчество);
	ДанныеСотрудника.Вставить("НачисленоСтраховая", ДанныеТекущейСтрокиПоСотруднику.НачисленоСтраховая);
	ДанныеСотрудника.Вставить("УплаченоСтраховая", ДанныеТекущейСтрокиПоСотруднику.УплаченоСтраховая);
	ДанныеСотрудника.Вставить("НачисленоНакопительная", ДанныеТекущейСтрокиПоСотруднику.НачисленоНакопительная);
	ДанныеСотрудника.Вставить("УплаченоНакопительная", ДанныеТекущейСтрокиПоСотруднику.УплаченоНакопительная);
	ДанныеСотрудника.Вставить("ДоначисленоСтраховая", ДанныеТекущейСтрокиПоСотруднику.ДоначисленоСтраховая);
	ДанныеСотрудника.Вставить("ДоначисленоНакопительная", ДанныеТекущейСтрокиПоСотруднику.ДоначисленоНакопительная);
	ДанныеСотрудника.Вставить("ДоУплаченоНакопительная", ДанныеТекущейСтрокиПоСотруднику.ДоУплаченоНакопительная);
	ДанныеСотрудника.Вставить("ДоУплаченоСтраховая", ДанныеТекущейСтрокиПоСотруднику.ДоУплаченоСтраховая);
	ДанныеСотрудника.Вставить("ФиксНачисленныеВзносы", ДанныеТекущейСтрокиПоСотруднику.ФиксНачисленныеВзносы);
	ДанныеСотрудника.Вставить("ФиксУплаченныеВзносы", ДанныеТекущейСтрокиПоСотруднику.ФиксУплаченныеВзносы);
	ДанныеСотрудника.Вставить("ФиксСтаж", ДанныеТекущейСтрокиПоСотруднику.ФиксСтаж);
	ДанныеСотрудника.Вставить("ФиксЗаработок", Ложь);
	ДанныеСотрудника.Вставить("СведенияОЗаработке", Новый Массив);
    ДанныеСотрудника.Вставить("ЗаписиОСтаже", Новый Массив);
	ДанныеСотрудника.Вставить("ИсходныйНомерСтроки", ДанныеТекущейСтрокиПоСотруднику.ИсходныйНомерСтроки);
	
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
				
	СтрокиЗаписиОСтаже = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаСтаж Из СтрокиЗаписиОСтаже Цикл
		СтруктураПолейЗаписиОСтаже = СтруктураПолейЗаписиОСтаже();
		ЗаполнитьЗначенияСвойств(СтруктураПолейЗаписиОСтаже, СтрокаСтаж);
		СтруктураПолейЗаписиОСтаже.ИдентификаторИсходнойСтроки = СтрокаСтаж.ПолучитьИдентификатор(); 
				
		ДанныеСотрудника.ЗаписиОСтаже.Добавить(СтруктураПолейЗаписиОСтаже);
	КонецЦикла;	

	СтрокиСведенияОЗаработке = Объект.СведенияОЗаработке.НайтиСтроки(СтруктураПоиска);
		
	Для Каждого СтрокаЗаработок Из СтрокиСведенияОЗаработке Цикл
		СтруктураПолейСведенияОЗаработке = СтруктураПолейСведенияОЗаработке();
		ЗаполнитьЗначенияСвойств(СтруктураПолейСведенияОЗаработке, СтрокаЗаработок);
		СтруктураПолейСведенияОЗаработке.ИдентификаторИсходнойСтроки = СтрокаЗаработок.ПолучитьИдентификатор(); 								
		
		ДанныеСотрудника.СведенияОЗаработке.Добавить(СтруктураПолейСведенияОЗаработке);
	КонецЦикла;	
	
	Если ЗначениеЗаполнено(АдресДанныхТекущегоДокументаВХранилище) Тогда
		ПоместитьВоВременноеХранилище(ДанныеСотрудника, АдресДанныхТекущегоДокументаВХранилище);	
	Иначе	
		АдресДанныхТекущегоДокументаВХранилище = ПоместитьВоВременноеХранилище(ДанныеСотрудника, УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище)
	
	ДанныеШапкиДокумента = Объект;
	
	ДанныеТекущегоДокумента = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ДанныеТекущегоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Неопределено;
	НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", ДанныеТекущегоДокумента.Сотрудник));
		
	Если НайденныеСтроки.Количество() > 0 Тогда
		ДанныеТекущейСтрокиПоСотруднику = НайденныеСтроки[0];
		
		Если ДанныеТекущейСтрокиПоСотруднику.Сотрудник <> ДанныеТекущегоДокумента.Сотрудник Тогда
			ДанныеТекущейСтрокиПоСотруднику = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено  Тогда
		
		ВызватьИсключение НСтр("ru = 'В текущем документе не найдены данные по редактируемому сотруднику.';
								|en = 'Data on the edited employee is not found in the current document.'");
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
		
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтрокиПоСотруднику, ДанныеТекущегоДокумента);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
			
	СтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаСтажСотрудника Из СтрокиСтажа Цикл
		Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(СтрокаСтажСотрудника));
	КонецЦикла;
	
	СтрокиСтажаПоСотруднику = Новый Массив;
	Для Каждого СтрокаСтаж Из ДанныеТекущегоДокумента.ЗаписиОСтаже Цикл
		СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.Добавить();
		СтрокаСтажОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
			
		ЗаполнитьЗначенияСвойств(СтрокаСтажОбъекта, СтрокаСтаж);
		
		СтрокиСтажаПоСотруднику.Добавить(СтрокаСтажОбъекта);
	КонецЦикла;
	
	СтрокиЗаработка = Объект.СведенияОЗаработке.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаЗаработокСотрудника Из СтрокиЗаработка Цикл
		Объект.СведенияОЗаработке.Удалить(Объект.СведенияОЗаработке.Индекс(СтрокаЗаработокСотрудника));
	КонецЦикла;
	
	Для Каждого СтрокаЗаработок Из ДанныеТекущегоДокумента.СведенияОЗаработке Цикл
		СтрокаЗаработокОбъекта = Объект.СведенияОЗаработке.Добавить();
		СтрокаЗаработокОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
			
		ЗаполнитьЗначенияСвойств(СтрокаЗаработокОбъекта, СтрокаЗаработок);
		
	КонецЦикла;

	Если ДанныеТекущегоДокумента.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция СтруктураПолейЗаписиОСтаже()
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("НомерОсновнойЗаписи");
	СтруктураПолей.Вставить("НомерДополнительнойЗаписи");
	СтруктураПолей.Вставить("ДатаНачалаПериода");
	СтруктураПолей.Вставить("ДатаОкончанияПериода");
	СтруктураПолей.Вставить("ОсобыеУсловияТруда");
	СтруктураПолей.Вставить("КодПозицииСписка");
	СтруктураПолей.Вставить("ОснованиеИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ПервыйПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ВторойПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ТретийПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ОснованиеВыслугиЛет");
	СтруктураПолей.Вставить("ПервыйПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ВторойПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТретийПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТерриториальныеУсловия");
	СтруктураПолей.Вставить("ПараметрТерриториальныхУсловий");
	СтруктураПолей.Вставить("ИдентификаторИсходнойСтроки");

	Возврат СтруктураПолей;	
КонецФункции

&НаСервере
Функция СтруктураПолейСведенияОЗаработке()
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("КатегорияЗастрахованныхЛиц");
	СтруктураПолей.Вставить("Месяц");
	СтруктураПолей.Вставить("Заработок");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиДоПредельнойВеличины");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиСвышеПредельнойВеличины");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиЗаЗанятыхНаПодземныхИВредныхРаботах");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиЗаЗанятыхНаТяжелыхИПрочихРаботах");
	СтруктураПолей.Вставить("ПоДоговорамГПХДоПредельнойВеличины");
	СтруктураПолей.Вставить("ИдентификаторИсходнойСтроки");
	
	Возврат СтруктураПолей;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента()
	ОписаниеДокумента = ПерсонифицированныйУчетКлиентСервер.ОписаниеДокументаСЗВ();
	ОписаниеДокумента.ВариантОтчетногоПериода = "КВАРТАЛ";
	ОписаниеДокумента.ЕстьКорректируемыйПериод = Ложь;
	ОписаниеДокумента.ИмяПоляКорректируемыйПериод = "ОтчетныйПериод";
	
	Возврат ОписаниеДокумента;
КонецФункции	

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	Если Не ТаблицаДополнена Тогда 
		ИменаТаблиц = Новый Массив;
		ИменаТаблиц.Добавить("Сотрудники");

		ПерсонифицированныйУчетФормы.ДобавитьЗаголовкиКПолямТаблицФормы(ЭтотОбъект, ИменаТаблиц, ОписаниеКолонокЗаголовковТаблицФормы());
		
		ТаблицаДополнена = Истина;
	КонецЕсли;	

	ПерсонифицированныйУчетФормы.ДокументыСЗВПриПолученииДанныхНаСервере(ЭтаФорма, ОписаниеДокумента());
	
	ПерсонифицированныйУчетФормы.ДокументыСведенийОВзносахИСтажеПриПолученииДанныхНаСервере(ЭтаФорма);
	
	ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВТаблице(ЭтотОбъект, Объект.Сотрудники, ОписаниеКолонокЗаголовковТаблицыСотрудники());
	ПерсонифицированныйУчетФормы.УстановитьВидимостьКолонокЗаголовков(ЭтотОбъект, "Сотрудники", ОписаниеКолонокЗаголовковТаблицыСотрудники());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
    ЗапрашиваемыеЗначения.Вставить("ПредыдущийКвартал", "Объект.ОтчетныйПериод");
	
	Возврат ЗапрашиваемыеЗначения;
КонецФункции

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияЗаполненияПоОрганизации()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)
	Возврат ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);	
КонецФункции	

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	ПерсонифицированныйУчет.ДокументыСЗВСотрудникПриИзменении(Элементы.Сотрудники, Объект, ТекущийСотрудник, Истина);	
КонецПроцедуры	

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	Объект.Сотрудники.Очистить();
	Объект.ЗаписиОСтаже.Очистить();
	Объект.СведенияОЗаработке.Очистить();
	
	ПерсонифицированныйУчетФормы.ОрганизацияПриИзменении(ЭтаФорма, ЗапрашиваемыеЗначенияЗаполненияПоОрганизации());
	
	УстановитьКатегориюЗастрахованныхЛицЗаПериод();
КонецПроцедуры

&НаСервере
Процедура ТипСведенийСЗВПриИзмененииНаСервере()
	Если Объект.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		ПерсонифицированныйУчетКлиентСервер.ДокументыСведенийОВзносахИСтажеУстановитьКорректируемыйПериод(ЭтотОбъект, '20131001');
	Иначе
		Объект.КорректируемыйПериод = '00010101';
		КорректируемыйПериодСтрока = "";
	КонецЕсли;
	
	УстановитьКатегориюЗастрахованныхЛицЗаПериод();
	
	ПерсонифицированныйУчетКлиентСервер.ДокументыСведенийОВзносахИСтажеУстановитьДоступностьЭлементов(ЭтаФорма);
	
	Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		
		Объект.ЗаписиОСтаже.Очистить();
		
		Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
			СтрокаСотрудник.НачисленоСтраховая = 0;
			СтрокаСотрудник.УплаченоСтраховая = 0;
			СтрокаСотрудник.НачисленоНакопительная = 0;
			СтрокаСотрудник.УплаченоНакопительная = 0;
			СтрокаСотрудник.СведенияОЗаработке.Очистить();			
		КонецЦикла;	
	КонецЕсли;	

	ПерсонифицированныйУчетФормы.УстановитьВидимостьКолонокЗаголовков(ЭтотОбъект, "Сотрудники", ОписаниеКолонокЗаголовковТаблицыСотрудники());
КонецПроцедуры

&НаСервере
Процедура УстановитьКатегориюЗастрахованныхЛицЗаПериод() Экспорт
	ПерсонифицированныйУчетФормы.ДокументыСЗВУстановитьКатегориюЗастрахованныхЛицЗаПериод(ЭтаФорма, ОписаниеДокумента());	
КонецПроцедуры	

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВСтрокеТаблицы(
			ЭтотОбъект, 
			Элементы.Сотрудники.ТекущиеДанные, 
			ОписаниеКолонокЗаголовковТаблицыСотрудники());
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверкаЗаполненияДокумента(Отказ = Ложь)
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ПроверитьДанныеДокумента(Отказ);
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммами(Отказ)
	
	Если Отказ Тогда
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой обнаружены ошибки.
		|Выполнить проверку сторонними программами?';
		|en = 'Errors occurred while checking with the integrated check.
		|Check with third-party applications?'")
	Иначе	
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой ошибок не обнаружено.
		|Выполнить проверку сторонними программами?';
		|en = 'Errors are not detected while checking with the integrated check.
		|Check with third-party applications?'");
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроверкаСтороннимиПрограммамиЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммамиЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		ПроверитьСтороннимиПрограммами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтороннимиПрограммами()
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ПараметрыОткрытия = Новый Структура;
	
	ПроверяемыеОбъекты = Новый Массив;
	ПроверяемыеОбъекты.Добавить(Объект.Ссылка);
	
	ПараметрыОткрытия.Вставить("СсылкиНаПроверяемыеОбъекты", ПроверяемыеОбъекты);
	
	ОткрытьФорму("ОбщаяФорма.ПроверкаФайловОтчетностиПерсУчетаПФР", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействия(ОповещениеЗавершения = Неопределено)
	ОчиститьСообщения();
	
	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);	
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если Отказ Тогда 
		ТекстВопроса = НСтр("ru = 'В комплекте обнаружены ошибки.
							|Продолжить (не рекомендуется)?';
							|en = 'Errors were detected in the set.
							|Continue (not recommended)?'");
							
		Оповещение = Новый ОписаниеОповещения("ПроверитьСЗапросомДальнейшегоДействияЗавершение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение.';
																											|en = 'Warning.'"));
	Иначе 
		ПроверитьСЗапросомДальнейшегоДействияЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);				
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаписатьНаДискЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);	
КонецПроцедуры

#КонецОбласти
