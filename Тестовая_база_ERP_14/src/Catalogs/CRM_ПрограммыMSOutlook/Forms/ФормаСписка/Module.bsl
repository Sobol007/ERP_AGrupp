#Область ОписаниеПеременных

&НаКлиенте 
Перем ДатыПредыдущейСинхронизации;

#КонецОбласти

#Область ОбработчикиСобытийФормы
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ CRM_ЛицензированиеСервер.ПодсистемаCRMИспользуется() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Невозможно открыть Обмен данными с MS Outlook. Подсистема 1С:CRM не используется! (см. Персональные настройки пользователя)';en='Can not open Data exchange with MS Outlook. Subsystem 1C: CRM is not used! (see Personal settings of the user)'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	CRM_ЛицензированиеСервер.ПолучитьЗащищеннуюОбработку().Обработка_CRM_ОбменСMSOutlook_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru='Обмен с MS Outlook невозможен в Веб-клиенте!';en='Exchange with MS Outlook is not possible in  Web Client!'"), 15);
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	УстановитьОтборСписка();
	ДатыПредыдущейСинхронизации = Новый Структура("ДатаПоследнейСинхронизацииКонтактов,
				|ДатаПоследнейСинхронизацииСобытий,ДатаПоследнейСинхронизацииПисем");
	ПодключитьОбработчикОжидания("ОбновитьНастройкиОбменаНаКлиенте", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкиОбменаOutlookПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	ПрограммаOutlook = Элементы.Список.ТекущаяСтрока;
	Если НЕ ЗначениеЗаполнено(ПрограммаOutlook) Тогда Возврат; КонецЕсли;
	ТекущаяНастройка = Неопределено;
	Если Копирование Тогда
		ТекущаяНастройка = Новый Структура("ПрограммаOutlook,Наименование");
		ЗаполнитьЗначенияСвойств(ТекущаяНастройка, Элемент.ТекущиеДанные);
	КонецЕсли;
	НоваяНастройка = CRM_ОбменСMSOutlookСервер.ДобавитьНовуюНастройку(ПрограммаOutlook, Копирование, ТекущаяНастройка);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновлениеНастроекОбменаНаКлиенте", ЭтотОбъект);
	ОткрытьФорму("Обработка.CRM_ОбменСMSOutlook.Форма.ФормаМастерНастройки",
		Новый Структура("ЗначенияЗаполнения", НоваяНастройка), ЭтотОбъект,,,, ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаOutlookПередНачаломИзменения(Элемент, Отказ)
	Отказ					= Истина;
	СтандартнаяОбработка	= Ложь;	
	ПрограммаOutlook		= Элементы.Список.ТекущаяСтрока;
	Если НЕ ЗначениеЗаполнено(ПрограммаOutlook) Тогда Возврат; КонецЕсли;	
	ТекущаяНастройка = Новый Структура("ПрограммаOutlook,Наименование");
	ЗаполнитьЗначенияСвойств(ТекущаяНастройка, Элемент.ТекущиеДанные);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновлениеНастроекОбменаНаКлиенте", ЭтотОбъект);
	ОткрытьФорму("Обработка.CRM_ОбменСMSOutlook.Форма.ФормаМастерНастройки",
		Новый Структура("ЗначенияЗаполнения", ТекущаяНастройка), ЭтотОбъект,,,, ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаOutlookВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка	= Ложь;	
	ПрограммаOutlook		= Элементы.Список.ТекущаяСтрока;
	Если НЕ ЗначениеЗаполнено(ПрограммаOutlook) Тогда Возврат; КонецЕсли;	
	ТекущаяНастройка = Новый Структура("ПрограммаOutlook,Наименование");
	ЗаполнитьЗначенияСвойств(ТекущаяНастройка, Элемент.ТекущиеДанные);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновлениеНастроекОбменаНаКлиенте", ЭтотОбъект);
	ОткрытьФорму("Обработка.CRM_ОбменСMSOutlook.Форма.ФормаМастерНастройки",
		Новый Структура("ЗначенияЗаполнения", ТекущаяНастройка), ЭтотОбъект,,,, ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаOutlookПередУдалением(Элемент, Отказ)
	ТекДанные = Элемент.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда Возврат; КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкиОбменаOutlookПередУдалениемЗавершение", ЭтотОбъект, Элемент);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Удалить выбранную настройку?';en='Delete the select settings?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаOutlookПередУдалениемЗавершение(Ответ, Элемент) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ТекДанные = Элемент.ТекущиеДанные;
		ПрограммаOutlook	= ТекДанные.ПрограммаOutlook;
		Наименование		= ТекДанные.Наименование;
		УдалитьНастройку(ПрограммаOutlook, Наименование);
		ОбновитьНастройкиОбменаНаКлиенте();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыполнитьОбмен(Команда)
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru='Обмен с MS Outlook невозможен в Веб-клиенте!';en='Exchange with MS Outlook is not possible in  Web Client!'"), 15);
		Возврат;
	#КонецЕсли
	ТекущиеДанные = Элементы.НастройкиОбменаOutlook.ТекущиеДанные;
	ИмяКомпьютера = Элементы.Список.ТекущиеДанные.Компьютер;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru='Не выбрана настройка обмена!';en='No exchange setting selected!'"));	
		Возврат;
	КонецЕсли;
	Настройка = CRM_ОбменСMSOutlookСервер.ПолучитьНастройкуОбмена(ТекущиеДанные.ПрограммаOutlook,
		ТекущиеДанные.Наименование);
	ЕстьОшибки = Ложь;	
	Если НЕ (ТипЗнч(Настройка) = Тип("Структура")) Тогда
		ЕстьОшибки = Истина;	
	ИначеЕсли НЕ Настройка.Свойство("ПрограммаOutlook") Тогда
		ЕстьОшибки = Истина;	
	КонецЕсли;
	Если ЕстьОшибки Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'В выбранной настройке обнаружены ошибки!
			|Используйте мастер для редактирования настройки или создайте новую.'"));
		Возврат;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ПрограммаOutlook) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Не выбрана настройка для проведения обмена данными';en='Settings for carrying out of a data interchange are not selected'"));
		Возврат;
	КонецЕсли;
	ПроверитьСкорректироватьМассивСоответствий(Настройка);
	ДатыПредыдущейСинхронизации	= ПолучитьДатыСинхронизации(ТекущиеДанные.ПрограммаOutlook);
	ЗаполнитьДатыИзменения(Настройка);
	СтруктураСвойств = CRM_ОбменСMSOutlookКлиент.ПолучитьСтруктуруСвойств();
	Если СтруктураСвойств.Свойство("ТаблицаПапокOutlook") Тогда 
		Если Настройка.Свойство("ТаблицаПапокOutlook") Тогда
			СтруктураСвойств.ТаблицаПапокOutlook = Настройка.ТаблицаПапокOutlook;
		Иначе 
			СтруктураСвойств.ТаблицаПапокOutlook = Новый Массив;	
		КонецЕсли;
	КонецЕсли;
	ТекстОшибки = "";
	Если НЕ CRM_ОбменСMSOutlookКлиент.ПолучитьOutlookObj(СтруктураСвойств, Настройка, ТекстОшибки) Тогда
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ПоказатьПредупреждение(, ТекстОшибки);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаВыполнитьОбменЗавершение", ЭтотОбъект);
	CRM_ОбменСMSOutlookКлиент.СинхронизироватьПоНастройке(СтруктураСвойств, Настройка, ЭтотОбъект, ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнитьОбменЗавершение(ДатыПоследнейСинхронизации, ДополнительныеПараметры) Экспорт
	Если НЕ (ДатыПоследнейСинхронизации = Неопределено) Тогда
		ТекущиеДанные = Элементы.НастройкиОбменаOutlook.ТекущиеДанные;
		Надписи	= ПолучитьНадписьДатыПоследнейСинхронизации(ТекущиеДанные.ПрограммаOutlook, ДатыПредыдущейСинхронизации);
		Элементы.НадписьДатаСинхронизации.Заголовок	= Надписи.НадписьДатыСинхронизации;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПометитьНастройкуОсновной(Команда)
	ТекущаяПрограммаOutlook = Элементы.Список.ТекущаяСтрока;
	Если  ТекущаяПрограммаOutlook = Неопределено Тогда Возврат; КонецЕсли;
	ТекущаяНастройка = Элементы.НастройкиОбменаOutlook.ТекущиеДанные;
	Если  ТекущаяНастройка = Неопределено Тогда Возврат; КонецЕсли;
	СтруктураНастройки = Новый Структура("ПрограммаOutlook,Наименование");
	ЗаполнитьЗначенияСвойств(СтруктураНастройки,ТекущаяНастройка);
	Если ТекущаяНастройка = Неопределено Тогда Возврат; КонецЕсли;
	CRM_ОбменСMSOutlookСервер.УстановитьНастройкуОсновной(ТекущаяПрограммаOutlook, СтруктураНастройки);
	ОбновитьНастройкиОбмена();
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьНастройкиОбменаНаКлиенте", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Общие процедуры и функции

&НаКлиенте
Процедура ОбновлениеНастроекОбменаНаКлиенте(Результат, ДополнительныеПараметры) Экспорт
	ОбновитьНастройкиОбменаНаКлиенте();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДатыИзменения(СтруктураНастройки)
	ПрограммаOutlook = Элементы.Список.ТекущаяСтрока;
	Если НЕ СтруктураНастройки.Свойство("ФильтрДатаИзмененияКонтактаOutlook")
		ИЛИ НЕ (ТипЗнч(СтруктураНастройки.ФильтрДатаИзмененияКонтактаOutlook) = Тип("Дата"))
		ИЛИ	НЕ ЗначениеЗаполнено(СтруктураНастройки.ФильтрДатаИзмененияКонтактаOutlook)
		ИЛИ (ПрограммаOutlook.ДатаПоследнейСинхронизацииКонтактов > СтруктураНастройки.ФильтрДатаИзмененияКонтактаOutlook) Тогда
		СтруктураНастройки.Вставить("ФильтрДатаИзмененияКонтактаOutlook", ПрограммаOutlook.ДатаПоследнейСинхронизацииКонтактов);
	КонецЕсли;
	Если НЕ СтруктураНастройки.Свойство("ФильтрДатаИзмененияСобытияOutlook")
		ИЛИ НЕ (ТипЗнч(СтруктураНастройки.ФильтрДатаИзмененияСобытияOutlook) = Тип("Дата"))
		ИЛИ	НЕ ЗначениеЗаполнено(СтруктураНастройки.ФильтрДатаИзмененияСобытияOutlook)
		ИЛИ (ПрограммаOutlook.ДатаПоследнейСинхронизацииСобытий > СтруктураНастройки.ФильтрДатаИзмененияСобытияOutlook) Тогда
		СтруктураНастройки.Вставить("ФильтрДатаИзмененияСобытияOutlook", ПрограммаOutlook.ДатаПоследнейСинхронизацииСобытий);
	КонецЕсли;
	Если НЕ СтруктураНастройки.Свойство("ФильтрДатаИзмененияПисьмаOutlook")
		ИЛИ НЕ (ТипЗнч(СтруктураНастройки.ФильтрДатаИзмененияПисьмаOutlook) = Тип("Дата"))
		ИЛИ	НЕ ЗначениеЗаполнено(СтруктураНастройки.ФильтрДатаИзмененияПисьмаOutlook)
		ИЛИ НЕ (ПрограммаOutlook.ДатаПоследнейСинхронизацииПисем > СтруктураНастройки.ФильтрДатаИзмененияПисьмаOutlook) Тогда
		СтруктураНастройки.Вставить("ФильтрДатаИзмененияПисьмаOutlook", ПрограммаOutlook.ДатаПоследнейСинхронизацииПисем);
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПроверитьСкорректироватьМассивСоответствий(Настройка)
	Таб	= Неопределено;
	Настройка.Свойство("СоответствиеКонтактнойИнформации", Таб);
	Если НЕ (Таб = Неопределено) Тогда
		Ном = Таб.Количество();
		Пока Ном > 0 Цикл
			Если ЗначениеЗаполнено(Таб[Ном - 1].ВидКИ1С) И НЕ ОбщегоНазначения.СсылкаСуществует(Таб[Ном - 1].ВидКИ1С) Тогда
				Таб.Удалить(Ном - 1);
			ИначеЕсли ЗначениеЗаполнено(Таб[Ном - 1].ВидКИ1С) Тогда
				Если (Таб[Ном - 1].Тип = Перечисления.ТипыКонтактнойИнформации.Факс) И НЕ (Таб[Ном - 1].ВидКИOutlook = "BusinessFaxNumber") Тогда
					Таб[Ном - 1].ВидКИOutlook			= "BusinessFaxNumber";
					Таб[Ном - 1].ПредставлениеКИOutlook	= "Факс рабочий";
				КонецЕсли;
			КонецЕсли;
			Ном = Ном - 1;
		КонецЦикла;
		Настройка.СоответствиеКонтактнойИнформации = Таб;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписка()
	ЭлементОтбора					= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("Пользователь");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение	= Пользователи.ТекущийПользователь();
	ЭлементОтбора.Использование		= Истина;
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиОбмена()
	РегНастройки = РегистрыСведений.CRM_НастройкиОбменаСOutlook;
	ТекущаяСтрокаСписка = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрокаСписка = Неопределено Тогда Возврат; КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_НастройкиОбменаСOutlook.ПрограммаOutlook,
	               |	CRM_НастройкиОбменаСOutlook.Наименование,
	               |	CRM_НастройкиОбменаСOutlook.Настройка,
	               |	CRM_НастройкиОбменаСOutlook.Основная
	               |ИЗ
	               |	РегистрСведений.CRM_НастройкиОбменаСOutlook КАК CRM_НастройкиОбменаСOutlook
	               |ГДЕ
	               |	CRM_НастройкиОбменаСOutlook.ПрограммаOutlook = &ПрограммаOutlook";
				   
	Запрос.УстановитьПараметр("ПрограммаOutlook",ТекущаяСтрокаСписка);
	ТаблицаНастроек = Запрос.Выполнить().Выгрузить();
	НастройкиОбменаOutlook.Очистить();
	НастройкиОбменаOutlook.Загрузить(ТаблицаНастроек);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНастройкиОбменаНаКлиенте()
	ОбновитьНастройкиОбмена();
	ПрограммаOutlook = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ПрограммаOutlook) Тогда
		Надписи = ПолучитьНадписьДатыПоследнейСинхронизации(ПрограммаOutlook, ДатыПредыдущейСинхронизации);
		Элементы.НадписьДатаСинхронизации.Заголовок = Надписи.НадписьДатыСинхронизации;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьДатыСинхронизации(ПрограммаOutlook)
	ДатыСинхронизации = Новый Структура("ДатаПоследнейСинхронизацииКонтактов,
	|ДатаПоследнейСинхронизацииСобытий,
	|ДатаПоследнейСинхронизацииПисем");
	ЗаполнитьЗначенияСвойств(ДатыСинхронизации, ПрограммаOutlook);
	Возврат ДатыСинхронизации;
КонецФункции

&НаСервере
Функция ПолучитьНадписьДатыПоследнейСинхронизации(ПрограммаOutlook, ДатыПредыдущейСинхронизации)
	СтруктураВозврата = Новый Структура("ОбменВыполнен,НадписьДатыСинхронизации");
	ДатыСинхронизации = ПолучитьДатыСинхронизации(ПрограммаOutlook);
	Для Каждого ДатаСинхр Из ДатыСинхронизации Цикл
		ДатыСинхронизации[ДатаСинхр.Ключ] = ?(ДатаСинхр.Значение = Неопределено, Дата("00010101000000"), ДатаСинхр.Значение);
	КонецЦикла;
	Для Каждого ДатаСинхр Из ДатыПредыдущейСинхронизации Цикл
		ДатыПредыдущейСинхронизации[ДатаСинхр.Ключ] = ?(ДатаСинхр.Значение = Неопределено, Дата("00010101000000"),
			ДатаСинхр.Значение);
	КонецЦикла;
	ДатаПоследнейСинхронизацииКонтактов	= ДатыСинхронизации.ДатаПоследнейСинхронизацииКонтактов;
	ДатаПоследнейСинхронизацииСобытий	= ДатыСинхронизации.ДатаПоследнейСинхронизацииСобытий;
	ДатаПоследнейСинхронизацииПисем		= ДатыСинхронизации.ДатаПоследнейСинхронизацииПисем;
	ОбменВыполнен	= Ложь;
	ОбменВыполнен	= ?((ЗначениеЗаполнено(ДатаПоследнейСинхронизацииКонтактов)
		И ДатыПредыдущейСинхронизации.ДатаПоследнейСинхронизацииКонтактов < ДатаПоследнейСинхронизацииКонтактов)
		ИЛИ ОбменВыполнен, Истина, Ложь);
	ОбменВыполнен	= ?((ЗначениеЗаполнено(ДатаПоследнейСинхронизацииСобытий)
		И ДатыПредыдущейСинхронизации.ДатаПоследнейСинхронизацииСобытий < ДатаПоследнейСинхронизацииСобытий)
		ИЛИ ОбменВыполнен, Истина, Ложь);
	ОбменВыполнен	= ?((ЗначениеЗаполнено(ДатаПоследнейСинхронизацииПисем)
		И ДатыПредыдущейСинхронизации.ДатаПоследнейСинхронизацииПисем < ДатаПоследнейСинхронизацииПисем)
		ИЛИ ОбменВыполнен, Истина, Ложь);
	Если ОбменВыполнен Тогда
		СтруктураВозврата.ОбменВыполнен = НСтр("ru='Обмен выполнен';en='The exchange are fulfill'");
	Иначе
		СтруктураВозврата.ОбменВыполнен = НСтр("ru='Обмен не выполнен';en='The exchange is not foundulfill'");
	КонецЕсли;
	дСинхрСобытий	= ?(ЗначениеЗаполнено(ДатаПоследнейСинхронизацииСобытий),	ДатаПоследнейСинхронизацииСобытий,		"");
	дСинхрКонтактов	= ?(ЗначениеЗаполнено(ДатаПоследнейСинхронизацииКонтактов),	ДатаПоследнейСинхронизацииКонтактов,	"");
	дСинхрПисем		= ?(ЗначениеЗаполнено(ДатаПоследнейСинхронизацииПисем),		ДатаПоследнейСинхронизацииПисем,		"");
	НадписьДатаСинхронизации	= "";
	ТекстСтроки = " Синхронизация контактов: " + Строка(дСинхрКонтактов) + Символы.ПС + " Синхронизации событий: " 
		+ Строка(дСинхрСобытий)+ Символы.ПС + " Синхронизации писем: " + Строка(дСинхрПисем);
	СтрокаЗаголовка = НСтр(ТекстСтроки);
	СтруктураВозврата.НадписьДатыСинхронизации = ТекстСтроки;
	Возврат СтруктураВозврата;
КонецФункции

&НаСервере
Процедура УдалитьНастройку(ПрограммаOutlook,Наименование)
	 НаборЗаписей										= РегистрыСведений.CRM_НастройкиОбменаСOutlook.СоздатьНаборЗаписей();
	 НаборЗаписей.Отбор.ПрограммаOutlook.Значение		= ПрограммаOutlook;
	 НаборЗаписей.Отбор.ПрограммаOutlook.Использование	= Истина;
	 НаборЗаписей.Отбор.Наименование.Значение			= Наименование;
	 НаборЗаписей.Отбор.Наименование.Использование		= Истина;
	 НаборЗаписей.Записать(Истина);
КонецПроцедуры

#КонецОбласти 



