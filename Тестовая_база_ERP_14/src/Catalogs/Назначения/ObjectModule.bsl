#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоНовый() Тогда
		ДвиженияПоСкладскимРегистрам = Истина;
	КонецЕсли;
	
	КонтролироватьТолькоНаличие =
		НЕ Партнер.Пустая() И НЕ ЗначениеЗаполнено(Заказ)
		//++ НЕ УТКА
		ИЛИ ЗначениеЗаполнено(Заказ) И ТипЗнч(Заказ) = Тип("ДокументСсылка.ЗаказДавальца")
		//-- НЕ УТКА
		ИЛИ НЕ НаправлениеДеятельности.Пустая() И НЕ ЗначениеЗаполнено(Заказ)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НаправлениеДеятельности, "ДопускаетсяОбособлениеСверхПотребности");
	
	ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.СинхронизироватьКлючи(ЭтотОбъект);	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Копирование недоступно';
							|en = 'Copying is not available'");;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыСинхронизацииКлючей()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("Справочник.ВидыЗапасов", "ПометкаУдаления");
	Результат.Вставить("Справочник.КлючиАналитикиУчетаНоменклатуры", "ПометкаУдаления");
	//++ НЕ УТ
	Результат.Вставить("Справочник.ПартииПроизводства", "ПометкаУдаления");
	//-- НЕ УТ
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
