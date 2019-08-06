#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ДанныеПоНоменклатуре <> Неопределено Тогда
		
		ЗаполнитьМатериалы();
		
		Заголовок = СтрШаблон(
			НСтр("ru = 'Подбор материалов по спецификации: %1';
				|en = 'Select materials by BOM: %1'"),
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ДанныеПоНоменклатуре.Спецификация, "Представление"));
		
	КонецЕсли;
	
	Если Параметры.ПоказыватьКоличествоПодобрано Тогда
		
		ПрочитатьКоличествоПодобрано();
		
		Если Параметры.ЗаголовокКолонкиКоличествоПодобрано <> "" Тогда
			Элементы.МатериалыКоличествоУпаковокПодобрано.Заголовок = Параметры.ЗаголовокКолонкиКоличествоПодобрано;
		КонецЕсли;
		
	Иначе
		Элементы.МатериалыКоличествоУпаковокПодобрано.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И ЕстьДанныеДляПереноса() Тогда
		
		ОповещениеСохранитьИЗакрыть = Новый ОписаниеОповещения(
			"ПередЗакрытиемПеренестиИЗакрыть", ЭтотОбъект);
	
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
			ОповещениеСохранитьИЗакрыть,
			Отказ,
			ЗавершениеРаботы,
			НСтр("ru = 'Данные были изменены. Перенести в документ?';
				|en = 'Data was changed. Transfer to the document?'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМатериалы

&НаКлиенте
Процедура МатериалыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИмяПоля = Поле.Имя;
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	
	Если ИмяПоля = "МатериалыНоменклатура"
		И ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ТекущиеДанные.Номенклатура);
		
	ИначеЕсли ИмяПоля = "МатериалыСпецификация"
		И ЗначениеЗаполнено(ТекущиеДанные.Спецификация) Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ТекущиеДанные.Спецификация);
		
	ИначеЕсли ИмяПоля = "МатериалыПрименениеМатериалаРедактирование"
		И ЗначениеЗаполнено(ТекущиеДанные.ПрименениеМатериалаРедактирование) Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуНастройкиПримененияМатериала(ТекущиеДанные);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура МатериалыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Материалы.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", Новый Структура("НужноОкруглять", Ложь));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Если ЕстьДанныеДляПереноса() Тогда
		
		ПеренестиМатериалыВДокумент();
		
	Иначе
		
		ОчиститьСообщения();
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо указать количество номенклатуры';
				|en = 'Specify the amount of products'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(
		ЭтотОбъект,
		"МатериалыНоменклатураЕдиницаИзмерения", 
        "Материалы.Упаковка");
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект,
		"МатериалыХарактеристика",
		"Материалы.ХарактеристикиИспользуются");
	
	// Текст <уточняется при производстве>
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыХарактеристика.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Материалы.ХарактеристикиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Материалы.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<уточняется при производстве>';
																|en = '<specified during production>'"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМатериалы()
	
	Материалы.Очистить();
	
	ПараметрыВыборки = Справочники.РесурсныеСпецификации.ПараметрыВыборкиДанных("МатериалыИУслуги");
	
	ПараметрыВыборки.ПолучитьПредставления = Истина;
	ПараметрыВыборки.ОбъединитьМатериалыИВходящиеИзделия = Истина;
	ПараметрыВыборки.УчитыватьВероятностьБрака = Ложь;
	ПараметрыВыборки.СпособРасчетаМатериалов = Перечисления.СпособыРасчетаМатериалов.МаксимальноеПотребление;
	
	Отбор = Неопределено;
	Если ЗначениеЗаполнено(Параметры.Этап) Тогда
		Отбор = Новый Структура("Этап", Параметры.Этап);
	КонецЕсли;
	
	ДанныеСпецификации = Справочники.РесурсныеСпецификации.ДанныеСпецификацииПоНоменклатуре(
		Параметры.ДанныеПоНоменклатуре,
		ПараметрыВыборки,
		Отбор);
	
	НомерСтроки = 1;
	
	Для каждого Строка Из ДанныеСпецификации.МатериалыИУслуги Цикл
		
		НоваяСтрока = Материалы.Добавить();
		
		ЗаполнитьЗначенияСвойств(
			НоваяСтрока,
			Строка,
			"Этап,
			|Номенклатура,
			|Характеристика,
			|Упаковка,
			|СтатьяКалькуляции,
			|Производится,
			|Спецификация,
			|ПрименениеМатериалаРедактирование,
			|ПрименениеМатериала,
			|Альтернативный,
			|Вероятность");
		
		НоваяСтрока.КоличествоУпаковокНорматив = Строка.КоличествоУпаковок;
		НоваяСтрока.КлючСвязиСпецификация = Строка.КлючСвязи;
		
		НоваяСтрока.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	СтруктураДействий = Новый Структура;
	
	СтруктураДействий.Вставить(
		"ЗаполнитьПризнакХарактеристикиИспользуются",
		Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
		
	СтруктураДействий.Вставить(
		"ЗаполнитьПризнакАртикул",
		Новый Структура("Номенклатура", "Артикул"));
		
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Материалы, СтруктураДействий);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьКоличествоПодобрано()
	
	Если НЕ ЭтоАдресВременногоХранилища(Параметры.АдресПодобранныеМатериалы) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПоиска = Параметры.СтруктураПоискаПодобранныеМатериалы;
	
	ПодобранныеМатериалы = ПолучитьИзВременногоХранилища(Параметры.АдресПодобранныеМатериалы);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(
		"ПересчитатьКоличествоУпаковокСуффикс",
		Новый Структура("Суффикс, НужноОкруглять", "Подобрано", Ложь));
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	Для каждого Строка Из Материалы Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Строка);
		НайденныеСтроки = ПодобранныеМатериалы.НайтиСтроки(СтруктураПоиска);
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			
			Для каждого СтрокаПодобрано Из НайденныеСтроки Цикл
				Строка.КоличествоПодобрано = Строка.КоличествоПодобрано + СтрокаПодобрано.Количество;
			КонецЦикла;
			
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(Строка, СтруктураДействий, КэшированныеЗначения);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПеренестиИЗакрыть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ПеренестиМатериалыВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиМатериалыВДокумент()
	
	Результат = ПоместитьМатериалыВХранилище();
	
	Модифицированность = Ложь;
	Закрыть();
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьМатериалыВХранилище()
	
	ТаблицаМатериалов = РеквизитФормыВЗначение("Материалы").СкопироватьКолонки(СоставРезультата());
	
	Для каждого Строка Из Материалы Цикл
		
		Если Строка.Количество <> 0 Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаМатериалов.Добавить(), Строка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаМатериалов);
	
