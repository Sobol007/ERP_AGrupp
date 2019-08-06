
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("ЗаписьНового", Истина);
	КонецЕсли;
	
	АдресДоставкиСтрокой = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(АдресДоставки);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияГИСМПереопределяемый.ОбработкаЗаполненияЗаявкиНаВыпускКиЗ(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	GLNКонтрагента = ИнтеграцияГИСМ.ПоследнийУказанныйВДокументахGLNКонтрагента(Контрагент);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("ВыпущенныеКиЗ.ДокументПоступления");
	
	Если ЭтоНовый() И ЗначениеЗаполнено(Основание) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	Состояния.ТекущаяЗаявкаНаВыпускКиЗ
		|ИЗ
		|	РегистрСведений.СтатусыЗаявокНаВыпускКиЗГИСМ КАК Состояния
		|ГДЕ
		|	     Состояния.Документ = &Основание
		|	И НЕ Состояния.СтатусЗаявкиНаВыпускКиЗ В (
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаЭмитентом),
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаГИСМ),
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВыпускКиЗГИСМ.Отсутствует))
		|	И НЕ Состояния.ТекущаяЗаявкаНаВыпускКиЗ = ЗНАЧЕНИЕ(Документ.ЗаявкаНаВыпускКиЗГИСМ.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("Основание", Основание);
		
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			ТекстОшибки = НСтр("ru = 'Для документа %1 уже существует текущая %2.';
								|en = 'Для документа %1 уже существует текущая %2.'");
				ТекстОшибки =  СтрШаблон(ТекстОшибки, Основание, Выборка.ТекущаяЗаявкаНаВыпускКиЗ);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					,
					,
					Отказ);
			
		КонецЕсли;
	КонецЕсли;
	
	ИнтеграцияГИСМПереопределяемый.ПроверитьКорректностьПерсонифицованностиЗаказываемыхКиЗ(ЭтотОбъект, "ЗаказанныеКиЗ", Отказ);
	ИнтеграцияГИСМПереопределяемый.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, "ЗаказанныеКиЗ", Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если ВыпущенныеКиЗ.Количество() > 0 Тогда
		
		Для Каждого СтрокаТЧ Из ВыпущенныеКиЗ Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.ДокументПоступления) 
				И (СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить 
				Или СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.КПередаче
				Или СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Передано
				Или СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ПринятоГИСМ) Тогда
				
				НомерСтроки = СтрокаТЧ.НомерСтроки;
				
				ТекстОшибки = НСтр("ru = 'Не указан документ поступления в строке %НомерСтроки% списка ""Выпущенные КиЗ""';
									|en = 'Не указан документ поступления в строке %НомерСтроки% списка ""Выпущенные КиЗ""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВыпущенныеКиЗ", НомерСтроки, "ДокументПоступления"),
					,
					Отказ);
				
			КонецЕсли;
		КонецЦикла;
		
		Запрос = Неопределено;
		ИнтеграцияГИСМПереопределяемый.ЗапросПоПоступившимКиЗ(ЭтотОбъект, Запрос);
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		ВыборкаНомераКиЗ = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаНомераКиЗ.Следующий() Цикл
			
			ТекущийДокументПоступленияПравильный = Ложь;
		
			ВыборкаДетали = ВыборкаНомераКиЗ.Выбрать();
			Пока ВыборкаДетали.Следующий() Цикл
				
				НомерСтроки = ВыборкаДетали.НомерСтроки;
				Если ВыборкаДетали.ДокументПоступления = ВыборкаДетали.ДокументПоступленияКандидат Тогда
					ТекущийДокументПоступленияПравильный = Истина;
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(ВыборкаДетали.ДокументПоступления) 
					И (ВыборкаДетали.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление
					   Или ВыборкаДетали.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление) Тогда
					
					ТекущийДокументПоступленияПравильный = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если Не ТекущийДокументПоступленияПравильный Тогда
				
				ТекстОшибки = НСтр("ru = 'Указан некорректный документ поступления в строке %НомерСтроки% списка ""Выпущенные КиЗ""';
									|en = 'Указан некорректный документ поступления в строке %НомерСтроки% списка ""Выпущенные КиЗ""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВыпущенныеКиЗ", НомерСтроки, "ДокументПоступления"),
					,
					Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВыпущенныеКиЗ.Очистить();
	
	НомерГИСМ = 0;
	Основание = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли