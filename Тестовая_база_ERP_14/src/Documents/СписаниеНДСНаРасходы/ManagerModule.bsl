#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполняет табличную часть Ценности с отбором по реквизитам шапки документа.
// 
// Параметры:
//   ДокументОбъект - ДокументОбъект.СписаниеНДСНаРасходы - Ссылка на объект документа.
//
Процедура ЗаполнитьСписаниеНДСНаРасходы(ДокументОбъект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДСПредъявленный.ВидЦенности КАК ВидЦенности,
	|	НДСПредъявленный.СтавкаНДС КАК СтавкаНДС,
	|	НДСПредъявленный.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|	НДСПредъявленный.РеализацияЭкспорт КАК РеализацияЭкспорт,
	|	НДСПредъявленный.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НДСПредъявленный.СуммаБезНДСОстаток КАК СуммаБезНДС,
	|	НДСПредъявленный.НДСОстаток КАК НДС,
	|	НДСПредъявленный.НДСУпрОстаток КАК НДСУпр
	|ИЗ
	|	РегистрНакопления.НДСПредъявленный.Остатки(
	|		&Период,
	|		Организация = &Организация 
	|		И СчетФактура = &СчетФактура 
	|		И Поставщик = &Поставщик) КАК НДСПредъявленный
	|";
	
	Запрос.УстановитьПараметр("Период",      ДокументОбъект.Дата);
	Запрос.УстановитьПараметр("Организация", ДокументОбъект.Организация);
	Запрос.УстановитьПараметр("Поставщик",   ДокументОбъект.Поставщик);
	Запрос.УстановитьПараметр("СчетФактура", ДокументОбъект.СчетФактура);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ДокументОбъект.Ценности.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла; 
	
КонецПроцедуры

#Область ПроведениеПоРеглУчету

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	ТекстЗапроса - Строка - Текст запроса отражения.
//   
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	ТекстЗапроса = "";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	ТекстЗапроса - Строка - Текст запроса создания временных таблиц, используемых при отражении.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	ТекстЗапроса = "";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаНДСПредъявленный(Запрос, ТекстыЗапроса, Регистры);
	//++ НЕ УТ
	ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	//-- НЕ УТ
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписаниеНДСНаРасходы.Ссылка,
	|	СписаниеНДСНаРасходы.ПометкаУдаления,
	|	СписаниеНДСНаРасходы.Номер,
	|	СписаниеНДСНаРасходы.Дата,
	|	СписаниеНДСНаРасходы.Проведен,
	|	СписаниеНДСНаРасходы.Организация,
	|	СписаниеНДСНаРасходы.Поставщик,
	|	СписаниеНДСНаРасходы.СчетФактура,
	|	СписаниеНДСНаРасходы.СтатьяРасходов,
	|	СписаниеНДСНаРасходы.Подразделение,
	|	СписаниеНДСНаРасходы.АналитикаРасходов,
	|	СписаниеНДСНаРасходы.Комментарий,
	|	СписаниеНДСНаРасходы.СуммаБезНДС,
	|	СписаниеНДСНаРасходы.СуммаНДС
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК СписаниеНДСНаРасходы
	|ГДЕ
	|	СписаниеНДСНаРасходы.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                     Реквизиты.Дата);
	Запрос.УстановитьПараметр("Организация",                Реквизиты.Организация);
	Запрос.УстановитьПараметр("Поставщик",                  Реквизиты.Поставщик);
	Запрос.УстановитьПараметр("СчетФактура",                Реквизиты.СчетФактура);
	Запрос.УстановитьПараметр("ИспользоватьУчетПрочихДоходовРасходов", 	ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов"));
	
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаНДСПредъявленный(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НДСПредъявленный";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	УчетНДСУПСлужебный.УстановитьПараметрТипыНалогообложенияНДСПоступления(Запрос);
	
	ТекстЗапроса = "
	|
	|ВЫБРАТЬ
	|	&Ссылка                                КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	Операция.Дата                          КАК Период,
	|	Операция.Организация                   КАК Организация,
	|	Операция.СчетФактура                   КАК СчетФактура,
	|	Операция.Поставщик                     КАК Поставщик,
	|	Строки.ВидЦенности                     КАК ВидЦенности,
	|	Строки.СтавкаНДС                       КАК СтавкаНДС,
	|	Строки.ВидДеятельностиНДС              КАК ВидДеятельностиНДС,
	|	НЕОПРЕДЕЛЕНО                           КАК ИсправленныйСчетФактура,
	|	Строки.РеализацияЭкспорт               КАК РеализацияЭкспорт,
	|	Строки.НаправлениеДеятельности         КАК НаправлениеДеятельности,
	|	Строки.СуммаБезНДС                     КАК СуммаБезНДС,
	|	Строки.НДС                             КАК НДС,
	|	ВЫБОР 
	|		КОГДА &УправленческийУчетОрганизаций
	|			ТОГДА Строки.НДСУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ                                  КАК НДСУпр,
	|	ЗНАЧЕНИЕ(Перечисление.СобытияНДСПредъявленный.СписаниеНДСНаРасходы) КАК Событие,
	|	НЕОПРЕДЕЛЕНО                           КАК КорВидДеятельностиНДС,
	|	Операция.Подразделение                 КАК Подразделение,
	|	Операция.СтатьяРасходов                КАК СтатьяРасходов,
	|	Операция.АналитикаРасходов             КАК АналитикаРасходов,
	|	""""                                   КАК ИдентификаторСтроки,
	|	ЛОЖЬ                                   КАК РегламентнаяОперация
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеНДСНаРасходы.Ценности КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И Операция.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|	И (Строки.НДС <> 0 ИЛИ Строки.НДСУпр <> 0)
	|	
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

//++ НЕ УТ

Функция ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Операция.Дата                          КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	Операция.Организация                   КАК Организация,
	|	Операция.Подразделение                 КАК Подразделение,
	|	Операция.СтатьяРасходов                КАК СтатьяРасходов,
	|	Операция.АналитикаРасходов             КАК АналитикаРасходов,
	|
	|	0                                      КАК Сумма,
	|	0                                      КАК СуммаБезНДС,
	|	Операция.СуммаНДС                      КАК СуммаРегл,
	|	ВЫБОР 
	|		КОГДА &УправленческийУчетОрганизаций
	|			ТОГДА Операция.СуммаНДСУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ                                  КАК СуммаУпр,
	|	ВЫБОР 
	|		КОГДА НЕ Статьи.ПринятиеКналоговомуУчету ТОГДА
	|			Операция.СуммаНДС 
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ                                  КАК ПостояннаяРазница,
	|	0                                     КАК ВременнаяРазница,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеНДСНаРасходы) КАК ХозяйственнаяОперация
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК Статьи
	|	ПО Операция.СтатьяРасходов = Статьи.Ссылка
	|
	|
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И &ИспользоватьУчетПрочихДоходовРасходов
	|";

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти

#КонецОбласти

#КонецЕсли