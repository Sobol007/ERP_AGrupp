
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Новое") Тогда
		Новое = Параметры.Новое;
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Идентификатор = ""
		И (НЕ Параметры.Свойство("ЗначениеКопирования")
		ИЛИ НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования.Идентификатор)) Тогда
		
		Если Параметры.Свойство("ЭтоУсловияЭтапов") Тогда
			ЭтоУсловияЭтапов = Параметры.ЭтоУсловияЭтапов;
		КонецЕсли;
		
		Если Параметры.Свойство("СуществующиеУсловия") Тогда
			Для Каждого КлючИЗначение ИЗ Параметры.СуществующиеУсловия Цикл
				НоваяСтрока = СуществующиеУсловия.Добавить();
				НоваяСтрока.Идентификатор	= КлючИЗначение.Ключ;
				НоваяСтрока.Наименование	= КлючИЗначение.Значение;
			КонецЦикла;
		КонецЕсли;
		
		Если Параметры.Свойство("Объект") Тогда
			Запись.Объект = Параметры.Объект;
		КонецЕсли;
		
		Если Параметры.Свойство("ТочкаМаршрута") Тогда
			Запись.ТочкаМаршрута = Параметры.ТочкаМаршрута;
		КонецЕсли;
		
		Если Параметры.Свойство("Событие") Тогда
			Запись.Событие = Параметры.Событие;
		КонецЕсли;
		
		Если Параметры.Свойство("ТипДействия") Тогда
			Запись.ТипДействия = Параметры.ТипДействия;
		КонецЕсли;
		
		Если Параметры.Свойство("Проверка") Тогда
			Запись.Проверка = Параметры.Проверка;
		КонецЕсли;
		
		Если Параметры.Свойство("Исполнителю") Тогда
			Запись.Исполнителю = Параметры.Исполнителю;
		КонецЕсли;
		
		Если Параметры.Свойство("Ответственному") Тогда
			Запись.Ответственному = Параметры.Ответственному;
		КонецЕсли;
		
		Если Параметры.Свойство("Клиенту") Тогда
			Запись.Клиенту = Параметры.Клиенту;
		КонецЕсли;
		
		Если Параметры.Свойство("ВыражениеУсловия") Тогда
			Запись.ВыражениеУсловия = Параметры.ВыражениеУсловия;
		КонецЕсли;
		
		Если Параметры.Свойство("ПредставлениеОтбора") Тогда
			Запись.ПредставлениеОтбора = Параметры.ПредставлениеОтбора;
		КонецЕсли;
		
		Если Параметры.Свойство("СпособЗаданияУсловия") И ЗначениеЗаполнено(Параметры.СпособЗаданияУсловия) Тогда
			Запись.СпособЗаданияУсловия = Параметры.СпособЗаданияУсловия;
		Иначе
			Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.ВРежимеКонструктора;
		КонецЕсли;
		
		Если Параметры.Свойство("Наименование") Тогда
			Запись.Наименование = Параметры.Наименование;
		КонецЕсли;
		
		Если Параметры.Свойство("Цель") Тогда
			// Запись.Цель = Параметры.Цель;
			Цель = Параметры.Цель;
		КонецЕсли;
		
		Если Параметры.Свойство("АдресНастройкаКомбинацииУсловий") И ЗначениеЗаполнено(Параметры.АдресНастройкаКомбинацииУсловий) Тогда
			НастройкиКомбинацииУсловий = ПолучитьИзВременногоХранилища(Параметры.АдресНастройкаКомбинацииУсловий);
			НастроитьКомпоновщикКомбинацииУсловий(НастройкиКомбинацииУсловий);
		Иначе
			НастроитьКомпоновщикКомбинацииУсловий();
		КонецЕсли;
		
		Если Параметры.Свойство("АдресНастройкаУсловия") И ЗначениеЗаполнено(Параметры.АдресНастройкаУсловия) Тогда
			Настройки = ПолучитьИзВременногоХранилища(Параметры.АдресНастройкаУсловия);
			НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(Настройки);
		Иначе
			НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта();
		КонецЕсли;
		
		Если Параметры.Свойство("Идентификатор") И ЗначениеЗаполнено(Параметры.Идентификатор) Тогда
			Запись.Идентификатор = Параметры.Идентификатор;
		Иначе
			Запись.Идентификатор = Строка(Новый УникальныйИдентификатор());
		КонецЕсли;
		
	ИначеЕсли Запись.ИсходныйКлючЗаписи.Идентификатор = ""
		И Параметры.Свойство("ЗначениеКопирования")
		И ЗначениеЗаполнено(Параметры.ЗначениеКопирования.Идентификатор) Тогда
		
		ЗаписьРегистра = РегистрыСведений.bpmУсловияЭтапов.СоздатьМенеджерЗаписи();
		ЗаписьРегистра.Объект			= Параметры.ЗначениеКопирования.Объект;
		ЗаписьРегистра.Идентификатор	= Параметры.ЗначениеКопирования.Идентификатор;
		ЗаписьРегистра.Прочитать();
		
		Настройки = ЗаписьРегистра.НастройкаУсловия.Получить();
		НастройкиКомбинацииУсловий = ЗаписьРегистра.НастройкаКомбинацииУсловий.Получить();
		НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(Настройки);
		НастроитьКомпоновщикКомбинацииУсловий(НастройкиКомбинацииУсловий);
		Запись.Идентификатор = Строка(Новый УникальныйИдентификатор());
	Иначе
		ЗаписьРегистра = РеквизитФормыВЗначение("Запись");
		
		Настройки = ЗаписьРегистра.НастройкаУсловия.Получить();
		НастройкиКомбинацииУсловий = ЗаписьРегистра.НастройкаКомбинацииУсловий.Получить();
		НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(Настройки);
		НастроитьКомпоновщикКомбинацииУсловий(НастройкиКомбинацииУсловий);
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы["Страница" + ОбщегоНазначения.ИмяЗначенияПеречисления(Запись.СпособЗаданияУсловия)];
	
	Элементы.КомпоновщикНастройкиОтборСгруппироватьЭлементыОтбора.Заголовок = НСтр("ru='Сгруппировать правила';en='Group rules'");
	Элементы.КомпоновщикНастройкиОтборКонтекстноеМенюСгруппироватьЭлементыОтбора.Заголовок = НСтр("ru='Сгруппировать правила';en='Group rules'");
    Элементы.КомпоновщикНастройкиОтборДобавитьЭлементОтбора.Заголовок = НСтр("ru='Добавить правило';en='Add rule'");
	Элементы.КомпоновщикНастройкиОтборКонтекстноеМенюДобавитьЭлементОтбора.Заголовок = НСтр("ru='Добавить правило';en='Add rule'");
	
	// Скрываем кнопку "Очистить" у колонки "Поле" в компоновщике отбора, который используется в режиме "Конструктор"
	Элементы.КомпоновщикНастройкиОтборЛевоеЗначение.КнопкаОчистки = Ложь;
		
	// Настройка действия при изменении вида сравнения
	Элементы.КомпоновщикНастройкиОтборВидСравнения.УстановитьДействие("ПриИзменении", "ВидСравненияПриИзменении");
		
	// Настройка действия при начале изменения правого значения сравнения
	Элементы.КомпоновщикНастройкиОтборПравоеЗначение.УстановитьДействие("НачалоВыбора", "ПравоеЗначениеНачалоВыбора");
		
	Элементы.КомпоновщикУсловийНастройкиОтборДобавитьЭлементОтбора.Заголовок = НСтр("ru='Добавить условие';en='Add condition'");
	Элементы.КомпоновщикУсловийНастройкиОтборКонтекстноеМенюДобавитьЭлементОтбора.Заголовок = НСтр("ru='Добавить условие';en='Add condition'");
	
	// Элементы.ГруппаКомпоновщик.Доступность = ЗначениеЗаполнено(ТипОбъекта);
	Элементы.ГруппаКомпоновщик.Доступность = Истина;
	
	// Настройка действия при начале изменения правого значения сравнения
	Элементы.КомпоновщикУсловийНастройкиОтборПравоеЗначение.КнопкаВыпадающегоСписка = Ложь;
	Элементы.КомпоновщикУсловийНастройкиОтборПравоеЗначение.КнопкаВыбора = Истина;
	Элементы.КомпоновщикУсловийНастройкиОтборПравоеЗначение.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
	Элементы.КомпоновщикУсловийНастройкиОтборПравоеЗначение.ИсторияВыбораПриВводе = ИсторияВыбораПриВводе.НеИспользовать;
	Элементы.КомпоновщикУсловийНастройкиОтборПравоеЗначение.УстановитьДействие("НачалоВыбора", "КомпоновщикУсловийНастройкиОтборПравоеЗначениеНачалоВыбора");
	Элементы.КомпоновщикУсловийНастройкиОтборПравоеЗначение.УстановитьДействие("ОбработкаВыбора", "КомпоновщикУсловийНастройкиОтборПравоеЗначениеОбработкаВыбора");
	
	Элементы.Событие.ТолькоПросмотр = ЭтоУсловияЭтапов;
	Элементы.ТипДействия.ТолькоПросмотр = ЭтоУсловияЭтапов;
	Элементы.Цель.ТолькоПросмотр = ЭтоУсловияЭтапов;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособЗаданияУсловияПриИзменении(Элемент)
		
	Если ЗначениеЗаполнено(Запись.СпособЗаданияУсловия) Тогда
		Если Запись.СпособЗаданияУсловия = ПредопределенноеЗначение("Перечисление.bpmСпособыЗаданияУсловия.ВРежимеКонструктора") Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы["СтраницаВРежимеКонструктора"];
		ИначеЕсли Запись.СпособЗаданияУсловия = ПредопределенноеЗначение("Перечисление.bpmСпособыЗаданияУсловия.НаВстроенномЯзыке") Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы["СтраницаНаВстроенномЯзыке"];
		ИначеЕсли Запись.СпособЗаданияУсловия = ПредопределенноеЗначение("Перечисление.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий") Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы["СтраницаКомбинацияИзДругихУсловий"];
		КонецЕсли;
		// Элементы.ГруппаОтветственныйИКомментарий.Видимость = 
		//	(Запись.СпособЗаданияУсловия = ПредопределенноеЗначение("Перечисление.bpmСпособыЗаданияУсловия.НаВстроенномЯзыке"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСравненияПриИзменении(Элемент)
	
	СтандартнаяОбработка = Ложь;
	ЭлементОтбора = Компоновщик.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастройкиОтбор.ТекущаяСтрока);
	Если ЭлементОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.Пользователи")
		ИЛИ 
		(ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СписокЗначений")
			И ЭлементОтбора.ПравоеЗначение.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Пользователи"))) Тогда
		
		ПараметрыФормы = Новый Структура;
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии
			ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии Тогда
			// ЭлементОтбора.ПравоеЗначение = ПредопределенноеЗначение("Справочник.РабочиеГруппы.ПустаяСсылка");
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭлементОтбора = Компоновщик.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикНастройкиОтбор.ТекущаяСтрока);
	Если ЭлементОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.ЗначенияСвойствОбъектов") Тогда
		СтандартнаяОбработка = Ложь;
		ИмяДопРеквизита = Строка(ЭлементОтбора.ЛевоеЗначение);
		ИмяДопРеквизита = Сред(ИмяДопРеквизита, Найти(ИмяДопРеквизита, "["));
		ИмяДопРеквизита = Сред(ИмяДопРеквизита, 2, СтрДлина(ИмяДопРеквизита) - 2);
		ВладелецЗначения = ПолучитьВладельцаЗначенияДопРеквизита(ИмяДопРеквизита);

		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", ВладелецЗначения));
		ОткрытьФорму("Справочник.ЗначенияСвойствОбъектов.Форма.ФормаСписка", ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметПриИзменении(Элемент)
	
	ПроверитьВыражениеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТипВыбранный = ТипПоТипуОбъекта(Запись.ТипОбъекта);
	
	ПолноеИмя = ПолноеИмяПоТипу(ТипВыбранный);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПредметСтрокойНажатиеЗавершение", ЭтотОбъект);
	РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ОткрытьФорму(ПолноеИмя + ".ФормаВыбора", , , , , , ОписаниеОповещения, РежимОткрытияОкна);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикУсловийНастройкиОтбор

&НаКлиенте
Процедура КомпоновщикУсловийНастройкиОтборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	НовыйЭлементОтбора = КомпоновщикУсловий.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ПолеОтбора = Новый ПолеКомпоновкиДанных("Результат_проверки_условия");
    НовыйЭлементОтбора.ЛевоеЗначение = ПолеОтбора;
    НовыйЭлементОтбора.Использование = Истина;
    НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикУсловийНастройкиОтборПриИзменении(Элемент)
	
	Если Элемент.ТекущиеДанные.ЛевоеЗначение <> Неопределено Тогда
		ДобавленноеУсловие = Элемент.ТекущиеДанные.ПравоеЗначение;
		Результат = ПроверитьНаличиеУсловияВДереве(Ложь);
		Если Результат Тогда
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Нельзя добавить условие ""%1"". Произошло зацикливание условий.';en='You can not add condition "" %1"". There was a looping of conditions.'"),
				ДобавленноеУсловие);
			ПоказатьПредупреждение(, ТекстПредупреждения);
			УдалитьУсловиеИзКомбинацииУсловий(ДобавленноеУсловие);
		КонецЕсли;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикУсловийНастройкиОтборПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭлементОтбора = КомпоновщикУсловий.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикУсловийНастройкиОтбор.ТекущаяСтрока);
	Если ЭлементОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Объект, ТочкаМаршрута", Запись.Объект, Запись.ТочкаМаршрута));
	ОткрытьФорму("РегистрСведений.bpmУсловияЭтапов.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикУсловийНастройкиОтборПравоеЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЭлементОтбора = КомпоновщикУсловий.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикУсловийНастройкиОтбор.ТекущаяСтрока);
	Если ЭлементОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ЭлементОтбора.ПравоеЗначение = ВернутьНаименованиеПоКлючу(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоРеквизитовОбъекта

&НаКлиенте
Процедура ДеревоРеквизитовОбъектаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Запись.ВыражениеУсловия = Запись.ВыражениеУсловия + " " + Элемент.ТекущиеДанные.ПолныйПуть;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикНастройкиОтбор

&НаКлиенте
Процедура КомпоновщикНастройкиОтборПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВставитьРеквизитИзДерева(Команда)
	
	Если Элементы.ДеревоРеквизитовОбъекта.ТекущиеДанные <> Неопределено Тогда
		Запись.ВыражениеУсловия = Запись.ВыражениеУсловия + " " + Элементы.ДеревоРеквизитовОбъекта.ТекущиеДанные.ПолныйПуть;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьОК(Команда)
	
	Если ПроверитьУсловие() Тогда
		
		СтруктураНастроекУсловия = ВернутьСтруктруНастроекУсловия();
		Модифицированность = Ложь;
		Закрыть(СтруктураНастроекУсловия);
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоРеквизитовОбъекта()
	
	СправочникОбъект = Метаданные.Задачи.ЗадачаИсполнителя;
	
	Если ОбщегоНазначения.ЭтоДокумент(СправочникОбъект) Тогда
		Элементы.ДеревоРеквизитовОбъекта.Заголовок = НСтр("ru='Реквизиты документа';en='Details of the Document'");
	Иначе
		Элементы.ДеревоРеквизитовОбъекта.Заголовок = НСтр("ru='Реквизиты объекта';en='Object attributes'");
	КонецЕсли;

	Дерево = РеквизитФормыВЗначение("ДеревоРеквизитовОбъекта");
	
	Дерево.Строки.Очистить();
	
	ПолныйПуть = "Предмет";
	НоваяСтрокаВладелецФайла = Дерево.Строки.Добавить();
	НоваяСтрокаВладелецФайла.НаименованиеРеквизита = "Предмет";
	НоваяСтрокаВладелецФайла.ТипРеквизита = Новый ОписаниеТипов("ЗадачаСсылка.ЗадачаИсполнителя");
	НоваяСтрокаВладелецФайла.ПолныйПуть = ПолныйПуть;
	
	Для Каждого СтандартныйРеквизит Из СправочникОбъект.СтандартныеРеквизиты Цикл
		Строка = НоваяСтрокаВладелецФайла.Строки.Добавить();
		Строка.НаименованиеРеквизита = СтандартныйРеквизит.Имя;
		Строка.ТипРеквизита = СтандартныйРеквизит.Тип;
		Строка.ПолныйПуть = ПолныйПуть + "." + СтандартныйРеквизит.Имя;
	КонецЦикла;
	Для Каждого Реквизит Из СправочникОбъект.Реквизиты Цикл
		Строка = НоваяСтрокаВладелецФайла.Строки.Добавить();
		Строка.НаименованиеРеквизита = Реквизит.Имя;
		Строка.ТипРеквизита = Реквизит.Тип;
		Строка.ПолныйПуть = ПолныйПуть + "." + Реквизит.Имя;
	КонецЦикла;
	Для Каждого ТабличнаяЧасть Из СправочникОбъект.ТабличныеЧасти Цикл
		СтрокаТабличнаяЧасть = НоваяСтрокаВладелецФайла.Строки.Добавить();
		СтрокаТабличнаяЧасть.НаименованиеРеквизита = ТабличнаяЧасть.Имя;
		СтрокаТабличнаяЧасть.ТипРеквизита = "Табличная часть";
		СтрокаТабличнаяЧасть.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]";
		Для Каждого СтандартныйРеквизитТЧ Из ТабличнаяЧасть.СтандартныеРеквизиты Цикл
			СтрокаРеквизитТЧ = СтрокаТабличнаяЧасть.Строки.Добавить();
			СтрокаРеквизитТЧ.НаименованиеРеквизита = СтандартныйРеквизитТЧ.Имя;
			СтрокаРеквизитТЧ.ТипРеквизита = СтандартныйРеквизитТЧ.Тип;
			СтрокаРеквизитТЧ.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]" + "." + СтандартныйРеквизитТЧ.Имя; 
		КонецЦикла;
		Для Каждого РеквизитТЧ Из ТабличнаяЧасть.Реквизиты Цикл
			СтрокаРеквизитТЧ = СтрокаТабличнаяЧасть.Строки.Добавить();
			СтрокаРеквизитТЧ.НаименованиеРеквизита = РеквизитТЧ.Имя;
			СтрокаРеквизитТЧ.ТипРеквизита = РеквизитТЧ.Тип;
			СтрокаРеквизитТЧ.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]" + "." + РеквизитТЧ.Имя;
		КонецЦикла; 
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево,"ДеревоРеквизитовОбъекта");
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(Настройки = Неопределено)
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ЗадачаИсполнителя.Ссылка,
	|	ЗадачаИсполнителя.ПометкаУдаления,
	|	ЗадачаИсполнителя.Номер,
	|	ЗадачаИсполнителя.Дата,
	|	ЗадачаИсполнителя.БизнесПроцесс,
	|	ЗадачаИсполнителя.ТочкаМаршрута,
	|	ЗадачаИсполнителя.Наименование,
	|	ЗадачаИсполнителя.Выполнена,
	|	ЗадачаИсполнителя.CRM_ВариантВыполнения,
	|	ЗадачаИсполнителя.CRM_ВариантВыполненияСтрокой,
	|	ЗадачаИсполнителя.CRM_ЗавершенДосрочно,
	|	ЗадачаИсполнителя.CRM_Итерация,
	|	ЗадачаИсполнителя.CRM_КонтактноеЛицо,
	|	ЗадачаИсполнителя.CRM_Личная,
	|	ЗадачаИсполнителя.CRM_НачалоПереадресации,
	|	ЗадачаИсполнителя.CRM_Неудача,
	|	ЗадачаИсполнителя.CRM_ОсновнаяКатегория,
	|	ЗадачаИсполнителя.CRM_Партнер,
	|	ЗадачаИсполнителя.CRM_Переадресована,
	|	ЗадачаИсполнителя.CRM_Проект,
	|	ЗадачаИсполнителя.CRM_ПроцентВыполненияЗадачи,
	|	ЗадачаИсполнителя.CRM_Родитель,
	|	ЗадачаИсполнителя.CRM_СостояниеСтрокой,
	|	ЗадачаИсполнителя.CRM_ТочкаМаршрута,
	|	ЗадачаИсполнителя.CRM_Этап,
	|	ЗадачаИсполнителя.Автор,
	|	ЗадачаИсполнителя.Важность,
	|	ЗадачаИсполнителя.ГруппаИсполнителейЗадач,
	|	ЗадачаИсполнителя.ДатаИсполнения,
	|	ЗадачаИсполнителя.ДатаНачала,
	|	ЗадачаИсполнителя.ДатаПринятияКИсполнению,
	|	ЗадачаИсполнителя.Описание,
	|	ЗадачаИсполнителя.Предмет,
	|	ЗадачаИсполнителя.ПредметСтрокой,
	|	ЗадачаИсполнителя.ПринятаКИсполнению,
	|	ЗадачаИсполнителя.РезультатВыполнения,
	|	ЗадачаИсполнителя.СостояниеБизнесПроцесса,
	|	ЗадачаИсполнителя.СрокИсполнения,
	|	ЗадачаИсполнителя.АвторСтрокой,
	|	ЗадачаИсполнителя.CRM_ПеренестиСрокИсполненияНа,
	|	ЗадачаИсполнителя.ДополнительныйОбъектАдресации,
	|	ЗадачаИсполнителя.Исполнитель,
	|	ЗадачаИсполнителя.ОсновнойОбъектАдресации,
	|	ЗадачаИсполнителя.РольИсполнителя
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.Ссылка = &Предмет";
	
	СхемаКомпоновкиДанных = РегистрыСведений.bpmУсловияЭтапов.ПолучитьМакет("ШаблонСхемы");
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1;
	
	НаборДанных.Запрос = ТекстЗапроса;
	
	Если Настройки = Неопределено Тогда
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	
	Компоновщик.Инициализировать(ИсточникНастроек);
	Компоновщик.ЗагрузитьНастройки(Настройки);
	
	ЗаполнитьДеревоРеквизитовОбъекта();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКомпоновщикКомбинацииУсловий(Настройки = Неопределено)
	
	СхемаКомпоновкиДанных = РегистрыСведений.bpmУсловияЭтапов.ПолучитьМакет("Условия");
	
	Если Настройки = Неопределено Тогда
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	КомпоновщикУсловий.Инициализировать(ИсточникНастроек);
	КомпоновщикУсловий.ЗагрузитьНастройки(Настройки);
	// Скрываем поле сравнения - в него будет ставиться всегда "Равно"
	Элементы.КомпоновщикУсловийНастройкиОтборВидСравнения.Видимость = Ложь;
	// Делаем недоступным для редактирования поле "Левое значение"
	Элементы.КомпоновщикУсловийНастройкиОтборЛевоеЗначение.ТолькоПросмотр = Истина;
	Элементы.КомпоновщикУсловийНастройкиОтбор.Шапка = Ложь;
	
КонецПроцедуры
	
&НаСервере
Функция ПроверитьНаличиеУсловияВДереве(ИщемПустоеЗначение)
	
	Результат = Ложь;
	Если Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
		ЭлементыНастройкиОтбора = КомпоновщикУсловий.Настройки.Отбор.Элементы;
		ИскомоеУсловие = ?(ИщемПустоеЗначение, Неопределено, Запись.Наименование);
		// ИскомоеУсловие = ?(ИщемПустоеЗначение, Неопределено, Запись);
		Результат = ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(ЭлементыНастройкиОтбора, ИскомоеУсловие);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(Элементы, ИскомоеУсловие)
	
	Для Каждого ЭлементОтбора Из Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда		
			Если ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(ЭлементОтбора.Элементы, ИскомоеУсловие) Тогда
				Возврат Истина;
			КонецЕсли;
		Иначе			
			Если (ЗначениеЗаполнено(ИскомоеУсловие) 
				И ЭлементОтбора.ПравоеЗначение = ИскомоеУсловие)
				ИЛИ (НЕ ЗначениеЗаполнено(ИскомоеУсловие) 
				И НЕ ЗначениеЗаполнено(ЭлементОтбора.ПравоеЗначение)) Тогда
				Возврат Истина;
			ИначеЕсли  ЭлементОтбора.ПравоеЗначение <> Неопределено Тогда
				
				ЗаписьУсловия = ПолучитьЗаписьСуществующегоУсловияПоНаименованию(ЭлементОтбора.ПравоеЗначение);
				
				НаборУсловий = РегистрыСведений.bpmУсловияЭтапов.СоздатьНаборЗаписей();
				НаборУсловий.Отбор.Идентификатор.Установить(ЗаписьУсловия.Идентификатор);
				НаборУсловий.Прочитать();
				
				Если НаборУсловий.Количество() > 0 Тогда
					Если НаборУсловий[0].СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий
						И ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(НаборУсловий[0].НастройкаКомбинацииУсловий.Получить().Отбор.Элементы, ИскомоеУсловие) Тогда
						Возврат Истина;
					КонецЕсли;
				КонецЕсли;
			// ИначеЕсли  ЭлементОтбора.ПравоеЗначение <> Неопределено
			//	И ЭлементОтбора.ПравоеЗначение.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий
			//	И ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(ЭлементОтбора.ПравоеЗначение.НастройкаКомбинацииУсловий.Получить().Отбор.Элементы, ИскомоеУсловие) Тогда
			//		Возврат Истина;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;

	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ПроверитьНаличиеПустыхСтрокОтбораВДереве()
	
	Результат = Ложь;
	Если Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.ВРежимеКонструктора Тогда
		ЭлементыНастройкиОтбора = Компоновщик.Настройки.Отбор.Элементы;
		Результат = ВыполнитьПоискПустойСтрокиВОдномУровнеНастройкиОтбора(ЭлементыНастройкиОтбора);
	КонецЕсли;
	Возврат Результат;		
	
