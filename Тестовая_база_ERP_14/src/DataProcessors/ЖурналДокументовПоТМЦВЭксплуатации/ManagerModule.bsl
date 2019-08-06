#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Определяет состав документов и хозяйственных операций, доступных для отображения в рабочем месте.
//
// Параметры:
//  ХозяйственныеОперацииИДокументы	 - ТаблицаЗначений - таблица значений с колонками:
//     * ХозяйственнаяОперация					 - ПеречислениеСсылка.ХозяйственныеОперации
//     * ИдентификаторОбъектаМетаданных			 - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//     * Отбор									 - Булево
//     * ДокументПредставление					 - Строка
//     * ПолноеИмяДокумента						 - Строка
//     * Накладная								 - Булево
//     * ИспользуетсяРаспоряжение				 - Булево
//     * ИспользуютсяСтатусы					 - Булево
//     * ПоНесколькимЗаказам					 - Булево
//     * ПриходныйОрдерНевозможен				 - Булево
//     * РазделятьДокументыПоПодразделению		 - Булево
//     * ПолноеИмяНакладной						 - Строка
//     * КлючНазначенияИспользования			 - Строка
//     * ПравоДоступаДобавление					 - Булево
//     * ПравоДоступаИзменение					 - Булево
//     * ЗаголовокРабочегоМеста					 - Строка
//     * ИменаЭлементовСУправляемойВидимостью	 - Строка
//     * ИменаЭлементовРабочегоМеста			 - Строка
//     * ИменаОтображаемыхЭлементов				 - Строка
//     * МенеджерРасчетаГиперссылкиКОформлению	 - Строка
//  ОтборХозяйственныеОперации		 - СписокЗначений - список значений типа ПеречислениеСсылка.ХозяйственныеОперации
//  ОтборТипыДокументов				 - СписокЗначений - список значений типа СправочникСсылка.ИдентификаторыОбъектовМетаданных
//  КлючНазначенияИспользования		 - Строка - ключ рабочего места для которого вызывается функция
//  ДокументыКОформлению			 - Булево - признак вызова метода для формы "ФормаСпискаКОформлению".
// 
// Возвращаемое значение:
//   - ТаблицаЗначений - таблица значений с колонками:
//     * ХозяйственнаяОперация					 - ПеречислениеСсылка.ХозяйственныеОперации
//     * ИдентификаторОбъектаМетаданных			 - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//     * Отбор									 - Булево
//     * ДокументПредставление					 - Строка
//     * ПолноеИмяДокумента						 - Строка
//     * Накладная								 - Булево
//     * ИспользуетсяРаспоряжение				 - Булево
//     * ИспользуютсяСтатусы					 - Булево
//     * ПоНесколькимЗаказам					 - Булево
//     * ПриходныйОрдерНевозможен				 - Булево
//     * РазделятьДокументыПоПодразделению		 - Булево
//     * ПолноеИмяНакладной						 - Строка
//     * КлючНазначенияИспользования			 - Строка
//     * ПравоДоступаДобавление					 - Булево
//     * ПравоДоступаИзменение					 - Булево
//     * ЗаголовокРабочегоМеста					 - Строка
//     * ИменаЭлементовСУправляемойВидимостью	 - Строка
//     * ИменаЭлементовРабочегоМеста			 - Строка
//     * ИменаОтображаемыхЭлементов				 - Строка
//     * МенеджерРасчетаГиперссылкиКОформлению	 - Строка.
//
//
Функция ИнициализироватьХозяйственныеОперацииИДокументы(ХозяйственныеОперацииИДокументы, ОтборХозяйственныеОперации, ОтборТипыДокументов, КлючНазначенияИспользования, ДокументыКОформлению = Ложь) Экспорт
	
	// ВнутреннееПотреблениеТоваров
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию;
	Строка.ТипДокумента                 = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ВнутреннееПотреблениеТоваров.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Передача';
												|en = 'Transfer'");
	Строка.ГруппаКнопок                 = "ПередачаВЭксплуатацию";
	Строка.Порядок                      = 2;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// ЗаказНаВнутреннееПотребление
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию;
	Строка.ТипДокумента                 = Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ЗаказНаВнутреннееПотребление.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Заказ';
												|en = 'Order'");
	Строка.ГруппаКнопок                 = "ПередачаВЭксплуатацию";
	Строка.Порядок                      = 1;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// ПеремещениеВЭксплуатации
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПеремещениеВЭксплуатации;
	Строка.ТипДокумента                 = Тип("ДокументСсылка.ПеремещениеВЭксплуатации");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПеремещениеВЭксплуатации.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Перемещение';
												|en = 'Transfer'");
	Строка.ГруппаКнопок                 = "ПеремещениеВЭксплуатации";
	Строка.Порядок                      = 3;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// ПрочееОприходованиеТоваров
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации;
	Строка.ТипДокумента                 = Тип("ДокументСсылка.ПрочееОприходованиеТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПрочееОприходованиеТоваров.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Возврат';
												|en = 'Return'");
	Строка.ГруппаКнопок                 = "ПеремещениеВЭксплуатации";
	Строка.Порядок                      = 5;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// НаработкаТМЦВЭксплуатации
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.НаработкаТМЦВЭксплуатации;
	Строка.ТипДокумента                 = Тип("ДокументСсылка.НаработкаТМЦВЭксплуатации");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.НаработкаТМЦВЭксплуатации.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Наработка';
												|en = 'Running time'");
	Строка.ГруппаКнопок                 = "НаработкаТМЦВЭксплуатации";
	Строка.Порядок                      = 6;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// СписаниеИзЭксплуатации
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.СписаниеИзЭксплуатации;
	Строка.ТипДокумента                 = Тип("ДокументСсылка.СписаниеИзЭксплуатации");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.СписаниеИзЭксплуатации.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Списание';
												|en = 'Write-off'");
	Строка.ГруппаКнопок                 = "ПеремещениеВЭксплуатации";
	Строка.Порядок                      = 4;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	ТаблицаЗначенийДоступно = ОбщегоНазначенияУТ.ДоступныеХозяйственныеОперацииИДокументы(
								ХозяйственныеОперацииИДокументы, 
								ОтборХозяйственныеОперации, 
								ОтборТипыДокументов, 
								КлючНазначенияИспользования);
	
	Возврат ТаблицаЗначенийДоступно;
		
КонецФункции

#Область Команды

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.МестоРазмещения = "СписокПодменюОтчеты";
		КомандаОтчет.Важность = "СмТакже";
		КомандаОтчет.ИмяСписка = "Список";
		КомандаОтчет.ВидимостьВФормах = "ДокументыТМЦВЭксплуатации";
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КлючНазначенияФормыПоУмолчанию() Экспорт
	
	Возврат "ДокументыОС";
	
КонецФункции

#КонецОбласти

#КонецЕсли
