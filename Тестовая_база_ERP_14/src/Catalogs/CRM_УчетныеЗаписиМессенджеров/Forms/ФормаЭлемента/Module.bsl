
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	CRM_ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	ИнициализироватьДанные();
	
	ТекущийПользовательРазрешеноАдминистрирование = CRM_РаботаСМессенджерамиСервер.ТекущийПользовательПолучитьПравоУчетнойЗаписи(Объект.Ссылка, "Администрирование");
	
	Если НЕ ТекущийПользовательРазрешеноАдминистрирование ИЛИ НЕ ПравоДоступа("Редактирование", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		
		ТолькоПросмотр = Истина;					
		
	КонецЕсли;
	Элементы.CRM_Пользователи.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.СписокПользователейГруппаЗаполнить.Доступность = НЕ ТолькоПросмотр;
	Элементы.СписокПользователейПодбор.Доступность = НЕ ТолькоПросмотр;
	
	Элементы.ТипМессенджера.СписокВыбора.ЗагрузитьЗначения(CRM_РаботаСМессенджерамиСервер.ПолучитьСписокМессенджеров().ВыгрузитьЗначения());
	
	Элементы.CRM_УказыватьПричинуОтклонения.Видимость = Объект.CRM_ИсточникЛидов;
	
	Если ЗначениеЗаполнено(Объект.CRM_РольОтветственного) Тогда
		РолеваяАдресация = 1;
	КонецЕсли;
	Элементы.Ответственный.Видимость = НЕ РолеваяАдресация;
	Элементы.CRM_РольОтветственного.Видимость = РолеваяАдресация;
	
	УправлениеВидимостьюЭлементов();
	ТипМессенджераПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	СтруктураПараметровДоступа = ТекущийОбъект.ХранилищеПараметровДоступа.Получить();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ХранилищеПараметровДоступа = Новый ХранилищеЗначения(СтруктураПараметровДоступа);
	
	// Добавляем Текущего пользователя в СписокПользователей, если это новый элемент.
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекПользователь = ПользователиКлиентСервер.ТекущийПользователь();
		СтрокаПользователь = CRM_СписокПользователей.Добавить();
		СтрокаПользователь.Пользователь = ТекПользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	НаборРегистра = РегистрыСведений.CRM_УчетныеЗаписиМессенджеров.СоздатьНаборЗаписей();
	НаборРегистра.Отбор.УчетнаяЗапись.Установить(Объект.Ссылка);
	НаборРегистра.Прочитать();
	ТаблицаНабора = НаборРегистра.Выгрузить();
	НаборРегистра.Очистить();
	// Запишем данные о пользователях учетной записи в регистр.
	Для Каждого СтрокаПользователя Из CRM_СписокПользователей Цикл
		СтрокаНабора = НаборРегистра.Добавить();
		СтрокаНабора.УчетнаяЗапись	= Объект.Ссылка;
		СтрокаНабора.Пользователь	= СтрокаПользователя.Пользователь;
		СтрокаНабора.Запись			= СтрокаПользователя.Запись;
		СтрокаНабора.Администрирование	= СтрокаПользователя.Администрирование;
		СтрокаТаблицыНабора = ТаблицаНабора.Найти(Объект.Ссылка, "УчетнаяЗапись");
		СтрокаНабора.Основная = ?(СтрокаТаблицыНабора = Неопределено, Ложь, СтрокаТаблицыНабора.Основная);
	КонецЦикла;
	НаборРегистра.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Закрыть(ЗначениеЗаполнено(Объект.Ссылка));
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		мСписокПользователей = Новый СписокЗначений;
		мСписокПользователей.ЗагрузитьЗначения(ВыбранноеЗначение);
		ЗаполнитьСписокПользователей(мСписокПользователей);
		Модифицированность = Истина;
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		мСписокПользователей = Новый СписокЗначений;
		мСписокПользователей.Добавить(ВыбранноеЗначение);
		ЗаполнитьСписокПользователей(мСписокПользователей);
		Модифицированность = Истина;
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипМессенджераПриИзменении(Элемент)
	ТипМессенджераПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура РолеваяАдресацияПриИзменении(Элемент)
	РолеваяАдресацияПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура CRM_ИсточникЛидовПриИзменении(Элемент)
	Элементы.CRM_УказыватьПричинуОтклонения.Видимость = Объект.CRM_ИсточникЛидов;
	Если НЕ Объект.CRM_ИсточникЛидов Тогда
		Объект.CRM_УказыватьПричинуОтклонения = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Настройка(Команда)
	Если ЗначениеЗаполнено(Объект.ТипМессенджера) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаЗавершение", ЭтотОбъект);
		ОткрытьФорму("Обработка.CRM_РаботаСМессенджером"+Строка(Объект.ТипМессенджера)+".Форма.ФормаНастройки", СтруктураПараметровДоступа,
				ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран мессенджер/соц. сеть!'"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЗавершение(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		СтруктураПараметровДоступа = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
// Процедура заполнения всеми пользователями.
//
Процедура ЗаполнитьВсемиПользователями(Команда)
	мСписокПользователей = ПолучитьСписокПользователей();
	ЗаполнитьСписокПользователей(мСписокПользователей);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
// Процедура заполнения по группе пользователей.
//
Процедура ЗаполнитьПоГруппеПользователей(Команда)
	ИспользоватьГруппы = ПолучитьИспользованиеГрупп();
	Если НЕ ИспользоватьГруппы Тогда
		ПоказатьПредупреждение(, "Отключена настройка ""Использовать группы пользователей""");
		Возврат;
	КонецЕсли;
	ПараметрыФормы = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоГруппеПользователейПродолжение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ГруппыПользователей.ФормаВыбораГруппы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоГруппеПользователейПродолжение(ГруппаПользователей, ДополнительныеПараметры) Экспорт
	Если ГруппаПользователей <> Неопределено Тогда
		ВключаяВложенные = ЕстьВложенныеГруппы(ГруппаПользователей);
		Если ВключаяВложенные Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоГруппеПользователейЗавершение", ЭтотОбъект, ГруппаПользователей);
			ПоказатьВопрос(ОписаниеОповещения, "Загрузить также пользователей вложенных групп?", РежимДиалогаВопрос.ДаНет, 0);
		Иначе
			ЗаполнитьПоГруппеПользователейЗавершение(Неопределено, ГруппаПользователей)
		КонецЕсли;		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоГруппеПользователейЗавершение(Ответ, ГруппаПользователей) Экспорт
	Если Ответ  = КодВозвратаДиалога.Да Тогда
		ВключаяВложенные = Истина;
	Иначе	
		ВключаяВложенные = Ложь;
	КонецЕсли;			
	мСписокПользователей = ПолучитьСписокПользователей(ГруппаПользователей, ВключаяВложенные);
	ЗаполнитьСписокПользователей(мСписокПользователей);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
// Процедура очистки списка пользователей.
//
Процедура ОчиститьСписок(Команда)
	ТД = Элементы.CRM_СписокПользователей.ТекущиеДанные;
	Если ТД = Неопределено Тогда Возврат; КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОчиститьСписокЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, "Все пользователи из списка будут удалены. Продолжить?", РежимДиалогаВопрос.ДаНет, 0);
КонецПроцедуры // ОчиститьСписок()

&НаКлиенте
// Процедура заполнения подбором.
//
Процедура Подбор(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора",				Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",		Истина);
	ПараметрыФормы.Вставить("ВыборГруппПользователей",	Ложь);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",		Ложь);
	ФормаПодбора = ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Функция получает список пользователей.
//
// Параметры:
//	ГруппаПользователей	- СправочникСсылка	- Группа, пользователей которой нужно получить.
//
// Возвращаемое значение:
//	СписокЗначений	- Список пользователей.
//
Функция ПолучитьСписокПользователей(ГруппаПользователей = Неопределено, ВключаяВложенные = Ложь)
	мСписокПользователей = Новый СписокЗначений;
	Запрос = Новый Запрос;
	Если ЗначениеЗаполнено(ГруппаПользователей) И ГруппаПользователей <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
		Запрос.УстановитьПараметр("Ссылка", ГруппаПользователей);
		Запрос.Текст = "ВЫБРАТЬ
           |	ГруппыПользователейСостав.Пользователь
           |ИЗ
           |	Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
           |ГДЕ";
		Если ВключаяВложенные Тогда
			Запрос.Текст = Запрос.Текст + "
           |	ГруппыПользователейСостав.Ссылка В ИЕРАРХИИ(&Ссылка)";
		Иначе	   
			Запрос.Текст = Запрос.Текст + "
           |	ГруппыПользователейСостав.Ссылка = &Ссылка";
		КонецЕсли;   
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
           |	Пользователи.Ссылка КАК Пользователь
           |ИЗ
           |	Справочник.Пользователи КАК Пользователи";
	КонецЕсли;				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаПользователя = мСписокПользователей.Добавить();
		СтрокаПользователя.Значение	= Выборка.Пользователь;
	КонецЦикла;
	Возврат мСписокПользователей;
КонецФункции // ПолучитьСписокПользователей() 	

&НаКлиенте
// Процедура выполняет заполнение списка пользователей на форме.
//
// Параметры:
//	мСписокПользователей	- СписокЗначений	- Список пользователей для заполнения на форме
//
Процедура ЗаполнитьСписокПользователей(мСписокПользователей)
	// Удаляем дубли из списка
	Для Каждого СтрокаСписка Из CRM_СписокПользователей Цикл
		ТекПользователь = мСписокПользователей.НайтиПоЗначению(СтрокаСписка.Пользователь);
		Если НЕ (ТекПользователь = Неопределено) Тогда 
			мСписокПользователей.Удалить(ТекПользователь);
		КонецЕсли;
	КонецЦикла;	
	// Добавляем новых пользователей в список.
	Для Каждого СтрокаСписка Из мСписокПользователей Цикл
		СтрокаПользователя = CRM_СписокПользователей.Добавить();
		СтрокаПользователя.Пользователь	= СтрокаСписка.Значение;
		СтрокаПользователя.Запись = Истина;
	КонецЦикла;	
	CRM_СписокПользователей.Сортировать("Пользователь Возр");
КонецПроцедуры // ЗаполнитьСписокПользователей()	

&НаСервере
// Функция проверяет наличие вложенных групп у группы.
//
// Параметры:
//	ГруппаПользователей	- СпрвочникСсылка	- Группа для проверки.
//
// Возвращаемое значение:
//	Булево	- Наличие вложенных групп.
//
Функция ЕстьВложенныеГруппы(ГруппаПользователей)
	Если НЕ ЗначениеЗаполнено(ГруппаПользователей) Тогда
		Возврат Ложь;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Родитель", ГруппаПользователей);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ГруппыПользователей.Ссылка
	               |ИЗ
	               |	Справочник.ГруппыПользователей КАК ГруппыПользователей
	               |ГДЕ
	               |	ГруппыПользователей.Родитель = &Родитель";
	Выборка = Запрос.Выполнить();
	Возврат НЕ Выборка.Пустой(); 
КонецФункции // ЕстьВложенныеГруппы()

&НаСервереБезКонтекста
// Функция проверяет использование функциональной опции "ИспользоватьГруппыПользователей".
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	Булево	- Использование опции.
//
Функция ПолучитьИспользованиеГрупп()
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
КонецФункции // ПолучитьИспользованиеГрупп()

&НаСервере
Процедура ТипМессенджераПриИзмененииСервер()
	Если Метаданные.ОбщиеКартинки.Найти("CRM_Мессенджер"+Объект.ТипМессенджера) <> Неопределено Тогда
		СтрокаКартинки = ПоместитьВоВременноеХранилище(БиблиотекаКартинок["CRM_Мессенджер"+Объект.ТипМессенджера]);
		Элементы.ПолеЛоготипа.Видимость = Истина;
	Иначе
		СтрокаКартинки = "";
		Элементы.ПолеЛоготипа.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		CRM_СписокПользователей.Очистить();
		Модифицированность = Истина;
	КонецЕсли;	
КонецПроцедуры // ОчиститьСписок()

&НаСервере
// Процедура заполняет таблицу пользователей учетной записи.
//
Процедура ИнициализироватьДанные()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УчетнаяЗапись", Объект.Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_УчетныеЗаписиМессенджеров.Пользователь КАК Пользователь,
	               |	CRM_УчетныеЗаписиМессенджеров.Администрирование,
	               |	CRM_УчетныеЗаписиМессенджеров.Запись
	               |ИЗ
	               |	РегистрСведений.CRM_УчетныеЗаписиМессенджеров КАК CRM_УчетныеЗаписиМессенджеров
	               |ГДЕ
	               |	CRM_УчетныеЗаписиМессенджеров.УчетнаяЗапись = &УчетнаяЗапись";
	ВыборкаРезультатовЗапроса = Запрос.Выполнить().Выбрать();
	Пока ВыборкаРезультатовЗапроса.Следующий() Цикл
		СтрокаПользователя = CRM_СписокПользователей.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПользователя, ВыборкаРезультатовЗапроса);
	КонецЦикла;
	CRM_СписокПользователей.Сортировать("Пользователь Возр");
КонецПроцедуры//

&НаСервере
Процедура УправлениеВидимостьюЭлементов()
КонецПроцедуры

&НаСервере
Процедура РолеваяАдресацияПриИзмененииСервер()
	Элементы.Ответственный.Видимость = НЕ РолеваяАдресация;
	Элементы.CRM_РольОтветственного.Видимость = РолеваяАдресация;
	Если РолеваяАдресация = 0 Тогда
		Объект.CRM_РольОтветственного = Справочники.РолиИсполнителей.ПустаяСсылка();
	Иначе
		Объект.Ответственный = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 




