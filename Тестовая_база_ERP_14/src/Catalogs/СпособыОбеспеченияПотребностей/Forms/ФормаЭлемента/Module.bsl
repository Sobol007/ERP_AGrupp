
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ДатаСегодня = НачалоДня(ТекущаяДатаСеанса());
	Справочники.СпособыОбеспеченияПотребностей.АктуализироватьГрафикЗаказовНаСервере(Объект, ДатаСегодня);

	ПереключательЗаказыФормируютсяНеПоПлану = ?(Объект.ФормироватьПлановыеЗаказы, 0, 1);
	ПереключательЗаказыФормируютсяПоПлану   = ?(Объект.ФормироватьПлановыеЗаказы, 1, 0);

	ОдинИсточник = ЗначениеЗаполнено(Объект.ИсточникОбеспеченияПотребностей);
	СписокВыбора = ЗаполнитьСписокВыбораТипаОбеспечения();
	
	// Приведение значения типа обеспечения к допустимому.
	Если СписокВыбора.НайтиПоЗначению(Объект.ТипОбеспечения) = Неопределено Тогда
		Если СписокВыбора.НайтиПоЗначению(Перечисления.ТипыОбеспечения.Покупка) <> Неопределено Тогда
			Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка;
		ИначеЕсли СписокВыбора.Количество() > 0 Тогда
			Объект.ТипОбеспечения = СписокВыбора[0].Значение;
		КонецЕсли;
	КонецЕсли;

	Если СписокВыбора.Количество() = 1 Тогда
		Элементы.ТипОбеспечения1.Видимость = Ложь;
		Элементы.ТипОбеспечения2.Видимость = Ложь;
		Элементы.ТипОбеспечения3.Видимость = Ложь;
		Элементы.ТипОбеспечения4.Видимость = Ложь;
		Элементы.ТипОбеспечения5.Видимость = Ложь;
	КонецЕсли;

	НастроитьФормуПоТипуОбеспечения();
	АктивизироватьСтраницыРежимИспользования(Элементы, ОдинИсточник);
	АктивизироватьСтраницыПравилоФормирования(Элементы, Объект.ФормироватьПлановыеЗаказы);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);
	СформироватьЗаголовкиПоясняющихНадписей();

	Элементы.Поставщик.ОграничениеТипа              = Новый ОписаниеТипов("СправочникСсылка.Партнеры");
	Элементы.Склад.ОграничениеТипа                  = Новый ОписаниеТипов("СправочникСсылка.Склады");
	Элементы.Переработчик.ОграничениеТипа           = Новый ОписаниеТипов("СправочникСсылка.Партнеры");
	Элементы.ПодразделениеДиспетчер.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ФормироватьПлановыеЗаказы Тогда
		ТекущийОбъект.ОбеспечиваемыйПериод = 0;
		ТекущийОбъект.ГарантированныйСрокОтгрузки = 0;
	Иначе
		// Очистка дат по графику заказов.
		ТекущийОбъект.ПлановаяДатаЗаказа    = '00010101';
		ТекущийОбъект.ПлановаяДатаПоставки  = '00010101';
		ТекущийОбъект.ДатаСледующейПоставки = '00010101';
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОбеспечения", Объект.ТипОбеспечения);
	Оповестить("Запись_СпособОбеспеченияПотребностей", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОдинИсточник = 1 И Не ЗначениеЗаполнено(Объект.ИсточникОбеспеченияПотребностей) Тогда
		
		Если Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Поставщик"" не заполнено';
									|en = 'Supplier is not filled in'");
		ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Распределительный центр"" не заполнено';
									|en = 'The ""Distribution center"" field is required'");
		//++ НЕ УТКА
		ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.ПроизводствоНаСтороне Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Переработчик"" не заполнено';
									|en = 'Toller is not filled in'");
		ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Производство Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Подразделение-диспетчер"" не заполнено';
									|en = 'Dispatcher department is not filled in'");
		//-- НЕ УТКА
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ИсточникОбеспеченияПотребностей", "Объект"); 
		Отказ = Истина;
	КонецЕсли;
	
	ПроверитьКорректностьЗаполненияДатПоставки(Объект, ДатаСегодня, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОбеспеченияПриИзменении(Элемент)
	
	Объект.ИсточникОбеспеченияПотребностей = Неопределено;
	Объект.Соглашение        = ПредопределенноеЗначение("Справочник.СоглашенияСПоставщиками.ПустаяСсылка");
	Объект.ВидЦеныПоставщика = ПредопределенноеЗначение("Справочник.ВидыЦенПоставщиков.ПустаяСсылка");
	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка") Тогда
		ОдинИсточник = 0;
		АктивизироватьСтраницыРежимИспользования(Элементы, Ложь);
	КонецЕсли;
	//++ НЕ УТКА
	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Производство") Тогда
		Объект.Подразделение = ПредопределенноеЗначение("Справочник.СтруктураПредприятия.ПустаяСсылка");
	КонецЕсли;
	//-- НЕ УТКА
	
	НастроитьФормуПоТипуОбеспечения();
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПокупкиПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокПеремещенияПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокСборкиПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокПроизводстваПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияЗаказаПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбеспечиваемыйПериодПриИзменении(Элемент)

	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПереключательЗаказыФормируютсяНеПоПлануПриИзменении(Элемент)

	ПереключательЗаказыФормируютсяНеПоПлану = 1;
	ПереключательЗаказыФормируютсяПоПлану   = 0;
	
	Объект.ПлановаяДатаПоставки  = '00010101'; //очистка даты
	Объект.ДатаСледующейПоставки = '00010101'; //очистка даты
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);

	Объект.ФормироватьПлановыеЗаказы        = Ложь;
	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();

	АктивизироватьСтраницыПравилоФормирования(Элементы, Объект.ФормироватьПлановыеЗаказы);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПереключательЗаказыФормируютсяПоПлануПриИзменении(Элемент)

	ПереключательЗаказыФормируютсяНеПоПлану = 0;
	ПереключательЗаказыФормируютсяПоПлану   = 1;

	Объект.ОбеспечиваемыйПериод = 0;
	Объект.ГарантированныйСрокОтгрузки = 0;

	Объект.ФормироватьПлановыеЗаказы        = Истина;

	АктивизироватьСтраницыПравилоФормирования(Элементы, Объект.ФормироватьПлановыеЗаказы);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура РежимИспользованияНесколькоИсточниковПриИзменении(Элемент)
	
	Объект.ИсточникОбеспеченияПотребностей = Неопределено;
	Объект.Соглашение        = ПредопределенноеЗначение("Справочник.СоглашенияСПоставщиками.ПустаяСсылка");
	Объект.ВидЦеныПоставщика = ПредопределенноеЗначение("Справочник.ВидыЦенПоставщиков.ПустаяСсылка");
	
	АктивизироватьСтраницыРежимИспользования(Элементы, Ложь);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимИспользованияОдинИсточникПриИзменении(Элемент)
	
	АктивизироватьСтраницыРежимИспользования(Элементы, Истина);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаБлижайшейПоставкиПриИзменении(Элемент)

	ОчиститьСообщения();
	Объект.ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
	ПроверитьКорректностьЗаполненияДатПоставки(Объект, ДатаСегодня);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДатаСледующейПоставкиПриИзменении(Элемент)

	ОчиститьСообщения();
	ПроверитьКорректностьЗаполненияДатПоставки(Объект, ДатаСегодня);
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СборкаДлительностьВДняхПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПеремещениеДлительностьВДняхПриИзменении(Элемент)

	СкорректироватьСрокИсполненияЗаказа();
	СкорректироватьГарантированныйСрокОтгрузки();
	СформироватьТекстПоясняющихНадписей(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииРаботыСДатами

&НаСервереБезКонтекста
Функция ОпределитьДатуЗаказаПоДатеПоставки(ДатаПоставки, СрокИсполненияЗаказа)

	Если Не ЗначениеЗаполнено(ДатаПоставки) Тогда
		Возврат НСтр("ru = 'для расчета заполните дату ближайшей поставки';
					|en = 'To calculate, fill in the date of the earliest delivery'");
	КонецЕсли;

	Возврат Справочники.СпособыОбеспеченияПотребностей.ОпределитьДатуЗаказаПоДатеПоставки(ДатаПоставки, СрокИсполненияЗаказа);

КонецФункции

&НаСервереБезКонтекста
Функция ОпределитьДатуПоставкиПоДатеЗаказа(СрокИсполненияЗаказа, ОбеспечиваемыйПериод)

	ДатаЗаказа = НачалоДня(ТекущаяДатаСеанса());
	Результат = Новый Структура("ДатаПоставки, ГраницаПериода");

	КалендарьПредприятия = Константы.ОсновнойКалендарьПредприятия.Получить();

	Если ЗначениеЗаполнено(КалендарьПредприятия) Тогда

		Результат.ДатаПоставки = КалендарныеГрафики.ДатаПоКалендарю(
			КалендарьПредприятия, ДатаЗаказа, СрокИсполненияЗаказа, Ложь);

	Иначе

		Результат.ДатаПоставки = ДатаЗаказа + СрокИсполненияЗаказа * 86400; //86400 - длительность суток в секундах

	КонецЕсли;

	Если Результат.ДатаПоставки = Неопределено Тогда

		Результат.ДатаПоставки   = НСтр("ru = 'не заполнен график работы предприятия';
										|en = 'enterprise schedule is not filled in'");
		Результат.ГраницаПериода = НСтр("ru = 'не заполнен график работы предприятия';
										|en = 'enterprise schedule is not filled in'");

	Иначе

		Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда

			Результат.ДатаПоставки = Формат(Результат.ДатаПоставки, "ДЛФ=D");
			Результат.ГраницаПериода = НСтр("ru = '<варьируется по складам>';
											|en = '<varies in warehouses>'");

		ИначеЕсли ОбеспечиваемыйПериод = 0 Тогда

			Результат.ДатаПоставки = Формат(Результат.ДатаПоставки, "ДЛФ=D");
			Результат.ГраницаПериода = НСтр("ru = 'не ограничена';
											|en = 'not limited'");

		Иначе

			СкладПоУмолчанию = Справочники.Склады.СкладПоУмолчанию();
			Если ЗначениеЗаполнено(СкладПоУмолчанию) Тогда

				КалендарьСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СкладПоУмолчанию, "Календарь");
				Если Не ЗначениеЗаполнено(КалендарьСклада) Тогда
					КалендарьСклада = КалендарьПредприятия;
				КонецЕсли;

				Если ЗначениеЗаполнено(КалендарьСклада) Тогда

					Результат.ГраницаПериода = КалендарныеГрафики.ДатаПоКалендарю(
						КалендарьСклада, Результат.ДатаПоставки, ОбеспечиваемыйПериод, Ложь);

					Если Результат.ГраницаПериода = Неопределено Тогда
						Результат.ГраницаПериода = НСтр("ru = 'не заполнен график работы склада';
														|en = 'warehouse schedule is not filled in'");
					Иначе
						Результат.ГраницаПериода = Формат(Результат.ГраницаПериода, "ДЛФ=D");
					КонецЕсли;

				Иначе

					Результат.ГраницаПериода = Результат.ДатаПоставки + ОбеспечиваемыйПериод * 86400; //86400 - длительность суток в секундах
					Результат.ГраницаПериода = Формат(Результат.ГраницаПериода, "ДЛФ=D");

				КонецЕсли;

			Иначе

				Результат.ГраницаПериода = НСтр("ru = '<варьируется по складам>';
												|en = '<varies in warehouses>'");

			КонецЕсли;

			Результат.ДатаПоставки = Формат(Результат.ДатаПоставки, "ДЛФ=D");

		КонецЕсли;

	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьКорректностьЗаполненияДатПоставки(Объект, ДатаСегодня, Отказ = Неопределено)

	ДатаПоставки                = Объект.ПлановаяДатаПоставки;
	ДатаСледующейПоставки       = Объект.ДатаСледующейПоставки;
	ФормироватьПлановыеЗаказы   = Объект.ФормироватьПлановыеЗаказы;
	ПлановаяДатаЗаказа          = Объект.ПлановаяДатаЗаказа;

	Если ФормироватьПлановыеЗаказы Тогда

		Если ЗначениеЗаполнено(ДатаПоставки) И ДатаПоставки < НачалоДня(ДатаСегодня) Тогда

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Недопустимо устанавливать в график прошедшую дату.
				| Если ближайшая поставка не запланирована, необходимо оставить дату пустой.';
				|en = 'Not allowed to set past date in schedule. 
				| If next delivery is not scheduled, the date shall be left empty.'"),
				, "Объект.ПлановаяДатаПоставки");
			Отказ = Истина;

		КонецЕсли;

		Если ЗначениеЗаполнено(ДатаСледующейПоставки) И НачалоДня(ДатаСледующейПоставки) <= НачалоДня(ДатаПоставки) Тогда

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Дата следующей поставки должна быть позднее даты ближайшей поставки.
				| Если следующая поставка не запланирована, необходимо оставить дату пустой.';
				|en = 'Next delivery date shall be later than the earliest delivery date. 
				|If next delivery is not planned, leave the date empty.'"),
				, "Объект.ДатаСледующейПоставки");
			Отказ = Истина;

		КонецЕсли;

		Если ЗначениеЗаполнено(ДатаПоставки) И НачалоДня(ПлановаяДатаЗаказа) < НачалоДня(ДатаСегодня) Тогда

			Шаблон = НСтр("ru = 'Недопустимо устанавливать в график дату поставки, дата заказа на которую просрочена%1. Если ближайшая поставка не запланирована, необходимо оставить дату пустой.';
							|en = 'Cannot schedule a delivery date, which order date %1 is overdue. If the closest delivery is not planned, leave the date empty.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, " (" + Формат(ПлановаяДатаЗаказа, "ДЛФ=D; ДП='или не определена'") + ")");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ПлановаяДатаПоставки");
			Отказ = Истина;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьТекстПоясняющихНадписей(Форма)

	Форма.ДатаФормированияЗаказаИнфо = "";
	Форма.ДатаОтгрузкиПоГарантированномуСрокуИнфо = "";
	Форма.ДатаБлижайшейПоставкиИнфо  = "";
	Форма.ГраницаОбеспечиваемогоПериодаИнфо = "";

	Если Форма.Объект.ФормироватьПлановыеЗаказы Тогда

		Форма.ДатаФормированияЗаказаИнфо        = Формат(Форма.Объект.ПлановаяДатаЗаказа,    "ДЛФ=D");
		Форма.ДатаБлижайшейПоставкиИнфо         = Формат(Форма.Объект.ПлановаяДатаПоставки,  "ДЛФ=D");
		Форма.ДатаОтгрузкиПоГарантированномуСрокуИнфо = Формат(Форма.Объект.ПлановаяДатаПоставки, "ДЛФ=D");
		Форма.ГраницаОбеспечиваемогоПериодаИнфо = Формат(Форма.Объект.ДатаСледующейПоставки, "ДЛФ=D");

	Иначе

		ГарантированныйСрок = ОпределитьДатуПоставкиПоДатеЗаказа(
			Форма.Объект.ГарантированныйСрокОтгрузки, Форма.Объект.ОбеспечиваемыйПериод);

		Длительность = ОпределитьДатуПоставкиПоДатеЗаказа(Форма.Объект.СрокИсполненияЗаказа, Форма.Объект.ОбеспечиваемыйПериод);
		Форма.ДатаФормированияЗаказаИнфо        = Формат(Форма.ДатаСегодня, "ДЛФ=D");
		Форма.ДатаБлижайшейПоставкиИнфо         = Длительность.ДатаПоставки;
		Форма.ДатаОтгрузкиПоГарантированномуСрокуИнфо = ГарантированныйСрок.ДатаПоставки;
		Форма.ГраницаОбеспечиваемогоПериодаИнфо = Длительность.ГраницаПериода;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовкиПоясняющихНадписей()

	НадписьРасчет = НСтр("ru = 'Расчет даты ближайшей возможной поставки и даты отгрузки при приеме заказов к обеспечению.';
						|en = 'Calculate earliest delivery date and shipment date when accepting orders to supply'");
	НадписьДатаОтгрузки = НСтр("ru = 'Дата отгрузки заказов к обеспечению:';
								|en = 'Shipment date of the orders to supply:'");

	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Покупка") Тогда

		НадписьДатаФормированияЗаказа = НСтр("ru = 'Дата формирования заказа поставщику:';
											|en = 'Date of purchase order placement'");
		НадписьДатаБлижайшейПоставки = НСтр("ru = 'Дата поступления по заказу:';
											|en = 'Date of receipt against the order:'");
		НадписьГраницаОбеспечиваемогоПериода = НСтр("ru = 'Обеспечиваемый период до:';
													|en = 'Covered period until:'");

	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение") Тогда

		НадписьДатаФормированияЗаказа = НСтр("ru = 'Дата формирования заказа на перемещение:';
											|en = 'Date of transfer order placement'");
		НадписьДатаБлижайшейПоставки = НСтр("ru = 'Дата окончания перемещения по заказу:';
											|en = 'Transfer end date against the order:'");
		НадписьГраницаОбеспечиваемогоПериода = НСтр("ru = 'Обеспечиваемый период до:';
													|en = 'Covered period until:'");

	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка") Тогда

		НадписьДатаФормированияЗаказа = НСтр("ru = 'Дата формирования заказа на сборку:';
											|en = 'Date of assembly order placement'");
		НадписьДатаБлижайшейПоставки = НСтр("ru = 'Дата окончания сборки по заказу:';
											|en = 'Assembly end date against the order:'");
		НадписьГраницаОбеспечиваемогоПериода = НСтр("ru = 'Обеспечиваемый период до:';
													|en = 'Covered period until:'");
	//++ НЕ УТ
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Производство") Тогда

		НадписьДатаФормированияЗаказа = НСтр("ru = 'Дата формирования заказа на производство:';
											|en = 'Date of production order placement:'");
		НадписьДатаБлижайшейПоставки = НСтр("ru = 'Дата выпуска продукции по заказу:';
											|en = 'Date of production against the order:'");
		НадписьГраницаОбеспечиваемогоПериода = НСтр("ru = 'Обеспечиваемый период до:';
													|en = 'Covered period until:'");

	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.ПроизводствоНаСтороне") Тогда

		НадписьДатаФормированияЗаказа = НСтр("ru = 'Дата формирования заказа переработчику:';
											|en = 'Date of tolling order generation:'");
		НадписьДатаБлижайшейПоставки = НСтр("ru = 'Дата поступления продукции по заказу:';
											|en = 'Date of product receipt against the order:'");
		НадписьГраницаОбеспечиваемогоПериода = НСтр("ru = 'Обеспечиваемый период до:';
													|en = 'Covered period until:'");
	//-- НЕ УТ
	КонецЕсли;

	Если Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы поставщику.';
										|en = 'This fulfillment method allows you to generate purchase orders.'");
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы на перемещение.';
										|en = 'This fulfillment method allows you to generate transfer orders.'");
		//++ НЕ УТ
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеПроизводством2_2") Тогда
			ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы на перемещение и заказы материалов в цеховые кладовые.';
											|en = 'This fulfillment method allows to generate transfer orders and orders for materials to shop storerooms.'");
		КонецЕсли;
		//-- НЕ УТ
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.СборкаРазборка Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы на сборку.';
										|en = 'This fulfillment method allows you to generate assembly orders.'");
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Производство Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы на производство.';
										|en = 'This fulfillment method allows you to generate production orders.'");
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.ПроизводствоНаСтороне Тогда
		ПояснениеТипаОбеспечения = НСтр("ru = 'Данный способ обеспечения позволяет формировать заказы переработчику.';
										|en = 'This fulfillment method allows you to generate tolling orders.'");
	Иначе
		ПояснениеТипаОбеспечения = "";
	КонецЕсли; 
	
	Элементы.ПояснениеТипОбеспечения.Заголовок = ПояснениеТипаОбеспечения;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоТипуОбеспечения()
	
	Если Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка Тогда
		
		Элементы.СтраницыРежимИспользования.Видимость = Истина;
		Элементы.СтраницыТипОбеспечения.Видимость     = Истина;
		
		Элементы.СтраницыРежимИспользования.ТекущаяСтраница = Элементы.СтраницаРежимИспользованияПокупка;
		Элементы.СтраницыТипОбеспечения.ТекущаяСтраница     = Элементы.СтраницаПокупка;
		Элементы.СтраницыСрокОбеспечения.ТекущаяСтраница    = Элементы.СтраницаСрокПокупки;
		
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение Тогда
		
		Элементы.СтраницыРежимИспользования.Видимость = Истина;
		Элементы.СтраницыТипОбеспечения.Видимость     = Истина;
		
		Элементы.СтраницыРежимИспользования.ТекущаяСтраница = Элементы.СтраницаРежимИспользованияПеремещение;
		Элементы.СтраницыТипОбеспечения.ТекущаяСтраница     = Элементы.СтраницаПеремещение;
		Элементы.СтраницыСрокОбеспечения.ТекущаяСтраница    = Элементы.СтраницаСрокПеремещения;
		
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.СборкаРазборка Тогда
		
		Элементы.СтраницыРежимИспользования.Видимость = Ложь;
		Элементы.СтраницыТипОбеспечения.Видимость     = Истина;
		
		Элементы.СтраницыТипОбеспечения.ТекущаяСтраница  = Элементы.СтраницаСборка;
		Элементы.СтраницыСрокОбеспечения.ТекущаяСтраница = Элементы.СтраницаСрокСборки;
		
	//++ НЕ УТ
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.Производство Тогда
		
		Элементы.СтраницыРежимИспользования.Видимость = Истина;
		Элементы.СтраницыТипОбеспечения.Видимость     = Ложь;
		
		Элементы.СтраницыРежимИспользования.ТекущаяСтраница = Элементы.СтраницаРежимИспользованияПроизводство;
		Элементы.СтраницыСрокОбеспечения.ТекущаяСтраница    = Элементы.СтраницаСрокПроизводства;
		
	ИначеЕсли Объект.ТипОбеспечения = Перечисления.ТипыОбеспечения.ПроизводствоНаСтороне Тогда
		
		Элементы.СтраницыРежимИспользования.Видимость = Истина;
		Элементы.СтраницыТипОбеспечения.Видимость     = Ложь;
		
		Элементы.СтраницыРежимИспользования.ТекущаяСтраница = Элементы.СтраницаРежимИспользованияПереработка;
		Элементы.СтраницыСрокОбеспечения.ТекущаяСтраница    = Элементы.СтраницаСрокПереработки;
	//-- НЕ УТ
	КонецЕсли;
	
	Элементы.Подразделение.Видимость = Объект.ТипОбеспечения <> Перечисления.ТипыОбеспечения.Производство;
	
	СформироватьЗаголовкиПоясняющихНадписей();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура АктивизироватьСтраницыРежимИспользования(Элементы, ОдинИсточник)
	
	Элементы.СтраницыРежимИспользованияПокупкаПояснение.ТекущаяСтраница = ?(ОдинИсточник,
		Элементы.РежимИспользованияОдинПоставщикПояснение, Элементы.РежимИспользованияНесколькоПоставщиковПояснение);
		
	Элементы.СтраницыРежимИспользованияПеремещениеПояснение.ТекущаяСтраница = ?(ОдинИсточник,
		Элементы.РежимИспользованияОдинСкладПояснение, Элементы.РежимИспользованияНесколькоСкладовПояснение);
	
	Элементы.Поставщик.Доступность = ОдинИсточник;
	Элементы.Склад.Доступность     = ОдинИсточник;
	
	Элементы.ВидЦеныПоставщика.Доступность = ОдинИсточник;
	Элементы.Соглашение.Доступность        = ОдинИсточник;
	
	//++ НЕ УТ
	Элементы.СтраницыРежимИспользованияПроизводствоПояснение.ТекущаяСтраница = ?(ОдинИсточник,
		Элементы.РежимИспользованияОдноПодразделениеДиспетчерПояснение,
		Элементы.РежимИспользованияНесколькоПодразделенийДиспетчеровПояснение);
		
	Элементы.СтраницыРежимИспользованияПереработкаПояснение.ТекущаяСтраница = ?(ОдинИсточник,
		Элементы.РежимИспользованияОдинПереработчикПояснение, Элементы.РежимИспользованияНесколькоПереработчиковПояснение);
	
	Элементы.ПодразделениеДиспетчер.Доступность = ОдинИсточник;
	Элементы.Переработчик.Доступность           = ОдинИсточник;
	//-- НЕ УТ
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура АктивизироватьСтраницыПравилоФормирования(Элементы, ФормироватьПлановыеЗаказы)
	
	Элементы.СтраницыОбеспечиваемыйПериод.ТекущаяСтраница = ?(ФормироватьПлановыеЗаказы,
		Элементы.СтраницаОбеспечиваемыйПериодНедоступен,
		Элементы.СтраницаОбеспечиваемыйПериод);
	
	Элементы.СтраницыДатыПоставок.ТекущаяСтраница = ?(ФормироватьПлановыеЗаказы,
		Элементы.СтраницаДатыПоставок,
		Элементы.СтраницаДатыПоставокНедоступны);
	
КонецПроцедуры

&НаКлиенте
Функция ТекстОшибкиСрокаИсполненияЗаказа()

	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение") Тогда
		Пояснение = НСтр("ru = 'Срок перемещения не может быть меньше длительности перемещения. Срок перемещения увеличен.';
						|en = 'Transfer period cannot be less than transfer duration. Transfer period is increased.'");
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка") Тогда
		Пояснение = НСтр("ru = 'Срок сборки не может быть меньше длительности сборки/разборки. Срок сборки увеличен.';
						|en = 'Assembly period cannot be less than assembly/disassembly duration. Assembly period is increased.'");
	Иначе
		Пояснение = "";
	КонецЕсли;

	Возврат Пояснение;

КонецФункции

&НаКлиенте
Процедура СкорректироватьСрокИсполненияЗаказа()

	Если Не Объект.ФормироватьПлановыеЗаказы
		И Объект.СрокИсполненияЗаказа < Объект.ДлительностьВДнях Тогда

		ТекстОшибки = ТекстОшибкиСрокаИсполненияЗаказа();
		Если ТекстОшибки <> "" Тогда

			ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение связанных реквизитов';
												|en = 'Change linked attributes'"),,ТекстОшибки);
			Объект.СрокИсполненияЗаказа = Объект.ДлительностьВДнях;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ТекстОшибкиГарантированногоСрокаОтгрузки()

	Если Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение") Тогда
		Пояснение = НСтр("ru = 'Гарантированный срок отгрузки не может быть меньше срока перемещения. Гарантированный срок отгрузки увеличен.';
						|en = 'Guaranteed shipment period cannot be less than transfer period. Guaranteed shipment period has been extended.'");
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка") Тогда
		Пояснение = НСтр("ru = 'Гарантированный срок отгрузки не может быть меньше срока сборки/разборки. Гарантированный срок отгрузки увеличен.';
						|en = 'Guaranteed shipment period cannot be less than assembly/disassembly period. Guaranteed shipment period has been extended.'");
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Покупка") Тогда
		Пояснение = НСтр("ru = 'Гарантированный срок отгрузки не может быть меньше срока покупки. Гарантированный срок отгрузки увеличен.';
						|en = 'Guaranteed shipment period cannot be less than purchase period. Guaranteed shipment period has been extended.'");
	//++ НЕ УТ
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Производство") Тогда
		Пояснение = НСтр("ru = 'Гарантированный срок отгрузки не может быть меньше срока производства. Гарантированный срок отгрузки увеличен.';
						|en = 'Guaranteed shipment period cannot be less than the production period. Guaranteed shipment period has been extended.'");
	ИначеЕсли Объект.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.ПроизводствоНаСтороне") Тогда
		Пояснение = НСтр("ru = 'Гарантированный срок отгрузки не может быть меньше срока переработки. Гарантированный срок отгрузки увеличен.';
						|en = 'Guaranteed shipment period cannot be less than the processing period. The guaranteed shipment period has been extended.'");
	//-- НЕ УТ
	Иначе
		Пояснение = "";
	КонецЕсли;

	Возврат Пояснение;

КонецФункции

&НаКлиенте
Процедура СкорректироватьГарантированныйСрокОтгрузки()

	Если Не Объект.ФормироватьПлановыеЗаказы
		И Объект.ГарантированныйСрокОтгрузки < Объект.СрокИсполненияЗаказа Тогда

		ТекстОшибки = ТекстОшибкиГарантированногоСрокаОтгрузки();
		Если ТекстОшибки <> "" Тогда

			ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение связанных реквизитов';
												|en = 'Change linked attributes'"),,ТекстОшибки);
			Объект.ГарантированныйСрокОтгрузки = Объект.СрокИсполненияЗаказа;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЗаполнитьСписокВыбораТипаОбеспечения()
	
	// Заполнение списка выбора доступных типов обеспечения.
	СписокВыбора = Новый СписокЗначений;
	
	// Заполняем возможные типы обеспечения в зависимости от функциональных опций.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.Покупка);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеТоваров")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаПеремещение")
		//++ НЕ УТ
		Или ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеПроизводством2_2")
		//-- НЕ УТ
		Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.Перемещение);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСборкуРазборку")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку") Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.СборкаРазборка, НСтр("ru = 'Сборка';
																				|en = 'Assembly'"));
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") 
		И ПолучитьФункциональнуюОпцию("УправлениеПредприятием") Тогда
		Представление = ?(ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоНаСтороне"), НСтр("ru = 'Собственное производство';
																								|en = 'Own production'"), НСтр("ru = 'Производство';
																																			|en = 'Manufacturing'"));
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.Производство, Представление);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоНаСтороне") Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.ПроизводствоНаСтороне);
	КонецЕсли;
	//-- НЕ УТ
	
	Для НомерПереключателя = 1 По 5 Цикл
		ИмяЭлемента = "ТипОбеспечения" + НомерПереключателя;
		Элементы[ИмяЭлемента].СписокВыбора.Очистить();
		Если НомерПереключателя <= СписокВыбора.Количество() Тогда
			ЗначениеВыбора = СписокВыбора.Получить(НомерПереключателя-1);
			Элементы[ИмяЭлемента].СписокВыбора.Добавить(ЗначениеВыбора.Значение, ЗначениеВыбора.Представление);
		Иначе
			Элементы[ИмяЭлемента].Видимость = Ложь;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат СписокВыбора;

КонецФункции

#КонецОбласти

#КонецОбласти
