#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		ЗаполнитьНаОсновании(ДанныеЗаполнения);
	Иначе
		ИнициализироватьДокумент(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не СкладыСервер.ИспользоватьАдресноеХранение(Склад, Помещение, Дата) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Ячейка");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Упаковка");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.УпаковкаОприходование");
		
	ИначеЕсли Не ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Упаковка");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.УпаковкаОприходование");
		
		ТекстСообщения = НСтр("ru = 'В настройках программы не включено использование упаковок номенклатуры, 
			|поэтому нельзя оформить документ по складу с адресным хранением остатков. Обратитесь к администратору';
			|en = 'Usage of product packaging is not enabled in the application settings, so you cannot register a document for the warehouse with bin location warehousing of remaining quantity.
			|Contact administrator'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Неопределено, "", "", Отказ);
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.УпаковкаОприходование");
		
		НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
		
	КонецЕсли;
	
	Если Не СкладыСервер.ИспользоватьСкладскиеПомещения(Склад, Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Помещение");
	КонецЕсли;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.СуффиксДопРеквизита = "Оприходование";
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ,
		ПараметрыПроверки);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект,
		Документы.ОрдерНаОтражениеПересортицыТоваров);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
	
	ТекстОшибки = НСтр("ru = 'Списываемый товар совпадает с приходуемым';
						|en = 'Written-off goods match the recorded as received ones'");
	
	Для Каждого СтрТабл Из Товары Цикл
		
		АдресОшибки = НСтр("ru = 'в строке %НомерСтроки% списка ""Товары""';
							|en = 'in line %НомерСтроки% of the Goods list'");
		АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", СтрТабл.НомерСтроки);
		
		Если ЗначениеЗаполнено(СтрТабл.Номенклатура)
			И СтрТабл.Номенклатура = СтрТабл.НоменклатураОприходование
			И СтрТабл.Характеристика = СтрТабл.ХарактеристикаОприходование
			И СтрТабл.Назначение = СтрТабл.НазначениеОприходование
			И СтрТабл.Серия = СтрТабл.СерияОприходование Тогда
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрТабл.НомерСтроки, "НоменклатураОприходование");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки + Символы.НПП + АдресОшибки, ЭтотОбъект, Поле, "", Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьМногооборотнуюТару") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
		|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
		|	ТаблицаТоваров.НоменклатураОприходование КАК НоменклатураОприходование
		|ПОМЕСТИТЬ ТаблицаТоваров
		|ИЗ
		|	&ТаблицаТоваров КАК ТаблицаТоваров
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
		|	ВЫРАЗИТЬ(ТаблицаТоваров.Номенклатура КАК Справочник.Номенклатура).ТипНоменклатуры КАК НоменклатураТипНоменклатуры,
		|	ВЫРАЗИТЬ(ТаблицаТоваров.НоменклатураОприходование КАК Справочник.Номенклатура).ТипНоменклатуры КАК НоменклатураОприходованиеТипНоменклатуры
		|ИЗ
		|	ТаблицаТоваров КАК ТаблицаТоваров
		|ГДЕ
		|	ВЫРАЗИТЬ(ТаблицаТоваров.Номенклатура КАК Справочник.Номенклатура).ТипНоменклатуры <> ВЫРАЗИТЬ(ТаблицаТоваров.НоменклатураОприходование КАК Справочник.Номенклатура).ТипНоменклатуры
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		Запрос.УстановитьПараметр("ТаблицаТоваров", Товары.Выгрузить(,"НомерСтроки,Номенклатура,НоменклатураОприходование"));
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ТекстОшибки = НСтр("ru = 'В строке %НомерСтроки% списка ""Товары"" не совпадают типы номенклатуры. 
			|У списываемой номенклатуры тип %НоменклатураТипНоменклатуры%, приходуемой - %НоменклатураОприходованиеТипНоменклатуры%.';
			|en = 'Product types do not match in line %НомерСтроки% of the Goods list.
			|Type of written off products is %НоменклатураТипНоменклатуры%, recorded as received one is %НоменклатураОприходованиеТипНоменклатуры%.'");
		
		Пока Выборка.Следующий() Цикл
			СообщениеОбОшибке = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Выборка.НомерСтроки);
			СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%НоменклатураТипНоменклатуры%",
				Выборка.НоменклатураТипНоменклатуры);
			СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%НоменклатураОприходованиеТипНоменклатуры%",
				Выборка.НоменклатураОприходованиеТипНоменклатуры); 
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрТабл.НомерСтроки, "НоменклатураОприходование");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ЭтотОбъект, Поле, "", Отказ);
		КонецЦикла;
		
	КонецЕсли;
	
	СверитьКоличествоВБазовыхЕдиницах(Отказ);
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	СкладыСервер.ПроверитьОрдерностьСклада(Склад, Дата, "ПриОтраженииИзлишковНедостач", Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если СкладыСервер.ИспользоватьАдресноеХранение(Склад, Помещение, Дата) Тогда
		ПроверитьБлокировкуЯчеек(Отказ);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект,
		Документы.ОрдерНаОтражениеПересортицыТоваров);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьОрдерныйСклад(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОрдерНаОтражениеПересортицыТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьТоварыВЯчейках(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОсновании(Основание)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НеОтгружаемыеТовары.Ссылка.ЗонаОтгрузки       КАК Ячейка,
	|	НеОтгружаемыеТовары.Номенклатура              КАК Номенклатура,
	|	НеОтгружаемыеТовары.Характеристика            КАК Характеристика,
	|	НеОтгружаемыеТовары.Назначение                КАК Назначение,
	|	НеОтгружаемыеТовары.Упаковка                  КАК Упаковка,
	|	НеОтгружаемыеТовары.Серия                     КАК Серия,
	|	НеОтгружаемыеТовары.СтатусУказанияСерий       КАК СтатусУказанияСерий,
	|	НеОтгружаемыеТовары.Номенклатура              КАК НоменклатураОприходование,
	|	НеОтгружаемыеТовары.Характеристика            КАК ХарактеристикаОприходование,
	|	НеОтгружаемыеТовары.Назначение                КАК НазначениеОприходование,
	|	НеОтгружаемыеТовары.Упаковка                  КАК УпаковкаОприходование,
	|	НеОтгружаемыеТовары.Серия                     КАК СерияОприходование,
	|	НеОтгружаемыеТовары.СтатусУказанияСерий       КАК СтатусУказанияСерийОприходование,
	|	СУММА(НеОтгружаемыеТовары.Количество)         КАК Количество,
	|	СУММА(НеОтгружаемыеТовары.КоличествоУпаковок) КАК КоличествоУпаковок,
	|	СУММА(НеОтгружаемыеТовары.Количество)         КАК КоличествоОприходование
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК НеОтгружаемыеТовары
	|ГДЕ
	|	НеОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И НеОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И (НеОтгружаемыеТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|		ИЛИ НеОтгружаемыеТовары.Упаковка.ТипУпаковки <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто))
	|
	|СГРУППИРОВАТЬ ПО
	|	НеОтгружаемыеТовары.Ссылка.ЗонаОтгрузки,
	|	НеОтгружаемыеТовары.Номенклатура,
	|	НеОтгружаемыеТовары.Характеристика,
	|	НеОтгружаемыеТовары.Назначение,
	|	НеОтгружаемыеТовары.Упаковка,
	|	НеОтгружаемыеТовары.Серия,
	|	НеОтгружаемыеТовары.СтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	НеОтгружаемыеТовары.Номенклатура.Наименование,
	|	НеОтгружаемыеТовары.Характеристика.Наименование,
	|	НеОтгружаемыеТовары.Назначение.Наименование,
	|	НеОтгружаемыеТовары.Серия.Наименование
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ
	|	ШапкаДокумента.Склад         КАК Склад,
	|	ШапкаДокумента.Помещение     КАК Помещение,
	|	ШапкаДокумента.Ответственный КАК Ответственный
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары КАК ШапкаДокумента
	|ГДЕ
	|	ШапкаДокумента.Ссылка = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", Основание);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РеквизитыДокумента = РезультатЗапроса[1].Выбрать();
	РеквизитыДокумента.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДокумента);
	
	Товары.Загрузить(РезультатЗапроса[0].Выгрузить());
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СверитьКоличествоВБазовыхЕдиницах(Отказ)
	
	ТаблицаПроверки = Товары.Выгрузить();
	ШаблонТекстаСообщения = НСтр("ru = 'Списываемое количество номенклатуры ""%НоменклатураСписания%"" в строке ""%НомерСтроки%"" списка ""Товары"" отличается от количества приходуемой номенклатуры ""%НоменклатураОприходования%"" на ""%Количество%"" единиц хранения';
								|en = 'Quantity of written off products ""%НоменклатураСписания%"" in line ""%НомерСтроки%"" of the ""Goods"" list is different from the quantity of recorded as received products ""%НоменклатураОприходования%"" by ""%Количество%"" storage units'");
	
	Для Каждого СтрокаТовара Из ТаблицаПроверки Цикл
		
		Если СтрокаТовара.Количество <> СтрокаТовара.КоличествоОприходование Тогда
			КоличествоРасхождение = СтрокаТовара.Количество - СтрокаТовара.КоличествоОприходование;
			КоличествоРасхождение = Макс(КоличествоРасхождение, -КоличествоРасхождение);
			
			ПредставлениеНоменклатурыСписания     = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТовара.Номенклатура,
													СтрокаТовара.Характеристика, СтрокаТовара.Упаковка, СтрокаТовара.Серия, СтрокаТовара.Назначение);
			ПредставлениеНоменклатурыПриходования = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
													СтрокаТовара.НоменклатураОприходование, СтрокаТовара.ХарактеристикаОприходование,
													СтрокаТовара.УпаковкаОприходование, СтрокаТовара.СерияОприходование, СтрокаТовара.НазначениеОприходование);
			
			ТекстСообщения = СтрЗаменить(ШаблонТекстаСообщения, "%НомерСтроки%", СтрокаТовара.НомерСтроки);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НоменклатураСписания%", ПредставлениеНоменклатурыСписания);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НоменклатураОприходования%", ПредставлениеНоменклатурыПриходования);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Количество%", КоличествоРасхождение);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТовара.НомерСтроки, "КоличествоУпаковок");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьБлокировкуЯчеек(Отказ)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.БлокировкиСкладскихЯчеек");
	ЭлементБлокировки.Режим          = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ячейка", "Ячейка");
	
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БлокировкиСкладскихЯчеек.Ячейка        КАК Ячейка,
	|	БлокировкиСкладскихЯчеек.ТипБлокировки КАК ТипБлокировки
	|ИЗ
	|	РегистрСведений.БлокировкиСкладскихЯчеек КАК БлокировкиСкладскихЯчеек
	|ГДЕ
	|	БлокировкиСкладскихЯчеек.Ячейка В (&МассивЯчеек)
	|
	|СГРУППИРОВАТЬ ПО
	|	БлокировкиСкладскихЯчеек.Ячейка,
	|	БлокировкиСкладскихЯчеек.ТипБлокировки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ячейка";
	
	Запрос.УстановитьПараметр("МассивЯчеек", Товары.ВыгрузитьКолонку("Ячейка"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = НСтр("ru = 'Ячейка %Ячейка% заблокирована: тип блокировки ""%ТипБлокировки%""';
								|en = 'Storage bin %Ячейка% is locked: lock type ""%ТипБлокировки%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ячейка%", Выборка.Ячейка);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипБлокировки%", Выборка.ТипБлокировки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Неопределено, "", "", Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьОрдерныйСклад(Отказ)
	
	Если Не СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад, Дата) Тогда
		
		Отказ = Истина;
		
		ТекстСообщения = НСтр("ru = 'На складе ""%Склад%"" на %Дата% не используется ордерная схема при отражении излишков, недостач, пересортицы и порчи.';
								|en = 'Advanced warehousing is not used in the ""%Склад%"" warehouse on recording surplus, shortages, misgrading, and damage as of %Дата%.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Склад%", Склад);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Дата%", Формат(Дата, "ДЛФ=D"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли