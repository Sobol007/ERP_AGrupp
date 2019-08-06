////////////////////////////////////////////////////////////////////////////////
// УправлениеВнеоборотнымиАктивами.
// Процедуры и функции для поддержки налоговой отчетности по ОС.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текстовое описание льготы по земельному налогу.
//
// Параметры:
//	Ссылка - Структура - Содержит ключи:
//		* НалоговаяЛьготаПоНалоговойБазе - ПеречислениеСсылка.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу - Вид налоговой льготы.
//
// Возвращаемое значение:
//	Строка - Строковое описание льготы.
//
Функция ПредставлениеНалоговойЛьготыПоЗемельномуНалогу(Ссылка) Экспорт
	
	ТекстНалоговойЛьготы = "";
	
	Если Ссылка.НалоговаяЛьготаПоНалоговойБазе = ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.ОсвобождениеОтНалогообложенияПоСтатье395") Тогда
		
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + НСтр("ru = 'Освобождение от налогообложения по ст. 395 НК РФ';
															|en = 'Taxation exemption in compliance with art.395 of the Tax Code of the Russian Federation'");
		
		Если НЕ ПустаяСтрока(Ссылка.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395) Тогда
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + " (" + Ссылка.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395 + ")";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Ссылка.НалоговаяЛьготаПоНалоговойБазе = ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.УменьшениеНалоговойБазы") Тогда
		
		Если Ссылка.УменьшениеНалоговойБазыПоСтатье391 Тогда
		
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
			                     + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			                     + НСтр("ru = 'Не облагаемая налогом сумма 10 000 руб., установленная ст. 391 НК РФ';
										|en = 'Amount of 10,000 rub. specified in art. 391 of the Tax Code of the Russian Federation is not subject to taxes '");
			
			Если НЕ ПустаяСтрока(Ссылка.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391) Тогда
				ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + " (" + Ссылка.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391 + ")";
			КонецЕсли;
			
		КонецЕсли;
		
		Если Ссылка.НеОблагаемаяНалогомСумма > 0 Тогда
			
			ТекстОписанияЛьготы =  НСтр("ru = 'Не облагаемая налогом сумма %1 руб., установленная местным нормативным актом';
										|en = 'Nontaxable amount of %1 rub. specified in the local standard regulation'");
			ТекстОписанияЛьготы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОписанияЛьготы, Ссылка.НеОблагаемаяНалогомСумма);
			
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
			                     + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			                     + ТекстОписанияЛьготы;
			
		КонецЕсли;
		
		
	КонецЕсли;
	
	Если Ссылка.НалоговаяЛьготаПоНалоговойБазе = ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.ОсвобождениеОтНалогообложенияМестное") Тогда
		
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
		                     + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
		                     + НСтр("ru = 'Освобождение от налогообложения, установленное местным нормативным актом';
									|en = 'Taxation exemption set by the local standard regulation'");
		
	КонецЕсли;
		
		
	Если Ссылка.НалоговаяЛьготаПоНалоговойБазе = ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.НеОблагаемаяНалогомПлощадь") Тогда
		
		ТекстОписанияЛьготы = НСтр("ru = 'Доля не облагаемой налогом площади %1/%2';
									|en = 'Share of the area not subject to tax %1/%2'");
		ТекстОписанияЛьготы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОписанияЛьготы, Ссылка.ДоляНеОблагаемойНалогомПлощадиЧислитель, Ссылка.ДоляНеОблагаемойНалогомПлощадиЗнаменатель);
		
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
		                     + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
		                     + ТекстОписанияЛьготы;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка.ПроцентУменьшенияСуммыНалога) Тогда
		
		ТекстОписанияЛьготы = НСтр("ru = 'Уменьшение суммы налога на %1';
									|en = 'Tax amount reduction in the amount of %1'");
		ТекстОписанияЛьготы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОписанияЛьготы, Строка(Ссылка.ПроцентУменьшенияСуммыНалога) + "%");
		
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
		                     + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
							 + ТекстОписанияЛьготы;
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Ссылка.СуммаУменьшенияСуммыНалога) Тогда
		
		ТекстОписанияЛьготы = НСтр("ru = 'Уменьшение суммы налога в размере %1 руб.';
									|en = 'Tax amount reduction in the amount of %1 rub.'");
		ТекстОписанияЛьготы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОписанияЛьготы, Ссылка.СуммаУменьшенияСуммыНалога);
		
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
		                     + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
							 + ТекстОписанияЛьготы;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка.СниженнаяНалоговаяСтавка) Тогда
		
		ТекстОписанияЛьготы = НСтр("ru = 'Снижение налоговой ставки до %1';
									|en = 'Reduce tax rate to %1'");
		ТекстОписанияЛьготы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОписанияЛьготы, Строка(Ссылка.СниженнаяНалоговаяСтавка) + "%");
		
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
		                     + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
		                     + ТекстОписанияЛьготы;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстНалоговойЛьготы) Тогда
		ТекстНалоговойЛьготы = НСтр("ru = 'Не применяется';
									|en = 'Not applied'");
	КонецЕсли;
	
	Возврат ТекстНалоговойЛьготы;
	
КонецФункции // ПредставлениеНалоговойЛьготыПоЗемельномуНалогу()

#КонецОбласти