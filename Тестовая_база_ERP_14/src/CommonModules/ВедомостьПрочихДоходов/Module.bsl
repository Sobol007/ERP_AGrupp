#Область СлужебныеПроцедурыИФункции

Функция МожноЗаполнитьВыплаты(Ведомость) Экспорт
	
	ПравилаПроверки = Новый Структура;
	
	ПравилаПроверки.Вставить("Организация",			НСтр("ru = 'Не выбрана организация';
															|en = 'Company is not selected'"));
	ПравилаПроверки.Вставить("ПериодРегистрации",	НСтр("ru = 'Не задан период регистрации';
															|en = 'Registration period not set'"));
	ПравилаПроверки.Вставить("Дата",				НСтр("ru = 'Не задана дата документа';
														|en = 'Document date must be defined'"));
	ПравилаПроверки.Вставить("СпособВыплаты",		НСтр("ru = 'Не указан способ выплаты';
															|en = 'Payment method is not specified'"));
	
	Если ПолучитьФункциональнуюОпцию("ПроверятьЗаполнениеФинансированияВВедомостях") Тогда
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Ведомость.Метаданные().Реквизиты.СтатьяФинансирования) Тогда
			ПравилаПроверки.Вставить("СтатьяФинансирования", НСтр("ru = 'Не указана статья финансирования';
																	|en = 'Financing item is not specified'"));
		КонецЕсли;
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Ведомость.Метаданные().Реквизиты.СтатьяРасходов) Тогда
			ПравилаПроверки.Вставить("СтатьяРасходов",       НСтр("ru = 'Не указана статья расходов';
																	|en = 'Expense item is not specified'"));
		КонецЕсли;
	КонецЕсли;	
	
	МожноЗаполнить = ЗарплатаКадрыКлиентСервер.СвойстваЗаполнены(Ведомость, ПравилаПроверки, Истина);

	Возврат МожноЗаполнить;

КонецФункции

Процедура ЗаполнитьВыплаты(Ведомость) Экспорт
	
	Запрос = ЗапросОстатковВыплат(Ведомость);
	
	// удалим отбор по физическим лицам
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"И Взаиморасчеты.ФизическоеЛицо В(&ФизическиеЛица)","");
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"И ФизическоеЛицо В (&ФизическиеЛица)","");
	
	Ведомость.ЗаполнитьПоТаблицеВыплат(Запрос.Выполнить().Выгрузить());
		
КонецПроцедуры

Процедура ДополнитьВыплаты(Ведомость, ФизическиеЛица) Экспорт
	
	Запрос = ЗапросОстатковВыплат(Ведомость);
	Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
	
	ТаблицаВыплат = Запрос.Выполнить().Выгрузить();
	ФизическиеЛицаСОстатками = ТаблицаВыплат.ВыгрузитьКолонку("ФизическоеЛицо");
	Для каждого ФизическоеЛицо Из ФизическиеЛица Цикл
		Если ФизическиеЛицаСОстатками.Найти(ФизическоеЛицо) = Неопределено Тогда
			НоваяСтрока = ТаблицаВыплат.Добавить();
			НоваяСтрока.ФизическоеЛицо = ФизическоеЛицо;
		КонецЕсли;
	КонецЦикла;
	
	Ведомость.ДополнитьПоТаблицеВыплат(ТаблицаВыплат);
		
КонецПроцедуры

Функция ЗапросОстатковВыплат(Ведомость)

	СпособВыплаты = Ведомость.СпособВыплаты;
	Основания     = Ведомость.Основания.ВыгрузитьКолонку("Документ");
	
	СпособРасчетов = ВзаиморасчетыПоПрочимДоходам.СоответствиеСпособВыплатыСпособРасчетов()[Ведомость.СпособВыплаты];
	ИмяВидаДокумента = ВзаиморасчетыПоПрочимДоходам.ИменаВидовДокументовВзаиморасчетыСКонтрагентамиАкционерами()[Ведомость.СпособВыплаты];
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаОстатков", КонецМесяца(Ведомость.ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Ведомость.Организация);
	Запрос.УстановитьПараметр("СпособРасчетов", СпособРасчетов);
	Запрос.УстановитьПараметр("ИсключаемыйРегистратор", Ведомость.Ссылка);
		 
	Запрос.Текст = ВзаиморасчетыПоПрочимДоходам.ТекстЗапросаОстаткиВзаиморасчетовСКонтрагентамиАкционерами();
	
	Если Основания.Количество() > 0 Тогда
		// указаны документы-основания, делаем отбор по ним
		Запрос.УстановитьПараметр("Основания", Основания); 
	Иначе
		// не указаны документы-основания, изменяем на отбор по виду документа
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"И ДокументОснование В (&Основания)","И ДокументОснование ССЫЛКА Документ." + ИмяВидаДокумента);
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"И Взаиморасчеты.ДокументОснование В(&Основания)","И Взаиморасчеты.ДокументОснование ССЫЛКА Документ." + ИмяВидаДокумента);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ведомость.СтатьяФинансирования) Тогда
		Запрос.УстановитьПараметр("СтатьяФинансирования", Ведомость.СтатьяФинансирования);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"И Остатки.СтатьяФинансирования = &СтатьяФинансирования", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ведомость.СтатьяРасходов) Тогда
		Запрос.УстановитьПараметр("СтатьяРасходов", Ведомость.СтатьяРасходов);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"И Остатки.СтатьяРасходов = &СтатьяРасходов", "");	
	КонецЕсли;
	
	Возврат Запрос;

КонецФункции

Процедура ЗаполнитьПоТаблицеВыплат(Ведомость, ТаблицаВыплат) Экспорт
	
	// Группируем строки таблицы зарплат
	СгруппироватьТаблицуВыплат(Ведомость, ТаблицаВыплат);
	
	// Собираем состав
	Состав = СоставПоТаблицеВыплат(Ведомость, ТаблицаВыплат);
	
	// Убираем неположительные строки
	УдаляемыеСтрокиСостава = Новый Массив;
	Для Каждого СтрокаСостава Из Состав Цикл
		Если СтрокаСостава.КВыплате <= 0 Тогда
			УдаляемыеСтрокиСостава.Добавить(СтрокаСостава);
		КонецЕсли;	
	КонецЦикла;
	Для Каждого УдаляемаяСтрокаСостава Из УдаляемыеСтрокиСостава Цикл
		Состав.Удалить(УдаляемаяСтрокаСостава);
	КонецЦикла;
	
	// Заполняем табличные части ведомости сгруппированной зарплатой 
	ОчиститьСостав(Ведомость);
	ДополнитьСостав(Ведомость, Состав);
	
КонецПроцедуры

Процедура ДополнитьПоТаблицеВыплат(Ведомость, ТаблицаВыплат) Экспорт
	
	// Группируем строки таблицы зарплат
	СгруппироватьТаблицуВыплат(Ведомость, ТаблицаВыплат);
	
	// Собираем состав
	Состав = СоставПоТаблицеВыплат(Ведомость, ТаблицаВыплат);
	
	// Дополняем табличные части ведомости сгруппированной зарплатой 
	ДополнитьСостав(Ведомость, Состав);
	
КонецПроцедуры

Процедура СгруппироватьТаблицуВыплат(Ведомость, ТаблицаВыплат)

	ТаблицаВыплат.Колонки.Добавить("ИдентификаторСтроки", Ведомость.Метаданные().ТабличныеЧасти.Состав.Реквизиты.ИдентификаторСтроки.Тип);
	ТаблицаВыплат.Индексы.Добавить("ИдентификаторСтроки");
	
	// колонки группировки - это реквизиты ТЧ Состав, кроме идентификатора строки
	КолонкиГруппировки = КолонкиГруппировкиЗарплаты(Ведомость);
	
	// структура для отбора строк зарплаты, попадающих в группу
	ПараметрыОтбораГруппы = Новый Структура(КолонкиГруппировки);
	
	// выделяем группы таблицы зарплат
	Группы = ТаблицаВыплат.Скопировать(, КолонкиГруппировки);
	Группы.Свернуть(КолонкиГруппировки);
	
	// Группируем строки
	Для Каждого Группа Из Группы Цикл
		
		ЗаполнитьЗначенияСвойств(ПараметрыОтбораГруппы, Группа); 
		ВыплатыГруппы = ТаблицаВыплат.НайтиСтроки(ПараметрыОтбораГруппы);
		
		ИдентификаторСтроки = Новый УникальныйИдентификатор;
		
		Для Каждого СтрокаВыплаты Из ВыплатыГруппы Цикл
			СтрокаВыплаты.ИдентификаторСтроки = ИдентификаторСтроки;
		КонецЦикла;	
		
	КонецЦикла;
	
КонецПроцедуры

Функция СоставПоТаблицеВыплат(Ведомость, ТаблицаВыплат)
	
	// Получаем ключевые поля группировки зарплаты
	КолонкиГруппировки = КолонкиГруппировкиЗарплаты(Ведомость);
	
	// Создаем таблицу состава - ключевые поля и поле с массивом строк таблицы зарплат
	Состав = Ведомость.Состав.ВыгрузитьКолонки(КолонкиГруппировки +", ИдентификаторСтроки");
	Состав.Колонки.Добавить("КВыплате");
	Состав.Колонки.Добавить("СписокВыплат");
	
	// структура для отбора строк зарплаты, попадающих в строку состава
	ПараметрыОтбораГруппы = Новый Структура("ИдентификаторСтроки");
	
	// выделяем группы из таблицы зарплат
	ИдентификаторыГрупп = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ТаблицаВыплат.ВыгрузитьКолонку("ИдентификаторСтроки"));
	
	// создаем строки состава, помещая в них и строки таблицы зарплат
	Для Каждого ИдентификаторСтроки Из ИдентификаторыГрупп Цикл
		
		ПараметрыОтбораГруппы.ИдентификаторСтроки = ИдентификаторСтроки; 
		ВыплатаГруппы = ТаблицаВыплат.Скопировать(ПараметрыОтбораГруппы);
		
		СтрокаСостава = Состав.Добавить();
		СтрокаСостава.ИдентификаторСтроки = ИдентификаторСтроки;
		
		ЗаполнитьЗначенияСвойств(СтрокаСостава, ВыплатаГруппы[0], КолонкиГруппировки);
		СтрокаСостава.СписокВыплат = ВыплатаГруппы;
		СтрокаСостава.КВыплате = ВыплатаГруппы.Итог("КВыплате");
		
	КонецЦикла;
	
	// Получаем НДФЛ к удержанию (перечислению)
	НДФЛ = НДФЛПоТаблицеЗарплат(Ведомость, ТаблицаВыплат);
	
	// Инициализируем колонку налога в таблице состава 		
	Состав.Колонки.Добавить("НДФЛ"); 
	Для Каждого СтрокаСостава Из Состав Цикл
		СтрокаСостава.НДФЛ = НДФЛ.СкопироватьКолонки()
	КонецЦикла;		
			
	// структура для отбора строк налога, попадающих в строку состава
	ПараметрыОтбораНДФЛ = Новый Структура("ФизическоеЛицо");
	
	// получаем список различных физлиц
	Физлица = ТаблицаВыплат.Скопировать(, "ФизическоеЛицо");
	Физлица.Свернуть("ФизическоеЛицо");
	Физлица = Физлица.ВыгрузитьКолонку("ФизическоеЛицо");
	
	// ищем строки состава для физлиц, помещая в них соответствующий налог
	Для Каждого Физлицо Из Физлица Цикл
		
		СтрокаСостава = Состав.Найти(Физлицо, "ФизическоеЛицо");
		Если СтрокаСостава = Неопределено Тогда
			Продолжить
		КонецЕсли;	
		
		ПараметрыОтбораНДФЛ.ФизическоеЛицо = Физлицо; 
		СтрокаСостава.НДФЛ = НДФЛ.Скопировать(ПараметрыОтбораНДФЛ);
		
	КонецЦикла;
	
	Возврат Состав;
	
КонецФункции

Процедура ОчиститьСостав(Ведомость)
	Ведомость.Состав.Очистить();
	Ведомость.Выплаты.Очистить();
	Ведомость.НДФЛ.Очистить();
КонецПроцедуры

Процедура ДополнитьСостав(Ведомость, Состав)
	
	Для Каждого СтрокаСостава Из Состав Цикл
		
		СтрокаТЧСостав = Ведомость.Состав.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧСостав, СтрокаСостава);

		Для Каждого СтрокаВыплаты Из СтрокаСостава.СписокВыплат Цикл
			СтрокаТЧСписокВыплат = Ведомость.Выплаты.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧСписокВыплат, СтрокаВыплаты);
			СтрокаТЧСписокВыплат.ИдентификаторСтроки = СтрокаСостава.ИдентификаторСтроки;
		КонецЦикла;
		
		Для Каждого СтрокаНДФЛ Из СтрокаСостава.НДФЛ Цикл
			СтрокаТЧНДФЛ = Ведомость.НДФЛ.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧНДФЛ, СтрокаНДФЛ);
			СтрокаТЧНДФЛ.ИдентификаторСтроки = СтрокаСостава.ИдентификаторСтроки;
		КонецЦикла;
		
	КонецЦикла
	
КонецПроцедуры

Функция КолонкиГруппировкиЗарплаты(Ведомость)
	
	// колонки группировки - это реквизиты ТЧ Состав, кроме идентификатора строки
	КолонкиГруппировки	= Новый Массив;
	Для Каждого РеквизитСостава Из Ведомость.Метаданные().ТабличныеЧасти.Состав.Реквизиты  Цикл
		КолонкиГруппировки.Добавить(РеквизитСостава.Имя);
	КонецЦикла;	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(КолонкиГруппировки, "ИдентификаторСтроки");
	
	Возврат СтрСоединить(КолонкиГруппировки, ", ")

КонецФункции

Процедура ОбработкаПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ПроверятьЗаполнениеФинансированияВВедомостях") Тогда
		
		ПоляСтатей = Новый Массив;
		ПоляСтатей.Добавить("СтатьяФинансирования");
		ПоляСтатей.Добавить("СтатьяРасходов");
		КолонкиСтатей = СтрСоединить(ПоляСтатей, ",");
		
		Для Каждого СтрокаСостава Из ДокументОбъект.Состав Цикл
			ВыплатаСтроки = ДокументОбъект.Выплаты.Выгрузить(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки), КолонкиСтатей);
			ОшибкаФинансированияСтроки = Ложь;
			Для Каждого ПолеСтатьи Из ПоляСтатей Цикл
				Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ДокументОбъект.Метаданные().Реквизиты[ПолеСтатьи]) И ЗначениеЗаполнено(ДокументОбъект[ПолеСтатьи]) Тогда
					СтатьиСтроки = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВыплатаСтроки.ВыгрузитьКолонку(ПолеСтатьи));
					Если СтатьиСтроки.Количество() > 1 Или СтатьиСтроки[0] <> ДокументОбъект[ПолеСтатьи] Тогда
						ОшибкаФинансированияСтроки = Истина;
						Прервать;
					КонецЕсли	
				КонецЕсли;	
			КонецЦикла;	
			Если ОшибкаФинансированияСтроки Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'У получателя %1 финансирование не совпадает с ведомостью';
								|en = 'Financing of the %1 recipient does not correspond to one in the paysheet'"),
							СтрокаСостава.ФизическоеЛицо);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДокументОбъект, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Состав[%1].ФизическоеЛицо", СтрокаСостава.НомерСтроки-1),, Отказ);
			КонецЕсли;	
		КонецЦикла;
		
	Иначе	
		ИсключаемыеРеквизиты = Новый Массив;
		ИсключаемыеРеквизиты.Добавить("СтатьяФинансирования");
		ИсключаемыеРеквизиты.Добавить("СтатьяРасходов");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	КонецЕсли;	
	
	Для Каждого СтрокаСостава Из ДокументОбъект.Состав Цикл
		ЗарплатаСтроки = ДокументОбъект.Выплаты.Выгрузить(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки), "КВыплате");
		Если ЗарплатаСтроки.Итог("КВыплате") < 0 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'У получателя %1 указана отрицательная сумма к выплате';
							|en = 'The recipient %1 has a negative amount to be paid'"),
						СтрокаСостава.ФизическоеЛицо);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДокументОбъект, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Состав[%1].ФизическоеЛицо", СтрокаСостава.НомерСтроки-1),, Отказ);
		КонецЕсли;	
	КонецЦикла;
	
	Если НачалоДня(ДокументОбъект.Дата) > ВедомостьПрочихДоходовКлиентСервер.ДатаВыплаты(ДокументОбъект) Тогда
		ТекстОшибки = НСтр("ru = 'Дата выплаты не может быть меньше даты документа';
							|en = 'Payment date cannot be less than the document date'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ДокументОбъект, "ДатаВыплаты",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьВТСписокСотрудниковПоТаблицеВыплат(МенеджерВременныхТаблиц, ТаблицаВыплат, Ведомость)

	КолонкиГруппировокСписка = "ФизическоеЛицо, ДокументОснование, СтатьяФинансирования, СтатьяРасходов";
	
	СписокСотрудников = Ведомость.Выплаты.ВыгрузитьКолонки(КолонкиГруппировокСписка + ", КВыплате");
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаВыплат, СписокСотрудников);
	СписокСотрудников.Свернуть(КолонкиГруппировокСписка, "КВыплате");
	СписокСотрудников.Колонки.КВыплате.Имя = "СуммаВыплаты";
	
	ОписательВТ = 
		ВзаиморасчетыССотрудниками.ОписательВременныхТаблицДляСоздатьВТСостояниеВыплат(
			МенеджерВременныхТаблиц, СписокСотрудников);
	ВзаиморасчетыССотрудниками.СоздатьВТСостояниеВыплат(
		ОписательВТ, Истина, 
		Ведомость.Организация, Ведомость.ПериодРегистрации, 
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ведомость.Ссылка), 
		"ВТСписокСотрудников");
	
КонецПроцедуры

Процедура ПередЗаписью(ДокументОбъект, Отказ, РежимЗаписи) Экспорт
	
	Если ВзаиморасчетыССотрудниками.ЕстьОплатаПоВедомости(ДокументОбъект.Ссылка) Тогда
		
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По ведомости %1 номер %2 от %3 произведены оплаты, изменения запрещены';
					|en = 'Payments are effected against the %1 paysheet number %2 dated %3, changes are prohibited'"), 
				?(ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВедомостьПрочихДоходовВКассу"), НСтр("ru = 'в кассу';
																									|en = 'to cash account'"), НСтр("ru = 'в банк';
																															|en = 'to bank'")), 
				ДокументОбъект.Номер, 
				Формат(ДокументОбъект.Дата, "ДЛФ=D"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ДокументОбъект);
		
		Отказ = Истина;
		
		Возврат
		
	КонецЕсли;
	
	// Очистка табличной части Зарплата от строк, не имеющих "родителя" в ТЧ Состав
	// Синхронизация общих реквизитов табличных частей Состав и Выплаты.
	ПоляСостава	= Новый Массив;
	Для Каждого РеквизитСостава Из ДокументОбъект.Метаданные().ТабличныеЧасти.Состав.Реквизиты  Цикл
		ПоляСостава.Добавить(РеквизитСостава.Имя);
	КонецЦикла;	
	СписокСвойств = СтрСоединить(ПоляСостава, ", ");
	
	ЛишниеСтроки = Новый Массив;
	Для Каждого СтрокаВыплаты Из ДокументОбъект.Выплаты Цикл
		СтрокаСостава = ДокументОбъект.Состав.Найти(СтрокаВыплаты.ИдентификаторСтроки, "ИдентификаторСтроки");
		Если СтрокаСостава = Неопределено Тогда
			ЛишниеСтроки.Добавить(СтрокаВыплаты);
		Иначе	
			ЗаполнитьЗначенияСвойств(СтрокаВыплаты, СтрокаСостава, СписокСвойств)
		КонецЕсли	
	КонецЦикла;
	Для Каждого ЛишняяСтрока Из ЛишниеСтроки Цикл
		ДокументОбъект.Выплаты.Удалить(ЛишняяСтрока);
	КонецЦикла;	
	
	// Очистка табличной части НДФЛ от строк, не имеющих "родителя" в ТЧ Состав
	// Синхронизация общих реквизитов табличных частей Состав и НДФЛ.
	ЛишниеСтроки = Новый Массив;
	Для Каждого СтрокаНДФЛ Из ДокументОбъект.НДФЛ Цикл
		СтрокаСостава = ДокументОбъект.Состав.Найти(СтрокаНДФЛ.ИдентификаторСтроки, "ИдентификаторСтроки");
		Если СтрокаСостава = Неопределено Тогда
			ЛишниеСтроки.Добавить(СтрокаНДФЛ);
		Иначе	
			ЗаполнитьЗначенияСвойств(СтрокаНДФЛ, СтрокаСостава, "ФизическоеЛицо")
		КонецЕсли	
	КонецЦикла;
	Для Каждого ЛишняяСтрока Из ЛишниеСтроки Цикл
		ДокументОбъект.НДФЛ.Удалить(ЛишняяСтрока);
	КонецЦикла;	
	
	// Посчитать сумму документа и записать ее в соответствующий реквизит шапки.
	ДокументОбъект.СуммаПоДокументу = ДокументОбъект.Выплаты.Итог("КВыплате");
	
КонецПроцедуры

Процедура ОбновитьНДФЛ(Ведомость, Физлица) Экспорт
	
	ТаблицаВыплат = Ведомость.Выплаты.ВыгрузитьКолонки("ФизическоеЛицо, ДокументОснование, СтатьяФинансирования, СтатьяРасходов, КВыплате");
	Для Каждого СтрокаВыплаты Из Ведомость.Выплаты Цикл
		Если Физлица.Найти(СтрокаВыплаты.ФизическоеЛицо) <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаВыплат.Добавить(), СтрокаВыплаты);
		КонецЕсли
	КонецЦикла;	
	
	// Получаем НДФЛ к удержанию (перечислению)
	НДФЛ = НДФЛПоТаблицеЗарплат(Ведомость, ТаблицаВыплат);
	
	ПараметрыОтбораНДФЛ = Новый Структура("ФизическоеЛицо");
	Для Каждого Физлицо Из Физлица Цикл
		
		ПараметрыОтбораНДФЛ.ФизическоеЛицо = ФизЛицо;
		
		// Определяем идентификатор строки состава, к которой будет привязан НДФЛ физического лица.
		ИдентификаторСтроки = Неопределено;
		СтрокаНДФЛ = Ведомость.НДФЛ.Найти(Физлицо, "ФизическоеЛицо");
		Если СтрокаНДФЛ = Неопределено Тогда
			СтрокаСостава = Ведомость.Состав.Найти(Физлицо, "ФизическоеЛицо");
			Если СтрокаСостава <> Неопределено Тогда
				ИдентификаторСтроки = СтрокаСостава.ИдентификаторСтроки
			КонецЕсли	
		Иначе
			ИдентификаторСтроки = СтрокаНДФЛ.ИдентификаторСтроки
		КонецЕсли;	
		
		Если ИдентификаторСтроки = Неопределено Тогда
			Продолжить
		КонецЕсли;	
		
		// Удаляем старый НДФЛ физического лица
		УдаляемыеСтроки = Ведомость.НДФЛ.НайтиСтроки(ПараметрыОтбораНДФЛ);
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			Ведомость.НДФЛ.Удалить(УдаляемаяСтрока)
		КонецЦикла;
		
		// Помещаем новый НДФЛ физического лица, привязывая его к строке состава
		НДФЛФизлица = НДФЛ.НайтиСтроки(ПараметрыОтбораНДФЛ);
		Для Каждого СтрокаНДФЛФизлица Из НДФЛФизлица Цикл
			ДобавляемаяСтрока = Ведомость.НДФЛ.Добавить();
			ЗаполнитьЗначенияСвойств(ДобавляемаяСтрока, СтрокаНДФЛФизлица);
			ДобавляемаяСтрока.ИдентификаторСтроки = ИдентификаторСтроки;
		КонецЦикла	
	КонецЦикла;
	
КонецПроцедуры

Функция НДФЛПоТаблицеЗарплат(Ведомость, ТаблицаВыплат)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТСписокСотрудниковПоТаблицеВыплат(МенеджерВременныхТаблиц, ТаблицаВыплат, Ведомость);
	
	НДФЛ = 	
		УчетНДФЛ.РассчитатьУдержанныеНалоги(
			Ведомость.Ссылка, 
			Ведомость.Организация, 
			Ведомость.Дата, 
			МенеджерВременныхТаблиц, 
			Ведомость.ПериодРегистрации,
			Ложь);
			
	// При постатейной выплате оставляем только налоги с заказанных статей 
	Если ЗначениеЗаполнено(Ведомость.СтатьяФинансирования) Или ЗначениеЗаполнено(Ведомость.СтатьяРасходов) Тогда
		
		КолонкиОтбораНДФЛ = "ФизическоеЛицо, МесяцНалоговогоПериода, Подразделение, ДокументОснование";
		ТаблицаОтбораБухучетаНДФЛ = НДФЛ.Скопировать(, КолонкиОтбораНДФЛ);
		ТаблицаОтбораБухучетаНДФЛ.Свернуть(КолонкиОтбораНДФЛ);
		
		БухучетНДФЛ = ОтражениеЗарплатыВБухучетеРасширенный.БухучетНДФЛФизическихЛицПоДокументамОснованиям(ТаблицаОтбораБухучетаНДФЛ);
		БухучетНДФЛ.Индексы.Добавить(КолонкиОтбораНДФЛ);
		
		УдаляемыеСтрокиНДФЛ = Новый Массив;
		ПараметрыОтбораНДФЛ = Новый Структура(КолонкиОтбораНДФЛ);
		Для Каждого СтрокаНДФЛ Из НДФЛ Цикл
			ЗаполнитьЗначенияСвойств(ПараметрыОтбораНДФЛ, СтрокаНДФЛ); 
			БухучетПоСтрокеНДФЛ = БухучетНДФЛ.НайтиСтроки(ПараметрыОтбораНДФЛ);
			СуммаИтого = 0;
			СуммаПоИсточнику = 0;
			Для Каждого СтрокаБухучета Из БухучетПоСтрокеНДФЛ Цикл
				СуммаИтого = СуммаИтого + СтрокаБухучета.Сумма;
				Если (Не ЗначениеЗаполнено(Ведомость.СтатьяФинансирования) Или Ведомость.СтатьяФинансирования = СтрокаБухучета.СтатьяФинансирования)
					И (Не ЗначениеЗаполнено(Ведомость.СтатьяРасходов) Или Ведомость.СтатьяРасходов = СтрокаБухучета.СтатьяРасходов) Тогда
					СуммаПоИсточнику = СуммаПоИсточнику + СтрокаБухучета.Сумма
				КонецЕсли;
			КонецЦикла;	
			Если СуммаПоИсточнику <> 0 И СуммаИтого <> 0 Тогда
				СтрокаНДФЛ.Сумма = МИН(СтрокаНДФЛ.НачисленоНалога * СуммаПоИсточнику / СуммаИтого, СтрокаНДФЛ.Сумма);
			Иначе
				УдаляемыеСтрокиНДФЛ.Добавить(СтрокаНДФЛ);
			КонецЕсли;	
		КонецЦикла;	
		
		Для Каждого СтрокаНДФЛ Из УдаляемыеСтрокиНДФЛ Цикл
			НДФЛ.Удалить(СтрокаНДФЛ)
		КонецЦикла;	
		
	КонецЕсли;	
	
	Возврат НДФЛ
	
