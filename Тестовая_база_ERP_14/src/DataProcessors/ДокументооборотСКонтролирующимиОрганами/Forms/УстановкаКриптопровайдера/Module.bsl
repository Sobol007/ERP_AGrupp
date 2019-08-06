
&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ЭтоОткрытиеИзВторичногоМастера", ЭтоОткрытиеИзВторичногоМастера);
	
	Если ЭтоОткрытиеИзВторичногоМастера Тогда
		Элементы.ПодсказкаНетCSP.Заголовок = НСтр("ru = 'Для отправки заявления необходимо установить программу для защиты информации';
													|en = 'To send a request, install an information protection application'");
		Элементы.ПодсказкаНетCSP6.Заголовок = НСтр("ru = 'После установки и перезагрузки компьютера работу с заявлением можно будет продолжить';
													|en = 'You can continue working with the application after installation and the computer restart'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодсказкаНетCSP3ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку("http://infotecs.ru/");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаНетCSP5ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку("http://www.cryptopro.ru/");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкачатьViPNet(Команда)
	 
	Оповещение = Новый ОписаниеОповещения("СкачатьViPNetПослеУстановки", ЭтотОбъект);
	ОбщегоНазначенияЭДКОКлиент.УстановитьViPNetCSP(Оповещение, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьCryptoPro(Команда)
	
	Оповещение = Новый ОписаниеОповещения("СкачатьCryptoProПослеУстановки", ЭтотОбъект);
	ОбщегоНазначенияЭДКОКлиент.УстановитьCryptoProCSP(Оповещение, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СкачатьViPNetПослеУстановки(Результат, ВходящийКонтекст) Экспорт
	
	Если НЕ Результат.Выполнено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось установить криптопровайдер.';
																|en = 'Cannot install cryptographic service provider.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьCryptoProПослеУстановки(Результат, ВходящийКонтекст) Экспорт
	
	Если НЕ Результат.Выполнено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось установить криптопровайдер.';
																|en = 'Cannot install cryptographic service provider.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;

КонецПроцедуры

#КонецОбласти



