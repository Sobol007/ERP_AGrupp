#Область ПрограммныйИнтерфейс

// Регистрирует начисления и удержания по прочим доходам в учете.
//
// Параметры:
//		Движения          - КоллекцияДвижений, коллекция наборов записей движений расчетного документа.
//  	Отказ             - Булево - признак отказа выполнения операции.
//		Организация       - СправочникСсылка.Организации
//		ПериодРегистрации - Дата  - первое число месяца периода регистрации.
//		СпособРасчетов    - ПеречисленияСсылка.СпособыРасчетовСФизическимиЛицами
//		Начисления        - ТаблицаЗначений - соответствует структуре регистра накопления НачисленияУдержанияПоКонтрагентамАкционерам.
//		Удержания         - ТаблицаЗначений - соответствует структуре регистра накопления НачисленияУдержанияПоКонтрагентамАкционерам.
//		ЗаписыватьДвижения- Булево, признак необходимости записи движений.
//
Процедура ЗарегистрироватьНачисленияУдержанияПоКонтрагентамАкционерам(Движения, Отказ, Организация, ПериодРегистрации, СпособРасчетов, Начисления = Неопределено, Удержания = Неопределено, ЗаписыватьДвижения = Ложь) Экспорт
	
	КолонкиСуммирования = "СуммаВзаиморасчетов";
	КолонкиГруппировок = "ФизическоеЛицо,СтатьяФинансирования,СтатьяРасходов,Сотрудник";
	
	УточнятьСпособРасчетов = (СпособРасчетов = Перечисления.СпособыРасчетовСФизическимиЛицами.Дивиденды);
	
	Если Начисления <> Неопределено Тогда
		
		ТаблицаНачислений = Начисления.Скопировать();
		ТаблицаНачислений.Колонки.Сумма.Имя = "СуммаВзаиморасчетов";
		ТаблицаНачислений.Свернуть(КолонкиГруппировок,КолонкиСуммирования);
		
		Для каждого СтрокаТЗ Из ТаблицаНачислений Цикл
			НоваяСтрока = Движения.ВзаиморасчетыСКонтрагентамиАкционерами.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ);
			Если УточнятьСпособРасчетов И ЗначениеЗаполнено(НоваяСтрока.Сотрудник) Тогда
				НоваяСтрока.СпособРасчетов = Перечисления.СпособыРасчетовСФизическимиЛицами.ДивидендыСотрудникам;
			Иначе
				НоваяСтрока.СпособРасчетов = СпособРасчетов;
			КонецЕсли;
			НоваяСтрока.Период				= ПериодРегистрации;
			НоваяСтрока.Организация			= Организация;
			НоваяСтрока.ДокументОснование 	= Движения.ВзаиморасчетыСКонтрагентамиАкционерами.Отбор.Регистратор.Значение;
			НоваяСтрока.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Начислено;
		КонецЦикла;
		
		Движения.ВзаиморасчетыСКонтрагентамиАкционерами.Записывать = Истина;
		
	КонецЕсли;
	 
	Если Удержания <> Неопределено Тогда
		
		ТаблицаУдержаний = Удержания.Скопировать();
		ТаблицаУдержаний.Колонки.Сумма.Имя = "СуммаВзаиморасчетов";
		ТаблицаУдержаний.Свернуть(КолонкиГруппировок,КолонкиСуммирования);
		
		Для каждого СтрокаТЗ Из ТаблицаУдержаний Цикл
			НоваяСтрока = Движения.ВзаиморасчетыСКонтрагентамиАкционерами.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ);
			Если УточнятьСпособРасчетов И ЗначениеЗаполнено(НоваяСтрока.Сотрудник) Тогда
				НоваяСтрока.СпособРасчетов = Перечисления.СпособыРасчетовСФизическимиЛицами.ДивидендыСотрудникам;
			Иначе
				НоваяСтрока.СпособРасчетов = СпособРасчетов;
			КонецЕсли;
			НоваяСтрока.Период				= ПериодРегистрации;
			НоваяСтрока.Организация			= Организация;
			НоваяСтрока.СуммаВзаиморасчетов = - НоваяСтрока.СуммаВзаиморасчетов;
			НоваяСтрока.ДокументОснование 	= Движения.ВзаиморасчетыСКонтрагентамиАкционерами.Отбор.Регистратор.Значение;
			НоваяСтрока.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Удержано;
		КонецЦикла;
		
		Движения.ВзаиморасчетыСКонтрагентамиАкционерами.Записывать = Истина;
		
	КонецЕсли;
	
	Если ЗаписыватьДвижения Тогда
		Движения.ВзаиморасчетыСКонтрагентамиАкционерами.Записать();
		Движения.ВзаиморасчетыСКонтрагентамиАкционерами.Записывать = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт

	Списки.Вставить(Метаданные.Справочники.ВедомостьПрочихДоходовВБанкПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Справочники.ВедомостьПрочихДоходовВКассуПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Справочники.ВедомостьПрочихДоходовПеречислениемПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.ВедомостьПрочихДоходовВБанк, Истина);
	Списки.Вставить(Метаданные.Документы.ВедомостьПрочихДоходовВКассу, Истина);
	Списки.Вставить(Метаданные.Документы.ВедомостьПрочихДоходовПеречислением, Истина);
	Списки.Вставить(Метаданные.ЖурналыДокументов.ВедомостиПрочихДоходов, Истина);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных.
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт

	Описание = Описание + "
	|Справочник.ВедомостьПрочихДоходовВБанкПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ВедомостьПрочихДоходовВБанкПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ВедомостьПрочихДоходовВБанкПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ВедомостьПрочихДоходовВБанкПрисоединенныеФайлы.Изменение.Организации
	|Справочник.ВедомостьПрочихДоходовВКассуПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ВедомостьПрочихДоходовВКассуПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ВедомостьПрочихДоходовВКассуПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ВедомостьПрочихДоходовВКассуПрисоединенныеФайлы.Изменение.Организации
	|Справочник.ВедомостьПрочихДоходовПеречислениемПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ВедомостьПрочихДоходовПеречислениемПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ВедомостьПрочихДоходовПеречислениемПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ВедомостьПрочихДоходовПеречислениемПрисоединенныеФайлы.Изменение.Организации
	|Документ.ВедомостьПрочихДоходовВБанк.Чтение.ГруппыФизическихЛиц
	|Документ.ВедомостьПрочихДоходовВБанк.Чтение.Организации
	|Документ.ВедомостьПрочихДоходовВБанк.Изменение.ГруппыФизическихЛиц
	|Документ.ВедомостьПрочихДоходовВБанк.Изменение.Организации
	|Документ.ВедомостьПрочихДоходовВКассу.Чтение.ГруппыФизическихЛиц
	|Документ.ВедомостьПрочихДоходовВКассу.Чтение.Организации
	|Документ.ВедомостьПрочихДоходовВКассу.Изменение.ГруппыФизическихЛиц
	|Документ.ВедомостьПрочихДоходовВКассу.Изменение.Организации
	|Документ.ВедомостьПрочихДоходовПеречислением.Чтение.ГруппыФизическихЛиц
	|Документ.ВедомостьПрочихДоходовПеречислением.Чтение.Организации
	|Документ.ВедомостьПрочихДоходовПеречислением.Изменение.ГруппыФизическихЛиц
	|Документ.ВедомостьПрочихДоходовПеречислением.Изменение.Организации
	|ЖурналДокументов.ВедомостиПрочихДоходов.Чтение.ГруппыФизическихЛиц
	|ЖурналДокументов.ВедомостиПрочихДоходов.Чтение.Организации";
	
КонецПроцедуры

#КонецОбласти
	
// Возвращает структуру с настройками подсистемы
//
Функция НастройкиВзаиморасчетовПоПрочимДоходам() Экспорт

	Настройки = РегистрыСведений.НастройкиВзаиморасчетовПоПрочимДоходам.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	СтруктураНастроек = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(
							Настройки, Метаданные.РегистрыСведений.НастройкиВзаиморасчетовПоПрочимДоходам);
							
	Возврат СтруктураНастроек;  

КонецФункции

Функция ИспользуютсяВзаиморасчетыПоПрочимДоходам() Экспорт

	Возврат НастройкиВзаиморасчетовПоПрочимДоходам().ИспользоватьВзаиморасчетыПоПрочимДоходам;	

КонецФункции 

// Создает новую пустую таблицу значений для данных о выплаченных доходах.
//
// Возвращаемое значение:
//		ТаблицаЗначений - таблица значений с колонками:
//			* ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//			* СтатьяФинансирования - СправочникСсылка.СтатьиФинансированияЗарплата
//			* СтатьяРасходов - СправочникСсылка.СтатьиРасходовЗарплата
//			* ДокументОснование - ОпределяемыйТип.ДокументОснованиеВыплатыПрочихДоходов
//			* Сумма - Число 	
//
Функция НоваяТаблицаВыплаченногоДохода() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	
	Таблица.Колонки.Добавить("ФизическоеЛицо",       Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	Таблица.Колонки.Добавить("СтатьяФинансирования", Новый ОписаниеТипов("СправочникСсылка.СтатьиФинансированияЗарплата"));
	Таблица.Колонки.Добавить("СтатьяРасходов",       Новый ОписаниеТипов("СправочникСсылка.СтатьиРасходовЗарплата"));
	Таблица.Колонки.Добавить("ДокументОснование",    Метаданные.ОпределяемыеТипы.ДокументОснованиеВыплатыПрочихДоходов.Тип);
	Таблица.Колонки.Добавить("Сумма",                ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	
	Возврат Таблица
	
КонецФункции

// Регистрирует выплату прочих доходов в учете взаиморасчетов.
//
// Параметры:
//		Движения          - КоллекцияДвижений - коллекция наборов записей движений ведомости.
//		Отказ             - Булево - признак отказа в проведении.
//		Организация       - СправочникСсылка.Организации
//		ПериодРегистрации - Дата  - первое число месяца периода регистрации.
//		Выплаты          - ТаблицаЗначений - см. НоваяТаблицаВыплаченнойЗарплаты
//		СпособРасчетов   - ПеречислениеСсылка.СпособыРасчетовСФизическимиЛицами
//
Процедура ЗарегистрироватьВыплаченныйДоход(Движения, Отказ, Организация, ПериодРегистрации, Выплаты, СпособРасчетов) Экспорт
	
	Если Выплаты.Количество() = 0	 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаВыплаты Из Выплаты Цикл
		НоваяЗапись = Движения.ВзаиморасчетыСКонтрагентамиАкционерами.ДобавитьРасход();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаВыплаты);
		НоваяЗапись.Организация 	= Организация;
		НоваяЗапись.СпособРасчетов 	= СпособРасчетов;
		НоваяЗапись.Период      	= ПериодРегистрации;
		НоваяЗапись.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Выплачено;
		НоваяЗапись.СуммаВзаиморасчетов	= СтрокаВыплаты.Сумма;
	КонецЦикла;
	
КонецПроцедуры

Функция МенеджерДокументаВедомостьПоВидуМестаВыплаты(ВидМестаВыплаты) Экспорт
	
	МенеджерДокументаПоМестуВыплаты = Неопределено;
	
	Если ВидМестаВыплаты = Перечисления.ВидыМестВыплатыЗарплаты.Касса Тогда
		МенеджерДокументаПоМестуВыплаты = Документы.ВедомостьПрочихДоходовВКассу
	ИначеЕсли ВидМестаВыплаты = Перечисления.ВидыМестВыплатыЗарплаты.БанковскийСчет Тогда
		МенеджерДокументаПоМестуВыплаты = Документы.ВедомостьПрочихДоходовПеречислением
	ИначеЕсли ВидМестаВыплаты = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект Тогда
		МенеджерДокументаПоМестуВыплаты = Документы.ВедомостьПрочихДоходовВБанк
	КонецЕсли;
		
	Возврат МенеджерДокументаПоМестуВыплаты
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоответствиеСпособВыплатыСпособРасчетов() Экспорт

	СоответствиеСпособВыплатыСпособРасчетов = Новый Соответствие;
	СоответствиеСпособВыплатыСпособРасчетов.Вставить(Перечисления.СпособыВыплатыПрочихДоходов.Дивиденды,Перечисления.СпособыРасчетовСФизическимиЛицами.Дивиденды);
	СоответствиеСпособВыплатыСпособРасчетов.Вставить(Перечисления.СпособыВыплатыПрочихДоходов.ДивидендыСотрудникам,Перечисления.СпособыРасчетовСФизическимиЛицами.ДивидендыСотрудникам);
	СоответствиеСпособВыплатыСпособРасчетов.Вставить(Перечисления.СпособыВыплатыПрочихДоходов.ВыплатыБывшимСотрудникам,Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами);
	СоответствиеСпособВыплатыСпособРасчетов.Вставить(Перечисления.СпособыВыплатыПрочихДоходов.ВыплатаПрочихДоходов,Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами);
	
	Возврат СоответствиеСпособВыплатыСпособРасчетов;

КонецФункции 

Функция ИменаВидовДокументовВзаиморасчетыСКонтрагентамиАкционерами() Экспорт

	ИменаВидовДокументовОснований = Новый Соответствие;
	ИменаВидовДокументовОснований.Вставить(Перечисления.СпособыВыплатыПрочихДоходов.Дивиденды, "ДивидендыФизическимЛицам");
	ИменаВидовДокументовОснований.Вставить(Перечисления.СпособыВыплатыПрочихДоходов.ДивидендыСотрудникам, "ДивидендыФизическимЛицам");
	ИменаВидовДокументовОснований.Вставить(Перечисления.СпособыВыплатыПрочихДоходов.ВыплатыБывшимСотрудникам,"ВыплатаБывшимСотрудникам");
	ИменаВидовДокументовОснований.Вставить(Перечисления.СпособыВыплатыПрочихДоходов.ВыплатаПрочихДоходов,"РегистрацияПрочихДоходов");
	
	Возврат ИменаВидовДокументовОснований;

КонецФункции

Функция ТекстЗапросаОстаткиВзаиморасчетовСКонтрагентамиАкционерами() Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Остатки.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Остатки.ДокументОснование КАК ДокументОснование,
	|	Остатки.СтатьяФинансирования КАК СтатьяФинансирования,
	|	Остатки.СтатьяРасходов КАК СтатьяРасходов,
	|	СУММА(Остатки.КВыплате) КАК КВыплате
	|ИЗ
	|	(ВЫБРАТЬ
	|		Взаиморасчеты.ФизическоеЛицо КАК ФизическоеЛицо,
	|		Взаиморасчеты.ДокументОснование КАК ДокументОснование,
	|		Взаиморасчеты.СтатьяФинансирования КАК СтатьяФинансирования,
	|		Взаиморасчеты.СтатьяРасходов КАК СтатьяРасходов,
	|		ВЫБОР
	|			КОГДА Взаиморасчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Взаиморасчеты.СуммаВзаиморасчетов
	|			ИНАЧЕ Взаиморасчеты.СуммаВзаиморасчетов
	|		КОНЕЦ КАК КВыплате
	|	ИЗ
	|		РегистрНакопления.ВзаиморасчетыСКонтрагентамиАкционерами КАК Взаиморасчеты
	|	ГДЕ
	|		Взаиморасчеты.Регистратор = &ИсключаемыйРегистратор
	|		И Взаиморасчеты.Организация = &Организация
	|		И Взаиморасчеты.СпособРасчетов = &СпособРасчетов
	|		И Взаиморасчеты.ФизическоеЛицо В(&ФизическиеЛица)
	|		И Взаиморасчеты.ДокументОснование В(&Основания)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВзаиморасчетыОстатки.ФизическоеЛицо,
	|		ВзаиморасчетыОстатки.ДокументОснование,
	|		ВзаиморасчетыОстатки.СтатьяФинансирования,
	|		ВзаиморасчетыОстатки.СтатьяРасходов,
	|		ВзаиморасчетыОстатки.СуммаВзаиморасчетовОстаток
	|	ИЗ
	|		РегистрНакопления.ВзаиморасчетыСКонтрагентамиАкционерами.Остатки(
	|				&ДатаОстатков,
	|				Организация = &Организация
	|					И СпособРасчетов = &СпособРасчетов
	|					И ФизическоеЛицо В (&ФизическиеЛица)
	|					И ДокументОснование В (&Основания)) КАК ВзаиморасчетыОстатки) КАК Остатки
	|ГДЕ
	|	ИСТИНА
	|	И Остатки.СтатьяФинансирования = &СтатьяФинансирования
	|	И Остатки.СтатьяРасходов = &СтатьяРасходов
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.ФизическоеЛицо,
	|	Остатки.ДокументОснование,
	|	Остатки.СтатьяФинансирования,
	|	Остатки.СтатьяРасходов
	|
	|ИМЕЮЩИЕ
	|	СУММА(Остатки.КВыплате) <> 0";
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