КонецФункции

Процедура ОбработкаПроведения(Ведомость, Отказ) Экспорт
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(Ведомость);
	
	ОписаниеКолонокВыплаты = НовоеОписаниеСоответствияКолонокДляТаблицыВыплаченногоДохода();
	ОписаниеКолонокВыплаты.Сумма = "КВыплате";
	
	Выплаты = НоваяТаблицаВыплаченногоДоходаПоТабличнойЧасти(
		Ведомость.Выплаты,
		ОписаниеКолонокВыплаты);
		
	СпособРасчетов = ВзаиморасчетыПоПрочимДоходам.СоответствиеСпособВыплатыСпособРасчетов()[Ведомость.СпособВыплаты];	
	
	ВзаиморасчетыПоПрочимДоходам.ЗарегистрироватьВыплаченныйДоход(
		Ведомость.Движения, 
		Отказ, 
		Ведомость.Организация, 
		Ведомость.ПериодРегистрации, 
		Выплаты,
		СпособРасчетов);
	
	// Регистрация выдачи зарплаты.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		
		ЗарегистрироватьУдержанныеНалоги(Ведомость, Отказ);
		
		Если Ведомость.ПеречислениеНДФЛВыполнено Тогда
			ЗарегистрироватьПеречислениеНДФЛ(Ведомость, Отказ);
		КонецЕсли;
		
	КонецЕсли;

	
	Для Каждого НаборЗаписей Из Ведомость.Движения Цикл
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Записывать = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Создает новую таблицу значений для данных о выплаченных доходах по переданной табличной части.
//
// Параметры:
//		ТабличнаяЧасть - ТабличнаяЧасть - данные о выплаченных доходах.
//		ОписаниеСоответствияКолонок - Структура - см. НовоеОписаниеСоответствияКолонокДляТаблицыВыплаченнойЗарплаты.
//
// Возвращаемое значение:
//		ТаблицаЗначений - см. НоваяТаблицаВыплаченногоДохода().
//
Функция НоваяТаблицаВыплаченногоДоходаПоТабличнойЧасти(ТабличнаяЧасть, ОписаниеСоответствияКолонок)
	
	КолонкиТаблицыВыплаченногоДохода = КолонкиТаблицыВыплаченногоДохода();
	
	КолонкиВыгружаемые  = Новый Массив;
	КолонкиГруппировок  = Новый Массив;
	КолонкиСуммирования = Новый Массив;
	
	Для Каждого ОписаниеКолонки Из ОписаниеСоответствияКолонок Цикл
		Если КолонкиТаблицыВыплаченногоДохода.Все.Найти(ОписаниеКолонки.Ключ) = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'НоваяТаблицаВыплаченногоДоходаПоТабличнойЧасти: недопустимое имя колонки таблицы выплаченной зарплаты в описании соответствия колонок';
									|en = 'НоваяТаблицаВыплаченногоДоходаПоТабличнойЧасти: invalid column name of the paid salary table in column mapping description'")
		КонецЕсли;	
		КолонкиВыгружаемые.Добавить(ОписаниеКолонки.Значение);
		Если КолонкиТаблицыВыплаченногоДохода.Группировок.Найти(ОписаниеКолонки.Ключ) <> Неопределено Тогда
			КолонкиГруппировок.Добавить(ОписаниеКолонки.Значение);
		ИначеЕсли КолонкиТаблицыВыплаченногоДохода.Суммирования.Найти(ОписаниеКолонки.Ключ) <> Неопределено Тогда
			КолонкиСуммирования.Добавить(ОписаниеКолонки.Значение);
		КонецЕсли	
	КонецЦикла;	
	
	ТаблицаВыплаченногоДохода = ТабличнаяЧасть.Выгрузить(, СтрСоединить(КолонкиВыгружаемые, ", "));
	ТаблицаВыплаченногоДохода.Свернуть(СтрСоединить(КолонкиГруппировок, ", "), СтрСоединить(КолонкиСуммирования, ", "));
	
	Для Каждого ОписаниеКолонки Из ОписаниеСоответствияКолонок Цикл
		ТаблицаВыплаченногоДохода.Колонки[ОписаниеКолонки.Значение].Имя = ОписаниеКолонки.Ключ
	КонецЦикла;
	
	Возврат ТаблицаВыплаченногоДохода
	
КонецФункции

Функция КолонкиТаблицыВыплаченногоДохода()
	
	Колонки = Новый Структура;
	Колонки.Вставить("Все", Новый Массив);
	Колонки.Вставить("Группировок",  Новый Массив);
	Колонки.Вставить("Суммирования", Новый Массив);
	
	Для Каждого Колонка Из ВзаиморасчетыПоПрочимДоходам.НоваяТаблицаВыплаченногоДохода().Колонки Цикл
		Колонки.Все.Добавить(Колонка.Имя);
		Если Колонка.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			Колонки.Суммирования.Добавить(Колонка.Имя)
		Иначе	
			Колонки.Группировок.Добавить(Колонка.Имя)
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Колонки
	
КонецФункции

// Создает описание соответствия колонок входной таблицы колонкам таблицы выплаченного дохода.
// Предназначена для использования в функциях- конструкторах. 
// см. НоваяТаблицаВыплаченногоДохода(), см. НоваяТаблицаВыплаченнойЗарплатыПоТабличнойЧасти().
//
// Возвращаемое значение:
//		Структура - Ключ содержит имя колонки таблицы выплаченной зарплаты, значение - имя колонки входной таблицы.
//
Функция НовоеОписаниеСоответствияКолонокДляТаблицыВыплаченногоДохода()
	
	ОписаниеСоответствияКолонок = Новый Структура;
	
	Для Каждого Колонка Из ВзаиморасчетыПоПрочимДоходам.НоваяТаблицаВыплаченногоДохода().Колонки Цикл
		ОписаниеСоответствияКолонок.Вставить(Колонка.Имя, Колонка.Имя)
	КонецЦикла;
	
	Возврат ОписаниеСоответствияКолонок
	
КонецФункции

Процедура ЗарегистрироватьУдержанныеНалоги(Ведомость, Отказ = Ложь)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТСписокСотрудниковПоТаблицеВыплат(МенеджерВременныхТаблиц, Ведомость.Выплаты, Ведомость);
	
	ЗапросНДФЛ = Новый Запрос;
	ЗапросНДФЛ.УстановитьПараметр("Ссылка", Ведомость.Ссылка);
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	// ФизическоеЛицо, СтавкаНалогообложенияРезидента, МесяцНалоговогоПериода, Подразделение, КодДохода, РегистрацияВНалоговомОргане, ВключатьВДекларациюПоНалогуНаПрибыль, ДокументОснование и др. поля
	|	*
	|ИЗ
	|	#ВедомостьНДФЛ КАК ВедомостьНДФЛ
	|ГДЕ
	|	ВедомостьНДФЛ.Ссылка = &Ссылка";
	ЗапросНДФЛ.Текст = СтрЗаменить(ТекстЗапроса, "#ВедомостьНДФЛ", Ведомость.Метаданные().ПолноеИмя() + ".НДФЛ");
	
	УчетФактическиПолученныхДоходов.СоздатьВТНалогУдержанный(МенеджерВременныхТаблиц, ЗапросНДФЛ, ВедомостьПрочихДоходовКлиентСервер.ДатаВыплаты(Ведомость)); 
	
	ЗарегистрироватьУдержанныйНалогПоВременнымТаблицам(Ведомость, Отказ, Ведомость.Организация, Ведомость.Дата, ВедомостьПрочихДоходовКлиентСервер.ДатаВыплаты(Ведомость), МенеджерВременныхТаблиц);

КонецПроцедуры

// Выполняет регистрацию удержанного налога
// Параметры:
//		Регистратор - ДокументОбъект
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - должен содержать временные таблицы 
//      	ВТСписокСотрудников и ВТНалогУдержанный, см. УчетНДФЛ.
//
Процедура ЗарегистрироватьУдержанныйНалогПоВременнымТаблицам(Регистратор, Отказ, Организация, ДатаОперации, ДатаВыплаты, МенеджерВременныхТаблиц)
	
	УчетФактическиПолученныхДоходов.ЗарегистрироватьНовуюДатуПолученияДохода(Регистратор.Ссылка, Регистратор.Движения, МенеджерВременныхТаблиц, ДатаВыплаты, ДатаОперации, Отказ, Истина);
	УчетНДФЛ.ВписатьСуммыВыплаченногоДоходаВУдержанныеНалоги(МенеджерВременныхТаблиц, Регистратор.Ссылка, ДатаВыплаты);	
	УчетНДФЛ.СформироватьУдержанныйНалогПоВременнойТаблице(Регистратор.Движения, Отказ, Организация, ДатаВыплаты, МенеджерВременныхТаблиц, , Истина);
	
КонецПроцедуры

Процедура ЗарегистрироватьПеречислениеНДФЛ(Ведомость, Отказ = Ложь)
	
	УчетНДФЛРасширенный.ЗарегистрироватьНДФЛПеречисленныйПоПлатежномуДокументу(Ведомость.Движения, Отказ, Ведомость.Организация, ВедомостьПрочихДоходовКлиентСервер.ДатаВыплаты(Ведомость), Ведомость.ПеречислениеНДФЛРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(Ведомость, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ЭтоДанныеЗаполненияВедомости(ДанныеЗаполнения) Тогда
		
		ЗаполнитьЗначенияСвойств(Ведомость, ДанныеЗаполнения.Шапка);
		Ведомость.Выплаты.Загрузить(ДанныеЗаполнения.Выплаты);
		
		ЗаполнитьОтветственныеЛица(Ведомость);
		
		Для Каждого Основание Из ДанныеЗаполнения.Основания Цикл
			СтрокаОснования = Ведомость.Основания.Добавить();
			СтрокаОснования.Документ = Основание;
		КонецЦикла;
		
		СтандартнаяОбработка = Ложь
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьОтветственныеЛица(Ведомость)
	
	ЗаполняемыеЗначения = Новый Структура;
	ЗаполняемыеЗначения.Вставить("Ответственный");
	ЗаполняемыеЗначения.Вставить("Организация");
	МенеджерВедомости = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ведомость.Ссылка);
	Для Каждого Реквизит Из МенеджерВедомости.РеквизитыОтветственныхЛиц() Цикл
		ЗаполняемыеЗначения.Вставить(Реквизит);
	КонецЦикла;	
	ЗаполнитьЗначенияСвойств(ЗаполняемыеЗначения, Ведомость);
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
	ЗаполнитьЗначенияСвойств(Ведомость, ЗаполняемыеЗначения,, "Организация");
	
КонецПроцедуры

// Возвращает структуру, используемую для заполнения ведомостей на выплату прочих доходов.
//
Функция ДанныеЗаполненияВедомости() Экспорт
	
	Шапка = Новый Структура;
	Шапка.Вставить("Дата");
	Шапка.Вставить("Организация");
	Шапка.Вставить("ПериодРегистрации");
	Шапка.Вставить("СпособВыплаты");
	Шапка.Вставить("ЗарплатныйПроект");
	
	Выплаты = Новый ТаблицаЗначений;
	Выплаты.Колонки.Добавить("ФизическоеЛицо");
	Выплаты.Колонки.Добавить("КВыплате");
	
	ДанныеЗаполненияВедомости = Новый Структура;
	
	ДанныеЗаполненияВедомости.Вставить("ЭтоДанныеЗаполненияВедомостиПрочихДоходов");
	ДанныеЗаполненияВедомости.Вставить("Шапка",		Шапка);
	ДанныеЗаполненияВедомости.Вставить("Выплаты",	Выплаты);
	
	ДанныеЗаполненияВедомости.Шапка.Вставить("ПеречислениеНДФЛВыполнено", Истина);
	ДанныеЗаполненияВедомости.Шапка.Вставить("ПеречислениеНДФЛРеквизиты", "");
	
	ДанныеЗаполненияВедомости.Вставить("Основания", Новый Массив);

	Возврат ДанныеЗаполненияВедомости
	
КонецФункции

// Проверяет, являются ли переданные данные структурой, используемой для заполнения документа
// (см. функцию ДанныеЗаполнения).
//
Функция ЭтоДанныеЗаполненияВедомости(ДанныеЗаполнения)
	Возврат ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ЭтоДанныеЗаполненияВедомостиПрочихДоходов") 
КонецФункции	

Функция ТекстЗапросаДанныеДляОплаты(ИмяТипа, ИмяПараметраВедомости = "Ведомости", ИмяПараметраФизическиеЛица = "ФизическиеЛица") Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВедомостьВыплаты.Ссылка КАК Ссылка,
	|	ВедомостьВыплаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СУММА(ВедомостьВыплаты.КВыплате) КАК КВыплате,
	|	0 КАК КомпенсацияЗаЗадержкуЗарплаты
	|ИЗ
	|	#ВедомостьВыплаты КАК ВедомостьВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ВедомостьВыплаты.Ссылка,
	|	ВедомостьВыплаты.ФизическоеЛицо";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ВедомостьВыплаты",	ИмяТипа + ".Выплаты");
	
	Схема = Новый СхемаЗапроса();
	Схема.УстановитьТекстЗапроса(ТекстЗапроса);
	
	Если ЗначениеЗаполнено(ИмяПараметраВедомости) Тогда
		Схема.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(СтрШаблон("ВедомостьВыплаты.Ссылка В(&%1)", ИмяПараметраВедомости));
	КонецЕсли;	
	Если ЗначениеЗаполнено(ИмяПараметраФизическиеЛица) Тогда
		Схема.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(СтрШаблон("ВедомостьВыплаты.ФизическоеЛицо В (&%1)", ИмяПараметраФизическиеЛица));
	КонецЕсли;	
	
	ТекстЗапроса = Схема.ПолучитьТекстЗапроса();
	
	Возврат ТекстЗапроса;
	
КонецФункции	

#КонецОбласти

