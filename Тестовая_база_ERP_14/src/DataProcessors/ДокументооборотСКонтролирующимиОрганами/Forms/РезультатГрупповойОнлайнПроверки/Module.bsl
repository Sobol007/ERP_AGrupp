&НаСервере
Перем ПредставлениеРезультатовПроверки;

&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.АдресТаблицыРезультатов) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаСРезультатами = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыРезультатов);
	Если ТипЗнч(ТаблицаСРезультатами) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	ПоддержкаВУниверсальномФормате = Параметры.ПоддержкаВУниверсальномФормате;
	
	ПрограммыПроверки = Новый Массив;
	ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверкиВУниверсальномФормате");
	ИсходноеКоличествоЭлементовУсловногоОформления = УсловноеОформление.Элементы.Количество();
	
	// дополнить записи результатами при нескольких проверках разными программами для одного документа
	Если НЕ ПоддержкаВУниверсальномФормате Тогда
		ПрограммыПроверки.Добавить("");
		Элементы.ПрограммаПроверки.Видимость = Ложь;
		
	Иначе
		Для Каждого СтрРезультат Из ТаблицаСРезультатами Цикл
			ТаблицаРезультатовПроверок = Неопределено;
			Если СтрРезультат.РезультатыПроверок <> Неопределено Тогда
				ТаблицаРезультатовПроверок = ПолучитьИзВременногоХранилища(СтрРезультат.РезультатыПроверок);
			КонецЕсли;
			Если ТаблицаРезультатовПроверок = Неопределено Тогда
				ТаблицаРезультатовПроверок = Новый ТаблицаЗначений;
				ТаблицаРезультатовПроверок.Колонки.Добавить("ИсходноеИмяФайлаПротокола");
				ТаблицаРезультатовПроверок.Колонки.Добавить("ИмяФайлаПротокола");
				ТаблицаРезультатовПроверок.Колонки.Добавить("РезультатПроверки");
				ТаблицаРезультатовПроверок.Колонки.Добавить("РезультатПроверкиВУниверсальномФормате");
				ТаблицаРезультатовПроверок.Колонки.Добавить("ПрограммаПроверки");
			КонецЕсли;
			
			// если заголовочный протокол отсутствует во вложенной таблице результатов всех проверок, добавляем его туда
			Если ТаблицаРезультатовПроверок.Найти(СтрРезультат.ИмяФайлаПротокола, "ИмяФайлаПротокола") = Неопределено Тогда
				СтрРезультатПроверки = ТаблицаРезультатовПроверок.Вставить(0);
				СтрРезультатПроверки.ИсходноеИмяФайлаПротокола = СтрРезультат.ИсходноеИмяФайлаПротокола;
				СтрРезультатПроверки.ИмяФайлаПротокола = СтрРезультат.ИмяФайлаПротокола;
				СтрРезультатПроверки.РезультатПроверки = СтрРезультат.РезультатПроверки;
				СтрРезультатПроверки.РезультатПроверкиВУниверсальномФормате = СтрРезультат.РезультатПроверкиВУниверсальномФормате;
				СтрРезультатПроверки.ПрограммаПроверки = СтрРезультат.ПрограммаПроверки;
			КонецЕсли;
			СтрРезультат.ИсходноеИмяФайлаПротокола = "";
			СтрРезультат.ИмяФайлаПротокола = "";
			СтрРезультат.РезультатПроверки = "";
			СтрРезультат.РезультатПроверкиВУниверсальномФормате = "";
			СтрРезультат.ПрограммаПроверки = "";
			
			Для Каждого СтрРезультатПроверки Из ТаблицаРезультатовПроверок Цикл
				НоваяПрограммаПроверки = Ложь;
				ИндексПрограммыПроверки = ПрограммыПроверки.Найти(СтрРезультатПроверки.ПрограммаПроверки);
				Если ИндексПрограммыПроверки = Неопределено Тогда
					ПрограммыПроверки.Добавить(СтрРезультатПроверки.ПрограммаПроверки);
					ИндексПрограммыПроверки = ПрограммыПроверки.Количество() - 1;
					НоваяПрограммаПроверки = Истина;
				КонецЕсли;
				НомерПрограммыПроверки = ?(ИндексПрограммыПроверки > 0, Формат(ИндексПрограммыПроверки + 1, "ЧН=0; ЧГ="), "");
				
				// при отсутствии колонки ее необходимо добавить
				Если НоваяПрограммаПроверки И ИндексПрограммыПроверки > 0 Тогда
					ТаблицаСРезультатами.Колонки.Добавить("ИсходноеИмяФайлаПротокола" + НомерПрограммыПроверки);
					ТаблицаСРезультатами.Колонки.Добавить("ИмяФайлаПротокола" + НомерПрограммыПроверки);
					ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверки" + НомерПрограммыПроверки);
					ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверкиВУниверсальномФормате" + НомерПрограммыПроверки);
					ТаблицаСРезультатами.Колонки.Добавить("ПрограммаПроверки" + НомерПрограммыПроверки);
					
					ДобавляемыеРеквизиты = Новый Массив();
					ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИсходноеИмяФайлаПротокола" + НомерПрограммыПроверки, Новый ОписаниеТипов("Строка"), "ТаблицаРезультатов"));
					ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИмяФайлаПротокола" + НомерПрограммыПроверки, Новый ОписаниеТипов("Строка"), "ТаблицаРезультатов"));
					ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("РезультатПроверки" + НомерПрограммыПроверки, Новый ОписаниеТипов("Строка"), "ТаблицаРезультатов"));
					ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("РезультатПроверкиВУниверсальномФормате" + НомерПрограммыПроверки, Новый ОписаниеТипов("Строка"), "ТаблицаРезультатов"));
					ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПрограммаПроверки" + НомерПрограммыПроверки, Новый ОписаниеТипов("Строка"), "ТаблицаРезультатов"));
					ИзменитьРеквизиты(ДобавляемыеРеквизиты);
					
					ЭлементПрограммаПроверки = Элементы.Добавить("ПрограммаПроверки" + НомерПрограммыПроверки, Тип("ПолеФормы"), Элементы.ПрограммыПроверки);
					ЭлементПрограммаПроверки.Вид = ВидПоляФормы.ПолеВвода;
					ЭлементПрограммаПроверки.ОтображатьВШапке = Ложь;
					ЭлементПрограммаПроверки.РастягиватьПоГоризонтали = Истина;
					ЭлементПрограммаПроверки.ПутьКДанным = "ТаблицаРезультатов.ПрограммаПроверки" + НомерПрограммыПроверки;
					ЭлементПрограммаПроверки.ТолькоПросмотр = Истина;
					
					ЭлементРезультатПроверки = Элементы.Добавить("РезультатПроверки" + НомерПрограммыПроверки, Тип("ПолеФормы"), Элементы.РезультатыПроверки);
					ЭлементРезультатПроверки.Вид = ВидПоляФормы.ПолеВвода;
					ЭлементРезультатПроверки.ОтображатьВШапке = Ложь;
					ЭлементРезультатПроверки.ПутьКДанным = "ТаблицаРезультатов.РезультатПроверки" + НомерПрограммыПроверки;
					ЭлементРезультатПроверки.ТолькоПросмотр = Истина;
				КонецЕсли;
				
				// заполнить результаты проверки для колонок соответствующей программы проверки
				ИндексИсходноеИмяФайлаПротокола = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("ИсходноеИмяФайлаПротокола" + НомерПрограммыПроверки));
				ИндексИмяФайлаПротокола = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("ИмяФайлаПротокола" + НомерПрограммыПроверки));
				ИндексПрограммаПроверки = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("ПрограммаПроверки" + НомерПрограммыПроверки));
				ИндексРезультатПроверки = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("РезультатПроверки" + НомерПрограммыПроверки));
				СтрРезультат[ИндексИсходноеИмяФайлаПротокола] = СтрРезультатПроверки.ИсходноеИмяФайлаПротокола;
				СтрРезультат[ИндексИмяФайлаПротокола] = СтрРезультатПроверки.ИмяФайлаПротокола;
				СтрРезультат[ИндексПрограммаПроверки] = СтрРезультатПроверки.ПрограммаПроверки;
				СтрРезультат[ИндексРезультатПроверки] = СтрРезультатПроверки.РезультатПроверки;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаСРезультатами.Колонки.Добавить("ПредставлениеДокумента");
	
	ТаблицаСРезультатами.Колонки.Добавить("Гиперссылка");
	ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверкиКрасным");
	ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверкиОранжевым");
	ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверкиЗеленым");
	
	ДобавляемыеРеквизиты = Новый Массив();
	Для ИндексПрограммыПроверки = 1 По ПрограммыПроверки.Количество() - 1 Цикл
		НомерПрограммыПроверки = Формат(ИндексПрограммыПроверки + 1, "ЧН=0; ЧГ=");
		ТаблицаСРезультатами.Колонки.Добавить("Гиперссылка" + НомерПрограммыПроверки);
		ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверкиКрасным" + НомерПрограммыПроверки);
		ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверкиОранжевым" + НомерПрограммыПроверки);
		ТаблицаСРезультатами.Колонки.Добавить("РезультатПроверкиЗеленым" + НомерПрограммыПроверки);
		
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Гиперссылка" + НомерПрограммыПроверки, Новый ОписаниеТипов("Булево"), "ТаблицаРезультатов"));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("РезультатПроверкиКрасным" + НомерПрограммыПроверки, Новый ОписаниеТипов("Булево"), "ТаблицаРезультатов"));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("РезультатПроверкиОранжевым" + НомерПрограммыПроверки, Новый ОписаниеТипов("Булево"), "ТаблицаРезультатов"));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("РезультатПроверкиЗеленым" + НомерПрограммыПроверки, Новый ОписаниеТипов("Булево"), "ТаблицаРезультатов"));
	КонецЦикла;
	Если ДобавляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;
	
	Для ИндексПрограммыПроверки = 1 По ПрограммыПроверки.Количество() - 1 Цикл
		НомерПрограммыПроверки = Формат(ИндексПрограммыПроверки + 1, "ЧН=0; ЧГ=");
		УстановитьУсловноеОформление(НомерПрограммыПроверки);
	КонецЦикла;
	
	// готовим служебное соответствие
	ЗаполнитьСоответствие(ПоддержкаВУниверсальномФормате);
	
	Для ИндексПрограммыПроверки = 0 По ПрограммыПроверки.Количество() - 1 Цикл
		НомерПрограммыПроверки = ?(ИндексПрограммыПроверки > 0, Формат(ИндексПрограммыПроверки + 1, "ЧН=0; ЧГ="), "");
		ИндексИмяФайлаПротокола = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("ИмяФайлаПротокола" + НомерПрограммыПроверки));
		ИндексРезультатПроверки = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("РезультатПроверки" + НомерПрограммыПроверки));
		ИндексРезультатПроверкиВУниверсальномФормате = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("РезультатПроверкиВУниверсальномФормате" + НомерПрограммыПроверки));
		ИндексГиперссылка = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("Гиперссылка" + НомерПрограммыПроверки));
		ИндексРезультатПроверкиКрасным = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("РезультатПроверкиКрасным" + НомерПрограммыПроверки));
		ИндексРезультатПроверкиОранжевым = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("РезультатПроверкиОранжевым" + НомерПрограммыПроверки));
		ИндексРезультатПроверкиЗеленым = ТаблицаСРезультатами.Колонки.Индекс(ТаблицаСРезультатами.Колонки.Найти("РезультатПроверкиЗеленым" + НомерПрограммыПроверки));
		
		Для Каждого ОформлениеСтроки Из ТаблицаСРезультатами Цикл
			// прорисовываем колонку Результат
			КодРезультата = ОформлениеСтроки[ИндексРезультатПроверки];
			ПредставлениеРезультата = ПредставлениеРезультатовПроверки[КодРезультата];
			ОформлениеСтроки[ИндексРезультатПроверки] = ПредставлениеРезультата;
			Если ПоддержкаВУниверсальномФормате Тогда
				ОформлениеСтроки[ИндексРезультатПроверкиВУниверсальномФормате] = КодРезультата;
			КонецЕсли;
			Если КодРезультата = "0" ИЛИ КодРезультата = 0 Тогда
				ОформлениеСтроки[ИндексРезультатПроверкиЗеленым] = Истина;
			ИначеЕсли ПоддержкаВУниверсальномФормате И (КодРезультата = "4" ИЛИ КодРезультата = 4) Тогда
				ОформлениеСтроки[ИндексРезультатПроверкиОранжевым] = Истина;
			Иначе
				ОформлениеСтроки[ИндексРезультатПроверкиКрасным] = Истина;
			КонецЕсли;
			
			// устанавливаем признак ссылки на протокол
			ОформлениеСтроки[ИндексГиперссылка] = ЗначениеЗаполнено(ОформлениеСтроки[ИндексИмяФайлаПротокола]);
			
			Если ИндексПрограммыПроверки = 0 Тогда
				// прорисовываем регламентированный отчет
				Если ТипЗнч(ОформлениеСтроки.Документ) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
					ОформлениеСтроки.ПредставлениеДокумента = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеДокументаРеглОтч(ОформлениеСтроки.Документ);
				Иначе
					ОформлениеСтроки.ПредставлениеДокумента = Строка(ОформлениеСтроки.Документ);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если ТаблицаСРезультатами.Количество() = 1 И Параметры.РежимПоказаДляОдиночногоДокументаРазрешен Тогда
		Заголовок = НСтр("ru = 'Проверка';
						|en = 'Check'") + ": " + ТаблицаСРезультатами[0].ПредставлениеДокумента;
		Элементы.ПредставлениеДокумента.Видимость = Ложь;
		КлючСохраненияПоложенияОкна = "ОдиночныйДокумент";
		Ширина = 70;
		Высота = 7;
	Иначе
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Нет;
	КонецЕсли;
	
	//Помещаем ТЗ в реквизит.
	ТаблицаРезультатов.Загрузить(ТаблицаСРезультатами);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ТаблицаРезультатовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ПредставлениеДокумента" Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
		
	Иначе
		НомерПрограммыПроверки = "";
		ДлинаСтрокиПрограммаПроверки = СтрДлина("ПрограммаПроверки");
		ДлинаСтрокиРезультатПроверки = СтрДлина("РезультатПроверки");
		Если Лев(Поле.Имя, ДлинаСтрокиПрограммаПроверки) = "ПрограммаПроверки" И СтрДлина(Поле.Имя) > ДлинаСтрокиПрограммаПроверки Тогда
			НомерПрограммыПроверки = Сред(Поле.Имя, ДлинаСтрокиПрограммаПроверки + 1);
		ИначеЕсли Лев(Поле.Имя, ДлинаСтрокиРезультатПроверки) = "РезультатПроверки" И СтрДлина(Поле.Имя) > ДлинаСтрокиРезультатПроверки Тогда
			НомерПрограммыПроверки = Сред(Поле.Имя, ДлинаСтрокиРезультатПроверки + 1);
		КонецЕсли;
		
		ЗначениеГиперссылка = Ложь;
		Элемент.ТекущиеДанные.Свойство("Гиперссылка" + НомерПрограммыПроверки, ЗначениеГиперссылка);
		ЗначениеИмяФайлаПротокола = "";
		Элемент.ТекущиеДанные.Свойство("ИмяФайлаПротокола" + НомерПрограммыПроверки, ЗначениеИмяФайлаПротокола);
		
		Если ЗначениеГиперссылка И ЗначениеЗаполнено(ЗначениеИмяФайлаПротокола) Тогда
			ПоказатьПротокол(Элемент.ТекущиеДанные, НомерПрограммыПроверки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСоответствие(ПоддержкаСервисаОнлайнПроверкиВУниверсальномФормате = Ложь)
	
	Если ПредставлениеРезультатовПроверки = Неопределено Тогда
		
		Если ПоддержкаСервисаОнлайнПроверкиВУниверсальномФормате <> Истина Тогда
			
			ПредставлениеРезультатовПроверки = Новый Соответствие;
			ПредставлениеРезультатовПроверки.Вставить("-1",	НСтр("ru = 'Неизвестная ошибка';
																	|en = 'Unknown error'"));
			ПредставлениеРезультатовПроверки.Вставить("0",	НСтр("ru = 'Ошибок не обнаружено';
																	|en = 'No errors detected'"));
			ПредставлениеРезультатовПроверки.Вставить("1",	НСтр("ru = 'Ошибка расшифровки';
																	|en = 'Decryption error'"));
			ПредставлениеРезультатовПроверки.Вставить("2",	НСтр("ru = 'Неизвестный формат';
																	|en = 'Unknown format'"));
			ПредставлениеРезультатовПроверки.Вставить("3",	НСтр("ru = 'Файл отчета поврежден';
																	|en = 'Report file is corrupted'"));
			ПредставлениеРезультатовПроверки.Вставить("4",	НСтр("ru = 'Обнаружены ошибки';
																	|en = 'Errors are detected'"));
			ПредставлениеРезультатовПроверки.Вставить("5",	НСтр("ru = 'Проверка не выполнена';
																	|en = 'Check is not performed'"));
			ПредставлениеРезультатовПроверки.Вставить("6",	НСтр("ru = 'Обнаружены ошибки';
																	|en = 'Errors are detected'"));
			
			ПредставлениеРезультатовПроверки.Вставить(-1,	НСтр("ru = 'Неизвестная ошибка';
																	|en = 'Unknown error'"));
			ПредставлениеРезультатовПроверки.Вставить(0,	НСтр("ru = 'Ошибок не обнаружено';
																|en = 'No errors detected'"));
			ПредставлениеРезультатовПроверки.Вставить(1,	НСтр("ru = 'Ошибка расшифровки';
																|en = 'Decryption error'"));
			ПредставлениеРезультатовПроверки.Вставить(2,	НСтр("ru = 'Неизвестный формат';
																|en = 'Unknown format'"));
			ПредставлениеРезультатовПроверки.Вставить(3,	НСтр("ru = 'Файл отчета поврежден';
																|en = 'Report file is corrupted'"));
			ПредставлениеРезультатовПроверки.Вставить(4,	НСтр("ru = 'Обнаружены ошибки';
																|en = 'Errors are detected'"));
			ПредставлениеРезультатовПроверки.Вставить(5,	НСтр("ru = 'Проверка не выполнена';
																|en = 'Check is not performed'"));
			ПредставлениеРезультатовПроверки.Вставить(6,	НСтр("ru = 'Обнаружены ошибки';
																|en = 'Errors are detected'"));
			
		Иначе
			
			ПредставлениеРезультатовПроверки = Новый Соответствие;
			ПредставлениеРезультатовПроверки.Вставить("-1",	НСтр("ru = 'Неизвестная ошибка';
																	|en = 'Unknown error'"));
			ПредставлениеРезультатовПроверки.Вставить("0",	НСтр("ru = 'Ошибок не обнаружено';
																	|en = 'No errors detected'"));
			ПредставлениеРезультатовПроверки.Вставить("1",	НСтр("ru = 'Ошибка расшифровки';
																	|en = 'Decryption error'"));
			ПредставлениеРезультатовПроверки.Вставить("2",	НСтр("ru = 'Неизвестный формат или файл поврежден';
																	|en = 'Unknown format or file is damaged'"));
			ПредставлениеРезультатовПроверки.Вставить("3",	НСтр("ru = 'Обнаружены ошибки';
																	|en = 'Errors are detected'"));
			ПредставлениеРезультатовПроверки.Вставить("4",	НСтр("ru = 'Есть предупреждения';
																	|en = 'There are warnings'"));
			
			ПредставлениеРезультатовПроверки.Вставить(-1,	НСтр("ru = 'Неизвестная ошибка';
																	|en = 'Unknown error'"));
			ПредставлениеРезультатовПроверки.Вставить(0,	НСтр("ru = 'Ошибок не обнаружено';
																|en = 'No errors detected'"));
			ПредставлениеРезультатовПроверки.Вставить(1,	НСтр("ru = 'Ошибка расшифровки';
																|en = 'Decryption error'"));
			ПредставлениеРезультатовПроверки.Вставить(2,	НСтр("ru = 'Неизвестный формат или файл поврежден';
																|en = 'Unknown format or file is damaged'"));
			ПредставлениеРезультатовПроверки.Вставить(3,	НСтр("ru = 'Обнаружены ошибки';
																|en = 'Errors are detected'"));
			ПредставлениеРезультатовПроверки.Вставить(4,	НСтр("ru = 'Есть предупреждения';
																|en = 'There are warnings'"));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРезультатовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПротокол(Стр, НомерПрограммыПроверки = "")
	
	// Текст будет загружаться в форме "РезультатОнлайнПроверки"
	
	ЗначениеИмяФайлаПротокола = "";
	Стр.Свойство("ИмяФайлаПротокола" + НомерПрограммыПроверки, ЗначениеИмяФайлаПротокола);
	ЗначениеИсходноеИмяФайлаПротокола = "";
	Стр.Свойство("ИсходноеИмяФайлаПротокола" + НомерПрограммыПроверки, ЗначениеИсходноеИмяФайлаПротокола);
	ЗначениеРезультатПроверкиВУниверсальномФормате = Неопределено;
	Стр.Свойство("РезультатПроверкиВУниверсальномФормате" + НомерПрограммыПроверки, ЗначениеРезультатПроверкиВУниверсальномФормате);
	ЗначениеПрограммаПроверки = "";
	Стр.Свойство("ПрограммаПроверки" + НомерПрограммыПроверки, ЗначениеПрограммаПроверки);
	
	КонтекстЭДОКлиент.ПоказатьПротоколОнлайнПроверки(Стр.Документ, Стр.ИмяФайлаОтчета, Стр.ПолноеИмяФайлаВыгрузки, ЗначениеИмяФайлаПротокола, ЗначениеИсходноеИмяФайлаПротокола, ЗначениеРезультатПроверкиВУниверсальномФормате, ЗначениеПрограммаПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление(НомерПрограммыПроверки)
	
	// условное оформление ошибки
	
	НовыйЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	НовыйОтборОформления = НовыйЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтборОформления.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтборОформления.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаРезультатов.РезультатПроверкиКрасным" + НомерПрограммыПроверки);
	НовыйОтборОформления.ПравоеЗначение = Истина;
	
	НовоеПолеОформления = НовыйЭлементУсловногоОформления.Поля.Элементы.Добавить();
	НовоеПолеОформления.Поле = Новый ПолеКомпоновкиДанных("РезультатПроверки" + НомерПрограммыПроверки);
	
	НовыйЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255, 0, 0));
	
	// условное оформление предупреждения
	
	НовыйЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	НовыйОтборОформления = НовыйЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтборОформления.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтборОформления.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаРезультатов.РезультатПроверкиОранжевым" + НомерПрограммыПроверки);
	НовыйОтборОформления.ПравоеЗначение = Истина;
	
	НовоеПолеОформления = НовыйЭлементУсловногоОформления.Поля.Элементы.Добавить();
	НовоеПолеОформления.Поле = Новый ПолеКомпоновкиДанных("РезультатПроверки" + НомерПрограммыПроверки);
	
	НовыйЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255, 128, 0));
	
	// условное оформление успеха
	
	НовыйЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	НовыйОтборОформления = НовыйЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтборОформления.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтборОформления.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаРезультатов.РезультатПроверкиЗеленым" + НомерПрограммыПроверки);
	НовыйОтборОформления.ПравоеЗначение = Истина;
	
	НовоеПолеОформления = НовыйЭлементУсловногоОформления.Поля.Элементы.Добавить();
	НовоеПолеОформления.Поле = Новый ПолеКомпоновкиДанных("РезультатПроверки" + НомерПрограммыПроверки);
	
	НовыйЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0, 128, 0));
	
	// условное оформление гиперссылки на протокол
	
	НовыйЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	НовыйОтборОформления = НовыйЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтборОформления.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтборОформления.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаРезультатов.Гиперссылка" + НомерПрограммыПроверки);
	НовыйОтборОформления.ПравоеЗначение = Истина;
	
	НовоеПолеОформления = НовыйЭлементУсловногоОформления.Поля.Элементы.Добавить();
	НовоеПолеОформления.Поле = Новый ПолеКомпоновкиДанных("РезультатПроверки" + НомерПрограммыПроверки);
	
	НовыйЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт( , , , , Истина));
	
КонецПроцедуры

#КонецОбласти
