////////////////////////////////////////////////////////////////////////////////
// УправлениеШтатнымРасписаниемКлиентСервер:
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеРеквизитовПроверяемыхНаСоответствие() Экспорт
	
	Возврат Новый Структура("СтруктураПоиска,РеквизитНесоответствияСтроки,РасшифровкаНачислений,ОписаниеСоответствияПоказателей,МаксимальноеКоличествоПоказателей")
	
КонецФункции

Функция ОписаниеТаблицыПозиций() Экспорт
	
	ОписаниеТаблицы = Новый Структура(
		"ИмяТаблицы,
		|ИмяРеквизитаПозиция,
		|ПутьКДанным");
	ОписаниеТаблицы.ИмяТаблицы = "Позиции";
	ОписаниеТаблицы.ИмяРеквизитаПозиция = "Позиция";
	ОписаниеТаблицы.ПутьКДанным = "Объект.Позиции";
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

Функция ПолучитьКомментарийКДействиюСПозициейШР(СтрокаПозицииШР, Форма)Экспорт	
	
	КомментарийНачисления = "";
	СтрокаПодстановки = "";
	
	Если Форма.ДоступноЧтениеНачисленийШтатногоРасписания Тогда
		Если Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьВилкуСтавокВШтатномРасписании") Тогда
			ФОТПозиции = СтрокаПозицииШР.ФОТМакс;
		Иначе
			ФОТПозиции = СтрокаПозицииШР.ФОТ;
		КонецЕсли;
		Если ФОТПозиции > СтрокаПозицииШР.ТекущийФОТ Тогда
			КомментарийНачисления = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'увеличен ФОТ (+%1)';
																								|en = 'salary budget is increased (+%1)'"), ФОТПозиции - СтрокаПозицииШР.ТекущийФОТ);
			СтрокаПодстановки = ", " + КомментарийНачисления;
		ИначеЕсли ФОТПозиции < СтрокаПозицииШР.ТекущийФОТ Тогда
			КомментарийНачисления = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'уменьшен ФОТ (%1)';
																								|en = 'salary budget is reduced (%1)'"), ФОТПозиции - СтрокаПозицииШР.ТекущийФОТ);	
			СтрокаПодстановки = ", " + КомментарийНачисления;	
		КонецЕсли;	
	КонецЕсли; 
	
	Если СтрокаПозицииШР.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.СоздатьНовуюПозицию") Тогда
		Возврат НСтр("ru = 'Новая позиция';
					|en = 'New position'");		
	ИначеЕсли СтрокаПозицииШР.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ЗакрытьПозицию") Тогда	
		Возврат НСтр("ru = 'Позиция закрыта';
					|en = 'The position is closed'");		
	ИначеЕсли СтрокаПозицииШР.ТекущееКоличествоСтавок > СтрокаПозицииШР.КоличествоСтавок Тогда 
		Возврат	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'уменьшено количество штатных единиц (%1)%2';
																				|en = 'number of FTE is reduced (%1)%2'"), Формат(СтрокаПозицииШР.КоличествоСтавок - СтрокаПозицииШР.ТекущееКоличествоСтавок, ""), СтрокаПодстановки); 
	ИначеЕсли СтрокаПозицииШР.ТекущееКоличествоСтавок < СтрокаПозицииШР.КоличествоСтавок Тогда  
		Возврат	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'увеличено количество штатных единиц (+%1)%2';
																				|en = 'number of FTE (+%1)%2 is increased'"), Формат(СтрокаПозицииШР.КоличествоСтавок - СтрокаПозицииШР.ТекущееКоличествоСтавок, ""), СтрокаПодстановки); 	
	ИначеЕсли Форма.ДоступноЧтениеНачисленийШтатногоРасписания И ФОТПозиции <> СтрокаПозицииШР.ТекущийФОТ Тогда 
		Возврат КомментарийНачисления;	
	Иначе 
		Возврат "";
	КонецЕсли;	
	
КонецФункции	

Функция СтруктураДанныхОЗанятыхПозициях(ДатаСеанса) Экспорт
	
	СтруктураДанных = Новый Структура;
	
	СтруктураДанных.Вставить("Период", ДатаСеанса);
	СтруктураДанных.Вставить("ПозицияШтатногоРасписания", ПредопределенноеЗначение("Справочник.ШтатноеРасписание.ПустаяСсылка"));
	СтруктураДанных.Вставить("Сотрудник", ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка"));
	СтруктураДанных.Вставить("КоличествоСтавок", 0);
	СтруктураДанных.Вставить("ДанныеОНачислениях", Новый Массив);
	СтруктураДанных.Вставить("ФОТ", 0);
	СтруктураДанных.Вставить("Грейд");
		
	Возврат СтруктураДанных;
		
КонецФункции

Процедура УстановитьКомментарииДействийСНачислением(СтрокаНачисления, МаксимальноеКоличествоПоказателей, ИспользоватьВилкуСтавокВШтатномРасписании) Экспорт
	
	Если СтрокаНачисления.Действие = ПредопределенноеЗначение("Перечисление.ДействияСНачислениямиИУдержаниями.Утвердить") И (Не СтрокаНачисления.ДействующийВидРасчета) Тогда
		СтрокаНачисления.Комментарий = НСтр("ru = 'Новое начисление';
											|en = 'New accrual'");
	ИначеЕсли СтрокаНачисления.Действие = ПредопределенноеЗначение("Перечисление.ДействияСНачислениямиИУдержаниями.Отменить") Тогда
		СтрокаНачисления.Комментарий = НСтр("ru = 'Начисление отменено';
											|en = 'Accrual is canceled'");	
	ИначеЕсли Не СтрокаНачисления.ДействующийВидРасчета Тогда
		СтрокаНачисления.Комментарий = НСтр("ru = 'Новое начисление';
											|en = 'New accrual'");	
	Иначе
		Комментарий = "";
		Для Сч = 1 По МаксимальноеКоличествоПоказателей Цикл
			
			Если СтрокаНачисления.Свойство("ТекущееМинимальноеЗначение" + Сч) Тогда
				
				ТекущееЗначение = ?(СтрокаНачисления["ТекущееМинимальноеЗначение" + Сч] = Неопределено, 0, СтрокаНачисления["ТекущееМинимальноеЗначение" + Сч]);
				Значение = ?(СтрокаНачисления["МинимальноеЗначение" + Сч] = Неопределено, 0, СтрокаНачисления["МинимальноеЗначение" + Сч]); 
				Если Значение > ТекущееЗначение  Тогда
					Комментарий = Комментарий + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Увеличен минимум';
																											|en = 'Increased minimum'") + " %1 (+%2); ", 
					СтрокаНачисления["Показатель" + Сч],  Значение - ТекущееЗначение);
				ИначеЕсли  Значение < ТекущееЗначение Тогда
					Комментарий = Комментарий + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Уменьшен минимум';
																											|en = 'Reduced minimum'") + " %1 (%2); ", 
					СтрокаНачисления["Показатель" + Сч],  Значение - ТекущееЗначение);
				КонецЕсли;
				
				ТекущееЗначение = ?(СтрокаНачисления["ТекущееМаксимальноеЗначение" + Сч] = Неопределено, 0, СтрокаНачисления["ТекущееМаксимальноеЗначение" + Сч]);
				Значение = ?(СтрокаНачисления["МаксимальноеЗначение" + Сч] = Неопределено, 0, СтрокаНачисления["МаксимальноеЗначение" + Сч]); 
				Если Значение > ТекущееЗначение Тогда
					Комментарий = Комментарий + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Увеличен максимум';
																											|en = 'Increased maximum'") + " %1 (+%2); ", 
					СтрокаНачисления["Показатель" + Сч],  Значение - ТекущееЗначение);
				ИначеЕсли  Значение < ТекущееЗначение Тогда
					Комментарий = Комментарий + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Уменьшен максимум';
																											|en = 'Reduced maximum'") + " %1 (%2); ", 
					СтрокаНачисления["Показатель" + Сч],  Значение - ТекущееЗначение);
				КонецЕсли;
				
			Иначе
				
				ТекущееЗначение = ?(СтрокаНачисления["ТекущееЗначение" + Сч] = Неопределено, 0, СтрокаНачисления["ТекущееЗначение" + Сч]);
				Значение = ?(СтрокаНачисления["Значение" + Сч] = Неопределено, 0, СтрокаНачисления["Значение" + Сч]); 
				Если Значение > ТекущееЗначение Тогда
					Комментарий = Комментарий + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Увеличен';
																											|en = 'Increased'") + " %1 (+%2); ", 
					СтрокаНачисления["Показатель" + Сч],  Значение - ТекущееЗначение);
				ИначеЕсли  Значение < ТекущееЗначение Тогда
					Комментарий = Комментарий + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Уменьшен';
																											|en = 'Reduced'") + " %1 (%2); ", 
					СтрокаНачисления["Показатель" + Сч],  Значение - ТекущееЗначение);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		СтрокаНачисления.Комментарий = Комментарий;
		
	КонецЕсли;
	
КонецПроцедуры	

Функция ПредставлениеНадбавкиЗаВредность(НачислениеНадбавкаЗаВредность) Экспорт
	
	ПредставлениеНадбавкиЗаВредность = Строка(НачислениеНадбавкаЗаВредность);
	Если ПустаяСтрока(ПредставлениеНадбавкиЗаВредность) Тогда
		ПредставлениеНадбавкиЗаВредность = НСтр("ru = 'Надбавка за вредность';
												|en = 'Hazard pay'");
	КонецЕсли; 
	
	Возврат ПредставлениеНадбавкиЗаВредность;
	
КонецФункции

Функция ПредставлениеРайонногоКоэффициента(НачислениеРайонныйКоэффициент, РайонныйКоэффициент) Экспорт
	
	РайонныйКоэффициентПредставление = Строка(НачислениеРайонныйКоэффициент);
	Если ПустаяСтрока(РайонныйКоэффициентПредставление) Тогда
		РайонныйКоэффициентПредставление = НСтр("ru = 'Районный коэффициент';
												|en = 'Regional factor'");
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(РайонныйКоэффициент) Тогда
		РайонныйКоэффициентПредставление = РайонныйКоэффициентПредставление + " (" + Формат(РайонныйКоэффициент, "ЧЦ=4; ЧДЦ=3") + ")";
	КонецЕсли;
		
	Возврат РайонныйКоэффициентПредставление;
	
КонецФункции

Функция ПредставлениеСевернойНадбавки(НачислениеСевернаяНадбавка, ПроцентСевернойНадбавки) Экспорт
	
	СевернаяНадбавкаПредставление = Строка(НачислениеСевернаяНадбавка);
	Если ПустаяСтрока(СевернаяНадбавкаПредставление) Тогда
		СевернаяНадбавкаПредставление = НСтр("ru = 'Северная надбавка';
											|en = 'Northern allowance'");
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ПроцентСевернойНадбавки) Тогда
		СевернаяНадбавкаПредставление = СевернаяНадбавкаПредставление + " (" + Формат(ПроцентСевернойНадбавки, "ЧЦ=5; ЧДЦ=2; ЧН=") + "%)";
	Иначе
		СевернаяНадбавкаПредставление = СевернаяНадбавкаПредставление + " (" + НСтр("ru = 'не задан';
																					|en = 'not specified'") + ")";
	КонецЕсли;
		
	Возврат СевернаяНадбавкаПредставление;
	
КонецФункции

Функция НаименованиеПозицииШтатногоРасписания(Подразделение, Должность, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтандартнаяОбработка = Истина;
	НаименованиеПозиции = "";
	
	Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("ОрганизационнаяСтруктураКлиентСервер");
		Модуль.СформироватьНаименованиеПозицииШтатногоРасписания(
			НаименованиеПозиции, Должность, ДополнительныеПараметры, СтандартнаяОбработка);
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		
		РазрядКатегория = Неопределено;
		Если ДополнительныеПараметры <> Неопределено Тогда
			ДополнительныеПараметры.Свойство("РазрядКатегория", РазрядКатегория);
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(РазрядКатегория) Тогда
			НаименованиеПозиции = Строка(Должность) + ", " + Строка(РазрядКатегория);
		Иначе
			НаименованиеПозиции = Строка(Должность);
		КонецЕсли;
		
		НаименованиеПозиции = НаименованиеПозиции + ?(ЗначениеЗаполнено(Подразделение), " /" + Строка(Подразделение) + "/", "");
		
	КонецЕсли;
	
	Возврат НаименованиеПозиции;
	
КонецФункции

Процедура ЗаполнитьИтоговыйФОТПоПозициям(Форма, Позиции) Экспорт
	
	Для каждого СтрокаПозиции Из Позиции Цикл
		РассчитатьИтогиФОТПоСтрокеПозиции(Форма, СтрокаПозиции);
	КонецЦикла;
	
КонецПроцедуры

Процедура РассчитатьИтогиФОТПоСтрокеПозиции(Форма, СтрокаПозиции) Экспорт
	
	Если Форма.ДоступноЧтениеНачисленийШтатногоРасписания Тогда
		СтрокаПозиции.ФОТПоПозиции = СтрокаПозиции.ФОТ * СтрокаПозиции.КоличествоСтавок;
		СтрокаПозиции.ФОТПоПозицииМин = СтрокаПозиции.ФОТМин * СтрокаПозиции.КоличествоСтавок;
		СтрокаПозиции.ФОТПоПозицииМакс = СтрокаПозиции.ФОТМакс * СтрокаПозиции.КоличествоСтавок;
	КонецЕсли; 
	
КонецПроцедуры

Процедура УстановитьВидимостьКомандыИзменитьНачисленияСотрудников(Форма) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаОтразитьВКадровомУчете",
		"Видимость",
		НЕ Форма.ВнешниеДанные И Форма.ИзмененыНачисления И НЕ Форма.СозданиеНовой);
	
КонецПроцедуры
	
Функция ДатаСобытия(Форма, ДатаСеанса) Экспорт
	
	Если Форма.ВнешниеДанные Тогда
		ДатаСобытия = Форма.Объект.ДатаУтверждения;
	Иначе
		
		ДатаСобытия = ДатаСеанса;
		Если Форма.Объект.ДатаУтверждения >= ДатаСобытия Тогда
			ДатаСобытия = Форма.Объект.ДатаУтверждения;
		КонецЕсли; 
	
	КонецЕсли;
	
	Возврат ДатаСобытия;
	
КонецФункции

#КонецОбласти
