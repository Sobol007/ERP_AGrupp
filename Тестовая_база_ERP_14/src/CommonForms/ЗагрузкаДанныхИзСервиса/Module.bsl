#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОткрытьФормуАктивныхПользователей(Элемент)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.АктивныеПользователи");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьЗагрузкуДанных", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения, , "data_dump.zip");
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗагрузкуДанных(ВыборВыполнен, АдресХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если ВыборВыполнен Тогда
		
		Состояние(
			НСтр("ru = 'Выполняется загрузка данных из сервиса.
                  |Операция может занять продолжительное время, пожалуйста, подождите...';
                  |en = 'Importing data from the service.
                  |It may take a long time, please wait...'"),);
		
		ВыполнитьЗагрузку(АдресХранилища, ЗагружатьИнформациюОПользователях);
		ПрекратитьРаботуСистемы(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ВыполнитьЗагрузку(Знач АдресФайла, Знач ЗагружатьИнформацияОПользователях)
	
	УстановитьМонопольныйРежим(Истина);
	
	Попытка
		
		ДанныеАрхива = ПолучитьИзВременногоХранилища(АдресФайла);
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ДанныеАрхива.Записать(ИмяАрхива);
		
		ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьТекущуюОбластьДанныхИзАрхива(ИмяАрхива, ЗагружатьИнформацияОПользователях, Истина);
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяАрхива);
		
		УстановитьМонопольныйРежим(Ложь);
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		УстановитьМонопольныйРежим(Ложь);
		
		ШаблонЗаписиЖР = НСтр("ru = 'При загрузке данных произошла ошибка:
                               |
                               |-----------------------------------------
                               |%1
                               |-----------------------------------------';
                               |en = 'An error occurred when importing data:
                               |
                               |-----------------------------------------
                               |%1
                               |-----------------------------------------'");
		ТекстЗаписиЖР = СтрШаблон(ШаблонЗаписиЖР, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));

		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Загрузка данных';
				|en = 'Data import'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстЗаписиЖР);

		ШаблонИсключения = НСтр("ru = 'При загрузке данных произошла ошибка: %1.
                                 |
                                 |Расширенная информация для службы поддержки записана в журнал регистрации. Если Вам неизвестна причина ошибки - рекомендуется обратиться в службу технической поддержки, предоставив для расследования выгрузку журнала регистрации и файл, из которого предпринималась попытка загрузить данные.';
                                 |en = 'An error occurred when importing data: %1.
                                 |
                                 |Detailed information for the technical support is written to the event log. If the error cause is unknown, it is recommended that you contact the technical support providing the event log export for investigation and file from which you attempted to import data.'");

		ВызватьИсключение СтрШаблон(ШаблонИсключения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти