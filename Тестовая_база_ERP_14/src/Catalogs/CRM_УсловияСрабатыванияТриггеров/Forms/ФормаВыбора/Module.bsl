
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Отбор.Свойство("ОбъектДействия") Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	CRM_УсловияСрабатыванияТриггеров.Ссылка КАК Ссылка
		                      |ИЗ
		                      |	Справочник.CRM_УсловияСрабатыванияТриггеров.ОбъектыОбработки КАК CRM_УсловияСрабатыванияТриггеровОбъектыОбработки
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.CRM_УсловияСрабатыванияТриггеров КАК CRM_УсловияСрабатыванияТриггеров
		                      |		ПО CRM_УсловияСрабатыванияТриггеровОбъектыОбработки.Ссылка = CRM_УсловияСрабатыванияТриггеров.Ссылка
		                      |ГДЕ
		                      |	(CRM_УсловияСрабатыванияТриггеровОбъектыОбработки.ОбъектОбработки = &ОбъектОбработки
		                      |			ИЛИ CRM_УсловияСрабатыванияТриггеров.ОбъектДействия = &ОбъектОбработки)
		                      |	И НЕ CRM_УсловияСрабатыванияТриггеров.ПометкаУдаления");
		Запрос.УстановитьПараметр("ОбъектОбработки", Параметры.Отбор.ОбъектДействия);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка",
			Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"), ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
			
		СтандартнаяОбработка = Ложь;
	Иначе
		МассивИсключаемых = Справочники.CRM_УсловияСрабатыванияТриггеров.МассивИсключаемыхПоФОПредопределенных();
		Если МассивИсключаемых.Количество()>0 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", МассивИсключаемых, ВидСравненияКомпоновкиДанных.НеВСписке,, Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

