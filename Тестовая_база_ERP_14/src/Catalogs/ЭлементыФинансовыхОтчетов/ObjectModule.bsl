#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ПометкаУдаления И ТипЗнч(Владелец) = Тип("СправочникСсылка.ВидыБюджетов")
		И Не БюджетнаяОтчетностьСерверПовтИсп.ЭлементПомеченНаУдаление(Владелец) Тогда
		ВызватьИсключение НСтр("ru = 'Для удаления элементов финансовой отчетности пометьте на удаление
									|элемент справочника-владельца """ + 
									?(ТипЗнч(Владелец) = Тип("СправочникСсылка.ВидыБюджетов"), 
									НСтр("ru = 'Виды бюджетов';
										|en = 'Budget profiles'"), НСтр("ru = 'Виды отчетов';
																		|en = 'Report kinds'")) + """'");
	КонецЕсли;
	
	Наименование = "" + ВидЭлемента + ": " + НаименованиеДляПечати + ", ";
	Для Каждого ДополнительныйРеквизит Из РеквизитыВидаЭлемента Цикл
		Если Не ЗначениеЗаполнено(ДополнительныйРеквизит.Значение) Тогда
			Продолжить;
		КонецЕсли;
		Наименование = Наименование + ДополнительныйРеквизит.Значение + ", ";
	КонецЦикла;
	
	Наименование = Лев(Наименование, СтрДлина(Наименование) - 2);
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ВидыБюджетов") Тогда
		УстановитьНастройкиВидаБюджета();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьНастройкиВидаБюджета()
	Перем Компоновщик;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, 
												"ИспользоватьДляВводаПлана, АналитикиШапки");
	ИспользоватьДляВводаПлана = Реквизиты.ИспользоватьДляВводаПлана;
	ВидыАналитикШапки = Реквизиты.АналитикиШапки.Выгрузить();
	
	ВидРодителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ВидЭлемента");
	
	Если ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.ВсеПоказателиБюджетов
		ИЛИ ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.ВсеСтатьиБюджетов
		ИЛИ ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов
		ИЛИ ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.ПоказательБюджетов
		ИЛИ ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель Тогда
		
		// Если элемент подчинен производному показателю или статье бюджетов - то
		// это операнд формулы.
		СброситьИспользованиеФильтров = Ложь;
		
		Если ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов Тогда
			Если НЕ ВидРодителя = Перечисления.ВидыЭлементовФинансовогоОтчета.ПроизводныйПоказатель
				И НЕ ВидРодителя = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов Тогда
				
				СброситьИспользованиеФильтров = ИспользоватьДляВводаПлана;
				
			КонецЕсли;
		КонецЕсли;
		
		Если СброситьИспользованиеФильтров Тогда
			ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоОрганизации", Ложь);
			ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоПодразделению", Ложь);
			ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоСценарию", Ложь);
		КонецЕсли;
		
		Реквизиты = ФинансоваяОтчетностьКлиентСервер.СтруктураЭлементаОтчета();
		ЗаполнитьЗначенияСвойств(Реквизиты, ЭтотОбъект);
		Реквизиты.Вставить("СтатьяБюджетов", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "СтатьяБюджетов"));
		Реквизиты.Вставить("ПоказательБюджетов", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "ПоказательБюджетов"));
		Реквизиты.Вставить("НефинансовыйПоказатель", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "НефинансовыйПоказатель"));
		Реквизиты.Вставить("ИспользоватьФильтрПоОрганизации", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоОрганизации") = Истина);
		Реквизиты.Вставить("ИспользоватьФильтрПоПодразделению", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоПодразделению") = Истина);
		Реквизиты.Вставить("ИспользоватьФильтрПоСценарию", 
			ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(ЭтотОбъект, "ИспользоватьФильтрПоСценарию") = Истина);
		Реквизиты.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор());
			
		Справочники.ЭлементыФинансовыхОтчетов.УстановитьНастройкиОтбора(Реквизиты, Компоновщик, ВидЭлемента, ДополнительныйОтбор);
		
		СписокЭлементов = Новый Массив;
		Если СброситьИспользованиеФильтров Тогда
			Компоновщик.Настройки.Отбор.Элементы.Очистить();
		КонецЕсли;
		
		Если ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель Тогда
			РеквизитыНФП = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Реквизиты.НефинансовыйПоказатель, 
																"ПоОрганизациям, ПоПодразделениям, ПоСценариям,
																|ВидАналитики1, ВидАналитики2, ВидАналитики3, ВидАналитики4,
																|ВидАналитики5, ВидАналитики6");
		КонецЕсли;
		
		Если НЕ Реквизиты.ИспользоватьФильтрПоОрганизации Тогда
			БюджетнаяОтчетностьРасчетКэшаСервер.НайтиОтборПоИмени(Компоновщик.Настройки, "Организация", СписокЭлементов);
			Если ВидЭлемента <> Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель
				ИЛИ РеквизитыНФП.ПоОрганизациям Тогда
				ФинансоваяОтчетностьСервер.УстановитьОтбор(Компоновщик.Настройки.Отбор, "Организация", 
					"<заполнить_организация>", ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ Реквизиты.ИспользоватьФильтрПоПодразделению Тогда
			БюджетнаяОтчетностьРасчетКэшаСервер.НайтиОтборПоИмени(Компоновщик.Настройки, "Подразделение", СписокЭлементов);
			Если ВидЭлемента <> Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель
				ИЛИ РеквизитыНФП.ПоПодразделениям Тогда
				ФинансоваяОтчетностьСервер.УстановитьОтбор(Компоновщик.Настройки.Отбор, "Подразделение", 
					"<заполнить_подразделение>", ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ Реквизиты.ИспользоватьФильтрПоСценарию Тогда
			БюджетнаяОтчетностьРасчетКэшаСервер.НайтиОтборПоИмени(Компоновщик.Настройки, "Сценарий", СписокЭлементов);
			Если ВидЭлемента <> Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель
				ИЛИ РеквизитыНФП.ПоСценариям Тогда
				ФинансоваяОтчетностьСервер.УстановитьОтбор(Компоновщик.Настройки.Отбор, "Сценарий", 
					"<заполнить_сценарий>", ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
		КонецЕсли;
		
		ФинансоваяОтчетностьСервер.УстановитьОтбор(Компоновщик.Настройки.Отбор, "ВалютаХранения", 
										"<заполнить_валютахранения>", ВидСравненияКомпоновкиДанных.Равно);
					
		Для Каждого Выборка Из ВидыАналитикШапки Цикл
			ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(Выборка.ВидАналитики);
			Если ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель Тогда
				НФПСодержитАналитикуШапки = Ложь;
				Для Сч = 1 По 6 Цикл
					Если РеквизитыНФП["ВидАналитики" + Сч] = Выборка.ВидАналитики Тогда
						НФПСодержитАналитикуШапки = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если Не НФПСодержитАналитикуШапки Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			ЭлементОтбора = ФинансоваяОтчетностьСервер.НайтиЭлементОтбора(Компоновщик.Настройки.Отбор, ИмяПоля);
			Если ЭлементОтбора = Неопределено ИЛИ Не ЭлементОтбора.Использование Тогда
				ФинансоваяОтчетностьСервер.УстановитьОтбор(Компоновщик.Настройки.Отбор, ИмяПоля, "<заполнить_" + ИмяПоля + ">", ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
		КонецЦикла;
		
		БюджетнаяОтчетностьРасчетКэшаСервер.НайтиОтборПоИмени(Компоновщик.Настройки, "", СписокЭлементов);
		
		Для Каждого ЭлементКУдалению Из СписокЭлементов Цикл
			Компоновщик.Настройки.Отбор.Элементы.Удалить(ЭлементКУдалению);
		КонецЦикла;
		
		ДополнительныйОтбор = Новый ХранилищеЗначения(Компоновщик.Настройки);
		
	КонецЕсли;
	
	Если ИспользоватьДляВводаПлана Тогда
		
		Если ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов Тогда
			// Если элемент подчинен производному показателю или статье бюджетов - то
			// это операнд формулы.
			Если НЕ ВидРодителя = Перечисления.ВидыЭлементовФинансовогоОтчета.ПроизводныйПоказатель
				И НЕ ВидРодителя = Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов Тогда
				
				ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "НижняяГраницаДанных", "[Начало периода данных]");
				ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "ВерхняяГраницаДанных", "[Конец периода данных]");
				ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "НачалоПериодаГруппировки", "[Период группировки]");
				ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(ЭтотОбъект, "КонецПериодаГруппировки", "[Период группировки]");
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли