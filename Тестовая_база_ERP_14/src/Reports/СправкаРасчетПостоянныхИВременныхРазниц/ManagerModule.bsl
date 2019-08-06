#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
	|ИспользоватьПослеКомпоновкиМакета,
	|ИспользоватьПослеВыводаРезультата,
	|ИспользоватьДанныеРасшифровки,
	|ИспользоватьПриВыводеЗаголовка",
	Истина, Истина, Истина, Ложь,Истина);
	
КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	//Организация
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	Результат.Вывести(ОбластьОрганизация);
	
	//Заголовок
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета);
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
	// Единица измерения
	Если ПараметрыОтчета.Свойство("ВыводитьЕдиницуИзмерения")
		И ПараметрыОтчета.ВыводитьЕдиницуИзмерения Тогда
		ОбластьОписаниеЕдиницыИзмерения = Макет.ПолучитьОбласть("ОписаниеЕдиницыИзмерения");
		Результат.Вывести(ОбластьОписаниеЕдиницыИзмерения);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Справка-расчет налоговых активов и обязательств %1';
			|en = 'Detailed calculation of tax assets and liabilities %1 '"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			?(ПараметрыОтчета.СНачалаГода,
				НачалоГода(ПараметрыОтчета.НачалоПериода),
				ПараметрыОтчета.НачалоПериода),
			ПараметрыОтчета.КонецПериода));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут.
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт

	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ?(ПараметрыОтчета.СначалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),НачалоДня(ПараметрыОтчета.НачалоПериода)));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;

	СтавкаНалогаНаПрибыль = Окр(НалоговыйУчет.ПолучитьСтавкуНалогаНаПрибыль(Новый Структура("Дата,Организация",ПараметрыОтчета.КонецПериода,ПараметрыОтчета.Организация))*100,2);

	ПараметрыОтчета.Вставить("СтавкаНалогаНаПрибыль",СтавкаНалогаНаПрибыль);

	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтавкаНалогаНаПрибыль", СтавкаНалогаНаПрибыль);

	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);

КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	МакетКомпоновки.Тело[0].Тело[1].Строки[0].Тело.Удалить(МакетКомпоновки.Тело[0].Тело[1].Строки[0].Тело[2]);
	МакетКомпоновки.Тело[2].Тело[1].Строки[0].Тело.Удалить(МакетКомпоновки.Тело[2].Тело[1].Строки[0].Тело[2]);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	СтавкаНалогаНаПрибыль = ПараметрыОтчета.СтавкаНалогаНаПрибыль;	
		
	Область = Результат.НайтиТекст("##СтавкаНалогаНаПрибыль##",Результат.Область("r1c1"));
	Пока НЕ Область = Неопределено Цикл
		Область.Текст = СтрЗаменить(Область.Текст,"##СтавкаНалогаНаПрибыль##",СтавкаНалогаНаПрибыль);
		Область = Результат.НайтиТекст("##СтавкаНалогаНаПрибыль##",Область);
	КонецЦикла;	
	
	Результат.ФиксацияСверху = 0;
	
	Результат.ФиксацияСлева = 0;	
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецЕсли