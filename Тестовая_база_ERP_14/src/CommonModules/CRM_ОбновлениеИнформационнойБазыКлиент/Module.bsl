
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии CRM".
// Клиентские процедуры и функции для интерактивного обновления информационной базы.
//
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Вызывается перед интерактивным началом работы пользователя с областью данных.
//  Соответствует событию ПередНачаломРаботыСистемы модулей приложения.
//
// Параметры:
//  Параметры	 - Структура - Параметры процедуры.
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ИмяПараметра = "CRM_ПараметрыЗапуска";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	
	// +На удаление
	//Если CRM_ОбновлениеИнформационнойБазы.ПервыйЗапускИнформационнойБазы() Тогда
	//	СтруктураДанных.Вставить("ЭтоПервыйЗапускИнформационнойБазы", Истина);
	//Иначе
	//	СтруктураДанных.Вставить("ЭтоПервыйЗапускИнформационнойБазы", Ложь);
	//КонецЕсли;
	// -На удаление
	
	Если СтрНачинаетсяС(CRM_ОбновлениеИнформационнойБазы.ВерсияCRM(), "2.0") Тогда
		СтруктураДанных.Вставить("ЭтоПереходСВерсии20", Истина);
	Иначе
		СтруктураДанных.Вставить("ЭтоПереходСВерсии20", Ложь);		
	КонецЕсли;
	
	Если CRM_ОбновлениеИнформационнойБазы.ПолучитьРежимОбновленияДанных() = "ПереходСДругойПрограммы" Тогда
		СтруктураДанных.Вставить("ЭтоПереходСДругойПрограммы", Истина);
	Иначе
		СтруктураДанных.Вставить("ЭтоПереходСДругойПрограммы", Ложь);
	КонецЕсли;
	
	// +На удаление
	//Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
	//	СтруктураДанных.Вставить("ЗапускатьМастерНастройкиРешения", CRM_ОбновлениеИнформационнойБазы.ЗапускатьМастерНастройкиРешения());
	//КонецЕсли;
	// -На удаление
	
	Если CRM_ДемонстрационныйРежим.ЭтоДемоРежим() Тогда
		СтруктураДанных.Вставить("ЗакладкиНеОткрываем", Истина);
	Иначе
		СтруктураДанных.Вставить("ЗакладкиНеОткрываем", Ложь);
	КонецЕсли;
	
	ПараметрыПриложения["CRM_ПараметрыЗапуска"] = СтруктураДанных;
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	CRM_ПараметрыЗапуска = ПараметрыПриложения["CRM_ПараметрыЗапуска"];
	Если НЕ CRM_ДемонстрационныйРежим.CRM_РазделениеВключено() Тогда
		
		// +На удаление
		//Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		//	// Открывается при первом старте CRM.
		//	Если CRM_ПараметрыЗапуска.ЭтоПервыйЗапускИнформационнойБазы ИЛИ CRM_ПараметрыЗапуска.ЭтоПереходСДругойПрограммы ИЛИ CRM_ПараметрыЗапуска.ЗапускатьМастерНастройкиРешения Тогда
		//		ИмяФормыОбработки = "Обработка.CRM_МастерНастройкиРешения.Форма";
		//		ОткрытьФорму(ИмяФормыОбработки);
		//	КонецЕсли;
		//КонецЕсли;
		// -На удаление
		
		// Открывается после перехода с CRM 2.0 на 3.0.
		Если CRM_ПараметрыЗапуска.ЭтоПереходСВерсии20 Тогда
			ИмяФормыОбработки = "Обработка.CRM_МастерКонвертацииСобытийВИнтересы.Форма";
			ОткрытьФорму(ИмяФормыОбработки);
		КонецЕсли;
		
	КонецЕсли;
	ПараметрыПриложения.Удалить("CRM_ПараметрыЗапуска");
	
КонецПроцедуры

#КонецОбласти
