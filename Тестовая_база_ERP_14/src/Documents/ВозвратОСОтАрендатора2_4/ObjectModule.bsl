#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПередачаОСАрендатору2_4") Тогда
		ЗаполнитьНаОснованииПередачиОСАрендатору(ДанныеЗаполнения);
	КонецЕсли;
	
	ВозвратОСОтАрендатораЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
		
	ПроверитьАналитикуРасходов(НепроверяемыеРеквизиты, Отказ, "БУ");
	ПроверитьАналитикуРасходов(НепроверяемыеРеквизиты, Отказ, "УУ");
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Арендатор) И (Организация = Арендатор) Тогда
		Текст = НСтр("ru = 'Поля ""Организация"" и ""Арендатор"" должны различаться.';
					|en = 'The ""Company"" and ""Lessee"" fields must be different.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Арендатор",, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ВозвратОСОтАрендатораЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	
	ИнициализироватьДокумент();
	
	ВозвратОСОтАрендатораЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не Отказ И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСПринятыКУчету(ЭтотОбъект, Отказ);
		ВнеоборотныеАктивыСлужебный.ЗаполнитьОтражениеВУчете(ЭтотОбъект, ОС.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство"));
	КонецЕсли;
	
	ВозвратОСОтАрендатораЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ВозвратОСОтАрендатора2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	ВозвратОСОтАрендатораЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЗаблокироватьЧитаемыеДанные();
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ВозвратОСОтАрендатора2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ВозвратОСОтАрендатораЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ВозвратОСОтАрендатораЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокумент()
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	ПодразделениеПолучатель = Подразделение;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Основание)

	Если Основание.Свойство("ОсновноеСредство") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание.ОсновноеСредство);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание)
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ЭтоГруппа");
	
	Если РеквизитыОснования.ЭтоГруппа Тогда
		
		ТекстСообщения = НСтр("ru = 'Возврат от арендатора группы ОС невозможен.
			|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз.';
			|en = 'Cannot return FA group from leaseholder.
			|Select FA. To open the group, press Ctrl and the arrow down.'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	МестонахождениеОС = ВнеоборотныеАктивы.МестонахождениеОС(Основание);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, МестонахождениеОС);
	Подразделение = МестонахождениеОС.ПодразделениеАрендатора;
	
	СтрокаТабличнойЧасти = ОС.Добавить();
	СтрокаТабличнойЧасти.ОсновноеСредство = Основание;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииПередачиОСАрендатору(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеЗаполнения", ДанныеЗаполнения);
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ПередачаОСАрендатору.Организация КАК Организация,
	|	ПередачаОСАрендатору.ПодразделениеПолучатель КАК Подразделение,
	|	ПередачаОСАрендатору.Подразделение КАК ПодразделениеПолучатель,
	|	ПередачаОСАрендатору.РасчетыМеждуОрганизациямиАрендатор КАК РасчетыМеждуОрганизациямиАрендатор,
	|	ПередачаОСАрендатору.Арендатор КАК Арендатор,
	|	ПередачаОСАрендатору.Ссылка КАК ДокументОснование,
	|	ИСТИНА КАК ДокументНаОсновании,
	|	ПередачаОСАрендатору.ОС.(
	|		ОсновноеСредство КАК ОсновноеСредство
	|	)
	|ИЗ
	|	Документ.ПередачаОСАрендатору2_4 КАК ПередачаОСАрендатору
	|ГДЕ
	|	ПередачаОСАрендатору.Ссылка = &ДанныеЗаполнения";
	
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	ОС.Загрузить(Выборка.ОС.Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьАналитикуРасходов(НепроверяемыеРеквизиты, Отказ, ВидУчета)
	
	Если ЭтотОбъект["НачислятьАмортизацию" + ВидУчета] Тогда
		
		РеквизитыРасходов = СтрШаблон("СтатьяРасходов%1,АналитикаРасходов%1",ВидУчета);
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект, РеквизитыРасходов, НепроверяемыеРеквизиты, Отказ);
		
	Иначе
		
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходов" + ВидУчета);
		НепроверяемыеРеквизиты.Добавить("АналитикаРасходов" + ВидУчета);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаблокироватьЧитаемыеДанные()

	// Нужно заблокировать данные, которые используются при записи движений.
	// Например, данные регистров сведений, которые используются для заполнения недостающих ресурсов.
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПервоначальныеСведенияОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.МестонахождениеОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	Если ОтражатьВРеглУчете Тогда
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаОСБУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ОС;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		
	КонецЕсли;
	
	Если ОтражатьВУпрУчете Тогда
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаОСУУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ОС;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		
	КонецЕсли; 
	
	Блокировка.Заблокировать(); 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
