
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеНалоговИВзносов") Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	Параметры.Свойство("ГоловнаяОрганизация", ГоловнаяОрганизация);
	
	Если ТолькоПросмотр Тогда
		СотрудникиКлиентСервер.УстановитьРежимТолькоПросмотрВФормеРедактированияИстории(ЭтотОбъект);
	КонецЕсли;
		
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	УпорядочитьНаборЗаписейВФорме(ЭтотОбъект);
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередНачаломИзменения(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередУдалением(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			
			Элемент.ТекущиеДанные.ФизическоеЛицо = ОбъектВладелец;
			Элемент.ТекущиеДанные.ГоловнаяОрганизация = ГоловнаяОрганизация;
			
			Если НаборЗаписей.Количество() > 1 Тогда
				Элемент.ТекущиеДанные.Год = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Год + 1;
			Иначе
				Элемент.ТекущиеДанные.Год = Год(ОбщегоНазначенияКлиент.ДатаСеанса());
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	УпорядочитьНаборЗаписейВФорме(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПараметрОповещения = Новый Структура("МассивЗаписей", НаборЗаписей);
	Оповестить("ОтредактированыРеквизитыУведомленияИФНСНаЗачетАвансовыхПлатежей", ПараметрОповещения, ОбъектВладелец);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УпорядочитьНаборЗаписейВФорме(Форма)
	
	Форма.НаборЗаписей.Сортировать("Год,ДатаУведомления");
	
КонецПроцедуры

&НаКлиенте
Функция ЗаблокироватьОбъектВФормеВладельце()
	
	Возврат СотрудникиКлиент.ЗаблокироватьОбъектВФормеВладельцеПриРедактированииИстории(ЭтотОбъект);
	
КонецФункции

#КонецОбласти
