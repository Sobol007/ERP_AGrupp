
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВызватьИсключение НСтр("ru = 'Помощник настройки базовой версии предназначен только для первоначального заполнения информационной базы при первом запуске.';
							|en = 'Wizard of base version setting is only for initial infobase filling on the first start.'");
КонецПроцедуры

#КонецОбласти
