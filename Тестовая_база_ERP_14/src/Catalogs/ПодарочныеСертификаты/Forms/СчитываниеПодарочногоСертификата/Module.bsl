
#Область ОписаниеПеременных

&НаКлиенте
Перем СтэкСтраниц; // История переходов для возврата по кнопке назад

&НаКлиенте
Перем ДанныеСчитывателя; // Кэш данных считывателя магнитной карты

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ОсновнойТипКода = ПодарочныеСертификатыСервер.ПолучитьОсновнойТипКодаПодарочногоСертификата();
	
	Если ЗначениеЗаполнено(Параметры.КодКарты) Тогда
		
		// При считывании в форме списка было найдено несколько карт с данным кодом,
		// требуется предложить карты на выбор пользователю.
		Если  Параметры.ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод")
			И ТипЗнч(Параметры.КодКарты) = Тип("Массив") Тогда
			Предобработка = Истина;
		Иначе
			Предобработка = Ложь;
		КонецЕсли;
		
		Если Параметры.ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
			Если Предобработка Тогда
				Текст = НСтр("ru = 'Обнаружено несколько подарочных сертификатов, соответствующих считанному магнитному коду.
				                   |Выберите подходящую карту.';
				                   |en = 'Several gift certificates which correspond to the scanned magnetic code are detected.
				                   |Select a suitable card.'");
			Иначе
				Текст = НСтр("ru = 'Обнаружено несколько подарочных сертификатов с магнитным кодом %1.
				                   |Выберите подходящую карту.';
				                   |en = 'Several gift certificates with magnetic code %1 are detected.
				                   |Select a suitable card.'");
			КонецЕсли;
		Иначе
			Текст = НСтр("ru = 'Обнаружено несколько подарочных сертификатов со штрихкодом %1.
			                   |Выберите подходящую карту.';
			                   |en = 'Several gift certificates with barcode %1 are detected.
			                   |Select a suitable card.'");
		КонецЕсли;
		НадписьВыборПодарочногоСертификата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, Параметры.КодКарты);
		
		Результат = ПодарочныеСертификатыВызовСервера.ОбработатьПолученныйКодНаСервере(Параметры.КодКарты, Параметры.ТипКода, Предобработка);
		Для Каждого СтрокаТЧ Из Результат Цикл
			ЗаполнитьЗначенияСвойств(НайденныеПодарочныеСертификаты.Добавить(), СтрокаТЧ);
		КонецЦикла;
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборПодарочногоСертификата;
		
	Иначе
		
		Если ЗначениеЗаполнено(ОсновнойТипКода) Тогда
			ТипКода = ОсновнойТипКода;
			Элементы.ТипКода.Видимость = Ложь;
		Иначе
			ТипКода = Перечисления.ТипыКодовКарт.Штрихкод;
		КонецЕсли;
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеПодарочногоСертификата;
		
	КонецЕсли;
	
	Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазадОтсутствует;
	Элементы.СтраницыКнопкиДалее.ТекущаяСтраница = Элементы.СтраницыКнопкиДалее.ПодчиненныеЭлементы.КнопкаГотово;
	
	Если Не ЗначениеЗаполнено(ОсновнойТипКода) Тогда
		Текст = НСтр("ru = 'Считайте подарочный сертификат при помощи сканера штрихкода
		                   |(считывателя магнитных карт) или введите код вручную';
		                   |en = 'Read a gift certificate using the barcode scanner
		                   |(magnetic stripe card reader) or enter the barcode manually'");
	ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
		Текст = НСтр("ru = 'Считайте подарочный сертификат при помощи считывателя
		                   |магнитных карт или введите магнитный код вручную';
		                   |en = 'Read a gift certificate using the
		                   |magnetic stripe card reader or enter the magnetic code manually'");
	ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
		Текст = НСтр("ru = 'Считайте подарочный сертификат при помощи сканера
		                   |штрихкода или введите штрихкод вручную';
		                   |en = 'Read a gift certificate using the barcode
		                   |scanner or enter the barcode manually'");
	КонецЕсли;
	НадписьСчитываниеПодарочногоСертификата = Текст;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтэкСтраниц = Новый Массив;
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода,СчитывательМагнитныхКарт");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипКодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КодКартыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(КодКарты) Тогда
		ПодключитьОбработчикОжидания("ДалееОбработчикОжидания", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НайденныеПодарочныеСертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПодключитьОбработчикОжидания("ДалееОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Назад(Команда)
	
	Если СтэкСтраниц.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = СтэкСтраниц[СтэкСтраниц.Количество()-1];
	СтэкСтраниц.Удалить(СтэкСтраниц.Количество()-1);
	
	Если СтэкСтраниц.Количество() = 0 Тогда
		Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазадОтсутствует;
	КонецЕсли;
	
	Элементы.СтраницыКнопкиДалее.ТекущаяСтраница = Элементы.СтраницыКнопкиДалее.ПодчиненныеЭлементы.КнопкаГотово;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ОтключитьОбработчикОжидания("ДалееОбработчикОжидания");
	
	ОчиститьСообщения();
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеПодарочногоСертификата Тогда
		
		Если Не ЗначениеЗаполнено(КодКарты) Тогда
			
			Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
				ТекстСообщения = НСтр("ru = 'Штрихкод не заполнен.';
										|en = 'Barcode is not filled in.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Магнитный код не заполнен.';
										|en = 'Magnetic code is not filled in.'");
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"КодКарты");
			
			Возврат;
			
		КонецЕсли;
		
		ОбработатьПолученныйКодНаКлиенте(КодКарты, ТипКода);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборПодарочногоСертификата Тогда
		
		ТекущиеДанные = Элементы.НайденныеПодарочныеСертификаты.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ОбработатьВыборПодарочногоСертификата(ТекущиеДанные);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НайденныеПодарочныеСертификаты.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НайденныеПодарочныеСертификаты.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НайденныеПодарочныеСертификаты.АвтоматическаяРегистрацияПриПервомСчитывании");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет());
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если Элементы.Страницы.ТекущаяСтраница <> Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеПодарочногоСертификата Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	ОбработатьПолученныйКодНаКлиенте(МассивШтрихкодов[0].Штрихкод, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	Если Элементы.Страницы.ТекущаяСтраница <> Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеПодарочногоСертификата Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСчитывателя = Данные;
	ПодключитьОбработчикОжидания("ОбработатьПолученныйКодНаКлиентеВОбработкеОжидания", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ПерейтиНаСтраницу(Страница)
	
	СтэкСтраниц.Добавить(Элементы.Страницы.ТекущаяСтраница);
	Элементы.Страницы.ТекущаяСтраница = Страница;
	Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазад;
	
	Если Страница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборПодарочногоСертификата Тогда
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
			Текст = НСтр("ru = 'Обнаружено несколько подарочных сертификатов с магнитным кодом %1.
			                   |Выберите подходящую карту.';
			                   |en = 'Several gift certificates with magnetic code %1 are detected.
			                   |Select a suitable card.'");
		Иначе
			Текст = НСтр("ru = 'Обнаружено несколько подарочных сертификатов со штрихкодом %1.
			                   |Выберите подходящую карту.';
			                   |en = 'Several gift certificates with barcode %1 are detected.
			                   |Select a suitable card.'");
		КонецЕсли;
		НадписьВыборПодарочногоСертификата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КодКарты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиенте(Данные, ПолученныйТипКода)
	
	НайденныеПодарочныеСертификаты.Очистить();
	
	Если  ПолученныйТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод")
		И ТипЗнч(Данные) = Тип("Массив") Тогда
		
		Предобработка = Истина;
		КодКарты = Данные[0];
		
	Иначе
		
		Предобработка = Ложь;
		КодКарты = Данные;
		
	КонецЕсли;

	Результат = ПодарочныеСертификатыВызовСервера.ОбработатьПолученныйКодНаСервере(Данные, ПолученныйТипКода, Предобработка);
	Для Каждого СтрокаТЧ Из Результат Цикл
		ЗаполнитьЗначенияСвойств(НайденныеПодарочныеСертификаты.Добавить(), СтрокаТЧ);
	КонецЦикла;
	
	Если НайденныеПодарочныеСертификаты.Количество() = 0 Тогда
		
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			ТекстСообщения = НСтр("ru = 'Подарочный сертификат со штрихкодом ""%1"" не зарегистрирован.';
									|en = 'Gift certificate with the ""%1"" barcode is not registered.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Подарочный сертификат с магнитным кодом ""%1"" не зарегистрирован.';
									|en = 'Gift certificate with the ""%1"" magnetic code is not registered.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КодКарты),
			,
			"КодКарты");
		
		Возврат;
		
	КонецЕсли;
	
	Если НайденныеПодарочныеСертификаты.Количество() > 1 Тогда
		ПерейтиНаСтраницу(Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборПодарочногоСертификата);
		Текст = НСтр("ru = 'Обнаружено несколько подарочных сертификатов с кодом %1.
		                   |Выберите подходящий подарочный сертификат.';
		                   |en = 'Several gift certificates with code %1 are detected.
		                   |Select a suitable gift certificate.'");
		НадписьВыборПодарочногоСертификата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, КодКарты);
	ИначеЕсли НайденныеПодарочныеСертификаты.Количество() = 1 Тогда
		ОбработатьВыборПодарочногоСертификата(НайденныеПодарочныеСертификаты[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборПодарочногоСертификата(ТекущиеДанные)
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		
		Закрыть();
		Оповестить(
			"СчитанПодарочныйСертификат",
			Новый Структура("ПодарочныйСертификат, ФормаВладелец", ТекущиеДанные.Ссылка, ВладелецФормы.УникальныйИдентификатор),
			Неопределено);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Считан подарочный сертификат';
				|en = 'Gift certificate is read'"),
			ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Считан подарочный сертификат %1';
																		|en = 'Gift certificate %1 is read'"), ТекущиеДанные.Ссылка),
			БиблиотекаКартинок.Информация32);
		
	Иначе // Карта не зарегистрирована.
		
		СтруктураДанныхПодарочногоСертификата = ПодарочныеСертификатыВызовСервера.ИнициализироватьОписаниеПодарочногоСертификата();
		ЗаполнитьЗначенияСвойств(СтруктураДанныхПодарочногоСертификата, ТекущиеДанные);
		ТекущиеДанные.Ссылка = ПодарочныеСертификатыВызовСервера.ЗарегистрироватьПодарочныйСертификат(СтруктураДанныхПодарочногоСертификата);
		
		Закрыть();
		
		Оповестить(
			"Запись_ПодарочныйСертификат",
			Новый Структура,
			ТекущиеДанные.Ссылка);
		
		Оповестить(
			"СчитанПодарочныйСертификат",
			Новый Структура("ПодарочныйСертификат, ФормаВладелец", ТекущиеДанные.Ссылка, ВладелецФормы.УникальныйИдентификатор),
			Неопределено);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Считан подарочный сертификат';
				|en = 'Gift certificate is read'"),
			ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Считан подарочный сертификат %1';
																		|en = 'Gift certificate %1 is read'"), ТекущиеДанные.Ссылка),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиентеВОбработкеОжидания()
	ОбработатьПолученныйКодНаКлиенте(ДанныеСчитывателя, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод"));
КонецПроцедуры

&НаКлиенте
Процедура ДалееОбработчикОжидания()
	
	Далее(Команды["Далее"]);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
