
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОфлайнОборудованияПереопределяемый.ФормаОбменСОфлайнОборудованиемПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормыККМ

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуДанныхНаККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьНастройки(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуНастроекНаККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПолныйПрайсЛист(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		МенеджерОфлайнОборудованияКлиент.НачатьПолнуюВыгрузкуПрайсЛистаНаККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПрайсЛист(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		МенеджерОфлайнОборудованияКлиент.НачатьОчисткуПрайсЛистаНаККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	ОповещениеПриЗавершении = Неопределено;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		ЭтоПерваяЗагрузкаКассыЭвотор = МенеджерОфлайнОборудованияВызовСервера.ПроверитьИсториюЗагрузкиУстройства(ТекущиеДанные.Ссылка);
		
		Если ЭтоПерваяЗагрузкаКассыЭвотор Тогда
			ОповещениеПриЗавершении = Новый ОписаниеОповещения("ЗагрузитьОтчетЗаПериодЗавершение", ЭтотОбъект);
		КонецЕсли;
			
		МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, ОповещениеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтчетыЗаПериод(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		ЭтоКассаЭвотор = МенеджерОфлайнОборудованияВызовСервера.ПодключаемоеОборудованиеЭвотор(ТекущиеДанные.Ссылка);
		
		Если ЭтоКассаЭвотор Тогда
			ИдентификаторУстройства = ?(ПустаяСтрока(ТекущиеДанные.Ссылка), Неопределено, ТекущиеДанные.Ссылка);
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
			
			ОповещениеПриЗавершении = Новый ОписаниеОповещения("ЗагрузитьОтчетЗаПериодЗавершение", ЭтотОбъект);
			ОткрытьФорму("ОбщаяФорма.ФормаНастройки1СЭвоторККМOfflineПроизвольногоПериодаЗагрузки", ПараметрыФормы, ЭтотОбъект,,,, ОповещениеПриЗавершении, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ТекстСообщения = НСтр("ru = 'Для данного типа устройства данная команда недоступна.';
									|en = 'The command is unavailable for this device type.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтчетЗаПериодЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Если Результат.Результат Тогда
			ТекстСообщения = НСтр("ru = 'Данные загружены успешно';
									|en = 'Data is imported successfully'");
		Иначе
			ТекстСообщения = Результат.ОписаниеОшибки;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти