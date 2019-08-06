///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	ИнициализироватьРеквизитыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекстПредупреждения = НСтр("ru = 'Отказаться от удаления настройки синхронизации данных?';
								|en = 'Refuse to remove data synchronization setting?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытьФормуБезусловно = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УдалениеНастройкиСинхронизации

&НаКлиенте
Процедура ПриНачалеУдаленияНастройкиСинхронизации()
	
	ПродолжитьОжидание = Истина;
	
	Если ПодключениеЧерезВнешнееСоединение Тогда
		Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая() Тогда
			ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
		КонецЕсли;
	КонецЕсли;
	
	ПриНачалеУдаленияНастройкиСинхронизацииНаСервере(ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ОбменДаннымиКлиент.ИнициализироватьПараметрыОбработчикаОжидания(
			ПараметрыОбработчикаОжидания);
			
		ПодключитьОбработчикОжидания("ПриОжиданииУдаленияНастройкиСинхронизации",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииУдаленияНастройкиСинхронизации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииУдаленияНастройкиСинхронизации()
	
	ПродолжитьОжидание = Ложь;
	ПриОжиданииУдаленияНастройкиСинхронизацииНаСервере(ЭтоОбменСПриложениемВСервисе,
		ПараметрыОбработчика, ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ОбменДаннымиКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		
		ПодключитьОбработчикОжидания("ПриОжиданииУдаленияНастройкиСинхронизации",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПараметрыОбработчикаОжидания = Неопределено;
		ПриЗавершенииУдаленияНастройкиСинхронизации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииУдаленияНастройкиСинхронизации()
	
	СообщениеОбОшибке = "";
	
	НастройкаУдалена = Истина;
	НастройкаУдаленаВКорреспонденте = Истина;
	
	ПриЗавершенииУдаленияНастройкиСинхронизацииНаСервере(НастройкаУдалена,
		НастройкаУдаленаВКорреспонденте, СообщениеОбОшибке);
	
	Если НастройкаУдалена Тогда
		ИзменитьПорядковыйНомерПерехода(+1);
		
		Если УдалитьНастройкуВКорреспонденте
			И НастройкаУдаленаВКорреспонденте Тогда
			Элементы.ДекорацияСинхронизацияУдаленаНадпись.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Настройки синхронизации данных в этой программе
				|и программе ""%1"" успешно удалены.';
				|en = 'Data synchronization settings in this application
				|and the ""%1"" application are deleted successfully.'"),
				НаименованиеКорреспондента);
		КонецЕсли;
		
	Иначе
		ИзменитьПорядковыйНомерПерехода(-1);
		
		Если Не ПустаяСтрока(СообщениеОбОшибке) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке);
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не удалось удалить настройку синхронизации данных.';
					|en = 'Cannot remove data synchronization setting.'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриНачалеУдаленияНастройкиСинхронизацииНаСервере(ПродолжитьОжидание)
	
	НастройкиУдаления = Новый Структура;
	
	Если ЭтоОбменСПриложениемВСервисе Тогда
		
		НастройкиУдаления.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
		НастройкиУдаления.Вставить("ОбластьДанныхКорреспондента", ОбластьДанныхКорреспондента);
		
		МодульПомощникУдаленияНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
		
	Иначе
		
		НастройкиУдаления.Вставить("УзелОбмена", УзелОбмена);
		НастройкиУдаления.Вставить("УдалитьНастройкуВКорреспонденте", УдалитьНастройкуВКорреспонденте);
		
		МодульПомощникУдаленияНастройки = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
		
	КонецЕсли;
	
	Если МодульПомощникУдаленияНастройки = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	МодульПомощникУдаленияНастройки.ПриНачалеУдаленияНастройкиСинхронизации(НастройкиУдаления,
		ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииУдаленияНастройкиСинхронизацииНаСервере(ЭтоОбменСПриложениемВСервисе, ПараметрыОбработчика, ПродолжитьОжидание)
	
	Если ЭтоОбменСПриложениемВСервисе Тогда
		МодульПомощникУдаленияНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	Иначе
		МодульПомощникУдаленияНастройки = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	КонецЕсли;
	
	Если МодульПомощникУдаленияНастройки = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	ПродолжитьОжидание = Ложь;
	МодульПомощникУдаленияНастройки.ПриОжиданииУдаленияНастройкиСинхронизации(ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииУдаленияНастройкиСинхронизацииНаСервере(НастройкаУдалена, НастройкаУдаленаВКорреспонденте, СообщениеОбОшибке)
	
	Если ЭтоОбменСПриложениемВСервисе Тогда
		МодульПомощникУдаленияНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	Иначе
		МодульПомощникУдаленияНастройки = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	КонецЕсли;
	
	Если МодульПомощникУдаленияНастройки = Неопределено Тогда
		НастройкаУдалена = Ложь;
		НастройкаУдаленаВКорреспонденте = Ложь;
		Возврат;
	КонецЕсли;
	
	СтатусЗавершения = Неопределено;
	
	МодульПомощникУдаленияНастройки.ПриЗавершенииУдаленияНастройкиСинхронизации(
		ПараметрыОбработчика, СтатусЗавершения);
		
	Если СтатусЗавершения.Отказ Тогда
		НастройкаУдалена = Ложь;
		
		СообщениеОбОшибке = СтатусЗавершения.СообщениеОбОшибке;
		Возврат;
	Иначе
		НастройкаУдалена = СтатусЗавершения.Результат.НастройкаУдалена;
		НастройкаУдаленаВКорреспонденте = СтатусЗавершения.Результат.НастройкаУдаленаВКорреспонденте;
		
		СообщениеОбОшибке = СтатусЗавершения.СообщениеОбОшибке;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияФормыПриСоздании

&НаСервере
Процедура ИнициализироватьРеквизитыФормы()
	
	УзелОбмена = Параметры.УзелОбмена;
	
	Параметры.Свойство("ИмяПланаОбмена", ИмяПланаОбмена);
	Если Не ЗначениеЗаполнено(ИмяПланаОбмена) Тогда
		ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелОбмена);
	КонецЕсли;
	
	МодельСервиса = ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
		
	Параметры.Свойство("ОбластьДанныхКорреспондента",  ОбластьДанныхКорреспондента);
	Параметры.Свойство("НаименованиеКорреспондента",   НаименованиеКорреспондента);
	Параметры.Свойство("ЭтоОбменСПриложениемВСервисе", ЭтоОбменСПриложениемВСервисе);
	
	Если Не ЗначениеЗаполнено(НаименованиеКорреспондента) Тогда
		НаименованиеКорреспондента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелОбмена, "Наименование");
	КонецЕсли;
	
	ВидТранспорта = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелОбмена);
	ПодключениеOnline = (ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.COM
		Или ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	ЭтоОбменСВнешнейСистемой = (ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.ВнешняяСистема);
	
	ПодключениеЧерезВнешнееСоединение = (ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.COM);
		
	УдалитьНастройкуВКорреспонденте = ПодключениеOnline Или ЭтоОбменСВнешнейСистемой;
	
	ПолучитьПараметрыКорреспондента = МодельСервиса
		И Не Параметры.Свойство("ЭтоОбменСПриложениемВСервисе")
		И Не ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS
		И Не ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WSПассивныйРежим
		И Не ЭтоОбменСВнешнейСистемой;
	
	ЗаполнитьТаблицуПереходов();
	
КонецПроцедуры

#КонецОбласти

#Область СценарииРаботыПомощника

&НаСервере
Функция ДобавитьСтрокуТаблицыПереходов(ИмяОсновнойСтраницы, ИмяСтраницыНавигации, ИмяСтраницыДекорации = "")
	
	СтрокаПереходов = ТаблицаПереходов.Добавить();
	СтрокаПереходов.ПорядковыйНомерПерехода = ТаблицаПереходов.Количество();
	СтрокаПереходов.ИмяОсновнойСтраницы = ИмяОсновнойСтраницы;
	СтрокаПереходов.ИмяСтраницыНавигации = ИмяСтраницыНавигации;
	СтрокаПереходов.ИмяСтраницыДекорации = ИмяСтраницыДекорации;
	
	Возврат СтрокаПереходов;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуПереходов()
	
	ТаблицаПереходов.Очистить();
	
	Если ПолучитьПараметрыКорреспондента Тогда
		НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаПолучениеПараметровКорреспондента", "СтраницаНавигацияОжидание");
		НовыйПереход.ДлительнаяОперация = Истина;
		НовыйПереход.ИмяОбработчикаДлительнойОперации = "СтраницаПолучениеПараметровКорреспондента_ДлительнаяОперация";
	КонецЕсли;
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаНачало", "СтраницаНавигацияНачало");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаНачало_ПриОткрытии";
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаОжидание", "СтраницаНавигацияОжидание");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаОжидание_ПриОткрытии";
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаОкончание", "СтраницаНавигацияОкончание");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаОкончание_ПриОткрытии";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПереходов

&НаКлиенте
Функция Подключаемый_СтраницаПолучениеПараметровКорреспондента_ДлительнаяОперация(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	ПриНачалеПолученияСпискаПриложений();
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаНачало_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.ГруппаНачалоДополнительно.Видимость = ПодключениеOnline Или ЭтоОбменСВнешнейСистемой;
	
	Если ЭтоОбменСВнешнейСистемой Тогда
		Элементы.УдалитьНастройкуВКорреспонденте.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Удалить настройку обмена с системой ""%1"" на Портале 1С:ИТС.';
				|en = 'Delete exchange with the ""%1"" system settings on 1C:ITS Portal.'"),
			НаименованиеКорреспондента);
	Иначе
		Элементы.УдалитьНастройкуВКорреспонденте.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Удалить настройку также в программе ""%1"".';
				|en = 'Also delete the setting in the ""%1"" application.'"),
			НаименованиеКорреспондента);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаОжидание_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеУдаленияРазрешений", ЭтотОбъект, УзелОбмена);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		Запросы = ОбменДаннымиВызовСервера.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(УзелОбмена);
		МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
		МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, Неопределено, ОповещениеОЗакрытии);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.ОК);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаОжидание_ДлительнаяОперация(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаОкончание_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Оповестить("Запись_УзелПланаОбмена");
	ЗакрытьФормы("ФормаУзла");
	ЗакрытьФормы("НастройкаСинхронизации");
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область ДополнительныеОбработчикиПереходов

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 1 Тогда
		
		ПорядковыйНомерПерехода = 1;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.';
								|en = 'Page for displaying is not defined.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Элементы.ПанельНавигации.ТекущаяСтраница.Доступность = Не (ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация);
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
		
			// Обработчик ПриПереходеДалее.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
		
			// Обработчик ПриПереходеНазад.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.';
								|en = 'Page for displaying is not defined.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.';
								|en = 'Page for displaying is not defined.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ПриНачалеПолученияСпискаПриложений()
	
	ПараметрыОбработчика = Неопределено;
	ПродолжитьОжидание = Ложь;
	
	ПриНачалеПолученияСпискаПриложенийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание);
		
	Если ПродолжитьОжидание Тогда
		ОбменДаннымиКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			
		ПодключитьОбработчикОжидания("ПриОжиданииПолученияСпискаПриложений",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииПолученияСпискаПриложений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииПолученияСпискаПриложений()
	
	ПродолжитьОжидание = Ложь;
	ПриОжиданииПолученияСпискаПриложенийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ОбменДаннымиКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		
		ПодключитьОбработчикОжидания("ПриОжиданииПолученияСпискаПриложений",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПараметрыОбработчикаОжидания = Неопределено;
		ПриЗавершенииПолученияСпискаПриложений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииПолученияСпискаПриложений()
	
	ПерейтиДалее = Истина;
	ПриЗавершенииПолученияСпискаПриложенийНаСервере(ПерейтиДалее);
	
	Если ПерейтиДалее Тогда
		ИзменитьПорядковыйНомерПерехода(+1);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриНачалеПолученияСпискаПриложенийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникНастройки = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыПомощника = Новый Структура("Режим", "НастроенныеОбмены");
	
	МодульПомощникНастройки.ПриНачалеПолученияСпискаПриложений(ПараметрыПомощника,
		ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииПолученияСпискаПриложенийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникНастройки = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	МодульПомощникНастройки.ПриОжиданииПолученияСпискаПриложений(
		ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииПолученияСпискаПриложенийНаСервере(ПерейтиДалее)
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтатусЗавершения = Неопределено;
	МодульПомощникНастройки.ПриЗавершенииПолученияСпискаПриложений(ПараметрыОбработчика, СтатусЗавершения);
		
	Если Не СтатусЗавершения.Отказ Тогда
		ТаблицаПриложений = СтатусЗавершения.Результат;
		СтрокаПриложение = ТаблицаПриложений.Найти(УзелОбмена, "Корреспондент");
		Если Не СтрокаПриложение = Неопределено Тогда
			ЭтоОбменСПриложениемВСервисе = Истина;
			ОбластьДанныхКорреспондента  = СтрокаПриложение.ОбластьДанных;
			НаименованиеКорреспондента   = СтрокаПриложение.НаименованиеПриложения;
		КонецЕсли;
	Иначе
		ОбщегоНазначения.СообщитьПользователю(СтатусЗавершения.СообщениеОбОшибке);
		ПерейтиДалее = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияРазрешений(Результат, УзелИнформационнойБазы) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ПриНачалеУдаленияНастройкиСинхронизации();
	Иначе
		ИзменитьПорядковыйНомерПерехода(-1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормы(Знач ИмяФормы)
	
	ОкнаПриложения = ПолучитьОкна();
	
	Если ОкнаПриложения = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Для Каждого ОкноПриложения Из ОкнаПриложения Цикл
		Если ОкноПриложения.Основное Тогда
			Продолжить;
		КонецЕсли;
			
		Форма = ОкноПриложения.ПолучитьСодержимое();
		
		Если ТипЗнч(Форма) = Тип("УправляемаяФорма")
			И Не Форма.Модифицированность
			И СтрНайти(Форма.ИмяФормы, ИмяФормы) <> 0 Тогда
			
			Форма.Закрыть();
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти