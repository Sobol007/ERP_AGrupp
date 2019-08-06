#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.УникальныйИдентификатор = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Предусмотрено открытие обработки только из форм объектов.';
								|en = 'Data processor can be opened only from object forms.'");
	КонецЕсли;
	
	ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	
	Если Параметры.Свойство("ВестиУчетСертификатовНоменклатуры") Тогда
		ВестиУчетСертификатовНоменклатуры = Истина;
	КонецЕсли;
	
	ЗагрузитьНастройкиОтбораПоУмолчанию();

	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ЗаголовокКнопкиПеренести) Тогда
		Команды["ПеренестиВДокумент"].Заголовок = Параметры.ЗаголовокКнопкиПеренести;
		Команды["ПеренестиВДокумент"].Подсказка = Параметры.ЗаголовокКнопкиПеренести;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ВыполняетсяЗакрытие И Не ПеренестиВДокумент И Объект.ТоварныеКатегории.Количество() > 0 Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru = 'Подобранные товарные категории не перенесены в документ. Перенести?';
																								|en = 'Selected product categories were not transferred to the document. Transfer?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		ВыполняетсяЗакрытие = Истина;
		АдресТоварныхКатегорийВХранилище = ПоместитьВоВременноеХранилищеНаСервере();
		Закрыть(АдресТоварныхКатегорийВХранилище);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВдокумент(Команда)
	
	ПеренестиВДокумент = Истина;
	АдресТоварныхКатегорийВХранилище = ПоместитьВоВременноеХранилищеНаСервере();
	Закрыть(АдресТоварныхКатегорийВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуТоварныхКатегорий(Команда)
	
	ТекстВопроса = НСтр("ru = 'При перезаполнении все введенные вручную данные будут потеряны, продолжить?';
						|en = 'During repopulation all information entered manually will be lost, continue?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьТаблицуТоварныхКатегорийЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуТоварныхКатегорийЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если Объект.ТоварныеКатегории.Количество() = 0 ИЛИ КодВозвратаДиалога.Да = РезультатВопроса Тогда
        ЗаполнитьТаблицуТоварныхКатегорийНаСервере();
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция СтруктураНастроек()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОбязательныеПоля"   , Новый Массив); //
	СтруктураНастроек.Вставить("ПараметрыДанных"    , Новый Структура);
	СтруктураНастроек.Вставить("КомпоновщикНастроек", Неопределено); // Отбор
	СтруктураНастроек.Вставить("ИмяМакетаСхемыКомпоновкиДанных" , Неопределено);
	СтруктураНастроек.Вставить("ВестиУчетСертификатовНоменклатуры" , ВестиУчетСертификатовНоменклатуры);
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ТоварныеКатегории.Выгрузить(), ИдентификаторВызывающейФормы);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоварныхКатегорийНаСервере(ПроверятьЗаполнение = Истина)
	
	// Поля необходимые для вывода в таблицу товарных категорий на форме.
	СтруктураНастроек = СтруктураНастроек();
	
	СтруктураНастроек.ОбязательныеПоля.Добавить("ТоварнаяКатегория");
	
	СтруктураНастроек.КомпоновщикНастроек = КомпоновщикНастроек;
	СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "Макет";
	
	Объект.ТоварныеКатегории.Очистить();
	
	// Загрузка сформированного списка товарных категорий.
	СтруктураРезультата = Обработки.ПодборТоварныхКатегорийПоОтбору.ПодготовитьСтруктуруДанных(СтруктураНастроек);
	Для Каждого СтрокаТЧ Из СтруктураРезультата.ТаблицаТоварныхКатегорий Цикл
		
		НоваяСтрока = Объект.ТоварныеКатегории.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
	КонецЦикла;
	
	Элементы.ТоварныеКатегории.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
	
	СхемаКомпоновкиДанных = Обработки.ПодборТоварныхКатегорийПоОтбору.ПолучитьМакет("Макет");
	
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	ИспользоватьАссортимент = ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент");
	Если ИспользоватьАссортимент Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "АссортиментНаДату", ТекущаяДатаСеанса());
	КонецЕсли;
	Если ВестиУчетСертификатовНоменклатуры Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ВестиУчетСертификатовНоменклатуры", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти