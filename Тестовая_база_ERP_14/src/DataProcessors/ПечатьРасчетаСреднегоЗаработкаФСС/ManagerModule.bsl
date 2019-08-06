#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда	

#Область СлужебныеПроцедурыИФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасчетСреднегоЗаработка") Тогда
		ДанныеДокументов = ДанныеДокументовРасчетаСреднегоЗаработкаФСС(МассивОбъектов);
		ТабличныйДокумент = ТабличныйДокументРасчетаСреднегоЗаработка(ДанныеДокументов, ОбъектыПечати);
		Если НЕ ТабличныйДокумент = Неопределено Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "РасчетСреднегоЗаработка", НСтр("ru = 'Расчет среднего заработка';
																														|en = 'Average earning calculation'"), ТабличныйДокумент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ТабличныйДокументРасчетаСреднегоЗаработка(ДанныеДокументов, ОбъектыПечати, ВыводитьЗаголовок = Истина, КомпактныйРежим = Ложь) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасчетСреднегоЗаработкаФСС";
	
	Для каждого ДанныеДокумента Из ДанныеДокументов Цикл
		
		Если ДанныеДокумента.ПараметрыРасчета.ПорядокРасчета = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаСреднегоЗаработкаФСС.Постановление2010") Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Печать расчета среднего заработка по правилам 2010 года не поддерживается.';
																	|en = 'Cannot print average earnings calculation according to 2010 rules.'"));
			Продолжить;
		КонецЕсли;
		
		Если ВыводитьЗаголовок И ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если КомпактныйРежим Тогда
			ВывестиТабличныйДокументРасчетаСреднегоЗаработкаКомпактный(ДанныеДокумента, ОбъектыПечати, ТабличныйДокумент);
		Иначе
			ВывестиТабличныйДокументРасчетаСреднегоЗаработка(ДанныеДокумента, ОбъектыПечати, ТабличныйДокумент, ВыводитьЗаголовок);
		КонецЕсли;
		
		Обработки.ПечатьРасчетаСреднегоЗаработка.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеДокумента.РеквизитыДокумента.Ссылка, ДанныеДокумента.РеквизитыДокумента.Сотрудник);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции 

// Подготавливает табличный документ с печатными формами для массива ссылок.
//
// Параметры:
//	МассивСсылок 		- массив ссылок на документы поддерживающие печать среднего заработка.
//	ВыводитьЗаголовок 	- признак того, что надо формировать полную печатную форму.
//
// Возвращаемое значение - структура в которой содержатся
// 		- ТабличныйДокумент, табличный документ с областями для каждой ссылки из массива ссылок.
// 		- ОбъектыПечати, соответствие, ключом которой является ссылка, а значением - имя области табличного документа,
// 			в которой хранится печатная форма для этой ссылки.
//
Функция ОбластиДляВстраивания(ДанныеДокументов, ВыводитьЗаголовок = Ложь, КомпактныйРежим = Ложь) Экспорт
	
	ОбъектыПечати = Обработки.ПечатьРасчетаСреднегоЗаработка.ОбъектыПечатиДляВстраиваемыхОбластей();
	
	ТабличныйДокумент = ТабличныйДокументРасчетаСреднегоЗаработка(ДанныеДокументов, ОбъектыПечати, ВыводитьЗаголовок, КомпактныйРежим);
	
	Возврат Новый Структура("ОбъектыПечати,ТабличныйДокумент", ОбъектыПечати, ТабличныйДокумент);
	
КонецФункции

Процедура ВывестиТабличныйДокументРасчетаСреднегоЗаработка(ДанныеДокумента, ОбъектыПечати, ТабличныйДокумент, ВыводитьЗаголовок)
	
	ОбластиМакета = ОбластиМакета(ДанныеДокумента.ПараметрыРасчета.ИспользоватьДниБолезниУходаЗаДетьми, ДанныеДокумента.ПараметрыРасчета.ПрименятьПредельнуюВеличину И НЕ ДанныеДокумента.ПараметрыРасчета.НеполныйРасчетныйПериод);

	Если ВыводитьЗаголовок Тогда
		ВывестиШапку(ТабличныйДокумент, ОбластиМакета.Шапка, ДанныеДокумента.РеквизитыДокумента, ДанныеДокумента.КадровыеДанныеСотрудника, ДанныеДокумента.ПараметрыРасчета.РасчетныеГоды);
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластиМакета.ЗаголовокНачислений);
	
	ВывестиТаблицуЗаработка(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента);
	
	ТабличныйДокумент.Вывести(ОбластиМакета.РасчетСреднегоЗаработкаЗаголовок);
	
	ВывестиРасчетСреднегоЗаработка(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента);
	
	ВывестиМРОТ(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента);
	
	Если ДанныеДокумента.ПараметрыРасчета.НеполныйРасчетныйПериод Тогда
		ВывестиМаксимальныйСреднийНеполногоРасчетногоПериода(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента);
	ИначеЕсли ДанныеДокумента.ПараметрыРасчета.ИспользоватьДниБолезниУходаЗаДетьми Тогда	
		ВывестиМаксимальныйСреднийПоМатеринству(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ВывестиТабличныйДокументРасчетаСреднегоЗаработкаКомпактный(ДанныеДокумента, ОбъектыПечати, ТабличныйДокумент)
	
	ОбластиМакета = ОбластиМакета(ДанныеДокумента.ПараметрыРасчета.ИспользоватьДниБолезниУходаЗаДетьми, ДанныеДокумента.ПараметрыРасчета.ПрименятьПредельнуюВеличину);
	
	ТабличныйДокумент.Вывести(ОбластиМакета.ПустойЗаголовокНачислений);
	ВывестиТаблицуЗаработка(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента);
	ВывестиРасчетСреднегоЗаработка(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента);
	
КонецПроцедуры

Процедура ВывестиШапку(ТабличныйДокумент, ОбластьШапка, РеквизитыДокумента, КадровыеДанныеСотрудника, РасчетныеГоды)
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("СинонимДокумента", 			РеквизитыДокумента.Ссылка.Метаданные().Синоним);
	ЗначенияПараметров.Вставить("НомерДокумента", 				РеквизитыДокумента.НомерДокумента);
	ЗначенияПараметров.Вставить("ДатаДокумента", 				Формат(РеквизитыДокумента.ДатаДокумента, "ДЛФ=DD"));
	ЗначенияПараметров.Вставить("ДатаНачалаОтсутствия", 		Формат(РеквизитыДокумента.ДатаНачалаОтсутствия, "ДЛФ=D"));
	ЗначенияПараметров.Вставить("ДатаОкончанияОтсутствия", 		Формат(РеквизитыДокумента.ДатаОкончанияОтсутствия,"ДЛФ=D"));
	ЗначенияПараметров.Вставить("НаименованиеОрганизации", 		?(ЗначениеЗаполнено(РеквизитыДокумента.ПолноеНаименованиеОрганизации), РеквизитыДокумента.ПолноеНаименованиеОрганизации, РеквизитыДокумента.НаименованиеОрганизации)); 	
	ЗначенияПараметров.Вставить("ВидЗанятости", 				КадровыеДанныеСотрудника.ВидЗанятости);
	ЗначенияПараметров.Вставить("Подразделение", 				КадровыеДанныеСотрудника.Подразделение);
	ЗначенияПараметров.Вставить("Должность", 					КадровыеДанныеСотрудника.Должность);
	ЗначенияПараметров.Вставить("ФИОРаботника", 				КадровыеДанныеСотрудника.ФИОПолные);
	ЗначенияПараметров.Вставить("ТабельныйНомер", 				ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(КадровыеДанныеСотрудника.ТабельныйНомер, Истина, Истина));
	ЗначенияПараметров.Вставить("РасчетныеГоды", 				ОписаниеРасчетныхЛет(РасчетныеГоды));
	
	НастройкиПечатныхФорм = ЗарплатаКадры.НастройкиПечатныхФорм();
	Если НастройкиПечатныхФорм.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов Тогда
		ЗначенияПараметров.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(РеквизитыДокумента.НомерДокумента, Истина, Истина);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластьШапка);
КонецПроцедуры

Процедура ВывестиТаблицуЗаработка(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента)
	
	ТабличныйДокумент.Вывести(ОбластиМакета.ЗаголовокТаблицы);
	
	Если ДанныеДокумента.ПараметрыРасчета.ИспользоватьДниБолезниУходаЗаДетьми Тогда
		ТабличныйДокумент.Присоединить(ОбластиМакета.ЗаголовокТаблицыДнейБолезниУходаЗаДетьми);
	КонецЕсли;
	
	Если ДанныеДокумента.ПараметрыРасчета.УчитыватьЗаработокПредыдущихСтрахователей Тогда
		ТабличныйДокумент.Присоединить(ОбластиМакета.ЗаголовокТаблицыСтрахователь);
	КонецЕсли;
	
	ЗначенияПараметров = Новый Структура("РасчетныйГод, Заработок, ДнейБолезниУходаЗаДетьми, Страхователь");
	
	Для Каждого РасчетныйГод Из ДанныеДокумента.ПараметрыРасчета.РасчетныеГоды Цикл
		СтрокаПоГоду = УчетПособийСоциальногоСтрахованияКлиентСервер.ЭлементКоллекцииПоОтбору(ДанныеДокумента.ДанныеРасчетаСреднего, Новый Структура("РасчетныйГод", РасчетныйГод));
		Если СтрокаПоГоду = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначенияПараметров.РасчетныйГод = СтрокаПоГоду.РасчетныйГод;
		
		ВыведеноСтрок = 0;
		Для Каждого СтрокаПоСтрахователю Из СтрокаПоГоду.Страхователи Цикл
			ЗаполнитьЗначенияСвойств(ЗначенияПараметров, СтрокаПоСтрахователю);
			Если ЗначенияПараметров.Страхователь = Неопределено Тогда
				Если ЗначенияПараметров.Заработок = 0 Тогда
					Продолжить; // Сотрудник не работал у текущего работодателя.
				КонецЕсли;
				ЗначенияПараметров.Страхователь = ДанныеДокумента.КадровыеДанныеСотрудника.Страхователь;
			КонецЕсли;
			ВывестиСтрокуПоСтрахователю(ТабличныйДокумент, ДанныеДокумента, ОбластиМакета, ЗначенияПараметров);
			ВыведеноСтрок = ВыведеноСтрок + 1;
		КонецЦикла;
		Если ВыведеноСтрок = 0 Тогда
			ЗначенияПараметров.Страхователь = "";
			ЗначенияПараметров.Заработок = 0;
			ЗначенияПараметров.ДнейБолезниУходаЗаДетьми = 0;
			ВывестиСтрокуПоСтрахователю(ТабличныйДокумент, ДанныеДокумента, ОбластиМакета, ЗначенияПараметров);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ОбластиМакета.ТекущийИтог.Параметры, СтрокаПоГоду);
		ТабличныйДокумент.Вывести(ОбластиМакета.ТекущийИтог);
	КонецЦикла;
	
	ВсегоЗаработка = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыйЗаработокФСС(ДанныеДокумента.ПараметрыРасчета, ДанныеДокумента.ДанныеРасчетаСреднего);
	ОбластиМакета.ПодвалТаблицыЗаработка.Параметры.ВсегоЗаработка = Формат(ВсегоЗаработка, "ЧЦ=15; ЧДЦ=2; ЧН=0.00");
	ТабличныйДокумент.Вывести(ОбластиМакета.ПодвалТаблицыЗаработка);
	
КонецПроцедуры

Процедура ВывестиСтрокуПоСтрахователю(ТабличныйДокумент, ДанныеДокумента, ОбластиМакета, ЗначенияПараметров)	
	ЗаполнитьЗначенияСвойств(ОбластиМакета.Строка.Параметры, ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластиМакета.Строка);
	Если ДанныеДокумента.ПараметрыРасчета.ИспользоватьДниБолезниУходаЗаДетьми Тогда
		ЗаполнитьЗначенияСвойств(ОбластиМакета.СтрокаДнейБолезниУходаЗаДетьми.Параметры, ЗначенияПараметров);
		ТабличныйДокумент.Присоединить(ОбластиМакета.СтрокаДнейБолезниУходаЗаДетьми);
	КонецЕсли;
	Если ДанныеДокумента.ПараметрыРасчета.УчитыватьЗаработокПредыдущихСтрахователей Тогда
		ЗаполнитьЗначенияСвойств(ОбластиМакета.СтрокаСтрахователь.Параметры, ЗначенияПараметров);
		ТабличныйДокумент.Присоединить(ОбластиМакета.СтрокаСтрахователь);
	КонецЕсли;
КонецПроцедуры

Процедура ВывестиРасчетСреднегоЗаработка(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента)
	
	УчитываемыхДнейВКалендарныхГодах = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыхДнейВКалендарныхГодахФСС(ДанныеДокумента.ПараметрыРасчета, ДанныеДокумента.ДанныеРасчетаСреднего);
	ВсегоЗаработка = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыйЗаработокФСС(ДанныеДокумента.ПараметрыРасчета, ДанныеДокумента.ДанныеРасчетаСреднего);
	СреднедневнойЗаработок = УчетПособийСоциальногоСтрахованияКлиентСервер.СреднедневнойЗаработокФСС(ВсегоЗаработка, УчитываемыхДнейВКалендарныхГодах);

	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ВсегоЗаработка", 					Формат(ВсегоЗаработка , "ЧЦ=15; ЧДЦ=2; ЧН=0.00"));
	ЗначенияПараметров.Вставить("УчитываемыхДнейВКалендарныхГодах", Формат(УчитываемыхДнейВКалендарныхГодах, "ЧДЦ="));
	ЗначенияПараметров.Вставить("СреднедневнойЗаработок", 			Формат(СреднедневнойЗаработок, "ЧЦ=15; ЧДЦ=2; ЧН=0.00"));
	ЗаполнитьЗначенияСвойств(ОбластиМакета.РасчетСреднегоЗаработка.Параметры, ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластиМакета.РасчетСреднегоЗаработка);

КонецПроцедуры

Процедура ВывестиМРОТ(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента)
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ДатаНачалаСобытия", 	Формат(ДанныеДокумента.ПараметрыРасчета.ДатаНачалаСобытия, "ДЛФ=D"));
	ЗначенияПараметров.Вставить("МРОТ", 				ДанныеДокумента.ПараметрыРасчета.МинимальныйРазмерОплатыТрудаРФ);
	ЗаполнитьЗначенияСвойств(ОбластиМакета.ШапкаМРОТ.Параметры,	ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластиМакета.ШапкаМРОТ);
	
	Если ДанныеДокумента.ПараметрыРасчета.ДоляНеполногоВремени < 1 Тогда
		ЗначенияПараметров.Очистить();
		ЗначенияПараметров.Вставить("ДоляНеполногоВремени", ДанныеДокумента.ПараметрыРасчета.ДоляНеполногоВремени);
		ЗаполнитьЗначенияСвойств(ОбластиМакета.НеполноеВремя.Параметры, ЗначенияПараметров);
		ТабличныйДокумент.Вывести(ОбластиМакета.НеполноеВремя);
	КонецЕсли;
	
	МинимальныйСреднедневнойЗаработок = УчетПособийСоциальногоСтрахованияКлиентСервер.МинимальныйСреднедневнойЗаработокФСС(ДанныеДокумента.ПараметрыРасчета);	

	ЗначенияПараметров.Вставить("СреднийМРОТ", МинимальныйСреднедневнойЗаработок);
	ЗаполнитьЗначенияСвойств(ОбластиМакета.ОкончаниеМРОТ.Параметры,	ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластиМакета.ОкончаниеМРОТ);
	
КонецПроцедуры

Процедура ВывестиМаксимальныйСреднийПоМатеринству(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента)
	
	ПредшествующиеГоды  = "";
	
	ГодыПредельныхВеличин = УчетПособийСоциальногоСтрахованияКлиентСервер.ГодыПредельныхВеличинДляОграниченияПособияПоМатеринству(ДанныеДокумента.ПараметрыРасчета);
	
	Для каждого РасчетныйГод Из ГодыПредельныхВеличин Цикл
		Если ПредшествующиеГоды = "" Тогда
			ПредшествующиеГоды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1';
																								|en = '%1'"), Формат(РасчетныйГод, "ЧГ=0"));
		Иначе	
			ПредшествующиеГоды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 и %2';
																								|en = '%1 and %2'"), ПредшествующиеГоды, Формат(РасчетныйГод, "ЧГ=0"));
		КонецЕсли;
	КонецЦикла;
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ПредшествующиеГоды", 	ПредшествующиеГоды);
	ЗаполнитьЗначенияСвойств(ОбластиМакета.МаксимальныйСреднийПоМатеринствуШапка.Параметры,	ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластиМакета.МаксимальныйСреднийПоМатеринствуШапка);
	
	Для каждого РасчетныйГод Из ГодыПредельныхВеличин Цикл
		ПредельнаяВеличина = ДанныеДокумента.ПараметрыРасчета.ПредельныеВеличиныПоГодам.Получить(РасчетныйГод);
		ЗначенияПараметров.Очистить();
		ЗначенияПараметров.Вставить("РасчетныйГод", 		Формат(РасчетныйГод, "ЧГ=0"));
		ЗначенияПараметров.Вставить("ПредельнаяВеличина", 	ПредельнаяВеличина);
		ЗаполнитьЗначенияСвойств(ОбластиМакета.МаксимальныйСреднийПоМатеринствуСтрока.Параметры, ЗначенияПараметров);
		ТабличныйДокумент.Вывести(ОбластиМакета.МаксимальныйСреднийПоМатеринствуСтрока);
	КонецЦикла;
	
	МаксимальныйСреднедневнойЗаработок = УчетПособийСоциальногоСтрахованияКлиентСервер.МаксимальныйСреднедневнойЗаработокДляОплатыПособияПоМатеринству(ДанныеДокумента.ПараметрыРасчета);
	
	ЗначенияПараметров.Очистить();
	ЗначенияПараметров.Вставить("МаксимальныйСреднедневнойЗаработок", 	МаксимальныйСреднедневнойЗаработок);
	ЗаполнитьЗначенияСвойств(ОбластиМакета.МаксимальныйСреднийПоМатеринствуПодвал.Параметры,	ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластиМакета.МаксимальныйСреднийПоМатеринствуПодвал);
	
КонецПроцедуры

Процедура ВывестиМаксимальныйСреднийНеполногоРасчетногоПериода(ТабличныйДокумент, ОбластиМакета, ДанныеДокумента)
	
	ДатаНачалаСобытия = ДанныеДокумента.ПараметрыРасчета.ДатаНачалаСобытия;
	
	МаксимальныйСреднедневнойЗаработок = УчетПособийСоциальногоСтрахованияКлиентСервер.МаксимальныйСреднедневнойЗаработокДляНеполногоРасчетногоПериода(ДатаНачалаСобытия);
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("МаксимальныйСреднедневнойЗаработок", 	МаксимальныйСреднедневнойЗаработок);
	ЗначенияПараметров.Вставить("ГодНаступленияСтраховогоСлучая", 		Формат(ДатаНачалаСобытия, "ДФ=yyyy"));
	ЗаполнитьЗначенияСвойств(ОбластиМакета.МаксимальныйСреднийНеполногоПериода.Параметры, ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластиМакета.МаксимальныйСреднийНеполногоПериода);
	
КонецПроцедуры

Функция ОбластиМакета(ИспользоватьДниБолезниУходаЗаДетьми, ПрименятьПредельнуюВеличину)
	
	ОбластиМакета = Новый Структура;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьРасчетаСреднегоЗаработкаФСС.ПФ_MXL_РасчетСреднегоЗаработкаПособий");
	
	ОбластиМакета.Вставить("Шапка", 								Макет.ПолучитьОбласть("Заголовок")); 
	ОбластиМакета.Вставить("НеполноеВремя", 						Макет.ПолучитьОбласть("НеполноеВремя"));
	ОбластиМакета.Вставить("ШапкаМРОТ", 							Макет.ПолучитьОбласть("ШапкаМРОТ"));
	ОбластиМакета.Вставить("ОкончаниеМРОТ", 						Макет.ПолучитьОбласть("ОкончаниеМРОТ"));
	ОбластиМакета.Вставить("ЗаголовокНачислений", 					Макет.ПолучитьОбласть("ЗаголовокНачислений")); 
	ОбластиМакета.Вставить("ПустойЗаголовокНачислений", 			Макет.ПолучитьОбласть("ПустойЗаголовокНачислений")); 
	ОбластиМакета.Вставить("РасчетСреднегоЗаработкаЗаголовок", 		Макет.ПолучитьОбласть("РасчетСреднегоЗаработкаЗаголовок"));
	ОбластиМакета.Вставить("РасчетСреднегоЗаработка", 				Макет.ПолучитьОбласть("РасчетСреднегоЗаработка"));
	ОбластиМакета.Вставить("МаксимальныйСреднийНеполногоПериода", 	Макет.ПолучитьОбласть("МаксимальныйСреднийНеполногоПериода")); 
	
	Если ПрименятьПредельнуюВеличину Тогда
		ОбластиМакета.Вставить("ЗаголовокТаблицы", 			Макет.ПолучитьОбласть("ЗаголовокТаблицыНачало")); 
		ОбластиМакета.Вставить("Строка", 					Макет.ПолучитьОбласть("СтрокаЗаработкаНачало"));
		ОбластиМакета.Вставить("ТекущийИтог", 				Макет.ПолучитьОбласть("ТекущийИтог"));
		ОбластиМакета.Вставить("ПодвалТаблицыЗаработка", 	Макет.ПолучитьОбласть("ПодвалТаблицыЗаработка")); 
	Иначе
		ОбластиМакета.Вставить("ЗаголовокТаблицы", 			Макет.ПолучитьОбласть("ЗаголовокТаблицыНачалоБезОграничений")); 
		ОбластиМакета.Вставить("Строка", 					Макет.ПолучитьОбласть("СтрокаЗаработкаНачалоБезОграничений"));
		ОбластиМакета.Вставить("ТекущийИтог", 				Макет.ПолучитьОбласть("ТекущийИтогБезОграничений"));
		ОбластиМакета.Вставить("ПодвалТаблицыЗаработка", 	Макет.ПолучитьОбласть("ПодвалТаблицыЗаработкаБезОграничений")); 
	КонецЕсли;
	
	Если ИспользоватьДниБолезниУходаЗаДетьми Тогда
		ОбластиМакета.Вставить("ЗаголовокТаблицыДнейБолезниУходаЗаДетьми", 	Макет.ПолучитьОбласть("ЗаголовокТаблицыДнейБолезниУходаЗаДетьми")); 
		ОбластиМакета.Вставить("СтрокаДнейБолезниУходаЗаДетьми", 			Макет.ПолучитьОбласть("СтрокаЗаработкаДнейБолезниУходаЗаДетьми"));
		ОбластиМакета.Вставить("ЗаголовокТаблицыСтрахователь", 				Макет.ПолучитьОбласть("ЗаголовокТаблицыСтрахователь")); 
		ОбластиМакета.Вставить("СтрокаСтрахователь", 						Макет.ПолучитьОбласть("СтрокаЗаработкаСтрахователь"));
		ОбластиМакета.Вставить("МаксимальныйСреднийПоМатеринствуШапка", 	Макет.ПолучитьОбласть("МаксимальныйСреднийПоМатеринствуШапка"));
		ОбластиМакета.Вставить("МаксимальныйСреднийПоМатеринствуСтрока", 	Макет.ПолучитьОбласть("МаксимальныйСреднийПоМатеринствуСтрока"));
		ОбластиМакета.Вставить("МаксимальныйСреднийПоМатеринствуПодвал", 	Макет.ПолучитьОбласть("МаксимальныйСреднийПоМатеринствуПодвал"));
	Иначе 
		ОбластиМакета.Вставить("ЗаголовокТаблицыСтрахователь", 				Макет.ПолучитьОбласть("ДлинныйЗаголовокТаблицыСтрахователь")); 
		ОбластиМакета.Вставить("СтрокаСтрахователь", 						Макет.ПолучитьОбласть("ДлиннаяСтрокаЗаработкаСтрахователь"));
	КонецЕсли;
	
	Возврат ОбластиМакета;
	
КонецФункции

Функция ОписаниеРасчетныхЛет(РасчетныеГоды)
			
	ОписаниеРасчетныхЛет = НСтр("ru = 'Не указаны';
								|en = 'Not specified'");   
	
	ВсегоСтрок = РасчетныеГоды.Количество();
	
	Если ВсегоСтрок = 2 Тогда
		ОписаниеРасчетныхЛет = Формат(РасчетныеГоды[0], "ЧЦ=4; ЧГ=0") + " и " + Формат(РасчетныеГоды[1], "ЧЦ=4; ЧГ=0");
	ИначеЕсли ВсегоСтрок = 1 Тогда	
		ОписаниеРасчетныхЛет = Формат(РасчетныеГоды[0], "ЧЦ=4; ЧГ=0");
	КонецЕсли;
	
	Возврат ОписаниеРасчетныхЛет;
КонецФункции

Функция ДокументыСгруппированныеПоТипам(МассивСсылок)
	
	ДокументыСгруппированныеПоТипам = Новый Соответствие;
	
	Для каждого Ссылка Из МассивСсылок Цикл
		
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
		
		МассивСсылок = ДокументыСгруппированныеПоТипам.Получить(Менеджер);
		
		Если МассивСсылок = Неопределено Тогда
			ДокументыСгруппированныеПоТипам.Вставить(Менеджер, Новый Массив);
			МассивСсылок = ДокументыСгруппированныеПоТипам.Получить(Менеджер);
		КонецЕсли;
		
		МассивСсылок.Добавить(Ссылка);
		
	КонецЦикла;
	
	Возврат ДокументыСгруппированныеПоТипам;
	
КонецФункции

Функция ДанныеДокументовРасчетаСреднегоЗаработкаФСС(МассивСсылок)
	
	ДанныеДокументов = Новый Массив;
	
	ДокументыСгруппированныеПоТипам = ДокументыСгруппированныеПоТипам(МассивСсылок);
	
	Для каждого ОписаниеТипаДокумента Из ДокументыСгруппированныеПоТипам Цикл
		
		Менеджер = ОписаниеТипаДокумента.Ключ;
		МассивСсылок = ОписаниеТипаДокумента.Значение;
		
		ДанныеДокументовПоТипу = Менеджер.ДанныеДокументовДляПечатиРасчетаСреднегоЗаработкаФСС(МассивСсылок);
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДанныеДокументов, ДанныеДокументовПоТипу);
	     		
	КонецЦикла;

	Возврат ДанныеДокументов
	
КонецФункции

Функция ПустаяСтруктураДанныхДляПечатиСреднегоЗаработка() Экспорт
	
	СтруктураДанных = Новый Структура;
	
	СтруктураДанных.Вставить("РеквизитыДокумента", ПустаяСтруктураРеквизитовДокументаДляПечатиСреднегоЗаработка());
	СтруктураДанных.Вставить("КадровыеДанныеСотрудника", ПустаяСтруктураКадровыхДанныхСотрудникаДляПечатиСреднегоЗаработка());
	СтруктураДанных.Вставить("ПараметрыРасчета", УчетПособийСоциальногоСтрахованияКлиентСервер.ПараметрыРасчетаСреднегоДневногоЗаработкаФСС());
	СтруктураДанных.Вставить("ДанныеРасчетаСреднего", Новый Массив);
	
	Возврат СтруктураДанных;
	
КонецФункции

Функция ПустаяСтруктураРеквизитовДокументаДляПечатиСреднегоЗаработка()
	
	СтруктураДанных = Новый Структура;
	
	СтруктураДанных.Вставить("Ссылка");
	СтруктураДанных.Вставить("Сотрудник");
	СтруктураДанных.Вставить("НомерДокумента");
	СтруктураДанных.Вставить("ДатаДокумента");
	СтруктураДанных.Вставить("ДатаНачалаОтсутствия");
	СтруктураДанных.Вставить("ДатаОкончанияОтсутствия");
	СтруктураДанных.Вставить("ПолноеНаименованиеОрганизации");
	СтруктураДанных.Вставить("НаименованиеОрганизации");
	
	Возврат СтруктураДанных;

КонецФункции

Функция ПустаяСтруктураКадровыхДанныхСотрудникаДляПечатиСреднегоЗаработка()
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Страхователь");
	СтруктураДанных.Вставить("ФизическоеЛицо");
	СтруктураДанных.Вставить("ФИОПолные");
	СтруктураДанных.Вставить("ТабельныйНомер");
	СтруктураДанных.Вставить("Подразделение");
	СтруктураДанных.Вставить("Должность");
	СтруктураДанных.Вставить("ВидЗанятости");
	
	Возврат СтруктураДанных;

КонецФункции

#КонецОбласти

#КонецЕсли