
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИмяТЧ = Параметры.ИмяТЧ;
	Если Параметры.ТолькоПросмотр Тогда
		Элементы.ФормаСохранитьНастройку.Доступность = Ложь;
	КонецЕсли;
	
	АлгоритмРасчетаКоличества = Параметры.АлгоритмРасчетаКоличества;
	АдресДополнительныхДанных = Параметры.АдресДополнительныхДанных;
	
	ВидИзделийИлиНоменклатура = Параметры.ВидИзделийИлиНоменклатура;
	Если ТипЗнч(ВидИзделийИлиНоменклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		ВидИзделий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидИзделийИлиНоменклатура, "ВидНоменклатуры");
	Иначе
		ВидИзделий = ВидИзделийИлиНоменклатура;
	КонецЕсли;
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	Если ИспользоватьДополнительныеРеквизитыИСведения Тогда
		
		ЗаполнитьСписокОтборовПоСвойствам();
		
	КонецЕсли;
	
	УстановитьВидимостьДоступностьПоСоставуНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПоСвойствамСвойствоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОтборПоСвойствам.ТекущиеДанные;
	
	СтрокиТаблицыСвойств = 
		ТаблицаДоступныхСвойствПродукции.НайтиСтроки(Новый Структура("Свойство", ТекущиеДанные.Свойство));
		
	Если НЕ ЗначениеЗаполнено(СтрокиТаблицыСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Условие  = "Равно";
	
	ТипЗначенияПриведенный = 
		УстановитьОграничениеТиповДляЗначенияСвойства(ТекущиеДанные, СтрокиТаблицыСвойств[0].ТипЗначения);
	
	ТекущиеДанные.Значение = ТипЗначенияПриведенный.ПривестиЗначение(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоСвойствамУсловиеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОтборПоСвойствам.ТекущиеДанные;
	
	СтрокиТаблицыСвойств = 
		ТаблицаДоступныхСвойствПродукции.НайтиСтроки(Новый Структура("Свойство", ТекущиеДанные.Свойство));
		
	Если НЕ ЗначениеЗаполнено(СтрокиТаблицыСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееУсловие = СтруктураУсловий[ТекущиеДанные.Условие];
	
	ТипЗначенияПриведенный = 
		УстановитьОграничениеТиповДляЗначенияСвойства(ТекущиеДанные, СтрокиТаблицыСвойств[0].ТипЗначения);
	
	Если ТекущееУсловие.Список Тогда
		
		ТекущиеДанные.Значение = Новый СписокЗначений;
		ТекущиеДанные.Значение.ТипЗначения = ТипЗначенияПриведенный;
		
	Иначе
		
		Если ТекущееУсловие.Интервал ИЛИ ТекущееУсловие.Заполненность Тогда
			ТекущиеДанные.Значение = Неопределено;
		КонецЕсли;
		
		ТекущиеДанные.Значение = ТипЗначенияПриведенный.ПривестиЗначение(ТекущиеДанные.Значение);
		
	КонецЕсли;
	
	Для Ит = 1 По 2 Цикл
		ТекущиеДанные["Значение"+Ит] = ТипЗначенияПриведенный.ПривестиЗначение(Неопределено);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоСвойствамЗначениеИнтервалПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОтборПоСвойствам.ТекущиеДанные;
	
	ТипЗначенияОтбора = Новый ОписаниеТипов(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(ТекущиеДанные[Элемент.Имя])));
	
	Для Ит = 1 По 2 Цикл
		ТекущиеДанные["Значение"+Ит] = ТипЗначенияОтбора.ПривестиЗначение(ТекущиеДанные["Значение"+Ит]);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоСвойствамПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ОтборПоСвойствам.ТекущиеДанные;
	
	СтрокиТаблицыСвойств = 
		ТаблицаДоступныхСвойствПродукции.НайтиСтроки(Новый Структура("Свойство", ТекущиеДанные.Свойство));
		
	Если НЕ ЗначениеЗаполнено(СтрокиТаблицыСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОграничениеТиповДляЗначенияСвойства(ТекущиеДанные, СтрокиТаблицыСвойств[0].ТипЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоСвойствамУсловиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокВыбора = Элементы.Условие.СписокВыбора;
	СписокВыбора.Очистить();
	
	ТекущиеДанные = Элементы.ОтборПоСвойствам.ТекущиеДанные;
	
	СтрокиТаблицыСвойств = 
		ТаблицаДоступныхСвойствПродукции.НайтиСтроки(Новый Структура("Свойство", ТекущиеДанные.Свойство));
		
	Если НЕ ЗначениеЗаполнено(СтрокиТаблицыСвойств) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого КлючИЗначение Из СтруктураУсловий Цикл
		Условие = КлючИЗначение.Значение;
		Если Условие.Сравнение 
			И НЕ СтрокиТаблицыСвойств[0].ТипЗначения.СодержитТип(Тип("Число"))
			И НЕ СтрокиТаблицыСвойств[0].ТипЗначения.СодержитТип(Тип("Дата"))
		Тогда
			Продолжить;
		КонецЕсли;
		СписокВыбора.Добавить(Условие.Идентификатор, Условие.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоСвойствамУсловиеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоСвойствамПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	ЗаписатьИЗакрытьНаКлиенте(Неопределено, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиФормулу(Команда)
	
	ПараметрыФормы = ПараметрыФормыРедактированияФормулы(АлгоритмРасчетаКоличества);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВводаФормулы", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул",
		ПараметрыФормы,
		,
		,
		,
		,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФормулу(Команда)
	
	АлгоритмРасчетаКоличества = "";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// условия использования
	
	УсловияЗаполненность = Новый СписокЗначений;
	УсловияИнтервал      = Новый СписокЗначений;
	
	СтруктураУсловий = УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураУсловийОтбораПоСвойствамНоменклатуры();
	Для каждого КлючИЗначение Из СтруктураУсловий Цикл
		
		Условие = КлючИЗначение.Значение;
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Условие.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОтборПоСвойствам.Условие");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Условие.Идентификатор;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Условие.Представление);
		
		Если Условие.Заполненность Тогда
			УсловияЗаполненность.Добавить(Условие.Идентификатор);
		КонецЕсли;
		
		Если Условие.Интервал Тогда
			УсловияИнтервал.Добавить(Условие.Идентификатор);
		КонецЕсли;
		
	КонецЦикла;
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Условие.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Значение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборПоСвойствам.Свойство");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборПоСвойствам.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ИспользоватьДополнительныеРеквизитыИСведения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// отбор по свойствам в интервале
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборПоСвойствамГруппаДиапазон.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Значение1.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Значение2.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОтборПоСвойствам.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = УсловияИнтервал;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Значение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОтборПоСвойствам.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = УсловияИнтервал;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// отбор по свойствам на заполнено, не заполнено
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Значение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОтборПоСвойствам.Условие");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = УсловияЗаполненность;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьПоСоставуНастроек()
	
	Перем СоставНастроек;
	
	Если Параметры.Свойство("СоставНастроек") Тогда
		СоставНастроек = Параметры.СоставНастроек;
	КонецЕсли;
	
	Элементы.ГруппаОтборПоСвойствам.Видимость =(
			СоставНастроек = Неопределено ИЛИ СоставНастроек.Свойство("ОтборПоСвойствам")
		) И ИспользоватьДополнительныеРеквизитыИСведения;
	
	Элементы.ГруппаАлгоритмРасчетаКоличества.Доступность = (
			СоставНастроек = Неопределено ИЛИ СоставНастроек.Свойство("АлгоритмРасчетаКоличества"));

КонецПроцедуры

&НаСервере
Функция ПостроитьДеревоОперандов()
	
	Дерево = РаботаСФормулами.ПолучитьПустоеДеревоОперандов();
	
	Если ЭтоАдресВременногоХранилища(АдресДополнительныхДанных) Тогда
		
		СтруктураДанных = ПолучитьИзВременногоХранилища(АдресДополнительныхДанных);
		
		Для каждого КлючИЗначение Из СтруктураДанных Цикл
			
			Ключ = КлючИЗначение.Ключ;
			Источник = КлючИЗначение.Значение;
			
			Операнды = Неопределено;
			Если Источник.Свойство("Операнды", Операнды) И Операнды.Количество() > 0 Тогда
				
				ГруппаОперандов = РаботаСФормулами.ДобавитьОперанд(Дерево, "", Источник.Представление);
				
				Для каждого Операнд Из Операнды Цикл
					
					РаботаСФормулами.ДобавитьОперанд(ГруппаОперандов, Операнд.Идентификатор, Операнд.Представление);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(Дерево, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция ПараметрыФормыРедактированияФормулы(Формула)
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ИспользуетсяДеревоОперандов", Истина);
	
	ПараметрыФормы.Вставить("Формула",   Формула);
	ПараметрыФормы.Вставить("Операнды",  ПостроитьДеревоОперандов());
	
	ДеревоОператоров = УправлениеДаннымиОбИзделиях.ПостроитьДеревоОператоров();
	ПараметрыФормы.Вставить("Операторы", ПоместитьВоВременноеХранилище(ДеревоОператоров, УникальныйИдентификатор));
	
	ПараметрыФормы.Вставить("ОперандыЗаголовок", НСтр("ru = 'Доступные реквизиты';
														|en = 'Available attributes'"));
	ПараметрыФормы.Вставить("НеИспользоватьПредставление", Истина);

	ПараметрыФормы.Вставить("ФункцииИзОбщегоМодуля", УправлениеДаннымиОбИзделиях.ФункцииИзОбщегоМодуля());
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВводаФормулы(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		АлгоритмРасчетаКоличества = РезультатЗакрытия;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ОчиститьСообщения();
	
	ШаблонПолеНеЗаполнено  = НСтр("ru = 'Ошибка заполнения настройки в строке %1.';
									|en = 'An error occurred when filling in settings in line %1.'");
	ШаблонНеверноеСвойство = НСтр("ru = 'Указано неверное свойство в строке %1.';
									|en = 'Incorrect property is specified in line %1.'");
	ШаблонНеверноеУсловие  = НСтр("ru = 'Ошибка заполнения настройки в строке %1. Левое значение не может быть больше правого.';
									|en = 'An error occurred when filling in settings in line %1. The left value cannot be greater than the right one.'");
	
	ЕстьОшибки = Ложь;
	Реквизиты = УправлениеДаннымиОбИзделияхКлиентСервер.РеквизитыНастройкаОтбораПоСвойствам();
	
	ОтборПоСвойствамДляТекущейСтроки = Новый Массив;
	Для каждого СтрокаОтбора Из ОтборПоСвойствам Цикл
		
		ИндексСтроки = ОтборПоСвойствам.Индекс(СтрокаОтбора);
		
		ТекущееУсловие = СтруктураУсловий[СтрокаОтбора.Условие];
		
		Если ТекущееУсловие.Интервал Тогда
			Если СтрокаОтбора.Значение1 <> Неопределено
				И СтрокаОтбора.Значение2 <> Неопределено
				И СтрокаОтбора.Значение1 > СтрокаОтбора.Значение2 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ШаблонНеверноеУсловие,ИндексСтроки+1),,"ОтборПоСвойствам["+ИндексСтроки+"].Значение1",,ЕстьОшибки);
				Продолжить;
			КонецЕсли;
			ПоляПроверки = СтрРазделить(СтрЗаменить(Реквизиты,"Значение","Значение1,Значение2"), ",");
		Иначе
			ПоляПроверки = СтрРазделить(Реквизиты, ",");
		КонецЕсли;
		
		Для каждого Поле Из ПоляПроверки Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаОтбора[Поле])
				И НЕ СтрокаОтбора[Поле] = 0 
				И НЕ ТекущееУсловие.Заполненность Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ШаблонПолеНеЗаполнено,ИндексСтроки+1),,"ОтборПоСвойствам["+ИндексСтроки+"]."+Поле,,ЕстьОшибки);
			ИначеЕсли Поле = "Свойство" 
					И ТаблицаДоступныхСвойствПродукции.НайтиСтроки(Новый Структура("Свойство", СтрокаОтбора[Поле])).Количество() = 0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ШаблонНеверноеСвойство,ИндексСтроки+1),,"ОтборПоСвойствам["+ИндексСтроки+"]."+Поле,,ЕстьОшибки);
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьОшибки Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекущееУсловие.Список Тогда
			Для каждого ЭлементСписка Из СтрокаОтбора.Значение Цикл
				ЭлементНастройкиУсловия = Новый Структура(Реквизиты);
				ЗаполнитьЗначенияСвойств(ЭлементНастройкиУсловия, СтрокаОтбора);
				ЭлементНастройкиУсловия.Значение = ЭлементСписка.Значение;
				ОтборПоСвойствамДляТекущейСтроки.Добавить(ЭлементНастройкиУсловия);
			КонецЦикла;
		ИначеЕсли ТекущееУсловие.Интервал Тогда
			ЭлементНастройкиУсловия = Новый Структура(Реквизиты);
			ЭлементНастройкиУсловия.Свойство = СтрокаОтбора.Свойство;
			ЭлементНастройкиУсловия.Условие  = ?(ТекущееУсловие.Идентификатор = "ВИнтервале", "Больше", "БольшеИлиРавно");
			ЭлементНастройкиУсловия.Значение = СтрокаОтбора.Значение1;
			ОтборПоСвойствамДляТекущейСтроки.Добавить(ЭлементНастройкиУсловия);
			
			ЭлементНастройкиУсловия = Новый Структура(Реквизиты);
			ЭлементНастройкиУсловия.Свойство = СтрокаОтбора.Свойство;
			ЭлементНастройкиУсловия.Условие  = ?(ТекущееУсловие.Идентификатор = "ВИнтервале", "Меньше", "МеньшеИлиРавно");
			ЭлементНастройкиУсловия.Значение = СтрокаОтбора.Значение2;
			ОтборПоСвойствамДляТекущейСтроки.Добавить(ЭлементНастройкиУсловия);
		Иначе
			ЭлементНастройкиУсловия = Новый Структура(Реквизиты);
			ЗаполнитьЗначенияСвойств(ЭлементНастройкиУсловия, СтрокаОтбора);
			ОтборПоСвойствамДляТекущейСтроки.Добавить(ЭлементНастройкиУсловия);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОтборПоСвойствам", ОтборПоСвойствамДляТекущейСтроки);
	ПараметрыФормы.Вставить("АлгоритмРасчетаКоличества", АлгоритмРасчетаКоличества);
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьОграничениеТиповДляЗначенияСвойства(ТекущиеДанные, ТипЗначения)
	
	ТекущееУсловие = СтруктураУсловий[ТекущиеДанные.Условие];
	
	Если ТекущееУсловие.Сравнение Тогда
		ВычитаемыеТипы = Новый Массив;
		Для каждого Тип Из ТипЗначения.Типы() Цикл
			Если НЕ Тип = Тип("Дата") И НЕ Тип = Тип("Число") Тогда
				ВычитаемыеТипы.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		ТипЗначенияПриведенный = Новый ОписаниеТипов(ТипЗначения,,ВычитаемыеТипы);
	Иначе
		ТипЗначенияПриведенный = ТипЗначения;
	КонецЕсли;
	
	ПараметрыВыбора = Новый Массив;
	Если ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ТекущиеДанные.Свойство));
	КонецЕсли;
	
	Элементы.Значение.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	Если ТекущееУсловие.Список Тогда
		Элементы.Значение.ОграничениеТипа = Новый ОписаниеТипов("СписокЗначений");
	ИначеЕсли ТекущееУсловие.Интервал Тогда
		Элементы.Значение1.ОграничениеТипа = ТипЗначенияПриведенный;
		Элементы.Значение2.ОграничениеТипа = ТипЗначенияПриведенный;
	Иначе
		Элементы.Значение.ОграничениеТипа  = ТипЗначенияПриведенный;
	КонецЕсли;
	
	Возврат ТипЗначенияПриведенный;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокОтборовПоСвойствам()
	
	// Свойства основного изделия
	СписокВсехДоступныхСвойств = УправлениеДаннымиОбИзделиях.ПолучитьСвойстваНоменклатурыДляРасчетаПоФормулам(ВидИзделий);
	Для каждого ДанныеСвойства Из СписокВсехДоступныхСвойств Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаДоступныхСвойствПродукции.Добавить(), ДанныеСвойства);
		Элементы.Свойство.СписокВыбора.Добавить(ДанныеСвойства.Свойство, ДанныеСвойства.Представление);
	КонецЦикла;
	
	НастройкиГруппировки = Новый Структура;
	
	НастройкиГруппировки.Вставить("ВСписке",
							Новый Структура("Дополнение, Результат", "ВСписке", "ВСписке"));
	НастройкиГруппировки.Вставить("НеВСписке",
							Новый Структура("Дополнение, Результат", "НеВСписке", "НеВСписке"));
	НастройкиГруппировки.Вставить("Меньше",
							Новый Структура("Дополнение, Результат", "Больше", "ВИнтервале"));
	НастройкиГруппировки.Вставить("МеньшеИлиРавно",
							Новый Структура("Дополнение, Результат", "БольшеИлиРавно", "ВИнтервалеВключая"));
	
	ТекущаяСтрока = Неопределено;
	
	ОтборПоСвойствамДляТекущейСтроки = Параметры.ОтборПоСвойствам;
	Для каждого Элемент Из ОтборПоСвойствамДляТекущейСтроки Цикл
		
		Настройка = Неопределено;
		Если НастройкиГруппировки.Свойство(Элемент.Условие, Настройка)
			И ТекущаяСтрока <> Неопределено
			И ТекущаяСтрока.Свойство = Элемент.Свойство 
			И ТекущаяСтрока.Условие = Настройка.Дополнение Тогда
			
			Если Настройка.Дополнение = Настройка.Результат Тогда
				ТекущаяСтрока.Значение.Добавить(Элемент.Значение);
			Иначе
				ТекущаяСтрока.Значение1 = ТекущаяСтрока.Значение;
				ТекущаяСтрока.Значение2 = Элемент.Значение;
				ТекущаяСтрока.Условие   = Настройка.Результат;
				ТекущаяСтрока = Неопределено;
			КонецЕсли;
			
		Иначе
			ТекущаяСтрока = ОтборПоСвойствам.Добавить();
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Элемент);
			Если Настройка <> Неопределено И Настройка.Дополнение = Настройка.Результат Тогда
				ТекущаяСтрока.Значение = Новый СписокЗначений;
				ТекущаяСтрока.Значение.ТипЗначения = Элемент.Свойство.ТипЗначения;
				ТекущаяСтрока.Значение.Добавить(Элемент.Значение);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
