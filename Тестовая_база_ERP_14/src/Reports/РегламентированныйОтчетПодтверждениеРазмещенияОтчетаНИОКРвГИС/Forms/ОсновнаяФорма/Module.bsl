
#Область ОбработчикиСобытийФормы

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСрокПредставленияОтчетности(Форма)
	
	СтрСрокПредставления = "Не позднее " + Формат(Дата(Год(Форма.мДатаКонцаПериодаОтчета) + 1, 3, 28),
	"ДФ=""дд ММММ гггг 'года'""") + " (п.4 ст.289 НК РФ)";
	
	Возврат НСтр("ru='" + СтрСрокПредставления + ".'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	ОбработкаПериодичностьОтчета(Форма);
	
	Форма.НадписьСрокПредставленияОтчета = ПолучитьСрокПредставленияОтчетности(Форма);
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		УстановитьДоступностьЭлементаПриРасширенномПервомНалоговомПериоде(Форма, "ОткрытьФормуОтчета");
		
	Иначе
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость	 = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементаПриРасширенномПервомНалоговомПериоде(Форма, "УстановитьПредыдущийПериод");
	
	ОтобразитьПоясненияКПериодуОтчета(Форма);
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
	// В РезультирующаяТаблица - действующие на выбранный период формы.
	// Заполним список выбора форм отчетности.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	Форма.НадписьКтоСдаетОтчет = НСтр("ru = 'Только организации (п.8 ст.262 НК РФ).';
										|en = 'Только организации (п.8 ст.262 НК РФ).'");
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг * 12));
	Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
	ПоказатьПериод(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработкаПериодичностьОтчета(Форма)
	
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Очистить();
	
	ДатаКонца  = КонецГода(Форма.мДатаКонцаПериодаОтчета);
	ДатаНачала = НачалоГода(Форма.мДатаНачалаПериодаОтчета);
	
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(
	Формат(ДатаНачала, "ДФ=""ММММ гггг ' г.'""") + " - " + Формат(ДатаКонца, "ДФ=""ММММ гггг ' г.'"""));
	
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(
	ПредставлениеПериода(ДатаНачала, ДатаКонца, "ФП = Истина"));
	
	Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
		Форма.ПолеВыбораПериодичностиПоказаПериода
		= Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора[1].Значение;
	Иначе
		Форма.ПолеВыбораПериодичностиПоказаПериода
		= Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора[0].Значение;
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
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
	мТаблицаФормОтчета);
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц);
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	ПеречислениеПериодичностьМесяц   = Перечисления.Периодичность.Месяц;
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мПериодичность)
		ИЛИ НЕ (мПериодичность = ПеречислениеПериодичностьМесяц
		ИЛИ мПериодичность = ПеречислениеПериодичностьКвартал) Тогда
		
		мПериодичность = ПеречислениеПериодичностьКвартал;
		
	КонецЕсли;
	
	ПолеВыбораПериодичность = мПериодичность;
	
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
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ОбработатьОрганизацию(Организация);
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
		"БП.Отчет.РегламентированныйОтчетПодтверждениеРазмещенияОтчетаНИОКРвГИС",
		"ОсновнаяФорма",
		,
		НСтр("ru = 'Новости: Подтверждение размещения отчета о НИОКР в ГИС';
			|en = 'Новости: Подтверждение размещения отчета о НИОКР в ГИС'"),
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
Процедура ПолеВыбораПериодичностиПоказаПериодаПриИзменении(Элемент)
	
	СтрВыбораПериодичностиПоказаПериода = ПолеВыбораПериодичностиПоказаПериода;
	
	СтрПериодОтчетаГод
	= ПредставлениеПериода(НачалоГода(мДатаКонцаПериодаОтчета), КонецГода(мДатаКонцаПериодаОтчета), "ФП = Истина");
	
	Если (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"КВАРТАЛ") > 1)
		ИЛИ (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"ГОД") > 1)
		ИЛИ (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"МЕСЯЦЕВ") > 1)
		ИЛИ (СтрВыбораПериодичностиПоказаПериода = СтрПериодОтчетаГод) Тогда
		
		ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал;
		
	Иначе
		
		ПолеВыбораПериодичность = ПеречислениеПериодичностьМесяц;
		
	КонецЕсли;
	
	ДатаНачала = "";
	ДатаКонца = "";
	РегламентированнаяОтчетностьКлиент.ПолучитьНачалоКонецПериода(СтрВыбораПериодичностиПоказаПериода, ДатаНачала, ДатаКонца);
	
	Если ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал Тогда
		
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДатаКонца);
		мДатаНачалаПериодаОтчета = НачалоКвартала(ДатаНачала);
		
	Иначе
		
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДатаКонца);
		мДатаНачалаПериодаОтчета = НачалоМесяца(ДатаНачала);
		
	КонецЕсли;
	
	мПериодичность = ПолеВыбораПериодичность;
	
	ПоказатьПериод(ЭтаФорма);
	
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
		мВыбраннаяФорма		= ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок	= ВыбраннаяФорма.ОписаниеОтчета;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, -1);
	
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
		// Документ был скопирован.
		// Проверяем соответствие форм.
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
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
	РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокВыбора = СписокДоступныхЮридическихЛиц(Текст);
	
	Если СписокВыбора.Количество() > 0 И ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = СписокВыбора;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ОбработатьОрганизацию(ДанныеВыбора);
	
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
	"ru = 'Подтверждение размещения отчета о НИОКР в ГИС представляют только организации (п.1 ст.246 НК РФ).
	|В справочнике ""Организации"" сведения об организациях отсутствуют.';
	|en = 'Подтверждение размещения отчета о НИОКР в ГИС представляют только организации (п.1 ст.246 НК РФ).
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
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОткорректироватьНачальныйПериод(Форма)
	
	Если Форма.ГраницыПервогоНалоговогоПериода <> Неопределено Тогда
		
		КонецПервогоНалоговогоПериода = Форма.ГраницыПервогоНалоговогоПериода.Конец;
		
		КонецПервогоОтчетногоПериода = КонецГода(КонецПервогоНалоговогоПериода);
		
		Если Форма.мДатаКонцаПериодаОтчета <= КонецПервогоОтчетногоПериода Тогда
			
			Форма.мДатаКонцаПериодаОтчета  = КонецПервогоОтчетногоПериода;
			Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементаПриРасширенномПервомНалоговомПериоде(Форма, ИмяЭлемента)
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	
	Если ЭлементФормы <> Неопределено Тогда
		
		ЭлементФормы.Доступность = НЕ (Форма.ГраницыПервогоНалоговогоПериода <> Неопределено
		И Форма.мДатаКонцаПериодаОтчета < НачалоГода(Форма.ГраницыПервогоНалоговогоПериода.Конец));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Организация = ВыбранноеЗначение;
	
	ОбработатьОрганизацию(Организация);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьОрганизацию(ВыбОрганизация)
	
	ГраницыПервогоНалоговогоПериода = Неопределено;
	
	Если ЗначениеЗаполнено(ВыбОрганизация) Тогда
		
		ДатаРегистрацииОрганизации = РегламентированнаяОтчетность.ДатаРегистрацииОрганизации(ВыбОрганизация);
		
		ПервыйНалоговыйПериод
		= ИнтерфейсыВзаимодействияБРО.БлижайшийНалоговыйПериод(ВыбОрганизация, ДатаРегистрацииОрганизации,
		Перечисления.ВариантыРасширенногоПервогоНалоговогоПериода.РегистрацияВДекабре);
		
		КонецПервогоНалоговогоПериода = КонецДня(ПервыйНалоговыйПериод.Конец);
		НачалоПервогоНалоговогоПериода = НачалоДня(Мин(ПервыйНалоговыйПериод.Начало, ПервыйНалоговыйПериод.Период));
		
		Если КонецПервогоНалоговогоПериода >= КонецГода('20171231')
			И КонецГода(НачалоПервогоНалоговогоПериода) < КонецПервогоНалоговогоПериода Тогда
			
			ГраницыПервогоНалоговогоПериода
			= Новый Структура("Начало, Конец", НачалоПервогоНалоговогоПериода, КонецПервогоНалоговогоПериода);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОткорректироватьНачальныйПериод(ЭтаФорма);
	
	ПоказатьПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьПоясненияКПериодуОтчета(Форма)
	
	Элементы = Форма.Элементы;
	
	ПризнакВидимости = Ложь;
	
	Если Форма.ГраницыПервогоНалоговогоПериода <> Неопределено Тогда
		
		// Случай расширенного первого налогового периода.
		//
		Если КонецГода(Форма.мДатаКонцаПериодаОтчета) < Форма.ГраницыПервогоНалоговогоПериода.Конец
			И КонецГода(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, 1)) = Форма.ГраницыПервогоНалоговогоПериода.Конец Тогда
			
			// Выбран период, предшествующий первому налоговому периоду.
			//
			ПризнакВидимости = Истина;
			
			ШаблонСообщения = НСтр(
			"ru = 'Подтверждение размещения отчета о НИОКР в ГИС за %1 сдавать не нужно. Период с даты регистрации %2 по %3 включается в подтверждение размещения отчета о НИОКР за отчетный период %4.';
			|en = 'Подтверждение размещения отчета о НИОКР в ГИС за %1 сдавать не нужно. Период с даты регистрации %2 по %3 включается в подтверждение размещения отчета о НИОКР за отчетный период %4.'");
			
			Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
				ТекстОтчетногоПериода = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='гггг ''год'''");
			Иначе
				ТекстОтчетногоПериода = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=""ММММ""")
				+ " - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ=""ММММ гггг 'года'""");
				ТекстОтчетногоПериода = НРег(ТекстОтчетногоПериода);
			КонецЕсли;
			
			ТекстПояснения
			= СтрШаблон(ШаблонСообщения, ТекстОтчетногоПериода,
			Формат(Форма.ГраницыПервогоНалоговогоПериода.Начало, "ДЛФ=D"), Формат(Форма.мДатаКонцаПериодаОтчета, "ДЛФ=D"),
			Формат(Форма.ГраницыПервогоНалоговогоПериода.Конец, "ДФ='гггг ''года'''"));
			
			Элементы.ПояснениеРасширенныйНалоговыйПериод.Заголовок = ТекстПояснения;
			
		ИначеЕсли КонецГода(Форма.мДатаКонцаПериодаОтчета) = Форма.ГраницыПервогоНалоговогоПериода.Конец Тогда
			
			// Выбран период, соответствующий первому налоговому периоду.
			//
			ПризнакВидимости = Истина;
			
			ШаблонСообщения = НСтр("ru = 'Период с даты регистрации %1 по %2 включается в подтверждение размещения отчета о НИОКР в ГИС за %3.';
									|en = 'Период с даты регистрации %1 по %2 включается в подтверждение размещения отчета о НИОКР в ГИС за %3.'");
			
			МесяцКонцаПериодаОтчета = Месяц(Форма.мДатаКонцаПериодаОтчета);
			
			Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
				Если МесяцКонцаПериодаОтчета = 12 Тогда
					ТекстОтчетногоПериода = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='гггг ''год'''");
				Иначе
					ТекстОтчетногоПериода = ПредставлениеПериода(
					НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина");
					ДлинаТекстаОтчетногоПериода = СтрДлина(ТекстОтчетногоПериода);
					ТекстОтчетногоПериода = Лев(ТекстОтчетногоПериода, ДлинаТекстаОтчетногоПериода - 2) + "года";
				КонецЕсли;
			Иначе
				Если МесяцКонцаПериодаОтчета = 1 Тогда
					ТекстОтчетногоПериода = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=""ММММ гггг 'года'""");
				Иначе
					ТекстОтчетногоПериода = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=""ММММ""")
					+ " - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ=""ММММ гггг 'года'""");
				КонецЕсли;
				ТекстОтчетногоПериода = НРег(ТекстОтчетногоПериода);
			КонецЕсли;
			
			ТекстПояснения = СтрШаблон(ШаблонСообщения, Формат(Форма.ГраницыПервогоНалоговогоПериода.Начало, "ДЛФ=D"),
			Формат(КонецКвартала(Форма.ГраницыПервогоНалоговогоПериода.Начало), "ДЛФ=D"),
			ТекстОтчетногоПериода);
			
			Элементы.ПояснениеРасширенныйНалоговыйПериод.Заголовок = ТекстПояснения;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.БлокРасширенныйНалоговыйПериод.Видимость = ПризнакВидимости;
	
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
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);
		
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