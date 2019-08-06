#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьТекущиеЗначенияРеквизитов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора" Тогда
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.ОсновныеСредства.Добавить().ОсновноеСредство = ЭлементМассива;
			КонецЦикла;
			ЗаполнитьТекущиеЗначенияРеквизитов();
			ОбновитьТекущиеЗначения = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьТекущиеЗначенияРеквизитов();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаУчет И ОбновитьТекущиеЗначения Тогда
		СтраницыПриСменеСтраницыНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СтраницыПриСменеСтраницыНаСервере()
	
	ЗаполнитьТекущиеЗначенияРеквизитов();
	УстановитьОформление("ПорядокУчета, МетодНачисленияАмортизации");
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаПриИзменении(Элемент)
	
	УстановитьОформление("ПорядокУчета, МетодНачисленияАмортизации");
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииПриИзменении(Элемент)
	
	УстановитьОформление("МетодНачисленияАмортизации");
	
	ФлагПриИзменении("СрокИспользованияФлаг");
	ФлагПриИзменении("ПоказательНаработкиФлаг");
	ФлагПриИзменении("ОбъемНаработкиФлаг");
	ФлагПриИзменении("КоэффициентУскоренияФлаг");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		СтатьяРасходовПриИзмененииНаСервере();
	Иначе
		АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики")=Истина);
		
	АналитикаРасходовЗаказРеализация =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация")=Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
	УстановитьОформление("ПорядокУчета, МетодНачисленияАмортизации");
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СчетАмортизацииФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
	УстановитьОформление("МетодНачисленияАмортизации");
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ПоказательНаработкиФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ОбъемНаработкиФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура КоэффициентУскоренияФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
	Если Объект.СтатьяРасходовФлаг Тогда
		Объект.АналитикаРасходовФлаг = Истина;
		ФлагПриИзменении("АналитикаРасходовФлаг");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовФлагПриИзменении(Элемент)
	ФлагПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если АналитикаРасходовЗаказРеализация Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходов = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиОсновныеСредства

&НаКлиенте
Процедура ОсновныеСредстваПриИзменении(Элемент)
	ОбновитьТекущиеЗначения = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваОсновноеСредствоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОсновныеСредства.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.ОсновноеСредство) Тогда
		ЗаполнитьЗначенияСвойств(
			ТекущиеДанные,
			ТекущиеЗначенияРеквизитовОсновногоСредства(ТекущиеДанные.ОсновноеСредство, Объект.Дата));
	Иначе
		ЗаполнитьЗначенияСвойств(
			ТекущиеДанные,
			ПустыеЗначенияРеквизитовОсновногоСредства());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваАналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.ОсновныеСредства.ТекущиеДанные;
	Если СтрокаТаблицы.АналитикаРасходовЗаказРеализация Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваАналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.ОсновныеСредства.ТекущиеДанные;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыбранноеЗначение);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваАналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваАналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваСтатьяРасходовПриИзменении(Элемент)
	ОсновныеСредстваСтатьяРасходовПриИзмененииСервер(КэшированныеЗначения);
КонецПроцедуры

&НаСервере
Процедура ОсновныеСредстваСтатьяРасходовПриИзмененииСервер(КэшированныеЗначения)
	
	ТекСтрока = Объект.ОсновныеСредства.НайтиПоИдентификатору(Элементы.ОсновныеСредства.ТекущаяСтрока);
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(Объект, ТекСтрока.СтатьяРасходов, ТекСтрока.АналитикаРасходов);
	
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовЗаказРеализация");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("МФУСостояние", ПредопределенноеЗначение("Перечисление.СостоянияОС.ПринятоКУчету"));
	ПараметрыОтбор.Вставить("МФУОрганизация", Объект.Организация);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контекст", "МФУ, БУ");
	ПараметрыФормы.Вставить("ДатаСведений", Объект.Дата);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("МФУНаправлениеПеревода", Объект.НаправлениеПеревода);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформление(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты=Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПорядокУчета") Тогда
		
		НачислятьАмортизацию = (Объект.ПорядокУчета=Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию);
		
		Элементы.ГруппаСчетАмортизации.Видимость = НачислятьАмортизацию;
		
		Элементы.ГруппаАмортизация.Видимость = НачислятьАмортизацию;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("МетодНачисленияАмортизации") Тогда
		
		ПоОбъемуНаработки = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции);
		ПоОстатку = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка);
		
		Если ЗначениеЗаполнено(Объект.МетодНачисленияАмортизации) И Не ПоОбъемуНаработки И Не ЗначениеЗаполнено(Объект.СрокИспользования) Тогда
			Объект.СрокИспользованияФлаг = Истина;
			Элементы.ГруппаСрокИспользования.Доступность = Истина;
			Элементы.СрокИспользованияФлаг.Доступность = Ложь;
		Иначе
			Элементы.СрокИспользованияФлаг.Доступность = Истина;
		КонецЕсли;
		Элементы.СрокИспользования.АвтоОтметкаНезаполненного = Не ПоОбъемуНаработки;
		Элементы.СрокИспользования.ОтметкаНезаполненного = Не ПоОбъемуНаработки;
		
		Если ПоОбъемуНаработки И Не ЗначениеЗаполнено(Объект.ОбъемНаработки) Тогда
			Объект.ОбъемНаработкиФлаг = Истина;
			Элементы.ГруппаОбъемНаработки.Доступность = Истина;
		КонецЕсли;
		Элементы.ОбъемНаработкиФлаг.Доступность = (ПоОбъемуНаработки И ЗначениеЗаполнено(Объект.ОбъемНаработки));
		Элементы.ОбъемНаработкиФлаг.Видимость = ПоОбъемуНаработки;
		Элементы.ГруппаОбъемНаработки.Видимость = ПоОбъемуНаработки;
		
		Если ПоОбъемуНаработки И Не ЗначениеЗаполнено(Объект.ПоказательНаработки) Тогда
			Объект.ПоказательНаработкиФлаг = Истина;
			Элементы.ГруппаПоказательНаработки.Доступность = Истина;
		КонецЕсли;
		Элементы.ПоказательНаработкиФлаг.Доступность = (ПоОбъемуНаработки И ЗначениеЗаполнено(Объект.ПоказательНаработки));
		Элементы.ПоказательНаработкиФлаг.Видимость = ПоОбъемуНаработки;
		Элементы.ГруппаПоказательНаработки.Видимость = ПоОбъемуНаработки;
		
		Если ПоОстатку И Не ЗначениеЗаполнено(Объект.КоэффициентУскорения) Тогда
			Объект.КоэффициентУскоренияФлаг = Истина;
			Элементы.ГруппаКоэффициентУскорения.Доступность = Истина;
		КонецЕсли;
		Элементы.КоэффициентУскоренияФлаг.Доступность = (ПоОстатку И ЗначениеЗаполнено(Объект.КоэффициентУскорения));
		Элементы.КоэффициентУскоренияФлаг.Видимость = ПоОстатку;
		Элементы.ГруппаКоэффициентУскорения.Видимость = ПоОстатку;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагПриИзменении(ИмяФлага)
	
	Имя = СтрЗаменить(ИмяФлага, "Флаг", "");
	
	Если Объект[ИмяФлага] Тогда
		
		Элементы[Имя+"Поля"].Доступность = Истина;
		Элементы["ОсновныеСредства"+Имя].Видимость = Истина;
		Элементы[Имя].ПодсказкаВвода = "";
	Иначе
		
		Элементы[Имя+"Поля"].Доступность = Ложь;
		Элементы["ОсновныеСредства"+Имя].Видимость = Ложь;
		Объект[Имя] = ТекущиеЗначенияРеквизитов[Имя];
		Если ТипЗнч(ТекущиеЗначенияРеквизитов[Имя]) = Тип("Строка") Тогда
			Элементы[Имя].ПодсказкаВвода = ТекущиеЗначенияРеквизитов[Имя];
		КонецЕсли;
		
	КонецЕсли;
	
	КоличествоИзмененныхСвойств = КоличествоИзмененныхСвойств + ?(Объект[ИмяФлага], 1, -1);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьТекущиеЗначенияРеквизитов(Истина);
	УстановитьОформление();
	
	АналитикаРасходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики")=Истина);
		
	АналитикаРасходовЗаказРеализация =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация")=Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущиеЗначенияРеквизитов(ЗаполнитьДоступность=Ложь)
	
	КоличествоИзмененныхСвойств = 0;
	Структура = СтруктураИзменяемыхРеквизитов();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеДокумента.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки,
		|	ВЫРАЗИТЬ(ДанныеДокумента.ОсновноеСредство КАК Справочник.ОбъектыЭксплуатации) КАК ОсновноеСредство
		|ПОМЕСТИТЬ ДанныеДокумента
		|ИЗ
		|	&ДанныеДокумента КАК ДанныеДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.НомерСтроки КАК НомерСтроки,
		|	ТекущиеЗначения.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	ТекущиеЗначения.ПорядокУчета КАК ПорядокУчета,
		|	ТекущиеЗначения.СчетУчета КАК СчетУчета,
		|	ТекущиеЗначения.СчетАмортизации КАК СчетАмортизации,
		|	ТекущиеЗначения.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
		|	ТекущиеЗначения.СрокИспользования КАК СрокИспользования,
		|	ТекущиеЗначения.ПоказательНаработки КАК ПоказательНаработки,
		|	ТекущиеЗначения.ОбъемНаработки КАК ОбъемНаработки,
		|	ТекущиеЗначения.КоэффициентУскорения КАК КоэффициентУскорения,
		|	ТекущиеЗначения.СтатьяРасходов КАК СтатьяРасходов,
		|	ТекущиеЗначения.АналитикаРасходов КАК АналитикаРасходов
		|ПОМЕСТИТЬ ТекущиеДанные
		|ИЗ
		|	ДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(
		|				&Дата,
		|				ОсновноеСредство В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.ОсновноеСредство
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК ТекущиеЗначения
		|		ПО ДанныеДокумента.ОсновноеСредство = ТекущиеЗначения.ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТекущиеДанные.НомерСтроки,
		|	ТекущиеДанные.ИнвентарныйНомер,
		|	ТекущиеДанные.ПорядокУчета,
		|	ТекущиеДанные.СчетУчета,
		|	ТекущиеДанные.СчетАмортизации,
		|	ТекущиеДанные.МетодНачисленияАмортизации,
		|	ТекущиеДанные.СрокИспользования,
		|	ТекущиеДанные.ПоказательНаработки,
		|	ТекущиеДанные.ОбъемНаработки,
		|	ТекущиеДанные.КоэффициентУскорения,
		|	ТекущиеДанные.СтатьяРасходов,
		|	ТекущиеДанные.АналитикаРасходов
		|ИЗ
		|	ТекущиеДанные КАК ТекущиеДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТекущиеДанные.ПорядокУчета) КАК ПорядокУчета,
		|	МАКСИМУМ(ТекущиеДанные.СчетУчета) КАК СчетУчета,
		|	МАКСИМУМ(ТекущиеДанные.СчетАмортизации) КАК СчетАмортизации,
		|	МАКСИМУМ(ТекущиеДанные.МетодНачисленияАмортизации) КАК МетодНачисленияАмортизации,
		|	МАКСИМУМ(ТекущиеДанные.СрокИспользования) КАК СрокИспользования,
		|	МАКСИМУМ(ТекущиеДанные.ПоказательНаработки) КАК ПоказательНаработки,
		|	МАКСИМУМ(ТекущиеДанные.ОбъемНаработки) КАК ОбъемНаработки,
		|	МАКСИМУМ(ТекущиеДанные.КоэффициентУскорения) КАК КоэффициентУскорения,
		|	МАКСИМУМ(ТекущиеДанные.СтатьяРасходов) КАК СтатьяРасходов,
		|	МАКСИМУМ(ТекущиеДанные.АналитикаРасходов) КАК АналитикаРасходов,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.ПорядокУчета) КАК ПорядокУчетаКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СчетУчета) КАК СчетУчетаКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СчетАмортизации) КАК СчетАмортизацииКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.МетодНачисленияАмортизации) КАК МетодНачисленияАмортизацииКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СрокИспользования) КАК СрокИспользованияКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.ПоказательНаработки) КАК ПоказательНаработкиКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.ОбъемНаработки) КАК ОбъемНаработкиКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.КоэффициентУскорения) КАК КоэффициентУскоренияКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СтатьяРасходов) КАК СтатьяРасходовКоличествоРазличных,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.АналитикаРасходов) КАК АналитикаРасходовКоличествоРазличных
		|ИЗ
		|	ТекущиеДанные КАК ТекущиеДанные");
	
	Запрос.УстановитьПараметр("Дата", Новый Граница(?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ДанныеДокумента", Объект.ОсновныеСредства.Выгрузить(, "НомерСтроки, ОсновноеСредство"));
	Запрос.УстановитьПараметр("ТекущийРегистратор", Объект.Ссылка);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Если Не Результат[3].Пустой() Тогда
		Выборка = Результат[3].Выбрать();
		Выборка.Следующий();
		Для Каждого КлючИЗначение Из Структура Цикл
			Имя = КлючИЗначение.Ключ;
			Если Выборка[Имя+"КоличествоРазличных"] > 1 Тогда
				Структура[Имя] = СтрЗаменить(НСтр("ru = '% различных';
													|en = '% different '"), "%", Формат(Выборка[Имя+"КоличествоРазличных"], "ЧЦ=1; ЧГ=0"));
			Иначе
				Структура[Имя] = Выборка[Имя];
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	ТекущиеЗначенияРеквизитов = Новый ФиксированнаяСтруктура(Структура);
	
	Если Не Результат[2].Пустой() Тогда
		Выборка = Результат[2].Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Объект.ОсновныеСредства[Выборка.НомерСтроки-1], Выборка,, "НомерСтроки");
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Структура Цикл
		Имя = КлючИЗначение.Ключ;
		Если Не Объект[Имя+"Флаг"] Тогда
			Объект[Имя] = ТекущиеЗначенияРеквизитов[Имя];
			Если ТипЗнч(ТекущиеЗначенияРеквизитов[Имя]) = Тип("Строка") Тогда
				Элементы[Имя].ПодсказкаВвода = ТекущиеЗначенияРеквизитов[Имя];
			КонецЕсли;
		КонецЕсли;
		Если ЗаполнитьДоступность Тогда
			Элементы[Имя+"Поля"].Доступность = Объект[Имя + "Флаг"];
			Элементы["ОсновныеСредства"+Имя].Видимость = Объект[Имя + "Флаг"];
		КонецЕсли;
		
		КоличествоИзмененныхСвойств = КоличествоИзмененныхСвойств + ?(Объект[Имя + "Флаг"], 1, 0);
		
	КонецЦикла;
	
	ОбновитьТекущиеЗначения = Ложь;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураИзменяемыхРеквизитов()
	
	Возврат Новый Структура(
		"ПорядокУчета, СчетУчета, СчетАмортизации, МетодНачисленияАмортизации,
		|СрокИспользования, ПоказательНаработки, ОбъемНаработки, КоэффициентУскорения,
		|СтатьяРасходов, АналитикаРасходов");
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекущиеЗначенияРеквизитовОсновногоСредства(ОсновноеСредство, Дата)
	
	Структура = ПустыеЗначенияРеквизитовОсновногоСредства();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТекущиеДанные.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	ТекущиеДанные.ПорядокУчета,
		|	ТекущиеДанные.СчетУчета,
		|	ТекущиеДанные.СчетАмортизации,
		|	ТекущиеДанные.МетодНачисленияАмортизации,
		|	ТекущиеДанные.СрокИспользования,
		|	ТекущиеДанные.ПоказательНаработки,
		|	ТекущиеДанные.ОбъемНаработки,
		|	ТекущиеДанные.КоэффициентУскорения,
		|	ТекущиеДанные.СтатьяРасходов,
		|	ТекущиеДанные.АналитикаРасходов
		|ИЗ
		|	РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(&Дата, ОсновноеСредство = &ОсновноеСредство) КАК ТекущиеДанные");
	
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Структура;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(Структура, Выборка);
	
	Возврат Структура;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПустыеЗначенияРеквизитовОсновногоСредства()
	
	Возврат Новый Структура(
		"ИнвентарныйНомер, ПорядокУчета, СчетУчета, СчетАмортизации,
		|МетодНачисленияАмортизации, СрокИспользования, ПоказательНаработки, ОбъемНаработки, КоэффициентУскорения,
		|СтатьяРасходов, АналитикаРасходов");
	
КонецФункции

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

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

#КонецОбласти







