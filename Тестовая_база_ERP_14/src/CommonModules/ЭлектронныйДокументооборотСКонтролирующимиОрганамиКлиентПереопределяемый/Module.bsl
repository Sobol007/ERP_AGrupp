
#Область ПрограммныйИнтерфейс

// Открывает окно сотрудника, позиционируясь на элементе формы,
// значение которого нужно изменить.
//
// Параметры:
//  Сотрудник  - ссылка на элемент справочника см. тип ОпределяемыйТип.СотрудникМакетПенсионногоДела.
//  НаименованиеРеквизита - Строка - параметр позволяет определить, какой на каком элементе формы физического лица
//		необходимо спозиционировать курсор. В самой функции каждому значению данного параметра определен соотвествующей элемент формы физического лица.
//		Возможные варианты значений параметра:
//			СНИЛС
//          АдресРегистрации
//          Телефон
// СтандартнаяОбработка - Булево - если Истина, то переопределяемый метод будет проигнорирован.
//
Процедура ОткрытьФормуСотрудникаНаРеквизите(Сотрудник, НаименованиеРеквизита, СтандартнаяОбработка) Экспорт
	
	Если СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизита = "";
	ИмяТекущейСтраницы = "";
	Если НаименованиеРеквизита = "СНИЛС" Тогда
		ИмяРеквизита = "ФизлицоСтраховойНомерПФР";
	ИначеЕсли НаименованиеРеквизита = "АдресРегистрации" Тогда
		ИмяТекущейСтраницы = "ГруппаКонтактнаяИнформация";
	ИначеЕсли НаименованиеРеквизита = "Телефон" Тогда
		ИмяТекущейСтраницы = "ГруппаКонтактнаяИнформация";
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Сотрудник);
	
	ФормаФизическогоЛица = ПолучитьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыОткрытия);
	
	Если Не ПустаяСтрока(ИмяТекущейСтраницы) Тогда
		
		ТекущаяСтраница = ФормаФизическогоЛица.Элементы.Найти(ИмяТекущейСтраницы);
		Если ТекущаяСтраница <> Неопределено Тогда
			ФормаФизическогоЛица.Страницы.ТекущаяСтраница = ТекущаяСтраница;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(ИмяРеквизита) Тогда
		
		ТекущийЭлемент = ФормаФизическогоЛица.Элементы.Найти(ИмяРеквизита);
		Если ТекущийЭлемент <> Неопределено Тогда
			ФормаФизическогоЛица.ТекущийЭлемент = ТекущийЭлемент;
		КонецЕсли;
		
	КонецЕсли;
	
	ФормаФизическогоЛица.Открыть();
	
КонецПроцедуры

// Открывает список для выбора сотрудника.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - задает процедуру, которая будет вызвана после выбора.
//   Сотрудник - ОпределяемыйТип.СотрудникМакетПенсионногоДела - ссылка на сотрудника.
//   Организация - СправочникСсылка.Организация - организация, может использоваться для отбора.
//   ВладелецФормы - УправляемаяФорма - форма, которая будет установлена в качестве владельца списка.
//   СтандартнаяОбработка - Булево - Истина - используется стандартный способ выбора из справочника,
//                                   Ложь - выбор из списка переопределяется.
//
Процедура ВыбратьСотрудникаИзСписка(ОповещениеОЗавершении, Сотрудник, Организация, ВладелецФормы, СтандартнаяОбработка) Экспорт
	
	Если СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отборы = Новый Структура;
		Отборы.Вставить("ТекущаяОрганизация", Организация);
		
		ПараметрыОткрытия.Вставить("Отбор", Отборы);
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Сотрудники.ФормаВыбора", ПараметрыОткрытия, ВладелецФормы, , , , ОповещениеОЗавершении);
	
КонецПроцедуры

// Открывает окно физического лица, позиционируясь элементе формы физического лица,
// значение которого нужно изменить из мастера подключения к 1С-Отчетности.
//
//
// Параметры:
//  СправочникСсылка.ФизическиеЛица  - физическое лицо, форму которого необходимо открыть
//  НаименованиеРеквизита - Строка - параметр позволяет определить, какой на каком элементе формы физического лица
//		необходимо спозиционировать курсор. В самой функции каждому значению данного параметра определен соотвествующей элемент формы физического лица
//		Возможные варианты значений параметра:
//			СНИЛС
//			ФИО
//
Процедура ОткрытьФормуВладельцаЭЦПНаРеквизите(ВладелецЭЦП, НаименованиеРеквизита) Экспорт
	
	ПараметрыФормы = Новый Структура("Ключ", ВладелецЭЦП);
	
	Если НаименованиеРеквизита = "СНИЛС" Тогда
		ПараметрыФормы.Вставить("ТекущийЭлемент", "ФизлицоСтраховойНомерПФР");
	ИначеЕсли НаименованиеРеквизита = "ФИО" Тогда
		ПараметрыФормы.Вставить("ТекущийЭлемент", "ФИО");
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму Главного бухгалтера организации
// 
// 
// Параметры:
//  СправочникСсылка.Организации - организация, форму главного бухгалтера которой нужно открыть.
//
Процедура ОткрытьФормуГлБухгалтера(Организация) Экспорт
	
	ФизЛицо = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ГлБухгалтер(Организация);
	
	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		ПараметрыФормы = Новый Структура("Ключ", ФизЛицо);
		ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыФормы);
	Иначе
		ОткрытьФорму("Справочник.ОтветственныеЛицаОрганизаций.ФормаОбъекта");
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму Организации, позиционируясь том элементе формы, который нужно изменить из мастера подключения к 1С-Отчетности.
//
//
// Параметры:
//  Организация - СправочникСсылка.Организации  - организация, у которой необходимо поменять значение реквизита из мастера
//  НаименованиеРеквизита - Строка - параметр позволяет определить, какой на каком элементе формы организации необходимо
//                                   спозиционировать курсор.
//		В самой функции каждому значению данного параметра определен соотвествующей элемент формы Организации
//		Возможные варианты значений параметра:
//			КраткоеНаименование
//			ПолноеНаименование
//			ИНН
//			КПП
//			РегНомерПФР
//			РегНомерФСС
//			ДополнительныйКодФСС
//			ОГРН
//
Процедура ОткрытьФормуОрганизацииНаРеквизите(Организация,НаименованиеРеквизита) Экспорт
	
	// Определяем соотвествие имен реквизитов мастера и имен реквизитов формы организации.
	СоответствиеИмен = Новый Структура(); 
	
	// СоответствиеИмен.Вставить(<имя поля мастера>, 	<Имя элемента управления формы организации>).
	СоответствиеИмен.Вставить("КраткоеНаименование",	"Наименование");
	СоответствиеИмен.Вставить("ПолноеНаименование", 	"НаименованиеПолное");
	СоответствиеИмен.Вставить("ИНН",				 	"ИНН");
	СоответствиеИмен.Вставить("КПП",				 	"КПП");
	СоответствиеИмен.Вставить("ОГРН",					"ОГРН");
	
	ИмяРеквизитаФормы = "";
	СоответствиеИмен.Свойство(НаименованиеРеквизита,ИмяРеквизитаФормы);	
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", Организация);
	
	ФормаОрганизации = ПолучитьФорму("Справочник.Организации.Форма.ФормаЭлемента", ПараметрыФормы);
	Если ФормаОрганизации.Элементы.Найти(ИмяРеквизитаФормы)<> Неопределено Тогда 
		ФормаОрганизации.ТекущийЭлемент = ФормаОрганизации.Элементы[ИмяРеквизитаФормы];
	КонецЕсли;
	ФормаОрганизации.Открыть();
	
КонецПроцедуры

// Открывает форму Руководителя организации
// 
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, форму руководителя которой нужно открыть.
//
Процедура ОткрытьФормуРуководителя(Организация) Экспорт
	
	ФизЛицо = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.Руководитель(Организация);
	
	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		ПараметрыФормы = Новый Структура("Ключ", ФизЛицо);
		ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыФормы);
	Иначе
		ОткрытьФорму("Справочник.ОтветственныеЛицаОрганизаций.ФормаОбъекта");
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список из 4х ссылок на статьи по 1С-Отчетности 
//
//
// Параметры:
//  Отсутсвуют
//
// Возвращаемое значение:
//  СписокЗначений - список из 4х ссылок на статьи. Значение элемента списка - URL-адрес на статью по 1С-Отчетности, 
//		представление элемента списка - пользовательское наименование статьи.
//  	Каждая статья содержит информацию о порядке предоставления отчетности в соотвествующий орган.
//
Функция СписокСсылокНаСтатьиПо1СОтчетности() Экспорт
	
	СписокСсылок = Новый СписокЗначений;
	СписокСсылок.Добавить("http://its.1c.ru/bmk/elreps/nalog", НСтр("ru = 'Отчетность в налоговые органы и Росстат';
																	|en = 'Отчетность в налоговые органы и Росстат'"));
	СписокСсылок.Добавить("http://its.1c.ru/bmk/elreps/pfr", НСтр("ru = 'Отчетность в ПФР';
																	|en = 'Отчетность в ПФР'"));
	СписокСсылок.Добавить("http://its.1c.ru/bmk/elreps/fss", НСтр("ru = 'Отчетность в ФСС';
																	|en = 'Отчетность в ФСС'"));
	СписокСсылок.Добавить("http://its.1c.ru/bmk/elreps/alco", НСтр("ru = 'Отчетность в Росалкогольрегулирование';
																	|en = 'Отчетность в Росалкогольрегулирование'"));
	СписокСсылок.Добавить("http://its.1c.ru/bmk/elreps/prirod", НСтр("ru = 'Отчетность в Росприроднадзор';
																	|en = 'Отчетность в Росприроднадзор'"));
	
	Возврат СписокСсылок;
	
КонецФункции

// Возвращает строку - путь к основной форме организации
//
//
// Параметры:
//  Отсутсвуют
//
// Возвращаемое значение:
//  Строка - путь к основной форме справочника организации. Строка вида "Справочник.Организации.Форма.<ИмяФормы>".
//
Функция ПутьКОсновнойФормеСправочникаОрганизации() Экспорт
	Возврат "Справочник.Организации.Форма.ФормаЭлемента";
КонецФункции
	
// Возвращает имя события, с которым будет срабатывать оповещение для показа истории отправки в контролирующие органы
// документа или элемента справочника в журнале обмена.
//
// Параметры
//   Источник  - СправочникСсылка, ДокументСсылка,  - документ или элемент справочника, отправляемый в контролируемые органы.
//
// Возвращаемое значение:
//   Строка   - имя события, может принимать одно из следущих значений:
//		- "Показать циклы обмена уведомления", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке ФНС, страница Исходящие уведомления   
//		- "Показать циклы обмена отчета ПФР", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке ПФР, страница Отчетность   
//		- "Показать циклы обмена отчета статистики", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке Росстат, страница Отчетность
//		- "Показать циклы обмена", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке ФНС, страница Отчетность
//		- "Показать циклы обмена заявления", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке ФНС, страница Заявления о ввозе товаров.
//
Функция ИмяСобытияОткрытияИсторииОтправки(Источник) Экспорт
	
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.ПачкаДокументовАДВ_1")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.ПачкаДокументовАДВ_2")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.ПачкаДокументовАДВ_3")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.ПачкаДокументовДСВ_1")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.ПачкаДокументовСЗВ_К")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.ПачкаДокументовСПВ_1")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.РеестрДСВ_3")
		Или ТипЗнч(Источник) = Тип("СправочникСсылка.КомплектыОтчетностиПерсучета")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.СведенияОЗастрахованныхЛицахСЗВ_М")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ") 
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.ДанныеОКорректировкеСведенийЗастрахованныхЛицСЗВ_КОРР")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.СведенияОЗаработкеСтажеЗастрахованныхЛицСЗВ_ИСХ")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.ОписьОДВ_1") Тогда
		
		Возврат  "Показать циклы обмена отчета ПФР";
	ИначеЕсли ТипЗнч(Источник) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган")
		Или ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ") Тогда
		Возврат "Показать циклы обмена";
	КонецЕсли;
	
КонецФункции 
	
// Процедура предназначена для выбора пользователем физического лица из списка физических лиц.
// При этом, из списка убираются сотрудники, являющиеся ответственными лицами у переданной организации.
// В списке физических лиц курсор устанавливается на том физ лице, которое передано в качестве параметра.
//
// Параметры
//  Организация  - <Справочники.Организации> - Организация, к уоторой будет выполнен поиск ответственных лиц
//  ВладелецЭЦП  - <Справочники.ФизическиеЛица> - физическое лицо, на котором нужно спозиционироваться в списке
//                                                физических лиц.
//		Если ВладелецЭЦП = Неопределено, то позиционироваться на физ лице не нужно
//  ВыполняемоеОповещение - <ОписаниеОповещения> - Оповещение, которое будет выполнено после выбора физического лица, результатом,
//		которого является выбранное физическое лицо.
//
Процедура ПолучитьИсполнителя(Организация, ВладелецЭЦП, ВыполняемоеОповещение) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	// Показываем физ лица, которые не являются ответственными лицами
	ОтветственныеЛицаОрганизации = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ПолучитьДанныеОтветственныхЛиц(Организация);
	Если НЕ ОтветственныеЛицаОрганизации = Неопределено Тогда
		
		ФН = Новый НастройкиКомпоновкиДанных;
		
		Эл = ФН.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Эл.ЛевоеЗначение	= Новый ПолеКомпоновкиДанных("Ссылка");
		Эл.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеВСписке;
		Эл.ПравоеЗначение	= ОтветственныеЛицаОрганизации;
		Эл.Использование	= Истина;
		
		ПараметрыФормы.Вставить("ФиксированныеНастройки", ФН)
	КонецЕсли;
	
	// Если уже был выбран владелец ЭЦП, то позиционироваться в списке на нем
	Если ЗначениеЗаполнено(ВладелецЭЦП) Тогда
		ПараметрыФормы.Вставить("ТекущаяСтрока", ВладелецЭЦП);
	КонецЕсли;
	
	// Открытие формы
	Если ОтветственныеЛицаОрганизации = Неопределено И ВладелецЭЦП = Неопределено Тогда
  		ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", Новый Структура("РежимВыбора", Истина),,,,,ВыполняемоеОповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
 	Иначе
  		ПараметрыФормы.Вставить("РежимВыбора", Истина);
  		ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы,,,,,ВыполняемоеОповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
 	КонецЕсли;
	
КонецПроцедуры

// Функция определяет, доступна ли для текущего пользователя возможность интерактивного редактирования 
// поля СНИЛС в карточке Физ лица, которое передано в качестве параметра функции 
// с учетом всех прав, функциональных опции и прочих ограничений.
//
// Параметры
//  ФизЛицо  - Справочники.ФизическиеЛица - Физичекое лицо, для которого определяется возможность редактирования СНИЛСа.
//
// Возвращаемое значение:
//   Булево   - Истина, если интерактирвное редактирование возможно, Ложь - в противном случае.
//
Функция СНИЛСДоступенДляРедактирования(ФизЛицо) Экспорт
	Возврат Истина;
КонецФункции
	
// Процедура выполняет отправку документа или отчета в контролирующий орган
//
// Параметры
//  Ссылка  					- СправочникСсылка, ДокументСсылка - Документ или элемент справочника, который отправляется в контролирующий орган
//  ВидКонтролирующегоОргана  - Перечисление.ТипыКонтролирующихОрганов - Вид контролирующего Органа, в который
//                                                                       выполняется отправка
//  КодКонтролирующегоОргана  - Строка - Код контролирующего органа, в который выполняется отправка
//  СтандартнаяОбработка  - Булево - Определяет, должна ли выполняться стандартная отправка в контролирующий орган или
//                                   отправка должна быть переопределена.
// 		Если СтандартнаяОбработка = Ложь, то будет выполняться отправка в данной процедуре, а стандартная отправка выполняться не будет.
//
Процедура ОтправитьВКонтролирующийОрган(Ссылка, ВидКонтролирующегоОргана, КодКонтролирующегоОргана, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#Область НеИспользуется1СОтчетность

// Процедура выполняет отправку регламентированного отчета в контролирующий орган не через "1С-Отчетность"
//
// Параметры
//  Ссылка - ДокументСсылка       - Документ, который отправляется в контролирующий орган;
//  КонтролирующийОрган - Строка  - Наименование контролирующего органа в который выполняется отправка;
//  Форма  - Управляемаяформа     - Форма, из которой который выполняется отправка;
//  ЭтоОтправкаИзФормыОтчетность  - Булево - Истина, если отправка выполняется из формы "1С-отчетность";
//  ДанныеОтчета - Структура      - Структура содержит данные выгрузки регламентированного отчета:
// * ТекстВыгрузки          - Строка - Текст выгрузки отчета или адрес во временном хранилище,
// * ИмяФайлаВыгрузки       - Строка - Имя файла выгрузки,
// * КодировкаФайлаВыгрузки - Строка - Кодировка файла выгрузки,
// * ТипФайлаВыгрузки       - Строка - Зарезервировано для выгрузки комплекта файлов.
//
// Пример реализации:
//  	
//  	Если ИнтеграцияСБанкамиВызовСервера.ОтправитьОбъектРегламентированнойОтчетности(Ссылка, ДанныеОтчета) Тогда
//  		ОповеститьОбИзменении(Ссылка);
//  	КонецЕсли;
//  	
//
Процедура ОтправитьВКонтролирующийОрганНеИспользуется1СОтчетность(
	Ссылка,
	КонтролирующийОрган,
	Форма,
	ЭтоОтправкаИзФормыОтчетность,
	ДанныеОтчета) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Процедура выполняет проверку в интернете документа или отчета
//
// Параметры
//  Ссылка  - СправочникСсылка, ДокументСсылка - Документ или элемент справочника, который проверяется в интернете
//  СтандартнаяОбработка  - Булево - Определяет, должна ли выполняться стандартная проверка в интернете или проверка
//                                   должна быть переопределена.
// 		Если СтандартнаяОбработка = Ложь, то будет выполняться проверка в данной процедуре, а стандартная проверка в интернете выполняться не будет.
//
Процедура ПроверитьВИнтернете(Ссылка, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Процедура показывает форму состояния отправки для объекта, отправляемого в контролирующие органы.
//
// Параметры
//  Ссылка  - СправочникСсылка, ДокументСсылка - Документ или элемент справочника, для которого будет отображено
//                                               состояние отправки
//  СтандартнаяОбработка  - Булево - Определяет, должна ли отображаться форма состояния отправки, входящая в БРО или нет
// 		Если СтандартнаяОбработка = Ложь, то форма, входящая в БРО отображаться не будет.
//
Процедура ПоказатьСостояниеОтправкиОтчета(Ссылка, СтандартнаяОбработка) Экспорт
	
	ЗарплатаКадрыКлиент.ПоказатьСостояниеОтправкиОтчета(Ссылка, СтандартнаяОбработка);
	
КонецПроцедуры

#Область ДокументыПоТребованиюФНС

// Заполняется при наличии в конфигурации документов библиотеки БРУ:
// Открывает форму выбора документов НДС, в качестве описания оповещения при открытии формы выбора используется
// ОписаниеОповещения, передаваемое в параметрах процедуры.
//
// Параметры процедуры: 
//	(обязательный) ОписаниеОповещения	- ОписаниеОповещения
//	(необязательный) ПараметрыОтбора	- Структура, задает начальные значения отборов. 
//		Поля структуры:
// 			(необязательный) Организация	- СправочникСсылка.Организации
// Пример:
// УчетНДСКлиент.ВыбратьДокументНДСДляПередачиФНС(ОписаниеОповещения, ПараметрыОтбора);
//
Процедура ВыбратьДокументНДСДляПередачиФНС(ОписаниеОповещения, ПараметрыОтбора = Неопределено) Экспорт 
	
	УчетНДСКлиент.ВыбратьДокументНДСДляПередачиФНС(ОписаниеОповещения, ПараметрыОтбора);
	
КонецПроцедуры

// Заполняется при наличии в конфигурации библиотеки БЭД:
//
// Параметры:
//  ДокументИБСсылка - ссылка на документ ИБ;
//
// Пример:
// ЭлектронныеДокументыКлиент.ОткрытьАктуальныйЭД(ДокументИБСсылка);
//
Процедура ОткрытьАктуальныйЭД(ДокументИБСсылка) Экспорт
	
	ОбменСКонтрагентамиКлиент.ОткрытьАктуальныйЭД(ДокументИБСсылка);
	
КонецПроцедуры

// Процедура выполняет открытие формы выбора для типа (документ или справочник), указанного в параметре Тип.
// При этом, если указана Ссылка, то в форме выбора строка с указанным элементом должна стать текущей.
// Если передана организация, то в списке выбора должен быть наложен отбор по организации.
// В форме выбора пользователь выбирает ссылку и затем информация об этой ссылке должна быть передана в процедуру, 
// указанную в параметре ВыполняемоеОповещение.
//
// Параметры:
//  Тип                   - Тип - один из типов, входящий в ОпределяемыйТип.ИсточникДокументаПоТребованиюФНСБРО, 
//                          для которого нужно открыть список выбора.
//  Ссылка                - ОпределяемыйТип.ИсточникДокументаПоТребованиюФНСБРО - если указана, то в форме выбора
//						    курсор должен быть на данной ссылке.
//  Организация           - Справочники.Организации, Неопределено - организация, по которой должен быть выполнен
//							отбор в форме выбора, если она задана.
//  ВыполняемоеОповещение - ОписаниеОповещения - в оповещении указано, какой процедуре должен быть передан
//							результат выбора.
//  СтандартнаяОбработка  - Булево - если содержимое процедуры переопределено, то СтандартнаяОбработка должна
//							быть установлена в Ложь;
//
// Возвращаемое значение:
//  В процедуру, указанную в параметре ВыполняемоеОповещение, должен быть передан результат выбора, который имеет тип
//  Структура со следующими полями:
//    * Ссылка - ОпределяемыйТип.ИсточникДокументаПоТребованиюФНСБРО - ссылка на выбранный документ или элемент
//				 справочника
//    * Описание - Строка - наименование, реквизиты или иные индивидуализирующие признаки документа,
//				   длина до 1000 символов. В качестве описания можно передавать вид документа, номер и дату, например,
//		 	       "Счет-фактура выданный 1234 от 12.01.2017 г.". Также дополнительно можно передавать любые другие
//				   сведения.
//    * Основание - Строка - наименование, реквизиты или иные индивидуализирующие признаки документа-основания,
//					длина до 1000 символов. Документ-основание - это договор, заказ-наряд, счет на оплату,
//					заявка покупателя или иной первичный документ, подтверждающий возникновение договорных
//					отношений между участниками сделки. В качестве описания можно передавать вид документа,
//					номер и дату, например, "Счет на оплату 1234 от 12.01.2017 г.". Также дополнительно можно
//					передавать любые другие сведения. Если документ-основание отсутствует, то в данном поле
//					возвращать пустую строку.
//
// Пример реализации:
//  СтандартнаяОбработка = Ложь;
//  ИмяФормы = ПолучитьИмяФормыОбъктаДляПередачиФНС(Тип);
//  Если ИмяФормы = Неопределено Тогда
//  	ТекстПредупреждения = НСтр("ru = 'Не удалось открыть форму выбора'");
//  	ПоказатьПредупреждение(, ТекстПредупреждения);
//  	Возврат;
//  КонецЕсли;
//  ЗначениеОтбора = Новый Структура("Организация", Организация);
//  ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
//  ДополнительныеПараметры = Новый Структура();
//  ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
//  ОписаниеОповещения = Новый ОписаниеОповещения(
//   "ВыбратьДокументИсточникДляПередачиФНСЗавершение", 
//   ЭтотОбъект, 
//   ДополнительныеПараметры);
//  ОткрытьФорму(ИмяФормы, ПараметрыФормы, , , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
//
Процедура ВыбратьДокументИсточникДляПередачиФНС(Тип, Ссылка, Организация, ВыполняемоеОповещение,
												СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

// Заполняется при наличии в конфигурации библиотеки БЭД:
// Открывает форму подключения к сервису электронных документов.
//
// Параметры:
//  ОрганизацияСсылка - СправочникСсылка.Организации
//  ДополнительныеПараметры - структура
//  ОбработчикЗакрытияФормы - ОписаниеОповещения.
//
// Пример для версии БЭД 1.2.6 и ниже:
//	ЭлектронныеДокументыКлиент.ПредложениеОформитьЗаявлениеНаПодключение(Неопределено, ОрганизацияСсылка);
//
// Пример для версии БЭД 1.2.7 и выше до версии БЭД 1.3.1 (не включительно):
//	ЭлектронныеДокументыКлиент.ПредложениеОформитьЗаявлениеНаПодключение(Неопределено, ОрганизацияСсылка, ДополнительныеПараметры);
//
// Пример для версии БЭД 1.3.1 (включительно) и выше:
//	ЭлектронныеДокументыКлиент.ПредложениеОформитьЗаявлениеНаПодключение(Неопределено, ОрганизацияСсылка, ДополнительныеПараметры, ОбработчикЗакрытияФормы);
//
Процедура ОткрытьФормуПодключенияКСервисуЭлектронныхДокументов(ОрганизацияСсылка, ДополнительныеПараметры, ОбработчикЗакрытияФормы) Экспорт
	
	ОбменСКонтрагентамиКлиент.ПредложениеОформитьЗаявлениеНаПодключение(Неопределено, ОрганизацияСсылка, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти