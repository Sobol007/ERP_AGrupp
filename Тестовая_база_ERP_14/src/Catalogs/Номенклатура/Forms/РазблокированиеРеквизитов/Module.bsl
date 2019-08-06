
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Скроем реквизиты, отключенные функциональными опциями
	РеквизитыФормы 			= ПолучитьРеквизиты();
	НеиспользуемыеРеквизиты = Справочники.Номенклатура.РеквизитыОтключенныеПоФО();
	
	ПрефиксИмениРеквизита   = "РазрешитьРедактирование";
	
	Для Каждого Реквизит Из РеквизитыФормы Цикл
		
		Если СтрНайти(Реквизит.Имя, ПрефиксИмениРеквизита) <> 1 Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяРеквизитаНоменклатуры = Сред(Реквизит.Имя, СтрДлина(ПрефиксИмениРеквизита) + 1);
		РеквизитИспользуется 	 = (НеиспользуемыеРеквизиты.Найти(ИмяРеквизитаНоменклатуры) = Неопределено);
		
		ЭтаФорма[Реквизит.Имя] 			 = РеквизитИспользуется;
		Элементы[Реквизит.Имя].Видимость = РеквизитИспользуется;
		
		ИменаРеквизитовФормы.Добавить(Реквизит.Имя, ИмяРеквизитаНоменклатуры); // кэш
		
	КонецЦикла;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	// Для всех включенных флажков сформируем массив соответствующих им реквизитов номенклатуры.
	Результат = Новый Массив;
	
	Для Каждого Реквизит Из ИменаРеквизитовФормы Цикл
		
		Если ЭтаФорма[Реквизит.Значение] Тогда
			Результат.Добавить(Реквизит.Представление);
		КонецЕсли;
		
	КонецЦикла;
	
	// Некоторые флажки управляют несколькими реквизитами номенклатуры
	Если РазрешитьРедактированиеНаборУпаковок Тогда
		Результат.Добавить("ИспользоватьУпаковки");
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
