#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Попытка
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			ВызватьИсключение НСтр("ru = 'Недостаточно прав для завершения сеанса!';
									|en = 'Insufficient rights to end session. '");
		КонецЕсли;
		
		Если ТипЗнч(Параметры.НомераСеансов) = Тип("Массив") Тогда
			НомераСеансов.ЗагрузитьЗначения(Параметры.НомераСеансов);
		КонецЕсли;
		
		ПерейтиКШагуМастера(1);
		
	Исключение
		
		ОбработатьИсключение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция НачатьЗавершениеСеансов()
	
	Если ПустаяСтрока(Пароль) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указан пароль для доступа к сервису!';
				|en = 'Password for access to the service is not specified.'"), ,
			"Пароль"
		);
		
		Возврат Ложь;
		
	Иначе
		
		Попытка
			
			НачатьЗавершениеСеансовНаСервере();
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеФоновогоЗадания", 5, Истина);
			
			Возврат Истина;
			
		Исключение
			
			ОбработатьИсключение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			Возврат Ложь;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура НачатьЗавершениеСеансовНаСервере()
	
	ПараметрыЗадания = Новый Массив();
	ПараметрыЗадания.Добавить(НомераСеансов.ВыгрузитьЗначения());
	ПараметрыЗадания.Добавить(Пароль);
	
	Задание = ФоновыеЗадания.Выполнить(
		"УдаленноеАдминистрированиеБТССлужебный.ЗавершитьСеансыОбластиДанных",
		ПараметрыЗадания,
		,
		НСтр("ru = 'Завершение активного сеанса';
			|en = 'End active session'")
	);
	
	ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеФоновогоЗадания()
	
	Попытка
		
		Если ФоновоеЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			
			Закрыть(КодВозвратаДиалога.ОК);
			
		Иначе
			
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
			
		КонецЕсли;
		
	Исключение
		
		ОбработатьИсключение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФоновоеЗаданиеВыполнено(ИдентификаторЗадания)
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		
		ВызватьИсключение НСтр("ru = 'Фоновое задание не найдено!';
								|en = 'Background job is not found.'");
		
	Иначе
		
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			
			ВызватьИсключение КраткоеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
			
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			
			ВызватьИсключение НСтр("ru = 'Фоновое задание отменено администратором!';
									|en = 'Background job is canceled by administrator'");
			
		Иначе
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура Далее(Команда)
	
	Если ВыполнитьОбработчикПереходаМеждуШагами(ОбработчикПереходаСТекущегоШага) Тогда
		ПерейтиКШагуМастера(ТекущийШаг + 1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьОбработчикПереходаМеждуШагами(Знач Обработчик)
	
	Результат = Ложь;
	
	Если ЗначениеЗаполнено(Обработчик) Тогда
		
		Попытка
			
			Если Обработчик = "НачатьЗавершениеСеансов" Тогда
				Результат = НачатьЗавершениеСеансов();
			КонецЕсли;
			
		Исключение
			
			ОбработатьИсключение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбработатьИсключение(Знач ТекстИсключения)
	
	ТекстОшибки = ТекстИсключения;
	ПерейтиКШагуМастера(3);
	
КонецПроцедуры

&НаСервере
Функция ПерейтиКШагуМастера(Знач Шаг)
	
	Сценарий = СценарийМастера();
	
	ОписаниеШага = Сценарий.Найти(Шаг, "НомерШага");
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы[ОписаниеШага.Страница];
	Элементы.ГруппаКомандыСтраницы.ТекущаяСтраница = Элементы[ОписаниеШага.СтраницаКоманд];
	
	ОбработчикПереходаСТекущегоШага = ОписаниеШага.Обработчик;
	ТекущийШаг = Шаг;
	
КонецФункции

&НаСервере
Функция СценарийМастера()
	
	Результат = Новый ТаблицаЗначений();
	
	Результат.Колонки.Добавить("НомерШага", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("Страница", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("СтраницаКоманд", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Обработчик", Новый ОписаниеТипов("Строка"));
	
	// Ввод пароля
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 1;
	НоваяСтрока.Страница = Элементы.СтраницаВводПароля.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыВводПароля.Имя;
	НоваяСтрока.Обработчик = "НачатьЗавершениеСеансов";
	
	// Ожидание завершения
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 2;
	НоваяСтрока.Страница = Элементы.СтраницаОжидание.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыОжидание.Имя;
	
	// Просмотр ошибки
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 3;
	НоваяСтрока.Страница = Элементы.СтраницаОшибка.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыОшибка.Имя;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти


