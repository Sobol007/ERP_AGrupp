#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дерево = РеквизитФормыВЗначение("ДеревоМетаданных");
	ИменаМетаданных = Новый Массив;
	Типы = ИнтеграцияС1СДокументооборотПовтИсп.ТипыОбъектовПоддерживающихИнтеграцию();
	Для Каждого Тип Из Типы Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		ИменаМетаданных.Добавить(ОбъектМетаданных.ПолноеИмя());
	КонецЦикла;
	
	ЗаполнитьВеткуДереваМетаданных(Дерево, ИменаМетаданных, "Справочники", БиблиотекаКартинок.Справочник, НСтр("ru = 'Справочники';
																												|en = 'Catalogs'"));
	ЗаполнитьВеткуДереваМетаданных(Дерево, ИменаМетаданных, "Документы",   БиблиотекаКартинок.Документ, НСтр("ru = 'Документы';
																											|en = 'Documents'"));
	ЗаполнитьВеткуДереваМетаданных(Дерево, ИменаМетаданных, "ПланыВидовРасчета",   БиблиотекаКартинок.ПланВидовРасчета, НСтр("ru = 'Планы видов расчета';
																															|en = 'Charts of calculation types'"));
	ЗаполнитьВеткуДереваМетаданных(Дерево, ИменаМетаданных, "БизнесПроцессы", БиблиотекаКартинок.БизнесПроцесс, НСтр("ru = 'Бизнес-процессы';
																													|en = 'Business processes'"));
	ЗаполнитьВеткуДереваМетаданных(Дерево, ИменаМетаданных, "Задачи", БиблиотекаКартинок.Задача, НСтр("ru = 'Задачи';
																										|en = 'Tasks'"));
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоМетаданных");
	
	Если ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда 
		Для Каждого СтрокаГруппа Из ДеревоМетаданных.ПолучитьЭлементы() Цикл
			Для Каждого Строка Из СтрокаГруппа.ПолучитьЭлементы() Цикл
				Если Строка.Имя = Параметры.ТекущаяСтрока Тогда 
					Элементы.ДеревоМетаданных.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Строки = ДеревоМетаданных.ПолучитьЭлементы();
	Для Каждого Строка Из Строки Цикл 
		Элементы.ДеревоМетаданных.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоМетаданных

&НаКлиенте
Процедура ДеревоМетаданныхВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОбработатьВыборЭлементаДерева();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработатьВыборЭлементаДерева();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьВеткуДереваМетаданных(Дерево, ИменаМетаданных, Менеджер, Картинка, Представление)
	
	Если Метаданные[Менеджер].Количество() > 0 Тогда 
		СтрокаГруппа = Дерево.Строки.Добавить();
		СтрокаГруппа.Имя = "";
		СтрокаГруппа.Синоним = Представление;
		СтрокаГруппа.Картинка = Картинка;
		Для Каждого Объект Из Метаданные[Менеджер] Цикл
			Если ИменаМетаданных.Найти(Объект.ПолноеИмя()) = Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			НоваяСтрока = СтрокаГруппа.Строки.Добавить();
			НоваяСтрока.Имя = Объект.ПолноеИмя();
			НоваяСтрока.Синоним = ?(Объект.Синоним = "", Объект.Имя, Объект.Синоним);
			НоваяСтрока.Картинка = СтрокаГруппа.Картинка;
		КонецЦикла;
		Если СтрокаГруппа.Строки.Количество() = 0 Тогда 
			Дерево.Строки.Удалить(СтрокаГруппа);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборЭлементаДерева()
	
	ТекущиеДанные = Элементы.ДеревоМетаданных.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	Если ТекущиеДанные.Имя = "" Тогда 
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Имя",  	  ТекущиеДанные.Имя);
	Результат.Вставить("Синоним", ТекущиеДанные.Синоним);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
