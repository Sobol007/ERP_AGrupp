
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ЗначениеОтбора;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокРаспоряжений();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Элементы.СписокРаспоряжений.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ОбщегоНазначенияУТКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.СписокРаспоряжений) Тогда
		Закрыть(Элементы.СписокРаспоряжений.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Заказы.Ссылка КАК Ссылка,
	|	ТИПЗНАЧЕНИЯ(Заказы.Ссылка) КАК ТипРаспоряжения,
	|	Заказы.Дата КАК Дата,
	|	Заказы.Номер КАК Номер,
	|	Заказы.Партнер КАК Партнер,
	|	Заказы.Контрагент КАК Контрагент,
	|	Заказы.Договор КАК Договор,
	|	Заказы.Соглашение КАК Соглашение,
	|	Заказы.Организация КАК Организация,
	|	Заказы.Склад КАК Склад,
	|	Заказы.Валюта КАК Валюта,
	|	Заказы.Менеджер КАК Менеджер,
	|	Заказы.Статус КАК Статус,
	|	Заказы.СуммаДокумента КАК СуммаДокумента,
	|	Заказы.Приоритет КАК Приоритет,
	|	Заказы.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Заказы.НалогообложениеНДС КАК НалогообложениеНДС,
	|	Заказы.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	Заказы.ПорядокРасчетов КАК ПорядокРасчетов,
	|	Заказы.Комментарий КАК Комментарий,
	|	ВЫБОР
	|		КОГДА Заказы.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА 0
	|		КОГДА Заказы.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КартинкаПриоритета
	|ИЗ
	|	Документ.ЗаказКлиента КАК Заказы
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТаблицаЗаказы.ЗаказКлиента КАК ЗаказКлиента,
	|			СУММА(ТаблицаЗаказы.КОформлению) КАК КОформлению
	|		ИЗ
	|			(ВЫБРАТЬ
	|				ЗаказыОстатки.ЗаказКлиента КАК ЗаказКлиента,
	|				ЗаказыОстатки.КОформлениюОстаток КАК КОформлению
	|			ИЗ
	|				РегистрНакопления.ЗаказыКлиентов.Остатки(
	|						,
	|						ЗаказКлиента.Организация = &Организация
	|							И ЗаказКлиента.Валюта = &Валюта
	|							И ЗаказКлиента.Контрагент = &Контрагент
	|							И ЗаказКлиента.Договор = &Договор
	|							И ЗаказКлиента.НалогообложениеНДС = &НалогообложениеНДС
	|							И ЗаказКлиента.Партнер = &Партнер
	|							И ВЫБОР
	|								КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|									ТОГДА ИСТИНА
	|								ИНАЧЕ ЗаказКлиента.Соглашение = &Соглашение
	|							КОНЕЦ
	|							И ЗаказКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|							И ЗаказКлиента.ПорядокРасчетов = &ПорядокРасчетов
	|							И ЗаказКлиента.Сделка = &Сделка
	|							И ЗаказКлиента.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|							И ЗаказКлиента.ТребуетсяЗалогЗаТару = &ТребуетсяЗалогЗаТару
	|							И Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|							И ВЫБОР
	|								КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|									ТОГДА ИСТИНА
	|								ИНАЧЕ ЗаказКлиента.НаправлениеДеятельности = &НаправлениеДеятельности
	|							КОНЕЦ
	|							И (Склад = &Склад
	|								ИЛИ Склад В ИЕРАРХИИ (&Склад)
	|								ИЛИ Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК ЗаказыОстатки
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|			ВЫБРАТЬ
	|				ЗаказКлиента.Ссылка,
	|				ЗаказКлиентаТовары.Количество
	|			ИЗ
	|				Документ.ЗаказКлиента КАК ЗаказКлиента
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|					ПО ЗаказКлиента.Ссылка = ЗаказКлиентаТовары.Ссылка
	|			ГДЕ
	|				ЗаказКлиента.Организация = &Организация
	|				И ЗаказКлиента.Валюта = &Валюта
	|				И ЗаказКлиента.Контрагент = &Контрагент
	|				И ЗаказКлиента.Договор = &Договор
	|				И ЗаказКлиента.НалогообложениеНДС = &НалогообложениеНДС
	|				И ЗаказКлиента.Партнер = &Партнер
	|				И ВЫБОР
	|						КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЗаказКлиента.Соглашение = &Соглашение
	|					КОНЕЦ
	|				И ЗаказКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|				И ЗаказКлиента.ПорядокРасчетов = &ПорядокРасчетов
	|				И ЗаказКлиента.Сделка = &Сделка
	|				И ЗаказКлиента.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|				И ЗаказКлиента.ТребуетсяЗалогЗаТару = &ТребуетсяЗалогЗаТару
	|				И ЗаказКлиентаТовары.Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|				И (ЗаказКлиента.Склад = &Склад
	|						ИЛИ ЗаказКлиента.Склад В ИЕРАРХИИ (&Склад)
	|						ИЛИ ЗаказКлиента.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|				И ВЫБОР
	|					КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЗаказКлиента.НаправлениеДеятельности = &НаправлениеДеятельности
	|				КОНЕЦ
	|				И НЕ ЗаказКлиентаТовары.Отменено
	|				И НЕ &ИспользоватьРасширенныеВозможностиЗаказаКлиента
	|				И НЕ ЗаказКлиента.ПометкаУдаления
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|			ВЫБРАТЬ
	|				ЗаказыДвижения.ЗаказКлиента,
	|				ВЫБОР
	|					КОГДА ЗаказыДвижения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|						ТОГДА -ЗаказыДвижения.КОформлению
	|					ИНАЧЕ ЗаказыДвижения.КОформлению
	|				КОНЕЦ
	|			ИЗ
	|				РегистрНакопления.ЗаказыКлиентов КАК ЗаказыДвижения
	|			ГДЕ
	|				ЗаказыДвижения.Регистратор = &Регистратор
	|				И ЗаказыДвижения.Активность
	|				И ЗаказыДвижения.ЗаказКлиента.Организация = &Организация
	|				И ЗаказыДвижения.ЗаказКлиента.Валюта = &Валюта
	|				И ЗаказыДвижения.ЗаказКлиента.Контрагент = &Контрагент
	|				И ЗаказыДвижения.ЗаказКлиента.Договор = &Договор
	|				И ЗаказыДвижения.ЗаказКлиента.НалогообложениеНДС = &НалогообложениеНДС
	|				И ЗаказыДвижения.ЗаказКлиента.Партнер = &Партнер
	|				И ВЫБОР
	|						КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЗаказыДвижения.ЗаказКлиента.Соглашение = &Соглашение
	|					КОНЕЦ
	|				И ЗаказыДвижения.ЗаказКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|				И ЗаказыДвижения.ЗаказКлиента.ПорядокРасчетов = &ПорядокРасчетов
	|				И ЗаказыДвижения.ЗаказКлиента.Сделка = &Сделка
	|				И ЗаказыДвижения.ЗаказКлиента.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|				И ЗаказыДвижения.ЗаказКлиента.ТребуетсяЗалогЗаТару = &ТребуетсяЗалогЗаТару
	|				И ЗаказыДвижения.Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|				И ВЫБОР
	|					КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЗаказыДвижения.ЗаказКлиента.НаправлениеДеятельности = &НаправлениеДеятельности
	|				КОНЕЦ
	|				И (ЗаказыДвижения.Склад = &Склад
	|						ИЛИ ЗаказыДвижения.Склад В ИЕРАРХИИ (&Склад)
	|						ИЛИ ЗаказыДвижения.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК ТаблицаЗаказы
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТаблицаЗаказы.ЗаказКлиента) КАК ТаблицаЗаказы
	|		ПО Заказы.Ссылка = ТаблицаЗаказы.ЗаказКлиента
	|ГДЕ
	|	ТаблицаЗаказы.КОформлению > 0
	|	//УсловиеХозяйственнойОперацииЗаказы
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Заявки.Ссылка,
	|	ТИПЗНАЧЕНИЯ(Заявки.Ссылка),
	|	Заявки.Дата,
	|	Заявки.Номер,
	|	Заявки.Партнер,
	|	Заявки.Контрагент,
	|	Заявки.Договор,
	|	Заявки.Соглашение,
	|	Заявки.Организация,
	|	Заявки.Склад,
	|	Заявки.Валюта,
	|	Заявки.Менеджер,
	|	Заявки.Статус,
	|	Заявки.СуммаДокумента,
	|	Заявки.Приоритет,
	|	Заявки.ХозяйственнаяОперация,
	|	Заявки.НалогообложениеНДС,
	|	Заявки.ЦенаВключаетНДС,
	|	Заявки.ПорядокРасчетов,
	|	Заявки.Комментарий,
	|	ВЫБОР
	|		КОГДА Заявки.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА 0
	|		КОГДА Заявки.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК Заявки
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТаблицаЗаказы.ЗаказКлиента КАК ЗаказКлиента,
	|			СУММА(ТаблицаЗаказы.КОформлению) КАК КОформлению
	|		ИЗ
	|			(ВЫБРАТЬ
	|				ЗаказыОстатки.ЗаказКлиента КАК ЗаказКлиента,
	|				ЗаказыОстатки.КОформлениюОстаток КАК КОформлению
	|			ИЗ
	|				РегистрНакопления.ЗаказыКлиентов.Остатки(
	|						,
	|						ЗаказКлиента.Организация = &Организация
	|							И ЗаказКлиента.Валюта = &Валюта
	|							И ЗаказКлиента.Контрагент = &Контрагент
	|							И ЗаказКлиента.Договор = &Договор
	|							И ЗаказКлиента.НалогообложениеНДС = &НалогообложениеНДС
	|							И ЗаказКлиента.Партнер = &Партнер
	|							И ВЫБОР
	|								КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|									ТОГДА ИСТИНА
	|								ИНАЧЕ ЗаказКлиента.Соглашение = &Соглашение
	|							КОНЕЦ
	|							И ЗаказКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|							И ЗаказКлиента.ПорядокРасчетов = &ПорядокРасчетов
	|							И ЗаказКлиента.Сделка = &Сделка
	|							И ЗаказКлиента.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|							И ЗаказКлиента.ТребуетсяЗалогЗаТару = &ТребуетсяЗалогЗаТару
	|							И Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|							И ВЫБОР
	|								КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|									ТОГДА ИСТИНА
	|								ИНАЧЕ ЗаказКлиента.НаправлениеДеятельности = &НаправлениеДеятельности
	|							КОНЕЦ
	|							И (Склад = &Склад
	|								ИЛИ Склад В ИЕРАРХИИ (&Склад)
	|								ИЛИ Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК ЗаказыОстатки
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|			ВЫБРАТЬ
	|				ЗаказКлиента.Ссылка,
	|				ЗаказКлиентаТовары.Количество
	|			ИЗ
	|				Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЗаменяющиеТовары КАК ЗаказКлиентаТовары
	|					ПО ЗаказКлиента.Ссылка = ЗаказКлиентаТовары.Ссылка
	|			ГДЕ
	|				ЗаказКлиента.Организация = &Организация
	|				И ЗаказКлиента.Валюта = &Валюта
	|				И ЗаказКлиента.Контрагент = &Контрагент
	|				И ЗаказКлиента.Договор = &Договор
	|				И ЗаказКлиента.НалогообложениеНДС = &НалогообложениеНДС
	|				И ЗаказКлиента.Партнер = &Партнер
	|				И ВЫБОР
	|						КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЗаказКлиента.Соглашение = &Соглашение
	|					КОНЕЦ
	|				И ЗаказКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|				И ЗаказКлиента.ПорядокРасчетов = &ПорядокРасчетов
	|				И ЗаказКлиента.Сделка = &Сделка
	|				И ЗаказКлиента.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|				И ЗаказКлиентаТовары.Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|				И (ЗаказКлиента.Склад = &Склад
	|						ИЛИ ЗаказКлиента.Склад В ИЕРАРХИИ (&Склад)
	|						ИЛИ ЗаказКлиента.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|				И ВЫБОР
	|					КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЗаказКлиента.НаправлениеДеятельности = &НаправлениеДеятельности
	|				КОНЕЦ
	|				И НЕ ЗаказКлиентаТовары.Отменено
	|				И НЕ &ИспользоватьРасширенныеВозможностиЗаказаКлиента
	|				И НЕ ЗаказКлиента.ПометкаУдаления
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|			ВЫБРАТЬ
	|				ЗаказыДвижения.ЗаказКлиента,
	|				ВЫБОР
	|					КОГДА ЗаказыДвижения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|						ТОГДА -ЗаказыДвижения.КОформлению
	|					ИНАЧЕ ЗаказыДвижения.КОформлению
	|				КОНЕЦ
	|			ИЗ
	|				РегистрНакопления.ЗаказыКлиентов КАК ЗаказыДвижения
	|			ГДЕ
	|				ЗаказыДвижения.Регистратор = &Регистратор
	|				И ЗаказыДвижения.Активность
	|				И ЗаказыДвижения.ЗаказКлиента.Организация = &Организация
	|				И ЗаказыДвижения.ЗаказКлиента.Валюта = &Валюта
	|				И ЗаказыДвижения.ЗаказКлиента.Контрагент = &Контрагент
	|				И ЗаказыДвижения.ЗаказКлиента.Договор = &Договор
	|				И ЗаказыДвижения.ЗаказКлиента.НалогообложениеНДС = &НалогообложениеНДС
	|				И ЗаказыДвижения.ЗаказКлиента.Партнер = &Партнер
	|				И ВЫБОР
	|						КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЗаказыДвижения.ЗаказКлиента.Соглашение = &Соглашение
	|					КОНЕЦ
	|				И ЗаказыДвижения.ЗаказКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|				И ЗаказыДвижения.ЗаказКлиента.ПорядокРасчетов = &ПорядокРасчетов
	|				И ЗаказыДвижения.ЗаказКлиента.Сделка = &Сделка
	|				И ЗаказыДвижения.ЗаказКлиента.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|				И ЗаказыДвижения.ЗаказКлиента.ТребуетсяЗалогЗаТару = &ТребуетсяЗалогЗаТару
	|				И ЗаказыДвижения.Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|				И ВЫБОР
	|					КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЗаказыДвижения.ЗаказКлиента.НаправлениеДеятельности = &НаправлениеДеятельности
	|				КОНЕЦ
	|				И (ЗаказыДвижения.Склад = &Склад
	|						ИЛИ ЗаказыДвижения.Склад В ИЕРАРХИИ (&Склад)
	|						ИЛИ ЗаказыДвижения.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК ТаблицаЗаказы
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТаблицаЗаказы.ЗаказКлиента) КАК ТаблицаЗаказы
	|		ПО Заявки.Ссылка = ТаблицаЗаказы.ЗаказКлиента
	|ГДЕ
	|	ТаблицаЗаказы.КОформлению > 0
	|	//УсловиеХозяйственнойОперацииЗаявки";
	
	Запрос.УстановитьПараметр("Организация",				Параметры.Отбор.Организация);
	Запрос.УстановитьПараметр("Контрагент",					Параметры.Отбор.Контрагент);
	Запрос.УстановитьПараметр("Валюта",						Параметры.Отбор.Валюта);
	Запрос.УстановитьПараметр("Партнер",					Параметры.Отбор.Партнер);
	Запрос.УстановитьПараметр("НалогообложениеНДС",			Параметры.Отбор.НалогообложениеНДС);
	Запрос.УстановитьПараметр("Соглашение",					Параметры.Отбор.Соглашение);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС",			Параметры.Отбор.ЦенаВключаетНДС);
	Запрос.УстановитьПараметр("Сделка",						Параметры.Отбор.Сделка);
	Запрос.УстановитьПараметр("ПорядокРасчетов",			Параметры.Отбор.ПорядокРасчетов);
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару",	Параметры.Отбор.ВернутьМногооборотнуюТару);
	Запрос.УстановитьПараметр("ТребуетсяЗалогЗаТару",		Параметры.Отбор.ТребуетсяЗалогЗаТару);
	Запрос.УстановитьПараметр("Договор",					Параметры.Отбор.Договор);
	Запрос.УстановитьПараметр("НаправлениеДеятельности",	Параметры.Отбор.НаправлениеДеятельности);
		
	Запрос.УстановитьПараметр("Регистратор", Параметры.Регистратор);
	Запрос.УстановитьПараметр("Склад", Параметры.Склад);
	
	Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", 
								ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
	Запрос.УстановитьПараметр("ИспользоватьРасширенныеВозможностиЗаказаКлиента", 
								ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента"));
	Запрос.УстановитьПараметр("ИспользоватьНаправленияДеятельности", 
								ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности"));
	
	Если Параметры.Отбор.Свойство("ХозяйственнаяОперация") Тогда
		
		Если ЗначениеЗаполнено(Параметры.Отбор.ХозяйственнаяОперация) Тогда
			
			СписокОпераций = Документы.РеализацияТоваровУслуг.ДопустимыеОперацииДокументовОснований(Параметры.Отбор.ХозяйственнаяОперация);
			
			Условие = "	И ";
			Запрос.УстановитьПараметр("СписокХозяйственныхОпераций", СписокОпераций);
			
		Иначе
			
			СписокОпераций = Новый СписокЗначений;
			СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
			СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера);
			СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя);
			
			Условие = "	И НЕ ";
			Запрос.УстановитьПараметр("СписокХозяйственныхОпераций", СписокОпераций);
			
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
									"//УсловиеХозяйственнойОперацииЗаказы",
									Условие + "Заказы.ХозяйственнаяОперация В (&СписокХозяйственныхОпераций)");
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
									"//УсловиеХозяйственнойОперацииЗаявки",
									Условие + "Заявки.ХозяйственнаяОперация В (&СписокХозяйственныхОпераций)");
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	СписокРаспоряжений.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти

