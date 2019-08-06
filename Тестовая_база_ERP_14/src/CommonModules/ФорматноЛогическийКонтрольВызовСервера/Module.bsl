
#Область ПрограммныйИнтерфейс    

// Выполняет проверку обязательности заполняет тэгов
// 
// Параметры:
//  Параметры - Структура анализируемых параметров.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование Устройство, фискализируещее чек
//  ОписаниеОшибки - Строка, описание ошибки для возврата в случае нахождения ошибки
//
// Возвращаемое значение:
//  Булево, Истина когда обязательные данные консистентны
Функция ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов(Параметры, ИдентификаторУстройства, ОписаниеОшибки) Экспорт
	
	// Определение типа устройства.
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ИдентификаторУстройства);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если НЕ Выборка.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
			Возврат Истина;
		КонецЕсли;
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Не выбрано устройство';
								|en = 'Device is not selected'");
		Возврат Ложь;
	КонецЕсли;
	
	СтруктураДанныхФорматноЛогическогоКонтроля = СтруктураДанныхФорматноЛогическогоКонтроля(ИдентификаторУстройства);
	
	Параметры.Вставить("ФорматФД", СтруктураДанныхФорматноЛогическогоКонтроля.ФорматФД);
	
	МассивФФД = МассивПроверяемыхФорматовФД(СтруктураДанныхФорматноЛогическогоКонтроля.ФорматФД);
	
	СоответствиеРеквизитов = Новый Соответствие;
	ПроверяемыеРеквизиты = ПроверяемыеРеквизиты(МассивФФД, СоответствиеРеквизитов);
	ЗаполнитьРеквизитовИзРегистрационныхДанных(Параметры, ПроверяемыеРеквизиты.РеквизитыЗаполняемыеИзРегистрационныхДанных, ИдентификаторУстройства);
	
	Если НЕ ЗаполненыРеквизитыШапки(Параметры, ПроверяемыеРеквизиты.РеквизитыШапки, ОписаниеОшибки, СоответствиеРеквизитов) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗаполненыРеквизитыПозицийЧека(Параметры.ПозицииЧека, ПроверяемыеРеквизиты.РеквизитыПозицийЧека, ОписаниеОшибки, СоответствиеРеквизитов) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПроверитьРеквизитыОплаты(Параметры.ТаблицаОплат, ОписаниеОшибки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Дополнительные условия проверки
	
	// Соответствие сумм товарных позиций и сумм оплаты.
	СуммаПозицийЧека = 0;
	СуммаВсехОплат   = 0;
	СуммаОплатыНаличными = 0;
	
	Для Каждого ПозицияЧека Из Параметры.ПозицииЧека Цикл
		Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
			СуммаПозицийЧека = СуммаПозицийЧека + ПозицияЧека.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементаОплаты Из Параметры.ТаблицаОплат Цикл
		СуммаВсехОплат = СуммаВсехОплат + ЭлементаОплаты.Сумма;
		Если ЭлементаОплаты.ТипОплаты = Перечисления.ТипыОплатыККТ.Наличные Тогда
			СуммаОплатыНаличными = СуммаОплатыНаличными + ЭлементаОплаты.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	Если СуммаПозицийЧека > СуммаВсехОплат Тогда
		ОписаниеОшибки = НСтр("ru = 'Сумма товарных позиций больше суммы оплат';
								|en = 'Goods item amount is greater than the payment amount'"); 
		Возврат Ложь;
	ИначеЕсли СуммаВсехОплат > СуммаПозицийЧека Тогда
		Если (СуммаВсехОплат - СуммаОплатыНаличными) > СуммаПозицийЧека Тогда
			ОписаниеОшибки = НСтр("ru = 'Сумма безналичных оплат больше суммы товарных позиций';
									|en = 'Electronic payment amount exceeds the goods item amount'"); 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Электронный чек
	Электронно = Ложь;
	Параметры.Свойство("Электронно", Электронно);
	
	Отправляет1СEmail = Ложь;
	Параметры.Свойство("Отправляет1СEmail", Отправляет1СEmail);
	
	Отправляет1СSMS = Ложь;
	Параметры.Свойство("Отправляет1СSMS", Отправляет1СSMS);
	
	ПокупательEmail = Ложь;
	Параметры.Свойство("ПокупательEmail", ПокупательEmail);
	
	ПокупательНомер = Ложь;
	Параметры.Свойство("ПокупательНомер", ПокупательНомер);
	
	Если Электронно = Истина 
		И НЕ ЗначениеЗаполнено(ПокупательEmail) 
		И НЕ ЗначениеЗаполнено(ПокупательНомер) Тогда
		ОписаниеОшибки = НСтр("ru = 'Для электронного чека нужно указать либо Email, либо телефон.';
								|en = 'Specify email or phone number for electronic receipt.'") ;
		Возврат Ложь;
	КонецЕсли;
	
	Если Электронно = Истина И Отправляет1СEmail = Истина Тогда
		ОписаниеОшибки = НСтр("ru = 'Чек обязательно должен быть напечатан';
								|en = 'Receipt must be printed'") ;
		Возврат Ложь;
	КонецЕсли;
	
	Если Электронно = Истина И Отправляет1СSMS = Истина Тогда
		ОписаниеОшибки = НСтр("ru = 'Чек обязательно должен быть напечатан';
								|en = 'Receipt must be printed'") ;
		Возврат Ложь;
	КонецЕсли;
	
	Если Отправляет1СEmail = Истина 
		И НЕ ЗначениеЗаполнено(ПокупательEmail) Тогда
		ОписаниеОшибки = НСтр("ru = 'Не заполнен E-mail';
								|en = 'Email is not filled in'") ;
		Возврат Ложь;
	КонецЕсли;
	
	Если Отправляет1СSMS = Истина 
		И НЕ ЗначениеЗаполнено(ПокупательНомер) Тогда
		ОписаниеОшибки = НСтр("ru = 'Не заполнен номер телефона';
								|en = 'Phone number is not entered'") ;
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Параметры.КассирИНН) Тогда
		Если НЕ МенеджерОборудованияКлиентСервер.ИННСоответствуетТребованиям(Параметры.КассирИНН, Ложь, ОписаниеОшибки) Тогда
			Сообщение = НСтр("ru = 'ИНН кассира некорректен (%Ошибка%)';
							|en = 'Cashier TIN is incorrect (%Error%)'");
			ОписаниеОшибки = СтрЗаменить(Сообщение, "%Ошибка%", ОписаниеОшибки);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Реквизиты платежного агента.
	ПризнакАгента = Перечисления.ПризнакиАгента.ПустаяСсылка();
	Если Параметры.Свойство("ПризнакАгента", ПризнакАгента) 
		И ЗначениеЗаполнено(ПризнакАгента) Тогда
		Если НЕ Параметры.Свойство("ДанныеАгента") Тогда
			ОписаниеОшибки = НСтр("ru = 'Не заданы данные платежного агента';
									|en = 'Paying agent data is not specified'");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Электронно = Истина 
		И Отправляет1СEmail = Ложь 
		И Отправляет1СSMS = Ложь Тогда
		// Чек оправляется электронно средствами ОФД
		Если ЗначениеЗаполнено(ПокупательEmail) И ЗначениеЗаполнено(ПокупательНомер) Тогда
			ОписаниеОшибки = НСтр("ru = 'У электронного чека заполнены как номер телефона, так и e-mail. ОФД не сможет передать данный чек электронно.';
									|en = 'Phone number and email of electronic receipt are filled in. FDO cannot send this receipt in electronic form. '");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	НомерПозиции = 0;
	
	Для Каждого ПозицияЧека Из Параметры.ПозицииЧека Цикл
		Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
			НомерПозиции = НомерПозиции + 1;
			НомерПозицииСтрока = Формат(НомерПозиции, "ЧГ=0");
			
			ПризнакАгентаПоПредметуРасчета = Перечисления.ПризнакиАгента.ПустаяСсылка();
			Если ПозицияЧека.Свойство("ПризнакАгентаПоПредметуРасчета", ПризнакАгентаПоПредметуРасчета) И ЗначениеЗаполнено(ПризнакАгентаПоПредметуРасчета) Тогда
				Если ПозицияЧека.Свойство("ДанныеПоставщика") И ПозицияЧека.ДанныеПоставщика.Свойство("ИНН")
					И ПустаяСтрока(ПозицияЧека.ДанныеПоставщика.ИНН) Тогда
						ОписаниеОшибки = НСтр("ru = 'ИНН поставщика для предмета расчета в строке №%Позиция% не указан.';
												|en = 'Supplier TIN for settlement subject in line No. %Позиция% is not specified.'") ;
						ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
					Возврат Ложь;
				КонецЕсли;
			КонецЕсли;
			
			// Реквизиты платежного агента по предмету расчета
			Если ЗначениеЗаполнено(ПризнакАгента) Тогда
				Если ПозицияЧека.Свойство("ПризнакАгентаПоПредметуРасчета", ПризнакАгентаПоПредметуРасчета) 
					И ЗначениеЗаполнено(ПризнакАгентаПоПредметуРасчета) Тогда
					Если НЕ ПризнакАгента = ПризнакАгентаПоПредметуРасчета Тогда
						// Тег 1222 должен быть равен тегу 1057
						ОписаниеОшибки = НСтр("ru = 'Признак платежного агента в шапке не совпадает с признаком платежного агента по предмету расчета в строке №%Позиция%.';
												|en = 'Paying agent characteristic in the header does not match paying agent characteristic by settlement subject in line No. %Позиция%.'");
						ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
						Возврат Ложь;
					КонецЕсли;
					Если ПозицияЧека.Свойство("ДанныеАгента") Тогда
						Если Параметры.ДанныеАгента.Свойство("ОператорПеревода")
							И ПозицияЧека.ДанныеАгента.Свойство("ОператорПеревода") Тогда
							ЗначениеПараметров = Неопределено;
							ЗначениеПозицииЧека = Неопределено;
							Если Параметры.ДанныеАгента.ОператорПеревода.Свойство("Адрес", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Адрес", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Адрес оператора перевода в строке №%Позиция% не равен адресу оператора перевода в шапке.';
														|en = 'Transfer operator address in line No. %Позиция% is not the same as the transfer operator address in the header.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
							Если Параметры.ДанныеАгента.ОператорПеревода.Свойство("ИНН", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("ИНН", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'ИНН оператора перевода в строке №%Позиция% не равен ИНН оператора перевода в шапке.';
														|en = 'Transfer operator TIN in line No. %Позиция% is not the same as the transfer operator TIN in the header.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
							Если Параметры.ДанныеАгента.ОператорПеревода.Свойство("Наименование", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Наименование", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Наименование оператора перевода в строке №%Позиция% не равно наименованию оператора перевода в шапке.';
														|en = 'Transfer operator name in line No. %Позиция% is not the same as the transfer operator name in the header.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
							Если Параметры.ДанныеАгента.ОператорПеревода.Свойство("Телефон", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПеревода.Свойство("Телефон", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Телефон оператора перевода в строке №%Позиция% не равен телефон оператора перевода в шапке.';
														|en = 'Transfer operator phone in line No. %Позиция% is not the same as the transfer operator phone in the header.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
						КонецЕсли;
						Если ПозицияЧека.ДанныеАгента.Свойство("ОператорПоПриемуПлатежей") Тогда
							Если Параметры.ДанныеАгента.ОператорПоПриемуПлатежей.Свойство("Телефон", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ОператорПоПриемуПлатежей.Свойство("Телефон", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Телефон оператора по приему платежей в строке №%Позиция% не равен телефон оператора приему платежей в шапке.';
														|en = 'Payment processor phone in line No. %Позиция% is not the same as payment processor phone in the header.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
						КонецЕсли;
						Если ПозицияЧека.ДанныеАгента.Свойство("ПлатежныйАгент") Тогда
							Если Параметры.ДанныеАгента.ПлатежныйАгент.Свойство("Операция", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Свойство("Операция", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Операция платежного агента в строке №%Позиция% не равна операции оператора платежного агента в шапке.';
														|en = 'Paying agent transaction in line No. %Позиция% is not the same as the transaction of the paying agent operator in the header.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
							
							Если Параметры.ДанныеАгента.ПлатежныйАгент.Свойство("Телефон", ЗначениеПараметров)
								И ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Свойство("Телефон", ЗначениеПозицииЧека) 
								И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
								ОписаниеОшибки = НСтр("ru = 'Телефон платежного агента в строке №%Позиция% не равен телефон оператора платежного агента в шапке.';
														|en = 'Paying agent phone in line No. %Позиция% is not the same as the paying agent phone in the header.'") ;
								ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
								Возврат Ложь;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
					
					Если ПозицияЧека.Свойство("ДанныеПоставщика") Тогда
						Если Параметры.ДанныеПоставщика.Свойство("ИНН", ЗначениеПараметров)
							И ПозицияЧека.ДанныеПоставщика.Свойство("ИНН", ЗначениеПозицииЧека) 
							И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
							ОписаниеОшибки = НСтр("ru = 'ИНН поставщика в строке №%Позиция% не равен ИНН поставщика в шапке.';
													|en = 'Supplier TIN in line No. %Позиция% is not the same as the supplier TIN in the header.'") ;
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
							Возврат Ложь;
						КонецЕсли;
						Если Параметры.ДанныеПоставщика.Свойство("Наименование", ЗначениеПараметров)
							И ПозицияЧека.ДанныеПоставщика.Свойство("Наименование", ЗначениеПозицииЧека) 
							И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
							ОписаниеОшибки = НСтр("ru = 'Наименование поставщика в строке №%Позиция% не равно наименованию поставщика в шапке.';
													|en = 'Supplier name in line No. %Позиция% is not the same as the supplier name in the header.'") ;
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
							Возврат Ложь;
						КонецЕсли;
						Если Параметры.ДанныеПоставщика.Свойство("Телефон", ЗначениеПараметров)
							И ПозицияЧека.ДанныеПоставщика.Свойство("Телефон", ЗначениеПозицииЧека) 
							И НЕ ЗначениеПараметров = ЗначениеПозицииЧека Тогда
							ОписаниеОшибки = НСтр("ru = 'Телефон поставщика в строке №%Позиция% не равен телефон поставщика в шапке.';
													|en = 'Supplier phone in line No. %Позиция% is not the same as the supplier phone in the header.'") ;
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%", НомерПозицииСтрока);
							Возврат Ложь;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если СтруктураДанныхФорматноЛогическогоКонтроля.ФорматФД = "1.0" Тогда
		
		Если СтруктураДанныхФорматноЛогическогоКонтроля.ВыводитьПризнакСпособаРасчета Тогда
			Параметры.Вставить("ВыводитьПризнакСпособаРасчета");
		КонецЕсли;
		
		Если СтруктураДанныхФорматноЛогическогоКонтроля.ВыводитьПризнакПредметаРасчета Тогда
			Параметры.Вставить("ВыводитьПризнакПредметаРасчета");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Выполняет коррекцию заполнения тэгов
// 
// Параметры:
//  Параметры - Структура анализируемых параметров.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование Устройство, фискализируещее чек
//  ОписаниеОшибки - Строка, описание ошибки для возврата в случае нахождения ошибки
//
Процедура ВыполненитьКоррекциюЗаполненияТэгов(Параметры, ИдентификаторУстройства, ОписаниеОшибки) Экспорт
	
	Электронно = Ложь;
	Параметры.Свойство("Электронно", Электронно);
	
	Отправляет1СEmail = Ложь;
	Параметры.Свойство("Отправляет1СEmail", Отправляет1СEmail);
	
	Отправляет1СSMS = Ложь;
	Параметры.Свойство("Отправляет1СSMS", Отправляет1СSMS);
	
	Если Отправляет1СEmail Или Отправляет1СSMS Тогда 
		Параметры.Электронно = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Структура данных форматно-логического контроля
//
// Параметры:
//  ПодключаемоеОборудование - СправочникСсылка.ПодключаемоеОборудование\
//
// Возвращаемое значение:
//  Структура
Функция СтруктураДанныхФорматноЛогическогоКонтроля(ПодключаемоеОборудование) Экспорт
	
	ФорматФД = "1.0";
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("ВыводитьПризнакСпособаРасчета"                  , Ложь);
	ВозвращаемаяСтруктура.Вставить("ВыводитьПризнакПредметаРасчета"                 , Ложь);
	ВозвращаемаяСтруктура.Вставить("СпособФорматноЛогическогоКонтроля"               , Неопределено);
	ВозвращаемаяСтруктура.Вставить("ДопустимоеРасхождениеФорматноЛогическогоКонтроля", 0.01);
	ВозвращаемаяСтруктура.Вставить("ФорматФД", ФорматФД);
	
	СтандартнаяОбработка = Истина;
	ФорматноЛогическийКонтрольКлиентСерверПереопределяемый.ПолучитьСтруктуруДанныхФорматноЛогическогоКонтроля(ПодключаемоеОборудование, ВозвращаемаяСтруктура, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.ДопустимоеРасхождениеФорматноЛогическогоКонтроля КАК ДопустимоеРасхождениеФорматноЛогическогоКонтроля,
	|	ПодключаемоеОборудование.СпособФорматноЛогическогоКонтроля КАК СпособФорматноЛогическогоКонтроля,
	|	ПодключаемоеОборудование.ВыводитьПризнакСпособаРасчета КАК ВыводитьПризнакСпособаРасчета,
	|	ПодключаемоеОборудование.ВыводитьПризнакПредметаРасчета КАК ВыводитьПризнакПредметаРасчета
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ПодключаемоеОборудование);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ВозвращаемаяСтруктура.ВыводитьПризнакСпособаРасчета    = Выборка.ВыводитьПризнакСпособаРасчета;
		ВозвращаемаяСтруктура.ВыводитьПризнакПредметаРасчета   = Выборка.ВыводитьПризнакПредметаРасчета;
		ВозвращаемаяСтруктура.СпособФорматноЛогическогоКонтроля = Выборка.СпособФорматноЛогическогоКонтроля;
		ВозвращаемаяСтруктура.ДопустимоеРасхождениеФорматноЛогическогоКонтроля = Выборка.ДопустимоеРасхождениеФорматноЛогическогоКонтроля;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПодключаемоеОборудованиеПараметрыРегистрации.ЗначениеПараметра КАК ЗначениеПараметра
	|ИЗ
	|	Справочник.ПодключаемоеОборудование.ПараметрыРегистрации КАК ПодключаемоеОборудованиеПараметрыРегистрации
	|ГДЕ
	|	ПодключаемоеОборудованиеПараметрыРегистрации.Ссылка = &Ссылка
	|	И ПодключаемоеОборудованиеПараметрыРегистрации.НаименованиеПараметра = &НаименованиеПараметра";
	
	Запрос.УстановитьПараметр("Ссылка", ПодключаемоеОборудование);
	Запрос.УстановитьПараметр("НаименованиеПараметра", "ВерсияФФДККТ");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ФорматФД = Выборка.ЗначениеПараметра;
	КонецЕсли;
	
	ВозвращаемаяСтруктура.Вставить("ФорматФД", ФорматФД);
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

// Процедура приводит к формату согласованному с ФНС.
// Для старта преобразования данных нужно
//
//  Параметры:
//    ОсновныеПараметры - см. МенеджерОборудованияКлиентСервер.ПараметрыОперацииФискализацииЧека
//    Отказ - Булево
//    ОписаниеОшибки - Строка
//
Процедура ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры) Экспорт
	
	ФорматноЛогическийКонтрольКлиентСервер.ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Все существующие форматы ФД, упорядоченные по возрастанию
// 
// Возвращаемое значение
//  Массив
//
Функция ПолныйМассивФорматовФД()
	
	ПолныйМассив = Новый Массив;
	ПолныйМассив.Добавить("1.0");
	ПолныйМассив.Добавить("1.0.5");
	ПолныйМассив.Добавить("1.1");
	
	Возврат ПолныйМассив;
КонецФункции 

// Массив проверяемых форматов ФД
// 
// Параметры:
//  ФорматФД - Строка
// 
// Возвращаемое значение
//  Массив
//
Функция МассивПроверяемыхФорматовФД(ФорматФД)
	
	ПолныйМассив = ПолныйМассивФорматовФД();
	
	ВозвращаемыйМассив = Новый Массив;
	
	Для Каждого ЭлементМассива Из ПолныйМассив Цикл
		
		ВозвращаемыйМассив.Добавить(ЭлементМассива);
		Если ЭлементМассива = ФорматФД Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемыйМассив;
КонецФункции

// Структуру из двух массивов: реквизиты шапки и реквизиты позиций чека
// 
// Параметры
//  МассивФФД - Массив проверяемых ФФД
//  СоответствиеРеквизитов - соответствие проверяемых реквизитов и их текстового представления в ошибке
// 
// Возвращаемое значение:
//  Структура;
//
Функция ПроверяемыеРеквизиты(МассивФФД, СоответствиеРеквизитов)
	
	ПроверяемыеРеквизиты = Новый Структура;
	ПроверяемыеРеквизиты.Вставить("РеквизитыШапки", ПроверяемыеРеквизитыШапки(МассивФФД, СоответствиеРеквизитов));
	ПроверяемыеРеквизиты.Вставить("РеквизитыПозицийЧека", ПроверяемыеРеквизитыПозицийЧека(МассивФФД, СоответствиеРеквизитов));
	ПроверяемыеРеквизиты.Вставить("РеквизитыЗаполняемыеИзРегистрационныхДанных", РеквизитыЗаполняемыеИзРегистрационныхДанных(МассивФФД));
	
	Возврат ПроверяемыеРеквизиты;
	
КонецФункции

//Массив проверяемых реквизитов шапки
// 
// Параметры
//  МассивФФД - Массив проверяемых ФФД
//  СоответствиеРеквизитов - соответствие проверяемых реквизитов и их текстового представления в ошибке
// 
// Возвращаемое значение:
//  Массив;
//
Функция ПроверяемыеРеквизитыШапки(МассивФФД, СоответствиеРеквизитов)
	
	МассивРеквизитов = Новый Массив;
	
	Для Каждого ФорматФД Из МассивФФД Цикл
		
		Если ФорматФД = "1.0" Тогда
			МассивРеквизитов.Добавить("ОрганизацияНазвание"); // тег 1048
			СоответствиеРеквизитов.Вставить("ОрганизацияНазвание", НСтр("ru = 'Наименование организации';
																		|en = 'Company name'"));
			
			МассивРеквизитов.Добавить("ОрганизацияИНН"); // тег 1018
			СоответствиеРеквизитов.Вставить("ОрганизацияИНН", НСтр("ru = 'ИНН организации';
																	|en = 'Company TIN'"));
			
			МассивРеквизитов.Добавить("ТипРасчета"); // тег 1054
			СоответствиеРеквизитов.Вставить("ТипРасчета", НСтр("ru = 'Тип расчета';
																|en = 'Calculation type'"));
			
			МассивРеквизитов.Добавить("СистемаНалогообложения"); // тег 1055
			СоответствиеРеквизитов.Вставить("СистемаНалогообложения", НСтр("ru = 'Система налогообложения';
																			|en = 'Taxation system'"));
			
			МассивРеквизитов.Добавить("Кассир"); // тег 1021
			СоответствиеРеквизитов.Вставить("Кассир", НСтр("ru = 'Кассир';
															|en = 'Cashier'"));
			
			МассивРеквизитов.Добавить("ПозицииЧека"); // тег 1059
			СоответствиеРеквизитов.Вставить("ПозицииЧека", НСтр("ru = 'Позиции чека';
																|en = 'Receipt positions'"));
			
			МассивРеквизитов.Добавить("ТаблицаОплат"); // теги 1020, 1031, 1081, 1215, 1216, 1217
			СоответствиеРеквизитов.Вставить("ТаблицаОплат", НСтр("ru = 'Оплата';
																|en = 'Payment'"));
			
		ИначеЕсли ФорматФД = "1.0.5" Тогда
			
		ИначеЕсли ФорматФД = "1.1" Тогда
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивРеквизитов;
	
КонецФункции

//Массив проверяемых реквизитов позиций чека
// 
// Параметры
//  МассивФФД - Массив проверяемых ФФД
//  СоответствиеРеквизитов - соответствие проверяемых реквизитов и их текстового представления в ошибке
// 
// Возвращаемое значение:
//  Массив;
//
Функция ПроверяемыеРеквизитыПозицийЧека(МассивФФД, СоответствиеРеквизитов)
	
	МассивРеквизитов = Новый Массив;
	
	Для Каждого ФорматФД Из МассивФФД Цикл
		Если ФорматФД = "1.0" Тогда
			
		МассивРеквизитов.Добавить("Количество"); // тег 1023
		СоответствиеРеквизитов.Вставить("Количество", НСтр("ru = 'Количество';
															|en = 'Quantity'"));
			
		МассивРеквизитов.Добавить("СтавкаНДС"); // тег 1199
		СоответствиеРеквизитов.Вставить("СтавкаНДС", НСтр("ru = 'Ставка НДС';
															|en = 'VAT rate'"));
		
		ИначеЕсли ФорматФД = "1.0.5" Тогда
			
		ИначеЕсли ФорматФД = "1.1" Тогда
			МассивРеквизитов.Добавить("ПризнакПредметаРасчета"); // тег 1212
			СоответствиеРеквизитов.Вставить("ПризнакПредметаРасчета", НСтр("ru = 'Признак предмета расчета';
																			|en = 'Settlement subject flag'"));
			
			МассивРеквизитов.Добавить("ПризнакСпособаРасчета"); // тег 1214
			СоответствиеРеквизитов.Вставить("ПризнакСпособаРасчета", НСтр("ru = 'Признак способа расчета';
																			|en = 'Shows calculation method'"));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивРеквизитов;
	
КонецФункции

//Массив реквизитов заполняемые из регистрационных данных
// 
// Параметры
//  МассивФФД - Массив проверяемых ФФД
// 
// Возвращаемое значение:
//  Массив;
//
Функция РеквизитыЗаполняемыеИзРегистрационныхДанных(МассивФФД)
	
	МассивРеквизитов = Новый Массив;
	
	Для Каждого ФорматФД Из МассивФФД Цикл
		Если ФорматФД = "1.0" Тогда
			МассивРеквизитов.Добавить("АдресРасчетов"); // тег 1009
		ИначеЕсли ФорматФД = "1.0.5" Тогда
			МассивРеквизитов.Добавить("МестоРасчетов"); // тег 1187
		ИначеЕсли ФорматФД = "1.1" Тогда
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивРеквизитов;
	
КонецФункции

// Проверка заполненности реквизитов шапки
// 
// Параметры:
//  ВходящиеДанные - структура данных чека
//  МассивРеквизитов - массив имен реквизитов
//  ОписаниеОшибки - Строка, заполняемая в случае ошибки
//  СоответствиеРеквизитов - соответствие проверяемых реквизитов и их текстового представления в ошибке
// 
// Возвращаемое значение
//  Булево
//
Функция ЗаполненыРеквизитыШапки(ВходящиеДанные, МассивРеквизитов, ОписаниеОшибки, СоответствиеРеквизитов)
Перем ЗначениеДанных;
	
	Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
		Если ВходящиеДанные.Свойство(ИмяРеквизита, ЗначениеДанных) Тогда
			Если НЕ ЗначениеЗаполнено(ЗначениеДанных) Тогда
				ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
				ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" не заполнен.';
										|en = '""%Реквизит%"" tag is required.'");
				ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
				Возврат Ложь;
			КонецЕсли;
		Иначе
			ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
			ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" отсутствует.';
									|en = '""%Реквизит%"" tag is missing.'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

// Проверка заполненности реквизитов позиций чека
// 
// Параметры:
//  ПозицииЧека - Массив структур позиций чека
//  МассивРеквизитов - массив имен реквизитов
//  ОписаниеОшибки - Строка, заполняемая в случае ошибки
//  СоответствиеРеквизитов - соответствие проверяемых реквизитов и их текстового представления в ошибке
// 
// Возвращаемое значение
//  Булево
//
Функция ЗаполненыРеквизитыПозицийЧека(ПозицииЧека, МассивРеквизитов, ОписаниеОшибки, СоответствиеРеквизитов)
Перем ЗначениеДанных;

	НДС18 = Ложь;
	НДС20 = Ложь;
	
	НомерПозиции = 0;
	Для Каждого ПозицияЧека Из ПозицииЧека Цикл
		
		Если ПозицияЧека.Свойство("ФискальнаяСтрока") Тогда
			НомерПозиции = НомерПозиции + 1;
			НомерПозицииСтрока = Формат(НомерПозиции, "ЧГ=0");
			Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
				Если ПозицияЧека.Свойство(ИмяРеквизита, ЗначениеДанных) Тогда
					Если ИмяРеквизита = "СтавкаНДС" Тогда
						Если ЗначениеДанных = НСтр("ru = 'не указана';
													|en = 'not specified'") Тогда
							ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
							ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" в строке №%Позиция% не заполнен.';
													|en = '""%Реквизит%"" tag in line No. %Позиция% is required.'");
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
							ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%" , НомерПозицииСтрока);
							Возврат Ложь;
						ИначеЕсли ЗначениеДанных = 18 Или ЗначениеДанных = 118 Тогда 
							НДС18 = Истина;
						ИначеЕсли ЗначениеДанных = 20 Или ЗначениеДанных = 120 Тогда 
							НДС20 = Истина;
						КонецЕсли;
					ИначеЕсли НЕ ЗначениеЗаполнено(ЗначениеДанных) Тогда
						ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
						ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" в строке №%Позиция% не заполнен.';
												|en = '""%Реквизит%"" tag in line No. %Позиция% is required.'");
						ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
						ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%" , НомерПозицииСтрока);
						Возврат Ложь;
					КонецЕсли;
				Иначе
					ИмяРеквизитаВОшибку = СоответствиеРеквизитов[ИмяРеквизита];
					ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" в строке №%Позиция% отсутствует.';
											|en = '""%Реквизит%"" tag in line No. %Позиция% is missing.'");
					ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", ИмяРеквизитаВОшибку);
					ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Позиция%" , НомерПозицииСтрока);
					Возврат Ложь;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если НДС18 И НДС20 Тогда
		ОписаниеОшибки = НСтр("ru = 'Ставки НДС 20% и НДС 18% в одном чеке не допустимы.';
								|en = 'VAT rate 20% and VAT rate 18% are not allowed in the same receipt.'");
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Проверка заполненности реквизитов таблицы оплат
// 
// Параметры:
//  ТаблицаОплат - Массив структур таблицы оплаты
//  ОписаниеОшибки - Строка, заполняемая в случае ошибки
// 
// Возвращаемое значение
//  Булево
//
Функция ПроверитьРеквизитыОплаты(ТаблицаОплат, ОписаниеОшибки)
	
	НомерПозиции = 0;
	Для Каждого Оплата Из ТаблицаОплат Цикл
		Если НЕ ЗначениеЗаполнено(Оплата.ТипОплаты) Тогда
			ОписаниеОшибки = НСтр("ru = 'Тэг ""%Реквизит%"" не заполнен.';
									|en = '""%Реквизит%"" tag is required.'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Реквизит%", НСтр("ru = 'Тип оплаты';
																			|en = 'Payment type'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат Истина;
	
КонецФункции

// Заполняет реквизиты из регистрационных данных
//
// Параметры:
//  ВходящиеДанные - структура данных чека
//  МассивРеквизитов - массив имен реквизитов
//
Процедура ЗаполнитьРеквизитовИзРегистрационныхДанных(ВходящиеДанные, МассивРеквизитов, Идентификатор)
Перем ПараметрыРегистрацииУстройства, ЗначениеДанных;
	
	МассивНеЗаполненныхРеквизитов = Новый Массив;
	Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
		Если ВходящиеДанные.Свойство(ИмяРеквизита, ЗначениеДанных) Тогда
			Если НЕ ЗначениеЗаполнено(ЗначениеДанных) Тогда
				МассивНеЗаполненныхРеквизитов.Добавить(ИмяРеквизита);
			КонецЕсли;
		Иначе
			МассивНеЗаполненныхРеквизитов.Добавить(ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивНеЗаполненныхРеквизитов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРегистрацииУстройства = МенеджерОборудованияВызовСервера.ПолучитьПараметрыРегистрацииУстройства(Идентификатор);
	
	Для Каждого ИмяРеквизита Из МассивНеЗаполненныхРеквизитов Цикл
		Если ИмяРеквизита = "АдресРасчетов" Тогда
			ВходящиеДанные.Вставить(ИмяРеквизита, ПараметрыРегистрацииУстройства.АдресПроведенияРасчетов);
		ИначеЕсли ИмяРеквизита = "МестоРасчетов" Тогда
			ВходящиеДанные.Вставить(ИмяРеквизита, ПараметрыРегистрацииУстройства.МестоПроведенияРасчетов);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
 
#КонецОбласти