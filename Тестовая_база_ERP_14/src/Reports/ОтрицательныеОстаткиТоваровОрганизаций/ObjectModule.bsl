#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Ложь;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПериодичностьФормированияДокументов = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПериодичностьФормированияДокументов");
	
	Если ПериодичностьФормированияДокументов.Значение = "ПоМесяцам" Тогда
		ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ЗаполнениеПоОтборам.Запрос;
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ", ДЕНЬ)", ", МЕСЯЦ)");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДЕНЬ,", "МЕСЯЦ,");
		СхемаКомпоновкиДанных.НаборыДанных.ЗаполнениеПоОтборам.Запрос = ТекстЗапроса;
	КонецЕсли;	
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("ПериодичностьФормированияДокументов");
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции
#КонецОбласти

#КонецЕсли