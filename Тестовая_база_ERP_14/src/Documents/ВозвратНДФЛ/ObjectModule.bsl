
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = ДанныеДляПроведенияДокумента();
	
	УчетНДФЛ.СформироватьУдержанныйНалогПоВременнойТаблице(Движения, Отказ, Организация, КонецМесяца(Месяц), ДанныеДляПроведения.МенеджерВременныхТаблиц);
	Для каждого Движение Из Движения.РасчетыНалогоплательщиковСБюджетомПоНДФЛ Цикл
		Движение.ВариантУдержания = Перечисления.ВариантыУдержанияНДФЛ.ВозвращеноНалоговымАгентом
	КонецЦикла;
	
	УчетНачисленнойЗарплаты.ЗарегистрироватьВозвратНДФЛ(Движения, Отказ, Организация, Месяц, ДанныеДляПроведения.УдержанияПоРабочимМестам, ПорядокВыплаты());
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка корректности распределения по источникам финансирования
	ИменаТаблиц = "СуммыВозврата";
	УчетНДФЛФормы.ВозвратНДФЛПроверитьРезультатыРаспределения(ЭтотОбъект, ИменаТаблиц, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведенияДокумента()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(Месяц));
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВозвратНДФЛСуммыВозврата.Ссылка.Сотрудник КАК ФизическоеЛицо,
	               |	ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка) КАК Подразделение,
	               |	ВозвратНДФЛСуммыВозврата.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	               |	ВозвратНДФЛСуммыВозврата.КатегорияДохода КАК КатегорияДохода,
	               |	ВозвратНДФЛСуммыВозврата.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	               |	КОНЕЦПЕРИОДА(ВозвратНДФЛСуммыВозврата.Ссылка.Месяц, МЕСЯЦ) КАК Период,
	               |	ВозвратНДФЛСуммыВозврата.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	               |	СУММА(ВозвратНДФЛСуммыВозврата.Налог) КАК Сумма
	               |ПОМЕСТИТЬ ВТСтрокиДокумента
	               |ИЗ
	               |	Документ.ВозвратНДФЛ.СуммыВозврата КАК ВозвратНДФЛСуммыВозврата
	               |ГДЕ
	               |	ВозвратНДФЛСуммыВозврата.Ссылка = &Ссылка
	               |	И ВозвратНДФЛСуммыВозврата.Налог > 0
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВозвратНДФЛСуммыВозврата.Ссылка.Сотрудник,
	               |	ВозвратНДФЛСуммыВозврата.МесяцНалоговогоПериода,
	               |	ВозвратНДФЛСуммыВозврата.РегистрацияВНалоговомОргане,
	               |	ВозвратНДФЛСуммыВозврата.Ссылка.Месяц,
	               |	ВозвратНДФЛСуммыВозврата.КатегорияДохода,
	               |	ВозвратНДФЛСуммыВозврата.СтавкаНалогообложенияРезидента
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
	               |ПОМЕСТИТЬ ВТФизическиеЛица
	               |ИЗ
	               |	ВТСтрокиДокумента КАК Сотрудники
	               |ГДЕ
	               |	Сотрудники.ФизическоеЛицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СтрокиДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	-СтрокиДокумента.Сумма КАК Сумма,
	               |	СтрокиДокумента.Подразделение КАК Подразделение,
	               |	СтрокиДокумента.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	               |	СтрокиДокумента.МесяцНалоговогоПериода КАК Период,
	               |	СтрокиДокумента.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	               |	СтрокиДокумента.КатегорияДохода КАК КатегорияДохода,
	               |	ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка) КАК КодДохода,
	               |	СтрокиДокумента.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане
	               |ПОМЕСТИТЬ ВТНалогУдержанный
	               |ИЗ
	               |	ВТСтрокиДокумента КАК СтрокиДокумента
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ ПЕРВЫЕ 0
	               |	ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка) КАК ФизическоеЛицо,
	               |	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
	               |	0 КАК СуммаДохода,
	               |	0 КАК СуммаВычета,
	               |	ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка) КАК Подразделение
	               |ПОМЕСТИТЬ ВТДанныеДляРасчетаНДФЛ";
	
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВозвратНДФЛ.Ссылка КАК Ссылка,
	               |	ВозвратНДФЛ.Организация КАК Организация,
	               |	ВозвратНДФЛ.Сотрудник КАК ФизическоеЛицо,
	               |	ВозвратНДФЛ.Месяц КАК Месяц
	               |ИЗ
	               |	Документ.ВозвратНДФЛ КАК ВозвратНДФЛ
	               |ГДЕ
	               |	ВозвратНДФЛ.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	РеквизитыДляПроведения = Новый Структура("Ссылка,Организация,Сотрудник,ФизическоеЛицо,Месяц,Подразделение,ТерриторияВыполненияРаботВОрганизации");
	ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, Выборка);
	
	УдержанияПоРабочимМестам = УчетНДФЛФормы.ВозвратНДФЛУдержанияПоРабочимМестам(РеквизитыДляПроведения);
	
	Возврат Новый Структура("УдержанияПоРабочимМестам, МенеджерВременныхТаблиц", УдержанияПоРабочимМестам, Запрос.МенеджерВременныхТаблиц);

КонецФункции

Функция ПорядокВыплаты()
	
	Если Метаданные().Реквизиты.Найти("ПорядокВыплаты") = Неопределено Тогда
		Возврат Перечисления.ХарактерВыплатыЗарплаты.Зарплата
	Иначе	
		Возврат ЭтотОбъект["ПорядокВыплаты"]
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли