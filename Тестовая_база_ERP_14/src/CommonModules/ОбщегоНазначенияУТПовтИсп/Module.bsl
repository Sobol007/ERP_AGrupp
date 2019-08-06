
#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДополнительныеРеквизитыИСведения

// Возвращает соответствие набора доп. реквизитов (сведений) и функциональных опций, влияющих на возможность его использования.
//
// Возвращаемое значение:
//	Соответствие
//		Ключ - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений
//		Значение - Строка - имена ФО конфигурации, с которыми связан этот набор.
//
Функция СвязиДопРеквизитовИФункциональныхОпций() Экспорт
	
	ОписаниеОбъектов = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НаборыДополнительныхРеквизитовИСведений.Ссылка
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК НаборыДополнительныхРеквизитовИСведений
	|ГДЕ
	|	НаборыДополнительныхРеквизитовИСведений.Предопределенный
	|	И НаборыДополнительныхРеквизитовИСведений.Родитель = ЗНАЧЕНИЕ(Справочник.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		// Заменим первый символ "_" в имени объекта на "."
		ИмяОбъекта = Справочники.НаборыДополнительныхРеквизитовИСведений.ПолучитьИмяПредопределенного(Выборка.Ссылка);
		
		ПозицияРазделителя = СтрНайти(ИмяОбъекта, "_");
		Если ПозицияРазделителя = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяОбъекта = Лев(ИмяОбъекта, ПозицияРазделителя - 1) + "." + Сред(ИмяОбъекта, ПозицияРазделителя + 1);
		
		// Объекты с префиксом "Удалить" пропускаем
		Если СтрНайти(НРег(ИмяОбъекта), ".удалить") > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяОбъекта);
		
		Если ОбъектМетаданных <> Неопределено Тогда
			
			ОписаниеОбъекта = Новый Структура;
			ОписаниеОбъекта.Вставить("Ссылка",              Выборка.Ссылка);
			ОписаниеОбъекта.Вставить("ФункциональныеОпции", "");
			ОписаниеОбъекта.Вставить("ОбъектМетаданных",    ОбъектМетаданных);
			
			ОписаниеОбъектов.Вставить(ИмяОбъекта, ОписаниеОбъекта);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого МетаФО Из Метаданные.ФункциональныеОпции Цикл
		
		Если НЕ Метаданные.Константы.Содержит(МетаФО.Хранение) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ОписаниеОбъекта Из ОписаниеОбъектов Цикл
			Если МетаФО.Состав.Содержит(ОписаниеОбъекта.Значение.ОбъектМетаданных) Тогда
				ОписаниеОбъекта.Значение.ФункциональныеОпции = ОписаниеОбъекта.Значение.ФункциональныеОпции
					+ ?(ОписаниеОбъекта.Значение.ФункциональныеОпции = "", "", ",") + МетаФО.Имя;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Результат = Новый Соответствие;
	Для Каждого ОписаниеОбъекта Из ОписаниеОбъектов Цикл
		Результат.Вставить(ОписаниеОбъекта.Значение.Ссылка, ОписаниеОбъекта.Значение.ФункциональныеОпции);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СвойстваОбъектаМетаданных

// Позволяет определить, есть ли среди реквизитов или стандартных реквизитов объекта реквизит с переданным именем.
//
// Параметры:
//  ИмяОбъектаМетаданных - Строка - имя метаданных объекта, в котором требуется проверить наличие реквизита
//  ИмяРеквизита - Строка - имя реквизита.
//
// Возвращаемое значение:
//  Булево.
//
Функция ЕстьРеквизитОбъекта(ИмяОбъектаМетаданных, ИмяРеквизита) Экспорт
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных);
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта(ИмяРеквизита, МетаданныеОбъекта) Тогда
		Возврат Истина;
	КонецЕсли;
	
	СвойстваОбъекта = Новый Структура("СтандартныеРеквизиты");
	ЗаполнитьЗначенияСвойств(СвойстваОбъекта, МетаданныеОбъекта);
	
	Если СвойстваОбъекта.СтандартныеРеквизиты = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЭтоСтандартныйРеквизит(СвойстваОбъекта.СтандартныеРеквизиты, ИмяРеквизита);
	
КонецФункции

#КонецОбласти

#Область ОчисткаРегистровСведений

// Возвращает информацию о регистрах сведений, в которых есть записи по указанным метаданным.
//
// Параметры:
//	ИменаОбъектовМетаданных - Строка - перечисленные через запятую полные имена метаданных,
//		записи по которым которые ищем в регистрах сведений.
//	ТолькоВедущиеИзмерения - Булево - выполнять поиск ссылок на метаданные только в ведущих измерениях.
//
// Возвращаемое значение:
//	Массив с элементами типа Структура с ключами
//		- Имя - Строка - имя регистра в метаданных
//		- Измерения - Массив - описание измерений регистра, в которых найдены ссылки, с элементами типа Структура с ключами
//			- Имя - Строка - Имя измерения в метаданных
//			- Типы - Массив - описание типов измерения, в которых найдены ссылки
//				- элемент массива - Строка - полное имя объекта метаданных, на которого найдена ссылка в регистре.
//	
Функция РегистрыСведенийПоМетаданнымИзмерений(ИменаОбъектовМетаданных, ТолькоВедущиеИзмерения = Ложь) Экспорт
	
	МассивИменМетаданных = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаОбъектовМетаданных, ",",, Истина);
	
	МассивРегистров = Новый Массив;
	
	Для Каждого Регистр Из Метаданные.РегистрыСведений Цикл
		
		Если Регистр.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
			Продолжить;
		КонецЕсли;
		
		МассивИзмерений = Новый Массив;
		
		Для Каждого Измерение Из Регистр.Измерения Цикл
			
			Если ТолькоВедущиеИзмерения И НЕ Измерение.Ведущее Тогда
				Продолжить;
			КонецЕсли;
			
			МассивТипов = Новый Массив;
			
			Для Каждого ТипИзмерения Из Измерение.Тип.Типы() Цикл
				
				ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипИзмерения);
				Если ОбъектМетаданных <> Неопределено
				 И МассивИменМетаданных.Найти(ОбъектМетаданных.ПолноеИмя()) <> Неопределено Тогда
					
					МассивТипов.Добавить(ОбъектМетаданных.ПолноеИмя());
					
			 	КонецЕсли;
				
			КонецЦикла; // типы
			
			Если МассивТипов.Количество() > 0 Тогда
				МассивИзмерений.Добавить(Новый Структура("Имя, Типы", Измерение.Имя, МассивТипов));
			КонецЕсли;
			
		КонецЦикла; // измерения
		
		Если МассивИзмерений.Количество() > 0 Тогда
			МассивРегистров.Добавить(Новый Структура("Имя, Измерения", Регистр.Имя, МассивИзмерений));
		КонецЕсли;
		
	КонецЦикла; // регистры
	
	Возврат МассивРегистров;
	
КонецФункции

// Возвращает текст запроса к регистрам сведений, в которых есть записи по указанным метаданным.
//
// Параметры:
//	ИменаОбъектовМетаданных - Строка - перечисленные через запятую полные имена метаданных,
//		записи по которым которые ищем в регистрах сведений.
//	РазмерПорцииВыборки - Число - количество записей в выборке, "ВЫБРАТЬ ПЕРВЫЕ ххх".
//
// Возвращаемое значение:
//	Строка - текст запроса, выбираются следующие поля
//		ИмяРегистра - Строка - имя регистра, в котором есть ссылки на искомые метаданные
//		ИмяИзмерения - Строка - имя измерения регистра, в которых есть ссылки на искомые метаданные
//		ЗначениеОтбора - Ссылка - ссылка на объект метаданных искомого типа, по которой можно выполнить отбор регистра.
//
Функция ТекстЗапросаКРегистрамСведенийПоМетаданнымИзмерений(ИменаОбъектовМетаданных, РазмерПорцииВыборки = 0) Экспорт
	
	ШаблонЗапросаКРегистру =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	""%1"" КАК ИмяРегистра,
	|	""%2"" КАК ИмяИзмерения,
	|	Регистр.%2 КАК ЗначениеОтбора
	|%4
	|ИЗ
	|	РегистрСведений.%1 КАК Регистр
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ %3 КАК ЗначенияОтбора
	|		ПО Регистр.%2 = ЗначенияОтбора.Ссылка";
	
	ШаблонЗапросаВТ =
	"ВЫБРАТЬ
	|	%1.ИмяРегистра КАК ИмяРегистра,
	|	%1.ИмяИзмерения КАК ИмяИзмерения,
	|	%1.ЗначениеОтбора КАК ЗначениеОтбора
	|%2
	|ИЗ
	|	%1 КАК %1";
	
	ТекстЗапроса = "";
	
	МассивРегистров = ОбщегоНазначенияУТПовтИсп.РегистрыСведенийПоМетаданнымИзмерений(ИменаОбъектовМетаданных);
	
	МассивТаблицЗапроса = Новый Массив;
	
	Для Каждого ТекущийРегистр Из МассивРегистров Цикл
		Для Каждого ТекущееИзмерение Из ТекущийРегистр.Измерения Цикл
			Для Каждого ТекущееИмяТипа Из ТекущееИзмерение.Типы Цикл
				
				МассивТаблицЗапроса.Добавить(
					Новый Структура(
						"ИмяРегистра, ИмяИзмерения, ИмяТипа",
						ТекущийРегистр.Имя, ТекущееИзмерение.Имя, ТекущееИмяТипа));
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	// Выборку будем делать порциями, чтобы не столкнуться с ограничением СУБД на 256 таблиц в запросе.
	КоличествоПорций 		  = МассивТаблицЗапроса.Количество() / 255;
	КоличествоВременныхТаблиц = Цел(КоличествоПорций) + ?(Цел(КоличествоПорций) = КоличествоПорций, 0, 1);
	
	Для НомерВременнойТаблицы = 1 По КоличествоВременныхТаблиц Цикл
		
		Если НомерВременнойТаблицы = 1 Тогда
			ИмяПредыдущейВременнойТаблицы = "";
		Иначе
			ИмяПредыдущейВременнойТаблицы = "ВТ" + Формат(НомерВременнойТаблицы-1, "ЧГ=");
		КонецЕсли;
		
		// Очередная порция
		Для НомерТаблицыЗапроса = (НомерВременнойТаблицы-1)*255+1
		 По Мин(НомерВременнойТаблицы*255, МассивТаблицЗапроса.Количество()) Цикл
			
		 	Если НомерТаблицыЗапроса = (НомерВременнойТаблицы-1)*255+1 Тогда
				
				// Первый запрос в порции
				ИмяВременнойТаблицы = "ПОМЕСТИТЬ ВТ" + Формат(НомерВременнойТаблицы, "ЧГ=");
				
				Если ЗначениеЗаполнено(ИмяПредыдущейВременнойТаблицы) Тогда
					
					// Не первая порция - выберем сначала результат из предыдущей порции
					ТекстЗапроса = ТекстЗапроса
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ШаблонЗапросаВТ,
							ИмяПредыдущейВременнойТаблицы,
							ИмяВременнойТаблицы);
					
					ИмяВременнойТаблицы = "";
					
				КонецЕсли;
				
			Иначе
				
				ИмяВременнойТаблицы = "";
				
			КонецЕсли;
			
			// Выберем результат из очередного регистра
			ДанныеРегистра = МассивТаблицЗапроса[НомерТаблицыЗапроса-1];
			
			ТекстЗапроса = ТекстЗапроса
				+ ?(ЗначениеЗаполнено(ИмяВременнойТаблицы), "", "
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|")
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонЗапросаКРегистру,
					ДанныеРегистра.ИмяРегистра,
					ДанныеРегистра.ИмяИзмерения,
					ДанныеРегистра.ИмяТипа,
					ИмяВременнойТаблицы);
				
		КонецЦикла;
		
		// Добавим разделитель пакетного запроса
		ТекстЗапроса = ТекстЗапроса + "
			|
			|;
			|
			|";
		
	КонецЦикла;
	
	Если ТекстЗапроса <> "" Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ" + ?(РазмерПорцииВыборки = 0, "", " ПЕРВЫЕ " + Формат(РазмерПорцииВыборки, "ЧГ=")) + "
		|	Регистры.ИмяРегистра,
		|	Регистры.ИмяИзмерения,
		|	Регистры.ЗначениеОтбора
		|ИЗ
		|
		|	ВТ" + Формат(КоличествоВременныхТаблиц, "ЧГ=") + " КАК Регистры
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИмяРегистра,
		|	ИмяИзмерения";
	
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ПроверкаКорректностиНумерации

// Проверяет наличие документов РеализацияУслугПрочихАктивов с префиксом "У"
// Используется в целях корректной нумерации документов с 6-ти значным номером.
//
// Возвращаемое значение:
// 	Строка - "0" если есть документы, "" если нет.
//
Функция ДополнительныйПрефиксНумератораДокументыРеализацииТоваров() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	1 
	               |ИЗ
	               |	Документ.РеализацияУслугПрочихАктивов КАК РеализацияУслугПрочихАктивов
	               |ГДЕ
	               |	ПОДСТРОКА(РеализацияУслугПрочихАктивов.Номер, 6, 1) = ""У""";
				   
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Возврат "0";
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Классификаторы

Функция МассивИсключаемыхВидовКИКонтрагентаДляВыводаВФормеПартнера() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.Ссылка
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.Родитель = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.СправочникКонтрагенты)
	|	И НЕ ВидыКонтактнойИнформации.Ссылка В (
	|		ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента),
	|		ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента),
	|		ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента),
	|		ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.МеждународныйАдресКонтрагента),
	|		ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФаксКонтрагенты)
	|	)
	|";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Функция СоответствиеКодовОКВЭД() Экспорт

	Возврат Справочники.Организации.СоответствиеКодовКНаименованиюИзМакета("ОКВЭД2"); 

КонецФункции

// Позволяет определить, указанный документ является регистратором указанного регистра.
//
// Параметры:
//  ИмяДокумента - Строка - краткое имя документа который требуется поискать в регистраторах регистра.
//  ИмяРегистра - Строка - полное имя регистра (как в дереве метаданных). Для регистров накопления можно передавать
//                         краткие имена. Пример: "РегистрыСведений.БлокировкиСкладскихЯчеек" или "ТоварыОрганизаций".
//
// Возвращаемое значение:
//  Истина - документ является регистратором указанного регистра.
//
Функция ЭтоРегистраторРегистра(ИмяДокумента, ИмяРегистра) Экспорт
	
	Если СтрНайти(ИмяРегистра, ".") > 0 Тогда
		МетаданныеРегистра = ОбщегоНазначенияУТ.МетаданныеПоИмени(ИмяРегистра);
	Иначе// передано краткое имя регистра - только регистры накопления
		МетаданныеРегистра = Метаданные.РегистрыНакопления[ИмяРегистра];
	КонецЕсли;
	ТипДокумента = Тип("ДокументСсылка."+ИмяДокумента);
	Возврат МетаданныеРегистра.СтандартныеРеквизиты.Регистратор.Тип.Типы().Найти(ТипДокумента) <> Неопределено;
	
КонецФункции

#КонецОбласти

Функция ЗначенияПустыхКлючейРеестраДокументов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлючиРеестраДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
	|ГДЕ
	|	КлючиРеестраДокументов.Ключ В(&ПустыеЗначения)";
	
	МассивПустыхЗначений = Новый Массив;
	
	ТипыКлючей = Метаданные.Справочники.КлючиРеестраДокументов.Реквизиты.Ключ.Тип.Типы();
	
	Для Каждого ТипКлюча из ТипыКлючей Цикл
		МассивПустыхЗначений.Добавить(ПредопределенноеЗначение(Метаданные.НайтиПоТипу(ТипКлюча).ПолноеИмя() + ".ПустаяСсылка"));
	КонецЦикла;
	
	МассивПустыхЗначений.Добавить(Неопределено);
	Запрос.УстановитьПараметр("ПустыеЗначения", МассивПустыхЗначений);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецОбласти