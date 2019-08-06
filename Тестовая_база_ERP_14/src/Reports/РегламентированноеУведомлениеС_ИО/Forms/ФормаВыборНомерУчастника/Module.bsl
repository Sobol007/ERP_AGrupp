&НаКлиенте
Перем Оповещение Экспорт;

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("ЗначениеОбласти") Тогда
		ЗначениеОбласти = Параметры.ЗначениеОбласти;
	КонецЕсли;
	Если Параметры.Свойство("ИмяОбласти") Тогда
		ИмяОбласти = Параметры.ИмяОбласти;
	КонецЕсли;
	
	Тип = Лев(ЗначениеОбласти, 3);
	Если Тип = "ИО-" Тогда 
		РосИн = 1;
	ИначеЕсли Тип = "ИС-" Тогда 
		РосИн = 2;
	ИначеЕсли Тип = "РО-" Тогда 
		РосИн = 3;
	ИначеЕсли Тип = "ФЛ-" Тогда 
		РосИн = 4;
	КонецЕсли;
	
	ОписаниеТипов = Новый ОписаниеТипов("Число");
	Номер = ОписаниеТипов.ПривестиЗначение(Сред(ЗначениеОбласти, 4));
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОК(Команда)
	Если Номер = 0 Тогда 
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Необходимо указать номер участника";
		СообщениеПользователю.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если РосИн=1 Тогда
		Результат = "ИО-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=2 Тогда
		Результат = "ИС-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=3 Тогда
		Результат = "РО-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	ИначеЕсли РосИн=4 Тогда
		Результат = "ФЛ-" + Формат(Номер, "ЧЦ=5; ЧВН=; ЧГ=");
	КонецЕсли;
	Закрыть(Новый Структура("ИмяОбласти, Результат", ИмяОбласти, Результат));
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	Закрыть(Новый Структура("ИмяОбласти, Очистить", ИмяОбласти, 0));
КонецПроцедуры
