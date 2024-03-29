#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") Тогда
			Если ДанныеЗаполнения.Действие = "Заполнить" Тогда
				ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ИсходнаяДатаНачала, "Объект.ИсходнаяДатаНачала", Отказ, НСтр("ru = 'Дата начала отпуска';
																												|en = 'Leave start date '"), , , Ложь);
	
	Документы.ПереносОтпуска.ПроверитьРаботающих(ЭтотОбъект, Отказ);
	
	Если ЗначениеЗаполнено(ИсходнаяДатаНачала) И ЗначениеЗаполнено(Сотрудник) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлановыеЕжегодныеОтпуска.Сотрудник,
		|	ПлановыеЕжегодныеОтпуска.ДатаНачала,
		|	ПлановыеЕжегодныеОтпуска.Перенесен
		|ИЗ
		|	РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
		|ГДЕ
		|	ПлановыеЕжегодныеОтпуска.Сотрудник = &Сотрудник
		|	И ПлановыеЕжегодныеОтпуска.ДатаНачала = &ДатаНачала";
		Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
		Запрос.УстановитьПараметр("ДатаНачала", ИсходнаяДатаНачала);
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Если Результат.Пустой() Тогда
			ТекстСообщения = НСтр("ru = 'Отпуск с %1 не был запланирован в графике отпусков.';
									|en = 'Leave from %1 was not scheduled in the leave schedule.'"); 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(ИсходнаяДатаНачала,"ДЛФ=D"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ИсходнаяДатаНачала",, Отказ);
		Иначе
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ОтменитьПеренос();
	ЗарегистрироватьПеренос();
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ОтменитьПеренос();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения)
	
	Если ЭтоНовый() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		Дата = ТекущаяДатаСеанса();
		
		ДанныеЗаполнения.Свойство("Руководитель", Руководитель);
		ДанныеЗаполнения.Свойство("ДолжностьРуководителя", ДолжностьРуководителя);
		
		ЗапрашиваемыеЗначения = Новый Структура;
		ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
		ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
		
		Если ЗначениеЗаполнено(Организация) И Не ЗначениеЗаполнено(Руководитель) Тогда
			ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
			ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
		КонецЕсли;
			
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтменитьПеренос()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДокументПереноса", Ссылка);

	Запрос.Текст = "ВЫБРАТЬ
	               |	ПлановыеЕжегодныеОтпуска.Организация КАК Организация,
	               |	ПлановыеЕжегодныеОтпуска.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ПлановыеЕжегодныеОтпуска.Сотрудник КАК Сотрудник,
	               |	ПлановыеЕжегодныеОтпуска.ДатаНачала КАК ДатаНачала,
	               |	ДАТАВРЕМЯ(1, 1, 1) КАК ПеренесеннаяДатаНачала,
	               |	ПлановыеЕжегодныеОтпуска.Запланирован КАК Запланирован,
	               |	ЛОЖЬ КАК Перенесен,
	               |	ПлановыеЕжегодныеОтпуска.ДокументПланирования КАК ДокументПланирования,
	               |	ПлановыеЕжегодныеОтпуска.КоличествоДней КАК КоличествоДней,
	               |	ПлановыеЕжегодныеОтпуска.ВидОтпуска КАК ВидОтпуска,
	               |	ПлановыеЕжегодныеОтпуска.ДатаОкончания КАК ДатаОкончания,
	               |	ЗНАЧЕНИЕ(Документ.ПереносОтпуска.ПустаяСсылка) КАК ДокументПереноса,
	               |	ПлановыеЕжегодныеОтпуска.Примечание КАК Примечание
	               |ИЗ
	               |	РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
	               |ГДЕ
	               |	ПлановыеЕжегодныеОтпуска.ДокументПереноса = &ДокументПереноса";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		
		НаборЗаписей = РегистрыСведений.ПлановыеЕжегодныеОтпуска.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Сотрудник.Установить(Выборка.Сотрудник);
		НаборЗаписей.Отбор.ДатаНачала.Установить(Выборка.ДатаНачала);
		
		НоваяСтрока = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьПеренос()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПлановыеЕжегодныеОтпуска.Организация КАК Организация,
	               |	ПлановыеЕжегодныеОтпуска.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ПлановыеЕжегодныеОтпуска.Сотрудник КАК Сотрудник,
	               |	ПлановыеЕжегодныеОтпуска.ДатаНачала КАК ДатаНачала,
	               |	ПереносОтпускаПереносы.ДатаНачала КАК ПеренесеннаяДатаНачала,
	               |	ПлановыеЕжегодныеОтпуска.Запланирован КАК Запланирован,
	               |	ИСТИНА КАК Перенесен,
	               |	ПлановыеЕжегодныеОтпуска.ДокументПланирования КАК ДокументПланирования,
	               |	ПлановыеЕжегодныеОтпуска.КоличествоДней КАК КоличествоДней,
	               |	ПлановыеЕжегодныеОтпуска.ВидОтпуска КАК ВидОтпуска,
	               |	ПлановыеЕжегодныеОтпуска.ДатаОкончания КАК ДатаОкончания,
	               |	ПереносОтпускаПереносы.Ссылка КАК ДокументПереноса,
	               |	ПлановыеЕжегодныеОтпуска.Примечание КАК Примечание
	               |ИЗ
	               |	Документ.ПереносОтпуска КАК ПереносОтпуска
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
	               |		ПО ПереносОтпуска.Сотрудник = ПлановыеЕжегодныеОтпуска.Сотрудник
	               |			И ПереносОтпуска.ИсходнаяДатаНачала = ПлановыеЕжегодныеОтпуска.ДатаНачала
	               |			И (ПереносОтпуска.Ссылка = &Ссылка)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПереносОтпуска.Переносы КАК ПереносОтпускаПереносы
	               |		ПО ПереносОтпуска.Ссылка = ПереносОтпускаПереносы.Ссылка
	               |			И (ПереносОтпуска.Ссылка = &Ссылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ПлановыеЕжегодныеОтпуска.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Сотрудник.Установить(Сотрудник);
	НаборЗаписей.Отбор.ДатаНачала.Установить(ИсходнаяДатаНачала);
	
	Пока Выборка.Следующий() Цикл 
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
