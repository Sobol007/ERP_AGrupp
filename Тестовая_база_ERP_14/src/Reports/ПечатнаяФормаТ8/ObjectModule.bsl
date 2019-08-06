#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Попытка
		
		РезультатКомпоновки = ЗарплатаКадрыОтчеты.РезультатКомпоновкиМакетаПечатнойФормы(ЭтотОбъект, ДанныеРасшифровки);
		Отчеты.ПечатнаяФормаТ8.Сформировать(ДокументРезультат, РезультатКомпоновки);
		
	Исключение
		
		ИнформацияОшибки = ИнформацияОбОшибке();
		ВызватьИсключение НСтр("ru = 'В настройку формирования Т-8 внесены критичные изменения. Печатная форма не будет сформирована';
								|en = 'Critical changes have been made to T-8 generation setting. Print form cannot be generated.'") + ". " + КраткоеПредставлениеОшибки(ИнформацияОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект,
		ЗарплатаКадрыОтчеты.ПоляПредставленийКадровыхДанныхСотрудниковОтчетовПечатныхФорм());
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ЗарплатаКадрыОтчеты.ИнициализироватьОтчетПечатнойФормы(Контекст, ЭтотОбъект, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли