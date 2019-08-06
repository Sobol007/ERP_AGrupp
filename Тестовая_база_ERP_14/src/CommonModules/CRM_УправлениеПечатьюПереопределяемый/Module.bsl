////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Вызывается из ОбщегоНазначения.НастройкиФорматовСохраненияТабличногоДокумента().
// Используется в случае, когда необходимо сократить список форматов сохранения, предлагаемый пользователю
// перед сохранением печатной формы в файл, либо перед отправкой по почте.
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений - коллекция форматов сохранения:
//   * ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента - значение в платформе, соответствующее формату;
//   * Ссылка        - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//   * Представление - Строка - представление типа файла (заполняется из перечисления);
//   * Расширение    - Строка - тип файла для операционной системы;
//   * Картинка      - Картинка - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
// Используется для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. Например, если нужны свои команды,
// которых нет в других объектах.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	// +CRM
	Если СтрНайти(ИмяФормы, "Документ.КоммерческоеПредложениеКлиенту.Форма.CRM_") > 0 Тогда
	
		СтандартнаяОбработка = Ложь;
		CRM_МетодыМодулейМенеджеровДокументов.КП_ДобавитьКомандыПечати(КомандыПечати);
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяФормы).Родитель();
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
			МодульДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, ОбъектМетаданных.ПолноеИмя());
		КонецЕсли;
		
	КонецЕсли;
	// -CRM
КонецПроцедуры

// Дополнительные настройки списка команд печати.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Значение по умолчанию: Истина.
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
КонецПроцедуры

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.CRM_РассылкаЭлектронныхПисем);
	СписокОбъектов.Добавить(Документы.CRM_Телемаркетинг);
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		СписокОбъектов.Добавить(Документы.КоммерческоеПредложениеКлиенту);
		СписокОбъектов.Добавить(Документы["CRM_СчетНаОплатуПокупателю"]);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// 
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	// +CRM
	Если МассивОбъектов.Количество() > 0 Тогда
		Если ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.КоммерческоеПредложениеКлиенту") Тогда
			Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КоммерческоеПредложение") Тогда
				УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КоммерческоеПредложение", НСтр("ru='Коммерческое предложение';en='Commercial Proposal'"),
					CRM_МетодыМодулейМенеджеровДокументов.КП_СформироватьПечатнуюФормуКоммерческогоПредложения(МассивОбъектов, ОбъектыПечати, Неопределено, ПараметрыПечати));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// -CRM
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
//
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	// +CRM
	CRM_Тема = "";
	Если ТипЗнч(ОбъектыПечати)=Тип("Массив") И ОбъектыПечати.Количество() > 0 Тогда
		
		ОбъектПечати = ОбъектыПечати[0];
		Если ОбъектыПечати.Количество()= 1 Тогда
			CRM_Тема = Строка(ОбъектПечати);
		КонецЕсли;
		
		CRM_ДокументОснованиеВходящее = "";
		
		МетаданныеДокумента = ОбъектПечати.Метаданные();
		
		МассивРеквизитов = Новый Массив;
		Для Каждого Реквизит Из МетаданныеДокумента.Реквизиты Цикл
			Если Метаданные.КритерииОтбора.СвязанныеДокументы.Состав.Содержит(Реквизит) Тогда
				МассивРеквизитов.Добавить(Реквизит.Имя);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
			Если ЗначениеЗаполнено(ОбъектПечати[ИмяРеквизита])
			И ТипЗнч(ОбъектПечати[ИмяРеквизита]) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
				
				CRM_ДокументОснованиеВходящее = ОбъектПечати[ИмяРеквизита];
				
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ОбъектыПечати.Количество() = 1 Тогда
			Попытка
				ДокументОснование = ОбъектПечати.Ссылка;
			Исключение
				Если CRM_МетодыОбщихФормСервер.ПроверитьЭтоСсылка(ТипЗнч(ОбъектыПечати)) Тогда
					ДокументОснование = ОбъектыПечати;
				ИначеЕсли ТипЗнч(ОбъектыПечати) = Тип("Массив") Тогда
					Если ОбъектыПечати.Количество() > 0 И CRM_МетодыОбщихФормСервер.ПроверитьЭтоСсылка(ТипЗнч(ОбъектПечати)) Тогда
						ДокументОснование = ОбъектПечати;
					Иначе
						ДокументОснование = Неопределено;
					КонецЕсли;
				Иначе
					ДокументОснование = Неопределено;
				КонецЕсли;
			КонецПопытки;
		Иначе
			ДокументОснование = Неопределено;
		КонецЕсли;
	Иначе
		ДокументОснование = Неопределено;
		CRM_ДокументОснованиеВходящее = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(CRM_ДокументОснованиеВходящее) Тогда
		ПараметрыОтправки.Текст = CRM_ДокументОснованиеВходящее;
	КонецЕсли;
	ПараметрыОтправки.Вставить("Тема", ?(ЗначениеЗаполнено(CRM_Тема), CRM_Тема, ПараметрыОтправки.Тема));
	ПараметрыОтправки.Вставить("Отправитель", "ОтправкаПечатнойФормы");
	ПараметрыОтправки.Вставить("Основание", ДокументОснование);
	// -CRM
КонецПроцедуры

#КонецОбласти
