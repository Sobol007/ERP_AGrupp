
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	МассивИсключаемых = Справочники.CRM_УсловияСрабатыванияТриггеров.МассивИсключаемыхПоФОПредопределенных();
	Если МассивИсключаемых.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", МассивИсключаемых, ВидСравненияКомпоновкиДанных.НеВСписке,, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
