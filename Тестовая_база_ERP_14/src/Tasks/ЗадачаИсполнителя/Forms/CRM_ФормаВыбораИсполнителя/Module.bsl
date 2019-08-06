
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БизнесПроцесс = Параметры.БизнесПроцесс;
	Если Параметры.СписокТочекМаршрута.Количество() = 1 Тогда
		ТочкаМаршрута = Параметры.СписокТочекМаршрута[0].Значение;
	КонецЕсли;
	
	НаборИсполнителей = РегистрыСведений.CRM_ИсполнителиЭтаповБизнесПроцессов.СоздатьНаборЗаписей();
	НаборИсполнителей.Отбор.Объект.Установить(БизнесПроцесс);
	НаборИсполнителей.Прочитать();
	
	Для Каждого СтрокаНабора Из НаборИсполнителей Цикл
		Если (НЕ СтрокаНабора.Исполнитель = Перечисления.CRM_ВидыИсполнителейЗадач.НеУказан) Тогда
			Если (НЕ СтрокаНабора.Исполнитель = Перечисления.CRM_ВидыИсполнителейЗадач.Руководитель) Тогда
				Если (НЕ СтрокаНабора.Исполнитель = Перечисления.CRM_ВидыИсполнителейЗадач.ИсполнительПредыдущейЗадачи) Тогда
					Если (НЕ СтрокаНабора.Исполнитель = Перечисления.CRM_ВидыИсполнителейЗадач.ОсновнойМенеджер) Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ Параметры.СписокТочекМаршрута.НайтиПоЗначению(СтрокаНабора.ТочкаМаршрута) = Неопределено Тогда
			НоваяСтрока = табИсполнители.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаНабора);
			НоваяСтрока.Исполнитель = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
	Элементы.Панель.ТекущаяСтраница = ?((Параметры.СписокТочекМаршрута.Количество()>1)
	ИЛИ (табИсполнители.Количество()>1),Элементы.ИсполнителиСписком,Элементы.ОдинИсполнитель);
	Элементы.табИсполнители.ТекущаяСтрока = табИсполнители[0].ПолучитьИдентификатор();
	
	Если Элементы.Панель.ТекущаяСтраница = Элементы.ОдинИсполнитель Тогда
		Элементы.ИсполнителиСписком.Высота = 1;
	КонецЕсли;
	
	ТекстЗаголовка = ?((Параметры.СписокТочекМаршрута.Количество()>1)
	ИЛИ (табИсполнители.Количество()>1),"Укажите исполнителей для следующих этапов","Укажите исполнителя следующего этапа");
	
	Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Элементы.табИсполнители.ТекущиеДанные.Исполнитель = Значение;
	СохранитьНаборИсполнителей();
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормытабИсполнители

&НаКлиенте
Процедура табИсполнителиПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура табИсполнителиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если ПроверкаЗаполненияИсполнителей() Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьНаборИсполнителей();
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНаборИсполнителей()
	
	НаборИсполнителей = РегистрыСведений.CRM_ИсполнителиЭтаповБизнесПроцессов.СоздатьНаборЗаписей();
	
	Для Каждого СтрокаТаб Из табИсполнители Цикл
		НаборИсполнителей.Отбор.Сбросить();
		НаборИсполнителей.Отбор.Объект.Установить(БизнесПроцесс);
		НаборИсполнителей.Отбор.ТочкаМаршрута.Установить(СтрокаТаб.ТочкаМаршрута);
		НаборИсполнителей.Отбор.Исполнитель.Установить(Перечисления.CRM_ВидыИсполнителейЗадач.НеУказан);
		НаборИсполнителей.Прочитать();
		
		Если НаборИсполнителей.Количество() = 0 Тогда
			НаборИсполнителей.Отбор.Сбросить();
			НаборИсполнителей.Отбор.Объект.Установить(БизнесПроцесс);
			НаборИсполнителей.Отбор.ТочкаМаршрута.Установить(СтрокаТаб.ТочкаМаршрута);
			НаборИсполнителей.Отбор.Исполнитель.Установить(Перечисления.CRM_ВидыИсполнителейЗадач.Руководитель);
			НаборИсполнителей.Прочитать();
		КонецЕсли;
		
		Если НаборИсполнителей.Количество() = 0 Тогда
			НаборИсполнителей.Отбор.Сбросить();
			НаборИсполнителей.Отбор.Объект.Установить(БизнесПроцесс);
			НаборИсполнителей.Отбор.ТочкаМаршрута.Установить(СтрокаТаб.ТочкаМаршрута);
			НаборИсполнителей.Отбор.Исполнитель.Установить(Перечисления.CRM_ВидыИсполнителейЗадач.ИсполнительПредыдущейЗадачи);
			НаборИсполнителей.Прочитать();
		КонецЕсли;
		
		Если НаборИсполнителей.Количество() = 0 Тогда
			НаборИсполнителей.Отбор.Сбросить();
			НаборИсполнителей.Отбор.Объект.Установить(БизнесПроцесс);
			НаборИсполнителей.Отбор.ТочкаМаршрута.Установить(СтрокаТаб.ТочкаМаршрута);
			НаборИсполнителей.Отбор.Исполнитель.Установить(Перечисления.CRM_ВидыИсполнителейЗадач.ОсновнойМенеджер);
			НаборИсполнителей.Прочитать();
		КонецЕсли;
		
		НаборИсполнителей.Очистить();
		НаборИсполнителей.Записать();
		
		НоваяСтрокаРегистра = РегистрыСведений.CRM_ИсполнителиЭтаповБизнесПроцессов.СоздатьМенеджерЗаписи();
		НоваяСтрокаРегистра.Объект			= БизнесПроцесс;
		НоваяСтрокаРегистра.ТочкаМаршрута	= СтрокаТаб.ТочкаМаршрута;
		НоваяСтрокаРегистра.Исполнитель		= СтрокаТаб.Исполнитель;
		НоваяСтрокаРегистра.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаЗаполненияИсполнителей()
	
	Отказ = Ложь;
	Для Каждого СтрокаТаб Из табИсполнители Цикл
		Если СтрокаТаб.Исполнитель = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка") Тогда
			Отказ = Истина;
			ТекстСообщения = НСтр("ru='Не указан исполнитель для этапа: %ТочкаМаршрута%';en='The executor for a stage are not specif: %tochkamarshruta %'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТочкаМаршрута%", """"+СтрокаТаб.ТочкаМаршрута+"""");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Отказ;
	
КонецФункции

#КонецОбласти
