
#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц) Экспорт
	ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц);
КонецПроцедуры

Процедура СоздатьВТБухучетНачислений(Организация, ПериодРегистрации, ПроцентЕНВД, МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТБухучетНачислений(Организация, ПериодРегистрации, ПроцентЕНВД, МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура СоздатьВТСведенияОБухучетеЗарплатыСотрудников(МенеджерВременныхТаблиц, ИмяВременнойТаблицы, ИменаПолейВременнойТаблицы = "Сотрудник,Период", Организация = Неопределено, Подразделение = Неопределено, ТерриторияВыполненияРаботВОрганизации = Неопределено) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТСведенияОБухучетеЗарплатыСотрудников(МенеджерВременныхТаблиц, ИмяВременнойТаблицы, ИменаПолейВременнойТаблицы, Организация, Подразделение, ТерриторияВыполненияРаботВОрганизации);

КонецПроцедуры

Процедура СоздатьВТСведенияОБухучетеНачислений(МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТСведенияОБухучетеНачислений(МенеджерВременныхТаблиц);

КонецПроцедуры

Функция ТекстЗапросаДанныеДокументаОбработкаДокументовОтражениеЗарплатыВБухучете() Экспорт

	Возврат ОтражениеЗарплатыВБухучетеРасширенный.ТекстЗапросаДанныеДокументаОбработкаДокументовОтражениеЗарплатыВБухучете();

КонецФункции

Процедура УстановитьСписокВыбораОтношениеКЕНВД(ЭлементФормы, ИмяЭлемента) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.УстановитьСписокВыбораОтношениеКЕНВД(ЭлементФормы, ИмяЭлемента);
	
КонецПроцедуры

Процедура ОбновитьВидОперацииУдержаниеПоПрочимОперациямСРаботниками() Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ОбновитьВидОперацииУдержаниеПоПрочимОперациямСРаботниками();

КонецПроцедуры

Процедура ЗаполнитьВидОперацииПоЗарплатеВНачислениях() Экспорт

	// В расширенной реализации не заполняется.

КонецПроцедуры

Процедура ЗаполнитьВидОперацииПоЗарплатеВНачисленияхДляНатуральныхДоходов() Экспорт

	// В расширенной реализации не заполняется.

КонецПроцедуры

Процедура СоздатьВТНачисленияБазаОтпуска(МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТНачисленияБазаОтпуска(МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура ОбновитьВидОперацииЕжегодныеОтпуска() Экспорт

	//	

КонецПроцедуры

Процедура ПерерасчетНДФЛРаспределитьПоСтатьям(Организация,ПериодРегистрации,ДокументСсылка,РезультатыРасчета) Экспорт
	ОтражениеЗарплатыВБухучетеРасширенный.ПерерасчетНДФЛРаспределитьПоСтатьям(Организация,ПериодРегистрации,ДокументСсылка,РезультатыРасчета);
КонецПроцедуры

Функция ДанныеДляОтраженияЗарплатыВБухучете(Организация, ПериодРегистрации) Экспорт

	Возврат ОтражениеЗарплатыВБухучетеРасширенный.ДанныеДляОтраженияЗарплатыВБухучете(Организация, ПериодРегистрации);

КонецФункции

Процедура ДополнитьСведенияОВзносахДаннымиБухучета(Движения, Организация, ПериодРегистрации, Ссылка, МенеджерВременныхТаблиц, ИмяВременнойТаблицы) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ДополнитьСведенияОВзносахДаннымиБухучета(Движения, Организация, ПериодРегистрации, Ссылка, МенеджерВременныхТаблиц, ИмяВременнойТаблицы);

КонецПроцедуры

Процедура ЗаполнитьПараметрыДляРасчетаОценочныхОбязательствОтпусков(Организация, ПериодРегистрации, ПараметрыДляРасчета, Сотрудники) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ЗаполнитьПараметрыДляРасчетаОценочныхОбязательствОтпусков(Организация, ПериодРегистрации, ПараметрыДляРасчета, Сотрудники);

КонецПроцедуры

#КонецОбласти
