
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ОбъектыПечати") Тогда
		ОбъектыПечати.ЗагрузитьЗначения(Параметры.ОбъектыПечати);
	Иначе
		ВызватьИсключение НСтр("ru = 'Не заполнено значение параметра ""ОбъектыПечати""';
								|en = 'Value of the ""ОбъектыПечати"" parameter is not filled in'"); 
	КонецЕсли;
	
	ЗагрузитьНастройкиФормы();
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПечататьСмежныеЭтапыПриИзменении(Элемент)
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечататьМатериалыПриИзменении(Элемент)
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлятьПустыеСтрокиВМатериалыПриИзменении(Элемент)
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечататьВыходныеИзделияПриИзменении(Элемент)
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлятьПустыеСтрокиВВыходныеИзделияПриИзменении(Элемент)
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечататьМаршрутнуюКартуПриИзменении(Элемент)
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.ЭтапПроизводства2_2",
			"ЗаданиеНаПроизводство",
			ОбъектыПечати.ВыгрузитьЗначения(),
			Неопределено,
			ЗначенияПараметровПечати());
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеПараметры(Команда)
	
	ЗаполнитьПараметры(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеПараметры(Команда)
	
	ЗаполнитьПараметры(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьНастройкиФормы()
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		КлючФормы(),
		Неопределено);
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Настройки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиФормыКлиент()
	
	Настройки = ЗначенияПараметровПечати();
	СохранитьНастройкиФормыСервер(Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиФормыСервер(Настройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		КлючФормы(),
		Неопределено,
		Настройки);
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Функция КлючФормы()
	
	Возврат "Документ.ЭтапПроизводства2_2.ПараметрыПечатиЗаданиеНаПроизводство";
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииПараметров()
	
	СохранитьНастройкиФормыКлиент();
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметры(Значение)
	
	ПараметрыПечати = МассивПараметровПечати();
	
	Для каждого Параметр Из ПараметрыПечати Цикл
		
		ЭтотОбъект[Параметр] = Значение;
		
	КонецЦикла;
	
	ПриИзмененииПараметров();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	Форма.Элементы.ДобавлятьПустыеСтрокиВМатериалы.Доступность = Форма.ПечататьМатериалы;
	Если НЕ Форма.Элементы.ДобавлятьПустыеСтрокиВМатериалы.Доступность
		И Форма.ДобавлятьПустыеСтрокиВМатериалы Тогда
		
		Форма.ДобавлятьПустыеСтрокиВМатериалы = Ложь;
		
	КонецЕсли;
	
	Форма.Элементы.ДобавлятьПустыеСтрокиВВыходныеИзделия.Доступность = Форма.ПечататьВыходныеИзделия;
	Если НЕ Форма.Элементы.ДобавлятьПустыеСтрокиВВыходныеИзделия.Доступность
		И Форма.ДобавлятьПустыеСтрокиВВыходныеИзделия Тогда
		
		Форма.ДобавлятьПустыеСтрокиВВыходныеИзделия = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция МассивПараметровПечати()
	
	Результат = Новый Массив;
	
	Результат.Добавить("ПечататьСмежныеЭтапы");
	Результат.Добавить("ПечататьМатериалы");
	Результат.Добавить("ДобавлятьПустыеСтрокиВМатериалы");
	Результат.Добавить("ПечататьВыходныеИзделия");
	Результат.Добавить("ДобавлятьПустыеСтрокиВВыходныеИзделия");
	Результат.Добавить("ПечататьМаршрутнуюКарту");
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ЗначенияПараметровПечати()
	
	ПараметрыПечати = МассивПараметровПечати();
	
	Результат = Новый Структура;
	
	Для каждого Параметр Из ПараметрыПечати Цикл
		
		Результат.Вставить(Параметр, ЭтотОбъект[Параметр]);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
