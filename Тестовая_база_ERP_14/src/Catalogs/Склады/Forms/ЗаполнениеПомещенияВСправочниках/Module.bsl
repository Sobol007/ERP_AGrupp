#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания; //Параметры обработчика ожидания, который проверяет завершение выполнения фонового задания

&НаКлиенте
Перем ЗадаватьВопросПередЗакрытием; //Для передачи в обработчик ПередЗакрытием признак необходимости вопроса.

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Склад = Параметры.Склад;
	
	ИменаОбъектов = Справочники.Склады.ИменаОбъектовСПустымПомещением(Склад);
	
	ЗаполняемыеСправочники = "";
	ЕстьРабочиеУчастки   = Ложь;
	ЕстьСправочныеЯчейки = Ложь;
	ЕстьХранениеОстатков = Ложь;
	
	Для Каждого СтрМас Из ИменаОбъектов Цикл
		
		Если СтрМас = "СкладскиеЯчейки" Тогда
			Текст = "- " + Метаданные.Справочники.СкладскиеЯчейки.ПредставлениеСписка + Символы.ПС;
		ИначеЕсли СтрМас = "РабочиеУчастки" Тогда
			Текст = "- " + Метаданные.Справочники.РабочиеУчастки.ПредставлениеСписка + Символы.ПС;
			ЕстьРабочиеУчастки   = Истина;
		ИначеЕсли СтрМас = "ОбластиХранения" Тогда
			Текст = "- " + Метаданные.Справочники.ОбластиХранения.ПредставлениеСписка + Символы.ПС;
			ЕстьХранениеОстатков = Истина;
		ИначеЕсли СтрМас = "ПравилаРазмещенияТоваровВЯчейках" Тогда
			Текст = "- " + Метаданные.РегистрыСведений.ПравилаРазмещенияТоваровВЯчейках.ПредставлениеСписка + Символы.ПС;
			ЕстьХранениеОстатков = Истина;
		ИначеЕсли СтрМас = "РазмещениеНоменклатурыПоСкладскимЯчейкам" Тогда
			Текст = "- " + Метаданные.РегистрыСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам.ПредставлениеСписка + Символы.ПС;
			ЕстьСправочныеЯчейки = Истина;
		Иначе
			Текст = "";
		КонецЕсли;
		ЗаполняемыеСправочники = ЗаполняемыеСправочники + Текст;
	КонецЦикла;
	
	МассивОтборов = Новый Массив;
	
	Если ЕстьРабочиеУчастки Тогда
		ПараметрВыбора = Новый ПараметрВыбора("ИспользованиеРабочихУчастков", Перечисления.ИспользованиеСкладскихРабочихУчастков.Использовать);
		МассивОтборов.Добавить(ПараметрВыбора);
	КонецЕсли;
	
	Если ЕстьХранениеОстатков Тогда
		ПараметрВыбора = Новый ПараметрВыбора("НастройкаАдресногоХранения", Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки);
		МассивОтборов.Добавить(ПараметрВыбора);
	ИначеЕсли ЕстьСправочныеЯчейки Тогда
		ПараметрВыбора = Новый ПараметрВыбора("НастройкаАдресногоХранения", Перечисления.НастройкиАдресногоХранения.ЯчейкиСправочно);
		МассивОтборов.Добавить(ПараметрВыбора);
	КонецЕсли;
	
	Элементы.Помещение.ПараметрыВыбора = Новый ФиксированныйМассив(МассивОтборов);
	
	УстановитьВидимостьНаСервере();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И ЗадаватьВопросПередЗакрытием Тогда
		
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Работа помощника по заполнению реквизита ""Помещение"" в справочниках будет прервана.';
									|en = 'Wizard filling in the Wareroom attribute in catalogs will be stopped.'");
		Возврат;
		
	КонецЕсли;
	
	Если ВыполняетсяЗакрытие Тогда
		
		Если Не ЗадаватьВопросПередЗакрытием Тогда
			Возврат;
		КонецЕсли;
		
		НСтрока = НСтр("ru = 'Завершить работу с помощником?';
						|en = 'Close the wizard?'");
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗадаватьВопросПередЗакрытием = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Помещение) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Помещение"".';
								|en = 'Wareroom is not filled in.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Помещение");
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработкаСправочников", 0.1, Истина);
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы.СтраницаСостояниеОбработки;
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОжидание;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСправочников()
	
	Результат = ОбработкаСправочниковСервер();
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗавершитьОбработку();
	Иначе
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработкаСправочниковСервер()
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Склад",Склад);
	ПараметрыЗаполнения.Вставить("Помещение",Помещение);
	
	НаименованиеЗадания = НСтр("ru = 'Заполнение помещения в справочниках по складу ""%Склад%"".';
								|en = 'Fill in a wareroom in catalogs for the ""%Склад%"" warehouse.'");
	НаименованиеЗадания = СтрЗаменить(НаименованиеЗадания, "%Склад%", Склад);
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Справочники.Склады.ЗаполнитьПомещениеВСправочниках", 
		ПараметрыЗаполнения, 
		НаименованиеЗадания);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьОбработку()
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы.СтраницаЗавершение;
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОкончание;
	Элементы.КомандаГотово.КнопкаПоУмолчанию = Истина;
	ЗадаватьВопросПередЗакрытием = Ложь;
	Оповестить("Склады_ЗаполненоПомещениеВСправочникахИРегистрах");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗавершитьОбработку();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,Истина);
		КонецЕсли;
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьРезервнуюКопиюНажатие(Элемент)
	// Резервная копия ИБ
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма");

КонецПроцедуры 

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	ЗначениеВидимости = ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СинхронизацияДанных",
		"Видимость",
		ЗначениеВидимости);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
