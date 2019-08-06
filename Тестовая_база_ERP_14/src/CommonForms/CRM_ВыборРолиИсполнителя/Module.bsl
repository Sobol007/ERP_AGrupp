
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	Если Параметры.Свойство("РольИсполнителя") Тогда
		Роль = Параметры.РольИсполнителя;
	КонецЕсли;	
	Если Параметры.Свойство("ОсновнойОбъектАдресации") Тогда
		ОсновнойОбъектАдресации = Параметры.ОсновнойОбъектАдресации;
	КонецЕсли;	
	Если Параметры.Свойство("ДополнительныйОбъектАдресации") Тогда
		ДополнительныйОбъектАдресации = Параметры.ДополнительныйОбъектАдресации;
	КонецЕсли;	
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ЗаданыТипыОсновногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации
		И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации 
		И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
	
	Если ЗаданыТипыОсновногоОбъектаАдресации И ОсновнойОбъектАдресации = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Поле ""%1"" не заполнено.';en='The field ""%1"" is not filled in.'"),
				Роль.ТипыОсновногоОбъектаАдресации.Наименование),,
				"ОсновнойОбъектАдресации",, Отказ);
	ИначеЕсли ЗаданыТипыДополнительногоОбъектаАдресации И ДополнительныйОбъектАдресации = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Поле ""%1"" не заполнено.';en='The field ""%1"" is not filled in.'"), 
			  Роль.ТипыДополнительногоОбъектаАдресации.Наименование),,
			"ДополнительныйОбъектАдресации",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РольПриИзменении(Элемент)
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура OKВыполнить()

	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;  
	КонецЕсли;
	Закрыть(ПараметрыЗакрытия());

КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТипыОбъектовАдресации()
	
	ТипыОсновногоОбъектаАдресации = Роль.ТипыОсновногоОбъектаАдресации.ТипЗначения;
	ТипыДополнительногоОбъектаАдресации = Роль.ТипыДополнительногоОбъектаАдресации.ТипЗначения;
	ИспользуетсяСОбъектамиАдресации = Роль.ИспользуетсяСОбъектамиАдресации;
	ИспользуетсяБезОбъектовАдресации = Роль.ИспользуетсяБезОбъектовАдресации;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЭлементов()

	ЗаданыТипыОсновногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации
		И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации 
		И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
		
	Элементы.ОсновнойОбъектАдресации.Заголовок = Роль.ТипыОсновногоОбъектаАдресации.Наименование;
	Элементы.ОдинОсновнойОбъектАдресации.Заголовок = Роль.ТипыОсновногоОбъектаАдресации.Наименование;
	
	Если ЗаданыТипыОсновногоОбъектаАдресации И ЗаданыТипыДополнительногоОбъектаАдресации Тогда
		Элементы.ГруппаОбъектыАдресации.ТекущаяСтраница = Элементы.ГруппаДваОбъектаАдресации;
	ИначеЕсли ЗаданыТипыОсновногоОбъектаАдресации Тогда
		Элементы.ГруппаОбъектыАдресации.ТекущаяСтраница = Элементы.ГруппаОдинОбъектАдресации;
	Иначе	
		Элементы.ГруппаОбъектыАдресации.ТекущаяСтраница = Элементы.ГруппаНетОбъектовАдресации;
	КонецЕсли;
		
	Элементы.ДополнительныйОбъектАдресации.Заголовок = Роль.ТипыДополнительногоОбъектаАдресации.Наименование;
	
	Элементы.ОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыОсновногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ОдинОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыОсновногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ДополнительныйОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыДополнительногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ОдинОсновнойОбъектАдресации.ОграничениеТипа = ТипыОсновногоОбъектаАдресации;
	Элементы.ОсновнойОбъектАдресации.ОграничениеТипа = ТипыОсновногоОбъектаАдресации;
	Элементы.ДополнительныйОбъектАдресации.ОграничениеТипа = ТипыДополнительногоОбъектаАдресации;
	                        
КонецПроцедуры

&НаСервере
Функция ПараметрыЗакрытия()
	Возврат Новый Структура("РольИсполнителя,ОсновнойОбъектАдресации,ДополнительныйОбъектАдресации", 
		Роль,
		?(ОсновнойОбъектАдресации <> Неопределено И НЕ ОсновнойОбъектАдресации.Пустая(), ОсновнойОбъектАдресации, Неопределено),
		?(ДополнительныйОбъектАдресации <> Неопределено И НЕ ДополнительныйОбъектАдресации.Пустая(), ДополнительныйОбъектАдресации, Неопределено));
КонецФункции

#КонецОбласти

#КонецОбласти
