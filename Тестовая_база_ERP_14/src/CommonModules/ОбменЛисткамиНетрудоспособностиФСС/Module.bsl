#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает пространство имен пакета XDTO для обмена ЭЛН с ФСС.
//
// Возвращаемое значение:
//   Строка - Пространство имен пакета XDTO для обмена ЭЛН с ФСС.
//
Функция ПространствоИмен() Экспорт
	Возврат "http://ru/ibs/fss/ln/ws/FileOperationsLn.wsdl";
КонецФункции

// Возвращает версию формата обмена ЭЛН с ФСС.
//
// Возвращаемое значение:
//   Строка - Версия формата обмена ЭЛН с ФСС.
//
Функция Версия() Экспорт
	Возврат "1.1";
КонецФункции

// Преобразует строку XML (полученную из текста элемента или значения атрибута XML) в значение указанного типа.
//
// Параметры:
//   * СтрокаXML - Строка, Неопределено - Строка, полученная из XML.
//   * Тип - Тип - Тип ожидаемого значения.
//
// Возвращаемое значение:
//   Произвольный - В соответствии с указанным типом.
//       Если параметр "СтрокаXML" не заполнен, то значение параметра СтрокаXML возвращается без приведения к типу.
//       Например, если передать Неопределено, то на выходе тоже будет Неопределено.
//
Функция ЗначениеИзСтрокиXMLПоТипу(СтрокаXML, Тип) Экспорт
	Если Тип <> Тип("Строка") И ТипЗнч(СтрокаXML) = Тип("Строка") И Не ПустаяСтрока(СтрокаXML) Тогда
		Возврат XMLЗначение(Тип, СтрокаXML);
	Иначе
		Возврат СтрокаXML;
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодготовкаНешифрованногоЗапроса

// Формирует параметры получения электронного листка нетрудоспособности.
//
// Параметры:
//   БольничныйЛист - ДокументОбъект.БольничныйЛист, ДанныеФормыСтруктура - Больничный.
//
// Возвращаемое значение:
//   Структура - Результат выгрузки в XML.
//       * Организация - СправочникСсылка.Организации - Организация, для которой получается ЭЛН.
//       * РегистрационныйНомерФСС - Строка - Рег. номер организации, для которой получается ЭЛН.
//       * ТекстXML - Строка - Сведения, необходимые для получения ЭЛН в формате XML.
//
Функция ВыгрузитьЗапросДляПолученияЭЛН(БольничныйЛист) Экспорт
	Отказ = Ложь;
	ДанныеБольничного = ДанныеБольничногоДляПолученияЭЛН(БольничныйЛист, Отказ);
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПакетXDTO = ФабрикаXDTO.Пакеты.Получить(ПространствоИмен());
	getPrivateLNData = ФабрикаXDTO.Создать(ПакетXDTO.КорневыеСвойства.Получить("getPrivateLNData").Тип);
	
	getPrivateLNData.lnCode = ДанныеБольничного.НомерЛисткаНетрудоспособности;
	getPrivateLNData.regNum = ДанныеБольничного.РегистрационныйНомерДляОбменаФСС;
	getPrivateLNData.snils  = ДанныеБольничного.СНИЛС;
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, getPrivateLNData, "getPrivateLNData");
	
	Результат = Новый Структура("Организация, РегистрационныйНомерФСС, ТекстXML");
	Результат.Организация             = БольничныйЛист.Организация;
	Результат.РегистрационныйНомерФСС = ДанныеБольничного.РегистрационныйНомерДляОбменаФСС;
	Результат.ТекстXML                = ЗаписьXML.Закрыть();
	
	Возврат Результат;
КонецФункции

// Формирует параметры отправки реестра электронных листков нетрудоспособности.
//
// Параметры:
//   Документ - ДокументОбъект.РеестрДанныхЭЛНЗаполняемыхРаботодателем, ДанныеФормыСтруктура - Реестр.
//   ПомещатьВФайл - Булево - Истина, если результат надо поместить в файл и вернуть адрес во временном хранилище.
//   ИдентификаторФормы - УникальныйИдентификатор - Идентификатор формы. Обязательный, если ПомещатьВФайл = Истина.
//
// Возвращаемое значение:
//   Структура - Результат выгрузки в XML.
//       * Организация - СправочникСсылка.Организации - Организация, для которой отправляется реестр ЭЛН.
//       * РегистрационныйНомерФСС - Строка - Рег. номер организации, для которой отправляется реестр ЭЛН.
//       * ТекстXML - Строка - Данные реестра в формате XML (электронное представление),
//                             либо пустая строка если ПомещатьВФайл = Истина.
//       * Адрес - Строка - Адрес временного хранилища, по которому размещены двоичные данные файла реестра в формате XML,
//                          либо пустая строка если ПомещатьВФайл = Ложь.
//
Функция ВыгрузитьЗапросДляОтправкиРеестраЭЛН(Документ, ПомещатьВФайл, ИдентификаторФормы) Экспорт
	РегистрационныйНомерДляОбменаФСС = УчетПособийСоциальногоСтрахованияКлиентСервер.РегистрационныйНомерДляОбменаФСС(Документ);
	
	ПакетXDTO = ФабрикаXDTO.Пакеты.Получить(ПространствоИмен());
	
	prParseReestrFile = ФабрикаXDTO.Создать(ПакетXDTO.КорневыеСвойства.Получить("prParseReestrFile").Тип);
	
	request = ФабрикаXDTO.Создать(prParseReestrFile.Свойства().Получить("request").Тип);
	request.regNum = РегистрационныйНомерДляОбменаФСС;
	
	pXmlFile = ФабрикаXDTO.Создать(request.Свойства().Получить("pXmlFile").Тип);
	ROWSET   = ФабрикаXDTO.Создать(pXmlFile.Свойства().Получить("ROWSET").Тип);
	
	ТипROW = ROWSET.Свойства().Получить("ROW").Тип;
	
	ROWSET.version          = Версия();
	ROWSET.software         = Лев("1С:" + Метаданные.Синоним, 80);
	ROWSET.version_software = Лев(Метаданные.Версия, 15);
	
	ROWSET.author = Строка(Документ.РеестрСоставил);
	ROWSET.phone  = Строка(Документ.ТелефонСоставителя);
	ROWSET.email  = Строка(Документ.АдресЭлектроннойПочтыСоставителя);
	
	ФИО = Новый Структура("Руководитель, ГлавныйБухгалтер", Документ.Руководитель, Документ.ГлавныйБухгалтер);
	ЗаполнитьПолныеФИО(ФИО);
	
	Для Каждого ДанныеЛН Из Документ.ДанныеЭЛН Цикл
		
		ROW = ROWSET.ROW.Добавить(ФабрикаXDTO.Создать(ТипROW));
		
		УстановитьЗначениеЕслиЗаполнено(ROW.LN_CODE,    ДанныеЛН.НомерЛисткаНетрудоспособности);
		УстановитьЗначениеЕслиЗаполнено(ROW.SNILS,      СтрЗаменить(СтрЗаменить(ДанныеЛН.СНИЛС, "-","")," ",""));
		УстановитьЗначениеЕслиЗаполнено(ROW.INN_PERSON, ДанныеЛН.ИНН);
		УстановитьЗначениеЕслиЗаполнено(ROW.EMPLOYER,   Строка(Документ.Организация));
		
		ROW.EMPL_FLAG = ?(ДанныеЛН.ВидЗанятости = Перечисления.ВидыЗанятости.ОсновноеМестоРаботы, 1 ,0);
		
		УстановитьЗначениеЕслиЗаполнено(ROW.EMPL_REG_NO,        Документ.РегистрационныйНомерФСС);
		УстановитьЗначениеЕслиЗаполнено(ROW.EMPL_PARENT_NO,     Документ.КодПодчиненностиФСС);
		УстановитьЗначениеЕслиЗаполнено(ROW.EMPL_REG_NO2,       Документ.ДополнительныйКодФСС);
		УстановитьЗначениеЕслиЗаполнено(ROW.APPROVE1,           ФИО.Руководитель);
		УстановитьЗначениеЕслиЗаполнено(ROW.APPROVE2,           ФИО.ГлавныйБухгалтер);
		УстановитьЗначениеЕслиЗаполнено(ROW.BASE_AVG_SAL,       ДанныеЛН.БазаДляРасчетаСреднегоЗаработка);
		УстановитьЗначениеЕслиЗаполнено(ROW.BASE_AVG_DAILY_SAL, ДанныеЛН.СреднийДневнойЗаработок);
		
		Если ДанныеЛН.СтажЛет <> 0 Или ДанныеЛН.СтажМесяцев <> 0 Тогда
			ROW.INSUR_YY = ДанныеЛН.СтажЛет;
			ROW.INSUR_MM = ДанныеЛН.СтажМесяцев;
		КонецЕсли;
		
		РазностьСтажей = УчетПособийСоциальногоСтрахования.ПодсчитатьРазностьСтажейВГодахИМесяцах(
			ДанныеЛН.СтажРасширенныйЛет,
			ДанныеЛН.СтажРасширенныйМесяцев,
			ДанныеЛН.СтажЛет,
			ДанныеЛН.СтажМесяцев);
		Если РазностьСтажей.РазностьЛет <> 0 Или РазностьСтажей.РазностьМесяцев <> 0 Тогда
			ROW.NOT_INSUR_YY = РазностьСтажей.РазностьЛет;
			ROW.NOT_INSUR_MM = РазностьСтажей.РазностьМесяцев;
		КонецЕсли;
		
		УстановитьЗначениеЕслиЗаполнено(ROW.CALC_CONDITION1,  ДанныеЛН.УсловияИсчисленияКод1);
		УстановитьЗначениеЕслиЗаполнено(ROW.CALC_CONDITION2,  ДанныеЛН.УсловияИсчисленияКод2);
		УстановитьЗначениеЕслиЗаполнено(ROW.CALC_CONDITION3,  ДанныеЛН.УсловияИсчисленияКод3);
		УстановитьЗначениеЕслиЗаполнено(ROW.FORM1_DT,         ДанныеЛН.ДатаАктаН1);
		УстановитьЗначениеЕслиЗаполнено(ROW.RETURN_DATE_EMPL, ДанныеЛН.ДатаНачалаРаботы);
		УстановитьЗначениеЕслиЗаполнено(ROW.DT1_LN,           ДанныеЛН.ДатаНачалаОплаты);
		УстановитьЗначениеЕслиЗаполнено(ROW.DT2_LN,           ДанныеЛН.ДатаОкончанияОплаты);
		
		ROW.EMPL_PAYMENT = ДанныеЛН.СуммаОплатыЗаСчетРаботодателя;
		ROW.FSS_PAYMENT  = ДанныеЛН.СуммаОплатыЗаСчетФСС;
		ROW.PAYMENT      = ДанныеЛН.СуммаОплатыЗаСчетРаботодателя + ДанныеЛН.СуммаОплатыЗаСчетФСС;
		
		Если ДанныеЛН.Исправление Тогда
			УстановитьЗначениеЕслиЗаполнено(ROW.CORRECTION_REASON, ДанныеЛН.КодПричиныИсправления);
			УстановитьЗначениеЕслиЗаполнено(ROW.CORRECTION_NOTE,   СокрЛП(ДанныеЛН.ОписаниеПричиныИсправления));
		КонецЕсли;
		
		УстановитьЗначениеЕслиЗаполнено(ROW.LN_HASH, РегистрыСведений.ХэшиЭЛН.ПрочитатьХэш(ДанныеЛН.НомерЛисткаНетрудоспособности));
		
	КонецЦикла;
	
	prParseReestrFile.request = request;
	request.pXmlFile = pXmlFile;
	pXmlFile.ROWSET = ROWSET;
	
	ЗаписьXML = Новый ЗаписьXML;
	Если ПомещатьВФайл Тогда
		ПолноеИмяФайла = ПолучитьИмяВременногоФайла("xml");
		ЗаписьXML.ОткрытьФайл(ПолноеИмяФайла, "UTF-8");
	Иначе
		ЗаписьXML.УстановитьСтроку("UTF-8");
	КонецЕсли;
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ROWSET, "ROWSET");
	
	Результат = Новый Структура("Организация, РегистрационныйНомерФСС, ТекстXML, Адрес");
	Результат.Организация             = Документ.Организация;
	Результат.РегистрационныйНомерФСС = РегистрационныйНомерДляОбменаФСС;
	Результат.ТекстXML                = ЗаписьXML.Закрыть();
	
	Если ПомещатьВФайл Тогда
		ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
		Результат.Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ИдентификаторФормы);
		ОбщегоНазначения.УдалитьВременныйКаталог(ПолноеИмяФайла);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ДанныеБольничногоДляПолученияЭЛН(БольничныйЛист, Отказ)
	Результат = Новый Структура("НомерЛисткаНетрудоспособности, РегистрационныйНомерДляОбменаФСС, СНИЛС");
	
	// Номер больничного листа.
	Результат.НомерЛисткаНетрудоспособности = БольничныйЛист.НомерЛисткаНетрудоспособности;
	
	// Регистрационный номер ФСС организации (страхователя).
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(БольничныйЛист.Организация, "РегистрационныйНомерФСС, ДополнительныйКодФСС");
	Результат.РегистрационныйНомерДляОбменаФСС = УчетПособийСоциальногоСтрахованияКлиентСервер.РегистрационныйНомерДляОбменаФСС(РеквизитыОрганизации);
	
	// СНИЛС сотрудника на которого оформлен листок нетрудоспособности.
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, БольничныйЛист.Сотрудник, "СтраховойНомерПФР");
	Если КадровыеДанные.Количество() > 0 Тогда
		Результат.СНИЛС = СтрЗаменить(СтрЗаменить(КадровыеДанные[0].СтраховойНомерПФР, "-", ""), " ", "");
	КонецЕсли;
	
	// Проверка результатов.
	Если Не ЗначениеЗаполнено(Результат.НомерЛисткаНетрудоспособности) Тогда
		Текст = НСтр("ru = 'Не заполнен номер листка нетрудоспособности';
					|en = 'Sick leave record No. is not filled in'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "НомерЛисткаНетрудоспособности", "Объект", Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Результат.РегистрационныйНомерДляОбменаФСС) Тогда
		Текст = НСтр("ru = 'У организации не заполнен регистрационный номер ФСС';
					|en = 'Company SSF registration number is required'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Организация", "Объект", Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Результат.СНИЛС) Тогда
		Текст = НСтр("ru = 'У сотрудника не указан СНИЛС';
					|en = 'IIAN is not specified for the employee'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Сотрудник", "Объект", Отказ);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Получает полные ФИО физических лиц.
//
// Параметры:
//   СтруктураФИО - Структура - По указанным ключам структуры будут размещены полные ФИО.
//       * Ключ - Строка - Имя ключа, по которому будет размещено полное ФИО.
//       * Значение - СправочникСсылка.ФизическиеЛица - Ссылка физ. лица, для которого требуется получить ФИО.
//           После выполнения процедуры превращается в тип "Строка".
//
Процедура ЗаполнитьПолныеФИО(СтруктураФИО)
	МассивФизическихЛиц = Новый Массив;
	Для Каждого КлючИЗначение Из СтруктураФИО Цикл
		МассивФизическихЛиц.Добавить(КлючИЗначение.Значение);
	КонецЦикла;
	
	ТаблицаКадровыхДанных = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, МассивФизическихЛиц, "ФИОПолные");
	
	Для Каждого КлючИЗначение Из СтруктураФИО Цикл
		КадровыеДанныеФизическогоЛица = ТаблицаКадровыхДанных.Найти(КлючИЗначение.Значение, "ФизическоеЛицо");
		Если КадровыеДанныеФизическогоЛица <> Неопределено Тогда
			ФИО = КадровыеДанныеФизическогоЛица.ФИОПолные;
		ИначеЕсли ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			ФИО = Строка(КлючИЗначение.Значение);
		Иначе
			ФИО = "";
		КонецЕсли;
		СтруктураФИО.Вставить(КлючИЗначение.Ключ, ФИО);
	КонецЦикла;
КонецПроцедуры

Процедура УстановитьЗначениеЕслиЗаполнено(ИзменяемоеЗначение, Значение)
	Если ЗначениеЗаполнено(Значение) Тогда
		ИзменяемоеЗначение = Значение;
	КонецЕсли;
КонецПроцедуры

Функция КодыПричинИсправления(Список = Неопределено) Экспорт
	Если ТипЗнч(Список) <> Тип("СписокЗначений") Тогда
		Список = Новый СписокЗначений;
	КонецЕсли;
	
	Список.Добавить("01", НСтр("ru = 'Работником представлены дополнительные сведения для расчета';
								|en = 'Employee has provided additional information for calculation'"));
	Список.Добавить("02", НСтр("ru = 'Работником представлено свидетельство ИНН';
								|en = 'Employee gave the TIN certificate'"));
	Список.Добавить("03", НСтр("ru = 'Изменены регистрационные данные работодателя/сведения о должностных лицах работодателя';
								|en = 'Employer''s registration data/information on employer''s officials was changed'"));
	Список.Добавить("04", НСтр("ru = 'Уточнены условия труда работника/условия исчисления пособия (включая Акт ф. Н-1)';
								|en = 'Employee working conditions/allowance calculation conditions are specified (including certificate N-1 from)'"));
	Список.Добавить("05", НСтр("ru = 'Выявлены ошибки в расчете пособия/подсчете страхового стажа';
								|en = 'Allowance/pensionable service calculation errors are detected'"));
	Список.Добавить("06", НСтр("ru = 'Ошибка оператора';
								|en = 'Provider error'"));
	
	Для Каждого Элемент Из Список Цикл
		Элемент.Представление = Элемент.Значение + ". " + Элемент.Представление;
	КонецЦикла;
	
	Возврат Список;
КонецФункции

#КонецОбласти

#Область ЧтениеРасшифрованногоОтвета

Функция ЗагрузитьОтветСервисаФСС(Документ, Операция, АдресРасшифрованногоОтвета) Экспорт
	Результат = Новый Структура("БольничныеТребующиеАктуализацииХэша, Отказ");
	Результат.БольничныеТребующиеАктуализацииХэша = Новый Массив;
	Результат.Отказ = Ложь;
	
	WSResult = ПрочитатьФайлXML(АдресРасшифрованногоОтвета, Операция);
	
	ТекстСообщенияФСС = "";
	Если WSResult.Свойства().Получить("MESS") <> Неопределено Тогда
		ТекстСообщенияФСС = Строка(WSResult.MESS);
		Если Не ПустаяСтрока(ТекстСообщенияФСС) Тогда
			ТекстСообщенияФСС = НСтр("ru = 'При обмене с ФСС возникли ошибки. Ответ ФСС:';
									|en = 'Errors occurred when exchanging with SSF. SSF response:'") + Символы.ПС + ТекстСообщенияФСС;
		КонецЕсли;
	КонецЕсли;
	
	Если Операция = "getPrivateLNData" Тогда
		Если Строка(WSResult.STATUS) = "1" Тогда
			ЗагрузитьРезультатПолученияЭЛН(Документ, WSResult, Результат.Отказ);
		Иначе
			ЗарплатаКадрыОтображениеОшибок.СообщитьОбОшибке(Результат.Отказ, ТекстСообщенияФСС, "");
		КонецЕсли;
	ИначеЕсли Операция = "prParseReestrFile" Тогда
		ЗагрузитьРезультатОтправкиРеестраЭЛН(Документ, WSResult, Результат, ТекстСообщенияФСС);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ЗагрузитьЭЛНИзФайла(Документ, Операция, АдресДвоичныхДанных) Экспорт
	WSResult = ПрочитатьФайлXML(АдресДвоичныхДанных, Операция);
	
	Если Операция = "getPrivateLNData" Тогда
		Отказ = Ложь;
		ЗаполнитьСотрудникаИНомерЭЛН(Документ, WSResult, Отказ);
		Если Не Отказ Тогда
			ЗагрузитьРезультатПолученияЭЛН(Документ, WSResult, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Процедура ЗагрузитьРезультатПолученияЭЛН(Документ, WSResult, Отказ)
	ДанныеЛН = КоллекцияОбъектовXDTO(WSResult.DATA.OUT_ROWSET.ROW)[0];
	ЗагрузитьХэшЭЛН(ДанныеЛН);
	Если ТипЗнч(Документ) = Тип("Структура") Тогда
		Возврат; // Метод вызван только для получения Хэша ЭЛН.
	КонецЕсли;
	ПроверитьРезультатПолученияЭЛН(Документ, ДанныеЛН, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьДанныеЭЛН(Документ, ДанныеЛН);
КонецПроцедуры

Процедура ЗагрузитьХэшЭЛН(ДанныеЛН)
	ДанныеИзСервиса = Новый Структура("LN_CODE, LN_HASH");
	ЗаполнитьЗначенияСвойств(ДанныеИзСервиса, ДанныеЛН);
	РегистрыСведений.ХэшиЭЛН.ЗаписатьХэш(ДанныеИзСервиса.LN_CODE, ДанныеИзСервиса.LN_HASH);
КонецПроцедуры

Процедура ЗагрузитьРезультатОтправкиРеестраЭЛН(Документ, WSResult, Результат, ТекстСообщенияФСС)
	ТекстСообщенияФССВыведен = ПустаяСтрока(ТекстСообщенияФСС);
	Если WSResult.Свойства().Получить("INFO") <> Неопределено
		И WSResult.INFO.Свойства().Получить("ROWSET") <> Неопределено
		И WSResult.INFO.ROWSET.Свойства().Получить("ROW") <> Неопределено Тогда
		ROWSET = КоллекцияОбъектовXDTO(WSResult.INFO.ROWSET.ROW);
		Для Каждого ROW Из ROWSET Цикл
			Если Строка(ROW.STATUS) = "1" Тогда
				РегистрыСведений.ХэшиЭЛН.ЗаписатьХэш(ROW.LN_CODE, ROW.LN_HASH);
			Иначе
				СтрокаДанныхЭЛН = Документ.ДанныеЭЛН.Найти(ROW.LN_CODE, "НомерЛисткаНетрудоспособности");
				НомерСтроки = (?(СтрокаДанныхЭЛН = Неопределено, 0, СтрокаДанныхЭЛН.НомерСтроки));
				ERRORS = КоллекцияОбъектовXDTO(ROW.ERRORS.ERROR);
				Для Каждого ERROR Из ERRORS Цикл
					Если ERROR.ERR_CODE = "ERR_013" И НомерСтроки <> 0 Тогда
						// Отказ не включается, т.к. будет предпринята попытка зачитать актуальные Хэши и повторная попытка отправки.
						Результат.БольничныеТребующиеАктуализацииХэша.Добавить(НомерСтроки);
					Иначе
						Если Не ТекстСообщенияФССВыведен Тогда
							ЗарплатаКадрыОтображениеОшибок.СообщитьОбОшибке(Результат.Отказ, ТекстСообщенияФСС, "");
							ТекстСообщенияФССВыведен = Истина;
						КонецЕсли;
						ЗарплатаКадрыОтображениеОшибок.СообщитьОбОшибке(
							Результат.Отказ,
							ERROR.ERR_MESS,
							"ЛистокНетрудоспособности",
							"ДанныеЭЛН",
							НомерСтроки,
							"Объект");
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьРезультатПолученияЭЛН(Документ, ДанныеЛН, Отказ)
	
	ДанныеИзСервиса = Новый Структура("LN_State, LN_DATE, SURNAME, NAME, PATRONIMIC, BIRTHDAY");
	ЗаполнитьЗначенияСвойств(ДанныеИзСервиса, ДанныеЛН);
	
	// Проверка состояния.
	Состояние = СостояниеЭЛН(ДанныеИзСервиса.LN_State);
	Если Не Состояние.ЗагрузкаРазрешена Тогда
		Если Состояние.Представление = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Ошибка в структуре сообщения ФСС: В поле ""%1"" недокументированное значение: ""%2"".';
								|en = 'An error occurred in the SSF message structure: There is an undocumented value in the ""%1"" field: ""%2"".'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, "LN_State", ДанныеИзСервиса.LN_State);
		Иначе
			ТекстОшибки = НСтр("ru = 'Листок нетрудоспособности не может быть загружен, его состояние: ""%1"".';
								|en = 'Sick leave record cannot be imported, its state: ""%1"".'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Состояние.Представление);
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	// Проверка кадровых данных сотрудника.
	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Документ.Сотрудник, "Фамилия, Имя, Отчество, ДатаРождения", ДанныеИзСервиса.LN_DATE);
	Найденные = КадровыеДанныеСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Документ.Сотрудник));
	Если Найденные.Количество() > 0 Тогда
		КадровыеДанныеСотрудника = Найденные[0];
		
		Если ВРег(СокрЛП(ДанныеИзСервиса.SURNAME))       <> ВРег(СокрЛП(КадровыеДанныеСотрудника.Фамилия))
			Или ВРег(СокрЛП(ДанныеИзСервиса.NAME))       <> ВРег(СокрЛП(КадровыеДанныеСотрудника.Имя))
			Или ВРег(СокрЛП(ДанныеИзСервиса.PATRONIMIC)) <> ВРег(СокрЛП(КадровыеДанныеСотрудника.Отчество)) Тогда
			ТекстОшибки = НСтр("ru = 'ФИО указанные в листке нетрудоспособности (%1 %2 %3) не совпадают с ФИО сотрудника.';
								|en = 'Full name specified in the sick leave certificate (%1 %2 %3) does not match employee''s full name.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, ДанныеИзСервиса.SURNAME, ДанныеИзСервиса.NAME, ДанныеИзСервиса.PATRONIMIC);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
		ДанныеЛНДатаРождения = ЗначениеИзСтрокиXMLПоТипу(ДанныеИзСервиса.BIRTHDAY, Тип("Дата"));
		Если ДанныеЛНДатаРождения <> КадровыеДанныеСотрудника.ДатаРождения Тогда
			ТекстОшибки = НСтр("ru = 'Дата рождения указанная в листке нетрудоспособности (%1) не совпадает с датой рождения сотрудника.';
								|en = 'Date of birth specified in the sick leave record (%1) does not match the employee date of birth.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Формат(ДанныеЛНДатаРождения, "ДЛФ=D"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеЭЛН(Документ, ДанныеЛН)
	
	ИменаПолейИзСервиса = 
	"APPROVE1,
	|APPROVE2,
	|BASE_AVG_DAILY_SAL,
	|BASE_AVG_SAL,
	|BIRTHDAY,
	|BOZ_FLAG,
	|CALC_CONDITION1,
	|CALC_CONDITION2,
	|CALC_CONDITION3,
	|CALC_CONDITION4,
	|DATE1,
	|DATE2,
	|DT1_LN,
	|DT2_LN,
	|DUPLICATE_FLAG,
	|EMPL_FLAG,
	|EMPL_PARENT_NO,
	|EMPL_PAYMENT,
	|EMPL_REG_NO,
	|EMPL_REG_NO2,
	|EMPLOYER,
	|FORM1_DT,
	|FSS_PAYMENT,
	|GENDER,
	|HOSPITAL_BREACH,
	|HOSPITAL_DT1,
	|HOSPITAL_DT2,
	|INN_PERSON,
	|INSUR_MM,
	|INSUR_YY,
	|LN_CODE,
	|LN_DATE,
	|LN_HASH,
	|LN_RESULT,
	|LN_STATE,
	|LPU_ADDRESS,
	|LPU_EMPL_FLAG,
	|LPU_EMPLOYER,
	|LPU_NAME,
	|LPU_OGRN,
	|MSE_DT1,
	|MSE_DT2,
	|MSE_DT3,
	|MSE_INVALID_GROUP,
	|NAME,
	|NOT_INSUR_MM,
	|NOT_INSUR_YY,
	|PARENT_CODE,
	|PATRONIMIC,
	|PAYMENT,
	|PREGN12W_FLAG,
	|PREV_LN_CODE,
	|PRIMARY_FLAG,
	|REASON1,
	|REASON2,
	|REASON3,
	|RETURN_DATE_EMPL,
	|SERV1_AGE,
	|SERV1_FIO,
	|SERV1_MM,
	|SERV1_RELATION_CODE,
	|SERV2_AGE,
	|SERV2_FIO,
	|SERV2_MM,
	|SERV2_RELATION_CODE,
	|SNILS,
	|SURNAME,
	|VOUCHER_NO,
	|VOUCHER_OGRN";
	ДанныеИзСервиса = Новый Структура(ИменаПолейИзСервиса);
	ЗаполнитьЗначенияСвойств(ДанныеИзСервиса, ДанныеЛН);
	
	СоответствиеПолей = Документы.БольничныйЛист.СоответствиеПолейЭЛН();
	Для Каждого СвойствоДокумента Из СоответствиеПолей Цикл
		Документ[СвойствоДокумента.Ключ] = ЗначениеИзСтрокиXMLПоТипу(ДанныеИзСервиса[СвойствоДокумента.Значение], ТипЗнч(Документ[СвойствоДокумента.Ключ]));
	КонецЦикла;
	
	Документ.ЯвляетсяПродолжениемБолезни = Не ЗначениеИзСтрокиXMLПоТипу(ДанныеИзСервиса.PRIMARY_FLAG, Тип("Булево"));
	
	Если ДанныеИзСервиса.LN_RESULT <> Неопределено Тогда
		Значения = Новый Структура("MSE_RESULT, OTHER_STATE_DT, RETURN_DATE_LPU, NEXT_LN_CODE");
		ЗаполнитьЗначенияСвойств(Значения, ДанныеИзСервиса.LN_RESULT);
		ЗаполнитьЗначениеИзСтрокиXML(Документ.НовыйСтатусНетрудоспособного,     Значения.MSE_RESULT,      Тип("Строка"));
		ЗаполнитьЗначениеИзСтрокиXML(Документ.ДатаНовыйСтатусНетрудоспособного, Значения.OTHER_STATE_DT,  Тип("Дата"));
		ЗаполнитьЗначениеИзСтрокиXML(Документ.ПриступитьКРаботеС,               Значения.RETURN_DATE_LPU, Тип("Дата"));
		ЗаполнитьЗначениеИзСтрокиXML(Документ.НомерЛисткаПродолжения,           Значения.NEXT_LN_CODE,    Тип("Строка"));
	КонецЕсли;
	
	Если ДанныеИзСервиса.HOSPITAL_BREACH <> Неопределено Тогда
		Значения = Новый Структура("HOSPITAL_BREACH_CODE, HOSPITAL_BREACH_DT");
		ЗаполнитьЗначенияСвойств(Значения, ДанныеИзСервиса.HOSPITAL_BREACH);
		ЗаполнитьЗначениеИзСтрокиXML(Документ.КодНарушенияРежима,  Значения.HOSPITAL_BREACH_CODE, Тип("Строка"));
		ЗаполнитьЗначениеИзСтрокиXML(Документ.ДатаНарушенияРежима, Значения.HOSPITAL_BREACH_DT,   Тип("Дата"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Документ.НомерПервичногоЛисткаНетрудоспособности)
		И Документ.ЯвляетсяПродолжениемБолезни Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НомерЛисткаНетрудоспособности", Документ.НомерПервичногоЛисткаНетрудоспособности);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	БольничныйЛист.Ссылка
		|ИЗ
		|	Документ.БольничныйЛист КАК БольничныйЛист
		|ГДЕ
		|	БольничныйЛист.НомерЛисткаНетрудоспособности = &НомерЛисткаНетрудоспособности";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Документ.ПервичныйБольничныйЛист = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Номер = 0;
	ТаблицаПолныхПериодов = КоллекцияОбъектовXDTO(ДанныеЛН.TREAT_PERIODS.TREAT_FULL_PERIOD);
	Для Каждого СтрокаТаблицыПолныхПериодов Из ТаблицаПолныхПериодов Цикл
		
		ЗначенияПолныхПериодов = Новый Структура("TREAT_CHAIRMAN, TREAT_CHAIRMAN_ROLE");
		ЗаполнитьЗначенияСвойств(ЗначенияПолныхПериодов, СтрокаТаблицыПолныхПериодов);
		
		ТаблицаПериодов = КоллекцияОбъектовXDTO(СтрокаТаблицыПолныхПериодов.TREAT_PERIOD);
		Для Каждого СтрокаТаблицыПериодов Из ТаблицаПериодов Цикл
			Номер = Номер + 1;
			
			ЗначенияПериодов = Новый Структура("TREAT_DT1, TREAT_DT2, TREAT_DOCTOR_ROLE, TREAT_DOCTOR");
			ЗаполнитьЗначенияСвойств(ЗначенияПериодов, СтрокаТаблицыПериодов);
			
			Документ["ОсвобождениеДатаНачала" + Номер]     = ЗначениеИзСтрокиXMLПоТипу(ЗначенияПериодов.TREAT_DT1, Тип("Дата"));
			Документ["ОсвобождениеДатаОкончания" + Номер]  = ЗначениеИзСтрокиXMLПоТипу(ЗначенияПериодов.TREAT_DT2, Тип("Дата"));
			Документ["ОсвобождениеФИОВрача" + Номер]       = ЗначенияПериодов.TREAT_DOCTOR;
			Документ["ОсвобождениеДолжностьВрача" + Номер] = ЗначенияПериодов.TREAT_DOCTOR_ROLE;
			
			Документ["ОсвобождениеФИОВрачаПредседателяВК" + Номер]       = ЗначенияПолныхПериодов.TREAT_CHAIRMAN;
			Документ["ОсвобождениеДолжностьВрачаПредседателяВК" + Номер] = ЗначенияПолныхПериодов.TREAT_CHAIRMAN_ROLE;
			
			Если Номер = 3 Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Номер = 3 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Документы.БольничныйЛист.ПослеЗагрузкиЭЛН(Документ, ДанныеИзСервиса);
	
КонецПроцедуры

// Расшифровывает код состояния ЛН.
Функция СостояниеЭЛН(LN_State)
	Состояние = Новый Структура("Код, Имя, Представление, ЗагрузкаРазрешена");
	Состояние.Код = LN_State;
	Состояние.ЗагрузкаРазрешена = Ложь;
	
	Если LN_State = "010" Тогда
		Состояние.Имя = "Открыт";
		Состояние.Представление = НСтр("ru = 'Открыт';
										|en = 'Open'");
		
	ИначеЕсли LN_State = "020" Тогда
		Состояние.Имя = "Продлен";
		Состояние.Представление = НСтр("ru = 'Продлен';
										|en = 'Extended'");
		
	ИначеЕсли LN_State = "030" Тогда
		Состояние.Имя = "Закрыт";
		Состояние.Представление = НСтр("ru = 'Закрыт';
										|en = 'Closed'");
		Состояние.ЗагрузкаРазрешена = Истина;
		
	ИначеЕсли LN_State = "040" Тогда
		Состояние.Имя = "НаправленНаМСЭ";
		Состояние.Представление = НСтр("ru = 'Направлен на медико-социальную экспертизу';
										|en = 'Sent for medical and social assessment '");
		Состояние.ЗагрузкаРазрешена = Истина;
		
	ИначеЕсли LN_State = "050" Тогда
		Состояние.Имя = "ДополненДаннымиМСЭ";
		Состояние.Представление = НСтр("ru = 'Дополнен данными медико-социальной экспертизы';
										|en = 'Data of medical and social assessment is added'");
		Состояние.ЗагрузкаРазрешена = Истина;
		
	ИначеЕсли LN_State = "060" Тогда
		Состояние.Имя = "ЗаполненСтрахователем";
		Состояние.Представление = НСтр("ru = 'Заполнен страхователем';
										|en = 'Populated by insurant'");
		
	ИначеЕсли LN_State = "070" Тогда
		Состояние.Имя = "ПособиеНачисленоСтраховщиком";
		Состояние.Представление = НСтр("ru = 'Пособие начислено страховщиком (прямые выплаты страхового обеспечения)';
										|en = 'Allowance is accrued by insurer (direct insurance coverage payments)'");
		
	ИначеЕсли LN_State = "080" Тогда
		Состояние.Имя = "ПособиеВыплачено";
		Состояние.Представление = НСтр("ru = 'Пособие выплачено';
										|en = 'Allowance is paid'");
		
	ИначеЕсли LN_State = "090" Тогда
		Состояние.Имя = "ДействияПрекращены";
		Состояние.Представление = НСтр("ru = 'Отменен';
										|en = 'Canceled'");
		
	КонецЕсли;
	
	Возврат Состояние;
КонецФункции

Функция ПрочитатьФайлXML(АдресРасшифрованногоОтвета, Операция)
	ПолноеИмяФайлаXML = ПолучитьИмяВременногоФайла("xml");
	РасшифрованныйОтвет = ПолучитьИзВременногоХранилища(АдресРасшифрованногоОтвета);
	УдалитьИзВременногоХранилища(АдресРасшифрованногоОтвета);
	
	Если ТипЗнч(РасшифрованныйОтвет) = Тип("ДвоичныеДанные") Тогда
		РасшифрованныйОтвет.Записать(ПолноеИмяФайлаXML);
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ПолноеИмяФайлаXML);
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
		УдалитьФайлы(ПолноеИмяФайлаXML);
	ИначеЕсли ТипЗнч(РасшифрованныйОтвет) = Тип("Строка") Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(РасшифрованныйОтвет);
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	КонецЕсли;
	
	Если Операция = "getPrivateLNData" Тогда
		WSResult = ОбъектXDTO.Body.getPrivateLNDataResponse.FileOperationsLnUserGetPrivateLNDataOut;
	ИначеЕсли Операция = "prParseReestrFile" Тогда
		WSResult = ОбъектXDTO.Body.prParseReestrFileResponse.WSResult;
	Иначе
		WSResult = ОбъектXDTO;
	КонецЕсли;
	
	Возврат WSResult;
КонецФункции

Процедура ЗаполнитьСотрудникаИНомерЭЛН(Документ, WSResult, Отказ)
	ROW = КоллекцияОбъектовXDTO(WSResult.DATA.OUT_ROWSET.ROW)[0];
	
	Сведения = Новый Структура("LN_CODE, LN_DATE, SNILS, SURNAME, NAME, PATRONIMIC, BIRTHDAY");
	ЗаполнитьЗначенияСвойств(Сведения, ROW);
	
	Документ.НомерЛисткаНетрудоспособности = Сведения.LN_CODE;
	
	// Поиск физ. лица.
	Если ТипЗнч(Сведения.SNILS) = Тип("Строка") И ЗначениеЗаполнено(Сведения.SNILS) Тогда
		СНИЛС = СтрШаблон("%1-%2-%3 %4", Сред(Сведения.SNILS, 1, 3), Сред(Сведения.SNILS, 4, 3), Сред(Сведения.SNILS, 7, 3), Сред(Сведения.SNILS, 10, 2));
	Иначе
		СНИЛС = "";
	КонецЕсли;
	ФизическоеЛицо = ФизическоеЛицо(СНИЛС, Строка(Сведения.SURNAME), Строка(Сведения.NAME), Строка(Сведения.PATRONIMIC));
	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Отказ = Истина; // Важно определить физ. лицо, которому выдан ЭЛН.
		Возврат;
	КонецЕсли;
	
	Если ФизическоеЛицо <> Документ.ФизическоеЛицо Тогда
		// Выбран сотрудник другого физ. лица, надо заполнить сотрудника (и организацию).
		Если ЗначениеЗаполнено(Сведения.LN_DATE) Тогда
			ДатаЭЛН = ЗначениеИзСтрокиXMLПоТипу(Сведения.LN_DATE, Тип("Дата"));
		Иначе
			ДатаЭЛН = Документ.Дата;
		КонецЕсли;
		РезультатПоиска = СотрудникОрганизации(Документ.Организация, ДатаЭЛН, ФизическоеЛицо);
		Если РезультатПоиска.Успех Тогда
			ЗаполнитьЗначенияСвойств(Документ, РезультатПоиска, "Сотрудник, Организация");
			Документ.ФизическоеЛицо = ФизическоеЛицо;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПоиска.ТекстОшибки, , , , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ФизическоеЛицо(СНИЛС, Фамилия, Имя, Отчество)
	Если Не ЗначениеЗаполнено(СНИЛС) Тогда
		ТекстОшибки = НСтр("ru = 'В файле не заполнен СНИЛС сотрудника.';
							|en = 'Employee IIAN is not populated in the file.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = УчетПособийСоциальногоСтрахования.ЗапросДляПоискаФизическихЛиц(Фамилия, Имя, Отчество, СНИЛС);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.СНИЛС = СНИЛС Тогда
			Возврат Выборка.Ссылка;
		ИначеЕсли Не ЗначениеЗаполнено(Выборка.СНИЛС) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У сотрудника ""%1"" не заполнен СНИЛС (в файле СНИЛС ""%2"").';
					|en = 'The IIAN is not specified for employee ""%1"" (in the ""%2"" IIAN file).'"),
				Строка(Выборка.Ссылка),
				СНИЛС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Возврат Выборка.Ссылка;
		Иначе
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По ФИО ""%1"" найден сотрудник ""%2"" с СНИЛС ""%3"", но в файле СНИЛС ""%4"".';
					|en = 'The ""%2"" employee with the ""%3"" IIAN was found by the ""%1"" name. However, the ""%4"" IIAN is specified in the file.'"),
				Фамилия + " " + Имя + " " + Отчество,
				Строка(Выборка.Ссылка),
				Выборка.СНИЛС,
				СНИЛС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не найден сотрудник с СНИЛС ""%1"" (%2). Проверьте что у сотрудника корректно заполнен СНИЛС.';
			|en = 'Employee with the ""%1"" IIAN was not found (%2). Make sure that the employee IIAN is filled in correctly.'"),
		СНИЛС,
		Фамилия + " " + Имя + " " + Отчество);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	Возврат Неопределено;
КонецФункции

Функция СотрудникОрганизации(ПредполагаемаяОрганизация, Дата, ФизическоеЛицо)
	Результат = Новый Структура("Успех, ТекстОшибки, Сотрудник, Организация", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	ПараметрыПолученияСотрудников.ОкончаниеПериода = Дата;
	ПараметрыПолученияСотрудников.КадровыеДанные = "Организация, ДатаУвольнения";
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Ложь, ПараметрыПолученияСотрудников);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ВТСотрудникиОрганизации.ДатаУвольнения = &ПустаяДата
	|				ТОГДА &МаксимальнаяДата
	|			ИНАЧЕ ВТСотрудникиОрганизации.ДатаУвольнения
	|		КОНЕЦ) КАК ДатаУвольнения,
	|	ВТСотрудникиОрганизации.Организация КАК Организация
	|ПОМЕСТИТЬ ВТСотрудникиСДатами
	|ИЗ
	|	ВТСотрудникиОрганизации КАК ВТСотрудникиОрганизации
	|ГДЕ
	|	(ВТСотрудникиОрганизации.ДатаУвольнения = &ПустаяДата
	|			ИЛИ ВТСотрудникиОрганизации.ДатаУвольнения >= ДОБАВИТЬКДАТЕ(&ТекущаяДата, ГОД, -1))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТСотрудникиОрганизации.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСотрудникиСДатами.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА ВТСотрудникиСДатами.ДатаУвольнения >= &ТекущаяДата
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Работает,
	|	ВТСотрудникиСДатами.ДатаУвольнения КАК ДатаУвольнения,
	|	ВТСотрудникиОрганизации.Сотрудник КАК Сотрудник
	|ИЗ
	|	ВТСотрудникиСДатами КАК ВТСотрудникиСДатами
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудникиОрганизации КАК ВТСотрудникиОрганизации
	|		ПО ВТСотрудникиСДатами.Организация = ВТСотрудникиОрганизации.Организация
	|			И (ВЫБОР
	|				КОГДА ВТСотрудникиОрганизации.ДатаУвольнения = &ПустаяДата
	|					ТОГДА &МаксимальнаяДата
	|				ИНАЧЕ ВТСотрудникиОрганизации.ДатаУвольнения
	|			КОНЕЦ = ВТСотрудникиСДатами.ДатаУвольнения)";
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	Запрос.УстановитьПараметр("ТекущаяДата", Дата);
	Запрос.УстановитьПараметр("МаксимальнаяДата", '39991231235959');
	
	ВсеОрганизации = Запрос.Выполнить().Выгрузить();
	ОбщееКоличество = ВсеОрганизации.Количество();
	Если ОбщееКоличество = 0 Тогда
		Результат.ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудник ""%1"" на ""%2"" не принят на работу.';
				|en = 'Employee ""%1"" is not hired as of ""%2"".'"),
			ФизическоеЛицо,
			Формат(Дата, "ДЛФ=D"));
	ИначеЕсли ОбщееКоличество = 1 Тогда
		Результат.Успех       = Истина;
		Результат.Организация = ВсеОрганизации[0].Организация;
		Результат.Сотрудник   = ВсеОрганизации[0].Сотрудник;
	Иначе
		ТекущиеРаботодатели = ВсеОрганизации.НайтиСтроки(Новый Структура("Работает", Истина));
		КоличествоАктивных = ТекущиеРаботодатели.Количество();
		Если КоличествоАктивных = 1 Тогда
			// Сотрудник работает в одной организации.
			Результат.Успех       = Истина;
			Результат.Организация = ТекущиеРаботодатели[0].Организация;
			Результат.Сотрудник   = ТекущиеРаботодатели[0].Сотрудник;
		Иначе
			// Сотрудник либо работал в нескольких организациях, либо работает в нескольких организациях.
			НайденнаяСтрока = ВсеОрганизации.Найти(ПредполагаемаяОрганизация, "Организация");
			Если НайденнаяСтрока <> Неопределено Тогда
				// Пользователь явно указал организацию.
				Результат.Успех       = Истина;
				Результат.Организация = НайденнаяСтрока.Организация;
				Результат.Сотрудник   = НайденнаяСтрока.Сотрудник;
			Иначе
				ПредставлениеОрганизаций = СтрСоединить(ВсеОрганизации.ВыгрузитьКолонку("Организация"), ", ");
				Результат.ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Требуется выбрать организацию, т.к. сотрудник ""%1"" на ""%2"" работает в нескольких организациях (%3).';
						|en = 'Select a company as employee ""%1"" works for several companies (%3) as of ""%2"".'"),
					ФизическоеЛицо,
					Формат(Дата, "ДЛФ=D"),
					ПредставлениеОрганизаций);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Процедура ЗаполнитьЗначениеИзСтрокиXML(Приемник, ЗначениеВФорматеXML, ТипЗначения)
	Если ЗначениеВФорматеXML <> Неопределено И ЗначениеЗаполнено(ЗначениеВФорматеXML) Тогда
		Приемник = ЗначениеИзСтрокиXMLПоТипу(ЗначениеВФорматеXML, ТипЗначения);
	КонецЕсли;
КонецПроцедуры

Функция КоллекцияОбъектовXDTO(Значение) Экспорт
	Если ТипЗнч(Значение) = Тип("ОбъектXDTO") Тогда
		Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
	Иначе
		Возврат Значение;
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
