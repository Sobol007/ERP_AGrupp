#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	
	Если ЗначениеЗаполнено(Отчет.Уведомление) Тогда
		ИнициализироватьРеквизитыФормыПоУведомлению();
	Иначе
		НайтиУведомление("Последний");
	КонецЕсли;
	
	КонтролируемыеСделки.ЗаполнитьСписокГоловныхОрганизаций(Элементы.Организация.СписокВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
	ИБФайловая = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	ЗаголовокДекорацияУведомлениеНеНайдено = НСтр("ru = 'За %ОтчетныйГод% год уведомлений нет';
													|en = 'Notifications are missing for %ОтчетныйГод%'");
	ТекстУведомлениеНеНайдено = СтрЗаменить(ЗаголовокДекорацияУведомлениеНеНайдено, "%ОтчетныйГод%", Формат(Отчет.ОтчетныйГод,"ЧГ="));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	УведомлениеДоЗагрузкиНастроек = Отчет.Уведомление;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	Если УведомлениеДоЗагрузкиНастроек <> Отчет.Уведомление Тогда
		Отчет.Уведомление = УведомлениеДоЗагрузкиНастроек;
		ИнициализироватьРеквизитыФормыПоУведомлению();
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ДействияКомандныхПанелейФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	НайтиУведомление("Последний");
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйГодПриИзменении(Элемент)
	
	НомерКорректировки = 0;
	НайтиУведомление("Последний");
	Отчет.НачалоПериода = НачалоГода(Дата(Отчет.ОтчетныйГод,1,1));
	Отчет.КонецПериода = КонецГода(Дата(Отчет.ОтчетныйГод,12,31,23,59,59));
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипУведомленияПриИзменении(Элемент)
	
	Если ТипУведомления = 0 Тогда
		НомерКорректировки = 0;
		НайтиУведомление("Указанный");
	Иначе
		НайтиУведомление("Последний");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НомерКорректировкиРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НомерКорректировки = НомерКорректировки + Направление;
	НайтиУведомление(?(Направление > 0,"Следующий","Предыдущий"));
	
КонецПроцедуры

&НаКлиенте
Процедура НомерКорректировкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	НомерКорректировки = Число(Текст);
	НайтиУведомление("Указанный");
	
КонецПроцедуры


&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Контрагент", );
	СтруктураДанных.Вставить("Организация", );
	СтруктураДанных.Вставить("НачалоПериода", );
	СтруктураДанных.Вставить("ТипВзаимозависимости", );
	
	ДанныеОткрываемойФормы = ПолучитьДанныеОткрываемойФормыПоРасшифровке(Расшифровка, СтруктураДанных);
	ФормаДляОткрытия = Неопределено;
	
	Если ДанныеОткрываемойФормы.Свойство("ФормаДляОткрытия", ФормаДляОткрытия) И ЗначениеЗаполнено(ДанныеОткрываемойФормы.ФормаДляОткрытия) Тогда
		
		ОткрытьФорму(ФормаДляОткрытия, ДанныеОткрываемойФормы.ПараметрыФормы, , ДанныеОткрываемойФормы.ЗначениеУникальности);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыГруппировка

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыОтборы

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыДополнительныеПоля

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыСортировка

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыОформление

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийПоляТабличногоДокумента

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРасшифровки(Элемент, ИмяПоля)
	
	Если ТипЗнч(Элемент) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Поле = Элемент.ПолучитьПоля().Найти(ИмяПоля);
		Если Поле <> Неопределено Тогда
			Возврат(Поле.Значение);
		КонецЕсли;
	КонецЕсли;
	
	Родители  = Элемент.ПолучитьРодителей();
	Если Родители.Количество()>0 Тогда
		Возврат(ПолучитьЗначениеРасшифровки(Родители[0], ИмяПоля));
	КонецЕсли;
	
    Возврат(Неопределено);
	
КонецФункции

&НаСервере
Процедура УстановитьДоступностьСвойствУведомления()
	
	Если Не ЗначениеЗаполнено(Отчет.Уведомление) И ЗначениеЗаполнено(Отчет.Организация) Тогда
		Элементы.СтраницыУведомления.ТекущаяСтраница = Элементы.СтраницаУведомленийНеНайдено;
		ЗаголовокДекорацияУведомлениеНеНайдено = НСтр("ru = 'За %ОтчетныйГод% год уведомлений нет';
														|en = 'Notifications are missing for %ОтчетныйГод%'");
		ТекстУведомлениеНеНайдено = СтрЗаменить(ЗаголовокДекорацияУведомлениеНеНайдено, "%ОтчетныйГод%", Формат(Отчет.ОтчетныйГод,"ЧГ="));	
	Иначе
		Элементы.СтраницыУведомления.ТекущаяСтраница = Элементы.СтраницаСписокУведомлений;
	КонецЕсли;
	ЭтаФорма.Элементы.НомерКорректировки.Доступность = ТипУведомления <> 0;
	УстановитьПараметрУведомление(Отчет);
	
	Элементы.Сформировать.Доступность = ЗначениеЗаполнено(Отчет.Уведомление);
	Элементы.ПрименитьНастройки.Доступность = ЗначениеЗаполнено(Отчет.Уведомление);
	Элементы.СформироватьВсеДействия.Доступность = ЗначениеЗаполнено(Отчет.Уведомление);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеОткрываемойФормыПоРасшифровке(Расшифровка, СтруктураПолей)
	
	// Сформируем структуру данных расшифровки:
	
	Данные_Расшифровки = ПолучитьИзВременногоХранилища(ДанныеРасшифровки).ДанныеРасшифровки;
	
	СтруктураДанных = Новый Структура();
	
	Уведомление = Данные_Расшифровки.Настройки.ПараметрыДанных.Элементы.Найти("Уведомление");
	Если Уведомление <> Неопределено Тогда
		СтруктураДанных.Вставить("Уведомление", Уведомление.Значение);
		Если ЗначениеЗаполнено(СтруктураДанных.Уведомление) Тогда
			ПараметрыУведомления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктураДанных.Уведомление, "Организация, ОтчетныйГод");
			СтруктураДанных.Вставить("Организация", ПараметрыУведомления.Организация);
		КонецЕсли;
		
	Иначе
		Организация = Данные_Расшифровки.Настройки.ПараметрыДанных.Элементы.Найти("Организация");
		СтруктураДанных.Вставить("Организация", ПараметрыУведомления.Организация);
		ДатаОкончания = Данные_Расшифровки.Настройки.ПараметрыДанных.Элементы.Найти("ДатаОкончания");
	КонецЕсли;
	
	Если Данные_Расшифровки <> Неопределено Тогда
		Для каждого ЭлементДанных Из СтруктураПолей Цикл
			Родитель = Данные_Расшифровки.Элементы[Расшифровка];
			ЗначениеРасшифровки = ПолучитьЗначениеРасшифровки(Родитель, ЭлементДанных.Ключ);
			Если ЗначениеРасшифровки <> Неопределено Тогда
				СтруктураДанных.Вставить(ЭлементДанных.Ключ, ЗначениеРасшифровки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// На основании структуры данных расшифровки решим какие формы и с какими параметрами открывать:
	
	СтруктураВозврата = Новый Структура("ЗначениеУникальности", СтруктураДанных.Контрагент);
	
	Если НЕ СтруктураДанных.Свойство("ТипВзаимозависимости") Тогда
		ИмяФормы = СтрЗаменить("Справочник.ИмяОбъекта.ФормаОбъекта", "ИмяОбъекта", ?(ТипЗнч(СтруктураДанных.Контрагент) = Тип("СправочникСсылка.Организации"), "Организации", "Контрагенты"));
		СтруктураВозврата.Вставить("ФормаДляОткрытия", ИмяФормы);
		СтруктураВозврата.Вставить("ПараметрыФормы", Новый Структура("Ключ", СтруктураДанных.Контрагент));
	Иначе
		ПараметрыОткрытияФормы = РегистрыСведений.ВзаимозависимыеЛица.ПолучитьПараметрыОткрытияФормыЗаписиВзаимозависимогоЛица(
			СтруктураДанных.Организация, СтруктураДанных.Контрагент, СтруктураДанных.НачалоПериода);
		Если ПараметрыОткрытияФормы<>Неопределено Тогда
			СтруктураВозврата.Вставить("ФормаДляОткрытия", "РегистрСведений.ВзаимозависимыеЛица.ФормаЗаписи");
			СтруктураВозврата.Вставить("ПараметрыФормы", ПараметрыОткрытияФормы);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураВозврата;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрУведомление(Отчет)
	
	Настройки = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных;
	ПользовательскиеНастройки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	Для Каждого Элемент Из ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Элемент.Параметр = Новый ПараметрКомпоновкиДанных("Уведомление") Тогда
			Элемент.Значение = Отчет.Уведомление;
		ИначеЕсли ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Элемент.Параметр = Новый ПараметрКомпоновкиДанных("ОкончаниеПериода") Тогда
			Элемент.Значение = КонецГода(Отчет.Уведомление.Дата);
		ИначеЕсли ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Элемент.Параметр = Новый ПараметрКомпоновкиДанных("НачалоПериода") Тогда
			Элемент.Значение = НачалоГода(Отчет.Уведомление.Дата);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НайтиУведомление(ТипПоиска)
	
	Если Не ЗначениеЗаполнено(Отчет.ОтчетныйГод) Тогда 
		Отчет.ОтчетныйГод = Год(ТекущаяДатаСеанса());
	КонецЕсли;
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		
		НайденноеУведомление = КонтролируемыеСделки.НайтиУведомлениеОрганизацииВОтчетномГоду(Отчет.Организация,Отчет.ОтчетныйГод,ЭтаФорма.ТипУведомления,ЭтаФорма.НомерКорректировки,ТипПоиска);
		
		Если НайденноеУведомление <> Неопределено Тогда
			Отчет.Уведомление = НайденноеУведомление;
		ИначеЕсли ЗначениеЗаполнено(Отчет.Уведомление) Тогда
			Если Отчет.Уведомление.Организация = Отчет.Организация Тогда
				НомерКорректировки = Отчет.Уведомление.НомерКорректировки;
				ТипУведомления = ?(НомерКорректировки = 0,0,1);
				Отчет.ОтчетныйГод = Год(Отчет.Уведомление.ОтчетныйГод);
			Иначе
				Отчет.Уведомление = Неопределено;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Отчет.Уведомление = Неопределено;
	КонецЕсли;
	
	УстановитьДоступностьСвойствУведомления();
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("ОтчетныйГод"                   	, Отчет.ОтчетныйГод);
	ПараметрыОтчета.Вставить("НачалоПериода"                   	, НачалоГода(Дата(Отчет.ОтчетныйГод,1,1)));
	ПараметрыОтчета.Вставить("КонецПериода"                   	, КонецГода(Дата(Отчет.ОтчетныйГод,12,31,23,59,59)));
	ПараметрыОтчета.Вставить("Уведомление"                   	, Отчет.Уведомление);
	
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , Отчет.РазмещениеДополнительныхПолей);

	ПараметрыОтчета.Вставить("Группировка"                      , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , Отчет.ДополнительныеПоля.Выгрузить());

	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодписи);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = НСтр("ru = 'Сведения о взаимозависимых лицах за %ОтчетныйГод% г.';
							|en = 'Information about interdependent persons for %ОтчетныйГод%'");
	ЗаголовокОтчета = СтрЗаменить(ЗаголовокОтчета, "%ОтчетныйГод%", Формат(Отчет.ОтчетныйГод, "ЧГ=0"));

	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	СписокПолей.Добавить("Регистратор");
	СписокПолей.Добавить("НачалоПериода");
	СписокПолей.Добавить("Организация");
	СписокПолей.Добавить("Валюта");
	СписокПолей.Добавить("ЕдиницаИзмерения");
	
	СписокПолей.Добавить("НевзаимозависимыйПосредник");
	СписокПолей.Добавить("ОкончаниеПериода");
	СписокПолей.Добавить("ФизическоеЛицо");
	СписокПолей.Добавить("КонтрагентЮрФизЛицо");
	СписокПолей.Добавить("СтранаРегистрацииПредставление");
	СписокПолей.Добавить("Организация");
	СписокПолей.Добавить("ЗарегистрированВОЭЗ");
	СписокПолей.Добавить("ЯвляетсяПлательщикомЕНВД");
	СписокПолей.Добавить("ЯвляетсяПлательщикомЕСХН");
	СписокПолей.Добавить("ЯвляетсяПлательщикомНалогаНаПрибыль");
	СписокПолей.Добавить("ЯвляетсяПлательщикомНДПИ");
	СписокПолей.Добавить("ПрименяетИнвестиционныйВычетПоНалогуНаПрибыль");
	СписокПолей.Добавить("ПрименяетЛьготыУчастникаРегиональногоИнвестиционногоПроекта");
	СписокПолей.Добавить("ОсвобожденОтУплатыНДС");
	СписокПолей.Добавить("ВзаимозависимыеЛица");
	СписокПолей.Добавить("ОкончаниеПериода");
	СписокПолей.Добавить("СуммаБезНДСВРублях");
	СписокПолей.Добавить("ФизическоеЛицо");
	СписокПолей.Добавить("КонтрагентЮрФизЛицо");
	СписокПолей.Добавить("КодВидаДеятельностиФизическогоЛица");
	СписокПолей.Добавить("КодНалогоплательщикаВСтранеРегистрации");
	СписокПолей.Добавить("РегистрационныйНомерВСтранеРегистрации");
	СписокПолей.Добавить("ЗарегистрированВОфшоре");
	СписокПолей.Добавить("СтранаРегистрацииПредставление");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	Если  Режим = "Выбор" Тогда
	ИначеЕсли Режим = "Отбор" ИЛИ Режим = "Порядок" ИЛИ Режим = "Группировка" Тогда
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
		
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодписи);

	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьРеквизитыФормыПоУведомлению()
	
	Отчет.Организация = Отчет.Уведомление.Организация;
	Отчет.ОтчетныйГод = Год(Отчет.Уведомление.ОтчетныйГод);
	Отчет.НачалоПериода = НачалоГода(Дата(Отчет.ОтчетныйГод,1,1));
	Отчет.КонецПериода = КонецГода(Дата(Отчет.ОтчетныйГод,12,31,23,59,59));
	НомерКорректировки = Отчет.Уведомление.НомерКорректировки;
	ТипУведомления = ?(НомерКорректировки = 0,0,1);
	
	УстановитьДоступностьСвойствУведомления();
	
КонецПроцедуры

#КонецОбласти