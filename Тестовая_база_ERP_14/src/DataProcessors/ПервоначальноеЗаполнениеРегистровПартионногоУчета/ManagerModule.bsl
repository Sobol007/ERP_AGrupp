#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет проведение документов по регистрам партий.
// Параметры:
//	- Параметры - Структура - Результаты работы метода.
//	- АдресХранилища - Строка - Адрес, по которому будет помещены результаты работы.
Процедура ДополнитьДвиженияДокументов(Параметры, АдресХранилища = "") Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Партионный учет сервер.Проведение документов по регистрам партий';
			|en = 'Batch accounting server.Document posting in the batch registers'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, , , НСтр("ru = 'Начато заполнение движений документов по регистрам';
														|en = 'Population of register document register records has started'"), 
		РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);

	ТоварныеРегистры = Новый Массив;
	ТоварныеРегистры.Добавить(Метаданные.РегистрыНакопления.ПартииТоваровОрганизаций);
	ТоварныеРегистры.Добавить(Метаданные.РегистрыНакопления.ПартииТоваровПереданныеНаКомиссию);
	ТоварныеРегистры.Добавить(Метаданные.РегистрыНакопления.ТоварыОрганизаций);
	
	РегистрыРасходов = Новый Массив;
	РегистрыРасходов.Добавить(Метаданные.РегистрыНакопления.ПрочиеРасходы);

	ПропускаемыеИмена = ПропускаемыеИменаДокументов();
	ТоварныеРегистраторы = СоставРегистраторов(ТоварныеРегистры, ПропускаемыеИмена);
	РегистраторыРасходов = СоставРегистраторов(РегистрыРасходов, ПропускаемыеИмена);
	
	ПериодДокументов = Новый Структура("Начало, Конец", Неопределено, Неопределено);
	ПериодДокументов(ТоварныеРегистраторы, ПериодДокументов);
	ПериодДокументов(РегистраторыРасходов, ПериодДокументов);
	
	Если Не ЗначениеЗаполнено(ПериодДокументов.Начало) Тогда
		Параметры.Вставить("ЗагрузкаВыполнена", Ложь);
		Параметры.Вставить("ТекстСообщения", НСтр("ru = 'В базе отсутствуют документы для проведения по регистрам партий';
													|en = 'Documents for posting for batch registers are missing in the base'"));
	Иначе
		МесяцПроведения = НачалоМесяца(ПериодДокументов.Начало);
		КонецПериода = КонецМесяца(ПериодДокументов.Конец);
		УстановитьГраницыРасчета(НачалоМесяца(ПериодДокументов.Начало));
		Пока МесяцПроведения < КонецПериода Цикл
			КонецМесяцаПроведения = КонецМесяца(МесяцПроведения);
			
			// последовательность вызовов важна
			ОбработатьТоварныеДокументы(ТоварныеРегистраторы, МесяцПроведения, КонецМесяцаПроведения);
			ОбработатьДокументыРасходов(РегистраторыРасходов, МесяцПроведения, КонецМесяцаПроведения);
				
			МесяцПроведения = ДобавитьМесяц(МесяцПроведения, 1);
		КонецЦикла;
		Параметры.Вставить("ЗагрузкаВыполнена", Истина);
	КонецЕсли;

	Если НЕ ПустаяСтрока(АдресХранилища) Тогда
		ПоместитьВоВременноеХранилище(Параметры, АдресХранилища);
	КонецЕсли;
КонецПроцедуры

// Метод очищает офлайновые регистры партий:
//	- Партии товаров организаций;
//	- Партии товаров переданные на комиссию;
//	- Партии расходов на себестоимость товаров;
//	- Партии затрат на выпуск.
Процедура ОтменаПроведенияДокументовПоРегистрамПартий() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ПартионныйУчет.Выключение партионного учета';
			|en = 'ПартионныйУчет.Disable batch accounting'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru = 'Начата операция отмены проведения документов по регистрам партий';
			|en = 'Cancellation of batch register document posting has started  '"), 
		РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
		
	// Очистка регистров партий
	ОчиститьРегистрПартий("ПартииТоваровОрганизаций");
	ОчиститьРегистрПартий("ПартииТоваровПереданныеНаКомиссию");
	ОчиститьРегистрПартий("ПартииРасходовНаСебестоимостьТоваров");
	ОчиститьРегистрПартий("ПартииЗатратНаВыпуск");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДополнениеДвиженийДокументов

Функция СоставРегистраторов(Регистры, ПропускаемыеИмена = Неопределено, ВключаемыеИмена = Неопределено)
	Состав = Новый Соответствие();
	
	Для Каждого Регистр Из Регистры Цикл
		Регистраторы = Регистр.СтандартныеРеквизиты.Регистратор.Тип.Типы();
		Для Каждого Регистратор Из Регистраторы Цикл
			МетаОбъект = Метаданные.НайтиПоТипу(Регистратор);
			ИмяМетаОбъекта = МетаОбъект.Имя;
			
			Если Неопределено <> ПропускаемыеИмена И ПропускаемыеИмена.Свойство(ИмяМетаОбъекта) Тогда
				Продолжить;
			КонецЕсли;
			
			Если Неопределено <> ВключаемыеИмена И Не ВключаемыеИмена.Свойство(ИмяМетаОбъекта) Тогда
				Продолжить;
			КонецЕсли;
			
			Состав.Вставить(ИмяМетаОбъекта, МетаОбъект);
		КонецЦикла;
	КонецЦикла;

	Возврат Состав;	
КонецФункции

Функция ПропускаемыеИменаДокументов()
	Возврат Новый Структура("
		// Не надо допроводить, есть в УТ11:
		|РаспределениеРасходовБудущихПериодов,
		|РаспределениеДоходовИРасходовПоНаправлениямДеятельности,
		|РасчетСебестоимостиТоваров,
		|КорректировкаРегистров,
		|РаспределениеНДС,
    	// Остается в УП2, не будет в УТ11:
	    |АмортизацияНМА,
	    |АмортизацияОС,
	    |ВосстановлениеНДСПоОбъектамНедвижимости,
	    |РаспределениеПрочихЗатрат,
	    |ОперацияБух,
    	// Будут удалены из УП2/УТ11:
	    |НачислениеНДСпоСМРхозспособом,
	    |ВосстановлениеНДС,
	    |ОтражениеНачисленияНДС,
	    |СписаниеНДС,
	    |ОтражениеНДСКВычету");
КонецФункции

Функция ПериодДокументов(ОписаниеДокументов, ДополняемыйПериод = Неопределено)
	Запрос = Новый Запрос();
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	МИНИМУМ(Операция.Дата) КАК Начало,
		|	МАКСИМУМ(Операция.Дата) КАК КОНЕЦ
		|ИЗ
		|	ИмяДокумента КАК Операция
		|ГДЕ
		|	Операция.Проведен
		|ИМЕЮЩИЕ
		|	НЕ МИНИМУМ(Операция.Дата) ЕСТЬ NULL
		|";
		
	Период = ?(Неопределено = ДополняемыйПериод, Новый Структура("Начало, Конец", Неопределено, Неопределено), ДополняемыйПериод);
	
	Для Каждого Описание Из ОписаниеДокументов Цикл
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "ИмяДокумента", "Документ." + Описание.Ключ);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Период.Начало = ?(ЗначениеЗаполнено(Период.Начало), Мин(Период.Начало, Выборка.Начало), Выборка.Начало);
			Период.Конец = ?(ЗначениеЗаполнено(Период.Конец), Макс(Период.Конец, Выборка.Конец), Выборка.Конец);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Период;
КонецФункции

Процедура ОбработатьТоварныеДокументы(ОписаниеДокументов, НачалоПериода, КонецПериода);
	Запрос = Новый Запрос;
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Дата
	|ИЗ
	|	// получим проведенные доки, не зарегистрированные в измененных/дополненных регистрах
	|	(
	|		// Товары организаций
	|		ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			Операция.Ссылка КАК Ссылка,
	|			Операция.Ссылка.Дата КАК Дата
	|		ИЗ
	|			ИмяДокумента КАК Операция
	|
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрг
	|			ПО Операция.Ссылка = ТоварыОрг.Регистратор
	|				И Операция.Ссылка.Дата = ТоварыОрг.Период
	|		ГДЕ
	|			Операция.Проведен 
	|			И Операция.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|			И ТоварыОрг.Активность
	|
	|		ОБЪЕДИНИТЬ ВСЕ
	|
	|		// Товары организаций к передаче
	|		ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			Операция.Ссылка КАК Ссылка,
	|			Операция.Ссылка.Дата КАК Дата
	|		ИЗ
	|			ИмяДокумента КАК Операция
	|
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизацийКПередаче КАК ТоварыОрг
	|			ПО Операция.Ссылка = ТоварыОрг.Регистратор
	|			И Операция.Ссылка.Дата = ТоварыОрг.Период
	|
	|		ГДЕ 
	|			Операция.Проведен 
	|			И Операция.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|			И ТоварыОрг.Активность
	|
	|		ОБЪЕДИНИТЬ ВСЕ
	|
	|		// Товары организаций к оформлению
	|		ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			Операция.Ссылка КАК Ссылка,
	|			Операция.Ссылка.Дата КАК Дата
	|		ИЗ
	|			ИмяДокумента КАК Операция
	|
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций КАК ТоварыОрг
	|			ПО Операция.Ссылка = ТоварыОрг.Регистратор
	|				И Операция.Ссылка.Дата = ТоварыОрг.Период
	|		ГДЕ
	|			Операция.Проведен 
	|			И Операция.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|			И ТоварыОрг.Активность
	|
	|		ОБЪЕДИНИТЬ ВСЕ
	|
	|		// Партии товаров организаций
	|		ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			Операция.Ссылка КАК Ссылка,
	|			Операция.Ссылка.Дата КАК Дата
	|		ИЗ
	|			ИмяДокумента КАК Операция
	|			
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрг
	|			ПО Операция.Ссылка = ТоварыОрг.Регистратор
	|				И Операция.Ссылка.Дата = ТоварыОрг.Период
	|
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваровОрганизаций КАК ПартииТоваров
	|			ПО Операция.Ссылка = ПартииТоваров.Регистратор
	|				И Операция.Ссылка.Дата = ПартииТоваров.Период
	|
	|		ГДЕ
	|			Операция.Проведен 
	|			И Операция.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|			И ТоварыОрг.Активность
	|			И ПартииТоваров.Регистратор ЕСТЬ NULL
	|			И &ДополнитьАналитику
	|
	|		ОБЪЕДИНИТЬ ВСЕ
	|
	|		// Товары переданные на комиссию
	|		ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			Операция.Ссылка КАК Ссылка,
	|			Операция.Ссылка.Дата КАК Дата
	|		ИЗ
	|			ИмяДокумента КАК Операция
	|
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыПереданныеНаКомиссию КАК ТоварыКомис
	|			ПО Операция.Ссылка = ТоварыКомис.Регистратор
	|				И Операция.Ссылка.Дата = ТоварыКомис.Период
	|		ГДЕ
	|			Операция.Проведен 
	|			И Операция.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|			И ТоварыКомис.Активность
	|
	|		ОБЪЕДИНИТЬ ВСЕ
	|
	|		ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			Операция.Ссылка КАК Ссылка,
	|			Операция.Ссылка.Дата КАК Дата
	|		ИЗ
	|			ИмяДокумента КАК Операция
	|
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыПереданныеНаКомиссию КАК ТоварыКомис
	|			ПО Операция.Ссылка = ТоварыКомис.Регистратор
	|				И Операция.Ссылка.Дата = ТоварыКомис.Период
	|
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваровПереданныеНаКомиссию КАК ПартииКомис
	|			ПО Операция.Ссылка = ПартииКомис.Регистратор
	|				И Операция.Ссылка.Дата = ПартииКомис.Период
	|
	|		ГДЕ
	|			Операция.Проведен 
	|			И Операция.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|			И ТоварыКомис.Активность
	|			И ПартииКомис.Регистратор ЕСТЬ NULL
	|			И &ДополнитьАналитику
	|			И ТИПЗНАЧЕНИЯ(Операция.Ссылка) = ТИП(Документ.ВводОстатков)
	|	) КАК Операция
	|
	|УПОРЯДОЧИТЬ ПО 
	|	Операция.Дата
	|";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	
	РегистрыДополненияДвижений = РегистрыДополненияДвижений();
	// специальная обработка документов поступления
	ДокументыПартий = Метаданные.РегистрыНакопления.ПартииТоваровОрганизаций.Измерения.ДокументПоступления.Тип;
	
	Для Каждого Описание Из ОписаниеДокументов Цикл
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "ИмяДокумента", "Документ." + Описание.Ключ);
		
		ДополнитьАналитику = ДокументыПартий.СодержитТип(Тип("ДокументСсылка." + Описание.Ключ))
			И Описание.Ключ <> "ПеремещениеТоваров"
			И Описание.Ключ <> "ТаможеннаяДекларацияИмпорт";
			
		Запрос.УстановитьПараметр("ДополнитьАналитику", ДополнитьАналитику);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Дополнение движений по партиям';
											|en = 'Batch movement addition'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), , , Выборка.Ссылка);
			ДополнитьДвиженияДокумента(Выборка.Ссылка, РегистрыДополненияДвижений);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ОбработатьДокументыРасходов(ОписаниеДокументов, НачалоПериода, КонецПериода);
	Запрос = Новый Запрос;
	ТекстЗапроса = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Операция.Ссылка КАК Ссылка,
		|	Операция.Ссылка.Дата КАК Дата
		|ИЗ
		|	ИмяДокумента КАК Операция
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходы КАК РасходыПрочие
		|		ПО Операция.Ссылка = РасходыПрочие.Регистратор
		|
		|ГДЕ
		|	Операция.Проведен И Операция.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|	И (РасходыПрочие.СтатьяРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
		|		ИЛИ РасходыПрочие.СтатьяРасходов.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров))
		|УПОРЯДОЧИТЬ ПО
		|	Операция.Ссылка.Дата
		|";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	
	РегистрыДополненияДвижений = РегистрыДополненияДвижений();
	
	Для Каждого Описание Из ОписаниеДокументов Цикл
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "ИмяДокумента", "Документ." + Описание.Ключ);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Дополнение движений по расходам';
											|en = 'Expense movement addition'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), , , Выборка.Ссылка);
			ДополнитьДвиженияДокумента(Выборка.Ссылка, РегистрыДополненияДвижений);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Функция РегистрыДополненияДвижений()
	Регистры = Новый Структура;
	Регистры.Вставить("ТаблицаТоварыОрганизаций", РегистрыНакопления.ТоварыОрганизаций);
	Регистры.Вставить("ТаблицаТоварыПереданныеНаКомиссию", РегистрыНакопления.ТоварыПереданныеНаКомиссию);
	Регистры.Вставить("ТаблицаПартииТоваровОрганизаций", РегистрыНакопления.ПартииТоваровОрганизаций);
	Регистры.Вставить("ТаблицаПартииТоваровПереданныеНаКомиссию", РегистрыНакопления.ПартииТоваровПереданныеНаКомиссию);
	
	Регистры.Вставить("ТаблицаПрочиеРасходы", РегистрыНакопления.ПрочиеРасходы);
	Регистры.Вставить("ТаблицаПартииПрочихРасходов", РегистрыНакопления.ПартииПрочихРасходов);
	
	Возврат Регистры;
КонецФункции

Процедура ДополнитьДвиженияДокумента(Ссылка, РегистрыДополнения)
	Перем Таблица;
	
	ДопСвойства = Новый Структура("ЭтоНовый, РежимЗаписи", Ложь, РежимЗаписиДокумента.Проведение);
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДопСвойства, РежимПроведенияДокумента.Неоперативный);
	Документы[ДопСвойства.ДляПроведения.МетаданныеДокумента.Имя].ИнициализироватьДанныеДокумента(Ссылка, ДопСвойства);
	Таблицы = ДопСвойства.ТаблицыДляДвижений;
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого Регистр Из РегистрыДополнения Цикл
			Если Таблицы.Свойство(Регистр.Ключ, Таблица) Тогда
				ЗаписатьДвиженияВБазу(Регистр.Значение, Таблица, Ссылка);
			КонецЕсли;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗаписатьДвиженияВБазу(МенеджерДвижений, Таблица, Ссылка, ЗаполнятьЦиклом = Ложь, УстановитьАктивность = Истина)
	Набор = МенеджерДвижений.СоздатьНаборЗаписей();
	Набор.Отбор.Регистратор.Установить(Ссылка);
	Набор.Прочитать();
	Если Набор.Количество() > 0 Или Таблица.Количество() > 0 Тогда
		Если ЗаполнятьЦиклом Тогда
			Для Каждого Строка Из Таблица Цикл
				Запись = Набор.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, Строка);
			КонецЦикла;
		Иначе
			Набор.Загрузить(Таблица);
		КонецЕсли;
		Если УстановитьАктивность Тогда
			Набор.УстановитьАктивность(Истина);
		КонецЕсли;
		Набор.Записать();
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьГраницыРасчета(НачалоРасчета)
	
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(НачалоРасчета);
	
КонецПроцедуры

#КонецОбласти

#Область ОтменаПроведенийПоРегистрамПартий

Процедура ОчиститьРегистрПартий(ИмяРегистра)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Регистратор КАК Ссылка
	|ИЗ
	|	ИмяРегистра КАК Регистр
	|";
	
	Запрос = Новый Запрос(СтрЗаменить(ТекстЗапроса,"ИмяРегистра", "РегистрНакопления." + ИмяРегистра));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Набор = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
		Набор.Отбор.Регистратор.Установить(Выборка.Ссылка);
		Набор.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли