#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	ОтборОрганизация = ОсновнаяОрганизация;
	
	Если Параметры.ОтключитьОтборПоОрганизации Тогда
		ОтборОрганизация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	УстановитьВосстановленныеОтборы();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.УведомлениеОКонтролируемыхСделках);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// Заполнение группы информационных ссылок
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтаФорма, Элементы.ИнформационныеСсылки);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.ОтключитьОтборПоОрганизации Тогда
		ОтборОрганизация = Справочники.Организации.ПустаяСсылка();
		ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	Иначе
		СтруктураОтбора = Неопределено;
		Если Параметры.Свойство("Отбор", СтруктураОтбора) И ЗначениеЗаполнено(СтруктураОтбора)
			И СтруктураОтбора.Свойство("Организация") Тогда
			ОтборОрганизация = СтруктураОтбора.Организация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			Параметры.Отбор.Удалить("Организация");
		Иначе
			Если ЗначениеЗаполнено(ОсновнаяОрганизация) И ОтборОрганизация <> ОсновнаяОрганизация Тогда
				ОтборОрганизация = ОсновнаяОрганизация;
				ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			ИначеЕсли НЕ ОтборОрганизацияИспользование Тогда
				ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	Оповестить("Запись_УведомлениеОКонтролируемыхСделках", , Элемент.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтаФорма.ИмяФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

&НаСервере
Процедура УстановитьВосстановленныеОтборы()
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

#КонецОбласти
