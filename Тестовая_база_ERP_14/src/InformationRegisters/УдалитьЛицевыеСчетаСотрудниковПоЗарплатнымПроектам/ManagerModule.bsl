#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ЗаполнитьЗарплатныйПроект() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
	|ГДЕ
	|	НЕ ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект = ЗНАЧЕНИЕ(Справочник.ЗарплатныеПроекты.ПустаяСсылка)";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		// Обновление уже выполнялось
		Возврат;
		
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация КАК Организация,
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Банк КАК Банк
	|ИЗ
	|	РегистрСведений.УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
	|
	|СГРУППИРОВАТЬ ПО
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация,
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Банк";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Организация") Цикл
		
		Пока Выборка.СледующийПоЗначениюПоля("Банк") Цикл
			
			ЗарплатныйПроект =
				ОбменСБанкамиПоЗарплатнымПроектам.ЗарплатныйПроектПоОрганизацииИБанку(
					Выборка.Организация,
					Выборка.Банк);
			
			Если НЕ ЗначениеЗаполнено(ЗарплатныйПроект) Тогда
				ЗарплатныйПроект =
					ОбменСБанкамиПоЗарплатнымПроектам.НовыйЗарплатныйПроектПоОрганизацииИБанку(
						Выборка.Организация,
						Выборка.Банк);
			КонецЕсли;
			
			// Создать набор записей
			НаборЗаписей = РегистрыСведений.УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СоздатьНаборЗаписей();
			
			НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
			НаборЗаписей.Отбор.Банк.Установить(Выборка.Банк);
			
			НаборЗаписей.Прочитать();
			
			Для каждого ЗаписьНабора Из НаборЗаписей Цикл
				
				ЗаписьНабора.ЗарплатныйПроект = ЗарплатныйПроект;
				
			КонецЦикла;
			
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.Записать();
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПериодРегистрации() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Сотрудники.Ссылка ЕСТЬ НЕ NULL 
	|			ТОГДА Сотрудники.Ссылка.МесяцОткрытия
	|		ИНАЧЕ ЛицевыеСчета.ЗарплатныйПроект.ДатаДоговора
	|	КОНЕЦ КАК Период,
	|	ЛицевыеСчета.Организация,
	|	ЛицевыеСчета.ФизическоеЛицо,
	|	ЛицевыеСчета.Банк,
	|	ЛицевыеСчета.НомерЛицевогоСчета,
	|	ЛицевыеСчета.ЗарплатныйПроект,
	|	Сотрудники.Ссылка КАК ДокументОснование
	|ИЗ
	|	РегистрСведений.УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Сотрудники КАК Сотрудники
	|		ПО ЛицевыеСчета.Организация = Сотрудники.Ссылка.Организация
	|			И ЛицевыеСчета.ЗарплатныйПроект = Сотрудники.Ссылка.ПервичныйДокумент.ЗарплатныйПроект
	|			И ЛицевыеСчета.ФизическоеЛицо = Сотрудники.ФизическоеЛицо
	|			И ЛицевыеСчета.НомерЛицевогоСчета = Сотрудники.НомерЛицевогоСчета
	|ГДЕ
	|	ЛицевыеСчета.ДокументОснование = ЗНАЧЕНИЕ(Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ПустаяСсылка)
	|	И ЛицевыеСчета.Период = ДАТАВРЕМЯ(1, 1, 1)
	|	И ВЫБОР
	|			КОГДА Сотрудники.Ссылка ЕСТЬ НЕ NULL 
	|				ТОГДА Сотрудники.Ссылка.МесяцОткрытия
	|			ИНАЧЕ ЛицевыеСчета.ЗарплатныйПроект.ДатаДоговора
	|		КОНЕЦ <> ДАТАВРЕМЯ(1, 1, 1)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СоздатьМенеджерЗаписи();
		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Период = Неопределено;
		МенеджерЗаписи.ДокументОснование = Неопределено;
		МенеджерЗаписи.Прочитать();
		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Записать(Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли