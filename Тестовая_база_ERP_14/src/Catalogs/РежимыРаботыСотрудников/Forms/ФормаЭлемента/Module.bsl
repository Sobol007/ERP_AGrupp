
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьНастройкиСпискаСпособовЗаполнения();
	
	Если Параметры.Ключ.Пустая() Тогда
		НомерТекущегоГода = Год(ТекущаяДатаСеанса());
		ЗаполнитьЗначенияПоУмолчанию();
		УстановитьОтображениеПолейСреднемесячныеНормыВремени();
		УстановитьДоступностьКомандыВводаШаблона(ЭтотОбъект);
	КонецЕсли;
		
	ОписаниеИспользуемыхВидовВремени = СписокВидовВремени.НайтиСтроки(Новый Структура("Использовать", Истина));
		
	НастроитьДоступностьЭлементов(ЭтаФорма);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Расписания, "РежимРаботы", Объект.Ссылка);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	НомерТекущегоГода = Год(ТекущаяДатаСеанса());
	ПрочитатьСреднемесячныеНормыВремени();
	УстановитьОтображениеПолейСреднемесячныеНормыВремени();
	УстановитьДоступностьКомандыВводаШаблона(ЭтотОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьСреднемесячныеНормыВремени();	
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
Процедура СуммированныйУчетРабочегоВремениПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовСуммированногоУчета(ЭтаФорма);
	
	Если НЕ Объект.СуммированныйУчетРабочегоВремени Тогда
		Объект.СпособОпределенияНормыСуммированногоУчета = ПредопределенноеЗначение("Перечисление.СпособыОпределенияНормыСуммированногоУчета.ПустаяСсылка");
		Объект.ГрафикНормыПриСуммированномУчете = ПредопределенноеЗначение("Справочник.ГрафикиРаботыСотрудников.ПустаяСсылка");
	Иначе
		Объект.СпособОпределенияНормыСуммированногоУчета = ПредопределенноеЗначение("Перечисление.СпособыОпределенияНормыСуммированногоУчета.ПоПроизводственномуКалендарю");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияНормыСуммированногоУчетаПриИзменении(Элемент)
	УстановитьДоступностьГрафикаНормыПриСуммированномУчете(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СреднемесячноеЧислоДнейПриИзменении(Элемент)
	СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную = Истина; 
	УстановитьОтображениеПолейСреднемесячныеНормыВремени();
КонецПроцедуры

&НаКлиенте
Процедура СреднемесячноеЧислоЧасовПриИзменении(Элемент)
	СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную = Истина;
	УстановитьОтображениеПолейСреднемесячныеНормыВремени();
КонецПроцедуры

&НаКлиенте
Процедура ВидГрафикаПриИзменении(Элемент)
	УстановитьДоступностьКомандыВводаШаблона(ЭтотОбъект);
	
	Если Объект.СпособЗаполнения <> ПредопределенноеЗначение("Перечисление.СпособыЗаполненияГрафиковРаботыСотрудников.ПоСменам") Тогда
		Объект.ШаблонЗаполнения.Очистить();
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПересчитатьСреднемесячныеЧислаЧасовИДней(Команда)
	ОбновитьСреднемесячныеНормыВремени();
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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
	
&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьДоступностьЭлементов(Форма)
	УстановитьДоступностьЭлементовСуммированногоУчета(Форма);	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовСуммированногоУчета(Форма)
		
	УстановитьДоступностьГрафикаНормыПриСуммированномУчете(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьГрафикаНормыПриСуммированномУчете(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГрафикНормыПриСуммированномУчете",
		"Доступность",
		Форма.Объект.СпособОпределенияНормыСуммированногоУчета = ПредопределенноеЗначение("Перечисление.СпособыОпределенияНормыСуммированногоУчета.ПоДаннымДругогоГрафика"));

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияПоУмолчанию()					
	Если Объект.ПроизводственныйКалендарь.Пустая() Тогда
		УстановитьПроизводственныйКалендарьПоУмолчанию();
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Объект.СпособЗаполнения) Тогда
		Объект.СпособЗаполнения = Перечисления.СпособыЗаполненияГрафиковРаботыСотрудников.ПоНеделям;
	КонецЕсли;	
	
	Если Объект.ДлительностьРабочейНедели = 0 Тогда
		Объект.ДлительностьРабочейНедели = 40;
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура УстановитьПроизводственныйКалендарьПоУмолчанию()	
	Объект.ПроизводственныйКалендарь = КалендарныеГрафики.ПроизводственныйКалендарьРоссийскойФедерации();	
КонецПроцедуры		
	
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеДанныхГрафика" Тогда
		ПриИзмененииДанныхГрафикаНаСервере(Параметр);		
	КонецЕсли;	
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Расписания, "РежимРаботы", Объект.Ссылка);
	Элементы.Расписания.Обновить();
	ПрочитатьСреднемесячныеНормыВремени();
КонецПроцедуры

&НаКлиенте
Процедура РасписанияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	
	Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
		ТекстСообщения = НСтр("ru = 'Перед началом добавления графиков, необходимо записать режим работы. Записать?';
								|en = 'Write operation mode before adding schedules. Write?'");
		Оповещение = Новый ОписаниеОповещения("ОбработкаОповещнияОЗаписиПриДобавленииГрафика", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
	Иначе
		СоздатьНовыйГрафик();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещнияОЗаписиПриДобавленииГрафика(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Записать();
		Если Не Объект.Ссылка.Пустая() Тогда
			СоздатьНовыйГрафик();
		КонецЕсли;	
	КонецЕсли;			
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйГрафик() Экспорт 
	ПараметрыГрафика = Новый Структура("РежимРаботы", Объект.Ссылка);
	ОткрытьФорму("Справочник.ГрафикиРаботыСотрудников.ФормаОбъекта", ПараметрыГрафика);
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЗаполнения(Команда)
	ТекущийШаблонЗаполнения = Новый Массив;
	Для Каждого СтрокаТаблицы Из Объект.ШаблонЗаполнения Цикл
		ТекущийШаблонЗаполнения.Добавить(СтрокаТаблицы.Смена);
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура("ШаблонЗаполнения", ТекущийШаблонЗаполнения);	
	ПараметрыОткрытия.Вставить("РежимРаботы", Объект.Ссылка);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеРедактированияШаблонаЗаполнения", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.РежимыРаботыСотрудников.Форма.ШаблонЗаполнения", ПараметрыОткрытия, ,,,,ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРедактированияШаблонаЗаполнения(Результат, ДполнительнеыПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Модифицированность = Истина;
		Объект.ШаблонЗаполнения.Очистить();
		Для Каждого Смена Из Результат Цикл
			СтрокаШаблона = Объект.ШаблонЗаполнения.Добавить();
			СтрокаШаблона.Смена = Смена;
			Если ЗначениеЗаполнено(Смена) Тогда
				СтрокаШаблона.ДеньВключенВГрафик = Истина;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;			
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСуществующийГрафик(Команда)
	Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
		ТекстСообщения = НСтр("ru = 'Перед началом добавления графиков, необходимо записать режим работы. Записать?';
								|en = 'Write operation mode before adding schedules. Write?'");
		Оповещение = Новый ОписаниеОповещения("ОбработкаОповещнияОЗаписиПриПодбореГрафика", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
	Иначе
		ОткрытьФормуПодбораГрафика();
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещнияОЗаписиПриПодбореГрафика(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Записать();
		Если Не Объект.Ссылка.Пустая() Тогда
			ОткрытьФормуПодбораГрафика();
		КонецЕсли;	
	КонецЕсли;			
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбораГрафика() Экспорт 
	ПараметрыОткрытияФормыВыбора = Новый Структура;
	ОтборГрафиков = Новый Структура("РежимРаботы", ПредопределенноеЗначение("Справочник.РежимыРаботыСотрудников.ПустаяСсылка"));
	ПараметрыОткрытияФормыВыбора.Вставить("Отбор", ОтборГрафиков);
	ПараметрыОткрытияФормыВыбора.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормыВыбора.Вставить("МножественныйВыбор", Ложь);
	
	ОткрытьФорму("Справочник.ГрафикиРаботыСотрудников.ФормаСписка", ПараметрыОткрытияФормыВыбора, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ГрафикиРаботыСотрудников") Тогда
		УстановитьРежимРаботыГрафику(ВыбранноеЗначение);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимРаботыГрафику(График)
	ГрафикОбъект = График.ПолучитьОбъект();
	
	Попытка 
		ГрафикОбъект.Заблокировать();
	Исключение
		ТекстИсключенияЗаписи = НСтр("ru = 'Не удалось изменить график работы.
				|Возможно, график работы редактируется другим пользователем';
				|en = 'Cannot change the work schedule.
				|Perhaps, the work schedule is being edited by another user'");
		ВызватьИсключение ТекстИсключенияЗаписи;
	КонецПопытки;	
	
	Если ЗначениеЗаполнено(ГрафикОбъект.РежимРаботы) Тогда
		ТекстИсключенияЗаписи = НСтр("ru = 'График относится к другому режиму работы';
									|en = 'Schedule refers to another operation mode'");
		ВызватьИсключение ТекстИсключенияЗаписи;
	КонецЕсли;
	
	ГрафикОбъект.РежимРаботы = Объект.Ссылка;
	ГрафикОбъект.Записать();
	
	Элементы.Расписания.Обновить();	
КонецПроцедуры	

&НаСервере
Процедура ПрочитатьСреднемесячныеНормыВремени()
	ДанныеСреднемесячныеНормыВремени = ДанныеСреднемесячныеНормыВремениГрафиковРаботыСотрудников(Объект.Ссылка, НомерТекущегоГода);
	ЗаполнитьЗначенияСвойств(СреднемесячныеНормыВремениГрафиковРаботыСотрудников, ДанныеСреднемесячныеНормыВремени);
	СреднемесячныеНормыВремениГрафиковРаботыСотрудниковПрежняя = Новый ФиксированнаяСтруктура(ДанныеСреднемесячныеНормыВремени);
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьСреднемесячныеНормыВремени()
	Если ДанныеСреднемесячнойНормыОтредактированы(ЭтотОбъект) Тогда
		Если СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную Тогда
			ДанныеОСреднемесячнойНормеЗаписи = РеквизитФормыВЗначение("СреднемесячныеНормыВремениГрафиковРаботыСотрудников");
			ДанныеОСреднемесячнойНормеЗаписи.Записать();
		Иначе 
			УчетРабочегоВремениРасширенный.ОбновитьСреднемесячныеНормыПоРежимуРаботы(Объект.Ссылка, НомерТекущегоГода, Истина);
		КонецЕсли;				
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Функция ДанныеСреднемесячныеНормыВремениГрафиковРаботыСотрудников(ГрафикРаботыСотрудников, Знач Год)
	
	Год = ?(Год = 0, 1, Год);
	
	СтруктураЗаписи = Справочники.ГрафикиРаботыСотрудников.СреднемесячныеНормыВремени(ГрафикРаботыСотрудников, Дата(Год, 1, 1));
	Если Не ЗначениеЗаполнено(СтруктураЗаписи.Год) Тогда
		СтруктураЗаписи.Год = Год;
	КонецЕсли; 
	
	Возврат СтруктураЗаписи;

КонецФункции

&НаСервере
Процедура УстановитьОтображениеПолейСреднемесячныеНормыВремени()

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПересчитатьСреднемесячныеЧислаЧасовИДней",
		"Видимость",
		СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную);
	
	Если СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную Тогда
		ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	Иначе
		ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.Отображать;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СреднемесячныеНормыВремениГрафиковРаботыСотрудниковСреднемесячноеЧислоЧасов",
		"ОтображениеПредупрежденияПриРедактировании",
		ОтображениеПредупреждения);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СреднемесячныеНормыВремениГрафиковРаботыСотрудниковСреднемесячноеЧислоДней",
		"ОтображениеПредупрежденияПриРедактировании",
		ОтображениеПредупреждения);
		
КонецПроцедуры

&НаКлиенте
Процедура ГодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ДанныеСреднемесячнойНормыОтредактированы(ЭтотОбъект) Тогда
		Если Объект.Ссылка.Пустая() Тогда
			ТекстВопроса = НСтр("ru = 'Данные о среднемесячной нормы были отредактированы. Для сохранения данных, необходимо записать режим работы. 
	                             |Записать?';
	                             |en = 'Average monthly standard data was edited. To save the data, write the operation mode.
	                             |Write?'");
			
			Оповещение = Новый ОписаниеОповещения("НомерТекущегоГодаДляНовогоРежимаРаботыРегулированиеЗавершение", ЭтотОбъект, Направление);					
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		Иначе
			ТекстВопроса = НСтр("ru = 'Данные о среднемесячной нормы были отредактированы. 
	                             |Сохранить изменения?';
	                             |en = 'Average monthly standard data was edited.
	                             |Save changes?'");
			
			Оповещение = Новый ОписаниеОповещения("НомерТекущегоГодаРаботыРегулированиеЗавершение", ЭтотОбъект, Направление);					
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);	
		КонецЕсли;	
	Иначе
		НомерТекущегоГода = НомерТекущегоГода + 1 * Направление;
		ПрочитатьСреднемесячныеНормыВремени();
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура НомерТекущегоГодаРаботыРегулированиеЗавершение(Ответ, Направление) Экспорт 
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьСреднемесячныеНормыВремени();	
	КонецЕсли;
	
	НомерТекущегоГода = НомерТекущегоГода + 1 * Направление;
	ПрочитатьСреднемесячныеНормыВремени();	
КонецПроцедуры

&НаКлиенте
Процедура НомерТекущегоГодаДляНовогоРежимаРаботыРегулированиеЗавершение(Ответ, Направление) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Записать();
	
		Если Не Объект.Ссылка.Пустая() Тогда
			ЗаписатьСреднемесячныеНормыВремени();;
		КонецЕсли;	
	КонецЕсли;
		
	НомерТекущегоГода = НомерТекущегоГода + 1 * Направление;
	ПрочитатьСреднемесячныеНормыВремени();	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДанныеСреднемесячнойНормыОтредактированы(Форма)
	СреднемесячныеНормыВремениГрафиковРаботыСотрудников = Форма.СреднемесячныеНормыВремениГрафиковРаботыСотрудников;
	СреднемесячныеНормыВремениГрафиковРаботыСотрудниковПрежняя = Форма.СреднемесячныеНормыВремениГрафиковРаботыСотрудниковПрежняя;
	
	Если  СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную Тогда
		Возврат (СреднемесячныеНормыВремениГрафиковРаботыСотрудников.СреднемесячноеЧислоЧасов <> СреднемесячныеНормыВремениГрафиковРаботыСотрудниковПрежняя.СреднемесячноеЧислоЧасов
				 Или СреднемесячныеНормыВремениГрафиковРаботыСотрудников.СреднемесячноеЧислоДней <> СреднемесячныеНормыВремениГрафиковРаботыСотрудниковПрежняя.СреднемесячноеЧислоДней);
				 
	ИначеЕсли СреднемесячныеНормыВремениГрафиковРаботыСотрудниковПрежняя <> Неопределено
		И СреднемесячныеНормыВремениГрафиковРаботыСотрудниковПрежняя.УстановленыВРучную Тогда
		
		Возврат Истина;
	Иначе 	
		Возврат Ложь;
	КонецЕсли;					 
КонецФункции	

&НаСервере
Процедура ОбновитьСреднемесячныеНормыВремени()
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Справочники.РежимыРаботыСотрудников.СоздатьВТСреднемесячныеНормыВремени(Запрос.МенеджерВременныхТаблиц, Объект.Ссылка, НомерТекущегоГода);
	
	Запрос.Текст = "ВЫБРАТЬ * ИЗ ВТСреднемесячныеНормыВремени";
	Выборка = Запрос.Выполнить().Выбрать();	
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СреднемесячныеНормыВремениГрафиковРаботыСотрудников, Выборка);
		СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную = Ложь;
	Иначе
		СреднемесячныеНормыВремениГрафиковРаботыСотрудников.СреднемесячноеЧислоДней = 0;
		СреднемесячныеНормыВремениГрафиковРаботыСотрудников.СреднемесячноеЧислоЧасов = 0;
	КонецЕсли;	
	
	СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную = Ложь;
	УстановитьОтображениеПолейСреднемесячныеНормыВремени();	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииДанныхГрафикаНаСервере(График)
	Если Объект.Ссылка.Пустая() Тогда 
		Возврат;
	КонецЕсли;	
	
	РежимРаботы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(График, "РежимРаботы");
	
	Если РежимРаботы = Объект.Ссылка 
		И Не СреднемесячныеНормыВремениГрафиковРаботыСотрудников.УстановленыВРучную Тогда
		
		ОбновитьСреднемесячныеНормыВремени();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиСпискаСпособовЗаполнения()
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСменыРаботыСотрудников") Тогда
		Элементы.ВидГрафика.СписокВыбора.Добавить(Перечисления.СпособыЗаполненияГрафиковРаботыСотрудников.ПоСменам, НСтр("ru = 'По сменам';
																														|en = 'By shifts'"));
	КонецЕсли;
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандыВводаШаблона(Форма)
	Если Форма.Объект.СпособЗаполнения = ПредопределенноеЗначение("Перечисление.СпособыЗаполненияГрафиковРаботыСотрудников.ПоСменам") Тогда
		Форма.Элементы.ШаблонЗаполнения.Видимость = Истина;
	Иначе
		Форма.Элементы.ШаблонЗаполнения.Видимость = Ложь;
	КонецЕсли;		
КонецПроцедуры	

#КонецОбласти
