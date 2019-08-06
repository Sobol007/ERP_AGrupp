
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ТабличныйДокумент, ДанныеРасшифровки, СтандартнаяОбработка)
	
	НастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	
	СтандартнаяОбработка = Ложь;
	СформироватьОтчет(ТабличныйДокумент, ДанныеРасшифровки, НастройкиКД);
	
	ДатаАктуальности = Константы.CRM_ДатаАктуальностиЦелевыхПоказателей.Получить();
	
	Ячейка = ТабличныйДокумент.Область(ТабличныйДокумент.ВысотаТаблицы + 2, 1, ТабличныйДокумент.ВысотаТаблицы + 2, 4);
	Ячейка.Объединить();
	Ячейка.Шрифт = Новый Шрифт(Ячейка.Шрифт, , , Истина);
	Ячейка.Текст = НСтр("ru = 'Данные актуальны на '") + Формат(ДатаАктуальности, "ДФ='dd.MM.yyyy HH:mm'");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьОтчет(ТабличныйДокумент, ДанныеРасшифровки, НастройкиКД)
	
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(СхемаКомпоновкиДанных, НастройкиКД);
	
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(МакетКД, , ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаРезультатаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаКД.УстановитьДокумент(ТабличныйДокумент);
	ПроцессорВыводаРезультатаКД.Вывести(ПроцессорКД);
	
	//ОтчетПустой = ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКД);
	//КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.Вставить("ВариантСтандартногоПериода", ВариантСтандартногоПериода.Месяц);
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли