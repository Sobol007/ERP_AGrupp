#Область ОписаниеПеременных

&НаКлиенте
Перем ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, МесяцРасчета", 
								"Объект.Организация", "Объект.Ответственный", "Объект.ПериодРегистрации");
		
		Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
		КонецЕсли;

		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		ЗаполнитьДанныеФормыПоОрганизации();
	КонецЕсли;

	УчетРабочегоВремениРасширенныйФормы.ТабельПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "ДанныеОВремениСотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УчетРабочегоВремениРасширенныйФормы.ТабельПриЧтенииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УчетРабочегоВремениРасширенныйФормы.ТабельПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УчетРабочегоВремениРасширенныйФормы.ТабельПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи); 
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ПерерасчетЗарплаты.РегистрацияПерерасчетовПоПредварительнымДаннымВФоне(ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки, "ПроведениеДокументаТабельУчетаРабочегоВремени");
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОповеститьОбИсправленииДокумента(Объект.Ссылка, Объект.ИсправленныйДокумент, ПараметрыЗаписи.РежимЗаписи);
	Оповестить("Запись_ТабельУчетаРабочегоВремени", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	УчетРабочегоВремениРасширенныйКлиент.ТабельОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
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
Процедура ОрганизацияПриИзменении(Элемент)
	
	УчетРабочегоВремениРасширенныйКлиент.ТабельОрганизацияПриИзменении(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПериодРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодВводаДанныхОВремениПриИзменении(Элемент)
	ПериодВводаДанныхОВремениПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаПриИзменении(Элемент)
	
	Если НачалоМесяца(Объект.ДатаНачалаПериода) <> НачалоМесяца(Объект.ДатаОкончанияПериода) Тогда
		Объект.ДатаОкончанияПериода = КонецМесяца(Объект.ДатаНачалаПериода);
	КонецЕсли;
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПериодаПриИзменении(Элемент)
	
	Если НачалоМесяца(Объект.ДатаНачалаПериода) <> НачалоМесяца(Объект.ДатаОкончанияПериода) Тогда
		Объект.ДатаОкончанияПериода = КонецМесяца(Объект.ДатаНачалаПериода);
	КонецЕсли;
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", Модифицированность);
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", Направление, Модифицированность);
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВысотаСтрокиПриИзменении(Элемент)
	УчетРабочегоВремениРасширенныйКлиент.ТабельВысотаСтрокиПриИзменении(ЭтаФорма);
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеОВремени

&НаКлиенте
Процедура ДанныеОВремениПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	УчетРабочегоВремениРасширенныйКлиент.ТабельДанныеОВремениПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа)
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	УдалитьСтрокиПоСотруднику(Элементы.ДанныеОВремени.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	УчетРабочегоВремениРасширенныйКлиент.ТабельДанныеОВремениПередОкончаниемРедактирования(ЭтаФорма, Элемент, НоваяСтрока, ОтменаРедактирования, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	УчетРабочегоВремениРасширенныйКлиент.ТабельДанныеОВремениВремяПредставлениеОкончаниеВводаТекста(ЭтаФорма, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	УчетРабочегоВремениРасширенныйКлиент.ТабельДанныеОВремениВремяПредставлениеАвтоПодбор(ЭтаФорма, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	УчетРабочегоВремениРасширенныйКлиент.ТабельДанныеОВремениВремяПредставлениеОбработкаВыбора(ЭтаФорма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УчетРабочегоВремениРасширенныйКлиент.ТабельДанныеОВремениПредставлениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Элемент);
КонецПроцедуры

#КонецОбласти

// Обработчик подсистемы "ПодписиДокументов".
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент) 
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтаФорма, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент) 
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтаФорма, Элемент.Имя);
КонецПроцедуры
// Конец Обработчик подсистемы "ПодписиДокументов".

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

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ТабельУчетаРабочегоВремени");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Сторнировать(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Сторнировать(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ТабельУчетаРабочегоВремени");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ТабельУчетаРабочегоВремени");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКСторно(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКСторно(ЭтаФорма.ДокументСторно);
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура Заполнить(Команда) Экспорт
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ЗаполнениеДокументаТабельУчетаРабочегоВремени");	
	
	ОчиститьСообщения();
	
	ЗаполнитьСотрудникамиОрганизацииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПодборСотрудникаВФормеДокументаТабельУчетаРабочегоВремени");
	
	УчетРабочегоВремениРасширенныйКлиент.ТабельПодбор(ЭтаФорма, АдресСпискаПодобранныхСотрудников());
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	УчетРабочегоВремениРасширенныйКлиент.ТабельПереместитьСтрокуВверх(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	УчетРабочегоВремениРасширенныйКлиент.ТабельПереместитьСтрокуВниз(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию(Команда)
	СортироватьПоВозрастаниюНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию(Команда)
	СортироватьПоУбываниюНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьОписаниеВидовВремени() Экспорт
	УчетРабочегоВремениРасширенныйФормы.ТабельПоместитьОписаниеВидовВремениВДанныеФормы(ЭтаФорма);	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПодбораНаСервере(Сотрудники)
	УчетРабочегоВремениРасширенныйФормы.ТабельОбработкаПодбора(ЭтаФорма, Сотрудники);
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСотрудникамиОрганизацииНаСервере()
	УчетРабочегоВремениРасширенныйФормы.ТабельЗаполнитьСотрудникамиОрганизации(ЭтаФорма);
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеПоСотрудникуНаСервере()
	УчетРабочегоВремениРасширенныйФормы.ТабельЗаполнитьДанныеПоСотруднику(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениСотрудникПриИзменении(Элемент)
	ЗаполнитьДанныеПоСотрудникуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПериодРегистрацииПриИзменении()
	УчетРабочегоВремениРасширенныйФормы.ТабельПериодРегистрацииПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПериодВводаДанныхОВремениПриИзмененииНаСервере()
	УчетРабочегоВремениРасширенныйФормы.ТабельПериодВводаДанныхОВремениПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиПоСотруднику(Знач УдаляемыеСтроки)
	Для Каждого ИдентификаторУдаляемойСтроки Из УдаляемыеСтроки Цикл
		УчетРабочегоВремениРасширенныйФормы.ТабельУдалитьСтрокиПоСотруднику(ЭтаФорма, ИдентификаторУдаляемойСтроки);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьВысотуСтрокНаСервере() Экспорт
	УчетРабочегоВремениРасширенныйФормы.ТабельУстановитьВысотуСтрокПоСотрудникам(ЭтаФорма, УстанавливаемаяВысотаСтроки);
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ДанныеОВремени.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеФормыПоОрганизации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ЗапрашиваемыеЗначения = Новый Структура("Организация, МесяцРасчета", "Объект.Организация", "Объект.ПериодРегистрации");
	ЗарплатаКадры.ЗаполнитьОтветственныхРаботниковОрганизацииВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой");
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаСервере
Процедура СортироватьПоВозрастаниюНаСервере()
	УчетРабочегоВремениРасширенныйФормы.ДанныеОВремениСортироватьПоВозрастанию(Объект.ДанныеОВремени);
КонецПроцедуры

&НаСервере
Процедура СортироватьПоУбываниюНаСервере()
	УчетРабочегоВремениРасширенныйФормы.ДанныеОВремениСортироватьПоУбыванию(Объект.ДанныеОВремени);
КонецПроцедуры

#КонецОбласти
