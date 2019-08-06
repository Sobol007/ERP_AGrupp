
#Область ОписаниеПеременных

&НаКлиенте
Перем ПредыдущаяВыделеннаяОбластьКалендаря;
&НаКлиенте
Перем НеОбрабатыватьАктивизациюОбластиКалендаря;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокСобытий") Тогда
		
		СписокВыбранныхСобытий = Параметры.СписокСобытий;
		
		Если ТипЗнч(СписокВыбранныхСобытий) = Тип("СписокЗначений") Тогда
			
			ТабличныйДокумент.Очистить();
			МакетЯчейки = РеквизитФормыВЗначение("Объект").ПолучитьМакет("КалендарьЯчейки");
			ТабДокументСобытие = МакетЯчейки.ПолучитьОбласть("R1C1:R1C48");
			
			ОбластьСобытие = ТабДокументСобытие.Область(1, 1, ТабДокументСобытие.ВысотаТаблицы, ТабДокументСобытие.ШиринаТаблицы);
			ОбластьСобытие.Объединить();
			
			ЛинияСобытие = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьСобытие.Обвести(ЛинияСобытие, ЛинияСобытие, ЛинияСобытие, ЛинияСобытие);
			
			Для Каждого ЭлементСписка Из СписокВыбранныхСобытий Цикл
				НоваяРасшифровка = ТаблицаРасшифровок.Добавить();
				НоваяРасшифровка.Событие = ЭлементСписка.Значение.Событие;
				НоваяРасшифровка.ИдентификаторСобытия = ЭлементСписка.Значение.ИдентификаторСобытия;
				ОбластьСобытие.Расшифровка = ТаблицаРасшифровок.Индекс(НоваяРасшифровка);
				
				ОбластьСобытие.ЦветФона = ЭлементСписка.Значение.ЦветФона;
				ОбластьСобытие.ЦветТекста = ЭлементСписка.Значение.ЦветТекста;
				ОбластьСобытие.Шрифт = ЭлементСписка.Значение.Шрифт;
				ОбластьСобытие.Текст = ЭлементСписка.Представление;
				
				ТабличныйДокумент.Вывести(ТабДокументСобытие);
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;	
	
	КалендарьДетальноеОписание = CRM_ОбщегоНазначенияКлиентСервер.НастройкиПолейОтображенияСодержанияПолучитьПустоеСодержание();
	
	Если Параметры.Свойство("ДатаДень") Тогда
		
		ДатаДень = Параметры.ДатаДень;
		
		Если ТипЗнч(ДатаДень) = Тип("Дата") Тогда
			
			Заголовок = Формат(ДатаДень, "ДФ='дд ММММ гггг'") + " " + НСтр("ru='г';en='0'");
			
		КонецЕсли;
		
	КонецЕсли;	
	
	Если Параметры.Свойство("ОписаниеТиповРегистрируемыхОбъектов") Тогда
		
		ОписаниеТиповРегистрируемыхОбъектов = Параметры.ОписаниеТиповРегистрируемыхОбъектов;
		
	КонецЕсли;	
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Попытка
		бЗакрыть = (ИмяСобытия = "ОбновленыДанныеСобытия" И Источник.ВладелецФормы = ВладелецФормы);
	Исключение
		бЗакрыть = Ложь;
	КонецПопытки;
	
	Если бЗакрыть Тогда
		Закрыть();
		ВладелецФормы.Активизировать();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТабличныйДокументПриАктивизацииОбласти(Элемент)
	Если НеОбрабатыватьАктивизациюОбластиКалендаря = Истина Тогда
		НеОбрабатыватьАктивизациюОбластиКалендаря = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекущаяОбласть = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Если ТекущаяОбласть = Неопределено Тогда Возврат; КонецЕсли;
	
	Если ТипЗнч(ТекущаяОбласть.Расшифровка) <> Тип("Число") Тогда
		Попытка
			НеОбрабатыватьАктивизациюОбластиКалендаря = Истина;
			Элементы.ТабличныйДокумент.ТекущаяОбласть = ПредыдущаяВыделеннаяОбластьКалендаря;
		Исключение
			НеОбрабатыватьАктивизациюОбластиКалендаря = Ложь;
		КонецПопытки;
	Иначе
		ПредыдущаяВыделеннаяОбластьКалендаря = ТекущаяОбласть;
	КонецЕсли;
	Если НеОбрабатыватьАктивизациюОбластиКалендаря = Истина Тогда Возврат; КонецЕсли;
	
	Попытка
		Расшифровка = ТекущаяОбласть.Расшифровка;
	Исключение
		Расшифровка = Неопределено;
	КонецПопытки;
	
	Если ТипЗнч(ТекущаяОбласть.Расшифровка) = Тип("Число") Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьПолеКалендарьДетальноеОписание", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Расшифровка) = Тип("Число") Тогда
		ЗначениеРасшифровки = Расшифровка;
	ИначеЕсли ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
		// Нужно для WEB-клиента, если расшифровка назначена картинке а не области.
		Попытка		ЗначениеРасшифровки = Число(Строка(Расшифровка));
		Исключение	ЗначениеРасшифровки = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("Число") Тогда
		Попытка		ЗначениеРасшифровки = ТаблицаРасшифровок[ЗначениеРасшифровки];
		Исключение	ЗначениеРасшифровки = Неопределено;
		КонецПопытки;
		Если ЗначениеРасшифровки <> Неопределено Тогда
			Если ЗначениеЗаполнено(ЗначениеРасшифровки.Событие) Тогда
				ОткрытьФормуСобытия(ЗначениеРасшифровки.Событие);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КалендарьДетальноеОписаниеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	// Поле отображения содержания.
	тОбъект = Неопределено;
	ТекущаяОбласть = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Если ТекущаяОбласть <> Неопределено Тогда 
		СобытиеВРасшифровке = Неопределено;
		Если ТипЗнч(ТекущаяОбласть.Расшифровка) = Тип("Число") Тогда
			Попытка		ЗначениеРасшифровки = ТаблицаРасшифровок[ТекущаяОбласть.Расшифровка];
			Исключение	ЗначениеРасшифровки = Неопределено;
			КонецПопытки;
			Если ЗначениеРасшифровки <> Неопределено Тогда
				СобытиеВРасшифровке = ЗначениеРасшифровки.Событие;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СобытиеВРасшифровке) Тогда
			тОбъект = СобытиеВРасшифровке;
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КалендарьДетальноеОписаниеПриНажатииЗавершение", ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиент.НастройкиПолейОтображенияСодержанияПолеСодержаниеПриНажатии(ДанныеСобытия, СтандартнаяОбработка, ОписаниеТиповРегистрируемыхОбъектов, тОбъект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КалендарьДетальноеОписаниеПриНажатииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Подключаемый_ОбновитьПолеКалендарьДетальноеОписание();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаУдалить(Команда)
	ТекущаяОбласть = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Если ТекущаяОбласть = Неопределено Тогда Возврат; КонецЕсли;
	
	МассивСобытий = Новый Массив();
	
	Для нСтрока = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
		Область = ТабличныйДокумент.Область(нСтрока, 1, нСтрока, 1);
		Если ТипЗнч(Область.Расшифровка) = Тип("Число") Тогда
			Попытка		ЗначениеРасшифровки = ТаблицаРасшифровок[Область.Расшифровка];
			Исключение	ЗначениеРасшифровки = Неопределено;
			КонецПопытки;
			Если ЗначениеРасшифровки <> Неопределено Тогда
				Если МассивСобытий.Найти(ЗначениеРасшифровки.ИдентификаторСобытия) = Неопределено Тогда
					МассивСобытий.Добавить(ЗначениеРасшифровки.ИдентификаторСобытия);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСобытий.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандаУдалитьЗавершение", ЭтотОбъект, МассивСобытий);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Удалить выбранные объекты?';en='Delete the select objects?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалитьЗавершение(Ответ, МассивСобытий) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Закрыть(Новый Структура("УдалитьСобытия,МассивСобытий", Истина, МассивСобытий));
		ВладелецФормы.Активизировать();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьПолеКалендарьДетальноеОписаниеСервер(СсылкаНаОбъект)
	КалендарьДетальноеОписание = CRM_ОбщегоНазначенияСервер.НастройкиПолейОтображенияСодержанияПолучитьСодержание(СсылкаНаОбъект, ОписаниеТиповРегистрируемыхОбъектов);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьОписаниеРегистрируемогоОбъектаКлиент(ЗначениеОбъекта)
	Тип = ТипЗнч(ЗначениеОбъекта);
	
	Для Каждого СтрокаТаблицы Из ВладелецФормы.ТаблицаРегистрируемыхОбъектов Цикл
		Если СтрокаТаблицы.Тип.СодержитТип(Тип) Тогда
			Возврат СтрокаТаблицы;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуСобытия(Событие)
	ОписаниеОбъекта = ПолучитьОписаниеРегистрируемогоОбъектаКлиент(Событие);
	
	бОткрытьЗначение = Ложь;
	
	Если ОписаниеОбъекта = Неопределено Тогда
		бОткрытьЗначение = Истина;
	Иначе
		СтруктураПараметры = Новый Структура("Ключ", Событие);
		ОткрытьФорму(ОписаниеОбъекта.ПолноеИмя + ".ФормаОбъекта", СтруктураПараметры, ВладелецФормы);
	КонецЕсли;
	
	Если бОткрытьЗначение Тогда // На крайний случай пробуем открыть объект так.
		Попытка ПоказатьЗначение(, Событие);
		Исключение КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьПолеКалендарьДетальноеОписание()
	ТекущаяОбласть = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Если ТекущаяОбласть = Неопределено Тогда Возврат; КонецЕсли;
	
	СобытиеВРасшифровке = Неопределено;
	Если ТипЗнч(ТекущаяОбласть.Расшифровка) = Тип("Число") Тогда
		Попытка		ЗначениеРасшифровки = ТаблицаРасшифровок[ТекущаяОбласть.Расшифровка];
		Исключение	ЗначениеРасшифровки = Неопределено;
		КонецПопытки;
		Если ЗначениеРасшифровки <> Неопределено Тогда
			СобытиеВРасшифровке = ЗначениеРасшифровки.Событие;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СобытиеВРасшифровке) Тогда
		ОбновитьПолеКалендарьДетальноеОписаниеСервер(СобытиеВРасшифровке);
	Иначе
		ДетальноеОписаниеПустое = CRM_ОбщегоНазначенияКлиентСервер.НастройкиПолейОтображенияСодержанияПолучитьПустоеСодержание();
		Если ДетальноеОписаниеПустое <> КалендарьДетальноеОписание Тогда
			КалендарьДетальноеОписание = ДетальноеОписаниеПустое;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
