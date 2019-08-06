
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("РучноеИзменение") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	РучноеИзменение = Ложь;
	ВКлассификаторе = Ложь;
	
	РучноеИзменение = Параметры.РучноеИзменение;
	РеквизитВладельца = Параметры.Реквизит;
	
	Если Параметры.ЗначенияПолей.Свойство("БИК") Тогда
		БИК = Параметры.ЗначенияПолей.БИК;
	КонецЕсли;
	Если Параметры.ЗначенияПолей.Свойство("СВИФТ") Тогда
		СВИФТБИК = Параметры.ЗначенияПолей.СВИФТ;
	КонецЕсли;
	
	Если Параметры.ЗначенияПолей.Свойство("КоррСчет") Тогда
		КоррСчет = Параметры.ЗначенияПолей.КоррСчет;
	КонецЕсли;
	
	Если РучноеИзменение Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ЗначенияПолей);
	Иначе
		Банк = Параметры.Банк;
		Если ТипЗнч(Банк) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
			
			РеквизитыБанка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Банк,
				"Код, СВИФТБИК, КоррСчет, Наименование, МеждународноеНаименование,
				|Страна, Город, ГородМеждународный, Адрес, АдресМеждународный, Телефоны, Родитель");
			
			ЗаполнитьЗначенияСвойств(ЭтаФорма, РеквизитыБанка);
			БИК                       = РеквизитыБанка.Код;
			Регион                    = РеквизитыБанка.Родитель;
			НаименованиеМеждународное = РеквизитыБанка.МеждународноеНаименование;
			ВКлассификаторе = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьФлагРучногоИзменения();
	БылиНажатыКнопкиЗакрытия = Ложь;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура КомандаОК(Команда)
	
	БылиНажатыКнопкиЗакрытия = Истина;
	ЗначенияПараметров = ПолучитьЗначенияПараметров();
	Закрыть(ЗначенияПараметров);
	ОповеститьОВыборе(ЗначенияПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	БылиНажатыКнопкиЗакрытия = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Процедура ОбработатьФлагРучногоИзменения()
	
	Если РучноеИзменение Тогда
		Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Автоматическое обновление элемента отключено';
													|en = 'Item automatic update is disabled'");
		ТолькоПросмотр = Ложь;
	Иначе
		Если ВКлассификаторе Тогда
			Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Элемент обновляется автоматически';
														|en = 'Item is updated automatically'");
			ТолькоПросмотр = Истина;
		Иначе
			Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Элемент не найден в классификаторе, автоматическое обновление элемента отключено';
														|en = 'Item is not found in the classifier, automatic item update is disabled'");
			ТолькоПросмотр = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗначенияПараметров()
	
	Результат = Новый Структура;
	Результат.Вставить("Реквизит", РеквизитВладельца);
	
	Если РучноеИзменение Тогда
		
		ЗначенияПолей = СтруктураПолей();
		ЗаполнитьЗначенияСвойств(ЗначенияПолей, ЭтаФорма);
		ЗначенияПолей.Вставить("РучноеИзменение", РучноеИзменение);
		
		Результат.Вставить("РучноеИзменение", РучноеИзменение);
		Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
	Иначе
		Если ВКлассификаторе Тогда
			Результат.Вставить("РучноеИзменение", РучноеИзменение);
			Результат.Вставить("Банк", Банк);
		Иначе
			ЗначенияПолей = СтруктураПолей();
			ЗаполнитьЗначенияСвойств(ЗначенияПолей, ЭтаФорма);
			
			Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
			Результат.Вставить("РучноеИзменение", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураПолей()
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("БИК", "");
	СтруктураПолей.Вставить("СВИФТБИК", "");
	СтруктураПолей.Вставить("КоррСчет", "");
	СтруктураПолей.Вставить("Наименование", "");
	СтруктураПолей.Вставить("НаименованиеМеждународное", "");
	СтруктураПолей.Вставить("Страна", Неопределено);
	СтруктураПолей.Вставить("Город", "");
	СтруктураПолей.Вставить("ГородМеждународный", "");
	СтруктураПолей.Вставить("Регион", "");
	СтруктураПолей.Вставить("КодРегиона", "");
	СтруктураПолей.Вставить("Адрес", "");
	СтруктураПолей.Вставить("АдресМеждународный", "");
	СтруктураПолей.Вставить("Телефоны", "");
	
	Возврат СтруктураПолей;
	
КонецФункции

#КонецОбласти