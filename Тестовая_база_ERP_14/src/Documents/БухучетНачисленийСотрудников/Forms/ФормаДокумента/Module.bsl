
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный",
			"Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если Не ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
			Объект.ДатаНачала = НачалоМесяца(Объект.Дата);
		КонецЕсли;
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СотрудникиДатаНачала", "Видимость", Объект.РазныеДатыДляСотрудников);
	
	СкрыватьДокументОснование = НачисленияСОбязательнымДокументом.Количество()=0 И НачисленияСНеОбязательнымДокументом.Количество()=0;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СотрудникиДокументОснование", "Видимость", Не СкрыватьДокументОснование);
	
	ОтражениеЗарплатыВБухучете.УстановитьСписокВыбораОтношениеКЕНВД(Элементы, "СотрудникиОтношениеКЕНВД");
	УстановитьУсловноеОформлениеСотрудники();

	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
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

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_БухучетПлановыхНачислений", ПараметрыЗаписи, Объект.Ссылка);
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
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазныеДатыДляСотрудниковПриИзменении(Элемент)
	
	Для каждого СтрокаТП Из Объект.Сотрудники Цикл
		СтрокаТП.ДатаНачала = Объект.ДатаНачала;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СотрудникиДатаНачала", "Видимость", Объект.РазныеДатыДляСотрудников);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование Тогда
		Элемент.ТекущиеДанные.ДокументОснование = Неопределено;
		Элемент.ТекущиеДанные.Начисление = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗаполнитьСотрудников(Команда)
	
	ОчиститьСообщения();
	ЗаполнитьСотрудниковНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСотрудников(Команда)
	
	Объект.Сотрудники.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	ПараметрыОткрытия = Неопределено;
			
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериодеПоПараметрамОткрытияФормыСписка(
		Элементы.Сотрудники,
		Объект.Организация, 
		Объект.Подразделение,
		Объект.ДатаНачала, 
		,
		Истина, 
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСведения(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация", Объект.Организация);
	ПараметрыОткрытия.Вставить("РазныеДатыДляСотрудников", Объект.РазныеДатыДляСотрудников);
	ПараметрыОткрытия.Вставить("ДатаНачалаПараметр", Объект.ДатаНачала);
	ПараметрыОткрытия.Вставить("НачисленияПараметрыВыбора", Элементы.СотрудникиНачисление.ПараметрыВыбора);
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьСведенияЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.БухучетНачисленийСотрудников.Форма.ФормаЗаполненияСведений",
				ПараметрыОткрытия, ЭтаФорма, Истина, , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДокументуНазначениеПлановогоНачисления(Команда)
	
	Если НЕ ФормаДокументаГотоваДляЗаполнения(ЭтаФорма, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоДокументуНазначениеПлановогоНачисленияЗавершение", ЭтотОбъект);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	Отбор = Новый Структура("Организация", Объект.Организация);
	ПараметрыОткрытия.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("Документ.НазначениеПлановогоНачисления.ФормаСписка",
		ПараметрыОткрытия, ЭтаФорма, ЭтаФорма,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
		
КонецПроцедуры


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
Процедура ПриПолученииДанныхНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	// заполним предупреждения 
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Начисления.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоПолутораЛет)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Начисления.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.ПоддерживаетНесколькоПлановыхНачислений
	|	И Начисления.КатегорияНачисленияИлиНеоплаченногоВремени <> ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаЗаСовмещение)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Начисления.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.ПоддерживаетНесколькоПлановыхНачислений
	|	И Начисления.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаЗаСовмещение)";
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	НачисленияПособия 					= Новый ФиксированныйМассив(РезультатЗапроса[0].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	НачисленияСНеОбязательнымДокументом = Новый ФиксированныйМассив(РезультатЗапроса[1].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	НачисленияСОбязательнымДокументом 	= Новый ФиксированныйМассив(РезультатЗапроса[2].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

#Область КлючевыеРеквизитыЗаполненияФормы

&НаСервере
// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить("Объект.Сотрудники");
	Массив.Добавить("Объект.ФизическиеЛица");
	
	Возврат Массив;
	
КонецФункции

&НаСервере
// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация", Нстр("ru = 'организации';
																						|en = 'companies'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Подразделение", Нстр("ru = 'подразделения';
																						|en = 'departments'")));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация", Объект.Организация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПодбораНаСервере(Знач Сотрудники)
	
	Модифицированность = Истина;
	
	Если ТипЗнч(Сотрудники) <> Тип("Массив") Тогда
		Сотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудники);
	КонецЕсли;
	
	Для Каждого Сотрудник Из Сотрудники Цикл
		
		СтрокиСотрудников = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		
		Если СтрокиСотрудников.Количество() = 0 Тогда
			НоваяСтрока = Объект.Сотрудники.Добавить();
			НоваяСтрока.Сотрудник = Сотрудник;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСотрудниковНаСервере()

	Если НЕ ФормаДокументаГотоваДляЗаполнения(ЭтаФорма, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Сотрудники.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация      = Объект.Организация;
	ПараметрыПолученияСотрудников.Подразделение    = Объект.Подразделение;
	ПараметрыПолученияСотрудников.НачалоПериода    = Объект.ДатаНачала;
	
	КадровыйУчетРасширенный.ПрименитьОтборПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(ПараметрыПолученияСотрудников);
	Объект.Сотрудники.Загрузить(КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудников));

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ФормаДокументаГотоваДляЗаполнения(Форма, СообщатьПользователю = Ложь)
	
	ФормаДокументаГотова = Истина;
	
	Если Не ЗначениеЗаполнено(Форма.Объект.Организация) Тогда
		ФормаДокументаГотова = Ложь;		
		Если СообщатьПользователю Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо указать организацию.';
																	|en = 'Specify company.'"), , "Организация");
		КонецЕсли;		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Форма.Объект.ДатаНачала) Тогда
		ФормаДокументаГотова = Ложь;		
		Если СообщатьПользователю Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо указать дату начала действия бухучета.';
																	|en = 'You must specify the date for commencement of accounting.'"), , "ДатаНачала");
		КонецЕсли;		
	КонецЕсли;
	
	Возврат ФормаДокументаГотова;
	
КонецФункции

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеСотрудники()
	
	Пособия = Новый СписокЗначений;
	Для каждого ЭлементМассива Из НачисленияПособия Цикл
		Пособия.Добавить(ЭлементМассива);
	КонецЦикла;
		
	ТекстПустогоЗначения = НСтр("ru = '<подбирается автоматически>';
								|en = '<selected automatically>'");
		
	// Таблица Сотрудники, поле СтатьяФинансирования.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// Вид оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстПустогоЗначения);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	// Оформляемое поле
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиСтатьяФинансирования");
	// условие для оформления
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.СтатьяФинансирования");
	
	// Таблица Сотрудники, поле СтатьяРасходов.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// Вид оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстПустогоЗначения);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	// Оформляемое поле
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиСтатьяРасходов");
	// Условие для оформления
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	// условие на заполнение СтатьиРасходов
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.СтатьяРасходов");
	// условие по категории начисления
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.Начисление");
	ЭлементОтбора.ПравоеЗначение = Пособия;
	
	// Таблица Сотрудники, поле СпособОтраженияЗарплатыВБухучете.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// Вид оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстПустогоЗначения);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	// Оформляемое поле
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиСпособОтраженияЗарплатыВБухучете");
	// Условие для оформления
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	// условие на заполнение СтатьиРасходов
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.СпособОтраженияЗарплатыВБухучете");
	// условие по категории начисления
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.Начисление");
	ЭлементОтбора.ПравоеЗначение = Пособия;
	
	// Таблица Сотрудники, поле ОтношениеКЕНВД.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// Вид оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстПустогоЗначения);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	// Оформляемое поле
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиОтношениеКЕНВД");
	// Условие для оформления
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	// условие на заполнение СтатьиРасходов
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.ОтношениеКЕНВД");
	// условие по категории начисления
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.Начисление");
	ЭлементОтбора.ПравоеЗначение = Пособия;
	
	
	ТекстПустогоЗначения = НСтр("ru = '<не заполняется>';
								|en = '<not filled in>'");

	// Таблица Сотрудники, оформление полей для пособий.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// Вид оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстПустогоЗначения);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	// Оформляемое поле
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиСтатьяРасходов");
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиСпособОтраженияЗарплатыВБухучете");
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиОтношениеКЕНВД");
	// Условие для оформления
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.Начисление");
	ЭлементОтбора.ПравоеЗначение = Пособия;
	
	ДокументОбязателен = Новый СписокЗначений;
	Для каждого ЭлементМассива Из НачисленияСОбязательнымДокументом Цикл
		ДокументОбязателен.Добавить(ЭлементМассива);
	КонецЦикла;
	
	// Таблица Сотрудники, оформление полей для НачисленияСДокументом.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// Вид оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	// Оформляемое поле
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиДокументОснование");
	// Условие для оформления
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.ДокументОснование");
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.Начисление");
	ЭлементОтбора.ПравоеЗначение = ДокументОбязателен;
	
	ДокументДоступен = Новый СписокЗначений;
	Для каждого ЭлементМассива Из НачисленияСНеОбязательнымДокументом Цикл
		ДокументДоступен.Добавить(ЭлементМассива);
	КонецЦикла;
	Для каждого ЭлементМассива Из НачисленияСОбязательнымДокументом Цикл
		ДокументДоступен.Добавить(ЭлементМассива);
	КонецЦикла;
	
	// Таблица Сотрудники, оформление полей для НачисленияСДокументом.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// Вид оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстПустогоЗначения);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	// Оформляемое поле
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СотрудникиДокументОснование");
	// Условие для оформления
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Сотрудники.Начисление");
	ЭлементОтбора.ПравоеЗначение = ДокументДоступен;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСведенияЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Или Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из Объект.Сотрудники Цикл
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, Результат);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДокументуНазначениеПлановогоНачисленияЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Сотрудники.Очистить();
	
	ЗаполнитьПоДокументуНазначениеПлановогоНачислениНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументуНазначениеПлановогоНачислениНаСервере(ДокументОснование)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НазначениеПлановогоНачисления.Начисление КАК Начисление,
	|	НазначениеПлановогоНачисления.Сотрудники.(
	|		Сотрудник КАК Сотрудник
	|	) КАК Сотрудники
	|ИЗ
	|	Документ.НазначениеПлановогоНачисления КАК НазначениеПлановогоНачисления
	|ГДЕ
	|	НазначениеПлановогоНачисления.Ссылка = &Ссылка";
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Начисление = Выборка.Начисление;
		
		ВыборкаСотрудники = Выборка.Сотрудники.Выбрать();
		Пока ВыборкаСотрудники.Следующий() Цикл
			НоваяСтрока = Объект.Сотрудники.Добавить();
			НоваяСтрока.Сотрудник = ВыборкаСотрудники.Сотрудник;
			НоваяСтрока.Начисление = Начисление;
			НоваяСтрока.ДокументОснование = ДокументОснование;
			Если Объект.РазныеДатыДляСотрудников Тогда
				НоваяСтрока.ДатаНачала = Объект.ДатаНачала;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("СотрудникиДокументОснованиеНачалоВыбораЗавершение", ЭтотОбъект);
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	
	Если НачисленияСОбязательнымДокументом.Найти(ТекущиеДанные.Начисление) <> Неопределено Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		Отбор = Новый Структура("Организация,Начисление,СовмещающийСотрудник", Объект.Организация, ТекущиеДанные.Начисление, ТекущиеДанные.Сотрудник);
		ПараметрыОткрытия.Вставить("Отбор", Отбор);
		
		ОткрытьФорму("Документ.Совмещение.ФормаСписка",
			ПараметрыОткрытия, ЭтаФорма, ЭтаФорма,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли НачисленияСНеОбязательнымДокументом.Найти(ТекущиеДанные.Начисление) <> Неопределено Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		ПараметрыОткрытия.Вставить("ИспользоватьОтборПоСотруднику", Истина);
		ПараметрыОткрытия.Вставить("СотрудникДляОтбора", ТекущиеДанные.Сотрудник);
		
		Отбор = Новый Структура("Организация,Начисление", Объект.Организация, ТекущиеДанные.Начисление);
		ПараметрыОткрытия.Вставить("Отбор", Отбор);
		
		ОткрытьФорму("Документ.НазначениеПлановогоНачисления.ФормаСписка",
			ПараметрыОткрытия, ЭтаФорма, ЭтаФорма,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДокументОснованиеНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Сотрудники.ТекущиеДанные.ДокументОснование = РезультатВыбора;

КонецПроцедуры

#КонецОбласти
