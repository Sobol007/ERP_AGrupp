
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеСписка();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Параметры.Свойство("СотрудникСсылка", СотрудникСсылка);
	
	Если ЗначениеЗаполнено(СотрудникСсылка) Тогда
		
		КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СотрудникСсылка, "ГоловнаяОрганизация,ФизическоеЛицо,ТекущаяОрганизация");
		Если КадровыеДанныеСотрудников.Количество() > 0 Тогда
			
			ДанныеСотрудника = КадровыеДанныеСотрудников[0];
			
			Организация = ДанныеСотрудника.ТекущаяОрганизация;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "ГоловнаяОрганизация", ДанныеСотрудника.ГоловнаяОрганизация);
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ФизическоеЛицо", ДанныеСотрудника.ФизическоеЛицо, Истина);
			УстановитьТипыОбъектовОповещения();
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"Сотрудник",
				"Видимость",
				Ложь);
			
			Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеСотрудника.ГоловнаяОрганизация, "ЕстьОбособленныеПодразделения") Тогда
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы,
					"Организация",
					"Видимость",
					Ложь);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтруктураПараметровОтбора = Новый Структура();
		ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ФизическоеЛицо",
			Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), НСтр("ru = 'Сотрудник';
																		|en = 'Employee'"));
		ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "Подразделение",
			Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"), НСтр("ru = 'Подразделение';
																					|en = 'Department'"));
		
		ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,
			СтруктураПараметровОтбора, "СписокКритерииОтбора");
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаУтвердить", "Видимость", Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ДобавлениеИзменениеНачисленнойЗарплатыРасширенная"));
			
	ЗарплатаКадрыРасширенный.СформироватьПодменюСоздатьФормыСпискаДокументов(ЭтаФорма, "ЖурналДокументов.КадровыеДокументы");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ШтрихкодыБольничныхЛистов") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ШтрихкодыБольничныхЛистов");
		Модуль.НастроитьСканерШтрихкода(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ШтрихкодыБольничныхЛистов") Тогда 
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ШтрихкодыБольничныхЛистовКлиент");
		Модуль.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ШтрихкодыБольничныхЛистов") Тогда 
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ШтрихкодыБольничныхЛистовКлиент");
		Модуль.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ШтрихкодыБольничныхЛистов") Тогда 
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ШтрихкодыБольничныхЛистовКлиент");
		Модуль.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	
	ОписаниеИзменения = ЗарплатаКадрыКлиент.ОписаниеИзмененияПараметраОтбораДинамическогоСписка(ЭтотОбъект, Элемент.Имя);
	
	Если ОписаниеИзменения.ИмяПараметра = "ФизическоеЛицо" Тогда
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "УстановкаОтбораПоСотрудникуЖурналаДокументовКадровыеДокументы");
	ИначеЕсли ОписаниеИзменения.ИмяПараметра = "Подразделение" Тогда
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "УстановкаОтбораПоПодразделениюЖурналаДокументовКадровыеДокументы");
	КонецЕсли;
	
	ЗарплатаКадрыКлиент.УстановитьПараметрДинамическогоСпискаПоОписаниюИзменения(ЭтотОбъект, ОписаниеИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьДоступностьКомандыУтвердитьВМногофункциональныхДокументах(ЭтотОбъект);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗначениеЗаполнено(СотрудникСсылка) Тогда
		
		Если Параметр = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыОткрытия = Новый Структура;
		
		ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
		
		Отказ = Истина;
		ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	Если Не ЗначениеЗаполнено(СотрудникСсылка) Тогда
		ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СотрудникСсылка) Тогда
		ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Утвердить(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.УтвердитьВыделенныеМногофункциональныеДокументы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	Если ЗначениеЗаполнено(СотрудникСсылка) Тогда
		
		ДополнительныеЗначенияЗаполнения = Новый Структура("Сотрудник", СотрудникСсылка);
		Если ЗначениеЗаполнено(Организация) Тогда
			ДополнительныеЗначенияЗаполнения.Вставить("Организация", Организация);
		КонецЕсли;
		
	Иначе
		ПараметрыОткрытия = Новый Структура;
		ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, КомандыСозданияДокументов.Получить(Команда.Имя).ПолноеИмя);
		ДополнительныеЗначенияЗаполнения = ПараметрыОткрытия.ЗначенияЗаполнения;
	КонецЕсли; 
	
	ЗарплатаКадрыРасширенныйКлиент.СоздатьДокументПоОписанию(ЭтаФорма, Команда.Имя, ДополнительныеЗначенияЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеСписка()
	
	ЗарплатаКадрыРасширенный.УстановитьУсловноеОформлениеСпискаМногофункциональныхДокументов(ЭтотОбъект);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеПозиций") Или Не ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		Возврат;
	КонецЕсли;
	
	УсловноеОформлениеКД = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	УсловноеОформлениеКД.ИдентификаторПользовательскойНастройки = "ОсновноеОформление";

	ТекущийШрифт = Элементы.Список.Шрифт;
	
	ЖирныйШрифт = Новый Шрифт(ТекущийШрифт,,,Истина);
	
	ЭлементОформления = УсловноеОформлениеКД.Элементы.Добавить();
	ЭлементОформления.Представление = НСтр("ru = 'Выделять бронирование.';
											|en = 'Highlight booking.'");
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БронированиеПозиции");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Проведен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("БронированиеПозиции");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ЖирныйШрифт);
			
КонецПроцедуры

&НаСервере
Процедура УстановитьТипыОбъектовОповещения()
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ТипыОбъектовОповещения", Новый ОписаниеТипов("СписокЗначений")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИспользоватьКритерийОтбора", Новый ОписаниеТипов("Булево")));
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(ЭтотОбъект, МассивИменРеквизитовФормы);
	ЗарплатаКадры.ИзменитьРеквизитыФормы(ЭтотОбъект, ДобавляемыеРеквизиты, МассивИменРеквизитовФормы);
	
	ТипОбъекта = ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ЭтотОбъект.ИмяФормы));
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипОбъекта);
	Для Каждого РегистрируемыйДокумент Из МетаданныеОбъекта.РегистрируемыеДокументы Цикл
		ЭтотОбъект.ТипыОбъектовОповещения.Добавить(ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(РегистрируемыйДокумент.ПолноеИмя()).ПустаяСсылка()));
	КонецЦикла;
	ЭтотОбъект.ИспользоватьКритерийОтбора = Истина;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДинамическийСписокНаСервере(ОписаниеМодификации) Экспорт
	ЗарплатаКадрыРасширенный.НастроитьДинамическийСписокПоОписаниюМодификации(ЭтаФорма, ОписаниеМодификации);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПараметрМодификацииВыбор(Элемент, ИмяПараметра, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ПараметрМодификацииОбработкаНавигационнойСсылки(
		ЭтотОбъект, Элемент.Родитель.Имя, ИмяПараметра);
	
КонецПроцедуры

#КонецОбласти
