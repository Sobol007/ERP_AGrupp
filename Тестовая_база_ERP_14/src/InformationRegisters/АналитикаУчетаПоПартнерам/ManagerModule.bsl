#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция получает элемент справочника - ключ аналитики учета.
//
// Параметры:
//	ПараметрыАналитики - Коллекция - Коллекция параметров для получения ключа.
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаПоПартнерам - Найденный элемент справочника.
//
Функция ЗначениеКлючаАналитики(ПараметрыАналитики) Экспорт

	КлючАналитики = Неопределено;
	
	НаборЗаписей = ПолучитьНаборЗаписей(ПараметрыАналитики);

	Если НаборЗаписей <> Неопределено Тогда
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0
			И Не ЗначениеЗаполнено(НаборЗаписей[0].КлючАналитики) Тогда
			НаборЗаписей.Очистить();
			НаборЗаписей.Записать();
		КонецЕсли;

		Если НаборЗаписей.Количество() > 0
			И ЗначениеЗаполнено(НаборЗаписей[0].КлючАналитики) Тогда
			КлючАналитики = НаборЗаписей[0].КлючАналитики;
		Иначе
			КлючАналитики = СоздатьКлючАналитики(ПараметрыАналитики);
		КонецЕсли;
	Иначе
		КлючАналитики = НаборЗаписей[0].КлючАналитики
	КонецЕсли;
	
	Возврат КлючАналитики;
КонецФункции

// Функция получает элемент справочника - ключ аналитики учета.
//
// Параметры:
//	ПараметрыАналитики - Выборка или Структура  с полями:
//		* Организация - СправочникСсылка.Организация - Организация, по которой запрашивается ключ.
//		* Партнер - СправочникСсылка.Партнеры - Партнер, по которому запрашивается ключ.
//		* Контрагент - СправочникСсылка.Контрагенты, СправочникСсылка.Организации - Контрагент, по которому запрашивается ключ.
//		* Договор - СправочникСсылка.ДоговорыКонтрагентов, СправочникСсылка.ДоговорыМеждуОрганизациями - Договор, по которому запрашивается ключ.
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаПоПартнерам - Найденный элемент справочника.
//
Функция СоздатьКлючАналитики(ПараметрыАналитики) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Аналитика.Партнер,
	|	Аналитика.Организация,
	|	Аналитика.Контрагент,
	|	Аналитика.Договор,
	|	Аналитика.НаправлениеДеятельности,
	|	Аналитика.КлючАналитики
	|ИЗ
	|	РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|ГДЕ
	|	Аналитика.Партнер = &Партнер
	|	И Аналитика.Организация = &Организация
	|	И Аналитика.Контрагент = &Контрагент
	|	И Аналитика.НаправлениеДеятельности = &НаправлениеДеятельности
	|	И (Аналитика.Договор = &Договор 
	|		ИЛИ (Аналитика.Договор = НЕОПРЕДЕЛЕНО И &ОбновитьДоговорВКлюче)
	|		ИЛИ (Аналитика.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|				И ТИПЗНАЧЕНИЯ(Аналитика.Контрагент) = ТИП(Справочник.Организации)
	|				И &ОбновитьДоговорВКлюче)
	|		)
	|");
	
	НаборЗаписей = РегистрыСведений.АналитикаУчетаПоПартнерам.СоздатьНаборЗаписей();
	
	ПоляРегистраКЗаполнению = ПоляРегистраКЗаполнению();
	СтруктураАналитики = Новый Структура(ПоляРегистраКЗаполнению);
	ЗаполнитьЗначенияСвойств(СтруктураАналитики, ПараметрыАналитики);
	
	Для Каждого КлючЗначение Из СтруктураАналитики Цикл
		НаборЗаписей.Отбор[КлючЗначение.Ключ].Установить(КлючЗначение.Значение);
	КонецЦикла;
		
	НоваяСтрока = НаборЗаписей.Добавить();
		
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураАналитики, ПоляРегистраКЗаполнению);
	
	Запрос.УстановитьПараметр("Партнер", НоваяСтрока.Партнер);
	Запрос.УстановитьПараметр("Организация", НоваяСтрока.Организация);
	Запрос.УстановитьПараметр("Контрагент", НоваяСтрока.Контрагент);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НоваяСтрока.НаправлениеДеятельности);
	
	Если ЗначениеЗаполнено(НоваяСтрока.Договор) Тогда
		Запрос.УстановитьПараметр("Договор", НоваяСтрока.Договор);
		Запрос.УстановитьПараметр("ОбновитьДоговорВКлюче", Ложь);
	Иначе
		Если ТипЗнч(НоваяСтрока.Контрагент) = Тип("СправочникСсылка.Организации") Тогда
			Запрос.УстановитьПараметр("Договор", Справочники.ДоговорыМеждуОрганизациями.ПустаяСсылка());
		Иначе
			Запрос.УстановитьПараметр("Договор", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		КонецЕсли;
		Запрос.УстановитьПараметр("ОбновитьДоговорВКлюче", Истина);
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда // создание нового ключа
		
		ПроверитьЗаполнениеПоляДоговор(НоваяСтрока);

		// Создание нового ключа аналитики.
		СправочникОбъект = Справочники.КлючиАналитикиУчетаПоПартнерам.СоздатьЭлемент();
		СправочникОбъект.Наименование = ПолучитьПолноеНаименованиеКлючаАналитики(НоваяСтрока);
		ЗаполнитьЗначенияСвойств(СправочникОбъект, ПараметрыАналитики, ПоляРегистраКЗаполнению);
		СправочникОбъект.Записать();

		Ключ = СправочникОбъект.Ссылка;

		НоваяСтрока.КлючАналитики = Ключ;
		НаборЗаписей.Записать(Ложь);
		
	Иначе // обновление договора в существующем ключе
		
		ДанныеКЗаполнению = Результат.Выгрузить()[0];
		
		НаборЗаписей.Отбор.Сбросить();
		
		НаборЗаписей.Отбор.Партнер.Установить(ДанныеКЗаполнению.Партнер);
		НаборЗаписей.Отбор.Организация.Установить(ДанныеКЗаполнению.Организация);
		НаборЗаписей.Отбор.Контрагент.Установить(ДанныеКЗаполнению.Контрагент);
		НаборЗаписей.Отбор.НаправлениеДеятельности.Установить(ДанныеКЗаполнению.НаправлениеДеятельности);
		
		НаборЗаписей.Прочитать();
		
		Для Каждого Запись Из НаборЗаписей Цикл
			
			Если Не ЗначениеЗаполнено(Запись.Договор) Тогда
				Если ТипЗнч(ДанныеКЗаполнению.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
					Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
				Иначе
					Договор = Справочники.ДоговорыМеждуОрганизациями.ПустаяСсылка();
				КонецЕсли;
				Запись.Договор = Договор;
				
				СпрОбъект = Запись.КлючАналитики.ПолучитьОбъект();
				СпрОбъект.Договор = Договор;
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпрОбъект);
				
				Ключ = Запись.КлючАналитики;
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЕсли;
	
	Возврат Ключ;

КонецФункции

// Функция возвращает массив из ключей аналитики учета по партнерам, в которых организация соответствует
// переданной в параметрах. Если передается пустая ссылка на справочник "Организации", 
// то формируется массив из ключей аналитик для всех доступных пользователю организаций
// Параметры:
//	Организация - СправочникСсылка.Организации - Организация, по которой формируется массив ключей.
//
// Возвращаемое значение:
//	Массив - Массив ключей по организации.
//
Функция КлючиАналитикиПоОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст ="
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеСправочника.Ссылка КАК Организация
		|ПОМЕСТИТЬ ВТОрганизации
		|ИЗ
		|	Справочник.Организации КАК ДанныеСправочника
		|ГДЕ
		|	ДанныеСправочника.Ссылка = &Организация
		|	ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АналитикаУчетаПоПартнерам.КлючАналитики КАК КлючАналитики
		|ИЗ
		|	ВТОрганизации КАК ВТОрганизации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
		|		ПО ВТОрганизации.Организация = АналитикаУчетаПоПартнерам.Организация";

	Запрос.УстановитьПараметр("Организация", Организация);
	
	МассивКлючейАналитикиПоПартнерам = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("КлючАналитики");
	
	Возврат МассивКлючейАналитикиПоПартнерам;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ПолучитьНаборЗаписей(ПараметрыАналитики)
	
	НаборЗаписей = РегистрыСведений.АналитикаУчетаПоПартнерам.СоздатьНаборЗаписей();
	
	// В параметрах аналитики могут быть не все свойства
	ПоляРегистраКЗаполнению = ПоляРегистраКЗаполнению();
	СтруктураАналитики = Новый Структура(ПоляРегистраКЗаполнению);
	ЗаполнитьЗначенияСвойств(СтруктураАналитики, ПараметрыАналитики);
	Если НЕ ЗначениеЗаполнено(СтруктураАналитики.Организация)
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.Партнер)
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.Контрагент) 
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.Договор)
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.НаправлениеДеятельности) Тогда
		Возврат НаборЗаписей
	Иначе
		
		Для Каждого КлючЗначение Из СтруктураАналитики Цикл
			НаборЗаписей.Отбор[КлючЗначение.Ключ].Установить(КлючЗначение.Значение);
		КонецЦикла;
		
		НоваяСтрока = НаборЗаписей.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураАналитики, ПоляРегистраКЗаполнению);
		ПроверитьЗаполнениеПоляДоговор(НоваяСтрока);
		Возврат НаборЗаписей;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПолноеНаименованиеКлючаАналитики(МенеджерЗаписи)
	
	Наименование = "";
	
	МетаданныеИзмерения = Метаданные.РегистрыСведений.АналитикаУчетаПоПартнерам.Измерения;
	Для Каждого Измерение Из МетаданныеИзмерения Цикл
		
		// Получим представление значения, которое указано в измерении регистра сведений.
		ТекстЗначения = Строка(МенеджерЗаписи[Измерение.Имя]);
		Если Не ПустаяСтрока(ТекстЗначения) Тогда
			Наименование = Наименование + ТекстЗначения + "; ";
		КонецЕсли;
		
	КонецЦикла;
	
	Если Прав(Наименование, 2) = "; " Тогда
		Наименование = Лев(Наименование, СтрДлина(Наименование) - 2);
	КонецЕсли;
	
	Возврат Наименование;
	
КонецФункции

Функция ПоляРегистраКЗаполнению()
	
	ПоляРегистраКЗаполнению = "";
	
	МетаданныеИзмерения = Метаданные.РегистрыСведений.АналитикаУчетаПоПартнерам.Измерения;
	Для Каждого Измерение Из МетаданныеИзмерения Цикл
		Если ЗначениеЗаполнено(ПоляРегистраКЗаполнению) Тогда
			ПоляРегистраКЗаполнению = ПоляРегистраКЗаполнению + ", " + Измерение.Имя;
		Иначе
			ПоляРегистраКЗаполнению = Измерение.Имя;
		КонецЕсли;
	КонецЦикла;
	Возврат ПоляРегистраКЗаполнению;
КонецФункции

Процедура ПроверитьЗаполнениеПоляДоговор(МенеджерЗаписи)

	Если ТипЗнч(МенеджерЗаписи.Договор) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
		И МенеджерЗаписи.Партнер = Справочники.Партнеры.НашеПредприятие
		И ТипЗнч(МенеджерЗаписи.Контрагент) = Тип("СправочникСсылка.Организации") Тогда
		ВызватьИсключение НСтр("ru = 'Ошибочное значение параметра ""Договор""';
								|en = 'Error value of the Contract parameter'");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли