
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	РучноеИзменение = Ложь;
	ВКлассификаторе = Ложь;
	БИК			 = "";
	КоррСчет	 = "";
	Наименование = "";
	Город		 = "";
	Адрес		 = "";
	Телефоны	 = "";
	Регион		 = "";
	КодРегиона	 = ""; 
	
	Если Не Параметры.Свойство("РучноеИзменение") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	РучноеИзменение = Параметры.РучноеИзменение;
	РеквизитВладельца = Параметры.Реквизит;
	
	Если Параметры.ЗначенияПолей.Свойство("БИК") Тогда
		БИК	= Параметры.ЗначенияПолей.БИК;
	КонецЕсли;
	
	Если Параметры.ЗначенияПолей.Свойство("КоррСчет") Тогда
		КоррСчет = Параметры.ЗначенияПолей.КоррСчет;
	КонецЕсли;	
	
	Если ПустаяСтрока(РучноеИзменение) Тогда
		РучноеИзменение = Ложь;
	КонецЕсли;	
	
	Если РучноеИзменение Тогда
		БИК			 = Параметры.ЗначенияПолей.БИК;
		КоррСчет	 = Параметры.ЗначенияПолей.КоррСчет;
		Наименование = Параметры.ЗначенияПолей.Наименование;
		Город		 = Параметры.ЗначенияПолей.Город;
		Адрес		 = Параметры.ЗначенияПолей.Адрес;
		Телефоны	 = Параметры.ЗначенияПолей.Телефоны;
	Иначе
		Банк = Параметры.Банк;
		Если ТипЗнч(Банк) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
			БИК				= Банк.Код;
			КоррСчет		= Банк.КоррСчет;
			Наименование	= Банк.Наименование;
			Город			= Банк.Город;
			Адрес			= Банк.Адрес;
			Телефоны		= Банк.Телефоны;
			Регион			= Банк.Родитель;
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
	Закрыть();
	ОповеститьОВыборе(ПолучитьЗначенияПараметров());
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	БылиНажатыКнопкиЗакрытия = Истина;
	Закрыть();
	
КонецПроцедуры

#Область ВспомогательныеПроцедурыИФункции

Процедура ОбработатьФлагРучногоИзменения()
	
	Если РучноеИзменение Тогда
		Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Автоматическое обновление элемента отключено.';
													|en = 'Automatic item update is disabled.'");
		ТолькоПросмотр = Ложь;
	Иначе
		Если ВКлассификаторе Тогда
			Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Элемент обновляется автоматически.';
														|en = 'Item is updated automatically.'");
			ТолькоПросмотр = Истина;
		Иначе
			Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Элемент не найден в классификаторе.Автоматическое обновление элемента отключено.';
														|en = 'Item is not found in the classifier. Automatic item update is disabled.'");
			ТолькоПросмотр = Ложь;
        КонецЕсли;	
	КонецЕсли;	
    
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗначенияПараметров()
	
	Результат = Новый Структура;
	Результат.Вставить("Реквизит", РеквизитВладельца);
	
	Если РучноеИзменение Тогда
	    Результат.Вставить("РучноеИзменение", РучноеИзменение);
		ЗначенияПолей = Новый Структура;
		ЗначенияПолей.Вставить("БИК", БИК);
		ЗначенияПолей.Вставить("Наименование", Наименование);
		ЗначенияПолей.Вставить("КоррСчет", КоррСчет);
		ЗначенияПолей.Вставить("Город", Город);
		ЗначенияПолей.Вставить("Адрес", Адрес);
		ЗначенияПолей.Вставить("Телефоны", Телефоны);
		ЗначенияПолей.Вставить("РучноеИзменение", РучноеИзменение);
		
		Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
    Иначе
		Если ВКлассификаторе Тогда
		    Результат.Вставить("РучноеИзменение", РучноеИзменение);
			Результат.Вставить("Банк", Банк);
		Иначе 
			Результат.Вставить("РучноеИзменение", Истина);
			ЗначенияПолей = Новый Структура;
			ЗначенияПолей.Вставить("БИК", БИК);
			ЗначенияПолей.Вставить("Наименование", Наименование);
			ЗначенияПолей.Вставить("КоррСчет", КоррСчет);
			ЗначенияПолей.Вставить("Город", Город);
			ЗначенияПолей.Вставить("Адрес", Адрес);
			ЗначенияПолей.Вставить("Телефоны", Телефоны);
			ЗначенияПолей.Вставить("РучноеИзменение", РучноеИзменение);
			
			Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
        КонецЕсли;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

