
////////////////////////////////////////////////////////////////////////////////
//
// Параметры формы:
//
//	 	СохраненныйОтчет					- Документ.РегламентированныйОтчет.Ссылка - документ отчета, 
//											ошибки которого показываются.
// 		ПредставлениеОшибок					- ТабличныйДокумент - Сформированный табличный документ с ошибками.
// 		НазваниеДекларации					- Строка - Представление отчета.
//		АдресХранилищаПредставленияОшибок	- Адрес внутреннего хранилища, в котором сохранен табличный документ
//											ПредставлениеОшибок. Позволяет экономить память на Клиенте.
//
// Данные представления ошибок передаются либо через свойство
// ПредставлениеОшибок, либо через АдресХранилищаПредставленияОшибок.
//  
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Перем ФормаРеглОтчета;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем Макет, МакетДляСведения;
	Перем НазваниеДекларации;
	Перем АдресХранилищаПредставленияОшибок;
	Перем НетКритическихОшибок, НетОшибокДляСведения;
	Перем РезультатОперации, РезультатОперацииИзХранилища;
	Перем ФормаОтчетаОткрытаПараметры;
	
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НужноОбнулитьФорму = Истина;
	
	Параметры.Свойство("УникальностьФормы", УникальностьФормы);
	
	Параметры.Свойство("СохраненныйОтчет", Отчет);
	Параметры.Свойство("ПредставлениеОшибок", Макет);
	Параметры.Свойство("ПредставлениеСообщенийДляСведения", МакетДляСведения);
	Параметры.Свойство("НазваниеДекларации", НазваниеДекларации);
	Параметры.Свойство("АдресХранилищаПредставленияОшибок", АдресХранилищаПредставленияОшибок);
	
	Параметры.Свойство("ФормаОтчетаОткрыта", ФормаОтчетаОткрытаПараметры);
	ФормаОтчетаОткрыта = ?(ТипЗнч(ФормаОтчетаОткрытаПараметры) = Тип("Булево"), ФормаОтчетаОткрытаПараметры, Ложь);
	
	Параметры.Свойство("РезультатОперации", РезультатОперации);		
	РезультатОперации = ?(ТипЗнч(РезультатОперации) = Тип("Число"), РезультатОперации, 10);
		
	// Данные представления ошибок передаются либо через свойство
	// ПредставлениеОшибок, либо через АдресХранилищаПредставленияОшибок.
	Если ЭтоАдресВременногоХранилища(АдресХранилищаПредставленияОшибок) Тогда
		
		СтруктураПредставленияОшибок = ПолучитьИзВременногоХранилища(АдресХранилищаПредставленияОшибок);
		
		Если ТипЗнч(СтруктураПредставленияОшибок) = Тип("Структура") Тогда
			
			МакетИзХранилища = Неопределено;
			СтруктураПредставленияОшибок.Свойство("ПредставлениеОшибок", МакетИзХранилища);
			
			МакетИзХранилищаДляСведения = Неопределено;
			СтруктураПредставленияОшибок.Свойство("ПредставлениеСообщенийДляСведения", МакетИзХранилищаДляСведения);
			
			СтруктураПредставленияОшибок.Свойство("РезультатОперации", РезультатОперацииИзХранилища);
			РезультатОперации = ?(ТипЗнч(РезультатОперацииИзХранилища) = Тип("Число"), РезультатОперацииИзХранилища, РезультатОперации);
			
			// РезультатОперации	- 0 - нет ошибок
			//						- 10 - только критические ошибки
			//      				больше 10 - есть критические ошибки и  сообщения для сведения
			//						меньше 10 - только сообщения для сведения
		КонецЕсли;
				
		УдалитьИзВременногоХранилища(АдресХранилищаПредставленияОшибок);
	
	КонецЕсли;
		
	
	Если ТипЗнч(МакетИзХранилища) = Тип("ТабличныйДокумент") Тогда	
		Макет = МакетИзХранилища;	
	КонецЕсли;
	
	Если ТипЗнч(МакетИзХранилищаДляСведения) = Тип("ТабличныйДокумент") Тогда	
		МакетДляСведения = МакетИзХранилищаДляСведения;	
	КонецЕсли;
	
	БезОшибок = (РезультатОперации < 10);
	
	Элементы.РезультатПроверкиБезОшибок.Видимость = БезОшибок;
	Элементы.РезультатПроверкиСОшибками.Видимость = НЕ БезОшибок;
	
	Если ТипЗнч(Макет) = Тип("ТабличныйДокумент") Тогда	
		Ошибки.Вывести(Макет);	 
	КонецЕсли;
	
	Если ТипЗнч(МакетДляСведения) = Тип("ТабличныйДокумент") Тогда	
		ОшибкиСведения.Вывести(МакетДляСведения);	 
	КонецЕсли;
		
	Если ЗначениеЗаполнено(НазваниеДекларации) Тогда
		Заголовок = "Результаты проверки выгрузки" + " (" + НазваниеДекларации + ")";
	КонецЕсли;
	
	Элементы.СтраницыОшибок.ТекущаяСтраница = ?(БезОшибок,	
												Элементы.ДляСведения, Элементы.КритическиеОшибки);
	
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Отчет, "ДатаНачала, ДатаОкончания, Организация, ВыбраннаяФорма");
	
	мДатаНачалаПериодаОтчета = Реквизиты.ДатаНачала;
	мДатаКонцаПериодаОтчета = Реквизиты.ДатаОкончания;
	Организация = Реквизиты.Организация;
	мВыбраннаяФорма = Реквизиты.ВыбраннаяФорма;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Параметр = Новый Структура;
	Параметр.Вставить("Отчет", Отчет);
	
	Оповестить("ЗакрытаФормаОшибок", Параметр);
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Параметр = Новый Структура;
	Параметр.Вставить("Отчет", Отчет);
	
	Оповестить("ОткрытаФормыОшибок", Параметр);
		
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = Отчет Тогда
		
		Если НРег(ИмяСобытия) = НРег("ЗакрытОтчет") Тогда
			
			ФормаОтчетаОткрыта 	= Ложь;
			ФормаРеглОтчета 	= Неопределено;
			
		КонецЕсли;
				
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОшибкиВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Область.ТипОбласти <> ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
		Возврат;
	КонецЕсли;
	
	Если Область.Гиперссылка = Истина Тогда 
		Текст = Область.Текст;
		Если СтрНайти(НРег(Текст), "http") > 0 Тогда 
			СтандартнаяОбработка = Ложь;
			ПерейтиПоНавигационнойСсылке(Текст);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОшибкиОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		ОбработкаРасшифровкиСтруктуры(Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаРасшифровкиСтруктуры(Расшифровка, СтандартнаяОбработка)
	
	Перем ИмяЯчейки;
	Перем Раздел;
	Перем Страница;
	
	СтандартнаяОбработка = Ложь;
	
	Расшифровка.Свойство("Показатель", ИмяЯчейки);
	Расшифровка.Свойство("Раздел", Раздел);
	Расшифровка.Свойство("Страница", Страница);
	
	Ячейка = Новый Структура("Раздел,Страница,ИмяЯчейки", Раздел, Страница, ИмяЯчейки);
	
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мСохраненныйДок", Отчет);
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета", мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма", мВыбраннаяФорма);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417", Ложь);
	
	СтрФормаРеглОтчета = РегламентированнаяОтчетностьВызовСервера.ПолучитьСсылкуНаФормуРеглОтчета(Отчет, ПараметрыФормы);
	
	Если СтрФормаРеглОтчета = ".Форма." Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытьФормуОшибок", ЭтотОбъект);
		
		ТекстПредупреждения = НСтр("ru = 'В отчет были загружены новые данные из файла.
			|Текущая открытая форма ошибок проверки выгрузки отчета будет закрыта,
			|поскольку может содержать неактуальные или некорректные данные об ошибках.
			|
			|Запустите проверку выгрузки отчета еще раз после закрытия этой формы.';
			|en = 'В отчет были загружены новые данные из файла.
			|Текущая открытая форма ошибок проверки выгрузки отчета будет закрыта,
			|поскольку может содержать неактуальные или некорректные данные об ошибках.
			|
			|Запустите проверку выгрузки отчета еще раз после закрытия этой формы.'");
		
		ПоказатьПредупреждение(Оповещение , ТекстПредупреждения, , "Внимание!");
		Возврат;
		
	КонецЕсли;
	
    Если СтрЧислоВхождений(СтрФормаРеглОтчета, "ОтчетМенеджер") > 0 Тогда
		
		СтрФормаРеглОтчета = СтрЗаменить(СтрФормаРеглОтчета, "ОтчетМенеджер.", "");
		СтрФормаРеглОтчета = "Отчет." + СтрФормаРеглОтчета;
		
	ИначеЕсли СтрЧислоВхождений(СтрФормаРеглОтчета, "ВнешнийОтчетОбъект") > 0 Тогда
		
		СтрФормаРеглОтчета = СтрЗаменить(СтрФормаРеглОтчета, "ВнешнийОтчетОбъект.", "");
		СтрФормаРеглОтчета = "ВнешнийОтчет." + СтрФормаРеглОтчета;
		
	КонецЕсли;
		
	Если НЕ ФормаОтчетаОткрыта Тогда
				
		ФормаРеглОтчета = ОткрытьФорму(СтрФормаРеглОтчета, ПараметрыФормы, , Отчет);
		
	ИначеЕсли НЕ ТипЗнч(ФормаРеглОтчета) = Тип("УправляемаяФорма") Тогда
		
		ФормаРеглОтчета = РегламентированнаяОтчетностьАЛКОКлиент.ОпределитьОткрытуюВспомогательнуюФормуОтчета(
																				Отчет, СтрФормаРеглОтчета);
			
	КонецЕсли;
	
    Если НЕ ФормаРеглОтчета.ОткрытаяФормаПотомокСБлокировкойВладельца = Неопределено Тогда

		ТекстПредупреждения = НСтр("ru = 'При открытых вспомогательных формах отчета (например, форма выбора значений, форма редактирования строк и др.)
										|невозможен переход к показателю, содержащему некорректное значение.
										|
										|Для перехода необходимо закрыть все вспомогательные формы отчета.';
										|en = 'При открытых вспомогательных формах отчета (например, форма выбора значений, форма редактирования строк и др.)
										|невозможен переход к показателю, содержащему некорректное значение.
										|
										|Для перехода необходимо закрыть все вспомогательные формы отчета.'");
		
		ПоказатьПредупреждение( , ТекстПредупреждения, , "Внимание!");
	    Возврат;
		
	ИначеЕсли НЕ ФормаРеглОтчета.ФормаДлительнойОперации = Неопределено Тогда
	
		ТекстПредупреждения = НСтр("ru = 'При выполнении длительной операции невозможен переход к показателю, 
									|содержащему некорректное значение.
									|
									|Для перехода необходимо дождаться завершения длительной операции.';
									|en = 'При выполнении длительной операции невозможен переход к показателю, 
									|содержащему некорректное значение.
									|
									|Для перехода необходимо дождаться завершения длительной операции.'");
		
		ПоказатьПредупреждение( , ТекстПредупреждения, , "Внимание!");
	    Возврат;
	
	ИначеЕсли ФормаРеглОтчета.БылаУдаленаСтраницаРаздела  Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытьФормуОшибок", ЭтотОбъект);
					
		ТекстПредупреждения = НСтр("ru = 'В отчете была удалена страница раздела, 
								|поэтому открытая форма ошибок проверки выгрузки отчета будет закрыта, 
								|поскольку может содержать неактуальные или некорректные данные об ошибках.
								|
								|Запустите проверку выгрузки отчета еще раз после сохранения отчета.';
								|en = 'В отчете была удалена страница раздела, 
								|поэтому открытая форма ошибок проверки выгрузки отчета будет закрыта, 
								|поскольку может содержать неактуальные или некорректные данные об ошибках.
								|
								|Запустите проверку выгрузки отчета еще раз после сохранения отчета.'");
		
		ПоказатьПредупреждение(Оповещение , ТекстПредупреждения, , "Внимание!");
	    Возврат;
	
	КонецЕсли;
		
	ФормаРеглОтчета.Активизировать();		
	ФормаРеглОтчета.АктивизироватьЯчейку(Ячейка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуОшибок(Результат) Экспорт

	Модифицированность = Ложь;
	Закрыть();

КонецПроцедуры
 

#КонецОбласти



