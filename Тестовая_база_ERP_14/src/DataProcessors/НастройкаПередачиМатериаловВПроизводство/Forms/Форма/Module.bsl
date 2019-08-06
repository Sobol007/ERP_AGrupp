#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьНесколькоСкладов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	СкладПоУмолчанию = ОбщегоНазначенияУТ.ПолучитьПроверитьСкладПоУмолчанию();
	
	ОснованиеДляПолученияПодразделение = Перечисления.ОснованияДляПолученияМатериаловВПроизводстве.ПоЗаказуНаПроизводство;
	ФильтрХарактеристика = Истина;
	
	Если НЕ ОбработатьПараметрыФормы() Тогда
		
		ПараметрыОтбора = ХранилищеНастроекДанныхФорм.Загрузить("НастройкаПередачиМатериаловВПроизводство", "ПараметрыОтбора");
		Если ЗначениеЗаполнено(ПараметрыОтбора) Тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыОтбора);
		КонецЕсли;
		
		СкладМатериаловДляПодразделения = СкладПередачиМатериаловВПроизводство(Подразделение);
		
		СохранятьПараметрыОтбора = Истина;
		
	КонецЕсли; 
	
	ТекущееПодразделение = Подразделение;
	
	УстановитьОтображениеХарактеристик(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПодключитьОжиданиеЧтенияНастройки Тогда
		ПодключитьОжиданиеЧтенияНастройки();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Результат = ДобавитьВСписокНоменклатуру(ВыбранноеЗначение);
	ОбработатьРезультатЧтенияНастройки(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НужноЗаписатьНастройку() Тогда
		
		Если ЗавершениеРаботы Тогда
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru = 'Данные в форме были изменены.
											|Можно продолжить работу и сохранить изменения, 
											|либо завершить работу без сохранения изменений.';
											|en = 'Data in the form was changed. 
											|You can continue working and save the changes
											|or close the form without saving changes.'");
			Возврат;
		КонецЕсли; 
		
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		ПоказатьВопросЗаписатьНастройку("ЗаписатьНастройкуИЗакрыть");
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
 	ПоказатьВопросЗаписатьНастройку("ЗаписатьНастройкуИИзменитьПодразделение");
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрХарактеристикаПриИзменении(Элемент)
	
	УстановитьОтображениеХарактеристик(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСкладПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные.Склад.Пустая() Тогда
		ТекущиеДанные.ОснованиеДляПолучения = ПредопределенноеЗначение("Перечисление.ОснованияДляПолученияМатериаловВПроизводстве.ПустаяСсылка");
		Если ТекущиеДанные.ЕстьНастройкаДляНоменклатуры Тогда
			ТекущиеДанные.СпособНастройки = ПредопределенноеЗначение("Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляНоменклатуры");
		Иначе
			ТекущиеДанные.СпособНастройки = ПредопределенноеЗначение("Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляПодразделения");
		КонецЕсли;
	Иначе
		ТекущиеДанные.СпособНастройки = ПредопределенноеЗначение("Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально");
	КонецЕсли;
	
	ТекущиеДанные.ОснованиеДляПолучения = ПриИзмененииСклада(ТекущиеДанные.Номенклатура, 
												ТекущиеДанные.Характеристика, 
												ТекущиеДанные.ХарактеристикиИспользуются,
												ТекущиеДанные.ОснованиеДляПолучения, 
												ТекущиеДанные.СпособНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОснованиеДляПолученияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные.ОснованиеДляПолучения.Пустая() Тогда
		ТекущиеДанные.Склад = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
		Если ТекущиеДанные.ЕстьНастройкаДляНоменклатуры Тогда
			ТекущиеДанные.СпособНастройки = ПредопределенноеЗначение("Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляНоменклатуры");
		Иначе
			ТекущиеДанные.СпособНастройки = ПредопределенноеЗначение("Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляПодразделения");
		КонецЕсли;
	Иначе
		ТекущиеДанные.СпособНастройки = ПредопределенноеЗначение("Перечисление.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально");
	КонецЕсли;
	
	ТекущиеДанные.Склад = ПриИзмененииОснования(ТекущиеДанные.Номенклатура, 
												ТекущиеДанные.Характеристика, 
												ТекущиеДанные.ХарактеристикиИспользуются,
												ТекущиеДанные.Склад, 
												ТекущиеДанные.СпособНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьНастройку();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	Если ЗаписатьНастройку() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьПоОтбору(Команда)
	
 	ПоказатьВопросЗаписатьНастройку("ЗаписатьНастройкуИЗаполнитьПоОтбору");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодобратьНоменклатуру(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормы.Вставить("РежимВыбора",        Истина);
	
	ТипНоменклатуры = Новый Массив;
	ТипНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	ТипНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
	ПараметрыОтбора = Новый Структура("ТипНоменклатуры", ТипНоменклатуры);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьМатериалыПоСпецификациям(Команда)
	
 	ПоказатьВопросЗаписатьНастройку("ЗаписатьНастройкуИЗаполнитьМатериалыПоСпецификациям");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьСклад(Команда)
	
	РезультатВыбора = Неопределено;

	
	ОткрытьФорму("Справочник.Склады.ФормаВыбора",, ЭтаФорма,,,, Новый ОписаниеОповещения("КомандаЗаполнитьСкладЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьСкладЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    РезультатВыбора = Результат;
    Если РезультатВыбора = Неопределено Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьСкладНаСервере(РезультатВыбора);

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьОснованиеЗначениемПоЗаказуНаВнутреннееПотребление(Команда)
	
	ЗаполнитьОснованиеНаСервере("ПоЗаказуНаВнутреннееПотребление");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьОснованиеЗначениемПоЗаказуНаПроизводство(Команда)
	
	ЗаполнитьОснованиеНаСервере("ПоЗаказуНаПроизводство");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьДанные(Команда)
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыХарактеристика.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ЭлементГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех характеристик>';
																|en = '<for all characteristics>'"));

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКартинкаЭлементГруппа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКартинкаЭлементГруппа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыСклад.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыОснованиеДляПолучения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.СпособНастройки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляПодразделения;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<как для подразделении в целом>';
																|en = '<as for the department as a whole>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыСклад.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыОснованиеДляПолучения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.СпособНастройки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляНоменклатуры;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<как для номенклатуры в целом>';
																|en = '<as for products in general>'"));

КонецПроцедуры

#Область ЗаполнениеСпискаМатериалов

&НаСервере
Функция ДобавитьВСписокНоменклатуру(Номенклатура)

	ТаблицаНоменклатуры = Новый ТаблицаЗначений;
	ТаблицаНоменклатуры.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаНоменклатуры.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	
	Если ТипЗнч(Номенклатура) = Тип("Массив") Тогда
		Для каждого ЭлементКоллекции Из Номенклатура Цикл
			НоваяСтрока = ТаблицаНоменклатуры.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоллекции);
		КонецЦикла; 
	Иначе
		НоваяСтрока = ТаблицаНоменклатуры.Добавить();
		НоваяСтрока.Номенклатура   = Номенклатура;
	КонецЕсли;
	
	Возврат ЗаполнитьМатериалыПоТаблицеНоменклатуры(ТаблицаНоменклатуры);
	
КонецФункции

&НаСервере
Функция ЗаполнитьМатериалыПоСпецификациям()

	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	РесурсныеСпецификацииМатериалыИУслуги.Номенклатура КАК Номенклатура,
	|	РесурсныеСпецификацииМатериалыИУслуги.Характеристика КАК Характеристика
	|ИЗ
	|	Справочник.РесурсныеСпецификации.МатериалыИУслуги КАК РесурсныеСпецификацииМатериалыИУслуги
	|ГДЕ
	|	РесурсныеСпецификацииМатериалыИУслуги.Этап.Подразделение = &Подразделение
	|	И РесурсныеСпецификацииМатериалыИУслуги.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификаций.Действует)
	|	И РесурсныеСпецификацииМатериалыИУслуги.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И РесурсныеСпецификацииМатериалыИУслуги.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|																			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))";
	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Возврат ЗаполнитьМатериалыПоТаблицеНоменклатуры(Запрос.Выполнить().Выгрузить(), Истина);

КонецФункции

&НаСервере
Функция ЗаполнитьМатериалыПоТаблицеНоменклатуры(ТаблицаНоменклатуры, ИспользоватьХарактеристикиИзТаблицы = Ложь)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаНоменклатуры.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ТаблицаНоменклатуры.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ ТаблицаНоменклатуры
	|ИЗ
	|	&ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	СправочникНоменклатура.Наименование КАК НоменклатураНаименование,
	|	ЕСТЬNULL(ХарактеристикиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика,
	|	ЕСТЬNULL(ХарактеристикиНоменклатуры.Наименование, """") КАК ХарактеристикаНаименование,
	|	ИСТИНА КАК ХарактеристикиИспользуются,
	|	0 КАК ЭлементГруппа
	|ИЗ
	|	Справочник.Номенклатура КАК СправочникНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО (СправочникНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|					И ХарактеристикиНоменклатуры.Владелец = СправочникНоменклатура.Ссылка
	|				ИЛИ СправочникНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры)
	|					И ХарактеристикиНоменклатуры.Владелец = СправочникНоменклатура.ВидНоменклатуры
	|				ИЛИ СправочникНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры)
	|					И ХарактеристикиНоменклатуры.Владелец = СправочникНоменклатура.ВладелецХарактеристик)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ПО (ТаблицаНоменклатуры.Номенклатура = СправочникНоменклатура.Ссылка)
	|			И (ТаблицаНоменклатуры.Характеристика = ХарактеристикиНоменклатуры.Ссылка)
	|ГДЕ
	|	СправочникНоменклатура.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
	|	И СправочникНоменклатура.Ссылка В
	|			(ВЫБРАТЬ
	|				ТаблицаНоменклатуры.Номенклатура
	|			ИЗ
	|				ТаблицаНоменклатуры)
	|	И (НЕ &ИспользоватьХарактеристикиИзТаблицы
	|			ИЛИ НЕ ТаблицаНоменклатуры.Номенклатура ЕСТЬ NULL )
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СправочникНоменклатура.Ссылка,
	|	СправочникНоменклатура.Наименование,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	"""",
	|	ВЫБОР
	|		КОГДА СправочникНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА СправочникНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
	|			ТОГДА 0
	|		ИНАЧЕ 2
	|	КОНЕЦ
	|ИЗ
	|	Справочник.Номенклатура КАК СправочникНоменклатура
	|ГДЕ
	|	СправочникНоменклатура.Ссылка В
	|			(ВЫБРАТЬ
	|				ТаблицаНоменклатуры.Номенклатура
	|			ИЗ
	|				ТаблицаНоменклатуры)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НоменклатураНаименование,
	|	ХарактеристикаНаименование";
	
	Запрос.УстановитьПараметр("ТаблицаНоменклатуры", ТаблицаНоменклатуры);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристикиИзТаблицы", ИспользоватьХарактеристикиИзТаблицы);
	
	ТаблицаМатериалов = Запрос.Выполнить().Выгрузить();
	
	Для каждого ДанныеНовойСтроки Из ТаблицаМатериалов Цикл
		СтруктураПоиска = Новый Структура("Номенклатура,Характеристика", ДанныеНовойСтроки.Номенклатура, ДанныеНовойСтроки.Характеристика);
  		СписокСтрок = Объект.Товары.НайтиСтроки(СтруктураПоиска);
		Если СписокСтрок.Количество() = 0 Тогда
			СтрокаТовары = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТовары, ДанныеНовойСтроки);
		КонецЕсли;
	КонецЦикла;
	
	Результат = ПрочитатьНастройкиПоСпискуМатериаловНаСервере(ТаблицаМатериалов);

	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЗаполнитьПоОтборуНаСервере(АдресНастроек)

	Объект.Товары.Очистить();
	
	Настройки = ПолучитьИзВременногоХранилища(АдресНастроек);
	
	Запрос = ПолучитьЗапросКомпоновщика(Настройки);
	Запрос.УстановитьПараметр("ИспользоватьОтборПоНоменклатуре", Истина);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристикиНоменклатуры",
		ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры"));
	
	ТаблицаМатериалов = Запрос.Выполнить().Выгрузить();
	
	Для каждого ДанныеНовойСтроки Из ТаблицаМатериалов Цикл
		СтрокаТовары = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТовары, ДанныеНовойСтроки);
	КонецЦикла;
	
	Результат = ПрочитатьНастройкиПоСпискуМатериаловНаСервере(ТаблицаМатериалов);

	Возврат Результат;
		
КонецФункции

&НаСервере
Функция ПолучитьЗапросКомпоновщика(Настройки)
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	СхемаКомпоновкиДанных = Обработки.НастройкаПередачиМатериаловВПроизводство.ПолучитьМакет("ОтборНоменклатуры");
	
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, Настройки);
	
	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных.Товары.Запрос);
	
	Для каждого ПараметрКомпоновки Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		
		Запрос.УстановитьПараметр(ПараметрКомпоновки.Имя, ПараметрКомпоновки.Значение);
		
	КонецЦикла;
	
	Возврат Запрос;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьДанные()

	ПоказатьВопросЗаписатьНастройку("ЗаписатьНастройкуИОбновитьДанные");
	
КонецПроцедуры

&НаСервере
Функция ОбновитьДанныеНаСервере()

	СписокНоменклатуры = Объект.Товары.Выгрузить(, "Номенклатура,Характеристика");
	Результат = ПрочитатьНастройкиПоСпискуМатериаловНаСервере(СписокНоменклатуры);

	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПрочитатьНастройкиПоСпискуМатериаловНаСервере(СписокНоменклатуры)
	
	СкладМатериаловДляПодразделения = СкладПередачиМатериаловВПроизводство(Подразделение);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("СписокНоменклатуры", СписокНоменклатуры);
	ПараметрыЗадания.Вставить("Подразделение",      Подразделение);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.НастройкаПередачиМатериаловВПроизводство.ПрочитатьНастройкиПоСпискуМатериалов(ПараметрыЗадания, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено, АдресХранилища", Истина, АдресХранилища);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Заполнение настройки передачи материалов в производство';
									|en = 'Fill in the setting of material transfer to production'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.НастройкаПередачиМатериаловВПроизводство.ПрочитатьНастройкиПоСпискуМатериалов",
			ПараметрыЗадания,
			НаименованиеЗадания);
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатЧтенияНастройки(Результат)

	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ПодключитьОжиданиеЧтенияНастройки();
	Иначе
		АдресХранилища = Результат.АдресХранилища;
		ЗагрузитьНастройкиИзХранилища();
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатЧтенияНастройкиНаСервере(Результат)

	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		ПодключитьОжиданиеЧтенияНастройки = Истина;
	Иначе
		АдресХранилища = Результат.АдресХранилища;
		ЗагрузитьНастройкиИзХранилища();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОжиданиеЧтенияНастройки()

	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2; // Уменьшим шаг увелечения времени опроса выполнения задания
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиИзХранилища()

	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Для каждого СтрокаНастройка Из Результат.РезультатРасчета Цикл
		СтруктураПоиска = Новый Структура("Номенклатура,Характеристика", 
						СтрокаНастройка.Номенклатура, 
						СтрокаНастройка.Характеристика);
						
  		СписокСтрок = Объект.Товары.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрокаТовар Из СписокСтрок Цикл
			ЗаполнитьЗначенияСвойств(СтрокаТовар, СтрокаНастройка);
		КонецЦикла; 
	КонецЦикла;

	УстановитьОтображениеХарактеристик(ЭтаФорма);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

// Унифицированная процедура проверки выполнения фонового задания
&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
 
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьНастройкиИзХранилища();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ГрупповоеИзменениеСпискаМатериалов

&НаСервере
Процедура ЗаполнитьСкладНаСервере(Склад)

	Для каждого ИдентификаторСтроки Из Элементы.Товары.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		ДанныеСтроки.Склад = Склад;
		ДанныеСтроки.СпособНастройки = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально;
		
		ДанныеСтроки.ОснованиеДляПолучения = ПриИзмененииСклада(ДанныеСтроки.Номенклатура, 
													ДанныеСтроки.Характеристика, 
													ДанныеСтроки.ХарактеристикиИспользуются,
													ДанныеСтроки.ОснованиеДляПолучения, 
													ДанныеСтроки.СпособНастройки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОснованиеНаСервере(ОснованиеДляПолученияИмя)

	ОснованиеДляПолучения = Перечисления.ОснованияДляПолученияМатериаловВПроизводстве[ОснованиеДляПолученияИмя];
	
	Для каждого ИдентификаторСтроки Из Элементы.Товары.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		ДанныеСтроки.ОснованиеДляПолучения = ОснованиеДляПолучения;
		ДанныеСтроки.СпособНастройки = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально;
		
		ДанныеСтроки.Склад = ПриИзмененииОснования(ДанныеСтроки.Номенклатура, 
													ДанныеСтроки.Характеристика, 
													ДанныеСтроки.ХарактеристикиИспользуются,
													ДанныеСтроки.Склад, 
													ДанныеСтроки.СпособНастройки);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписьСпискаМатериалов

&НаКлиенте
Функция НужноЗаписатьНастройку()

	Возврат (Модифицированность И Объект.Товары.Количество() <> 0);

КонецФункции
 
&НаКлиенте
Процедура ПоказатьВопросЗаписатьНастройку(ИмяПроцедурыДляОбработкиРезультата)

	Если НужноЗаписатьНастройку() Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?';
							|en = 'Data has been changed. Save the changes?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросПоказатьВопросЗаписатьНастройку", ЭтаФорма, ИмяПроцедурыДляОбработкиРезультата);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		Модифицированность = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедурыДляОбработкиРезультата, ЭтаФорма);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПоказатьВопросЗаписатьНастройку(РезультатВопроса, ИмяПроцедурыДляОбработкиРезультата) Экспорт

	РезультатЗаписи = Истина;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		РезультатЗаписи =  ЗаписатьНастройку();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		РезультатЗаписи = Ложь
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедурыДляОбработкиРезультата, ЭтаФорма);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатЗаписи);

КонецПроцедуры
 
&НаКлиенте
Процедура ЗаписатьНастройкуИЗакрыть(РезультатЗаписи, ДополнительныеПараметры = Неопределено) Экспорт

	Если РезультатЗаписи Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкуИИзменитьПодразделение(РезультатЗаписи, ДополнительныеПараметры = Неопределено) Экспорт

	Если РезультатЗаписи Тогда
		ОбновитьДанные();
		ТекущееПодразделение = Подразделение;
	Иначе
		Подразделение = ТекущееПодразделение;
	КонецЕсли;

КонецПроцедуры
 
&НаКлиенте
Процедура ЗаписатьНастройкуИОбновитьДанные(РезультатЗаписи, ДополнительныеПараметры = Неопределено) Экспорт

	Если РезультатЗаписи Тогда
		СохранитьПараметрыОтбора();
		
		Результат = ОбновитьДанныеНаСервере();
		ОбработатьРезультатЧтенияНастройки(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкуИЗаполнитьПоОтбору(РезультатЗаписи, ДополнительныеПараметры = Неопределено) Экспорт

	Если РезультатЗаписи Тогда
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьПоОтборуЗаврешить", ЭтаФорма);
		ПараметрыФормы = Новый Структура("Подразделение", Подразделение);
		ОткрытьФорму("Обработка.НастройкаПередачиМатериаловВПроизводство.Форма.ЗаполнениеПоОтбору", ПараметрыФормы, ЭтаФорма,,,, ОповещениеОЗакрытии);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОтборуЗаврешить(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		Результат = ЗаполнитьПоОтборуНаСервере(РезультатЗакрытия);
		ОбработатьРезультатЧтенияНастройки(Результат);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкуИЗаполнитьМатериалыПоСпецификациям(РезультатЗаписи, ДополнительныеПараметры = Неопределено) Экспорт

	Если РезультатЗаписи Тогда
		Результат = ЗаполнитьМатериалыПоСпецификациям();
		ОбработатьРезультатЧтенияНастройки(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ЗаписатьНастройку()

	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗаписатьНастройкуНаСервере() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Не удалось записать настройку.';
									|en = 'Cannot write the setting.'"));
		Возврат Ложь;
	КонецЕсли; 
	
	Оповестить("Запись_НастройкаПередачиМатериаловВПроизводство");
	
	Возврат Истина;

КонецФункции

&НаСервере
Функция ЗаписатьНастройкуНаСервере()

	Для каждого ДанныеСтроки Из Объект.Товары Цикл
		Попытка
			МенеджерЗаписи = РегистрыСведений.НастройкаПередачиМатериаловВПроизводство.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Подразделение  = ТекущееПодразделение;
			МенеджерЗаписи.Номенклатура   = ДанныеСтроки.Номенклатура;
			МенеджерЗаписи.Характеристика = ДанныеСтроки.Характеристика;
			
			Если ДанныеСтроки.СпособНастройки = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально Тогда
				МенеджерЗаписи.Склад = ?(ИспользоватьНесколькоСкладов, ДанныеСтроки.Склад, СкладПоУмолчанию);
				МенеджерЗаписи.ОснованиеДляПолучения = ДанныеСтроки.ОснованиеДляПолучения;
				МенеджерЗаписи.Записать();
			Иначе
				МенеджерЗаписи.Удалить();
			КонецЕсли; 
		Исключение
			Возврат Ложь;
		КонецПопытки;
	КонецЦикла; 

	Модифицированность = Ложь;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область Прочее
 
&НаСервереБезКонтекста
Функция СкладПередачиМатериаловВПроизводство(Подразделение)

	УстановитьПривилегированныйРежим(Истина);
	НастройкаПередачиМатериалов = РегистрыСведений.НастройкаПередачиМатериаловВПроизводство.ПолучитьНастройкуПередачиМатериаловПроизводство(Подразделение);
	
	Если ЗначениеЗаполнено(НастройкаПередачиМатериалов.Склад) Тогда
		СкладПередачиМатериаловВПроизводство = НастройкаПередачиМатериалов.Склад;
	Иначе
		СкладПередачиМатериаловВПроизводство = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);

	Возврат ?(ЗначениеЗаполнено(СкладПередачиМатериаловВПроизводство), 
				СкладПередачиМатериаловВПроизводство, 
				НСтр("ru = '<склад не указан>';
					|en = '<warehouse is not set>'"));
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеХарактеристик(Форма)

	Если Форма.ФильтрХарактеристика Тогда
		ОтборСтрок = Неопределено;
	Иначе
		ОтборСтрок = Новый ФиксированнаяСтруктура("НастройкаХарактеристики", Ложь);
	КонецЕсли; 
	Форма.Элементы.Товары.ОтборСтрок = ОтборСтрок;

КонецПроцедуры

&НаСервере
Функция ПриИзмененииСклада(Номенклатура, Характеристика, ХарактеристикиИспользуются, ОснованиеДляПолучения, СпособНастройки)
	
	Если НЕ ЗначениеЗаполнено(ОснованиеДляПолучения) Тогда
		// Нужно подставить значение согласно правилу наследования
		ОснованиеДляПолучения = ОснованиеДляПолученияПодразделение;
		Если ЗначениеЗаполнено(Характеристика) Тогда
			СтруктураПоиска = Новый Структура("Номенклатура,Характеристика", 
									Номенклатура,
									Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
			СписокСтрок = Объект.Товары.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() <> 0 И ЗначениеЗаполнено(СписокСтрок[0].ОснованиеДляПолучения) Тогда
				ОснованиеДляПолучения = СписокСтрок[0].ОснованиеДляПолучения;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Характеристика) 
		И ХарактеристикиИспользуются Тогда
		ЗаполнитьСпособНастройкиХарактеристик(Номенклатура, СпособНастройки);
	КонецЕсли; 

	Возврат ОснованиеДляПолучения;
	
КонецФункции
 
&НаСервере
Функция ПриИзмененииОснования(Знач Номенклатура, Знач Характеристика, Знач ХарактеристикиИспользуются, Знач Склад, Знач СпособНастройки)

	Если НЕ ЗначениеЗаполнено(Склад) Тогда
		// Нужно подставить значение согласно правилу наследования
		Если ТипЗнч(СкладМатериаловДляПодразделения) = Тип("СправочникСсылка.Склады") Тогда
			Склад = СкладМатериаловДляПодразделения;
		Иначе
			Склад = Неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Характеристика) Тогда
			СтруктураПоиска = Новый Структура("Номенклатура,Характеристика", 
									Номенклатура,
									Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
			СписокСтрок = Объект.Товары.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() <> 0 И ЗначениеЗаполнено(СписокСтрок[0].ОснованиеДляПолучения) Тогда
				Склад = СписокСтрок[0].Склад;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Характеристика) 
		И ХарактеристикиИспользуются Тогда
		ЗаполнитьСпособНастройкиХарактеристик(Номенклатура, СпособНастройки);
	КонецЕсли; 

	Возврат Склад;
	
КонецФункции
 
&НаСервере
Процедура ЗаполнитьСпособНастройкиХарактеристик(Номенклатура, СпособНастройки)

	СтруктураПоиска = Новый Структура("Номенклатура", Номенклатура);
   	СписокСтрок = Объект.Товары.НайтиСтроки(СтруктураПоиска);
	Для каждого ДанныеСтроки Из СписокСтрок Цикл
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.Характеристика) 
			ИЛИ ДанныеСтроки.СпособНастройки = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если СпособНастройки = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально Тогда
			ДанныеСтроки.СпособНастройки = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляНоменклатуры;
			ДанныеСтроки.ЕстьНастройкаДляНоменклатуры = Истина;
		Иначе
			ДанныеСтроки.СпособНастройки = Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.ОпределяетсяНастройкойДляПодразделения;
			ДанныеСтроки.ЕстьНастройкаДляНоменклатуры = Ложь;
		КонецЕсли;
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Функция ОбработатьПараметрыФормы()

	ПараметрыОбработаны = Ложь;
	
	Если НЕ Параметры.Подразделение.Пустая() Тогда
			
		Подразделение = Параметры.Подразделение;
		
		СкладМатериаловДляПодразделения = СкладПередачиМатериаловВПроизводство(Подразделение);
		
		Элементы.Подразделение.ТолькоПросмотр = Истина;
		
		ПараметрыОбработаны = Истина;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Номенклатура") Тогда
		
		Характеристика = Неопределено;
		Результат = ДобавитьВСписокНоменклатуру(Параметры.Номенклатура);
		
		ОбработатьРезультатЧтенияНастройкиНаСервере(Результат);
		
		ПараметрыОбработаны = Истина;
		
	ИначеЕсли Параметры.Свойство("СписокНоменклатуры") Тогда
		
		Результат = ДобавитьВСписокНоменклатуру(Параметры.СписокНоменклатуры);
		
		ОбработатьРезультатЧтенияНастройкиНаСервере(Результат);
		
		ПараметрыОбработаны = Истина;
		
	КонецЕсли; 
	
	Возврат ПараметрыОбработаны;

КонецФункции

&НаСервере
Процедура СохранитьПараметрыОтбора()
	
	Если СохранятьПараметрыОтбора Тогда
		ПараметрыОтбора = Новый Структура("Подразделение");
		ЗаполнитьЗначенияСвойств(ПараметрыОтбора, ЭтаФорма);
		ХранилищеНастроекДанныхФорм.Сохранить("НастройкаПередачиМатериаловВПроизводство", "ПараметрыОтбора", ПараметрыОтбора);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
