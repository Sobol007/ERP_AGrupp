#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуСПроверкойЗаписи(ИмяФормы, ПараметрыФормы, ФормаВладелец) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ФормаВладелец.Объект.Ссылка) ИЛИ ФормаВладелец.Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Открытие возможно только после проведения документа. Провести документ?';
							|en = 'Opening is possible only after posting the document. Post the document?'");
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ИмяФормы", ПараметрыФормы);
		ДополнительныеПараметры.Вставить("ПараметрыФормы", ПараметрыФормы);
		ДополнительныеПараметры.Вставить("ФормаВладелец", ФормаВладелец);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуСПроверкойЗаписиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормы, ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

Процедура ОткрытьФормуСПроверкойЗаписиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОткрыватьФорму = Ложь;
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Попытка
			ФормаВладелец = ДополнительныеПараметры.ФормаВладелец;
			ПараметрыЗаписи = Новый Структура;
			ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
			ОткрыватьФорму = ФормаВладелец.Записать(ПараметрыЗаписи);
		Исключение
			ПоказатьПредупреждение(,НСтр("ru = 'Не удалось выполнить проведение документа';
										|en = 'Failed to post document'"));
		КонецПопытки;
	КонецЕсли;
	
	Если ОткрыватьФорму Тогда
		ОткрытьФорму(ДополнительныеПараметры.ИмяФормы, ДополнительныеПараметры.ПараметрыФормы, ДополнительныеПараметры.ФормаВладелец);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьВозможностьСозданияДокументаНаОсновании(Форма, Оповещение) Экспорт
	
	Если Не ЗначениеЗаполнено(Форма.Объект.Ссылка)
		Или Не Форма.Объект.Проведен
		Или Форма.Модифицированность Тогда
		
		ДополнительныеПараметры = Новый Структура("Оповещение, Форма", Оповещение, Форма);
		ОповещениеВопроса = Новый ОписаниеОповещения(
			"ПроверитьВозможностьСозданияДокументаНаОснованииЗавершение",
			ЭтотОбъект, ДополнительныеПараметры);
		
		ТекстВопроса = НСтр("ru = 'Для продолжения необходимо провести документ. Провести?';
							|en = 'Post the document to continue. Post?'");
		ПоказатьВопрос(ОповещениеВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Истина);
	
КонецПроцедуры

Процедура ПроверитьВозможностьСозданияДокументаНаОснованииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	ВводитьДокумент = Ложь;
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Попытка
			Форма = ДополнительныеПараметры.Форма;
			ПараметрыЗаписи = Новый Структура;
			ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "НеВыполнятьПроверкуПередЗаписью") Тогда
				ПараметрыЗаписи.Вставить("ДействиеПослеЗаписи", ДополнительныеПараметры.Оповещение);
			КонецЕсли;
			ВводитьДокумент = Форма.Записать(ПараметрыЗаписи);
		Исключение
			ПоказатьПредупреждение(,НСтр("ru = 'Не удалось выполнить проведение документа';
										|en = 'Failed to post document'"));
		КонецПопытки;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение, ВводитьДокумент);
	
КонецПроцедуры

#Область РегистрацияСчетовФактурПолученных

Процедура ВвестиСчетФактуруПолученный(Форма, ПараметрыРегистрации) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыРегистрации",  ПараметрыРегистрации);
	ДополнительныеПараметры.Вставить("ОткрыватьСуществующую", Ложь);
	ДополнительныеПараметры.Вставить("Форма",                 Форма);
	
	Оповещение = Новый ОписаниеОповещения("ВвестиСчетФактуруПолученныйЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПроверитьВозможностьСозданияДокументаНаОсновании(Форма, Оповещение);
	
КонецПроцедуры

Процедура ВвестиСчетФактуруПолученныйЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да 
		И Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРегистрации = ДополнительныеПараметры.ПараметрыРегистрации;
		
	Если ЗначениеЗаполнено(ПараметрыРегистрации.Ссылка) Тогда
		ДокументОснование = ПараметрыРегистрации.Ссылка;
	Иначе
		ДокументОснование = ДополнительныеПараметры.Форма.Объект.Ссылка;
	КонецЕсли;
		
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДокументОснование", ДокументОснование);
	ПараметрыОткрытия.Вставить("Организация",       ПараметрыРегистрации.Организация);
	ПараметрыОткрытия.Вставить("Контрагент",        ПараметрыРегистрации.Контрагент);
	ПараметрыОткрытия.Вставить("Исправление",       ПараметрыРегистрации.ИсправлениеОшибок);
	ПараметрыОткрытия.Вставить("Корректировочный",  ПараметрыРегистрации.КорректировкаПоСогласованиюСторон);
	
	ПараметрыФормы = Новый Структура("Основание, ДокументОснование",ПараметрыОткрытия, ДокументОснование);
	Если ПараметрыРегистрации.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя") Тогда
		ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
	Иначе
		ОткрытьФорму("Документ.СчетФактураПолученный.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВвестиЗаявлениеОВвозеТоваров(Форма, ПараметрыРегистрации) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыРегистрации",  ПараметрыРегистрации);
	ДополнительныеПараметры.Вставить("ОткрыватьСуществующую", Ложь);
	ДополнительныеПараметры.Вставить("Форма",                 Форма);
	
	Оповещение = Новый ОписаниеОповещения("ВвестиЗаявлениеОВвозеТоваровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПроверитьВозможностьСозданияДокументаНаОсновании(Форма, Оповещение);
	
КонецПроцедуры

Процедура ВвестиЗаявлениеОВвозеТоваровЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да 
		И Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРегистрации = ДополнительныеПараметры.ПараметрыРегистрации;
	
	Если ЗначениеЗаполнено(ПараметрыРегистрации.Ссылка) Тогда
		ДокументОснование = ПараметрыРегистрации.Ссылка;
	Иначе
		ДокументОснование = ДополнительныеПараметры.Форма.Объект.Ссылка;
	КонецЕсли;
	
	ДанныеЗаявленияОВвозеТоваров = Новый Структура;
	ДанныеЗаявленияОВвозеТоваров.Вставить("ДокументОснование", ДокументОснование);
	ДанныеЗаявленияОВвозеТоваров.Вставить("Организация",       ПараметрыРегистрации.Организация);
	ДанныеЗаявленияОВвозеТоваров.Вставить("Контрагент",        ПараметрыРегистрации.Контрагент);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Основание", ДанныеЗаявленияОВвозеТоваров);
	ПараметрыФормы.Вставить("ДокументОснование", ПараметрыРегистрации.Ссылка);
	
	ОткрытьФорму("Документ.ЗаявлениеОВвозеТоваров.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
	
КонецПроцедуры

#КонецОбласти

#Область РегистрацияРучныхЗаписейКнигиПокупок

Процедура ВвестиЗаписьКнигиПокупок(Форма, ПараметрыРегистрации) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыРегистрации",  ПараметрыРегистрации);
	ДополнительныеПараметры.Вставить("Форма",                 Форма);
	
	Оповещение = Новый ОписаниеОповещения("ВвестиЗаписьКнигиПокупокЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПроверитьВозможностьСозданияДокументаНаОсновании(Форма, Оповещение);
	
КонецПроцедуры

Процедура ВвестиЗаписьКнигиПокупокЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да 
		И Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРегистрации = ДополнительныеПараметры.ПараметрыРегистрации;
	
	Если ЗначениеЗаполнено(ПараметрыРегистрации.Ссылка) Тогда
		ДокументОснование = ПараметрыРегистрации.Ссылка;
	Иначе
		ДокументОснование = ДополнительныеПараметры.Форма.Объект.Ссылка;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ДокументОснование);
	ОткрытьФорму("Документ.ЗаписьКнигиПокупок.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеСчетовФактурВыданных

Процедура ВвестиСчетФактуруВыданный(Форма, ПараметрыРегистрации) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыРегистрации",  ПараметрыРегистрации);
	ДополнительныеПараметры.Вставить("ОткрыватьСуществующую", Ложь);
	ДополнительныеПараметры.Вставить("Форма",                 Форма);
	
	Оповещение = Новый ОписаниеОповещения("ВвестиСчетФактуруВыданныйЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПроверитьВозможностьСозданияДокументаНаОсновании(Форма, Оповещение);
	
КонецПроцедуры

Процедура ВвестиСчетФактуруВыданныйЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да 
		И Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРегистрации = ДополнительныеПараметры.ПараметрыРегистрации;
		
	Если ЗначениеЗаполнено(ПараметрыРегистрации.Ссылка) Тогда
		ДокументОснование = ПараметрыРегистрации.Ссылка;
	Иначе
		ДокументОснование = ДополнительныеПараметры.Форма.Объект.Ссылка;
	КонецЕсли;
		
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДокументОснование", ДокументОснование);
	ПараметрыОткрытия.Вставить("Организация",       ПараметрыРегистрации.Организация);
	ПараметрыОткрытия.Вставить("Контрагент",        ПараметрыРегистрации.Контрагент);
	ПараметрыОткрытия.Вставить("Исправление",       ПараметрыРегистрации.ИсправлениеОшибок);
	ПараметрыОткрытия.Вставить("Корректировочный",  ПараметрыРегистрации.КорректировкаПоСогласованиюСторон);
	
	ПараметрыФормы = Новый Структура("Основание, ДокументОснование",ПараметрыОткрытия, ДокументОснование);
	ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКоманд

Процедура КорректировочныйСчетФактура(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	РеквизитыДляОбработки = УчетНДСУПСлужебныйВызовСервера.СтруктураРеквизитовДляОбработки(ПараметрКоманды);
	
	ЗначенияЗаполнения = Новый Структура;
	
	Если ТипЗнч(ПараметрКоманды)=Тип("ДокументСсылка.СчетФактураВыданный") Тогда
		ТипСчетФактуры = "Выданный";
	ИначеЕсли ТипЗнч(ПараметрКоманды)=Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		ТипСчетФактуры = "Полученный";
	ИначеЕсли ТипЗнч(ПараметрКоманды)=Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент") Тогда
		ТипСчетФактуры = "ПолученныйНалоговыйАгент";
	КонецЕсли;
	
	Если РеквизитыДляОбработки.Исправление Тогда
		
		ЗначенияЗаполнения.Вставить("Исправление", Истина);
		ЗначенияЗаполнения.Вставить("СчетФактураОснование", ПараметрКоманды);
		
	ИначеЕсли РеквизитыДляОбработки.Корректировочный Тогда
		
		Основания = РеквизитыДляОбработки.Основания;
		
		Если Основания.Количество() = 1 Тогда
			ЗначенияЗаполнения.Вставить("ДокументОснование", Основания[0]);
		Иначе
			ЗначенияЗаполнения.Вставить("ДокументОснование", Основания);
			ЗначенияЗаполнения.Вставить("Дата", РеквизитыДляОбработки.ДатаКорректировки);
		КонецЕсли;
		
		ЗначенияЗаполнения.Вставить("Корректировочный", Истина);
		
	Иначе
		
		Если ТипСчетФактуры="Выданный" Тогда
			ТекстОперации = НСтр("ru = 'Корректировка реализации';
								|en = 'Sale adjustment'");
		Иначе
			ТекстОперации = НСтр("ru = 'Корректировка приобретения';
								|en = 'Purchase adjustment'");
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru = 'Для выбранного документа уже введен корректировочный счет-фактура.
		|Чтобы ввести новую корректировку, необходимо создать документ ""%Операция%"".';
		|en = 'Corrective tax invoice is already entered for the selected document.
		|To enter new adjustment, create the ""%Операция%"" document.'");
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Операция%",ТекстОперации);
		
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.СчетФактура"+ТипСчетФактуры+".ФормаОбъекта",
			ПараметрыФормы,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

Процедура ИсправительныйСчетФактураВыданныйАванс(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Исправление", Истина);
	ЗначенияЗаполнения.Вставить("СчетФактураОснование", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.СчетФактураВыданныйАванс.ФормаОбъекта",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

Процедура ИсправительныйСчетФактураПолученныйАванс(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Исправление", Истина);
	ЗначенияЗаполнения.Вставить("СчетФактураОснование", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.СчетФактураПолученныйАванс.ФормаОбъекта",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

Процедура ИсправлениеПрочегоНачисленияНДС(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	
	ОткрытьФорму(
		"Документ.ЗаписьКнигиПродаж.Форма.ФормаДокумента",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

Процедура ТаможеннаяДекларацияЭкспортНаОсновании(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	//++ НЕ УТ
	ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаДокумента",
		Новый Структура("Основание", МассивСсылок));
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область ЗаявленияОВвозеТоваров

// Выводит печатную форму заявления о ввозе товаров из ЕАЭС.
//
// Параметры:
//  ОписаниеКоманды	 - Структура - структура с описанием команды.
// 
// Возвращаемое значение:
//  Неопределено - ничего не возвращается.
//
Функция ПечатьЗаявлениеОВвозеТоваров(ОписаниеКоманды) Экспорт

	ПараметрыПечати = ОбщегоНазначенияБПКлиент.ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") 
		И ПараметрыПечати <> Неопределено Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли;

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.ЗаявлениеОВвозеТоваров",
		"ЗаявлениеОВвозеТоваров",
		ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма,
		ПараметрыПечати);
	
КонецФункции
	
// Выводит печатную форму учета перемещения товаров документа "Заявление о ввозе товаров из ЕАЭС".
//
// Параметры:
//  ОписаниеКоманды	 - Структура - структура с описанием команды.
// 
// Возвращаемое значение:
//  Неопределено - ничего не возвращается.
//
Функция ПечатьСтатистическаяФормаУчетаПеремещенияТоваров(ОписаниеКоманды) Экспорт

	ПараметрыПечати = ОбщегоНазначенияБПКлиент.ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") 
		И ПараметрыПечати <> Неопределено Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли;

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.ЗаявлениеОВвозеТоваров",
		"СтатистическаяФормаУчетаПеремещенияТоваров",
		ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма,
		ПараметрыПечати);

КонецФункции
	
#КонецОбласти

#КонецОбласти