#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ID = Параметры.ID;
	Тип = Параметры.type;
	Если НЕ ЗначениеЗаполнено(Тип) Тогда
		Тип = "DMCorrespondent";
	КонецЕсли;
	
	Параметры.Свойство("ВнешнийОбъект", ВнешнийОбъект);
	
	ЗначениеЮрЛицо = "ЮрЛицо";
	ЗначениеФизЛицо = "ФизЛицо";
	ЗначениеИП = "ИндивидуальныйПредприниматель";
	ЗначениеНеРезидент = "ЮрЛицоНеРезидент";
	
	Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
		Элементы.ДекорацияЮрФизЛицо.Заголовок = НСтр("ru = 'Вид корреспондента';
													|en = 'Correspondent kind'");
	КонецЕсли;
	
	// считать данные документа
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	Если ЗначениеЗаполнено(ID) И ЗначениеЗаполнено(Тип) Тогда 
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMRetrieveRequest");
		
		ОбъектИд = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ID, Тип);
		Запрос.objectIds.Добавить(ОбъектИд);
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат.objects[0];
		
		Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
			Заголовок = СтрШаблон(НСтр("ru = '%1 (Корреспондент)';
										|en = '%1 (Correspondent) '"), ОбъектXDTO.name);
		Иначе
			Заголовок = СтрШаблон(НСтр("ru = '%1 (Контрагент)';
										|en = '%1 (Counterparty)'"), ОбъектXDTO.name);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВнешнийОбъект) Тогда
			ВнешниеОбъекты = ИнтеграцияС1СДокументооборот.СсылкиПоВнешнимОбъектам(ОбъектXDTO);
			Если ВнешниеОбъекты.Количество() <> 0 Тогда
				ВнешнийОбъект = ВнешниеОбъекты[0];
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetNewObjectRequest");
		Запрос.type = Тип;
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат;
		
		Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
			Заголовок = НСтр("ru = 'Корреспондент (создание)';
							|en = 'Correspondent (creation)'");
		Иначе
			Заголовок = НСтр("ru = 'Контрагент (создание)';
							|en = 'Counterparty (creation)'");
		КонецЕсли;
		
	КонецЕсли;
	
	// перенести данные в форму
	ПрочитатьОбъектВФорму(ОбъектXDTO);
	
	Если Не ЗначениеЗаполнено(ID)
		И ЗначениеЗаполнено(ВнешнийОбъект)
		И ЗначениеЗаполнено(Параметры.Правило) Тогда
		
		Справочники.ПравилаИнтеграцииС1СДокументооборотом.ЗаполнитьФормуИзПотребителя(
			ВнешнийОбъект, ЭтаФорма, Параметры.Правило);
		ИнтеграцияС1СДокументооборотПереопределяемый.ЗаполнитьФормуИзПотребителя(
			ВнешнийОбъект, ЭтаФорма);
			
		// Корректировка юр. / физ. лица.
		Если ЮрФизЛицо = НСтр("ru = 'Физическое лицо';
								|en = 'Individual'") Тогда
			ЮрФизЛицоID = "ФизЛицо";
			ЮрФизЛицоТип = "DMLegalPrivatePerson";
		ИначеЕсли ЮрФизЛицо = НСтр("ru = 'Юридическое лицо';
									|en = 'Business entity'") Тогда
			ЮрФизЛицоID = "ЮрЛицо";
			ЮрФизЛицоТип = "DMLegalPrivatePerson";
		ИначеЕсли ЮрФизЛицо = НСтр("ru = 'Индивидуальный предприниматель';
									|en = 'Individual entrepreneur'") Тогда
			ЮрФизЛицоID =  "ИндивидуальныйПредприниматель";
			ЮрФизЛицоТип = "DMLegalPrivatePerson";
		ИначеЕсли ЮрФизЛицо = НСтр("ru = 'Не резидент';
									|en = 'Non-resident'")   Тогда
			ЮрФизЛицоID =  "ЮрЛицоНеРезидент";
			ЮрФизЛицоТип = "DMLegalPrivatePerson";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ТолькоПросмотр = Истина Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// почта
	Если НЕ ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.2.8.1.CORP") Тогда
		Элементы.ФормаСоздатьПисьмо.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьДекорацииСвязи();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Документооборот_ВыбратьЗначениеИзВыпадающегоСпискаЗавершение" И Источник = ЭтаФорма Тогда
		Если Параметр.Реквизит = "ЮрФизЛицо" И ЮрФизЛицоID <> ИсходноеЮрФизЛицоID Тогда 
			УстановитьВидимость();
			ОбновитьЭлементыДополнительныхРеквизитов();
			ИсходноеЮрФизЛицоID = ЮрФизЛицоID;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Документооборот_ДобавлениеСвязи" И Параметр.ID = ID Тогда
		ВнешнийОбъект = Параметр.Объект;
		ОбновитьДекорацииСвязи();
		
	ИначеЕсли ИмяСобытия = "Документооборот_УдалениеСвязи" И Параметр.ID = ID Тогда
		ВнешнийОбъект = Неопределено;
		ОбновитьДекорацииСвязи();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗакрытиеСПараметром Тогда 
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтаФорма);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
		
	Иначе
		
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ЗакрытьСПараметром", 0.1, Истина);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СвязьОбъектНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, ВнешнийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьСоздатьНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(ID) Тогда
		ЗаписатьОбъект();
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СвязьСоздатьНажатиеЗавершение", ЭтаФорма);
	Если ПравилаЗаполнения.Количество() = 1 Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ПравилаЗаполнения[0]);
	Иначе
		ПоказатьВыборИзМеню(ОписаниеОповещения, ПравилаЗаполнения, Элементы.СвязьСоздать);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьВыбратьНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(ID) Тогда
		ЗаписатьОбъект();
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СвязьВыбратьНажатиеЗавершение", ЭтаФорма);
	Если ПравилаЗаполнения.Количество() = 1 Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ПравилаЗаполнения[0]);
	Иначе
		ПоказатьВыборИзМеню(ОписаниеОповещения, ПравилаЗаполнения, Элементы.СвязьВыбрать);
	КонецЕсли; 
		
КонецПроцедуры


&НаКлиенте
Процедура СвязьОчиститьНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(ВнешнийОбъект) Тогда 
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("СвязьОчиститьНажатиеЗавершение", ЭтаФорма);
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Вы действительно хотите очистить соответствие для
					|%1?';
					|en = 'Are you sure you want to clear mapping for
					|%1?'"),Строка(ВнешнийОбъект));
	
	Кнопки = новый СписокЗначений;
	Кнопки.Добавить(КодВозвратаДиалога.Да,НСтр("ru = 'Очистить';
												|en = 'Clear'"));
	Кнопки.Добавить(КодВозвратаДиалога.Нет,НСтр("ru = 'Не очищать';
												|en = 'Do not clean up'"));
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	Если ЮрФизЛицоID <> ИсходноеЮрФизЛицоID Тогда 
		
		УстановитьВидимость();
		
		// Обработчик механизма "Свойства"
		ОбновитьЭлементыДополнительныхРеквизитов();
		
		ИсходноеЮрФизЛицоID = ЮрФизЛицоID;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка("DMLegalPrivatePerson", "ЮрФизЛицо", 
		ЭтаФорма,,,Элементы.ЮрФизЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMLegalPrivatePerson", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("ЮрФизЛицо", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMLegalPrivatePerson", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("ЮрФизЛицо", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПолноеНаименование) Тогда 
		ПолноеНаименование = Наименование;
	КонецЕсли;
	
	Представление = Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Ответственный", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка("DMPrivatePerson", "ФизЛицо", ЭтаФорма); 
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("ФизЛицо", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMPrivatePerson", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMPrivatePerson", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ФизЛицо", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		 Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Ответственный", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Ответственный", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСвойства

&НаКлиенте
Процедура СвойстваЗначениеПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеДополнительногоРеквизита(ЭтаФорма, Элемент, СтандартнаяОбработка);
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	ЗаписатьОбъект();
	Модифицированность = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтаФорма, ВнешнийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьОбъект();
	Модифицированность = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтаФорма, ВнешнийОбъект);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБизнесПроцесс(Команда)
	
	Если ЗначениеЗаполнено(ID) Тогда
		ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцессПоОбъектуДО(ID, Тип, Наименование);
	Иначе
		Оповещение = Новый ОписаниеОповещения("СоздатьБизнесПроцессЗавершение", ЭтаФорма);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
							|Создание бизнес-процесса возможно только после записи данных.
							|Данные будут записаны.';
							|en = 'Data has not been written yet.
							|You can create a business process only after the data is written.
							|Data will be written.'");
		Кнопки = РежимДиалогаВопрос.ОКОтмена;
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, 0);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПисьмо(Команда)
	
	ПараметрыФормы = новый Структура("Предмет", новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("id", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	ПараметрыФормы.Предмет.Вставить("name", Наименование);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаписатьОбъект();
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьОбъекта(ЭтаФорма, ВнешнийОбъект);
	ЗакрытьСПараметром();
	
КонецПроцедуры

// Вызывается после создания объекта ИС и фиксирует созданную связь.
//
&НаКлиенте
Процедура СвязьСоздатьНажатиеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотКлиент.СоздатьИнтегрированныйОбъектПоДаннымФормы(
			ЭтаФорма, Результат.Значение);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после выбора типа объекта ИС и начинает выбор объекта.
//
&НаКлиенте
Процедура СвязьВыбратьНажатиеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено  Тогда
		ТипОбъектаПотребителя = ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Результат.Значение,
			"ТипОбъектаПотребителя");
		Оповещение = Новый ОписаниеОповещения("СвязьВыбратьНажатиеЗавершениеВыбора", ЭтаФорма);
		ОткрытьФорму(ТипОбъектаПотребителя + ".ФормаВыбора",, Элементы.СвязьВыбрать,,,, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьВыбратьНажатиеЗавершениеВыбора(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДобавитьСвязь(ID, Тип, Результат);
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ДобавлениеСвязи(ID, Тип, Результат);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СвязьОчиститьНажатиеЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		КэшВнешнийОбъект = ВнешнийОбъект;
		УдалитьСвязьНаСервере();
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_УдалениеСвязи(ID, Тип, КэшВнешнийОбъект); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБизнесПроцессЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ЗаписатьВыполнить(Неопределено);
		ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцессПоОбъектуДО(ID, Тип, Наименование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСПараметром()
	
	Если ЗначениеЗаполнено(ID) Тогда
		Результат = Новый Структура;
		Результат.Вставить("id", ID);
		Результат.Вставить("type", Тип);
		Результат.Вставить("name", Наименование);
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	ЗакрытиеСПараметром = Истина;
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьОбъектВФорму(ОбъектXDTO)
	
	// заполнение реквизитов
	Представление = ОбъектXDTO.objectID.presentation;
	ИНН = ОбъектXDTO.inn;
	КПП = ОбъектXDTO.kpp;
	КодПоОКПО = ОбъектXDTO.okpo;
	Если ОбъектXDTO.Свойства().Получить("registrationNumber") = Неопределено Тогда
		Элементы.РегистрационныйНомер.Видимость = Ложь;
		Элементы.РегистрационныйНомер2.Видимость = Ложь;
		Элементы.РегистрационныйНомер3.Видимость = Ложь;
	Иначе
		РегистрационныйНомер = ОбъектXDTO.registrationNumber;
	КонецЕсли;
	
	Комментарий = ОбъектXDTO.comment;
	ПолноеНаименование = ОбъектXDTO.fullName;
	Наименование = ОбъектXDTO.name;
	
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.legalPrivatePerson, "ЮрФизЛицо", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.privatePerson, "ФизЛицо", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.responsible, "Ответственный", Ложь);
	
	ИсходноеЮрФизЛицоID = ЮрФизЛицоID;
	
	// дополнительные реквизиты
	Обработки.ИнтеграцияС1СДокументооборот.ПоместитьДополнительныеРеквизитыНаФорму(ЭтаФорма, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьНавигационнуюСсылку(ЭтаФорма, ОбъектXDTO);
	
	Если ЗначениеЗаполнено(ID) Тогда
		ПравилаЗаполнения = ИнтеграцияС1СДокументооборотВызовСервера.
			ПравилаЗаполненияИнтегрированныхОбъектовСписком(ОбъектXDTO);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	Обработки.ИнтеграцияС1СДокументооборот.ПолучитьДополнительныеРеквизитыИПоместитьНаФорму(Прокси, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	Если ЮрФизЛицоID = ЗначениеФизЛицо Тогда
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.ГруппаКакФизЛицо;
	ИначеЕсли ЮрФизЛицоID = ЗначениеИП Тогда
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.ГруппаКакИП;
	ИначеЕсли ЮрФизЛицоID = ЗначениеНеРезидент Тогда	
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.ГруппаКакНерезидент;
	Иначе
		Элементы.ГруппаЮрФизЛицо.ТекущаяСтраница = Элементы.ГруппаКакЮрЛицо;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьОбъект()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMCorrespondent");
	Обработки.ИнтеграцияС1СДокументооборот.СформироватьДополнительныеСвойства(Прокси, ОбъектXDTO, ЭтаФорма);
	
	СоответствиеРеквизитов = НовыйСоответствиеСвойствXDTOИРеквизитовОбъекта();
	
	Для Каждого СтрокаСоответствия Из СоответствиеРеквизитов Цикл
		Если ТипЗнч(СтрокаСоответствия.Значение) = Тип("Строка") Тогда
			ИнтеграцияС1СДокументооборот.ЗаполнитьСвойствоXDTOизСтруктурыРеквизитов(
				Прокси,
				ОбъектXDTO,
				СтрокаСоответствия.Значение,
				ЭтаФорма,
				СтрокаСоответствия.Ключ);
		Иначе
			Для Каждого Строка Из ЭтаФорма[СтрокаСоответствия.Ключ] Цикл
				СтрокаXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, СтрокаСоответствия.Значение.Тип);
				Для Каждого СтрокаСоответствияТЧ Из СтрокаСоответствия.Значение.Реквизиты Цикл
					ИнтеграцияС1СДокументооборот.ЗаполнитьСвойствоXDTOизСтруктурыРеквизитов(
						Прокси,
						СтрокаXDTO,
						СтрокаСоответствияТЧ.Значение,
						Строка,
						СтрокаСоответствияТЧ.Ключ);
				КонецЦикла;
				ОбъектXDTO[СтрокаСоответствия.Значение.Имя].Добавить(СтрокаXDTO);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ID) И ЗначениеЗаполнено(Тип) Тогда // обновление
		
		ОбъектXDTO.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ID, Тип);
		ОбъектXDTO.name = Наименование;
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMUpdateRequest");
		Запрос.objects.Добавить(ОбъектXDTO);
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат.objects[0];
		
	Иначе // создание
		
		ОбъектXDTO.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, "", "");
		ОбъектXDTO.name = Наименование;
		
		Если ЗначениеЗаполнено(ВнешнийОбъект) Тогда 
			ExternalObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "ExternalObject");
			ExternalObject.id = Строка(ВнешнийОбъект.УникальныйИдентификатор());
			ExternalObject.type = ВнешнийОбъект.Метаданные().ПолноеИмя();
			ExternalObject.name = Строка(ВнешнийОбъект);
			
			ОбъектXDTO.externalObject = ExternalObject;
		КонецЕсли;
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMCreateRequest");
		Запрос.object = ОбъектXDTO;
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		ОбъектXDTO = Результат.object;
		ID  = ОбъектXDTO.objectId.id;
		Тип = ОбъектXDTO.objectId.type;
		
	КонецЕсли;
	
	//перечитать объект в форму
	ПрочитатьОбъектВФорму(ОбъектXDTO);
	
КонецПроцедуры

&НаСервере
Функция НовыйСоответствиеСвойствXDTOИРеквизитовОбъекта()
	
	СоответствиеРеквизитов = Новый Соответствие;
	СоответствиеРеквизитов.Вставить("Наименование", "name");
	СоответствиеРеквизитов.Вставить("ЮрФизЛицо", "legalPrivatePerson");
	СоответствиеРеквизитов.Вставить("ИНН", "inn");
	СоответствиеРеквизитов.Вставить("КПП", "kpp");
	СоответствиеРеквизитов.Вставить("КодПоОКПО", "okpo");
	СоответствиеРеквизитов.Вставить("РегистрационныйНомер", "registrationNumber");
	СоответствиеРеквизитов.Вставить("Комментарий", "comment");
	СоответствиеРеквизитов.Вставить("ПолноеНаименование", "fullName");
	СоответствиеРеквизитов.Вставить("ФизЛицо", "privatePerson");
	СоответствиеРеквизитов.Вставить("Ответственный", "responsible");
	
	Возврат СоответствиеРеквизитов;
	
КонецФункции

&НаСервере
Процедура УдалитьСвязьНаСервере()

	ИнтеграцияС1СДокументооборотВызовСервера.УдалитьСвязь(ID, Тип, ВнешнийОбъект);
	ВнешнийОбъект = Неопределено;
	ОбновитьДекорацииСвязи();

КонецПроцедуры

&НаСервере
Процедура ОбновитьДекорацииСвязи()
	
	ДокументЗаполнен = ЗначениеЗаполнено(ВнешнийОбъект);
	
	Если ДокументЗаполнен Тогда
	
		МетаданныеОбъекта = ВнешнийОбъект.Метаданные();
		Если ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) Тогда
			ВнешнийОбъектПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2)",
				Строка(ВнешнийОбъект), МетаданныеОбъекта.Представление());
		Иначе
			ВнешнийОбъектПредставление = Строка(ВнешнийОбъект);
		КонецЕсли; 
	
	КонецЕсли; 
	
	Элементы.СвязьОбъект.Видимость = ДокументЗаполнен;
	Элементы.СвязьОчистить.Видимость = ДокументЗаполнен;
	
	Элементы.СвязьВыбрать.Видимость = НЕ ДокументЗаполнен;
	
	Если Не ДокументЗаполнен Тогда
	
		Если ПравилаЗаполнения.Количество() > 0 Тогда
			ВозможноСозданиеОбъекта = Истина;
		Иначе
			ВозможноСозданиеОбъекта = Ложь;
		КонецЕсли;
		
		Если ПравилаЗаполнения.Количество() = 1 Тогда
			ТекстЗаголовкаСоздать = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'создать %1';
					|en = 'create %1'"), НРег(ПравилаЗаполнения[0].Представление));
		ИначеЕсли ПравилаЗаполнения.Количество() = 0 Тогда
			Элементы.ГруппаСвязь.Видимость = Ложь;
			Возврат;
		Иначе
			ТекстЗаголовкаСоздать = НСтр("ru = 'создать...';
										|en = 'create ...'");
		КонецЕсли;
		
		Элементы.СвязьСоздать.Заголовок = ТекстЗаголовкаСоздать;
	
	КонецЕсли;
	
	Элементы.СвязьСоздать.Видимость = НЕ ДокументЗаполнен И ВозможноСозданиеОбъекта;
	Элементы.СвязьИли.Видимость = НЕ ДокументЗаполнен И ВозможноСозданиеОбъекта;
	
КонецПроцедуры

#КонецОбласти
