
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокументПередЗаполнением();
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОсновныхСредств Тогда
			
		МассивНепроверяемыхРеквизитов.Добавить("НМА");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыПоДоговорамЛизинга");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы");
		МассивНепроверяемыхРеквизитов.Добавить("АрендованныеОС");
		
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ГруппаФинансовогоУчета");
		МассивНепроверяемыхРеквизитов.Добавить("ВидАктивов");
		
		ПроверитьЗаполнениеТЧ("ОС", ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, Отказ);
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковНМАиРасходовНаНИОКР Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыПоДоговорамЛизинга");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы");
		МассивНепроверяемыхРеквизитов.Добавить("АрендованныеОС");
		
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ГруппаФинансовогоУчета");
		МассивНепроверяемыхРеквизитов.Добавить("ВидАктивов");
		
		ПроверитьЗаполнениеТЧ("НМА", ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, Отказ);
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковВложенийВоВнеоборотныеАктивы Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
		МассивНепроверяемыхРеквизитов.Добавить("НМА");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыПоДоговорамЛизинга");
		МассивНепроверяемыхРеквизитов.Добавить("АрендованныеОС");

		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ГруппаФинансовогоУчета");
		МассивНепроверяемыхРеквизитов.Добавить("Местонахождение");
		
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.ВнеоборотныйАктив");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.СуммаРегл");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.СуммаБезНДС");
		
		ПроверитьЗаполнениеТЧ("ПрочиеРасходы", ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, Отказ);

	КонецЕсли; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокументПередЗаполнением();
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОсновныхСредств Тогда
			ВнеоборотныеАктивыСлужебный.ПроверитьВозможностьПринятияКУчетуОС(ЭтотОбъект, Отказ);
		ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковНМАиРасходовНаНИОКР Тогда
			ВнеоборотныеАктивыСлужебный.ПроверитьВозможностьПринятияКУчетуНМА(ЭтотОбъект, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПередЗаписью();
	
	ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ПрочиеРасходы);
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ВводОстатковВнеоборотныхАктивов2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС,ДокументыПоНМА");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ВводОстатковВнеоборотныхАктивов2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаЗаполнения

Процедура ПроверитьЗаполнениеТЧ(ИмяТЧ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, Отказ) Экспорт

	Если ЭтотОбъект[ИмяТЧ].Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяТЧ = "ОС" Тогда
		
		ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
			
		ВнеоборотныеАктивыСлужебный.ПроверитьРеквизитыОСПриПринятииКУчету(ЭтотОбъект, "ОС", Отказ);
			
	ИначеЕсли ИмяТЧ = "НМА" Тогда
		
		ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "НМА", "НематериальныйАктив", Отказ);
			
	ИначеЕсли ИмяТЧ = "ПрочиеРасходы" Тогда
		
		ПроверкаТабличнойЧастиПрочиеРасходы(Отказ);
		
	КонецЕсли; 
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ПроверитьЗаполнениеТЧ(ЭтотОбъект, ИмяТЧ, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Универсальная проверка выполняемая на основании свойств реквизитов: 
	//  - если реквизит видимый и не заполнен то выводится сообщение.
	//  - если реквизит не видимый или недоступен для редактирования то он не проверяется.
	УниверсальнаяПроверкаТЧ(ИмяТЧ, ПроверяемыеРеквизиты, Отказ);
	
КонецПроцедуры

Процедура УниверсальнаяПроверкаТЧ(ИмяТЧ, ПроверяемыеРеквизиты, Отказ)

	ПараметрыУниверсальнойПроверкиТЧ = Неопределено;
	ПроверяемыеРеквизитыСтатейРасходов = Неопределено;
	ДопПараметрыПровериАналитик = Неопределено;
	МетаданныеОбъекта = Метаданные();
	
	Если ИмяТЧ = "ОС" Тогда
		
		ПараметрыУниверсальнойПроверкиТЧ = Новый Структура;
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("ИмяОбъектаУчета", "ОсновноеСредство");
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("ШаблонСообщения", НСтр("ru = 'В сведениях об основном средстве ""%1"" не заполнено поле %2.';
																			|en = 'Field %2 is not populated in the %1 fixed asset data. '"));
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("РедактированиеВОтдельномОкне", Истина);
		
		ПроверяемыеРеквизитыСтатейРасходов = "СтатьяРасходовБУ, АналитикаРасходовБУ,"
											+ "СтатьяРасходовАмортизационнойПремии, АналитикаРасходовАмортизационнойПремии,"
											+ "СтатьяРасходовУУ, АналитикаРасходовУУ,"
											+ "СтатьяРасходовНалог, АналитикаРасходовНалог";
											
	ИначеЕсли ИмяТЧ = "НМА" Тогда
	
		ПараметрыУниверсальнойПроверкиТЧ = Новый Структура;
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("ИмяОбъектаУчета", "НематериальныйАктив");
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("ШаблонСообщения", НСтр("ru = 'В сведениях о нематериальном активе ""%1"" не заполнено поле %2.';
																			|en = 'Field %2 is not populated in the %1 intangible asset data. '"));
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("РедактированиеВОтдельномОкне", Истина);
		
		ПроверяемыеРеквизитыСтатейРасходов = "СтатьяРасходовБУ, АналитикаРасходовБУ,"
											+ "СтатьяРасходовУУ, АналитикаРасходовУУ";
	ИначеЕсли ИмяТЧ = "ПрочиеРасходы" Тогда
		
		ПараметрыУниверсальнойПроверкиТЧ = Новый Структура;
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("ИмяОбъектаУчета", "ВнеоборотныйАктив");
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("ШаблонСообщения", НСтр("ru = 'Не заполнена колонка ""%2"" в строке %1 списка ""Расходы""';
																			|en = 'The ""%2"" column is not filled in line %1 of the Expenses list'"));
		ПараметрыУниверсальнойПроверкиТЧ.Вставить("РедактированиеВОтдельномОкне", Ложь);
		
	Иначе
		ПараметрыУниверсальнойПроверкиТЧ = ВводОстатковВнеоборотныхАктивовЛокализация.ПараметрыУниверсальнойПроверкиТЧ(ИмяТЧ);
	КонецЕсли;
	
	Если ПараметрыУниверсальнойПроверкиТЧ = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если ПроверяемыеРеквизитыСтатейРасходов <> Неопределено Тогда
		// Вызываем проверку аналитик, чтобы потом использовать результат проверки.
		РеквизитыАналитик = Новый Структура(ИмяТЧ, ПроверяемыеРеквизитыСтатейРасходов);
		ДопПараметрыПровериАналитик = Новый Структура;
		ДопПараметрыПровериАналитик.Вставить("ПрограммнаяПроверка");
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект, РеквизитыАналитик,,, ДопПараметрыПровериАналитик);
	КонецЕсли; 

	ПутьКРеквизитам = ИмяТЧ + ".";
	ПроверяемыеРеквизитыТЧ = Новый Массив;
	ПроверяемыеРеквизитыБезИмениТЧ = Новый Массив;
	Для каждого ИмяПроверяемогоРеквизита Из ПроверяемыеРеквизиты Цикл
		Если СтрНачинаетсяС(ИмяПроверяемогоРеквизита, ПутьКРеквизитам) Тогда
			ПроверяемыеРеквизитыТЧ.Добавить(ИмяПроверяемогоРеквизита);
			ПроверяемыеРеквизитыБезИмениТЧ.Добавить(СтрРазделить(ИмяПроверяемогоРеквизита, ".")[1]);
		КонецЕсли; 
	КонецЦикла; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверяемыеРеквизитыТЧ);
	
	ВспомогательныеРеквизитыОбъекта = Документы.ВводОстатковВнеоборотныхАктивов2_4.ВспомогательныеРеквизиты(ЭтотОбъект, Ложь);
	
	ШаблонРеквизитАналитики = "Объект.%1[%2].%3";
	
	ПредставлениеРеквизитов = Неопределено;
	СписокНезаполненныхАналитик = Новый Массив;
	Для каждого ДанныеСтроки Из ЭтотОбъект[ИмяТЧ] Цикл
		
		ВспомогательныеРеквизиты = Документы.ВводОстатковВнеоборотныхАктивов2_4.ДополнитьВспомогательныеРеквизитыПоДаннымСтроки(
										ЭтотОбъект, ДанныеСтроки, ВспомогательныеРеквизитыОбъекта);
		 
		ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков(
										ДанныеСтроки, ВспомогательныеРеквизиты);
		
		МассивНепроверяемыхРеквизитов = Новый Массив;
		ВнеоборотныеАктивыСлужебный.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов);
		Для каждого ИмяРеквизита Из ПроверяемыеРеквизитыБезИмениТЧ Цикл
			
			Если МассивНепроверяемыхРеквизитов.Найти(ИмяРеквизита) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ДанныеСтроки[ИмяРеквизита]) Тогда
				
				Если ИмяРеквизита = "АналитикаРасходовБУ"
					ИЛИ ИмяРеквизита = "АналитикаРасходовУУ"
					ИЛИ ИмяРеквизита = "АналитикаРасходовАмортизационнойПремии"
					ИЛИ ИмяРеквизита = "АналитикаРасходовНалог" Тогда
					
					ПолеАналитики = СтрШаблон(ШаблонРеквизитАналитики, ИмяТЧ, Формат(ДанныеСтроки.НомерСтроки, "ЧГ="), ИмяРеквизита);
					СписокНезаполненныхАналитик.Добавить(ПолеАналитики);
					
				Иначе
				
					ПредставлениеРеквизита = ВнеоборотныеАктивыСлужебный.ПредставлениеРеквизита(
												ИмяРеквизита, ИмяТЧ, ПредставлениеРеквизитов, МетаданныеОбъекта);
												
					Если ПараметрыУниверсальнойПроверкиТЧ.РедактированиеВОтдельномОкне Тогда
						// При редактировании в отдельном окне сообщение нужно привязать к номеру строки,
						// чтобы при выборе сообщения не происходило открытие формы редактирования.
						ТекстСообщения = СтрШаблон(ПараметрыУниверсальнойПроверкиТЧ.ШаблонСообщения, 
													ДанныеСтроки[ПараметрыУниверсальнойПроверкиТЧ.ИмяОбъектаУчета], 
													ПредставлениеРеквизита);
													
						Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТЧ, ДанныеСтроки.НомерСтроки, "НомерСтроки");
					Иначе	
						ТекстСообщения = СтрШаблон(ПараметрыУниверсальнойПроверкиТЧ.ШаблонСообщения, 
													ДанныеСтроки.НомерСтроки, 
													ПредставлениеРеквизита);
													
						Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТЧ, ДанныеСтроки.НомерСтроки, ИмяРеквизита);
					КонецЕсли; 
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
					
					// Используется для получения ошибок проверки заполнения из вызывающего кода.
					ВнеоборотныеАктивыСлужебный.ДобавитьРезультатПроверкиЗаполнения(
						ЭтотОбъект,
						ПредставлениеРеквизита,
						ИмяТЧ,
						ДанныеСтроки.НомерСтроки,
						ДанныеСтроки[ПараметрыУниверсальнойПроверкиТЧ.ИмяОбъектаУчета]);
					
				КонецЕсли; 
			КонецЕсли;
			
		КонецЦикла; 
		
	КонецЦикла;
	
	Если ДопПараметрыПровериАналитик <> Неопределено Тогда
		Для каждого ОписаниеОшибки Из ДопПараметрыПровериАналитик.Ошибки.СписокОшибок Цикл
			ПолеАналитики = СтрШаблон(ОписаниеОшибки.ПолеОшибки, Формат(ОписаниеОшибки.НомерСтроки+1, "ЧГ="));
			Если СписокНезаполненныхАналитик.Найти(ПолеАналитики) <> Неопределено Тогда
				
				ПоляОшибки = СтрРазделить(ОписаниеОшибки.ПолеОшибки, ".");
				ИмяРеквизита = ПоляОшибки.Получить(ПоляОшибки.ВГраница());
				ПредставлениеРеквизита = ВнеоборотныеАктивыСлужебный.ПредставлениеРеквизита(
											ИмяРеквизита, ИмяТЧ, ПредставлениеРеквизитов, МетаданныеОбъекта);
											
				ТекстСообщения = СтрШаблон(ПараметрыУниверсальнойПроверкиТЧ.ШаблонСообщения, 
											ДанныеСтроки[ПараметрыУниверсальнойПроверкиТЧ.ИмяОбъектаУчета], 
											ПредставлениеРеквизита);
				
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТЧ, ОписаниеОшибки.НомерСтроки+1, "НомерСтроки");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
				
				// Используется для получения ошибок проверки заполнения из вызывающего кода.
				ВнеоборотныеАктивыСлужебный.ДобавитьРезультатПроверкиЗаполнения(
					ЭтотОбъект,
					ПредставлениеРеквизита,
					ИмяТЧ,
					ДанныеСтроки.НомерСтроки+1,
					ДанныеСтроки[ПараметрыУниверсальнойПроверкиТЧ.ИмяОбъектаУчета]);
				
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПроверкаТабличнойЧастиПрочиеРасходы(Отказ)

	Если ВидАктивов = Перечисления.ВидыВнеоборотныхАктивов.ОбъектыСтроительства Тогда
		ШаблонСообщенияАктив = НСтр("ru = 'Не заполнена колонка ""Объект строительства"" в строке %1 списка ""Расходы""';
									|en = 'The ""Construction object"" column in %1 line of the ""Expenses"" list is left empty'");
		ШаблонСообщенияСумма = НСтр("ru = 'Необходимо указать сумму вложений для объекта строительства в строке %1 списка ""Расходы""';
									|en = 'Specify investment amount for the construction object in line %1 of the Expenses list'");
	ИначеЕсли ВидАктивов = Перечисления.ВидыВнеоборотныхАктивов.НМА Тогда
		ШаблонСообщенияАктив = НСтр("ru = 'Не заполнена колонка ""НМА (расходы на НИОКР)"" в строке %1 списка ""Расходы""';
									|en = 'The ""IA (R&D expenses)"" column in %1 line of the ""Expenses"" list is left empty'");
		ШаблонСообщенияСумма = НСтр("ru = 'Необходимо указать сумму вложений для НМА (расходов на НИОКР) в строке %1 списка ""Расходы""';
									|en = 'Specify investment amount for IA (R&D expenses) in line %1 of the Expenses list'");
	Иначе
		ШаблонСообщенияАктив = НСтр("ru = 'Не заполнена колонка ""Основное средство"" в строке %1 списка ""Расходы""';
									|en = 'The ""Fixed asset"" column in %1 line of the ""Expenses"" list is left empty'");
		ШаблонСообщенияСумма = НСтр("ru = 'Необходимо указать сумму вложений для основного средства в строке %1 списка ""Расходы""';
									|en = 'Specify investment amount for the fixed asset in line %1 of the Expenses list'");
	КонецЕсли;
	
	Для каждого ДанныеСтроки Из ПрочиеРасходы Цикл
		
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.ВнеоборотныйАктив) Тогда
			ТекстСообщения = СтрШаблон(ШаблонСообщенияАктив, ДанныеСтроки.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПрочиеРасходы", ДанныеСтроки.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.СуммаРегл) 
				И НЕ ЗначениеЗаполнено(ДанныеСтроки.СуммаПР) 
				И НЕ ЗначениеЗаполнено(ДанныеСтроки.СуммаВР) 
				И ОтражатьВРеглУчете 
				И НЕ ОтражатьВУпрУчете
			ИЛИ НЕ ЗначениеЗаполнено(ДанныеСтроки.Сумма) 
				И НЕ ЗначениеЗаполнено(ДанныеСтроки.СуммаБезНДС) 
				И ОтражатьВУпрУчете 
				И НЕ ОтражатьВРеглУчете
			ИЛИ НЕ ЗначениеЗаполнено(ДанныеСтроки.Сумма) 
				И НЕ ЗначениеЗаполнено(ДанныеСтроки.СуммаБезНДС) 
				И НЕ ЗначениеЗаполнено(ДанныеСтроки.СуммаРегл) 
				И НЕ ЗначениеЗаполнено(ДанныеСтроки.СуммаПР) 
				И НЕ ЗначениеЗаполнено(ДанныеСтроки.СуммаВР)
				И ОтражатьВУпрУчете 
				И ОтражатьВРеглУчете Тогда
				
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПрочиеРасходы", ДанныеСтроки.НомерСтроки, "ВнеоборотныйАктив");
			ТекстСообщения = СтрШаблон(ШаблонСообщенияСумма, ДанныеСтроки.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПередЗаписью

Процедура ЗаполнитьРеквизитыПередЗаписью()

	Если НЕ ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА()
		И Константы.ВалютаУправленческогоУчета.Получить() = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		
		Для каждого ДанныеСтроки Из ОС Цикл
			ДанныеСтроки.ТекущаяСтоимостьУУ = ДанныеСтроки.ТекущаяСтоимостьБУ;
			ДанныеСтроки.НакопленнаяАмортизацияУУ = ДанныеСтроки.НакопленнаяАмортизацияБУ;
			ДанныеСтроки.ПервоначальнаяСтоимостьУУ = ДанныеСтроки.ПервоначальнаяСтоимостьБУ;
			ДанныеСтроки.РезервПереоценкиСтоимости = ДанныеСтроки.РезервПереоценкиСтоимостиРегл;
		КонецЦикла; 
		
		Для каждого ДанныеСтроки Из НМА Цикл
			ДанныеСтроки.ТекущаяСтоимостьУУ = ДанныеСтроки.ТекущаяСтоимостьБУ;
			ДанныеСтроки.НакопленнаяАмортизацияУУ = ДанныеСтроки.НакопленнаяАмортизацияБУ;
			ДанныеСтроки.ПервоначальнаяСтоимостьУУ = ДанныеСтроки.ПервоначальнаяСтоимостьБУ;
			ДанныеСтроки.РезервПереоценкиСтоимости = ДанныеСтроки.РезервПереоценкиСтоимостиРегл;
		КонецЦикла; 
		
	КонецЕсли; 
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ОбработатьОСПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);
	
КонецПроцедуры

Процедура ИнициализироватьДокументПередЗаполнением()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковВложенийВоВнеоборотныеАктивы Тогда
		ВидАктивов = Перечисления.ВидыВнеоборотныхАктивов.ОсновноеСредство;
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОсновныхСредств 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковНМАиРасходовНаНИОКР
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковВложенийВоВнеоборотныеАктивы Тогда
		ОтражатьВУпрУчете = Истина;
	КонецЕсли;
	
	ОтражатьВРеглУчете = Истина;
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ИнициализироватьДокументПередЗаполнением(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
