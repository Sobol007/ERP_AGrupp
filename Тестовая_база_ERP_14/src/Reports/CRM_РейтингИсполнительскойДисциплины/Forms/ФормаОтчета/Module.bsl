
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	ОтборПериод.Вариант = ВариантСтандартногоПериода.Месяц;
	Отчет.Дата1 		= ОтборПериод.ДатаНачала;
	Отчет.Дата2 		= ОтборПериод.ДатаОкончания;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПериодПриИзменении(Элемент)
	Отчет.Дата1 = ОтборПериод.ДатаНачала;
	Отчет.Дата2 = ОтборПериод.ДатаОкончания;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)	
	Если Отчет.Дата1=Дата(1,1,1) 
			Или Отчет.Дата2=Дата(1,1,1) Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Укажите начало и окончание периода отчета.';en='Specify the beginning and the end of report period.'"), ,
		"Отчет.Дата1");
		Возврат;
		
	ИначеЕсли Отчет.Дата1>Отчет.Дата2 Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Начало отчета не может быть больше окончания.';en='The start of report can not be more than the end.'"), ,
		"Отчет.Дата1");
		Возврат;
		
	КонецЕсли;                            
	
	СформироватьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьНаСервере()
	ОбъектОтчет	= РеквизитФормыВЗначение("Отчет");
	ОбъектОтчет.ЗаполнитьОтчет(ТабДокумент);	
КонецПроцедуры

#КонецОбласти 



