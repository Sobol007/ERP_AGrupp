
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ПолноеИмя = РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя();
	
	// Параметры ABC/XYZ классификации
	ИспользоватьКлассификациюПоВыручке = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоВыручке.Получить();
	ИспользоватьКлассификациюПоВаловойПрибыли = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоВаловойПрибыли.Получить();
	ИспользоватьКлассификациюПоКоличествуПродаж = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоКоличествуПродаж.Получить();
	
	// ABC классификация
	ПериодABCКлассификации = Константы.ПериодABCКлассификацииНоменклатуры.Получить();
	КоличествоПериодовABCКлассификации = Константы.КоличествоПериодовABCКлассификацииНоменклатуры.Получить();
	УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры = Константы.УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры.Получить();
	
	// XYZ классификация
	ПериодXYZКлассификации = Константы.ПериодXYZКлассификацииНоменклатуры.Получить();
	КоличествоПериодовXYZКлассификации = Константы.КоличествоПериодовXYZКлассификацииНоменклатуры.Получить();
	ПодпериодXYZКлассификации = Константы.ПодпериодXYZКлассификацииНоменклатуры.Получить();
	УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры = Константы.УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры.Получить();
	
	// Цвета оформления надписей
	ЦветПоясняющийТекст = ЦветаСтиля.ПоясняющийТекст;
	ЦветПоясняющийОшибкуТекст = ЦветаСтиля.ПоясняющийОшибкуТекст;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.СтраницыВозможности.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	ОбновитьОтображениеФормы();
	ОбновитьОписания();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПолныеЧастоИспользуемыеВозможностиНажатие(Элемент)
	
	ПолныеВозможности = НЕ ПолныеВозможности;
	ОбновитьОтображениеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьABCXYZКлассификациюЧастоИспользуемыеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ВыполнитьABCXYZКлассификациюЧастоИспользуемыеВозможности");
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
										|en = 'Product classification'"),, НСтр("ru = 'Выполняется ABC/XYZ классификация...';
																					|en = 'Executing ABC/XYZ classification ...'"), БиблиотекаКартинок.Информация32);
	
	ВыполнитьABCXYZКлассификациюНаСервере();
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
										|en = 'Product classification'"),, НСтр("ru = 'Выполнена ABC/XYZ классификация!';
																					|en = 'ABC/XYZ classification is executed.'"), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьABCКлассификациюПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ВыполнитьABCКлассификациюПолныеВозможности");
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
										|en = 'Product classification'"),, НСтр("ru = 'Выполняется ABC классификация...';
																					|en = 'Executing ABC classification...'"), БиблиотекаКартинок.Информация32);
	
	ВыполнитьABCКлассификациюНаСервере();
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
										|en = 'Product classification'"),, НСтр("ru = 'Выполнена ABC классификация!';
																					|en = 'ABC classification is executed.'"), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьXYZКлассификациюПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ВыполнитьXYZКлассификациюПолныеВозможности");
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
										|en = 'Product classification'"),, НСтр("ru = 'Выполняется XYZ классификация...';
																					|en = 'Executing XYZ classification...'"), БиблиотекаКартинок.Информация32);
	
	ВыполнитьXYZКлассификациюНаСервере();
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
										|en = 'Product classification'"),, НСтр("ru = 'Выполнена XYZ классификация!';
																					|en = 'XYZ classification is executed.'"), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаABCXYZКлассификацияПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.НастройкаABCXYZКлассификацияПолныеВозможности");
	
	КодВозврата = Неопределено;

	
	ОткрытьФорму(ПолноеИмя + ".Форма.НастройкаПараметровКлассификацииНоменклатуры",,,,,, Новый ОписаниеОповещения("НастройкаABCXYZКлассификацияПолныеВозможностиЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаABCXYZКлассификацияПолныеВозможностиЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    КодВозврата = Результат;
    
    Если ТипЗнч(КодВозврата) = Тип("Структура") Тогда
        
        ИспользоватьКлассификациюПоВыручке = КодВозврата.ИспользоватьКлассификациюПоВыручке;
        ИспользоватьКлассификациюПоВаловойПрибыли = КодВозврата.ИспользоватьКлассификациюПоВаловойПрибыли;
        ИспользоватьКлассификациюПоКоличествуПродаж = КодВозврата.ИспользоватьКлассификациюПоКоличествуПродаж;
        ПериодABCКлассификации = КодВозврата.ПериодABCКлассификации;
        КоличествоПериодовABCКлассификации = КодВозврата.КоличествоПериодовABCКлассификации;
        ПериодXYZКлассификации = КодВозврата.ПериодXYZКлассификации;
        КоличествоПериодовXYZКлассификации = КодВозврата.КоличествоПериодовXYZКлассификации;
        ПодпериодXYZКлассификации = КодВозврата.ПодпериодXYZКлассификации;
        УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры = КодВозврата.УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры;
        УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры = КодВозврата.УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры;
        
        ОбновитьОтображениеФормы();
        ОбновитьОписания();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьABCКлассификациюПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ОчиститьABCКлассификациюПолныеВозможности");
	
	КодВозврата = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьABCКлассификациюПолныеВозможностиЗавершение", ЭтотОбъект), НСтр("ru = 'Вся информация об ABC классификации номенклатуры будет очищена. Продолжить?';
																													|en = 'All information about ABC classification of products will be cleared. Continue?'"), РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьABCКлассификациюПолныеВозможностиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    КодВозврата = РезультатВопроса;
    
    Если КодВозврата = КодВозвратаДиалога.ОК Тогда
        
        ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
											|en = 'Product classification'"),, НСтр("ru = 'Выполняется очистка ABC классификации...';
																						|en = 'Clearing ABC classification...'"), БиблиотекаКартинок.Информация32);
        
        ОчиститьABCКлассификациюНаСервере();
        
        ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
											|en = 'Product classification'"),, НСтр("ru = 'Выполнена очистка ABC классификации!';
																						|en = 'ABC classification is cleared.'"), БиблиотекаКартинок.Информация32);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьXYZКлассификациюПолныеВозможности(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.Классификация.КлассификацияНоменклатуры.Команда.ОчиститьXYZКлассификациюПолныеВозможности");
	
	КодВозврата = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьXYZКлассификациюПолныеВозможностиЗавершение", ЭтотОбъект), НСтр("ru = 'Вся информация об XYZ классификации номенклатуры будет очищена. Продолжить?';
																													|en = 'All information about XYZ classification of products will be cleared. Continue?'"), РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьXYZКлассификациюПолныеВозможностиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    КодВозврата = РезультатВопроса;
    
    Если КодВозврата = КодВозвратаДиалога.ОК Тогда
        
        ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
											|en = 'Product classification'"),, НСтр("ru = 'Выполняется очистка XYZ классификации...';
																						|en = 'Clearing XYZ classification...'"), БиблиотекаКартинок.Информация32);
        
        ОчиститьXYZКлассификациюНаСервере();
        
        ПоказатьОповещениеПользователя(НСтр("ru = 'Классификация номенклатуры';
											|en = 'Product classification'"),, НСтр("ru = 'Выполнена очистка XYZ классификации!';
																						|en = 'XYZ classification is cleared.'"), БиблиотекаКартинок.Информация32);
        
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ОбновитьОписания()
	
	ABCОписаниеЧастоИспользуемыеВозможности = СтрШаблон(НСтр("ru = 'ABC классификация по данным за период: %1.';
															|en = 'ABC classification according to the data over a period: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации));
	XYZОписаниеЧастоИспользуемыеВозможности = СтрШаблон(НСтр("ru = 'XYZ классификация по данным за период: %1.';
															|en = 'XYZ classification according to the data over a period: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации));
	ABCОписаниеПолныеВозможности = СтрШаблон(НСтр("ru = 'ABC классификация за все периоды по данным за период: %1.';
													|en = 'ABC classification for all periods according to the data over a period: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации));
	XYZОписаниеПолныеВозможности = СтрШаблон(НСтр("ru = 'XYZ классификация за все периоды по данным за период: %1.';
													|en = 'XYZ classification for all periods according to the data over a period: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации));
	
	// Часто используемые возможности
	Если ИспользоватьКлассификациюПоВыручке
		ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
		ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж Тогда
	
		Элементы.ДекорацияABCXYZКлассификацияОписаниеЧастоИспользуемыеВозможности.Заголовок =
			ABCОписаниеЧастоИспользуемыеВозможности + " " + XYZОписаниеЧастоИспользуемыеВозможности;
			
		Элементы.ДекорацияABCXYZКлассификацияОписаниеЧастоИспользуемыеВозможности.ЦветТекста = ЦветПоясняющийТекст;
		
	Иначе
		
		Элементы.ДекорацияABCXYZКлассификацияОписаниеЧастоИспользуемыеВозможности.Заголовок =
			НСтр("ru = 'Перейдите к полным возможностям и в настройке установите параметры, по которым необходимо выполнять классификацию.';
				|en = 'Go to full functionality. In the settings set parameters that will be used for classification.'");
			
		Элементы.ДекорацияABCXYZКлассификацияОписаниеЧастоИспользуемыеВозможности.ЦветТекста = ЦветПоясняющийОшибкуТекст;
		
	КонецЕсли;
	
	// Полные возможности
	Если ИспользоватьКлассификациюПоВыручке
		ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
		ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж Тогда
		
		Элементы.ДекорацияABCКлассификацияОписаниеПолныеВозможности.Заголовок = ABCОписаниеПолныеВозможности;
		Элементы.ДекорацияXYZКлассификацияОписаниеПолныеВозможности.Заголовок = XYZОписаниеПолныеВозможности;
		
		Элементы.ДекорацияABCКлассификацияОписаниеПолныеВозможности.ЦветТекста = ЦветПоясняющийТекст;
		Элементы.ДекорацияXYZКлассификацияОписаниеПолныеВозможности.ЦветТекста = ЦветПоясняющийТекст;
	
	Иначе
		
		Элементы.ДекорацияABCКлассификацияОписаниеПолныеВозможности.Заголовок = НСтр("ru = 'Перейдите к настройке и установите параметры, по которым необходимо выполнять классификацию.';
																					|en = 'Go to settings and set parameters that will be used for classification.'");
		Элементы.ДекорацияXYZКлассификацияОписаниеПолныеВозможности.Заголовок = НСтр("ru = 'Перейдите к настройке и установите параметры, по которым необходимо выполнять классификацию.';
																					|en = 'Go to settings and set parameters that will be used for classification.'");
		
		Элементы.ДекорацияABCКлассификацияОписаниеПолныеВозможности.ЦветТекста = ЦветПоясняющийОшибкуТекст;
		Элементы.ДекорацияXYZКлассификацияОписаниеПолныеВозможности.ЦветТекста = ЦветПоясняющийОшибкуТекст;
	
	КонецЕсли;
	
	Элементы.ДекорацияОчиститьABCКлассификацияОписаниеПолныеВозможности.Заголовок = НСтр("ru = 'Очистить ABC классификацию за все периоды.';
																						|en = 'Clear the ABC classification for all periods.'");
	Элементы.ДекорацияОчиститьXYZКлассификацияОписаниеПолныеВозможности.Заголовок = НСтр("ru = 'Очистить XYZ классификацию за все периоды.';
																						|en = 'Clear the XYZ classification for all periods.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеФормы()
	
	Если ПолныеВозможности Тогда
		
		// Переключение к полным возможностям
		Элементы.СтраницыВозможности.ТекущаяСтраница = Элементы.СтраницаПолныеВозможности;
		
		// Изменение заголовка формы и заголовка декорации
		Заголовок = НСтр("ru = 'Классификация номенклатуры - полные возможности';
						|en = 'Product classification - full functions'");
		Элементы.ДекорацияПолныеЧастоИспользуемыеВозможности.Заголовок = НСтр("ru = 'Часто используемые возможности';
																				|en = 'Frequently used features'");
		
		// Доступность выполнения ABC классификации
		Элементы.ВыполнитьABCКлассификациюПолныеВозможности.Доступность = ИспользоватьКлассификациюПоВыручке
																			ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
																			ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж;
																			
		// Доступность выполнения XYZ классификации
		Элементы.ВыполнитьXYZКлассификациюПолныеВозможности.Доступность = ИспользоватьКлассификациюПоВыручке
																			ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
																			ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж;
		
	Иначе
		
		 // Переключение к часто используемым возможностям
		Элементы.СтраницыВозможности.ТекущаяСтраница = Элементы.СтраницаЧастоИспользуемыеВозможности;
		
		// Изменение заголовка формы и заголовка декорации
		Заголовок = НСтр("ru = 'Классификация номенклатуры - часто используемые возможности';
						|en = 'Product classification - frequently used functions'");
		Элементы.ДекорацияПолныеЧастоИспользуемыеВозможности.Заголовок = НСтр("ru = 'Полные возможности';
																				|en = 'Full functionality'");
		
		// Доступность выполнения ABC/XYZ классификации
		Элементы.ВыполнитьABCXYZКлассификациюЧастоИспользуемыеВозможности.Доступность = ИспользоватьКлассификациюПоВыручке
																						ИЛИ ИспользоватьКлассификациюПоВаловойПрибыли
																						ИЛИ ИспользоватьКлассификациюПоКоличествуПродаж;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьABCXYZКлассификациюНаСервере()
	
	Справочники.Номенклатура.ВыполнитьABCКлассификацию();
	Справочники.Номенклатура.ВыполнитьXYZКлассификацию();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьABCКлассификациюНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВыручкаИСебестоимостьПродаж.Период КАК Период
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК ВыручкаИСебестоимостьПродаж
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(Выборка.Период, ПериодABCКлассификации, 0).ДатаОкончания + 1;
    МаксимальнаяДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(ТекущаяДатаСеанса(), ПериодABCКлассификации, -1).ДатаОкончания + 1;
	
	Пока ДатаКлассификации <= МаксимальнаяДатаКлассификации Цикл
		
		Справочники.Номенклатура.ВыполнитьABCКлассификацию(ДатаКлассификации);
		ДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаКлассификации, ПериодABCКлассификации, 1) + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьXYZКлассификациюНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВыручкаИСебестоимостьПродаж.Период КАК Период
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК ВыручкаИСебестоимостьПродаж
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(Выборка.Период, ПериодXYZКлассификации, 0).ДатаОкончания + 1;
    МаксимальнаяДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(ТекущаяДатаСеанса(), ПериодXYZКлассификации, -1).ДатаОкончания + 1;
	
	Пока ДатаКлассификации <= МаксимальнаяДатаКлассификации Цикл
		
		Справочники.Номенклатура.ВыполнитьXYZКлассификацию(ДатаКлассификации);
		ДатаКлассификации = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаКлассификации, ПериодXYZКлассификации, 1) + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьABCКлассификациюНаСервере()
	
	РегистрыСведений.ABCXYZКлассификацияНоменклатуры.ОчиститьABCКлассификацию();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьXYZКлассификациюНаСервере()
	
	РегистрыСведений.ABCXYZКлассификацияНоменклатуры.ОчиститьXYZКлассификацию();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
