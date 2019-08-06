
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МодифицироватьЭлементыФормыПриСоздании();
	
	ВосстановитьНастройкиФормыПриСоздании();
	
	УстановитьПометкуКнопкамПериодичности();
	
	ВывестиРасписаниеПриСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НачатьОжиданиеФоновойОперацииПриОткрытии Тогда
		
		ПодключитьОбработчикОжидания("НачатьОжиданиеФоновойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделенияПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутныеЛистыПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовДиаграммыГанта

&НаКлиенте
Процедура ДиаграммаГантаОбработкаРасшифровки(Элемент, Расшифровки, СтандартнаяОбработка, Дата)
	
	Если ТипЗнч(Расшифровки) = Тип("Массив")
		И ТипЗнч(Расшифровки[1]) = Тип("Структура")
		И Расшифровки[1].Свойство("ПараллельнаяЗагрузка")
		И Расшифровки[1].ПараллельнаяЗагрузка Тогда
		
		ПараметрыФормы = Расшифровки[1];
		ПараметрыФормы.Вставить("ПериодВыборкиНачало", Период.ДатаНачала);
		ПараметрыФормы.Вставить("ПериодВыборкиОкончание", Период.ДатаОкончания);
		ПараметрыФормы.Вставить("Подразделения", Подразделения.ВыгрузитьЗначения());
		
		ОперативныйУчетПроизводстваКлиент.ОбработкаРасшифровкиИнтервалаСПараллельнойЗагрузкой(
			ЭтотОбъект, ПараметрыФормы, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ВывестиРасписание();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодДень(Команда)

	УстановитьПериодДеньНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодНеделя(Команда)
	
	УстановитьПериодНеделяНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодМесяц(Команда)
	
	УстановитьПериодМесяцНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеНастройками

&НаСервере
Процедура ВосстановитьНастройкиФормыПриСоздании()
	
	НастройкиФормы = ХранилищеНастроекДанныхФорм.Загрузить(
		МенеджерНастроекКлючОбъекта(), МенеджерНастроекКлючНастроек());
	Если ЗначениеЗаполнено(НастройкиФормы) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	НастройкиФормы = СохраняемыеНастройкиФормы();
	
	ЗаполнитьЗначенияСвойств(НастройкиФормы, ЭтаФорма);
	ХранилищеНастроекДанныхФорм.Сохранить(
		МенеджерНастроекКлючОбъекта(), МенеджерНастроекКлючНастроек(), НастройкиФормы);
	
КонецПроцедуры

&НаСервере
Функция СохраняемыеНастройкиФормы()
	
	Результат = Новый Структура;
	Результат.Вставить("Период");
	Результат.Вставить("Подразделения");
	Результат.Вставить("Распоряжения");
	Результат.Вставить("МаршрутныеЛисты");
	Результат.Вставить("Периодичность");
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция МенеджерНастроекКлючОбъекта()
	
	Возврат "ДиаграммаПооперационногоРасписания";
	
КонецФункции

&НаСервере
Функция МенеджерНастроекКлючНастроек()
	
	Возврат "НастройкиФормы";
	
КонецФункции

#КонецОбласти

#Область ВыводРасписания

&НаКлиенте
Процедура ОбработатьИзменениеОтбора()
	
	ВывестиРасписание();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодДеньНаСервере()
	
	Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.День;
	ОбработатьИзменениеПериодичностиОтображения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодНеделяНаСервере()
	
	Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Неделя;
	ОбработатьИзменениеПериодичностиОтображения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодМесяцНаСервере()
	
	Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Месяц;
	ОбработатьИзменениеПериодичностиОтображения();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеПериодичностиОтображения()
	
	СохранитьНастройкиФормы();
	УстановитьПометкуКнопкамПериодичности();
	УстановитьПериодичность();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуКнопкамПериодичности()
	
	ПометкаДень = Ложь;
	ПометкаНеделя = Ложь;
	ПометкаМесяц = Ложь;
	
	Если Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.День Тогда
		ПометкаДень = Истина;
	ИначеЕсли Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Неделя Тогда
		ПометкаНеделя = Истина;
	ИначеЕсли Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Месяц Тогда
		ПометкаМесяц = Истина;
	Иначе
		Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Неделя;
		ПометкаНеделя = Истина;
	КонецЕсли;
	
	Элементы.УстановитьПериодДень.Пометка = ПометкаДень;
	Элементы.УстановитьПериодНеделя.Пометка = ПометкаНеделя;
	Элементы.УстановитьПериодМесяц.Пометка = ПометкаМесяц;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодичность()
	
	ПараметрыВывода = ПараметрыВыводаРасписания();
	Отчеты.ДиаграммаПооперационногоРасписания.УстановитьПериодичность(ПараметрыВывода, ДиаграммаГанта);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиРасписаниеПриСозданииНаСервере()
	
	Если ПроверитьЗаполнение() Тогда
		
		Результат = ВывестиРасписаниеВФоновомРежиме();
		
		Если Результат.ЗаданиеВыполнено Тогда
			
			НачатьОжиданиеФоновойОперацииПриОткрытии = Ложь;
			
			ПрочитатьРезультатВыводаРасписанияВФоновомРежиме(ДиаграммаГанта, Результат.АдресХранилища);
			
		Иначе
			
			НачатьОжиданиеФоновойОперацииПриОткрытии = Истина;
			
			АдресХранилищаФоноваяОперация = Результат.АдресХранилища;
			ИдентификаторЗадания = Результат.ИдентификаторЗадания;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиРасписание()
	
	Если ПроверитьЗаполнение() Тогда
		
		Результат = ВывестиРасписаниеВФоновомРежиме();
		ЗаполнитьРеквизитыФоновойОперации(Результат);
	
		Если Результат.ЗаданиеВыполнено Тогда
			ЗавершенВыводРасписанияВФоновомРежиме();
		Иначе
			НачатьОжиданиеФоновойОперации();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВывестиРасписаниеВФоновомРежиме()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Параметры", ПараметрыВыводаРасписания());
	ПараметрыЗадания.Вставить("ДиаграммаГанта", ДиаграммаГанта);
	
	НаименованиеЗадания = НСтр("ru = 'Вывод расписания';
								|en = 'Display schedule'");
	
	РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
						УникальныйИдентификатор,
						"Отчеты.ДиаграммаПооперационногоРасписания.ВывестиРасписаниеВФоновомРежиме",
						ПараметрыЗадания,
						НаименованиеЗадания);
	
	Возврат РезультатРасчета;
	
КонецФункции

&НаКлиенте
Процедура ЗавершенВыводРасписанияВФоновомРежиме()
	
	ПрочитатьРезультатВыводаРасписанияВФоновомРежиме(ДиаграммаГанта, АдресХранилищаФоноваяОперация);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПрочитатьРезультатВыводаРасписанияВФоновомРежиме(ДиаграммаГанта, АдресХранилища)
	
	Если ЭтоАдресВременногоХранилища(АдресХранилища) Тогда
		
		ДиаграммаГанта = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыВыводаРасписания()
	
	ПараметрыВывода = Отчеты.ДиаграммаПооперационногоРасписания.ПараметрыВывода();
	ЗаполнитьЗначенияСвойств(ПараметрыВывода, ЭтаФорма);
	
	ПараметрыВывода.Начало = Период.ДатаНачала;
	ПараметрыВывода.Окончание = Период.ДатаОкончания;
	
	Возврат ПараметрыВывода;
	
КонецФункции

#КонецОбласти

#Область ВыполнениеОперацийВФоновомРежиме

&НаКлиенте
Процедура ЗаполнитьРеквизитыФоновойОперации(Результат)
	
	АдресХранилищаФоноваяОперация = Результат.АдресХранилища;
	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОжиданиеФоновойОперации()
	
	ПодключитьОбработчикОжиданияФоновойОперации();
	ОткрытьФормуДлительнойОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияФоновойОперации()
	
	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДлительнойОперации()
	
	ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
 	
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				
				ЗавершенВыводРасписанияВФоновомРежиме();
				
			Иначе
				
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

#КонецОбласти

#Область Прочее

&НаСервере
Процедура МодифицироватьЭлементыФормыПриСоздании()
	
	Отчеты.ДиаграммаПооперационногоРасписания.ДобавитьВФормуОбозначенияДиаграммы(ЭтаФорма, Истина, Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
