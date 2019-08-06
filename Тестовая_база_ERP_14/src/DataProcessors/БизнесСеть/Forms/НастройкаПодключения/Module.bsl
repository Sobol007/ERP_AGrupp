
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Не БизнесСеть.ПравоНастройкиОбменаДокументами() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ИнформационнаяБазаПодключенаКСервису() Тогда
		ТекстОшибки = НСтр("ru = 'Информационная база не подключена к сервису 1С:Бизнес-сеть.';
							|en = 'Infobase is not connected to 1C:Business Network service.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ОбновитьИнформациюДляТехническойПоддержки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СинхронизироватьПользователей(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	БизнесСетьВызовСервера.ОбновитьПользователейВСервисе(Неопределено, Ложь, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Текст = НСтр("ru = 'Пользователи информационной базы синхронизированы с сервисом 1С:Бизнес-сеть.';
				|en = 'Infobase users are synchronized with 1C:Business Network service.'");
	ПоказатьОповещениеПользователя(НСтр("ru = '1С:Бизнес-сеть';
										|en = '1C:Business Network'"),, Текст, БиблиотекаКартинок.БизнесСеть);
	
	ОбновитьИнформациюДляТехническойПоддержки();
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьПодключение(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	БизнесСетьВызовСервера.ОбновитьПользователейВСервисе(Неопределено, Истина, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Текст = НСтр("ru = 'Информационная база синхронизирована с сервисом 1С:Бизнес-сеть.';
				|en = 'Infobase is synchronized with 1C:Business Network service.'");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	
	ОбновитьИнформациюДляТехническойПоддержки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьИнформационнуюБазу(Команда)
	
	ТекстВопроса = НСтр("ru = 'Будет произведено отключение информационной базы от сервиса 1С:БизнесСеть.
		|Для других участников сервиса, организации будут отображаться как зарегистрированные.';
		|en = 'The infobase will be disconnected from 1C:BusinessNetwork service.
		|The companies will be displayed as registered for other service participants.'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ОтключитьИнформационнуюБазуПродолжение", ЭтотОбъект),
		ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИнформационнаяБазаПодключенаКСервису()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПользователиБизнесСеть.Пользователь
	|ИЗ
	|	РегистрСведений.ПользователиБизнесСеть КАК ПользователиБизнесСеть";
	
	Результат = НЕ Запрос.Выполнить().Пустой();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьИнформациюДляТехническойПоддержки()
	
	// Получение идентификатора информационной базы.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПользователиБизнесСеть.Идентификатор КАК Идентификатор
	|ИЗ
	|	РегистрСведений.ПользователиБизнесСеть КАК ПользователиБизнесСеть
	|ГДЕ
	|	ПользователиБизнесСеть.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Истина);
	Ссылка = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.ПользователиБизнесСеть");
	ИдентификаторИнформационнойБазы = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Ссылка, "ПарольБизнесСеть");
	Если ТипЗнч(ИдентификаторИнформационнойБазы) <> Тип("Строка") Тогда
		ИдентификаторИнформационнойБазы = "";
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	ИдентификаторПользователя = "";
	Если Выборка.Следующий() Тогда
		ИдентификаторПользователя = Выборка.Идентификатор;
	КонецЕсли;
	
	Шаблон = НСтр("ru = 'Регистрация в сервисе 1С:Бизнес-сеть:';
					|en = 'Registration in 1C:Business Network service:'");
	Если НЕ ПустаяСтрока(ИдентификаторИнформационнойБазы) Тогда
		Шаблон = Шаблон + Символы.ПС + НСтр("ru = 'Ключ информационной базы: %1';
											|en = 'Infobase key: %1'");
	КонецЕсли;
	Если НЕ ПустаяСтрока(ИдентификаторПользователя) Тогда
		Шаблон = Шаблон + Символы.ПС + НСтр("ru = 'Ключ пользователя: %2';
											|en = 'User key: %2'");
	КонецЕсли;
	
	Шаблон = Шаблон + Символы.ПС + НСтр("ru = 'Версия библиотеки электронных документов: %3';
										|en = 'Version of electronic document library: %3'");
	
	ВерсияБиблиотеки = ОбновлениеИнформационнойБазыБЭД.ВерсияБиблиотеки();
	
	ТекстДляТехнологическойПоддержки = СтрШаблон(Шаблон,
		ИдентификаторИнформационнойБазы, ИдентификаторПользователя, ВерсияБиблиотеки);
		
	ОбновитьИнформациюСостояниеСинхронизацииПользователей();
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюСостояниеСинхронизацииПользователей()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Получение списка пользователей информационной базы.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Пользователи.Ссылка КАК Ссылка,
	|	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи";
	
	СписокПользователей = Запрос.Выполнить().Выгрузить();
	
	// Анализ ролей пользователей программы для регистрации в сервисе.
	СтрокиУдаления = Новый Массив;
	Для каждого СтрокаТаблицы Из СписокПользователей Цикл
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(СтрокаТаблицы.ИдентификаторПользователяИБ);
		Если ПользовательИБ = Неопределено Тогда
			СтрокиУдаления.Добавить(СтрокаТаблицы);
			Продолжить;
		КонецЕсли;
		
		ПравоВыполненияОбменаДокументами = ПравоДоступа("Просмотр", Метаданные.ОбщиеКоманды.ВходящиеДокументыБизнесСеть,
			СтрокаТаблицы.Ссылка);
		ПравоИзмененияНастроек = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ОрганизацииБизнесСеть,
			СтрокаТаблицы.Ссылка);
			
		Если НЕ ПравоВыполненияОбменаДокументами И НЕ ПравоИзмененияНастроек Тогда
			СтрокиУдаления.Добавить(СтрокаТаблицы);
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
	// Удаление незарегистрированных пользователей.
	Для каждого СтрокаУдаления Из СтрокиУдаления Цикл
		СписокПользователей.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокПользователей.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ СписокПользователей
	|ИЗ
	|	&СписокПользователей КАК СписокПользователей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Пользователь КАК Пользователь
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВложенныйЗапрос.Пользователь КАК Пользователь,
	|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВложенныйЗапрос.ЭтоПользователи) КАК ЭтоПользователи,
	|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВложенныйЗапрос.ЭтоИдентификаторы) КАК ЭтоИдентификаторы
	|	ИЗ
	|		(ВЫБРАТЬ
	|			СписокПользователей.Ссылка КАК Пользователь,
	|			ИСТИНА КАК ЭтоПользователи,
	|			NULL КАК ЭтоИдентификаторы
	|		ИЗ
	|			СписокПользователей КАК СписокПользователей
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ПользователиБизнесСеть.Пользователь,
	|			NULL,
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.ПользователиБизнесСеть КАК ПользователиБизнесСеть
	|		ГДЕ
	|			ПользователиБизнесСеть.Пользователь <> &НеуказанныйПользователь) КАК ВложенныйЗапрос
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВложенныйЗапрос.Пользователь) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.ЭтоПользователи <> ВложенныйЗапрос.ЭтоИдентификаторы";
	
	Запрос.УстановитьПараметр("СписокПользователей", СписокПользователей);
	
	НеуказанныйПользователь = Пользователи.СсылкаНеуказанногоПользователя();
	Запрос.УстановитьПараметр("НеуказанныйПользователь", НеуказанныйПользователь);
	
	Если Запрос.Выполнить().Пустой() Тогда
		
		СостояниеСинхронизацииПользователей = НСтр("ru = 'Синхронизация пользователей не требуется.';
													|en = 'User synchronization is not required.'");
		Элементы.СостояниеСинхронизацииПользователей.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
		
	Иначе
		
		СостояниеСинхронизацииПользователей = НСтр("ru = 'Требуется синхронизация пользователей.';
													|en = 'User synchronization is required.'");
		Элементы.СостояниеСинхронизацииПользователей.ЦветТекста = ЦветаСтиля.ПоясняющийОшибкуТекст;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьИнформационнуюБазуПродолжение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ТребуетсяОбновитьИнтерфейс = Ложь;
	
	БизнесСетьВызовСервера.ОтключитьОрганизации(Неопределено, Ложь, Отказ, ТребуетсяОбновитьИнтерфейс);
	Если ТребуетсяОбновитьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ОбновитьИнтерфейс();
		#КонецЕсли
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	СправочникОрганизации = ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп.ИмяПрикладногоСправочника("Организации");
	ОповеститьОбИзменении(Тип("СправочникСсылка." + СправочникОрганизации));
	Оповестить("БизнесСеть_РегистрацияОрганизаций");
	
	ПоказатьОповещениеПользователя(НСтр("ru = '1С:Бизнес-сеть';
										|en = '1C:Business Network'"),,
		НСтр("ru = 'Информационная база отключена от сервиса 1С:Бизнес-сеть.';
			|en = 'Infobase is disconnected from 1C:Business Network service.'"), БиблиотекаКартинок.БизнесСеть);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти