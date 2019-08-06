
&НаКлиенте
Перем КэшСвойстваДинамическогоСписка;

&НаКлиенте
Перем КэшОграничениеТипов;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Список.Параметры.УстановитьЗначениеПараметра("АктуальнаяДатаСеанса", НачалоДня(ТекущаяДатаСеанса()));
	
	// Заполним список выбора периода.
	ПериодСписокВыбора = CRM_ОбщегоНазначенияПовтИсп.ПериодПолучитьСписокВыбора();
	
	Для каждого ЭлементСписка Из ПериодСписокВыбора Цикл
		Элементы.ОтборПериод.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;	
		
	ЭтаФорма.ОтборПериод = "НеВыбран";
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Пользователь = Настройки.Получить("ОтборПользователь");
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Ответственный", Пользователь, Истина);
		
	КонецЕсли;	

	НастройкаПериод = Настройки.Получить("Период");
	НастройкаОтборПериод =  Настройки.Получить("ОтборПериод");
		
	Если НастройкаПериод <> Неопределено И НастройкаОтборПериод <> "НеВыбран" Тогда  
		
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Дата", НастройкаПериод, Истина);
		
		Если НастройкаПериод.Вариант =  ВариантСтандартногоПериода.ПроизвольныйПериод Тогда
			
			ПериодСтрокойДатаНачала	   = НастройкаПериод.ДатаНачала;
			ПериодСтрокойДатаОкончания = НастройкаПериод.ДатаОкончания;			
			
			ЭлементСпискаПериодСтрокой = Элементы.ОтборПериод.СписокВыбора.Вставить(1,"ПериодСтрокой");		
			ЭлементСпискаПериодСтрокой.Представление = ПредставлениеПериода(НастройкаПериод.ДатаНачала, НастройкаПериод.ДатаОкончания);
			
		КонецЕсли;	
		
	КонецЕсли;
	
	Статус = Настройки.Получить("ОтборСтатус");
	
	// Установить отборы для статуса сделки.
	Если Статус = "ВсеСделки" ИЛИ Статус = "" Тогда
		
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние");
		
	Иначе
		
		Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		
			CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние", Статус, Истина);
			
		Иначе
				
			Если Статус = "ВРаботе" Тогда
				CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние", Перечисления.СтатусыСделок.ВРаботе, Истина);
			ИначеЕсли Статус = "Проиграна" Тогда
				CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние", Перечисления.СтатусыСделок.Проиграна, Истина);
			ИначеЕсли Статус = "Выиграна" Тогда
				CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние", Перечисления.СтатусыСделок.Выиграна, Истина);
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	
	Клиент = Настройки.Получить("ОтборКлиент");
	
	Если ЗначениеЗаполнено(Клиент) Тогда
		
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Клиент", Клиент, Истина);
		
	КонецЕсли;

КонецПроцедуры

#Область БыстрыеОтборы

&НаКлиенте
Процедура ОтборПользовательПриИзменении(Элемент)
	Если ОтборПользователь.Пустая() Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Ответственный");			
	Иначе	
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Ответственный", ОтборПользователь, Истина);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПериода(ВыбранныйПериод = Неопределено)
	Если ВыбранныйПериод <> Неопределено Тогда
		ЗначениеСтандартногоПериода = Неопределено;
		Для Каждого ЗначениеСписка Из Элементы.ОтборПериод.СписокВыбора Цикл
			Попытка
				Если ВариантСтандартногоПериода[ЗначениеСписка.Значение] = ВыбранныйПериод.Вариант Тогда
					ЗначениеСтандартногоПериода = ЗначениеСписка.Значение;
					Прервать;
				КонецЕсли;
			Исключение
			КонецПопытки;
		КонецЦикла;
		Если ЗначениеСтандартногоПериода = Неопределено Тогда
			ОтборПериод = "НеВыбран";
		Иначе
			ОтборПериод = ЗначениеСтандартногоПериода;
		КонецЕсли;
	КонецЕсли;
	
	Если ОтборПериод = "НеВыбран" ИЛИ ОтборПериод = "" Тогда
		
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Дата");
		ОтборПериод = "НеВыбран";
		
		Период = Новый СтандартныйПериод;
		
	ИначеЕсли ОтборПериод = "ПериодСтрокой" Тогда
		
		Период = Новый СтандартныйПериод;
		Период.ДатаНачала 	 = ПериодСтрокойДатаНачала;
		Период.ДатаОкончания = ПериодСтрокойДатаОкончания;
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Дата", Период, Истина);
		
	ИначеЕсли ОтборПериод = "ПроизвольныйПериод" Тогда
		
		Если ВыбранныйПериод = Неопределено Тогда
			ФормаРедактирования = ПолучитьФорму("ОбщаяФорма.CRM_ФормаРедактированияПроизвольногоПериода");
			
			ФормаРедактирования.Период = Период;
			
			НовыйПериод = ФормаРедактирования.ОткрытьМодально();
			
			Если НовыйПериод = Неопределено ИЛИ НовыйПериод = КодВозвратаДиалога.Отмена Тогда
				Возврат
			КонецЕсли;	
		Иначе
			НовыйПериод = ВыбранныйПериод;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НовыйПериод.ДатаНачала) ИЛИ  ЗначениеЗаполнено(НовыйПериод.ДатаОкончания) Тогда
			
			ЭлементСпискаПериодСтрокой = Элементы.ОтборПериод.СписокВыбора.НайтиПоЗначению("ПериодСтрокой");
			Если  ЭлементСпискаПериодСтрокой = Неопределено Тогда					
				ЭлементСпискаПериодСтрокой = Элементы.ОтборПериод.СписокВыбора.Вставить(1,"ПериодСтрокой");
			КонецЕсли;
			
			ЭлементСпискаПериодСтрокой.Представление = ПредставлениеПериода(НовыйПериод.ДатаНачала, НовыйПериод.ДатаОкончания);
			
			ПериодСтрокойДатаНачала	   = НовыйПериод.ДатаНачала;
			ПериодСтрокойДатаОкончания = НовыйПериод.ДатаОкончания;			
			
			ОтборПериод = "ПериодСтрокой";	
			
		Иначе
			
			ЭлементСпискаПериодСтрокой = Элементы.ОтборПериод.СписокВыбора.НайтиПоЗначению("ПериодСтрокой");
			Если  ЭлементСпискаПериодСтрокой <> Неопределено Тогда					
				Элементы.ОтборПериод.СписокВыбора.Удалить(ЭлементСпискаПериодСтрокой);
			КонецЕсли;

			ОтборПериод = "НеВыбран";
			
		КонецЕсли;
		
		Период = НовыйПериод;
		
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Дата", Период, Истина);

	Иначе	
		
		Период = Новый СтандартныйПериод;		
		Период.Вариант = ВариантСтандартногоПериода[ОтборПериод];
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Дата", Период, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодПриИзменении(Элемент)
	
	ПриИзмененииПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Дата");
	ОтборПериод = "НеВыбран";
	Период = Новый СтандартныйПериод();
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	Если ОтборСтатус = "ВсеСделки" Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние");
	Иначе
		
		Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
			
			CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние", Элемент.ТекстРедактирования, Истина);
			
		Иначе
			
			Если ОтборСтатус = "ВРаботе" Тогда
				CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние", ПредопределенноеЗначение("Перечисление.СтатусыСделок.ВРаботе"), Истина);
			ИначеЕсли ОтборСтатус = "Проиграна" Тогда
				CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние", ПредопределенноеЗначение("Перечисление.СтатусыСделок.Проиграна"), Истина);
			ИначеЕсли ОтборСтатус = "Выиграна" Тогда
				CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Состояние", ПредопределенноеЗначение("Перечисление.СтатусыСделок.Выиграна"), Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборКлиентПриИзменении(Элемент)
	Если ОтборКлиент.Пустая() Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Клиент");
	Иначе	
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Клиент", ОтборКлиент, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция НастройкаПоляОтображенияСодержанияПолучитьОграничениеТиповСпискаСервер()
	Возврат CRM_ОбщегоНазначенияСервер.НастройкиПолейОтображенияСодержанияПолучитьОписаниеТиповДляСписка(Список.ОсновнаяТаблица);
КонецФункции

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// Поле отображения содержания.
	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОжиданияСписокПриАктивизацииСтроки", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияСписокПриАктивизацииСтроки()
	
	Если Элементы.ГруппаПолеОтображенияСодержания.Видимость Тогда
		// Поле отображения содержания.
		CRM_ОбщегоНазначенияКлиент.НастройкиПолейОтображенияСодержанияПриАктивизацииСтроки(ЭтаФорма, Элементы.Список.ТекущаяСтрока, НастройкаПоляОтображенияСодержанияПолучитьОграничениеТиповСписка());
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Поле отображения содержания.

&НаКлиенте
Процедура КомандаПоказатьСкрытьПолеОтображенияСодержания(Команда)
	CRM_ОбщегоНазначенияКлиент.НастройкиПолейОтображенияСодержанияПоказатьСкрытьПолеОтображенияСодержания(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Функция НастройкаПоляОтображенияСодержанияПолучитьОграничениеТиповСписка()
	Если ТипЗнч(КэшОграничениеТипов) <> Тип("ОписаниеТипов") Тогда
		КэшОграничениеТипов = НастройкаПоляОтображенияСодержанияПолучитьОграничениеТиповСпискаСервер();
	КонецЕсли;
	Возврат КэшОграничениеТипов;
КонецФункции

&НаКлиенте
Процедура ПолеОтображениеСодержанияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	// Поле отображения содержания.
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		тОбъект = Элементы.Список.ТекущиеДанные.Ссылка;
	Иначе
		тОбъект = Неопределено;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КалендарьДетальноеОписаниеПриНажатииЗавершение", ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиент.НастройкиПолейОтображенияСодержанияПолеСодержаниеПриНажатии(ДанныеСобытия, СтандартнаяОбработка, НастройкаПоляОтображенияСодержанияПолучитьОграничениеТиповСписка(), тОбъект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КалендарьДетальноеОписаниеПриНажатииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Подключаемый_ОбработчикОжиданияСписокПриАктивизацииСтроки();
	КонецЕсли;
	
КонецПроцедуры
