
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Ключ.Пустая() Тогда
		// создается новый документ
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Месяц", "Объект.ПериодРегистрации");
		ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
		ЗначенияДляЗаполнения.Вставить("Ответственный", "Объект.Ответственный");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		Объект.РасчетныйПериод = Год(Объект.ПериодРегистрации);
		
		ТекущийОбъект = РеквизитФормыВЗначение("Объект");
		
		ПриПолученииДанныхНаСервере(ТекущийОбъект);
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Ошибки = ПолучитьСообщенияПользователю(Истина);
	
	ЗарплатаКадрыОтображениеОшибок.ПреобразоватьПутиКДаннымВСообщенияхПользователю(
		ТекущийОбъект,
		ЭтотОбъект,
		Ошибки,
		СоответствиеДанныхОбъектаДанныхФормы());
		
	Для Каждого Сообщение Из Ошибки Цикл
		Если ВРег(Лев(Сообщение.Поле, 7)) = "ОБЪЕКТ." Тогда
			Сообщение.Поле = Сред(Сообщение.Поле, 8);
			Сообщение.ПутьКДанным = "Объект";
		ИначеЕсли  Не ЗначениеЗаполнено(Сообщение.ПутьКДанным) Тогда
			Сообщение.ПутьКДанным = Сообщение.Поле; 
			Сообщение.Поле = "";	
		КонецЕсли;	
		
		Сообщение.Сообщить();
	КонецЦикла;	
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "Объект");
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьПредставлениеМесяцаПолученияДоходаВСтрокахТаблиц();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_АктПроверкиСтраховыхВзносов", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РасчетныйПериодПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	РасчетныйПериодПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РасчетныйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	РасчетныйПериодПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	УстановитьФункциональныеОпцииФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
КонецПроцедуры
	
&НаКлиенте
Процедура ПериодРегистрацииСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура РасчетныйПериодПриИзмененииНаСервере()
	УстановитьФункциональныеОпцииФормы();	
	УстановитьВидимостьКолонокТаблиц();
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыВзносы

&НаКлиенте
Процедура ВзносыМесяцРасчетногоПериодаСтрокойПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.Взносы.ТекущиеДанные;
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ДанныеТекущейСтроки, "МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ВзносыМесяцРасчетногоПериодаСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДанныеТекущейСтроки = Элементы.Взносы.ТекущиеДанные;
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, ДанныеТекущейСтроки, "МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ВзносыМесяцРасчетногоПериодаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВзносыМесяцРасчетногоПериодаСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВзносыМесяцРасчетногоПериодаСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(элементы.Взносы.ТекущиеДанные, "МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ВзносыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ДобавитьПодобранныхФизическихЛицВТаблицу("Взносы", ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ВзносыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ПриИзмененииСоставаОчищаемойТаблицы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВзносыПослеУдаления(Элемент)
	ПриИзмененииСоставаОчищаемойТаблицы(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСведенияОДоходах

&НаКлиенте
Процедура СведенияОДоходахМесяцРасчетногоПериодаСтрокойПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.СведенияОДоходах.ТекущиеДанные;
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ДанныеТекущейСтроки, "МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахМесяцРасчетногоПериодаСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДанныеТекущейСтроки = Элементы.СведенияОДоходах.ТекущиеДанные;
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, ДанныеТекущейСтроки, "МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахМесяцРасчетногоПериодаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахМесяцРасчетногоПериодаСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахМесяцРасчетногоПериодаСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.СведенияОДоходах.ТекущиеДанные, "МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ДобавитьПодобранныхФизическихЛицВТаблицу("СведенияОДоходах", ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ПриИзмененииСоставаОчищаемойТаблицы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахПослеУдаления(Элемент)
	ПриИзмененииСоставаОчищаемойТаблицы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахЛьготныйТерриториальныйТарифПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.СведенияОДоходах.ТекущиеДанные;
	ДанныеТекущейСтроки.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ = ДанныеТекущейСтроки.ЛьготныйТерриториальныйТариф = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ДляЧленовЭкипажейМорскихСудовПодФлагомРФ")
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.СведенияОДоходах.ТекущиеДанные;
	Если ДанныеТекущейСтроки.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ Тогда
		ДанныеТекущейСтроки.ЛьготныйТерриториальныйТариф = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ДляЧленовЭкипажейМорскихСудовПодФлагомРФ")
	ИначеЕсли ДанныеТекущейСтроки.ЛьготныйТерриториальныйТариф = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ДляЧленовЭкипажейМорскихСудовПодФлагомРФ") Тогда
		ДанныеТекущейСтроки.ЛьготныйТерриториальныйТариф = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ПустаяСсылка")
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ПодборВзносы(Команда)
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(
		Элементы.Взносы, 
		Объект.Организация, 
		АдресСпискаПодобранныхСотрудников("Взносы"), 
		Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПодборДоходы(Команда)
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(
		Элементы.СведенияОДоходах, 
		Объект.Организация, 
		АдресСпискаПодобранныхСотрудников("СведенияОДоходах"), 
		Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	УстановитьФункциональныеОпцииФормы();
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");	
	
	ЗаполнитьПредставлениеМесяцаПолученияДоходаВСтрокахТаблиц();
	
	УстановитьВидимостьКолонокТаблиц();
	
	ОписаниеКлючевыхРеквизитов = КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов();
	ТаблицыОчищаемыеПриИзменении = КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении();
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма, , ОписаниеКлючевыхРеквизитов, ТаблицыОчищаемыеПриИзменении);
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма, ОписаниеКлючевыхРеквизитов);	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ПараметрыФО = Новый Структура;
	ПараметрыФО.Вставить("Организация", Объект.Организация);
	Если ЗначениеЗаполнено(Объект.РасчетныйПериод) Тогда	
		ПериодРасчета = Дата(Объект.РасчетныйПериод, 1, 1);
		ПараметрыФО.Вставить("Период", ПериодРасчета);
	Иначе
		ПараметрыФО.Вставить("Период", ТекущаяДатаСеанса());
	КонецЕсли;	
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКолонокТаблиц()
	Если ЗначениеЗаполнено(Объект.РасчетныйПериод) Тогда
		ПериодРасчета = Дата(Объект.РасчетныйПериод, 1, 1);
		УчетСтраховыхВзносов.УстановитьВидимостьКолонокТаблицыСтраховыхВзносов(ЭтотОбъект, ПериодРасчета, "Взносы");
		УчетСтраховыхВзносов.УстановитьВидимостьКолонокТаблицыСтраховыхВзносов(ЭтотОбъект, ПериодРасчета, "СведенияОДоходах");	
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьПредставлениеМесяцаПолученияДоходаВСтрокахТаблиц()
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.Взносы, "МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.СведенияОДоходах, "МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой");
КонецПроцедуры	

&НаКлиенте
Процедура ДобавитьПодобранныхФизическихЛицВТаблицу(ИмяТаблицы, СписокФизическихЛиц)
	Для Каждого ФизическоеЛицо Из СписокФизическихЛиц Цикл
		СтрокаТаблицы = Объект[ИмяТаблицы].Добавить();
		СтрокаТаблицы.ФизическоеЛицо = ФизическоеЛицо;
	КонецЦикла;	
	ПриИзмененииСоставаОчищаемойТаблицы(ЭтотОбъект);
КонецПроцедуры	

&НаСервере
Функция СоответствиеДанныхОбъектаДанныхФормы()
	СоответствиеДанных = ЗарплатаКадрыОтображениеОшибок.ОписаниеПодчиненностиДанныхФормы();
	
	ЗарплатаКадрыОтображениеОшибок.ДобавитьОписаниеСвязиРеквизитов(СоответствиеДанных, "ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	ЗарплатаКадрыОтображениеОшибок.ДобавитьОписаниеСвязиДанныхСтрокТаблиц(
		СоответствиеДанных,
		"СведенияОДоходах",
		"МесяцРасчетногоПериода",
		"Объект.СведенияОДоходах",
		"МесяцРасчетногоПериодаСтрокой");
		
	ЗарплатаКадрыОтображениеОшибок.ДобавитьОписаниеСвязиДанныхСтрокТаблиц(
		СоответствиеДанных,
		"Взносы",
		"МесяцРасчетногоПериода",
		"Объект.Взносы",
		"МесяцРасчетногоПериодаСтрокой");
				
	Возврат СоответствиеДанных;		
КонецФункции	

&НаСервере
Функция АдресСпискаПодобранныхСотрудников(ИмяТаблицы)
	
	Возврат ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор);
	
КонецФункции

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.Взносы");
	Массив.Добавить("Объект.СведенияОДоходах");
	
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация", НСтр("ru = 'организации';
																						|en = 'companies'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "РасчетныйПериод", НСтр("ru = 'периода';
																							|en = 'period'")));
	
	Возврат Массив
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииСоставаОчищаемойТаблицы(Форма)
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(Форма);	
КонецПроцедуры	

#КонецОбласти
