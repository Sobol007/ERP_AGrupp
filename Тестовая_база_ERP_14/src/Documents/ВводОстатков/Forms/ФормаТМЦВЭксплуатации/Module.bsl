
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
	
	Элементы.ГруппаВводОстатковПо.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
	УстановитьЗаголовок();
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

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ТМЦВЭксплуатации, ПараметрыЗаполненияРеквизитов);
	//++ НЕ УТ
	Справочники.КатегорииЭксплуатации.ЗаполнитьПризнакиКатегорииЭксплуатации(Объект.ТМЦВЭксплуатации);
	//-- НЕ УТ
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.ТМЦВЭксплуатации);
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиТМЦВЭксплуатации

&НаКлиенте
Процедура ТМЦВЭксплуатацииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		ТекущиеДанные = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
		ТекущиеДанные.ДатаПередачиВЭксплуатацию = ?(
			ЗначениеЗаполнено(Объект.Дата),
			Объект.Дата,
			ТекущаяДатаСеанса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти", ЭтаФорма.ИмяФормы, "ТМЦВЭксплуатации"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииКатегорияЭксплуатацииПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакиКатегорииЭксплуатации");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//++ НЕ УТ
	РасчитатьПервоначальнуюСуммуПоСтроке(ТекущаяСтрока);
	//-- НЕ УТ
	
	Если ТекущаяСтрока.Количество = 0 Тогда
		ТекущаяСтрока.Количество = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииСтатьяРасходовПриИзменении(Элемент)
	
	ТМЦВЭксплуатацииСтатьяРасходовПриИзмененииНаСервере(КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ТМЦВЭксплуатацииСтатьяРасходовПриИзмененииНаСервере(КэшированныеЗначения)
	
	СтрокаТаблицы = Объект.ТМЦВЭксплуатации.НайтиПоИдентификатору(Элементы.ТМЦВЭксплуатации.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(СтрокаТаблицы.СтатьяРасходов) Тогда
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.АналитикаРасходов) Тогда
			СтрокаТаблицы.АналитикаРасходов = ПланыВидовХарактеристик.СтатьиРасходов.ПолучитьАналитикуРасходовПоУмолчанию(
				СтрокаТаблицы.СтатьяРасходов,
				Объект);
		Иначе
			ДоходыИРасходыСервер.ОчиститьАналитикуПрочихРасходов(
				СтрокаТаблицы.СтатьяРасходов,
				СтрокаТаблицы.АналитикаРасходов);
		КонецЕсли;
		
		СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна");
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
		
	Иначе
		СтрокаТаблицы.АналитикаРасходов = Неопределено;
		СтрокаТаблицы.АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииСуммаПриИзменении(Элемент)
	
	//++ НЕ УТ
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
	РасчитатьПервоначальнуюСуммуПоСтроке(ТекущаяСтрока);
	//-- НЕ УТ
	Возврат; // Для УТ обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииДатаПередачиВЭксплуатациюПриИзменении(Элемент)
	
	//++ НЕ УТ
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
	РасчитатьПервоначальнуюСуммуПоСтроке(ТекущаяСтрока);
	//-- НЕ УТ
	Возврат; // Для УТ обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	#Область Характеристика
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтаФорма,
		"ТМЦВЭксплуатацииХарактеристика",
		"Объект.ТМЦВЭксплуатации.ХарактеристикиИспользуются");
	
	#КонецОбласти
	
	#Область АналитикаРасходов
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(
		УсловноеОформление, Новый Структура("ТМЦВЭксплуатации"));
	
	#КонецОбласти
	
	//++ НЕ УТ
	
	#Область Сумма_СуммаВР_СуммаПР
	
	// Колонки остаточной суммы не требуются, если стоимость была погашена при передаче в эксплуатацию
	// 		Определяется по способу отражения стоимости.
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУсловногоОформления.Поля, Элементы["ТМЦВЭксплуатацииСумма"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУсловногоОформления.Поля, Элементы["ТМЦВЭксплуатацииСуммаПР"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУсловногоОформления.Поля, Элементы["ТМЦВЭксплуатацииСуммаВР"].Имя);
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ЭлементУсловногоОформления.Отбор, "Объект.ТМЦВЭксплуатации.СпособПогашенияСтоимостиБУ", Перечисления.СпособыПогашенияСтоимостиТМЦ.ПриПередаче);
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '0.00';
																					|en = '0.00'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);	
	
	#КонецОбласти
	
	#Область ИнвентарныйНомер
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ТМЦВЭксплуатацииИнвентарныйНомер"].Имя);
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Элемент.Отбор, "Объект.ТМЦВЭксплуатации.ИнвентарныйУчет", Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<отсутствует>';
																|en = '<missing>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	#КонецОбласти
	
	#Область Количество
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ТМЦВЭксплуатацииКоличество"].Имя);
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Элемент.Отбор, "Объект.ТМЦВЭксплуатации.ИнвентарныйУчет", Истина);
		
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '1.000';
																|en = '1.000'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	#КонецОбласти
	
	#Область РазделУчетаРегламентированный
	// Снятие отметки незаполненного при разделе учета "Регламентированный"
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ТМЦВЭксплуатацииИнвентарныйНомер"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ТМЦВЭксплуатацииДатаПередачиВЭксплуатацию"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ТМЦВЭксплуатацииСтатьяРасходов"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ТМЦВЭксплуатацииАналитикаРасходов"].Имя);
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Элемент.Отбор, "Объект.ОтражатьВОперативномУчете", Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	#КонецОбласти
	
	//-- НЕ УТ
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(
		Объект.Ссылка, Объект.Номер, Объект.Дата, Объект.ТипОперации);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ТМЦВЭксплуатации, ПараметрыЗаполненияРеквизитов);
	//++ НЕ УТ
	Справочники.КатегорииЭксплуатации.ЗаполнитьПризнакиКатегорииЭксплуатации(Объект.ТМЦВЭксплуатации);
	//-- НЕ УТ
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(Объект.ТМЦВЭксплуатации);
	
КонецПроцедуры

//++ НЕ УТ
&НаКлиенте
Процедура РасчитатьПервоначальнуюСуммуПоСтроке(ТекущаяСтрока)
	
	Если ТекущаяСтрока.СпособПогашенияСтоимостиБУ = ПредопределенноеЗначение("Перечисление.СпособыПогашенияСтоимостиТМЦ.ПриПередаче") Тогда
		ТекущаяСтрока.ПервоначальнаяСумма = ТекущаяСтрока.Сумма;
	Иначе
		
		ВыработанныйРесурс = (Год(Объект.Дата) - Год(ТекущаяСтрока.ДатаПередачиВЭксплуатацию))*12 + Месяц(Объект.Дата) - Месяц(ТекущаяСтрока.ДатаПередачиВЭксплуатацию);
		НазначенныйРесурс = ТекущаяСтрока.СрокЭксплуатации;
		
		Если ВыработанныйРесурс > НазначенныйРесурс Тогда
			ВыработанныйРесурс = НазначенныйРесурс;
		КонецЕсли;
		
		Если НазначенныйРесурс = 0 Или ВыработанныйРесурс = 0 Тогда
			НазначенныйРесурс = 1;
			ВыработанныйРесурс = 1;
		КонецЕсли;
		
		ТекущаяСтрока.ПервоначальнаяСумма = ТекущаяСтрока.Сумма * (НазначенныйРесурс/ВыработанныйРесурс);
		
	КонецЕсли;
	
КонецПроцедуры
//-- НЕ УТ

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