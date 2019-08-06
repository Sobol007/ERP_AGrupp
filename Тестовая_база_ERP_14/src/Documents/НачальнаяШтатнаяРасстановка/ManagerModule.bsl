#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// используется при загрузке данных
Процедура РассчитатьФОТПоДокументу(ДокументОбъект) Экспорт

	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	ИзвестныеКадровыеДанные = ПлановыеНачисленияСотрудников.СоздатьТаблицаКадровыхДанных();
		
	Отбор = Новый Структура("Сотрудник");
	Для каждого СтрокаСотрудник Из ДокументОбъект.Сотрудники Цикл
		
		КадровыеДанныеСотрудника = ИзвестныеКадровыеДанные.Добавить();
		КадровыеДанныеСотрудника.Сотрудник = СтрокаСотрудник.Сотрудник;
		КадровыеДанныеСотрудника.Период = ДокументОбъект.Месяц;
		КадровыеДанныеСотрудника.Организация = ДокументОбъект.Организация;
		КадровыеДанныеСотрудника.Подразделение = ДокументОбъект.Подразделение;
		КадровыеДанныеСотрудника.ГрафикРаботы = СтрокаСотрудник.ГрафикРаботы;
		КадровыеДанныеСотрудника.КоличествоСтавок = СтрокаСотрудник.КоличествоСтавок;
	    				
		Отбор.Сотрудник = СтрокаСотрудник.Сотрудник;
		СтрокиНачисления = ДокументОбъект.Начисления.Выгрузить(Отбор);
		Для Каждого СтрокаНачисления Из СтрокиНачисления Цикл
			ДанныеНачисления = ТаблицаНачислений.Добавить();
			ДанныеНачисления.Сотрудник = СтрокаНачисления.Сотрудник;
			ДанныеНачисления.Период = ДокументОбъект.Месяц;
			ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
			ДанныеНачисления.Размер = СтрокаНачисления.Размер;
		КонецЦикла;
		
		СтрокиПоказателя = ДокументОбъект.Показатели.Выгрузить(Отбор);
		Для Каждого СтрокаПоказателя Из СтрокиПоказателя Цикл
			ДанныеПоказателя = ТаблицаПоказателей.Добавить();
			ДанныеПоказателя.Сотрудник = СтрокаНачисления.Сотрудник;
			ДанныеПоказателя.Период = ДокументОбъект.Месяц;
			ДанныеПоказателя.Показатель = СтрокаПоказателя.Показатель;
			ДанныеПоказателя.Значение = СтрокаПоказателя.Значение;
		КонецЦикла;
				
	КонецЦикла;
	
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей, ИзвестныеКадровыеДанные);
	Отбор = Новый Структура("Сотрудник,Начисление");
	Для Каждого ОписаниеНачисления Из РассчитанныеДанные.ПлановыйФОТ Цикл
		ЗаполнитьЗначенияСвойств(Отбор,ОписаниеНачисления);
		СтрокиДокумента = ДокументОбъект.Начисления.НайтиСтроки(Отбор);
		Если СтрокиДокумента.Количество() > 0 Тогда
			СтрокиДокумента[0].Размер = ОписаниеНачисления.ВкладВФОТ;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.НачальнаяШтатнаяРасстановка;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти	


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	ДанныеДляРегистрации = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачальнаяШтатнаяРасстановкаСотрудники.Сотрудник,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Подразделение,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Должность,
	|	НачальнаяШтатнаяРасстановкаСотрудники.ДолжностьПоШтатномуРасписанию,
	|	НачальнаяШтатнаяРасстановкаСотрудники.КоличествоСтавок,
	|	НачальнаяШтатнаяРасстановкаСотрудники.ГрафикРаботы,
	|	НачальнаяШтатнаяРасстановкаСотрудники.ВидЗанятости,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Ссылка.Месяц,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Ссылка КАК Ссылка,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Ссылка.Организация КАК Организация
	|ИЗ
	|	Документ.НачальнаяШтатнаяРасстановка.Сотрудники КАК НачальнаяШтатнаяРасстановкаСотрудники
	|ГДЕ
	|	НачальнаяШтатнаяРасстановкаСотрудники.Ссылка В(&МассивСсылок)
	|	И НачальнаяШтатнаяРасстановкаСотрудники.Сотрудник = НачальнаяШтатнаяРасстановкаСотрудники.Сотрудник.ГоловнойСотрудник
	|	И НЕ НачальнаяШтатнаяРасстановкаСотрудники.Ссылка.ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровССотрудниками.ВоеннослужащийПоПризыву), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровССотрудниками.КонтрактВоеннослужащего))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		ДанныеДляРегистрацииПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрации.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииПоДокументу);
		
		Пока Выборка.Следующий() Цикл
			ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
			ОписаниеПериода.Сотрудник = Выборка.Сотрудник;	
			ОписаниеПериода.ДатаНачалаПериода = Выборка.Месяц;
			ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;
			ОписаниеПериода.ВидЗанятости = Выборка.ВидЗанятости;

			РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииПоДокументу, ОписаниеПериода);
										
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ДолжностьПоШтатномуРасписанию", Выборка.ДолжностьПоШтатномуРасписанию);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Должность", Выборка.Должность);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "КоличествоСтавок", Выборка.КоличествоСтавок);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ГрафикРаботы", Выборка.ГрафикРаботы);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии);

		КонецЦикла;	
		
	КонецЦикла;	
	
	Возврат ДанныеДляРегистрации;
	
КонецФункции	

Процедура ПеренестиДвиженияКадровойИсторииНаДатуОтсчетаПериодическихСведений(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ДатаНачала", ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений());
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КадроваяИсторияСотрудников.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТРегистраторы
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|		ПО КадроваяИсторияСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
		|			И (НАЧАЛОПЕРИОДА(КадроваяИсторияСотрудников.Период, ДЕНЬ) <> ТекущиеКадровыеДанныеСотрудников.ДатаПриема)
		|			И (КадроваяИсторияСотрудников.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.НачальныеДанные))
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(КадроваяИсторияСотрудников.Период, ДЕНЬ) <> &ДатаНачала
		|	И НАЧАЛОПЕРИОДА(КадроваяИсторияСотрудников.Период, ДЕНЬ) <> ВЫРАЗИТЬ(КадроваяИсторияСотрудников.Регистратор КАК Документ.НачальнаяШтатнаяРасстановка).Месяц
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Регистраторы.Регистратор КАК Регистратор
		|ИЗ
		|	ВТРегистраторы КАК Регистраторы";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбработкаЗавершена = Ложь;
		
		// Кадровая история
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор КАК Регистратор,
			|	ВЫБОР
			|		КОГДА ТекущиеКадровыеДанныеСотрудников.ДатаПриема = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &ДатаНачала
			|		ИНАЧЕ ТекущиеКадровыеДанныеСотрудников.ДатаПриема
			|	КОНЕЦ КАК Период,
			|	КадроваяИсторияСотрудников.*
			|ПОМЕСТИТЬ ВТДанныеРегистратров
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|			ПО КадроваяИсторияСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
			|		ПО Регистраторы.Регистратор = КадроваяИсторияСотрудников.Регистратор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДанныеРегистратров.Сотрудник КАК Сотрудник
			|ПОМЕСТИТЬ ВТОтборДляПереформирования
			|ИЗ
			|	ВТДанныеРегистратров КАК ДанныеРегистратров
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДанныеРегистратров.*
			|ИЗ
			|	ВТДанныеРегистратров КАК ДанныеРегистратров
			|
			|УПОРЯДОЧИТЬ ПО
			|	Регистратор";
			
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.КадроваяИсторияСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НаборЗаписей = РегистрыСведений.КадроваяИсторияСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			
			Пока Выборка.Следующий() Цикл
				
				НоваяСтрока = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, , "Период, Регистратор");
				
				НоваяСтрока.Период = Выборка.Период;
				НоваяСтрока.Регистратор = Выборка.Регистратор;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
		ПараметрыПостроения = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияИнтервальногоРегистра();
		ПараметрыПостроения.ПараметрыРесурсов = ЗарплатаКадрыПериодическиеРегистры.ПараметрыНаследованияРесурсов("КадроваяИсторияСотрудников");
		
		ПараметрыПостроения.ОсновноеИзмерение = "Сотрудник";
		
		ПараметрыПостроения.Вставить("ПолноеПереформирование", Истина);
		ПараметрыПостроения.Вставить("РежимЗагрузки", Истина);
		
		ЗарплатаКадрыПериодическиеРегистры.СформироватьДвиженияИнтервальногоРегистра(
			"КадроваяИсторияСотрудников", Запрос.МенеджерВременныхТаблиц, ПараметрыПостроения, ПараметрыОбновления);
		
		// Виды занятости
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор КАК Регистратор,
			|	ВЫБОР
			|		КОГДА ТекущиеКадровыеДанныеСотрудников.ДатаПриема = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &ДатаНачала
			|		ИНАЧЕ ТекущиеКадровыеДанныеСотрудников.ДатаПриема
			|	КОНЕЦ КАК Период,
			|	ВидыЗанятостиСотрудников.*
			|ПОМЕСТИТЬ ВТДанныеРегистратровВидыЗанятостиСотрудников
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудников КАК ВидыЗанятостиСотрудников
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|			ПО ВидыЗанятостиСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
			|		ПО Регистраторы.Регистратор = ВидыЗанятостиСотрудников.Регистратор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДанныеРегистратров.Сотрудник КАК Сотрудник
			|ПОМЕСТИТЬ ВТОтборДляПереформирования
			|ИЗ
			|	ВТДанныеРегистратровВидыЗанятостиСотрудников КАК ДанныеРегистратров
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДанныеРегистратров.*
			|ИЗ
			|	ВТДанныеРегистратровВидыЗанятостиСотрудников КАК ДанныеРегистратров
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДанныеРегистратров.Регистратор";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.ВидыЗанятостиСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НаборЗаписей = РегистрыСведений.ВидыЗанятостиСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			
			Пока Выборка.Следующий() Цикл
				
				НоваяСтрока = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, , "Период, Регистратор");
				
				НоваяСтрока.Период = Выборка.Период;
				НоваяСтрока.Регистратор = Выборка.Регистратор;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
		ПараметрыПостроения = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияИнтервальногоРегистра();
		ПараметрыПостроения.ПараметрыРесурсов = ЗарплатаКадрыПериодическиеРегистры.ПараметрыНаследованияРесурсов("ВидыЗанятостиСотрудников");
		
		ПараметрыПостроения.ОсновноеИзмерение = "Сотрудник";
		
		ПараметрыПостроения.Вставить("ПолноеПереформирование", Истина);
		ПараметрыПостроения.Вставить("РежимЗагрузки", Истина);
		
		ЗарплатаКадрыПериодическиеРегистры.СформироватьДвиженияИнтервальногоРегистра(
			"ВидыЗанятостиСотрудников", Запрос.МенеджерВременныхТаблиц, ПараметрыПостроения, ПараметрыОбновления);
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбработкаЗавершена);
	
КонецПроцедуры

Процедура ПеренестиДвиженияДанныхСостоянийСотрудниковНаДатуОтсчетаПериодическихСведений(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеСостоянийСотрудников.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТРегистраторы
		|ИЗ
		|	РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|		ПО ДанныеСостоянийСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
		|			И (НАЧАЛОПЕРИОДА(ДанныеСостоянийСотрудников.Начало, ДЕНЬ) <> ТекущиеКадровыеДанныеСотрудников.ДатаПриема)
		|			И (ТИПЗНАЧЕНИЯ(ДанныеСостоянийСотрудников.Регистратор) = ТИП(Документ.НачальнаяШтатнаяРасстановка))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Регистраторы.Регистратор КАК Регистратор
		|ИЗ
		|	ВТРегистраторы КАК Регистраторы";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбработкаЗавершена = Ложь;
		
		Запрос.УстановитьПараметр("ДатаНачала", ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений());
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор КАК Регистратор,
			|	ВЫБОР
			|		КОГДА ТекущиеКадровыеДанныеСотрудников.ДатаПриема = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &ДатаНачала
			|		ИНАЧЕ ТекущиеКадровыеДанныеСотрудников.ДатаПриема
			|	КОНЕЦ КАК Начало,
			|	ДанныеСостоянийСотрудников.*
			|ПОМЕСТИТЬ ВТДанныеКОбновлению
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|			ПО ДанныеСостоянийСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
			|		ПО Регистраторы.Регистратор = ДанныеСостоянийСотрудников.Регистратор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДанныеКОбновлению.Сотрудник КАК Сотрудник,
			|	ДанныеКОбновлению.Начало КАК Начало,
			|	ДанныеКОбновлению.Окончание КАК Окончание
			|ПОМЕСТИТЬ ВТКлючиИзменившихсяДанных
			|ИЗ
			|	ВТДанныеКОбновлению КАК ДанныеКОбновлению
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДанныеКОбновлению.*
			|ИЗ
			|	ВТДанныеКОбновлению КАК ДанныеКОбновлению
			|
			|УПОРЯДОЧИТЬ ПО
			|	Регистратор";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.ДанныеСостоянийСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НаборЗаписей = РегистрыСведений.ДанныеСостоянийСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			
			Пока Выборка.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
		СостоянияСотрудников.ОбновитьСостоянияСотрудников(Запрос.МенеджерВременныхТаблиц, , Истина);
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбработкаЗавершена);
	
КонецПроцедуры

Процедура ЗаполнитьНеподтвержденныеДанные(ПараметрыОбновления) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КадроваяИсторияСотрудников.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТРегистраторыНеподтвержденныхДанных
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(КадроваяИсторияСотрудников.Регистратор) = ТИП(Документ.НачальнаяШтатнаяРасстановка)
		|	И КадроваяИсторияСотрудников.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.НеподтвержденныеДанные)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	КадроваяИсторияСотрудников.Регистратор КАК Регистратор,
		|	ВЫРАЗИТЬ(КадроваяИсторияСотрудников.Регистратор КАК Документ.НачальнаяШтатнаяРасстановка).Месяц КАК Месяц
		|ПОМЕСТИТЬ ВТРегистраторыКадровойИстории
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРегистраторыНеподтвержденныхДанных КАК РегистраторыНеподтвержденныхДанных
		|		ПО КадроваяИсторияСотрудников.Регистратор = РегистраторыНеподтвержденныхДанных.Регистратор
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(КадроваяИсторияСотрудников.Регистратор) = ТИП(Документ.НачальнаяШтатнаяРасстановка)
		|	И КадроваяИсторияСотрудников.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.НачальныеДанные)
		|	И РегистраторыНеподтвержденныхДанных.Регистратор ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистраторыКадровойИстории.Регистратор КАК Регистратор,
		|	РегистраторыКадровойИстории.Месяц КАК Месяц
		|ИЗ
		|	ВТРегистраторыКадровойИстории КАК РегистраторыКадровойИстории";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	Иначе
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		
		ДатаОтсчетаПериодическихСведений = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений();
		СписокОбновленныхРегистраторов = Новый Массив;
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	РегистраторыКадровойИстории.Месяц КАК Месяц,
			|	КадроваяИсторияСотрудников.Сотрудник КАК Сотрудник
			|ИЗ
			|	ВТРегистраторыКадровойИстории КАК РегистраторыКадровойИстории
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
			|		ПО (РегистраторыКадровойИстории.Месяц = НАЧАЛОПЕРИОДА(КадроваяИсторияСотрудников.Период, ДЕНЬ))
			|			И (КадроваяИсторияСотрудников.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение))";
		
		ИсключаемыеСотрудникиПериоды = Запрос.Выполнить().Выгрузить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НачатьТранзакцию();
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КадроваяИсторияСотрудников.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ВидыЗанятостиСотрудников.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДанныеСостоянийСотрудников.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			
			Попытка
				Блокировка.Заблокировать();
			Исключение
				
				ОтменитьТранзакцию();
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы.Ошибка блокировки';
												|en = 'Updating the infobase.Lock error'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Предупреждение, , Выборка.Регистратор, "РегистрСведений.КадроваяИсторияСотрудников.НаборЗаписей");
				
				Продолжить;
				
			КонецПопытки;
			
			СписокОбновленныхРегистраторов.Добавить(Выборка.Регистратор);
			
			// КадроваяИсторияСотрудников
			НаборЗаписей = РегистрыСведений.КадроваяИсторияСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Прочитать();
			
			ТаблицаНабора = НаборЗаписей.Выгрузить();
			ТаблицаНабораНеподтвержденных = ТаблицаНабора.СкопироватьКолонки();
			
			ИсключаемыеЗаписи = Новый Массив;
			Для Каждого Запись Из ТаблицаНабора Цикл
				
				Если Запись.Период = ДатаОтсчетаПериодическихСведений Тогда
					
					Запись.ВидСобытия = Перечисления.ВидыКадровыхСобытий.НеподтвержденныеДанные;
					Продолжить;
					
				КонецЕсли;
				
				СтруктураПоиска = Новый Структура("Сотрудник,ГоловнаяОрганизация,ФизическоеЛицо");
				ЗаполнитьЗначенияСвойств(СтруктураПоиска, Запись);
				
				СтруктураПоиска.Вставить("Период", ДатаОтсчетаПериодическихСведений);
				
				НайденныеСтроки = ТаблицаНабора.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество() > 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Запись.Период = Выборка.Месяц;
				
				ЗаписьНеподтвержденных = ТаблицаНабораНеподтвержденных.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьНеподтвержденных, Запись);
				
				ЗаписьНеподтвержденных.ВидСобытия = Перечисления.ВидыКадровыхСобытий.НеподтвержденныеДанные;
				ЗаписьНеподтвержденных.Период = ДатаОтсчетаПериодическихСведений;
				
				Если ИсключаемыеСотрудникиПериоды.НайтиСтроки(Новый Структура("Месяц,Сотрудник", Запись.Период, Запись.Сотрудник)).Количество() > 0 Тогда
					ИсключаемыеЗаписи.Добавить(Запись);
				КонецЕсли;
				
			КонецЦикла;
			
			Для Каждого ИсключаемаяЗапись Из ИсключаемыеЗаписи Цикл
				ТаблицаНабора.Удалить(ИсключаемаяЗапись);
			КонецЦикла;
			
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаНабораНеподтвержденных, ТаблицаНабора);
			НаборЗаписей.Загрузить(ТаблицаНабора);
			
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			// ВидыЗанятостиСотрудников
			НаборЗаписей = РегистрыСведений.ВидыЗанятостиСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.Период = ДатаОтсчетаПериодическихСведений;
			КонецЦикла;
			
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			// ДанныеСостоянийСотрудников
			НаборЗаписей = РегистрыСведений.ДанныеСостоянийСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.Начало = ДатаОтсчетаПериодическихСведений;
			КонецЦикла;
			
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
			
		КонецЦикла;
		
		Если СписокОбновленныхРегистраторов.Количество() > 0 Тогда
			
			Запрос.УстановитьПараметр("СписокОбновленныхРегистраторов", СписокОбновленныхРегистраторов);
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ВидыЗанятостиСотрудников.Сотрудник КАК Сотрудник
				|ПОМЕСТИТЬ ВТОтборДляПереформирования
				|ИЗ
				|	РегистрСведений.ВидыЗанятостиСотрудников КАК ВидыЗанятостиСотрудников
				|ГДЕ
				|	ВидыЗанятостиСотрудников.Регистратор В(&СписокОбновленныхРегистраторов)";
			
			Запрос.Выполнить();
			РегистрыСведений.ВидыЗанятостиСотрудников.СформироватьДвиженияИнтервальногоРегистра(Запрос.МенеджерВременныхТаблиц, ПараметрыОбновления);
			
			ЗарплатаКадры.УничтожитьВТ(Запрос.МенеджерВременныхТаблиц, "ВТОтборДляПереформирования", Истина);
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	КадроваяИсторияСотрудников.Сотрудник КАК Сотрудник
				|ПОМЕСТИТЬ ВТОтборДляПереформирования
				|ИЗ
				|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
				|ГДЕ
				|	КадроваяИсторияСотрудников.Регистратор В(&СписокОбновленныхРегистраторов)";
			
			Запрос.Выполнить();
			РегистрыСведений.КадроваяИсторияСотрудников.СформироватьДвиженияИнтервальногоРегистра(Запрос.МенеджерВременныхТаблиц, ПараметрыОбновления);
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ДанныеСостоянийСотрудников.Сотрудник КАК Сотрудник,
				|	ДанныеСостоянийСотрудников.Начало КАК Начало,
				|	ДанныеСостоянийСотрудников.Окончание КАК Окончание
				|ПОМЕСТИТЬ ВТКлючиИзменившихсяДанных
				|ИЗ
				|	РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
				|ГДЕ
				|	ДанныеСостоянийСотрудников.Регистратор В(&СписокОбновленныхРегистраторов)";
			
			Запрос.Выполнить();
			СостоянияСотрудников.ОбновитьСостоянияСотрудников(Запрос.МенеджерВременныхТаблиц, , Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНеподтвержденныеДанныеСостоянийСотрудников(ПараметрыОбновления) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДатаОтсчетаПериодическихСведений = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений();
	Запрос.УстановитьПараметр("ДатаОтсчетаПериодическихСведений", ДатаОтсчетаПериодическихСведений);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеСостоянийСотрудников.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ДанныеСостоянийСотрудников.Регистратор) = ТИП(Документ.НачальнаяШтатнаяРасстановка)
		|	И ДанныеСостоянийСотрудников.Начало <> &ДатаОтсчетаПериодическихСведений";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	Иначе
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		
		СписокОбновленныхРегистраторов = Новый Массив;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.ДанныеСостоянийСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			СписокОбновленныхРегистраторов.Добавить(Выборка.Регистратор);
			
			НаборЗаписей = РегистрыСведений.ДанныеСостоянийСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.Начало = ДатаОтсчетаПериодическихСведений;
			КонецЦикла;
			
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
		Если СписокОбновленныхРегистраторов.Количество() > 0 Тогда
			
			Запрос.УстановитьПараметр("СписокОбновленныхРегистраторов", СписокОбновленныхРегистраторов);
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ДанныеСостоянийСотрудников.Сотрудник КАК Сотрудник,
				|	ДанныеСостоянийСотрудников.Начало КАК Начало,
				|	ДанныеСостоянийСотрудников.Окончание КАК Окончание
				|ПОМЕСТИТЬ ВТКлючиИзменившихсяДанных
				|ИЗ
				|	РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
				|ГДЕ
				|	ДанныеСостоянийСотрудников.Регистратор В(&СписокОбновленныхРегистраторов)";
			
			Запрос.Выполнить();
			СостоянияСотрудников.ОбновитьСостоянияСотрудников(Запрос.МенеджерВременныхТаблиц, , Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНеподтвержденныеДанныеГрафиковРаботы(ПараметрыОбновления) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДатаОтсчетаПериодическихСведений = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений();
	Запрос.УстановитьПараметр("ДатаОтсчетаПериодическихСведений", ДатаОтсчетаПериодическихСведений);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГрафикРаботыСотрудников.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.ГрафикРаботыСотрудников КАК ГрафикРаботыСотрудников
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ГрафикРаботыСотрудников.Регистратор) = ТИП(Документ.НачальнаяШтатнаяРасстановка)
		|	И НАЧАЛОПЕРИОДА(ГрафикРаботыСотрудников.Период, ДЕНЬ) <> &ДатаОтсчетаПериодическихСведений";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	Иначе
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		
		СписокОбновленныхРегистраторов = Новый Массив;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.ГрафикРаботыСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			СписокОбновленныхРегистраторов.Добавить(Выборка.Регистратор);
			
			НаборЗаписей = РегистрыСведений.ГрафикРаботыСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Прочитать();
			
			ТаблицаНабора = НаборЗаписей.Выгрузить();
			НоваяТаблицаНабора = ТаблицаНабора.СкопироватьКолонки();
			
			Для Каждого СтрокаТаблицаНабора Из ТаблицаНабора Цикл
				
				СтруктураПоиска = Новый Структура("Период,Сотрудник", ДатаОтсчетаПериодическихСведений, СтрокаТаблицаНабора.Сотрудник);
				Если НоваяТаблицаНабора.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
					
					СтрокаНоваяТаблицаНабора = НоваяТаблицаНабора.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаНоваяТаблицаНабора, СтрокаТаблицаНабора);
					СтрокаНоваяТаблицаНабора.Период = ДатаОтсчетаПериодическихСведений;
					
				КонецЕсли;
				
			КонецЦикла;
			
			НаборЗаписей.Загрузить(НоваяТаблицаНабора);
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
		Если СписокОбновленныхРегистраторов.Количество() > 0 Тогда
			
			Запрос.УстановитьПараметр("СписокОбновленныхРегистраторов", СписокОбновленныхРегистраторов);
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ГрафикРаботыСотрудников.Сотрудник КАК Сотрудник
				|ПОМЕСТИТЬ ВТОтборДляПереформирования
				|ИЗ
				|	РегистрСведений.ГрафикРаботыСотрудников КАК ГрафикРаботыСотрудников
				|ГДЕ
				|	ГрафикРаботыСотрудников.Регистратор В(&СписокОбновленныхРегистраторов)";
			
			Запрос.Выполнить();
			РегистрыСведений.ГрафикРаботыСотрудников.СформироватьДвиженияИнтервальногоРегистра(Запрос.МенеджерВременныхТаблиц, ПараметрыОбновления);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли