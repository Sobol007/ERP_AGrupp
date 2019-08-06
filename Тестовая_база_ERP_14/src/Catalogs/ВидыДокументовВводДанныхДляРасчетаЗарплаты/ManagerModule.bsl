#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция НастройкиВидаДокумента(ВидДокумента) Экспорт
	
	ИменаВыбираемыхРеквизитовСправочника = 
	"НесколькоПодразделений,
	|НесколькоОрганизаций,
	|НесколькоСотрудников,
	|ЗначенияПоказателейВводятсяНаРазныеДаты,
	|ИспользоватьПериодОкончания,
	|ВремяВводитсяСводно,
	|ВремяВводитсяЗаМесяц,
	|ВидыРаботЗаполняютсяВДокументе,
	|ВыполненныеРаботыРаспределяютсяПоСотрудникам,
	|ВыполненныеРаботыРаспределяютсяСверхТарифа,
	|ВыполненныеРаботыРаспределяютсяСУчетомКоэффициентов,
	|ВыполненныеРаботыРаспределяютсяСУчетомТарифныхСтавок,
	|ВыполненныеРаботыРаспределяютсяСУчетомОтработанногоВремени,
	|ВыполненныеРаботыВводятсяСводно,
	|ЗаполнятьСписокОбъектов,
	|Организация,
	|Подразделение,
	|ПоказыватьПодразделение,
	|ПроверятьЗаполнениеПодразделения,
	|ПредставлениеДокумента,
	|Подсказка,
	|СпособПримененияЗначенийПоказателей,
	|РегистрироватьСведенияОБухучете,
	|РежимВводаСпособаОтраженияЗарплатыВБухучете,
	|РежимВводаСтатьиФинансирования,
	|РежимВводаОтношенияКЕНВД,
	|РежимВводаПодразделенияУчетаЗатрат";
	
	НастройкиВида = Новый Структура(ИменаВыбираемыхРеквизитовСправочника + ",
	|ЭтоВводПостоянныхПоказателей,
	|ПоказыватьТарифнуюСтавку,
	|ПоказыватьОтработанноеВремя");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыДокументов.Ссылка,
	|	&ИменаВыбираемыхРеквизитовСправочника,
	|	ВЫБОР
	|		КОГДА ВидыДокументов.СпособПримененияЗначенийПоказателей = ЗНАЧЕНИЕ(Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВводПостоянныхПоказателей
	|ИЗ
	|	Справочник.ВидыДокументовВводДанныхДляРасчетаЗарплаты КАК ВидыДокументов
	|ГДЕ
	|	ВидыДокументов.Ссылка = &ВидДокумента";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИменаВыбираемыхРеквизитовСправочника", ИменаВыбираемыхРеквизитовСправочника);
	Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(НастройкиВида, Выборка);
	
	Если Не НастройкиВида.РегистрироватьСведенияОБухучете Тогда
		НастройкиВида.РежимВводаСтатьиФинансирования              = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
		НастройкиВида.РежимВводаСпособаОтраженияЗарплатыВБухучете = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
		НастройкиВида.РежимВводаОтношенияКЕНВД                    = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
		НастройкиВида.РежимВводаПодразделенияУчетаЗатрат          = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
	Иначе
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный") Тогда
			НастройкиВида.РежимВводаСтатьиФинансирования = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
		ИначеЕсли Не ЗначениеЗаполнено(НастройкиВида.РежимВводаСтатьиФинансирования) Тогда
			НастройкиВида.РежимВводаСтатьиФинансирования = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ВводитьВШапке;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(НастройкиВида.РежимВводаСпособаОтраженияЗарплатыВБухучете) Тогда
			НастройкиВида.РежимВводаСпособаОтраженияЗарплатыВБухучете = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ВводитьВШапке;
		КонецЕсли;
		Если Не ПолучитьФункциональнуюОпцию("ПлательщикЕНВДЗарплатаКадрыРасширенная") Тогда
			НастройкиВида.РежимВводаОтношенияКЕНВД = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
		ИначеЕсли Не ЗначениеЗаполнено(НастройкиВида.РежимВводаОтношенияКЕНВД) Тогда
			НастройкиВида.РежимВводаОтношенияКЕНВД = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ВводитьВШапке;
		КонецЕсли;
	КонецЕсли;
	
	НастройкиВида.ПоказыватьТарифнуюСтавку = НастройкиВида.ВыполненныеРаботыРаспределяютсяСУчетомТарифныхСтавок
		Или НастройкиВида.ВыполненныеРаботыРаспределяютсяСверхТарифа;
	НастройкиВида.ПоказыватьОтработанноеВремя = НастройкиВида.ВыполненныеРаботыРаспределяютсяСУчетомОтработанногоВремени
		Или НастройкиВида.ВыполненныеРаботыРаспределяютсяСверхТарифа;
	
	Возврат НастройкиВида;
КонецФункции

Функция СсылкиВидыДокументовВводДанныхДляРасчетаЗарплатыНачальнойНастройкиПрограммы() Экспорт 
	
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты = Новый Структура;
	
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("ВводПроцентаГодовойПремии", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("ВводГодовойПремии", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("ВводПроцентаКвартальнойПремии", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("ВводКвартальнойПремии", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("ВводПроцентаРазовойПремии", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("ВводРазовойПремии", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("ВыручкаОтРеализации", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("НазначениеПроцентаДоплатыЗаВыручку", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("ВыполнениеПлана", Неопределено);
	СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты.Вставить("НазначениеПлана", Неопределено);
	
	Возврат СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты;
	
КонецФункции

// Формирует список видов документов по умолчанию в соответствии с настройками.
//
Процедура СоздатьВидыДокументовПоНастройкам(НастройкиРасчетаЗарплаты = Неопределено, ПараметрыПланаВидовРасчета = Неопределено) Экспорт
	
	Если ПараметрыПланаВидовРасчета = Неопределено Тогда
		ПараметрыПланаВидовРасчета = РасчетЗарплатыРасширенный.ОписаниеПараметровПланаВидовРасчета();
	КонецЕсли;
	
	Если НастройкиРасчетаЗарплаты = Неопределено Тогда
		НастройкиРасчетаЗарплаты = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты();
	КонецЕсли;
	
	СозданныеЭлементы = ПараметрыПланаВидовРасчета.СсылкиВидыДокументовВводДанныхДляРасчетаЗарплаты;
	Если СозданныеЭлементы = Неопределено Тогда 
		СозданныеЭлементы = СсылкиВидыДокументовВводДанныхДляРасчетаЗарплатыНачальнойНастройкиПрограммы();
	КонецЕсли;
	
	СозданныеПоказатели = ПараметрыПланаВидовРасчета.СсылкиПоказателиРасчетаЗарплаты;
	Если СозданныеПоказатели = Неопределено Тогда 
		СозданныеПоказатели = Справочники.ПоказателиРасчетаЗарплаты.СсылкиПоказателиРасчетаЗарплатыНачальнойНастройкиПрограммы();
	КонецЕсли;
	
	// Создание шаблонов документов.
	ПараметрыПремии = ПараметрыПланаВидовРасчета.ГодоваяПремия;
	Если ПараметрыПремии.НачисляетсяПоЗначениюПоказателей И ПараметрыПремии.ИспользоватьПремиюПроцентом Тогда
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "ВводПроцентаГодовойПремии";
		Описание.Наименование = НСтр("ru = 'Ввод процента годовой премии';
									|en = 'Enter year-end bonus percent'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Ввод процента годовой премии';
												|en = 'Enter year-end bonus percent'");
		Описание.Подсказка = НСтр("ru = 'Введенные значения показателя годовой премии будут использованы при начислении зарплаты.';
									|en = 'Entered values of year-end bonus indicator will be used on salary accounting.'");
		Показатель = ЗарплатаКадрыРасширенный.ПоказательПоИдентификатору("ПроцентГодовойПремии");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Показатель);
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "ВводПроцентаГодовойПремии");
	КонецЕсли;
	
	Если ПараметрыПремии.НачисляетсяПоЗначениюПоказателей И ПараметрыПремии.ИспользоватьПремиюСуммой Тогда
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "ВводГодовойПремии";
		Описание.Наименование = НСтр("ru = 'Ввод годовой премии';
									|en = 'Enter year-end bonus'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Ввод годовой премии';
												|en = 'Enter year-end bonus'");
		Описание.Подсказка = НСтр("ru = 'Введенные значения показателя годовой премии будут использованы при начислении зарплаты.';
									|en = 'Entered values of year-end bonus indicator will be used on salary accounting.'");
		Показатель = ЗарплатаКадрыРасширенный.ПоказательПоИдентификатору("РазмерГодовойПремии");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Показатель);
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "ВводГодовойПремии");
	КонецЕсли;
	
	ПараметрыПремии = ПараметрыПланаВидовРасчета.КвартальнаяПремия;
	Если ПараметрыПремии.НачисляетсяПоЗначениюПоказателей И ПараметрыПремии.ИспользоватьПремиюПроцентом Тогда
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "ВводПроцентаКвартальнойПремии";
		Описание.Наименование = НСтр("ru = 'Ввод процента квартальной премии';
									|en = 'Enter quarterly bonus percent'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Ввод процента квартальной премии';
												|en = 'Enter quarterly bonus percent'");
		Описание.Подсказка = НСтр("ru = 'Введенные значения показателя квартальной премии будут использованы при начислении зарплаты.';
									|en = 'Entered values of quarterly bonus indicator will be used on salary accounting.'");
		Показатель = ЗарплатаКадрыРасширенный.ПоказательПоИдентификатору("ПроцентКвартальнойПремии");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Показатель);
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "ВводПроцентаКвартальнойПремии");
	КонецЕсли;
	
	Если ПараметрыПремии.НачисляетсяПоЗначениюПоказателей И ПараметрыПремии.ИспользоватьПремиюСуммой Тогда
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "ВводКвартальнойПремии";
		Описание.Наименование = НСтр("ru = 'Ввод квартальной премии';
									|en = 'Enter quarterly bonus'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Ввод квартальной премии';
												|en = 'Enter quarterly bonus'");
		Описание.Подсказка = НСтр("ru = 'Введенные значения показателя квартальной премии будут использованы при начислении зарплаты.';
									|en = 'Entered values of quarterly bonus indicator will be used on salary accounting.'");
		Показатель = ЗарплатаКадрыРасширенный.ПоказательПоИдентификатору("РазмерКвартальнойПремии");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Показатель);
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "ВводКвартальнойПремии");
	КонецЕсли;
	
	ПараметрыПремии = ПараметрыПланаВидовРасчета.РазоваяПремия;
	Если ПараметрыПремии.НачисляетсяПоЗначениюПоказателей И ПараметрыПремии.ИспользоватьПремиюПроцентом Тогда
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "ВводПроцентаРазовойПремии";
		Описание.Наименование = НСтр("ru = 'Ввод процента разовой премии';
									|en = 'Enter one-off bonus percent'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Ввод процента разовой премии';
												|en = 'Enter one-off bonus percent'");
		Описание.Подсказка = НСтр("ru = 'Введенные значения показателя разовой премии будут использованы при начислении зарплаты.';
									|en = 'Entered values of one-off bonus indicator will be used for salary accounting.'");
		Показатель = ЗарплатаКадрыРасширенный.ПоказательПоИдентификатору("ПроцентРазовойПремии");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Показатель);
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "ВводПроцентаРазовойПремии");
	КонецЕсли;
	
	Если ПараметрыПремии.НачисляетсяПоЗначениюПоказателей И ПараметрыПремии.ИспользоватьПремиюСуммой Тогда
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "ВводРазовойПремии";
		Описание.Наименование = НСтр("ru = 'Ввод разовой премии';
									|en = 'Enter one-off bonus'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Ввод разовой премии';
												|en = 'Enter one-off bonus'");
		Описание.Подсказка = НСтр("ru = 'Введенные значения показателя разовой премии будут использованы при начислении зарплаты.';
									|en = 'Entered values of one-off bonus indicator will be used for salary accounting.'");
		Показатель = ЗарплатаКадрыРасширенный.ПоказательПоИдентификатору("РазмерРазовойПремии");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Показатель);
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "ВводРазовойПремии");
	КонецЕсли;
	
	// - Для выручки от реализации.
	Если ПараметрыПланаВидовРасчета.ИспользоватьДоплатуЗаВыручкуОтРеализации Тогда
		// Выручка
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "ВыручкаОтРеализации";
		Описание.Наименование = НСтр("ru = 'Выручка от реализации';
									|en = 'Revenue from sales'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Выручка от реализации';
												|en = 'Revenue from sales'");
		Описание.Подсказка = НСтр("ru = 'Количество денежных средств, получаемое компанией за определенный период деятельности,
                                   |в основном за счет продажи товаров или услуг своим клиентам.';
                                   |en = 'Amount of cash received by the company over the specified period,
                                   |mainly due to sale of goods or services to its customers.'");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СозданныеПоказатели.Выручка);
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
		
		// Процент доплаты
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "НазначениеПроцентаДоплатыЗаВыручку";
		Описание.Наименование = НСтр("ru = 'Назначение процента доплаты за выручку';
									|en = 'Assign extra pay percent for revenue '");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Назначение процента доплаты за выручку';
												|en = 'Assign extra pay percent for revenue '");
		Описание.Подсказка = НСтр("ru = 'Процентная ставка доплаты сотрудникам организации за выручку от реализации.';
									|en = 'Percent rate of company employee extra pay for revenue from sale.'");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СозданныеПоказатели.ПроцентДоплатыЗаВыручку);
		Описание.НесколькоСотрудников = Ложь;
		Описание.ПоказыватьПодразделение = Ложь;
		Описание.СпособПримененияЗначенийПоказателей = Перечисления.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное;
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "ВыручкаОтРеализации");
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "НазначениеПроцентаДоплатыЗаВыручку");
	КонецЕсли;
	
	// - для выполнения плана
	Если ПараметрыПланаВидовРасчета.ИспользоватьДоплатуЗаВыполнениеПлана Тогда
		// Выполнение плана
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "ВыполнениеПлана";
		Описание.Наименование = НСтр("ru = 'Выполнение месячного плана';
									|en = 'Fulfill monthly plan'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Выполнение месячного плана';
												|en = 'Fulfill monthly plan'");
		Описание.Подсказка = НСтр("ru = 'Фактические результаты выполненных работ. При расчете соотносятся с запланированными.';
									|en = 'Actual results of performed works. Compared to the planned results during calculation.'");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СозданныеПоказатели.ВыполнениеПлана);
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
		
		// Процент доплаты
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Идентификатор = "НазначениеПлана";
		Описание.Наименование = НСтр("ru = 'Назначение плана';
									|en = 'Assign plan '");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Назначение плана';
												|en = 'Assign plan '");
		Описание.Подсказка = НСтр("ru = 'Позволяет соотнести фактические результаты плановым значениям.';
									|en = 'Allows you to compare actual results with planned values. '");
		Описание.Показатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СозданныеПоказатели.План);
		Описание.НесколькоСотрудников = Ложь;
		Описание.НесколькоПодразделений = Истина;
		Описание.ПоказыватьПодразделение = Ложь;
		Описание.СпособПримененияЗначенийПоказателей = Перечисления.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное;
		ЗаписатьВидДокумента(Описание, СозданныеЭлементы);
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "ВыполнениеПлана");
		ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, "НазначениеПлана");
	КонецЕсли;
	
	СоздатьВидыДокументовСдельногоЗаработка(НастройкиРасчетаЗарплаты, ПараметрыПланаВидовРасчета);
	
КонецПроцедуры

// Предназначена для получения актуальных видов документов.
//
Функция ТаблицаВидовДокументов() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВидыДокументов.Ссылка КАК ВидДокумента,
		|	ВидыДокументов.Наименование КАК Наименование,
		|	ВЫБОР
		|		КОГДА ВидыДокументов.ПредставлениеДокумента <> """"
		|			ТОГДА ВидыДокументов.ПредставлениеДокумента
		|		ИНАЧЕ ВидыДокументов.Наименование
		|	КОНЕЦ КАК Представление,
		|	ВидыДокументов.Родитель
		|ИЗ
		|	Справочник.ВидыДокументовВводДанныхДляРасчетаЗарплаты КАК ВидыДокументов
		|ГДЕ
		|	НЕ ВидыДокументов.ПометкаУдаления
		|	И НЕ ВидыДокументов.НеИспользуется
		|	И НЕ ВидыДокументов.ЭтоГруппа
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидыДокументов.РеквизитДопУпорядочивания");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ДоступныеВнешниеПечатныеФормы(ВидДокумента) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВнешниеПечатныеФормы.ПечатнаяФорма КАК ПечатнаяФорма
	|ИЗ
	|	Справочник.ВидыДокументовВводДанныхДляРасчетаЗарплаты.ВнешниеПечатныеФормы КАК ВнешниеПечатныеФормы
	|ГДЕ
	|	ВнешниеПечатныеФормы.Ссылка = &ВидДокумента";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПечатнаяФорма");
	
КонецФункции

// Создает описание вида документа в виде структуры со значениями полей по умолчанию.
//
Функция СоздатьОписаниеВидаДокумента()
	
	Описание = Новый Структура(
	"Идентификатор,
	|Наименование, 
	|ПредставлениеДокумента, 
	|Подсказка, 
	|НесколькоСотрудников, 
	|НесколькоПодразделений, 
	|НесколькоОрганизаций, 
	|ПоказыватьПодразделение, 
	|ПроверятьЗаполнениеПодразделения, 
	|ЗаполнятьСписокОбъектов, 
	|СпособПримененияЗначенийПоказателей, 
	|ИспользоватьПериодОкончания, 
	|ЗначенияПоказателейВводятсяНаРазныеДаты, 
	|ВремяВводитсяСводно, 
	|ВидыРаботЗаполняютсяВДокументе,
	|ВыполненныеРаботыВводятсяСводно,
	|РегистрироватьСведенияОБухучете,
	|РежимВводаСтатьиФинансирования,
	|РежимВводаСпособаОтраженияЗарплатыВБухучете,
	|РежимВводаОтношенияКЕНВД,
	|РежимВводаПодразделенияУчетаЗатрат,
	|ВыполненныеРаботыРаспределяютсяПоСотрудникам,
	|ВыполненныеРаботыРаспределяютсяСУчетомКоэффициентов,
	|ВыполненныеРаботыРаспределяютсяСУчетомТарифныхСтавок,
	|ВыполненныеРаботыРаспределяютсяСУчетомОтработанногоВремени,
	|Показатели,
	|ВидыВремени");
	
	Описание.НесколькоСотрудников = Истина;
	Описание.НесколькоПодразделений = Ложь;
	Описание.НесколькоОрганизаций = Ложь;
	Описание.ПоказыватьПодразделение = Истина;
	Описание.ПроверятьЗаполнениеПодразделения = Ложь;
	Описание.ЗаполнятьСписокОбъектов = Ложь;
	Описание.СпособПримененияЗначенийПоказателей = Перечисления.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Разовое;
	Описание.ИспользоватьПериодОкончания = Ложь;
	Описание.ЗначенияПоказателейВводятсяНаРазныеДаты = Ложь;
	Описание.ВремяВводитсяСводно = Ложь;
	
	Описание.ВидыРаботЗаполняютсяВДокументе = Ложь;
	Описание.ВыполненныеРаботыВводятсяСводно = Ложь;
	Описание.ВыполненныеРаботыРаспределяютсяПоСотрудникам = Ложь;
	Описание.ВыполненныеРаботыРаспределяютсяСУчетомКоэффициентов = Ложь;
	Описание.ВыполненныеРаботыРаспределяютсяСУчетомТарифныхСтавок = Ложь;
	Описание.ВыполненныеРаботыРаспределяютсяСУчетомОтработанногоВремени = Ложь;
	
	Описание.РегистрироватьСведенияОБухучете = Ложь;
	Описание.РежимВводаСтатьиФинансирования              = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
	Описание.РежимВводаСпособаОтраженияЗарплатыВБухучете = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
	Описание.РежимВводаОтношенияКЕНВД                    = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
	Описание.РежимВводаПодразделенияУчетаЗатрат          = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ПустаяСсылка();
	
	Возврат Описание;
	
КонецФункции

// Создает или обновляет в информационной базе идентифицируемый элемент по описанию.
//
// Параметры:
//	- ОписаниеПоказателя - структура, состав полей см. в СоздатьОписаниеВидаДокумента.
//
Функция ЗаписатьВидДокумента(Описание, СозданныеЭлементы = Неопределено)
	
	Ссылка = Неопределено;
	
	Если СозданныеЭлементы <> Неопределено Тогда
		СозданныеЭлементы.Свойство(Описание.Идентификатор, Ссылка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) И ОбщегоНазначения.СсылкаСуществует(Ссылка) Тогда
		Объект = Ссылка.ПолучитьОбъект();
		Объект.НеИспользуется = Ложь;
	Иначе
		Объект = Справочники.ВидыДокументовВводДанныхДляРасчетаЗарплаты.СоздатьЭлемент();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, Описание);
	
	// Показатели
	Если Описание.Показатели <> Неопределено Тогда
		Для Каждого Показатель Из Описание.Показатели Цикл
			Если Объект.Показатели.НайтиСтроки(Новый Структура("Показатель", Показатель)).Количество() = 0 Тогда
				Объект.Показатели.Добавить().Показатель = Показатель;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Виды времени
	Если Описание.ВидыВремени <> Неопределено Тогда
		Для Каждого ВидВремени Из Описание.ВидыВремени Цикл
			Если Объект.ВидыВремени.НайтиСтроки(Новый Структура("ВидВремени", ВидВремени)).Количество() = 0 Тогда
				Объект.ВидыВремени.Добавить().ВидВремени = ВидВремени;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Объект.Записать();
	
	Если СозданныеЭлементы <> Неопределено Тогда
		СозданныеЭлементы.Вставить(Описание.Идентификатор, Объект.Ссылка);
	КонецЕсли;
	
	Возврат Объект.Ссылка;
	
КонецФункции

Процедура ОтключитьИспользованиеОбъектаСИдентификатором(СозданныеЭлементы, Идентификатор)
	
	СправочникСсылка = Неопределено;
	СозданныеЭлементы.Свойство(Идентификатор, СправочникСсылка);
	
	Если СправочникСсылка <> Неопределено Тогда 
		
		СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		
		Попытка
			СправочникОбъект.Заблокировать();
		Исключение
			ТекстИсключения = НСтр("ru = 'Невозможно изменить Шаблон документа ввода исходных данных для расчета зарплаты """"%2"""". Возможно, объект редактируется другим пользователем';
									|en = 'Cannot change Template of document for entering original payroll data """"%2"""". Maybe, the object is being edited by another user'");
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИсключения, СправочникОбъект.Наименование);
		КонецПопытки;
		
		СправочникОбъект.НеИспользуется = Истина;
		СправочникОбъект.Записать();
		
		СозданныеЭлементы.Вставить(Идентификатор, СправочникОбъект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьВидыДокументовСдельногоЗаработка(НастройкиРасчетаЗарплаты = Неопределено, ПараметрыПланаВидовРасчета = Неопределено)
	Если Не ЗарплатаКадрыРасширенный.ИспользоватьДляРегистрацииВыполненныхРаботДокументВводаДанныхДляРасчетаЗарплаты() Тогда
		Возврат; // Не используем шаблоны для ввода сдельных работ.
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВидыДокументов.Ссылка,
	|	ВидыДокументов.НеИспользуется
	|ИЗ
	|	Справочник.ВидыДокументовВводДанныхДляРасчетаЗарплаты КАК ВидыДокументов
	|ГДЕ
	|	(ВидыДокументов.ВидыРаботЗаполняютсяВДокументе
	|			ИЛИ ВидыДокументов.Ссылка В
	|				(ВЫБРАТЬ
	|					ВидыРабот.Ссылка
	|				ИЗ
	|					Справочник.ВидыДокументовВводДанныхДляРасчетаЗарплаты.ВидыРабот КАК ВидыРабот))";
	
	// Запросом выбираем виды документов, предназначенные для ввода выполненных работ.
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		// Создание шаблона.
		Если Не НастройкиРасчетаЗарплаты.ИспользоватьСдельныйЗаработок Тогда
			Возврат; // Настройка отключена.
		КонецЕсли;
		
		Описание = СоздатьОписаниеВидаДокумента();
		Описание.Наименование = НСтр("ru = 'Сдельные работы';
									|en = 'Pieceworks'");
		Описание.ПредставлениеДокумента = НСтр("ru = 'Сдельные работы';
												|en = 'Pieceworks'");
		Описание.Подсказка = НСтр("ru = 'Данные о выполненных работах будут использованы при расчете показателя «Сдельный заработок».';
									|en = 'Data on performed works will be used when calculating the ""Piecework earnings"" indicator.  '");
		Описание.ВидыРаботЗаполняютсяВДокументе = Истина;
		Описание.ПоказыватьПодразделение = Истина;
		Описание.ВыполненныеРаботыВводятсяСводно = Истина;
		Описание.ВыполненныеРаботыРаспределяютсяПоСотрудникам = Истина;
		Описание.ВыполненныеРаботыРаспределяютсяСУчетомКоэффициентов = Истина;
		Описание.ВыполненныеРаботыРаспределяютсяСУчетомТарифныхСтавок = Истина;
		
		Описание.РегистрироватьСведенияОБухучете = ПараметрыПланаВидовРасчета.РегистрироватьСдельнуюОплатуВБухучете;
		Если Описание.РегистрироватьСведенияОБухучете Тогда
			Описание.РежимВводаСтатьиФинансирования              = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ВводитьВШапке;
			Описание.РежимВводаСпособаОтраженияЗарплатыВБухучете = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ВводитьВШапке;
			Описание.РежимВводаОтношенияКЕНВД                    = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ВводитьВШапке;
			Описание.РежимВводаПодразделенияУчетаЗатрат          = Перечисления.РежимыВводаБухучетаВДанныхДляРасчетаЗарплаты.ВводитьВШапке;
		КонецЕсли;
		
		ЗаписатьВидДокумента(Описание);
	Иначе
		// Включение/отключение имеющихся шаблонов.
		НеИспользуется = Не НастройкиРасчетаЗарплаты.ИспользоватьСдельныйЗаработок;
		Пока Выборка.Следующий() Цикл
			Если Выборка.НеИспользуется <> НеИспользуется Тогда
				ВидДокументаОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ВидДокументаОбъект.НеИспользуется = НеИспользуется;
				ВидДокументаОбъект.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли