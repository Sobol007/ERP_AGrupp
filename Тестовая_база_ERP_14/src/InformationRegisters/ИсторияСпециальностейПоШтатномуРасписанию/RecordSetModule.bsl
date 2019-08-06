#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТекущийНабор",	ЭтотОбъект);
	Запрос.УстановитьПараметр("Регистратор",	ЭтотОбъект.Отбор.Регистратор.Значение);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущийНабор.ПозицияШтатногоРасписания
	|ПОМЕСТИТЬ ВТТекущийНабор
	|ИЗ
	|	&ТекущийНабор КАК ТекущийНабор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсторияСпециальностейПоШтатномуРасписанию.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания
	|ПОМЕСТИТЬ ВТОбщийНабор
	|ИЗ
	|	РегистрСведений.ИсторияСпециальностейПоШтатномуРасписанию КАК ИсторияСпециальностейПоШтатномуРасписанию
	|ГДЕ
	|	ИсторияСпециальностейПоШтатномуРасписанию.Регистратор = &Регистратор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТекущийНабор.ПозицияШтатногоРасписания
	|ИЗ
	|	ВТТекущийНабор КАК ТекущийНабор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОбщийНабор.ПозицияШтатногоРасписания
	|ИЗ
	|	ВТОбщийНабор КАК ОбщийНабор";
	
	МассивОбновляемыхПозиций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПозицияШтатногоРасписания");
	
	ЭтотОбъект.ДополнительныеСвойства.Вставить("МассивОбновляемыхПозиций", МассивОбновляемыхПозиций);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтотОбъект.ДополнительныеСвойства.Свойство("МассивОбновляемыхПозиций")
		Или ЭтотОбъект.ДополнительныеСвойства.МассивОбновляемыхПозиций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("СписокПозицийШтатногоРасписания", ЭтотОбъект.ДополнительныеСвойства.МассивОбновляемыхПозиций);
	Запрос.УстановитьПараметр("Регистратор",	ЭтотОбъект.Отбор.Регистратор.Значение);
	ЭтоПроведение = ?(ЭтотОбъект.Количество() = 0, Ложь, Истина);
	ТипДокумента = ТипЗнч(ЭтотОбъект.Отбор.Регистратор.Значение);
	Запрос.Текст = "";
	
	Если ЭтоПроведение Тогда
		
		Если ТипДокумента = Тип("ДокументСсылка.УтверждениеШтатногоРасписания") Тогда
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	УтверждениеШтатногоРасписанияПозиции.Позиция КАК ПозицияШтатногоРасписания,
			|	УтверждениеШтатногоРасписанияПозиции.Ссылка.МесяцВступленияВСилу КАК Дата
			|ПОМЕСТИТЬ ВТОбщийНабор
			|ИЗ
			|	Документ.УтверждениеШтатногоРасписания.Позиции КАК УтверждениеШтатногоРасписанияПозиции
			|ГДЕ
			|	УтверждениеШтатногоРасписанияПозиции.Ссылка = &Регистратор";
			
		ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ИзменениеШтатногоРасписания") Тогда
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ИзменениеШтатногоРасписанияПозиции.Позиция КАК ПозицияШтатногоРасписания,
			|	ИзменениеШтатногоРасписанияПозиции.Ссылка.ДатаВступленияВСилу КАК Дата
			|ПОМЕСТИТЬ ВТОбщийНабор
			|ИЗ
			|	Документ.ИзменениеШтатногоРасписания.Позиции КАК ИзменениеШтатногоРасписанияПозиции
			|ГДЕ
			|	ИзменениеШтатногоРасписанияПозиции.Ссылка = &Регистратор";
			
		Иначе
			
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЗНАЧЕНИЕ(Справочник.ШтатноеРасписание.ПустаяСсылка) КАК ПозицияШтатногоРасписания,
			|	ДАТАВРЕМЯ(1, 1, 1) КАК Дата
			|ПОМЕСТИТЬ ВТОбщийНабор";
			
		КонецЕсли;
		
		Запрос.Текст = 	Запрос.Текст + " ОБЪЕДИНИТЬ ВСЕ ";
	
	КонецЕсли;

	Запрос.Текст = 	Запрос.Текст
		+ 	"ВЫБРАТЬ
		|	ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания,
		|	МАКСИМУМ(ИсторияИспользованияШтатногоРасписания.Дата) КАК Дата 
		| " + ?(ЭтоПроведение, "", " ПОМЕСТИТЬ ВТОбщийНабор ") + "
		|ИЗ
		|	РегистрСведений.ИсторияИспользованияШтатногоРасписания КАК ИсторияИспользованияШтатногоРасписания
		|ГДЕ
		|	ИсторияИспользованияШтатногоРасписания.Используется
		|	И ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания В(&СписокПозицийШтатногоРасписания) 
		| " + ?(ЭтоПроведение, "", " И ИсторияИспользованияШтатногоРасписания.Регистратор <> &Регистратор ") + "
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбщийНабор.ПозицияШтатногоРасписания,
		|	МАКСИМУМ(ОбщийНабор.Дата) КАК Дата
		|ПОМЕСТИТЬ ВТПоследниеДатыИспользованияПозиций
		|ИЗ
		|	ВТОбщийНабор КАК ОбщийНабор
		|
		|СГРУППИРОВАТЬ ПО
		|	ОбщийНабор.ПозицияШтатногоРасписания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоследниеДатыИспользованияПозиций.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания,
		|	ИсторияСпециальностейПоШтатномуРасписанию.Специальность КАК Специальность
		|ИЗ
		|	ВТПоследниеДатыИспользованияПозиций КАК ПоследниеДатыИспользованияПозиций
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСпециальностейПоШтатномуРасписанию КАК ИсторияСпециальностейПоШтатномуРасписанию
		|		ПО ПоследниеДатыИспользованияПозиций.ПозицияШтатногоРасписания = ИсторияСпециальностейПоШтатномуРасписанию.ПозицияШтатногоРасписания
		|			И ПоследниеДатыИспользованияПозиций.Дата = ИсторияСпециальностейПоШтатномуРасписанию.Дата
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПозицияШтатногоРасписания,
		|	Специальность";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ПозицияШтатногоРасписания") Цикл
		ПозицияОбъект = Выборка.ПозицияШтатногоРасписания.ПолучитьОбъект();
		ПозицияОбъект.Специальности.Очистить();
		
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ПозицияОбъект.Специальности.Добавить(), Выборка);
		КонецЦикла;
		
		УправлениеШтатнымРасписанием.ОтключитьОбновлениеСтруктурыШтатногоРасписания(ПозицияОбъект);
		
		ПозицияОбъект.Записать();
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
