
#Область ОбработчикиСобытийФормы

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСрокПредставленияОтчетности(Форма)

	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	СтрСрокПредставления = "Не позднее ";
	ДатаСрокаПредставления = Дата(ГодПериода + 1, 3, 30);
	СтрСрокПредставления = СтрСрокПредставления
	+ Формат(ДатаСрокаПредставления, "ДФ=""дд ММММ гггг 'года'""") + " (п.3 ст.386 НК РФ)";
	
	Возврат НСтр("ru='" + СтрСрокПредставления + ".'");
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	СтрПериодОтчета = ПредставлениеПериода(
	НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина");
	
	Форма.НадписьПериодСоставленияОтчета = СтрПериодОтчета;
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	Форма.НадписьСрокПредставленияОтчета = ПолучитьСрокПредставленияОтчетности(Форма);
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
		
	Иначе
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = Ложь;
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
	
	Форма.НадписьКтоСдаетОтчет = НСтр("ru = 'Только организации (п.1 ст.373 НК РФ).';
										|en = 'Только организации (п.1 ст.373 НК РФ).'");
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг);
	
	Если Год(Форма.мДатаКонцаПериодаОтчета) >= 2008 Тогда
		Форма.мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг * 11));
		Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	Иначе
		Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг * 2));
		Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	ПоказатьПериод(Форма);
	
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
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
	мТаблицаФормОтчета);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	мПериодичность = Перечисления.Периодичность.Квартал;
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	ИзменитьПериод(ЭтаФорма, 0);
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(СписокДоступныхЮридическихЛиц().ВыгрузитьЗначения());
	
	Если Элементы.Организация.СписокВыбора.НайтиПоЗначению(Организация) = Неопределено Тогда
		Организация = Неопределено;
	КонецЕсли;
	
	ДоступныеОрганизацииОтсутствуют = Ложь;
	
	Если Элементы.Организация.СписокВыбора.Количество() = 0 Тогда
		
		ДоступныеОрганизацииОтсутствуют = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		
		Сообщение.Текст = ДоступныеОрганизацииОтсутствуютТекст();
		
		Сообщение.Сообщить();
		
		Элементы.Организация.КнопкаОткрытия = Ложь;
		
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		
		Элементы.Организация.СписокВыбора.Очистить();
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
		
	КонецЕсли;
	
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
		
		ОбщаяЧастьСсылкиНаИзмененияЗаконодательства
		= ОбщаяЧастьСсылкиНаИзмененияЗаконодательства + Фильтр1 + "&" + Фильтр2 + "&" + Фильтр3;
		
	КонецЕсли;
	
	ПолеСсылкаИзмененияЗаконодательства = "Изменения законодательства";
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
		
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		
		МодульОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
			ЭтаФорма,
			"БП.Отчет.РегламентированныйОтчетИмущество",
			"ОсновнаяФорма",
			,
			НСтр("ru = 'Новости: Декларация по налогу на имущество организаций';
				|en = 'Новости: Декларация по налогу на имущество организаций'"),
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
		мВыбраннаяФорма = ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок = ВыбраннаяФорма.ОписаниеОтчета;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если ДоступныеОрганизацииОтсутствуют Тогда
		
		ПоказатьПредупреждение(, ДоступныеОрганизацииОтсутствуютТекст());
		Возврат;
		
	КонецЕсли;
	
	Если мСкопированаФорма <> Неопределено Тогда
		
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
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
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
	РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
	
	ДопТекстОписания = НСтр("ru = 'Декларацию по налогу на имущество представляют организации (п.1 ст.373 НК РФ).';
							|en = 'Декларацию по налогу на имущество представляют организации (п.1 ст.373 НК РФ).'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(
	ЭтаФорма, ОписаниеОповещения, ДопТекстОписания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокВыбора = СписокДоступныхЮридическихЛиц(Текст);
	
	Если СписокВыбора.Количество() > 0 И ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = СписокВыбора;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ДоступныеОрганизацииОтсутствуют Тогда
		
		ПоказатьПредупреждение(, ДоступныеОрганизацииОтсутствуютТекст());
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	Текст = ВРег(СокрЛП(Элементы.Организация.ТекстРедактирования));
	
	Если НЕ (ЗначениеЗаполнено(Текст) И ЗначениеЗаполнено(Организация)) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СписокДоступныхЮридическихЛиц(Знач Текст = Неопределено)
	
	СписокВыбора = Новый СписокЗначений;
	РегламентированнаяОтчетность.ПолучитьСписокДоступныхЮридическихЛиц(СписокВыбора, Текст);
	
	Возврат СписокВыбора;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДоступныеОрганизацииОтсутствуютТекст()
	
	Возврат НСтр(
	"ru = 'Декларацию по налогу на имущество представляют только организации (п.1 ст.373 НК РФ).
	|В справочнике ""Организации"" сведения об организациях отсутствуют.';
	|en = 'Декларацию по налогу на имущество представляют только организации (п.1 ст.373 НК РФ).
	|В справочнике ""Организации"" сведения об организациях отсутствуют.'");
	
КонецФункции

&НаКлиенте
Процедура ПолеСсылкаИзмененияЗаконодательстваНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "" Тогда
		// Нет общей части - ничего не делаем.
		Возврат;
	КонецЕсли; 
	
	// Фильтр4 - год.
	Фильтр4 = "currentYear=" + Формат(Год(мДатаКонцаПериодаОтчета),"ЧГ=0");
	
	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства + "&" + Фильтр4;
	
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(
	СсылкаИзмененияЗаконодательства);
	
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

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
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