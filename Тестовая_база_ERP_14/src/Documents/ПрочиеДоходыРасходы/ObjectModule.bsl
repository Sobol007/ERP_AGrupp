
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаПрочихРасходовМеждуФилиалами Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучатель");
	КонецЕсли;
	
	РеквизитыСтатьиРасходов = "СтатьяРасходов,АналитикаРасходов";
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеклассификацияРасходов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.СтатьяАктивовПассивов");
		РеквизитыСтатьиРасходов = РеквизитыСтатьиРасходов+",КорСтатьяРасходов,КорАналитикаРасходов";
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаПрочихРасходовМеждуФилиалами Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.СтатьяАктивовПассивов");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.КорСтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.КорАналитикаРасходов");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.КорСтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.КорАналитикаРасходов");
	КонецЕсли;
	
	РеквизитыСтатьиДоходов = "СтатьяДоходов,АналитикаДоходов";
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеклассификацияДоходов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеДоходы.СтатьяАктивовПассивов");
		РеквизитыСтатьиДоходов = РеквизитыСтатьиДоходов+",КорСтатьяДоходов,КорАналитикаДоходов";
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеДоходы.КорСтатьяДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеДоходы.КорАналитикаДоходов");
	КонецЕсли;
	
	ЭтоДоходы = ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеДоходы
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СторнированиеПрочихДоходов
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеклассификацияДоходов;
		
	Если ЭтоДоходы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.СтатьяАктивовПассивов");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.КорСтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеРасходы.КорАналитикаРасходов");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеДоходы.СтатьяАктивовПассивов");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеДоходы.КорСтатьяДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("ПрочиеДоходы.КорАналитикаДоходов");
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("ПрочиеРасходы", РеквизитыСтатьиРасходов), МассивНепроверяемыхРеквизитов, Отказ);
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("ПрочиеДоходы", РеквизитыСтатьиДоходов), МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПрочиеДоходыРасходыЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		
		РеквизитыДляЗаполнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДляЗаполнения);
		
		ЗаполнитьНаправленияДеятельностиПоПоступлению(ДанныеЗаполнения); 
		
	КонецЕсли;

	ПрочиеДоходыРасходыЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		
		Для Каждого ТекСтрока Из ПрочиеРасходы Цикл
			Если НЕ ЗначениеЗаполнено(ТекСтрока.СтатьяАктивовПассивов) Тогда
				ТекСтрока.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПрочиеПассивы;
			КонецЕсли;
		КонецЦикла;
		Для Каждого ТекСтрока Из ПрочиеДоходы Цикл
			Если НЕ ЗначениеЗаполнено(ТекСтрока.СтатьяАктивовПассивов) Тогда
				ТекСтрока.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПрочиеАктивы;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеДоходы
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СторнированиеПрочихДоходов
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеклассификацияДоходов Тогда
		ПрочиеРасходы.Очистить();
	Иначе
		ПрочиеДоходы.Очистить();
	КонецЕсли;
	
	Для Каждого Строка Из ПрочиеРасходы Цикл
		Если НЕ ЗначениеЗаполнено(Строка.ДатаОтражения) Тогда
			Строка.ДатаОтражения = Дата;
		КонецЕсли;
	КонецЦикла;
	Для Каждого Строка Из ПрочиеДоходы Цикл
		Если НЕ ЗначениеЗаполнено(Строка.ДатаОтражения) Тогда
			Строка.ДатаОтражения = Дата;
		КонецЕсли;
	КонецЦикла;
	
	//++ НЕ УТ
	ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ПрочиеРасходы);
	ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ПрочиеДоходы);
	//-- НЕ УТ
	
	ПрочиеДоходыРасходыЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ПрочиеДоходыРасходы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	
	
	// Запись наборов записей
	ПрочиеДоходыРасходыЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПрочиеДоходыРасходыЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта = Константы.ВалютаУправленческогоУчета.Получить();
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ЗаполнитьНаправленияДеятельностиПоПоступлению(ДокументПоступления)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрочиеРасходы.Подразделение КАК КорПодразделение,
	|	ПрочиеРасходы.НаправлениеДеятельности КАК КорНаправлениеДеятельности,
	|	ПрочиеРасходы.СтатьяРасходов КАК КорСтатьяРасходов,
	|	ПрочиеРасходы.АналитикаРасходов КАК КорАналитикаРасходов,
	|	СУММА(ПрочиеРасходы.Сумма) КАК Сумма,
	|	СУММА(ПрочиеРасходы.СуммаБезНДС) КАК СуммаБезНДС,
	|	СУММА(ПрочиеРасходы.СуммаРегл) КАК СуммаРегл,
	|	СУММА(ПрочиеРасходы.ПостояннаяРазница) КАК ПостояннаяРазница,
	|	СУММА(ПрочиеРасходы.ВременнаяРазница) КАК ВременнаяРазница
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы КАК ПрочиеРасходы
	|ГДЕ
	|	ПрочиеРасходы.Регистратор = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходы.Подразделение,
	|	ПрочиеРасходы.НаправлениеДеятельности,
	|	ПрочиеРасходы.СтатьяРасходов,
	|	ПрочиеРасходы.АналитикаРасходов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПартииПрочихРасходов.Подразделение,
	|	ПартииПрочихРасходов.НаправлениеДеятельности,
	|	ПартииПрочихРасходов.СтатьяРасходов,
	|	ПартииПрочихРасходов.АналитикаРасходов,
	|	СУММА(ПартииПрочихРасходов.Стоимость),
	|	СУММА(ПартииПрочихРасходов.СтоимостьБезНДС),
	|	СУММА(ПартииПрочихРасходов.СтоимостьРегл),
	|	СУММА(ПартииПрочихРасходов.ПостояннаяРазница),
	|	СУММА(ПартииПрочихРасходов.ВременнаяРазница)
	|ИЗ
	|	РегистрНакопления.ПартииПрочихРасходов КАК ПартииПрочихРасходов
	|ГДЕ
	|	ПартииПрочихРасходов.Регистратор = &Ссылка
	|	И (ПартииПрочихРасходов.СтатьяРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|		ИЛИ ПартииПрочихРасходов.СтатьяРасходов.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров))
	|
	|СГРУППИРОВАТЬ ПО
	|	ПартииПрочихРасходов.Подразделение,
	|	ПартииПрочихРасходов.НаправлениеДеятельности,
	|	ПартииПрочихРасходов.СтатьяРасходов,
	|	ПартииПрочихРасходов.АналитикаРасходов";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументПоступления);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеклассификацияРасходов;
		ПрочиеРасходы.Загрузить(РезультатЗапроса.Выгрузить());
	Иначе
		Текст = НСтр("ru = 'Нет данных для реклассификации расходов';
					|en = 'No data for expense reclassification'");
		ВызватьИсключение Текст;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
