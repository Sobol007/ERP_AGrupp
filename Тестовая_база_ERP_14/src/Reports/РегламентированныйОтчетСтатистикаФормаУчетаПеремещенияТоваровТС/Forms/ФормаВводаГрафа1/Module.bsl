
&НаКлиенте
Перем Оповестить;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОтправительИндекс 			  = Параметры.ОтправительИндекс;
	ОтправительНаименование       = Параметры.ОтправительНаименование;
	ОтправительНаселенныйПункт    = Параметры.ОтправительНаселенныйПункт;
	ОтправительОбласть 			  = Параметры.ОтправительОбласть;
	ОтправительРБ_УНП 			  = Параметры.ОтправительРБ_УНП;
	ОтправительРК_БИН 			  = Параметры.ОтправительРК_БИН;	
	ОтправительРК_ИИН 			  = Параметры.ОтправительРК_ИИН;
	ОтправительРФ_ИНН			  = Параметры.ОтправительРФ_ИНН;
	ОтправительРФ_КПП 			  = Параметры.ОтправительРФ_КПП;
	ОтправительРФ_ОГРН 			  = Параметры.ОтправительРФ_ОГРН;
	ОтправительСтранаКод 		  = Параметры.ОтправительСтранаКод;
	ОтправительСтранаНаименование = Параметры.ОтправительСтранаНаименование;
	ОтправительУлицаНомерДома     = Параметры.ОтправительУлицаНомерДома;
	
	Параметры.Свойство("ОтправительКГ_ИНН", ОтправительКГ_ИНН);
	Параметры.Свойство("ОтправительКГ_ОКПО", ОтправительКГ_ОКПО);
	Параметры.Свойство("ОтправительКодКГ", ОтправительКодКГ);
	Параметры.Свойство("ОтправительРА_Соц", ОтправительРА_Соц);
	Параметры.Свойство("ОтправительРА_УНН", ОтправительРА_УНН);
	
	Если Параметры.Свойство("Отправитель_ВидДокКод", Отправитель_ВидДокКод) Тогда 
		Параметры.Свойство("Отправитель_ВидДокНаим", Отправитель_ВидДокНаим);
		Параметры.Свойство("Отправитель_СерДок", Отправитель_СерДок);
		Параметры.Свойство("Отправитель_НомДок", Отправитель_НомДок);
		Параметры.Свойство("Отправитель_ДатаДок", Отправитель_ДатаДок);
		Параметры.Свойство("Отправитель_ОргДок", Отправитель_ОргДок);
		Параметры.Свойство("Отправитель_Тел", Отправитель_Тел);
		Параметры.Свойство("Отправитель_Факс", Отправитель_Факс);
		Параметры.Свойство("Отправитель_Телекс", Отправитель_Телекс);
		Параметры.Свойство("Отправитель_Почта", Отправитель_Почта);
	Иначе
		Элементы.Группа2.Видимость = Ложь;
	КонецЕсли;
	
	Параметры.Свойство("Отправитель_Форма", Отправитель_Форма);
	Элементы.Отправитель_Форма.Видимость = Параметры.Свойство("Отправитель_Форма") И ("RU" = ОтправительСтранаКод);
	Если Не Элементы.Отправитель_Форма.Видимость Тогда 
		Отправитель_Форма = Неопределено;
		Элементы.Отправитель_Форма.АвтоОтметкаНезаполненного = Неопределено;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	МассивРеквизитов = ПолучитьРеквизиты();
	Для Каждого Реквизит Из МассивРеквизитов Цикл
		Если Реквизит.Имя <> "СтруктураРеквизитов" И Реквизит.Имя <> "ВидыУдостЛичности" Тогда
			СтруктураРеквизитов.Вставить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановкаДляРФ = Ложь;
	УстановкаДляРБ = Ложь;
	УстановкаДляРК = Ложь;
	УстановкаДляАМ = Ложь;
	УстановкаДляКГ = Ложь;
	
	Если ВладелецФормы.СтруктураРеквизитовФормы.СтранаОтправления = "РФ" Тогда
	
		УстановкаДляРФ = Истина;
		ОтправительСтранаКод = "RU";
		ОтправительСтранаНаименование = "РОССИЯ";
		
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаОтправления = "РБ" Тогда
		
		УстановкаДляРБ = Истина;
		ОтправительСтранаКод = "BY";
		ОтправительСтранаНаименование = "БЕЛАРУСЬ";
		
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаОтправления = "РК" Тогда
		
		УстановкаДляРК = Истина;
		ОтправительСтранаКод = "KZ";
		ОтправительСтранаНаименование = "КАЗАХСТАН";
		
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаОтправления = "АМ" Тогда
		
		УстановкаДляАМ = Истина;
		ОтправительСтранаКод = "AM";
		ОтправительСтранаНаименование = "АРМЕНИЯ";
		
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаОтправления = "КГ" Тогда
		
		УстановкаДляКГ = Истина;
		ОтправительСтранаКод = "KG";
		ОтправительСтранаНаименование = "КЫРГЫЗСТАН";
	
	КонецЕсли; 
	
	Элементы.ОтправительРФ_ОГРН.Доступность = УстановкаДляРФ;
	Элементы.ОтправительРФ_ИНН.Доступность  = УстановкаДляРФ;
	Элементы.ОтправительРФ_КПП.Доступность  = УстановкаДляРФ;
	
	Элементы.ОтправительРБ_УНП.Доступность  = УстановкаДляРБ;
	
	Элементы.ОтправительРК_БИН.Доступность  = УстановкаДляРК;
	Элементы.ОтправительРК_ИИН.Доступность  = УстановкаДляРК;
	
	Элементы.ОтправительРА_Соц.Доступность  = УстановкаДляАМ;
	Элементы.ОтправительРА_УНН.Доступность  = УстановкаДляАМ;
	
	Элементы.ОтправительКГ_ИНН.Доступность = УстановкаДляКГ;
	Элементы.ОтправительКГ_ОКПО.Доступность = УстановкаДляКГ;
	Элементы.ОтправительКодКГ.Доступность = УстановкаДляКГ;
	
	Если Не УстановкаДляКГ Тогда 
		ОтправительКодКГ = Неопределено;
		Элементы.ОтправительКодКГ.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Россия.Видимость = УстановкаДляРФ;
	Элементы.Беларусь.Видимость = УстановкаДляРБ;
	Элементы.Казахстан.Видимость = УстановкаДляРК;
	Элементы.Армения.Видимость = УстановкаДляАМ;
	Элементы.Кыргызстан.Видимость = УстановкаДляКГ;
	
	Модифицированность = Ложь;
	Оповестить = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОКНажатие(Команда)
	    	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершениеПродолжение", ЭтотОбъект);
	ПрименитьИзменения(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
		
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены.
											|Перед завершением работы рекомендуется сохранить измененные данные,
											|иначе изменения будут утеряны.';
											|en = 'Данные были изменены.
											|Перед завершением работы рекомендуется сохранить измененные данные,
											|иначе изменения будут утеряны.'");
			
			Возврат;
		
		КонецЕсли;
		               		
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Применить изменения?';
							|en = 'Данные были изменены. Применить изменения?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,  РежимДиалогаВопрос.ДаНетОтмена);
						
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершениеПродолжение", ЭтотОбъект);
		ПрименитьИзменения(ОписаниеОповещения);
				
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершениеПродолжение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Истина Тогда
		
		Модифицированность = Ложь;
		Закрыть(СтруктураРеквизитов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПустуюСтруктуруРеквизитов() Экспорт
	
	ПустаяСтруктураРеквизитовФормы = Новый Структура;
		
	Для Каждого ЭлементФормы Из ЭтаФорма.Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
			Если ЗначениеЗаполнено(ЭлементФормы.ПутьКДанным) Тогда
				
				ПустаяСтруктураРеквизитовФормы.Вставить(ЭлементФормы.ПутьКДанным);
								
			КонецЕсли; 
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПустаяСтруктураРеквизитовФормы;
	
КонецФункции	

&НаКлиенте
Процедура ПрименитьИзменения(ВыполняемоеОповещение)
		
	РеквСтрокаСообщения	= "";
		
	Для Каждого РеквизитФормы Из СтруктураРеквизитов Цикл
						
		СтруктураРеквизитов[РеквизитФормы.Ключ] = ЭтаФорма[РеквизитФормы.Ключ];
								
		//Проверка на заполненность полей, обязательных к заполнению
		Если ТипЗнч(Элементы[РеквизитФормы.Ключ]) = Тип("ПолеФормы") Тогда
			Если Элементы[РеквизитФормы.Ключ].Доступность И Элементы[РеквизитФормы.Ключ].АвтоОтметкаНезаполненного = Истина Тогда
				Если НЕ ЗначениеЗаполнено(СтруктураРеквизитов[РеквизитФормы.Ключ]) Тогда
							
					ПредставлениеРекв = Элементы[РеквизитФормы.Ключ].Заголовок;
					РеквСтрокаСообщения = РеквСтрокаСообщения + ?(ПустаяСтрока(РеквСтрокаСообщения), "", "," + Символы.ПС) + """" + ПредставлениеРекв + """";
							 
				КонецЕсли;	
			КонецЕсли; 
		КонецЕсли;		
			
	КонецЦикла; 
	
	Если НЕ ПустаяСтрока(РеквСтрокаСообщения) Тогда 
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не заполнены поля, обязательные к заполнению: %1 %1%2. %1 %1 Продолжить редактирование ?';
																					|en = 'Не заполнены поля, обязательные к заполнению: %1 %1%2. %1 %1 Продолжить редактирование ?'"), Символы.ПС, РеквСтрокаСообщения);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПрименитьИзмененияЗавершение", ЭтотОбъект, ВыполняемоеОповещение);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;		

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьИзмененияЗавершение(Ответ, ВыполняемоеОповещение) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправительНаименованиеПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительИндексПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительОбластьПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительНаселенныйПунктПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительУлицаНомерДомаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительРФ_ИННПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительРФ_КПППриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительРФ_ОГРНПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительРБ_УНППриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительРК_ИИНПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительРК_БИНПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

// Обработка выбора адресной информации из справочников
//
&НаКлиенте
Процедура ОтправительНаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИмяСправочникаДляВыбора = "Контрагенты";
	Если ВладелецФормы.СтруктураРеквизитовФормы.НапрПеремещения = "ЭК" Тогда
			ИмяСправочникаДляВыбора = "Организации";
	КонецЕсли;
	Если НЕ ВладелецФормы.СуществуетСправочник(ИмяСправочникаДляВыбора) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранноеЗначение = Неопределено;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправительНаименованиеНачалоВыбораЗавершение", ЭтотОбъект);
	ВладелецФормы.ПолучитьСведенияИзСправочника(Элемент.ТекстРедактирования, ИмяСправочникаДляВыбора, ВыбранноеЗначение, ОписаниеОповещения);
	
	УстановитьДанныеКонтрагента(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеКонтрагента(ВыбранноеЗначение)
	Попытка
		ЮрАддр = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ВыбранноеЗначение, Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента, ТекущаяДатаСеанса(), Ложь);
		Если ЮрАддр.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		ЗначениеПолей = ЮрАддр[0].Значение;
		СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(ЗначениеПолей);
		Если ВРег(СведенияОбАдресе.Страна) = "РОССИЯ" Тогда 
			Возврат;
		КонецЕсли;
		ОтправительОбласть = РаботаСАдресами.РегионАдресаКонтактнойИнформации(ЗначениеПолей);
		ОтправительУлицаНомерДома = СведенияОбАдресе.Улица;
		ОтправительНаселенныйПункт = ?(ЗначениеЗаполнено(СведенияОбАдресе.НаселенныйПункт), СведенияОбАдресе.НаселенныйПункт, ОтправительОбласть);
		ОтправительИндекс = СведенияОбАдресе.Индекс;
		ОтправительУлицаНомерДома = ОтправительУлицаНомерДома + ", " + СведенияОбАдресе.Здание.Номер;
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ОтправительНаименованиеНачалоВыбораЗавершение(СтруктураВозврата, ДополнительныеПараметры) Экспорт 
	
	СтруктураСведений = СтруктураВозврата.СтруктураСведений;
	ВыбранноеЗначение = СтруктураВозврата.ВыбранноеЗначение;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураАдреса = ВладелецФормы.АдресВФормате9ЗапятыхВСтруктуруПорталаТСНаКлиенте(СтруктураСведений.Адрес);
	
	ОтправительНаименование = СтруктураСведений.Наименование;
	
	ОтправительИндекс =  СтруктураАдреса.Индекс;
	ОтправительОбласть = СтруктураАдреса.Область;
	ОтправительНаселенныйПункт = СтруктураАдреса.НаселенныйПункт;
	ОтправительУлицаНомерДома = СтруктураАдреса.УлицаНомерДома; 
	
	Если ВладелецФормы.СтруктураРеквизитовФормы.СтранаОтправления = "РФ" Тогда
		ОтправительРФ_ИНН  = СтруктураСведений.ИНН;
		ОтправительРФ_КПП  = СтруктураСведений.КПП;
		ОтправительРФ_ОГРН = СтруктураСведений.ОГРН;
		СтруктураСведений.Свойство("ОргПравФорм", Отправитель_Форма);
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаОтправления = "РБ" Тогда
		ОтправительРБ_УНП  = СтруктураСведений.ИНН;
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаОтправления = "РК" Тогда	
	    ОтправительРК_ИИН  = СтруктураСведений.ИНН;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Отправитель_ВидДокКодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",                      "Выберите документ, удостоверяющий личность");
	ПараметрыФормы.Вставить("ТаблицаЗначений",                ВидыУдостЛичности);
	ПараметрыФормы.Вставить("СтруктураДляПоиска",             Новый Структура("Кратко", Отправитель_ВидДокНаим));
	ПараметрыФормы.Вставить("НаимКолонкиНазвание",            "Наименование");
	ПараметрыФормы.Вставить("ВключитьВидимостьКолонкиКратко", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборДокументаЗавершение", ЭтотОбъект);

	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ВыборДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Отправитель_ВидДокКод = Прав("00" + Результат["Код"], 2);
		Отправитель_ВидДокНаим = ВРег(Результат["Кратко"]);
	КонецЕсли;
КонецПроцедуры
