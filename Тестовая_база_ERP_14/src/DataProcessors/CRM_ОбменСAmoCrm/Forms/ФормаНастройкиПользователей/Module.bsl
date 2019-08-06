
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Объект,Параметры);
	
	Объект.ПользователиСопоставление.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ПользователиСопоставлениеАдрес));
	Если Параметры.Автозаполнение Тогда
		Объект.ПользователиСопоставление.Очистить();
		ЗаполнитьПользователейДлясопоставления();
		Элементы.ПользователиСопоставлениеЗагрузитьПользователейИзAmoCRM.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПользователейДлясопоставления()
	
	ОбъектДанных = РеквизитФормыВЗначение("Объект");
	
	Ресурс = "/api/v2/account";
	ОтветСервера = ОбъектДанных.ВыполнитьЗагрузкуДанных(Ресурс,10,Истина);
	
	ЗначениеВРеквизитФормы(ОбъектДанных,"Объект");
	//пользователей сопоставляем по электронному адресу
	СопоставитьПользователейПоЭлектронномуАдресу();
	
КонецПроцедуры

&НаСервере
Процедура СопоставитьПользователейПоЭлектронномуАдресу()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаПользователей.ИдАмо КАК ИдАмо,
		|	ТаблицаПользователей.ИмяАмо КАК ИмяАмо,
		|	ТаблицаПользователей.ЭлАдресПользователя КАК ЭлАдресПользователя,
		|	ТаблицаПользователей.Пользователь КАК Пользователь
		|ПОМЕСТИТЬ ВтПользователи
		|ИЗ
		|	&ТаблицаПользователей КАК ТаблицаПользователей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПользователиКонтактнаяИнформация.Ссылка КАК Ссылка,
		|	ПользователиКонтактнаяИнформация.Представление КАК ПредставлениеАдреса
		|ПОМЕСТИТЬ ПользователиБазы
		|ИЗ
		|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
		|ГДЕ
		|	ПользователиКонтактнаяИнформация.Тип = &Тип
		|	И ПользователиКонтактнаяИнформация.Вид = &Вид
		|	И ПользователиКонтактнаяИнформация.Представление В
		|			(ВЫБРАТЬ
		|				ВтПользователи.ЭлАдресПользователя
		|			ИЗ
		|				ВтПользователи)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПользователиБазы.Ссылка КАК Пользователь,
		|	ВтПользователи.ИдАмо КАК ИдАмо,
		|	ВтПользователи.ИмяАмо КАК ИмяАмо,
		|	ВтПользователи.ЭлАдресПользователя КАК ЭлАдресПользователя
		|ИЗ
		|	ВтПользователи КАК ВтПользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПользователиБазы КАК ПользователиБазы
		|		ПО ПользователиБазы.ПредставлениеАдреса = ВтПользователи.ЭлАдресПользователя";
	
	Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.EmailПользователя);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	Запрос.УстановитьПараметр("ТаблицаПользователей", Объект.ПользователиСопоставление.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Объект.ПользователиСопоставление.Загрузить(РезультатЗапроса);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуПользователейДляСопоставления()
	
	Возврат	ПоместитьВоВременноеХранилище(Объект.ПользователиСопоставление.Выгрузить(),Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	СтруктураЗакрытия = Новый Структура;
	СтруктураЗакрытия.Вставить("ПользователиСопоставлениеАдрес",ПолучитьТаблицуПользователейДляСопоставления());
	ОповеститьОВыборе(СтруктураЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПользователейИзAmoCRM(Команда)
	
	Если Объект.ПользователиСопоставление.Количество() > 0 Тогда
		
		Режим = РежимДиалогаВопрос.ДаНет;
		
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Табличная часть не пустая. Очистить?'"), Режим, 0);
	Иначе	
		
		ЗаполнитьПользователейДлясопоставления();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	//От выбора результата зависит будет ли установлен отвественный в документах
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.ПользователиСопоставление.Очистить();
	КонецЕсли;
	
	ЗаполнитьПользователейДлясопоставления();
	
КонецПроцедуры
