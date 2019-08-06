&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Параметры.Ключ.Пустая();
	Если ЭтоНовый Тогда
		ТекстПредупреждения = НСтр("ru = 'Копирование входящих сообщений запрещено!';
									|en = 'Копирование входящих сообщений запрещено!'");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	ПрименяетсяФорматОтветаНаТребованиеПояснений_5_02 = КонтекстЭДОСервер.ПрименяетсяФорматОтветаНаТребованиеПояснений_5_02();
	
	ОпределитьВидДокумента(КонтекстЭДОСервер);
	УправлениеЭУ(КонтекстЭДОСервер);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// При записи ответа необходимо перерисовать количество ответов в панели требования. 
	Если ИмяСобытия = "Запись_ОписиИсходящихДокументовВНалоговыеОрганы" 
		И ТипЗнч(Источник) = Тип("СправочникСсылка.ОписиИсходящихДокументовВНалоговыеОрганы")
		ИЛИ	ИмяСобытия = "Запись_ПоясненияКДекларацииПоНДС" 
		И ТипЗнч(Источник) = Тип("ДокументСсылка.ПоясненияКДекларацииПоНДС")
		ИЛИ	ИмяСобытия = "Запись_ПерепискаСКонтролирующимиОрганами" 
		И ТипЗнч(Источник) = Тип("СправочникСсылка.ПерепискаСКонтролирующимиОрганами") Тогда
		
		ПрорисоватьСтатус();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ДокументыРеализацииПолномочийНалоговыхОрганов", , Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СсылкаСрокиНажатие(Элемент)
	
	ОткрытьФорму("Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов.Форма.ФормаСрокиПредставления", , ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяФайла = НавигационнаяСсылкаФорматированнойСтроки;
	
	Результат = ПолучитьВложениеНаСервере(ИмяФайла);
	Если ЗначениеЗаполнено(Результат.ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, Результат.ТекстПредупреждения);
	Иначе
		Если Результат.ВАрхиве Тогда 
			КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 9, 3, Истина);
			Возврат;
		КонецЕсли;
		ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(Результат.АдресДанных, ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаОтветыНажатие(Элемент)
	КонтекстЭДОКлиент.НажатиеНаКнопкуПоказатьОтветыПоТребованию(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеДокументаОснованияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.ДокументОснование);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодготвоитьУведомлениеОНевозможностиОтветитьВСрок(Команда)
	
	ПараметрыУведомления = Новый Структура;
	ПараметрыУведомления.Вставить("Организация", 	Объект.Организация);
	ПараметрыУведомления.Вставить("ВидУведомления", ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов"));
	ПараметрыУведомления.Вставить("Данные", 		Объект.Ссылка);
	
	ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.ФормаОбъекта",  ПараметрыУведомления, ЭтотОбъект.ВладелецФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьОтветНаТребованиеДокументов(Команда)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЗапретитьСозданиеПисьмаВОтветНаТребованиеПоДекларации", Истина);
			
	КонтекстЭДОКлиент.СоздатьОтветНаДокументРеализацииПолномочий(Объект.Ссылка, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузитьВложения(Команда)
	
	СохранитьВложения();

КонецПроцедуры

&НаКлиенте
Процедура КомандаСоздатьОтвет(Команда)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЗапретитьСозданиеПисьмаВОтветНаТребованиеПоДекларации", Истина);
			
	КонтекстЭДОКлиент.СоздатьОтветНаДокументРеализацииПолномочий(Объект.Ссылка, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодтвердитьПрием(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПодтвержденияПриемаИлиОтказаВПриеме", 
		ЭтотОбъект);
		
	КонтекстЭДОКлиент.СоздатьРезультатПриемаВходящейОписиИнтерактивноПоДокументуОписи(Объект.Ссылка, Истина, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтказатьВПриеме(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПодтвержденияПриемаИлиОтказаВПриеме", 
		ЭтотОбъект);
	
	КонтекстЭДОКлиент.СоздатьРезультатПриемаВходящейОписиИнтерактивноПоДокументуОписи(Объект.Ссылка, Ложь, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьПоясненияПоНДС(Команда)
	КонтекстЭДОКлиент.СоздатьПоясненияКДекларацииПоНДС(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьПоясненияПисьмом(Команда)
	КонтекстЭДОКлиент.СоздатьПисьмоВОтветНаДокументРеализацииПолномочий(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросАктаСверкиРасчетов(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов"));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросВыпискиОперацийИзКарточкиРасчетыСБюджетом(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеВыпискиОперацийИзКарточкиРасчетыСБюджетом"));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросСпискаПредставленнойОтчетности(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеПеречняБухгалтерскойИНалоговойОтчетности"));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросСправкиОбИсполненииОбязанностейПоУплате(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеСправкиОбИсполненииОбязанностейПоУплате"));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросСправкиОСостоянииРасчетовСБюджетом(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеСправкиОСостоянииРасчетовСБюджетом"));
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьВложениеНаСервере(ИмяФайла)
	
	Результат = Новый Структура("ТекстПредупреждения, АдресДанных, ВАрхиве", "",, Ложь);
	
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		Результат.ТекстПредупреждения = ТекстСообщения;
		Возврат Результат;
	КонецЕсли;
	
	// получаем вложение
	СтрВложения = КонтекстЭДОСервер.ПолучитьФайлыДокументовРеализацииПолномочийНалоговыхОрганов(Объект.Ссылка, ИмяФайла);
	Если СтрВложения.Количество() = 0 Тогда
		Результат.ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вложение с именем  %1 не обнаружено.';
																									|en = 'Вложение с именем  %1 не обнаружено.'"), Символ(34) + ИмяФайла + Символ(34));
		Возврат Результат;
	КонецЕсли;
	
	Вложение = СтрВложения[0];
	
	Если Вложение.ВАрхиве Тогда 
		Результат.ВАрхиве = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Адрес = ПоместитьВоВременноеХранилище(Вложение.Данные.Получить(), УникальныйИдентификатор);
	Результат.АдресДанных = Адрес;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПроверитьВложения(Всего, ВАрхиве)
	
	КонтекстМодуля = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ВложенияОснования = КонтекстМодуля.ПолучитьФайлыДокументовРеализацииПолномочийНалоговыхОрганов(Объект.Ссылка);
	
	Всего = 0;
	ВАрхиве = 0;
	
	Для Каждого Вложение Из ВложенияОснования Цикл 
		ВАрхиве = ВАрхиве + ?(Вложение.ВАрхиве, 1, 0);
		Всего = Всего + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложения()
	
	МассивИменВложений = Новый Массив;
	Для Каждого Элемент Из Вложения Цикл
		МассивИменВложений.Добавить(Элемент.Значение.ИмяФайла);
	КонецЦикла;
	
	Если МассивИменВложений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Всего = 0;
	ВАрхиве = 0;
	ПроверитьВложения(Всего, ВАрхиве);
	
	ВхПараметры = Новый Структура("МассивИменВложений", МассивИменВложений);
	
	Если ВАрхиве > 0 Тогда 
		ВсеВАрхиве = ?(ВАрхиве = Всего, 1, 0);		
		Описание = Новый ОписаниеОповещения("СохранитьВложенияПослеПроверкиЗавершение", ЭтотОбъект, ВхПараметры);
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(Описание, 18 + ВсеВАрхиве, 0, ?(ВсеВАрхиве = 1, Истина, Ложь));
		Возврат;
	КонецЕсли;
	
	СохранитьВложенияПослеПроверкиЗавершение(КодВозвратаДиалога.Да, ВхПараметры);
			
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложенияПослеПроверкиЗавершение(Результат, ВхПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		
		МассивОписанийПолучаемыеФайлы = ПолучитьМассивОписанийФайловВложений(ВхПараметры.МассивИменВложений);
		ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда 
		Закрыть();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивОписанийФайловВложений(МассивИменВложений)
	
	МассивОписаний = Новый Массив;
	
	Для Каждого ИмяВложения Из МассивИменВложений Цикл 
		Результат = ПолучитьВложениеНаСервере(ИмяВложения);
		Если ЗначениеЗаполнено(Результат.АдресДанных) Тогда 
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ИмяВложения, Результат.АдресДанных); 
			МассивОписаний.Добавить(ОписаниеФайла);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат МассивОписаний;
	
КонецФункции

&НаСервере
Функция ПрорисоватьСтатус()
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Объект.Ссылка, Объект.Организация, "ФНС");
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(ЭтаФорма, ПараметрыПрорисовкиПанелиОтправки);
	ПрорисоватьПанельПриема();
			
КонецФункции

&НаСервере
Процедура ПрорисоватьПанельПриема()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ТекущееСостояниеОтправки = КонтекстЭДОСервер.ТекущееСостояниеОтправки(Объект.Ссылка, Перечисления.ТипыКонтролирующихОрганов.ФНС);

	ГруппаКнопкиПриемаВидимость 	= Ложь;
	Элементы.ГиперссылкаОтветы.Заголовок = "";
	
	Если ТекущееСостояниеОтправки <> Неопределено Тогда
		ТекущийЭтапОтправки = ТекущееСостояниеОтправки.ТекущийЭтапОтправки;
		Если ТекущийЭтапОтправки <> Неопределено Тогда
			
			СостояниеСдачиОтчетности = ТекущийЭтапОтправки.СостояниеСдачиОтчетности;
			
			ГруппаКнопкиПриемаВидимость = (СостояниеСдачиОтчетности = Перечисления.СостояниеСдачиОтчетности.ТребуетсяПодтверждениеПриема);
			Элементы.ГиперссылкаОтветы.Заголовок = ТекущийЭтапОтправки.КоличествоОтветов;
			
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаПанельПриема.Видимость = ГруппаКнопкиПриемаВидимость;
	Элементы.ОтступПередКнопкойОбновитьОтправку.Видимость 	= Истина;
	
	Если ЭтоТребованиеФНС Тогда
		
		Элементы.ЗаголовокНеотправленныхСообщений.Заголовок = 
			НСтр("ru = 'Оператору не отправлено извещение о получении документа';
				|en = 'Оператору не отправлено извещение о получении документа'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВидДокумента(КонтекстЭДОСервер)

	ЭтоТребованиеОПредставленииДокументов = 
		Объект.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииДокументов;
		
	ЭтоТребованиеОПредставленииПояснений = 
		Объект.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииПоясненийКДекларацииНДС;
		
	ЭтоТребованиеФНС = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоТребованиеФНС(Объект.Ссылка);
		
	ВТребованииЕстьXMLФайл = КонтекстЭДОСервер.ЕстьТребованияКРазделам8_12(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭУ(КонтекстЭДОСервер)
	
	Заголовок = Объект.Наименование;
	
	Элементы.Тема.Заголовок = Заголовок;
	Элементы.ТекстПисьма.Заголовок = "Приложенные файлы:";
	
	ПрорисоватьПриложения();
	
	ОписьВходящихДокументов = ДокументооборотСКОВызовСервера.ПолучитьОписьВходящихДокументовПоТребованию(Объект.Ссылка);
	
	Элементы.ГруппаСрокиПредставления.Видимость = ЭтоТребованиеФНС;
	
	Если ЭтоТребованиеОПредставленииДокументов Тогда
		Элементы.СсылкаСроки.Видимость = Ложь;
		Элементы.ИнформацияСроки.Заголовок = 
			НСтр("ru = 'Обратите внимание на срок представления документов, указанный в приложенном файле';
				|en = 'Обратите внимание на срок представления документов, указанный в приложенном файле'");
	КонецЕсли;
		
	Если ЭтоТребованиеОПредставленииПояснений Тогда
		
		Элементы.КомандаСоздатьОтвет.Заголовок = 
			НСтр("ru = 'Подготовить пояснения';
				|en = 'Подготовить пояснения'");
		Элементы.ИнформацияСроки.Заголовок = 
			НСтр("ru = 'Ответ на требование должен быть направлен в течение 5 дней с момента получения';
				|en = 'Ответ на требование должен быть направлен в течение 5 дней с момента получения'");
			
	КонецЕсли;
	
	ЭтоФормализованноеТребованиеПоНДС = ЭтоТребованиеОПредставленииПояснений И ВТребованииЕстьXMLФайл;
	// Требование пояснений может быть к декларации НДС и к прочим расчетам.
	// Если требование содержит только pdf-файл, то это может быть как требование к декларации НДС так и к прочим расчетам.
	// Если требование содержит xml-файл, то это только требование к декларации НДС.
	
	Элементы.ГруппаОтветовНаТребованиеДокументов.Видимость = ЭтоТребованиеОПредставленииДокументов;
	
	Элементы.ГруппаОтветовНаТребованиеПояснений.Видимость = 
		ЭтоТребованиеОПредставленииПояснений 
		И НЕ ВТребованииЕстьXMLФайл 
		И ПрименяетсяФорматОтветаНаТребованиеПояснений_5_02;
		
	ЭтоУведомление = НЕ ЭтоТребованиеФНС;
		
	Элементы.КомандаСоздатьОтвет.Видимость = 
		(ЭтоФормализованноеТребованиеПоНДС ИЛИ ЭтоУведомление) И ПрименяетсяФорматОтветаНаТребованиеПояснений_5_02
		ИЛИ НЕ ПрименяетсяФорматОтветаНаТребованиеПояснений_5_02 И НЕ ЭтоТребованиеОПредставленииДокументов;
	
	Элементы.ЗапроситьСверку.Видимость =
		Объект.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОбУплатеНалогаСбораПениШтрафа;
		
	ПрорисоватьПодписанта();
	УстановитьПредставлениеДокументаОснования(КонтекстЭДОСервер);
	
	ПрорисоватьСтатус();
	
КонецПроцедуры

&НаСервере
Функция ПрорисоватьПриложения()
	
	ВсеВложенияТребования = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьВложенияДокументовРеализацииПолномочийНалоговыхОрганов(Объект.Ссылка);
	
	Если ЭтоТребованиеОПредставленииПояснений Тогда
		// Не показываем xml-файлы, если это требование о представлении пояснений к декларации по НДС
		Для каждого ПриложениеТребования Из ВсеВложенияТребования Цикл
			
			СвойстваФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПриложениеТребования.ИмяФайла);
			
			Если ВРЕГ(СвойстваФайла.Расширение) <> ВРЕГ(".xml") Тогда
				Вложения.Добавить(ПриложениеТребования);
			КонецЕсли;
		
		КонецЦикла;
	Иначе
		Вложения.ЗагрузитьЗначения(ВсеВложенияТребования);
	КонецЕсли;
	
	Элементы.Вложения.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ФорматированноеПредставлениеСпискаВложений(Вложения.ВыгрузитьЗначения());
	
КонецФункции

&НаКлиенте
Процедура ПослеПодтвержденияПриемаИлиОтказаВПриеме(Результат, ВходящийКонтекст) Экспорт
	
	ПрорисоватьСтатус();
	
	// Перерисовываем другие формы при необходимости
	ОповеститьОбОкончанииОтправки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбОкончанииОтправки()
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	ПараметрыОповещения.Вставить("Ссылка", 		Объект.Ссылка);
	
	Оповестить("Завершение отправки", ПараметрыОповещения, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПрорисоватьПодписанта()
	
	// Текст подсказки
	НалоговыйОрганПодсказка = СокрЛП(Объект.ПодписантДолжность + " " + Объект.ПодписантФИО);
	
	Если ЗначениеЗаполнено(Объект.ПодписантТелефон) Тогда
		ПодписантТелефон = НСтр("ru = 'тел: ';
								|en = 'тел: '") + Объект.ПодписантТелефон;
	Иначе
		ПодписантТелефон = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ПодписантПочта) Тогда
		ПодписантПочта = НСтр("ru = 'e-mail: ';
								|en = 'e-mail: '") + Объект.ПодписантПочта;
	Иначе
		ПодписантПочта = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПодписантТелефон) И ЗначениеЗаполнено(ПодписантПочта) Тогда
		КонтактныеДанныеПодписанта = ПодписантТелефон + ", " + ПодписантПочта;
	ИначеЕсли ЗначениеЗаполнено(ПодписантТелефон) Тогда
		КонтактныеДанныеПодписанта = ПодписантТелефон;
	Иначе
		КонтактныеДанныеПодписанта = ПодписантПочта;
	КонецЕсли;
	
	НалоговыйОрганПодсказка = СокрЛП(НалоговыйОрганПодсказка + Символы.ПС + КонтактныеДанныеПодписанта);
	
	Элементы.НалоговыйОрган.РасширеннаяПодсказка.Заголовок = НалоговыйОрганПодсказка;
	
	// Отображение подсказки
	Если ЗначениеЗаполнено(НалоговыйОрганПодсказка) Тогда
		Элементы.НалоговыйОрган.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	Иначе
		Элементы.НалоговыйОрган.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеДокументаОснования(КонтекстЭДОСервер)
	
	// Представление
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		СведенияПоОбъекту = КонтекстЭДОСервер.СведенияПоОтправляемымОбъектам(Объект.ДокументОснование);
		ПредставлениеДокументаОснования = СведенияПоОбъекту.Наименование;
		
		Если НЕ ЗначениеЗаполнено(ПредставлениеДокументаОснования) Тогда
			ПредставлениеДокументаОснования = Строка(Объект.ДокументОснование);
		КонецЕсли;
	Иначе
		ПредставлениеДокументаОснования = "";
	КонецЕсли;
	
	// Видимость
	Элементы.ПредставлениеДокументаОснования.Видимость = 
		ЗначениеЗаполнено(Объект.ДокументОснование)
		И ЗначениеЗаполнено(ПредставлениеДокументаОснования);

КонецПроцедуры

#КонецОбласти

