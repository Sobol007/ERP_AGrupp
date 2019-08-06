&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьПараметрыВыбора_БанкУК();
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаИнструкции138И", Дата(2012,10,01));
	Список.Параметры.УстановитьЗначениеПараметра("ДатаИнструкции181И", Дата(2018,03,01));
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ОтборОрганизацияИспользование);
			
	ОтборБанкУКИспользование = Ложь;
	ОтборБанкУК = Неопределено;
	
	ОтборБанкУКИспользованиеПриИзменении(Элемент);
	УстановитьПараметрыВыбора_БанкУК();
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	ОтборОрганизацияИспользованиеПриИзменении(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтборБанкУКИспользованиеПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"БанкУК",
		ОтборБанкУК,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ОтборБанкУКИспользование);
КонецПроцедуры

&НаКлиенте
Процедура ОтборБанкУКПриИзменении(Элемент)
	ОтборБанкУКИспользование = ЗначениеЗаполнено(ОтборБанкУК);
	ОтборБанкУКИспользованиеПриИзменении(Элемент);
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокБанковНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	*
	|ИЗ (
	|	ВЫБРАТЬ
	|		РЭЙ_БанковскиеСчетаВалютные.Банк
	|	ИЗ
	|		Справочник.РЭЙ_БанковскиеСчетаВалютные КАК РЭЙ_БанковскиеСчетаВалютные
	|	ГДЕ РЭЙ_БанковскиеСчетаВалютные.Владелец ССЫЛКА Справочник.Организации
	|" + ?(ЗначениеЗаполнено(ОтборОрганизация) И ОтборОрганизацияИспользование, " И РЭЙ_БанковскиеСчетаВалютные.Владелец = (&Владелец)", "") + "
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		БанковскиеСчета.Банк
	|	ИЗ
	|		Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчета
	|	ГДЕ БанковскиеСчета.Владелец ССЫЛКА Справочник.Организации
	|" + ?(ЗначениеЗаполнено(ОтборОрганизация) И ОтборОрганизацияИспользование, " И БанковскиеСчета.Владелец = (&Владелец)", "") + "
	|	) КАК Т
	|";
	Запрос.УстановитьПараметр("Владелец", ОтборОрганизация);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		
		ТаблицаЗначенийЗапроса	= РезультатЗапроса.Выгрузить();
		МассивБанков 	= ТаблицаЗначенийЗапроса.ВыгрузитьКолонку(0);
		                       	
	КонецЕсли;
	
	Возврат МассивБанков;

КонецФункции

&НаСервере
Процедура УстановитьПараметрыВыбора_БанкУК()
	МассивПараметровВыбора = Новый Массив;
	
	МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ПолучитьСписокБанковНаСервере()));
	
	Элементы.ОтборБанкУК.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
КонецПроцедуры
