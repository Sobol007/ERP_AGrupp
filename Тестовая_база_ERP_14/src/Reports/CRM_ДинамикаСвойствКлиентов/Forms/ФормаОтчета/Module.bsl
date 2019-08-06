
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Если Не ПолучитьФункциональнуюОпцию("CRM_ВестиИсториюРеквизитовКлиентов") Тогда
	//	Отказ = Истина;
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Ведение истории реквизитов клиентов отключено в настройках!';en='Guiding of history of details of customers are disconnect in settings!'"));
	//	Возврат;
	//КонецЕсли;
	
	СписокВыбораРеквизитовКлиента.Очистить();
	СписокВерсионируемыхРеквизитов = РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров.ПолучитьСписокВерсионируемыхРеквизитов();
	Для Каждого ЗначениеСписка Из СписокВерсионируемыхРеквизитов Цикл
		СписокВыбораРеквизитовКлиента.Добавить(ЗначениеСписка.Значение, ЗначениеСписка.Представление);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСкомпоноватьРезультат(Команда)
	СкомпоноватьРезультат(РежимКомпоновкиРезультата.Непосредственно);
	
	ПослеКомпоновкиРезультата();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеКомпоновкиРезультата()
	Для Каждого Рисунок Из Результат.Рисунки Цикл
		Попытка		РисунокОбъект = Рисунок.Объект;
		Исключение	Продолжить;
		КонецПопытки;
		
		Если ТипЗнч(РисунокОбъект) = Тип("Диаграмма") Тогда
			Рисунок.Ширина = 250;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекПользовательскиеНастройкиЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекДанные = Элементы.КомпоновщикНастроекПользовательскиеНастройки.ТекущиеДанные;
	
	Если ТекДанные <> Неопределено Тогда
		Попытка		бЭтоПолеРеквизита = (ТекДанные.Настройка = "Реквизит")
		Исключение	бЭтоПолеРеквизита = Ложь;
		КонецПопытки;
		
		Если бЭтоПолеРеквизита И Элемент.Имя = "КомпоновщикНастроекПользовательскиеНастройкиЗначение" Тогда
			ДанныеВыбора = СписокВыбораРеквизитовКлиента.Скопировать();
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
