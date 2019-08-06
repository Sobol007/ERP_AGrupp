
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Список = Элементы.ТипПараметраКлассификации.СписокВыбора;

	Если ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли") Тогда
		Список.Добавить(Перечисления.ТипыПараметровКлассификации.ВаловаяПрибыль);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВыручке") Тогда
		Список.Добавить(Перечисления.ТипыПараметровКлассификации.Выручка);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж") Тогда
		Список.Добавить(Перечисления.ТипыПараметровКлассификации.Количество);
	КонецЕсли;
	
	Если Список.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр(
			"ru = 'Не включено использование ни одного типа ABC и XYZ классификации партнеров.';
			|en = 'No type of partner ABC and XYZ classification is enabled.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	ТипПараметраКлассификации = Список.Получить(0).Значение;
	Элементы.ТипПараметраКлассификации.ТолькоПросмотр = (Список.Количество() <= 1);

	АнализНаДату = ТекущаяДатаСеанса();
	ТекстОшибки = "";
	УстановитьПериоды(ТекстОшибки);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ДатаПредыдущегоСреза >= ДатаТекущегоСреза Тогда
		ТекстСообщения = НСтр("ru = 'Дата предыдущего среза должна быть меньше даты текущего среза.';
								|en = 'The previous slice date should be earlier than the current slice date.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ДатаПредыдущегоСреза");
		
		Отказ = Истина;
	Иначе
		Если Не ЗначениеЗаполнено(ДатаСреза(ДатаПредыдущегоСреза)) Тогда
			ТекстСообщения = НСтр("ru = 'Среза на %Дата% не существует.';
									|en = 'Slice for %Дата% does not exist.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Дата%", Формат(ДатаПредыдущегоСреза, "ДЛФ=ДД"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ДатаПредыдущегоСреза");
		
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТипПараметраКлассификации) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо указать тип параметра классификации';
																|en = 'Specify classification parameter type'"),,"ТипПараметраКлассификации");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаТекущегоСреза) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнена дата текущего среза. Данное значение заполняется автоматически при выборе даты анализа, ближайшми значеним периода рассчета ABC и XYZ классификации.';
																|en = 'The current slice date is not filled in. This value is filled in automatically with the nearest values of the period of ABC and XYZ classification calculation when selecting an analysis date.'"),,"ДатаТекущегоСреза");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПредыдущегоСреза) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнена дата предыдущего среза.';
																|en = 'The previous slice date is not filled in.'"),,"ДатаПредыдущегоСреза");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПредыдущегоСрезаПриИзменении(Элемент)
	ОчиститьСообщения();
	ПроверитьЗаполнение();
КонецПроцедуры

&НаКлиенте
Процедура АнализНаДатуПриИзменении(Элемент)
	
	ТекстОшибки = "";
	УстановитьПериоды(ТекстОшибки);
	Если ТекстОшибки <> "" Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"АнализНаДату");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Расшифровка.Вставить("ТекущийПериод",             ДатаТекущегоСреза);
	Расшифровка.Вставить("ПрошлыйПериод",             ДатаПредыдущегоСреза);
	Расшифровка.Вставить("ТипПараметраКлассификации", ТипПараметраКлассификации);
	
	ПользовательскиеНастройки = ПолучитьПользовательскиеНастройкиОтчетаРасшифровки(Расшифровка.ИмяРасшифровки);
	
	ОткрытьФорму(
		Расшифровка.ИмяРасшифровки,
		Новый Структура("СформироватьПриОткрытии, Расшифровка, ПользовательскиеНастройки", Истина, Расшифровка, ПользовательскиеНастройки),
		ЭтаФорма, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	Если ПроверитьЗаполнение() Тогда
		ВывестиМатрицы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьПользовательскиеНастройкиОтчетаРасшифровки(ИмяФормыОтчета)
	
	Если ИмяФормыОтчета = "Отчет.ИзменениеABCXYZРаспределенияКлиентов.Форма" Тогда
		Схема = Отчеты.ИзменениеABCXYZРаспределенияКлиентов.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Иначе
		Схема = Отчеты.ABCXYZРаспределениеКлиентов.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	КонецЕсли;
	Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема);
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Источник);
	ПользовательскиеНастройки = Компоновщик.ПользовательскиеНастройки;
	
	Возврат ПользовательскиеНастройки;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИмяПараметра(ЗначениеКласса)

	Если ЗначениеКласса = Перечисления.ABCКлассификация.AКласс Тогда
		ИмяПараметра = "A";
	ИначеЕсли ЗначениеКласса = Перечисления.ABCКлассификация.BКласс Тогда
		ИмяПараметра = "B";
	ИначеЕсли ЗначениеКласса = Перечисления.ABCКлассификация.CКласс Тогда
		ИмяПараметра = "C";
	ИначеЕсли ЗначениеКласса = Перечисления.ABCКлассификация.НеКлассифицирован Тогда
		ИмяПараметра = "_";
	ИначеЕсли ЗначениеКласса = Перечисления.ABCКлассификация.ПустаяСсылка() Тогда
		ИмяПараметра = "P";
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.XКласс Тогда
		ИмяПараметра = "X";
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.YКласс Тогда
		ИмяПараметра = "Y";
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.ZКласс Тогда
		ИмяПараметра = "Z";
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.НеКлассифицирован Тогда
		ИмяПараметра = "L";
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.ПустаяСсылка() Тогда
		ИмяПараметра = "P";
	КонецЕсли;

	Возврат ИмяПараметра;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОписаниеКласса(ЗначениеКласса)

	Если ЗначениеКласса = Перечисления.ABCКлассификация.ПустаяСсылка() Тогда
		Возврат НСтр("ru = 'потенциальный клиент(ABC)';
					|en = 'potential customer (ABC)'");
	ИначеЕсли ЗначениеКласса = Перечисления.ABCКлассификация.НеКлассифицирован Тогда
		Возврат НСтр("ru = 'потерянный клиент(ABC)';
					|en = 'lost customer (ABC)'");
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.ПустаяСсылка() Тогда
		Возврат НСтр("ru = 'потенциальный клиент(XYZ)';
					|en = 'potential customer (XYZ)'");
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.НеКлассифицирован Тогда
		Возврат НСтр("ru = 'потерянный клиент(XYZ)';
					|en = 'lost customer (XYZ)'");
	Иначе
		Возврат Строка(ЗначениеКласса);
	КонецЕсли;

КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьПараметры(Параметр1, Параметр2, КоличествоКлиентов, Область)

	ТипПараметра1 = ТипЗнч(Параметр1);
	Изменения = (ТипПараметра1 = ТипЗнч(Параметр2));
	ИмяПараметра = ПолучитьИмяПараметра(Параметр1) + ПолучитьИмяПараметра(Параметр2);
	ИмяПараметраРасшифровки = ?(Изменения, "m", "d");
	ИмяПараметраРасшифровки = ИмяПараметраРасшифровки + ИмяПараметра;
	Попытка
	   Область.Параметры[ИмяПараметра] = КоличествоКлиентов;	
	Исключение
	   Возврат;
	КонецПопытки;	

	Если Изменения Тогда
		ИмяРасшифровки = "Отчет.ИзменениеABCXYZРаспределенияКлиентов.Форма";
		Если ТипПараметра1 = Тип("ПеречислениеСсылка.ABCКлассификация") Тогда
			ПоляОтбора = Новый Структура("ПрошлыйABC, ТекущийABC", Параметр1, Параметр2);
			ЗаголовокСписка = НСтр("ru = 'Перешли из %Параметр1% в %Параметр2%';
									|en = 'Transferred from %Параметр1% to %Параметр2%'");
		Иначе
			ПоляОтбора = Новый Структура("ПрошлыйXYZ, ТекущийXYZ", Параметр1, Параметр2);
			ЗаголовокСписка = НСтр("ru = 'Перешли из %Параметр1% в %Параметр2%';
									|en = 'Transferred from %Параметр1% to %Параметр2%'");
		КонецЕсли;
	Иначе
		ИмяРасшифровки = "Отчет.ABCXYZРаспределениеКлиентов.Форма";
		ПоляОтбора = Новый Структура("КлассABC, КлассXYZ", Параметр1, Параметр2);
		ЗаголовокСписка = НСтр("ru = 'Отнесены к %Параметр1%, %Параметр2%';
								|en = 'Referred to %Параметр1%, %Параметр2% '");
	КонецЕсли;

	ЗаголовокСписка = СтрЗаменить(ЗаголовокСписка, "%Параметр1%", ПолучитьОписаниеКласса(Параметр1));
	ЗаголовокСписка = СтрЗаменить(ЗаголовокСписка, "%Параметр2%", ПолучитьОписаниеКласса(Параметр2));
	Попытка
		Область.Параметры[ИмяПараметраРасшифровки] = Новый Структура(
		"ИмяРасшифровки, Заголовок, Отбор", ИмяРасшифровки, ЗаголовокСписка, ПоляОтбора);
	Исключение
		Возврат;
	КонецПопытки;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДатаСреза(РабочаяДата)

	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МАКСИМУМ(ABCXYZКлассификацияКлиентовСрезПоследних.Период) КАК Период
		|ИЗ
		|	РегистрСведений.ABCXYZКлассификацияКлиентов.СрезПоследних(&ДатаСреза, ) КАК ABCXYZКлассификацияКлиентовСрезПоследних");
	Запрос.УстановитьПараметр("ДатаСреза", РабочаяДата - 1);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Период;

КонецФункции

&НаСервере
Процедура УстановитьПериоды(ТекстОшибки)

	ПериодКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(
			АнализНаДату, Константы.ПериодABCКлассификацииПартнеров.Получить(), -Константы.КоличествоПериодовABCКлассификацииПартнеров.Получить());
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
		|	ABCXYZКлассификацияКлиентов.Период КАК Период
		|ИЗ
		|	РегистрСведений.ABCXYZКлассификацияКлиентов КАК ABCXYZКлассификацияКлиентов
		|ГДЕ
		|	ABCXYZКлассификацияКлиентов.Период <= &АнализНаДату
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ");
	Запрос.УстановитьПараметр("АнализНаДату", АнализНаДату);
	Выборка = Запрос.Выполнить();

	Если Не Выборка.Пустой() Тогда

		Выборка = Выборка.Выбрать();
		Выборка.Следующий();
		ДатаТекущегоСреза = Выборка.Период;
		Если Выборка.Следующий() Тогда
			ДатаПредыдущегоСреза = Выборка.Период;
		Иначе
			ТекстОшибки = НСтр("ru = 'На %Дата% отсутствует предыдущий срез.';
								|en = 'Previous slice is missing on %Дата%.'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Формат(АнализНаДату, "ДЛФ=ДД"));
			ДатаПредыдущегоСреза = '00010101';
		КонецЕсли;

		Если ЗначениеЗаполнено(ТипПараметраКлассификации) Тогда
			ВывестиМатрицы();
		КонецЕсли;
	Иначе
		ТекстОшибки = НСтр("ru = 'На %Дата% классификация отсутствует.';
							|en = 'Classification is missing on %Дата%.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Формат(АнализНаДату, "ДЛФ=ДД"));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ВывестиМатрицы()

	Вопросы					= 0;
	Макет					= Отчеты.АнализКлиентскойБазыBCG.ПолучитьМакет("Матрицы");
	ОбластьМатриц			= Макет.ПолучитьОбласть("Матрицы");
	ОбластьИзменений		= Макет.ПолучитьОбласть("Изменения");
	ПотенциальныхКлиентов	= 0 ;

	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ABCXYZКлассификацияКлиентовСрезПоследних.Партнер КАК Партнер,
		|	ABCXYZКлассификацияКлиентовСрезПоследних.Класс КАК Класс
		|ПОМЕСТИТЬ ТекущийABC
		|ИЗ
		|	РегистрСведений.ABCXYZКлассификацияКлиентов.СрезПоследних(&ТекущийПериод, ) КАК ABCXYZКлассификацияКлиентовСрезПоследних
		|ГДЕ
		|	ABCXYZКлассификацияКлиентовСрезПоследних.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.ABC)
		|	И ABCXYZКлассификацияКлиентовСрезПоследних.ТипПараметраКлассификации = &ТипПараметраКлассификации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ABCXYZКлассификацияКлиентовСрезПоследних.Партнер КАК Партнер,
		|	ABCXYZКлассификацияКлиентовСрезПоследних.Класс КАК Класс
		|ПОМЕСТИТЬ ПрошлыйABC
		|ИЗ
		|	РегистрСведений.ABCXYZКлассификацияКлиентов.СрезПоследних(&ПрошлыйПериод, ) КАК ABCXYZКлассификацияКлиентовСрезПоследних
		|ГДЕ
		|	ABCXYZКлассификацияКлиентовСрезПоследних.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.ABC)
		|	И ABCXYZКлассификацияКлиентовСрезПоследних.ТипПараметраКлассификации = &ТипПараметраКлассификации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ABCXYZКлассификацияКлиентовСрезПоследних.Партнер КАК Партнер,
		|	ABCXYZКлассификацияКлиентовСрезПоследних.Класс КАК Класс
		|ПОМЕСТИТЬ ТекущийXYZ
		|ИЗ
		|	РегистрСведений.ABCXYZКлассификацияКлиентов.СрезПоследних(&ТекущийПериод, ) КАК ABCXYZКлассификацияКлиентовСрезПоследних
		|ГДЕ
		|	ABCXYZКлассификацияКлиентовСрезПоследних.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.XYZ)
		|	И ABCXYZКлассификацияКлиентовСрезПоследних.ТипПараметраКлассификации = &ТипПараметраКлассификации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ABCXYZКлассификацияКлиентовСрезПоследних.Партнер КАК Партнер,
		|	ABCXYZКлассификацияКлиентовСрезПоследних.Класс КАК Класс
		|ПОМЕСТИТЬ ПрошлыйXYZ
		|ИЗ
		|	РегистрСведений.ABCXYZКлассификацияКлиентов.СрезПоследних(&ПрошлыйПериод, ) КАК ABCXYZКлассификацияКлиентовСрезПоследних
		|ГДЕ
		|	ABCXYZКлассификацияКлиентовСрезПоследних.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.XYZ)
		|	И ABCXYZКлассификацияКлиентовСрезПоследних.ТипПараметраКлассификации = &ТипПараметраКлассификации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Партнеры.Ссылка КАК Партнер
		|ПОМЕСТИТЬ КлассифицированныеПартнеры
		|ИЗ
		|	Справочник.Партнеры КАК Партнеры
		|ГДЕ
		|	Партнеры.Ссылка В
		|			(ВЫБРАТЬ
		|				ПрошлыйABC.Партнер
		|			ИЗ
		|				ПрошлыйABC КАК ПрошлыйABC
		|		
		|			ОБЪЕДИНИТЬ ВСЕ
		|		
		|			ВЫБРАТЬ
		|				ПрошлыйXYZ.Партнер
		|			ИЗ
		|				ПрошлыйXYZ КАК ПрошлыйXYZ
		|		
		|			ОБЪЕДИНИТЬ ВСЕ
		|		
		|			ВЫБРАТЬ
		|				ТекущийABC.Партнер
		|			ИЗ
		|				ТекущийABC КАК ТекущийABC
		|		
		|			ОБЪЕДИНИТЬ ВСЕ
		|		
		|			ВЫБРАТЬ
		|				ТекущийXYZ.Партнер
		|			ИЗ
		|				ТекущийXYZ КАК ТекущийXYZ)
		|	И (НЕ Партнеры.ПометкаУдаления) И (НЕ Партнеры.Предопределенный)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ТекущийXYZ.Класс, ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ПустаяСсылка)) КАК ТекущийXYZ,
		|	ЕСТЬNULL(ТекущийABC.Класс, ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.ПустаяСсылка)) КАК ТекущийABC,
		|	ЕСТЬNULL(ПрошлыйXYZ.Класс, ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ПустаяСсылка)) КАК ПрошлыйXYZ,
		|	ЕСТЬNULL(ПрошлыйABC.Класс, ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.ПустаяСсылка)) КАК ПрошлыйABC,
		|	КлассифицированныеПартнеры.Партнер КАК Партнер
		|ИЗ
		|	КлассифицированныеПартнеры КАК КлассифицированныеПартнеры
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПрошлыйABC КАК ПрошлыйABC
		|		ПО КлассифицированныеПартнеры.Партнер = ПрошлыйABC.Партнер
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущийABC КАК ТекущийABC
		|		ПО КлассифицированныеПартнеры.Партнер = ТекущийABC.Партнер
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПрошлыйXYZ КАК ПрошлыйXYZ
		|		ПО КлассифицированныеПартнеры.Партнер = ПрошлыйXYZ.Партнер
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущийXYZ КАК ТекущийXYZ
		|		ПО КлассифицированныеПартнеры.Партнер = ТекущийXYZ.Партнер
		|ГДЕ
		|	(НЕ КлассифицированныеПартнеры.Партнер.ПометкаУдаления)
		|ИТОГИ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Партнер)
		|ПО
		|	ТекущийXYZ,
		|	ТекущийABC,
		|	ПрошлыйXYZ,
		|	ПрошлыйABC");
	Запрос.УстановитьПараметр("ТекущийПериод", ДатаТекущегоСреза);
	Запрос.УстановитьПараметр("ПрошлыйПериод", ДатаПредыдущегоСреза);
	Запрос.УстановитьПараметр("ТипПараметраКлассификации", ТипПараметраКлассификации);

	РезультатЗапроса = Запрос.Выполнить();

	// заполнить BCG, A-Z распределение и изменения XYZ
	ВыборкаТекущийXYZ = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Пока ВыборкаТекущийXYZ.Следующий() Цикл

		Если ВыборкаТекущийXYZ.ТекущийXYZ = Перечисления.XYZКлассификация.НеКлассифицирован Тогда
			ОбластьМатриц.Параметры.Потерянные = ВыборкаТекущийXYZ.Партнер;
			ИмяРасшифровки = "Отчет.ABCXYZРаспределениеКлиентов.Форма";
			ЗаголовокСписка = НСтр("ru = 'Потерянные клиенты';
									|en = 'Lost customers'");
			ПоляОтбора = Новый Структура("КлассXYZ", Перечисления.XYZКлассификация.НеКлассифицирован);
			ОбластьМатриц.Параметры.dПотерянные = Новый Структура(
				"ИмяРасшифровки, Заголовок, Отбор", ИмяРасшифровки, ЗаголовокСписка, ПоляОтбора);
		ИначеЕсли ВыборкаТекущийXYZ.ТекущийXYZ = Перечисления.XYZКлассификация.ПустаяСсылка() Тогда
			ОбластьМатриц.Параметры.Потенциальные = ВыборкаТекущийXYZ.Партнер;
			
			ПотенциальныхКлиентов = ВыборкаТекущийXYZ.Партнер;
			
			ИмяРасшифровки = "Отчет.ABCXYZРаспределениеКлиентов.Форма";
			ЗаголовокСписка = НСтр("ru = 'Потенциальные клиенты';
									|en = 'Potential customers'");
			ПоляОтбора = Новый Структура("КлассXYZ", Перечисления.XYZКлассификация.ПустаяСсылка());
			ОбластьМатриц.Параметры.dПотенциальные = Новый Структура(
				"ИмяРасшифровки, Заголовок, Отбор", ИмяРасшифровки, ЗаголовокСписка, ПоляОтбора);
		Иначе
			// заполнить A-Z распределение
			ВыборкаТекущийABC = ВыборкаТекущийXYZ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
			Пока ВыборкаТекущийABC.Следующий() Цикл
				ЗаполнитьПараметры(
					ВыборкаТекущийABC.ТекущийABC, ВыборкаТекущийABC.ТекущийXYZ,
					ВыборкаТекущийABC.Партнер, ОбластьМатриц);
				Если Не((ВыборкаТекущийABC.ТекущийABC = Перечисления.ABCКлассификация.AКласс
						И ВыборкаТекущийABC.ТекущийXYZ = Перечисления.XYZКлассификация.XКласс)
						Или
						(ВыборкаТекущийABC.ТекущийABC = Перечисления.ABCКлассификация.AКласс
						И ВыборкаТекущийABC.ТекущийXYZ = Перечисления.XYZКлассификация.ZКласс)
						Или
						(ВыборкаТекущийABC.ТекущийABC = Перечисления.ABCКлассификация.CКласс
						И ВыборкаТекущийABC.ТекущийXYZ = Перечисления.XYZКлассификация.XКласс)) Тогда
					Вопросы = Вопросы + ВыборкаТекущийABC.Партнер;
				КонецЕсли;
			КонецЦикла; //заполнить A-Z распределение
		КонецЕсли;

		// заполнить изменения XYZ
		Если ДатаПредыдущегоСреза <> '00010101' Тогда
			ВыборкаПрошлыйXYZ = ВыборкаТекущийXYZ.Выбрать(
				ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "ПрошлыйXYZ");
			Пока ВыборкаПрошлыйXYZ.Следующий() Цикл
				Если Не ЗначениеЗаполнено(ВыборкаПрошлыйXYZ.ТекущийXYZ) Тогда
					Продолжить;
				КонецЕсли;

				ЗаполнитьПараметры(
					?(ЗначениеЗаполнено(ВыборкаПрошлыйXYZ.ПрошлыйXYZ),
						ВыборкаПрошлыйXYZ.ПрошлыйXYZ, Перечисления.XYZКлассификация.ПустаяСсылка()
					),
					?(ЗначениеЗаполнено(ВыборкаПрошлыйXYZ.ТекущийXYZ),
							ВыборкаПрошлыйXYZ.ТекущийXYZ, Перечисления.XYZКлассификация.ПустаяСсылка()
					),
					ВыборкаПрошлыйXYZ.Партнер, ОбластьИзменений);
			КонецЦикла; //заполнить изменения XYZ
		КонецЕсли; //заполнить изменения XYZ

		ОбластьМатриц.Параметры.Вопросы = Вопросы;
		ИмяРасшифровки = "Отчет.ABCXYZРаспределениеКлиентов.Форма";
		ОбластьМатриц.Параметры.dВопросы = Новый Структура(
			"ИмяРасшифровки, Заголовок, Вопросы",
			ИмяРасшифровки, НСтр("ru = 'Отнесены к категории BCG ""вопросы""';
								|en = 'Referred to the BCG ""questions"" category'"), Истина);

	КонецЦикла; //заполнить BCG, A-Z распределение и изменения XYZ

	// вывести область матриц
	Результат.Очистить();
	Результат.Вывести(ОбластьМатриц);
	
	Если ПотенциальныхКлиентов = 0 Тогда
		Результат.УдалитьОбласть(Результат.Области.Потенциальные, ТипСмещенияТабличногоДокумента.ПоВертикали);
	КонецЕсли;
	
	// заполнить изменения ABC и вывести область изменений
	Если ДатаПредыдущегоСреза <> '00010101' Тогда
		ВыборкаТекущийABC = РезультатЗапроса.Выбрать(
			ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "ТекущийABC");
		Пока ВыборкаТекущийABC.Следующий() Цикл
			Если Не ЗначениеЗаполнено(ВыборкаТекущийABC.ТекущийABC) Тогда
				Продолжить;
			КонецЕсли;
			ВыборкаПрошлыйABC = ВыборкаТекущийABC.Выбрать(
				ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "ПрошлыйABC");
			Пока ВыборкаПрошлыйABC.Следующий() Цикл
				ЗаполнитьПараметры(
					?(ЗначениеЗаполнено(ВыборкаПрошлыйABC.ПрошлыйABC),
						ВыборкаПрошлыйABC.ПрошлыйABC,
						Перечисления.ABCКлассификация.ПустаяСсылка()
					),
					?(ЗначениеЗаполнено(ВыборкаПрошлыйABC.ТекущийABC),
							ВыборкаПрошлыйABC.ТекущийABC,
							Перечисления.ABCКлассификация.ПустаяСсылка()
					),
					ВыборкаПрошлыйABC.Партнер, ОбластьИзменений);
			КонецЦикла;
		КонецЦикла;

		Результат.Вывести(ОбластьИзменений);
	КонецЕсли; //заполнить изменения ABC и вывести область изменений

КонецПроцедуры

#КонецОбласти
