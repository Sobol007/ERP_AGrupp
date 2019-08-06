#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	УниверсальныеМеханизмыПартийИСебестоимости.СохранитьДвиженияСформированныеРасчетомПартийИСебестоимости(ЭтотОбъект, Замещение);
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	*
	|ПОМЕСТИТЬ ДетализацияПартийТоваровДляНДСиУСН2_4ПередЗаписью
	|ИЗ
	|	РегистрНакопления.ДетализацияПартийТоваровДляНДСиУСН2_4 КАК Т
	|ГДЕ
	|	Т.Регистратор = &Регистратор";
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК Месяц,
	|	Таблица.Организация                  КАК Организация,
	|	Таблица.Регистратор                  КАК Документ,
	|	ЛОЖЬ                                 КАК ИзмененыДанныеДляПартионногоУчетаВерсии21
	|ПОМЕСТИТЬ ДетализацияПартийТоваровДляНДСиУСН2_4ЗаданияКРасчетуСебестоимости
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДетализацияПартий.Период                        	 КАК Период,
	|		ДетализацияПартий.Регистратор                   	 КАК Регистратор,
	|		ДетализацияПартий.Организация                   	 КАК Организация,
	|		ДетализацияПартий.Партия                        	 КАК Партия,
	|		ДетализацияПартий.АналитикаУчетаПартий               КАК АналитикаУчетаПартий,
	|		ДетализацияПартий.ВидДеятельностиНДС            	 КАК ВидДеятельностиНДС,
	|		ДетализацияПартий.ДокументПоступления           	 КАК ДокументПоступления,
	|		ДетализацияПартий.АналитикаУчетаДокументаПоступления КАК АналитикаУчетаДокументаПоступления,
	|		ДетализацияПартий.Номенклатура           			 КАК Номенклатура,
	|		ДетализацияПартий.Характеристика           			 КАК Характеристика,
	|		ДетализацияПартий.НаправлениеДеятельности			 КАК НаправлениеДеятельности,
	|		ДетализацияПартий.СтоимостьБезНДС               	 КАК СтоимостьБезНДС,
	|		ДетализацияПартий.НДС                           	 КАК НДС,
	|		ДетализацияПартий.СтоимостьБезНДСУпр            	 КАК СтоимостьБезНДСУпр,
	|		ДетализацияПартий.НДСУпр                        	 КАК НДСУпр,
	|		ДетализацияПартий.ХозяйственнаяОперация         	 КАК ХозяйственнаяОперация,
	|		ДетализацияПартий.КорВидДеятельностиНДС         	 КАК КорВидДеятельностиНДС,
	|		ДетализацияПартий.КорАналитикаУчетаНоменклатуры 	 КАК КорАналитикаУчетаНоменклатуры,
	|		ДетализацияПартий.КорВидЗапасов                 	 КАК КорВидЗапасов,
	|		ДетализацияПартий.СтатьяРасходовАктивов         	 КАК СтатьяРасходовАктивов,
	|		ДетализацияПартий.АналитикаРасходов         		 КАК АналитикаРасходов,
	|		ДетализацияПартий.АналитикаАктивов             		 КАК АналитикаАктивов,
	|		ДетализацияПартий.ДокументИсточник              	 КАК ДокументИсточник,
	|		ДетализацияПартий.Знаменатель						 КАК Знаменатель,
	|		ДетализацияПартий.СтатьяСписанияНДС					 КАК СтатьяСписанияНДС,
	|		ДетализацияПартий.АналитикаСписанияНДС				 КАК АналитикаСписанияНДС,
	|		ДетализацияПартий.ТипЗаписи                     	 КАК ТипЗаписи,
	|		ДетализацияПартий.РасчетПартий                  	 КАК РасчетПартий,
	|		ДетализацияПартий.РасчетНеЗавершен					 КАК РасчетНеЗавершен
	|	ИЗ
	|		ДетализацияПартийТоваровДляНДСиУСН2_4ПередЗаписью КАК ДетализацияПартий
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДетализацияПартий.Период                        	 КАК Период,
	|		ДетализацияПартий.Регистратор                   	 КАК Регистратор,
	|		ДетализацияПартий.Организация                   	 КАК Организация,
	|		ДетализацияПартий.Партия                        	 КАК Партия,
	|		ДетализацияПартий.АналитикаУчетаПартий               КАК АналитикаУчетаПартий,
	|		ДетализацияПартий.ВидДеятельностиНДС            	 КАК ВидДеятельностиНДС,
	|		ДетализацияПартий.ДокументПоступления           	 КАК ДокументПоступления,
	|		ДетализацияПартий.АналитикаУчетаДокументаПоступления КАК АналитикаУчетаДокументаПоступления,
	|		ДетализацияПартий.Номенклатура           			 КАК Номенклатура,
	|		ДетализацияПартий.Характеристика           			 КАК Характеристика,
	|		ДетализацияПартий.НаправлениеДеятельности			 КАК НаправлениеДеятельности,
	|		-ДетализацияПартий.СтоимостьБезНДС               	 КАК СтоимостьБезНДС,
	|		-ДетализацияПартий.НДС                           	 КАК НДС,
	|		-ДетализацияПартий.СтоимостьБезНДСУпр            	 КАК СтоимостьБезНДСУпр,
	|		-ДетализацияПартий.НДСУпр                        	 КАК НДСУпр,
	|		ДетализацияПартий.ХозяйственнаяОперация         	 КАК ХозяйственнаяОперация,
	|		ДетализацияПартий.КорВидДеятельностиНДС         	 КАК КорВидДеятельностиНДС,
	|		ДетализацияПартий.КорАналитикаУчетаНоменклатуры 	 КАК КорАналитикаУчетаНоменклатуры,
	|		ДетализацияПартий.КорВидЗапасов                 	 КАК КорВидЗапасов,
	|		ДетализацияПартий.СтатьяРасходовАктивов         	 КАК СтатьяРасходовАктивов,
	|		ДетализацияПартий.АналитикаРасходов         		 КАК АналитикаРасходов,
	|		ДетализацияПартий.АналитикаАктивов             		 КАК АналитикаАктивов,
	|		ДетализацияПартий.ДокументИсточник              	 КАК ДокументИсточник,
	|		ДетализацияПартий.Знаменатель						 КАК Знаменатель,
	|		ДетализацияПартий.СтатьяСписанияНДС					 КАК СтатьяСписанияНДС,
	|		ДетализацияПартий.АналитикаСписанияНДС				 КАК АналитикаСписанияНДС,
	|		ДетализацияПартий.ТипЗаписи                     	 КАК ТипЗаписи,
	|		ДетализацияПартий.РасчетПартий                  	 КАК РасчетПартий,
	|		ДетализацияПартий.РасчетНеЗавершен					 КАК РасчетНеЗавершен
	|	ИЗ
	|		РегистрНакопления.ДетализацияПартийТоваровДляНДСиУСН2_4 КАК ДетализацияПартий
	|	ГДЕ
	|		ДетализацияПартий.Регистратор = &Регистратор
	|	) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.Партия,
	|	Таблица.АналитикаУчетаПартий,
	|	Таблица.ВидДеятельностиНДС,
	|	Таблица.ДокументПоступления,
	|	Таблица.АналитикаУчетаДокументаПоступления,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.НаправлениеДеятельности,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.КорВидДеятельностиНДС,
	|	Таблица.КорАналитикаУчетаНоменклатуры,
	|	Таблица.КорВидЗапасов,
	|	Таблица.СтатьяРасходовАктивов,
	|	Таблица.АналитикаРасходов,
	|	Таблица.АналитикаАктивов,
	|	Таблица.ДокументИсточник,
	|	Таблица.Знаменатель,
	|	Таблица.СтатьяСписанияНДС,
	|	Таблица.АналитикаСписанияНДС,
	|	Таблица.ТипЗаписи,
	|	Таблица.РасчетПартий,
	|	Таблица.РасчетНеЗавершен
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.СтоимостьБезНДС) <> 0
	|	И СУММА(Таблица.НДС) <> 0
	|	И СУММА(Таблица.СтоимостьБезНДСУпр) <> 0
	|	И СУММА(Таблица.НДСУпр) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДетализацияПартийТоваровДляНДСиУСН2_4ПередЗаписью
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

#КонецОбласти

#КонецЕсли
