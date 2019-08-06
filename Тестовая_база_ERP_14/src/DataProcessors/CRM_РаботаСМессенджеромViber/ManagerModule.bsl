#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбязательныеМетодыПрограмногоИнтерфейса

Функция ПолучитьСообщения(УчетнаяЗапись) Экспорт
	
	СтруктураПараметровДоступа = CRM_РаботаСМессенджерамиСерверПовтИсп.СтруктураПараметровДоступа(УчетнаяЗапись);
	Если СтруктураПараметровДоступа=Неопределено Тогда Возврат Новый Массив; КонецЕсли;
	
	Соединение = Новый HTTPСоединение(СтруктураПараметровДоступа.АдресПубликации, СтруктураПараметровДоступа.Порт,,,,, Новый ЗащищенноеСоединениеOpenSSL());
    Запрос = Новый HTTPЗапрос(СтруктураПараметровДоступа.ЗапросПолученияСообщений);
 
    Результат = Соединение.Получить(Запрос);
	//СтруктураОтвета = CRM_СинхронизацияСервер.ЗначениеИзСтрокиJSON(Результат.ПолучитьТелоКакСтроку());
	//Если ТипЗнч(СтруктураОтвета) = Тип("Структура") Тогда
	//	Для Каждого ПолученноеСообщение Из СтруктураОтвета.data Цикл
	//		clid = ПолученноеСообщение.clid;
	//		Сообщить(ПолученноеСообщение.name + "   -   " + ПолученноеСообщение.message);
	//	КонецЦикла;	
	//КонецЕсли;
	
	МассивСообщений = Новый Массив;
	СтруктураОтвета=CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(Результат.ПолучитьТелоКакСтроку());
	Если ТипЗнч(СтруктураОтвета) = Тип("Структура") Тогда
		Если СтруктураОтвета.Свойство("error") Тогда
			ВызватьИсключение СтруктураОтвета.error.error_msg;
		Иначе
			Для Каждого ПолученноеСообщение Из СтруктураОтвета.data Цикл
				
				user_id = Строка(ПолученноеСообщение.clid);
				Сообщение = CRM_РаботаСМессенджерамиСервер.СтруктураСообщенияМесенджера();
				Сообщение.Дата = ТекущаяДатаСеанса();
				Сообщение.ТекстСообщения = ПолученноеСообщение.message;
				Сообщение.ВидСообщения = "Входящее";
				Сообщение.ID_Пользователя = user_id;
				Сообщение.КонтактПредставление = ПолученноеСообщение.name;

				Контакт = CRM_РаботаСМессенджерамиСерверПовтИсп.НайтиКонтактПоКонтактнойИнформации(user_id, УчетнаяЗапись, Перечисления.ТипыКонтактнойИнформации.ВебСтраница);
				Если ЗначениеЗаполнено(Контакт) Тогда
					Сообщение.Контакт = Контакт;
				КонецЕсли;
				МассивСообщений.Добавить(Сообщение);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Возврат МассивСообщений;
	
КонецФункции

Функция ОтправитьСообщение(Сообщение, УчетнаяЗапись, IDПользователя, СписокФайлов, ДопПараметры) Экспорт
	
	СтруктураПараметровДоступа = CRM_РаботаСМессенджерамиСерверПовтИсп.СтруктураПараметровДоступа(УчетнаяЗапись);
	
	
	Соединение = Новый HTTPСоединение(СтруктураПараметровДоступа.АдресПубликации, СтруктураПараметровДоступа.Порт,,,,, Новый ЗащищенноеСоединениеOpenSSL());
    Запрос = Новый HTTPЗапрос(СтруктураПараметровДоступа.ЗапросОтправкиСообщений+"?message="+КодироватьСтроку(Сообщение, СпособКодированияСтроки.КодировкаURL)+"&clid="+КодироватьСтроку(IDПользователя, СпособКодированияСтроки.КодировкаURL));
	Результат = Соединение.Получить(Запрос);
	
	СтруктураОтвета=CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(Результат.ПолучитьТелоКакСтроку());
	Если СтруктураОтвета.Свойство("error") Тогда
		ВызватьИсключение СтруктураОтвета.error.error_msg;
	Иначе
		Возврат Сообщение;
	КонецЕсли;
	
КонецФункции

Процедура ОжиданиеСобытий(УчетнаяЗапись) Экспорт
КонецПроцедуры

Функция ПолучитьВидКИМессенджера(Контакт) Экспорт
	
	Наименование = "Viber";
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВидыКонтактнойИнформации.Ссылка КАК Ссылка,
	                      |	ВидыКонтактнойИнформации.ПометкаУдаления КАК ПометкаУдаления
	                      |ИЗ
	                      |	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	                      |ГДЕ
	                      |	ВидыКонтактнойИнформации.Наименование = &Наименование
	                      |	И ВидыКонтактнойИнформации.Тип = &Тип
	                      |	И ВидыКонтактнойИнформации.Родитель = &Родитель");
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Партнеры") Тогда
		Родитель = Справочники.ВидыКонтактнойИнформации.CRM_СправочникПартнерыЧастноеЛицо;
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		Родитель = Справочники.ВидыКонтактнойИнформации.СправочникКонтактныеЛицаПартнеров;
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.CRM_ПотенциальныеКлиенты") Тогда
		Родитель = Справочники.ВидыКонтактнойИнформации.СправочникCRM_ПотенциальныеКлиенты;
	КонецЕсли;
	
	ТипКИ = ТипКИМессенджера();
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.УстановитьПараметр("Тип", ТипКИ);
	Запрос.УстановитьПараметр("Родитель", Родитель);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.ПометкаУдаления Тогда
			Выборка.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(Ложь);
		КонецЕсли;
		Возврат Выборка.Ссылка;
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		НовыйВидКИ = Справочники.ВидыКонтактнойИнформации.СоздатьЭлемент();
		НовыйВидКИ.Родитель = Родитель;
		НовыйВидКИ.Наименование = Наименование;
		НовыйВидКИ.Тип = ТипКИ;
		НовыйВидКИ.Используется = Истина;
		НовыйВидКИ.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		Возврат НовыйВидКИ.Ссылка;
	КонецЕсли;
	
КонецФункции

Функция ТипКИМессенджера() Экспорт
	
	Возврат Перечисления.ТипыКонтактнойИнформации.ВебСтраница;
	
КонецФункции

Функция НачалоАдресаСтраницыПользователя() Экспорт
	Возврат "";
КонецФункции

Функция ПутьКДиалогуВБраузере(Структура) Экспорт
	Возврат "";
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
