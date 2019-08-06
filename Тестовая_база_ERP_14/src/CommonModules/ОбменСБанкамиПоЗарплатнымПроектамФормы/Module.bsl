////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен с банками по зарплатным проектам".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру пояснения для номера лицевого счета.
//
// Параметры:
//		ФизическоеЛицо      - СправочникСсылка.ФизическиеЛица    - владелец лицевого счета.
//		ЗарплатныйПроект    - СправочникСсылка.ЗарплатныеПроекты - зарплатный проект.
//		НомерЛицевогоСчета  - Строка - проверяемый номер лицевого счета.
//		ЛицевыеСчета        - РегистрСведенийМенеджерЗаписи.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам - лицевой счет.
//		ЛицевыеСчетаПрежняя - Структура - предыдущее состояние лицевого счета.
//		ПерсонализироватьСообщение - Булево - признак необходимости упоминания владельца в сообщении проверки.
//
// Возвращаемое значение:
//		Структура:
//			* СообщенияПроверки - Строка     - текст сообщения проверки номера лицевого счета. 
//			* Картинка          - Картинка   - может принимать значения "Предупреждение" и "ОперацияВыполненаУспешно".
//			* ТекстНадписи      - Строка     - текст, который будет показан пользователю на форме.
//			* ЭлементЦветТекста - ЦветаСтиля - цвет текста надписи.
//			* ВведенДокументом  - Булево     - Истина, если лицевой счет введен документом подтверждения из банка.
//
Функция СтруктураПоясненияКНомеруЛицевогоСчета(ФизическоеЛицо, ЗарплатныйПроект, НомерЛицевогоСчета, ЛицевыеСчета, ЛицевыеСчетаПрежняя, ПерсонализироватьСообщение = Истина) Экспорт
	
	ИспользоватьЭОИСБанком = ОбменСБанкамиПоЗарплатнымПроектам.ИспользоватьЭОИСБанком(ЗарплатныйПроект);
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить(
		"СообщениеПроверки",
		?(ИспользоватьЭОИСБанком,
			СообщениеПроверкиНомераЛицевогоСчетаНаСоответствиеТребованиям(ФизическоеЛицо, ЗарплатныйПроект, НомерЛицевогоСчета, ПерсонализироватьСообщение),
			""));
	
	СтруктураЛицевыеСчета = Новый Структура;
	Для Каждого ЭлементСтруктуры Из ЛицевыеСчетаПрежняя Цикл
		СтруктураЛицевыеСчета.Вставить(ЭлементСтруктуры.Ключ, ЛицевыеСчета[ЭлементСтруктуры.Ключ]);
	КонецЦикла;
	СтруктураЛицевыеСчета = Новый ФиксированнаяСтруктура(СтруктураЛицевыеСчета);
	
	РезультатПроверки.Вставить(
		"ЗначениеЛСИзменено",
		Не ОбщегоНазначения.КоллекцииИдентичны(
			ЛицевыеСчетаПрежняя,
			СтруктураЛицевыеСчета));
	
	ЛСУказанПравильно = ?(ПустаяСтрока(РезультатПроверки.СообщениеПроверки), Истина, Ложь);
	
	СообщенияПроверки = ?(ПустаяСтрока(РезультатПроверки.СообщениеПроверки) И ИспользоватьЭОИСБанком,
			НСтр("ru = 'Номер лицевого счета указан правильно';
				|en = 'Account number is correct'"), РезультатПроверки.СообщениеПроверки);
	
	ВведенДокументом = Ложь;
	ТекстНадписи = "";
	Если Не ИспользоватьЭОИСБанком Тогда
		Картинка = Новый Картинка;
		ЭлементЦветТекста = ЦветаСтиля.ЦветТекстаПоля;
	Иначе
		Если ЛСУказанПравильно Или (Не РезультатПроверки.ЗначениеЛСИзменено И ЗначениеЗаполнено(ЛицевыеСчета.ДокументОснование)) Тогда
			Картинка = БиблиотекаКартинок.ОперацияВыполненаУспешно;
			Если Не РезультатПроверки.ЗначениеЛСИзменено И ЗначениеЗаполнено(ЛицевыеСчета.ДокументОснование) Тогда
				ПредставлениеДокумента = Новый ФорматированнаяСтрока(
					Строка(ЛицевыеСчета.ДокументОснование), , , , ПолучитьНавигационнуюСсылку(ЛицевыеСчета.ДокументОснование));
				ТекстНадписи = Новый ФорматированнаяСтрока(НСтр("ru = 'Номер лицевого счета введен документом (см.';
																|en = 'Account number is entered by document (see'") + " ", ПредставлениеДокумента, ")");
				ВведенДокументом = Истина;
			КонецЕсли;
			ЭлементЦветТекста = ЦветаСтиля.ЦветТекстаПоля;
		Иначе
			Картинка = БиблиотекаКартинок.Предупреждение;
			ТекстНадписи = НСтр("ru = 'Предупреждение';
								|en = 'Warning'");
			ЭлементЦветТекста = ЦветаСтиля.РезультатПредупреждениеЦвет;
		КонецЕсли;
	КонецЕсли;
	
	СтруктураПояснения = Новый Структура;
	СтруктураПояснения.Вставить("СообщенияПроверки", СообщенияПроверки);
	СтруктураПояснения.Вставить("Картинка", Картинка);
	СтруктураПояснения.Вставить("ТекстНадписи", ТекстНадписи);
	СтруктураПояснения.Вставить("ЭлементЦветТекста", ЭлементЦветТекста);
	СтруктураПояснения.Вставить("ВведенДокументом", ВведенДокументом);
	
	Возврат СтруктураПояснения;
	
КонецФункции

// Возвращает признак изменения лицевого счета зарплатного проекта в форме.
//
// Параметры:
//		Форма - УправляемаяФорма - должна содержать реквизиты:
//			* ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам - РегистрСведенийМенеджерЗаписи.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.       
//			* ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя - Структура       
//
// Возвращаемое значение:
//		Булево - признак изменения записи о лицевом счете
//
Функция ЗаписьЛицевыеСчетаСотрудниковПоЗарплатнымПроектамИзменена(Форма) Экспорт
	
	КоллекцииРазличны = Ложь;
	Для Каждого ОписаниеЭлемента Из Форма.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя Цикл
		
		КлючСтруктуры = ОписаниеЭлемента.Ключ;
		
		Если Не ЗначениеЗаполнено(Форма.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам[КлючСтруктуры])
			И Не ЗначениеЗаполнено(Форма.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя[КлючСтруктуры]) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если Форма.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам[КлючСтруктуры] <> Форма.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя[КлючСтруктуры] Тогда
			
			КоллекцииРазличны = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КоллекцииРазличны;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает сообщение об ошибке в номере лицевого счета сотрудника,
// если номер лицевого счета не соответствует стандарту.
//
// Параметры:
//		ФизическоеЛицо - Физическое лицо, чей лицевой счет проверяется.
//		НомерЛицевогоСчета - Строка, номер лицевого счета сотрудника.
//		ЗарплатныйПроект - зарплатный проект, в котором открыт лицевой счет.
//
Функция СообщениеПроверкиНомераЛицевогоСчетаНаСоответствиеТребованиям(ФизическоеЛицо, ЗарплатныйПроект, Знач НомерЛицевогоСчета, ПерсонализироватьСообщение = Истина)
	
	Если Не ЗначениеЗаполнено(ЗарплатныйПроект) Тогда
		ТекстОшибки = НСтр("ru = 'Не указан зарплатный проект.';
							|en = 'Payroll card program not specified.'");
		Возврат ТекстОшибки;
	КонецЕсли;
	
	Если СтрДлина(СокрЛП(НомерЛицевогоСчета)) <> 20 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерЛицевогоСчета) Тогда
		
		Если ПерсонализироватьСообщение Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У сотрудника %1 неверный номер лицевого счета (%2), он должен содержать 20 цифр.';
						|en = 'Incorrect account number of employee %1 (%2). The number must contain 20 digits.'"),
					ФизическоеЛицо,
					СокрЛП(НомерЛицевогоСчета));
			
		Иначе
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неверный номер лицевого счета (%1), он должен содержать 20 цифр.';
						|en = 'Incorrect personal account number (%1). The number must contain 20 digits.'"),
					СокрЛП(НомерЛицевогоСчета));
			
		КонецЕсли;
		
		Возврат ТекстОшибки;
		
	КонецЕсли;
	
	СоответствиеСимволов = Новый Соответствие;
	// латиница
	СоответствиеСимволов.Вставить("A", 0);
	СоответствиеСимволов.Вставить("B", 1);
	СоответствиеСимволов.Вставить("C", 2);
	СоответствиеСимволов.Вставить("E", 3);
	СоответствиеСимволов.Вставить("H", 4);
	СоответствиеСимволов.Вставить("K", 5);
	СоответствиеСимволов.Вставить("M", 6);
	СоответствиеСимволов.Вставить("P", 7);
	СоответствиеСимволов.Вставить("T", 8);
	СоответствиеСимволов.Вставить("X", 9);
	
	ШестойРазряд = Сред(НомерЛицевогоСчета, 6, 1);
	Если СоответствиеСимволов[ШестойРазряд] <> Неопределено Тогда
		НомерЛицевогоСчета = Лев(НомерЛицевогоСчета, 5) + СоответствиеСимволов[ШестойРазряд] + Сред(НомерЛицевогоСчета, 7);
	КонецЕсли;
	
	БИК = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗарплатныйПроект, "Банк.Код");
	Если БИК = Null Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не указан банк в зарплатном проекте ""%1"".';
					|en = 'Bank is not specified in the ""%1"" payroll card program.'"),
				ЗарплатныйПроект);
		Возврат ТекстОшибки;
	КонецЕсли;
	
	УсловныйНомер = Прав(БИК, 3);
	Если УсловныйНомер = "000" Или УсловныйНомер = "001" Или УсловныйНомер = "002" Тогда
		// Это БИК РКЦ
		УсловныйНомер = "0" + Сред(БИК, 5, 2);
	КонецЕсли;
	
	МассивВесовыхКоэффициентов = Новый Массив;
	МассивВесовыхКоэффициентов.Добавить(7);
	МассивВесовыхКоэффициентов.Добавить(1);
	МассивВесовыхКоэффициентов.Добавить(3);
	
	Коэффициент = 0;
	СуммаМладшихРазрядов = 0;
	Для Шаг = 1 По 3 Цикл
		
		ЦифраРазряда = Число(Сред(УсловныйНомер, Шаг, 1));
		
		Произведение = ЦифраРазряда * МассивВесовыхКоэффициентов.Получить(Коэффициент);
		МладшийРазряд = Произведение - Цел(Произведение/10)*10;
		СуммаМладшихРазрядов = СуммаМладшихРазрядов + МладшийРазряд;
		
		Коэффициент = Коэффициент + 1;
		Если Коэффициент = 3 Тогда
			Коэффициент = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Шаг = 1 По МИН(СтрДлина(НомерЛицевогоСчета), 20) Цикл
		
		ЦифраРазряда = Число(Сред(НомерЛицевогоСчета, Шаг, 1));
		
		Произведение = ЦифраРазряда * МассивВесовыхКоэффициентов.Получить(Коэффициент);
		МладшийРазряд = Произведение - Цел(Произведение/10)*10;
		СуммаМладшихРазрядов = СуммаМладшихРазрядов + МладшийРазряд;
		
		Коэффициент = Коэффициент + 1;
		Если Коэффициент = 3 Тогда
			Коэффициент = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СуммаМладшихРазрядов <> Цел(СуммаМладшихРазрядов/10)*10 Тогда
		
		Если ПерсонализироватьСообщение Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У сотрудника %1 указан неверный номер лицевого счета (%2), либо указан неверный БИК банка.
					|Возможно, лицевой счет открывался в другом отделении банка.';
					|en = 'Employee %1 has an incorrect account number (%2), or BIC code of the bank is incorrect.
					|The account might have been opened in another bank branch.'"),
				ФизическоеЛицо,
				СокрЛП(НомерЛицевогоСчета));
			
		Иначе
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Указан неверный номер лицевого счета (%1), либо указан неверный БИК банка.
					|Возможно, лицевой счет открывался в другом отделении банка.';
					|en = 'Account number (%1) or bank branch ID is incorrect.
					|The account might have been opened in another bank branch.'"),
				СокрЛП(НомерЛицевогоСчета));
			
		КонецЕсли;
		
		Возврат ТекстОшибки;
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти
