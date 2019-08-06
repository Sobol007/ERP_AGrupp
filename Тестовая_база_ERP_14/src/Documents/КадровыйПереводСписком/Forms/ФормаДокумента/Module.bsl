
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ПриПолученииДанныхНаСервере(Объект);
		ЗаполнитьДанныеФормыПоОрганизации();
		
	КонецЕсли;
	
	Если Не КадровыйУчетРасширенный.ПравоИнтерактивногоСозданияКадровыхПриказовСотрудника() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Сотрудники",
			"ИзменятьСоставСтрок",
			Ложь);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОбработкаОповещенияИсправленногоДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	ЗарплатаКадрыРасширенный.ЗаблокироватьДокументДляРедактирования(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ПараметрыЗаписи.РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения
		И Не ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда
		
		Отказ = Истина;
		ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КадровыйПереводСписком", ПараметрыЗаписи, Объект.Ссылка);
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОповеститьОбИсправленииДокумента(Объект.Ссылка, Объект.ИсправленныйДокумент, ПараметрыЗаписи.РежимЗаписи, "ПериодическиеСведения");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	КадровыйУчетФормыРасширенный.ЗапуститьОтложеннуюОбработкуДанных(
		ТекущийОбъект, Метаданные.Документы.КадровыйПереводСписком.ТабличныеЧасти.Сотрудники.Реквизиты.Сотрудник);
	
	ДанныеВРеквизит();
	
	ПерерасчетЗарплаты.РегистрацияПерерасчетовПоПредварительнымДаннымВФоне(ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	
	Если РегистрацияНачисленийДоступна Тогда
		ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	Иначе
		ОчиститьТаблицыПриИзмененииКлючевыхРеквизитов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторСтроки = Элементы.Сотрудники.ТекущаяСтрока;
	РедактироватьСтроку(ИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	МаксимальныйИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника + 1;
	
	НоваяСтрока = Объект.Сотрудники.Добавить();
	НоваяСтрока.ИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника;
	
	Если Объект.Сотрудники.Количество() > 1 Тогда
		НоваяСтрока.ДатаНачала = Объект.Сотрудники[Объект.Сотрудники.Количество() - 2].ДатаНачала;
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(НоваяСтрока.ДатаНачала) Тогда
		НоваяСтрока.ДатаНачала = Объект.Дата;
	КонецЕсли; 
	
	ИдентификаторСтроки = НоваяСтрока.ПолучитьИдентификатор();
	
	Элементы.Сотрудники.ТекущаяСтрока = ИдентификаторСтроки;
	РедактироватьСтроку(ИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	
	УдаляемыйСотрудник = Элементы.Сотрудники.ТекущиеДанные.ИдентификаторСтрокиСотрудника;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПослеУдаления(Элемент)
	
	Если ЗначениеЗаполнено(УдаляемыйСотрудник) Тогда
		СотрудникиПослеУдаленияНаСервере();
	КонецЕсли; 
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СотрудникиОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "КадровыйПереводСписком");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "КадровыйПереводСписком");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "КадровыйПереводСписком");
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура ПодобратьСотрудников(Команда)
	
	ПараметрыОткрытия = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДатуПоПараметрамОткрытияФормыСписка(
		Элементы.Сотрудники,
		Объект.Организация,
		,
		Объект.Дата,
		Истина,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаСоответствиеШтатномуРасписанию(Команда)
	
	КадровыйУчетРасширенныйКлиент.ПроверитьНаСоответствиеШтатномуРасписанию(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровестиИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	ЗаписатьНаКлиенте(Истина, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровести(Команда)
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
	ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область КлючевыеРеквизитыЗаполненияФормы

&НаСервере
// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	Возврат ТаблицыОчищаемыеПриИзмененииКлючевыхРеквизитов();
	
КонецФункции

&НаСервере
// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация", Нстр("ru = 'организации';
																						|en = 'companies'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "ВидДоговора", Нстр("ru = 'вида договора';
																						|en = 'contract kind'")));
	
	Возврат Массив;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТаблицыОчищаемыеПриИзмененииКлючевыхРеквизитов()
	
	Массив = Новый Массив;
	Массив.Добавить("Объект.Сотрудники");
	
	Возврат Массив;
	
КонецФункции

&НаСервере
Процедура ОчиститьТаблицыПриИзмененииКлючевыхРеквизитов()
	
	ЗарплатаКадрыРасширенный.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма, ТаблицыОчищаемыеПриИзмененииКлючевыхРеквизитов());
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура СотрудникиПослеУдаленияНаСервере()

	ТабличныеЧасти = Новый Структура;
	ТабличныеЧасти.Вставить("Начисления");
	ТабличныеЧасти.Вставить("Показатели");
	ТабличныеЧасти.Вставить("ЕжегодныеОтпуска");
	ТабличныеЧасти.Вставить("Льготы");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплатаФормы");
		Модуль.КадровыйПереводСпискомДополнитьСписокОчищаемыхТабличныхЧастей(ТабличныеЧасти);
	КонецЕсли;
	
	СтруктураОписания = Новый Структура("ТабличныеЧасти", ТабличныеЧасти);
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УдалитьДанныеСотрудникаСписочногоДокумента(
		Объект, СтруктураОписания, УдаляемыйСотрудник);
	
	УдаляемыйСотрудник = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСтроку(ИдентификаторСтроки)
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьРасшифровку", ЭтотОбъект);
	
	ПараметрыОткрытия = ПараметрыОткрытияФормыРедактированияСтрокиДокумента(ИдентификаторСтроки);
	
	ЗарплатаКадрыРасширенныйКлиент.РедактироватьСтрокуСписочногоДокумента(
		ЭтаФорма, "Документ.КадровыйПеревод", Оповещение, ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРасшифровку(Результат, ДополнительныеУсловия) Экспорт
	
	УстановитьРасшифровкуСтроки(ИдентификаторСтроки);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	УправлениеШтатнымРасписаниемФормы.ПроверкаШтатногоРасписанияПодготовитьТаблицуФормы(ЭтаФорма, РеквизитыПроверяемыеНаСоответствие());
	
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтаФорма, Истина, Ложь);
	
	ДанныеВРеквизит();
	
	ОписаниеФормы = ОписаниеФормыРедактирующейДанныеКонтрактаДоговора();
	КонтрактыДоговорыСотрудниковФормы.НастроитьФормуПоВидуДоговора(ЭтотОбъект, ОписаниеФормы, Объект.ВидДоговора, Ложь);
	КонтрактыДоговорыСотрудниковФормы.ЗаполнитьСписокВыбораВидаДоговора(Элементы.ВидДоговора.СписокВыбора,"РаботникиИСлужащие"); 
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизит()
	
	ДоступноЧтениеДанныхДляНачисленияЗарплаты = Пользователи.РолиДоступны(
		"ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная,ЧтениеДанныхДляНачисленияЗарплатыРасширенная");
	
	// заполним предупреждения 
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
	УстановитьДоступностьРегистрацииНачислений();
	
	МаксимальныйИдентификаторСтрокиСотрудника = ЗарплатаКадрыРасширенный.МаксимальныйИдентификаторСтроки(
		Объект.Сотрудники, "ИдентификаторСтрокиСотрудника");
		
	ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма, "ПериодическиеСведения");
	ИсправлениеДокументовЗарплатаКадрыКлиентСервер.УстановитьПоляИсправления(ЭтаФорма, "ПериодическиеСведения");
	
	ЗарплатаКадрыРасширенный.МногофункциональныеДокументыДобавитьЭлементыФормы(ЭтаФорма, НСтр("ru = 'Приказом установлены ежемесячные начисления';
																								|en = 'Monthly accruals are set by the order'"), "РасчетчикГруппа", "НачисленияУтверждены");
	
	ЗаполнитьРасшифровкиСотрудников();
	
	ЗарплатаКадрыРасширенный.УстановитьВидимостьКомандПечатиМногофункциональногоДокумента(ЭтаФорма);
	
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтаФорма, "НачисленияУтверждены");
	
	Если ИспользуетсяРасчетЗарплаты И Не ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений И Объект.НачисленияУтверждены Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	КадровыйУчетФормыРасширенный.РазместитьКомандуПроверкиШтатномуРасписанию(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасшифровкиСотрудников()
	
	Для каждого СтрокаСотрудника Из Объект.Сотрудники Цикл
		УстановитьРасшифровкуСтроки(СтрокаСотрудника.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьРегистрацииНачислений()
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(Объект);
	РегистрацияНачисленийДоступна = ПраваНаДокумент.ПолныеПраваПоРолям;
	ОграниченияНаУровнеЗаписей = Новый ФиксированнаяСтруктура(ПраваНаДокумент.ОграниченияНаУровнеЗаписей);
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейМногофункциональныхДокументов(ЭтаФорма, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("РасчетчикГруппа"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасшифровкуСтроки(ИдентификаторСтрокиСотрудника)
	
	Если ИдентификаторСтрокиСотрудника = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтрокиСотрудника);
	
	СтрокаСотрудника.КоличествоСтавокПредставление = КадровыйУчетРасширенныйКлиентСервер.ПредставлениеКоличестваСтавок(СтрокаСотрудника.КоличествоСтавок);
	
	Расшифровка = РасшифровкаСтрокиСотрудника(ИдентификаторСтрокиСотрудника);
	СтрокаСотрудника.Расшифровка = Расшифровка;
	
КонецПроцедуры

&НаСервере
Функция РасшифровкаСтрокиСотрудника(ИдентификаторСтрокиСотрудника)
	
	СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтрокиСотрудника);
	
	СтруктураПоиска = Новый Структура("ИдентификаторСтрокиСотрудника", СтрокаСотрудника.ИдентификаторСтрокиСотрудника);
	ТекстРасшифровки = "";
	
	Если СтрокаСотрудника.ИзменитьПодразделениеИДолжность Тогда
		ТекстРасшифровки = НСтр("ru = 'Изменено рабочее место';
								|en = 'Workplace is changed'");
	КонецЕсли;
	
	Если СтрокаСотрудника.ИзменитьТерриторию Тогда
		ТекстРасшифровки = ?(ПустаяСтрока(ТекстРасшифровки), "", ТекстРасшифровки + "; ") + НСтр("ru = 'Изменена территория';
																								|en = 'Territory is changed'");
	КонецЕсли;
	
	Если СтрокаСотрудника.ИзменитьГрафикРаботы Тогда
		ТекстРасшифровки = ?(ПустаяСтрока(ТекстРасшифровки), "", ТекстРасшифровки + "; ") + НСтр("ru = 'Изменен график работы';
																								|en = 'Work schedule is changed'");
	КонецЕсли;
	
	Если СтрокаСотрудника.ИзменитьНачисления
		И Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная,ЧтениеДанныхДляНачисленияЗарплатыРасширенная") Тогда
		
		ТекстРасшифровки = ?(ПустаяСтрока(ТекстРасшифровки), "", ТекстРасшифровки + "; ") + НСтр("ru = 'Изменен состав начислений';
																								|en = 'Accruals are changed'") + ": ";
		ДобавитьЗапятую = Ложь;
		
		СтрокиНачислений = Объект.Начисления.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрокаНачисления Из СтрокиНачислений Цикл
			
			Если СтрокаНачисления.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить Тогда
				Продолжить;
			КонецЕсли; 
			
			Если ЗначениеЗаполнено(СтрокаНачисления.Начисление) Тогда
				
				ОсновнойОПоказатель = Неопределено;
				ИнфоОВидеРасчета = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(СтрокаНачисления.Начисление);
				Для каждого ПоказательНачисления Из ИнфоОВидеРасчета.Показатели Цикл
					
					Если ПоказательНачисления.ОсновнойПоказатель Тогда
						ОсновнойОПоказатель = ПоказательНачисления;
						Прервать;
					КонецЕсли; 
					
				КонецЦикла;
				
				Если ОсновнойОПоказатель <> Неопределено Тогда
					
					СтруктураПоиска.Вставить("ИдентификаторСтрокиВидаРасчета", СтрокаНачисления.ИдентификаторСтрокиВидаРасчета);
					СтруктураПоиска.Вставить("Показатель", ОсновнойОПоказатель.Показатель);
					СтрокиПоказателей = Объект.Показатели.НайтиСтроки(СтруктураПоиска);
					Если СтрокиПоказателей.Количество() > 0 Тогда
						
						Если ДобавитьЗапятую Тогда
							ТекстРасшифровки = ТекстРасшифровки + ", ";
						Иначе
							ДобавитьЗапятую = Истина;
						КонецЕсли;
						
						ТекстРасшифровки = ТекстРасшифровки
							+ ОсновнойОПоказатель.КраткоеНаименование + " = " + Формат(СтрокиПоказателей[0].Значение, "ЧДЦ=" + ОсновнойОПоказатель.Точность + "; ЧН=");
						
					КонецЕсли; 
					
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла;
		
	КонецЕсли; 
	
	Если СтрокаСотрудника.ИзменитьЕжегодныеОтпуска Тогда
		
		СтруктураПоиска = Новый Структура("ИдентификаторСтрокиСотрудника", СтрокаСотрудника.ИдентификаторСтрокиСотрудника);
		СтрокиОтпусков = Объект.ЕжегодныеОтпуска.НайтиСтроки(СтруктураПоиска);
		Если СтрокиОтпусков.Количество() > 0 Тогда
			ИнформацияОбОтпуске = ОстаткиОтпусков.НадписьПраваНаОтпуск(СтрокиОтпусков, Истина, 2);
			Если Не ПустаяСтрока(ИнформацияОбОтпуске) Тогда
				ТекстРасшифровки = ?(ПустаяСтрока(ТекстРасшифровки), "", ТекстРасшифровки + "; ") + ИнформацияОбОтпуске;
			КонецЕсли; 
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ПустаяСтрока(ТекстРасшифровки) Тогда
		ТекстРасшифровки = НСтр("ru = 'Нет сведений о кадровом переводе';
								|en = 'No information about employee transfer'");
	КонецЕсли; 
	
	Возврат ТекстРасшифровки;
	
КонецФункции

&НаСервере
Функция ОписанияТаблиц()
	
	ОписанияТаблиц = Новый Структура;
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыПлановыхНачислений(Истина, Ложь);
	ОписаниеТаблицыВидовРасчета.СодержитПолеХарактерНачисления = Истина;
	ОписанияТаблиц.Вставить("Начисления", ОписаниеТаблицыВидовРасчета);
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыПлановыхНачислений(Ложь, Ложь);
	ОписаниеТаблицыВидовРасчета.НомерТаблицы = 1;
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаДокументОснование = "";
	ОписанияТаблиц.Вставить("Льготы", ОписаниеТаблицыВидовРасчета);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплатаФормы");
		Модуль.КадровыйПереводДополнитьОписаниеТаблиц(ОписанияТаблиц);
	КонецЕсли;
	
	Возврат ОписанияТаблиц;
	
КонецФункции

&НаСервере
Функция ПараметрыОткрытияФормыРедактированияСтрокиДокумента(ИдентификаторСтроки)
	
	ТекущиеДанные = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ПараметрыОткрытия = ЗарплатаКадрыРасширенный.ПараметрыОткрытияФормыРедактированияСтрокиДокумента(Объект, ТекущиеДанные, "Документ.КадровыйПеревод");
	ПараметрыОткрытия.Вставить("АдресСпискаПодобранныхСотрудников", АдресСпискаПодобранныхСотрудников());
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСтрокуМногосотрудниковогоДокумента(Результат) Экспорт
	
	ТекущиеДанные = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтроки);
	ЗарплатаКадрыРасширенный.ЗаполнитьСтрокуМногосотрудниковогоДокумента(Результат, ТекущиеДанные, Объект, ОписанияТаблиц()); 
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиОбработкаВыбораНаСервере(ВыбранныеСотрудники)

	Если ТипЗнч(ВыбранныеСотрудники) = Тип("Массив") Тогда
		СписокСотрудников = ВыбранныеСотрудники;
	Иначе
		СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранныеСотрудники);
	КонецЕсли;
	
	ДобавляемыеСотрудники = Новый Массив;
	Для каждого Сотрудник Из СписокСотрудников Цикл
		
		Если Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник)).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавляемыеСотрудники.Добавить(Сотрудник);
		
	КонецЦикла;
	
	Если ДобавляемыеСотрудники.Количество() > 0 Тогда
		
		ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(Объект.Ссылка, ДобавляемыеСотрудники, Объект.Дата);
		
		СтрокаШаблон = Неопределено;
		Если Объект.Сотрудники.Количество() > 0 Тогда
			ПоследняяСтрокаСотрудников = Объект.Сотрудники[Объект.Сотрудники.Количество() - 1];
		КонецЕсли;
		
		ОписаниеДанныхПоследнейСтрокиСотрудника = Неопределено;
		Если ПоследняяСтрокаСотрудников <> Неопределено Тогда
			
			ОписаниеДанныхПоследнейСтрокиСотрудника = ЗарплатаКадрыРасширенныйВызовСервера.СтруктураПоМетаданным("Документ.КадровыйПеревод");
			ЗарплатаКадрыРасширенный.ЗаполнитьОбъектПоОбразцу(ОписаниеДанныхПоследнейСтрокиСотрудника, Объект, ПоследняяСтрокаСотрудников, "ИдентификаторСтрокиСотрудника");
			
		КонецЕсли;
		
		ДанныеСотрудников = КадровыйУчетФормыРасширенный.ДанныеДляКадровогоПеревода(ДобавляемыеСотрудники, ВремяРегистрацииСотрудников, Объект.Ссылка, ОписаниеДанныхПоследнейСтрокиСотрудника);
		Для каждого ДобавляемыйСотрудник Из ДобавляемыеСотрудники Цикл
			
			СведенияСотрудника = ДанныеСотрудников.Получить(ДобавляемыйСотрудник);
			Если СведенияСотрудника <> Неопределено Тогда
				
				МаксимальныйИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника + 1;
				
				НоваяСтрокаСотрудников = Объект.Сотрудники.Добавить();
				НоваяСтрокаСотрудников.ИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника;
				
				ЗарплатаКадрыРасширенный.ЗаполнитьСтрокуМногосотрудниковогоДокумента(
					СведенияСотрудника, НоваяСтрокаСотрудников, Объект, ОписанияТаблиц());
				
				УстановитьРасшифровкуСтроки(НоваяСтрокаСотрудников.ПолучитьИдентификатор());
				
			КонецЕсли;
			
		КонецЦикла;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверкаПередЗаписьюНаСервере(РезультатыПроверки, ДанныеОЗанятыхПозициях) Экспорт
	Возврат КадровыйУчетРасширенный.ПроверкаСоответствияШтатномуРасписанию(ДанныеОЗанятыхПозициях, Объект.Ссылка, Истина, РезультатыПроверки);
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеФормыПоОрганизации();
	ОчиститьТаблицыПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
	
КонецПроцедуры

#Область ЗаписьДокумента

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
	ЗаписатьНаКлиенте(Истина, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено)

	КадровыйУчетРасширенныйКлиент.ПередЗаписьюКадровогоДокументаВФорме(ЭтаФорма, Объект, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);  
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция ПолучитьДанныеОЗанятыхПозициях() Экспорт
	
	Возврат ПоместитьДанныеОЗанятыхПозицияхВоВременноеХранилище();
	
КонецФункции

&НаСервере
Функция ПоместитьДанныеОЗанятыхПозицияхВоВременноеХранилище()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Сотрудники", Объект.Сотрудники.Выгрузить());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Сотрудники.ДатаНачала КАК Период,
		|	Сотрудники.Сотрудник
		|ПОМЕСТИТЬ ВТСотрудникиПериоды
		|ИЗ
		|	&Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СотрудникиПериоды.Сотрудник
		|ИЗ
		|	ВТСотрудникиПериоды КАК СотрудникиПериоды";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОписательТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
			Запрос.МенеджерВременныхТаблиц, "ВТСотрудникиПериоды");
			
		Отборы = Новый Массив;
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
			Отборы, "Регистратор", "<>", Объект.Ссылка);
			
		ПоляОтбора = Новый Структура;
		ПоляОтбора.Вставить("КадроваяИсторияСотрудников", Отборы);
			
		КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательТаблиц, Истина, "Должность,ДолжностьПоШтатномуРасписанию,КоличествоСтавок", ПоляОтбора);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	КадровыеДанныеСотрудников.Период,
			|	КадровыеДанныеСотрудников.Сотрудник,
			|	КадровыеДанныеСотрудников.Должность,
			|	КадровыеДанныеСотрудников.ДолжностьПоШтатномуРасписанию,
			|	КадровыеДанныеСотрудников.КоличествоСтавок
			|ИЗ
			|	ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников";
			
		ДанныеСотрудников = Запрос.Выполнить().Выгрузить();
		
	Иначе
		ДанныеСотрудников = Неопределено;
	КонецЕсли; 
	
	ИспользуетсяШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	
	МассивНачислений = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Начисления, "Начисление", Истина);
	ЗначенияРеквизитаРассчитывается = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивНачислений, "Рассчитывается");
	
	СотрудникиДаты = Объект.Сотрудники.Выгрузить(, "ДатаНачала, Сотрудник");
	СотрудникиДаты.Колонки.ДатаНачала.Имя = "ДатаСобытия";
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Объект.Ссылка, СотрудникиДаты);
	
	МассивСотрудников = Новый Массив;
	Для каждого СтрокаСотрудники Из Объект.Сотрудники Цикл
		
		СтруктураДанныхСотрудника = УправлениеШтатнымРасписаниемКлиентСервер.СтруктураДанныхОЗанятыхПозициях(ТекущаяДатаСеанса());
		ЗаполнитьЗначенияСвойств(СтруктураДанныхСотрудника, СтрокаСотрудники);
		ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(СтрокаСотрудники.ДатаНачала);
		Если ВремяРегистрацииСотрудников <> Неопределено Тогда 
			СтруктураДанныхСотрудника.Период = ВремяРегистрацииСотрудников.Получить(СтрокаСотрудники.Сотрудник);
		КонецЕсли;
		СтруктураДанныхСотрудника.ПозицияШтатногоРасписания = ?(ИспользуетсяШтатноеРасписание, 
			СтрокаСотрудники.ДолжностьПоШтатномуРасписанию, СтрокаСотрудники.Должность);
		
		Если ДоступноЧтениеДанныхДляНачисленияЗарплаты Тогда
			
			ФОТ = 0;
			ДанныеОНачислениях = Новый Массив;
			СтрокиНачислений = Объект.Начисления.НайтиСтроки(Новый Структура("ИдентификаторСтрокиСотрудника", СтрокаСотрудники.ИдентификаторСтрокиСотрудника));
			Для каждого СтрокаНачислений Из СтрокиНачислений Цикл
				
				Если СтрокаНачислений.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокиПоказателей = Объект.Показатели.НайтиСтроки(Новый Структура("ИдентификаторСтрокиСотрудника,ИдентификаторСтрокиВидаРасчета", СтрокаНачислений.ИдентификаторСтрокиСотрудника, СтрокаНачислений.ИдентификаторСтрокиВидаРасчета));
				Если СтрокиПоказателей.Количество() = 0 Тогда
					
					СтруктураПоказателя = Новый Структура("Начисление,Показатель,Значение", СтрокаНачислений.Начисление);
					Если Не ЗначенияРеквизитаРассчитывается[СтрокаНачислений.Начисление] Тогда 
						СтруктураПоказателя.Значение = СтрокаНачислений.Размер;
					КонецЕсли;
					ДанныеОНачислениях.Добавить(СтруктураПоказателя);
					
				Иначе
					
					Для каждого СтрокаПоказателей Из СтрокиПоказателей Цикл
						СтруктураПоказателя = Новый Структура("Начисление,Показатель,Значение", СтрокаНачислений.Начисление, СтрокаПоказателей.Показатель, СтрокаПоказателей.Значение);
						ДанныеОНачислениях.Добавить(СтруктураПоказателя);
					КонецЦикла;
					
				КонецЕсли;
				ФОТ = ФОТ + СтрокаНачислений.Размер;
				
			КонецЦикла;
			
			СтруктураДанныхСотрудника.ФОТ = ФОТ;
			СтруктураДанныхСотрудника.Грейд = СтрокаСотрудники.Грейд;
			
		Иначе
			ДанныеОНачислениях = Неопределено;
		КонецЕсли;
		
		СтруктураДанныхСотрудника.ДанныеОНачислениях = ДанныеОНачислениях;
		
		МассивСотрудников.Добавить(СтруктураДанныхСотрудника);
		
		Если СтрокаСотрудники.ИзменитьПодразделениеИДолжность И ЗначениеЗаполнено(СтрокаСотрудники.ДатаОкончания) Тогда
			
			ЭлементДанных = УправлениеШтатнымРасписаниемКлиентСервер.СтруктураДанныхОЗанятыхПозициях(ТекущаяДатаСеанса());
			ЭлементДанных.Период = СтрокаСотрудники.ДатаОкончания;
			ЭлементДанных.Сотрудник = СтрокаСотрудники.Сотрудник;
			
			Если ДанныеСотрудников <> Неопределено Тогда
				
				ТекущиеДанные = ДанныеСотрудников.НайтиСтроки(Новый Структура("Период,Сотрудник", СтрокаСотрудники.ДатаНачала, СтрокаСотрудники.Сотрудник));
				
				Если ТекущиеДанные.Количество() > 0 Тогда
					ЭлементДанных.ПозицияШтатногоРасписания	= ?(ИспользуетсяШтатноеРасписание, СтрокаСотрудники.ДолжностьПоШтатномуРасписанию, СтрокаСотрудники.Должность);
					ЭлементДанных.КоличествоСтавок			= - СтрокаСотрудники.КоличествоСтавок;
				КонецЕсли; 
				
			КонецЕсли; 
				
			ЭлементДанных.ДанныеОНачислениях = Неопределено;
			МассивСотрудников.Добавить(ЭлементДанных);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(МассивСотрудников, Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыПроверяемыеНаСоответствие()
	
	РеквизитыПроверяемыеНаСоответствие = Новый Структура("РеквизитыШапки,ТабличныеЧасти", Новый Соответствие, Новый Соответствие);
	
	СтруктураОписанияТЧСотрудники = УправлениеШтатнымРасписаниемКлиентСервер.ОписаниеРеквизитовПроверяемыхНаСоответствие();
	СтруктураОписанияТЧСотрудники.СтруктураПоиска = Новый Структура("Сотрудник,ДолжностьПоШтатномуРасписанию");
	РеквизитНесоответствияСтроки = Новый Структура("ИмяРеквизита,ИмяРеквизитаНесоответствия", "ДолжностьПоШтатномуРасписанию", "ДолжностьПоШтатномуРасписаниюНеСоответствуетПозиции");
	СтруктураОписанияТЧСотрудники.РасшифровкаНачислений = Ложь;
	СтруктураОписанияТЧСотрудники.РеквизитНесоответствияСтроки = РеквизитНесоответствияСтроки;
	
	РеквизитыПроверяемыеНаСоответствие.ТабличныеЧасти.Вставить("Сотрудники", СтруктураОписанияТЧСотрудники);
	
	Возврат РеквизитыПроверяемыеНаСоответствие;
	
КонецФункции

&НаКлиенте
Функция РеквизитыПроверяемыеНаСоответствиеНаКлиенте() Экспорт
	Возврат РеквизитыПроверяемыеНаСоответствие();
КонецФункции

&НаСервере
Функция ОписаниеФормыРедактирующейДанныеКонтрактаДоговора()
	
	ОписаниеФормы = КонтрактыДоговорыСотрудниковФормы.ОписаниеФормыРедактирующейДанныеКонтрактаДоговора();
	ОписаниеФормы.Вставить("ИмяЭлементаПредставитель", 				"Руководитель");
	ОписаниеФормы.Вставить("ИмяЭлементаДолжностьПредставителя", 	"ДолжностьРуководителя");
	
	Возврат ОписаниеФормы;
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуПослеПодтвержденияЗаписи", ЭтотОбъект, Команда);
	ЗарплатаКадрыРасширенныйКлиент.ПоказатьДиалогЗаписиОбъектаДляВыполненияПодключаемойКоманды(ЭтотОбъект, Команда, ОписаниеОповещения);
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
Процедура ВыполнитьПодключаемуюКомандуПослеПодтвержденияЗаписи(РезультатВопроса, Команда) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
		ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
		Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

#КонецОбласти
