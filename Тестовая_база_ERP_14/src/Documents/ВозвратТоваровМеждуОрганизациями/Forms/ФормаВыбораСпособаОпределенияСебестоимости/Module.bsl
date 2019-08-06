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
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ИспользоватьНесколькоВидовЦен = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен");
	НастроитьФормуПоПараметрам(Параметры);
	НастроитьПараметрыВыбораДокументаПередачи(Параметры);
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПередачи
		И НЕ ЗначениеЗаполнено(ДокументПередачи) Тогда
		ПроверяемыеРеквизиты.Добавить("ДокументПередачи");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособОпределенияСебестоимостиВручнуюПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияСебестоимостиТекущийДокументПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияСебестоимостиДокументПередачиПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	ЗаполнитьСуммыПоВидуЦен();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗаполненияПриИзменении(Элемент)
	
	ЗаполнитьСуммыПоВидуЦен();

КонецПроцедуры

&НаКлиенте
Процедура СуммаУпрПриИзменении(Элемент)
	
	Если ТипНалогообложения <> ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС") Тогда
		СебестоимостьУпрБезНДС = СебестоимостьУпр;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОКЗакрыть(Команда)

	ОчиститьСообщения();
	Если ПроверитьЗаполнение() Тогда
		ПеренестиДанныеВДокумент();
	КонецЕсли;
		
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьПараметрыВыбораДокументаПередачи(Параметры)
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Организация", Параметры.Организация));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ОрганизацияПолучатель", Параметры.ОрганизацияПолучатель));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Договор", Параметры.Договор));
	Элементы.ДокументПередачи.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимость(Форма)
	
	Если Форма.СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.Вручную") Тогда
		Форма.Элементы.ГруппаСуммы.ТекущаяСтраница = Форма.Элементы.ГруппаВручнуюДанные;
	Иначе
		Форма.Элементы.ГруппаСуммы.ТекущаяСтраница = Форма.Элементы.ГруппаВручнуюПустая;
	КонецЕсли;
	Если Форма.СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.ИзДокументаПередачи") Тогда
		Форма.Элементы.ГруппаСтраницыДокументПередачи.ТекущаяСтраница = Форма.Элементы.СтраницаДокументПередачи;
	Иначе
		Форма.Элементы.ГруппаСтраницыДокументПередачи.ТекущаяСтраница = Форма.Элементы.СтраницаДокументПередачиПустая;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуммыПоВидуЦен()
	
	Если НЕ ЗначениеЗаполнено(ВидЦены) ИЛИ НЕ ЗначениеЗаполнено(ДатаЗаполнения) Тогда
		Элементы.НадписьНетЦеныНаДату.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	СтруктураОтбораПоВидуЦен = Новый Структура;
	СтруктураОтбораПоВидуЦен.Вставить("Ссылка", ВидЦены);
	ЦенаВключаетНДС = Справочники.ВидыЦен.ВидЦеныИПризнакЦенаВключаетНДСПоУмолчанию(СтруктураОтбораПоВидуЦен).ЦенаВключаетНДС;

	СтруктураПараметровОтбора = Новый Структура;
	СтруктураПараметровОтбора.Вставить("Валюта", ВалютаДокумента);
	СтруктураПараметровОтбора.Вставить("Дата", ДатаЗаполнения);
	СтруктураПараметровОтбора.Вставить("ВидЦены", ВидЦены);
	СтруктураПараметровОтбора.Вставить("Номенклатура", Номенклатура);
	СтруктураПараметровОтбора.Вставить("Характеристика", Характеристика);
	СтруктураПараметровОтбора.Вставить("Упаковка", Упаковка);
	Цена = ПродажиСервер.ПолучитьЦенуПоОтбору(СтруктураПараметровОтбора);
	Себестоимость = Цена * КоличествоУпаковок
			* ?(ВалютаДокумента = ВалютаУправленческогоУчета,
				1,
				РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаДокумента,
					ВалютаУправленческогоУчета,
					ДатаЗаполнения)
				);
	СуммаНДС = ЦенообразованиеКлиентСервер.РассчитатьСуммуНДС(Себестоимость, СтавкаНДС, ЦенаВключаетНДС);
	Если ЦенаВключаетНДС Тогда
		СебестоимостьУпр = Себестоимость;
		СебестоимостьУпрБезНДС = СебестоимостьУпр - СуммаНДС;
	Иначе
		СебестоимостьУпрБезНДС = Себестоимость;
		СебестоимостьУпр = СебестоимостьУпрБезНДС + СуммаНДС;
	КонецЕсли;
	
	//++ НЕ УТ
	СебестоимостьРегл = СебестоимостьУпрБезНДС
		* ?(ВалютаРегламентированногоУчета = ВалютаУправленческогоУчета,
			1,
			РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаУправленческогоУчета,
				ВалютаРегламентированногоУчета,
				ДатаЗаполнения)
			);
	СебестоимостьПР = 0;
	СебестоимостьВР = 0;
	//-- НЕ УТ
	
	Элементы.НадписьНетЦеныНаДату.Видимость = (Цена = 0);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоПараметрам(Параметры)
	
	Организация = Параметры.Организация;
	Договор = Параметры.Договор;
	ВидЦены = Параметры.ВидЦеныСебестоимости;
	ДатаЗаполнения = Параметры.ДатаЗаполненияСебестоимостиПоВидуЦены;
	СпособОпределенияСебестоимости = Параметры.СпособОпределенияСебестоимости;
	КоличествоУпаковок = Параметры.КоличествоУпаковок;
	Упаковка = Параметры.Упаковка;
	ТипНалогообложения = Параметры.ТипНалогообложения;
	ДокументПередачи = Параметры.ДокументПередачи;
	Номенклатура = Параметры.Номенклатура;
	Характеристика = Параметры.Характеристика;
	СтавкаНДС = Параметры.СтавкаНДС;
	ВалютаДокумента = Параметры.ВалютаДокумента;
	СебестоимостьУпр = Параметры.Себестоимость;
	СебестоимостьУпрБезНДС = Параметры.СебестоимостьБезНДС;
	
	//++ НЕ УТ
	СебестоимостьРегл = Параметры.СебестоимостьРегл;
	СебестоимостьПР = Параметры.СебестоимостьПР;
	СебестоимостьВР = Параметры.СебестоимостьВР;
	//-- НЕ УТ
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"ГруппаВидЦен",
		"Видимость",
		ИспользоватьНесколькоВидовЦен);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"УпрБезНДС",
		"Видимость",
		ТипНалогообложения = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС);
	//++ НЕ УТ
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"ГруппаПРВР",
		"Видимость",
		УчетнаяПолитика.ПоддержкаПБУ18(Параметры.Организация, Параметры.Дата));
	//-- НЕ УТ
	Если ТипНалогообложения = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС Тогда
		ТекстЗаголовкаУпр = НСтр("ru = 'Упр. учет с НДС (%1):';
								|en = 'Man. accounting VAT included (%1):'");
		ТекстЗаголовкаУпрБезНДС = НСтр("ru = 'Упр. учет без НДС (%1):';
										|en = 'Management accounting VAT exempt (%1):'");
		Элементы.НадписьУпрБезНДС.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаУпрБезНДС, ВалютаУправленческогоУчета);
	Иначе
		ТекстЗаголовкаУпр = НСтр("ru = 'Упр. учет (%1):';
								|en = 'Man. accounting (%1):'");
	КонецЕсли;
	Элементы.НадписьУпр.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаУпр, ВалютаУправленческогоУчета);
	
	//++ НЕ УТ
	ТекстЗаголовкаРегл = НСтр("ru = 'Регл. учет %1(%2):';
								|en = 'Compl. accounting %1(%2):'");
	Элементы.НадписьРегл.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстЗаголовкаРегл,
		?(ТипНалогообложения = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС, НСтр("ru = 'без НДС';
																								|en = 'VAT exempt'") + " ", ""),
		ВалютаРегламентированногоУчета);	
	//-- НЕ УТ		
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Перенести изменения в документ?';
				|en = 'The data was modified. Migrate the changes to the document?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Если ПроверитьЗаполнение() Тогда
			ВыполняетсяЗакрытие = Истина;
			ПеренестиДанныеВДокумент();
		КонецЕсли;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиДанныеВДокумент()

	Модифицированность = Ложь;
	
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("СпособОпределенияСебестоимости", СпособОпределенияСебестоимости);
		ПараметрыЗакрытия.Вставить("ДокументПередачи", ДокументПередачи);
		Если СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.Вручную") Тогда
			ПараметрыЗакрытия.Вставить("ВидЦеныСебестоимости", ВидЦены);
			ПараметрыЗакрытия.Вставить("ДатаЗаполненияСебестоимостиПоВидуЦены", ДатаЗаполнения);
			ПараметрыЗакрытия.Вставить("Себестоимость", СебестоимостьУпр);
			ПараметрыЗакрытия.Вставить("СебестоимостьБезНДС", СебестоимостьУпрБезНДС);
			ПараметрыЗакрытия.Вставить("СебестоимостьРегл", СебестоимостьРегл);
			ПараметрыЗакрытия.Вставить("СебестоимостьПР", СебестоимостьПР);
			ПараметрыЗакрытия.Вставить("СебестоимостьВР", СебестоимостьВР);
		Иначе
			ПараметрыЗакрытия.Вставить("ВидЦеныСебестоимости", Неопределено);
			ПараметрыЗакрытия.Вставить("ДатаЗаполненияСебестоимостиПоВидуЦены", Дата(1, 1, 1));
			ПараметрыЗакрытия.Вставить("Себестоимость", 0);
			ПараметрыЗакрытия.Вставить("СебестоимостьБезНДС", 0);
			ПараметрыЗакрытия.Вставить("СебестоимостьРегл", 0);
			ПараметрыЗакрытия.Вставить("СебестоимостьПР", 0);
			ПараметрыЗакрытия.Вставить("СебестоимостьВР", 0);
		КонецЕсли;
		Закрыть(ПараметрыЗакрытия);
						
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти



