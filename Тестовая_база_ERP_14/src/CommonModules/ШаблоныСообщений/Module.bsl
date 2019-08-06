///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает сообщение на основании предмета по шаблону сообщения.
//
// Параметры:
//  Шаблон                   - СправочникСсылка.ШаблоныСообщений - ссылка на шаблон сообщения.
//  Предмет                  - Произвольный - Объект основание для шаблона сообщений, типы объектов перечислены в
//                                            определяемом типе ПредметШаблонаСообщения.
//  УникальныйИдентификатор  - УникальныйИдентификатор - Идентификатор формы, необходим для размещения вложений во
//                                                       временном хранилище при клиент-серверном вызове. Если вызов
//                                                       происходит только на сервере, то можно использовать любой идентификатор.
//  ДополнительныеПараметры  - Структура - Необязательный, список дополнительных параметров, который будет передан в
//                                         параметр Сообщение в процедурах ПриФормированииСообщения при создании сообщения.
//     * ПреобразовыватьHTMLДляФорматированногоДокумента - Булево - необязательный, по умолчанию Ложь, определяет
//                      необходимо ли преобразование HTML текста сообщения содержащего картинки в тексте письма из-за
//                      особенностей вывода изображений в форматированном документе.
// 
// Возвращаемое значение:
//  Структура - подготовленное сообщение на основание шаблона для отправки.
//    * Тема - Строка - тема письма
//    * Текст - Строка - текст письма
//    * Получатель - СписокЗначений - список получателей письма
//    * ДополнительныеПараметры - Структура - параметры шаблона сообщения.
//    * Вложения - ТаблицаЗначений - список вложений 
//       ** Представление - Строка - имя файла вложения.
//       ** АдресВоВременномХранилище - Строка - адрес двоичных данных вложения во временном хранилище.
//       ** Кодировка - Строка - кодировка вложения (используется, если отличается от кодировки письма).
//       ** Идентификатор - Строка - необязательный,  идентификатор вложения, используется для хранения 
//                                   картинок, отображаемых в теле письма.
//
Функция СформироватьСообщение(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОтправки = СформироватьПараметрыОтправки(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры);
	Возврат ШаблоныСообщенийСлужебный.СформироватьСообщение(ПараметрыОтправки);
	
КонецФункции

// Отправляет сообщение почты или SMS на основании предмета по шаблону сообщения.
//
// Параметры:
//  Шаблон                   - СправочникСсылка.ШаблоныСообщений - ссылка на шаблон сообщения.
//  Предмет                  - Произвольный - объект основание для шаблона сообщений, типы объектов перечислены в
//                                            определяемом типе ПредметШаблонаСообщения.
//  УникальныйИдентификатор  - УникальныйИдентификатор - идентификатор формы, необходим для размещения вложений во
//                                                       временном хранилище.
//  ДополнительныеПараметры  - Структура - Необязательный, список дополнительных параметров, который будет передан в
//                                         параметр Сообщение в процедурах ПриФормированииСообщения при создании сообщения.
//     * ПреобразовыватьHTMLДляФорматированногоДокумента - Булево - необязательный, по умолчанию Ложь, определяет,
//                      необходимо ли преобразование HTML-текста сообщения, содержащего картинки в тексте письма, из-за
//                      особенностей вывода изображений в форматированном документе.
// 
// Возвращаемое значение:
//  Структура - результат отправки сообщения.
//   * Отправлено     - Булево - если Истина, то сообщение было успешно отправлено.
//   * ОписаниеОшибки - Строка - содержит описание ошибки, если письмо не было отправлено.
//
Функция СформироватьСообщениеИОтправить(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры = Неопределено) Экспорт
	ПараметрыОтправки = СформироватьПараметрыОтправки(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры);
	Возврат ШаблоныСообщенийСлужебный.СформироватьСообщениеИОтправить(ПараметрыОтправки);
КонецФункции

// Заполняет список реквизитов шаблона сообщений на основание макета СКД.
//
// Параметры:
//  Реквизиты  - ДеревоЗначений - Заполняемый список реквизитов.
//  Макет      - Макет - Макет СКД.
//
Процедура СформироватьСписокРеквизитовПоСКД(Реквизиты, Макет) Экспорт
	ШаблоныСообщенийСлужебный.РеквизитыПоСКД(Реквизиты, Макет);
КонецПроцедуры

// Заполняет список реквизитов шаблона сообщений на основании макета СКД.
//
// Параметры:
//  Реквизиты        - Соответствие - Список реквизитов.
//  Предмет          - Произвольный - Ссылка на объект основание для шаблона сообщений.
//  ПараметрыШаблона - Структура    - Список параметров шаблона, см. функцию ПараметрыШаблона.
//
Процедура ЗаполнитьРеквизитыПоСКД(Реквизиты, Предмет, ПараметрыШаблона) Экспорт
	ШаблоныСообщенийСлужебный.ЗаполнитьРеквизитыПоСКД(Реквизиты, Предмет, ПараметрыШаблона);
КонецПроцедуры

// Создать шаблон сообщения.
//
// Параметры:
//  Наименование     - Строка - наименование шаблона.
//  ПараметрыШаблона - Структура - параметры шаблона сообщения. см. ШаблоныСообщений.ОписаниеПараметровШаблона.
//
// Возвращаемое значение:
//  СправочникСсылка.ШаблоныСообщений - ссылка на созданный шаблон.
//
Функция СоздатьШаблон(Наименование, ПараметрыШаблона) Экспорт
	
	ПараметрыШаблона.Вставить("Наименование", Наименование);
	
	Шаблон = Справочники.ШаблоныСообщений.СоздатьЭлемент();
	Шаблон.Заполнить(ПараметрыШаблона);
	
	Если ОбновлениеИнформационнойБазы.ЭтоВызовИзОбработчикаОбновления() Тогда
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Шаблон, Истина);
	Иначе
		Шаблон.Записать();
	КонецЕсли;
	
	Возврат Шаблон.Ссылка;
	
