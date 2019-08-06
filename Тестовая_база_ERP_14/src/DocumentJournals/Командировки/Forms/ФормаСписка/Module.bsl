
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаИнформация",
		"Видимость",
		ПравоДоступа("Изменение", Метаданные.Документы.Командировка));
	
	ПравоДобавления = ПравоДоступа("Добавление", Метаданные.Документы.Командировка);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаСкопировать",
		"Видимость",
		ПравоДобавления);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокСкопировать",
		"Видимость",
		ПравоДобавления);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаУтвердить", "Видимость", Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ДобавлениеИзменениеНачисленнойЗарплатыРасширенная"));
	ЗарплатаКадрыРасширенный.УстановитьУсловноеОформлениеСпискаМногофункциональныхДокументов(ЭтаФорма);
	
	СтруктураПараметровОтбора = Новый Структура();
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ФизическоеЛицо",
		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), НСтр("ru = 'Сотрудник';
																	|en = 'Employee'"));
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "Подразделение",
		Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"), НСтр("ru = 'Подразделение';
																				|en = 'Department'"));
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьДоступностьКомандыУтвердитьВМногофункциональныхДокументах(ЭтаФорма);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		
		Если Копирование И ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("ДокументСсылка.КомандировкиСотрудников") Тогда
			ОформитьТ9а(Копирование);
		Иначе
			ОформитьТ9(Копирование);
		КонецЕсли;
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
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
Процедура СоздатьТ9(Команда)
	
	ОформитьТ9();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьТ9а(Команда)
	
	ОформитьТ9а();
	
КонецПроцедуры

&НаКлиенте
Процедура Утвердить(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.УтвердитьВыделенныеМногофункциональныеДокументы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыСозданияДокумента(ТипДокумента)
	
	ПараметрыОткрытия = Новый Структура;
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, ТипДокумента);
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

&НаКлиенте
Процедура ОформитьТ9(Копирование = Ложь)
	
	ПараметрыОткрытия = ПараметрыСозданияДокумента("Документ.Командировка");
	
	Если Копирование И Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
	Иначе
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	КонецЕсли;
	
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьТ9а(Копирование = Ложь)
	
	ПараметрыОткрытия = ПараметрыСозданияДокумента("Документ.КомандировкиСотрудников");
	
	Если Копирование И Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
	Иначе
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	КонецЕсли;
	
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы, ЭтаФорма);
	
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
