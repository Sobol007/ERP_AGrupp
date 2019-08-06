#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	
	Возврат Результат;
	
КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	//Организация
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	Результат.Вывести(ОбластьОрганизация);
	
	//Заголовок
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета);
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
	// Единица измерения
	Если ПараметрыОтчета.Свойство("ВыводитьЕдиницуИзмерения")
		И ПараметрыОтчета.ВыводитьЕдиницуИзмерения Тогда
		ОбластьОписаниеЕдиницыИзмерения = Макет.ПолучитьОбласть("ОписаниеЕдиницыИзмерения");
		Результат.Вывести(ОбластьОписаниеЕдиницыИзмерения);
	КонецЕсли;
	
	ПараметрыОтчета.Вставить("ВысотаШапки", Результат.ВысотаТаблицы);
	
КонецПроцедуры

Функция НайтиПоИмени(Структура, Имя)
	
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат Группировка;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Группировка;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Справка-расчет налога на имущество %1';
			|en = 'Detailed calculation of property tax %1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			НачалоГода(ПараметрыОтчета.Период),
			КонецДня(ПараметрыОтчета.Период)));
	
КонецФункции

Процедура ДобавитьВыбранныеПоля(ВыбранныеПоля, ВыбранныеЭлементыТаблицыГруппировок)
	
	Для каждого ВыбранноеПоле Из ВыбранныеЭлементыТаблицыГруппировок Цикл
		Если ТипЗнч(ВыбранноеПоле) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
			Поле = ВыбранныеПоля.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(Поле, ВыбранноеПоле);
		ИначеЕсли ТипЗнч(ВыбранноеПоле) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			КоллекцияПолей = ВыбранныеПоля.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			КоллекцияПолей.Заголовок = ВыбранноеПоле.Заголовок;
			ДобавитьВыбранныеПоля(КоллекцияПолей.Элементы, ВыбранноеПоле.Элементы);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Период) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Период", ПараметрыОтчета.Период);
	КонецЕсли;
	
	МассивГруппировок = Новый Массив;
	МассивГруппировок.Добавить("СреднегодоваяСтоимость");
	
	Если ПараметрыОтчета.Период < '20190101' Тогда
		ГруппировкаКомпоновкиДанныхКУдалению = КомпоновщикНастроек.Настройки.Структура[2];
		МассивГруппировок.Добавить("КадастроваяСтоимость2013");
	Иначе
		ГруппировкаКомпоновкиДанныхКУдалению = КомпоновщикНастроек.Настройки.Структура[1];
		МассивГруппировок.Добавить("КадастроваяСтоимость2019");
	КонецЕсли;
	КомпоновщикНастроек.Настройки.Структура.Удалить(ГруппировкаКомпоновкиДанныхКУдалению);
	
	Для инд = 0 По 1 Цикл
		ТаблицаГруппировок = КомпоновщикНастроек.Настройки.Структура[инд].Структура[0];
		ТаблицаГруппировок.Строки.Очистить();
		СтруктураГруппировок = Новый Структура("Структура", ТаблицаГруппировок.Строки);
		
		ГуппировкаПоОКТМО = ПараметрыОтчета.Группировка.Найти("КодПоОКТМО");
		УстановленаГруппировкаПоОКТМО = ГуппировкаПоОКТМО <> Неопределено И ГуппировкаПоОКТМО.Использование;
		
		КоличествоГруппировок = 0;
		Для каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл
			Если ПолеВыбраннойГруппировки.Использование Тогда
				Структура = СтруктураГруппировок.Структура.Добавить();
				ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировки.Использование  = Истина;
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
				Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
					ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
				ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
					ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
				Иначе
					ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
				КонецЕсли;
				
				НастройкаВыводаИтогов = Структура.ПараметрыВывода.Элементы.Найти("РасположениеИтогов");
				
				Если КоличествоГруппировок = 0 Тогда
					Структура.Имя = МассивГруппировок[инд];
					НастройкаВыводаИтогов.Использование = Ложь;
				Иначе
					НастройкаВыводаИтогов.Использование = Истина;
					НастройкаВыводаИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Авто;
				КонецЕсли;
				
				Если ПолеВыбраннойГруппировки.Предопределенная ИЛИ ПолеВыбраннойГруппировки.Поле = "ОсновноеСредство" Тогда
					ВыбранноеПоле = Структура.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
					ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("СистемныеПоля.НомерПоПорядку");
					
					НастройкаВыводаИтогов.Использование = Истина;
					Если КоличествоГруппировок = 0 Тогда
						НастройкаВыводаИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Конец;
					Иначе
						НастройкаВыводаИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Нет;
					КонецЕсли;
					
					Если УстановленаГруппировкаПоОКТМО Тогда
						Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
						
						ПолеИтогаДоляСтоимости = Схема.ПоляИтога.Найти("ДоляСтоимости");
						Если ПолеИтогаДоляСтоимости = Неопределено Тогда
							ПолеИтогаДоляСтоимости = Схема.ПоляИтога.Добавить();
							ПолеИтогаДоляСтоимости.Выражение = "ЕстьNull(ДоляСтоимости, """")";
							ПолеИтогаДоляСтоимости.ПутьКДанным = "ДоляСтоимости";
							ПолеИтогаДоляСтоимости.Группировки.Добавить("ОсновноеСредство");
						КонецЕсли;
						
						ВыбранноеПоле = Структура.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
						ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ОсновноеСредство");
						
						ДобавитьВыбранныеПоля(Структура.Выбор.Элементы, ТаблицаГруппировок.Выбор.Элементы);
					Иначе
						ВыбранноеПоле = Структура.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
						ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ОсновноеСредство");
						
						ДобавитьВыбранныеПоля(Структура.Выбор.Элементы, ТаблицаГруппировок.Выбор.Элементы);
						
						ПолеКомпоновкиДоляСтоимости = Новый ПолеКомпоновкиДанных("ДоляСтоимости");
						ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
						ПолеГруппировки.Использование  = Истина;
						ПолеГруппировки.Поле           = ПолеКомпоновкиДоляСтоимости;
						
						ПолеИтогаДоляСтоимости = Схема.ПоляИтога.Найти("ДоляСтоимости");
						Если ПолеИтогаДоляСтоимости <> Неопределено Тогда
							Схема.ПоляИтога.Удалить(ПолеИтогаДоляСтоимости);
						КонецЕсли;
						
					КонецЕсли;
					
					ПолеКомпоновкиНалоговаяСтавка = Новый ПолеКомпоновкиДанных("НалоговаяСтавка");
					ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
					ПолеГруппировки.Использование  = Истина;
					ПолеГруппировки.Поле           = ПолеКомпоновкиНалоговаяСтавка;
					
					ПолеИтогаНалоговаяСтавка = Схема.ПоляИтога.Найти("НалоговаяСтавка");
					Если ПолеИтогаНалоговаяСтавка <> Неопределено Тогда
						Схема.ПоляИтога.Удалить(ПолеИтогаНалоговаяСтавка);
					КонецЕсли;
						
					Если Инд = 1 Тогда
						ПолеКомпоновкиКадастроваяСтоимость = Новый ПолеКомпоновкиДанных("КадастроваяСтоимость");
						ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
						ПолеГруппировки.Использование  = Истина;
						ПолеГруппировки.Поле           = ПолеКомпоновкиКадастроваяСтоимость;
						
						ПолеИтогаКадастроваяСтоимость = Схема.ПоляИтога.Найти("КадастроваяСтоимость");
						Если ПолеИтогаКадастроваяСтоимость <> Неопределено Тогда
							Схема.ПоляИтога.Удалить(ПолеИтогаКадастроваяСтоимость);
						КонецЕсли;
					КонецЕсли;
					
				Иначе
					Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
				КонецЕсли;
				
				Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
				
				СтруктураГруппировок = Структура;
				КоличествоГруппировок = КоличествоГруппировок + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	Если ПараметрыОтчета.Свойство("ВысотаШапки") Тогда
		ВысотаШапки = ПараметрыОтчета.ВысотаШапки;
	Иначе
		ВысотаШапки = 0;
	КонецЕсли;
	
	Для каждого ЭлементТелаМакета Из МакетКомпоновки.Тело Цикл
		Если ТипЗнч(ЭлементТелаМакета) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ПараметрыОтчета.Вставить("ВысотаШапки", МакетКомпоновки.Макеты[ЭлементТелаМакета.МакетШапки].Макет.Количество() + ВысотаШапки);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТекстШапкиГруппировок(Группировки)
	
	ТекстШапки = "";
	Для каждого Группа Из Группировки Цикл
		Если Группа.Использование Тогда
			ТекстШапки = ТекстШапки + ?(ПустаяСтрока(ТекстШапки), "", ", ") + Группа.Представление;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТекстШапки;
	
КонецФункции

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	Если ПараметрыОтчета.Свойство("ВысотаШапки") Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
	ТекстШапкиГруппировок = ПолучитьТекстШапкиГруппировок(ПараметрыОтчета.Группировка);
	Группировки1 = Результат.НайтиТекст("###Группировки1###");
	Если Группировки1 <> Неопределено Тогда
		Результат.Область(, 5, ?(ПараметрыОтчета.ВыводитьЕдиницуИзмерения, 7, 6), 17).Сгруппировать(
			"РасшифровкаСреднегодовойСтоимости", РасположениеЗаголовкаГруппировкиТабличногоДокумента.Начало);
		Группировки1.Текст = ТекстШапкиГруппировок;
		Результат.ТекущаяОбласть = Группировки1;
	КонецЕсли;
	
	Группировки2 = Результат.НайтиТекст("###Группировки2###");
	Если Группировки2 <> Неопределено Тогда
		Группировки2.Текст = ТекстШапкиГруппировок;
	Иначе
		Результат.ФиксацияСверху = Результат.ФиксацияСверху + ?(Группировки1 = Неопределено, 0, 4);
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Результат.ФиксацияСлева = 0;
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецЕсли
