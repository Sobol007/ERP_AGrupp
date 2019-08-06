#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ИспользуютсяПодклассы Тогда
		
		Если РемонтныйЦикл.Количество()<>0 Тогда
			РемонтныйЦикл.Очистить();
		КонецЕсли;
		
		Если ПрочиеРемонты.Количество()<>0 Тогда
			ПрочиеРемонты.Очистить();
		КонецЕсли;
		
	КонецЕсли;
	
	СобственныйНаборСвойств = Истина;
	Если ЗначениеЗаполнено(НаборСвойств) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НаборСвойств", ЭтотОбъект.НаборСвойств);
		Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КлассыОбъектовЭксплуатации.Ссылка
		|ИЗ
		|	Справочник.КлассыОбъектовЭксплуатации КАК КлассыОбъектовЭксплуатации
		|ГДЕ
		|	КлассыОбъектовЭксплуатации.Ссылка <> &Ссылка
		|	И НЕ КлассыОбъектовЭксплуатации.ПометкаУдаления
		|	И КлассыОбъектовЭксплуатации.НаборСвойств = &НаборСвойств";
		СобственныйНаборСвойств = Запрос.Выполнить().Пустой();
	КонецЕсли;
	Если СобственныйНаборСвойств И ЗначениеЗаполнено(НаборСвойств) Тогда
		
		УправлениеСвойствами.ПередЗаписьюВидаОбъекта(
			ЭтотОбъект,
			?(ЭтоКлассУзла, "Справочник_УзлыОбъектовЭксплуатации", "Справочник_ОбъектыЭксплуатации"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНеПроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЭтоГруппа Тогда
		
		Если Не ИспользуютсяПодклассы Тогда
			
			// Проверка заполнения правил планирования
			Справочники.КлассыОбъектовЭксплуатации.ПроверкаЗаполненияПравилПланирования(ЭтотОбъект, МассивНеПроверяемыхРеквизитов, Отказ);
			
		КонецЕсли;
		
		МассивНеПроверяемыхРеквизитов.Добавить("ПоказателиНаработки.СреднесуточноеЗначение");
		МассивНеПроверяемыхРеквизитов.Добавить("ПоказателиНаработки.МинимальныйПериодРасчета");
		МассивНеПроверяемыхРеквизитов.Добавить("ПоказателиНаработки.МаксимальныйПериодРасчета");
		
		// Проверка заполнения показателей наработки
		Для ТекИндекс = 0 По ПоказателиНаработки.Количество()-1 Цикл
			
			Строка = ПоказателиНаработки[ТекИндекс];
			
			АдресОшибки = " " + НСтр("ru = 'в строке %НомерСтроки% списка ""Показатели наработки""';
									|en = 'in row %НомерСтроки% of the ""Running time values"" list'");
			АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", ПоказателиНаработки[ТекИндекс].НомерСтроки);
			
			Если Строка.ПересчитыватьСреднесуточноеЗначение Тогда
				
				Если Не ЗначениеЗаполнено(Строка.МинимальныйПериодРасчета) Тогда
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						НСтр("ru = 'Не заполнена колонка ""Минимальный период расчета""';
							|en = 'Fill in the ""Minimum calculation period"" column'") + АдресОшибки,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПоказателиНаработки", ПоказателиНаработки[ТекИндекс].НомерСтроки, "МинимальныйПериодРасчета"),
						,
						Отказ);
					
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(Строка.МаксимальныйПериодРасчета) Тогда
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						НСтр("ru = 'Не заполнена колонка ""Максимальный период расчета""';
							|en = 'Fill in the ""Maximum calculation period"" column'") + АдресОшибки,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПоказателиНаработки", ПоказателиНаработки[ТекИндекс].НомерСтроки, "МаксимальныйПериодРасчета"),
						,
						Отказ);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНеПроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
