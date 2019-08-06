///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет стандартное поведение подсистемы Пользователи.
//
// Параметры:
//  Настройки - Структура - со свойствами:
//   * ОбщиеНастройкиВхода - Булево - определяет, будут ли в панели администрирования
//          "Настройки прав и пользователей" доступны настройки входа, и доступность
//          настроек ограничения срока действия в формах пользователя и внешнего пользователя.
//          По умолчанию - Истина, а для базовых версий конфигурации - всегда Ложь.
//
//   * РедактированиеРолей - Булево - определяет доступность интерфейса изменения ролей 
//          в карточках пользователя, внешнего пользователя и группы внешних пользователей
//          (в том числе для администратора). По умолчанию - Истина.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	
	
КонецПроцедуры

// Позволяет указать роли, назначение которых будет контролироваться особым образом.
// Большинство ролей конфигурации не требуется здесь указывать, т.к. они предназначены для любых пользователей, 
// кроме внешних пользователей.
//
// Параметры:
//  НазначениеРолей - Структура - со свойствами:
//   * ТолькоДляАдминистраторовСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для администраторов сервиса, например:
//       Администрирование, ОбновлениеКонфигурацииБазыДанных, АдминистраторСистемы,
//     а также все роли с правами:
//       Администрирование,
//       Администрирование расширений конфигурации,
//       Обновление конфигурации базы данных.
//     Такие роли, как правило, существуют только в БСП и не встречаются в прикладных решениях.
//
//   * ТолькоДляПользователейСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для неразделенных пользователей (сотрудников технической поддержки сервиса и
//     администраторов сервиса), например:
//       ДобавлениеИзменениеАдресныхСведений, ДобавлениеИзменениеБанков,
//     а также все роли с правами изменения неразделенных данных и следующими правами:
//       Толстый клиент,
//       Внешнее соединение,
//       Automation,
//       Режим все функции,
//       Интерактивное открытие внешних обработок,
//       Интерактивное открытие внешних отчетов.
//     Такие роли в большей части существует в БСП, но могут встречаться и в прикладных решениях.
//
//   * ТолькоДляВнешнихПользователей - Массив - имена ролей, которые предназначены
//     только для внешних пользователей (роли со специально разработанным набором прав), например:
//       ДобавлениеИзменениеОтветовНаВопросыАнкет, БазовыеПраваВнешнихПользователейБСП.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
//   * СовместноДляПользователейИВнешнихПользователей - Массив - имена ролей, которые предназначены
//     для любых пользователей (и внутренних, и внешних, и неразделенных), например:
//       ЧтениеОтветовНаВопросыАнкет, ДобавлениеИзменениеЛичныхВариантовОтчетов.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	//++ НЕ ГОСИС
	ПользователиЛокализация.ПриОпределенииНазначенияРолей(НазначениеРолей);

#Область РолиТолькоДляВнешнихПользователей

	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.БазовыеПраваВнешнихПользователейБСП.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.БазовыеПраваВнешнегоПользователяУТ.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательБазовыеПрава.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательЧтениеНСИ.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательОформлениеПлановПродаж.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательРедактированиеПодписокНаРассылкиИОповещения.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательИзменениеКонтактнойИнформацииКлиента.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательИзменениеКонтактныхЛиц.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательИзменениеКонтрагентов.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательОформлениеПретензий.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательПросмотрДокументовУсловийПродажи.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательОформлениеАктовПриемки.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательОформлениеЗаказов.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательОформлениеЗаявокНаВозврат.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательОформлениеОтчетовКомиссионеров.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательПросмотрОтчетаСостояниеРасчетов.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательИзменениеБанковскихСчетов.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательЧтениеДанныхПоРасчетам.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательПросмотрСостоянияОбеспеченияЗаказа.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательПросмотрОтчетаСостояниеДоступностиТоваров.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.СамообслуживаниеВнешнийПользовательПереходКСпискуАнкет.Имя);

#КонецОбласти

#Область РолиСовместногоИспользованияДляВнешнихПользователейИПользователей
	
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ЗапускТонкогоКлиента.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.СохранениеДанныхПользователя.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ВыводНаПринтерФайлБуферОбмена.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ЗапускВебКлиента.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ПечатьДокументовОтгрузки.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ПросмотрОтчетаСостояниеВыполненияДокумента.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ЧтениеВерсийОбъектов.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ПечатьДокументовОтгрузки.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ЧтениеОстатковДоступныхТоваров.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ЧтениеОтветовНаВопросыАнкет.Имя);
	
#КонецОбласти
	//-- НЕ ГОСИС
КонецПроцедуры

// Переопределяет поведение формы пользователя и формы внешнего пользователя,
// группы внешних пользователей, когда оно должно отличаться от поведения по умолчанию.
//
// Например, требуется скрывать/показывать или разрешать изменять/блокировать
// некоторые свойства в случаях, которые определены прикладной логикой.
//
// Параметры:
//  ПользовательИлиГруппа - СправочникСсылка.Пользователи,
//                          СправочникСсылка.ВнешниеПользователи,
//                          СправочникСсылка.ГруппыВнешнихПользователей - ссылка на пользователя,
//                          внешнего пользователя или группу внешних пользователей при создании формы.
//
//  ДействияВФорме - Структура - со свойствами:
//         * Роли                   - Строка - "", "Просмотр", "Редактирование".
//                                             Например, когда роли редактируются в другой форме, можно скрыть
//                                             их в этой форме или только блокировать редактирование.
//         * КонтактнаяИнформация   - Строка - "", "Просмотр", "Редактирование".
//                                             Свойство отсутствует для групп внешних пользователей.
//                                             Например, может потребоваться скрыть контактную информацию
//                                             от пользователя при отсутствии прикладных прав на просмотр КИ.
//         * СвойстваПользователяИБ - Строка - "", "Просмотр", "Редактирование".
//                                             Свойство отсутствует для групп внешних пользователей.
//                                             Например, может потребоваться показать свойства пользователя ИБ
//                                             для пользователя, который имеет прикладные права на эти сведения.
//         * СвойстваЭлемента       - Строка - "", "Просмотр", "Редактирование".
//                                             Например, Наименование является полным именем пользователя ИБ,
//                                             может потребоваться разрешить редактировать наименование
//                                             для пользователя, который имеет прикладные права на кадровые операции.
//
Процедура ИзменитьДействияВФорме(Знач ПользовательИлиГруппа, Знач ДействияВФорме) Экспорт
	
КонецПроцедуры

// Доопределяет действия при записи пользователя информационной базы.
// Например, если требуется синхронно обновить запись в соответствующем регистре и т.п.
// Вызывается из процедуры Пользователи.ЗаписатьПользователяИБ, если пользователь был действительно изменен.
// Если поле Имя в структуре СтарыеСвойства не заполнено, то создается новый пользователь ИБ.
//
// Параметры:
//  СтарыеСвойства - Структура - см. Пользователи.НовоеОписаниеПользователяИБ.
//  НовыеСвойства  - Структура - см. Пользователи.НовоеОписаниеПользователяИБ.
//
Процедура ПриЗаписиПользователяИнформационнойБазы(Знач СтарыеСвойства, Знач НовыеСвойства) Экспорт
	
КонецПроцедуры

// Доопределяет действия после удаления пользователя информационной базы.
// Например, если требуется синхронно обновить запись в соответствующем регистре и т.п.
// Вызывается из процедуры УдалитьПользователяИБ, если пользователь был удален.
//
// Параметры:
//  СтарыеСвойства - Структура - см. Пользователи.НовоеОписаниеПользователяИБ.
//
Процедура ПослеУдаленияПользователяИнформационнойБазы(Знач СтарыеСвойства) Экспорт
	
КонецПроцедуры

// Переопределяет настройки интерфейса, устанавливаемые для новых пользователей.
// Например, можно установить начальные настройки расположения разделов командного интерфейса.
//
// Параметры:
//  НачальныеНастройки - Структура - настройки по умолчанию:
//   * НастройкиКлиента    - НастройкиКлиентскогоПриложения           - настройки клиентского приложения.
//   * НастройкиИнтерфейса - НастройкиКомандногоИнтерфейса            - настройки командного интерфейса (панели
//                                                                      разделов, панели навигации, панели действий).
//   * НастройкиТакси      - НастройкиИнтерфейсаКлиентскогоПриложения - настройки интерфейса клиентского приложения
//                                                                      (состав и размещение панелей).
//
//   * ЭтоВнешнийПользователь - Булево - если Истина, то это внешний пользователь.
//
Процедура ПриУстановкеНачальныхНастроек(НачальныеНастройки) Экспорт
	
	//++ НЕ ГОСИС
	НастройкиКлиента = НачальныеНастройки.НастройкиКлиента;
	
	// Первый запуск до установки начальных значений констант выполняется в режиме по умолчанию
	Если ОбновлениеИнформационнойБазыСлужебный.ВерсияИБ("СтандартныеПодсистемы",
		ОбщегоНазначения.РазделениеВключено()) <> "0.0.0.0" Тогда
		
		Если Константы.ИнтерфейсВерсии82.Получить() Тогда
			НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2;
		Иначе
			НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Такси;
		КонецЕсли;
		
	КонецЕсли;
	
	НачальныеНастройки.НастройкиТакси = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
	НастройкиСостава = Новый НастройкиСоставаИнтерфейсаКлиентскогоПриложения;
	ГруппаВерх = Новый ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения;
	ГруппаВерх.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельИнструментов"));
	ГруппаВерх.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельОткрытых"));
	НастройкиСостава.Верх.Добавить(ГруппаВерх);
	НастройкиСостава.Лево.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельРазделов"));
	НачальныеНастройки.НастройкиТакси.УстановитьСостав(НастройкиСостава);
	
	Если НЕ НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
	
		НачальныеНастройки.НастройкиИнтерфейса.ОтображениеПанелиРазделов = ОтображениеПанелиРазделов.Текст;
	
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Позволяет добавить произвольную настройку на закладке "Прочее" в интерфейсе
// обработки НастройкиПользователей, чтобы ее можно было удалять и копировать другим пользователям.
// Для возможности управления настройкой нужно написать код ее по копированию (см. ПриСохраненииПрочихНастроек)
// и удалению (см. ПриУдаленииПрочихНастроек), который будет вызываться при интерактивных действиях с настройкой.
//
// Например, признак того, нужно ли показывать предупреждение при завершении работы программы.
//
// Параметры:
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка  - СправочникСсылка.Пользователи - пользователь,
//                               у которого нужно получить настройки.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             у которого нужно получить настройки.
//  Настройки - Структура - прочие пользовательские настройки.
//       * Ключ     - Строка - строковый идентификатор настройки, используемый в дальнейшем
//                             для копирования и очистки этой настройки.
//       * Значение - Структура - информация о настройке.
//              ** НазваниеНастройки  - Строка - название, которое будет отображаться в дереве настроек.
//              ** КартинкаНастройки  - Картинка - картинка, которая будет отображаться в дереве настроек.
//              ** СписокНастроек     - СписокЗначений - список полученных настроек.
//
Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Сохраняет произвольную настройку переданному пользователю.
// См. также ПриПолученииПрочихНастроек.
//
// Параметры:
//  Настройки - Структура - структура с полями:
//       * ИдентификаторНастройки - Строка - строковый идентификатор копируемой настройки.
//       * ЗначениеНастройки      - СписокЗначений - список значений копируемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно скопировать настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно скопировать настройку.
//
Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Очищает произвольную настройку у переданного пользователя.
// См. также ПриПолученииПрочихНастроек.
//
// Параметры:
//  Настройки - Структура - структура с полями:
//       * ИдентификаторНастройки - Строка - строковый идентификатор очищаемой настройки.
//       * ЗначениеНастройки      - СписокЗначений - список значений очищаемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно очистить настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно очистить настройку.
//
Процедура ПриУдаленииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
