#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		
		ЗаполнитьПоНематериальномуАктиву(ДанныеЗаполнения);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПринятиеКУчетуНМА") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		
		ЗначенияРеквизитовОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация, НематериальныйАктив");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитовОбъекта);
		Если ЗначениеЗаполнено(ЗначенияРеквизитовОбъекта.НематериальныйАктив) Тогда
			НМА.Добавить().НематериальныйАктив = ЗначенияРеквизитовОбъекта.НематериальныйАктив;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,
		Новый Структура("ОтражениеАмортизационныхРасходов", "СтатьяРасходов, АналитикаРасходов"),
		НепроверяемыеРеквизиты,
		Отказ);
		
	НепроверяемыеРеквизиты.Добавить("ОтражениеАмортизационныхРасходов.ОрганизацияПолучательРасходов");
	НепроверяемыеРеквизиты.Добавить("ОтражениеАмортизационныхРасходов.СчетПередачиРасходов");
	ПроверитьЗаполнениеРеквизитовПередачиРасходов(Отказ);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ИзменениеПараметровНМА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоНМА");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ИзменениеПараметровНМА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ЗаполнитьПоНематериальномуАктиву(Основание)
	
	Организация = ВнеоборотныеАктивыЛокализация.ОрганизацияВКоторойНМАПринятКУчету(Основание);
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Нематериальный актив ""%1"" не принят к учету.';
										|en = 'The ""%1"" intangible asset is not entered in the books.'"), Строка(Основание));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли; 
	
	НоваяСтрока = НМА.Добавить();
	НоваяСтрока.НематериальныйАктив = Основание;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовПередачиРасходов(Отказ)
	
	Для каждого Строка Из ОтражениеАмортизационныхРасходов Цикл
		
		Если Не Строка.ПередаватьРасходыВДругуюОрганизацию Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.ОрганизацияПолучательРасходов) Тогда
			Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"ОтражениеАмортизационныхРасходов", Строка.НомерСтроки, "ОрганизацияПолучательРасходов");
					
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Не заполнено поле ""Получатель"" в строке ""%1"" табличной части.';
									|en = 'Recipient is not populated in row ""%1"" of the tabular section.'"), Строка.НомерСтроки);
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				Путь,
				,
				Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.СчетПередачиРасходов) Тогда
			
			Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"ОтражениеАмортизационныхРасходов", Строка.НомерСтроки, "СчетПередачиРасходов");
					
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Не заполнено поле ""Счет передачи"" в строке ""%1"" табличной части.';
									|en = 'The ""Transfer account"" field is not populated in row ""%1"" of the tabular section.'"), Строка.НомерСтроки);
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				Путь,
				,
				Отказ);
				
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли