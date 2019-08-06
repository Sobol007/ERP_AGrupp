
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПартнерыИКонтрагенты.ПартнерыФормаВыбораСпискаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Обработчик подсистемы "Внешние обработки"
	
	// Электронные документы
	Если ПравоДоступа("Изменение", Метаданные.Справочники.Партнеры) Тогда
		Элементы.СписокЗагрузитьРеквизиты.Видимость = Истина;
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Партнеры);
	Элементы.СписокИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложения.ПриСозданииПодсказокФормы(ЭтотОбъект, Элементы.ПодсказкиБизнесСеть);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
	ПартнерыИКонтрагенты.СкрытьКомандыПриОтсутствииПравНаИзменение(ЭтотОбъект);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	УстановитьВидимостьКомандКонтекстныхОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ТребуетсяОбновлениеПанелиИнформации = Ложь;
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник, ТребуетсяОбновлениеПанелиИнформации);
	
	Если ТребуетсяОбновлениеПанелиИнформации Тогда
		ИгнорироватьСохранениеТекущейПозиции = Истина;
		ОбработатьАктивизациюСтрокиСписка();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ПартнерыИКонтрагенты.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПартнерыИКонтрагентыКлиент.ПанельНавигацииУправлениеДоступностью(ЭтаФорма);
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложенияКлиент.ОбновитьПодсказкуФормы(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		ПартнерыИКонтрагентыКлиент.ФормаСпискаВыбораПриЗакрытии(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТолькоМоиПриИзменении(Элемент)
	
	ИзменитьОтборСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ВыполнитьПоиск(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеВыбораНажатие(Элемент, СтандартнаяОбработка)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораОснованиеВыбораНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СегментПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораСегментПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	СпискиВыбораКлиентСервер.АвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипФильтраОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФильтрПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПанельНавигацииУправлениеДоступностью(ЭтаФорма);
	ОбработатьАктивизациюСтрокиДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписокФильтрыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.Имя = "БизнесРегионы" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаБизнесРегионы Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "ГруппыДоступаПартнеров" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаГруппыДоступа Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Менеджеры" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаМенеджеры Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Свойства" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаСвойства Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Категории" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаКатегории Тогда
		Возврат;
	КонецЕсли;
	
	Если НеОтрабатыватьАктивизациюПанелиНавигации Тогда
		НеОтрабатыватьАктивизациюПанелиНавигации = Ложь;
	Иначе
		Если Элемент.Имя = "БизнесРегионы" И ТекущееЗначениеФильтра = Элементы.БизнесРегионы.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "ГруппыДоступаПартнеров" И ТекущееЗначениеФильтра = Элементы.ГруппыДоступаПартнеров.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Менеджеры" И ТекущееЗначениеФильтра = Элементы.Менеджеры.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Свойства" И ТекущееЗначениеФильтра = Свойства.НайтиПоИдентификатору(Элементы.Свойства.ТекущаяСтрока) Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Категории" И ТекущееЗначениеФильтра = Категории.НайтиПоИдентификатору(Элементы.Категории.ТекущаяСтрока) Тогда
			Возврат;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиДинамическогоСписка",0.2,Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыПартнераНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПартнерыИКонтрагентыКлиент.КонтрагентыПартнераНажатие(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактныеЛицаПартнераНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПартнерыИКонтрагентыКлиент.КонтактныеЛицаПартнераНажатие(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоВсемПриИзменении(Элемент)
	
	ИзменитьОтборСписок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипФильтраПриИзменении(Элемент)
	
	ТребуетсяЗаполнениеСтраницыСвойств = ЛОЖЬ;
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииТипФильтраПриИзменении(ЭтаФорма, Элемент, ТребуетсяЗаполнениеСтраницыСвойств);
	ИзменитьОтборСписок(Истина, ТребуетсяЗаполнениеСтраницыСвойств);
	Если ТребуетсяЗаполнениеСтраницыСвойств Тогда
		Для каждого СтрокаДерева Из Свойства.ПолучитьЭлементы() Цикл
			Элементы.Свойства.Развернуть(СтрокаДерева.ПолучитьИдентификатор());
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииПроверкаПеретаскивания(ЭтаФорма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) 
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	КоличествоЗаписанных = 0;
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииПеретаскивание(КоличествоЗаписанных, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	
	Если КоличествоЗаписанных > 0 Тогда
		ИзменитьОтборСписок();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.Найти("ГоловнойКонтрагент") Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные.ОбособленноеПодразделение И Не ЗначениеЗаполнено(ТекущиеДанные.ГоловнойКонтрагент) Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПараметрыЗаполнения = Новый Структура;
			ПараметрыЗаполнения.Вставить("Контрагент", ТекущиеДанные.Контрагент);
			ПараметрыЗаполнения.Вставить("ИНН",        ТекущиеДанные.ИНН);
			ПараметрыЗаполнения.Вставить("Партнер",    ТекущиеДанные.Ссылка);
			ПараметрыЗаполнения.Вставить("ИспользоватьПартнеровКакКонтрагентов", Истина);
			
			Оповещение = Новый ОписаниеОповещения("ЗаполнитьГоловногоКонтрагентаЗавершение", ЭтотОбъект);
			ПартнерыИКонтрагентыКлиент.ЗаполнитьГоловногоКонтрагента(ЭтотОбъект, ПараметрыЗаполнения, Истина, Оповещение);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораСписокПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНового(Команда)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораСоздатьНового(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиПП(Команда)
	
	ВыполнитьПоиск(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРеквизиты(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПослеВопросаОбУстановкеРасширенияДляРаботыСФайлами", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

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

// ЭлектронноеВзаимодействие.ТорговыеПредложения
&НаКлиенте
Процедура Подключаемый_ПодсказкиБизнесСетьНажатие(Команда)
	
	ТорговыеПредложенияКлиент.ОткрытьФормуПодсказок(ЭтаФорма);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения

&НаКлиенте
Процедура ОткрытьОтчетЗаполненностьСвойствПартнеров(Команда)
	ПараметрыОтчета = Новый Структура("СформироватьПриОткрытии", Истина);
	ОткрытьФорму("Отчет.ЗаполнениеСвойствПартнеров.Форма", ПараметрыОтчета, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	ПартнерыИКонтрагенты.ПартнерыФормаВыбораСпискаУсловноеОформление(ЭтаФорма);
	ПартнерыИКонтрагенты.УстановитьОформлениеГоловногоКонтрагентаВСписке(ЭтаФорма);

КонецПроцедуры

#Область ПолнотекстовыйПоиск

&НаКлиенте
Процедура ПроверитьИндексПолнотекстовогоПоиска(Знач Оповещение)
	
	Если Не ИндексПолнотекстовогоПоискаАктуален И ИнформационнаяБазаФайловая Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ПроверитьИндексПолнотекстовогоПоискаЗавершение", ЭтотОбъект, Новый Структура("Оповещение", Оповещение)), 
			НСтр("ru = 'Индекс полнотекстового поиска неактуален. Обновить индекс?';
				|en = 'Full-text search index is invalid. Update the index?'"), РежимДиалогаВопрос.ДаНет);
        Возврат;
		
	КонецЕсли;
	
	ПроверитьИндексПолнотекстовогоПоискаФрагмент(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИндексПолнотекстовогоПоискаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    Результат = РезультатВопроса; 
    
    Если Результат = КодВозвратаДиалога.Да Тогда
        ПодключитьОбработчикОжидания("ОбновитьИндексПолнотекстовогоПоиска",0.2,Истина);
        ВыполнитьОбработкуОповещения(Оповещение);
        Возврат;
    КонецЕсли;
    
    
    ПроверитьИндексПолнотекстовогоПоискаФрагмент(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИндексПолнотекстовогоПоискаФрагмент(Знач Оповещение)
    
    ВыполнитьПолнотекстовыйПоиск();
    
    ВыполнитьОбработкуОповещения(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндексПолнотекстовогоПоиска()
	
	Состояние(НСтр("ru = 'Идет обновление индекса полнотекстового поиска...';
					|en = 'Full-text search index is being updated...'"));
	ОбновитьИндексПолнотекстовогоПоискаСервер();
	ИндексПолнотекстовогоПоискаАктуален = Истина;
	Состояние(НСтр("ru = 'Обновление индекса полнотекстового поиска завершено...';
					|en = 'Updating of the full-text search index has been completed...'"));
	ВыполнитьПолнотекстовыйПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПолнотекстовыйПоиск()
	
	ТекстОшибки = НайтиПартнеровПолнотекстовыйПоиск();
	Если ТекстОшибки = Неопределено Тогда
		РасширенныйПоиск = Истина;
		ЗаполнитьСтрокуОснования();
	Иначе
		Если НЕ ТекстОшибки = НСтр("ru = 'Ничего не найдено';
									|en = 'No results found'") Тогда
			ПоказатьОповещениеПользователя(ТекстОшибки);
		Иначе
			ПартнерыИКонтрагентыКлиент.ВосстановитьОтображениеСпискаПослеПолнотекстовогоПоиска(ЭтаФорма);
			РасширенныйПоиск = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИндексПолнотекстовогоПоискаСервер()
	
	ПартнерыИКонтрагенты.ОбновитьИндексПолнотекстовогоПоиска();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтрокуОснования()
	
	Основание = Основания.НайтиСтроки(Новый Структура("Партнер", Элементы.Список.ТекущаяСтрока));
	Если Основание.Количество() = 0 Тогда
		ОснованиеВыбора = "";
	Иначе
		ОснованиеВыбора = Основание[0].Основание;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиПартнеровПолнотекстовыйПоиск()

	Возврат ПартнерыИКонтрагенты.НайтиПартнеровПолнотекстовыйПоиск(ЭтаФорма)

КонецФункции

&НаКлиенте
Процедура ВыполнитьПоиск(Знач Оповещение)
	
	Если СтрокаПоиска <> "" Тогда
		
		ПроверитьИндексПолнотекстовогоПоиска(Новый ОписаниеОповещения("ВыполнитьПоискЗавершение", ЭтотОбъект, Новый Структура("Оповещение", Оповещение)));
        Возврат;
		
	Иначе
		ПартнерыИКонтрагентыКлиент.ВосстановитьОтображениеСпискаПослеПолнотекстовогоПоиска(ЭтаФорма);
		РасширенныйПоиск = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		                                                                   "ОтборПоПолнотекстовомуПоискуУстановлен",
		                                                                   Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		                                                                   "ОтборПоПолнотекстовомуПоиску",
		                                                                   Неопределено);
		ОснованиеВыбора = "";
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоискЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    ЭтаФорма.ТекущийЭлемент = ?(НЕ РасширенныйПоиск, Элементы.СтрокаПоиска, Элементы.Список);
    
    
    ВыполнитьОбработкуОповещения(Оповещение);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	Если Не ПартнерыИКонтрагентыКлиент.ПозиционированиеКорректно("Список",ЭтаФорма) Тогда
		
		Если ТекущийАктивныйПартнер <> ПредопределенноеЗначение("Справочник.Партнеры.ПустаяСсылка") Тогда
			ЗаполнитьПанельИнформацииПоДаннымПартнера(Неопределено);
		КонецЕсли;
		ОснованиеВыбора = "";
		
	Иначе
		
		Если ТекущийАктивныйПартнер <> Элементы.Список.ТекущаяСтрока ИЛИ ИгнорироватьСохранениеТекущейПозиции Тогда
			ЗаполнитьПанельИнформацииПоДаннымПартнера(Элементы.Список.ТекущаяСтрока);
		КонецЕсли;
		
		Если РасширенныйПоиск Тогда
			ПартнерыИКонтрагентыКлиент.ЗаполнитьСтрокуОснования(ЭтаФорма);
		Иначе
			ОснованиеВыбора = "";
		КонецЕсли;
		
	КонецЕсли;
	
	ИгнорироватьСохранениеТекущейПозиции = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПанельИнформацииПоДаннымПартнера(Партнер)
	
	ПартнерыИКонтрагенты.ЗаполнитьПанельИнформацииПоДаннымПартнера(ЭтаФорма, Партнер);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиДинамическогоСписка()

	ИзменитьОтборСписок();

КонецПроцедуры

&НаСервере
Процедура ИзменитьОтборСписок(ПереформированиеПанелиНавигации = Ложь, ТребуетсяЗаполнениеСтраницыСвойств = Ложь)

	ПартнерыИКонтрагенты.ИзменитьОтборСписок(ЭтаФорма, ПереформированиеПанелиНавигации, ТребуетсяЗаполнениеСтраницыСвойств);

КонецПроцедуры

&НаСервере 
Процедура УстановитьВидимостьКомандКонтекстныхОтчетов()
	КоличествоДоступныхОтчетов = 0;
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ЗаполнениеСвойствПартнеров) Тогда
		Элементы.ОткрытьОтчетЗаполненностьСвойствПартнеров.Видимость = Истина;
		КоличествоДоступныхОтчетов = КоличествоДоступныхОтчетов + 1;
	Иначе
		Элементы.ОткрытьОтчетЗаполненностьСвойствПартнеров.Видимость = Ложь;
	КонецЕсли;
	
	Если КоличествоДоступныхОтчетов > 0 Тогда
		Элементы.СтраницыКонтекстныеОтчеты.ТекущаяСтраница = Элементы.СтраницаДоступныеОтчеты;
	Иначе
		Элементы.СтраницыКонтекстныеОтчеты.ТекущаяСтраница = Элементы.СтраницаНетДоступныхОтчетов;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ЗаполнитьГоловногоКонтрагентаЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОбУстановкеРасширенияДляРаботыСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'XML файл';
											|en = 'XML file'")+"(*.xml)|*.xml";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл';
											|en = 'Select file'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗагрузитьРеквизитыВыборФайла",
			ЭтотОбъект);
		
		ДиалогОткрытияФайла.Показать(ОписаниеОповещения);
		
	Иначе
		
		#Если ВебКлиент Тогда
			
			АдресФайлаВоВременномХранилище = "";
			ИмяФайла = "";
			НачатьПомещениеФайла(
				Новый ОписаниеОповещения(
					"ЗагрузитьСхемуИзФайлаЗавершение",
					ЭтотОбъект,
					Новый Структура("АдресФайлаВоВременномХранилище", АдресФайлаВоВременномХранилище)),
				АдресФайлаВоВременномХранилище,
				ИмяФайла,
				Истина,
				УникальныйИдентификатор);
			
		#КонецЕсли
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРеквизитыВыборФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ФайлЗагрузки = ВыбранныеФайлы[0];
	ДвоичныеДанные  = Новый ДвоичныеДанные(ФайлЗагрузки);
	СсылкаНаФайл = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового",
		Новый Структура("СсылкаНаФайл, СписокОтборПоТипуПартнера", СсылкаНаФайл, СписокОтборПоТипуПартнера),
		,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаЗавершение(Результат, Адрес, ИмяФайла, ДополнительныеПараметры) Экспорт
    
    АдресФайлаВоВременномХранилище = ДополнительныеПараметры.АдресФайлаВоВременномХранилище;
    
    Если НЕ Результат Тогда
        Возврат;
    КонецЕсли;
    
	ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового",
		Новый Структура("СсылкаНаФайл, СписокОтборПоТипуПартнера", АдресФайлаВоВременномХранилище, СписокОтборПоТипуПартнера),
		,
		УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти
