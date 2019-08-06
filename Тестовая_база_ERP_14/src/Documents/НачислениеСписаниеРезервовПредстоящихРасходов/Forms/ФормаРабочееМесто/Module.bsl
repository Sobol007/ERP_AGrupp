
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Период = Параметры.Период;
	МассивОрганизаций = Новый ФиксированныйМассив(Параметры.МассивОрганизаций);
	
	ПредставлениеПериода = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(Период);
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		СформироватьПредставлениеОрганизаций(Параметры, Неопределено);
	Иначе
		Элементы.КОтражениюОрганизация.Видимость = Ложь;
		УстановитьПараметрыОтбораСписков();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ОбработчикЗакрытия = Новый ОписаниеОповещения("ПредставлениеПериодаНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы 	   = Новый Структура("Значение, РежимВыбораПериода", Период, "МЕСЯЦ");
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода",
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор,
		,
		, 
		ОбработчикЗакрытия,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.РегулированиеПредставленияПериодаРегистрации(
		Направление,
		СтандартнаяОбработка,
		Период,
		ПредставлениеПериода);
		
	УстановитьПараметрыОтбораСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОрганизацийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = ПараметрыОткрытияФормыВыбораОрганизаций();
	
	ОбработчикЗакрытия = Новый ОписаниеОповещения("ПредставлениеОрганизацийНачалоВыбораЗавершение", ЭтотОбъект, ПараметрыФормы.ОписаниеОрганизаций);
	
	ОткрытьФорму("Обработка.ОперацииЗакрытияМесяца.Форма.ВыборОрганизаций",
		ПараметрыФормы,
		ЭтотОбъект, 
		УникальныйИдентификатор,
		,
		,
		ОбработчикЗакрытия,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОрганизацийОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если МассивОрганизаций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивОрганизаций = Новый ФиксированныйМассив(Новый Массив);
	ПараметрыПредставления = Новый Структура("МассивОрганизаций, ВсеОрганизации", Неопределено, Истина);
	
	СформироватьПредставлениеОрганизаций(ПараметрыПредставления, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#Область СтандартныеПодсистемы_Печать

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокДокументов);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокДокументов, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокДокументов);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.СписокДокументов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеФормой

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ПредставлениеПериодаНачалоВыбораЗавершениеСервер(ВыбранныйПериод);
	
КонецПроцедуры

&НаСервере
Процедура ПредставлениеПериодаНачалоВыбораЗавершениеСервер(ВыбранныйПериод) 
	
	Период = ВыбранныйПериод;
	ПредставлениеПериода = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(Период);
	
	УстановитьПараметрыОтбораСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОрганизацийНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьПредставлениеОрганизаций(Результат, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОрганизаций(ПараметрыПредставления, ОписаниеОрганизаций)
	
	Если ПараметрыПредставления.МассивОрганизаций <> Неопределено Тогда
		МассивОрганизаций = Новый ФиксированныйМассив(ПараметрыПредставления.МассивОрганизаций);
	КонецЕсли;
	
	Если ПараметрыПредставления.ВсеОрганизации
	 ИЛИ (ЗначениеЗаполнено(ОписаниеОрганизаций)
	   И ОбщегоНазначенияУТКлиентСервер.МассивыРавны(МассивОрганизаций, ОписаниеОрганизаций.ДоступныеОрганизации, Ложь)) Тогда
	   
		Если ЗначениеЗаполнено(ОписаниеОрганизаций) И ОписаниеОрганизаций.ЕстьОграниченияДоступа Тогда
			ПредставлениеОрганизаций = НСтр("ru = 'По всем доступным организациям';
											|en = 'By all available companies'");
		Иначе
			ПредставлениеОрганизаций = НСтр("ru = 'По всем организациям';
											|en = 'By all companies'");
		КонецЕсли;
		
		Элементы.ПредставлениеОрганизаций.КнопкаОчистки = Ложь;
		
	Иначе
		
		ПредставлениеОрганизаций = УниверсальныеМеханизмыПартийИСебестоимости.ПредставлениеОрганизаций(МассивОрганизаций, ", ");
		
		Элементы.ПредставлениеОрганизаций.КнопкаОчистки = Истина;
		
	КонецЕсли;
	
	УстановитьПараметрыОтбораСписков();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыОтбораСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(КОтражению, "КонецПериода", КонецМесяца(Период));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(КОтражению, "МассивОрганизаций", МассивОрганизаций);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(КОтражению, "ВсеОрганизации", МассивОрганизаций.Количество() = 0);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов, "Дата",  КонецМесяца(Период), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов, "Дата",  НачалоМесяца(Период), ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов, "Организация",  МассивОрганизаций, ВидСравненияКомпоновкиДанных.ВСписке, , МассивОрганизаций.Количество());
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция ПараметрыОткрытияФормыВыбораОрганизаций()
	
	// Сформируем структуру с описанием организаций.
	ОписаниеОрганизаций = Новый Структура;
	
	ВсеОрганизации = Справочники.Организации.ДоступныеОрганизации(, Ложь);
	ДоступныеОрганизации = Справочники.Организации.ДоступныеОрганизации(Истина, Ложь);
	
	ОписаниеОрганизаций.Вставить("ОдиночныеОрганизации",  Новый ФиксированныйМассив(ВсеОрганизации));
	ОписаниеОрганизаций.Вставить("ГруппыОрганизаций", 	  Новый ФиксированныйМассив(Новый Массив));
	
	ОписаниеОрганизаций.Вставить("ОрганизацииИнтеркампани", Новый ФиксированноеСоответствие(Новый Соответствие));
	ОписаниеОрганизаций.Вставить("ОрганизацииОСиНМА", 	  Новый ФиксированноеСоответствие(Новый Соответствие));
	ОписаниеОрганизаций.Вставить("ДоступныеОрганизации", 	  Новый ФиксированныйМассив(ДоступныеОрганизации));
	
	ОписаниеОрганизаций.Вставить("ЕстьОграниченияДоступа",  ДоступныеОрганизации.Количество() <> ВсеОрганизации.Количество());
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПериодРегистрации",   Период);
	ПараметрыФормы.Вставить("МассивОрганизаций",   МассивОрганизаций);
	ПараметрыФормы.Вставить("ВсеОрганизации",      МассивОрганизаций.Количество() = 0);
	ПараметрыФормы.Вставить("ОписаниеОрганизаций", ОписаниеОрганизаций);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура СоздатьДокументОтражения(Команда)
	
	ТекущаяСтрока = Элементы.КОтражению.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не выбраны ""Организация"" и ""Вид резервов"" для создания документа';
								|en = '""Company"" and ""Reserve kind"" are not selected to create a document'");
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", ТекущаяСтрока.Организация);
	ЗначенияЗаполнения.Вставить("ВидРезервов", ТекущаяСтрока.ВидРезервов);
	ЗначенияЗаполнения.Вставить("Дата", Период);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.НачислениеСписаниеРезервовПредстоящихРасходов.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
