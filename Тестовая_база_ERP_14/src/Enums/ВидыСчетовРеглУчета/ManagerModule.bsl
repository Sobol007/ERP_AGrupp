#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаНоменклатуры" и "ПорядокОтраженияНоменклатуры"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовНоменклатуры() Экспорт
	
	ВидыСчетовНоменклатуры = Новый Массив;
	ВидыСчетовНоменклатуры.Добавить(Перечисления.ВидыСчетовРеглУчета.НаСкладе);
	ВидыСчетовНоменклатуры.Добавить(Перечисления.ВидыСчетовРеглУчета.ВыручкаОтПродаж);
	ВидыСчетовНоменклатуры.Добавить(Перечисления.ВидыСчетовРеглУчета.СебестоимостьПродаж);
	ВидыСчетовНоменклатуры.Добавить(Перечисления.ВидыСчетовРеглУчета.НДСПриПродаже);
	ВидыСчетовНоменклатуры.Добавить(Перечисления.ВидыСчетовРеглУчета.РеализацияБезПереходаПраваСобственности);
	ВидыСчетовНоменклатуры.Добавить(Перечисления.ВидыСчетовРеглУчета.НДСПриОтгрузкеБезПереходаПраваСобственности);
	ВидыСчетовНоменклатуры.Добавить(Перечисления.ВидыСчетовРеглУчета.ВыручкаОтПродажЕНВД);
	ВидыСчетовНоменклатуры.Добавить(Перечисления.ВидыСчетовРеглУчета.СебестоимостьПродажЕНВД);
	Возврат ВидыСчетовНоменклатуры;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаНоменклатуры" и "ПорядокОтраженияНоменклатурыПереданнойНаКомиссию"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовНоменклатурыУКонтрагентов() Экспорт
	
	ВидыСчетовНоменклатурыУКонтрагентов = Новый Массив;
	ВидыСчетовНоменклатурыУКонтрагентов.Добавить(Перечисления.ВидыСчетовРеглУчета.ПередачаНаКомиссию);
	ВидыСчетовНоменклатурыУКонтрагентов.Добавить(Перечисления.ВидыСчетовРеглУчета.ПередачаВПереработку);
	ВидыСчетовНоменклатурыУКонтрагентов.Добавить(Перечисления.ВидыСчетовРеглУчета.ЗатратыНаПриобретениеТМЦ);
	ВидыСчетовНоменклатурыУКонтрагентов.Добавить(Перечисления.ВидыСчетовРеглУчета.ВыручкаОтПродажКомиссионера);
	ВидыСчетовНоменклатурыУКонтрагентов.Добавить(Перечисления.ВидыСчетовРеглУчета.СебестоимостьПродажКомиссионера);
	ВидыСчетовНоменклатурыУКонтрагентов.Добавить(Перечисления.ВидыСчетовРеглУчета.НДСПриПродажеКомиссионера);
	Возврат ВидыСчетовНоменклатурыУКонтрагентов;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаРасчетов" и "ПорядокОтраженияРасчетовСПартнерами"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРасчетовСКлиентами() Экспорт
	
	ВидыСчетовРасчетовСКлиентами = Новый Массив;
	ВидыСчетовРасчетовСКлиентами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКлиентами);
	ВидыСчетовРасчетовСКлиентами.Добавить(Перечисления.ВидыСчетовРеглУчета.АвансыПолученные);
	ВидыСчетовРасчетовСКлиентами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКлиентамиТара);
	Возврат ВидыСчетовРасчетовСКлиентами;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаРасчетов" и "ПорядокОтраженияРасчетовСПартнерами"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРасчетовСПоставщиками() Экспорт
	
	ВидыСчетовРасчетовСПоставщиками = Новый Массив;
	ВидыСчетовРасчетовСПоставщиками.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСПоставщиками);
	ВидыСчетовРасчетовСПоставщиками.Добавить(Перечисления.ВидыСчетовРеглУчета.АвансыВыданные);
	ВидыСчетовРасчетовСПоставщиками.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыПоПретензиям);
	ВидыСчетовРасчетовСПоставщиками.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСПоставщикамиТара);
	ВидыСчетовРасчетовСПоставщиками.Добавить(Перечисления.ВидыСчетовРеглУчета.НеотфактурованныеПоставки);
	Возврат ВидыСчетовРасчетовСПоставщиками;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаРасчетов" и "ПорядокОтраженияРасчетовСПартнерами"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРасчетовСКомиссионерами() Экспорт
	
	ВидыСчетовРасчетовСКомиссионерами = Новый Массив;
	ВидыСчетовРасчетовСКомиссионерами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКлиентами);
	ВидыСчетовРасчетовСКомиссионерами.Добавить(Перечисления.ВидыСчетовРеглУчета.АвансыПолученные);
	ВидыСчетовРасчетовСКомиссионерами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСПоставщиками);
	ВидыСчетовРасчетовСКомиссионерами.Добавить(Перечисления.ВидыСчетовРеглУчета.АвансыВыданные);
	Возврат ВидыСчетовРасчетовСКомиссионерами;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаРасчетов" и "ПорядокОтраженияРасчетовСПартнерами"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРасчетовСКомитентами() Экспорт
	
	ВидыСчетовРасчетовСКомитентами = Новый Массив;
	ВидыСчетовРасчетовСКомитентами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКлиентами);
	ВидыСчетовРасчетовСКомитентами.Добавить(Перечисления.ВидыСчетовРеглУчета.АвансыПолученные);
	ВидыСчетовРасчетовСКомитентами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСПоставщиками);
	ВидыСчетовРасчетовСКомитентами.Добавить(Перечисления.ВидыСчетовРеглУчета.АвансыВыданные);
	Возврат ВидыСчетовРасчетовСКомитентами;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаРасчетов" и "ПорядокОтраженияРасчетовСПартнерами"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРасчетовСКредиторами() Экспорт
	
	ВидыСчетовРасчетовСКредиторами = Новый Массив;
	ВидыСчетовРасчетовСКредиторами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКредиторамиОсновнойДолг);
	ВидыСчетовРасчетовСКредиторами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКредиторамиКомиссия);
	ВидыСчетовРасчетовСКредиторами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСКредиторамиПроценты);
	Возврат ВидыСчетовРасчетовСКредиторами;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаРасчетов" и "ПорядокОтраженияРасчетовСПартнерами"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРасчетовСДебиторами() Экспорт
	
	ВидыСчетовРасчетовСДебиторами = Новый Массив;
	ВидыСчетовРасчетовСДебиторами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСДебиторамиОсновнойДолг);
	ВидыСчетовРасчетовСДебиторами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСДебиторамиКомиссия);
	ВидыСчетовРасчетовСДебиторами.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыСДебиторамиПроценты);
	Возврат ВидыСчетовРасчетовСДебиторами;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаРасчетов" и "ПорядокОтраженияРасчетовСПартнерами"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРасчетовСЛизингодателями() Экспорт
	
	ВидыСчетовРасчетовСЛизингодателями = Новый Массив;
	ВидыСчетовРасчетовСЛизингодателями.Добавить(Перечисления.ВидыСчетовРеглУчета.ЛизинговыеУслуги);
	ВидыСчетовРасчетовСЛизингодателями.Добавить(Перечисления.ВидыСчетовРеглУчета.ОбеспечительныйПлатежПоЛизингу);
	ВидыСчетовРасчетовСЛизингодателями.Добавить(Перечисления.ВидыСчетовРеглУчета.ВыкупПредметаЛизинга);
	ВидыСчетовРасчетовСЛизингодателями.Добавить(Перечисления.ВидыСчетовРеглУчета.АрендныеОбязательстваПоЛизингу);
	Возврат ВидыСчетовРасчетовСЛизингодателями;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "СтатьиДоходов" и "ПорядокОтраженияДоходов"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовДоходов() Экспорт
	
	ВидыСчетовДоходов = Новый Массив;
	ВидыСчетовДоходов.Добавить(Перечисления.ВидыСчетовРеглУчета.Доходы);
	Возврат ВидыСчетовДоходов;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "СтатьиРасходов" и "ПорядокОтраженияРасходов"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРасходов() Экспорт
	
	ВидыСчетовРасходов = Новый Массив;
	ВидыСчетовРасходов.Добавить(Перечисления.ВидыСчетовРеглУчета.Расходы);
	ВидыСчетовРасходов.Добавить(Перечисления.ВидыСчетовРеглУчета.СписаниеРасходовОСНО);
	ВидыСчетовРасходов.Добавить(Перечисления.ВидыСчетовРеглУчета.СписаниеРасходовЕНВД);
	Возврат ВидыСчетовРасходов;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "БанковскиеСчетаОрганизаций" и "Кассы"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовДенежныхСредств() Экспорт
	
	ВидыСчетовДенежныхСредств = Новый Массив;
	ВидыСчетовДенежныхСредств.Добавить(Перечисления.ВидыСчетовРеглУчета.ДенежныеСредства);
	Возврат ВидыСчетовДенежныхСредств;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ПорядокОтраженияПроизводства"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовПроизводства() Экспорт
	
	ВидыСчетовПроизводства = Новый Массив;
	ВидыСчетовПроизводства.Добавить(Перечисления.ВидыСчетовРеглУчета.Производство);
	Возврат ВидыСчетовПроизводства;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ВидыПодарочныхСертификатов" и "ПорядокОтраженияПодарочныхСертификатов"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовПодарочныхСертификатов() Экспорт
	
	ВидыСчетовПодарочныхСертификатов = Новый Массив;
	ВидыСчетовПодарочныхСертификатов.Добавить(Перечисления.ВидыСчетовРеглУчета.РасчетыПоПодарочнымСертификатам);
	Возврат ВидыСчетовПодарочныхСертификатов;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "КатегорииЭксплуатации" и "ПорядокОтраженияТМЦВЭксплуатации"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовТМЦВЭксплуатации() Экспорт
	
	ВидыСчетовТМЦВЭксплуатации = Новый Массив;
	ВидыСчетовТМЦВЭксплуатации.Добавить(Перечисления.ВидыСчетовРеглУчета.ТМЦВЭксплуатации);
	ВидыСчетовТМЦВЭксплуатации.Добавить(Перечисления.ВидыСчетовРеглУчета.ТМЦВЭксплуатацииЗаБалансом);
	Возврат ВидыСчетовТМЦВЭксплуатации;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "ГруппыФинансовогоУчетаВнеоборотныхАктивов"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовВнеоборотныхАктивов() Экспорт
	
	ВидыСчетовВнеоборотныхАктивов = Новый Массив;
	ВидыСчетовВнеоборотныхАктивов.Добавить(Перечисления.ВидыСчетовРеглУчета.СтоимостьВНА);
	ВидыСчетовВнеоборотныхАктивов.Добавить(Перечисления.ВидыСчетовРеглУчета.СтоимостьВНА_ЦФ);
	ВидыСчетовВнеоборотныхАктивов.Добавить(Перечисления.ВидыСчетовРеглУчета.АмортизацияВНА);
	ВидыСчетовВнеоборотныхАктивов.Добавить(Перечисления.ВидыСчетовРеглУчета.АмортизацияВНА_ЦФ);
	ВидыСчетовВнеоборотныхАктивов.Добавить(Перечисления.ВидыСчетовРеглУчета.ВыбытиеВНА);
	ВидыСчетовВнеоборотныхАктивов.Добавить(Перечисления.ВидыСчетовРеглУчета.РезервДооценкиВНА);
	ВидыСчетовВнеоборотныхАктивов.Добавить(Перечисления.ВидыСчетовРеглУчета.ЗабалансовыйУчетВНА);
	Возврат ВидыСчетовВнеоборотныхАктивов;
	
КонецФункции

// Возвращает список видов счетов, применяющихся для счетов "Резервы" и "ПорядокОтраженияРезервов"
// Возвращаемое значение:
//	Массив - массив значений типа ПеречислениеСсылка.ВидыСчетовРеглУчета;
//
Функция ВидыСчетовРезервов() Экспорт
	
	ВидыСчетовВнеоборотныхАктивов = Новый Массив;
	ВидыСчетовВнеоборотныхАктивов.Добавить(Перечисления.ВидыСчетовРеглУчета.Резервы);
	Возврат ВидыСчетовВнеоборотныхАктивов;
	
КонецФункции

#КонецОбласти

#КонецЕсли