
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИдентификаторНоменклатуры",   ИдентификаторНоменклатуры);
	Параметры.Свойство("Номенклатура",                НоменклатураСсылка);
	Параметры.Свойство("ИдентификаторХарактеристики", ИдентификаторХарактеристики);
	Параметры.Свойство("НаименованиеНоменклатуры",    НаименованиеНоменклатуры);
	Параметры.Свойство("НаименованиеХарактеристики",  НаименованиеХарактеристики);
	
	РаботаСНоменклатуройПереопределяемый.ПолучитьВидНоменклатуры(НоменклатураСсылка, ВидНоменклатуры);
	
	СформироватьПодсказкиФормы();
	
	УстановитьВидимостьДоступность();
	
	ДействиеСХарактеристикой = "Создать";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СоздатьНовуюХарактеристикуПриИзменении(Элемент)
	
	ДействиеСХарактеристикой = "Создать";
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Неопределено;
	
	Если ДействиеСХарактеристикой = "Создать" Тогда
		СоздатьХарактеристику();
	Иначе
		ПривязатьХарактеристику(Характеристика, ПараметрыЗакрытия);	
		Закрыть(ПараметрыЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьХарактеристику()
			
	ПараметрыСоздания = РаботаСНоменклатуройСлужебныйКлиентСервер.ПараметрыЗагрузкиХарактеристик();
	
	ПараметрыСоздания.Номенклатура              = НоменклатураСсылка;
	ПараметрыСоздания.ЗаполнитьСозданныеОбъекты = Истина;
	ПараметрыСоздания.ИдентификаторыХарактеристик.Добавить(ИдентификаторХарактеристики);
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьХарактеристикиПродолжение", ЭтотОбъект, Новый Структура);
	
	РаботаСНоменклатуройКлиент.ЗагрузитьХарактеристики(Оповещение, ПараметрыСоздания, ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьХарактеристикиПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗакрытия = Неопределено;
	
	ЗагрузитьХарактеристикиЗавершение(Результат.АдресРезультата, ДополнительныеПараметры, ПараметрыЗакрытия);	
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьХарактеристикиЗавершение(АдресРезультата, ДополнительныеПараметры, ПараметрыЗакрытия)
	
	Если Не ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	СозданныеОбъекты = Результат.СозданныеОбъекты;	
		
	Если ЗначениеЗаполнено(СозданныеОбъекты) Тогда
		
		ХарактеристикаСсылка = СозданныеОбъекты[0].Характеристика;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'Создана характеристика %1';
					|en = '%1 characteristic is created'"), ХарактеристикаСсылка));
				
		ПараметрыЗакрытия = РаботаСНоменклатурой.ПараметрыЗаписиСоответствияНоменклатуры();	
		
		ПараметрыЗакрытия.ИдентификаторНоменклатурыСервиса   = ИдентификаторНоменклатуры;
		ПараметрыЗакрытия.ИдентификаторХарактеристикиСервиса = ИдентификаторХарактеристики;
		ПараметрыЗакрытия.ПредставлениеНоменклатурыСервиса   = НаименованиеНоменклатуры;
		ПараметрыЗакрытия.ПредставлениеХарактеристикиСервиса = НаименованиеХарактеристики;
		ПараметрыЗакрытия.ДатаОбновления                     = ТекущаяДатаСеанса();
		
		ПараметрыЗакрытия.Вставить("Характеристика", ХарактеристикаСсылка);
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПривязатьХарактеристику(ХарактеристикаСсылка, ПараметрыЗаписи)
	
	ПараметрыЗаписи = РаботаСНоменклатурой.ПараметрыЗаписиСоответствияНоменклатуры();	
	
	ПараметрыЗаписи.ИдентификаторНоменклатурыСервиса   = ИдентификаторНоменклатуры;
	ПараметрыЗаписи.ИдентификаторХарактеристикиСервиса = ИдентификаторХарактеристики;
	ПараметрыЗаписи.ПредставлениеНоменклатурыСервиса   = НаименованиеНоменклатуры;
	ПараметрыЗаписи.ПредставлениеХарактеристикиСервиса = НаименованиеХарактеристики;
	ПараметрыЗаписи.ДатаОбновления                     = ТекущаяДатаСеанса();
	
	ПараметрыЗаписи.Вставить("Характеристика", ХарактеристикаСсылка);
	
	РаботаСНоменклатурой.ЗаписатьСоответствиеНоменклатурыИХарактеристик(НоменклатураСсылка, ХарактеристикаСсылка, ПараметрыЗаписи);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПривязатьКСуществующейХарактеристикеПриИзменении(Элемент)
	
	ДействиеСХарактеристикой = "Привязать";
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПодсказкиФормы()
	
	Элементы.ПодсказкаКФорме.Заголовок
		= СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru = 'Привяжите характеристику <a href = ""Номенклатура"">%1</a> к существующей или создайте новую';
					|en = 'Link the a href = ""Номенклатура"">%1</a> characteristic to an existing one or create a new one.'"), НаименованиеНоменклатуры));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.Характеристика.Доступность = ДействиеСХарактеристикой = "Привязать"; 
	Элементы.Характеристика.АвтоОтметкаНезаполненного = ДействиеСХарактеристикой = "Привязать"; 
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ДействиеСХарактеристикой = "Привязать" Тогда
		ПроверяемыеРеквизиты.Добавить("Характеристика");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаКФормеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РаботаСНоменклатуройКлиент.ОткрытьФормуКарточкиНоменклатуры(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторНоменклатуры), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = РаботаСНоменклатуройКлиент.ПараметрыФормыСопоставленияХарактеристик();
	
	ПараметрыФормы.ИдентификаторНоменклатуры       = ИдентификаторНоменклатуры;
	ПараметрыФормы.Номенклатура                    = НоменклатураСсылка;
	ПараметрыФормы.НаименованиеНоменклатурыСервиса = НаименованиеНоменклатуры;
	ПараметрыФормы.ЭтоРежимВыбораХарактеристики    = Истина;
	
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	РаботаСНоменклатуройКлиент.ОткрытьФормуСопоставленияХарактеристик(ПараметрыФормы, Элемент, Неопределено);
	
КонецПроцедуры

#КонецОбласти










