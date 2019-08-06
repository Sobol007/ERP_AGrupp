
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	КартаМаршрута = ?(ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Проекты"),КартаМаршрута(ПараметрКоманды),ПараметрКоманды);
	
	Если НЕ ЗначениеЗаполнено(КартаМаршрута) Тогда
		Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Проекты") Тогда
			Возврат;
		Иначе
			Если Найти(ПараметрыВыполненияКоманды.Источник.ИмяФормы,"ФормаСписка") > 0 Тогда
			Иначе
				ПоказатьПредупреждение(, Нстр("ru='Карта маршрута не записана.
				|Настройка этапов недоступна!'"));
			КонецЕсли;
			Возврат;
			
		КонецЕсли;
	Иначе
		Если Найти(ПараметрыВыполненияКоманды.Источник.ИмяФормы,"ФормаЭлемента") > 0
		И ПараметрыВыполненияКоманды.Источник.Модифицированность Тогда
			Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Проекты") Тогда
				ПоказатьПредупреждение(, Нстр("ru='Процесс не записан."
"Настройка этапов недоступна!';en='Process not recorded...'"));
			Иначе
				ПоказатьПредупреждение(, Нстр("ru='Карта маршрута не записана.
				|Настройка этапов недоступна!'"));
			КонецЕсли;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если КартаМаршрутаЭтоГруппа(КартаМаршрута) Тогда
		Возврат;
	КонецЕсли;
	
	Если  КартаМаршрутаРедактируется(КартаМаршрута) Тогда
		ПоказатьПредупреждение(, Нстр("ru='Карта маршрута находится в процессе редактирования.
								|Настройка этапов недоступна!'"));
		Возврат;
	КонецЕсли;		
	
	ПараметрыФормы = Новый Структура("Процесс", ПараметрКоманды);
	ОткрытьФорму("ОбщаяФорма.CRM_НастройкаЭтаповБизнесПроцессов", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник,ПараметрКоманды);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция КартаМаршрута(Проект)
	Возврат Проект.CRM_КартаМаршрута;
КонецФункции

&НаСервере
Функция КартаМаршрутаРедактируется(КартаМаршрута)
	Возврат (КартаМаршрута.Редактируется);
КонецФункции

&НаСервере
Функция КартаМаршрутаЭтоГруппа(КартаМаршрута)
	Возврат (КартаМаршрута.ЭтоГруппа);
КонецФункции

#КонецОбласти


