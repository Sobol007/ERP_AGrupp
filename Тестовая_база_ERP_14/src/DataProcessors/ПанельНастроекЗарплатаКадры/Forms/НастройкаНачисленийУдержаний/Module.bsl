#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьНастройкиПрограммы();
	ОбновитьФормуПоНастройкам();
	
	РаботаВБюджетномУчреждении = ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
	ИспользованиеТарифныхГрупп = ПолучитьФункциональнуюОпцию("ИспользоватьТарифныеСеткиПриРасчетеЗарплаты");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 		
		"ГруппаКвалификационнаяНадбавка", "Видимость", РаботаВБюджетномУчреждении И ИспользованиеТарифныхГрупп);
		
	ПоказыватьУправленческийУчет = Ложь;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы")
		И ПолучитьФункциональнуюОпцию("РаботаВХозрасчетнойОрганизации")
		И ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		ПоказыватьУправленческийУчет = Истина;
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УправленческийУчет", "Видимость", ПоказыватьУправленческийУчет);
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНастройкиНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНастройкиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьУчетВремениСотрудниковВЧасахПриИзменении(Элемент)
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьУчетВремениСотрудниковВЧасах Тогда
		// Восстановим прежние значения зависимых настроек.
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхКомандировок 	  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуВнутрисменныхКомандировок;
		НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтпускаБезОплаты 		  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьВнутрисменныеОтпускаБезОплаты;
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхПростоев	      = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуВнутрисменныхПростоев;
		НастройкиРасчетаЗарплаты.ИспользоватьУчетВнутрисменныхПрочихНевыходов	  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьУчетВнутрисменныхПрочихНевыходов;
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуСверхурочных               	  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуСверхурочных;
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуПереработокСуммированногоУчета = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуПереработокСуммированногоУчета;
		
		НастройкиУчетаВремени.УчитыватьНочныеЧасы 	= НастройкиУчетаВремениПрежняя.УчитыватьНочныеЧасы;
		НастройкиУчетаВремени.УчитыватьВечерниеЧасы = НастройкиУчетаВремениПрежняя.УчитыватьВечерниеЧасы;
		НастройкиУчетаВремени.УчитыватьВремяНаКормлениеРебенка = НастройкиУчетаВремениПрежняя.УчитыватьВремяНаКормлениеРебенка;
		
	Иначе
		
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуВнутрисменныхКомандировок 	 = НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхКомандировок;
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьВнутрисменныеОтпускаБезОплаты  		 = НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтпускаБезОплаты;
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуВнутрисменныхПростоев		     = НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхПростоев;
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьУчетВнутрисменныхПрочихНевыходов	 = НастройкиРасчетаЗарплаты.ИспользоватьУчетВнутрисменныхПрочихНевыходов;
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуСверхурочных            	     = НастройкиРасчетаЗарплаты.ИспользоватьОплатуСверхурочных;
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуПереработокСуммированногоУчета = НастройкиРасчетаЗарплаты.ИспользоватьОплатуПереработокСуммированногоУчета;
		
		НастройкиУчетаВремениПрежняя.УчитыватьНочныеЧасы 	= НастройкиУчетаВремени.УчитыватьНочныеЧасы;
		НастройкиУчетаВремениПрежняя.УчитыватьВечерниеЧасы 	= НастройкиУчетаВремени.УчитыватьВечерниеЧасы;
		НастройкиУчетаВремениПрежняя.УчитыватьВремяНаКормлениеРебенка 			= НастройкиУчетаВремени.УчитыватьВремяНаКормлениеРебенка;
		
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхКомандировок	  = Ложь;
		НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтпускаБезОплаты  	  = Ложь;
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхПростоев    	  = Ложь;
		НастройкиРасчетаЗарплаты.ИспользоватьУчетВнутрисменныхПрочихНевыходов	  = Ложь;
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуСверхурочных 				  = Ложь;
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуПереработокСуммированногоУчета = Ложь;
		
		НастройкиУчетаВремени.УчитыватьНочныеЧасы   = Ложь;
		НастройкиУчетаВремени.УчитыватьВечерниеЧасы = Ложь;
		НастройкиУчетаВремени.УчитыватьВремяНаКормлениеРебенка = Ложь;
		
	КонецЕсли;
	
	ОбновитьФормуПриИзмененииУчетаВремени(ЭтаФорма);
	ОбновитьДоступностьИспользоватьОтгулы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуКомандировокПриИзменении(Элемент)
	
	Элементы.ОплачиватьДлительныеКомандировкиПомесячно.Доступность   = НастройкиРасчетаЗарплаты.ИспользоватьОплатуКомандировок;
	Если НастройкиРасчетаЗарплаты.ИспользоватьОплатуКомандировок Тогда
		НастройкиРасчетаЗарплаты.ОплачиватьДлительныеКомандировкиПомесячно  = НастройкиРасчетаЗарплатыПрежняя.ОплачиватьДлительныеКомандировкиПомесячно;
	Иначе
		НастройкиРасчетаЗарплатыПрежняя.ОплачиватьДлительныеКомандировкиПомесячно  = НастройкиРасчетаЗарплаты.ОплачиватьДлительныеКомандировкиПомесячно;
		НастройкиРасчетаЗарплаты.ОплачиватьДлительныеКомандировкиПомесячно = Ложь;
	КонецЕсли;
	
	НастройкаДоступна = НастройкиРасчетаЗарплаты.ИспользоватьУчетВремениСотрудниковВЧасах И НастройкиРасчетаЗарплаты.ИспользоватьОплатуКомандировок;
	Элементы.ИспользоватьОплатуВнутрисменныхКомандировок.Доступность = НастройкаДоступна;
	Если НастройкаДоступна Тогда
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхКомандировок  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуВнутрисменныхКомандировок;
	Иначе
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуВнутрисменныхКомандировок  = НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхКомандировок;
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхКомандировок = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуСверхурочныхПриИзменении(Элемент)
	
	ОбновитьДоступностьИспользоватьОтгулы(ЭтаФорма);	
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуПереработокСуммированногоУчетаПриИзменении(Элемент)
	
	ОбновитьДоступностьИспользоватьОтгулы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьИспользоватьОтгулы(Форма)
	
	НастройкаДоступна = Форма.НастройкиРасчетаЗарплаты.ИспользоватьОплатуПраздничныхИВыходных
						Или Форма.НастройкиРасчетаЗарплаты.ИспользоватьОплатуСверхурочных
						Или Форма.НастройкиРасчетаЗарплаты.ИспользоватьОплатуПереработокСуммированногоУчета;
	
	Если НастройкаДоступна Тогда
		Форма.НастройкиРасчетаЗарплаты.ИспользоватьОтгулы  = Форма.НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОтгулы;
		Форма.Элементы.ГруппаОтгулыПояснение.ТекущаяСтраница = Форма.Элементы.СтраницаОтгулыДоступны;
	Иначе
		Форма.НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОтгулы  = Форма.НастройкиРасчетаЗарплаты.ИспользоватьОтгулы;
		Форма.НастройкиРасчетаЗарплаты.ИспользоватьОтгулы = Ложь;
		Форма.Элементы.ГруппаОтгулыПояснение.ТекущаяСтраница = Форма.Элементы.СтраницаОтгулыНедоступны;
	КонецЕсли;
	
	Если НастройкаДоступна И Форма.НастройкиРасчетаЗарплаты.ИспользоватьОтгулы И Форма.НастройкиРасчетаЗарплаты.ИспользоватьУчетВремениСотрудниковВЧасах Тогда
		Форма.НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтгулы  = Форма.НастройкиРасчетаЗарплатыПрежняя.ИспользоватьВнутрисменныеОтгулы;
	Иначе
		Форма.НастройкиРасчетаЗарплатыПрежняя.ИспользоватьВнутрисменныеОтгулы  = Форма.НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтгулы;
		Форма.НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтгулы = Ложь;
	КонецЕсли;
	
	Форма.Элементы.ГруппаОтгулы.Доступность = НастройкаДоступна;
	Форма.Элементы.ИспользоватьОтгулы.Доступность = НастройкаДоступна;
	Форма.Элементы.ИспользоватьВнутрисменныеОтгулы.Доступность = НастройкаДоступна И Форма.НастройкиРасчетаЗарплаты.ИспользоватьОтгулы И Форма.НастройкиРасчетаЗарплаты.ИспользоватьУчетВремениСотрудниковВЧасах;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуПраздничныхИВыходныхПриИзменении(Элемент)
	
	ОбновитьДоступностьИспользоватьОтгулы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтгулыПриИзменении(Элемент)
	
	НастройкаДоступна = НастройкиРасчетаЗарплаты.ИспользоватьУчетВремениСотрудниковВЧасах И НастройкиРасчетаЗарплаты.ИспользоватьОтгулы;
	
	Элементы.ИспользоватьВнутрисменныеОтгулы.Доступность = НастройкаДоступна;
	
	Если НастройкаДоступна Тогда
		НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтгулы  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьВнутрисменныеОтгулы;
	Иначе
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьВнутрисменныеОтгулы  = НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтгулы;
		НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтгулы = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтпускаБезОплатыПриИзменении(Элемент)
	
	НастройкаДоступна = НастройкиРасчетаЗарплаты.ИспользоватьУчетВремениСотрудниковВЧасах И НастройкиРасчетаЗарплаты.ИспользоватьОтпускаБезОплаты;
	
	Элементы.ИспользоватьВнутрисменныеОтпускаБезОплаты.Доступность = НастройкаДоступна;
	
	Если НастройкаДоступна Тогда
		НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтпускаБезОплаты  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьВнутрисменныеОтпускаБезОплаты;
	Иначе
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьВнутрисменныеОтпускаБезОплаты  = НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтпускаБезОплаты;
		НастройкиРасчетаЗарплаты.ИспользоватьВнутрисменныеОтпускаБезОплаты = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуПростоевПриИзменении(Элемент)
	
	НастройкаДоступна = НастройкиРасчетаЗарплаты.ИспользоватьУчетВремениСотрудниковВЧасах И НастройкиРасчетаЗарплаты.ИспользоватьОплатуПростоев;
	
	Элементы.ИспользоватьОплатуВнутрисменныхПростоев.Доступность = НастройкаДоступна;
	
	Если НастройкаДоступна Тогда
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхПростоев  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуВнутрисменныхПростоев;
	Иначе
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьОплатуВнутрисменныхПростоев  = НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхПростоев;
		НастройкиРасчетаЗарплаты.ИспользоватьОплатуВнутрисменныхПростоев = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетПрочихНевыходовПриИзменении(Элемент)
	
	НастройкаДоступна = НастройкиРасчетаЗарплаты.ИспользоватьУчетВремениСотрудниковВЧасах И НастройкиРасчетаЗарплаты.ИспользоватьУчетПрочихНевыходов;
	
	Элементы.ИспользоватьУчетВнутрисменныхПрочихНевыходов.Доступность = НастройкаДоступна;
	
	Если НастройкаДоступна Тогда
		НастройкиРасчетаЗарплаты.ИспользоватьУчетВнутрисменныхПрочихНевыходов  = НастройкиРасчетаЗарплатыПрежняя.ИспользоватьУчетВнутрисменныхПрочихНевыходов;
	Иначе
		НастройкиРасчетаЗарплатыПрежняя.ИспользоватьУчетВнутрисменныхПрочихНевыходов  = НастройкиРасчетаЗарплаты.ИспользоватьУчетВнутрисменныхПрочихНевыходов;
		НастройкиРасчетаЗарплаты.ИспользоватьУчетВнутрисменныхПрочихНевыходов = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьНастройкиПрограммы()
	
	Настройки = РегистрыСведений.НастройкиРасчетаЗарплатыРасширенный.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	ЗначениеВРеквизитФормы(Настройки, "НастройкиРасчетаЗарплаты");
	ЗначениеВРеквизитФормы(Настройки, "НастройкиРасчетаЗарплатыПрежняя");
	
	Настройки = РегистрыСведений.НастройкиУчетаВремени.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	ЗначениеВРеквизитФормы(Настройки, "НастройкиУчетаВремени");
	ЗначениеВРеквизитФормы(Настройки, "НастройкиУчетаВремениПрежняя");
	
	ИспользоватьУправленческуюЗарплату = Константы.ИспользоватьУправленческуюЗарплату.Получить();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФормуПоНастройкам()
	
	ОбновитьФормуПриИзмененииУчетаВремени(ЭтаФорма);
	ОбновитьДоступностьИспользоватьОтгулы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьФормуПриИзмененииУчетаВремени(Форма)

	Настройки = Форма.НастройкиРасчетаЗарплаты;
	ИспользоватьУчетВремени = Настройки.ИспользоватьУчетВремениСотрудниковВЧасах;
	Элементы = Форма.Элементы;
	Элементы.УчитыватьНочныеЧасы.Доступность = ИспользоватьУчетВремени;
	Элементы.УчитыватьВечерниеЧасы.Доступность = ИспользоватьУчетВремени;
	Элементы.УчитыватьВремяНаКормлениеРебенка.Доступность = ИспользоватьУчетВремени;
	Элементы.ИспользоватьОплатуСверхурочных.Доступность = ИспользоватьУчетВремени;
	Элементы.ИспользоватьОплатуПереработокСуммированногоУчета.Доступность = ИспользоватьУчетВремени;
	
	Элементы.ИспользоватьОтгулы.Доступность = ИспользоватьУчетВремени И (Настройки.ИспользоватьОплатуСверхурочных ИЛИ Настройки.ИспользоватьОплатуПереработокСуммированногоУчета);
	Элементы.ИспользоватьВнутрисменныеОтгулы.Доступность = ИспользоватьУчетВремени И Настройки.ИспользоватьОплатуСверхурочных И Настройки.ИспользоватьОтгулы;
	
	Элементы.ОплачиватьДлительныеКомандировкиПомесячно.Доступность    = Настройки.ИспользоватьОплатуКомандировок;
	Элементы.ИспользоватьОплатуВнутрисменныхКомандировок.Доступность  = ИспользоватьУчетВремени И Настройки.ИспользоватьОплатуКомандировок;
	Элементы.ИспользоватьВнутрисменныеОтпускаБезОплаты.Доступность    = ИспользоватьУчетВремени И Настройки.ИспользоватьОтпускаБезОплаты;
	Элементы.ИспользоватьУчетВнутрисменныхПрочихНевыходов.Доступность = ИспользоватьУчетВремени И Настройки.ИспользоватьУчетПрочихНевыходов;
	Элементы.ИспользоватьОплатуВнутрисменныхПростоев.Доступность      = ИспользоватьУчетВремени И Настройки.ИспользоватьОплатуПростоев;

КонецПроцедуры

&НаСервере
Функция ЗаписатьНастройкиНаСервере()
	
	ПараметрыНастроек = Обработки.ПанельНастроекЗарплатаКадры.ЗаполнитьСтруктуруПараметровНастроек("СоздатьПВР,НастройкиРасчетаЗарплаты,НастройкиУчетаВремени,ИспользоватьУправленческуюЗарплату");
	ПараметрыНастроек.НастройкиРасчетаЗарплаты = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(НастройкиРасчетаЗарплаты, Метаданные.РегистрыСведений.НастройкиРасчетаЗарплатыРасширенный);
	ПараметрыНастроек.НастройкиУчетаВремени = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(НастройкиУчетаВремени, Метаданные.РегистрыСведений.НастройкиУчетаВремени);
	ПараметрыНастроек.ИспользоватьУправленческуюЗарплату = ИспользоватьУправленческуюЗарплату;
	
	НаименованиеЗадания = НСтр("ru = 'Сохранение настроек расчета зарплаты';
								|en = 'Save payroll settings'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.ПанельНастроекЗарплатаКадры.ЗаписатьНастройки",
		ПараметрыНастроек,
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьНастройкиНаКлиенте(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт	
	
	Результат = ЗаписатьНастройкиНаСервере();
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		Модифицированность = Ложь;
		ЗарплатаКадрыРасширенныйВызовСервера.ПередОбновлениемИнтерфейса();
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьИнтерфейс();
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ОбновитьПовторноИспользуемыеЗначения();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				ЗарплатаКадрыРасширенныйВызовСервера.ПередОбновлениемИнтерфейса();
				ОбновитьИнтерфейс();
				Модифицированность = Ложь;
				Закрыть();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
