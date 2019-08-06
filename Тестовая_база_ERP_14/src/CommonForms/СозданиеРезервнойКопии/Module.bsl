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
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не РаботаВМоделиСервиса.ИспользованиеРазделителяСеанса() Тогда 
		ВызватьИсключение(НСтр("ru = 'Не установлено значение разделителя';
								|en = 'Separator value is not set'"));
	КонецЕсли;
	
	ПереключитьСтраницу(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьКопиюОбласти(Команда)
	
	ДлительнаяОперация = СоздатьКопиюОбластиНаСервере();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);

	ОповещениеОЗавершении = Новый ОписаниеОповещения("СоздатьКопиюОбластиЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьКопиюОбластиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	ОбработатьРезультатВыполненияЗадания(Результат);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработатьРезультатВыполненияЗадания(Результат)
	
	СнятьМонопольныйРежим();
	
	Если Результат.Статус = "Ошибка" Тогда
		
		ЗаписатьИсключениеНаСервере(Результат.ПодробноеПредставлениеОшибки);
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	
	ИначеЕсли НЕ ПустаяСтрока(Результат.АдресРезультата) Тогда
		
		УдалитьИзВременногоХранилища(Результат.АдресРезультата);
		Результат.АдресРезультата = "";
		// Перейти на страницу результата.
		ПереключитьСтраницу(ЭтотОбъект, "СтраницаПослеВыгрузкиУспех");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьСтраницу(Форма, Знач ИмяСтраницы = "СтраницаДоВыгрузки")
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы[ИмяСтраницы];
	
	Если ИмяСтраницы = "СтраницаДоВыгрузки" Тогда
		Форма.Элементы.ФормаСоздатьКопиюОбласти.Доступность = Истина;
	Иначе
		Форма.Элементы.ФормаСоздатьКопиюОбласти.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьИсключениеНаСервере(Знач ПредставлениеОшибки)
	
	СнятьМонопольныйРежим();
	
	Событие = РезервноеКопированиеОбластейДанных.НаименованиеФоновогоРезервногоКопирования();
	ЗаписьЖурналаРегистрации(Событие, УровеньЖурналаРегистрации.Ошибка, , , ПредставлениеОшибки);
	
КонецПроцедуры

&НаСервере
Функция СоздатьКопиюОбластиНаСервере()
	
	ОбластьДанных = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
	УстановитьМонопольныйРежим(Истина);
	
	ПараметрыЗадания = РезервноеКопированиеОбластейДанных.СоздатьПустыеПараметрыВыгрузки();
	ПараметрыЗадания.ОбластьДанных = ОбластьДанных;
	ПараметрыЗадания.ИДКопии = Новый УникальныйИдентификатор;
	ПараметрыЗадания.Принудительно = Истина;
	ПараметрыЗадания.ПоТребованию = Истина;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = РезервноеКопированиеОбластейДанных.НаименованиеФоновогоРезервногоКопирования();
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Попытка
		
		Результат = ДлительныеОперации.ВыполнитьВФоне(
			РезервноеКопированиеОбластейДанных.ИмяМетодаФоновогоРезервногоКопирования(),
			ПараметрыЗадания,
			ПараметрыВыполнения);
		
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьИсключениеНаСервере(ПредставлениеОшибки);
		ВызватьИсключение;
		
	КонецПопытки;
	
	АдресХранилища = Результат.АдресРезультата;
	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СнятьМонопольныйРежим()
	
	УстановитьМонопольныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти
