
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ИспользоватьФорматыМагазинов = ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов");
	Если ИспользоватьФорматыМагазинов Тогда
		Элементы.ОбъектПланирования.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФорматыМагазинов");
		Элементы.ОбъектПланирования.ВыбиратьТип = Ложь;
		Если НЕ ЗначениеЗаполнено(Объект.ОбъектПланирования) Тогда
			Объект.ОбъектПланирования = Справочники.ФорматыМагазинов.ПустаяСсылка();
		КонецЕсли; 
	Иначе
		Элементы.ГруппаКвотаРекомендованная.Видимость = Ложь;
		Элементы.ОбъектПланирования.Заголовок = НСтр("ru = 'Магазин/склад';
													|en = 'Store/warehouse'");
		Если НЕ ЗначениеЗаполнено(Объект.ОбъектПланирования) Тогда
			Объект.ОбъектПланирования = Справочники.Склады.СкладПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;
	
	СформироватьДеревоПоТаблицеКатегорий();
	
	ОбновитьИтоговыеПоказателиСервер();
	ОбновитьРекомендованныеПоказателиСервер();
	
	Элементы.ДеревоКатегорийЗагрузитьКвотыИзФайла.Доступность = НЕ ЭтаФорма.ТолькоПросмотр;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПерезаполнитьКатегории(ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьИтоговыеПоказателиСервер();
	ОбновитьРекомендованныеПоказателиСервер();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
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
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтаФорма, "Объект.Комментарий");
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПланированияПриИзменении(Элемент)
	ОбновитьРекомендованныеПоказателиСервер();
	ЕстьПлан = НаличиеПлана();
	Если ЕстьПлан Тогда
		Объект.ОбъектПланирования = Элементы.ОбъектПланирования.ОграничениеТипа.ПривестиЗначение(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаДействияПриИзменении(Элемент)
	Объект.ДатаНачалаДействия = НачалоМесяца(Объект.ДатаНачалаДействия);
	ЕстьПлан = НаличиеПлана();
	Если ЕстьПлан Тогда
		Объект.ДатаНачалаДействия = Неопределено;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ДеревоКатегорийКвотаПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.ДеревоКатегорий.ТекущиеДанные;
	Родитель = ТекущаяСтрока.ПолучитьРодителя();
	Если Родитель<>Неопределено Тогда
		ОбновитьКвотуРодителя(Родитель);
	КонецЕсли;
	ОбновитьИтоговыеПоказателиСервер();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПроцентОтклоненияПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.ДеревоКатегорий.ТекущиеДанные;
	Если ТекущаяСтрока.ПроцентОтклонения > 100 Тогда
		ТекстПредупреждения = НСтр("ru = 'Отклонение не может превышать 100%';
									|en = 'Variance cannot be more than 100%'");
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ДеревоКатегорийПроцентОтклоненияПриИзмененииЗавершение", ЭтотОбъект, Новый Структура("ТекущаяСтрока", ТекущаяСтрока)), ТекстПредупреждения);
        Возврат;
	КонецЕсли;
	ДеревоКатегорийПроцентОтклоненияПриИзмененииФрагмент(ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПроцентОтклоненияПриИзмененииЗавершение(ДополнительныеПараметры) Экспорт
    
    ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
    
    
    ТекущаяСтрока.ПроцентОтклонения = 100;
    
    ДеревоКатегорийПроцентОтклоненияПриИзмененииФрагмент(ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПроцентОтклоненияПриИзмененииФрагмент(Знач ТекущаяСтрока)
    
    Родитель = ТекущаяСтрока.ПолучитьРодителя();
    Если Родитель<>Неопределено Тогда
        ОбновитьПроцентРодителя(Родитель);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПередНачаломИзменения(Элемент, Отказ)
	Если ТипЗнч(Элемент.ТекущиеДанные.ВидКатегорияМарка) = Тип("СправочникСсылка.Марки")
		ИЛИ ТипЗнч(Элемент.ТекущиеДанные.ВидКатегорияМарка) = Тип("Строка") Тогда
		Если Элемент.ТекущийЭлемент.Имя = "ДеревоКатегорийВидПредставление" Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Если ТекущаяСтрока<>Неопределено Тогда
		Если ТипЗнч(ТекущаяСтрока.ВидКатегорияМарка) = Тип("СправочникСсылка.ТоварныеКатегории")
			ИЛИ ТипЗнч(ТекущаяСтрока.ВидКатегорияМарка) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
			Элементы.ДеревоКатегорий.Развернуть(ТекущаяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ДеревоКатегорийПередУдалениемЗавершение", ЭтотОбъект), 
		НСтр("ru = 'Удалить строку?';
			|en = 'Remove the line?'"), 
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПередУдалениемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	ТекущаяСтрока = Элементы.ДеревоКатегорий.ТекущиеДанные;
	ИндексТекущейСтроки = Элементы.ДеревоКатегорий.ТекущаяСтрока;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		УменьшитьКвотуРодителяПослеУдаления(ТекущаяСтрока, ТекущаяСтрока.Квота);
		ТекущийРодитель = ТекущаяСтрока.ПолучитьРодителя();
		Если ТекущийРодитель <> Неопределено Тогда
			ТекущаяСтрока.ПроцентОтклонения = 0;
			ОбновитьПроцентРодителя(ТекущийРодитель, Истина);
			ИндексРодителя = ТекущийРодитель.ПолучитьИдентификатор();
			КоличествоДопустимых = 1;
			УдалитьСтрокуРодителяПриНеобходимости(ИндексРодителя, КоличествоДопустимых);
			Если ТекущийРодитель.ПолучитьЭлементы().Количество() <> 0 Тогда
				ТекущийРодитель.ПолучитьЭлементы().Удалить(ТекущаяСтрока);
			КонецЕсли;
		Иначе
			ДеревоКатегорий.ПолучитьЭлементы().Удалить(ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийПослеУдаления(Элемент)
	ДеревоКатегорийПослеУдаленияСервер();
КонецПроцедуры

&НаКлиенте
Процедура КоллекцияНоменклатурыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КоллекцияНоменклатуры) Тогда
	
		ДатаНачала = КоллекцияНоменклатурыПриИзмененииНаСервере(Объект.КоллекцияНоменклатуры);
		
		Если ЗначениеЗаполнено(ДатаНачала) 
			И (НЕ ЗначениеЗаполнено(Объект.ДатаНачалаДействия) 
			ИЛИ Объект.ДатаНачалаДействия < ДатаНачала) Тогда
		
			Объект.ДатаНачалаДействия = ДатаНачала;
		
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКатегориями(Команда)
	
	ЗаполнитьКатегориямиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымДругогоФормата(Команда)
	Если Объект.ТоварныеКатегории.Количество()>0 Тогда
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоДаннымДругогоФорматаЗавершение", ЭтотОбъект), НСтр("ru = 'Табличная часть содержит строки и будет перезаполнена';
																												|en = 'Tabular section contains rows and will be refilled'"), РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;
	ЗаполнитьПоДаннымДругогоФорматаФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымДругогоФорматаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьПоДаннымДругогоФорматаФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымДругогоФорматаФрагмент()
	
	ОткрытьФорму("Справочник.ФорматыМагазинов.ФормаВыбора",,,,,, 
					Новый ОписаниеОповещения("ЗаполнитьПоДаннымДругогоФорматаФрагментЗавершение", ЭтотОбъект), 
					РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымДругогоФорматаФрагментЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыбранныйФорматМагазина = Результат;
	Если ВыбранныйФорматМагазина = Неопределено Тогда
		Возврат;
	Иначе
		ЗаполнитьПоДаннымДругогоФорматаСервер(ВыбранныйФорматМагазина);
		СформироватьДеревоПоТаблицеКатегорий();
		ОбновитьИтоговыеПоказателиСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(Команда)
	ЭлементыДерева = ДеревоКатегорий.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		ИДСтроки = ЭлементДерева.ПолучитьИдентификатор();
		Элементы.ДеревоКатегорий.Развернуть(ИДСтроки, Истина);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПроцентОтклоненияВсемСтрокам(Команда)
	Процент = 0;
	ТекстЗаголовкаВводаЧисла = НСтр("ru = 'Введите % отклонения';
									|en = 'Enter % of variance'");
	ПоказатьВводЧисла(Новый ОписаниеОповещения("УстановитьПроцентОтклоненияВсемСтрокамЗавершение", ЭтотОбъект, Новый Структура("Процент", Процент)), Процент, ТекстЗаголовкаВводаЧисла, 3, 0);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПроцентОтклоненияВсемСтрокамЗавершение(Число, ДополнительныеПараметры) Экспорт
    
    Процент = ?(Число = Неопределено, ДополнительныеПараметры.Процент, Число);
    
    
    Если (Число <> Неопределено) Тогда
        Если Процент > 100 Тогда
            ТекстПредупреждения = НСтр("ru = 'Отклонение не может превышать 100%';
										|en = 'Variance cannot be more than 100%'");
            ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
        Иначе
            ЭлементыДерева = ДеревоКатегорий.ПолучитьЭлементы();
            УстановитьПроцентПодчиненным(ЭлементыДерева, Процент);
        КонецЕсли;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьПроцентПодчиненным(ЭлементыДерева, Процент)
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		ЭлементДерева.ПроцентОтклонения = Процент;
		Подчиненные = ЭлементДерева.ПолучитьЭлементы();
		Если Подчиненные.Количество() > 0 Тогда
			УстановитьПроцентПодчиненным(Подчиненные, Процент);
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры
	
&НаКлиенте
Процедура СвернутьДерево(Команда)
	ЭлементыДерева = ДеревоКатегорий.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		ИДСтроки = ЭлементДерева.ПолучитьИдентификатор();
		Элементы.ДеревоКатегорий.Свернуть(ИДСтроки);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМарку(Команда)
	ТекСтрока = Элементы.ДеревоКатегорий.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Марку можно добавить только в подчинение какой-либо категории';
																					|en = 'Brand can be added only to any category subordination'"));
	Иначе
		ТипСтроки = 0;
		Если ТипЗнч(ТекСтрока.ВидКатегорияМарка) = Тип("СправочникСсылка.ТоварныеКатегории") Тогда
			Если НЕ ТекСтрока.ЭтоГруппаКатегорий Тогда
				ТипСтроки = 1;
			КонецЕсли;
		ИначеЕсли ТипЗнч(ТекСтрока.ВидКатегорияМарка) = Тип("СправочникСсылка.Марки")
			ИЛИ ТипЗнч(ТекСтрока.ВидКатегорияМарка) = Тип("Строка") Тогда
			ТипСтроки = 2;
		КонецЕсли;
		Если ТипСтроки > 0 Тогда
			ВыбраннаяМарка = Неопределено;

			ОткрытьФорму("Справочник.Марки.ФормаВыбора", , ЭтаФорма,,,, Новый ОписаниеОповещения("ДобавитьМаркуЗавершение", ЭтотОбъект, Новый Структура("ТипСтроки", ТипСтроки)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Марку можно добавить только в подчинение какой-либо категории';
														|en = 'Brand can be added only to any category subordination'"));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМаркуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТипСтроки = ДополнительныеПараметры.ТипСтроки;
    
    
    ВыбраннаяМарка = Результат;
    Если ВыбраннаяМарка<>Неопределено Тогда
        ТекСтрокаКоллекция = ДеревоКатегорий.НайтиПоИдентификатору(Элементы.ДеревоКатегорий.ТекущаяСтрока);
        Если ТекСтрокаКоллекция<>Неопределено Тогда
            Если ТипСтроки = 1 Тогда
                // добавляем в подчинение к текущей строке
                СтрокаРодителя = ТекСтрокаКоллекция;
            Иначе
                // добавляем в подчинение к строке родителя
                СтрокаРодителя = ТекСтрокаКоллекция.ПолучитьРодителя();
            КонецЕсли;
            ЭлементыСтроки = СтрокаРодителя.ПолучитьЭлементы();
            Если МаркаУжеДобавлена(СтрокаРодителя.ПолучитьИдентификатор(), ВыбраннаяМарка) Тогда
                ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Марка уже добавлена в данной категории';
															|en = 'Brand has already been added to this category'"));
            Иначе
                НоваяСтрока = ЭлементыСтроки.Добавить();
                НоваяСтрока.ВидКатегорияМарка = ВыбраннаяМарка;
                НоваяСтрока.Представление = Строка(ВыбраннаяМарка);
                НоваяСтрока.Квота = 0;
                НоваяСтрока.ПроцентОтклонения = 0;
                НоваяСтрока.ИндексКартинки = 2;
                ОбновитьПроцентРодителя(НоваяСтрока.ПолучитьРодителя());
            КонецЕсли;
        КонецЕсли;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорийИзменить(Команда)
	ТекущиеДанные = Элементы.ДеревоКатегорий.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Элементы.ДеревоКатегорий.ИзменитьСтроку();
	КонецЕсли;
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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКвотыИзФайла(Команда)
	
	ПараметрыЗагрузки = ЗагрузкаДанныхИзФайлаКлиент.ПараметрыЗагрузкиДанных();
	ПараметрыЗагрузки.ПолноеИмяТабличнойЧасти = "УстановкаКвотАссортимента.ТоварныеКатегории";
	ПараметрыЗагрузки.Заголовок = НСтр("ru = 'Загрузка квот ассортимента из файла';
										|en = 'Import assortment quotas from file'");
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьКвотыИзФайлаЗавершение", ЭтотОбъект);
	ЗагрузкаДанныхИзФайлаКлиент.ПоказатьФормуЗагрузки(ПараметрыЗагрузки, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКвотуРодителя(Родитель)
	
	ЭлементыРодителя = Родитель.ПолучитьЭлементы();
	КвотаИтог = 0;
	Для Каждого ЭлементРодителя Из ЭлементыРодителя Цикл
		КвотаИтог = КвотаИтог+ЭлементРодителя.Квота;
	КонецЦикла;
	Родитель.Квота = КвотаИтог;
	//
	РодительВыше = Родитель.ПолучитьРодителя();
	Если РодительВыше<>Неопределено Тогда
		ОбновитьКвотуРодителя(РодительВыше);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПроцентРодителя(Родитель, ПередУдалением = Ложь)
	
	ЭлементыРодителя = Родитель.ПолучитьЭлементы();
	ПроцентИтог = 0;
	КоличествоПодчиненных = 0;
	Для Каждого ЭлементРодителя Из ЭлементыРодителя Цикл
		ПроцентИтог = ПроцентИтог + ЭлементРодителя.ПроцентОтклонения;
		КоличествоПодчиненных = КоличествоПодчиненных + 1;
	КонецЦикла;
	Если ПередУдалением Тогда
		КоличествоПодчиненных = КоличествоПодчиненных - 1;
	КонецЕсли;
	Родитель.ПроцентОтклонения =  ?(КоличествоПодчиненных = 0, 0, ПроцентИтог / КоличествоПодчиненных);
	//
	РодительВыше = Родитель.ПолучитьРодителя();
	Если РодительВыше <> Неопределено Тогда
		Если ПередУдалением Тогда
			ЭлементыНиже = РодительВыше.ПолучитьЭлементы();
			Если ЭлементыНиже.Количество() > 1
				И ЭлементыРодителя.Количество() > 1 Тогда
				ОбновитьПроцентРодителя(РодительВыше);
			Иначе
				// Эта строка также будет удаляться
				ОбновитьПроцентРодителя(РодительВыше, Истина);
			КонецЕсли;
		Иначе
			ОбновитьПроцентРодителя(РодительВыше);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НаличиеПлана()
	ЕстьПлан = Ложь;
	Если ЗначениеЗаполнено(Объект.ОбъектПланирования) И ЗначениеЗаполнено(Объект.ДатаНачалаДействия) Тогда
		ЕстьПлан = НаличиеПланаСервер();
		Если ЕстьПлан Тогда
			ТекстПредупреждения = НСтр("ru = 'На %1 для выбранного формата уже существует документ установки квот.';
										|en = 'Quota setting document already exists for the selected format on %1.'")
			+ Символы.ПС + НСтр("ru = 'Установка квот может производиться не чаще 1 раза в месяц.';
								|en = 'Quotas can be set only once a month.'")
			+ Символы.ПС + НСтр("ru = 'Выберите другую дату или формат магазинов.';
								|en = 'Select another date or store format.'");
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ТекстПредупреждения,
									Формат(Объект.ДатаНачалаДействия,"ДФ = dd.MM.yyyy"));
			ПоказатьПредупреждение(,ТекстПредупреждения);
		КонецЕсли;
	КонецЕсли;
	Возврат ЕстьПлан;
КонецФункции

&НаКлиенте
Процедура УдалитьСтрокуРодителяПриНеобходимости(ИндексТекущий, КоличествоДопустимых)
	ТекущийРодитель = ДеревоКатегорий.НайтиПоИдентификатору(ИндексТекущий);
	Если ТекущийРодитель <> Неопределено Тогда
		ТекущиеПодчиненныеЭлементы = ТекущийРодитель.ПолучитьЭлементы();
		Если ТекущиеПодчиненныеЭлементы.Количество() = КоличествоДопустимых Тогда
			ТекущийРодительРодителя = ТекущийРодитель.ПолучитьРодителя();
			Если ТекущийРодительРодителя = Неопределено Тогда
				ПодчиненныеРодителяРодителя = ДеревоКатегорий.ПолучитьЭлементы();
				ПодчиненныеРодителяРодителя.Удалить(ТекущийРодитель);
				КоличествоДопустимых = 0;
			Иначе
				ПодчиненныеРодителяРодителя = ТекущийРодительРодителя.ПолучитьЭлементы();
				ПодчиненныеРодителяРодителя.Удалить(ТекущийРодитель);
				КоличествоДопустимых = 0;
				ИндексРодителяРодителя = ТекущийРодительРодителя.ПолучитьИдентификатор();
				УдалитьСтрокуРодителяПриНеобходимости(ИндексРодителяРодителя, КоличествоДопустимых);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УменьшитьКвотуРодителяПослеУдаления(ТекущаяСтрока, ВычитаемаяКвота)
	ТекущийРодитель = ТекущаяСтрока.ПолучитьРодителя();
	Если ТекущийРодитель <> Неопределено Тогда
		ТекущийРодитель.Квота = ТекущийРодитель.Квота-ВычитаемаяКвота;
		УменьшитьКвотуРодителяПослеУдаления(ТекущийРодитель, ВычитаемаяКвота);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымДругогоФорматаСервер(ВыбранныйОбъектПланирования)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Квоты.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	Квоты.Марка КАК Марка,
	|	Квоты.Квота КАК Квота,
	|	Квоты.ПроцентОтклонения КАК ПроцентОтклонения
	|ИЗ
	|	РегистрСведений.КвотыАссортимента.СрезПоследних(&НаДату, ОбъектПланирования = &ОбъектПланирования) КАК Квоты
	|ГДЕ
	|	Квоты.Период В
	|			(ВЫБРАТЬ
	|				МАКСИМУМ(К.Период)
	|			ИЗ
	|				РегистрСведений.КвотыАссортимента КАК К
	|			ГДЕ
	|				К.Период <=  &НаДату
	|				И К.ОбъектПланирования = &ОбъектПланирования)";
	Запрос.УстановитьПараметр("ОбъектПланирования", ВыбранныйОбъектПланирования);
	Запрос.УстановитьПараметр("НаДату", Объект.Дата);
	Выборка = Запрос.Выполнить().Выбрать();
	ТоварныеКатегорииОбъекта = Объект.ТоварныеКатегории;
	ТоварныеКатегорииОбъекта.Очистить();
	Пока Выборка.Следующий() Цикл
		НоваяСтрокаКатегорий = ТоварныеКатегорииОбъекта.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаКатегорий,Выборка);
	КонецЦикла;
	Элементы.ДеревоКатегорий.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКатегориямиСервер()
	ПерезаполнитьКатегории();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаКатегории.ТоварнаяКатегория,
	|	ТаблицаКатегории.Марка,
	|	ТаблицаКатегории.Квота,
	|	ТаблицаКатегории.ПроцентОтклонения
	|ПОМЕСТИТЬ втДокументКатегории
	|ИЗ
	|	&ТаблицаКатегории КАК ТаблицаКатегории
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварныеКатегории.Владелец КАК ВидНоменклатуры,
	|	ВидыНоменклатуры.Наименование КАК НаименованиеДополнительногоВидаНоменклатуры,
	|	ВидыНоменклатуры.Ссылка КАК ДополнительныйВидНоменклатуры
	|ИЗ
	|	Справочник.ТоварныеКатегории КАК ТоварныеКатегории
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|		ПО ТоварныеКатегории.Владелец = ВидыНоменклатуры.ВладелецТоварныхКатегорий
	|УПОРЯДОЧИТЬ ПО
	|	ВидНоменклатуры
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникКатегории.Владелец КАК ВидНоменклатуры,
	|	СправочникКатегории.Владелец.ЭтоГруппа КАК ЭтоГруппаВидов,
	|	СправочникКатегории.Владелец.Наименование КАК НаименованиеВидаНоменклатуры,
	|	СправочникКатегории.Ссылка КАК ТоварнаяКатегория,
	|	СправочникКатегории.Наименование КАК НаименованиеКатегории,
	|	СправочникКатегории.ЭтоГруппа КАК ЭтоГруппаКатегорий,
	|	ЕСТЬNULL(ДокументКатегории.Марка,ЗНАЧЕНИЕ(Справочник.Марки.ПустаяСсылка)) КАК Марка,
	|	ЕСТЬNULL(ДокументКатегории.Марка.Наименование,"""") КАК НаименованиеМарки,
	|	ЕСТЬNULL(ДокументКатегории.Квота, 0) КАК Квота,
	|	ЕСТЬNULL(ДокументКатегории.ПроцентОтклонения, 0) КАК ПроцентОтклонения
	|ИЗ
	|	Справочник.ТоварныеКатегории КАК СправочникКатегории
	|		ЛЕВОЕ СОЕДИНЕНИЕ втДокументКатегории КАК ДокументКатегории
	|		ПО СправочникКатегории.Ссылка = ДокументКатегории.ТоварнаяКатегория
	|ГДЕ
	|	НЕ СправочникКатегории.ЭтоГруппа
	|	И НЕ СправочникКатегории.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеВидаНоменклатуры,
	|	НаименованиеКатегории,
	|	НаименованиеМарки
	|ИТОГИ
	|	СУММА(Квота),
	|	0 КАК ПроцентОтклонения
	|ПО
	|	ВидНоменклатуры ИЕРАРХИЯ,
	|	ТоварнаяКатегория ИЕРАРХИЯ";
	
	Запрос.УстановитьПараметр("ТаблицаКатегории",Объект.ТоварныеКатегории.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ДополнительныеВиды = СоотвествиеДополнительныйВидовПоРезультатуЗапроса(МассивРезультатов[МассивРезультатов.Количество() - 2]);
	
	ЗаполнитьДеревоПоРезультатуЗапроса(МассивРезультатов[МассивРезультатов.Количество() - 1], ДополнительныеВиды);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоговыеПоказателиСервер()
	ДеревоОбъект = РеквизитФормыВЗначение("ДеревоКатегорий",Тип("ДеревоЗначений"));
	КвотаВсего = ДеревоОбъект.Строки.Итог("Квота");
	Если КвотаВсего = КвотаРекомендованная Тогда
		Элементы.КвотаВсего.ЦветТекста = Новый Цвет(0,128,0);
		Элементы.КвотаРекомендованная.ЦветТекста = Новый Цвет(0,128,0);
	Иначе
		Элементы.КвотаВсего.ЦветТекста = Новый Цвет(22,39,121);
		Элементы.КвотаРекомендованная.ЦветТекста = Новый Цвет(22,39,121);
	КонецЕсли;
	ДеревоОбъект = Неопределено;
КонецПроцедуры

&НаСервере
Процедура ОбновитьРекомендованныеПоказателиСервер()
	
	Если ТипЗнч(Объект.ОбъектПланирования) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
	
		КвотаРекомендованная = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ОбъектПланирования, "КоличествоАссортиментныхПозиций");
	
	Иначе
	
		КвотаРекомендованная = 0;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоПоТаблицеКатегорий()
	
	ТаблицаИсточник = Объект.ТоварныеКатегории.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаКатегории.ТоварнаяКатегория,
	|	ТаблицаКатегории.Марка,
	|	ТаблицаКатегории.Квота,
	|	ТаблицаКатегории.ПроцентОтклонения
	|ПОМЕСТИТЬ втДокументКатегории
	|ИЗ
	|	&ТаблицаИсточник КАК ТаблицаКатегории
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫРАЗИТЬ(втДокументКатегории.ТоварнаяКатегория КАК Справочник.ТоварныеКатегории).Владелец КАК ВидНоменклатуры,
	|	ВидыНоменклатуры.Наименование КАК НаименованиеДополнительногоВидаНоменклатуры,
	|	ВидыНоменклатуры.Ссылка КАК ДополнительныйВидНоменклатуры
	|ИЗ
	|	втДокументКатегории КАК втДокументКатегории
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|		ПО втДокументКатегории.ТоварнаяКатегория.Владелец = ВидыНоменклатуры.ВладелецТоварныхКатегорий
	|УПОРЯДОЧИТЬ ПО
	|	ВидНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварныеКатегории.ТоварнаяКатегория.Владелец КАК ВидНоменклатуры,
	|	ТоварныеКатегории.ТоварнаяКатегория.Владелец.ЭтоГруппа КАК ЭтоГруппаВидов,
	|	ТоварныеКатегории.ТоварнаяКатегория.Владелец.Наименование КАК НаименованиеВидаНоменклатуры,
	|	ТоварныеКатегории.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	ТоварныеКатегории.ТоварнаяКатегория.Наименование КАК НаименованиеКатегории,
	|	ТоварныеКатегории.ТоварнаяКатегория.ЭтоГруппа КАК ЭтоГруппаКатегорий,
	|	ТоварныеКатегории.Марка КАК Марка,
	|	ТоварныеКатегории.Марка.Наименование КАК НаименованиеМарки,
	|	ТоварныеКатегории.Квота КАК Квота,
	|	ТоварныеКатегории.ПроцентОтклонения КАК ПроцентОтклонения
	|ИЗ
	|	втДокументКатегории КАК ТоварныеКатегории
	|ГДЕ
	|	НЕ ТоварныеКатегории.ТоварнаяКатегория.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеВидаНоменклатуры,
	|	НаименованиеКатегории,
	|	НаименованиеМарки
	|ИТОГИ
	|	СУММА(Квота),
	|	СРЕДНЕЕ(ПроцентОтклонения)
	|ПО
	|	ВидНоменклатуры ИЕРАРХИЯ,
	|	ТоварнаяКатегория ИЕРАРХИЯ";
	
	Запрос.УстановитьПараметр("ТаблицаИсточник",ТаблицаИсточник);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ДополнительныеВиды = СоотвествиеДополнительныйВидовПоРезультатуЗапроса(МассивРезультатов[МассивРезультатов.Количество() - 2]);
	
	//
	ЗаполнитьДеревоПоРезультатуЗапроса(МассивРезультатов[МассивРезультатов.Количество() - 1], ДополнительныеВиды);
	
КонецПроцедуры

&НаСервере
Функция СоотвествиеДополнительныйВидовПоРезультатуЗапроса(РезультатЗапроса)
	ВыборкаПоДопВидам = РезультатЗапроса.Выбрать();
	
	Если ВыборкаПоДопВидам.Следующий() Тогда
		ДополнительныеВидыСоответсвие = Новый Соответствие;
		
		ТекущийВид = ВыборкаПоДопВидам.ВидНоменклатуры; 
		МассивДопВидов = Новый Массив;
		
		ВыборкаПоДопВидам.Сбросить();
		Пока ВыборкаПоДопВидам.Следующий() Цикл
			
			Если ВыборкаПоДопВидам.ВидНоменклатуры <> ТекущийВид Тогда
				
				ДополнительныеВидыСоответсвие.Вставить(ТекущийВид, Новый ФиксированныйМассив(МассивДопВидов));
				МассивДопВидов = Новый Массив;
				
			КонецЕсли;
			
			ОписаниеДопВида = Новый Структура;
			ОписаниеДопВида.Вставить("Ссылка",ВыборкаПоДопВидам.ДополнительныйВидНоменклатуры); 
			ОписаниеДопВида.Вставить("Наименование",ВыборкаПоДопВидам.НаименованиеДополнительногоВидаНоменклатуры); 
			
			МассивДопВидов.Добавить(Новый ФиксированнаяСтруктура(ОписаниеДопВида));
			
		КонецЦикла;	
		ДополнительныеВидыСоответсвие.Вставить(ТекущийВид, Новый ФиксированныйМассив(МассивДопВидов));
		
		ДополнительныеВиды = Новый ФиксированноеСоответствие(ДополнительныеВидыСоответсвие);
	Иначе
		ДополнительныеВиды = Новый ФиксированноеСоответствие(Новый Соответствие);
	КонецЕсли;
	
	Возврат ДополнительныеВиды;
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоПоРезультатуЗапроса(РезультатЗапроса, ДополнительныеВиды)
	ДеревоОбъект = РеквизитФормыВЗначение("ДеревоКатегорий", Тип("ДеревоЗначений"));
	ДеревоОбъект.Строки.Очистить();
	//
	ДеревоРезультат = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗаполнитьПодчиненныеСтроки(ДеревоОбъект, ДеревоРезультат, ДополнительныеВиды);
	
	ЗначениеВРеквизитФормы(ДеревоОбъект,"ДеревоКатегорий");
	Элементы.ДеревоКатегорий.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодчиненныеСтроки(ПриемникРодитель, ИсточникРодитель, ДополнительныеВиды)
	
	Для Каждого СтрокаИсточника Из ИсточникРодитель.Строки Цикл
		
		СтрокаПриемника = ПриемникРодитель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПриемника,СтрокаИсточника);
		Если СтрокаИсточника.Марка <> Null Тогда
			Если ЗначениеЗаполнено(СтрокаИсточника.Марка) Тогда
				СтрокаПриемника.ВидКатегорияМарка = СтрокаИсточника.Марка;
				СтрокаПриемника.Представление = СтрокаИсточника.НаименованиеМарки;
			Иначе
				СтрокаПриемника.ВидКатегорияМарка = Справочники.Марки.ПустаяСсылка();
				СтрокаПриемника.Представление = НСтр("ru = 'Прочие марки';
													|en = 'Other brands'");
			КонецЕсли;
			
			СтрокаПриемника.ЭтоИтог = Ложь;
			СтрокаПриемника.ИндексКартинки = 2;
		ИначеЕсли СтрокаИсточника.ТоварнаяКатегория <> Null Тогда
			СтрокаПриемника.ВидКатегорияМарка = СтрокаИсточника.ТоварнаяКатегория;
			СтрокаПриемника.Представление = СтрокаИсточника.НаименованиеКатегории;
			СтрокаПриемника.ЭтоИтог = Истина;
			Если СтрокаИсточника.ЭтоГруппаКатегорий Тогда
				СтрокаПриемника.ИндексКартинки = 0;
			Иначе
				СтрокаПриемника.ИндексКартинки = 1;
			КонецЕсли;
		Иначе
			ТекстДополнительныхВидов = "";
			ТекстВида = НСтр("ru = '%ОсновнойВид%';
							|en = '%ОсновнойВид%'");
			
			Если Не СтрокаИсточника.ЭтоГруппаВидов Тогда 
				НайденныеДополнительныеВиды = ДополнительныеВиды.Получить(СтрокаИсточника.ВидНоменклатуры);
				
				Если НайденныеДополнительныеВиды <> Неопределено Тогда
					ТекстВида = НСтр("ru = '%ОсновнойВид% (а так же %ДополнительныеВиды%)';
									|en = '%ОсновнойВид% (as well as %ДополнительныеВиды%)'");
					
					Для Каждого ДополнительныйВид Из НайденныеДополнительныеВиды Цикл
						ТекстДополнительныхВидов = ТекстДополнительныхВидов + ДополнительныйВид.Наименование + ", ";	
					КонецЦикла;
					
					ТекстДополнительныхВидов = Лев(ТекстДополнительныхВидов, СтрДлина(ТекстДополнительныхВидов) - 2);
				КонецЕсли;
				
			КонецЕсли;
			СтрокаПриемника.ВидКатегорияМарка = СтрокаИсточника.ВидНоменклатуры;
			
			СтрокаПриемника.Представление = ТекстВида;
			СтрокаПриемника.Представление = СтрЗаменить(СтрокаПриемника.Представление, "%ОсновнойВид%", СтрокаИсточника.НаименованиеВидаНоменклатуры);
			СтрокаПриемника.Представление = СтрЗаменить(СтрокаПриемника.Представление, "%ДополнительныеВиды%", ТекстДополнительныхВидов);
			
			СтрокаПриемника.ЭтоИтог = Истина;
			СтрокаПриемника.ИндексКартинки = 0;
		КонецЕсли;
		
		// И рекурсивно подчиненные
		ЗаполнитьПодчиненныеСтроки(СтрокаПриемника,СтрокаИсточника, ДополнительныеВиды);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьКатегории(ТекущийОбъект = Неопределено)
	Если ТекущийОбъект = Неопределено Тогда
		Объект.ТоварныеКатегории.Очистить();
		ОбработатьПодчиненныеСтрокиПриПерезаполнении(ДеревоКатегорий);
	Иначе
		ТекущийОбъект.ТоварныеКатегории.Очистить();
		ОбработатьПодчиненныеСтрокиПриПерезаполнении(ДеревоКатегорий, ТекущийОбъект);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодчиненныеСтрокиПриПерезаполнении(ЭлементДереваРодитель, ТекущийОбъект = Неопределено)
	ЭлементыДерева = ЭлементДереваРодитель.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.ЭтоИтог Тогда
			ОбработатьПодчиненныеСтрокиПриПерезаполнении(ЭлементДерева, ТекущийОбъект);
		Иначе
			ДобавитьСтрокуВТаблицуКатегорийПриПерезаполнении(ЭлементДерева, ТекущийОбъект);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуВТаблицуКатегорийПриПерезаполнении(ЭлементДерева, ТекущийОбъект = Неопределено)
	Родитель = ЭлементДерева.ПолучитьРодителя();
	Если Родитель<>Неопределено Тогда
		ТекущаяКатегория = Родитель.ВидКатегорияМарка;
		Если ТекущийОбъект = Неопределено Тогда
			НоваяСтрока = Объект.ТоварныеКатегории.Добавить();
		Иначе
			НоваяСтрока = ТекущийОбъект.ТоварныеКатегории.Добавить();
		КонецЕсли;
		НоваяСтрока.ТоварнаяКатегория = ТекущаяКатегория;
		//
		НоваяСтрока.Марка				 =  ЭлементДерева.ВидКатегорияМарка;
		НоваяСтрока.Квота				 =  ЭлементДерева.Квота;
		НоваяСтрока.ПроцентОтклонения	 =  ЭлементДерева.ПроцентОтклонения;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДеревоКатегорийПослеУдаленияСервер()
	ПерезаполнитьКатегории();
	ОбновитьИтоговыеПоказателиСервер();
КонецПроцедуры

&НаСервере
Функция НаличиеПланаСервер()
	Возврат Документы.УстановкаКвотАссортимента.СуществуетПлан(Объект.ОбъектПланирования, Объект.ДатаНачалаДействия, Объект.Ссылка);
КонецФункции

&НаСервере
Функция МаркаУжеДобавлена(СтрокаРодителя, ВыбраннаяМарка)
	УжеДобавлена = Ложь;
	ПодчиненныеСтроки = ДеревоКатегорий.НайтиПоИдентификатору(СтрокаРодителя).ПолучитьЭлементы();
	Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
		Если ПодчиненнаяСтрока.ВидКатегорияМарка = ВыбраннаяМарка Тогда
			УжеДобавлена = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат УжеДобавлена;
КонецФункции

&НаСервереБезКонтекста
Функция КоллекцияНоменклатурыПриИзмененииНаСервере(КоллекцияНоменклатуры)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КоллекцияНоменклатуры, "ДатаНачалаЗакупок");
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьКвотыИзФайлаЗавершение(АдресЗагруженныхДанных, ДополнительныеПараметры) Экспорт
	
	Если АдресЗагруженныхДанных = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗагрузитьКвотыИзФайлаНаСервере(АдресЗагруженныхДанных);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьКвотыИзФайлаНаСервере(АдресЗагруженныхДанных)
	
	ПерезаполнитьКатегории();
	
	ЗагруженныеДанные = ПолучитьИзВременногоХранилища(АдресЗагруженныхДанных);
	
	СтрокиДобавлены = Ложь;
	Для каждого СтрокаТаблицы Из ЗагруженныеДанные Цикл 
		
		НоваяСтрока = Объект.ТоварныеКатегории.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		СтрокиДобавлены = Истина;

	КонецЦикла;
	
	Если СтрокиДобавлены Тогда
		Модифицированность = Истина;
		
		СформироватьДеревоПоТаблицеКатегорий();
		
		ОбновитьИтоговыеПоказателиСервер();
		ОбновитьРекомендованныеПоказателиСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
