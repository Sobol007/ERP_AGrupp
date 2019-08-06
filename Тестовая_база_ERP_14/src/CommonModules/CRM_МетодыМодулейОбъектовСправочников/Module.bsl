
#Область СлужебныеПроцедурыИФункции

#Область ПриЗаписи

Процедура ПриЗаписи(Источник, Отказ) Экспорт

	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	#Область Пользователи

	Если НЕ Отказ Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		                      |	НастройкиПользователей.Пользователь КАК Пользователь
		                      |ИЗ
		                      |	РегистрСведений.CRM_НастройкиПользователей КАК НастройкиПользователей
		                      |ГДЕ
		                      |	НастройкиПользователей.Пользователь = &Пользователь");
		Запрос.УстановитьПараметр("Пользователь", Источник.Ссылка);
		Если Запрос.Выполнить().Пустой() Тогда
			// Создание настроек пользователя по умолчанию при первой записи.
			CRM_ПользователиПереопределяемый.CRM_ЗаполнитьНастройкиПользователяПоУмолчанию(Источник.Ссылка);
		КонецЕсли;
	КонецЕсли;

	#КонецОбласти // Пользователи

КонецПроцедуры

#КонецОбласти

#Область Справочник_Партнеры

// Осуществляет расширенный поиск партнеров.
//
// Параметры:
//  СписокПартнеров - таблица значений, заполняемая результатами поиска,
//
// Возвращаемое значение:
//   Неопределено если поиск произведен успешно.
//   Текст сообщения пользователю, если поиск неудачен.
//
Функция НайтиПартнеров(СтрокаПоиска, СписокПартнеров) Экспорт

	// настроить параметры поиска
	мОбластьПоиска = Новый Массив;
	мОбластьПоиска.Добавить(Метаданные.Справочники.Партнеры);
	мОбластьПоиска.Добавить(Метаданные.Справочники.КонтактныеЛицаПартнеров);
	мОбластьПоиска.Добавить(Метаданные.РегистрыСведений.сфпНомераТелефоновДляПоиска);
	РазмерПорции = 200;
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	СписокПоиска.ОбластьПоиска = мОбластьПоиска;
	
	Попытка
		СписокПоиска.ПерваяЧасть();
	Исключение
		ИО = ИнформацияОбОшибке();
		Если Прав(СтрокаПоиска, 1) = "*" Тогда
			СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок("""" + Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска) - 1) + """", РазмерПорции);
			СписокПоиска.ОбластьПоиска = мОбластьПоиска;
			СписокПоиска.ПерваяЧасть();
		Иначе
			ВызватьИсключение ПодробноеПредставлениеОшибки(ИО);
		КонецЕсли;
	КонецПопытки;
	
	// Возврат, если поиск не результативен.
	Если СписокПоиска.СлишкомМногоРезультатов() Тогда
		Возврат НСтр("ru='Слишком много результатов, уточните запрос.';en='It is too much results, specify request.'");
	ИначеЕсли СписокПоиска.ПолноеКоличество() = 0 Тогда
		Возврат НСтр("ru='Ничего не найдено';en='It is found nothing'");
	КонецЕсли;
	КоличествоЭлементов = СписокПоиска.ПолноеКоличество();
	
	// Сформировать список найденных партнеров.
	СписокПартнеров.Очистить();
	НачальнаяПозиция = 0;
	КонечнаяПозиция = ?(КоличествоЭлементов>РазмерПорции,РазмерПорции,КоличествоЭлементов)-1;
	ЕстьСледующаяПорция = Истина;
	
	КИПредставлениеСиноним		= Метаданные.Справочники.Партнеры.ТабличныеЧасти.КонтактнаяИнформация.Реквизиты.Представление.Синоним;
	КИЗначенияПолейСиноним		= Метаданные.Справочники.Партнеры.ТабличныеЧасти.КонтактнаяИнформация.Реквизиты.ЗначенияПолей.Синоним;
	СтрокаПоискаВРег			= ВРег(СтрокаПоиска);
	
	// Обработать по порциям результаты ППД.
	Пока ЕстьСледующаяПорция Цикл
		Для СчетчикЭлементов = 0 По КонечнаяПозиция Цикл
			// Сформировать элемент результата.
			Элемент = СписокПоиска.Получить(СчетчикЭлементов);
			Если ТипЗнч(Элемент.Значение) = Тип("РегистрСведенийКлючЗаписи.сфпНомераТелефоновДляПоиска") Тогда
				Если ТипЗнч(Элемент.Значение.Объект) = Тип("СправочникСсылка.Партнеры") Или ТипЗнч(Элемент.Значение.Объект) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
					ЭлементСсылка = Элемент.Значение.Объект;
				Иначе
					Продолжить;
				КонецЕсли;
			Иначе
				ЭлементСсылка = Элемент.Значение.Ссылка;
			КонецЕсли;
			
			Если КоличествоЭлементов < 20 Тогда // Ограничение - если количество найденных много не будем усложнять описание.
				Если	Лев(Элемент.Описание, СтрДлина(КИПредставлениеСиноним)) = КИПредставлениеСиноним
					Или	Лев(Элемент.Описание, СтрДлина(КИЗначенияПолейСиноним)) = КИЗначенияПолейСиноним Тогда
					// Считаем, что нашли в контактной информации.
					бНайдено = Ложь;
					
					// Обход контактной информации вручную - попытка определить, где нашли.
					Для Каждого СтрокаТаблицы Из ЭлементСсылка.КонтактнаяИнформация Цикл
						Если	Найти(ВРег(СтрокаТаблицы.Представление),		СтрокаПоискаВРег) > 0
							Или	Найти(ВРег(СтрокаТаблицы.ЗначенияПолей),		СтрокаПоискаВРег) > 0
							Или	Найти(ВРег(СтрокаТаблицы.Страна),				СтрокаПоискаВРег) > 0
							Или	Найти(ВРег(СтрокаТаблицы.Регион),				СтрокаПоискаВРег) > 0
							Или	Найти(ВРег(СтрокаТаблицы.Город),				СтрокаПоискаВРег) > 0
							Или	Найти(ВРег(СтрокаТаблицы.АдресЭП),				СтрокаПоискаВРег) > 0
							Или	Найти(ВРег(СтрокаТаблицы.ДоменноеИмяСервера),	СтрокаПоискаВРег) > 0 Тогда
							//
							бНайдено = Истина;
							ЭлементОписание = СокрЛП(СтрокаТаблицы.Вид) + ": " + СтрокаТаблицы.Представление;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					
					Если Не бНайдено Тогда
						ЭлементОписание = Элемент.Описание;
					КонецЕсли;
				Иначе
					ЭлементОписание = Элемент.Описание;
				КонецЕсли;
			Иначе
				ЭлементОписание = Элемент.Описание;
			КонецЕсли;
			
			Попытка
				СтрПредставлениеОбъекта = Элемент.Метаданные.ПредставлениеОбъекта + " """;
				Основание = СтрПредставлениеОбъекта + Элемент.Представление + """ - " + ЭлементОписание;
			Исключение
				Если ТипЗнч(ЭлементСсылка) = Тип("СправочникСсылка.Партнеры") Тогда
					СтрПредставлениеОбъекта = НСтр("ru='Клиент';en='Customer'") + " """ + Строка(ЭлементСсылка) + """";
				ИначеЕсли ТипЗнч(ЭлементСсылка) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
					СтрПредставлениеОбъекта = НСтр("ru='Контактное лицо';en='Contact person'") + " """ + Строка(ЭлементСсылка) + """";
				Иначе
					СтрПредставлениеОбъекта = "";
				КонецЕсли;
				Если ТипЗнч(Элемент.Значение) = Тип("РегистрСведенийКлючЗаписи.сфпНомераТелефоновДляПоиска") Тогда
					НомерТелефона = ПолучитьНомерТелефонаПоЭлементуПоиска(Элемент.Значение.Объект, Элемент.Значение.Вид, Элемент.Значение.ПорядковыйНомер);
					Основание = "" + СтрПредставлениеОбъекта + "- " + "Номер Телефона: " + НомерТелефона ;
				Иначе
					Основание = ?(Не ЗначениеЗаполнено(СтрПредставлениеОбъекта), """" + Элемент.Представление + """", СтрПредставлениеОбъекта)
					+ " - " + ЭлементОписание;					
				КонецЕсли;					
				//
			КонецПопытки;
			
			Если ТипЗнч(ЭлементСсылка) = Тип("СправочникСсылка.Партнеры") Тогда
				Партнер = ЭлементСсылка;
			ИначеЕсли ТипЗнч(ЭлементСсылка) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
				Партнер = ЭлементСсылка.Владелец;
			Иначе
				Продолжить;
			КонецЕсли;
			Если НЕ ДобавитьПартнераВСписокНайденныхПолнотекстовымПоиском(СписокПартнеров,Партнер,Основание,ЭлементСсылка) Тогда
				Возврат НСтр("ru='Слишком много результатов, уточните запрос.';en='It is too much results, specify request.'");					
			КонецЕсли;
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
	Если СписокПартнеров.Количество() = 0 Тогда
	     Возврат НСтр("ru='Ничего не найдено.';en='It is found nothing.'");		
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

Функция ДобавитьПартнераВСписокНайденныхПолнотекстовымПоиском(СписокПартнеров,Партнер,Основание,ЭлементСсылка)
	
	// Добавить элемент, если партнера еще нет в списке найденных.
	Если СписокПартнеров.Найти(Партнер,"Партнер") = Неопределено Тогда
		// Ограничить количество возвращаемых партнеров.
		Если СписокПартнеров.Количество() > 100 Тогда
			Возврат Ложь; 
		Иначе 
			Запись = СписокПартнеров.Добавить();
			Запись.Партнер = Партнер;
			Запись.Основание = Основание;
			Запись.Ссылка = ЭлементСсылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ДобавитьПартнераВСписокНайденныхПолнотекстовымПоиском()

// Функция возвращает представление телефона для найденного элемента полнотекстового поиска.
//
//  Параметры:
//   Объект - СправочникСсылка - Ссылка на найденный элемент.
//   Вид	- Вид контактной информации - Ссылка на вид КИ.
//   Порядковый номер - Число - Порядковый номер КИ (нужен для однозначного сопоставления).
//
//  Возвращаемое значение:
//   СтрокаПредставления - Строка - Представление найденного номера телефона.
//
Функция ПолучитьНомерТелефонаПоЭлементуПоиска(Объект, Вид, ПорядковыйНомер)
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	|	сфпНомераТелефоновДляПоиска.НомерТелефона,
	|	сфпНомераТелефоновДляПоиска.Представление
	|ИЗ
	|	РегистрСведений.сфпНомераТелефоновДляПоиска КАК сфпНомераТелефоновДляПоиска
	|ГДЕ
	|	сфпНомераТелефоновДляПоиска.Объект = &Объект
	|	И сфпНомераТелефоновДляПоиска.Вид = &Вид
	|	И сфпНомераТелефоновДляПоиска.ПорядковыйНомер = &ПорядковыйНомер";
	
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("Вид", Вид);
	запрос.УстановитьПараметр("ПорядковыйНомер", ПорядковыйНомер);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Представление;
	Иначе
		Возврат "";
	КонецЕсли;		
	
КонецФункции	

Процедура CRM_ПередЗаписьюЛида(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Источник.Ответственный) И ЗначениеЗаполнено(Источник.CRM_РольОтветственного) Тогда
		Источник.CRM_РольОтветственного = Справочники.РолиИсполнителей.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура CRM_ПриЗаписиЛида(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Удалим признак лида при пометке удаления
	Если Источник.ПометкаУдаления Тогда
		РегистрыСведений.CRM_СостоянияЛидов.УдалитьСостояниеЛида(Источник.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура CRM_ПриЗаписиПользователяДляiCRMПриЗаписи(Источник, Отказ) Экспорт
	
	// не вполнять проверку!
	//Если Источник.ОбменДанными.Загрузка Тогда
	//	Возврат;
	//КонецЕсли;
	
	Если Источник.Недействителен Тогда
		НаборЗаписей = РегистрыСведений.CRM_СостояниеПользователейСинхронизации.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Пользователь.Установить(Источник.Ссылка);
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() > 0 Тогда
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.Состояние = Перечисления.CRM_СостоянияСинхронизацииПользователя.Блокирован;
			КонецЦикла;	
			НаборЗаписей.Записать(Истина);
			Попытка
				CRM_ЛицензированиеСервер.ПолучитьЗащищеннуюОбработку().СоздатьНастройкиСинхронизации();
			Исключение
			КонецПопытки;
		КонецЕсли;	
		
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти  //Справочник_Партнеры

#КонецОбласти