КонецФункции

// Возвращает описание параметров шаблона.
// 
// Возвращаемое значение:
//  Структура - параметры шаблона.
//   * Наименование - Строка - наименование шаблона сообщений.
//   * Текст        - Строка - текст шаблона письма или сообщения SMS.
//   * Тема         - Строка - текст темы письма. Только для шаблонов электронной почты.
//   * ТипШаблона   - Строка - тип шаблона. Варианты: "Письмо","SMS".
//   * Назначение   - Строка - представление предмет шаблона сообщений. Например, Заказ покупателя.
//   * ПолноеИмяТипаНазначения - Строка - предмет шаблона сообщений. Если указан полный путь к объекту метаданных, то в шаблоне
//                                        в качестве параметров будут доступны все его реквизиты. Например, Документ.ЗаказПокупателя.
//   * ФорматПисьма    - ПеречислениеСсылка.СпособыРедактированияЭлектронныхПисем- формат письма HTML или обычный текст.
//                                         Только для шаблонов электронной почты.
//   * УпаковатьВАрхив - Булево - если Истина, то печатные формы и вложения будут упакованы в архив при отправке.
//                                Только для шаблонов электронной почты.
//   * ТранслитерироватьИменаФайлов - Булево - печатные формы и файлы, вложенные в письмо будут иметь имена, содержащие 
//                                             только латинские буквы и цифры, для возможности переноса между
//                                             различными операционными системами. Например, файл "Счет на оплату.pdf" будет
//                                             сохранен с именем "Schet na oplaty.pdf". Только для шаблонов электронной почты.
//   * ФорматыВложений - СписокЗначений - список форматов вложений. Только для шаблонов электронной почты.
//   * ВладелецШаблона - ОпределяемыйТип.ВладелецШаблонаСообщения - владелец контекстного шаблона.
//   * ШаблонПоВнешнейОбработке - Булево - если Истина, то шаблон формируется внешней обработкой.
//   * ВнешняяОбработка - СправочникСсылка.ДополнительныеОтчетыИОбработки - внешняя обработка, в которой содержится шаблон.
//   * ПодписьИПечать   - Булево - добавляет факсимильную подпись и печать в печатную форму. Только для шаблонов электронной почты.
//
Функция ОписаниеПараметровШаблона() Экспорт
	
	ПараметрыШаблона = ШаблоныСообщенийКлиентСервер.ОписаниеПараметровШаблона();
	ПараметрыШаблона.Удалить("РазворачиватьСсылочныеРеквизиты");
	
	Возврат ПараметрыШаблона;
	
КонецФункции

// Создает подчиненные реквизиты у ссылочного реквизита в дереве значений
//
// Параметры:
//  Имя					 - Строка - имя ссылочного реквизита, в дереве значений у которого необходимо добавить подчиненные реквизиты.
//  Узел				 - КоллекцияСтрокДереваЗначений - узел в дереве значений, для которого необходимо создать дочерние элементы.
//  СписокРеквизитов	 - Строка - список добавляемых реквизитов через запятую, если указано, то будет добавлены только они.
//  ИсключаяРеквизиты	 - Строка - список исключаемых реквизитов через запятую.
//
Процедура РазвернутьРеквизит(Имя, Узел, СписокРеквизитов = "", ИсключаяРеквизиты = "") Экспорт
	ШаблоныСообщенийСлужебный.РазвернутьРеквизит(Имя, Узел, СписокРеквизитов, ИсключаяРеквизиты);
КонецПроцедуры

// Добавляет актуальные адреса почты или номера телефонов из контактной информации объекта в список получателей.
// В выборку адресов почты или номеров телефонов попадают только актуальные сведения, 
// т.к. нет смысла отправлять письма или сообщения SMS на архивные данные. 
//
// Параметры:
//  ПолучателиПисьма        - ТаблицаЗначений - список получателей письма или сообщения SMS
//  ПредметСообщения        - Произвольный - объект-родитель, у которого есть реквизиты, содержащие контактную информацию.
//  ИмяРеквизита            - Строка - имя реквизита в объекте-родителе, из которого следует получить адреса почты или
//                                     номера телефонов.
//  ТипКонтактнойИнформации - ПеречислениеСсылка.ТипыКонтактнойИнформации - если тип Адрес, то будут добавлены адреса
//                                                                          почты, если Телефон, то номера телефонов.
//
Процедура ЗаполнитьПолучателей(ПолучателиПисьма, ПредметСообщения, ИмяРеквизита, ТипКонтактнойИнформации = Неопределено) Экспорт
	
	Если ТипЗнч(ПредметСообщения) = Тип("Структура") Тогда
		Предмет = ПредметСообщения.Предмет;
	Иначе
		Предмет = ПредметСообщения;
	КонецЕсли;
		
		
	Если Предмет.Метаданные().Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		
		Если Предмет[ИмяРеквизита] = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если ТипКонтактнойИнформации = Неопределено Тогда
			ТипКонтактнойИнформации = МодульУправлениеКонтактнойИнформацией.ТипКонтактнойИнформацииПоНаименованию("АдресЭлектроннойПочты");
		КонецЕсли;
		
		ОбъектыКонтактнойИнформации = Новый Массив;
		ОбъектыКонтактнойИнформации.Добавить(Предмет[ИмяРеквизита]);
		
		КонтактнойИнформация = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(ОбъектыКонтактнойИнформации, ТипКонтактнойИнформации,, ТекущаяДатаСеанса());
		Для каждого ЭлементКонтактнойИнформации Из КонтактнойИнформация Цикл
			Получатель = ПолучателиПисьма.Добавить();
			Если ТипКонтактнойИнформации = МодульУправлениеКонтактнойИнформацией.ТипКонтактнойИнформацииПоНаименованию("Телефон") Тогда
				Получатель.НомерТелефона = ЭлементКонтактнойИнформации.Представление;
				Получатель.Представление = Строка(ЭлементКонтактнойИнформации.Объект);
				Получатель.Контакт       = ОбъектыКонтактнойИнформации[0];
			Иначе
				Получатель.Адрес         = ЭлементКонтактнойИнформации.Представление;
				Получатель.Представление = Строка(ЭлементКонтактнойИнформации.Объект);
				Получатель.Контакт       = ОбъектыКонтактнойИнформации[0];
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли
	
КонецПроцедуры

// Программный интерфейс для внешних обработок.

// Создает описание таблицы параметров шаблона сообщения.
//
// Возвращаемое значение:
//   ТаблицаЗначений   - сформированная пустая таблица значений.
//
Функция ТаблицаПараметров() Экспорт
	
	ПараметрыШаблона = Новый ТаблицаЗначений;
	
	ПараметрыШаблона.Колонки.Добавить("ИмяПараметра"                , Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));
	ПараметрыШаблона.Колонки.Добавить("ОписаниеТипа"                , Новый ОписаниеТипов("ОписаниеТипов"));
	ПараметрыШаблона.Колонки.Добавить("ЭтоПредопределенныйПараметр" , Новый ОписаниеТипов("Булево"));
	ПараметрыШаблона.Колонки.Добавить("ПредставлениеПараметра"      , Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	
	Возврат ПараметрыШаблона;
	
КонецФункции

// Добавить параметр шаблона для внешней обработки.
//
// Параметры:
//  ТаблицаПараметров			 - ТаблицаЗначений - таблица со списком параметров.
//  ИмяПараметра				 - Строка - Имя добавляемого параметра.
//  ОписаниеТипа				 - ОписаниеТипов - Тип параметра.
//  ЭтоПредопределенныйПараметр	 - Булево - Если Истина, то параметр предопределенный.
//  ПредставлениеПараметра		 - Строка - Представление параметра.
//
Процедура ДобавитьПараметрШаблона(ТаблицаПараметров, ИмяПараметра, ОписаниеТипа, ЭтоПредопределенныйПараметр, ПредставлениеПараметра = "") Экспорт

	НоваяСтрока                             = ТаблицаПараметров.Добавить();
	НоваяСтрока.ИмяПараметра                = ИмяПараметра;
	НоваяСтрока.ОписаниеТипа                = ОписаниеТипа;
	НоваяСтрока.ЭтоПредопределенныйПараметр = ЭтоПредопределенныйПараметр;
	НоваяСтрока.ПредставлениеПараметра      = ?(ПустаяСтрока(ПредставлениеПараметра),ИмяПараметра, ПредставлениеПараметра);
	
КонецПроцедуры

// Инициализирует структуру Получатели для заполнения возможных получателей сообщения.
//
// Возвращаемое значение:
//   Структура  - созданная структура.
//
Функция ИнициализироватьСтруктуруПолучатели() Экспорт
	
	Возврат Новый Структура("Получатель", Новый Массив);
	
КонецФункции

// Инициализирует структуру сообщения по шаблону, которую должна вернуть внешняя обработка.
//
// Возвращаемое значение:
//   Структура  - созданная структура.
//
Функция ИнициализироватьСтруктуруСообщения() Экспорт
	
	СтруктураСообщения = Новый Структура;
	СтруктураСообщения.Вставить("ТекстСообщенияSMS", "");
	СтруктураСообщения.Вставить("ТемаПисьма", "");
	СтруктураСообщения.Вставить("ТекстПисьма", "");
	СтруктураСообщения.Вставить("СтруктураВложений", Новый Структура);
	СтруктураСообщения.Вставить("ТекстПисьмаHTML", "<HTML></HTML>");
	
	Возврат СтруктураСообщения;
	
КонецФункции

// Возвращает описание параметров шаблона сообщения по данным формы, ссылке на элемент справочника шаблона
// сообщения или определив контекстный шаблон по его владельцу. Если шаблон не будет найден, то будет возвращена
// структура с незаполненными полями шаблона сообщения, заполнив которые, можно создать новый шаблон сообщения.
//
// Параметры:
//  Шаблон - ДанныеФормыСтруктура, СправочникСсылка.ШаблоныСообщений,
//           ЛюбаяСсылка - Ссылка на шаблон сообщения или на владельца контекстного шаблона.
//
// Возвращаемое значение:
//  Структура - Сведения о шаблоне. Подробнее см. ШаблоныСообщенийКлиентСервер.ОписаниеПараметровШаблона.
//
Функция ПараметрыШаблона(Знач Шаблон) Экспорт
	
	ПоискПоВладельцу = Ложь;
	Если ТипЗнч(Шаблон) <> Тип("ДанныеФормыСтруктура") 
		И ТипЗнч(Шаблон) <> Тип("СправочникСсылка.ШаблоныСообщений") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШаблоныСообщений.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ШаблоныСообщений КАК ШаблоныСообщений
		|ГДЕ
		|	ШаблоныСообщений.ВладелецШаблона = &ВладелецШаблона";
		Запрос.УстановитьПараметр("ВладелецШаблона", Шаблон);
		
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		Если РезультатЗапроса.Следующий() Тогда
			Шаблон = РезультатЗапроса.Ссылка;
		Иначе
			ПоискПоВладельцу = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Результат = ШаблоныСообщенийСлужебный.ПараметрыШаблона(Шаблон);
	Если ПоискПоВладельцу Тогда
		Результат.ВладелецШаблона = Шаблон;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Обратная совместимость.

// Подставляет в шаблон значения параметров сообщения и формирует текст сообщения.
//
// Параметры:
//  ШаблонСтроки        - Строка - шаблон, в который будут подставляться значения, согласно таблице параметров.
//  ВставляемыеЗначения - Соответствие - соответствие, содержащее ключи параметров и значения параметров.
//  Префикс             - Строка - префикс параметра.
//
// Возвращаемое значение:
//   Строка - строка, в которую были подставлены значения параметров шаблона.
//
Функция ВставитьПараметрыВСтрокуСогласноТаблицеПараметров(Знач ШаблонСтроки, ВставляемыеЗначения, Знач Префикс = "") Экспорт
	Возврат ШаблоныСообщенийСлужебный.ВставитьПараметрыВСтрокуСогласноТаблицеПараметров(ШаблонСтроки, ВставляемыеЗначения, Префикс);
КонецФункции

// Возвращает соответствие параметров текста сообщения шаблона.
//
// Параметры:
//  ПараметрыШаблона - Структура - Сведения о шаблоне.
//
// Возвращаемое значение:
//  Соответствие - соответствие имеющихся в тексте сообщения параметров.
//
Функция ПараметрыИзТекстаСообщения(ПараметрыШаблона) Экспорт
	Возврат ШаблоныСообщенийСлужебный.ПараметрыИзТекстаСообщения(ПараметрыШаблона);
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Определяет, является ли переданная ссылка элементом справочника шаблоны сообщений.
//
// Параметры:
//  ШаблонСсылка - СправочникСсылка.ШаблоныСообщений - Ссылка на элемент справочника шаблоны сообщений.
// 
// Возвращаемое значение:
//  Булево - Если Истина, то ссылка является элементом справочника шаблоны сообщений.
//
Функция ЭтоШаблон(ШаблонСсылка) Экспорт
	Возврат ТипЗнч(ШаблонСсылка) = Тип("СправочникСсылка.ШаблоныСообщений");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПараметрыОтправки(Шаблон, Предмет, УникальныйИдентификатор, ДополнительныеПараметры = Неопределено)
	
	ПараметрыОтправки = ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки(Шаблон.Ссылка, Предмет, УникальныйИдентификатор);
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОтправки.ДополнительныеПараметры, ДополнительныеПараметры, Истина);
	КонецЕсли;
	
	Возврат ПараметрыОтправки;
	
КонецФункции

// Обработчик подписки на событие ОбработкаПолученияФормы для переопределения формы файла.
//
// Параметры:
//  Источник                 - СправочникМенеджер - менеджер справочника с именем "*ПрисоединенныеФайлы".
//  ВидФормы                 - Строка - имя стандартной формы.
//  Параметры                - Структура - параметры формы.
//  ВыбраннаяФорма           - Строка - имя или объект метаданных открываемой формы.
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка     - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОпределитьФормуПрисоединенногоФайла(Источник, ВидФормы, Параметры,
				ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		МодульРаботаСФайлами.ОпределитьФормуПрисоединенногоФайла(Источник, ВидФормы, Параметры,
				ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

