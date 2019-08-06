#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ДокументОбъект") 
		Или Не ТипЗнч(Параметры.ДокументОбъект) = Тип("ДанныеФормыСтруктура")
		Или НЕ Параметры.ДокументОбъект.Свойство("Ссылка") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ДокументОбъект,,"ПриемкаТоваров");
	ПриемкаТоваров.Загрузить(Параметры.ДокументОбъект.ПриемкаТоваров.Выгрузить());
	
	НастроитьФормуВЗависимостиОтТипаДокумента(Параметры.ДокументОбъект);
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		
		Если Параметры.ДокументОбъект.Статус <> Перечисления.СтатусыАктаОРасхождениях.НеСогласовано Тогда
			ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Элементы.СтраховаяКомпания.Видимость           = Ложь;
		Элементы.КонтрагентСтраховойКомпании.Видимость = Ложь;
		
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность И Не СохранитьПараметры Тогда
		
		СохранитьПараметры = Ложь;
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = НСтр("ru = 'Реквизиты печати акта о расхождениях были изменены. Перенести изменения?';
									|en = 'Print attributes of the discrepancy certificate were changed. Transfer the changes?'");
		
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыполняетсяЗакрытие = Истина;
	СохранитьПараметры  = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если СохранитьПараметры И Не ЗавершениеРаботы Тогда
		
		ОповеститьОВыборе(СтруктраВозвращаемыхДанных());
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраховаяКомпанияПриИзменении(Элемент)
	СтраховаяКомпанияПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ТолькоПросмотр Тогда
		СохранитьПараметры = Истина;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СтраховаяКомпанияПриИзмененииНаСервере()
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(СтраховаяКомпания, КонтрагентСтраховойКомпании);
	
КонецПроцедуры

Функция СтруктраВозвращаемыхДанных()
	
	СтруктураВозврата = Новый Структура;
	
	РеквизитыФормы = ПолучитьРеквизиты();
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл
		
		СтруктураВозврата.Вставить(РеквизитФормы.Имя, ЭтотОбъект[РеквизитФормы.Имя]);
		
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Процедура НастроитьФормуВЗависимостиОтТипаДокумента(ДокументОбъект)
	
	ЕстьПравоИзменения = Ложь;
	
	Если ТипЗнч(ДокументОбъект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки") Тогда
		
		Элементы.Руководитель.ОграничениеТипа     = Новый ОписаниеТипов("Строка");
		Элементы.ГлавныйБухгалтер.ОграничениеТипа = Новый ОписаниеТипов("Строка");
		Элементы.Грузоотправитель.ОграничениеТипа = Новый ОписаниеТипов("Строка");
		
		ЕстьПравоИзменения = ПравоДоступа("Изменение", Метаданные.Документы.АктОРасхожденияхПослеОтгрузки);
		
	ИначеЕсли ТипЗнч(ДокументОбъект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеПриемки") Тогда
		
		Элементы.Руководитель.ОграничениеТипа     = Новый ОписаниеТипов("СправочникСсылка.ОтветственныеЛицаОрганизаций");
		Элементы.ГлавныйБухгалтер.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ОтветственныеЛицаОрганизаций");
		Элементы.Грузоотправитель.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		
		ЕстьПравоИзменения = ПравоДоступа("Изменение", Метаданные.Документы.АктОРасхожденияхПослеПриемки);
		
	КонецЕсли;
	
	ТолькоПросмотр = Не ЕстьПравоИзменения;

КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
