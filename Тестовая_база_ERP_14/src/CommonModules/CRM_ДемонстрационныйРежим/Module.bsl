
////////////////////////////////////////////////////////////////////////////////
// CRM демонстрационный режим
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

//////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ В ДЕМОНСТРАЦИОННОМ РЕЖИМЕ

// Процедура проверяет и обновляет демонстрационные данные в демо-режиме
Функция ЭтоДемоРежим() Экспорт
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Константы.CRM_ДемонстрационныйРежим.Получить();
КонецФункции

// Процедура проверяет и обновляет демонстрационные данные в демо-режиме
//
Процедура ПроверкаОбновлениеДемоДанные() Экспорт
	Если Константы.CRM_ДемонстрационныйРежим.Получить() Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
			
			Константы.CRM_ДемонстрационныйРежим.Установить(Ложь);
			
			Возврат;			
		
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВложенныйЗапрос.Дата КАК Дата,
		|	ВложенныйЗапрос.Ссылка
		|ИЗ
		|	(ВЫБРАТЬ
		|		CRM_Взаимодействие.Дата КАК Дата,
		|		CRM_Взаимодействие.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.CRM_Взаимодействие КАК CRM_Взаимодействие
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_ДокументРасчетовСКонтрагентом.Дата,
		|		CRM_ДокументРасчетовСКонтрагентом.Ссылка
		|	ИЗ
		|		Документ.CRM_ДокументРасчетовСКонтрагентом КАК CRM_ДокументРасчетовСКонтрагентом
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_Интерес.Дата,
		|		CRM_Интерес.Ссылка
		|	ИЗ
		|		Документ.CRM_Интерес КАК CRM_Интерес
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_ОтчетОРаботе.Дата,
		|		CRM_ОтчетОРаботе.Ссылка
		|	ИЗ
		|		Документ.CRM_ОтчетОРаботе КАК CRM_ОтчетОРаботе
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	
		|	ВЫБРАТЬ
		|		CRM_ПланированиеВоронкиПродаж.Дата,
		|		CRM_ПланированиеВоронкиПродаж.Ссылка
		|	ИЗ
		|		Документ.CRM_ПланированиеВоронкиПродаж КАК CRM_ПланированиеВоронкиПродаж
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_РассылкаЭлектронныхПисем.Дата,
		|		CRM_РассылкаЭлектронныхПисем.Ссылка
		|	ИЗ
		|		Документ.CRM_РассылкаЭлектронныхПисем КАК CRM_РассылкаЭлектронныхПисем
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		удалитьCRM_Сделка.Дата,
		|		удалитьCRM_Сделка.Ссылка
		|	ИЗ
		|		Документ.удалитьCRM_Сделка КАК удалитьCRM_Сделка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		УдалитьCRM_Событие.Дата,
		|		УдалитьCRM_Событие.Ссылка
		|	ИЗ
		|		Документ.УдалитьCRM_Событие КАК УдалитьCRM_Событие
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_УстановкаИспользуемыхПоказателей.Дата,
		|		CRM_УстановкаИспользуемыхПоказателей.Ссылка
		|	ИЗ
		|		Документ.CRM_УстановкаИспользуемыхПоказателей КАК CRM_УстановкаИспользуемыхПоказателей
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_Телемаркетинг.Дата,
		|		CRM_Телемаркетинг.Ссылка
		|	ИЗ
		|		Документ.CRM_Телемаркетинг КАК CRM_Телемаркетинг
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Анкета.Дата,
		|		Анкета.Ссылка
		|	ИЗ
		|		Документ.Анкета КАК Анкета
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		КоммерческоеПредложениеКлиенту.Дата,
		|		КоммерческоеПредложениеКлиенту.Ссылка
		|	ИЗ
		|		Документ.КоммерческоеПредложениеКлиенту КАК КоммерческоеПредложениеКлиенту
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		КорректировкаРегистров.Дата,
		|		КорректировкаРегистров.Ссылка
		|	ИЗ
		|		Документ.КорректировкаРегистров КАК КорректировкаРегистров
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		НазначениеОпросов.Дата,
		|		НазначениеОпросов.Ссылка
		|	ИЗ
		|		Документ.НазначениеОпросов КАК НазначениеОпросов
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		СообщениеSMS.Дата,
		|		СообщениеSMS.Ссылка
		|	ИЗ
		|		Документ.СообщениеSMS КАК СообщениеSMS
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТелефонныйЗвонок.Дата,
		|		ТелефонныйЗвонок.Ссылка
		|	ИЗ
		|		Документ.ТелефонныйЗвонок КАК ТелефонныйЗвонок
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЭлектронноеПисьмоВходящее.Дата,
		|		ЭлектронноеПисьмоВходящее.Ссылка
		|	ИЗ
		|		Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЭлектронноеПисьмоИсходящее.Дата,
		|		ЭлектронноеПисьмоИсходящее.Ссылка
		|	ИЗ
		|		Документ.ЭлектронноеПисьмоИсходящее КАК ЭлектронноеПисьмоИсходящее
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЗадачаИсполнителя.Дата,
		|		ЗадачаИсполнителя.Ссылка
		|	ИЗ
		|		Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя) КАК ВложенныйЗапрос
		|	
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ДатаПоследнегоОбъекта = Выборка.Дата;
		Иначе
			Возврат;
		КонецЕсли;
		//Возврат;
		ПараметрыДаты = Новый КвалификаторыДаты();
		Массив = Новый Массив;
		Массив.Добавить(Тип("Дата"));
		
		ОписаниеДата = Новый ОписаниеТипов(Массив,,,,,ПараметрыДаты);
		
		ПараметрыДаты = Новый КвалификаторыДаты(ЧастиДаты.Дата);
		Массив = Новый Массив;
		Массив.Добавить(Тип("Дата"));
		
		ОписаниеДатаВремя = Новый ОписаниеТипов(Массив,,,,,ПараметрыДаты);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВложенныйЗапрос.Ссылка КАК Ссылка
		|ИЗ
		|	(ВЫБРАТЬ
		|		CRM_Взаимодействие.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.CRM_Взаимодействие КАК CRM_Взаимодействие
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_ДокументРасчетовСКонтрагентом.Ссылка
		|	ИЗ
		|		Документ.CRM_ДокументРасчетовСКонтрагентом КАК CRM_ДокументРасчетовСКонтрагентом
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_Интерес.Ссылка
		|	ИЗ
		|		Документ.CRM_Интерес КАК CRM_Интерес
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_ЭтапКалендарногоПлана.Ссылка
		|	ИЗ
		|		Документ.CRM_ЭтапКалендарногоПлана КАК CRM_ЭтапКалендарногоПлана
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		удалитьCRM_Мероприятие.Ссылка
		|	ИЗ
		|		Документ.удалитьCRM_Мероприятие КАК удалитьCRM_Мероприятие
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_ОтчетОРаботе.Ссылка
		|	ИЗ
		|		Документ.CRM_ОтчетОРаботе КАК CRM_ОтчетОРаботе
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_ПланированиеВоронкиПродаж.Ссылка
		|	ИЗ
		|		Документ.CRM_ПланированиеВоронкиПродаж КАК CRM_ПланированиеВоронкиПродаж
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_РассылкаЭлектронныхПисем.Ссылка
		|	ИЗ
		|		Документ.CRM_РассылкаЭлектронныхПисем КАК CRM_РассылкаЭлектронныхПисем
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		удалитьCRM_Сделка.Ссылка
		|	ИЗ
		|		Документ.удалитьCRM_Сделка КАК удалитьCRM_Сделка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		УдалитьCRM_Событие.Ссылка
		|	ИЗ
		|		Документ.УдалитьCRM_Событие КАК УдалитьCRM_Событие
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_УстановкаИспользуемыхПоказателей.Ссылка
		|	ИЗ
		|		Документ.CRM_УстановкаИспользуемыхПоказателей КАК CRM_УстановкаИспользуемыхПоказателей
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_Телемаркетинг.Ссылка
		|	ИЗ
		|		Документ.CRM_Телемаркетинг КАК CRM_Телемаркетинг
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Анкета.Ссылка
		|	ИЗ
		|		Документ.Анкета КАК Анкета
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		КоммерческоеПредложениеКлиенту.Ссылка
		|	ИЗ
		|		Документ.КоммерческоеПредложениеКлиенту КАК КоммерческоеПредложениеКлиенту
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		КорректировкаРегистров.Ссылка
		|	ИЗ
		|		Документ.КорректировкаРегистров КАК КорректировкаРегистров
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		НазначениеОпросов.Ссылка
		|	ИЗ
		|		Документ.НазначениеОпросов КАК НазначениеОпросов
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		СообщениеSMS.Ссылка
		|	ИЗ
		|		Документ.СообщениеSMS КАК СообщениеSMS
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТелефонныйЗвонок.Ссылка
		|	ИЗ
		|		Документ.ТелефонныйЗвонок КАК ТелефонныйЗвонок
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЭлектронноеПисьмоВходящее.Ссылка
		|	ИЗ
		|		Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЭлектронноеПисьмоИсходящее.Ссылка
		|	ИЗ
		|		Документ.ЭлектронноеПисьмоИсходящее КАК ЭлектронноеПисьмоИсходящее
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЗадачаИсполнителя.Ссылка
		|	ИЗ
		|		Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		CRM_БизнесПроцесс.Ссылка
		|	ИЗ
		|		БизнесПроцесс.CRM_БизнесПроцесс КАК CRM_БизнесПроцесс
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Задание.Ссылка
		|	ИЗ
		|		БизнесПроцесс.Задание КАК Задание
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		МаркетинговыеМероприятия.Ссылка
		|	ИЗ
		|		Справочник.МаркетинговыеМероприятия КАК МаркетинговыеМероприятия
		|
		|) КАК ВложенныйЗапрос";
		
		Выборка = Запрос.Выполнить().Выбрать();
		РазностьДат = КонецМесяца(ТекущаяДатаСеанса()) - НачалоДня(ДатаПоследнегоОбъекта);
		Пока Выборка.Следующий() Цикл
			Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.CRM_УстановкаИспользуемыхПоказателей") Тогда
				Об = Выборка.Ссылка.Скопировать();
			Иначе	
				Об = Выборка.Ссылка.ПолучитьОбъект();
			КонецЕсли;
			Для Каждого Реквизит Из Об.Метаданные().Реквизиты Цикл
				Если ТипЗнч(Об) = Тип("ДокументОбъект.CRM_УстановкаИспользуемыхПоказателей") И Найти(Реквизит.Имя, "ПериодаПланирования") > 0 Тогда
					Продолжить;
				КонецЕсли;	
				Если Реквизит.Тип = ОписаниеДата ИЛИ Реквизит.Тип = ОписаниеДатаВремя Тогда
					Значение = Об[Реквизит.Имя];
					Если Значение = '00010101' Тогда
						Продолжить;
					КонецЕсли;
					Дата = Об[Реквизит.Имя];
					ДатаНов = Дата + РазностьДат;
					//ДатаНов = Дата(2017, 3, День(Дата), Час(Дата), Минута(Дата), Секунда(Дата));
					Об[Реквизит.Имя] = ДатаНов;
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого Реквизит Из Об.Метаданные().СтандартныеРеквизиты Цикл
				Если Реквизит.Тип = ОписаниеДата ИЛИ Реквизит.Тип = ОписаниеДатаВремя Тогда
					Значение = Об[Реквизит.Имя];
					Если Значение = '00010101' Тогда
						Продолжить;
					КонецЕсли;
					Дата = Об[Реквизит.Имя];
					ДатаНов = Дата + РазностьДат;
					//ДатаНов = Дата(2017, 3, День(Дата), Час(Дата), Минута(Дата), Секунда(Дата));
					Об[Реквизит.Имя] = ДатаНов;
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого ТабЧасть Из Об.Метаданные().ТабличныеЧасти Цикл
				Для Каждого Реквизит Из ТабЧасть.Реквизиты Цикл
					Если Реквизит.Тип = ОписаниеДата ИЛИ Реквизит.Тип = ОписаниеДатаВремя Тогда
						Для Каждого Строка из Об[ТабЧасть.Имя] Цикл
							Значение = Строка[Реквизит.Имя];
							Если Значение = '00010101' Тогда
								Продолжить;
							КонецЕсли;
							Дата = Строка[Реквизит.Имя];
							ДатаНов = Дата + РазностьДат;
							//ДатаНов = Дата(2017, 3, День(Дата), Час(Дата), Минута(Дата), Секунда(Дата));
							Строка[Реквизит.Имя] = ДатаНов;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;
				
			КонецЦикла;
			Если ТипЗнч(Об) = Тип("ДокументОбъект.CRM_УстановкаИспользуемыхПоказателей") Тогда
				Об.Дата = НачалоМесяца(ТекущаяДатаСеанса());
				Об.НачалоПериодаПланирования = НачалоМесяца(Об.Дата);
				Об.КонецПериодаПланирования = КонецМесяца(Об.Дата);
				Об.ПредставлениеПериодаПланирования = ПредставлениеПериода(Об.НачалоПериодаПланирования, КонецДня(Об.КонецПериодаПланирования), "L = ru_RU");
			КонецЕсли;
			Попытка
				Если Найти(Строка(ТипЗнч(Об)), "Документ объект") = 0 Тогда
					Если ТипЗнч(Об) = Тип("ЗадачаОбъект.ЗадачаИсполнителя") Тогда
						Об.ОбменДанными.Загрузка = Истина;
					КонецЕсли;
					Об.Записать();
				Иначе
					Об.Записать(РежимЗаписиДокумента.Проведение);
				КонецЕсли;	
			Исключение	
				Об.ОбменДанными.Загрузка = Истина;
				Если Найти(Строка(ТипЗнч(Об)), "Документ объект") = 0 Тогда
					Об.Записать(); 
				Иначе
					Об.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;	
			КонецПопытки;
		КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
		НаборЗаписей.Прочитать();
		Для Каждого тЗапись Из НаборЗаписей Цикл
			Значение = тЗапись.ВремяСобытия;
			Если Значение <> '00010101' Тогда
				тЗапись.ВремяСобытия = тЗапись.ВремяСобытия + РазностьДат;
			КонецЕсли;
			Значение = тЗапись.СрокНапоминания;
			Если Значение <> '00010101' Тогда
				тЗапись.СрокНапоминания = тЗапись.ВремяСобытия + РазностьДат;
			КонецЕсли;
		КонецЦикла;
		ВыборкаВзаимодействий = Документы.CRM_Взаимодействие.Выбрать();
		Пока ВыборкаВзаимодействий.Следующий() Цикл
			Если ВыборкаВзаимодействий.ПометкаУдаления Тогда Продолжить конецЕсли;
			Об = ВыборкаВзаимодействий.ПолучитьОбъект();
			Об.Записать();
		КонецЦикла;	
		Константы.CRM_ДемонстрационныйРежим.Установить(Ложь);
	КонецЕсли;
КонецПроцедуры

// Возвращает признак разделенной информационной базы.
// Устанавливается вручную.
Функция CRM_РазделениеВключено() Экспорт
	Возврат ОбщегоНазначения.РазделениеВключено();
КонецФункции

#КонецОбласти

