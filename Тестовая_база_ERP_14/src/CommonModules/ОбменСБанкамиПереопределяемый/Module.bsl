////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет массив актуальными видами электронных документов, которые поддерживает прикладное решение.
//
// Параметры:
//  Массив - Массив - виды актуальных ЭД:
//   * Перечисления.ВидыЭДОбменСБанками - вид электронного документа.
//   Добавлять можно только следующие значения:
//    - Перечисления.ВидыЭДОбменСБанками.ЗапросВыписки
//    - Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение
//    - Перечисления.ВидыЭДОбменСБанками.ПлатежноеТребование
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПереводВалюты
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПокупкуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПродажуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.РаспоряжениеНаОбязательнуюПродажуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.СписокНаЗачислениеДенежныхСредствНаСчетаСотрудников
//    - Перечисления.ВидыЭДОбменСБанками.СписокНаОткрытиеСчетовПоЗарплатномуПроекту
//    - Перечисления.ВидыЭДОбменСБанками.СписокУволенныхСотрудников
//    - Перечисления.ВидыЭДОбменСБанками.Письмо
//
Процедура ПолучитьАктуальныеВидыЭД(Массив) Экспорт
	
	//++ НЕ ГОСИС
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросВыписки);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ВыпискаБанка);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПлатежноеТребование);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.Письмо);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПереводВалюты);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПродажуВалюты);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПокупкуВалюты);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.РаспоряжениеНаОбязательнуюПродажуВалюты);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.СправкаОПодтверждающихДокументах);
	//++ НЕ УТ
	ЗарплатаКадры.ЗаполнитьАктуальныеВидыЭД(Массив);
	//-- НЕ УТ
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Получает номеров счетов в виде массив строк.
// Используется только при получении выписки банка.
//
// Параметры:
//  Организация - ОпределеяемыйТип.Организация - отбор по организации.
//  Банк - ОпределяемыйТип.СправочникБанки - отбор по банку.
//  МассивНомеровБанковскихСчетов - Массив - (возвращаемое значение) в элементах содержатся строки с номерами счетов.
//
Процедура ПолучитьНомераБанковскихСчетов(Организация, Банк, МассивНомеровБанковскихСчетов) Экспорт
	
	//++ НЕ ГОСИС
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	БанковскиеСчетаОрганизаций.НомерСчета КАК НомерСчета
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	БанковскиеСчетаОрганизаций.Владелец = &Организация
	|	И БанковскиеСчетаОрганизаций.Банк = &Банк
	|	И НЕ БанковскиеСчетаОрганизаций.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Банк", Банк);
	
	МассивНомеровБанковскихСчетов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НомерСчета");
	//-- НЕ ГОСИС
	
КонецПроцедуры

#Область ЗаполнениеДокументов

// Определяет параметры электронного документа по типу владельца, на основании которого он формируется.
//
// Параметры:
//  Источник - ДокументСсылка, ДокументОбъект - объект, на основании которого формируется электронный документ.
//  ПараметрыЭД - Структура - (возвращаемое значение) структура параметров источника, необходимых для определения
//                настроек обмена электронными документами. Содержит поля:
//      * ВидЭД - ПеречислениеСсылка.ВидыЭДОбменСБанками - вид электронного документа, который должен быть сформирован.
//      * Организация - ОпределяемыйТип.Организация - организация, к которой относится Источник.
//      * Банк - ОпределяемыйТип.СправочникБанки - ссылка на банк, в который будет отправлен электронный документ.
//
Процедура ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД);
	
	//++ НЕ УТ
	ЗарплатаКадры.ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД);
	//-- НЕ УТ
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Платежное поручение.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПлатежноеПоручение из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПлатежныхПоручений(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ЗаполнитьДанныеПлатежныхПоручений(МассивСсылок, ДанныеДляЗаполнения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на перевод валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПереводВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПорученийНаПереводВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ЗаполнитьДанныеПорученийНаПереводВалюты(МассивСсылок, ДанныеДляЗаполнения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Платежное требование.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПлатежноеТребование из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПлатежныхТребований(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ЗаполнитьДанныеПлатежныхТребований(МассивСсылок, ДанныеДляЗаполнения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на продажу валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПродажуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПорученийНаПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ЗаполнитьДанныеПорученийНаПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на покупку валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПокупкуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПорученийНаПокупкуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ЗаполнитьДанныеПорученийНаПокупкуВалюты(МассивСсылок, ДанныеДляЗаполнения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Распоряжение на обязательную продажу валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета РаспоряжениеНаОбязательнуюПродажуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеРаспоряженийНаОбязательнуюПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ЗаполнитьДанныеРаспоряженийНаОбязательнуюПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Справка о подтверждающих документах.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета СправкаОПодтверждающихДокументах из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеСправокОПодтверждающихДокументах(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ЗаполнитьДанныеСправокОПодтверждающихДокументах(МассивСсылок, ДанныеДляЗаполнения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

// Вызывается при получении уведомления о зачислении валюты
//
// Параметры:
//  ДеревоРазбора - ДеревоЗначений - дерево данных, соответствующее макету Обработки.ОбменСБанками.УведомлениеОЗачислении
//  НовыйДокументСсылка - ДокументСсылка - ссылка на созданный документ на основании данных электронного документа.
//
Процедура ПриПолученииУведомленияОЗачислении(ДеревоРазбора, НовыйДокументСсылка) Экспорт
	
	//++ НЕ ГОСИС
	ОбменСБанкамиУТ.ПриПолученииУведомленияОЗачислении(ДеревоРазбора, НовыйДокументСсылка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Определяет возможно ли редактировать объект информационной базы.
//
// Параметры:
//  СсылкаНаОбъект  - ДокументСсылка - ссылка на проверяемый объект;
//  РедактированиеРазрешено - Булево - (возвращаемое значение) разрешено или нет редактирование.
//
Процедура ПроверитьВозможностьРедактированияОбъекта(СсылкаНаОбъект, РедактированиеРазрешено) Экспорт
	
	//++ НЕ ГОСИС
	РедактированиеРазрешено = Истина;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Заполняет список команд ЭДО.
// 
// Параметры:
//  СоставКомандЭДО - Массив - содержит представления объектов метаданных, для которых необходимо отображать группу команд ДиректБанк,
//    например "Документ.ПлатежныйДокумент".
//
Процедура ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКомандЭДО) Экспорт
	
	//++ НЕ ГОСИС
	СоставКомандЭДО.Добавить("Документ.СписаниеБезналичныхДенежныхСредств");
	СоставКомандЭДО.Добавить("Документ.ПоступлениеБезналичныхДенежныхСредств");
	
	СоставКомандЭДО.Добавить("Обработка.ЖурналДокументовБезналичныеПлатежи");
	СоставКомандЭДО.Добавить("Обработка.ЖурналДокументовПлатежи");
	
	СоставКомандЭДО.Добавить("Обработка.ПлатежныйКалендарь");
	//++ НЕ УТ
	ЗарплатаКадры.ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКомандЭДО);
	//-- НЕ УТ
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Проверяет, включен ли тестовый режим обмена в банком.
// При включении тестового режима для обмена используются тестовые сервера банков.
//
// Параметры:
//    ИспользуетсяТестовыйРежим - Булево - признак использования тестового режима.
//
Процедура ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим) Экспорт
	
	//++ НЕ ГОСИС
	Если Найти(ВРег(Константы.ЗаголовокСистемы.Получить()), ВРег("DirectBank"))>0 Тогда
		ИспользуетсяТестовыйРежим = Истина;
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Событие возникает при получении выписки из регламентного задания или при синхронизации.
// Необходимо создать документы в информационной базе для отражения произведенных по счету операций.
// Для получения данных выписки в удобном формате можно использовать следующие процедуры:
//  - ОбменСБанками.ПолучитьДанныеВыпискиБанкаДеревоЗначений()
//  - ОбменСБанками.ПолучитьДанныеВыпискиБанкаТекстовыйФормат() - только для рублевых выписок.
//
// Параметры:
//  СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - ссылка на сообщение обмена, содержащий выписку банка.
//
Процедура ПриПолученииВыписки(СообщениеОбмена) Экспорт
	
КонецПроцедуры

#Область ЗарплатныйПроект

// Вызывается для формирования XML файла в прикладном решении.
//
// Параметры:
//    ОбъектДляВыгрузки - ДокументСсылка - ссылка на документ, на основании которого будет сформирован ЭД.
//    ИмяФайла - Строка - (возвращаемое значение) имя сформированного файла.
//    АдресФайла - АдресВременногоХранилища - (возвращаемое значение) содержит двоичные данные файла.
//
Процедура ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла) Экспорт
	
	//++ НЕ ГОСИС
	//++ НЕ УТ
	ЗарплатаКадры.ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла);
	//-- НЕ УТ
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Формирует табличный документ на основании файла XML для визуального отображения электронного документа.
//
// Параметры:
//  ИмяФайла - Строка - полный путь к файлу XML
//  ТабличныйДокумент - ТабличныйДокумент - (возвращаемое значение) визуальное отображение данных файла.
//
Процедура ЗаполнитьТабличныйДокумент(Знач ИмяФайла, ТабличныйДокумент) Экспорт
	
	//++ НЕ ГОСИС
	//++ НЕ УТ
	ЗарплатаКадры.ЗаполнитьТабличныйДокументПоПрямомуОбменуСБанками(ИмяФайла, ТабличныйДокумент);
	//-- НЕ УТ
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Вызывается при получении файла из банка.
//
// Параметры:
//  АдресДанныхФайла - Строка - адрес временного хранилища с двоичными данными файла.
//  ИмяФайла - Строка - формализованное имя файла данных.
//  ОбъектВладелец - ДокументСсылка - (возвращаемое значение) ссылка на документ, который был создан на основании ЭД.
//  ДанныеОповещения - Структура - (возвращаемое значение) данные для вызова метода Оповестить на клиенте.
//                 * Ключ - Строка - имя события.
//                 * Значение - Произвольный - параметр сообщения.
Процедура ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения) Экспорт
	
	//++ НЕ ГОСИС
	//++ НЕ УТ
	ЗарплатаКадры.ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения);
	//-- НЕ УТ
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Вызывается при изменении состояния электронного документа.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - владелец электронного документа;
//  СостояниеЭД - ПеречислениеСсылка.СостоянияОбменСБанками - новое состояние электронного документооборота.
//
Процедура ПриИзмененииСостоянияЭД(СсылкаНаОбъект, СостояниеЭД) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти