#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачалаСписания", ДатаНачалаСписания);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	УбыткиПрошлыхЛет.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.УбыткиПрошлыхЛет КАК УбыткиПрошлыхЛет
	               |ГДЕ
	               |	УбыткиПрошлыхЛет.ДатаНачалаСписания = &ДатаНачалаСписания
	               |	И УбыткиПрошлыхЛет.Ссылка <> &Ссылка";
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		ТекстОшибки = НСтр("ru = 'Для учета убытков за %1 год уже существует элемент справочника ""Убытки прошлых лет""';
							|en = 'To account losses for %1 year, use the ""Previous years losses"" catalog item'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки,Формат(Год(ДатаНачалаСписания)-1,"ЧГ=0")),
			ЭтотОбъект, 
			"ДатаНачалаСписания",
			,
			Отказ);
	КонецЕсли;	

	Если ВидРБП <> Перечисления.ВидыРБП.УбыткиПрошлыхЛет Тогда
		ВидРБП = Перечисления.ВидыРБП.УбыткиПрошлыхЛет;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
