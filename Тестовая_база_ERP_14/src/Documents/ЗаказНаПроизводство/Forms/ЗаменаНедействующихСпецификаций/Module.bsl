#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбработатьПараметрыФормы();
	
	ЗаполнитьСписокЗаказов();
	
	ОпределитьНаличиеПолуфабрикатов();
	
	ОпределитьБольшеНеИспользуемыеПолуфабрикаты(ЭтаФорма);
	
	ОпределитьПроизводствоЗапущено();
	
	ПараметрыВыбораСпецификаций = УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификацийНаИзготовлениеСборку();
	УправлениеДаннымиОбИзделияхКлиентСервер.УстановитьПараметрыВыбораСпецификаций(Элементы.СписокЗаказовНоваяСпецификация, ПараметрыВыбораСпецификаций);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗаменаВФормеЗаказе Тогда
	
		ОповещениеСохранитьИЗакрыть = Новый ОписаниеОповещения(
			"ВыполнитьЗаменуИЗакрыть", ЭтаФорма);
		
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
			ОповещениеСохранитьИЗакрыть, Отказ, ЗавершениеРаботы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаменуИЗакрыть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыполнитьЗамену();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""Заменить на спецификацию"" в строке %1';
							|en = 'Column ""Replace with BOM"" is not populated in line %1'");
	НомерСтроки = 1;
	Для каждого ДанныеСтроки Из СписокЗаказов Цикл
		Если ДанныеСтроки.Заменить
			И НЕ ЗначениеЗаполнено(ДанныеСтроки.НоваяСпецификация)
			И НЕ ДанныеСтроки.БольшеНеИспользуется
			И НЕ ДанныеСтроки.ПроизводствоЗапущено Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Формат(НомерСтроки, "ЧГ=0"));
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СписокЗаказов", НомерСтроки, "НоваяСпецификация");
   			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
		КонецЕсли; 
		
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗаказов

&НаКлиенте
Процедура СписокЗаказовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СписокЗаказовВходитВИзделиеНоменклатура"
		ИЛИ Поле.Имя = "СписокЗаказовВходитВИзделиеХарактеристика" Тогда
		СтандартнаяОбработка = Ложь;
		ПерейтиКИзделиюВКотороеВходитПолуфабрикат();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗаказовЗаменитьПриИзменении(Элемент)
	
	ОпределитьБольшеНеИспользуемыеПолуфабрикаты(ЭтаФорма);
	
	Если ЗаменаВФормеЗаказе Тогда
		Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗаказовНоваяСпецификацияПриИзменении(Элемент)
	
	Если ЗаменаВФормеЗаказе Тогда
		Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСнятьФлажки(Команда)
	
	УстановитьФлажки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажки(Команда)
	
	УстановитьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнитьЗамену(Команда)
	
	ВыполнитьЗамену();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрытьЗаказ(Команда)
	
	ТекущиеДанные = Элементы.СписокЗаказов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ,АктивироватьСтрокуПродукции", 
					ТекущиеДанные.Заказ, ТекущиеДанные.КодСтроки);
					
	ОткрытьФорму("Документ.ЗаказНаПроизводство.ФормаОбъекта", ПараметрыФормы); 
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

&НаСервере
Процедура ЗаполнитьСписокЗаказов()

	СписокЗаказов.Очистить();
	
	Если ЗаменаВФормеЗаказе Тогда
		
		ЗаполнитьПоДаннымЗаказа();
		
	Иначе
		
		ЗаполнитьПоОтбору();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымЗаказа()

	ДанныеДляЗаменыСпецификаций = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Продукция        = ДанныеДляЗаменыСпецификаций.Продукция;
	МатериалыИУслуги = ДанныеДляЗаменыСпецификаций.МатериалыИУслуги;
	
	МатериалыИУслуги.Колонки.Добавить("КодСтрокиПродукция", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0)));
	
	// Заполним связь с ТЧ Продукция через число, т.к. уникальный идентификатор нельзя использовать.
	СоответствиеКодовСтрокиПродукция = Новый Соответствие;
	Для каждого СтрокаПродукция Из Продукция Цикл
		СоответствиеКодовСтрокиПродукция.Вставить(СтрокаПродукция.КодСтроки, СтрокаПродукция.КлючСвязи);
		СтруктураПоиска = Новый Структура("КлючСвязиПродукция", СтрокаПродукция.КлючСвязи);
		СписокСтрок = МатериалыИУслуги.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрокаМатериал Из СписокСтрок Цикл
			СтрокаМатериал.КодСтрокиПродукция = СтрокаПродукция.КодСтроки;
		КонецЦикла; 
	КонецЦикла; 
	
	СоответствиеКодовСтрокиМатериалыИУслуги = Новый Соответствие;
	Для каждого СтрокаМатериал Из МатериалыИУслуги Цикл
		СоответствиеКодовСтрокиМатериалыИУслуги.Вставить(СтрокаМатериал.КодСтроки, СтрокаМатериал.КлючСвязи);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПродукция.НомерСтроки КАК НомерСтроки,
	|	ТаблицаПродукция.Номенклатура КАК Номенклатура,
	|	ТаблицаПродукция.Характеристика КАК Характеристика,
	|	ТаблицаПродукция.Назначение КАК Назначение,
	|	ТаблицаПродукция.ДатаПотребности КАК ДатаПотребности,
	|	ТаблицаПродукция.НачатьНеРанее КАК НачатьНеРанее,
	|	ТаблицаПродукция.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТаблицаПродукция.Упаковка КАК Упаковка,
	|	ТаблицаПродукция.КодСтроки КАК КодСтроки,
	|	ВЫРАЗИТЬ(ТаблицаПродукция.Спецификация КАК Справочник.РесурсныеСпецификации) КАК ТекущаяСпецификация
	|ПОМЕСТИТЬ ТаблицаПродукция
	|ИЗ
	|	&ТаблицаПродукция КАК ТаблицаПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаМатериалыИУслуги.НомерСтроки КАК НомерСтроки,
	|	ТаблицаМатериалыИУслуги.Номенклатура КАК Номенклатура,
	|	ТаблицаМатериалыИУслуги.Характеристика КАК Характеристика,
	|	ТаблицаМатериалыИУслуги.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТаблицаМатериалыИУслуги.Упаковка КАК Упаковка,
	|	ТаблицаМатериалыИУслуги.КодСтроки КАК КодСтроки,
	|	ТаблицаМатериалыИУслуги.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	ВЫРАЗИТЬ(ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката КАК Справочник.РесурсныеСпецификации) КАК ТекущаяСпецификация,
	|	ИСТИНА КАК ПроизводитсяВПроцессе
	|ПОМЕСТИТЬ ТаблицаМатериалыИУслуги
	|ИЗ
	|	&ТаблицаМатериалыИУслуги КАК ТаблицаМатериалыИУслуги
	|ГДЕ
	|	ТаблицаМатериалыИУслуги.ПроизводитсяВПроцессе
	|		И ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката ССЫЛКА Справочник.РесурсныеСпецификации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПродукция.НомерСтроки,
	|	ТаблицаПродукция.Номенклатура,
	|	ТаблицаПродукция.Характеристика,
	|	ТаблицаПродукция.Назначение,
	|	ТаблицаПродукция.ДатаПотребности,
	|	ТаблицаПродукция.НачатьНеРанее,
	|	ТаблицаПродукция.КоличествоУпаковок,
	|	ТаблицаПродукция.Упаковка,
	|	ТаблицаПродукция.КодСтроки,
	|	0 КАК КодСтрокиПродукция,
	|	ТаблицаПродукция.ТекущаяСпецификация,
	|	ТаблицаПродукция.ТекущаяСпецификация.Представление КАК ТекущаяСпецификацияПредставление,
	|	ЛОЖЬ КАК ПроизводитсяВПроцессе,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК ВходитВИзделиеНоменклатура,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ВходитВИзделиеХарактеристика,
	|	ТаблицаПродукция.ТекущаяСпецификация.НачалоДействия КАК НачалоДействия,
	|	ТаблицаПродукция.ТекущаяСпецификация.КонецДействия КАК КонецДействия,
	|	ТаблицаПродукция.ТекущаяСпецификация.Статус КАК Статус
	|ИЗ
	|	ТаблицаПродукция КАК ТаблицаПродукция
	|ГДЕ
	|	(ТаблицаПродукция.ТекущаяСпецификация.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификаций.Действует)
	|			ИЛИ ТаблицаПродукция.ТекущаяСпецификация.НачалоДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.ДатаПотребности < ТаблицаПродукция.ТекущаяСпецификация.НачалоДействия
	|			ИЛИ ТаблицаПродукция.ТекущаяСпецификация.КонецДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.ДатаПотребности > ТаблицаПродукция.ТекущаяСпецификация.КонецДействия
	|			ИЛИ ТаблицаПродукция.ТекущаяСпецификация.НачалоДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.НачатьНеРанее < ТаблицаПродукция.ТекущаяСпецификация.НачалоДействия
	|			ИЛИ ТаблицаПродукция.ТекущаяСпецификация.КонецДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.НачатьНеРанее >= ТаблицаПродукция.ТекущаяСпецификация.КонецДействия)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаМатериалыИУслуги.НомерСтроки,
	|	ТаблицаМатериалыИУслуги.Номенклатура,
	|	ТаблицаМатериалыИУслуги.Характеристика,
	|	ТаблицаПродукция.Назначение,
	|	ТаблицаПродукция.ДатаПотребности,
	|	ТаблицаПродукция.НачатьНеРанее,
	|	ТаблицаМатериалыИУслуги.КоличествоУпаковок,
	|	ТаблицаМатериалыИУслуги.Упаковка,
	|	ТаблицаМатериалыИУслуги.КодСтроки,
	|	ТаблицаМатериалыИУслуги.КодСтрокиПродукция,
	|	ТаблицаМатериалыИУслуги.ТекущаяСпецификация,
	|	ТаблицаМатериалыИУслуги.ТекущаяСпецификация.Представление,
	|	ИСТИНА,
	|	ТаблицаПродукция.Номенклатура,
	|	ТаблицаПродукция.Характеристика,
	|	ТаблицаМатериалыИУслуги.ТекущаяСпецификация.НачалоДействия,
	|	ТаблицаМатериалыИУслуги.ТекущаяСпецификация.КонецДействия,
	|	ТаблицаМатериалыИУслуги.ТекущаяСпецификация.Статус
	|ИЗ
	|	ТаблицаМатериалыИУслуги КАК ТаблицаМатериалыИУслуги
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПродукция КАК ТаблицаПродукция
	|		ПО (ТаблицаПродукция.КодСтроки = ТаблицаМатериалыИУслуги.КодСтрокиПродукция)
	|ГДЕ
	|	(ТаблицаМатериалыИУслуги.ТекущаяСпецификация.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификаций.Действует)
	|			ИЛИ ТаблицаМатериалыИУслуги.ТекущаяСпецификация.НачалоДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.ДатаПотребности < ТаблицаМатериалыИУслуги.ТекущаяСпецификация.НачалоДействия
	|			ИЛИ ТаблицаМатериалыИУслуги.ТекущаяСпецификация.КонецДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.ДатаПотребности > ТаблицаМатериалыИУслуги.ТекущаяСпецификация.КонецДействия
	|			ИЛИ ТаблицаМатериалыИУслуги.ТекущаяСпецификация.НачалоДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.НачатьНеРанее < ТаблицаМатериалыИУслуги.ТекущаяСпецификация.НачалоДействия
	|			ИЛИ ТаблицаМатериалыИУслуги.ТекущаяСпецификация.КонецДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.НачатьНеРанее >= ТаблицаМатериалыИУслуги.ТекущаяСпецификация.КонецДействия)";
	
	Запрос.УстановитьПараметр("ТаблицаПродукция",        Продукция);
	Запрос.УстановитьПараметр("ТаблицаМатериалыИУслуги", МатериалыИУслуги);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеСтроки = СписокЗаказов.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		
		ДанныеСтроки.ПредставлениеСтроки = Формат(Выборка.НомерСтроки, "ЧГ=0");
		
		// Восстановим ключ связи, который потеряли при работе с временными таблицами
		Если Выборка.ПроизводитсяВПроцессе Тогда
			ДанныеСтроки.КлючСвязи = СоответствиеКодовСтрокиМатериалыИУслуги.Получить(Выборка.КодСтроки);
			ДанныеСтроки.КлючСвязиПродукция = СоответствиеКодовСтрокиПродукция.Получить(Выборка.КодСтрокиПродукция);
		Иначе
			ДанныеСтроки.КлючСвязи = СоответствиеКодовСтрокиПродукция.Получить(Выборка.КодСтроки);
		КонецЕсли; 
		
		ЗаполнитьДанныеСтроки(ДанныеСтроки, Выборка);
		
	КонецЦикла;
	
	// Заполним Заказ
	Для каждого ДанныеСтроки Из СписокЗаказов Цикл
		ДанныеСтроки.Заказ = Заказ;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОтбору()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПродукция.Ссылка КАК Заказ,
	|	ТаблицаПродукция.Ссылка.Номер КАК Номер,
	|	ТаблицаПродукция.Ссылка.Дата КАК Дата,
	|	ТаблицаПродукция.НомерСтроки,
	|	ТаблицаПродукция.Номенклатура,
	|	ТаблицаПродукция.Характеристика,
	|	ТаблицаПродукция.Назначение,
	|	ТаблицаПродукция.ДатаПотребности,
	|	ТаблицаПродукция.НачатьНеРанее,
	|	ТаблицаПродукция.КоличествоУпаковок,
	|	ТаблицаПродукция.Упаковка,
	|	ТаблицаПродукция.КодСтроки,
	|	ТаблицаПродукция.КлючСвязи,
	|	&ПустойКлючСвязи КАК КлючСвязиПродукция,
	|	ТаблицаПродукция.Спецификация,
	|	ТаблицаПродукция.Спецификация.Представление КАК ТекущаяСпецификацияПредставление,
	|	ЛОЖЬ КАК ПроизводитсяВПроцессе,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК ВходитВИзделиеНоменклатура,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ВходитВИзделиеХарактеристика,
	|	ТаблицаПродукция.Спецификация.НачалоДействия КАК НачалоДействия,
	|	ТаблицаПродукция.Спецификация.КонецДействия КАК КонецДействия,
	|	ТаблицаПродукция.Спецификация.Статус КАК Статус
	|ИЗ
	|	Документ.ЗаказНаПроизводство.Продукция КАК ТаблицаПродукция
	|ГДЕ
	|	(ТаблицаПродукция.Спецификация.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификаций.Действует)
	|			ИЛИ ТаблицаПродукция.Спецификация.НачалоДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.ДатаПотребности < ТаблицаПродукция.Спецификация.НачалоДействия
	|			ИЛИ ТаблицаПродукция.Спецификация.КонецДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.ДатаПотребности > ТаблицаПродукция.Спецификация.КонецДействия
	|			ИЛИ ТаблицаПродукция.Спецификация.НачалоДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.НачатьНеРанее < ТаблицаПродукция.Спецификация.НачалоДействия
	|			ИЛИ ТаблицаПродукция.Спецификация.КонецДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.НачатьНеРанее >= ТаблицаПродукция.Спецификация.КонецДействия)
	|	И (ТаблицаПродукция.Ссылка.Подразделение = &Подразделение
	|			ИЛИ &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))
	|	И (ТаблицаПродукция.Ссылка.Ответственный = &Ответственный
	|			ИЛИ &Ответственный = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
	|	И ТаблицаПродукция.Ссылка.Проведен
	|	И ТаблицаПродукция.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Закрыт)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаМатериалыИУслуги.Ссылка,
	|	ТаблицаМатериалыИУслуги.Ссылка.Номер,
	|	ТаблицаМатериалыИУслуги.Ссылка.Дата,
	|	ТаблицаМатериалыИУслуги.НомерСтроки,
	|	ТаблицаМатериалыИУслуги.Номенклатура,
	|	ТаблицаМатериалыИУслуги.Характеристика,
	|	ТаблицаПродукция.Назначение,
	|	ТаблицаПродукция.ДатаПотребности,
	|	ТаблицаПродукция.НачатьНеРанее,
	|	ТаблицаМатериалыИУслуги.КоличествоУпаковок,
	|	ТаблицаМатериалыИУслуги.Упаковка,
	|	ТаблицаПродукция.КодСтроки,
	|	ТаблицаМатериалыИУслуги.КлючСвязи,
	|	ТаблицаМатериалыИУслуги.КлючСвязиПродукция,
	|	РесурсныеСпецификации.Ссылка,
	|	РесурсныеСпецификации.Представление,
	|	ИСТИНА,
	|	ТаблицаПродукция.Номенклатура,
	|	ТаблицаПродукция.Характеристика,
	|	РесурсныеСпецификации.НачалоДействия,
	|	РесурсныеСпецификации.КонецДействия,
	|	РесурсныеСпецификации.Статус
	|ИЗ
	|	Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ТаблицаМатериалыИУслуги
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК ТаблицаПродукция
	|		ПО (ТаблицаПродукция.КлючСвязи = ТаблицаМатериалыИУслуги.КлючСвязиПродукция)
	|			И (ТаблицаПродукция.Ссылка = ТаблицаМатериалыИУслуги.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РесурсныеСпецификации КАК РесурсныеСпецификации
	|		ПО ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката = РесурсныеСпецификации.Ссылка
	|ГДЕ
	|	(РесурсныеСпецификации.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСпецификаций.Действует)
	|			ИЛИ РесурсныеСпецификации.НачалоДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.ДатаПотребности < РесурсныеСпецификации.НачалоДействия
	|			ИЛИ РесурсныеСпецификации.КонецДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.ДатаПотребности > РесурсныеСпецификации.КонецДействия
	|			ИЛИ РесурсныеСпецификации.НачалоДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.НачатьНеРанее < РесурсныеСпецификации.НачалоДействия
	|			ИЛИ РесурсныеСпецификации.КонецДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|				И ТаблицаПродукция.НачатьНеРанее >= РесурсныеСпецификации.КонецДействия)
	|	И (ТаблицаМатериалыИУслуги.Ссылка.Подразделение = &Подразделение
	|			ИЛИ &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))
	|	И (ТаблицаМатериалыИУслуги.Ссылка.Ответственный = &Ответственный
	|			ИЛИ &Ответственный = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
	|	И ТаблицаМатериалыИУслуги.Ссылка.Проведен
	|	И ТаблицаМатериалыИУслуги.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Закрыт)";
	
	Запрос.УстановитьПараметр("Подразделение",   Подразделение);
	Запрос.УстановитьПараметр("Ответственный",   Ответственный);
	Запрос.УстановитьПараметр("ПустойКлючСвязи", ПустойКлючСвязи);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеСтроки = СписокЗаказов.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		
		НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.Номер, Ложь, Истина);
		ДанныеСтроки.ПредставлениеСтроки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = '№%1 от %2 (строка %3)';
											|en = 'No. %1 from %2 (line %3)'"),
										НомерДокумента,
										Формат(Выборка.Дата, "ДЛФ=D"),
										Формат(Выборка.НомерСтроки, "ЧГ=0"));
		
		ЗаполнитьДанныеСтроки(ДанныеСтроки, Выборка);
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСтроки(ДанныеСтроки, Выборка)
		
	// Сформируем представление статуса спецификации, 
	// чтобы пользователь понимал почему она недействующая.
	Если Выборка.Статус = Перечисления.СтатусыСпецификаций.Действует Тогда
		Если Выборка.НачалоДействия <> '000101010000' И Выборка.КонецДействия <> '000101010000' Тогда
			ПредставлениеСтатус = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											НСтр("ru = 'Действует с %1 по %2';
												|en = 'Valid from %1 to %2'"),
											Формат(Выборка.НачалоДействия, "ДЛФ=D"),
											Формат(Выборка.КонецДействия, "ДЛФ=D"));
		ИначеЕсли Выборка.НачалоДействия <> '000101010000' Тогда
			ПредставлениеСтатус = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											НСтр("ru = 'Действует с %1';
												|en = 'Valid from %1'"),
											Формат(Выборка.НачалоДействия, "ДЛФ=D"));
		Иначе
			ПредставлениеСтатус = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											НСтр("ru = 'Действует по %1';
												|en = 'Valid until %1'"),
											Формат(Выборка.КонецДействия, "ДЛФ=D"));
		КонецЕсли; 
	Иначе
		ПредставлениеСтатус = Строка(Выборка.Статус);
	КонецЕсли; 
	ДанныеСтроки.ТекущаяСпецификацияПредставление = ДанныеСтроки.ТекущаяСпецификацияПредставление + " (" + ПредставлениеСтатус + ")";
	
	// Определим на какую спецификацию можно заменить
	ДанныеСпецификации = УправлениеДаннымиОбИзделияхВызовСервера.СпецификацияИзделия(
											ДанныеСтроки.Номенклатура, 
											ДанныеСтроки.Характеристика, 
											ДанныеСтроки.НачатьНеРанее,
											Подразделение,
											ПараметрыВыбораСпецификаций);
											
	Если ДанныеСпецификации <> Неопределено Тогда
		ДанныеСтроки.НоваяСпецификация = ДанныеСпецификации.Спецификация;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОпределитьНаличиеПолуфабрикатов()

	Для каждого ДанныеСтроки Из СписокЗаказов Цикл
		СтруктураПоиска = Новый Структура("Заказ,КлючСвязиПродукция", ДанныеСтроки.Заказ, ДанныеСтроки.КлючСвязи);
		СписокСтрок = СписокЗаказов.НайтиСтроки(СтруктураПоиска);
		ДанныеСтроки.ЕстьПолуфабрикаты = (СписокСтрок.Количество() <> 0);
	КонецЦикла; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОпределитьБольшеНеИспользуемыеПолуфабрикаты(Форма)

	// Обработаем только те строки для которых есть полуфабрикаты
	СтруктураПоиска = Новый Структура("ЕстьПолуфабрикаты", Истина);
 	СписокСтрокПродукция = Форма.СписокЗаказов.НайтиСтроки(СтруктураПоиска);
	Для каждого СтрокаПродукция Из СписокСтрокПродукция Цикл
		
		СтруктураПоиска = Новый Структура("Заказ,КлючСвязиПродукция", СтрокаПродукция.Заказ, СтрокаПродукция.КлючСвязи);
		СписокСтрокПолуфабрикаты = Форма.СписокЗаказов.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрокаПолуфабрикат Из СписокСтрокПолуфабрикаты Цикл
			СтрокаПолуфабрикат.БольшеНеИспользуется = СтрокаПродукция.Заменить;
		КонецЦикла; 
		
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ОпределитьПроизводствоЗапущено()
	
	ТаблицаСписокЗаказов = СписокЗаказов.Выгрузить();
	ТаблицаСписокЗаказов.Свернуть("Заказ,КодСтроки");
	ЗапущенныеЭтапы = ПланированиеПроизводства.ЭтапыПоКоторымЗапущеноПроизводство(ТаблицаСписокЗаказов);
	
	Для каждого ДанныеСтроки Из СписокЗаказов Цикл
		КодСтрокиПродукция = ?(ДанныеСтроки.КодСтрокиПродукция = 0, ДанныеСтроки.КодСтроки, ДанныеСтроки.КодСтрокиПродукция);
		СтруктураПоиска = Новый Структура("Распоряжение,КодСтрокиПродукция", ДанныеСтроки.Заказ, КодСтрокиПродукция);
  		СписокСтрок = ЗапущенныеЭтапы.НайтиСтроки(СтруктураПоиска);
		ДанныеСтроки.ПроизводствоЗапущено = (СписокСтрок.Количество() <> 0);
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Оформление полуфабрикатов
	#Область ПроизводитсяВПроцессе
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.ПроизводитсяВПроцессе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.БольшеНеИспользуется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.ПроизводствоЗапущено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстПредопределенногоЗначения);
	
	#КонецОбласти
	
	// Оформление полуфабриката, который не будет использоваться, в результате применения новой спецификации.
	#Область БольшеНеИспользуется
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.БольшеНеИспользуется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.ПроизводствоЗапущено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстПредопределенногоЗначения);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,,,, Истина));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказовЗаменить.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.БольшеНеИспользуется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	#КонецОбласти
	
	// Оформление продукции, для которой уже запущено производство
	#Область ПроизводствоЗапущено
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.ПроизводствоЗапущено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗавершенныйБизнесПроцесс);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказовЗаменить.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.ПроизводствоЗапущено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	#КонецОбласти
	
	// Стандартное оформление номенклатуры
	#Область Номенклатура

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "СписокЗаказовНоменклатураЕдиницаИзмерения", 
                                                                   "СписокЗаказов.Упаковка");

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "СписокЗаказовХарактеристика",
																		     "СписокЗаказов.ХарактеристикиИспользуются");

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказовНазначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.Назначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<без назначения>';
																|en = '<without assignment>'"));
	
	#КонецОбласти
	
	// Отметка не обязательного заполнения спецификации
	#Область СпецификацияОтметкаНеЗаполненного

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказовНоваяСпецификация.Имя);

	ОтборГруппа = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппа.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ОтборГруппа.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.Заменить");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ОтборГруппа.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.БольшеНеИспользуется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ОтборГруппа.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.ПроизводствоЗапущено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНеЗаполненного", Ложь);
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрыФормы()

	Если Параметры.Свойство("Заказ") Тогда
		
		// Форма открывается из формы заказа
		ЗаменаВФормеЗаказе = Истина;
		
		Подразделение = Параметры.Подразделение;
		Заказ = Параметры.Заказ;
		
		Заголовок = НСтр("ru = 'Замена недействующих спецификаций в заказе';
						|en = 'Invalid BOM replacement in order'");
		
		Элементы.ФормаВыполнитьЗамену.Заголовок = НСтр("ru = 'Перенести в заказ';
														|en = 'Move to order'");
		
		Элементы.СписокЗаказовПредставлениеСтроки.Заголовок = НСтр("ru = 'Номер строки';
																	|en = 'Line number'");
		Элементы.СписокЗаказовОткрытьЗаказ.Видимость = Ложь;
		
		АдресХранилища = Параметры.ДанныеДляЗаменыСпецификаций;
		
	Иначе
		
		Заголовок = НСтр("ru = 'Замена недействующих спецификаций в заказах';
						|en = 'Invalid BOM replacement in orders'");
		
		Элементы.СписокЗаказовПредставлениеСтроки.Заголовок = НСтр("ru = 'Заказ и номер строки';
																	|en = 'Order and line number'");
		
		Если Параметры.Свойство("СтруктураБыстрогоОтбора") Тогда
			// Форма открывается из текущих дел
			Подразделение = Параметры.СтруктураБыстрогоОтбора.Подразделение;
			Ответственный = Параметры.СтруктураБыстрогоОтбора.Ответственный;
		Иначе
			Подразделение = Параметры.Подразделение;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКИзделиюВКотороеВходитПолуфабрикат()

	ТекущиеДанные = Элементы.СписокЗаказов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено 
		ИЛИ ТекущиеДанные.КодСтрокиПродукция = 0 Тогда
		Возврат
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура("КодСтроки", ТекущиеДанные.КодСтрокиПродукция);
 	СписокСтрок = СписокЗаказов.НайтиСтроки(СтруктураПоиска);
	Если СписокСтрок.Количество() <> 0 Тогда
		Элементы.СписокЗаказов.ТекущаяСтрока = СписокСтрок[0].ПолучитьИдентификатор();
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Отметка)

	Для каждого СтрокаЗаказ Из СписокЗаказов Цикл
		СтрокаЗаказ.Заменить = Отметка;
	КонецЦикла; 
	
	ОпределитьБольшеНеИспользуемыеПолуфабрикаты(ЭтаФорма);

	Если ЗаменаВФормеЗаказе Тогда
		Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗамену()

	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаменаВФормеЗаказе Тогда
		
		Модифицированность = Ложь;
		ПередатьВЗаказДанныеЗамены();
		
	Иначе
		
		ВыполнитьЗаменуВЗаказахНаСервере();
		
		Если ВсегоЗамен = 0 Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать строки, в которых требуется выполнить замену';
											|en = 'Select lines in which replacement should be made'"));
			Возврат
			
		ИначеЕсли ВыполненоЗамен = ВсегоЗамен Тогда
			
			// Успешно заменили во всех заказах
			ТекстЗавершеннойОперации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											НСтр("ru = 'Выполнена замена в %1 из %2 заказах';
												|en = 'Replacement is completed in %1 out of %2 orders'"), 
											Формат(ВыполненоЗамен, "ЧГ=0"), 
											Формат(ВсегоЗамен, "ЧГ=0"));
											
			ПоказатьОповещениеПользователя(ТекстЗавершеннойОперации);
			ЗаполнитьСписокЗаказов();
			Оповестить("Запись_ЗаказНаПроизводство");
			ОповеститьОбИзменении(Тип("ДокументСсылка.ЗаказНаПроизводство"));
			
		ИначеЕсли ВыполненоЗамен = 0 Тогда
			
			// Ни в одном заказе не смогли заменить
			ПоказатьПредупреждение(,НСтр("ru = 'Не удалось выполнить замену';
										|en = 'Failed to replace'"));
			Возврат;
			
		Иначе
			
			// В некоторых заказах не смогли заменить
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											НСтр("ru = 'Замена выполнена не во всех заказах (в %1 из %2).
											|Завершить замену?';
											|en = 'Replacement is not executed in all orders (in %1 out of %2).
											|Complete replacement?'"), 
											Формат(ВыполненоЗамен, "ЧГ=0"), 
											Формат(ВсегоЗамен, "ЧГ=0"));
											
			ПоказатьПредупреждение(, ТекстСообщения);
			ЗаполнитьСписокЗаказов();
			Оповестить("Запись_ЗаказНаПроизводство");
			ОповеститьОбИзменении(Тип("ДокументСсылка.ЗаказНаПроизводство"));
			
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьВЗаказДанныеЗамены()

	ДанныеЗамены = Новый Массив;
	Для каждого ДанныеСтроки Из СписокЗаказов Цикл
		Если ДанныеСтроки.Заменить
			И НЕ ДанныеСтроки.БольшеНеИспользуется 
			И НЕ ДанныеСтроки.ПроизводствоЗапущено Тогда
			ДанныеЗамены.Добавить(ПараметрыЗамены(ДанныеСтроки));
		КонецЕсли;
	КонецЦикла; 
	
	Если ДанныеЗамены.Количество() = 0 Тогда
		ДанныеЗамены = Неопределено;
	КонецЕсли;
	
	Закрыть(ДанныеЗамены);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗаменуВЗаказахНаСервере()

	СтруктураПоиска = Новый Структура("Заменить,БольшеНеИспользуется,ПроизводствоЗапущено", Истина, Ложь, Ложь);
	ТаблицаЗаказы = СписокЗаказов.Выгрузить(СтруктураПоиска);
	ТаблицаЗаказы.Свернуть("Заказ");
	
	ВсегоЗамен = 0;
	ВыполненоЗамен = 0;
	
	Для каждого СтрокаЗаказ Из ТаблицаЗаказы Цикл
		
		// Получим данные замены в заказе
		СтруктураПоиска = Новый Структура("Заказ", СтрокаЗаказ.Заказ);
		СтруктураПоиска.Вставить("Заменить",                  Истина);
		СтруктураПоиска.Вставить("БольшеНеИспользуется",        Ложь);
		СтруктураПоиска.Вставить("ПроизводствоЗапущено",        Ложь);
		
		СписокСтрок = СписокЗаказов.НайтиСтроки(СтруктураПоиска);
		ДанныеЗамены = Новый Массив;
		Для каждого ДанныеСтроки Из СписокСтрок Цикл
			ДанныеЗамены.Добавить(ПараметрыЗамены(ДанныеСтроки));
		КонецЦикла; 
		
		ВсегоЗамен = ВсегоЗамен + 1;
		
		ЗаказОбъект = ДанныеСтроки.Заказ.ПолучитьОбъект();
		ЗаказОбъект.ЗаменитьСпецификации(ДанныеЗамены);
		
		Если ЗаказОбъект.ПроверитьЗаполнение() Тогда
			
			Попытка
				
				Если ЗаказОбъект.Проведен Тогда
					ЗаказОбъект.Записать(РежимЗаписиДокумента.Проведение);
				Иначе	
					ЗаказОбъект.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
				ВыполненоЗамен = ВыполненоЗамен + 1;
				
			Исключение
				
				СобытиеЖурналаРегистрации = НСтр("ru = 'Не удалось выполнить замену спецификаций';
												|en = 'Cannot replace BOMs'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				
				ЗаписьЖурналаРегистрации(
					СобытиеЖурналаРегистрации,
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Документы.ЗаказНаПроизводство,
					ДанныеСтроки.Заказ,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			КонецПопытки;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗамены(ДанныеСтроки)

	ПараметрыЗамены = Новый Структура;
	ПараметрыЗамены.Вставить("КлючСвязи", ДанныеСтроки.КлючСвязи);
	ПараметрыЗамены.Вставить("КлючСвязиПродукция", ДанныеСтроки.КлючСвязиПродукция);
	ПараметрыЗамены.Вставить("Спецификация", ДанныеСтроки.НоваяСпецификация);
	
	Возврат ПараметрыЗамены;

КонецФункции

#КонецОбласти

#КонецОбласти
