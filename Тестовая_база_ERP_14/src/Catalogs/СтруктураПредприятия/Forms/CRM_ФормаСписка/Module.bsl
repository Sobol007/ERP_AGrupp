
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	CRM_ОбщегоНазначенияСервер.ВыделитьЖирнымОсновнойЭлемент(Пользователи.ТекущийПользователь().Подразделение, Список, "ОсновноеПодразделение");
	
	// +CRM
	УстановитьПараметрыДинамическогоСписка();
	// -CRM	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// +CRM

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьПараметрыДинамическогоСписка();
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	МассивРезультатов = УстановитьПодразделениеПользователю(ПараметрыПеретаскивания.Значение, Строка, СтандартнаяОбработка);
	Для Каждого Пользователь Из МассивРезультатов Цикл
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Пользователю %1 установлено подразделение %2';en='The user %1 department %2 are install'"),
			Пользователь,
			Строка
		);
		ПоказатьОповещениеПользователя(
			НСтр("ru='Установлено подразделение';en='Department is installed'"),
			ПолучитьНавигационнуюСсылку(Пользователь),
			Текст,
			БиблиотекаКартинок.Информация32
		);
	КонецЦикла;
	
	Если МассивРезультатов.Количество() > 0 Тогда
		Элементы.СписокПользователей.Обновить();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// -CRM

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// +CRM

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция УстановитьПодразделениеПользователю(МассивПользователей, Подразделение, СтандартнаяОбработка)
	
	МассивРезультатов = Новый Массив;
	
	Для Каждого Пользователь Из МассивПользователей Цикл
	
		Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ТекущееПодразделение = Пользователь.Подразделение;
			Если ТекущееПодразделение <> Подразделение Тогда
				
				СправочникОбъект = Пользователь.ПолучитьОбъект();
				СправочникОбъект.Подразделение = Подразделение;
				
				Попытка
					НачатьТранзакцию();
					
					СправочникОбъект.Записать();
					
					//CRM_ОбщегоНазначенияСервер.УстановитьНастройкуПользователя(Подразделение, "ОсновноеПодразделение", Пользователь);
					ОбновитьПовторноИспользуемыеЗначения();
					
					МассивРезультатов.Добавить(Пользователь);
					
					ЗафиксироватьТранзакцию();
				Исключение
					ОтменитьТранзакцию();
					
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Пользователю %1 не удалось установить подразделение %2';en='The user %1 doing not manage to install department %2'"),
						Пользователь,
						Подразделение
					);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
				КонецПопытки
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивРезультатов;
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	Подразделения = Элементы.Список.ВыделенныеСтроки;
	Если Подразделения = Неопределено Тогда
		Подразделения = ПредопределенноеЗначение("Справочник.СтруктураПредприятия.ПустаяСсылка");
	КонецЕсли;
	
	СписокПользователей.Параметры.УстановитьЗначениеПараметра("Подразделение", Подразделения);
	
КонецПроцедуры

// -CRM

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ СОХРАНЕНИЯ НАСТРОЕК

&НаСервере
// Процедура сохраняет выбранный элемент в настройки.
//
Процедура УстановитьОсновнойЭлемент(ВыбранныйЭлемент, ИмяНастройки)
	
	Пользователь = Пользователи.ТекущийПользователь();
	Если ВыбранныйЭлемент <> Пользователь.Подразделение Тогда
		
		Успех = Истина;
		Попытка
			Пользователь = Пользователь.ПолучитьОбъект();
			Пользователь.Подразделение = ВыбранныйЭлемент;
			Пользователь.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Ошибка при установке основного подразделения.';en='An error occurred while installing the main unit.'"));
			Успех = Ложь;
		КонецПопытки;
		
		Если Успех Тогда
			CRM_ОбщегоНазначенияСервер.ВыделитьЖирнымОсновнойЭлемент(ВыбранныйЭлемент, Список, ИмяНастройки);
			УстановитьПараметрыДинамическогоСписка();
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик выполнения команды КомандаУстановитьОсновноеПодразделение.
//
Процедура КомандаУстановитьОсновноеПодразделение(Команда)
	
	ВыбранныйЭлемент = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
		УстановитьОсновнойЭлемент(ВыбранныйЭлемент, "ОсновноеПодразделение");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти