#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());	

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.СинхронизироватьКлючи(ЭтотОбъект);	

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ИдентификаторУникален() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		СтрЗаменить(НСтр("ru = 'В базе данных уже содержится статья калькуляции с идентификатором ""%Идентификатор%"".
			|Идентификатор должен быть уникальным';
			|en = 'Infobase already contains a costing item with the ""%Идентификатор%"" ID. 
			|The ID should be unique'"), "%Идентификатор%", Идентификатор), 
		ЭтотОбъект, "Идентификатор",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Осуществляет поиск идентификатора, совпадающего с заполненным в объекте
//
// Возвращаемое значение:
//	Булево
//	Истина, если идентификатор не найден, Ложь в противном случае.
//
Функция ИдентификаторУникален()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.СтатьиКалькуляции КАК СтатьиКалькуляции
	|ГДЕ
	|	СтатьиКалькуляции.Идентификатор = &Идентификатор
	|	И СтатьиКалькуляции.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",        Ссылка);
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ПараметрыСинхронизацииКлючей()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("Справочник.КлючиАналитикиУчетаНоменклатуры", "ПометкаУдаления");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
