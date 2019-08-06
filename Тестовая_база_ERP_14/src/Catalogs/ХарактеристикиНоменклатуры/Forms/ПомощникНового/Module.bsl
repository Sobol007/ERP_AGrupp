#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		
		ИсточникКопирования = Параметры.ЗначениеКопирования;
		ЗаполнитьЗначенияСвойств(Объект, ИсточникКопирования,,"ДополнительныеРеквизиты, ПометкаУдаления");
		
		Объект.ДополнительныеРеквизиты.Загрузить(ИсточникКопирования.ДополнительныеРеквизиты.Выгрузить());
		
	Иначе
		
		РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ВидНоменклатуры,"ИспользованиеХарактеристик,ВладелецХарактеристик");
		
		Если РеквизитыВладельца.ИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры Тогда
			Объект.Владелец = Параметры.ВидНоменклатуры;
		ИначеЕсли РеквизитыВладельца.ИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры Тогда
			Объект.Владелец = РеквизитыВладельца.ВладелецХарактеристик;
		Иначе
			Объект.Владелец = Параметры.Владелец;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ВидНоменклатуры");
		Элементы.Владелец.Заголовок = НСтр("ru = 'Номенклатура';
											|en = 'Products and services'");
		Номенклатура = Объект.Владелец;
		
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		
		ВидНоменклатуры = Объект.Владелец;
		Элементы.Владелец.Заголовок = НСтр("ru = 'Вид номенклатуры';
											|en = 'Product kind'");
		
	КонецЕсли;
	
	// Наборы
	РеквизитыВида = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ВидНоменклатуры,
		"ШаблонНаименованияДляПечатиХарактеристики, ШаблонРабочегоНаименованияХарактеристики,ТипНоменклатуры,
		|ЗапретРедактированияНаименованияДляПечатиХарактеристики, ЗапретРедактированияРабочегоНаименованияХарактеристики");
	
	ЭтоНабор = (РеквизитыВида.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Набор);
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда
		Номенклатура = Параметры.Номенклатура;
	КонецЕсли;
	
	ВариантРасчетаЦеныНабора =
		Справочники.ВариантыКомплектацииНоменклатуры.ПустаяСсылка().Метаданные().Реквизиты.ВариантРасчетаЦеныНабора.ЗначениеЗаполнения;
	ВариантПредставленияНабораВПечатныхФормах =
		Справочники.ВариантыКомплектацииНоменклатуры.ПустаяСсылка().Метаданные().Реквизиты.ВариантПредставленияНабораВПечатныхФормах.ЗначениеЗаполнения;
	НастроитьЭлементыФормыНабора();
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПолучитьНаборУникальныхИОбязательныхРеквизитов();
	
	Если ЗначениеЗаполнено(Параметры.АдресТаблицы) Тогда
		ЗаполнитьПараметрыХарактеристик(Параметры);
	КонецЕсли;
	
	Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОсновная;
	Элементы.СтраницыПодвал.ТекущаяСтраница    = Элементы.СтраницаКнопкиДалееЗакрыть;
	
	
	ШаблонРабочегоНаименования  = РеквизитыВида.ШаблонРабочегоНаименованияХарактеристики;
	ШаблонНаименованияДляПечати = РеквизитыВида.ШаблонНаименованияДляПечатиХарактеристики;
	
	ЗапретРедактированияНаименованияДляПечати = РеквизитыВида.ЗапретРедактированияНаименованияДляПечатиХарактеристики;
	ЗапретРедактированияРабочегоНаименования  = РеквизитыВида.ЗапретРедактированияРабочегоНаименованияХарактеристики;
	
	Элементы.НаименованиеПолное.ТолькоПросмотр      = ЗапретРедактированияНаименованияДляПечати;
	Элементы.Наименование.ТолькоПросмотр            = ЗапретРедактированияРабочегоНаименования;
	Элементы.Наименование.АвтоОтметкаНезаполненного = Не ЗапретРедактированияРабочегоНаименования;
	
	Элементы.ЗаполнитьРабочееНаименованиеПоШаблону.Доступность   = ЗначениеЗаполнено(ШаблонРабочегоНаименования);
	Элементы.ЗаполнитьНаименованиеДляПечатиПоШаблону.Доступность = ЗначениеЗаполнено(ШаблонНаименованияДляПечати);
	
	Если ЗначениеЗаполнено(ШаблонРабочегоНаименования) Тогда
		Объект.Наименование = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонНаименованияДляПечати) Тогда
		Объект.НаименованиеПолное = "";
	КонецЕсли;
	
	ЗапрашиваемыеРеквизиты  = Новый Структура;
	ЗапрашиваемыеРеквизиты.Вставить("ТипНоменклатуры");
	ЗапрашиваемыеРеквизиты.Вставить("ОсобенностьУчета");
	
	РеквизитыВладельца = Новый ФиксированнаяСтруктура(ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец,
																								ЗапрашиваемыеРеквизиты));
	
	НастройкиВидимостиПоТипу = ЗначениеНастроекПовтИсп.ВсеРеквизитыХарактеристикНоменклатуры(РеквизитыВладельца.ТипНоменклатуры,
																							РеквизитыВладельца.ОсобенностьУчета);
	
	Для Каждого НастройкаРеквизита Из НастройкиВидимостиПоТипу Цикл
		Элементы[НастройкаРеквизита.Ключ].Видимость = НастройкаРеквизита.Значение.Использование;
	КонецЦикла;
	
	Если РеквизитыВладельца.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПоАгентскойСхеме Тогда
		ТипСсылкаОрганизации = Новый ОписаниеТипов("СправочникСсылка.Организации");
		
		Элементы.Принципал.ОграничениеТипа = ТипСсылкаОрганизации;
	КонецЕсли;
	
	Если РеквизитыВладельца.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Партнером Тогда
		ТипСсылкаКонтрагенты = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		ТипСсылкаПартнеры    = Новый ОписаниеТипов("СправочникСсылка.Партнеры");
		
		Элементы.Принципал.ОграничениеТипа  = ТипСсылкаПартнеры;
		Элементы.Контрагент.ОграничениеТипа = ТипСсылкаКонтрагенты;
	КонецЕсли;
	
	ЗадаватьВопросОЗакрытии = Истина;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗадаватьВопросОЗакрытии И Модифицированность Тогда
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.';
										|en = 'Data was changed. All changes will be lost.'");
			Возврат;
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru = 'Закрыть форму помощника? Введенные данные будут потеряны.';
							|en = 'Close the wizard form? The data entered will be lost.'");
		СписокКнопок = Новый СписокЗначений;
		
		СписокКнопок.Добавить(КодВозвратаДиалога.Да,НСтр("ru = 'Закрыть';
														|en = 'Close'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет,НСтр("ru = 'Не закрывать';
															|en = 'Keep open'"));
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), ТекстВопроса, СписокКнопок);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		ЗадаватьВопросОЗакрытии = Истина;
		Возврат;
	КонецЕсли;
	
	ЗадаватьВопросОЗакрытии = Ложь;
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаданияЦеныПриИзменении(Элемент)
	
	Элементы.ГруппаЦенаНабораПраво.ТолькоПросмотр = (ВариантЗаданияЦены = 0);
	
	Если ВариантЗаданияЦены = 0 Тогда
		ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих");
	Иначе
		Если ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам" Тогда
			ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам");
		ИначеЕсли ВариантРаспределенияЦены = "РаспределяетсяПропорциональноДолям" Тогда
			ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям");
		КонецЕсли;
	КонецЕсли;
	
	НаборыКлиент.ИзменитьВидимостьПредупрежденияОбОграниченииНастроек(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПредставленияНабораВПечатныхФормахПриИзменении(Элемент)
	
	НаборыКлиент.ИзменитьВидимостьПредупрежденияОбОграниченииНастроек(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаспределенияЦеныПриИзменении(Элемент)
	
	Если ВариантЗаданияЦены = 0 Тогда
		ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих");
	Иначе
		Если ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам" Тогда
			ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам");
		ИначеЕсли ВариантРаспределенияЦены = "РаспределяетсяПропорциональноДолям" Тогда
			ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям");
		КонецЕсли;
	КонецЕсли;
	
	Если ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям")
		И ВариантЗаданияЦены = 1 Тогда
		Элементы.ТоварыДоляСтоимости.АвтоОтметкаНезаполненного = Истина;
		Элементы.ТоварыДоляСтоимости.Видимость = Истина;
	Иначе
		Элементы.ТоварыДоляСтоимости.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ТоварыДоляСтоимости.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКомпонентаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(Неопределено, НоменклатураОсновногоКомпонента);
КонецПроцедуры

&НаКлиенте
Процедура ПринципалПриИзменении(Элемент)
	ПринципалПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПринципалПриИзмененииНаСервере()
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Принципал, Объект.Контрагент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиФормыТовары

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные; 
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока,СтруктураДействий,КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	Действия = Новый Структура("
		|ПроверитьХарактеристикуПоВладельцу,
		|ПроверитьЗаполнитьУпаковкуПоВладельцу, ПересчитатьКоличествоЕдиниц");
	Действия.ПроверитьХарактеристикуПоВладельцу = ТекущаяСтрока.Характеристика;
	Действия.ПроверитьЗаполнитьУпаковкуПоВладельцу = ТекущаяСтрока.Упаковка;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, Действия, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	Компонент = Элемент.ТекущиеДанные;
	Если Компонент <> Неопределено Тогда
		ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	Если Товары.Количество() = 1 Тогда
		Компонент = Товары[0];
		Если Компонент <> Неопределено Тогда
			ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
		КонецЕсли;
	КонецЕсли;
	
	Если Товары.Количество() = 0 Тогда
		ЗаполнитьОсновнойКомпонент(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	Если Товары.Количество() = 1 Тогда
		Компонент = Товары[0];
		Если Компонент <> Неопределено Тогда
			ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
		КонецЕсли;
	Иначе
		
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура", НоменклатураОсновногоКомпонента);
		Отбор.Вставить("Характеристика", ХарактеристикаОсновногоКомпонента);
		НайденныеСтроки = Товары.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() = 0 И Товары.Количество() > 0 Тогда
			
			Компонент = Товары[0];
			Если Компонент <> Неопределено Тогда
				ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные; 
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока,СтруктураДействий,КэшированныеЗначения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПереходПоСтраницам(Команда)
	
	Если Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОсновная Тогда
		
		ФормироватьРабочееНаименование = Ложь;
		ФормироватьНаименованиеДляПечати = Ложь;
		
		Если (Не ЗначениеЗаполнено(Объект.Наименование) И ЗначениеЗаполнено(ШаблонРабочегоНаименования))
			Или ЗапретРедактированияРабочегоНаименования Тогда
			
			ФормироватьРабочееНаименование = Истина;
			
		КонецЕсли;
		
		Если (Не ЗначениеЗаполнено(Объект.НаименованиеПолное) И ЗначениеЗаполнено(ШаблонНаименованияДляПечати))
			Или ЗапретРедактированияНаименованияДляПечати Тогда
			
			ФормироватьНаименованиеДляПечати = Истина;
			
		КонецЕсли;
		
		Если ФормироватьРабочееНаименование И ФормироватьНаименованиеДляПечати Тогда
			
			ЗаполнитьНаименованиеПоШаблонуКлиент("Оба");
			
		ИначеЕсли ФормироватьРабочееНаименование Тогда
			
			ЗаполнитьНаименованиеПоШаблонуКлиент("Рабочее");
			
		ИначеЕсли ФормироватьНаименованиеДляПечати Тогда
			
			ЗаполнитьНаименованиеПоШаблонуКлиент("ДляПечати");
			
		КонецЕсли;
		
		НоваяХарактеристика = НовыйЭлементСправочника();
		
		Если Не ЗначениеЗаполнено(НоваяХарактеристика) Тогда
			
			Если ТаблицаНайдено.Количество() > 0 Тогда
				
				Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаНайдено;
				Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.СтраницаКнопкиДалееНазадВыбрать;
				Элементы.ВыбратьСуществующую.КнопкаПоУмолчанию = Истина;
				
			Иначе
				
				Возврат;
				
			КонецЕсли;
			
		Иначе
			
			Оповестить("Запись_ХарактеристикиНоменклатуры",Новый Структура, НоваяХарактеристика);
			
			Если ЭтоНабор И ЗначениеЗаполнено(Номенклатура) Тогда
				
				Элементы.СтраницыПомощника.ТекущаяСтраница  = Элементы.СтраницаНаборы;
				Элементы.СтраницыПодвал.ТекущаяСтраница     = Элементы.СтраницаКнопкиДалееНаборы;
				Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = Истина;
				
			Иначе
				
				ЗадаватьВопросОЗакрытии = Ложь;
				Закрыть();
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаНайдено Тогда
		
		Если Команда.Имя = "Назад" Тогда
			
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОсновная;
			Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.СтраницаКнопкиДалееЗакрыть;
			Элементы.Далее1.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаименованиеДляПечатиПоШаблону(Команда)
	
	ЗаполнитьНаименованиеПоШаблонуКлиент("ДляПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРабочееНаименованиеПоШаблону(Команда)
	
	ЗаполнитьНаименованиеПоШаблонуКлиент("Рабочее");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСуществующую(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаНайдено.ТекущиеДанные;
	
	Если Не (ТекущиеДанные = Неопределено) Тогда
		
		ЗадаватьВопросОЗакрытии = Ложь;
		Оповестить("Запись_ХарактеристикиНоменклатуры", Новый Структура, ТекущиеДанные.ХарактеристикаНоменклатуры);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	ВыполнитьПереходПоСтраницам(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ВыполнитьПереходПоСтраницам(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	НаборыКлиент.ПроверитьЗаполнение(ЭтаФорма, Отказ);
	
	Если Не Отказ Тогда
		ВариантКомплектацииНоменклатуры = СоздатьВариантКомплектацииНоменклатуры();
		Если ЗначениеЗаполнено(ВариантКомплектацииНоменклатуры) Тогда
			
			ПараметрыЗаписи = Новый Структура;
			ПараметрыЗаписи.Вставить("ВладелецКомплекта", Объект.Владелец);
			
			ЗадаватьВопросОЗакрытии = Ложь;
			Оповестить("Запись_ВариантыКомплектацииНоменклатуры", ПараметрыЗаписи, ВариантКомплектацииНоменклатуры);
			Закрыть();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОсновнымКомпонентом(Команда)
	Компонент = Элементы.Товары.ТекущиеДанные;
	Если Компонент <> Неопределено Тогда
		ЗаполнитьОсновнойКомпонент(Компонент.Номенклатура, Компонент.Характеристика);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	УстановитьУсловноеОформлениеРедактированияНабора();

КонецПроцедуры

&НаСервере
Процедура ПолучитьНаборУникальныхИОбязательныхРеквизитов()
	
	ОписаниеТиповБулево = Новый ОписаниеТипов("Булево");
	
	Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда
		ТаблицаНастроекРеквизитов.Очистить();
	Иначе
		
		ЗапрашиваемыеРеквизиты = Новый Структура;
		ЗапрашиваемыеРеквизиты.Вставить("ТипНоменклатуры",  "ТипНоменклатуры");
		ЗапрашиваемыеРеквизиты.Вставить("ОсобенностьУчета", "ОсобенностьУчета");
		
		Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
			ЗапрашиваемыеРеквизиты.Вставить("ВидНоменклатуры", "ВидНоменклатуры");
		Иначе
			ЗапрашиваемыеРеквизиты.Вставить("ВидНоменклатуры", "Ссылка");
		КонецЕсли;
		
		РеквизитыВидаНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец,ЗапрашиваемыеРеквизиты);
		
		ТаблицаРеквизитов = Справочники.Номенклатура.ТаблицаНастроекРеквизитов(РеквизитыВидаНоменклатуры.ВидНоменклатуры,
																				РеквизитыВидаНоменклатуры.ТипНоменклатуры,
																				РеквизитыВидаНоменклатуры.ОсобенностьУчета,
																				Неопределено,
																				Неопределено,
																				"ХарактеристикиНоменклатуры");
		
		ТаблицаНастроекРеквизитов.Загрузить(ТаблицаРеквизитов);
		
	КонецЕсли;
	
	Справочники.Номенклатура.НастроитьФормуПоТаблицеНастроек(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыХарактеристик(СтруктураПараметров)
	
	АдресТаблицы = Параметры.АдресТаблицы;
	
	ТаблицаДопРеквизитов = Новый ТаблицаЗначений;
	ТаблицаДопРеквизитов.Колонки.Добавить("ИмяРеквизита", Новый ОписаниеТипов("Строка",,,Новый КвалификаторыСтроки(255)));
	
	Если ЗначениеЗаполнено(АдресТаблицы) Тогда
		
		ТаблицаЗначенийРеквизитов = ПолучитьИзВременногоХранилища(АдресТаблицы);
		
		Для Каждого СтрокаТаблицы Из ТаблицаЗначенийРеквизитов Цикл
			
			НоваяСтрока = ТаблицаДопРеквизитов.Добавить();
			НоваяСтрока.ИмяРеквизита = СтрокаТаблицы.ИмяРеквизита;
			
		КонецЦикла;
		
		НаборСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "НаборСвойствХарактеристик");
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДопРеквизитов.ИмяРеквизита
		|ПОМЕСТИТЬ ТаблицаИменСвойств
		|ИЗ
		|	&ТаблицаДопРеквизитов КАК ТаблицаДопРеквизитов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаИменСвойств.ИмяРеквизита         КАК ИмяРеквизита,
		|	НаборыДополнительныхРеквизитов.Свойство КАК Свойство
		|ИЗ
		|	ТаблицаИменСвойств КАК ТаблицаИменСвойств
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК НаборыДополнительныхРеквизитов
		|		ПО ТаблицаИменСвойств.ИмяРеквизита = НаборыДополнительныхРеквизитов.Свойство.Наименование
		|ГДЕ
		|	НаборыДополнительныхРеквизитов.Ссылка = &НаборРеквизитов";
		
		Запрос.УстановитьПараметр("ТаблицаДопРеквизитов", ТаблицаДопРеквизитов);
		Запрос.УстановитьПараметр("НаборРеквизитов", НаборСвойств);
		
		ТаблицаСвойств = Запрос.Выполнить().Выгрузить();
		СтруктураПоиска = Новый Структура("ИмяРеквизита");
		
		Для Каждого СтрокаТаблицы Из ТаблицаСвойств Цикл
			
			СтруктураПоискаЗначения = Новый Структура("Свойство", СтрокаТаблицы.Свойство);
			МассивСтрок     = ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(СтруктураПоискаЗначения);
			СтрокаРеквизита = МассивСтрок[0];
			ПутьКДанным     = СтрокаРеквизита.ИмяРеквизитаЗначение;
			СтруктураПоиска.ИмяРеквизита = СтрокаТаблицы.ИмяРеквизита;
			МассивСтрокЗначение   = ТаблицаЗначенийРеквизитов.НайтиСтроки(СтруктураПоиска);
			ЗначениеРеквизита     = МассивСтрокЗначение[0].ЗначениеОтбора;
			
			ЭтаФорма[ПутьКДанным] = ЗначениеРеквизита;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаименованиеПоШаблонуКлиент(ВариантФормирования)
	
	#Если ВебКлиент Тогда
		ЗаполнитьНаименованиеПоШаблонуСервер(ВариантФормирования);
		Возврат;
	#КонецЕсли
	
	ФормулыНаименования = ФормулыНаименования();
	
	Если ВариантФормирования = "Рабочее" Тогда
		
		Объект.Наименование = НоменклатураКлиент.НаименованиеПоФормуле(
			ФормулыНаименования.ФормулаРабочегоНаименования,
			ВидНоменклатуры);
		
	ИначеЕсли ВариантФормирования = "ДляПечати" Тогда 
		
		Объект.НаименованиеПолное = НоменклатураКлиент.НаименованиеПоФормуле(
			ФормулыНаименования.ФормулаНаименованияДляПечати,
			ВидНоменклатуры,
			Объект.Наименование);
		
	ИначеЕсли ВариантФормирования = "Оба" Тогда
		
		Объект.Наименование = НоменклатураКлиент.НаименованиеПоФормуле(
			ФормулыНаименования.ФормулаРабочегоНаименования,
			ВидНоменклатуры);
		
		Объект.НаименованиеПолное = НоменклатураКлиент.НаименованиеПоФормуле(
			ФормулыНаименования.ФормулаНаименованияДляПечати,
			ВидНоменклатуры,
			Объект.Наименование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаименованиеПоШаблонуСервер(ВариантФормирования)
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, Объект);
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	
	Если ВариантФормирования = "Рабочее" ИЛИ ВариантФормирования = "Оба" Тогда
		Объект.Наименование = НоменклатураСервер.НаименованиеПоШаблону(ШаблонРабочегоНаименования, СправочникОбъект);
		СправочникОбъект.Наименование = Объект.Наименование;
	КонецЕсли;
	Если ВариантФормирования = "ДляПечати" ИЛИ ВариантФормирования = "Оба" Тогда
		Объект.НаименованиеПолное = НоменклатураСервер.НаименованиеПоШаблону(ШаблонНаименованияДляПечати, СправочникОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ФормулыНаименования()
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, Объект);
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	
	Результат = Новый Структура;
	Результат.Вставить("ФормулаРабочегоНаименования", НоменклатураСервер.ФормулаНаименования(ШаблонРабочегоНаименования, СправочникОбъект)); 
	Результат.Вставить("ФормулаНаименованияДляПечати", НоменклатураСервер.ФормулаНаименования(ШаблонНаименованияДляПечати, СправочникОбъект)); 
	
	Возврат Результат; 
	
КонецФункции

&НаСервере
Функция ОбязательныеРеквизитыЗаполнены()
	
	Отказ = Ложь;
	ТекстОшибки = НСтр("ru = 'Заполните поле ""%ИмяРеквизита%""';
						|en = 'Fill in the ""%ИмяРеквизита%"" field '");
	
	Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда
		
		ТекстСообщения = СтрЗаменить(ТекстОшибки, "%ИмяРеквизита%", НСтр("ru = 'Вид номенклатуры';
																		|en = 'Product kind'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Владелец");
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
		
		ТекстСообщения = СтрЗаменить(ТекстОшибки, "%ИмяРеквизита%", НСтр("ru = 'Рабочее наименование';
																		|en = 'Work name'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Наименование");
		Отказ = Истина;
		
	КонецЕсли;
	
	Для Каждого Строка Из ТаблицаНастроекРеквизитов Цикл
		
		Если Не Строка.ОбязателенДляЗаполнения Тогда
			Продолжить;
		КонецЕсли;
		
		Если Строка.ЭтоДопРеквизит Тогда
			ЗначениеРеквизита = ЭтаФорма[Строка.ПутьКДанным];
			ПутьКРеквизиту = Строка.ПутьКДанным;
		Иначе
			ЗначениеРеквизита = Объект[Строка.ИмяРеквизита];
			ПутьКРеквизиту    = "Объект." + Строка.ИмяРеквизита;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
			
			ТекстСообщения = СтрЗаменить(ТекстОшибки, "%ИмяРеквизита%", Строка.Представление);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , ПутьКРеквизиту);
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
			
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, Новый Массив);
	// Конец СтандартныеПодсистемы.Свойства
	
	Возврат Отказ;

КонецФункции

&НаСервере
Функция НовыйЭлементСправочника()
	
	Отказ = ОбязательныеРеквизитыЗаполнены();
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Справочники.Номенклатура.ПроверитьУникальностьЭлементаПоРеквизитам(ЭтотОбъект);
	
	Если ТаблицаНайдено.Количество() = 0 Тогда
		
		ОбъектЗаписан = Истина;
		НачатьТранзакцию();
		
		Попытка
			
			УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, Объект);
			
			СправочникОбъект = РеквизитФормыВЗначение("Объект");
			
			Если Константы.КонтролироватьУникальностьРабочегоНаименованияНоменклатурыИХарактеристик.Получить() Тогда
				Если Не Справочники.ХарактеристикиНоменклатуры.РабочееНаименованиеУникально(СправочникОбъект) Тогда
					
					ОтменитьТранзакцию();
					
					ТекстСообщения = НСтр("ru = 'Значение поля ""Рабочее наименование"" не уникально';
											|en = 'Value of field ""Work name"" is not unique'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Наименование", "Объект");
					
					Возврат Неопределено;
					
				КонецЕсли;
			КонецЕсли;
			
			СправочникОбъект.ДополнительныеСвойства.Вставить("РабочееНаименованиеСформировано");
			СправочникОбъект.ДополнительныеСвойства.Вставить("НаименованиеДляПечатиСформировано");
			
			СправочникОбъект.Записать();
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбъектЗаписан = Ложь;
			
			ТекстСообщения = НСтр("ru = 'Не удалось создать новую характеристику номенклатуры';
									|en = 'Cannot create new characteristic of products'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Наименование", "Объект");
			
			КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(); // Для записи события в журнал регистрации.
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание новой характеристики номенклатуры.';
											|en = 'Create new product characteristics.'", КодОсновногоЯзыка),
				УровеньЖурналаРегистрации.Ошибка, , ,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
		Если ОбъектЗаписан Тогда
			Возврат СправочникОбъект.Ссылка;
		Иначе
			Возврат Неопределено;
		КонецЕсли;

	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

#Область Наборы

&НаКлиенте
Процедура ЗаполнитьОсновнойКомпонент(НоменклатураКомпонента, ХарактеристикаКомпонента)
	
	НоменклатураОсновногоКомпонента = НоменклатураКомпонента;
	ХарактеристикаОсновногоКомпонента = ХарактеристикаКомпонента;
	
	ПредставлениеОсновногоКомпонента = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
		НоменклатураОсновногоКомпонента,
		ХарактеристикаОсновногоКомпонента);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыНабора()
	
	Если ИсточникКопирования = Неопределено ИЛИ Не ЗначениеЗаполнено(Номенклатура) Тогда
	
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВидыНоменклатуры.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
		|	ВидыНоменклатуры.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора
		|ИЗ
		|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
		|ГДЕ
		|	ВидыНоменклатуры.Ссылка = &ВидНоменклатуры");
		
		Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
		КонецЕсли;
	
	Иначе
		
		Если ЭтоНабор Тогда
			ПараметрыВариантаКомплектацииНоменклатуры = НаборыВызовСервера.ПараметрыВариантаКомплектацииНоменклатуры(Номенклатура, ИсточникКопирования);
			Если ЗначениеЗаполнено(ПараметрыВариантаКомплектацииНоменклатуры) Тогда 
				ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыВариантаКомплектацииНоменклатуры);
				ПредставлениеОсновногоКомпонента = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
					ПараметрыВариантаКомплектацииНоменклатуры.НоменклатураОсновногоКомпонента,
					ПараметрыВариантаКомплектацииНоменклатуры.ХарактеристикаОсновногоКомпонента);
				Товары.Загрузить(ПараметрыВариантаКомплектацииНоменклатуры.Комплектующие);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам";
	
	Если ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих
		ИЛИ НЕ ЗначениеЗаполнено(ВариантРасчетаЦеныНабора) Тогда
		
		ВариантЗаданияЦены = 0;
		
	Иначе
		
		ВариантЗаданияЦены = 1;
		
		Если ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям Тогда
			
			ВариантРаспределенияЦены = "РаспределяетсяПропорциональноДолям";
			
		Иначе
			
			ВариантРаспределенияЦены = "РаспределяетсяПропорциональноЦенам";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ГруппаЦенаНабораПраво.ТолькоПросмотр = (ВариантЗаданияЦены = 0);
	
	Если ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
		И ВариантЗаданияЦены = 1 Тогда
		Элементы.ТоварыДоляСтоимости.АвтоОтметкаНезаполненного = Истина;
		Элементы.ТоварыДоляСтоимости.Видимость = Истина;
	Иначе
		Элементы.ТоварыДоляСтоимости.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ТоварыДоляСтоимости.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьВариантКомплектацииНоменклатуры()
	
	ВариантКомплектацииОбъект = Справочники.ВариантыКомплектацииНоменклатуры.СоздатьЭлемент();
	ВариантКомплектацииОбъект.Владелец                                  = Номенклатура;
	ВариантКомплектацииОбъект.Характеристика                            = НоваяХарактеристика;
	
	ВариантКомплектацииОбъект.ВариантПредставленияНабораВПечатныхФормах = ВариантПредставленияНабораВПечатныхФормах;
	ВариантКомплектацииОбъект.ВариантРасчетаЦеныНабора                  = ВариантРасчетаЦеныНабора;
	
	ВариантКомплектацииОбъект.НоменклатураОсновногоКомпонента   = НоменклатураОсновногоКомпонента;
	ВариантКомплектацииОбъект.ХарактеристикаОсновногоКомпонента = ХарактеристикаОсновногоКомпонента;
	ВариантКомплектацииОбъект.КоличествоУпаковок = 1;
	ВариантКомплектацииОбъект.Количество         = 1;
	ВариантКомплектацииОбъект.Основной           = Истина;
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		ЗаполнитьЗначенияСвойств(ВариантКомплектацииОбъект.Товары.Добавить(), СтрокаТЧ);
	КонецЦикла;
	
	ВариантКомплектацииОбъект.Записать();
	
	Возврат ВариантКомплектацииОбъект.Ссылка;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеРедактированияНабора()

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, , 
																		     "Товары.ХарактеристикиИспользуются");

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма,, 
                                                                   "Товары.Упаковка");

КонецПроцедуры

#КонецОбласти

#КонецОбласти
