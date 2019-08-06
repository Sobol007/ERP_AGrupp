#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сертификат = Параметры.Сертификат;
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Результат = СервисКриптографии.ПолучитьНастройкиПолученияВременныхПаролей(Сертификат.Идентификатор);
	Телефон = Результат.Телефон;
	
	ПарольОтправлен = ПолучитьПарольНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПарольОтправлен Тогда	
		//ЗапуститьОбратныйОтсчет();
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.';
										|en = 'SMS service is temporarily unavailable. Try again later.'"));
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьПарольПовторно(Команда)

	Пароль = Неопределено;
	ЗапуститьОбратныйОтсчет();

	ПарольОтправлен = ПолучитьПарольНаСервере(Истина);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ОчиститьСообщения();
	ТекстОшибки = "";
	Пароль = СокрЛП(Пароль);
	Если ЗначениеЗаполнено(Пароль) И СтрДлина(Пароль) = 6 Тогда
		Попытка
			Результат = ПодтвердитьНаСервере();
			Если Не Результат.Выполнено Тогда
				Если Результат.КодОшибки = "КодНеверный" Тогда
					ТекстОшибки = Результат.ОписаниеОшибки;
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибки);
				КонецЕсли;
			Иначе			
				Закрыть(КодВозвратаДиалога.ОК);				
			КонецЕсли;
		Исключение
			ПоказатьПредупреждение(, НСтр("ru = 'Выполнение операции временно невозможно';
											|en = 'Operation temporarily cannot be executed'"));
		КонецПопытки;		
	ИначеЕсли ЗначениеЗаполнено(Пароль) И СтрДлина(Пароль) <> 6 Тогда
		ТекстОшибки = НСтр("ru = 'Пароль должен состоять из 6 цифр';
							|en = 'The password must contain 6 characters'");
	Иначе
		ТекстОшибки = НСтр("ru = 'Пароль не указан';
							|en = 'Password is not specified'");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПарольНаСервере(Повторно = Ложь)
		
	Результат = МенеджерСервисаКриптографии.НачатьИзменениеНастроекПолученияВременныхПаролей(
		Сертификат.Идентификатор, Параметры.Телефон, Параметры.ЭлектроннаяПочта);
		
	Если Результат.Выполнено Тогда
		ИдентификаторЗаявления = Результат.Идентификатор;
	КонецЕсли;

	Возврат Результат.Выполнено;
	
КонецФункции

&НаКлиенте
Процедура ЗапуститьОбратныйОтсчет()
	
	Таймер = 60;
	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОбратногоОтсчета()
	
	Таймер = Таймер - 1;
	Если Таймер >= 0 Тогда
		НадписьОбратногоОтсчета = СтрШаблон(НСтр("ru = 'Запросить пароль повторно можно будет через %1 сек.';
												|en = 'You can request the password again in %1 sec.'"), Таймер);
		ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);		
	Иначе
		НадписьОбратногоОтсчета = "";
		ПарольОтправлен = Ложь;		
		
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.НадписьОбратногоОтсчета.Видимость = Форма.ПарольОтправлен;	
	Элементы.ОтправитьПарольПовторно.Видимость = Не Форма.ПарольОтправлен;
	
КонецПроцедуры

&НаСервере
Функция ПодтвердитьНаСервере()
	
	Результат = МенеджерСервисаКриптографии.ЗавершитьИзменениеНастроекПолученияВременныхПаролей(
		ИдентификаторЗаявления, Пароль);

	Возврат Результат;
	
КонецФункции

#КонецОбласти