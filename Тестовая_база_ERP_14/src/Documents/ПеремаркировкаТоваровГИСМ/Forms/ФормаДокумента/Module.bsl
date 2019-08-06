#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.Подразделение.Видимость = ИнтеграцияГИСМ.ИспользоватьПодразделения();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьСтатусГИСМ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПеремаркировкаТоваровГИСМ");
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияГИСМ"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусГИСМФормахВДокументах)) Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ПеремаркировкаТоваровГИСМ.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияПоврежден(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Поврежден"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияУничтожен(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Уничтожен"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияУтерян(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Утерян"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ПеремаркировкаТоваровГИСМ.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ПеремаркировкаТоваровГИСМ.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Перемаркировка товаров ГИСМ не проведена. Провести?';
							|en = 'SPMS goods remarking is not posted. Post?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Перемаркировка товаров ГИСМ была изменена. Провести?';
							|en = 'SPMS goods marking was changed. Post?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать();
	КонецЕсли;
	
	Если Не Модифицированность И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеСписаниеКиЗ" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеМаркировкаТоваров" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеПеремаркировкаТоваров" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМВидПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМРазмерПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСпособВыпускаВОборотПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСИндивидуализациейПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормГИСМКлиентПереопределяемый.ХарактеристикаСоздание(ЭтотОбъект, Элементы.Товары.ТекущиеДанные, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СписокВыбораGTIN = Новый Массив;
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.МассивGTINМаркированногоТовара(
		ТекущаяСтрока.Номенклатура, ТекущаяСтрока.Характеристика, СписокВыбораGTIN);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораGTIN);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураКиЗНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	GTIN = ?(Объект.КиЗГИСМСИндивидуализацией, ТекущаяСтрока.GTIN, "");
	СписокВыбораКиЗ = Новый Массив;
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.ОтобратьНоменклатуруПоНомеруGTIN(
		СписокНоменклатураКиЗ, GTIN, СписокВыбораКиЗ);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораКиЗ);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаКиЗСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормГИСМКлиентПереопределяемый.ХарактеристикаСоздание(ЭтотОбъект, Элементы.Товары.ТекущиеДанные, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ТекущаяСтрока.Количество = 1;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПричинуСписания(ПричинаСписания)

	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Товары.ДанныеСтроки(ВыделеннаяСтрока);
		ДанныеСтроки.ПричинаСписания = ПричинаСписания;
	КонецЦикла

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ОбновитьСтатусГИСМ();
	
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьСпискиВыбораРеквизитовШапкиПеремаркировкаТоваров(ЭтаФорма);
	МаркировкаТоваровГИСМПереопределяемый.ПолучитьКиЗДляЗаполнения(Объект,СписокНоменклатураКиЗ);
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьGTINВСтроке(ТекущаяСтрока);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьGTINВСтроке(ТекущаяСтрока);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура КатегорияКиЗПриИзменении()
	МаркировкаТоваровГИСМПереопределяемый.КатегорияКиЗПриИзменении(Объект, СписокНоменклатураКиЗ, Ложь);
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

#КонецОбласти

&НаСервере
Процедура ОбновитьСтатусГИСМ()
	
	МаркировкаТоваровГИСМ.ОбновитьСтатусГИСМ(ЭтаФорма, "ПеремаркировкаТоваровГИСМ");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

#КонецОбласти