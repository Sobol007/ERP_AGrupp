////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

// Процедуры и функции данного модуля обеспечивают возможность сопоставления и
// пересоздания ссылок, хранящихся в хранилищах значений.
// Без дополнительной обработки сопоставление ссылок в этом случае невозможно,
// т.к. значения, записанные в хранилища значений, при сериализации записываются
// в XML в виде base64.
//

#Область РегистрацияОбработчиковВыгрузкиЗагрузкиДанных

// Вызывается при регистрации произвольных обработчиков выгрузки данных.
//
// Параметры: ТаблицаОбработчиков - ТаблицаЗначений, в данной процедуре требуется
//  дополнить эту таблицу значений информацией о регистрируемых произвольных
//  обработчиках выгрузки данных. Колонки:
//    ОбъектМетаданных - ОбъектМетаданных, при выгрузке данных которого должен
//      вызываться регистрируемый обработчик,
//    Обработчик - ОбщийМодуль, общий модуль, в котором реализован произвольный
//      обработчик выгрузки данных. Набор экспортных процедур, которые должны
//      быть реализованы в обработчике, зависит от установки значений следующих
//      колонок таблицы значений,
//    Версия - Строка - номер версии интерфейса обработчиков выгрузки / загрузки данных,
//      поддерживаемого обработчиком,
//    ПередВыгрузкойТипа - Булево, флаг необходимости вызова обработчика перед
//      выгрузкой всех объектов информационной базы, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередВыгрузкойТипа(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        Сериализатор - СериализаторXDTO, инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПередВыгрузкойТипа() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        ОбъектМетаданных - ОбъектМетаданных, перед выгрузкой данных которого
//          был вызван обработчик,
//        Отказ - Булево. Если в процедуре ПередВыгрузкойТипа() установить значение
//          данного параметра равным Истина - выгрузка объектов, соответствующих
//          текущему объекту метаданных, выполняться не будет.
//    ПередВыгрузкойОбъекта - Булево, флаг необходимости вызова обработчика перед
//      выгрузкой конкретного объекта информационной базы. Если присвоено значение
//      Истина - в общем модуле обработчика должна быть реализована экспортируемая процедура
//      ПередВыгрузкойОбъекта(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        МенеджерВыгрузкиОбъекта - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы -
//          менеджер выгрузки текущего объекта. Подробнее см. комментарий к программному интерфейсу обработки
//          ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы. Параметр передается только при вызове
//          процедур обработчиков, для которых при регистрации указана версия не ниже 1.0.0.1,
//        Сериализатор - СериализаторXDTO, инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПередВыгрузкойОбъекта() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        Объект - КонстантаМенеджерЗначения.*, СправочникОбъект.*, ДокументОбъект.*,
//          БизнесПроцессОбъект.*, ЗадачаОбъект.*, ПланСчетовОбъект.*, ПланОбменаОбъект.*,
//          ПланВидовХарактеристикОбъект.*, ПланВидовРасчетаОбъект.*, РегистрСведенийНаборЗаписей.*,
//          РегистрНакопленияНаборЗаписей.*, РегистрБухгалтерииНаборЗаписей.*,
//          РегистрРасчетаНаборЗаписей.*, ПоследовательностьНаборЗаписей.*, ПерерасчетНаборЗаписей.* -
//          объект данных информационной базы, перед выгрузкой которого был вызван обработчик.
//          Значение, переданное в процедуру ПередВыгрузкойОбъекта() в качестве значения параметра
//          Объект может быть модифицировано внутри обработчика ПередВыгрузкойОбъекта(), при
//          этом внесенные изменения будут отражены в сериализации объекта в файлах выгрузки, но
//          не будут зафиксированы в информационной базе
//        Артефакты - Массив(ОбъектXDTO) - набор дополнительной информации, логически неразрывно
//          связанной с объектом, но не являющейся его частью (артефакты объекта). Артефакты должны
//          сформированы внутри обработчика ПередВыгрузкойОбъекта() и добавлены в массив, переданный
//          в качестве значения параметра Артефакты. Каждый артефакт должен являться XDTO-объектом,
//          для типа которого в качестве базового типа используется абстрактный XDTO-тип
//          {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать XDTO-пакеты,
//          помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных. В дальнейшем
//          артефакты, сформированные в процедуре ПередВыгрузкойОбъекта(), будут доступны в процедурах
//          обработчиков загрузки данных (см. комментарий к процедуре ПриРегистрацииОбработчиковЗагрузкиДанных().
//        Отказ - Булево. Если в процедуре ПередВыгрузкойОбъекта() установить значение
//           данного параметра равным Истина - выгрузка объекта, для которого был вызван обработчик,
//           выполняться не будет.
//    ПослеВыгрузкиТипа() - Булево, флаг необходимости вызова обработчика после выгрузки всех
//      объектов информационной базы, относящихся к данному объекту метаданных. Если присвоено значение
//      Истина - в общем модуле обработчика должна быть реализована экспортируемая процедура
//      ПослеВыгрузкиТипа(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        Сериализатор - СериализаторXDTO, инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПослеВыгрузкиТипа() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        ОбъектМетаданных - ОбъектМетаданных, после выгрузки данных которого
//          был вызван обработчик.
//
Процедура ПриРегистрацииОбработчиковВыгрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	СписокМетаданных = ВыгрузкаЗагрузкаДанныхХранилищЗначенийПовтИсп.СписокОбъектовМетаданныхИмеющихХранилищеЗначения();
	
	Для Каждого ЭлементСписка Из СписокМетаданных Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ЭлементСписка.Ключ);
		НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаДанныхХранилищЗначений;
		НовыйОбработчик.ПередВыгрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
	
	НовыйОбработчик = ТаблицаОбработчиков.Добавить();
	НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаДанныхХранилищЗначений;
	НовыйОбработчик.ПередВыгрузкойНастроек = Истина;
	НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
	
КонецПроцедуры

// Вызывается при регистрации произвольных обработчиков загрузки данных.
//
// Параметры: ТаблицаОбработчиков - ТаблицаЗначений, в данной процедуре требуется
//  дополнить эту таблицу значений информацией о регистрируемых произвольных
//  обработчиках загрузки данных. Колонки:
//    ОбъектМетаданных - ОбъектМетаданных, при загрузке данных которого должен
//      вызываться регистрируемый обработчик,
//    Обработчик - ОбщийМодуль, общий модуль, в котором реализован произвольный
//      обработчик загрузки данных. Набор экспортных процедур, которые должны
//      быть реализованы в обработчике, зависит от установки значений следующих
//      колонок таблицы значений,
//    Версия - Строка - номер версии интерфейса обработчиков выгрузки / загрузки данных,
//      поддерживаемого обработчиком,
//    ПередСопоставлениемСсылок - Булево, флаг необходимости вызова обработчика перед
//      сопоставлением ссылок (в исходной ИБ и в текущей), относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередСопоставлениемСсылок(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        ОбъектМетаданных - ОбъектМетаданных, перед сопоставлением ссылок которого
//          был вызван обработчик,
//        СтандартнаяОбработка - Булево. Если процедуре ПередСопоставлениемСсылок()
//          установить значение данного параметра равным Ложь, вместо стандартного
//          сопоставления ссылок (поиск объектов в текущей ИБ с теми же значениями
//          естественного ключа, которые были выгружены из ИБ-источника) будет
//          вызвана функция СопоставитьСсылки() общего модуля, в процедуре
//          ПередСопоставлениемСсылок() которого значение параметра СтандартнаяОбработка
//          было установлено равным Ложь.
//          Параметры функции СопоставитьСсылки():
//            Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//              контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//              к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//            ТаблицаИсходныхСсылок - ТаблицаЗначений, содержащая информацию о ссылках,
//              выгруженных из исходной ИБ. Колонки:
//                ИсходнаяСсылка - ЛюбаяСсылка, ссылка объекта исходной ИБ, которую требуется
//                  сопоставить c ссылкой в текущей ИБ,
//                Остальные колонки равным полям естественного ключа объекта, которые в
//                  процессе выгрузки данных были переданы в функцию
//                  ВыгрузкаЗагрузкаДанныхИнформационнойБазы.ТребуетсяСопоставитьСсылкуПриЗагрузке()
//          Возвращаемое значение функции СопоставитьСсылки() - ТаблицаЗначений, колонки:
//            ИсходнаяСсылка - ЛюбаяСсылка, ссылка объекта, выгруженная из исходной ИБ,
//            Ссылка - ЛюбаяСсылка, сопоставленная исходной ссылка в текущей ИБ.
//        Отказ - Булево. Если в процедуре ПередСопоставлениемСсылок() установить значение
//          данного параметра равным Истина - сопоставление ссылок, соответствующих
//          текущему объекту метаданных, выполняться не будет.
//    ПередЗагрузкойТипа - Булево, флаг необходимости вызова обработчика перед
//      загрузкой всех объектов данных, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередЗагрузкойТипа(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        ОбъектМетаданных - ОбъектМетаданных, перед загрузкой всех данных которого
//          был вызван обработчик,
//        Отказ - Булево. Если в процедуре ПередЗагрузкойТипа() установить значение данного
//          параметра равным Истина - загрузка всех объектов данных соответствующих текущему
//          объекту метаданных выполняться не будет.
//    ПередЗагрузкойОбъекта - Булево, флаг необходимости вызова обработчика перед
//      загрузкой объекта данных, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередЗагрузкойОбъекта(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        Объект - КонстантаМенеджерЗначения.*, СправочникОбъект.*, ДокументОбъект.*,
//          БизнесПроцессОбъект.*, ЗадачаОбъект.*, ПланСчетовОбъект.*, ПланОбменаОбъект.*,
//          ПланВидовХарактеристикОбъект.*, ПланВидовРасчетаОбъект.*, РегистрСведенийНаборЗаписей.*,
//          РегистрНакопленияНаборЗаписей.*, РегистрБухгалтерииНаборЗаписей.*,
//          РегистрРасчетаНаборЗаписей.*, ПоследовательностьНаборЗаписей.*, ПерерасчетНаборЗаписей.* -
//          объект данных информационной базы, перед загрузкой которого был вызван обработчик.
//          Значение, переданное в процедуру ПередЗагрузкойОбъекта() в качестве значения параметра
//          Объект может быть модифицировано внутри процедуры обработчика ПередЗагрузкойОбъекта().
//        Артефакты - Массив(ОбъектXDTO) - дополнительные данные, логически неразрывно связанные
//          с объектом данных, но не являющиеся его частью. Сформированы в экспортируемых процедурах
//          ПередВыгрузкойОбъекта() обработчиков выгрузки данных (см. комментарий к процедуре
//          ПриРегистрацииОбработчиковВыгрузкиДанных(). Каждый артефакт должен являться XDTO-объектом,
//          для типа которого в качестве базового типа используется абстрактный XDTO-тип
//          {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать XDTO-пакеты,
//          помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных.
//        Отказ - Булево. Если в процедуре ПередЗагрузкойОбъекта() установить значение данного
//          параметра равным Истина - загрузка объекта данных выполняться не будет.
//    ПослеЗагрузкиОбъекта - Булево, флаг необходимости вызова обработчика после
//      загрузки объекта данных, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПослеЗагрузкиОбъекта(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        Объект - КонстантаМенеджерЗначения.*, СправочникОбъект.*, ДокументОбъект.*,
//          БизнесПроцессОбъект.*, ЗадачаОбъект.*, ПланСчетовОбъект.*, ПланОбменаОбъект.*,
//          ПланВидовХарактеристикОбъект.*, ПланВидовРасчетаОбъект.*, РегистрСведенийНаборЗаписей.*,
//          РегистрНакопленияНаборЗаписей.*, РегистрБухгалтерииНаборЗаписей.*,
//          РегистрРасчетаНаборЗаписей.*, ПоследовательностьНаборЗаписей.*, ПерерасчетНаборЗаписей.* -
//          объект данных информационной базы, после загрузки которого был вызван обработчик.
//        Артефакты - Массив(ОбъектXDTO) - дополнительные данные, логически неразрывно связанные
//          с объектом данных, но не являющиеся его частью. Сформированы в экспортируемых процедурах
//          ПередВыгрузкойОбъекта() обработчиков выгрузки данных (см. комментарий к процедуре
//          ПриРегистрацииОбработчиковВыгрузкиДанных(). Каждый артефакт должен являться XDTO-объектом,
//          для типа которого в качестве базового типа используется абстрактный XDTO-тип
//          {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать XDTO-пакеты,
//          помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных.
//    ПослеЗагрузкиТипа - Булево, флаг необходимости вызова обработчика после
//      загрузки всех объектов данных, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПослеЗагрузкиТипа(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//        ОбъектМетаданных - ОбъектМетаданных, после загрузки всех объектов которого
//          был вызван обработчик.
//
Процедура ПриРегистрацииОбработчиковЗагрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	СписокМетаданных = ВыгрузкаЗагрузкаДанныхХранилищЗначенийПовтИсп.СписокОбъектовМетаданныхИмеющихХранилищеЗначения();
	
	Для Каждого ЭлементСписка Из СписокМетаданных Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ЭлементСписка.Ключ);
		НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаДанныхХранилищЗначений;
		НовыйОбработчик.ПередЗагрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
	
	НовыйОбработчик = ТаблицаОбработчиков.Добавить();
	НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаДанныхХранилищЗначений;
	НовыйОбработчик.ПередЗагрузкойНастроек = Истина;
	НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиВыгрузкиЗагрузкиДанных

// Вызывается перед выгрузкой объекта.
// см. "ПриРегистрацииОбработчиковВыгрузкиДанных".
//
Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	ОбъектМетаданных = Объект.Метаданные();
	РеквизитыСХранилищемЗначений = РеквизитыОбъектаСХранилищемЗначений(Контейнер, ОбъектМетаданных);
	
	Если РеквизитыСХранилищемЗначений = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком ВыгрузкаЗагрузкаДанныхХранилищЗначений.ПередВыгрузкойОбъекта()!';
										|en = 'Metadata object %1 cannot be processed by handler ВыгрузкаЗагрузкаДанныхХранилищЗначений.ПередВыгрузкойОбъекта().'"),
			ОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
	
	Если ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойКонстанты(Контейнер, Объект, Артефакты, РеквизитыСХранилищемЗначений);
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойСсылочногоОбъекта(Контейнер, Объект, Артефакты, РеквизитыСХранилищемЗначений);
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
		
		ПередВыгрузкойНабораЗаписей(Контейнер, Объект, Артефакты, РеквизитыСХранилищемЗначений);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неожиданный объект метаданных: %1!';
										|en = 'Unexpected metadata object: %1.'"),
			ОбъектМетаданных.ПолноеИмя);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередВыгрузкойНастроек(Контейнер, Сериализатор, ИмяХранилищаНастроек, КлючНастроек, КлючОбъекта, Настройки, Пользователь, Представление, Артефакты, Отказ) Экспорт
	
	Если ТипЗнч(Настройки) = Тип("ХранилищеЗначения") Тогда
		
		НовыйАртефакт = ФабрикаXDTO.Создать(ТипАртефактХранилищаЗначений());
		НовыйАртефакт.Owner = ФабрикаXDTO.Создать(ТипВладелецТело());
		
		Если ВыгрузитьХранилищеЗначения(Контейнер, Настройки, НовыйАртефакт.Data) Тогда
			Настройки = Неопределено;
			Артефакты.Добавить(НовыйАртефакт);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед выгрузкой объекта.
// см. "ПриРегистрацииОбработчиковВыгрузкиДанных".
//
Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	ОбъектМетаданных = Объект.Метаданные();
	
	Для Каждого Артефакт Из Артефакты Цикл
		
		Если Артефакт.Тип() <> ТипАртефактХранилищаЗначений() Тогда
			Продолжить;
		КонецЕсли;
		
		Если ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
			
			ПередЗагрузкойКонстанты(Контейнер, Объект, Артефакт);
			
		ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
			
			ПередЗагрузкойСсылочногоОбъекта(Контейнер, Объект, Артефакт);
			
		ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
			
			ПередЗагрузкойНабораЗаписей(Контейнер, Объект, Артефакт);
			
		Иначе
			
			ВызватьИсключение СтрШаблон(НСтр("ru = 'Неожиданный объект метаданных: %1!';
											|en = 'Unexpected metadata object: %1.'"),
				ОбъектМетаданных.ПолноеИмя);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗагрузкойНастроек(Контейнер, ИмяХранилищаНастроек, КлючНастроек, КлючОбъекта, Настройки, Пользователь, Представление, Артефакты, Отказ) Экспорт
	
	Для Каждого Артефакт Из Артефакты Цикл
		
		Если Артефакт.Тип() = ТипАртефактХранилищаЗначений() И Артефакт.Owner.Тип() = ТипВладелецТело() Тогда
			
			ЗагрузитьХранилищеЗначения(Контейнер, Настройки, Артефакт);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Выгрузка данных хранилищ значений

// Вызывается перед выгрузкой константы с хранилищем значения.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Объект - объект выгружаемых данных.
//	Артефакты - Массив - массив артефактов (Объектов XDTO).
//	РеквизитыСХранилищемЗначений - Массив - массив структур см. "СтруктураРеквизитовСХранилищемЗначений".
//
Процедура ПередВыгрузкойКонстанты(Контейнер, Объект, Артефакты, РеквизитыСХранилищемЗначений)
	
	НовыйАртефакт = ФабрикаXDTO.Создать(ТипАртефактХранилищаЗначений());
	НовыйАртефакт.Owner = ФабрикаXDTO.Создать(ТипВладелецКонстанта());
	
	Если ВыгрузитьХранилищеЗначения(Контейнер, Объект.Значение, НовыйАртефакт.Data) Тогда
		Объект.Значение = Новый ХранилищеЗначения(Неопределено);
		Артефакты.Добавить(НовыйАртефакт);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед выгрузкой ссылочного объекта с хранилищем значения.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Объект - объект выгружаемых данных.
//	Артефакты - Массив - массив артефактов (Объектов XDTO).
//	РеквизитыСХранилищемЗначений - Массив - массив структур см. "СтруктураРеквизитовСХранилищемЗначений".
//
Процедура ПередВыгрузкойСсылочногоОбъекта(Контейнер, Объект, Артефакты, РеквизитыСХранилищемЗначений)
	
	Для Каждого ТекущийРеквизит Из РеквизитыСХранилищемЗначений Цикл
		
		Если ТекущийРеквизит.ИмяТабличнойЧасти = Неопределено Тогда
			
			ИмяРеквизита = ТекущийРеквизит.ИмяРеквизита;
			
			НовыйАртефакт = ФабрикаXDTO.Создать(ТипАртефактХранилищаЗначений());
			НовыйАртефакт.Owner = ФабрикаXDTO.Создать(ТипВладелецОбъект());
			НовыйАртефакт.Owner.Property = ИмяРеквизита;
			
			Если ВыгрузитьХранилищеЗначения(Контейнер, Объект[ИмяРеквизита], НовыйАртефакт.Data) Тогда
				Объект[ИмяРеквизита] = Новый ХранилищеЗначения(Неопределено);
				Артефакты.Добавить(НовыйАртефакт);
			КонецЕсли;
			
		Иначе
			
			ИмяРеквизита      = ТекущийРеквизит.ИмяРеквизита;
			ИмяТабличнойЧасти = ТекущийРеквизит.ИмяТабличнойЧасти;
			
			Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл 
				
				НовыйАртефакт = ФабрикаXDTO.Создать(ТипАртефактХранилищаЗначений());
				НовыйАртефакт.Owner = ФабрикаXDTO.Создать(ТипВладелецТабличнаяЧасть());
				НовыйАртефакт.Owner.TabularSection = ИмяТабличнойЧасти;
				НовыйАртефакт.Owner.Property = ИмяРеквизита;
				НовыйАртефакт.Owner.LineNumber = СтрокаТабличнойЧасти.НомерСтроки;
				
				Если ВыгрузитьХранилищеЗначения(Контейнер, СтрокаТабличнойЧасти[ИмяРеквизита], НовыйАртефакт.Data) Тогда
					СтрокаТабличнойЧасти[ИмяРеквизита] = Новый ХранилищеЗначения(Неопределено);
					Артефакты.Добавить(НовыйАртефакт);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Вызывается перед выгрузкой набора записей объекта с хранилищем значения.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Объект - объект выгружаемых данных.
//	Артефакты - Массив - массив артефактов (Объектов XDTO).
//	РеквизитыСХранилищемЗначений - Массив - массив структур см. "СтруктураРеквизитовСХранилищемЗначений".
//
Процедура ПередВыгрузкойНабораЗаписей(Контейнер, НаборЗаписей, Артефакты, РеквизитыСХранилищемЗначений)
	
	Для Каждого ТекущийРеквизит Из РеквизитыСХранилищемЗначений Цикл
		
		ИмяСвойства = ТекущийРеквизит.ИмяРеквизита;
		
		Для Каждого Запись Из НаборЗаписей Цикл
			
			НовыйАртефакт = ФабрикаXDTO.Создать(ТипАртефактХранилищаЗначений());
			НовыйАртефакт.Owner = ФабрикаXDTO.Создать(ТипВладелецНаборЗаписей());
			НовыйАртефакт.Owner.Property = ИмяСвойства;
			НовыйАртефакт.Owner.LineNumber = НаборЗаписей.Индекс(Запись);
			
			Если ВыгрузитьХранилищеЗначения(Контейнер, Запись[ИмяСвойства], НовыйАртефакт.Data) Тогда
				Запись[ИмяСвойства] = Новый ХранилищеЗначения(Неопределено);
				Артефакты.Добавить(НовыйАртефакт);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Выгружает хранилище значений.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	ХранилищеЗначения - ХранилищеЗначений - хранилище.
//	Артефакт - ОбъектXDTO - артефакт.
//
// Возвращаемое значение:
//	Булево - Истина, если выгружено.
//
Функция ВыгрузитьХранилищеЗначения(Контейнер, ХранилищеЗначения, Артефакт)
	
	Если ХранилищеЗначения = Null Тогда
		
		// Например, значения реквизитов, используемых только для элементов справочника,
		// прочитанные из группы справочника.
		Возврат Ложь;
		
	КонецЕсли;
	
	Попытка
		
		Значение = ХранилищеЗначения.Получить();
		
	Исключение
		
		// Если не удалось получить из хранилища сохраненное в нем значение,
		// не пытаться сериализовать и оставить в объекте.
		Возврат Ложь;
		
	КонецПопытки;
	
	Если Значение = Неопределено
		ИЛИ (ОбщегоНазначенияБТС.ЭтоПримитивныйТип(ТипЗнч(Значение)) И НЕ ЗначениеЗаполнено(Значение)) Тогда
		
		Возврат Ложь;
		
	Иначе
		
		Попытка
			
			Артефакт = ЗаписатьХранилищеЗначенияВАртефакт(Контейнер, Значение);
			Возврат Истина;
			
		Исключение
			
			Возврат Ложь; // Если хранилище не удалось сериализовать - оставим его в объекте
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

// Записывает хранилище значений в артефакт.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	ЗначениеХранилища - ЛюбойТип - значение хранилища.
//
// Возвращаемое значение:
//	ОбъектXDTO - артефакт.
//
Функция ЗаписатьХранилищеЗначенияВАртефакт(Контейнер, Знач ЗначениеХранилища)
	
	ВыгружатьКакБинарное = ТипЗнч(ЗначениеХранилища) = Тип("ДвоичныеДанные");
	
	Если ВыгружатьКакБинарное Тогда
		
		Возврат ЗаписатьБинарноеХранилищеЗначенияВАртефакт(Контейнер, ЗначениеХранилища);
		
	Иначе
		
		Возврат ЗаписатьСериализуемоеХранилищеЗначенияВАртефакт(Контейнер, ЗначениеХранилища);
		
	КонецЕсли;
	
КонецФункции

// Записывает сериализуемое значение в артефакт.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	ЗначениеХранилища - ЛюбойТип - значение хранилища.
//
// Возвращаемое значение:
//	ОбъектXDTO - артефакт.
//
Функция ЗаписатьСериализуемоеХранилищеЗначенияВАртефакт(Контейнер, Знач ЗначениеХранилища)
	
	ОписаниеЗначения = ФабрикаXDTO.Создать(ТипСериализуемоеЗначение());
	ОписаниеЗначения.Data = СериализаторXDTO.ЗаписатьXDTO(ЗначениеХранилища);
	
	Возврат ОписаниеЗначения;
	
КонецФункции

// Записывает бинарное значение в артефакт.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	ЗначениеХранилища - ЛюбойТип - значение хранилища.
//
// Возвращаемое значение:
//	ОбъектXDTO - артефакт.
//
Функция ЗаписатьБинарноеХранилищеЗначенияВАртефакт(Контейнер, Знач ЗначениеХранилища)
	
	ИмяФайла = Контейнер.СоздатьПроизвольныйФайл("bin");
	ЗначениеХранилища.Записать(ИмяФайла);
	
	ОписаниеЗначения = ФабрикаXDTO.Создать(ТипБинарноеЗначение());
	ОписаниеЗначения.RelativeFilePath = Контейнер.ПолучитьОтносительноеИмяФайла(ИмяФайла);
	
	Возврат ОписаниеЗначения;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Загрузка данных хранилищ значений

// Вызывается перед загрузкой константы.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Объект - КонстантаМенеджерЗначения - менеджер значения константы.
//	Артефакт - ОбъектXDTO - артефакт.
//
Процедура ПередЗагрузкойКонстанты(Контейнер, Объект, Артефакт)
	
	Если Артефакт.Owner.Тип() = ТипВладелецКонстанта() Тогда
		ЗагрузитьХранилищеЗначения(Контейнер, Объект.Значение, Артефакт);
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Тип владельца {%1}%2 не должен использоваться для объекта метаданных %3!';
										|en = 'Type of owner {%1}%2 cannot be used for metadata object %3.'"),
			Артефакт.Owner.Тип().URIПространстваИмен,
			Артефакт.Owner.Тип().Имя,
			Объект.Метаданные().ПолноеИмя()
		);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед загрузкой ссылочного объекта.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Объект - объект ссылочного типа.
//	Артефакт - ОбъектXDTO - артефакт.
//
Процедура ПередЗагрузкойСсылочногоОбъекта(Контейнер, Объект, Артефакт)
	
	Если Артефакт.Owner.Тип() = ТипВладелецОбъект() Тогда
		ЗагрузитьХранилищеЗначения(Контейнер, Объект[Артефакт.Owner.Property], Артефакт);
	ИначеЕсли Артефакт.Owner.Тип() = ТипВладелецТабличнаяЧасть() Тогда
		ЗагрузитьХранилищеЗначения(Контейнер,
			Объект[Артефакт.Owner.TabularSection].Получить(Артефакт.Owner.LineNumber - 1)[Артефакт.Owner.Property],
			Артефакт);
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Тип владельца {%1}%2 не должен использоваться для объекта метаданных %3!';
										|en = 'Type of owner {%1}%2 cannot be used for metadata object %3.'"),
			Артефакт.Owner.Тип().URIПространстваИмен,
			Артефакт.Owner.Тип().Имя,
			Объект.Метаданные().ПолноеИмя()
		);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед загрузкой набора записей.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	НаборЗаписей - набор записей.
//	Артефакт - ОбъектXDTO - артефакт.
//
Процедура ПередЗагрузкойНабораЗаписей(Контейнер, НаборЗаписей, Артефакт)
	
	Если Артефакт.Owner.Тип() = ТипВладелецНаборЗаписей() Тогда
		ЗагрузитьХранилищеЗначения(Контейнер,
			НаборЗаписей.Получить(Артефакт.Owner.LineNumber)[Артефакт.Owner.Property],
			Артефакт);
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Тип владельца {%1}%2 не должен использоваться для объекта метаданных %3!';
										|en = 'Type of owner {%1}%2 cannot be used for metadata object %3.'"),
			Артефакт.Owner.Тип().URIПространстваИмен,
			Артефакт.Owner.Тип().Имя,
			НаборЗаписей.Метаданные().ПолноеИмя()
		);
		
	КонецЕсли;
	
КонецПроцедуры

// Загружает значение хранилище значения из артефакта.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	НаборЗаписей - набор записей.
//	Артефакт - ОбъектXDTO - артефакт.
//
Процедура ЗагрузитьХранилищеЗначения(Контейнер, ХранилищеЗначения, Артефакт)
	
	Если Артефакт.Data.Тип() = ТипБинарноеЗначение() Тогда
		ИмяФайла = Контейнер.ПолучитьПолноеИмяФайла(Артефакт.Data.RelativeFilePath);
		Значение = Новый ДвоичныеДанные(ИмяФайла);
	ИначеЕсли Артефакт.Data.Тип() = ТипСериализуемоеЗначение() Тогда
		Если ТипЗнч(Артефакт.Data.Data) = Тип("ОбъектXDTO") Тогда
			Значение = СериализаторXDTO.ПрочитатьXDTO(Артефакт.Data.Data);
		Иначе
			Значение = Артефакт.Data.Data;
		КонецЕсли;
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неожиданный тип размещения данных хранилища значений в контейнере выгрузки: {%1}%2!';
										|en = 'Unexpected placement type of value storage data in export container: ({%1})%2.'"),
			Артефакт.Data.Тип().URIПространстваИмен,
			Артефакт.Data.Тип().Имя,
		);
		
	КонецЕсли;
	
	ХранилищеЗначения = Новый ХранилищеЗначения(Значение);
	
КонецПроцедуры

// Возвращает массив структур, в которых хранятся имена реквизитов и табличных частей,
// в которых имеются хранилища значений.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	МетаданныеОбъекта - Метаданные - метаданные.
//
// Возвращаемое значение:
//	Массив - массив структур см. "СтруктураРеквизитовСХранилищемЗначений".
//
Функция РеквизитыОбъектаСХранилищемЗначений(Контейнер, Знач МетаданныеОбъекта)
	
	ПолноеИмяМетаданных = МетаданныеОбъекта.ПолноеИмя();
	
	СписокМетаданных = ВыгрузкаЗагрузкаДанныхХранилищЗначенийПовтИсп.СписокОбъектовМетаданныхИмеющихХранилищеЗначения();
	
	РеквизитыСХранилищемЗначений = СписокМетаданных.Получить(ПолноеИмяМетаданных);
	Если РеквизитыСХранилищемЗначений = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РеквизитыСХранилищемЗначений;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции определяющие типы объектов XDTO

// Тип артефакта хранилища значения.
//
// Возвращаемое значение:
//	ТипОбъектаXDTO - тип возвращаемого объекта.
//
Функция ТипАртефактХранилищаЗначений()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "ValueStorageArtefact");
	
КонецФункции

// Тип бинарного значения.
//
// Возвращаемое значение:
//	ТипОбъектаXDTO - тип возвращаемого объекта.
//
Функция ТипБинарноеЗначение()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "BinaryValueStorageData");
	
КонецФункции

// Тип сериализуемого значения.
//
// Возвращаемое значение:
//	ТипОбъектаXDTO - тип возвращаемого объекта.
//
Функция ТипСериализуемоеЗначение()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "SerializableValueStorageData");
	
КонецФункции

// Тип владельца константы.
//
// Возвращаемое значение:
//	ТипОбъектаXDTO - тип возвращаемого объекта.
//
Функция ТипВладелецКонстанта()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "OwnerConstant");
	
КонецФункции

// Тип владельца ссылочного объекта.
//
// Возвращаемое значение:
//	ТипОбъектаXDTO - тип возвращаемого объекта.
//
Функция ТипВладелецОбъект()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "OwnerObject");
	
КонецФункции

// Тип владельца табличной части.
//
// Возвращаемое значение:
//	ТипОбъектаXDTO - тип возвращаемого объекта.
//
Функция ТипВладелецТабличнаяЧасть()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "OwnerObjectTabularSection");
	
КонецФункции

// Тип владельца набора записей.
//
// Возвращаемое значение:
//	ТипОбъектаXDTO - тип возвращаемого объекта.
//
Функция ТипВладелецНаборЗаписей()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "OwnerRecordset");
	
КонецФункции

Функция ТипВладелецТело()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "OwnerBody");
	
КонецФункции

// Возвращает пространство имен XDTO-пакета для хранилищ значений.
//
// Возвращаемое значение:
//	Строка - пространство имен XDTO-пакета для хранилищ значений.
//
Функция Пакет()
	
	Возврат "http://www.1c.ru/1cFresh/Data/Artefacts/ValueStorage/1.0.0.1";
	
КонецФункции

#КонецОбласти
