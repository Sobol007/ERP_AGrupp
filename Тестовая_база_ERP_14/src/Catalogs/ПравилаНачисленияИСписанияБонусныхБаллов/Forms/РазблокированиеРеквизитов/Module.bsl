#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Закрыть(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИспользованиеОбъекта(Команда)
	
	Результат = ПроверитьИспользованиеОбъектаНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2; // Уменьшим шаг увеличения времени опроса выполнения задания
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ПолучитьРезультатПроверкиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочие

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

// Унифицированная процедура проверки выполнения фонового задания
&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
 
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ПолучитьРезультатПроверкиНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьИспользованиеОбъектаНаСервере()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Объект", Параметры.Объект);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ОбщегоНазначенияУТ.ПроверитьИспользованиеОбъекта(ПараметрыЗадания, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
		
	Иначе
		
		НаименованиеЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Проверка использования объекта %1';
					|en = 'Check the usage of object %1'"),
				Параметры.Объект);
				
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
				УникальныйИдентификатор,
				"ОбщегоНазначенияУТ.ПроверитьИспользованиеОбъекта",
				ПараметрыЗадания,
				НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
		
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПолучитьРезультатПроверкиНаСервере()
	
	ЕстьСсылки = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ЕстьСсылки Тогда
		ТекущаяСтраница = Элементы.ГруппаОбъектИспользуетсяОбъектИспользуется;
	Иначе
		ТекущаяСтраница = Элементы.ГруппаОбъектИспользуетсяОбъектНеИспользуется;
	КонецЕсли;
	
	Элементы.ГруппаОбъектИспользуетсяСтраницы.ТекущаяСтраница = ТекущаяСтраница;
	
КонецФункции

#КонецОбласти

#КонецОбласти
