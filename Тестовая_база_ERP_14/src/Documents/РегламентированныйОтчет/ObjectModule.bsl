#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мЭтоНовый;

#Область ОбработчикиСобытийМодуляОбъекта

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	мЭтоНовый = ЭтоНовый();
	
	Период = СокрЛП(Формат(ДатаОкончания, "ДФ=yyyyMMdd") + Формат('39991231' - ДатаНачала, "ДФ=yyyyMMdd"));
	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
		ПредставлениеПериода =
			РегламентированнаяОтчетностьВызовСервера.ПредставлениеФинансовогоПериода(ДатаНачала, ДатаОкончания, "Ложь");
	Иначе
		ПредставлениеПериода =
			РегламентированнаяОтчетностьВызовСервера.ПредставлениеФинансовогоПериода(ДатаНачала, ДатаОкончания);
	КонецЕсли;
	
	// Переопределение представления периода для форм бухотчетности.
	ФормыБухОтчетности = Новый Массив;
	ФормыБухОтчетности.Добавить("РегламентированныйОтчетБухОтчетность");
	ФормыБухОтчетности.Добавить("РегламентированныйОтчетБухОтчетностьМП");
	ФормыБухОтчетности.Добавить("РегламентированныйОтчетБухОтчетностьСОНКО");
	
	Если (ФормыБухОтчетности.Найти(ЭтотОбъект.ИсточникОтчета) <> Неопределено И ДатаНачала <> НачалоГода(ДатаНачала))
		ИЛИ ЭтотОбъект.ИсточникОтчета = "РегламентированныйОтчетСтрановойОтчет" Тогда
		ПредставлениеПериода
		= Формат(ДатаНачала, "ДФ=""дд.ММ.гггг""") + " - " + Формат(ДатаОкончания, "ДФ=""дд.ММ.гггг""");
	КонецЕсли;
	
	// Финансовая отчетность для банков.
	Если ЭтотОбъект.ИсточникОтчета = "БухгалтерскаяОтчетностьВБанк" Тогда
		ПредставлениеПериода = ПредставлениеПериода(НачалоМесяца(ДатаОкончания), КонецМесяца(ДатаОкончания), "Л=ru_RU");//Формат(ДатаОкончания, "ДФ='ММММ гггг'");
	КонецЕсли;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	ВыгрузкаРегламентированныхОтчетов.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ВыгрузкаРегламентированныхОтчетов.Основная КАК ВыгрузкаРегламентированныхОтчетов
	               |ГДЕ
	               |	ВыгрузкаРегламентированныхОтчетов.Основание.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	ДокументыВыгрузки = Запрос.Выполнить().Выгрузить();
	
	Если ДокументыВыгрузки.Количество() > 0 Тогда
		
		НачатьТранзакцию();
		
		Попытка
			
			Для Каждого ДокВыгрузки Из ДокументыВыгрузки Цикл
				
				ДокВыгрузки = ДокВыгрузки.Ссылка.ПолучитьОбъект();
				
				ДокВыгрузки.Заблокировать();
				
				Если ЭтотОбъект.ПометкаУдаления Тогда
					
					КоличествоДокВыгрузки = ДокВыгрузки.Основная.Количество();
					
					Если КоличествоДокВыгрузки > 1 Тогда
						
						Для НомерЭлемента = 1 По КоличествоДокВыгрузки Цикл
							
							Если ДокВыгрузки.Основная.Получить(КоличествоДокВыгрузки - НомерЭлемента).Основание.Ссылка = ЭтотОбъект.Ссылка Тогда
								ДокВыгрузки.Основная.Удалить(КоличествоДокВыгрузки - НомерЭлемента);
							КонецЕсли;
							
						КонецЦикла;
						
						ДокВыгрузки.Записать(РежимЗаписиДокумента.Запись);
						
					Иначе
						
						ДокВыгрузки.УстановитьПометкуУдаления(Истина);
						
					КонецЕсли;
					
				Иначе	
					
					ДокВыгрузки.УстановитьПометкуУдаления(Ложь);
					
					ДокВыгрузки.Записать(РежимЗаписиДокумента.Проведение);
					
				КонецЕсли;
				
				ДокВыгрузки.Разблокировать();
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если мЭтоНовый Тогда
		РегламентированнаяОтчетность.ОбработатьСобытие1СОтчетности(НСтр("ru = 'Регламентированный отчет. Создание';
																		|en = 'Регламентированный отчет. Создание'"), ЭтотОбъект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли