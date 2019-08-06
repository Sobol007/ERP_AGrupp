
#Область ПрограммныйИнтерфейс

// Заполняет список обработчиков текущих дел.
//
// Параметры:
//  Обработчики - Массив - массив ссылок на модули менеджеров или общие модули, в которых
//                         определена процедура ПриЗаполненииСпискаТекущихДел.
//
Процедура ПриОпределенииОбработчиковТекущихДел(Обработчики) Экспорт
	
	Обработчики.Добавить(Справочники.СделкиСКлиентами);
	
	Обработчики.Добавить(Справочники.СоглашенияСКлиентами);
	
	// СоглашенияСПоставщиками (2ч)
	Обработчики.Добавить(Справочники.СоглашенияСПоставщиками);
	
	// ДоговорыСКлиентами (2ч)
	// ДоговорыСПоставщиками (2ч)
	Обработчики.Добавить(Справочники.ДоговорыКонтрагентов);
	
	// КоммерческиеПредложенияКлиентам (2ч)
	Обработчики.Добавить(Документы.КоммерческоеПредложениеКлиенту);
	
	// ЗаказыКлиентов (4ч)
	Обработчики.Добавить(Документы.ЗаказКлиента);
	
	// ЗаявкиНаВозвратТоваровОтКлиентов (4ч)
	Обработчики.Добавить(Документы.ЗаявкаНаВозвратТоваровОтКлиента);
	
	// РаспоряженияНаПоступление (1т)
	Обработчики.Добавить(Обработки.УправлениеПоступлением);
	
	// РаспоряженияНаОтгрузку (1т)
	Обработчики.Добавить(Обработки.УправлениеОтгрузкой);
	
	// ЗаказыПоставщикам (4ч)
	Обработчики.Добавить(Документы.ЗаказПоставщику);
	
	// ЗаявкиНаОплату (2ч)
	Обработчики.Добавить(Документы.ЗаявкаНаРасходованиеДенежныхСредств);
	
	// ЗаданияТорговымПредставителям (3ч)
	Обработчики.Добавить(Документы.ЗаданиеТорговомуПредставителю);
	
	// ДоверенностиНаПолучениеТоваров (4ч)
	Обработчики.Добавить(Документы.ДоверенностьВыданная);
	
	// ДоверенностиНаПолучениеТоваров (4ч)
	Обработчики.Добавить(Документы.УведомлениеОЗачисленииВалюты);
	
	// ПеремещенияТоваров (2ч)
	Обработчики.Добавить(Документы.ПеремещениеТоваров);
	
	// ОформлениеСкладскихАктов (1ч)
	Обработчики.Добавить(Обработки.ЖурналСкладскихАктов);
	
	// ОтчетыКомиссионеров (1ч)
	Обработчики.Добавить(ЖурналыДокументов.ОтчетыКомиссионеров);
	
	// ОтчетыКомитентам (1ч)
	Обработчики.Добавить(ЖурналыДокументов.ОтчетыКомитентам);
	
	// ВнутренниеПотребленияТоваров (3ч)
	Обработчики.Добавить(Документы.ВнутреннееПотреблениеТоваров);
	
	// ДокументыСборкиРазборки (3ч)
	Обработчики.Добавить(Документы.СборкаТоваров);
	
	// ДокументыПоступленияТоваровИУслуг (1ч)
	Обработчики.Добавить(Документы.ПриобретениеТоваровУслуг);
	
	// ДокументыРеализацииТоваровИУслуг (4ч)
	Обработчики.Добавить(Документы.РеализацияТоваровУслуг);
	
	// ПланыЗакупок (1ч)
	Обработчики.Добавить(Документы.ПланЗакупок);
	
	// ПланыОстатков (1ч)
	Обработчики.Добавить(Документы.ПланОстатков);
	
	// ПланыПродаж (1ч)
	Обработчики.Добавить(Документы.ПланПродаж);
	
	Обработчики.Добавить(Документы.ПланПродажПоКатегориям);
	
	// ПланыСборкиРазборки (1ч)
	Обработчики.Добавить(Документы.ПланСборкиРазборки);
	
	//++ НЕ УТ
	// ПередачаМатериаловВПроизводство (3ч)
	Обработчики.Добавить(Документы.ПередачаМатериаловВПроизводство);
	
	// ПланыПроизводства (1ч)
	Обработчики.Добавить(Документы.ПланПроизводства);
	
	ЗарплатаКадры.ПриОпределенииОбработчиковТекущихДел(Обработчики);
	//-- НЕ УТ
	//++ НЕ УТКА
	// (2т)
	Обработчики.Добавить(Обработки.ДоступностьВидовРабочихЦентров);
	
	// МаршрутныеЛисты (1т)
	Обработчики.Добавить(Обработки.ДиспетчированиеПроизводства);
	
	// ЗаказыНаПроизводство (2ч)
	Обработчики.Добавить(Документы.ЗаказНаПроизводство);
	
	//-- НЕ УТКА
	
	//++ НЕ УТ
	// ДокументыДвиженияПродукцииИМатериалов (1ч)
	Обработчики.Добавить(Документы.ДвижениеПродукцииИМатериалов);
	
	// ДокументыВыпускаПродукции (1ч)
	Обработчики.Добавить(Документы.ВыпускПродукции);
	
	// ВыработкаСотрудников (1ч)
	Обработчики.Добавить(Документы.ВыработкаСотрудников);
	//++ НЕ УТКА
	// (1ч)
	Обработчики.Добавить(Документы.ЗаказПереработчику);
	//-- НЕ УТКА
	
	// ДокументыПередачиТоваровХранителю (4ч)
	Обработчики.Добавить(Документы.ПередачаТоваровХранителю);
	
	// (2ч)
	Обработчики.Добавить(Документы.ПередачаСырьяПереработчику);
	
	// (1ч)
	Обработчики.Добавить(Документы.ПоступлениеОтПереработчика);
	
	// (1ч)
	Обработчики.Добавить(Документы.ОтчетПереработчика);
	//-- НЕ УТ
	//++ НЕ УТКА
	// (1ч)
	Обработчики.Добавить(Документы.ПоступлениеСырьяОтДавальца);
	
	// (2ч)
	Обработчики.Добавить(Документы.ПередачаДавальцу);
	
	// (1ч)
	Обработчики.Добавить(Документы.ОтчетДавальцу);
	
	// Задачи бюджетирования
	Обработчики.Добавить(Задачи.БюджетнаяЗадача);
	//-- НЕ УТКА
	
	// ДокументыПоступленияТоваров (1ч)
	Обработчики.Добавить(Документы.ПоступлениеТоваровНаСклад);
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПриОпределенииОбработчиковТекущихДел(Обработчики);
	// Конец ИнтернетПоддержкаПользователей
	
КонецПроцедуры

#КонецОбласти
