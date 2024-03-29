
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("АктивПассив") Тогда
		ПризнакАктивПассив = Параметры.АктивПассив;
		Если ПризнакАктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив Тогда
			Элементы.Статья.Заголовок = НСтр("ru = 'Статья активов';
											|en = 'Asset item'");
			Заголовок = НСтр("ru = 'Выбор статьи активов и аналитики';
							|en = 'Select an item of assets and dimension'");
		Иначе
			Элементы.Статья.Заголовок = НСтр("ru = 'Статья пассивов';
											|en = 'Liability item'");
			Заголовок = НСтр("ru = 'Выбор статьи пассивов и аналитики';
							|en = 'Select an item of liabilities and dimension'");
		КонецЕсли;
		
		ПараметрВыбора = Новый ПараметрВыбора("Отбор.АктивПассив", Параметры.АктивПассив);
		МассивПараметровВыбора = Новый Массив;
		МассивПараметровВыбора.Добавить(ПараметрВыбора);
		Элементы.Статья.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	Иначе
		Заголовок = НСтр("ru = 'Выбор статьи и аналитики';
						|en = 'Select item and dimension'");
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		Параметр = Новый Структура("Статья, Аналитика", СтатьяАктивовПассивов, АналитикаАктивовПассивов);
		Закрыть(Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
