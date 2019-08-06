
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("УникальныйИдентификатор") Тогда
		ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	Иначе
		ИдентификаторВызывающейФормы = Новый УникальныйИдентификатор;
	КонецЕсли;
	Если Параметры.Свойство("АдресМоделиПланирования") Тогда
		ПрочитатьМоделиПланирования(Параметры.АдресМоделиПланирования);
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ДанныеКорректны = МоделиЗаполненыКорректно();
	Если ДанныеКорректны Тогда
		
		Результат = РезультатЗакрытияФормы();
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьМоделиПланирования(АдресМоделиПланирования)
	
	Если ЭтоАдресВременногоХранилища(АдресМоделиПланирования) Тогда
		ИсточникЗаполнения = ПолучитьИзВременногоХранилища(АдресМоделиПланирования);
		Если ТипЗнч(ИсточникЗаполнения) = Тип("ТаблицаЗначений") Тогда
			МоделиПланирования.Загрузить(ИсточникЗаполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция МоделиЗаполненыКорректно()
	
	Результат = Истина;
	Ошибки = Неопределено;
	ВыбранныеМодели = Новый Массив;
	
	Для Каждого Строка Из МоделиПланирования Цикл
		Если НЕ ЗначениеЗаполнено(Строка.МодельПланирования) Тогда
			
			Результат = Ложь;
			
			ИмяПоля = НСтр("ru = 'Модель планирования';
							|en = 'Planning model'");
			НомерСтроки = МоделиПланирования.Индекс(Строка);
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", ИмяПоля, НомерСтроки);
			
			Поле = "МоделиПланирования[%1].МодельПланирования";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстОшибки, Неопределено, НомерСтроки);
			
		ИначеЕсли НЕ ВыбранныеМодели.Найти(Строка.МодельПланирования) = Неопределено Тогда
			
			Результат = Ложь;
			
			ИмяПоля = НСтр("ru = 'Модель планирования';
							|en = 'Planning model'");
			НомерСтроки = МоделиПланирования.Индекс(Строка);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Модель ""%1"" выбрана более одного раза.';
					|en = 'The ""%1"" model is selected more than once.'"), Строка.МодельПланирования);
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность", ИмяПоля, НомерСтроки,, ТекстСообщения);
			
			Поле = "МоделиПланирования[%1].МодельПланирования";
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстОшибки, Строка.МодельПланирования, НомерСтроки, ТекстОшибки);
			
		Иначе
			
			ВыбранныеМодели.Добавить(Строка.МодельПланирования);
			
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РезультатЗакрытияФормы()
	
	ТаблицаМодели = МоделиПланирования.Выгрузить();
	Результат = ПоместитьВоВременноеХранилище(ТаблицаМодели, ИдентификаторВызывающейФормы);
	Возврат Результат;
	
КонецФункции

#КонецОбласти
