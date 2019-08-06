
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация   = Параметры.Организация;
	УчетнаяЗапись = Организация.УчетнаяЗаписьОбмена;
	
	ДеревоКонтролирующиеОрганы = РеквизитФормыВЗначение("КонтролирующиеОрганы");
	
	Корень = ДеревоКонтролирующиеОрганы.Строки;
	
	ДобавитьФНС(Корень);
	ДобавитьПФР(Корень);
	ДобавитьФСГС(Корень);
	ДобавитьФСС(Корень);
	
	ЗначениеВРеквизитФормы(ДеревоКонтролирующиеОрганы, "КонтролирующиеОрганы");
	
	// Установка текущей строки.
	ВыделитьТекущийОрган(Параметры);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьФСГС(Корень)
	
	ЕстьФСГС = УчетнаяЗапись.ПредназначенаДляДокументооборотаСФСГС;
	
	Если НЕ ЕстьФСГС Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОрганыФСГС.Ссылка КАК Ссылка,
	|	""Росстат "" + ОрганыФСГС.Код КАК Представление
	|ИЗ
	|	Справочник.ОрганыФСГС КАК ОрганыФСГС";
	
	ВыборкаОрганы = Запрос.Выполнить().Выбрать();
	
	ДобавитьОрганВДерево(
		НСтр("ru = 'Росстат';
			|en = 'Russian Federal State Statistics Service'"), 
		ВыборкаОрганы, 
		Корень);
	
КонецПроцедуры
	
&НаСервере
Процедура ДобавитьПФР(Корень)
	
	ЕстьПФР = УчетнаяЗапись.ПредназначенаДляДокументооборотаСПФР;
	
	Если НЕ ЕстьПФР Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОрганыПФР.Ссылка КАК Ссылка,
	|	""ПФР "" + ОрганыПФР.Код КАК Представление
	|ИЗ
	|	Справочник.ОрганыПФР КАК ОрганыПФР";
	
	ВыборкаОрганы = Запрос.Выполнить().Выбрать();
	
	ДобавитьОрганВДерево(
		НСтр("ru = 'ПФР';
			|en = 'PF'"), 
		ВыборкаОрганы, 
		Корень);
	
КонецПроцедуры
	
&НаСервере
Процедура ДобавитьФНС(Корень)
	
	ЕстьФНС = УчетнаяЗапись.ПредназначенаДляДокументооборотаСФНС;
	
	Если НЕ ЕстьФНС Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НалоговыеОрганы.Ссылка КАК Ссылка,
	|	""ФНС "" + НалоговыеОрганы.Код КАК Представление
	|ИЗ
	|	Справочник.НалоговыеОрганы КАК НалоговыеОрганы";
	
	ВыборкаОрганы = Запрос.Выполнить().Выбрать();
	
	ДобавитьОрганВДерево(
		НСтр("ru = 'ФНС';
			|en = 'FTS'"), 
		ВыборкаОрганы, 
		Корень);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОрганВДерево(ОрганСтрокой, ВыборкаОрганы, Корень)
	
	УровеньВидаОргана = Корень.Добавить();
	УровеньВидаОргана.Представление = ОрганСтрокой;
	УровеньВидаОргана.ЭтоГруппа 	= Истина;
	
	Пока ВыборкаОрганы.Следующий() Цикл
		
		СтрокаОргана =  УровеньВидаОргана.Строки.Добавить();
		СтрокаОргана.Представление 	= ВыборкаОрганы.Представление;
		СтрокаОргана.Ссылка 		= ВыборкаОрганы.Ссылка;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьФСС(Корень)
	
	ОрганизацияИспользуетОбменСФСС                    = Ложь;
	ОрганизацияИспользуетАвтонастройкуПоУчетнойЗаписи = Ложь;
	НастроенОбменВУниверсальномФормате                = Ложь;
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПолучитьСвойстваОрганизацииДляФСС(
		Организация,
		НастроенОбменВУниверсальномФормате,
		ОрганизацияИспользуетОбменСФСС,
		ОрганизацияИспользуетАвтонастройкуПоУчетнойЗаписи);
	
	Если НЕ ОрганизацияИспользуетОбменСФСС Тогда
		Возврат;
	КонецЕсли;
	
	// ФСС
	УровеньВидаОргана = Корень.Добавить();
	УровеньВидаОргана.Представление = НСтр("ru = 'ФСС';
											|en = 'SSF'");
	УровеньВидаОргана.ЭтоГруппа 	= Истина;
	
	СтрокаОргана = УровеньВидаОргана.Строки.Добавить();
	СтрокаОргана.Представление = НСтр("ru = 'ФСС (не поддерживается)';
										|en = 'SSF (not supported)'");
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьТекущийОрган(Параметры)

	ИскомыйИдентификатор = -1;
	ИдентификаторСтрокиДерева(КонтролирующиеОрганы, Параметры.ТекущаяСтрока, ИскомыйИдентификатор);
	
	Если ИскомыйИдентификатор <> -1 Тогда
		Элементы.КонтролирующиеОрганы.ТекущаяСтрока = ИскомыйИдентификатор;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ИдентификаторСтрокиДерева(Узел, ИскомоеЗначение, ИскомыйИдентификатор)
	
	ЭлементыУзла = Узел.ПолучитьЭлементы();
	Для каждого ЭлементУзла Из ЭлементыУзла Цикл
		Если ЭлементУзла.Ссылка = ИскомоеЗначение Тогда
			ИскомыйИдентификатор = ЭлементУзла.ПолучитьИдентификатор();
		Иначе
			ИдентификаторСтрокиДерева(ЭлементУзла, ИскомоеЗначение, ИскомыйИдентификатор);
		КонецЕСли;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтролирующиеОрганыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если ТипЗнч(Значение) = Тип("Число") Тогда
		ДанныеСтроки = КонтролирующиеОрганы.НайтиПоИдентификатору(Значение);
		
		Если ДанныеСтроки <> Неопределено Тогда
			
			Если Найти(ДанныеСтроки.Представление,НСтр("ru = 'ФСС';
														|en = 'SSF'")) > 0 Тогда
				ТекстПредупреждения = НСтр("ru = 'К сожалению, Фонд социального страхования не поддерживает возможность обмена письмами.
                                            |Мы обязательно поддержим эту функцию в 1С-Отчетности, как только такая возможность будет 
                                            |поддержана на стороне ФСС.';
                                            |en = 'Sorry, Social Security Fund does not support email exchange.
                                            |We will make sure 1C Reporting has this function when it is
                                            |supported on SSF side.'");
				ПоказатьПредупреждение(, ТекстПредупреждения);
				
			ИначеЕсли НЕ ДанныеСтроки.ЭтоГруппа Тогда
				Закрыть(ДанныеСтроки.Ссылка);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти