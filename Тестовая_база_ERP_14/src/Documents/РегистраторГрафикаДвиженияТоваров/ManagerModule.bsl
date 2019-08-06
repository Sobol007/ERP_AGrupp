
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Соотвествие со списком реквизитов, по которым определяется уникальность ключа
// 
// Возвращаемое значение:
//   Соотвествие - ключ - имя реквизита 
//
Функция КлючевыеРеквизиты() Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить("Распоряжение");
	
	Возврат Результат;
	
КонецФункции

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Регистратор графика движения товаров".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.РегистраторГрафикаДвиженияТоваров) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РегистраторГрафикаДвиженияТоваров.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.РегистраторГрафикаДвиженияТоваров);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

// Ищет документ регистрации по распоряжению
//
// Параметры:
//  Распоряжение - ДокументСсылка, СправочникСсылка.СоглашенияСПоставщиками, СправочникСсылка.ДоговорыКонтрагентов 
//  Создавать	 - Булево - создавать документ-регистратор, если он не найден по распоряжению 
// 
// Возвращаемое значение:
//  ДокументСсылка.РегистраторГрафикаДвиженияТоваров - ссылка на документ.
//
Функция РегистраторПоРаспоряжению(Распоряжение) Экспорт
	
	Если Не (ТипЗнч(Распоряжение) = Тип("СправочникСсылка.СоглашенияСПоставщиками")
		Или ТипЗнч(Распоряжение) = Тип("СправочникСсылка.ДоговорыКонтрагентов")) Тогда
		Возврат Распоряжение;
	КонецЕсли;
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Ссылка КАК Документ
	|ИЗ
	|	Документ.РегистраторГрафикаДвиженияТоваров КАК Таблица
	|ГДЕ
	|	Таблица.Распоряжение = &Распоряжение";
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Результат = Выборка.Документ;
		
	Иначе
		
		ТекстИсключения = НСтр("ru = 'Не найден документ-регистратор движения графика движения товаров по распоряжению %Распоряжение%.';
								|en = 'Document recorder of transfer of goods transfer schedule under the %Распоряжение% reference was not found.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%Распоряжение%", Распоряжение);
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Распоряжение.Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
