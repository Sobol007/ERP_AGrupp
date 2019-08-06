#Область ОбработчикиСлужебныхСобытий

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
	
	НовыйОбработчик = ТаблицаОбработчиков.Добавить();
	НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаНеразделенныхПредопределенныхДанных;
	НовыйОбработчик.ПередВыгрузкойДанных = Истина;
	НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
	
КонецПроцедуры

Процедура ПередВыгрузкойДанных(Контейнер) Экспорт
	
	ПараметрыВыгрузки = Новый Структура(Контейнер.ПараметрыВыгрузки());
	
	ДополнительноВыгружаемые = Новый Массив();
	
	ПравилаКонтроля = ВыгрузкаЗагрузкаНеразделенныхДанныхПовтИсп.КонтрольСсылокНаНеразделенныеДанныеВРазделенныхПриВыгрузке();
	
	Для Каждого ПравилоКонтроля Из ПравилаКонтроля Цикл
		
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПравилоКонтроля.Ключ);
		
		Если ПараметрыВыгрузки.ВыгружаемыеТипы.Найти(ОбъектМетаданных) <> Неопределено Тогда
			
			Для Каждого ИмяПоля Из ПравилоКонтроля.Значение Цикл
				
				СтруктураИмениПоля = СтрРазделить(ИмяПоля, ".");
				
				Если ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
					
					ПодстрокаПоля = "Значение";
					ПодстрокаТаблицы = ОбъектМетаданных.ПолноеИмя();
					
				ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
					
					Если СтруктураИмениПоля[2] = "Реквизит" ИЛИ СтруктураИмениПоля[2] = "Attribute" Тогда // Не локализуется
						
						ПодстрокаПоля = СтруктураИмениПоля[3];
						ПодстрокаТаблицы = ОбъектМетаданных.ПолноеИмя();
						
					ИначеЕсли СтруктураИмениПоля[2] = "ТабличнаяЧасть" ИЛИ СтруктураИмениПоля[2] = "TabularSection" Тогда // Не локализуется
						
						ИмяТабличнойЧасти = СтруктураИмениПоля[3];
						
						Если СтруктураИмениПоля[4] = "Реквизит" ИЛИ СтруктураИмениПоля[4] = "Attribute" Тогда // Не локализуется
							
							ПодстрокаПоля = СтруктураИмениПоля[5];
							ПодстрокаТаблицы = ОбъектМетаданных.ПолноеИмя() + "." + ИмяТабличнойЧасти;
							
						Иначе
							
							ВызватьИсключениеНеУдалосьОпределитьПоле(ИмяПоля, ОбъектМетаданных.ПолноеИмя());
							
						КонецЕсли;
						
					Иначе
						
						ВызватьИсключениеНеУдалосьОпределитьПоле(ИмяПоля, ОбъектМетаданных.ПолноеИмя());
						
					КонецЕсли;
					
				ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
					
					Если СтруктураИмениПоля[2] = "Измерение" ИЛИ СтруктураИмениПоля[2] = "Dimension"
							ИЛИ СтруктураИмениПоля[2] = "Ресурс" ИЛИ СтруктураИмениПоля[2] = "Resource"
							ИЛИ СтруктураИмениПоля[2] = "Реквизит" ИЛИ СтруктураИмениПоля[2] = "Attribute" Тогда // Не локализуется
						
						ПодстрокаПоля = СтруктураИмениПоля[3];
						ПодстрокаТаблицы = ОбъектМетаданных.ПолноеИмя();
						
					Иначе
						
						ВызватьИсключениеНеУдалосьОпределитьПоле(ИмяПоля, ОбъектМетаданных.ПолноеИмя());
						
					КонецЕсли;
					
				Иначе
					
					ВызватьИсключение СтрШаблон(НСтр("ru = 'Объект метаданных %1 не поддерживается!';
													|en = 'Metadata object %1 is not supported.'"), ОбъектМетаданных.ПолноеИмя());
					
				КонецЕсли;
				
				ВозможныеТипыПоля = Метаданные.НайтиПоПолномуИмени(ИмяПоля).Тип.Типы();
				ПроверяемыеТипыПоля = Новый Массив();
				Для Каждого ВозможныйТипПоля Из ВозможныеТипыПоля Цикл
					
					ОбъектВозможногоТипа = Метаданные.НайтиПоТипу(ВозможныйТипПоля);
					
					Если ОбъектВозможногоТипа = Неопределено Тогда
						// Примитивный тип
						Продолжить;
					КонецЕсли;
					
					Если ПараметрыВыгрузки.ВыгружаемыеТипы.Найти(ОбъектВозможногоТипа) <> Неопределено Тогда
						// Объект изначально включен в состав выгружаемых типов
						Продолжить;
					КонецЕсли;
					
					Если ДополнительноВыгружаемые.Найти(ОбъектВозможногоТипа) <> Неопределено Тогда
						// Объект уже добавлен в состав дополнительно выгружаемых
						Продолжить;
					КонецЕсли;
					
					Если Не ОбщегоНазначенияБТС.ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(ОбъектВозможногоТипа) Тогда
						// Объект не может содержать предопределенных элементов
						Продолжить;
					КонецЕсли;
					
					ПроверяемыеТипыПоля.Добавить(ВозможныйТипПоля);
					
				КонецЦикла;
				
				Если ПроверяемыеТипыПоля.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				ТекстЗапроса = "";
				ШаблонТекстаЗапроса =
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ТИПЗНАЧЕНИЯ(Т.[ИмяПоля]) КАК Тип
				|ИЗ
				|	[Таблица] КАК Т
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ [ТаблицаПредопределенные] КАК ТПредопределенные
				|		ПО Т.[ИмяПоля] = ТПредопределенные.Ссылка
				|			И (ТПредопределенные.Предопределенный)";
				
				Для каждого ПроверяемыйТипПоля Из ПроверяемыеТипыПоля Цикл
					
					Если НЕ ПустаяСтрока(ТекстЗапроса) Тогда
						
						ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
						
					КонецЕсли;
					
					ТекстЗапроса = ТекстЗапроса + ШаблонТекстаЗапроса;
					ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[Таблица]", ПодстрокаТаблицы);
					ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ТаблицаПредопределенные]", Метаданные.НайтиПоТипу(ПроверяемыйТипПоля).ПолноеИмя());
					ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПоля]", ПодстрокаПоля);
					
				КонецЦикла;
				
				Запрос = Новый Запрос(ТекстЗапроса);
				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					
					ДополнительныйОбъектМетаданных = Метаданные.НайтиПоТипу(Выборка.Тип);
					Если ДополнительныйОбъектМетаданных <> Неопределено Тогда
						ДополнительноВыгружаемые.Добавить(ДополнительныйОбъектМетаданных);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПараметрыВыгрузки.ВыгружаемыеТипы, ДополнительноВыгружаемые, Истина);
	
	Контейнер.УстановитьПараметрыВыгрузки(ПараметрыВыгрузки);
	
	ИменаДополнительноВыгружаемых = Новый Массив();
	Для Каждого ДополнительноВыгружаемыйОбъект Из ДополнительноВыгружаемые Цикл
		ИменаДополнительноВыгружаемых.Добавить(ДополнительноВыгружаемыйОбъект.ПолноеИмя());
	КонецЦикла;
	
	ИмяФайла = Контейнер.СоздатьПроизвольныйФайл("xml", ТипДанныхДляТаблицыДополнительноВыгружаемыхДанных());
	ВыгрузкаЗагрузкаДанныхСлужебный.ЗаписатьОбъектВФайл(ИменаДополнительноВыгружаемых, ИмяФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
	
	НовыйОбработчик = ТаблицаОбработчиков.Добавить();
	НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаНеразделенныхПредопределенныхДанных;
	НовыйОбработчик.ПередЗагрузкойДанных = Истина;
	НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
	
КонецПроцедуры

Процедура ПередЗагрузкойДанных(Контейнер) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		ИмяФайла = Контейнер.ПолучитьПроизвольныйФайл(ТипДанныхДляТаблицыДополнительноВыгружаемыхДанных());
		ИменаДополнительноЗагружаемых = ВыгрузкаЗагрузкаДанныхСлужебный.ПрочитатьОбъектИзФайла(ИмяФайла);
		
		ПараметрыЗагрузки = Новый Структура(Контейнер.ПараметрыЗагрузки());
		
		Для Каждого ИмяДополнительноЗагружаемогоОбъекта Из ИменаДополнительноЗагружаемых Цикл
			ПараметрыЗагрузки.ЗагружаемыеТипы.Добавить(Метаданные.НайтиПоПолномуИмени(ИмяДополнительноЗагружаемогоОбъекта));
		КонецЦикла;
		
		Контейнер.УстановитьПараметрыЗагрузки(ПараметрыЗагрузки);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ТипДанныхДляТаблицыДополнительноВыгружаемыхДанных()
	
	Возврат "1cfresh\UnseparatedPredefined\AdditionalObjects";
	
КонецФункции

Процедура ВызватьИсключениеНеУдалосьОпределитьПоле(Знач ИмяПоля, Знач ИмяОбъекта)
	
	ВызватьИсключение СтрШаблон(НСтр("ru = 'Не удалось построить запрос получения значения поля %1 объекта метаданных %2!';
									|en = 'Cannot build request to receive the %1 field value of the %2 metadata object.'"),
		ИмяПоля, ИмяОбъекта
	);
	
КонецПроцедуры

#КонецОбласти