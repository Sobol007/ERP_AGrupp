
#Область ОбработчикиСобытийФормы

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма, ОргДатаРегистрации)
	
	ВидПериода = ВидПериодаОтчета(Форма, ОргДатаРегистрации);
	
	Если ВидПериода <> "Стандартный" Тогда
		СтрПериодОтчета = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=dd.MM.yyyy")
			+ " - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'");
	Иначе
		Если Месяц(Форма.мДатаКонцаПериодаОтчета) = 1 Тогда
			СтрПериодОтчета = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'") + " г.";
		Иначе
			СтрПериодОтчета = "Январь - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'") + " г.";
		КонецЕсли;
	КонецЕсли;
	
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		Форма.Элементы.ПолеРедакцияФормы.Видимость    = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
	Иначе
		Форма.Элементы.ПолеРедакцияФормы.Видимость    = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
	// В РезультирующаяТаблица - действующие на выбранный период формы.
	// Заполним список выбора форм отчетности.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг));
	Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВидПериодаОтчета(Форма, ОргДатаРегистрации)
	
	ДатаРегистрации = НачалоДня(ОргДатаРегистрации);
	ДатаРасширенногоПериода = Дата(Год(Форма.мДатаКонцаПериодаОтчета) - 1, 10, 1);
	ДатаНачалаОбычногоПериода = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
	Если (ДатаРегистрации > ДатаНачалаОбычногоПериода И ДатаРегистрации < Форма.мДатаКонцаПериодаОтчета) Тогда
		Возврат "Сокращенный";
	ИначеЕсли Форма.СпособСозданияОрганизации = 0
		И (ДатаРегистрации >= ДатаРасширенногоПериода И ДатаРегистрации < ДатаНачалаОбычногоПериода) Тогда
		Возврат "Расширенный";
	Иначе
		Возврат "Стандартный";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОткорректироватьНачальныйПериод(ВыбОрганизация)
	
	ПредставляетсяЗаГод = (ТекущаяДатаСеанса() >= '2013-01-01');
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) ИЛИ НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		Если ПредставляетсяЗаГод Тогда
			мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(КонецГода(ТекущаяДатаСеанса()), -12));
		Иначе
			мДатаКонцаПериодаОтчета = КонецКвартала(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		КонецЕсли;
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	ДатаРегистрации = НачалоДня(ВыбОрганизация.ДатаРегистрации);
	РасширятьПериод = (ДатаРегистрации >= Дата(Год(ДатаРегистрации), 10, 1) И СпособСозданияОрганизации <> 1);
	
	Если мДатаКонцаПериодаОтчета < ДатаРегистрации Тогда
		// Период предшествует дате регистрации.
		Если РасширятьПериод Тогда
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(ДатаРегистрации, 12));
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(НачалоГода(ДобавитьМесяц(ДатаРегистрации, 12)));
			КонецЕсли;
		Иначе
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДатаРегистрации);
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(ДатаРегистрации);
			КонецЕсли;
		КонецЕсли;
		мДатаНачалаПериодаОтчета = ДатаРегистрации;
	ИначеЕсли мДатаНачалаПериодаОтчета <= ДатаРегистрации И ДатаРегистрации <= мДатаКонцаПериодаОтчета Тогда
		// Период содержит дату регистрации.
		Если РасширятьПериод Тогда
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(ДатаРегистрации, 12));
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(НачалоГода(ДобавитьМесяц(ДатаРегистрации, 12)));
			КонецЕсли;
		КонецЕсли;
		мДатаНачалаПериодаОтчета = ДатаРегистрации;
	Иначе
		// Период следует за датой регистрации.
		Если РасширятьПериод Тогда
			ДатаРасширенногоПериода = Дата(Год(мДатаКонцаПериодаОтчета) - 1, 10, 1);
			Если ДатаРегистрации >= ДатаРасширенногоПериода Тогда
				мДатаНачалаПериодаОтчета = ДатаРегистрации;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКнопокПериода(Форма, ОргДатаРегистрации);
	
	ВидПериода = ВидПериодаОтчета(Форма, ОргДатаРегистрации);
	
	Если ВидПериода = "Расширенный" Тогда
		Если Месяц(Форма.мДатаКонцаПериодаОтчета) = 1 Тогда
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Ложь;
		Иначе
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
		КонецЕсли;
	ИначеЕсли ВидПериода = "Сокращенный" Тогда
		Если КонецМесяца(Форма.мДатаКонцаПериодаОтчета) <= КонецМесяца(Форма.мДатаНачалаПериодаОтчета) Тогда
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Ложь;
		Иначе
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
		КонецЕсли;
	Иначе
		Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ДатаКонцаПериодаОтчетаОригинала = Неопределено;
	Если ЗначениеЗаполнено(мСкопированаФорма) Тогда
		Если мСохраненныйДок <> Неопределено Тогда
			ДатаКонцаПериодаОтчетаОригинала = мДатаКонцаПериодаОтчета;
		КонецЕсли;
	КонецЕсли;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		
		Организация = ОргПоУмолчанию;
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
		
	КонецЕсли;
	
	ОрганизацияДатаРегистрации = ДатаРегистрацииОрганизации(Организация);
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	Если мДатаКонцаПериодаОтчета <> Неопределено Тогда
		ИзменитьПериод(ЭтаФорма, 0);
	КонецЕсли;
	
	ОткорректироватьНачальныйПериод(Организация);
	
	ПоказатьПериод(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтаФорма);
	
	УстановитьДоступностьКнопокПериода(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьДоступностьФлажкаБалансаНКО(ЭтаФорма);
	Если БалансНекоммерческойОрганизации Тогда
		ПереключательНКО = 1;
	Иначе
		ПереключательНКО = 0;
	КонецЕсли;
	ВосстановитьНастройкиНКО(Организация);
	
	// Вычислим общую часть ссылки на ИзмененияЗаконодательства.
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "http://v8.1c.ru/lawmonitor/lawchanges.jsp?";
	СпрРеглОтчетов = Справочники.РегламентированныеОтчеты;
	НайденнаяСсылка = СпрРеглОтчетов.НайтиПоРеквизиту("ИсточникОтчета", ИсточникОтчета);
	
	Если НайденнаяСсылка = СпрРеглОтчетов.ПустаяСсылка() Тогда
		
		ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "";
		
	Иначе
		
		УИДОтчета = НайденнаяСсылка.УИДОтчета;
		
		Фильтр1 = "regReportForm=" + УИДОтчета;
		Фильтр2 = "regReportOnly=true";
		УИДКонфигурации = "";
		РегламентированнаяОтчетностьПереопределяемый.ПолучитьУИДКонфигурации(УИДКонфигурации);
		Фильтр3 = "userConfiguration=" + УИДКонфигурации;
		
		ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства +
		                                                Фильтр1 + "&" + Фильтр2 + "&" + Фильтр3;
		
	КонецЕсли;
	
	ПолеСсылкаИзмененияЗаконодательства = "Изменения законодательства";
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
		
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		
		МодульОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
			ЭтаФорма,
			"БП.Отчет.РегламентированныйОтчетБухОтчетность",
			"ОсновнаяФорма",
			,
			НСтр("ru = 'Новости: Бухгалтерская отчетность';
				|en = 'Новости: Бухгалтерская отчетность'"),
			Ложь,
			Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Ложь),
			ИдентификаторыСобытийПриОткрытии);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	
	СтрРедакцияФормы = ПолеРедакцияФормы;
	// Ищем в таблице мТаблицаФормОтчета для определения выбранной формы отчета.
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);
	
	Если МассивСтрок.Количество() > 0 Тогда
		ВыбраннаяФорма = МассивСтрок[0];
		// Присваиваем.
		мВыбраннаяФорма     = ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок = ВыбраннаяФорма.ОписаниеОтчета;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, -1);
	
	ВидПериода = ВидПериодаОтчета(ЭтаФорма, ОрганизацияДатаРегистрации);
	Если ВидПериода <> "Стандартный" Тогда
		мДатаНачалаПериодаОтчета = ОрганизацияДатаРегистрации;
	КонецЕсли;
	
	ПоказатьПериод(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтаФорма);
	УстановитьДоступностьКнопокПериода(ЭтаФорма, ОрганизацияДатаРегистрации);
	УстановитьДоступностьФлажкаБалансаНКО(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, 1);
	
	ВидПериода = ВидПериодаОтчета(ЭтаФорма, ОрганизацияДатаРегистрации);
	Если ВидПериода <> "Стандартный" Тогда
		мДатаНачалаПериодаОтчета = ОрганизацияДатаРегистрации;
	КонецЕсли;
	
	ПоказатьПериод(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтаФорма);
	УстановитьДоступностьКнопокПериода(ЭтаФорма, ОрганизацияДатаРегистрации);
	УстановитьДоступностьФлажкаБалансаНКО(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопирован.
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма
			ИЛИ (ДатаКонцаПериодаОтчетаОригинала <> Неопределено
			И ((ДатаКонцаПериодаОтчетаОригинала < '2015-01-01' И мДатаКонцаПериодаОтчета >= '2015-01-01')
			ИЛИ (ДатаКонцаПериодаОтчетаОригинала >= '2015-01-01' И мДатаКонцаПериодаОтчета < '2015-01-01')
			ИЛИ (ДатаКонцаПериодаОтчетаОригинала < '2018-01-01' И мДатаКонцаПериодаОтчета >= '2018-01-01')
			ИЛИ (ДатаКонцаПериодаОтчетаОригинала >= '2018-01-01' И мДатаКонцаПериодаОтчета < '2018-01-01'))) Тогда
			
			ПоказатьПредупреждение(,НСтр("ru = 'Форма отчета изменилась, копирование невозможно!';
										|en = 'Форма отчета изменилась, копирование невозможно!'"));
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1';
				|en = '%1'"), РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());
		
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	// Открываем форму - есть смысл сохранить настойки НКО для текущей организации
	СохранитьНастройкиНКО(Организация);
	
	НачатьЗамерВремени();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
		РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ПараметрыФормы.Вставить("СпособСозданияОрганизации",
		?(СпособСозданияОрганизации = 1, "Реорганизация", "ВновьСозданная"));
	ПараметрыФормы.Вставить("ДатаСозданияОрганизации", НачалоДня(ОрганизацияДатаРегистрации));
	
	Если РеализованБалансНКО(ЭтаФорма) Тогда
		ПараметрыФормы.Вставить("ЭтоБалансНекоммерческойОрганизации", БалансНекоммерческойОрганизации);
	КонецЕсли;
	
	Форма = ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Если мВыбраннаяФорма = "ФормаОтчета2011Кв4" Тогда
		Форма.ОткрытьУведомление();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьФлажкаБалансаНКО(Форма)
	
	Если Форма.мСохраненныйДок = Неопределено Тогда
		
		Если РеализованБалансНКО(Форма) Тогда
			Форма.Элементы.ПереключательНКО.Доступность = Истина;
		Иначе
			Форма.БалансНекоммерческойОрганизации = Ложь;
			Форма.ПереключательНКО = 0;
			Форма.Элементы.ПереключательНКО.Доступность = Ложь;
		КонецЕсли;
	Иначе
		// Отчет скопирован.
		Форма.Элементы.ПереключательНКО.Видимость = Ложь;
		Форма.Элементы.Баланс.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеализованБалансНКО(Форма)
	
	Возврат (Форма.мДатаКонцаПериодаОтчета >= '20111201');
	
КонецФункции

&НаКлиенте
Функция НачатьЗамерВремени()
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		КлючеваяОперация = "ОткрытиеФормыБухгалтерскаяОтчетность";
		ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент").НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецФункции

&НаСервере
Функция ДатаРегистрацииОрганизации(ВыбОрганизация)
	
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(ВыбОрганизация, , "ДатаРегистрации");
	
	Если ЗначениеЗаполнено(ОргСведения) И ОргСведения.Свойство("ДатаРегистрации") Тогда
		Возврат ОргСведения["ДатаРегистрации"];
	Иначе
		Возврат РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбработатьВыбраннуюОрганизацию(ВыбОрганизация)
	
	ОрганизацияДатаРегистрации = ДатаРегистрацииОрганизации(ВыбОрганизация);
	
	ОткорректироватьНачальныйПериод(ВыбОрганизация);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиНКО(ВыбОрганизация)
	
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
	ВыбОрганизация, мДатаКонцаПериодаОтчета, "НекоммерческаяОрганизация");
	
	Если ОргСведения.Свойство("НекоммерческаяОрганизация")
		И ТипЗнч(ОргСведения.НекоммерческаяОрганизация) = Тип("Булево") Тогда
		Элементы.ПризнакНекоммерческойОрганизации.Видимость = Ложь;
		БалансНекоммерческойОрганизации = ОргСведения.НекоммерческаяОрганизация;
		Возврат;
	КонецЕсли;
	
	Если НЕ (Элементы.ПереключательНКО.Доступность и Элементы.ПереключательНКО.Видимость) Тогда
		// Отчет скопирован или создан за период, в котором отдельного баланса НКО еще не было.
		Возврат;
	КонецЕсли;
	
	НастройкиНКОизНастроек = ХранилищеНастроекДанныхФорм.Загрузить(
		"Отчет.РегламентированныйОтчетБухОтчетность.Форма.ОсновнаяФорма", "НастройкиНКО");
	Если НастройкиНКОизНастроек <> Неопределено Тогда
		НастройкиНКО.Загрузить(НастройкиНКОизНастроек);
	КонецЕсли; 
	
	БалансНекоммерческойОрганизации = Ложь;
	
	Для каждого ТекНастройкаНКО Из НастройкиНКО Цикл
		Если ТекНастройкаНКО.ОрганизацияНКО = ВыбОрганизация Тогда
			БалансНекоммерческойОрганизации = ТекНастройкаНКО.БалансНКО;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если БалансНекоммерческойОрганизации Тогда
		ПереключательНКО = 1;
	Иначе
		ПереключательНКО = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиНКО(ВыбОрганизация)
	
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
	ВыбОрганизация, мДатаКонцаПериодаОтчета, "НекоммерческаяОрганизация");
	
	Если ОргСведения.Свойство("НекоммерческаяОрганизация")
		И ТипЗнч(ОргСведения.НекоммерческаяОрганизация) = Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ (Элементы.ПереключательНКО.Доступность и Элементы.ПереключательНКО.Видимость) Тогда
		// Отчет скопирован или создан за период, в котором отдельного баланса НКО еще не было.
		Возврат;
	КонецЕсли;
	
	Найден = Ложь;
	Для каждого ТекНастройкаНКО Из НастройкиНКО Цикл
		Если ТекНастройкаНКО.ОрганизацияНКО = ВыбОрганизация Тогда
			ТекНастройкаНКО.БалансНКО = БалансНекоммерческойОрганизации;
			Найден = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не Найден Тогда
		
		НовыйЭлемент = НастройкиНКО.Добавить();
		НовыйЭлемент.ОрганизацияНКО = ВыбОрганизация;
		НовыйЭлемент.БалансНКО = БалансНекоммерческойОрганизации;
		
	КонецЕсли;
	
	НастройкиНКОдляНастроек = НастройкиНКО.Выгрузить();
	
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Отчет.РегламентированныйОтчетБухОтчетность.Форма.ОсновнаяФорма",
		"НастройкиНКО", НастройкиНКОдляНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИзменитьПериод(ЭтаФорма, 0);
	
	ОбработатьВыбраннуюОрганизацию(ВыбранноеЗначение);
	
	ПоказатьПериод(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтаФорма);
	УстановитьДоступностьКнопокПериода(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	ВосстановитьНастройкиНКО(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСсылкаИзмененияЗаконодательстваНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "" Тогда
		// Нет общей части - ничего не делаем.
		Возврат;
	КонецЕсли; 
	
	// Фильтр4 - год.
	Фильтр4 = "currentYear=" + Формат(Год(мДатаКонцаПериодаОтчета),"ЧГ=0");
	
	// Фильтр5 - квартал.
	МесяцКонцаКварталаОтчета = Месяц(КонецКвартала(мДатаКонцаПериодаОтчета));
	КварталОтчета = МесяцКонцаКварталаОтчета/3;
	
	Фильтр5 = "currentQuartal=" + Строка(КварталОтчета);
	
	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства + 
										"&" + Фильтр4 + "&" + Фильтр5;
	
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(СсылкаИзмененияЗаконодательства);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = "Активизировать" Тогда
		Если ИмяСобытия = ЭтаФорма.Заголовок Тогда
			ЭтаФорма.Активизировать();
		КонецЕсли;
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательСпособСозданияОрганизацииПриИзменении(Элемент)
	
	мДатаНачалаПериодаОтчета = Неопределено;
	мДатаКонцаПериодаОтчета  = Неопределено;
	
	ОткорректироватьНачальныйПериод(Организация);
	
	ПоказатьПериод(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтаФорма);
	УстановитьДоступностьКнопокПериода(ЭтаФорма, ОрганизацияДатаРегистрации);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПереключателяСпособаСозданияОрганизации(Форма)
	
	ПредельнаяДатаОтображения = КонецГода(ДобавитьМесяц(Форма.ОрганизацияДатаРегистрации, 24));
	
	ОтображатьПереключатель
		= Форма.ОрганизацияДатаРегистрации >= Дата(Год(Форма.ОрганизацияДатаРегистрации), 10, 1)
		И Форма.мДатаКонцаПериодаОтчета <= ПредельнаяДатаОтображения;
	
	Форма.Элементы.ПереключательСпособСозданияОрганизации.Видимость = ОтображатьПереключатель;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательНКОПриИзменении(Элемент)
	
	БалансНекоммерческойОрганизации = (ПереключательНКО = 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

#КонецОбласти

#Область Новости

&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(
			ЭтаФорма, ИдентификаторыСобытийПриОткрытии);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыНовости(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(ЭтаФорма, Команда);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти