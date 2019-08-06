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
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора" Тогда
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.ОС.Добавить().ОсновноеСредство = ЭлементМассива;
			КонецЦикла;
			ЗаполнитьИнвентарныеНомера();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьИнвентарныеНомера();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СписаниеОС", ПараметрыЗаписи, Объект.Ссылка);
	ОповеститьОбИзменении(Тип("СправочникСсылка.ОбъектыЭксплуатации"));
	
	Если Объект.ДокументНаОсновании И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда
		Оповестить("ЗаписьДокументаНаОснованииИнвентаризации",, Объект.Ссылка);
	КонецЕсли;

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДокументНаОснованииПриИзменении(Элемент)
	
	Если Объект.ДокументНаОсновании Тогда
		ОткрытьФорму("Документ.ИнвентаризацияОС.ФормаВыбора", , ЭтаФорма, ЭтаФорма,,, Новый ОписаниеОповещения("ВыборДокументаОснования", ЭтаФорма));
	Иначе
		Объект.ДокументОснование = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДокументаОснования(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.ДокументОснование = Результат;
	Иначе
		Объект.ДокументНаОсновании = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	СтруктураПараметровФО = Новый Структура("Организация", Объект.Организация);
	УстановитьПараметрыФункциональныхОпцийФормы(СтруктураПараметровФО);
	
	Элементы.ОССуммаСписанияБУ.ОтображатьВШапке = ПолучитьФункциональнуюОпцию("ПлательщикНалогаНаПрибыль", СтруктураПараметровФО);
	
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьИнвентарныеНомера();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СобытиеОСПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СобытиеОС) Тогда
		ВидСобытияОС = ВидСобытияОС(Объект.СобытиеОС);
	Иначе
		ВидСобытияОС = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидСобытияОС) Тогда
		Объект.ЧастичнаяЛиквидация = (ВидСобытияОС=ПредопределенноеЗначение("Перечисление.ВидыСобытийОС.ЧастичнаяЛиквидация"));
	КонецЕсли;
	
	Элементы.ЧастичнаяЛиквидация.ТолькоПросмотр = ЗначениеЗаполнено(ВидСобытияОС);
	Элементы.ОСГруппаЧастичнойЛиквидации.Видимость = Объект.ЧастичнаяЛиквидация;
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичнаяЛиквидацияПриИзменении(Элемент)
	Элементы.ОСГруппаЧастичнойЛиквидации.Видимость = Объект.ЧастичнаяЛиквидация;
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		АналитикаРасходовОбязательна = ПризнакОбязательностиАналитикиСтатьи(Объект.СтатьяРасходов);
	Иначе
		АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьИнвентарныеНомера();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыОС

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		СтрокаТЧ.ИнвентарныйНомер = "";
	Иначе
		СтрокаТЧ.ИнвентарныйНомер = УчетОСВызовСервера.ПолучитьИнвентарныйНомерОС(ОсновноеСредство, Объект.Организация, Объект.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОССуммаСписанияБУПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	СуммаНУ = ТекущиеДанные.СуммаСписанияБУ - ТекущиеДанные.СуммаСписанияПР - ТекущиеДанные.СуммаСписанияВР;
	Если СуммаНУ < 0 Тогда
		ТекущиеДанные.СуммаСписанияНУ = 0;
		ТекущиеДанные.СуммаСписанияВР = ТекущиеДанные.СуммаСписанияБУ - ТекущиеДанные.СуммаСписанияНУ - ТекущиеДанные.СуммаСписанияПР;
	Иначе
		ТекущиеДанные.СуммаСписанияНУ = СуммаНУ;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОССуммаСписанияНУПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	ТекущиеДанные.СуммаСписанияВР = ТекущиеДанные.СуммаСписанияБУ - ТекущиеДанные.СуммаСписанияНУ - ТекущиеДанные.СуммаСписанияПР;
	
КонецПроцедуры

&НаКлиенте
Процедура ОССуммаСписанияПРПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	ТекущиеДанные.СуммаСписанияВР = ТекущиеДанные.СуммаСписанияБУ - ТекущиеДанные.СуммаСписанияНУ - ТекущиеДанные.СуммаСписанияПР;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыПриходуемыеМЦ

&НаКлиенте
Процедура ПриходуемыеМЦНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПриходуемыеМЦ.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеритикиИспользуются"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)
	
	ОсновноеСредство = ВнеоборотныеАктивыКлиентЛокализация.ПолучитьОСДляЗаполнениеПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма));
	
	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		
		ЗаполнитьПоНаименованиюСервер(ОсновноеСредство);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("БУСостояние", ПредопределенноеЗначение("Перечисление.СостоянияОС.ПринятоКУчету"));
	ПараметрыОтбор.Вставить("БУОрганизация", Объект.Организация);
	ПараметрыОтбор.Вставить("БУПодразделение", Объект.Подразделение);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контекст", "БУ, МФУ");
	ПараметрыФормы.Вставить("ДатаСведений", Объект.Дата);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#Область СтандартныеПодсистемы_Печать

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

#Область ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтаФорма, "ПриходуемыеМЦХарактеристика", "Объект.ПриходуемыеМЦ.ХарактеристикиИспользуются");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	СтруктураПараметровФО = Новый Структура("Организация", Объект.Организация);
	УстановитьПараметрыФункциональныхОпцийФормы(СтруктураПараметровФО);
	
	Элементы.ОССуммаСписанияБУ.ОтображатьВШапке = ПолучитьФункциональнуюОпцию("ПлательщикНалогаНаПрибыль", СтруктураПараметровФО);
	
	АналитикаРасходовОбязательна = ПризнакОбязательностиАналитикиСтатьи(Объект.СтатьяРасходов);
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить(
		"ЗаполнитьПризнакХарактеристикиИспользуются",
		Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ПриходуемыеМЦ, ПараметрыЗаполненияРеквизитов);
	
	ЗаполнитьИнвентарныеНомера();
	
	ВидСобытияОС = ВидСобытияОС(Объект.СобытиеОС);
	
	Элементы.ЧастичнаяЛиквидация.ТолькоПросмотр = ЗначениеЗаполнено(ВидСобытияОС);
	Элементы.ОСГруппаЧастичнойЛиквидации.Видимость = Объект.ЧастичнаяЛиквидация;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПризнакОбязательностиАналитикиСтатьи(Статья)
	
	Возврат ЗначениеЗаполнено(Статья)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Статья, "КонтролироватьЗаполнениеАналитики");
	
КонецФункции

&НаСервере
Процедура ЗаполнитьИнвентарныеНомера()
	
	ТаблицаОС = Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство");
	
	ТаблицаНомеров = УчетОСВызовСервера.ИнвентарныеНомераОС(ТаблицаОС, Объект.Организация, Объект.Дата);
	
	Для Каждого Строка Из ТаблицаНомеров Цикл
		Объект.ОС[Строка.НомерСтроки-1].ИнвентарныйНомер = Строка.ИнвентарныйНомер;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗаполненияПоНаименованию(Форма)
	
	Результат = Новый Структура;
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("Объект", Форма.Объект);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоНаименованиюСервер(Знач ОсновноеСредство)
	
	УчетОСВызовСервера.ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма), ОсновноеСредство);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидСобытияОС(СобытиеОС)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СобытияОС.ВидСобытияОС КАК ВидСобытияОС
		|ИЗ
		|	Справочник.СобытияОС КАК СобытияОС
		|ГДЕ
		|	СобытияОС.Ссылка = &СобытиеОС");
	Запрос.УстановитьПараметр("СобытиеОС", СобытиеОС);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ВидСобытияОС;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти