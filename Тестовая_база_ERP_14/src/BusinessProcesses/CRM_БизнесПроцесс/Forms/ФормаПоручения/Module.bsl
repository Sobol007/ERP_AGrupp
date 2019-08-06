#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоНовый = Объект.Ссылка.Пустая();
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		Попытка
			ЗаполнитьЗначенияСвойств(Объект, Параметры.ЗначенияЗаполнения);
		Исключение
		КонецПопытки;	
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.КартаМаршрута) Тогда
		
		ПолучитьТочкиСтарта();
		
		Если Объект.Ссылка.Пустая() Тогда
			
			НаборЭтапов = РегистрыСведений.CRM_НастройкиЭтапов.СоздатьНаборЗаписей();
			НаборЭтапов.Отбор.Объект.Установить(Объект.КартаМаршрута);
			НаборЭтапов.Прочитать();
			
			Если ЗначениеЗаполнено(Объект.Проект) Тогда		
				// Получение исполнителей по процессу.
				НаборИсполнителей = РегистрыСведений.CRM_ИсполнителиЭтапов.СоздатьНаборЗаписей();
				НаборИсполнителей.Отбор.Объект.Установить(Объект.Проект);
				НаборИсполнителей.Прочитать();
				
				// Если для процесса исполнители не определены, тогда берем их из карты.
				Если НаборИсполнителей.Количество() = 0 Тогда
					НаборИсполнителей = РегистрыСведений.CRM_ИсполнителиЭтапов.СоздатьНаборЗаписей();
					НаборИсполнителей.Отбор.Объект.Установить(Объект.КартаМаршрута);
					НаборИсполнителей.Прочитать();
				КонецЕсли;
			Иначе
				НаборИсполнителей = РегистрыСведений.CRM_ИсполнителиЭтапов.СоздатьНаборЗаписей();
				НаборИсполнителей.Отбор.Объект.Установить(Объект.КартаМаршрута);
				НаборИсполнителей.Прочитать();	
			КонецЕсли;
			
		Иначе
			НаборЭтапов = РегистрыСведений.CRM_НастройкиЭтаповБизнесПроцессов.СоздатьНаборЗаписей();
			НаборЭтапов.Отбор.Объект.Установить(Объект.Ссылка);
			НаборЭтапов.Прочитать();
			
			// Исполнители бизнес-процесса.
			НаборИсполнителей = РегистрыСведений.CRM_ИсполнителиЭтаповБизнесПроцессов.СоздатьНаборЗаписей();
			НаборИсполнителей.Отбор.Объект.Установить(Объект.Ссылка);
			НаборИсполнителей.Прочитать();	
		КонецЕсли;
			
		Для Каждого СтрокаНабора Из НаборИсполнителей Цикл
			Если СтрокаНабора.ТочкаМаршрута = НаборЭтапов[0].ТочкаМаршрута Тогда		// точка действия "Выполнить"
				Если СтрокаНабора.Исполнитель = Перечисления.CRM_ВидыИсполнителейЗадач.Автор Тогда
					Исполнитель		= Объект.Автор;
				ИначеЕсли ТипЗнч(СтрокаНабора.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
					Исполнитель		= СтрокаНабора.Исполнитель;
				ИначеЕсли ТипЗнч(СтрокаНабора.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
					Исполнитель		= СтрокаНабора.Исполнитель;
				КонецЕсли;
				Попытка
					СрокИсполнения	= НаборЭтапов[0].ДатаВыполнения;
				Исключение
					СрокИсполнения = НачалоДня(ТекущаяДатаСеанса())+ ВернутьВремяКонцаРабочегоДня()*60*60;
				КонецПопытки;
				ТочкаИсполнения	= НаборЭтапов[0].ТочкаМаршрута;
			ИначеЕсли СтрокаНабора.ТочкаМаршрута = НаборЭтапов[1].ТочкаМаршрута Тогда	// точка действия "Проверить"
				КонтролироватьВыполнение	= НаборЭтапов[1].Используется;
				Если СтрокаНабора.Исполнитель = Перечисления.CRM_ВидыИсполнителейЗадач.Автор Тогда
					Контролер		= Объект.Автор;
				ИначеЕсли ТипЗнч(СтрокаНабора.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
					Контролер		= СтрокаНабора.Исполнитель;
				ИначеЕсли ТипЗнч(СтрокаНабора.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
					Контролер		= СтрокаНабора.Исполнитель;
				КонецЕсли;
				Попытка
					СрокКонтроля	= НаборЭтапов[1].ДатаВыполнения;
				Исключение
					ИспользуемыйКалендарь = Константы.ОсновнойКалендарьПредприятия.Получить();
					Попытка
						СледующийДень = CRM_КалендарныеГрафики.ПолучитьДатуПоКалендарю(ИспользуемыйКалендарь, ТекущаяДатаСеанса(), 1);
					Исключение
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен календарный график!
											|Расчет без учета календаря!'"));
						//
						СекундВДне = 24 * 60 * 60;
						СледующийДень = ТекущаяДатаСеанса() + СекундВДне;
						Пока ДеньНедели(СледующийДень) = 6 Или ДеньНедели(СледующийДень) = 7 Цикл
							СледующийДень = СледующийДень + СекундВДне;
						КонецЦикла;
					КонецПопытки;
					СрокКонтроля = НачалоДня(СледующийДень) + ВернутьВремяКонцаРабочегоДня()*60*60;
					
				КонецПопытки;
				ТочкаКонтроля = НаборЭтапов[1].ТочкаМаршрута;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Исполнитель) Тогда
		Исполнитель = Справочники.Пользователи.ПустаяСсылка();
		ТипИсполнителя = "Пользователь";
	Иначе
		Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
			ТипИсполнителя = "Пользователь";
		ИначеЕсли ТипЗнч(СтрокаНабора.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
			ТипИсполнителя = "Роль";
		КонецЕсли;
	КонецЕсли;
	Если  ЗначениеЗаполнено(Объект.Проект) Или
		  ЗначениеЗаполнено(Объект.Этап)   Или	
		  ЗначениеЗаполнено(Объект.Партнер) Тогда
		  
		Элементы.ГруппаСвязатьСРеквизиты.Видимость = Истина;
		Элементы.ДекорацияСвязатьС.Видимость = Ложь;
	Иначе
		Элементы.ГруппаСвязатьСРеквизиты.Видимость = Ложь;
		Элементы.ДекорацияСвязатьС.Видимость = Истина;
	КонецЕсли;
	
	УстановитьСвойстваЭлементовФормы();
	
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда
		ПредметПредставление = CRM_ОбщегоНазначенияСервер.ПолучитьПредставлениеПредметаДокумента(Объект.Предмет);
	Иначе
		Элементы.ПредметПредставление.Видимость = Ложь;
	КонецЕсли;
	
	Если ЭтоНовый И ЗначениеЗаполнено(Объект.Предмет) 
	И ((ТипЗнч(Объект.Предмет) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"))
	ИЛИ (ТипЗнч(Объект.Предмет) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее"))) Тогда
		
		МассивФайлов = РаботаСФайламиСлужебный.ВсеПодчиненныеФайлы(Объект.Предмет);
		
		Если МассивФайлов.Количество() > 0 Тогда
			СписокФайловПисьма.ЗагрузитьЗначения(МассивФайлов);
		КонецЕсли;

		// В случае поручения в описание не переносим текст писем, только тему и инфомрацию, что
		// поручение введено на основании такого-то письма.
		Объект.Описание = "Тема: " + Объект.Предмет.Тема + "
						   |Введено на основании: " + Объект.Предмет;
	КонецЕсли;

	Если Параметры.Свойство("Исполнитель") И ЗначениеЗаполнено(Параметры.Исполнитель) Тогда
		Исполнитель = Параметры.Исполнитель;
	КонецЕсли;		
	
	CRM_ПрисоединенныеФайлы.СформироватьПредставлениеВложений(ЭтотОбъект, Объект.Ссылка);
	
	Элементы.ФормаСтарт.Видимость = Не Объект.Стартован;
	
	Элементы.ЗавершитьБизнесПроцессДосрочно.Видимость = (Не ЭтоНовый И Объект.КартаМаршрута.РазрешеноДосрочноеЗавершение И (Пользователи.ЭтоПолноправныйПользователь() ИЛИ Объект.Автор = Пользователи.ТекущийПользователь()));

	Если ЭтоНовый Тогда
		Если Параметры.Свойство("Основание") Тогда
			Если ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.CRM_Интерес") Тогда
				Исполнитель = Параметры.Основание.Ответственный;
				Объект.Наименование = "";
			ИначеЕсли ТипЗнч(Параметры.Основание) = Тип("Структура") Тогда	
				Если Параметры.Основание.Свойство("Основание") Тогда
					Если ТипЗнч(Параметры.Основание.Основание) = Тип("ДокументСсылка.CRM_Интерес") Тогда
						Исполнитель = Параметры.Основание.Основание.Ответственный;
						Объект.Наименование = "";
					КонецЕсли;	
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СрокИсполнения = CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаИсполнения, ВремяИсполнения);
	СрокКонтроля = CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаКонтроля, ВремяКонтроля);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("СохраненоПоручение", Объект.Предмет);
	Если ЗначениеЗаполнено(СрокИсполнения) Тогда
		Оповестить("ОбновленыДанныеСобытия", Новый Структура("СсылкаНаОбъект, ОбновлятьКалендарь", Неопределено, Параметры.ОбновлятьКалендарь), ЭтотОбъект);
	КонецЕсли;
	Оповестить("ОбновитьНапоминания", Новый Структура("ОткрыватьАктивизироватьФормуНапоминаний", Ложь), ЭтотОбъект);
	Оповестить("ОбновитьАРМ");
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	НаборЭтапов = РегистрыСведений.CRM_НастройкиЭтаповБизнесПроцессов.СоздатьНаборЗаписей();
	НаборЭтапов.Отбор.Объект.Установить(ТекущийОбъект.Ссылка);
	НаборЭтапов.Прочитать();
	
	// Исполнители бизнес-процесса.
	НаборИсполнителей = РегистрыСведений.CRM_ИсполнителиЭтаповБизнесПроцессов.СоздатьНаборЗаписей();
	НаборИсполнителей.Отбор.Объект.Установить(ТекущийОбъект.Ссылка);
	НаборИсполнителей.Прочитать();	
	
	ТекущаяЗадача = ПолучитьТекущуюЗадачу(); 
	НоваяДатаЗадачи = Неопределено;
	Для Каждого СтрокаНабора Из НаборИсполнителей Цикл
		Если СтрокаНабора.ТочкаМаршрута = НаборЭтапов[0].ТочкаМаршрута Тогда		// точка действия "Выполнить"
			СтрокаНабора.Исполнитель = ?(ЗначениеЗаполнено(Исполнитель),Исполнитель,Перечисления.CRM_ВидыИсполнителейЗадач.НеУказан);
			НаборЭтапов[0].ДатаВыполнения = СрокИсполнения;
			НаборЭтапов[0].ВариантВыполнения = ?(КонтролироватьВыполнение,1,0);
			НаборЭтапов[0].ВариантВыполненияСтрокой = CRM_БизнесПроцессыСервер.ПолучитьПредставлениеВариантаУсловия(НаборЭтапов[0].ТочкаМаршрута, НаборЭтапов[0].ВариантВыполнения, Объект.НомерВерсииКартыМаршрута);
			Если ЗначениеЗаполнено(ТекущаяЗадача) И ТекущаяЗадача.CRM_ТочкаМаршрута = СтрокаНабора.ТочкаМаршрута Тогда
				НоваяДатаЗадачи = СрокИсполнения;
			КонецЕсли;
		ИначеЕсли СтрокаНабора.ТочкаМаршрута = НаборЭтапов[1].ТочкаМаршрута Тогда	// точка действия "Проверить"
			НаборЭтапов[1].ДатаВыполнения = СрокКонтроля;
			НаборЭтапов[1].Используется	= КонтролироватьВыполнение;
			СтрокаНабора.Исполнитель = ?(ЗначениеЗаполнено(Контролер),Контролер,Перечисления.CRM_ВидыИсполнителейЗадач.НеУказан);
			Если ЗначениеЗаполнено(ТекущаяЗадача) И ТекущаяЗадача.CRM_ТочкаМаршрута = СтрокаНабора.ТочкаМаршрута Тогда
				НоваяДатаЗадачи = СрокКонтроля;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекущаяЗадача) И ЗначениеЗаполнено(НоваяДатаЗадачи) И ТекущаяЗадача.СрокИсполнения <>НоваяДатаЗадачи Тогда
		ЗадачаОбъект = ТекущаяЗадача.ПолучитьОбъект();
		ЗадачаОбъект.СрокИсполнения = НоваяДатаЗадачи;
		ЗадачаОбъект.Записать();
	КонецЕсли;
	НаборЭтапов.Записать();
	НаборИсполнителей.Записать();
	
	Если ЭтоНовый Тогда
		ПеренестиПрисоединенныеФайлы(ТекущийОбъект.Ссылка);
	КонецЕсли;
	
	ЭтоНовый = Ложь;
	
	CRM_БизнесПроцессыИЗадачиСервер.ЗаписатьГрупповыеПредметы(ЭтотОбъект, ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередСтартом(Отказ)
	
	Если Объект.Ссылка.Пустая() ИЛИ Модифицированность Тогда
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если НЕ ПрошлаПроверка Тогда
		ПрошлаПроверка = Истина;
		Отказ = Истина;
		Закрыть(Объект.Ссылка);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ КонтролироватьВыполнение Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Контролер"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СрокКонтроля"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если СписокФайловПисьма.Количество() > 0 Тогда
		НовоеОповещение = Новый ОписаниеОповещения("ВыборФайловДляКопирования", ЭтотОбъект);
		ПараметрыФормы = Новый Структура ("СписокФайлов", СписокФайловПисьма);
		ОткрытьФорму("ОбщаяФорма.CRM_ФормаВыбораФайловДляКопирования", ПараметрыФормы,,,,,НовоеОповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);		
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеСпискаПрисоединенныхФайлов" И Объект.БизнесПроцесс = Параметр Тогда
		СформироватьПредставлениеВложений();
	ИначеЕсли ИмяСобытия = "Запись_Файл" И (ТипЗнч(Источник) = Тип("СправочникСсылка.CRM_БизнесПроцессПрисоединенныеФайлы")
		ИЛИ ТипЗнч(Источник) = Тип("Массив") И Источник.Количество()>0 И ТипЗнч(Источник[0]) = Тип("СправочникСсылка.CRM_БизнесПроцессПрисоединенныеФайлы")) Тогда
		СформироватьПредставлениеВложений();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ПриИзмененииПроектаНаСервере()
	Если ЗначениеЗаполнено(Объект.Проект) И ЗначениеЗаполнено(Объект.Проект.CRM_Партнер) Тогда
		Объект.Партнер = Объект.Проект.CRM_Партнер;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьВыполнениеПриИзменении(Элемент)
	
	Элементы.Контролер.Доступность					= КонтролироватьВыполнение;
	Элементы.СрокКонтроля.Доступность				= КонтролироватьВыполнение;
	Элементы.Контролер.АвтоОтметкаНезаполненного	= КонтролироватьВыполнение;
	Элементы.СрокКонтроля.АвтоОтметкаНезаполненного	= КонтролироватьВыполнение;
	Элементы.ВремяКонтроля.Доступность				= КонтролироватьВыполнение;
	Элементы.ВремяКонтроля.АвтоОтметкаНезаполненного= КонтролироватьВыполнение;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Объект.Предмет) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
		ОткрытьФорму("Документ.ЭлектронноеПисьмоИсходящее.Форма.CRM_ФормаДокумента", 
			Новый Структура("Ключ, ОткрытиеИзФормы", Объект.Предмет, Истина),ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.Независимый);
		
	ИначеЕсли ТипЗнч(Объект.Предмет) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда		
		ОткрытьФорму("Документ.ЭлектронноеПисьмоВходящее.Форма.CRM_ФормаДокумента", 
			Новый Структура("Ключ, ОткрытиеИзФормы", Объект.Предмет, Истина),ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.Независимый);		
	Иначе			
		ПоказатьЗначение(, Объект.Предмет);			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДатаВремяНачалаПриИзменении(Элемент)
	СкорректироватьДатыЗадачи(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДатаВремяОкончанияПриИзменении(Элемент)
	СкорректироватьДатыЗадачи(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВремяИсполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВремяИсполненияНачалоВыбораЗавершение", ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, ВремяИсполнения, Элемент,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяКонтроляНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВремяКонтроляНачалоВыбораЗавершение", ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, ВремяКонтроля, Элемент,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСвязатьСНажатие(Элемент)
	Элементы.ГруппаСвязатьСРеквизиты.Видимость = Истина;
	Элементы.ДекорацияСвязатьС.Видимость = Ложь;
	
	УстановитьСвойстваЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура CRM_ПроектПриИзменении(Элемент)
	ПриИзмененииПроектаНаСервере();
	УстановитьСвойстваЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Партнер) Тогда
		Объект.КонтактноеЛицо = ВернутьОсновноеКонтактноеЛицо(Объект.Партнер);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Ссылка.Пустая() Тогда
		ТекстПредупреждения = Нстр("ru='Бизнес-процесс не записан. Добавление файлов невозможно!';en='The business process is not recorded. Adding files is impossible!'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;		
	
	ПараметрыФормы = Новый Структура("ВладелецФайла", Объект.Ссылка);
	ПараметрыФормы.Вставить("ТолькоВложения",	Истина);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтотОбъект.ТолькоПросмотр);	
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы",
	             ПараметрыФормы,
	             ЭтотОбъект,
	             Ложь,
	             Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перенаправить(Команда)
	
	Если Объект.Ссылка.Пустая() ИЛИ Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	МассивЗадач = Новый Массив;
	МассивЗадач.Добавить(Объект.Ссылка);
	CRM_БизнесПроцессыИЗадачиКлиент.ОбработкаКомандыПеренаправить(МассивЗадач, Новый Структура("Источник",ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьБизнесПроцессДосрочно(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьБизнесПроцессДосрочноЗавершение", ЭтотОбъект);
	ОткрытьФорму("БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаДосрочногоЗавершения",,ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьТочкиСтарта()
		
	СписокТочекСтарта = CRM_БизнесПроцессыЭкспортныеМетоды.ПолучитьВариантыСтарта(Объект.КартаМаршрута);
	Объект.ТочкаСтарта = СписокТочекСтарта[0].Значение;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()
	
	ТолькоПросмотр = ?(Объект.Стартован, НЕ Объект.Автор = ПараметрыСеанса.ТекущийПользователь, Ложь);
	Элементы.Контролер.Доступность					= КонтролироватьВыполнение;
	Элементы.СрокКонтроля.Доступность				= КонтролироватьВыполнение;
	Элементы.Контролер.АвтоОтметкаНезаполненного	= КонтролироватьВыполнение;
	Элементы.СрокКонтроля.АвтоОтметкаНезаполненного	= КонтролироватьВыполнение;
	
	ДатаВремя = CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(СрокИсполнения);
	ДатаИсполнения	= ДатаВремя.Дата;
	ВремяИсполнения	= ДатаВремя.Время;
	
	ДатаВремя = CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(СрокКонтроля);
	ДатаКонтроля	= ДатаВремя.Дата;
	ВремяКонтроля	= ДатаВремя.Время;
	
	ИспользоватьДатуИВремяВСрокахЗадач = Константы.ИспользоватьДатуИВремяВСрокахЗадач.Получить();
	
	Элементы.ВремяИсполнения.Видимость	= ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ВремяКонтроля.Видимость	= ИспользоватьДатуИВремяВСрокахЗадач;
	
	Если Элементы.CRM_Проект.Видимость Тогда
		Если ЗначениеЗаполнено(Объект.Проект) И Объект.Проект.CRM_ЭтоПроект Тогда
			Элементы.CRM_Этап.Видимость = Истина;
		Иначе
			Элементы.CRM_Этап.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВернутьВремяКонцаРабочегоДня()
	
	КонецРабочегоДняЧас = Час(CRM_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеНастройки("ВремяОкончанияРабочегоДня"));
	Если КонецРабочегоДняЧас = 0 Тогда
		КонецРабочегоДняЧас = 18;
	КонецЕсли;
	
	Возврат КонецРабочегоДняЧас;
	
КонецФункции

&НаСервере
Процедура ПеренестиПрисоединенныеФайлы(ПоручениеСсылка)
	
	Если ЭтоНовый Тогда
		СписокОтбора = Новый СписокЗначений;
		Для Каждого ТекущиеДанные Из СписокФайловПисьма Цикл
			Если ТекущиеДанные.Пометка Тогда
				СписокОтбора.Добавить(ТекущиеДанные.Значение);
			КонецЕсли;
		КонецЦикла;
		Если СписокОтбора.Количество() > 0 Тогда
			CRM_ПрисоединенныеФайлы.СкопироватьПрисоединенныеФайлы(Объект.Предмет, ПоручениеСсылка, СписокОтбора);
		КонецЕсли;
	КонецЕсли;
	
	СписокФайловПисьма.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайловДляКопирования(Результат, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		СписокФайловПисьма = Результат;
	Иначе
		СписокФайловПисьма.Очистить();
	КонецЕсли;		
КонецПроцедуры

&НаСервере
Процедура СкорректироватьДатыЗадачи(ПриоритетДатыНачала)
	
	Если ДатаИсполнения > ДатаКонтроля Тогда
		Если ПриоритетДатыНачала Тогда
			ДатаКонтроля = ДатаИсполнения;
		Иначе
			ДатаИсполнения = ДатаКонтроля;
		КонецЕсли;
	КонецЕсли;
	Если НачалоДня(ДатаИсполнения) = НачалоДня(ДатаКонтроля) И ВремяИсполнения > ВремяКонтроля Тогда
		Если ПриоритетДатыНачала Тогда
			ВремяКонтроля = ВремяИсполнения;
		Иначе
			ВремяИсполнения = ВремяКонтроля;
		КонецЕсли;
	КонецЕсли;
	
	СрокИсполнения	= CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаИсполнения, ВремяИсполнения);
	СрокКонтроля	= CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаКонтроля, ВремяКонтроля);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекущуюЗадачу()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЗадачаИсполнителя.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	                      |ГДЕ
	                      |	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
	                      |	И НЕ ЗадачаИсполнителя.Выполнена");
	Запрос.УстановитьПараметр("БизнесПроцесс", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ВремяИсполненияНачалоВыбораЗавершение(ВыбранноеВремя, Дополнительно) Экспорт
	Если ВыбранноеВремя <> Неопределено Тогда
		ВремяИсполнения = ВыбранноеВремя.Значение;		
		СрокИсполнения = CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаИсполнения, ВремяИсполнения);
		СкорректироватьДатыЗадачи(Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВремяКонтроляНачалоВыбораЗавершение(ВыбранноеВремя, Дополнительно) Экспорт
	Если ВыбранноеВремя <> Неопределено Тогда
		ВремяКонтроля = ВыбранноеВремя.Значение;
		СрокКонтроля = CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаКонтроля, ВремяКонтроля);
		СкорректироватьДатыЗадачи(Ложь);		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВернутьОсновноеКонтактноеЛицо(ВыбранныйПартнер)
	
	Возврат ВыбранныйПартнер.CRM_ОсновноеКонтактноеЛицо;
	
КонецФункции

&НаСервере
Процедура СформироватьПредставлениеВложений()
	CRM_ПрисоединенныеФайлы.СформироватьПредставлениеВложений(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьБизнесПроцессДосрочноЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат = Неопределено Тогда
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("ПараметрыДосрочногоЗавершения", Результат);
		Закрыть(СтруктураДанных);
		
	КонецЕсли;
	
КонецПроцедуры

#Область ГрупповыеПредметыБизнеспроцессов

&НаСервере
Процедура СценарийПриИзмененииНаСервере()
	CRM_БизнесПроцессыИЗадачиСервер.СформироватьИЗаполнитьГрупповыхПредметы(ЭтотОбъект, Объект, Элементы.ГруппаПредметы, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	СценарийПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредметыПроцессаПодбор(Команда)

	CRM_КлассификаторыКлиент.ОткрытьПодборПоКлассификации(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредметыПроцессаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Таблица = ЭтотОбъект[Элемент.Имя];
	Для каждого Предмет из ВыбранноеЗначение Цикл
		Если Таблица.НайтиСтроки(Новый Структура("Предмет", Предмет)).Количество() = 0 Тогда
			НовыйПредмет = Таблица.Добавить();
			НовыйПредмет.Предмет = Предмет;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ТипИсполнителяПриИзмененииСервер()
	Если ТипИсполнителя = "Пользователь" Тогда
		Исполнитель = Справочники.Пользователи.ПустаяСсылка();
	ИначеЕсли ТипИсполнителя = "Роль" Тогда
		Исполнитель = Справочники.РолиИсполнителей.ПустаяСсылка();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипИсполнителяПриИзменении(Элемент)
	ТипИсполнителяПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#КонецОбласти
