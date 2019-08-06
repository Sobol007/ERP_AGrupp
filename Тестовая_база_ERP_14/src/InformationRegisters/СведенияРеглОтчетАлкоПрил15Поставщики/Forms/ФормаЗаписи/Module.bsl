
#Область ОписаниеПеременных

&НаСервере
Перем ОбъектЭтогоОтчета; // Объект метаданных отчета, из которого открыта форма записи.

&НаКлиенте
Перем УправляемаяФормаВладелец; // Форма отчета, из которого открыта форма записи.

&НаКлиенте
Перем УникальностьФормы; // Уникальный идентификатор формы отчета.

&НаКлиенте
Перем ПоказыватьПредупреждениеПослеПереходаПоСсылке; // Флаг необходимости показа предупреждения.

// Форма выбора из списка, ввода пары значений, форма длительной операции, 
// записи регистра, ввода данных по ОП и т.д.
// Любая открытая из данной формы форма в режиме блокировки владельца.
&НаКлиенте
Перем ОткрытаяФормаПотомокСБлокировкойВладельца Экспорт;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеВидимостью(Ложь);
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
	МетаданныеКонтрагенты = Метаданные.Справочники.Контрагенты;
	ЕстьСтранаРегистрации = ОбщегоНазначения.ЕстьРеквизитОбъекта("СтранаРегистрации", МетаданныеКонтрагенты);
	
	// Определим тексты запросов динамических списков.
	
	ОсновнаяТаблица = "";
	ТекстЗапроса = РегламентированнаяОтчетностьАЛКО.ТекстЗапросаВыбораКонтрагентаАЛКО(
																	ОсновнаяТаблица, Ложь, Неопределено);
			
	ДинСписокПоставщика.ТекстЗапроса = ТекстЗапроса;
	ДинСписокПоставщика.ОсновнаяТаблица = ОсновнаяТаблица;
	ДинСписокПоставщика.ДинамическоеСчитываниеДанных = Истина;
	
	Элементы.ТаблицаПоставщиков.Обновить();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ТекстПредупреждения = НСтр("ru = 'Данная форма предназначена для редактирования данных из форм регламентированных отчетов.
										|
										|Открытие данной формы не из формы регламентированного отчета не предусмотрено!';
										|en = 'Данная форма предназначена для редактирования данных из форм регламентированных отчетов.
										|
										|Открытие данной формы не из формы регламентированного отчета не предусмотрено!'");
	
	// Ищем управляемую форму, откуда открыли.
	Если ВладелецФормы = Неопределено Тогда
		
	    Отказ = Истина;		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
				
	ТекущийРодитель = ВладелецФормы;
	 
	Пока ТипЗнч(ТекущийРодитель) <> Тип("УправляемаяФорма") Цикл
	    ТекущийРодитель = ТекущийРодитель.Родитель;		
	КонецЦикла;
	
	УправляемаяФормаВладелец = ТекущийРодитель;
		
	ИмяФормыВладельца 	= УправляемаяФормаВладелец.ИмяФормы;
		
	Если СтрНайти(ИмяФормыВладельца, "РегламентированныйОтчетАлко") = 0 Тогда
	
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	
	КонецЕсли;
	
	УникальностьФормы   = УправляемаяФормаВладелец.УникальностьФормы;
	Оповестить("ОткрытаФормаЗаписиРегистра", ЭтаФорма, УникальностьФормы);
	
	ТекущееСостояниеВладельца = УправляемаяФормаВладелец.ТекущееСостояние;
	
    ДокументЗаписи = 		УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мСохраненныйДок;
	ИндексСтраницыЗаписи = 	УправляемаяФормаВладелец.ИндексАктивнойСтраницыВРегистре;
	ИндексСтраницы = 		УправляемаяФормаВладелец.НомерАктивнойСтраницыМногострочногоРаздела;
	НомерПоследнейЗаписи = 	УправляемаяФормаВладелец.КоличествоСтрок;
	МаксИндексСтраницы = 	УправляемаяФормаВладелец.МаксИндексСтраницы;
	
	ПоказыватьПредупреждениеПослеПереходаПоссылке = УправляемаяФормаВладелец.ПоказыватьПредупреждениеПослеПереходаПоссылке;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
				
		// Заполним измерения, их нет на форме.
	    Запись.Активно = Истина;
		
		Запись.Документ = ДокументЗаписи;
				
		НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
	    Запись.ИндексСтроки = НомерПоследнейЗаписи;
		
		Модифицированность = Истина;
			
	КонецЕсли;
		
	Заголовок = "Сведения о поставщике винограда";
	
	ФлажокОтклАвтоРасчет 	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.ФлажокОтклАвтоРасчет;
	ФлажокОтклАвтоВыборКодов	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мАвтоВыборКодов;
	ДатаПериодаОтчета = УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мДатаКонцапериодаОтчета;
	
	ПодготовкаНаСервере();

	Если НЕ ВладелецФормы.ТекущийЭлемент = Неопределено Тогда
		
		ИмяАктивногоПоля = ВладелецФормы.ТекущийЭлемент.Имя;
		
		АктивноеПоле = Элементы.Найти(ИмяАктивногоПоля);
		Если НЕ АктивноеПоле = Неопределено Тогда
		    ТекущийЭлемент = АктивноеПоле;		
		КонецЕсли;
	
	КонецЕсли;
			
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("ЗакрытаФормаЗаписиРегистра", , УникальностьФормы);
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
				
	ВнесеныИзменения = Модифицированность;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		// Обработка ситуаций "битых" внутренних данных отчета.
		// В норме условие должно проверяться один раз, результат Ложь, 
		// но если из отчета пришло неверное значениепоследней строки - этот цикл позволит
		// записать корректно данные.
		// В дальнейшем при закрытии формы через оповещение отчет будет проинформирован о текущей строке,
		// и скорректирует свои внутренние данные.
		
		СписокСоставаРегистра = Новый СписокЗначений;
		СписокСоставаРегистра.Добавить("Измерения");
		СтруктураИзмерений = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(
																		ИмяРегистра, СписокСоставаРегистра);
	
		Пока РегламентированнаяОтчетностьАЛКО.СуществуетЗапись(Запись, ИмяРегистра, СтруктураИзмерений) Цикл
			
			НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
			Запись.ИндексСтроки = НомерПоследнейЗаписи;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭтоПервоеРедактирование = Ложь;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "ДобавлениеСтроки");
									
	ИначеЕсли ВнесеныИзменения Тогда
			
		// Нужно записать первоначальные данные Записи регистра в журнал.
		// Но сделать это надо только для случая первого изменения Записи после последнего сохранения отчета,
		// чтобы была информация о данных до изменения в случае отката внесенных изменений, если
		// отказался пользователь от сохранения отчета.
		
		ЭтоПервоеРедактирование = РегламентированнаяОтчетностьАЛКО.ЭтоПервоеРедактированиеЗаписиРегистра(ТекущийОбъект.Документ, ИмяРегистра, 
															ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки);
				
	КонецЕсли;
	
	Если ЭтоПервоеРедактирование Тогда
		
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("НачальноеЗначение", НачальноеЗначение);
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		// Нужно сохранить первоначальные данные.
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "Редактирование", Ресурсы);
	Иначе
									
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);		
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, 0, "Сервис", Ресурсы);							
	КонецЕсли;

	Если ВнесеныИзменения Тогда
		РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
											Запись, ИмяРегистра, КонечноеЗначениеСтруктураДанных);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповещаем о необходимости пересчета итогов форму-владелец для активных записей.
	Если ВнесеныИзменения и Запись.Активно Тогда
	 
		// Оповещаем форму-владелец о изменениях.
		ИнформацияДляПересчетаИтогов = Новый Структура;
		ИнформацияДляПересчетаИтогов.Вставить("ИмяРегистра", 		ИмяРегистра);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтраницы", 	ИндексСтраницы);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтроки", 		Запись.ИндексСтроки);
		ИнформацияДляПересчетаИтогов.Вставить("НачальноеЗначение", 	НачальноеЗначениеСтруктураДанных);
		ИнформацияДляПересчетаИтогов.Вставить("КонечноеЗначение", 	КонечноеЗначениеСтруктураДанных);
		
		Оповестить("ПересчетИтогов", ИнформацияДляПересчетаИтогов, УникальностьФормы);
	
	КонецЕсли;
	
	ВнесеныИзменения = Ложь;
		
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если (НЕ ЗавершениеРаботы = Неопределено) и ЗавершениеРаботы Тогда
		// Идет завершение работы системы.
	Иначе
		// Обычное закрытие.
	    Если Элементы.ГруппаВыборПоставщика.Видимость Тогда
		    // Щелкнули на крестик при выборе производителя.
			Отказ = Истина;
		    УправлениеВидимостью(Ложь);
			
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = УникальностьФормы Тогда
		
		Если НРег(ИмяСобытия) = НРег("ЗакрытьОткрытыеФормыЗаписи") Тогда			
		    Модифицированность = Ложь;
			Закрыть();			
		КонецЕсли;
					
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеПриИзменении(Элемент)
	
	ИмяЭлемента = Элемент.Имя;
	
	ОбработкаПослеИзменения();
			
КонецПроцедуры


&НаКлиенте
Процедура ПоставщикПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	НажатиеГиперссылки(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезидентРФПриИзменении(Элемент)
	
	Если (Запись.РезидентРФ) И (НЕ Запись.РезидентЕАЭС)  Тогда
		Запись.РезидентЕАЭС = Истина;	
	КонецЕсли;
	
	Запись.РезидентУстановленПользователем = Истина;
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура РезидентЕАЭСПриИзменении(Элемент)
	
	Если (Запись.РезидентРФ) И (НЕ Запись.РезидентЕАЭС)  Тогда
		Запись.РезидентРФ = Ложь;	
	КонецЕсли;
	
	Запись.РезидентУстановленПользователем = Истина;
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры
#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПоставщиков

&НаКлиенте
Процедура ТаблицаПоставщиковВыбор(Элемент, ВыбраннаяСтрока = Неопределено, Поле = Неопределено, СтандартнаяОбработка = Истина)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	НаименованиеПолное = Элемент.ТекущиеДанные.НаименованиеПолное;
	ИНН = Элемент.ТекущиеДанные.ИНН;
	КПП = Элемент.ТекущиеДанные.КПП;
		
	ТаблицаПоставщиковВыборНаСервере(НаименованиеПолное, ИНН, КПП);
			
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаПоставщиковПриАктивизацииСтроки(Элемент)
	
	Если НЕ ПроверялиНеобходимостьПоказаПредупреждения Тогда	
		
		Элементы.ГруппаИнфоВыбораПоставщика.Видимость = (Элемент.ТекущиеДанные = Неопределено);			
		
		ПроверялиНеобходимостьПоказаПредупреждения = Истина;
		
	КонецЕсли;	 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьИЗакрыть(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ Модифицированность Тогда
	    Закрыть();
	Иначе	
	    Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьПоставщика(Команда)
	
	УправлениеВидимостью(Истина);
	
КонецПроцедуры



&НаКлиенте
Процедура ВыборПоставщика(Команда)
	
	ТаблицаПоставщиковВыбор(Элементы.ТаблицаПоставщиков);
	
КонецПроцедуры


&НаКлиенте
Процедура ВернутьсяНазад(Команда)
	
	УправлениеВидимостью(Ложь);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовкаНаСервере()
	
	УправлениеВидимостью(Ложь);
	
	ДоступностьПолейНаСервере();
	ФормированиеВнешнегоВида();
	
	// Заполним начальное значение всех полей записи во внутреннем формате.
	ИмяРегистра = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяОбъектаМетаданныхПоИмениФормы(ИмяФормы);
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		Запись.ИДДокИндСтраницы = РегламентированнаяОтчетностьАЛКО.ПолучитьИдДокИндСтраницы(Запись.Документ, ИндексСтраницыЗаписи);
		Запись.Организация = Запись.Документ.Организация;
		
		// Начальные данные в этих случаях всегда пустые.
		НачальноеЗначениеСтруктураДанных = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(ИмяРегистра);
		НачальноеЗначение = ЗначениеВСтрокуВнутр(НачальноеЗначениеСтруктураДанных);
		
	Иначе
		НачальноеЗначение = РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
															Запись, ИмяРегистра, НачальноеЗначениеСтруктураДанных);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ДоступностьПолейНаСервере()

	// Доступность полей формы в зависимости от флажка Авторасчет в отчете-владельце.
	// Для раздела Декларация приложения 13 нет авторасчета.
	
	Возврат;
	
КонецПроцедуры


&НаСервере
Функция ОбъектОтчета(ИмяФормыОбъекта)
	
	Возврат РегламентированнаяОтчетностьАЛКО.ОбъектОтчетаАЛКО(ИмяФормыОбъекта, ОбъектЭтогоОтчета);
	
КонецФункции


&НаСервере
Процедура ОбработкаМодифицированности(НачальноеЗначениеПолей, СтруктураМодифицированности)
	
	МодифицированностьКлючевыхПолей = Ложь;
	Для Каждого ЭлСтруктуры Из СтруктураМодифицированности Цикл
					
		Если ЭлСтруктуры.Значение Тогда
		    МодифицированностьКлючевыхПолей = Истина;
			Прервать;			
		КонецЕсли; 
	
	КонецЦикла;
			
	Если НЕ МодифицированностьКлючевыхПолей Тогда
		
		// Принудительно записываем начальные данные, включая всю
		// вспомогательную информацию.
		ЗаполнитьЗначенияСвойств(Запись, НачальноеЗначениеПолей);
		
	Иначе
		
		Запись.Поставщик = Неопределено;
		
		ОбъектОтчета(ИмяФормыВладельца).ОбработкаЗаписи(ИмяРегистра, Запись, , ЕстьСтранаРегистрации);		
				
	КонецЕсли; 
	
	Модифицированность = МодифицированностьКлючевыхПолей;
	
КонецПроцедуры


&НаСервере
Процедура ОбработкаПослеИзменения()
	
	СтруктураМодифицированности = "";
	РегламентированнаяОтчетностьАЛКО.ЗаписьИзменилась(Запись, НачальноеЗначениеСтруктураДанных, 
														Ложь, СтруктураМодифицированности);
	ОбработкаМодифицированности(НачальноеЗначениеСтруктураДанных, СтруктураМодифицированности);
	
	ФормированиеВнешнегоВида();
	
КонецПроцедуры


&НаСервере
Процедура ФормированиеВнешнегоВида()
	
		
	// ГруппаПоставщика.
	Элементы.ПоставщикПредставление.Видимость = ЗначениеЗаполнено(Запись.Поставщик);
	
						
	// Доступ к КПП только если введен 10 значный ИНН.
	Если СтрДлина(Запись.П000010000305) = 10 Тогда
		
	    Элементы.П000010000306.ТолькоПросмотр = Ложь;
		Элементы.П000010000306.ПропускатьПриВводе = Ложь;
		
	Иначе
		
	    Элементы.П000010000306.ТолькоПросмотр = Истина;
		Элементы.П000010000306.ПропускатьПриВводе = Истина;
		Если НЕ СокрЛП(Запись.П000010000306) = "" Тогда
		    Запись.П000010000306 = "";
			Модифицированность = Истина;		
		КонецЕсли; 
		
	КонецЕсли;
		
КонецПроцедуры


&НаСервере
Процедура УправлениеВидимостью(ПоказатьВыборПоставщиков = Ложь)
	
	Если ПоказатьВыборПоставщиков Тогда
		
		ПроверялиНеобходимостьПоказаПредупреждения = Ложь;
				
		Элементы.ОК.Видимость = Ложь;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.ГруппаЗапись.Видимость = Ложь;
		
		Элементы.ГруппаВыборПоставщика.Видимость = Истина;
		
		Если ЗначениеЗаполнено(Запись.Поставщик) Тогда
						
			Элементы.ТаблицаПоставщиков.ТекущаяСтрока = Запись.Поставщик;
			
		КонецЕсли;
		
	Иначе
				
		Элементы.ГруппаИнфоВыбораПоставщика.Видимость = Ложь;
		
		Элементы.ГруппаВыборПоставщика.Видимость = Ложь;
		
		Элементы.ГруппаЗапись.Видимость = Истина;	
		Элементы.Отмена.Видимость = Истина;
		Элементы.ОК.Видимость = Истина;
		
	КонецЕсли; 
	
КонецПроцедуры


&НаСервере
Функция ПолучитьИмяФормыОбъектаЭлементаСсылки(ИмяЭлементаСсылки, ЗначениеСсылка = Неопределено)
	
	ЗначениеСсылка = РегламентированнаяОтчетностьАЛКО.ПолучитьЗначениеЭлементаФормы(ЭтаФорма, ИмяЭлементаСсылки);	
	ИмяФормыОбъекта = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяФормыОбъекта(ЗначениеСсылка);
	
	Возврат ИмяФормыОбъекта;
	
КонецФункции


&НаКлиенте
Процедура НажатиеГиперссылки(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ИмяЭлементаСсылки = Элемент.Имя;
	
	ЗначениеСсылка = Неопределено;
	ИмяФормыОбъекта = ПолучитьИмяФормыОбъектаЭлементаСсылки(ИмяЭлементаСсылки, ЗначениеСсылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НажатиеГиперссылкиЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ЗначениеСсылка);
	ОткрытаяФормаПотомокСБлокировкойВладельца = ОткрытьФорму(ИмяФормыОбъекта, ПараметрыФормы, 
			ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


&НаКлиенте
Процедура НажатиеГиперссылкиЗавершение(Результат, ДопПараметры) Экспорт
	
	ОткрытаяФормаПотомокСБлокировкойВладельца = Неопределено;
	
	Если ПоказыватьПредупреждениеПослеПереходаПоссылке = Неопределено Тогда
	    ПоказыватьПредупреждениеПослеПереходаПоссылке = Истина;	
	КонецЕсли;
	
	Если ПоказыватьПредупреждениеПослеПереходаПоссылке Тогда
	    // Открываем форму предупреждения.
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Внимание!';
													|en = 'Внимание!'"));
		ПараметрыФормы.Вставить("ТекстПредупреждения", НСтр("ru='"
				+ "Если Вы внесли изменения в элемент справочника или документ,"
				+ " следует учесть, что изменения автоматически обновятся только"
				+ " в текущей редактируемой строке таблицы отчета.'"));
		ПараметрыФормы.Вставить("ТекстЗаголовкаФлажка", НСтр("ru = 'Больше не показывать в этом сеансе редактирования';
															|en = 'Больше не показывать в этом сеансе редактирования'"));
		ПараметрыФормы.Вставить("УникальностьФормы",       		УникальностьФормы);
		
		ИмяФормыПредупреждения = "ОбщаяФорма.АЛКОФормаПредупрежденияСФлажком";
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьСостояниеФлажкаФормыПредупреждения", ЭтотОбъект);
		ОткрытьФорму(ИмяФормыПредупреждения, ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьСостояниеФлажкаФормыПредупреждения(Результат, ДопПараметры) Экспорт
	
	Если (НЕ Результат = Неопределено) и Результат Тогда
		// Оповещаем форму отчета владельца о том, что больше показывать
		// предупреждение не надо.
		ПоказыватьПредупреждениеПослеПереходаПоссылке = Ложь;
		Оповестить("ПоказыватьПредупреждениеПослеПереходаПоСсылке", , УникальностьФормы);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ТаблицаПоставщиковВыборНаСервере(НаименованиеПолное, ИНН, КПП)
	
	ОбщаяСтрокаДоВыбора = СокрЛП(Запись.П000010000304) + СокрЛП(Запись.П000010000305) + СокрЛП(Запись.П000010000306);
	ОбщаяСтрокаПослеВыбора = СокрЛП(НаименованиеПолное) + СокрЛП(ИНН) + СокрЛП(КПП);
	
	Если ОбщаяСтрокаДоВыбора <> ОбщаяСтрокаПослеВыбора Тогда
		
		Запись.П000010000305 = СокрЛП(ИНН);
		Запись.П000010000306 = СокрЛП(КПП);
		
		Если НЕ СокрЛП(Запись.П000010000304) = СокрЛП(НаименованиеПолное) Тогда
		
			Запись.П000010000304 = СокрЛП(НаименованиеПолное);
			Запись.П0000100003041 = "";	
			Запись.П0000100003042 = "";
		
		КонецЕсли;
		
		// Признак принадлежности к странам установлен автоматически.
		Запись.РезидентУстановленПользователем = Ложь;
		
		ОбработкаПослеИзменения();
		
	КонецЕсли;
		
	УправлениеВидимостью(Ложь);
	
КонецПроцедуры

#КонецОбласти