КонецФункции

&НаСервере
Функция ВыполнитьПоискПустойСтрокиВОдномУровнеНастройкиОтбора(Элементы)
	
	Для Каждого ЭлементОтбора Из Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда		
			Если ВыполнитьПоискПустойСтрокиВОдномУровнеНастройкиОтбора(ЭлементОтбора.Элементы) Тогда
				Возврат Истина;
			КонецЕсли;
		Иначе			
			Если (НЕ ЗначениеЗаполнено(ЭлементОтбора.ПравоеЗначение)
				ИЛИ НЕ ЗначениеЗаполнено(Строка(ЭлементОтбора.ЛевоеЗначение)))
				И ЭлементОтбора.ВидСравнения <> ВидСравненияКомпоновкиДанных.Заполнено
				И ЭлементОтбора.ВидСравнения <> ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда
				Возврат Истина;
				
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;

	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура УдалитьУсловиеИзКомбинацииУсловий(ИмяУсловия)
	
	Если Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
		ЭлементыНастройкиОтбора = КомпоновщикУсловий.Настройки.Отбор.Элементы;
		ВыполнитьПоискИУдалениеДляОдногоУровня(ЭлементыНастройкиОтбора, ИмяУсловия);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискИУдалениеДляОдногоУровня(Элементы, ИмяУсловия)
	
	Для Каждого ЭлементОтбора Из Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда		
			ВыполнитьПоискИУдалениеДляОдногоУровня(ЭлементОтбора.Элементы, ИмяУсловия);
		ИначеЕсли ЭлементОтбора.ПравоеЗначение <> Неопределено Тогда
			СпособЗаданияУсловия = ЭлементОтбора.ПравоеЗначение.СпособЗаданияУсловия;
				
			Если ЭлементОтбора.ПравоеЗначение.Наименование = ИмяУсловия Тогда
				// ЭлементОтбора.ПравоеЗначение = Справочники.bpmУсловияЭтапов.ПустаяСсылка();
			ИначеЕсли СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
            	ВыполнитьПоискИУдалениеДляОдногоУровня(ЭлементОтбора.ПравоеЗначение.НастройкаКомбинацииУсловий.Получить().Отбор.Элементы, ИмяУсловия);
			КонецЕсли;
			
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗаписьСуществующегоУсловияПоНаименованию(НаименованиеУсловия)
	
	СуществующиеУсловия_Значение = РеквизитФормыВЗначение("СуществующиеУсловия");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТЗ.Наименование КАК Наименование,
	               |	ТЗ.Идентификатор КАК Идентификатор
	               |ПОМЕСТИТЬ Таблица
	               |ИЗ
	               |	&ТЗ КАК ТЗ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Таблица.Наименование,
				   |	Таблица.Идентификатор
	               |ИЗ
	               |	Таблица КАК Таблица
	               |ГДЕ
	               |	Таблица.Наименование = &Наименование
	               |	И Таблица.Идентификатор <> &Ссылка";
	
	Запрос.УстановитьПараметр("ТЗ", СуществующиеУсловия_Значение);
	Запрос.УстановитьПараметр("Наименование", НаименованиеУсловия);
	Запрос.УстановитьПараметр("Ссылка", Запись.Идентификатор);
	Запрос.УстановитьПараметр("Владелец", Запись.Объект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
	   Возврат Выборка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ПроверитьУникальностьУсловия()
	
	СуществующиеУсловия_Значение = РеквизитФормыВЗначение("СуществующиеУсловия");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТЗ.Наименование КАК Наименование,
	               |	ТЗ.Идентификатор КАК Идентификатор
	               |ПОМЕСТИТЬ Таблица
	               |ИЗ
	               |	&ТЗ КАК ТЗ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Таблица.Наименование
	               |ИЗ
	               |	Таблица КАК Таблица
	               |ГДЕ
	               |	Таблица.Наименование = &Наименование
	               |	И Таблица.Идентификатор <> &Ссылка";
	
	Запрос.УстановитьПараметр("ТЗ", СуществующиеУсловия_Значение);
	Запрос.УстановитьПараметр("Наименование", Запись.Наименование);
	Запрос.УстановитьПараметр("Ссылка", Запись.Идентификатор);
	Запрос.УстановитьПараметр("Владелец", Запись.Объект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
	   Возврат Выборка;	 
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ВернутьНаименованиеПоКлючу(КлючЗаписи)
	
	ЗаписьРегистра = РегистрыСведений.bpmУсловияЭтапов.СоздатьМенеджерЗаписи();
	ЗаписьРегистра.Объект			= КлючЗаписи.Объект;
	ЗаписьРегистра.ТочкаМаршрута	= КлючЗаписи.ТочкаМаршрута;
	ЗаписьРегистра.Идентификатор	= КлючЗаписи.Идентификатор;
	ЗаписьРегистра.Прочитать();
	Возврат ЗаписьРегистра.Наименование;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВладельцаЗначенияДопРеквизита(ИмяДопРеквизита)
	
	Возврат ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(ИмяДопРеквизита);	
	
КонецФункции

&НаСервере
Процедура ПроверитьВыражениеСервер()
	
	Результат = Неопределено;
	ИтогПроверки = "";
	
	Попытка
		Выполнить(Запись.ВыражениеУсловия);
	Исключение
		Результат = Ложь;
		Инфо = ИнформацияОбОшибке();
		
		Описание = "";
		Если ТипЗнч(Инфо.Причина) = Тип("ИнформацияОбОшибке") Тогда
			Описание = Инфо.Причина.Описание;
		Иначе
			Описание = Инфо.Описание;
		КонецЕсли;
		
		ИтогПроверки = НСтр("ru='Ошибка.';en='Error.'") + Символы.ВК + Описание;
		Возврат;
	КонецПопытки;		
	
	Если ТипЗнч(Результат) <> Тип("Булево") Тогда
		ИтогПроверки = НСтр("ru = 'Ошибка.
			|Переменной ""Результат"" необходимо присвоить значение типа ""Булево""'");	
		Возврат;
	КонецЕсли;
	
	ИтогПроверки = ?(Результат, НСтр("ru='Истина';en='TRUE'"), НСтр("ru='Ложь';en='LIE'"));
		
КонецПроцедуры

&НаСервереБезКонтекста
// Возвращает тип по типу объекта
// Параметры:
//  ТипОбъекта - ПеречислениеСсылка.ТипыОбъектов
//
// Возвращаемое значение - Тип
Функция ТипПоТипуОбъекта(ТипОбъекта)
	
	ТипВыбранный = ТипОбъекта.ТипЗначения.Типы()[0];
	
	Возврат ТипВыбранный;
	
КонецФункции	

&НаСервере
Функция ПроверитьУсловие()
	
	Отказ = Ложь;
	
	// Проверка на уникальность имени условия
	РезультатПроверки = ПроверитьУникальностьУсловия();
	Если РезультатПроверки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Данное Наименование уже указано для другого условия';en='This Name is already indicated for another condition'"),, "Запись.Наименование",, Отказ);
	КонецЕсли;
	
	Если Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий
		И КомпоновщикУсловий.Настройки.Отбор.Элементы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указано ни одного условия';en='No conditions specified'"),,"КомпоновщикУсловий.Настройки.Отбор",, Отказ);
	ИначеЕсли Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.ВРежимеКонструктора
		И Компоновщик.Настройки.Отбор.Элементы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указано ни одного правила';en='No rules specified'"),,"Компоновщик.Настройки.Отбор",, Отказ);
	ИначеЕсли Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.НаВстроенномЯзыке
		И НЕ ЗначениеЗаполнено(Запись.ВыражениеУсловия) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не задано выражение';en='No expression specified'"),,"Запись.ВыражениеУсловия",, Отказ);
	КонецЕсли;
	
	Если Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий
		И ПроверитьНаличиеУсловияВДереве(Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Заполнены не все значения в комбинации условий';en='Not all values in the combination of conditions are filled in'"),,"КомпоновщикУсловий.Настройки.Отбор",, Отказ);
	КонецЕсли;
	
	Если Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.ВРежимеКонструктора
		И ПроверитьНаличиеПустыхСтрокОтбораВДереве() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Среди правил есть некорректно заполненные';en='Among the rules are incorrectly filled'"),,"Компоновщик.Настройки.Отбор",, Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаСервере
Функция ВернутьСтруктруНастроекУсловия()
	
		СтруктураНастроекУсловия = Новый Структура("Объект,
												|Идентификатор,
												|ТочкаМаршрута,
												|Событие,
												|ТипДействия,
												|Проверка,
												|Исполнителю,
												|Ответственному,
												|Клиенту,
												|ВыражениеУсловия,
												|ПредставлениеОтбора,
												|СпособЗаданияУсловия,
												|Наименование,
												|Цель,
												|АдресНастройкаКомбинацииУсловий,
												|АдресНастройкаУсловия");
		
		
		СтруктураНастроекУсловия.Объект								= Запись.Объект;
		СтруктураНастроекУсловия.ВыражениеУсловия					= Запись.ВыражениеУсловия;
		Если Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
			СтруктураНастроекУсловия.ПредставлениеОтбора = Строка(КомпоновщикУсловий.Настройки.Отбор);
		ИначеЕсли Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.ВРежимеКонструктора Тогда
			СтруктураНастроекУсловия.ПредставлениеОтбора = Строка(Компоновщик.Настройки.Отбор);
		ИначеЕсли Запись.СпособЗаданияУсловия = Перечисления.bpmСпособыЗаданияУсловия.НаВстроенномЯзыке Тогда
			СтруктураНастроекУсловия.ПредставлениеОтбора = "";
		КонецЕсли;
		СтруктураНастроекУсловия.ПредставлениеОтбора = СтрЗаменить(СтруктураНастроекУсловия.ПредставлениеОтбора, "( ", "(");
		СтруктураНастроекУсловия.ПредставлениеОтбора = СтрЗаменить(СтруктураНастроекУсловия.ПредставлениеОтбора, " )", ")");
		СтруктураНастроекУсловия.ТочкаМаршрута						= Запись.ТочкаМаршрута;
		СтруктураНастроекУсловия.Событие							= Запись.Событие;
		СтруктураНастроекУсловия.ТипДействия						= Запись.ТипДействия;
		СтруктураНастроекУсловия.Проверка							= Запись.Проверка;
		СтруктураНастроекУсловия.Исполнителю						= Запись.Исполнителю;
		СтруктураНастроекУсловия.Ответственному						= Запись.Ответственному;
		СтруктураНастроекУсловия.Клиенту							= Запись.Клиенту;
		СтруктураНастроекУсловия.СпособЗаданияУсловия				= Запись.СпособЗаданияУсловия;
		СтруктураНастроекУсловия.Наименование						= Запись.Наименование;
		СтруктураНастроекУсловия.Идентификатор						= Запись.Идентификатор;
		СтруктураНастроекУсловия.Цель								= Цель;
		СтруктураНастроекУсловия.АдресНастройкаКомбинацииУсловий	= ПоместитьВоВременноеХранилище(КомпоновщикУсловий.ПолучитьНастройки(), Новый УникальныйИдентификатор());
		СтруктураНастроекУсловия.АдресНастройкаУсловия				= ПоместитьВоВременноеХранилище(Компоновщик.ПолучитьНастройки(), Новый УникальныйИдентификатор());
		
		Возврат СтруктураНастроекУсловия;
КонецФункции

&НаСервереБезКонтекста
Функция ПолноеИмяПоТипу(ТипВыбранный)
	
	ПолноеИмя = Метаданные.НайтиПоТипу(ТипВыбранный).ПолноеИмя();
	Возврат ПолноеИмя;
	
КонецФункции	

&НаКлиенте
Процедура ПредметСтрокойНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Предмет = Результат;
		ПроверитьВыражениеСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти





