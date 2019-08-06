////////////////////////////////////////////////////////////////////////////////
// Система сквозной аналитики (сервер)
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура Справочник_CRM_ИсточникиРекламныхКампаний_ФормаЭлемента_ПриСозданииНаСервере() Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.Справочник_CRM_ИсточникиРекламныхКампаний_ФормаЭлемента_ПриСозданииНаСервере();
КонецПроцедуры

Процедура Справочник_CRM_ИсточникиРекламныхКампаний_ФормаПомощникВвода_ПриСозданииНаСервере() Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.Справочник_CRM_ИсточникиРекламныхКампаний_ФормаПомощникВвода_ПриСозданииНаСервере();
КонецПроцедуры

Процедура Обработка_CRM_АРМ_РабочееМестоСквознаяАналитика_Форма_ПриСозданииНаСервере() Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.Обработка_CRM_АРМ_РабочееМестоСквознаяАналитика_Форма_ПриСозданииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПредопределенныеЭлементыИнтерваловВремени() Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.УстановитьПредопределенныеЭлементыИнтерваловВремени();
КонецПроцедуры

Процедура CRM_СозданиеРегЗаданияПоСценарию(Параметр1, Параметр2, АдресРасписания, Наименование, Сквозная, Дозагрузка) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.CRM_СозданиеРегЗаданияПоСценарию(Параметр1, Параметр2, АдресРасписания, Наименование, Сквозная, Дозагрузка);
КонецПроцедуры

Процедура ДозагрузитьДанныеПоАналитике(Параметр1, Параметр2, Параметр3) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.ДозагрузитьДанныеПоАналитике(Параметр1, Параметр2, Параметр3);
КонецПроцедуры

Процедура CRM_ПолучитьРегЗаданияПоСценарию(Источник, Сценарий, АдресРасписания, Дозагрузка) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.CRM_ПолучитьРегЗаданияПоСценарию(Источник, Сценарий, АдресРасписания, Дозагрузка);
КонецПроцедуры

Процедура CRM_ПолучитьРегЗаданияПоСценариюЛидогенерация(Ссылка, Источник, АдресРасписания) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.CRM_ПолучитьРегЗаданияПоСценариюЛидогенерация(Ссылка, Источник, АдресРасписания);
КонецПроцедуры

Процедура ВыполнитьРегламентоеЗадание(Параметр1 = Неопределено, Параметр2 = Неопределено) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.ВыполнитьРегламентоеЗадание(Параметр1, Параметр2);
КонецПроцедуры

Функция СлужебныйПользовательСервисовЛогин() Экспорт
	Возврат "httpService";
КонецФункции

Функция СлужебныйПользовательСервисовПароль() Экспорт
	Возврат "Rhp5931QwL";
КонецФункции

// Функция - Создать изменить служебного пользователя http-сервисов
//  Функция создает нового пользователя. Если пользователь уже создан, то изменяет настройки его аутентификации.
//
// Параметры:
//  Включить - Булево	 - Признак необходимости использования аутентификации.
// 
// Возвращаемое значение:
//  Булево - Результат выполнения функции. Истина, если пользователь создан или изменен.
//
Функция СоздатьИзменитьСлужебногоПользователяСервисов(Включить = Ложь) Экспорт
	
	Логин = СлужебныйПользовательСервисовЛогин();
	Пароль = СлужебныйПользовательСервисовПароль();
	
	УстановитьПривилегированныйРежим(Истина);
	ПользовательИзСправочника = сфпОбщегоНазначения.НайтиПользователяПоИмени(Логин);
	УстановитьПривилегированныйРежим(Ложь);
	
	Попытка
		Если ПользовательИзСправочника = Неопределено Тогда
			
			ИмяСобытия = "HTTP-сервисы.СозданиеСлужебногоПользователя";
			
			ОписаниеПользователяИБ = сфпОбщегоНазначения.НовоеОписаниеПользователяИБ();
			ОписаниеПользователяИБ.Имя = Логин;
			ОписаниеПользователяИБ.ПолноеИмя = НСтр("en='HTTP-service user telephony';ru='Служебный пользователь http-сервисов'");
			ОписаниеПользователяИБ.АутентификацияСтандартная = Включить;
			ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
			ОписаниеПользователяИБ.Вставить("Действие", "Записать");
			ОписаниеПользователяИБ.Вставить("ВходВПрограммуРазрешен", Истина);
			ОписаниеПользователяИБ.ЗапрещеноИзменятьПароль = Истина;
			ОписаниеПользователяИБ.Пароль = Пароль;
			ОписаниеПользователяИБ.Роли = Новый Массив;
			ОписаниеПользователяИБ.Роли.Добавить(Метаданные.Роли.ПолныеПрава.Имя);
			
			НовыйПользователь = Справочники.Пользователи.СоздатьЭлемент();
			НовыйПользователь.Наименование = ОписаниеПользователяИБ.ПолноеИмя;
			НовыйПользователь.Служебный = Истина;
			НовыйПользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
			НовыйПользователь.Записать();
			
		Иначе
			
			ИмяСобытия = "HTTP-сервисы.ИзменениеДоступаСлужебногоПользователя";
			ИзменитьДоступВБазу(Включить, Пароль, ПользовательИзСправочника);
			
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация, Метаданные.Справочники.Пользователи, ПользовательИзСправочника);
		Возврат Истина;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

Процедура ИзменитьДоступВБазу(Включить, Знач Пароль, Знач ПользовательИзСправочника)
	
	ОбновляемыеСвойства = Новый Структура;
	ОбновляемыеСвойства.Вставить("СтарыйПароль", Пароль);
	ОбновляемыеСвойства.Вставить("АутентификацияСтандартная", Включить);
	
	ОписаниеОшибки = "";
	ПользовательИБ = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	ПользовательЗаписан = сфпОбщегоНазначения.ЗаписатьПользователяИБ(
	//Пользователи.УстановитьСвойстваПользователяИБ(
		сфпОбщегоНазначения.сфпЗначениеРеквизитаОбъекта(ПользовательИзСправочника, "ИдентификаторПользователяИБ"),
		ОбновляемыеСвойства,
		Ложь,
		ОписаниеОшибки,
		ПользовательИзСправочника
	);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ПользовательЗаписан Тогда
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

#Область ЗагрузкаЛидогенерация

Процедура CRM_ЗагрузкаЛидогенерации(Параметр1, Параметр2) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.CRM_ЗагрузкаЛидогенерации(Параметр1, Параметр2);
КонецПроцедуры

#Область ЗагрузкаЛидогенерацияComagic

Процедура УстановитьСсылкуВИсточникПервичногоИнтересаЗаписатьДопРеквизит(Сделка, КаналПервичногоИнтереса, ИД, ИсточникПервичногоИнтереса) Экспорт
	
	//СтруктураДанных = Новый Структура("");
	//СтруктураДанных.Вставить("id", );
	//СтруктураДанных.Вставить("CRM_Сайт", );
	//СтруктураДанных.Вставить("ИсточникПолучения", );
	//СтруктураДанных.Вставить("КаналПервичногоИнтереса", );
	//СтруктураДанных.Вставить("ИсточникПервичногоИнтереса", );
	//СтруктураДанных.Вставить("CRM_UTM_source", );
	//СтруктураДанных.Вставить("CRM_UTM_medium", );
	//СтруктураДанных.Вставить("CRM_UTM_pos", );
	//");
	//
	//CRM_СистемаСквознойАналитикиЛицензированиеСервер.УстановитьСсылкуВИсточникПервичногоИнтересаЗаписатьДопРеквизит(Сделка, КаналПервичногоИнтереса, ИД, ИсточникПервичногоИнтереса);
	
КонецПроцедуры

Функция ПолучитьРекламнуюКампаниюПоИД(ИД,Наименование, КаналПривлечения) Экспорт 
	Возврат CRM_СистемаСквознойАналитикиЛицензированиеСервер.ПолучитьРекламнуюКампаниюПоИД(ИД,Наименование, КаналПривлечения);
КонецФункции

#КонецОбласти

#Область ЗагрузкаЛидогенерацияСallTouch

Процедура ВыполнитьЗагрузкуЗаявокИзСallTouch(Токен, IDСайта) Экспорт 
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.ВыполнитьЗагрузкуЗаявокИзСallTouch(Токен, IDСайта);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ДополнительныеДанные

Функция ПолучитьДанныеПоКаналамРекламныхВзаимодействий(Наименование) Экспорт
	Возврат CRM_СистемаСквознойАналитикиЛицензированиеСервер.ПолучитьДанныеПоКаналамРекламныхВзаимодействий(Наименование);
КонецФункции

Функция ПолучитьМаркетинговоеМероприятиеПоИД(ИД, ПВХ) Экспорт
	Возврат CRM_СистемаСквознойАналитикиЛицензированиеСервер.ПолучитьМаркетинговоеМероприятиеПоИД(ИД, ПВХ);
КонецФункции

#КонецОбласти

#Область ЗагрузкаЯндекс

Процедура ОбработкаТаблицыИтоговЗаписьВРегистрСведений(ИтоговаяТаблица, ДатаЗагрузки, Структура) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.ОбработкаТаблицыИтоговЗаписьВРегистрСведений(ИтоговаяТаблица, ДатаЗагрузки, Структура);
КонецПроцедуры

Функция ЗаписатьИнформациюПоСайтам(Структура) Экспорт
	Возврат CRM_СистемаСквознойАналитикиЛицензированиеСервер.ЗаписатьИнформациюПоСайтам(Структура);
КонецФункции

#КонецОбласти

#Область ЗагрузкаЯндексДиректа

Функция СформироватьСтрокуJSONИзСтруктуры(Объект) Экспорт
	Возврат CRM_СистемаСквознойАналитикиЛицензированиеСервер.СформироватьСтрокуJSONИзСтруктуры(Объект);
КонецФункции

Функция СформироватьСтрокуJSON(Объект) Экспорт
	Возврат CRM_СистемаСквознойАналитикиЛицензированиеСервер.СформироватьСтрокуJSON(Объект);
КонецФункции

Процедура ЗапросКода(УникальныйИдентификатор, СтруктураПараметров) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.ЗапросКода(УникальныйИдентификатор, СтруктураПараметров);
КонецПроцедуры

// Обменивает заранее полученный код авторизации на токен. Код авторизации нужно
// предварительно поместить в реквизит обработки КодАвторизации. Полученный токен 
// записывается в реквизит Токен. Требуется для работоспособности других методов.
//
Процедура ПолучитьТокен(СтруктураПараметров) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.ПолучитьТокен(СтруктураПараметров);
КонецПроцедуры

Процедура ЗагрузкаЗатрат(СтруктураПараметров) Экспорт
	CRM_СистемаСквознойАналитикиЛицензированиеСервер.ЗагрузкаЗатрат(СтруктураПараметров);
КонецПроцедуры

#КонецОбласти

#КонецОбласти