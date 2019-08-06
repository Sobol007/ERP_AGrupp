#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеРегистра() Экспорт
	ОписаниеРегистра = УчетРабочегоВремениРасширенный.ОписаниеРегистраДанныхУчетаВремени();
	
	ОписаниеРегистра.МетаданныеРегистра = Метаданные.РегистрыНакопления.ДанныеОперативногоУчетаРабочегоВремениСотрудников;
	ОписаниеРегистра.ИмяПоляСотрудник = "Сотрудник";
	ОписаниеРегистра.ИмяПоляПериод = "Период";
	ОписаниеРегистра.ИмяПоляПериодРегистрации = "ПериодРегистрации";
	ОписаниеРегистра.ИмяПоляВидДанных = "ВидДанных";
	ОписаниеРегистра.ВидДанных = Неопределено;
	
	Возврат ОписаниеРегистра;
КонецФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ЗаполнитьОрганизацию(ПараметрыОбновления = Неопределено) Экспорт
	
	ПоследнийОбработанныйРегистратор = Неопределено;
	Пока Истина Цикл
		Запрос = ЗарплатаКадрыРасширенный.ЗапросПолученияРегистраторовДляОбработкиЗаполненияОрганизации("ДанныеОперативногоУчетаРабочегоВремениСотрудников", ПоследнийОбработанныйРегистратор);
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
			Возврат;
		Иначе
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		КонецЕсли;
		
		Регистраторы = Результат.Выгрузить().ВыгрузитьКолонку("Регистратор");
		ОрганизацииДокументов = ОбщегоНазначенияБЗК.ЗначениеРеквизитаОбъектов(Регистраторы, "Организация");
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Период КАК Период,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Регистратор КАК Регистратор,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.НомерСтроки КАК НомерСтроки,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Активность КАК Активность,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Сотрудник КАК Сотрудник,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.ПериодРегистрации КАК ПериодРегистрации,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.ВидУчетаВремени КАК ВидУчетаВремени,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.ВидДанных КАК ВидДанных,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Дни КАК Дни,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Часы КАК Часы,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.ПереходящаяЧастьПредыдущейСмены КАК ПереходящаяЧастьПредыдущейСмены,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.ПереходящаяЧастьТекущейСмены КАК ПереходящаяЧастьТекущейСмены,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Смена КАК Смена,
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Организация КАК Организация
			|ИЗ
			|	РегистрНакопления.ДанныеОперативногоУчетаРабочегоВремениСотрудников КАК ДанныеОперативногоУчетаРабочегоВремениСотрудников
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРегистраторы КАК ВТРегистраторы
			|		ПО ДанныеОперативногоУчетаРабочегоВремениСотрудников.Регистратор = ВТРегистраторы.Регистратор
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДанныеОперативногоУчетаРабочегоВремениСотрудников.Регистратор";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрНакопления.ДанныеОперативногоУчетаРабочегоВремениСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				Продолжить;
			КонецЕсли;
			НаборЗаписей = РегистрыНакопления.ДанныеОперативногоУчетаРабочегоВремениСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			Пока Выборка.Следующий() Цикл
				НоваяСтрока = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
				НоваяСтрока.Организация = ОрганизацииДокументов[Выборка.Регистратор];
				Если Не ЗначениеЗаполнено(НоваяСтрока.Организация) Тогда
					НоваяСтрока.Организация = Выборка.ГоловнаяОрганизация;
				КонецЕсли;
			КонецЦикла;
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			ПоследнийОбработанныйРегистратор = Выборка.Регистратор;
		КонецЦикла;
		Если ПараметрыОбновления <> Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли