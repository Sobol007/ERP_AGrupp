
////////////////////////////////////////////////////////////////////////////////
// CRM режим форм закладки клиент
//  
////////////////////////////////////////////////////////////////////////////////
#Область СлужебныеПроцедурыИФункции

Процедура ПередЗавершениемРаботыСистемы(Отказ) Экспорт
	Если Не CRM_РежимФормЗакладкиКлиентПовтИсп.ИспользуетсяРежимЗакладок() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийСоставОткрытыхФорм = CRM_РежимФормЗакладкиСервер.ПолучитьТекущийСоставОткрытыхФорм();
	Если ТекущийСоставОткрытыхФорм.Количество() = 0 Тогда Возврат; КонецЕсли;
	
	ОткрытыеОкна = ПолучитьОкна();
	МассивОткрытыхФорм = Новый Массив();
	Для Каждого ОткрытоеОкно Из ОткрытыеОкна Цикл
		// Основные окна пропускаем
		Если ОткрытоеОкно.Основное Тогда Продолжить; КонецЕсли;
		
		Попытка		УпрФорма = ОткрытоеОкно.ПолучитьСодержимое();
		Исключение	Продолжить;
		КонецПопытки;
		
		Если ТипЗнч(УпрФорма) <> Тип("УправляемаяФорма") Тогда Продолжить; КонецЕсли;
		
		// Если у формы определен владелец, значит форма открыта из другой формы как вспомогательная - пропускаем.
		Если УпрФорма.ВладелецФормы <> Неопределено Тогда Продолжить; КонецЕсли;
		
		Попытка		ИмяФормы = УпрФорма.ИмяФормы;
		Исключение	Продолжить;
		КонецПопытки;
		
		Параметры = Новый Структура();
		Если ИмяФормы = "ОбщаяФорма.ПанельОтчетов" Тогда
			Попытка Параметры.Вставить("Подсистемы", УпрФорма.Подсистемы);
			Исключение КонецПопытки;
			Попытка Параметры.Вставить("ИмяФормы", УпрФорма.ИмяФормыОтчетов);
			Исключение КонецПопытки;
		КонецЕсли;
		
		СтруктураОписаниеФормы = CRM_РежимФормЗакладкиКлиентСервер.ПолучитьСтруктуруБланкОписанияФормы();
		СтруктураОписаниеФормы.ИмяФормы = ИмяФормы;
		СтруктураОписаниеФормы.Параметры = Параметры;
		
		СтруктураОписаниеФормы.Вставить("ФормаОбъект", УпрФорма);
		
		МассивОткрытыхФорм.Добавить(СтруктураОписаниеФормы);
	КонецЦикла;
	
	нИндекс = 0;
	Пока нИндекс < ТекущийСоставОткрытыхФорм.Количество() Цикл
		НайденныйИндекс = CRM_РежимФормЗакладкиКлиентСервер.НайтиФормуВСоставеФорм(ТекущийСоставОткрытыхФорм[нИндекс].ИмяФормы,
				ТекущийСоставОткрытыхФорм[нИндекс].Параметры, МассивОткрытыхФорм);
		//
		
		Если НайденныйИндекс = Неопределено  Тогда
			ТекущийСоставОткрытыхФорм.Удалить(нИндекс);
		Иначе
			нИндекс = нИндекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	CRM_РежимФормЗакладкиСервер.СохранитьТекущийСоставОткрытыхФорм(ТекущийСоставОткрытыхФорм);
	
	CRM_РежимФормЗакладкиСервер.СохранитьПризнакСтартСистемы(Ложь);
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы() Экспорт
	Если Не CRM_РежимФормЗакладкиКлиентПовтИсп.ИспользуетсяРежимЗакладок() Тогда
		Возврат;
	КонецЕсли;
	
	CRM_РежимФормЗакладкиСервер.СохранитьПризнакСтартСистемы(Истина);
	
	ТекущийСоставОткрытыхФорм = CRM_РежимФормЗакладкиСервер.ПолучитьТекущийСоставОткрытыхФорм();
	
	АктивнаяФорма = Неопределено;
	Для Каждого ОписаниеФормы Из ТекущийСоставОткрытыхФорм Цикл
		Если ТипЗнч(ОписаниеФормы) <> Тип("Структура") Тогда Продолжить; КонецЕсли;
		Если Не ОписаниеФормы.Свойство("ИмяФормы") Тогда Продолжить; КонецЕсли;
		
		Форма = Неопределено;
		Если ОписаниеФормы.Свойство("Параметры") И ТипЗнч(ОписаниеФормы.Параметры) = Тип("Структура") Тогда
			ОписаниеФормы.Параметры.Вставить("_НачалоРаботыСистемы");
			Если ОписаниеФормы.ИмяФормы = "ОбщаяФорма.ПанельОтчетов" Тогда
				Попытка		Форма = ПолучитьФорму(ОписаниеФормы.ИмяФормы, ОписаниеФормы.Параметры,, Истина);
				Исключение	Продолжить;
				КонецПопытки;
			Иначе
				Попытка		Форма = ПолучитьФорму(ОписаниеФормы.ИмяФормы, ОписаниеФормы.Параметры);
				Исключение	Продолжить;
				КонецПопытки;
			КонецЕсли;
		Иначе
			Попытка		Форма = ПолучитьФорму(ОписаниеФормы.ИмяФормы, Новый Структура("_НачалоРаботыСистемы"));
			Исключение	Продолжить;
			КонецПопытки;
		КонецЕсли;
		
		Если Форма <> Неопределено Тогда
			Форма.Открыть();
			Если АктивнаяФорма = Неопределено И Форма.Открыта() Тогда
				АктивнаяФорма = Форма;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если АктивнаяФорма <> Неопределено Тогда
		АктивнаяФорма.Активизировать();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти