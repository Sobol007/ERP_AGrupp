#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимНавигации = -1;
	
	Заголовок1_Цвет = WebЦвета.ТемноСиний;
	Заголовок1_Шрифт = Новый Шрифт("Arial", 18, Истина);
	Заголовок2_Цвет = ЦветаСтиля.ГруппаВариантовОтчетовЦвет;
	Заголовок2_Шрифт = Новый Шрифт("Arial", 14, Истина);
	
	ОбновитьДанные();
	
	ПараметрыОткрытияФормыОбработаны = Истина;
	ОбработатьПараметрыОткрытияФормы(Параметры, Ложь);
	
	Если Параметры.НомерОкна = 0 Тогда
		Если РежимНавигации = 1 Тогда
			Параметры.НомерОкна = 1;
		ИначеЕсли РежимНавигации = 2 ИЛИ РежимНавигации = 3 Тогда
			Параметры.НомерОкна = 2;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.НомерОкна = 1 Тогда
		Заголовок = НСтр("ru = 'Функциональная модель (функции)';
						|en = 'Functional model (functions)'");
	ИначеЕсли Параметры.НомерОкна = 2 Тогда
		Заголовок = НСтр("ru = 'Функциональная модель (объекты и профили)';
						|en = 'Functional model (objects and profiles)'");
	Иначе
		Заголовок = НСтр("ru = 'Функциональная модель';
						|en = 'Functional model'");
	КонецЕсли; 
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СППР_ФункциональнаяМодель" 
		И (НЕ Параметр.Свойство("НомерОкна") 
			ИЛИ Параметр.НомерОкна = Параметры.НомерОкна) Тогда
			
		Если НЕ ПараметрыОткрытияФормыОбработаны Тогда
			ОбработатьПараметрыОткрытияФормы(Параметр, Истина);
		КонецЕсли; 
		ПараметрыОткрытияФормыОбработаны = Ложь;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКФункцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылка = "СледующиеФункции" Тогда
		ПутьКФункцииНачало = Макс(ПутьКФункцииНачало - 1, 0);
		ПоказатьПутьКФункции();
	ИначеЕсли НавигационнаяСсылка = "ПредыдущиеФункции" Тогда
		ПутьКФункцииНачало = Мин(ПутьКФункцииНачало + 1, ПутьКФункцииСписокФункций.Количество() - 1);
		ПоказатьПутьКФункции();
	Иначе
		ПутьКФункцииОбработкаНавигационнойСсылкиНаСервере(НавигационнаяСсылка);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СхемаФункцииВыбор(Элемент)
	
	ОткрытьГиперссылкуЭлементаСхемы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПерейтиПоСсылкеHTML(ДанныеСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоНавигацииПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПерейтиПоСсылкеHTML(ДанныеСобытия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокФункций

&НаКлиенте
Процедура СписокФункцийПриАктивизацииСтроки(Элемент)
	
	Если НеОбрабатыватьАктивизациюСтроки Тогда
		НеОбрабатыватьАктивизациюСтроки = Ложь;
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_СписокФункцийПриАктивизацииСтроки", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОбъектов

&НаКлиенте
Процедура СписокОбъектовПриАктивизацииСтроки(Элемент)
	
	Если НеОбрабатыватьАктивизациюСтроки Тогда
		НеОбрабатыватьАктивизациюСтроки = Ложь;
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_СписокОбъектовПриАктивизацииСтроки", 0.3, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПрофилей

&НаКлиенте
Процедура СписокПрофилейПриАктивизацииСтроки(Элемент)
	
	Если НеОбрабатыватьАктивизациюСтроки Тогда
		НеОбрабатыватьАктивизациюСтроки = Ложь;
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_СписокПрофилейПриАктивизацииСтроки", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПоказатьСписок(Команда)
	
	ВидимостьСписка = НЕ ВидимостьСписка;
	УстановитьВидимостьСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНавигацияВперед(Команда)
	
	НавигацияВперед();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНавигацияНазад(Команда)
	
	НавигацияНазад();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНавигацияДомой(Команда)
	
	НавигацияДомой();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеДанными

&НаСервере
Процедура ОбработатьПараметрыОткрытияФормы(ПараметрыОткрытия, ПовторноеОткрытие)

	Если ПараметрыОткрытия.Свойство("ДополнительныеПараметры")
		И ПараметрыОткрытия.ДополнительныеПараметры <> Неопределено
		И ПараметрыОткрытия.ДополнительныеПараметры.Свойство("Отчет") Тогда
		
		// Для отчетов свой алгоритм
		ИмяОтчета = СтрЗаменить(ПараметрыОткрытия.ДополнительныеПараметры.Отчет, "Отчет.", "");
		ПерейтиКОписаниюФормы("", ПараметрыОткрытия.Заголовок, ПовторноеОткрытие, Метаданные.Отчеты[ИмяОтчета]);
		
	ИначеЕсли ПараметрыОткрытия.Свойство("РазделИнтерфейса") Тогда
		
		НачалоНавигации = ИнтеграцияССППРПовтИсп.ОписаниеРазделаИнтерфейса(ПараметрыОткрытия.РазделИнтерфейса);
		
		Если НачалоНавигации = "" Тогда
			МетаданныеПодсистемы = Метаданные.Подсистемы.Найти(ПараметрыОткрытия.РазделИнтерфейса);
			Если МетаданныеПодсистемы <> Неопределено Тогда
				ПредставлениеПодсистемы = МетаданныеПодсистемы.Синоним;
			Иначе
				ПредставлениеПодсистемы = ПараметрыОткрытия.РазделИнтерфейса;
			КонецЕсли; 
			
			ТекстПараграфа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
												НСтр("ru = 'Для раздела ""%1"" не определены функции.';
													|en = 'Functions are not defined for the ""%1"" section. '"),
												ПредставлениеПодсистемы);
												
			СформироватьОписаниеНеНайдено(ТекстПараграфа, ПовторноеОткрытие);
			
		Иначе
			
			ПерейтиКНачалуНавигации();
			
		КонецЕсли;
		
		
	ИначеЕсли ПараметрыОткрытия.Свойство("ИмяФормы") Тогда
		
		ПерейтиКОписаниюФормы(ПараметрыОткрытия.ИмяФормы, ПараметрыОткрытия.Заголовок, ПовторноеОткрытие);
		
	ИначеЕсли ПараметрыОткрытия.Свойство("ИДЭлемента") Тогда
		
		Если ПараметрыОткрытия.ТипЭлемента = "Function" Тогда
			ПерейтиКФункции(ПараметрыОткрытия.ИДЭлемента);
			
		ИначеЕсли ПараметрыОткрытия.ТипЭлемента = "Control"
			ИЛИ ПараметрыОткрытия.ТипЭлемента = "Input" 
			ИЛИ ПараметрыОткрытия.ТипЭлемента = "Link" 
			ИЛИ ПараметрыОткрытия.ТипЭлемента = "Output" Тогда
			
			ПерейтиКОбъекту(ПараметрыОткрытия.ИДЭлемента);
			
		ИначеЕсли ПараметрыОткрытия.ТипЭлемента = "Performer" Тогда
			
			ПерейтиКПрофилю(ПараметрыОткрытия.ИДЭлемента);
			
		КонецЕсли;
		
		Если НЕ ПовторноеОткрытие Тогда
			УстановитьНавигациюДомой(РежимНавигации, ПараметрыОткрытия.ИДЭлемента);
		КонецЕсли;
		
	Иначе
		
		Если НЕ ПовторноеОткрытие Тогда
			УстановитьНавигациюДомой(0, Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеИсториейНавигации();
	УстановитьВидимостьСписка();

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанные()

	ДанныеФунциональнойМодели = ИнтеграцияССППРПовтИсп.ПодготовитьДанныеФункциональнойМодели();
	
	ЗначениеВРеквизитФормы(ДанныеФунциональнойМодели.СписокФункцийДерево, "СписокФункций");
	ЗначениеВРеквизитФормы(ДанныеФунциональнойМодели.СписокОбъектовДерево, "СписокОбъектов");
	ЗначениеВРеквизитФормы(ДанныеФунциональнойМодели.СписокПрофилейДерево, "СписокПрофилей");
	
КонецПроцедуры

#КонецОбласти

#Область СписокФункций

&НаСервере
Процедура ПерейтиКФункции(Знач ИДФункции, Знач ОбновитьИсториюНавигации = Истина)

	// Установим строку в списке функций на нужной
	ТекущийСписок = СписокФункций.ПолучитьЭлементы();
	ДанныеСтроки = НайтиСтрокуПоИД(ИДФункции, ТекущийСписок);
	Если ДанныеСтроки <> Неопределено Тогда
		НеОбрабатыватьАктивизациюСтроки = Истина;
		Элементы.СписокФункций.ТекущаяСтрока = ДанныеСтроки.ПолучитьИдентификатор();
	КонецЕсли;
	
	ПоказатьОписаниеФункции(ДанныеСтроки, ОбновитьИсториюНавигации);
	
	РежимНавигации = 1;
	УстановитьРежимНавигации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОписаниеФункции(ДанныеСтроки, ОбновитьИсториюНавигации = Истина)

	Если ДанныеСтроки <> Неопределено Тогда
		ТекущаяФункция_ИД = ДанныеСтроки.ИД;
	Иначе
		ТекущаяФункция_ИД = ПустойКлюч;
	КонецЕсли;
	
	ПоказатьСхемуФункции(ДанныеСтроки);
	СформироватьПутьКФункции(ДанныеСтроки);
	ПоказатьПутьКФункции();
	
	ЭлементыСхемыТекущейФункции.Очистить();
	ФормыРабочегоМеста.Очистить();
	КонечнаяФункция = Ложь;
	Если ДанныеСтроки <> Неопределено Тогда
		КонечнаяФункция = ДанныеСтроки.КонечнаяФункция;
		Для каждого ДанныеЭлементаСхемы Из ДанныеСтроки.ЭлементыСхемы Цикл
			ЗаполнитьЗначенияСвойств(ЭлементыСхемыТекущейФункции.Добавить(), ДанныеЭлементаСхемы);
		КонецЦикла; 
		Для каждого ДанныеФормыРабочегоМеста Из ДанныеСтроки.ФормыРабочегоМеста Цикл
			ЗаполнитьЗначенияСвойств(ФормыРабочегоМеста.Добавить(), ДанныеФормыРабочегоМеста);
		КонецЦикла; 
		
		Если ОбновитьИсториюНавигации Тогда
			ДобавитьВИсториюНавигации(ДанныеСтроки.ИД, 1);
		КонецЕсли; 
	КонецЕсли; 
	
	УправлениеИсториейНавигации();
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСхемуФункции(ДанныеСтроки)

	Если ДанныеСтроки = Неопределено Тогда
		СхемаФункции = Новый ГрафическаяСхема;
		Возврат;
	КонецЕсли;
	
	Если ДанныеСтроки.Схема = Неопределено Тогда
		ДанныеФункции = ИнтеграцияССППР.ДанныеФункции(ДанныеСтроки.ИД);
		ДанныеСтроки.Схема = ОбработатьСхему(ДанныеФункции.Scheme.Получить());
		ДанныеСтроки.КонечнаяФункция = ДанныеФункции.IsWorkplace;
		Для каждого ДанныеЭлементаСхемы Из ДанныеФункции.SchemeElements Цикл
			НоваяСтрока = ДанныеСтроки.ЭлементыСхемы.Добавить();
			НоваяСтрока.ИД = ДанныеЭлементаСхемы.ID;
			НоваяСтрока.Код = ДанныеЭлементаСхемы.Code;
			НоваяСтрока.Тип = ДанныеЭлементаСхемы.Type;
			НоваяСтрока.Представление = ДанныеЭлементаСхемы.Name;
		КонецЦикла; 
		Для каждого ДанныеФормыРабочегоМеста Из ДанныеФункции.ListOfWorkplace Цикл
			НоваяСтрока = ДанныеСтроки.ФормыРабочегоМеста.Добавить();
			НоваяСтрока.ИмяОбъектаМетаданных = ДанныеФормыРабочегоМеста.Metadata;
			НоваяСтрока.ИмяФормы = ДанныеФормыРабочегоМеста.FormName;
			НоваяСтрока.ТипФормы = ДанныеФормыРабочегоМеста.FormType;
		КонецЦикла; 
	КонецЕсли; 

	СхемаФункции = ДанныеСтроки.Схема;

КонецПроцедуры

&НаСервере
Процедура СформироватьПутьКФункции(ДанныеСтроки)

	ПутьКФункцииСписокФункций.Очистить();
	ПутьКФункцииНачало = 0;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ПутьКФункцииСписокФункций.Добавить(ДанныеСтроки.ИД, ДанныеСтроки.Представление);
	
	СтрокаРодитель = ДанныеСтроки.ПолучитьРодителя();
	Пока СтрокаРодитель <> Неопределено Цикл
		ПутьКФункцииСписокФункций.Добавить(СтрокаРодитель.ИД, СтрокаРодитель.Представление);
		СтрокаРодитель = СтрокаРодитель.ПолучитьРодителя();
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПоказатьПутьКФункции()

	Если ПутьКФункцииСписокФункций.Количество() = 0 Тогда
		ПутьКФункции = Новый ФорматированнаяСтрока("");
		Возврат;
	КонецЕсли; 
	
	МаксимальноеКоличествоФункций = 3; // Путь к функции состоит только из трех функций
	
	МассивСтрокНавигации = Новый Массив;
	
	НомерПервойФункции = ПутьКФункцииСписокФункций.Количество() - 1;
	
	ПутьКФункцииКонец = Мин(ПутьКФункцииНачало + МаксимальноеКоличествоФункций - 1, НомерПервойФункции);
	
	Для НомерФункции = -ПутьКФункцииКонец По -ПутьКФункцииНачало Цикл
		
		// Список содержит функции в обратном порядке
		ДанныеФункции = ПутьКФункцииСписокФункций.Получить(-НомерФункции);
		
		Если НомерФункции = 0 Тогда
			
			// Текущая функция не содержит гиперссылки
			СтрокаНавигации = Новый ФорматированнаяСтрока(ДанныеФункции.Представление, Новый Шрифт(,,Истина));
			МассивСтрокНавигации.Добавить(СтрокаНавигации);
			
		Иначе
			
			Если НомерФункции = -ПутьКФункцииКонец И НомерФункции <> -НомерПервойФункции Тогда
				// Путь начинается с функции, которая не первая
				МассивСтрокНавигации.Добавить(Новый ФорматированнаяСтрока(
													БиблиотекаКартинок.НавигацияПутьНазад,,,,
													"ПредыдущиеФункции"));
				МассивСтрокНавигации.Добавить(" \ ");
			КонецЕсли;
			
			// Предыдущие функции выводятся как гиперссылки
			СтрокаНавигации = Новый ФорматированнаяСтрока(
										ДанныеФункции.Представление,,,,
										Строка(ДанныеФункции.Значение));
										
			МассивСтрокНавигации.Добавить(СтрокаНавигации);
			
			Если НомерФункции = -ПутьКФункцииНачало Тогда
				// Путь завершается функцией, которая не последняя
				МассивСтрокНавигации.Добавить(" \ ");
				МассивСтрокНавигации.Добавить(Новый ФорматированнаяСтрока(
													БиблиотекаКартинок.НавигацияПутьВперед,,,,
													"СледующиеФункции"));
			Иначе	
				МассивСтрокНавигации.Добавить(" \ ");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПутьКФункции = Новый ФорматированнаяСтрока(МассивСтрокНавигации);
	
КонецПроцедуры

&НаСервере
Функция ОбработатьСхему(Схема)

	Если НЕ Схема.ИспользоватьСетку Тогда
		Возврат Схема;
	КонецЕсли;
	
	Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
	ОбъектXDTOСхема = Сериализатор.ЗаписатьXDTO(Схема);
		
	ОбъектXDTOСхема.EnableGrid = Ложь;
	ОбъектXDTOСхема.DrawGridMode = РежимОтрисовкиСеткиГрафическойСхемы.НеРисовать;
		
	Возврат Сериализатор.ПрочитатьXDTO(ОбъектXDTOСхема);

КонецФункции

&НаСервере
Процедура ПоказатьОписаниеТекущейФункции()
	
	СхемаФункции = Новый ГрафическаяСхема;
	
	ТекущаяСтрока = Элементы.СписокФункций.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = СписокФункций.НайтиПоИдентификатору(ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОписаниеФункции(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГиперссылкуЭлементаСхемы()

	ЭлементСхемы = Элементы.СхемаФункции.ТекущийЭлемент;
	Если ЭлементСхемы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипЭлементаСхемы = ТипЗнч(ЭлементСхемы);
	Если ТипЭлементаСхемы <> Тип("ЭлементГрафическойСхемыДекорация") Тогда
		Возврат;
	КонецЕсли;
	ПараметрыОтбора = Новый Структура("Код", ЭлементСхемы.Имя);
	МассивСтрок = ЭлементыСхемыТекущейФункции.НайтиСтроки(ПараметрыОтбора);
	Если МассивСтрок.Количество() <> 0 Тогда
		ДанныеЭлементаСхемы = МассивСтрок[0];
		Если ДанныеЭлементаСхемы.ИД <> ПустойКлюч Тогда
			
			Если ДанныеЭлементаСхемы.Тип = "Function" Тогда
				ПерейтиКФункции(ДанныеЭлементаСхемы.ИД);
				
			ИначеЕсли ДанныеЭлементаСхемы.Тип = "Control"
				ИЛИ ДанныеЭлементаСхемы.Тип = "Input" 
				ИЛИ ДанныеЭлементаСхемы.Тип = "Link" 
				ИЛИ ДанныеЭлементаСхемы.Тип = "Output" Тогда
				
				ОткрытьФункциональнуМодель(ДанныеЭлементаСхемы.ИД, ДанныеЭлементаСхемы.Тип, 2);
				
			ИначеЕсли ДанныеЭлементаСхемы.Тип = "Performer" Тогда
				
				ОткрытьФункциональнуМодель(ДанныеЭлементаСхемы.ИД, ДанныеЭлементаСхемы.Тип, 2);
			КонецЕсли;
			
		ИначеЕсли ДанныеЭлементаСхемы.Тип = "Function" Тогда
			ОткрытьФормуРабочегоМеста();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФункциональнуМодель(ИДЭлемента, ТипЭлемента, НомерОкна)

	ПараметрыФормы = Новый Структура("ИДЭлемента,ТипЭлемента,НомерОкна", ИДЭлемента, ТипЭлемента, НомерОкна);
	ОткрытьФорму("Обработка.ИнтеграцияССППР.Форма.ФункциональнаяМодель", ПараметрыФормы);
	
	// Если форма уже открыта, то оповестим ее, чтобы показать новые данные
	Оповестить("СППР_ФункциональнаяМодель", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРабочегоМеста()

	Если НЕ КонечнаяФункция Тогда
		Возврат;
	КонецЕсли;
	
	Если ФормыРабочегоМеста.Количество() = 1 Тогда
		
		ДанныеФормыРабочегоМеста = ФормыРабочегоМеста[0];
		ПолноеИмяФормы = ПолноеИмяФормыРабочегоМеста(
							ДанныеФормыРабочегоМеста.ИмяОбъектаМетаданных,
							ДанныеФормыРабочегоМеста.ИмяФормы, 
							ДанныеФормыРабочегоМеста.ТипФормы);
							
		СписокВыбораРабочихМест = Новый СписокЗначений;
		СписокВыбораРабочихМест.Добавить(ПолноеИмяФормы);
		ОткрытьФормуРабочегоМестаЗавершение(СписокВыбораРабочихМест[0], Неопределено);
		
	Иначе
		
		СписокВыбораРабочихМест = СписокВыбораРабочихМест();
		Если СписокВыбораРабочихМест.Количество() = 1 Тогда
			ОткрытьФормуРабочегоМестаЗавершение(СписокВыбораРабочихМест[0], Неопределено);
		ИначеЕсли СписокВыбораРабочихМест.Количество() > 1 Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуРабочегоМестаЗавершение", ЭтотОбъект);
			СписокВыбораРабочихМест.ПоказатьВыборЭлемента(ОписаниеОповещения, НСтр("ru = 'Выберите какую форму открыть';
																					|en = 'Select a form to open'"));
		КонецЕсли; 
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолноеИмяФормыРабочегоМеста(ИмяОбъектаМетаданных, ИмяФормыРабочегоМеста, ТипФормы)

	ПолноеИмяФормы = ИмяОбъектаМетаданных;
	
	Если ЗначениеЗаполнено(ИмяФормыРабочегоМеста) Тогда
		ПолноеИмяФормы = ПолноеИмяФормы + ".Форма." + ИмяФормыРабочегоМеста;
	ИначеЕсли ТипФормы <> "" Тогда
		ПолноеИмяФормы = ПолноеИмяФормы + "." + ТипФормы;
	Иначе
		ПолноеИмяФормы = Неопределено;
	КонецЕсли;
	
	Возврат ПолноеИмяФормы;
	
КонецФункции

&НаСервере
Функция СписокВыбораРабочихМест()

	СписокВыбора = Новый СписокЗначений;
	
	Для каждого ДанныеФормыРабочегоМеста Из ФормыРабочегоМеста Цикл
		ПолноеИмяФормы = ПолноеИмяФормыРабочегоМеста(
								ДанныеФормыРабочегоМеста.ИмяОбъектаМетаданных,
								ДанныеФормыРабочегоМеста.ИмяФормы, 
								ДанныеФормыРабочегоМеста.ТипФормы);
								
		Если ПолноеИмяФормы = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПредставлениеФормы = ПолноеИмяФормы;
		МетаданныеФормы = Метаданные.НайтиПоПолномуИмени(ПолноеИмяФормы);
		Если МетаданныеФормы = Неопределено Тогда
			МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ДанныеФормыРабочегоМеста.ИмяОбъектаМетаданных);
			Если МетаданныеОбъекта <> Неопределено Тогда
				ПредставлениеФормы = МетаданныеОбъекта.Синоним;
			КонецЕсли; 
		Иначе
			ПредставлениеФормы = МетаданныеФормы.Синоним;
		КонецЕсли;
		
		Если Лев(ПолноеИмяФормы, 6) = "Отчет." Тогда
			ПредставлениеФормы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = 'Отчет ""%1""';
										|en = 'Report ""%1""'"),
									ПредставлениеФормы);
		Иначе
			ПредставлениеФормы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = 'Форма ""%1""';
										|en = 'Form ""%1""'"),
									ПредставлениеФормы);
		КонецЕсли; 
		
		СписокВыбора.Добавить(ПолноеИмяФормы, ПредставлениеФормы);
	КонецЦикла;
	
	Возврат СписокВыбора;

КонецФункции

&НаКлиенте
Процедура ОткрытьФормуРабочегоМестаЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Попытка
			ОткрытьФорму(ВыбранныйЭлемент.Значение);
		Исключение
			ТекстПредупреждения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ПоказатьПредупреждение(, ТекстПредупреждения,, НСтр("ru = 'Не удалось открыть рабочее место';
																|en = 'Cannot open workplace'"));
		КонецПопытки; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокФункцийПриАктивизацииСтроки()

	ПоказатьОписаниеТекущейФункции();

КонецПроцедуры

#КонецОбласти

#Область СписокОбъектов

&НаСервере
Функция ПерейтиКОбъекту(Знач ИДОбъекта, Знач ОбновитьИсториюНавигации = Истина)

	// Установим строку в списке объектов на нужной
	ТекущийСписок = СписокОбъектов.ПолучитьЭлементы();
	ДанныеСтроки = НайтиСтрокуПоИД(ИДОбъекта, ТекущийСписок);
	Если ДанныеСтроки <> Неопределено Тогда
		НеОбрабатыватьАктивизациюСтроки = Истина;
		Элементы.СписокОбъектов.ТекущаяСтрока = ДанныеСтроки.ПолучитьИдентификатор();
	КонецЕсли;

	ПоказатьОписаниеОбъекта(ДанныеСтроки, ОбновитьИсториюНавигации);
	
	РежимНавигации = 2;
	УстановитьРежимНавигации(ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ПоказатьОписаниеОбъекта(ДанныеСтроки, ОбновитьИсториюНавигации = Истина)
	
	СформироватьОписаниеОбъекта(ДанныеСтроки);
	
	Если ДанныеСтроки <> Неопределено Тогда
		Если ОбновитьИсториюНавигации Тогда
			ДобавитьВИсториюНавигации(ДанныеСтроки.ИД, 2);
		КонецЕсли; 
	КонецЕсли;
	
	УправлениеИсториейНавигации();
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОписаниеТекущегоОбъекта()

	ТекущаяСтрока = Элементы.СписокОбъектов.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = СписокОбъектов.НайтиПоИдентификатору(ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОписаниеОбъекта(ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеОбъекта(ДанныеСтроки)

	Если ДанныеСтроки = Неопределено Тогда
		ОписаниеHTML = "";
		Возврат;
	КонецЕсли; 
	
	Если НЕ ДанныеСтроки.ОписаниеПодготовлено Тогда
		ДанныеСтроки.ОписаниеПодготовлено = Истина;
		ДанныеСтроки.ОписаниеHTML = ИнтеграцияССППР.ОписаниеОбъекта(ДанныеСтроки.ИД);
	КонецЕсли;
	
	ОписаниеHTML = ДанныеСтроки.ОписаниеHTML;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиПоСсылкеHTML(ДанныеСобытия)

	Если НЕ ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСсылки = ДанныеСобытия.Href;
	
	НачалоИД = СтрНайти(ТекстСсылки, "ИД_Функции");
	Если НачалоИД <> 0 Тогда
		ИД_Функции = Новый УникальныйИдентификатор(Сред(ТекстСсылки, НачалоИД + 10));
		Если Параметры.НомерОкна = 1 Тогда
			ПерейтиКФункции(ИД_Функции);
		Иначе
			ОткрытьФункциональнуМодель(ИД_Функции, "Function", 1);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	
	НачалоИД = СтрНайти(ТекстСсылки, "ИД_Объекта");
	Если НачалоИД <> 0 Тогда
		ИД_Объекта = Новый УникальныйИдентификатор(Сред(ТекстСсылки, НачалоИД + 10));
		Если Параметры.НомерОкна = 2 Тогда
			ПерейтиКОбъекту(ИД_Объекта);
		Иначе
			ОткрытьФункциональнуМодель(ИД_Объекта, "Input", 2);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	
	НачалоИД = СтрНайти(ТекстСсылки, "ИД_Профиля");
	Если НачалоИД <> 0 Тогда
		ИД_Профиля = Новый УникальныйИдентификатор(Сред(ТекстСсылки, НачалоИД + 10));
		Если Параметры.НомерОкна = 2 Тогда
			ПерейтиКПрофилю(ИД_Профиля);
		Иначе
			ОткрытьФункциональнуМодель(ИД_Профиля, "Performer", 2);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокОбъектовПриАктивизацииСтроки()

	ПоказатьОписаниеТекущегоОбъекта();

КонецПроцедуры

#КонецОбласти

#Область СписокПрофилей

&НаСервере
Функция ПерейтиКПрофилю(Знач ИДПрофиля, Знач ОбновитьИсториюНавигации = Истина)

	// Установим строку в списке объектов на нужной
	ТекущийСписок = СписокПрофилей.ПолучитьЭлементы();
	ДанныеСтроки = НайтиСтрокуПоИД(ИДПрофиля, ТекущийСписок);
	Если ДанныеСтроки <> Неопределено Тогда
		НеОбрабатыватьАктивизациюСтроки = Истина;
		Элементы.СписокПрофилей.ТекущаяСтрока = ДанныеСтроки.ПолучитьИдентификатор();
	КонецЕсли;

	ПоказатьОписаниеПрофиля(ДанныеСтроки, ОбновитьИсториюНавигации);
	
	РежимНавигации = 3;
	УстановитьРежимНавигации(ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ПоказатьОписаниеПрофиля(ДанныеСтроки, ОбновитьИсториюНавигации = Истина)
	
	СформироватьОписаниеПрофиля(ДанныеСтроки);
	
	Если ДанныеСтроки <> Неопределено Тогда
		Если ОбновитьИсториюНавигации Тогда
			ДобавитьВИсториюНавигации(ДанныеСтроки.ИД, 3);
		КонецЕсли; 
	КонецЕсли;
	
	УправлениеИсториейНавигации();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеПрофиля(ДанныеСтроки)

	Если ДанныеСтроки = Неопределено Тогда
		ОписаниеHTML = "";
		Возврат;
	КонецЕсли; 
	
	Если НЕ ДанныеСтроки.ОписаниеПодготовлено Тогда
		ДанныеСтроки.ОписаниеПодготовлено = Истина;
		ДанныеСтроки.ОписаниеHTML = ИнтеграцияССППР.ОписаниеПрофиля(ДанныеСтроки.ИД);
	КонецЕсли;
	
	ОписаниеHTML = ДанныеСтроки.ОписаниеHTML;

КонецПроцедуры

&НаСервере
Процедура ПоказатьОписаниеТекущегоПрофиля()

	ТекущаяСтрока = Элементы.СписокПрофилей.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = СписокПрофилей.НайтиПоИдентификатору(ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОписаниеПрофиля(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПрофилейПриАктивизацииСтроки()

	ПоказатьОписаниеТекущегоПрофиля();

КонецПроцедуры

#КонецОбласти

#Область Навигация

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРежимНавигации(Форма)

	Если Форма.РежимНавигации = 1 Тогда
		Форма.Элементы.СтраницыПросмотр.ТекущаяСтраница = Форма.Элементы.СтраницаПросмотрФункциональнойМодели;
		Форма.Элементы.СтраницыНавигация.ТекущаяСтраница = Форма.Элементы.СтраницаСписокФункций;
		Форма.Элементы.СтраницыДанные.ТекущаяСтраница = Форма.Элементы.СтраницаФункция;
		Форма.Элементы.СтраницыИнформация.ТекущаяСтраница = Форма.Элементы.СтраницаИнформацияФункция;
		Форма.Элементы.ПоказатьСписок.Доступность = Истина;
	ИначеЕсли Форма.РежимНавигации = 2 Тогда
		Форма.Элементы.СтраницыПросмотр.ТекущаяСтраница = Форма.Элементы.СтраницаПросмотрФункциональнойМодели;
		Форма.Элементы.СтраницыНавигация.ТекущаяСтраница = Форма.Элементы.СтраницаСписокОбъектов;
		Форма.Элементы.СтраницыДанные.ТекущаяСтраница = Форма.Элементы.СтраницаОписаниеHTML;
		Форма.Элементы.СтраницыИнформация.ТекущаяСтраница = Форма.Элементы.СтраницаИнформацияПрочее;
		Форма.Элементы.ПоказатьСписок.Доступность = Истина;
	ИначеЕсли Форма.РежимНавигации = 3 Тогда
		Форма.Элементы.СтраницыПросмотр.ТекущаяСтраница = Форма.Элементы.СтраницаПросмотрФункциональнойМодели;
		Форма.Элементы.СтраницыНавигация.ТекущаяСтраница = Форма.Элементы.СтраницаСписокПрофилей;
		Форма.Элементы.СтраницыДанные.ТекущаяСтраница = Форма.Элементы.СтраницаОписаниеHTML;
		Форма.Элементы.СтраницыИнформация.ТекущаяСтраница = Форма.Элементы.СтраницаИнформацияПрочее;
		Форма.Элементы.ПоказатьСписок.Доступность = Истина;
	Иначе
		Форма.Элементы.СтраницыПросмотр.ТекущаяСтраница = Форма.Элементы.СтраницаНачалоНавигации;
		Форма.Элементы.ПоказатьСписок.Доступность = Ложь;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура УправлениеИсториейНавигации()

	МожноПерейтиНазад = ТекущаяПозицияВИстории > 1;
	МожноПерейтиВперед = ТекущаяПозицияВИстории < ИсторияНавигации.Количество();
	
	Элементы.НавигацияНазад.Доступность = МожноПерейтиНазад;
	Элементы.НавигацияВперед.Доступность = МожноПерейтиВперед;

КонецПроцедуры

&НаСервере
Процедура ДобавитьВИсториюНавигации(ИД, ТекущийРежимНавигации)

	// Удалим историю которая позже текущей позиции, т.к. вперед уже нельзя перейти
	Для Сч = ТекущаяПозицияВИстории По ИсторияНавигации.Количество() - 1 Цикл
		ИсторияНавигации.Удалить(ТекущаяПозицияВИстории);
	КонецЦикла; 

	КоличествоЭлементовИстории = ИсторияНавигации.Количество();
	Если КоличествоЭлементовИстории = 0 
		ИЛИ ИсторияНавигации[КоличествоЭлементовИстории-1].ИД <> ИД
		ИЛИ ИсторияНавигации[КоличествоЭлементовИстории-1].РежимНавигации <> ТекущийРежимНавигации Тогда
		
		ДанныеИстории = ИсторияНавигации.Добавить();
		ДанныеИстории.РежимНавигации = ТекущийРежимНавигации;
		ДанныеИстории.ИД = ИД;
		
		// Сократим количество записей в истории
		МаксИндексУдаляемойЗаписи = ИсторияНавигации.Количество() - 15;
		Для Сч = 0 По МаксИндексУдаляемойЗаписи - 1 Цикл
			ИсторияНавигации.Удалить(0);
		КонецЦикла; 
		
		ТекущаяПозицияВИстории = ИсторияНавигации.Количество();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура НавигацияВперед()

	ТекущаяПозицияВИстории = ТекущаяПозицияВИстории + 1;
	ДанныеИстории = ИсторияНавигации.Получить(ТекущаяПозицияВИстории - 1);
	ПерейтиПоДаннымНавигации(ДанныеИстории.РежимНавигации, ДанныеИстории.ИД, Ложь);

КонецПроцедуры

&НаСервере
Процедура НавигацияНазад()

	ТекущаяПозицияВИстории = ТекущаяПозицияВИстории - 1;
	ДанныеИстории = ИсторияНавигации.Получить(ТекущаяПозицияВИстории - 1);
	ПерейтиПоДаннымНавигации(ДанныеИстории.РежимНавигации, ДанныеИстории.ИД, Ложь);

КонецПроцедуры

&НаСервере
Процедура НавигацияДомой()

	ПерейтиПоДаннымНавигации(ДомойРежимНавигации, ДомойИД, Истина);

КонецПроцедуры

&НаСервере
Процедура ПерейтиПоДаннымНавигации(РежимНавигации, ИД, ОбновитьИсториюНавигации)

	Если РежимНавигации = 1 Тогда
		ПерейтиКФункции(ИД, ОбновитьИсториюНавигации);
	ИначеЕсли РежимНавигации = 2 Тогда
		ПерейтиКОбъекту(ИД, ОбновитьИсториюНавигации);
	ИначеЕсли РежимНавигации = 3 Тогда
		ПерейтиКПрофилю(ИД, ОбновитьИсториюНавигации);
	Иначе
		ПерейтиКНачалуНавигации(ОбновитьИсториюНавигации);
	КонецЕсли; 

	УправлениеИсториейНавигации();

КонецПроцедуры

&НаСервере
Процедура ПерейтиКНачалуНавигации(ОбновитьИсториюНавигации = Истина)

	РежимНавигации = 0;
	УстановитьРежимНавигации(ЭтаФорма);

	Если ОбновитьИсториюНавигации Тогда
		ДобавитьВИсториюНавигации(Неопределено, РежимНавигации);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеОписанияHTML

&НаСервере
Функция ДобавитьЭлементПараграфа(ТекстЭлемента, ПараграфДокумента)

	ДобавленныйТекст = ПараграфДокумента.Элементы.Добавить(ТекстЭлемента);
	
	Возврат ДобавленныйТекст;

КонецФункции

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьСписка()

	Элементы.ПоказатьСписок.Пометка = ВидимостьСписка;
	Элементы.СтраницыНавигация.Видимость = ВидимостьСписка;
	
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуПоИД(ИД, ТекущийСписок)

	Для каждого ДанныеСтроки Из ТекущийСписок Цикл
		Если ДанныеСтроки.ИД = ИД Тогда
			Возврат ДанныеСтроки;
		КонецЕсли;
		НайденнаяСтрока = НайтиСтрокуПоИД(ИД, ДанныеСтроки.ПолучитьЭлементы());
		Если НайденнаяСтрока <> Неопределено Тогда
			Возврат НайденнаяСтрока;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат Неопределено;

КонецФункции

&НаСервере
Процедура ПутьКФункцииОбработкаНавигационнойСсылкиНаСервере(НавигационнаяСсылка)

	ПерейтиКФункции(Новый УникальныйИдентификатор(НавигационнаяСсылка));

КонецПроцедуры

&НаСервере
Процедура УстановитьНавигациюДомой(ТекущийРежимНавигации, ИД)

	ДомойРежимНавигации = ТекущийРежимНавигации;
	ДомойИД = ИД;

КонецПроцедуры

&НаСервере
Процедура ПерейтиКОписаниюФормы(ИмяФормыРабочегоМеста, ЗаголовокРабочегоМеста, ПовторноеОткрытие, ОбъектСодержащийФорму = Неопределено)
	
	Если ОбъектСодержащийФорму = Неопределено Тогда
		МетаданныеФормы = Метаданные.НайтиПоПолномуИмени(ИмяФормыРабочегоМеста);
		ОбъектСодержащийФорму = МетаданныеФормы.Родитель();
	КонецЕсли; 
	
	Если ОбъектСодержащийФорму <> Неопределено Тогда
		ИмяМетаданных = ОбъектСодержащийФорму.ПолноеИмя();
	Иначе
		ИмяМетаданных = "";
	КонецЕсли;
	
	СсылкиНаФункции = Неопределено;
	СсылкиНаОбъекты = Неопределено;
	
	ОписаниеФормы = ИнтеграцияССППРПовтИсп.ОписаниеФормы(ИмяФормыРабочегоМеста, ИмяМетаданных, ЗаголовокРабочегоМеста);
	Если ОписаниеФормы.Свойство("ОписаниеHTML") Тогда
		
		НачалоНавигации	= ОписаниеФормы.ОписаниеHTML;
		ПерейтиКНачалуНавигации();
		
	ИначеЕсли ОписаниеФормы.Свойство("Функция") Тогда
		
		ПерейтиКФункции(ОписаниеФормы.Функция);
		
	ИначеЕсли ОписаниеФормы.Свойство("Объект") Тогда
		
		ПерейтиКОбъекту(ОписаниеФормы.Объект);
		
	Иначе
		
		ТекстПараграфа = НСтр("ru = 'Форма не используется в функциях и в объектах данных.';
								|en = 'Form is not used in functions and in data objects.'");
		СформироватьОписаниеНеНайдено(ТекстПараграфа, ПовторноеОткрытие);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеНеНайдено(ЗаголовокОписания, ПовторноеОткрытие)

	Перем ВложенияHTML;
	
	Описание = Новый ФорматированныйДокумент;
	НовыйПараграф = Описание.Элементы.Добавить();
	
	КоллекцияФункций = СписокФункций.ПолучитьЭлементы();			
	Если КоллекцияФункций.Количество() <> 0 Тогда
		ДанныеСтроки = КоллекцияФункций[0];
		
		ДобавленныйТекст = ДобавитьЭлементПараграфа(ЗаголовокОписания, НовыйПараграф);
		
		НовыйПараграф.Элементы.Добавить(,ТипЭлементаФорматированногоДокумента.ПереводСтроки);
		НовыйПараграф.Элементы.Добавить(,ТипЭлементаФорматированногоДокумента.ПереводСтроки);
		
		ДобавленныйТекст = ДобавитьЭлементПараграфа(НСтр("ru = 'Перейти к просмотру всех функций';
														|en = 'Go to viewing all functions'"), НовыйПараграф);
		ДобавленныйТекст.НавигационнаяСсылка = "ИД_Функции" + Строка(ДанныеСтроки.ИД);
		
		// Заранее покажем список
		ВидимостьСписка = Истина;
		УстановитьВидимостьСписка();
		
		Если НЕ ПовторноеОткрытие Тогда
			УстановитьНавигациюДомой(1, ДанныеСтроки.ИД);
		КонецЕсли; 
	Иначе
		ДобавитьЭлементПараграфа(НСтр("ru = 'В СППР отсутствует функциональная модель.';
										|en = 'The functional model is missing in ASDS.'"), НовыйПараграф);
		Если НЕ ПовторноеОткрытие Тогда
			УстановитьНавигациюДомой(0, Неопределено);
		КонецЕсли; 
	КонецЕсли; 

	Описание.ПолучитьHTML(НачалоНавигации, ВложенияHTML);
	
	ПерейтиКНачалуНавигации(Ложь);

КонецПроцедуры

&НаСервере
Процедура СформироватьСписокСсылокНаФункцииРекурсивно(СсылкиНаФункции, ТекущийУровень, СтрокиДерева)

	Для каждого СтрокаФункция Из СтрокиДерева Цикл
		Если НЕ СтрокаФункция.ПоказатьВСписке Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСсылки = Новый Структура;
		ДанныеСсылки.Вставить("ИД", СтрокаФункция.ИД);
		ДанныеСсылки.Вставить("Представление", СтрокаФункция.Представление);
		ДанныеСсылки.Вставить("Отступ", ТекущийУровень);
		Если НЕ СтрокаФункция.ВходитВРаздел Тогда
			ДанныеСсылки.Вставить("ЦветТекста", WebЦвета.Серый);
		КонецЕсли;
		СсылкиНаФункции.Добавить(ДанныеСсылки);
		
		СформироватьСписокСсылокНаФункцииРекурсивно(СсылкиНаФункции, ТекущийУровень + 1, СтрокаФункция.Строки);
	КонецЦикла; 

КонецПроцедуры

#КонецОбласти

#КонецОбласти
