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
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СостоянияЭтапов = СхемаКомпоновкиДанных.НаборыДанных.Найти("СостоянияЭтапов");
	
	ТекстЗапроса = СостоянияЭтапов.Запрос;
	
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса,
		"&ПредставлениеЭтапа",
		Документы.ЭтапПроизводства2_2.ТекстЗапросаПредставлениеЭтапа("СостоянияЭтаповПроизводства.Этап"));
		
	СостоянияЭтапов.Запрос = ТекстЗапроса;
		
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПооперационноеУправление") Тогда
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(КомпоновщикНастроек, "Операция");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
