#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// Программный интерфейс для подсистемы бизнес-процессов и задач.

#Область ПрограммныйИнтерфейс

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры:
//   ЗадачаСсылка                - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
// Возвращаемое значение:
//   Структура   - структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", "БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаЗадачи");
	Возврат Результат;
	
КонецФункции

// Вызывается при перенаправлении задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - перенаправляемая задача.
//   НоваяЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	
КонецПроцедуры

// Вызывается при выполнении задачи из формы списка.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   БизнесПроцессСсылка - БизнесПроцессСсылка - бизнес-процесс, по которому сформирована задача ЗадачаСсылка.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
КонецПроцедуры	

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

#КонецЕсли

#Область СлужебныеПроцедурыИФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Осуществляет расширенный поиск Бизнес-процессов.
// Параметры:
//          СписокБизнесПроцессов - таблица значений, заполняемая результатами поиска,
// Возвращаемое значение:
//          Неопределено если поиск произведен успешно.
//          Текст сообщения пользователю, если поиск неудачен.
//
Функция НайтиБизнесПроцессы(СтрокаПоиска, СписокБизнесПроцессов) Экспорт

	// настроить параметры поиска
	мОбластьПоиска = Новый Массив;
	РазмерПорции = 200;
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска,РазмерПорции);
	мОбластьПоиска.Добавить(Метаданные.БизнесПроцессы.CRM_БизнесПроцесс);
	СписокПоиска.ОбластьПоиска = мОбластьПоиска;

	СписокПоиска.ПерваяЧасть();

	// Возврат, если поиск не результативен.
	Если СписокПоиска.СлишкомМногоРезультатов() Тогда
		Возврат НСтр("ru='Слишком много результатов, уточните запрос.';en='It is too much results, specify request.'");
	КонецЕсли;

	Если СписокПоиска.ПолноеКоличество() = 0 Тогда
		Возврат НСтр("ru='Ничего не найдено';en='It is found nothing'");
	КонецЕсли;
	
	КоличествоЭлементов = СписокПоиска.ПолноеКоличество();
	
	// Сформировать список найденных партнеров.
	СписокБизнесПроцессов.Очистить();
	НачальнаяПозиция = 0;
	КонечнаяПозиция = ?(КоличествоЭлементов>РазмерПорции,РазмерПорции,КоличествоЭлементов)-1;
	ЕстьСледующаяПорция = Истина;

	// Обработать по порциям результаты ППД.
	Пока ЕстьСледующаяПорция Цикл
		Для СчетчикЭлементов = 0 По КонечнаяПозиция Цикл
			
			// Сформировать элемент результата.
			Элемент = СписокПоиска.Получить(СчетчикЭлементов);
			ЭлементСсылка = Элемент.Значение.Ссылка;
			Основание = Элемент.Метаданные.ПредставлениеОбъекта + " """ + Элемент.Представление + """ - " + Элемент.Описание;
			БизнесПроцесс = Элемент.Значение;
			
			// +CRM
			//Если НЕ Элемент.Метаданные = Метаданные.Справочники.ФизическиеЛица Тогда
				Если НЕ ДобавитьБизнесПроцессВСписокНайденныхПолнотекстовымПоиском(СписокБизнесПроцессов,БизнесПроцесс,Основание,ЭлементСсылка) Тогда
					Возврат НСтр("ru='Слишком много результатов, уточните запрос.';en='It is too much results, specify request.'");					
				КонецЕсли;
			//КонецЕсли;
			// -CRM
			
		КонецЦикла;
		НачальнаяПозиция = НачальнаяПозиция + РазмерПорции;
		ЕстьСледующаяПорция = (НачальнаяПозиция < КоличествоЭлементов - 1);
		Если ЕстьСледующаяПорция Тогда
			КонечнаяПозиция = 
			?(КоличествоЭлементов > НачальнаяПозиция + РазмерПорции, РазмерПорции,
			КоличествоЭлементов - НачальнаяПозиция) - 1;
			СписокПоиска.СледующаяЧасть();
		КонецЕсли;
	КонецЦикла;
	
	Если СписокБизнесПроцессов.Количество() = 0 Тогда
	     Возврат НСтр("ru='Ничего не найдено.';en='It is found nothing.'");		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

Функция ДобавитьБизнесПроцессВСписокНайденныхПолнотекстовымПоиском(СписокБизнесПроцессов,БизнесПроцесс,Основание,ЭлементСсылка)
	
	// Добавить элемент, если партнера еще нет в списке найденных.
	Если СписокБизнесПроцессов.Найти(БизнесПроцесс,"БизнесПроцесс") = Неопределено Тогда
		// Ограничить количество возвращаемых партнеров.
		Если СписокБизнесПроцессов.Количество() > 100 Тогда
			Возврат Ложь; 
		Иначе 
			Запись = СписокБизнесПроцессов.Добавить();
			Запись.БизнесПроцесс = БизнесПроцесс;
			Запись.Основание = Основание;
			Запись.Ссылка = ЭлементСсылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ДобавитьБизнесПроцессВСписокНайденныхПолнотекстовымПоиском()

#КонецЕсли

Функция ВернутьСсылкуНаЗадачу(Объект)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("БизнесПроцесс", Объект);
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.АвторизованныйПользователь());
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗадачаИсполнителя.Ссылка,
	|	ВЫБОР
	|		КОГДА ЗадачаИсполнителя.Выполнена
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Выполнена
	|ПОМЕСТИТЬ Задачи
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
	|	И НЕ ЗадачаИсполнителя.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсполнителиЗадач.РольИсполнителя,
	|	ИсполнителиЗадач.Исполнитель
	|ПОМЕСТИТЬ ИсполнителиРолей
	|ИЗ
	|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	|ГДЕ
	|	ИсполнителиЗадач.ОсновнойОбъектАдресации = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ОбъектыАдресацииЗадач.ПустаяСсылка)
	|	И ИсполнителиЗадач.ДополнительныйОбъектАдресации = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ОбъектыАдресацииЗадач.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Задачи.Ссылка КАК Задача,
	|	Задачи.Выполнена КАК Выполнена,
	|	ВЫБОР
	|		КОГДА НЕ Задачи.Ссылка.Исполнитель = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|			ТОГДА Задачи.Ссылка.Исполнитель
	|		КОГДА НЕ Задачи.Ссылка.РольИсполнителя = ЗНАЧЕНИЕ(Справочник.РолиИсполнителей.ПустаяСсылка)
	|			ТОГДА ИсполнителиРолей.Исполнитель
	|	КОНЕЦ = &ТекущийПользователь КАК ЗадачаПользователя
	|ИЗ
	|	Задачи КАК Задачи
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсполнителиРолей КАК ИсполнителиРолей
	|		ПО Задачи.Ссылка.РольИсполнителя = ИсполнителиРолей.РольИсполнителя
	|
	|УПОРЯДОЧИТЬ ПО
	|	Выполнена,
	|	ЗадачаПользователя";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Задача;
	КонецЕсли;
	
КонецФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Ключ") Тогда
		Если Параметры.Ключ.КартаМаршрута.ТипПроцесса = Перечисления.bpmТипыПроцессов.ПроцессОбъекта 
		И ЗначениеЗаполнено(Параметры.Ключ.Интерес)
		И (ТипЗнч(Параметры.Ключ.Интерес) = Тип("ДокументСсылка.CRM_Интерес")) Тогда
			СтандартнаяОбработка = Ложь;
			Параметры.Ключ = Параметры.Ключ.Интерес;
			ВыбраннаяФорма = "Документ.CRM_Интерес.ФормаОбъекта";
		ИначеЕсли Параметры.Ключ.КартаМаршрута.ТипПроцесса = Перечисления.bpmТипыПроцессов.ПроцессОбъекта 
		И ЗначениеЗаполнено(Параметры.Ключ.Интерес) Тогда
			СтандартнаяОбработка = Ложь;
			Параметры.Ключ = Параметры.Ключ.Интерес;
			ИсточникНов = CRM_ОбщегоНазначенияСервер.МенеджерОбъектаПоСсылке(Параметры.Ключ);
			Если Метаданные.Документы.Содержит(Параметры.Ключ.Метаданные()) Тогда
				CRM_МетодыМодулейМенеджеровДокументов.ОбработкаПолученияФормОбъектовCRM(ИсточникНов, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
			Иначе
				CRM_МетодыМодулейМенеджеровСправочников.ОбработкаПолученияФормОбъектовCRM(ИсточникНов, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
			КонецЕсли;
		ИначеЕсли Параметры.Ключ.КартаМаршрута.ТипПроцесса = Перечисления.bpmТипыПроцессов.НезависимыйПроцесс Тогда
			Если Параметры.Ключ.Стартован Тогда
				СтандартнаяОбработка = Ложь;
				Параметры.Ключ = ВернутьСсылкуНаЗадачу(Параметры.Ключ);
				ВыбраннаяФорма = "БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаЗадачиНезависимыйПроцесс";
			Иначе
				СтандартнаяОбработка = Ложь;
				ВыбраннаяФорма = "БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаСтартаНезависимого";
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("Основание") Тогда
		Если ТипЗнч(Параметры.Основание) = Тип("СправочникСсылка.CRM_КартыМаршрутов")
		И Параметры.Основание = Справочники.CRM_КартыМаршрутов.Поручение Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаПоручения";
		ИначеЕсли ТипЗнч(Параметры.Основание) = Тип("СправочникСсылка.Проекты")
		И Параметры.Основание.CRM_КартаМаршрута = Справочники.CRM_КартыМаршрутов.Поручение Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаПоручения";
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") И Параметры.ЗначенияЗаполнения.Свойство("КартаМаршрута") Тогда
		Если Параметры.ЗначенияЗаполнения.КартаМаршрута = Справочники.CRM_КартыМаршрутов.Поручение Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаПоручения";
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") Тогда
		Если Параметры.ЗначениеКопирования.КартаМаршрута = Справочники.CRM_КартыМаршрутов.Поручение Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаПоручения";
		ИначеЕсли Параметры.ЗначениеКопирования.КартаМаршрута.ТипПроцесса = Перечисления.bpmТипыПроцессов.НезависимыйПроцесс Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаСтартаНезависимого";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Результат = Новый Массив;
	Если ЗначениеЗаполнено(Ссылка.КонтактноеЛицо) Тогда
		Результат.Добавить(Ссылка.КонтактноеЛицо);
	ИначеЕсли ЗначениеЗаполнено(Ссылка.Партнер) Тогда
		Результат.Добавить(Ссылка.Партнер);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

#КонецОбласти

