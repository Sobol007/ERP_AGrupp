////////////////////////////////////////////////////////////////////////////////
// Подсистема "Документооборот с Минобороны".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Криптография

Процедура ПолучитьСвойстваПрограммыМенеджераКриптографии(ОповещениеОбратногоВызова, Сертификат = Неопределено, УниверсальныйКриптопровайдер=Ложь) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ПолучитьСвойстваПрограммыМенеджераКриптографии(ОповещениеОбратногоВызова, Сертификат, УниверсальныйКриптопровайдер);
	
КонецПроцедуры

Процедура ОпределитьУстановленныеКрипторовайдеры(ОповещениеОбратногоВызова, ОпределятьГОСТ2001 = Ложь) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ОпределитьУстановленныеКрипторовайдеры(ОповещениеОбратногоВызова, ОпределятьГОСТ2001);
	
КонецПроцедуры

// Создает и возвращает менеджер криптографии (на клиенте) для указанной программы.
Процедура СоздатьМенеджерКриптографии(Оповещение, СвойстваПрограммы) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.СоздатьМенеджерКриптографии(Оповещение, СвойстваПрограммы);
	
КонецПроцедуры

Процедура НайтиСертификатПоОтпечатку(ОписаниеОповещениеВозврата, Отпечаток, МенеджерКриптографии = Неопределено) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.НайтиСертификатПоОтпечатку(ОписаниеОповещениеВозврата, Отпечаток, МенеджерКриптографии);
	
КонецПроцедуры

Процедура УстановитьСертификатыГоловныхПромежуточныхЦентров(ОповещениеОбратногоВызова, Сертификаты) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.УстановитьСертификатыГоловныхПромежуточныхЦентров(ОповещениеОбратногоВызова, Сертификаты);
	
КонецПроцедуры

Процедура ПодписатьCadesBes(Оповещение, ПараметрыПодписи) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ПодписатьCadesBes(Оповещение, ПараметрыПодписи);
	
КонецПроцедуры

Процедура ПолучитьСертификаты(ОписаниеОповещения, Параметры) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ПолучитьСертификаты(ОписаниеОповещения, Параметры);
	
КонецПроцедуры

Процедура ПроверитьПодпись(Оповещение, ИсходныеДанные, Подпись) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ПроверитьПодпись(Оповещение, ИсходныеДанные, Подпись);
	
КонецПроцедуры
 
Процедура ВыбратьСертификат(ОповещенияОЗавершение, НачальноеЗначениеВыбора) Экспорт
	ДокументооборотСМинобороныСлужебныйКлиент.ВыбратьСертификат(ОповещенияОЗавершение, НачальноеЗначениеВыбора);
КонецПроцедуры

// Процедура - Отображает представления сертификатов в полях ввода
//
// Параметры:
//  ПараметрыОтображенияСертификатов 	- Массив - описание параметров отображения сертификатов
//           *ПолеВвода							 	 - ПолеФормы - поле формы, в котором выводится представление сертификата.
//													  Будет подкрашено красным, если в сертификате есть ошибка.
//           *Сертификат							 - Строка - отпечаток сертификата или свойства сертификата.
//  												 - Массив - описание сертификатов.
//  													* Сертификат - Строка - отпечаток сертификата.
//           *ИмяРеквизитаПредставлениеСертификата	 - Строка - имя реквизита представления сертификат.
//  Форма								 - УправляемаяФорма - форма, в которой выводится представление сертификата.
//  ЭтоЭлектроннаяПодписьВМоделиСервиса	 - Булево - определяет системное хранилище: локальное или защищенное хранилище на сервере.
//  ВыполняемоеОповещение				 - ОписаниеОповещения - описание процедуры, принимающей результат (не обязательный)
Процедура ОтобразитьПредставленияСертификатов(
	ПараметрыОтображенияСертификатов, 
	Форма,
	ЭтоЭлектроннаяПодписьВМоделиСервиса,
	ВыполняемоеОповещение = Неопределено) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ОтобразитьПредставленияСертификатов(
		ПараметрыОтображенияСертификатов,
		Форма,
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		ВыполняемоеОповещение);
	
КонецПроцедуры

Процедура ОтобразитьПредставлениеСертификата(
		ПолеВвода,
		Сертификат,
		Форма,
		ИмяРеквизитаПредставлениеСертификата,
		ВыполняемоеОповещение = Неопределено) Экспорт
		
		ДокументооборотСМинобороныСлужебныйКлиент.ОтобразитьПредставлениеСертификата(
			ПолеВвода,
			Сертификат,
			Форма,
			ИмяРеквизитаПредставлениеСертификата,
			ВыполняемоеОповещение);
		
КонецПроцедуры

Функция ПолучитьСвойстваСертификата(Знач ДанныеСертификата, Настройки = Неопределено) Экспорт
	
	Возврат ДокументооборотСМинобороныСлужебныйВызовСервера.ПолучитьСвойстваСертификата(ДанныеСертификата, Настройки);
	
КонецФункции

// Открывает сертификат для просмотра в специализированной форме.
//
// Параметры:
//  Сертификат - Структура
//    * СерийныйНомер - Строка - серийный номер сертификата.
//    * Поставщик     - Строка - издатель сертификата.
//    * Отпечаток     - Строка - отпечаток сертификата. Используется для поиска сертификата если не указаны СерийныйНомер и Поставщик.
//    * Адрес         - Строка - адрес файла сертификата.
//
// ФормаВладелец - УправляемаяФорма - владелец формы.
//
Процедура ПоказатьСертификат(Сертификат, ФормаВладелец = Неопределено) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ПоказатьСертификат(Сертификат, ФормаВладелец);
	
КонецПроцедуры

Функция СертификатКриптографииВСтуктуру(СертификатКриптографии) Экспорт
	
	Возврат	ДокументооборотСМинобороныСлужебныйКлиент.СертификатКриптографииВСтуктуру(СертификатКриптографии);
	
КонецФункции

// Выполняет проверку сертификата.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено            - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ОписаниеОшибки       - Строка - описание ошибки выполнения.
//      * Валиден              - Булево - сертификат соответствует требованиям проверки.
//
//  Сертификат - Структура - описание сертификата.
//    * СерийныйНомер - Строка - серийный номер сертификата.
//    * Поставщик     - Строка - издатель сертификата.
//    * Отпечаток     - Строка - отпечаток сертификата. Используется для поиска сертификата если не указаны СерийныйНомер и Поставщик.
//
//  Проверки   - Строка - при значении "ПроверитьТолькоПоСпискуУстановленныхУЦ" выполняется толко проверка соответствия списку установленных УЦ,
//                        при значении Неопределено выполняется проверка соответствию списка УЦ и срока действия.
//
//  ВыводитьСообщения     - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура ПроверитьСертификат(ОповещениеОЗавершении, Сертификат, Проверки = Неопределено, ВыводитьСоообщения = Истина) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ПроверитьСертификат(ОповещениеОЗавершении, Сертификат, Проверки, ВыводитьСоообщения);
	
КонецПроцедуры

Функция НаименованиеСертификата(СертификатКриптографии) Экспорт
		
	Возврат ДокументооборотСМинобороныСлужебныйКлиент.НаименованиеСертификата(СертификатКриптографии);
	
КонецФункции

Функция СтуктураДанныхСертификатаВСтроку(Структура) Экспорт
	
	Результат = "";
	Для каждого КлючЗначение Из Структура Цикл
		Результат = Результат + СтрШаблон("%1=%2;", КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла; 
	Возврат Результат;
	
КонецФункции

// Выгружает указанный сертификат хранилища в файл.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено            - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * МенеджерКриптографии - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки       - Строка - описание ошибки выполнения.
//      * ИмяФайлаСертификата  - Строка - имя файла, в который выгружен сертификат.
//
//  Сертификат - Структура - описание сертификата.
//    * СерийныйНомер - Строка - серийный номер сертификата.
//    * Поставщик     - Строка - издатель сертификата.
//    * Отпечаток     - Строка - отпечаток сертификата. Используется для поиска сертификата если не указаны СерийныйНомер и Поставщик.
//
//  ИмяФайлаИлиРасширение - Строка - имя файла, в который необходимо сохранить результат.
//                                   Также можно указать только расширение создаваемого файла - ".расширение".
//
//  ВыводитьСообщения     - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  МенеджерКриптографии  - AddIn  - объект используемый для работы с криптографией. Если не задан, то будет создан новый.
//
Процедура ЭкспортироватьСертификатВФайл(ОповещениеОЗавершении, Сертификат, ИмяФайлаИлиРасширение = Неопределено, 
										ВыводитьСоообщения = Истина) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ЭкспортироватьСертификатВФайл(
		ОповещениеОЗавершении, Сертификат, ИмяФайлаИлиРасширение, ВыводитьСоообщения);
	
КонецПроцедуры

Функция ПодобратьСертификатДляАбонента(ОповещениеОбратногоВызова, Параметры) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ПодобратьСертификатДляАбонента(ОповещениеОбратногоВызова, Параметры);
	
КонецФункции

#КонецОбласти 

Функция СтатусОтчетаУстановленВручную(СсылкаНаОтчет, Статус) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.СтатусОтчетаУстановленВручную(СсылкаНаОтчет, Статус);
	
КонецФункции

Функция ПолучитьНеЗавершенныеОтправки(Организация) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.ПолучитьНеЗавершенныеОтправки(Организация);
	
КонецФункции

Функция ПолучитьПоследнююОтправкуОтчета(ОтчетСсылка) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.ПолучитьПоследнююОтправкуОтчета(ОтчетСсылка);
	
КонецФункции

Функция ДвоичныеДанныеВСтроку(Данные) Экспорт 
	
	Возврат ДокументооборотСМинобороныКлиентСервер.ДвоичныеДанныеВСтроку(Данные);
	
КонецФункции

Функция ПолучитьФормуОтчетаПоСсылке(ИсточникСсылка) Экспорт
	
	ИсточникОтчета = "РегламентированныйОтчетИсполнениеКонтрактовГОЗ";
	
	ДанныеОтчета = ДокументооборотСМинобороныКлиент.ПолучитьРеквизитыПоСсылке(ИсточникСсылка, "ДатаНачала, ДатаОкончания, ВыбраннаяФорма");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", ДанныеОтчета.ДатаНачала);// 
	ПараметрыФормы.Вставить("мСохраненныйДок",          ИсточникСсылка);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  ДанныеОтчета.ДатаОкончания);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          ДанныеОтчета.ВыбраннаяФорма);
	ПараметрыФормы.Вставить("БезОткрытияФормы",         Истина);
	
	ПолныйПутьКФорме = РегламентированнаяОтчетностьВызовСервера.ПолныйПутьКФорме(ИсточникОтчета, ДанныеОтчета.ВыбраннаяФорма);
	Уникальность = Ложь;
	ТекФорма = ПолучитьФорму(ПолныйПутьКФорме, ПараметрыФормы, , Уникальность);
	Возврат ТекФорма;
	
КонецФункции
 
Процедура ПоказатьПротокол(Знач ИсточникСсылка) Экспорт
	
	// ИсточникСсылка - ссылка на отчет
	Если ТипЗнч(ИсточникСсылка) = Тип("СправочникСсылка.ОтправкиМинобороны") Тогда
		ДанныеОтправки = ПолучитьРеквизитыПоСсылке(ИсточникСсылка, "ОтчетСсылка");
		СсылкаНаОтчет = ДанныеОтправки.ОтчетСсылка;
	Иначе
		СсылкаНаОтчет = ИсточникСсылка;
	КонецЕсли;
	
	// формируем хранилище с протоколом и помещаем в данные формы
	ФормаОтчета = ПолучитьФормуОтчетаПоСсылке(СсылкаНаОтчет);
	АдресДереваПротокола = ПолучитьАдресДереваПротоколаСдачи(ИсточникСсылка);
	ФормаОтчета.СтруктураРеквизитовФормы.Вставить("АдресВоВременномХранилищеОтветноеСообщение", АдресДереваПротокола);
	
	// выводим протокол пользователю
	СостояниеПротокола = Неопределено;
	ВыводитьСообщенияОбОшибках = Истина;
	СообщенияОбОшибкахВыведены = Неопределено;
	ФормаОтчета.ОбработатьПротоколСдачиОтчета(СостояниеПротокола, ВыводитьСообщенияОбОшибках, СообщенияОбОшибкахВыведены);
	// если не было выведено никаких сообщений, то это значит информации об ошибках нет
	Если НЕ СообщенияОбОшибкахВыведены Тогда
		ТекстСообщения = НСтр("ru = 'Протокол сдачи отчета не содержит информации об ошибках.';
								|en = 'Протокол сдачи отчета не содержит информации об ошибках.'");
		Сообщить(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Функция СохранитьСтатусОтправки(Отправка, Статус) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.СохранитьСтатусОтправки(Отправка, Статус);
	
КонецФункции

Функция ПолучитьСтатусОтправкиИзСостоянияПротокола(СостояниеПротокола) Экспорт
	
	ПервичнаяВалидация = СостояниеПротокола.ПервичнаяВалидация;
	Если НЕ ПервичнаяВалидация.ЭтоПротоколСдачиОтчета Тогда
		// протокол имеет неправильный формат
		Возврат Неопределено;
	КонецЕсли;
	
	СостояниеКонтрактов = Неопределено;
	СостояниеПротокола.Свойство("СостояниеКонтрактов", СостояниеКонтрактов);
	Если ПервичнаяВалидация.ЕстьКритичныеОшибки ИЛИ
		НЕ ПервичнаяВалидация.ВалидностьПакета ИЛИ
		(СостояниеКонтрактов <> Неопределено И
		СостояниеКонтрактов.ЕстьКритичныеОшибки) ИЛИ
		(СостояниеКонтрактов <> Неопределено И
		СостояниеКонтрактов.ЕстьНеПринятые) Тогда
		// не сдан
		Возврат ПредопределенноеЗначение("Перечисление.СтатусыОтправки.НеПринят");
	Иначе
		Если ПервичнаяВалидация.ЕстьНеКритичныеОшибки ИЛИ
			(СостояниеКонтрактов <> Неопределено И
			СостояниеКонтрактов.ЕстьНеКритичныеОшибки) Тогда
			// сдано, есть не критичные ошибки
			Возврат ПредопределенноеЗначение("Перечисление.СтатусыОтправки.ПринятЕстьОшибки");
		Иначе
			// сдано без ошибок
			Возврат ПредопределенноеЗначение("Перечисление.СтатусыОтправки.Сдан");
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ТекущееСостояниеОтправки(Знач Ссылка, Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.ТекущееСостояниеОтправки(Ссылка, ДополнительныеПараметры);
	
КонецФункции

Функция ПолучитьАдресДереваПротоколаСдачи(ИсточникСсылка) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.ПолучитьАдресДереваПротоколаСдачи(ИсточникСсылка);
	
КонецФункции

Функция ПолучитьРеквизитыПоСсылке(Ссылка, Реквизиты) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.ПолучитьРеквизитыПоСсылке(Ссылка, Реквизиты);
	
КонецФункции

Процедура ЗаписьОбъектовРегламентированнойОтчетности(ОтчетСсылка, Отказ) Экспорт
	
	ДокументооборотСМинобороныВызовСервера.ЗаписьОбъектовРегламентированнойОтчетности(ОтчетСсылка, Отказ);
	
КонецПроцедуры

Функция УстановитьНовыйСтатус(Отчет, Статус) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.УстановитьНовыйСтатус(Отчет, Статус);
	
КонецФункции

Функция СтатусУстановленВручную(Отправка, Знач СтатусИзЖурнала) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.СтатусУстановленВручную(Отправка, СтатусИзЖурнала);
	
КонецФункции

// Проверяет разрешение на выполнение операции.
//
// Параметры:
//  ОповещениеОЗавершении   - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат,
//                                       иначе - была ошибка при выполнении проверки.
//      * ВыполнениеРазрешено - Булево - если Истина, то продолжение выполнения разрешено.
//
//  ВладелецФормы           - УправляемаяФорма - форма, которая будет использования в качестве 
//                                               владельца открываемых служебных окон.
//
//  ПараметрыАутентификации - Структура - параметры доступа к сайту поддержки пользователей.
//    * Логин  - Строка - логин пользователя.
//    * Пароль - Строка - пароль пользователя.
//
Процедура ПроверитьВозможностьВыполненияОперации(ОповещениеОЗавершении, ВладелецФормы = Неопределено, ПараметрыАутентификации = Неопределено) Экспорт
	
	ДокументооборотСМинобороныСлужебныйКлиент.ПроверитьВозможностьВыполненияОперации(
		ОповещениеОЗавершении, ВладелецФормы, ПараметрыАутентификации);
	
КонецПроцедуры

Процедура ЗаписатьВЖурналРегистрации(ТекстОшибки) Экспорт
	
	ДокументооборотСМинобороныВызовСервера.ЗаписатьВЖурналРегистрации(ТекстОшибки);
	
КонецПроцедуры

Функция ПолучитьКоличествоОтправокМинобороныНаДату(Организация, Дата) Экспорт
	
	Возврат ДокументооборотСМинобороныВызовСервера.ПолучитьКоличествоОтправокМинобороныНаДату(Организация, Дата);
	
КонецФункции

Процедура ОткрытьФормуНастройкиСМинобороны(Организация, ФормаВладелец = Неопределено, Окно = Неопределено) Экспорт 
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФормы = Новый Структура("ОрганизацияСсылка", Организация);
		ОткрытьФорму(
			"РегистрСведений.НастройкиОбменаМинобороны.ФормаЗаписи", 
			ПараметрыФормы,,,,,, 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ВидНастроек", ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.Минобороны"));
		ОткрытьФорму(
			"Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.ФормаНастроекДокументооборотаОрганизаций", 
			ПараметрыОткрытия,,
			Новый УникальныйИдентификатор,
			Окно);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти