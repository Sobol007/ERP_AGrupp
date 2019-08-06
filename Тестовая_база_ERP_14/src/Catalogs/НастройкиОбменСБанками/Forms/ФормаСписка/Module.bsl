
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Банк) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор, "Банк", Параметры.Банк, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор, "Организация", Параметры.Организация, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	ОформитьИСкрытьНедействительныеНастройкиОбмена();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьНедействительныеНастройкиОбменаПриИзменении(Элемент)
	
	ПереключитьОтображениеНедействительныхНастроекОбмена(ПоказыватьНедействительныеНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНастройкуОбменаСБанком(Команда)
	
	ОчиститьСообщения();
	ПараметрыФормы = Новый Структура;
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Параметры.Организация);
	ЗначенияЗаполнения.Вставить("Банк", Параметры.Банк);
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);

	ОткрытьФорму("Справочник.НастройкиОбменСБанками.Форма.ПомощникСозданияНастройкиОбмена", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПакетыЭДОСБанками(Команда)
	
	ОткрытьФорму("Документ.ПакетОбменСБанками.Форма.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройкиИзФайла(Команда)

	ОчиститьСообщения();
	#Если ВебКлиент Тогда
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ПослеВыбораФайлаНастроекОбменаИзВеб", ЭтотОбъект);
		НачатьПомещениеФайла(ОписаниеОповещенияОЗавершении, , "*.xml", , УникальныйИдентификатор);
	#Иначе
		Режим = РежимДиалогаВыбораФайла.Открытие;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		Фильтр = НСтр("ru = 'Файл настроек обмена';
						|en = 'Exchange setting file'") + "(*.xml)|*.xml";
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл настроек обмена';
											|en = 'Select exchange setting file'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораФайлаНастроекОбменаИзТонкогоКлиента", ЭтотОбъект);
		ДиалогОткрытияФайла.Показать(ОписаниеОповещения);
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСообщенияОбменаСБанками(Команда)
	
	ОткрытьФорму("Документ.СообщениеОбменСБанками.Форма.ФормаСписка", , ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПереключитьОтображениеНедействительныхНастроекОбмена(ПоказатьНедействительные)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Недействительна", Ложь, , , НЕ ПоказатьНедействительные);
	
КонецПроцедуры

&НаСервере
Процедура ОформитьИСкрытьНедействительныеНастройкиОбмена()
	
	// Оформление.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.НедоступныеДанныеЭДЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.Недействительна");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("Список");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	// Скрытие.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Недействительна", Ложь, , , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФайлаНастроекОбменаИзВеб(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		ЗапуститьПомощникПодключения(Адрес);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФайлаНастроекОбменаИзТонкогоКлиента(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() Тогда
		ПутьКФайлуНастроекОбмена = ВыбранныеФайлы[0];
		ДанныеФайла = Новый ДвоичныеДанные(ПутьКФайлуНастроекОбмена);
		АдресФайлаНастроек = ПоместитьВоВременноеХранилище(ДанныеФайла, УникальныйИдентификатор);
		ЗапуститьПомощникПодключения(АдресФайлаНастроек);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьПомощникПодключения(АдресФайлаНастроек)

	ПараметрыФормы = Новый Структура("АдресДанныхФайлаНастроек, ЛокальныйФайл", АдресФайлаНастроек, Истина);
	ОткрытьФорму("Справочник.НастройкиОбменСБанками.Форма.ПомощникСозданияНастройкиОбмена", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
