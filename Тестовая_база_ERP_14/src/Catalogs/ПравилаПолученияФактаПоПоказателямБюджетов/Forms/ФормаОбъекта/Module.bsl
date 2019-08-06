#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			КомпоновщикНастроек = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеКопирования, "КомпоновщикНастроек");
		КонецЕсли;
		БюджетированиеСервер.ИнициализироватьКомпоновщикНастроекПравила(Объект, ЭтаФорма, КомпоновщикНастроек.Настройки);
	КонецЕсли;
	
	ЗаполнитьВидыАналитик();
	ЗаполнитьНастройкиЗаполненияАналитики();
	
	Если Не БюджетированиеСервер.ИспользуетсяМеждународныйУчет() Тогда
		Разделы = Элементы.РазделИсточникаДанных.СписокВыбора;
		РазделМеждународныйУчет = Разделы.НайтиПоЗначению(Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет);
		Если РазделМеждународныйУчет <> Неопределено Тогда
			Разделы.Удалить(РазделМеждународныйУчет);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		Разделы = Элементы.РазделИсточникаДанных.СписокВыбора;
		РазделРеглУчет = Разделы.НайтиПоЗначению(Перечисления.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет);
		Если РазделРеглУчет <> Неопределено Тогда
			Разделы.Удалить(РазделРеглУчет);
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеПоказателяБюджетов = Строка(Объект.ПоказательБюджетов);
	
	Если Параметры.Свойство("ТипПоказателя", ТипПоказателя) Тогда
		СвязьПараметров = Новый СвязьПараметраВыбора("Отбор.ТипПоказателя", "ТипПоказателя");
		МассивСвязей = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СвязьПараметров);
		Элементы.ПоказательБюджетов.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязей);
	Иначе
		ТипПоказателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПоказательБюджетов, "ТипПоказателя")
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьУсловноеОформление();
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СохраненныйКомпоновщикНастроек = ТекущийОбъект.КомпоновщикНастроек.Получить();
	БюджетированиеСервер.ИнициализироватьКомпоновщикНастроекПравила(Объект, ЭтаФорма, СохраненныйКомпоновщикНастроек);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ВключитьРасширеннуюНастройкуЗаполненияАналитикПриОшибкахВАвто() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если ТипПоказателя <> Перечисления.ТипПоказателяБюджетов.Целевой Тогда
		ТекущийОбъект.ТипПравила = Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ФактическиеДанные;
	КонецЕсли;
	
	ТекущийОбъект.КомпоновщикНастроек = Новый ХранилищеЗначения(КомпоновщикНастроек.ПолучитьНастройки());
	ТекущийОбъект.ПредставлениеОтбора = Строка(КомпоновщикНастроек.Настройки.Отбор);
	Если ТекущийОбъект.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
		ТекущийОбъект.СхемаИсточникаДанных = Новый ХранилищеЗначения(СхемаКомпоновкиДанных);
	КонецЕсли;
	
	БюджетированиеСервер.ПоместитьНастройкиЗаполненияАналитикиВПравило(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	БюджетированиеСервер.ОбработкаПроверкиНастроекЗаполненияАналитики(НастройкиЗаполненияАналитики, Отказ, Объект.РасширенныйРежимНастройкиЗаполненияАналитики);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОЗаписиНового(Объект.Ссылка);
	
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
Процедура ИсточникДанныхПриИзменении(Элемент)
	
	ОчиститьСообщения();
	ПриИзмененииИсточникаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура РазделИсточникаДанныхПриИзменении(Элемент)
	
	ОчиститьСообщения();
	ПриИзмененииРазделаИсточникаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательБюджетовПриИзменении(Элемент)
	
	ПриИзмененииПоказателяБюджетовСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗаполненияАналитикиВыражениеЗаполненияАналитикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.НастройкиЗаполненияАналитики.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидАналитики",               ТекущиеДанные.ВидАналитики);
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных", АдресСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("РазделИсточникаДанных",      Объект.РазделИсточникаДанных);
	ПараметрыФормы.Вставить("ТекущееВыражение",           ТекущиеДанные.ВыражениеЗаполненияАналитики);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПоляЗаполненияАналитики", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗаполненияАналитикиВыражениеЗаполненияАналитикиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.НастройкиЗаполненияАналитики.ТекущиеДанные;
	ТекущиеДанные.ВыражениеЗаполненияАналитики = ВыбранноеЗначение;
	
	ВыражениеЗаполненияАналитикиОбработкаВыбораСервер(ТекущиеДанные.ПолучитьИдентификатор());
	Модифицированность = Истина;
	Элементы.НастройкиЗаполненияАналитики.ЗакончитьРедактированиеСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗаполненияАналитикиВыражениеЗаполненияАналитикиОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗаполненияАналитикиПриАктивизацииСтроки(Элемент)
	
	ПараметрыВыбораФормы = Новый Массив;
	
	ТекущиеДанные = Элементы.НастройкиЗаполненияАналитики.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ДополнительноеСвойство) Тогда
		НовыйПараметрВыбора = Новый ПараметрВыбора("Отбор.Владелец", ТекущиеДанные.ДополнительноеСвойство);
		ПараметрыВыбораФормы.Добавить(НовыйПараметрВыбора);
	КонецЕсли;
	
	Элементы.НастройкиЗаполненияАналитикиЗначениеАналитики.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСхемуПолученияДанных(Команда)
	
	
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru = 'Настройки схемы получения произвольных данных';
														|en = 'Settings of arbitrary data receipt scheme'");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных",            АдресСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("Заголовок",                             ЗаголовокФормыНастройкиСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("УникальныйИдентификатор",               УникальныйИдентификатор);
	ПараметрыФормы.Вставить("НеНастраиватьУсловноеОформление",       Истина);
	ПараметрыФормы.Вставить("НеНастраиватьПорядок",                  Истина);
	ПараметрыФормы.Вставить("НеНастраиватьОтбор",                    Истина);
	ПараметрыФормы.Вставить("НеНастраиватьВыбор",                    Истина);
	ПараметрыФормы.Вставить("НеПомещатьНастройкиВСхемуКомпоновкиДанных", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьСхемуКомпоновкиДанных", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьРежимРасширеннойНастройкиЗаполненияАналитики(Команда)
	
	ОтключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРежимРасширеннойНастройкиЗаполненияАналитик(Команда)
	
	ВключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНастройкиАналитикиПоИсточникуДанных(Команда)
	
	ОчиститьСообщения();
	ЗаполнитьНастройкиАналитикиПоИсточникуДанныхСервер();
	
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

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	БюджетированиеСервер.УстановитьУсловноеНастроекЗаполненияАналитики(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыАналитик()
	
	ВидыАналитик = БюджетированиеСервер.ВидыАналитик(Объект);
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ВидыАналитик);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСхемуКомпоновкиДанных(Результат, Параметры) Экспорт
	
	Модифицированность = Истина;
	ИзмененаСхемаКомпоновкиДанныхСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПоказателяБюджетовСервер()
	
	РазделПроизвольныеДанные = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные;
	СтрокаПоказательБюджетов = Строка(Объект.ПоказательБюджетов);
	Если Объект.РазделИсточникаДанных = РазделПроизвольныеДанные 
		И (Объект.ИсточникДанных = ПредставлениеПоказателяБюджетов Или Объект.ИсточникДанных = "") Тогда
		Объект.ИсточникДанных = СтрокаПоказательБюджетов;
	КонецЕсли;
	ПредставлениеПоказателяБюджетов = СтрокаПоказательБюджетов;
	ТипПоказателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПоказательБюджетов, "ТипПоказателя");
	
	ЗаполнитьВидыАналитик();
	ЗаполнитьНастройкиЗаполненияАналитики();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииИсточникаСервер()
	
	НастроитьЭлементыФормы();
	
	Если Объект.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные 
		И Объект.ИсточникДанных = "" Тогда
		Объект.ИсточникДанных = ПредставлениеПоказателяБюджетов;
	КонецЕсли;
	
	ПолучитьСхемуКомпоновкиДанных();
	БюджетированиеСервер.ИнициализироватьКомпоновщикНастроекПравила(Объект, ЭтаФорма, КомпоновщикНастроек.ПолучитьНастройки());
	Если Не ВключитьРасширеннуюНастройкуЗаполненияАналитикПриОшибкахВАвто() Тогда
		БюджетированиеСервер.ПроверитьДоступностьПолейЗаполненияАналитики(ЭтаФорма, Объект, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРазделаИсточникаСервер()
	
	Раздел = Объект.РазделИсточникаДанных; 
	
	ПравилоПоРеглУчету = (Раздел = Перечисления.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет);
	ПравилоПоМеждународномуУчету = (Раздел = Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет);
	
	Если Не ПравилоПоРеглУчету И Не ПравилоПоМеждународномуУчету Тогда 
		Объект.ТипИтога = Неопределено;
	КонецЕсли;
	
	ПриИзмененииИсточникаСервер();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	ПравилоПоОперативномуУчету = 
		(Объект.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ОперативныйУчет);
	ПравилоПоРеглУчету = 
		(Объект.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет);
	ПравилоПоМеждународномуУчету = 
		(Объект.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет);
	ПравилоПоПроизвольнымДанным = 
		(Объект.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные);
	
	Элементы.ИсточникДанных.Видимость = ЗначениеЗаполнено(Объект.РазделИсточникаДанных);
	
	Элементы.ТипИтога.Видимость = ПравилоПоРеглУчету Или ПравилоПоМеждународномуУчету;
	
	ОписаниеТиповИсточника = Новый ОписаниеТипов(Неопределено);
	ЗаголовокИсточника = НСтр("ru = 'Источник данных';
								|en = 'Data source'");
	Если ПравилоПоОперативномуУчету Тогда
		ОписаниеТиповИсточника = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов");
		ЗаголовокИсточника = НСтр("ru = 'Статья активов/пассивов';
									|en = 'Asset/liability item'");
	ИначеЕсли ПравилоПоРеглУчету Тогда
		ОписаниеТиповИсточника = Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный");
		ЗаголовокИсточника = НСтр("ru = 'Счет учета';
									|en = 'GL account'");
	//++ НЕ УТКА
	ИначеЕсли ПравилоПоМеждународномуУчету Тогда
		ОписаниеТиповИсточника = Новый ОписаниеТипов("ПланСчетовСсылка.Международный");
		ЗаголовокИсточника = НСтр("ru = 'Счет учета';
									|en = 'GL account'");
	//-- НЕ УТКА
	ИначеЕсли ПравилоПоПроизвольнымДанным Тогда
		ОписаниеТиповИсточника = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(200));
		Если ТипЗнч(Объект.ИсточникДанных) <> Тип("Строка") Тогда
			Объект.ИсточникДанных = Строка(Объект.ПоказательБюджетов);
		КонецЕсли;
	КонецЕсли;
	
	Объект.ИсточникДанных = ОписаниеТиповИсточника.ПривестиЗначение(Объект.ИсточникДанных);
	Элементы.ИсточникДанных.Заголовок = ЗаголовокИсточника;
	Если ПравилоПоОперативномуУчету Или ПравилоПоРеглУчету Или ПравилоПоМеждународномуУчету Тогда
		Элементы.ИсточникДанных.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	Иначе
		Элементы.ИсточникДанных.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		Элементы.ИсточникДанных.РасширеннаяПодсказка.Заголовок = ПодсказкаПроизвольногоИсточникаДанных();
	КонецЕсли;
	
	Элементы.НастроитьСхемуПолученияДанных.Видимость = ПравилоПоПроизвольнымДанным;
	
	Элементы.ВключитьРежимРасширеннойНастройкиЗаполненияАналитики.Видимость = Не Объект.РасширенныйРежимНастройкиЗаполненияАналитики;
	Элементы.ГруппаНастройкаЗаполненияАналитикиПояснение.Видимость = Не Объект.РасширенныйРежимНастройкиЗаполненияАналитики;
	
	Элементы.ОтключитьРежимРасширеннойНастройкиЗаполненияАналитики.Видимость = Объект.РасширенныйРежимНастройкиЗаполненияАналитики;
	Элементы.НастройкиЗаполненияАналитики.Видимость = Объект.РасширенныйРежимНастройкиЗаполненияАналитики;
	
	Элементы.ГруппаНевыбранИсточник.Видимость = Не ЗначениеЗаполнено(Объект.РазделИсточникаДанных);
	
	Элементы.ТипПравила.Видимость = ТипПоказателя = Перечисления.ТипПоказателяБюджетов.Целевой;
	
КонецПроцедуры

&НаСервере
Процедура ИзмененаСхемаКомпоновкиДанныхСервер()
	
	Модифицированность = Истина;
	
	БюджетированиеСервер.ИнициализироватьКомпоновщикНастроекПравила(Объект, ЭтаФорма, КомпоновщикНастроек.ПолучитьНастройки()); 
	БюджетированиеСервер.ПроверитьДоступностьПолейЗаполненияАналитики(ЭтаФорма, Объект, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСхемуКомпоновкиДанных()
	
	МенеджерЗаписи = РеквизитФормыВЗначение("Объект");
	СхемаКомпоновкиДанных = ИсточникиДанныхСервер.СхемаКомпоновкиДанныхПравила(МенеджерЗаписи,,, Ложь);
	
	БюджетированиеСервер.УстановитьСвойстваПолейДляНастройкиПравила(СхемаКомпоновкиДанных, Объект);
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиЗаполненияАналитики()
	
	ВидыАналитик = Новый Структура;
	Для НомерАналитики = 1 По 6 Цикл
		ВидыАналитик.Вставить("ВидАналитики" + НомерАналитики, ЭтаФорма["ВидАналитики" + НомерАналитики]);
	КонецЦикла;
	БюджетированиеСервер.ЗаполнитьНастройкиЗаполненияАналитикиПоПравилу(ЭтаФорма, Объект, ВидыАналитик);
	БюджетированиеСервер.ПроверитьДоступностьПолейЗаполненияАналитики(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ВключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер(Знач ВыраженияЗаполненияАналитики = Неопределено)
	
	Объект.РасширенныйРежимНастройкиЗаполненияАналитики = Истина;
	ЗаполнитьНастройкиЗаполненияАналитики();
	БюджетированиеСервер.УстановитьНастройкиЗаполненияАналитикиАвтоматически(ЭтаФорма, ВыраженияЗаполненияАналитики);
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер()
	
	Объект.РасширенныйРежимНастройкиЗаполненияАналитики = Ложь;
	ЗаполнитьНастройкиЗаполненияАналитики();
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиАналитикиПоИсточникуДанныхСервер()
	
	БюджетированиеСервер.УстановитьНастройкиЗаполненияАналитикиАвтоматически(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВыражениеЗаполненияАналитикиОбработкаВыбораСервер(ИдентификаторСтроки) 
	
	БюджетированиеСервер.ПроверитьВыражениеЗаполненияАналитикиПослеВыбора(ЭтаФорма, ИдентификаторСтроки);
	
КонецПроцедуры

&НаСервере
Функция ВключитьРасширеннуюНастройкуЗаполненияАналитикПриОшибкахВАвто()
	
	Результат = Ложь;
	Если Не Объект.РасширенныйРежимНастройкиЗаполненияАналитики Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
		ВидыАналитик = НастройкиЗаполненияАналитики.Выгрузить(, "НомерАналитики, ВидАналитики");
		ВыраженияЗаполненияАналитики = БюджетированиеСервер.ВыраженияЗаполненияАналитикиПоСхемеКомпоновкиДанных(СхемаКомпоновкиДанных, ВидыАналитик);
		ПараметрыПоиска = Новый Структура("Неоднозначно", Истина);
		НайденныеСтроки = ВыраженияЗаполненияАналитики.НайтиСтроки(ПараметрыПоиска);
		Если НайденныеСтроки.Количество() Тогда
			ВключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер(ВыраженияЗаполненияАналитики);
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере 
Функция ПодсказкаПроизвольногоИсточникаДанных()
	ПодсказкаИсточника = НСтр("ru = 'В запросе схемы компоновки данных следует добавить поле выборки и условие вида:
		|""%1"" КАК ИсточникДанных.';
		|en = 'In request for data composition schema, add a selection field and a condition of the following kind: 
		|""%1"" AS ИсточникДанных.'");
	ПодсказкаИсточника = СтрШаблон(ПодсказкаИсточника, 
		?(ЗначениеЗаполнено(Объект.ИсточникДанных), Объект.ИсточникДанных, ПредставлениеПоказателяБюджетов));
	
	Возврат ПодсказкаИсточника; 
КонецФункции

#КонецОбласти