КонецФункции

&НаСервере
Функция СоставРезультата()
	
	Возврат
		"Этап,
		|Номенклатура,
		|Характеристика,
		|Упаковка,
		|КоличествоУпаковок,
		|Количество,
		|СтатьяКалькуляции,
		|Производится,
		|Спецификация,
		|ПрименениеМатериала,
		|КлючСвязиСпецификация";
	
КонецФункции

&НаКлиенте
Функция ЕстьДанныеДляПереноса()
	
	Результат = Ложь;
	
	Для каждого Строка Из Материалы Цикл
		
		Если Строка.Количество <> 0 Тогда
			
			Результат = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНастройкиПримененияМатериала(ДанныеСтроки)
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Номенклатура", ДанныеСтроки.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", ДанныеСтроки.Характеристика);
	
	ПараметрыФормы.Вставить("ПрименениеМатериала", ДанныеСтроки.ПрименениеМатериала);
	ПараметрыФормы.Вставить("Альтернативный", ДанныеСтроки.Альтернативный);
	ПараметрыФормы.Вставить("Вероятность", ДанныеСтроки.Вероятность);
	
	ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	
	ОткрытьФорму("Справочник.РесурсныеСпецификации.Форма.ФормаНастройкиПримененияМатериала", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

#КонецОбласти
