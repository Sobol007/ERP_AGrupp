
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшОграничениеТипов;

#КонецОбласти

#Область ОбработчикиСобытийФормы

//////////////////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");

	ИмяФормыНастройкаСоставаВидовДокументов = ОбработкаОбъект.Метаданные().ПолноеИмя()
			+ ".Форма.НастройкаСоставаВидовДокументов";

	УстановитьКлючНастроек();

	ЗаполнитьТаблицуЗапросов(ОбработкаОбъект);

	ОбновитьСписокВидовДокументов();

	ВосстановитьНастройки();

	ОбновитьТекстЗапроса();

	УстановитьЗначенияПоУмолчанию();

	ПрименитьПараметрыКоманды();

	// Поле отображения содержания.
	CRM_ОбщегоНазначенияСервер.НастройкиПолейОтображенияСодержанияПриСозданииФормыСпискаНаСервере(ЭтотОбъект,ИмяФормы);
	
	Если Параметры.Свойство("Отбор") Тогда
		Элементы.Параметр.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы "ПриЗакрытии".
//
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда Возврат; КонецЕсли;
	СохранитьНастройки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДокументов

//////////////////////////////////////////////////////////////////////////////////////////////
// Обработчики событий ТаблицаДокументов.

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияТаблицаПриАктивизацииСтроки()
	
	Если Элементы.ГруппаПолеОтображенияСодержания.Видимость Тогда
		СсылкаНаДокумент = ?(Элементы.ТаблицаДокументов.ТекущиеДанные = Неопределено, Неопределено, Элементы.ТаблицаДокументов.ТекущиеДанные.Документ); 
		CRM_ОбщегоНазначенияКлиент.НастройкиПолейОтображенияСодержанияПриАктивизацииСтроки(ЭтотОбъект, СсылкаНаДокумент, НастройкаПоляОтображенияСодержанияПолучитьОграничениеТиповСписка());
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция НастройкаПоляОтображенияСодержанияПолучитьОграничениеТиповСпискаСервер()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СписокТипов = "";
	Для Каждого ЭлементСостава Из Метаданные.КритерииОтбора.CRM_ДокументыПоКонтактномуЛицу.Состав Цикл

		СтруктураДанных = ОбработкаОбъект.ПолучитьСтруктуруДанных(ЭлементСостава.ПолноеИмя());

		Если Не ПравоДоступа("Чтение", СтруктураДанных.Метаданные) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтруктураДанных.ТипОбъекта = "Документ" Тогда
			Стр = "ДокументСсылка."+СтруктураДанных.ВидОбъекта;
			Если Найти(СписокТипов,Стр)=0 Тогда			
				СписокТипов = СписокТипов + Стр + ",";
			КонецЕсли;
		ИначеЕсли СтруктураДанных.ТипОбъекта = "БизнесПроцесс" Тогда
			Стр = "БизнесПроцессСсылка."+СтруктураДанных.ВидОбъекта;
			Если Найти(СписокТипов,Стр)=0 Тогда			
				СписокТипов = СписокТипов + Стр + ",";
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СписокТипов) Тогда
		ОписаниеТипов = Новый ОписаниеТипов(Сред(СписокТипов,1,СтрДлина(СписокТипов)-1)) ;
		Возврат ОписаниеТипов;
	КонецЕсли;
	
КонецФункции

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
	Если Элементы.ТаблицаДокументов.ТекущиеДанные <> Неопределено Тогда
		тОбъект = Элементы.ТаблицаДокументов.ТекущиеДанные.Документ;
	Иначе
		тОбъект = Неопределено;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолеОтображениеСодержанияПриНажатииЗавершение", ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиент.НастройкиПолейОтображенияСодержанияПолеСодержаниеПриНажатии(ДанныеСобытия, СтандартнаяОбработка, НастройкаПоляОтображенияСодержанияПолучитьОграничениеТиповСписка(), тОбъект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОтображениеСодержанияПриНажатииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Подключаемый_ОбработчикОжиданияТаблицаПриАктивизацииСтроки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОжиданияТаблицаПриАктивизацииСтроки", 0.1, Истина);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

//////////////////////////////////////////////////////////////////////////////////////////////
// Обработчики команд формы

&НаКлиенте
Процедура НастроитьСоставДокументов(Команда)

	РедактироватьСоставДокументов();

КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)

	ОбновитьТаблицуДокументовНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)

	ВыборПериода(ПериодВыборкиДокументов);

КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)

	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда

		ПоказатьЗначение(, ТекущиеДанные.Документ);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьСкрытьПолеОтображенияСодержания(Команда)
	
	CRM_ОбщегоНазначенияКлиент.НастройкиПолейОтображенияСодержанияПоказатьСкрытьПолеОтображенияСодержания(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПривязатьВзаимодействия(Команда)
	Если Не ЗначениеЗаполнено(Параметр) Тогда Возврат; КонецЕсли;
	
	СтрокаСообщения = "";
	МассивПривязанныхДокументов = Новый Массив();
	CRM_КлиентыСервер.ПривязатьВзаимодействияПоКлиенту(Параметр, СтрокаСообщения, МассивПривязанныхДокументов);
	Если Не ПустаяСтрока(СтрокаСообщения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
	КонецЕсли;
	Состояние(НСтр("ru='Количество новых привязанных документов взаимодействия';en='Quantity of the new anchor documents of interaction'")
		+ ": " + Формат(МассивПривязанныхДокументов.Количество(), "ЧН=0; ЧГ="));
	//
	ОбновитьТаблицуДокументовНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//////////////////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции
&НаСервере
Процедура ОбновитьТекстЗапроса()

	ВремТекстЗапроса = "";
	Для Каждого СтрокаТаб Из ТаблицаЗапросов.НайтиСтроки(Новый Структура("Использовать", Истина)) Цикл

		ВремТекстЗапроса = ВремТекстЗапроса + ?(ПустаяСтрока(ВремТекстЗапроса), "", " ОБЪЕДИНИТЬ ВСЕ ")
				+ СтрокаТаб.ТекстЗапроса;

	КонецЦикла;

	Позиция = Найти(ВРЕГ(ВремТекстЗапроса), ВРег("ВЫБРАТЬ"));
	Если Позиция > 0 Тогда

		ВремТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + Сред(ВремТекстЗапроса, Позиция + СтрДлина("Выбрать")) + 
		"УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Документ
		|";

	КонецЕсли;

	ТекстЗапросаПоДокументам = ВремТекстЗапроса;

КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакИспользованияВидаДокумента()

	Для Каждого СтрокаТаб Из ТаблицаЗапросов Цикл

		ЭлементСписка = СписокВидовДокументов.НайтиПоЗначению(СтрокаТаб.ИмяДокумента);
		Если ЭлементСписка <> Неопределено Тогда
			СтрокаТаб.Использовать = ЭлементСписка.Пометка;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВидовДокументов()

	СписокВидовДокументов.Очистить();
	Для Каждого Строка Из ТаблицаЗапросов Цикл
		СписокВидовДокументов.Добавить(Строка.ИмяДокумента, Строка.СинонимДокумента, Строка.Использовать);
	КонецЦикла;

	СписокВидовДокументов.СортироватьПоПредставлению(НаправлениеСортировки.Возр);

КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкиКСпискуВидовДокументов(ЗначениеНастройки)

	ПереформироватьЗапрос = Ложь;
	Для Каждого Элемент Из ЗначениеНастройки Цикл

		ЭлементСписка = СписокВидовДокументов.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка <> Неопределено И ЭлементСписка.Пометка <> Элемент.Пометка Тогда

			ЭлементСписка.Пометка = Элемент.Пометка;
			ПереформироватьЗапрос = Истина;

		КонецЕсли;

	КонецЦикла;

	Если ПереформироватьЗапрос Тогда

		УстановитьПризнакИспользованияВидаДокумента();

		ОбновитьТекстЗапроса();

		СохранитьНастройки();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСоставДокументов()

	ОписаниеОповещения = Новый ОписаниеОповещения("РедактироватьСоставДокументовЗавершение", ЭтотОбъект);
	Результат = ОткрытьФорму(ИмяФормыНастройкаСоставаВидовДокументов, Новый Структура("СписокВидовДокументов", СписокВидовДокументов),,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСоставДокументовЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
		ПрименитьНастройкиКСпискуВидовДокументов(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыборПериода(Период)

	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Период;
	Диалог.Показать(Новый ОписаниеОповещения("ВыборПериодаЗавершение", ЭтотОбъект));

КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Период = Результат;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуДокументовНаСервере()

	Если ПустаяСтрока(ТекстЗапросаПоДокументам) Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Необходимо настроить состав документов';en='It is necessary set up composition of documents'"),,"");
		Возврат;

	КонецЕсли;

	Запрос = Новый Запрос(ТекстЗапросаПоДокументам);
	Запрос.УстановитьПараметр("Параметр",         Параметр);
	Запрос.УстановитьПараметр("НачалоПериода",    ПериодВыборкиДокументов.ДатаНачала);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ПериодВыборкиДокументов.ДатаОкончания);

	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "ТаблицаДокументов");

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры работы с настройками.

&НаСервере
Процедура ВосстановитьНастройки()

	ЗначениеНастроек = ХранилищеОбщихНастроек.Загрузить("Обработка.CRM_ДокументыПоКонтактномуЛицу", КлючНастроек);
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда

		ЗначениеИзНастройки = ЗначениеНастроек.Получить("СписокВидовДокументов");
		Если ТипЗнч(ЗначениеИзНастройки) = Тип("СписокЗначений") Тогда
			ПрименитьНастройкиКСпискуВидовДокументов(ЗначениеИзНастройки);
		КонецЕсли;

		ПериодВыборкиДокументов.ДатаНачала    = ЗначениеНастроек.Получить("ДатаНачала");
		ПериодВыборкиДокументов.ДатаОкончания = ЗначениеНастроек.Получить("ДатаОкончания");
		
		Если Найти(КлючНастроек,"_ОтборВСписке") > 0 Тогда
			Параметр = Параметры.Отбор.КонтактноеЛицо;
		Иначе
			Параметр = ЗначениеНастроек.Получить("КонтактноеЛицо");
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	Настройки = Новый Соответствие;
	Настройки.Вставить("КонтактноеЛицо",       	Параметр);
	Настройки.Вставить("СписокВидовДокументов", СписокВидовДокументов);
	Настройки.Вставить("ДатаНачала",            ПериодВыборкиДокументов.ДатаНачала);
	Настройки.Вставить("ДатаОкончания",         ПериодВыборкиДокументов.ДатаОкончания);

	ХранилищеОбщихНастроек.Сохранить("Обработка.CRM_ДокументыПоКонтактномуЛицу", КлючНастроек, Настройки);

	// Поле отображения содержания.
	CRM_ОбщегоНазначенияСервер.НастройкиПолейОтображенияСодержанияПриЗакрытииФормыСписка(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()

	Если Не ЗначениеЗаполнено(ПериодВыборкиДокументов.ДатаНачала)
	 Или Не ЗначениеЗаполнено(ПериодВыборкиДокументов.ДатаОкончания) Тогда

	    ПериодВыборкиДокументов.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
	 	ПериодВыборкиДокументов.ДатаНачала    = ДобавитьМесяц(CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса(), - 12);
		ПериодВыборкиДокументов.ДатаОкончания = CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса();

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПрименитьПараметрыКоманды()

	Если Параметры.Свойство("Отбор") Тогда

		Параметры.Отбор.Свойство("КонтактноеЛицо", Параметр);

	КонецЕсли;

	Если Параметры.Свойство("СформироватьПриОткрытии") И Параметры.СформироватьПриОткрытии Тогда

		ОбновитьТаблицуДокументовНаСервере();

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗапросов(ОбработкаОбъект)

	ДополнительныеДокументы = Новый Массив;

	ПоляШапки = Новый Массив;
	ПоляШапки.Добавить("СуммаДокумента");
	ПоляШапки.Добавить("ВидОперации");
	ПоляШапки.Добавить("Валюта");
	ПоляШапки.Добавить("Подразделение");
	ПоляШапки.Добавить("Организация");
	ПоляШапки.Добавить("Ответственный");
	ПоляШапки.Добавить("Комментарий");
	ПоляШапки.Добавить("Автор");
	
	ПоляШапки.Добавить("Тема");

	ОбработкаОбъект.ЗаполнитьТаблицуЗапросов(ТаблицаЗапросов,
			ДополнительныеДокументы,
			ПоляШапки,,, ?(Параметры.Свойство("Отбор"),(ТипЗнч(Параметры.Отбор.КонтактноеЛицо) = Тип("СписокЗначений")), Ложь));

КонецПроцедуры

&НаСервере
Процедура УстановитьКлючНастроек()

	Если Параметры.Свойство("КлючНастроек") И Не ПустаяСтрока(Параметры.КлючНастроек) Тогда

		КлючНастроек = Параметры.КлючНастроек;

	Иначе

		КлючНастроек = "БезКонтактногоЛица";

	КонецЕсли;

	КлючНастроек = КлючНастроек + "_" + Пользователи.ТекущийПользователь().УникальныйИдентификатор();

	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("КонтактноеЛицо") Тогда
		Если НЕ ТипЗнч(Параметры.Отбор.КонтактноеЛицо) = Тип("СписокЗначений") Тогда
			КлючНастроек = КлючНастроек + "_" + Параметры.Отбор.КонтактноеЛицо.УникальныйИдентификатор();
		Иначе
			Заголовок = НСтр("ru='Документы по юр. лицам';en='Documents on юр. to persons'");
			Элементы.ТаблицаДокументовГруппаКнопокПривязатьВзаимодействия.Видимость = Ложь;
			КлючНастроек = КлючНастроек + "_ОтборВСписке";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти






