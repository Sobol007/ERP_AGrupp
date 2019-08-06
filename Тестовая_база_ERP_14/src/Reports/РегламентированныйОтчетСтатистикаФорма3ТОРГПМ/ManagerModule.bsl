#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
		
	Если НаДату > '20110101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияФСГС;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 05.12.2012 № 628.";
	НоваяФорма.РедакцияФормы	  = "от 05.12.2012 № 628.";
	НоваяФорма.ДатаНачалоДействия = '20130101';
	НоваяФорма.ДатаКонецДействия  = '20131231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 09.08.2013 № 317.";
	НоваяФорма.РедакцияФормы	  = "от 09.08.2013 № 317.";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.08.2014 № 536.";
	НоваяФорма.РедакцияФормы	  = "от 27.08.2014 № 536.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20161231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 04.08.2016 № 388.";
	НоваяФорма.РедакцияФормы	  = "от 04.08.2016 № 388.";
	НоваяФорма.ДатаНачалоДействия = '20170101';
	НоваяФорма.ДатаКонецДействия  = '20171231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 04.10.2017 № 657.";
	НоваяФорма.РедакцияФормы	  = "от 04.10.2017 № 657.";
	НоваяФорма.ДатаНачалоДействия = '20180101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));

	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "614009", '20121205', "628", "ФормаОтчета2013Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "614009", '20130809', "317", "ФормаОтчета2014Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "614009", '20140827', "536", "ФормаОтчета2015Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "614009", '20160804', "388", "ФормаОтчета2016Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФорма3ТОРГПМ", "ФормаОтчета2016Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, ВерсияВыгрузки);
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "614009", '20171004', "657", "ФормаОтчета2018Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФорма3ТОРГПМ", "ФормаОтчета2018Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, ВерсияВыгрузки);
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#Если Не ВнешнееСоединение Тогда
#Область ФормированиеТекстаВыгрузки

Функция ПолучитьПодчиненныйЭлемент(Узел, КодЭлемента)
	
	Для Каждого Стр Из Узел.Строки Цикл
		Если Стр.Код = КодЭлемента Тогда
			Возврат Стр;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

Функция НовыйУзелИзПрототипа(ПрототипУзла)
	
	РодительУзла = ПрототипУзла.Родитель;
	
	ПозицияИсходногоУзла = РодительУзла.Строки.Индекс(ПрототипУзла);
	НовыйУзел = РодительУзла.Строки.Вставить(ПозицияИсходногоУзла);
	ЗаполнитьЗначенияСвойств(НовыйУзел, ПрототипУзла, , "Родитель, Строки");
	Для Каждого Стр из ПрототипУзла.Строки Цикл
		РегламентированнаяОтчетность.СкопироватьУзел(НовыйУзел, Стр);
	КонецЦикла;
	
	Возврат НовыйУзел;
	
КонецФункции

Функция ПолучитьТаблицуСоответствийСтрокКодам2018(ИмяФормы)
	мОбъектОтчета = РегламентированнаяОтчетностьВызовСервера.ОбъектОтчета(ИмяФормы);
	МакетСоставаПоказателей = мОбъектОтчета.ПолучитьМакет(СтрЗаменить(СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФормы, ".")[3], "ФормаОтчета", "Список"));
	
	КоллекцияСписковВыбора = Новый Соответствие;
	Для Каждого Область Из МакетСоставаПоказателей.Области Цикл
		Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
			ВерхОбласти = Область.Верх;
			НизОбласти = Область.Низ;
			ТаблСписка = Новый ТаблицаЗначений;
			ТаблСписка.Колонки.Добавить("Код",,, МакетСоставаПоказателей.Область(ВерхОбласти, 1, ВерхОбласти, 1).ШиринаКолонки);
			ТаблСписка.Колонки.Добавить("Название",,, МакетСоставаПоказателей.Область(ВерхОбласти, 2, ВерхОбласти, 2).ШиринаКолонки);
			Для НомСтр = ВерхОбласти По НизОбласти Цикл
				КодПоказателя = СокрП(МакетСоставаПоказателей.Область(НомСтр, 1).Текст);
				Если КодПоказателя <> "###" Тогда
					НовСтрока = ТаблСписка.Добавить();
					НовСтрока.Код = КодПоказателя;
					НовСтрока.Название = СокрП(МакетСоставаПоказателей.Область(НомСтр, 2).Текст);
				КонецЕсли;
			КонецЦикла;
			КоллекцияСписковВыбора.Вставить(Область.Имя, ТаблСписка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат КоллекцияСписковВыбора["КодПоНомеруСтроки"];
КонецФункции

Процедура ЗаполнитьДанными_3ТоргПМ(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки)
	Таблица = ПолучитьТаблицуСоответствийСтрокКодам2018(КонтекстФормы.ИмяФормы);
	ДанныеОтчета = КонтекстФормы.мДанныеОтчета.ПолеТабличногоДокументаФормаОтчета;
	
	Узел_report = ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "report");
	Узел_sections = ПолучитьПодчиненныйЭлемент(Узел_report, "sections");
	Узел_section = Узел_sections.Строки[1];
	Узел_row = ПолучитьПодчиненныйЭлемент(Узел_section, "row");
	
	Для Каждого КЗ Из ДанныеОтчета Цикл 
		Если Лев(КЗ.Ключ, 3) <> "П02" Тогда 
			Продолжить;
		КонецЕсли;
		
		ИндСтр = Сред(КЗ.Ключ, 4, 2);
		Если СтрДлина(КЗ.Ключ) = 9 Тогда 
			ИндСтр = ИндСтр + "_" + Сред(КЗ.Ключ, 7, 1);
		КонецЕсли;
		
		Гр = Прав(КЗ.Ключ, 1);
		ПараметрыВыгрузки.Вставить("ХХХ" + ИндСтр + "ХХХ" + Гр, КЗ.Значение);
	КонецЦикла;
	
	СоответствиеСтрок = Новый Соответствие;
	Для Каждого КЗ Из ПараметрыВыгрузки Цикл 
		Если Лев(КЗ.Ключ, 3) = "ХХХ" Тогда 
			Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КЗ.Ключ, "ХХХ", Истина);
			Если СоответствиеСтрок[Разложение[0]] = Неопределено Тогда 
				СоответствиеСтрок.Вставить(Разложение[0], Новый Структура);
			КонецЕсли;
			
			СоответствиеСтрок[Разложение[0]].Вставить("Гр"+Разложение[1], КЗ.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КЗ Из СоответствиеСтрок Цикл 
		СтрСтр = СтрЗаменить(КЗ.Ключ, "_", ".");
		
		Новый_row = НовыйУзелИзПрототипа(Узел_row);
		Узел_code = ПолучитьПодчиненныйЭлемент(Новый_row, "code");
		Узел_s1 = ПолучитьПодчиненныйЭлемент(Новый_row, "s1");
		Узел_s2 = ПолучитьПодчиненныйЭлемент(Новый_row, "s2");
		Узел_col4 = Новый_row.Строки[3];
		Узел_col5 = Новый_row.Строки[4];
		Узел_col6 = Новый_row.Строки[5];
		Узел_col7 = Новый_row.Строки[6];
		
		Узел_code.Значение = "06";
		Узел_s1.Значение = СтрСтр;
		Узел_s2.Значение = Таблица.НайтиСтроки(Новый Структура("Название", СтрСтр))[0].Код;
		Узел_col4.Значение = Формат(КЗ.Значение["Гр4"], "ЧРД=.; ЧГ=0");
		Узел_col5.Значение = Формат(КЗ.Значение["Гр5"], "ЧРД=.; ЧГ=0");
		Узел_col6.Значение = Формат(КЗ.Значение["Гр6"], "ЧРД=.; ЧГ=0");
		Узел_col7.Значение = Формат(КЗ.Значение["Гр7"], "ЧРД=.; ЧГ=0");
	КонецЦикла;
	
	РегламентированнаяОтчетность.УдалитьУзел(Узел_row);
КонецПроцедуры

Процедура ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки, ВыбраннаяФорма) 
	РегламентированнаяОтчетность.ОбработатьУсловныеЭлементы(КонтекстФормы, ПараметрыВыгрузки, ДеревоВыгрузки);
	УниверсальныйОтчетСтатистики.ЗаполнитьДаннымиУзел(ПараметрыВыгрузки, ДеревоВыгрузки);
	ЗаполнитьДанными_3ТоргПМ(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
	РегламентированнаяОтчетность.ОтсечьНезаполненныеНеобязательныеУзлыСтатистики(ДеревоВыгрузки);
КонецПроцедуры

Функция ТекстВыгрузкиОтчетаСтатистики(мСохраненныйДок, ВыбраннаяФорма) Экспорт 
	ТекстВыгрузки = "";
	Если ВыбраннаяФорма = "ФормаОтчета2018Кв1" Тогда 
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = УниверсальныйОтчетСтатистики.СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, "АтрибВыгрузкиXML2018Кв1");
		МесПериод = 12 / ПараметрыВыгрузки.КодПериодичности;
		ПараметрыВыгрузки.ОтчПериод = "" + Месяц(мСохраненныйДок.ДатаОкончания) / МесПериод;
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2018Кв1");
		ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки, ВыбраннаяФорма);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	КонецЕсли;
	
	Возврат ТекстВыгрузки;
КонецФункции

#КонецОбласти
#КонецЕсли

#КонецЕсли