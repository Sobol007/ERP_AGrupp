#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ДоступенПросмотрБухучетЗарплатыТерриторийВыполненияРабот = ОтражениеЗарплатыВБухучетеРасширенный.ДоступноЧтениеБухучетаЗарплатыТерриторийВыполненияРабот();
		
		СсылкаНаОбъект = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка).ПолучитьСсылку();
		
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(ЭтаФорма, "БухучетЗарплатыТерриторийВыполненияРабот", СсылкаНаОбъект);
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(ЭтаФорма, "ТерриториальныеУсловияПФР", СсылкаНаОбъект);
		УстановитьПараметрыФункциональныхОпций(Объект.Владелец);
		ЗаполнитьРеквизитыПоВладельцу();
		
	КонецЕсли;
	
	Если ДоступенПросмотрБухучетЗарплатыТерриторийВыполненияРабот Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокой",
			"ТолькоПросмотр",
			Не ОтражениеЗарплатыВБухучетеРасширенный.ДоступноИзменениеБухучетаЗарплатыТерриторийВыполненияРабот());
		
	КонецЕсли; 
	
	ИспользоватьРасчетЗарплатыРасширенная = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаРегистрацияВНалоговомОргане",
		"Видимость",
		ИспользоватьРасчетЗарплатыРасширенная);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "ОтредактированаИстория" И СсылкаНаОбъект = Источник И Параметр.ИмяРегистра <> "ИсторияРегистрацийВНалоговомОргане" Тогда
		
		Если ЭтаФорма[Параметр.ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
			
			Если Параметр.ИмяРегистра = "БухучетЗарплатыТерриторийВыполненияРабот" Или Параметр.ИмяРегистра = "ТерриториальныеУсловияПФР" Тогда
				ВедущийОбъект = СсылкаНаОбъект;
			КонецЕсли;
			РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, ВедущийОбъект, ИмяСобытия, Параметр, Источник);
			Если Параметр.ИмяРегистра = "БухучетЗарплатыТерриторийВыполненияРабот" Тогда
				ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, Объект, ЭтаФорма.Элементы, БухучетЗарплатыТерриторийВыполненияРабот, БухучетЗарплатыТерриторийВыполненияРаботПрежняя, ОбщегоНазначенияКлиент.ДатаСеанса());
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзмененаРегистрацияВНалоговомОргане" И Источник = ЭтаФорма Тогда
		
		Объект.РегистрацияВНалоговомОргане = Параметр.Ссылка;
		УстановитьПредставлениеРегистрацииВНалоговомОргане(ЭтаФорма);
		РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, СсылкаНаОбъект, ИмяСобытия, Параметр, Источник);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	СсылкаНаОбъект = Объект.Ссылка;
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда 
		Отказ = Истина;
		ЗаписатьНаКлиенте(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Параметры.Ключ.Пустая() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНаОбъект);
	КонецЕсли;
	
	ЗаписатьТерриториальныеУсловияПФР(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ОтражениеЗарплатыВБухучетеРасширенный.ДоступноИзменениеБухучетаЗарплатыТерриторийВыполненияРабот() Тогда
		РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтаФорма, "БухучетЗарплатыТерриторийВыполненияРабот", ТекущийОбъект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Параметры.Ключ.Пустая() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНаОбъект);
	КонецЕсли;
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(ЭтаФорма, "ТерриториальныеУсловияПФР", СсылкаНаОбъект, Отказ);
	
	Если ОтражениеЗарплатыВБухучетеРасширенный.ДоступноИзменениеБухучетаЗарплатыТерриторийВыполненияРабот() Тогда
		РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(ЭтаФорма, "БухучетЗарплатыТерриторийВыполненияРабот", СсылкаНаОбъект, Отказ);
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ВладелецПриИзмененииНаСервере();
	
	Если ЗначениеЗаполнено(Объект.Владелец) И Не ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленныеТерритории") Тогда
		
		ТекстПредупреждения = НСтр("ru = 'В организации %1 не используются обособленные территории';
									|en = 'Separate territories are not used in the %1 company'");
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, Объект.Владелец);
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РайонныйКоэффициентРФПриИзменении(Элемент)
	
	ПриИзмененииРайонногоКоэффициента();
	
КонецПроцедуры

&НаКлиенте
Процедура РайонныйКоэффициентПриИзменении(Элемент)
	
	ПриИзмененииРайонногоКоэффициента();
	
КонецПроцедуры

&НаКлиенте
Процедура ТерриториальныеУсловияПФРТерриториальныеУсловияПФРПриИзменении(Элемент)
	
	ПриИзмененииТерриториальныеУсловияПФР();
	
КонецПроцедуры

&НаКлиенте
Процедура ТерриториальныеУсловияПФРПериодПриИзменении(Элемент)
	
	ПриИзмененииТерриториальныеУсловияПФР();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяФинансированияПриИзменении(Элемент)
	
	ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, Объект, ЭтаФорма.Элементы, БухучетЗарплатыТерриторийВыполненияРабот, БухучетЗарплатыТерриторийВыполненияРаботПрежняя, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОтраженияЗарплатыВБухучетеПриИзменении(Элемент)
	
	ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, Объект, ЭтаФорма.Элементы, БухучетЗарплатыТерриторийВыполненияРабот, БухучетЗарплатыТерриторийВыполненияРаботПрежняя, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтношениеКЕНВДПриИзменении(Элемент)
	
	ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, Объект, ЭтаФорма.Элементы, БухучетЗарплатыТерриторийВыполненияРабот, БухучетЗарплатыТерриторийВыполненияРаботПрежняя, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "БухучетЗарплатыТерриторийВыполненияРабот.Период", "БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма,
		ЭтаФорма,
		"БухучетЗарплатыТерриторийВыполненияРабот.Период",
		"БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "БухучетЗарплатыТерриторийВыполненияРабот.Период", "БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьНаКлиенте(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРегистрациюВНалоговомОргане(Команда)
	
	ДополнительныеПараметры = Новый Структура("ЗаписатьТерриторию", Истина);
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru = 'Территория еще не записана.
			|Записать и продолжить?';
			|en = 'Area is not written yet.
			|Write and continue?'");
		
		Оповещение = Новый ОписаниеОповещения("ИзменитьРегистрациюВНалоговомОрганеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Отмена);
		
	Иначе 
		
		ДополнительныеПараметры.ЗаписатьТерриторию = Ложь;
		ИзменитьРегистрациюВНалоговомОрганеЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТерриториальныеУсловияПФРИстория(Команда)
	
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию("ТерриториальныеУсловияПФР", СсылкаНаОбъект, ЭтаФорма, ТолькоПросмотр);
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("БухучетЗарплатыТерриторийВыполненияРабот", СсылкаНаОбъект, ЭтаФорма);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиентеЗавершение(ЗакрытьПослеЗаписи, ДополнительныеПараметры) Экспорт 

	ПараметрыЗаписи = Новый Структура("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Записать(ПараметрыЗаписи) И ДополнительныеПараметры.ЗакрытьПослеЗаписи Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ОповещениеЗавершения = Неопределено) 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если ДоступенПросмотрБухучетЗарплатыТерриторийВыполненияРабот Тогда
	
		ДатаИзменения = БухучетЗарплатыТерриторийВыполненияРабот.Период;
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При редактировании Вы изменили бухгалтерский учет для территории выполнения работ. 
						|Если Вы просто исправили прежние данные (они были ошибочны), нажмите ""Исправлена ошибка"".
						|Если бухучет территории выполнения работ изменился с %1, нажмите ""Изменился бухучет""';
						|en = 'When editing, you have changed bookkeeping for the work area. 
						|If you corrected the previous data (it was incorrect), click ""Error is corrected"".
						|If the bookkeeping for the work area is changed from %1, click ""Bookkeeping changed"".'"), 
			Формат(ДатаИзменения, "ДФ='д ММММ гггг ""г""'"));
			ТекстКнопкиДа = НСтр("ru = 'Изменился бухучет';
								|en = 'Accounting changed'");
		
		Оповещение = Новый ОписаниеОповещения("ЗаписатьНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ЭтаФорма, "БухучетЗарплатыТерриторийВыполненияРабот", ТекстВопроса, ТекстКнопкиДа, Ложь, Оповещение);
		
	Иначе
		ЗаписатьНаКлиентеЗавершение(ЗакрытьПослеЗаписи, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеСведенияОБухучетеПериод(Форма, Объект, Элементы, БухучетЗарплатыТерриторийВыполненияРабот, БухучетЗарплатыТерриторийВыполненияРаботПрежняя, ДатаСеанса)
	
	Если Элементы.Найти("БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокой") = НеОпределено Тогда
		Возврат;
	КонецЕсли;
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, "БухучетЗарплатыТерриторийВыполненияРабот", Форма.СсылкаНаОбъект);
	// Не обязательно заполнение поля Период если данные по умолчанию и при этом 
	// записи о бухучете еще нет.
	Если ЗарплатаКадрыКлиентСервер.СведенияОБухучетеСотрудникаПоУмолчанию(БухучетЗарплатыТерриторийВыполненияРабот) И 
		Не ЗначениеЗаполнено(БухучетЗарплатыТерриторийВыполненияРаботПрежняя.Период) Тогда
		Если ЗначениеЗаполнено(БухучетЗарплатыТерриторийВыполненияРабот.Период) Тогда
			БухучетЗарплатыТерриторийВыполненияРабот.Период = '00010101';
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(БухучетЗарплатыТерриторийВыполненияРабот.Период) Тогда
			БухучетЗарплатыТерриторийВыполненияРабот.Период = НачалоМесяца(ДатаСеанса);
		КонецЕсли;
	КонецЕсли;
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "БухучетЗарплатыТерриторийВыполненияРабот.Период", "БухучетЗарплатыТерриторийВыполненияРаботПериодСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРегистрациюВНалоговомОрганеЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЗаписатьТерриторию И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыКлиент.ОткрытьФормуРедактированияРегистрацииВНалоговомОргане(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРайонногоКоэффициента()
	
	Если Объект.РайонныйКоэффициент < Объект.РайонныйКоэффициентРФ Тогда
		Объект.РайонныйКоэффициент = Объект.РайонныйКоэффициентРФ;
	КонецЕсли; 
	
КонецПроцедуры		

&НаКлиенте
Процедура ПриИзмененииТерриториальныеУсловияПФР()
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(ЭтаФорма, "ТерриториальныеУсловияПФР", СсылкаНаОбъект);

	ТерриториальныеУсловия = ТерриториальныеУсловияПФР.ТерриториальныеУсловияПФР;
	
	ПоказыватьПоляВвода = (ТерриториальныеУсловия = ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.РКС")
		ИЛИ ТерриториальныеУсловия = ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.РКСМ")
		ИЛИ ТерриториальныеУсловия = ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.МКС")
		ИЛИ ТерриториальныеУсловия = ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.МКСР")
		ИЛИ ТерриториальныеУсловия = ПредопределенноеЗначение("Справочник.ТерриториальныеУсловияПФР.ПРОЧ"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"КоличествоДополнительныхДнейВГод",
		"Видимость",
		ПоказыватьПоляВвода);
		
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "ТерриториальныеУсловияПФР", СсылкаНаОбъект);
	
	ДоступенПросмотрБухучетЗарплатыТерриторийВыполненияРабот = ОтражениеЗарплатыВБухучетеРасширенный.ДоступноЧтениеБухучетаЗарплатыТерриторийВыполненияРабот();
	Если ДоступенПросмотрБухучетЗарплатыТерриторийВыполненияРабот Тогда
		РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "БухучетЗарплатыТерриторийВыполненияРабот", СсылкаНаОбъект);
		ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, ТекущийОбъект, ЭтаФорма.Элементы, БухучетЗарплатыТерриторийВыполненияРабот, БухучетЗарплатыТерриторийВыполненияРаботПрежняя, ТекущаяДатаСеанса());
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Владелец",
		"ТолькоПросмотр",
		ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Владелец));
	
	УстановитьПредставлениеРегистрацииВНалоговомОргане(ЭтаФорма);
	УстановитьПараметрыФункциональныхОпций(ТекущийОбъект.Владелец);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеПолейВводаТерриториальныхУсловий()
	
	ПараметрВыбора = Новый ПараметрВыбора("ВыбиратьТерриторииСОсобымиКлиматическимиУсловиями", ПолучитьФункциональнуюОпциюФормы("ПрименятьСевернуюНадбавку"));
	МассивПараметровВыбора = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрВыбора);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТерриториальныеУсловияПФРТерриториальныеУсловияПФР",
		"ПараметрыВыбора",
		Новый ФиксированныйМассив(МассивПараметровВыбора));
	
	ДоступностьЭлементов = ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленныеТерритории");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Код",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Наименование",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаРегистрацияВНалоговомОргане",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РайонныйКоэффициентГруппа",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаПроцентЗаОсобыеКлиматическиеУсловия",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаТерриториальныеУсловияПФРПериодИстория",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"БухучетГруппа",
		"Доступность",
		ДоступностьЭлементов);
	
	// Команды записи формы
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаКомандаЗаписатьИЗакрыть",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаКомандаЗаписать",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаЗаписатьИЗакрыть",
		"Доступность",
		ДоступностьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаЗаписать",
		"Доступность",
		ДоступностьЭлементов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеРегистрацииВНалоговомОргане(Форма)
	
	Форма.ПредставлениеРегистрацииВНалоговомОргане =
		ЗарплатаКадрыКлиентСервер.ПредставлениеРегистрацииВНалоговомОргане(Форма.Объект.Ссылка, Форма.Объект.РегистрацияВНалоговомОргане);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВладелецПриИзмененииНаСервере()
	
	ЗаполнитьРеквизитыПоВладельцу();
	УстановитьПараметрыФункциональныхОпций(Объект.Владелец);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыФункциональныхОпций(Организация)
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Организация));
	УстановитьОтображениеПолейВводаТерриториальныхУсловий();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоВладельцу()
	
	Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияРеквизитовРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец,
		"РайонныйКоэффициент,РайонныйКоэффициентРФ,ПроцентСевернойНадбавки");
	
	Объект.РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитовРодителя);
	
	УстановитьПредставлениеРегистрацииВНалоговомОргане(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТерриториальныеУсловияПФР(ТекущийОбъект)
	
	ДополнительныеСвойства = Новый Структура;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АвтоматическийРасчетСтажейФизическихЛиц") Тогда
		
		МодульАвтоматическийРасчетСтажейФизическихЛиц = ОбщегоНазначения.ОбщийМодуль("АвтоматическийРасчетСтажейФизическихЛиц");
		МодульАвтоматическийРасчетСтажейФизическихЛиц.ЗаполнитьЗависимыеСтажиТерриторииПоДаннымФормы(ЭтаФорма, ТекущийОбъект, ДополнительныеСвойства);
		
	КонецЕсли;
	
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтаФорма, "ТерриториальныеУсловияПФР", СсылкаНаОбъект, , ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти
