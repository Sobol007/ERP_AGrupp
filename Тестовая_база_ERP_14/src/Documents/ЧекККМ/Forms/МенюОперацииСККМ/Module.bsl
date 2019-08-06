#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьФормуПослеЗавершенияОперации = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Документы.ЧекККМ.Форма.МенюОперацийСККМ", "ЗакрыватьФормуПослеЗавершенияОперации", Ложь);
	
	Кассир = Параметры.Кассир;
	ПраваДоступа = НастройкиПродажДляПользователейСервер.ПраваДоступаРМК(Кассир);
	
	КассаККМ = Параметры.КассаККМ;
	ПриИзмененииКассыККМ();
	
	НастроитьРМК();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если СохранятьНастройкиПриЗакрытии И НЕ ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗакрыватьФормуПослеЗавершенияОперацииПриИзменении(Элемент)
	СохранятьНастройкиПриЗакрытии = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьКассуККМ(Команда)
	
	Отбор = Новый Структура("Ссылка", ДоступныеКассыККМ);
	ПараметрыОткрытия = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму(
		"Справочник.КассыККМ.ФормаВыбора",
		ПараметрыОткрытия,,,,,
		Новый ОписаниеОповещения("ПослеИзмененияКассыККМ", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьКассовуюСмену(Команда)
	
	ОчиститьСообщения();
	
	РозничныеПродажиКлиент.ЗакрытьКассовуюСмену(
		ПараметрыКассыККМ,
		Новый ОписаниеОповещения("ПослеЗавершенияОперацииСКассовойСменой", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКассовуюСмену(Команда)
	
	ОчиститьСообщения();
	
	РозничныеПродажиКлиент.ОткрытьКассовуюСмену(
		ПараметрыКассыККМ,
		Новый ОписаниеОповещения("ПослеЗавершенияОперацииСКассовойСменой", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВнесениеДенежныхСредств(Команда)
	
	ОчиститьСообщения();
	
	РозничныеПродажиКлиент.ОбработатьСостояниеСмены(
		ЭтотОбъект,
		Новый ОписаниеОповещения("ВнесениеДенежныхСредствПослеОбработкиСостоянияСмены", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыемкаДенежныхСредств(Команда)
	
	ОчиститьСообщения();
	
	РозничныеПродажиКлиент.ОбработатьСостояниеСмены(
		ЭтотОбъект,
		Новый ОписаниеОповещения("ВыемкаДенежныхСредствПослеОбработкиСостоянияСмены", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДенежныйЯщик(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьОткрытиеДенежногоЯщика(
		Новый ОписаниеОповещения("ПослеЗавершенияОперацииОткрытияДенежногоЯщика", ЭтотОбъект),
		УникальныйИдентификатор,
		ПараметрыКассыККМ.ИдентификаторУстройства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовкиФормы(Форма)
	
	Форма.СтруктураСостояниеКассовойСмены = РозничныеПродажиВызовСервера.СостояниеКассовойСмены(Форма.КассаККМ);
	
	Форма.Элементы.ОткрытьКассовуюСмену.Доступность = Форма.ПраваДоступа.ОткрытьСмену И Не Форма.СтруктураСостояниеКассовойСмены.СменаОткрыта;
	Форма.Элементы.ЗакрытьКассовуюСмену.Доступность = Форма.ПраваДоступа.ЗакрытьСмену И    Форма.СтруктураСостояниеКассовойСмены.СменаОткрыта;
	
	Форма.Элементы.ВнесениеДенежныхСредств.Доступность = Форма.ПраваДоступа.ВнесениеДенег;
	Форма.Элементы.ВыемкаДенежныхСредств.Доступность   = Форма.ПраваДоступа.ВыемкаДенег;
	
	Форма.Элементы.ГруппаКассаККМ.Заголовок = Строка(Форма.КассаККМ);
	
	Если ЗначениеЗаполнено(Форма.СтруктураСостояниеКассовойСмены.СтатусКассовойСмены) Тогда
		
		ЗаголовокГруппыОперацииСКассовойСменой = НСтр("ru = 'Статус смены: %СтатусСмены% %ВремяИзменения%';
														|en = 'Shift status: %СтатусСмены% %ВремяИзменения%'");
		
		ЗаголовокГруппыОперацииСКассовойСменой = СтрЗаменить(ЗаголовокГруппыОперацииСКассовойСменой, "%СтатусСмены%", Форма.СтруктураСостояниеКассовойСмены.СтатусКассовойСмены);
		ЗаголовокГруппыОперацииСКассовойСменой = СтрЗаменить(ЗаголовокГруппыОперацииСКассовойСменой, "%ВремяИзменения%", Формат(Форма.СтруктураСостояниеКассовойСмены.ДатаИзмененияСтатуса,"ДФ='dd.MM.yy ЧЧ:мм'"));
		
	Иначе
		
		ЗаголовокГруппыОперацииСКассовойСменой = НСтр("ru = 'Смена не открыта';
														|en = 'Shift is not opened '");
		
	КонецЕсли;
	Форма.Элементы.ГруппаОперацииСКассовойСменой.Заголовок = ЗаголовокГруппыОперацииСКассовойСменой;
	
	ЗаголовокГруппыДенежныеОперации = НСтр("ru = 'В кассе %НаличностьВКассе% %Валюта%';
											|en = 'On cash account %НаличностьВКассе% %Валюта%'");
	
	перНаличностьВКассе = Формат(Форма.СтруктураСостояниеКассовойСмены.НаличностьВКассе, "ЧДЦ=2"); 	
	ЗаголовокГруппыДенежныеОперации = СтрЗаменить(ЗаголовокГруппыДенежныеОперации, "%НаличностьВКассе%", перНаличностьВКассе);
	ЗаголовокГруппыДенежныеОперации = СтрЗаменить(ЗаголовокГруппыДенежныеОперации, "%Валюта%", Форма.СтруктураСостояниеКассовойСмены.ВалютаПредставление);
	Форма.Элементы.ГруппаДенежныеОперации.Заголовок = ЗаголовокГруппыДенежныеОперации;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Документы.ЧекККМ.Форма.МенюОперацийСККМ", "ЗакрыватьФормуПослеЗавершенияОперации", ЗакрыватьФормуПослеЗавершенияОперации);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьРМК()
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
	РозничныеПродажи.ПодписатьГорячиеКлавишиНаКнопках(ЭтотОбъект);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|	И 1 В (ВЫБРАТЬ 1 ИЗ Справочник.НастройкиРМК.КассыККМ КАК Т ГДЕ Т.Ссылка.РабочееМесто = &РабочееМесто И Т.КассаККМ = КассыККМ.Ссылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|	И НЕ 1 В (ВЫБРАТЬ 1 ИЗ Справочник.НастройкиРМК КАК Т ГДЕ Т.РабочееМесто = &РабочееМесто)
	|");
	
	Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ДоступныеКассыККМ = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		ДоступныеКассыККМ.Добавить(Выборка.КассаККМ);
	КонецЦикла;
	
	Элементы.ИзменитьКассуККМ.Видимость = ДоступныеКассыККМ.Количество() > 1 И Параметры.ИзменитьКассуККМ;
	
	Элементы.ОткрытьДенежныйЯщик.Видимость = Не ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииКассыККМ()
	
	СтруктураСостояниеКассовойСмены = РозничныеПродажиВызовСервера.СостояниеКассовойСмены(КассаККМ);
	ПараметрыКассыККМ = Новый ФиксированнаяСтруктура(Справочники.КассыККМ.ПараметрыКассыККМ(КассаККМ));
	ОбновитьЗаголовкиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияОперацииОткрытияДенежногоЯщика(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда  
		ЗаголовокИнформации = НСтр("ru = 'При открытии денежного ящика возникла ошибка.';
									|en = 'An error occurred while opening the cash till'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияКассыККМ(ВыбраннаяКассаККМ, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ВыбраннаяКассаККМ) Тогда
		Возврат;
	КонецЕсли;
	
	КассаККМ = ВыбраннаяКассаККМ;
	
	ПриИзмененииКассыККМ();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьКассуККМЗавершение", ВладелецФормы);
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КассаККМ);
	
	Если ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияОперацииСКассовойСменой(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьЗаголовкиФормы(ЭтотОбъект);
	
	Если ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
	Оповестить("ИзменениеКассовойСмены");
	
КонецПроцедуры

&НаКлиенте
Процедура ВнесениеДенежныхСредствПослеОбработкиСостоянияСмены(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	РозничныеПродажиКлиент.ВнесениеДенежныхСредств(
		ЭтотОбъект,
		ПараметрыКассыККМ,
		Новый ОписаниеОповещения("ПослеВнесенияВыемкиДенежныхСредств", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыемкаДенежныхСредствПослеОбработкиСостоянияСмены(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	РозничныеПродажиКлиент.ВыемкаДенежныхСредств(
		ЭтотОбъект,
		ПараметрыКассыККМ,
		Новый ОписаниеОповещения("ПослеВнесенияВыемкиДенежныхСредств", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВнесенияВыемкиДенежныхСредств(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьЗаголовкиФормы(ЭтотОбъект);
	
	Если ЗакрыватьФормуПослеЗавершенияОперации Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти