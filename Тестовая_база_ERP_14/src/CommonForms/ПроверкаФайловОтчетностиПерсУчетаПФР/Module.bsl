
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
	
	Если Параметры.СсылкиНаПроверяемыеОбъекты.Количество() = 0 Тогда
		Отказ = Истина;		
		Возврат;
	КонецЕсли;	
	
	РСВ_1 = Параметры.РСВ_1;
	АдресФайлаВыгрузкиРСВ = Параметры.АдресФайлаВыгрузкиРСВ;
	ИмяФайлаВыгрузкиРСВ = Параметры.ИмяФайлаВыгрузкиРСВ;
	ЕдинаяОтчетностьПФР = Параметры.ЕдинаяОтчетностьПФР;
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(
									Пользователи.ТекущийПользователь(),
	                                Истина,
	                                Ложь);		
	
	ПроверяемыеОбъекты = Новый Массив;
	
	Для Каждого СсылкаНаПроверяемыйОбъект Из Параметры.СсылкиНаПроверяемыеОбъекты Цикл
		ПроверяемыеОбъекты.Добавить(СсылкаНаПроверяемыйОбъект);	
	КонецЦикла;	
	
	ОписаниеПроверяемыхФайловВДанныеФормы(ПроверяемыеОбъекты);
	
	НастройкиПроверочныхПрограмм = ПерсонифицированныйУчет.ОбщиеНастройкиПрограммПроверкиОтчетности();
	
	Если НастройкиПроверочныхПрограмм = Неопределено 
		Или Не НастройкиПроверочныхПрограмм.ВыполнятьПроверкуНаСервере 
		Или ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		НастройкиПроверочныхПрограмм = ПерсонифицированныйУчет.ПерсональныеНастройкиПрограммПроверкиОтчетности();
		
		ВыполнятьПроверкуНаСервере = Ложь;	
		ЗаданыОбщиеНастройки = Ложь;
		Элементы.НастройкаПрограмм.Видимость = Истина;
	Иначе
		ВыполнятьПроверкуНаСервере = НастройкиПроверочныхПрограмм.ВыполнятьПроверкуНаСервере;
		ЗаданыОбщиеНастройки = Истина;
		Элементы.НастройкаПрограмм.Видимость = Ложь;
	КонецЕсли;	
	
	ОпределитьПроверочныеПрограммыДляФайлов(НастройкиПроверочныхПрограмм);
	
	СоздатьЭлементыОтображенияПротоколов();
	
	Если ПроверятьПрограммойCheckUFA Тогда
		ОпределитьКаталогПрограммыСheckUFA(НастройкиПроверочныхПрограмм);
	КонецЕсли;
	
	Если ПроверятьПрограммойCheckXML Тогда
		ОпределитьКаталогПрограммыСheckXML(НастройкиПроверочныхПрограмм);
	КонецЕсли;
	
	Если ПроверятьПрограммойПОПД Тогда
		ОпределитьКаталогПрограммыПОПД(НастройкиПроверочныхПрограмм);
	КонецЕсли;
	
	Если ВыполнятьПроверкуНаСервере Тогда
		УстановитьИнфоНадписьНаличиеПрограммНаСервере();
		
		Если (ПроверятьПрограммойCheckUFA И ФайлПрограммыCheckUFAОбнаружен) 
			Или (ПроверятьПрограммойCheckXML И ФайлПрограммыCheckXMLОбнаружен)  
			Или (ПроверятьПрограммойПОПД И ФайлПрограммыПОПДОбнаружен) Тогда 
			
			СохранитьФайлыНаСервере();
			
		Иначе
			УстановитьСвойстваЭлементовПослеПроверки(ЭтаФорма, 0, 0, 0);
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВыполнятьПроверкуНаСервере Тогда
		ИнициализироватьПроверкуФайловВФоне();
	Иначе
		ОповещениеВопроса = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
		ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОповещениеВопроса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Истина Тогда 
		
		ТекстИсключения = НСтр("ru = 'Не подключено расширение работы с файлами. Проверка не возможна.';
								|en = 'File operation extension is not enabled. The check cannot be performed.'");		
		ПоказатьПредупреждение(, ТекстИсключения);
		
		Закрыть();
	КонецЕсли;	
	
	УстановитьИнфоНадписьНаличиеПрограммНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СохранитьИПроверитьФайлыПослеОткрытияФормы()
	Если Открыта() Тогда
		
		СохранитьФайлыНаКлиенте();	
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_СохранитьИПроверитьФайлыПослеОткрытияФормы", 0.1, Истина);
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененыПерсональныеНастройкиПроверочныхПрограммПФР" Тогда
		ПриИзмененииПерсональныхНастроек();	
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ПроверкаФайловПослеВыполненияДлительнойОперации(ЭтаФорма);
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаПрограмм(Команда)
	ПараметрыОткрытия = Новый Структура("БлокироватьОкноВладельца ", Истина);
	ОткрытьФорму("ОбщаяФорма.НастройкаПроверочныхПрограммПФРПерсональная", ПараметрыОткрытия, ЭтаФорма); 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

#Область ИнициализацияФормы

&НаСервере
Функция ОписаниеПроверяемыхФайловВДанныеФормы(ПроверяемыеОбъекты)
	ПроверяемыеФайлы = Новый Массив;
	
	Для Каждого СсылкаНаПроверяемыйОбъект Из ПроверяемыеОбъекты Цикл
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(СсылкаНаПроверяемыйОбъект);
		
		ОписаниеФайлов = МенеджерОбъекта.ВыгрузитьФайлыВоВременноеХранилище(СсылкаНаПроверяемыйОбъект, УникальныйИдентификатор);
		
		Для Каждого ОписаниеФайла Из ОписаниеФайлов Цикл
			ПроверяемыеФайлы.Добавить(Новый ФиксированнаяСтруктура(ОписаниеФайла));			
		КонецЦикла;	
	КонецЦикла;	
	
	// РСВ-1
	Если ЗначениеЗаполнено(РСВ_1)  
		И ЗначениеЗаполнено(АдресФайлаВыгрузкиРСВ) Тогда
		
		ОписаниеВыгруженногоФайла = ПерсонифицированныйУчет.ОписаниеВыгруженногоФайлаОтчетности();
		
		ОписаниеВыгруженногоФайла.Владелец = РСВ_1;
		ОписаниеВыгруженногоФайла.АдресВоВременномХранилище = АдресФайлаВыгрузкиРСВ;
		ОписаниеВыгруженногоФайла.ИмяФайла = ИмяФайлаВыгрузкиРСВ;
		ОписаниеВыгруженногоФайла.ФайлВСоставеКомплекта = Истина;
		ОписаниеВыгруженногоФайла.ПроверяемыйФайлКомплекта = ЕдинаяОтчетностьПФР;
		ОписаниеВыгруженногоФайла.ПроверятьCheckXML = Не ЕдинаяОтчетностьПФР;
		ОписаниеВыгруженногоФайла.ПроверятьCheckUFA = Истина;
		
		ПроверяемыеФайлы.Добавить(ОписаниеВыгруженногоФайла);	
	КонецЕсли;	
	
	ОписаниеПроверяемыхФайлов = Новый ФиксированныйМассив(ПроверяемыеФайлы);
КонецФункции	

&НаСервере
Процедура ОпределитьПроверочныеПрограммыДляФайлов(НастройкиПроверочныхПрограмм)
	
	Для Каждого ОписаниеФайла Из ОписаниеПроверяемыхФайлов Цикл
		Если ОписаниеФайла.ПроверятьCheckXML 
			И (НастройкиПроверочныхПрограмм = Неопределено 
			Или НастройкиПроверочныхПрограмм.ПроверятьПрограммойCheckXML) Тогда
			
			ПроверятьПрограммойCheckXML = Истина;
		КонецЕсли;	
		Если ОписаниеФайла.ПроверятьCheckUFA 
			И (НастройкиПроверочныхПрограмм = Неопределено  
			Или НастройкиПроверочныхПрограмм.ПроверятьПрограммойCheckUFA) Тогда
			
			ПроверятьПрограммойCheckUFA = Истина;
		КонецЕсли;
		Если ОписаниеФайла.ПроверятьПОПД 
			И (НастройкиПроверочныхПрограмм = Неопределено  
			Или НастройкиПроверочныхПрограмм.ПроверятьПрограммойПОПД) Тогда
			
			ПроверятьПрограммойПОПД = Истина;
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ОпределитьКаталогПрограммыСheckUFA(НастройкиПроверочныхПрограмм)
	Если НастройкиПроверочныхПрограмм <> Неопределено Тогда 
		КаталогПрограммыСheckUFA = НастройкиПроверочныхПрограмм.КаталогПрограммыCheckUFA;
	КонецЕсли;				
КонецФункции

&НаСервере
Функция ОпределитьКаталогПрограммыСheckXML(НастройкиПроверочныхПрограмм)
	Если НастройкиПроверочныхПрограмм <> Неопределено Тогда
		
		КаталогПрограммыСheckXml = НастройкиПроверочныхПрограмм.КаталогПрограммыCheckXML;
		
	КонецЕсли;	
КонецФункции

&НаСервере
Функция ОпределитьКаталогПрограммыПОПД(НастройкиПроверочныхПрограмм)
	
	Если НастройкиПроверочныхПрограмм <> Неопределено Тогда
		КаталогПрограммыПОПД = НастройкиПроверочныхПрограмм.КаталогПрограммыПОПД;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОпределитьНаличиеПроверочныхПрограммНаСервере()
	
	Если ПроверятьПрограммойCheckUFA Тогда	
		Файл = Новый Файл(КаталогПрограммыСheckUFA + "\Check.exe");
		
		ФайлПрограммыCheckUFAОбнаружен = Файл.Существует();
	КонецЕсли;
	
	Если ПроверятьПрограммойCheckXML Тогда
		Файл = Новый Файл(КаталогПрограммыСheckXml + "\CheckXML.exe");
		
		ФайлПрограммыCheckXMLОбнаружен = Файл.Существует();
	КонецЕсли;
	
	Если ПроверятьПрограммойПОПД Тогда
		Файл = Новый Файл(КаталогПрограммыПОПД + "\run.cmd");
		
		ФайлПрограммыПОПДОбнаружен = Файл.Существует();
	КонецЕсли;
	
КонецПроцедуры	


&НаСервере
Процедура СоздатьЭлементыОтображенияПротоколов()
	
	СоответствиеДокументовИменамРеквизитовCheckXML = Новый Соответствие;
	СоответствиеДокументовИменамРеквизитовCheckUFA = Новый Соответствие;
	СоответствиеДокументовИменамРеквизитовПОПД = Новый Соответствие;
	
	СоздаваемыеРеквизиты = Новый Массив;
	РеквизитыПротоколовCheckXML = Новый Массив;
	РеквизитыПротоколовCheckUFA = Новый Массив;
	РеквизитыПротоколовПОПД = Новый Массив;
	
	НомерФайла = 1;
	Для Каждого ОписаниеФайла Из ОписаниеПроверяемыхФайлов Цикл	
		Если ОписаниеФайла.ПроверятьCheckXML Тогда
			
			РеквизитПротоколаCheckXML = Новый РеквизитФормы("ПротоколПроверкиCheckXML" + НомерФайла, Новый ОписаниеТипов("Строка"),, ОписаниеФайла.ИмяФайла);
			
			СоздаваемыеРеквизиты.Добавить(РеквизитПротоколаCheckXML);
			РеквизитыПротоколовCheckXML.Добавить(РеквизитПротоколаCheckXML);
			
			СоответствиеДокументовИменамРеквизитовCheckXML.Вставить(ОписаниеФайла.Владелец, РеквизитПротоколаCheckXML.Имя);
		КонецЕсли;	
		
		Если ОписаниеФайла.ПроверятьCheckUFA
			И (Не ОписаниеФайла.ФайлВСоставеКомплекта 
			Или ОписаниеФайла.ПроверяемыйФайлКомплекта) Тогда

			Заголовок = ?(ОписаниеФайла.ФайлВСоставеКомплекта, НСтр("ru = 'Комплект файлов';
																	|en = 'Set of files'"), ОписаниеФайла.ИмяФайла); 
			
			РеквизитПротоколаCheckUFA = Новый РеквизитФормы("ПротоколПроверкиCheckUFA" + НомерФайла, Новый ОписаниеТипов("Строка"),, Заголовок);
			
			СоздаваемыеРеквизиты.Добавить(РеквизитПротоколаCheckUFA);
			РеквизитыПротоколовCheckUFA.Добавить(РеквизитПротоколаCheckUFA);
			
			СоответствиеДокументовИменамРеквизитовCheckUFA.Вставить(ОписаниеФайла.Владелец, РеквизитПротоколаCheckUFA.Имя);
		КонецЕсли;	
		
		Если ОписаниеФайла.ПроверятьПОПД Тогда
			
			РеквизитПротоколаПОПД = Новый РеквизитФормы("ПротоколПроверкиПОПД" + НомерФайла, Новый ОписаниеТипов("Строка"),, ОписаниеФайла.ИмяФайла);
			
			СоздаваемыеРеквизиты.Добавить(РеквизитПротоколаПОПД);
			РеквизитыПротоколовПОПД.Добавить(РеквизитПротоколаПОПД);
			
			СоответствиеДокументовИменамРеквизитовПОПД.Вставить(ОписаниеФайла.Владелец, РеквизитПротоколаПОПД.Имя);
		КонецЕсли;	
		
		НомерФайла = НомерФайла + 1;
	КонецЦикла;	
	
	ИзменитьРеквизиты(СоздаваемыеРеквизиты);
	
	СоответствиеСсылокРеквизитамПротоколовCheckUFA = Новый ФиксированноеСоответствие(СоответствиеДокументовИменамРеквизитовCheckUFA);
	СоответствиеСсылокРеквизитамПротоколовCheckXML = Новый ФиксированноеСоответствие(СоответствиеДокументовИменамРеквизитовCheckXML);
	СоответствиеСсылокРеквизитамПротоколовПОПД = Новый ФиксированноеСоответствие(СоответствиеДокументовИменамРеквизитовПОПД);
	
	Для Каждого Реквизит Из РеквизитыПротоколовCheckXML Цикл
		СтраницаПротокола = Элементы.Добавить(Реквизит.Имя + "Страница", Тип("ГруппаФормы"), Элементы.ПротоколыПроверкиCheckXML);
		СтраницаПротокола.Вид = ВидГруппыФормы.Страница;
		СтраницаПротокола.Заголовок = Реквизит.Заголовок; 	
		
		ПолеПротокола = Элементы.Добавить(Реквизит.Имя, Тип("ПолеФормы"), СтраницаПротокола);
		ПолеПротокола.ПутьКДанным = Реквизит.Имя;
		ПолеПротокола.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		ПолеПротокола.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЦикла;	
	
	Для Каждого Реквизит Из РеквизитыПротоколовCheckUFA Цикл
		СтраницаПротокола = Элементы.Добавить(Реквизит.Имя + "Страница", Тип("ГруппаФормы"), Элементы.ПротоколыПроверкиCheckUFA);
		СтраницаПротокола.Заголовок = Реквизит.Заголовок; 
		СтраницаПротокола.Вид = ВидГруппыФормы.Страница;
		
		ПолеПротокола = Элементы.Добавить(Реквизит.Имя, Тип("ПолеФормы"), СтраницаПротокола);
		ПолеПротокола.ПутьКДанным = Реквизит.Имя;
		ПолеПротокола.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		ПолеПротокола.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЦикла;	
	
	Для Каждого Реквизит Из РеквизитыПротоколовПОПД Цикл
		СтраницаПротокола = Элементы.Добавить(Реквизит.Имя + "Страница", Тип("ГруппаФормы"), Элементы.ПротоколыПроверкиПОПД);
		СтраницаПротокола.Заголовок = Реквизит.Заголовок; 
		СтраницаПротокола.Вид = ВидГруппыФормы.Страница;
		
		ПолеПротокола = Элементы.Добавить(Реквизит.Имя, Тип("ПолеФормы"), СтраницаПротокола);
		ПолеПротокола.ПутьКДанным = Реквизит.Имя;
		ПолеПротокола.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		ПолеПротокола.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьИнфоНадписьНаличиеПрограммНаСервере()
	Элементы.НастройкаПрограмм.Видимость = Ложь;
	
	ОпределитьНаличиеПроверочныхПрограммНаСервере();
	
	ОбнаруженыВсеПрограммы = (ФайлПрограммыCheckUFAОбнаружен Или Не ПроверятьПрограммойCheckUFA) 
								И (ФайлПрограммыCheckXMLОбнаружен Или Не ПроверятьПрограммойCheckXML)
								И (ФайлПрограммыПОПДОбнаружен Или Не ПроверятьПрограммойПОПД);
									
	ТекстИнфонадписиCheckUFA = "";
	ТекстИнфонадписиCheckXML = "";
	ТекстИнфонадписиПОПД = "";
	ТекстИнфонадписиДействие = "";
	
	ТекстНачалоСообщения = "";
	
	Если ПроверятьПрограммойCheckXML И ПроверятьПрограммойCheckUFA И ПроверятьПрограммойПОПД Тогда	
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программами CheckXML, CheckPFR и ПО ПД.';
									|en = 'Check with CheckXML, CheckPFR and Document Verification Software applications is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойCheckXML И ПроверятьПрограммойCheckUFA Тогда	
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программами CheckXML и CheckPFR.';
									|en = 'Check with CheckXML and CheckPF applications is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойCheckXML И ПроверятьПрограммойПОПД Тогда	
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программами CheckXML и ПО ПД.';
									|en = 'Check with CheckXML and Document Verification Software applications is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойCheckUFA И ПроверятьПрограммойПОПД Тогда	
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программами CheckPFR и ПО ПД.';
									|en = 'Check with CheckPFR and Document Verification Software applications is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойCheckXML Тогда
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программой CheckXML.';
									|en = 'Check with CheckXML application is configured.'") + " ";	
	ИначеЕсли ПроверятьПрограммойCheckUFA Тогда
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программой CheckPFR.';
									|en = 'Check with CheckPF application is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойПОПД Тогда
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программой ПО ПД.';
									|en = 'Check with Document Verification Software application is configured.'") + " ";
	КонецЕсли;	
		
	Если ОбнаруженыВсеПрограммы Тогда
		Инфонадпись = ТекстНачалоСообщения + НСтр("ru = 'Для изменения настроек обратитесь к администратору системы.';
													|en = 'To change the settings, contact the information system administrator. '");	
	Иначе
		Если ПроверятьПрограммойCheckUFA И Не ФайлПрограммыCheckUFAОбнаружен Тогда
			ТекстИнфонадписиCheckUFA = НСтр("ru = 'Не обнаружен файл программы CheckPFR.';
											|en = 'CheckPF file not found.'") + " ";
		КонецЕсли;
		Если ПроверятьПрограммойCheckXML И Не ФайлПрограммыCheckXMLОбнаружен Тогда
			ТекстИнфонадписиCheckXML = НСтр("ru = 'Не обнаружен файл программы CheckXML.';
											|en = 'CheckXML file not found.'") + " ";
		КонецЕсли;
		Если ПроверятьПрограммойПОПД И Не ФайлПрограммыПОПДОбнаружен Тогда
			ТекстИнфонадписиПОПД = НСтр("ru = 'Не обнаружен файл программы ПО ПД.';
										|en = 'Document Verification Software application file not found.'") + " ";
		КонецЕсли;
		ТекстИнфонадписиДействие = НСтр("ru = 'Обратитесь к администратору системы для настройки проверочных программ.';
										|en = 'Contact your administrator to set verification application settings.'");	
		
		Инфонадпись = ТекстНачалоСообщения + ТекстИнфонадписиCheckUFA + ТекстИнфонадписиCheckXML + ТекстИнфонадписиПОПД + ТекстИнфонадписиДействие;
	КонецЕсли;		
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьИнфоНадписьНаличиеПрограммНаКлиенте()
		
	ОпределитьНаличиеПроверочныхПрограммНаКлиенте();

КонецПроцедуры	

&НаКлиенте
Процедура ПослеПроверкиНаличияПрограммНаКлиенте() 
	ОбнаруженыВсеПрограммы = (ФайлПрограммыCheckUFAОбнаружен Или Не ПроверятьПрограммойCheckUFA) 
								И (ФайлПрограммыCheckXMLОбнаружен Или Не ПроверятьПрограммойCheckXML)
								И (ФайлПрограммыПОПДОбнаружен Или Не ПроверятьПрограммойПОПД);
								
	НеЗаданыНастройки = Не ПроверятьПрограммойCheckUFA И Не ПроверятьПрограммойCheckXML И Не ПроверятьПрограммойПОПД;							
									
	ТекстИнфонадписиCheckUFA = "";
	ТекстИнфонадписиCheckXML = "";
	ТекстИнфонадписиПОПД = "";
	ТекстИнфонадписиДействие = "";
	
	ТекстНачалоСообщения = "";
	
	Если ПроверятьПрограммойCheckXML И ПроверятьПрограммойCheckUFA И ПроверятьПрограммойПОПД Тогда	
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программами CheckXML, CheckPFR и ПО ПД.';
									|en = 'Check with CheckXML, CheckPFR and Document Verification Software applications is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойCheckXML И ПроверятьПрограммойCheckUFA Тогда	
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программами CheckXML и CheckPFR.';
									|en = 'Check with CheckXML and CheckPF applications is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойCheckXML И ПроверятьПрограммойПОПД Тогда	
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программами CheckXML и ПО ПД.';
									|en = 'Check with CheckXML and Document Verification Software applications is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойCheckUFA И ПроверятьПрограммойПОПД Тогда	
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программами CheckPFR и ПО ПД.';
									|en = 'Check with CheckPFR and Document Verification Software applications is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойCheckXML Тогда
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программой CheckXML.';
									|en = 'Check with CheckXML application is configured.'") + " ";	
	ИначеЕсли ПроверятьПрограммойCheckUFA Тогда
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программой CheckPFR.';
									|en = 'Check with CheckPF application is configured.'") + " ";
	ИначеЕсли ПроверятьПрограммойПОПД Тогда
		ТекстНачалоСообщения = НСтр("ru = 'Настроена проверка программой ПО ПД.';
									|en = 'Check with Document Verification Software application is configured.'") + " ";
	КонецЕсли;	

	Если ОбнаруженыВсеПрограммы Тогда
		Инфонадпись = ТекстНачалоСообщения + НСтр("ru = 'Для изменения настроек перейдите по ссылке.';
													|en = 'To change the settings, click the link.'");
	ИначеЕсли НеЗаданыНастройки Тогда
		Инфонадпись = НСтр("ru = 'Не заданы настройки. Чтобы задать настройки проверочных программ перейдите по ссылке.';
							|en = 'The settings are not specified. Click the link to set verification application settings.'");	
	Иначе
		Если ПроверятьПрограммойCheckUFA И Не ФайлПрограммыCheckUFAОбнаружен Тогда
			ТекстИнфонадписиCheckUFA = НСтр("ru = 'Не обнаружен файл программы CheckPFR.';
											|en = 'CheckPF file not found.'") + " ";
		КонецЕсли;
		Если ПроверятьПрограммойCheckXML И Не ФайлПрограммыCheckXMLОбнаружен Тогда
			ТекстИнфонадписиCheckXML = НСтр("ru = 'Не обнаружен файл программы CheckXML.';
											|en = 'CheckXML file not found.'") + " ";
		КонецЕсли;
		Если ПроверятьПрограммойПОПД И Не ФайлПрограммыПОПДОбнаружен Тогда
			ТекстИнфонадписиПОПД = НСтр("ru = 'Не обнаружен файл программы ПО ПД.';
										|en = 'Document Verification Software application file not found.'") + " ";
		КонецЕсли;
		ТекстИнфонадписиДействие = НСтр("ru = 'Установите персональные настройки проверочных программ.';
										|en = 'Set personal settings of verification applications.'");	
		Инфонадпись = ТекстНачалоСообщения + ТекстИнфонадписиCheckUFA + ТекстИнфонадписиCheckXML + ТекстИнфонадписиПОПД + ТекстИнфонадписиДействие;
	КонецЕсли;		
	
	Если (ПроверятьПрограммойCheckUFA И ФайлПрограммыCheckUFAОбнаружен) 
		Или (ПроверятьПрограммойCheckXML И ФайлПрограммыCheckXMLОбнаружен)  
		Или (ПроверятьПрограммойПОПД И ФайлПрограммыПОПДОбнаружен) Тогда
		
		Состояние(НСтр("ru = 'Проверка файлов';
						|en = 'Check files'"));
		ПодключитьОбработчикОжидания("Подключаемый_СохранитьИПроверитьФайлыПослеОткрытияФормы", 0.1, Истина);
		
	Иначе
		УстановитьСвойстваЭлементовПослеПроверки(ЭтаФорма, 0, 0, 0);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьНаличиеПроверочныхПрограммНаКлиенте()
	Если ПроверятьПрограммойCheckUFA Тогда	
		ОписаниеОповещение = Новый ОписаниеОповещения("ПослеИнициализацииФайлаCheckUFA", ЭтотОбъект);
		
		Файл = Новый Файл;
		Файл.НачатьИнициализацию(ОписаниеОповещение, КаталогПрограммыСheckUFA + "\Check.exe");
		
	Иначе
		ПослеПроверкиСуществованияCheckUFA(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИнициализацииФайлаCheckUFA(Файл, ДополнительныеПараметры) Экспорт
	ОписаниеОповещение = Новый ОписаниеОповещения("ПослеПроверкиСуществованияCheckUFA", ЭтотОбъект);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещение);		
КонецПроцедуры	


&НаКлиенте
Процедура ПослеПроверкиСуществованияCheckUFA(Существует, ДополнительныеПараметры = Неопределено) Экспорт 
	ФайлПрограммыCheckUFAОбнаружен = Существует;	
	
	Если ПроверятьПрограммойCheckXML Тогда
		ОписаниеОповещение = Новый ОписаниеОповещения("ПослеИнициализацииФайлаCheckXML", ЭтотОбъект);
		
		Файл = Новый Файл;
		Файл.НачатьИнициализацию(ОписаниеОповещение, КаталогПрограммыСheckXml + "\CheckXML.exe");
	
	Иначе
		ПослеПроверкиСуществованияCheckXML(Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеИнициализацииФайлаCheckXML(Файл, ДополнительныеПараметры) Экспорт
	ОписаниеОповещение = Новый ОписаниеОповещения("ПослеПроверкиСуществованияCheckXML", ЭтотОбъект);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещение);		
КонецПроцедуры	

&НаКлиенте
Процедура ПослеПроверкиСуществованияCheckXML(Существует, ДополнительныеПараметры = Неопределено) Экспорт 
	
	ФайлПрограммыCheckXMLОбнаружен = Существует;
	
	Если ПроверятьПрограммойПОПД Тогда
		ОписаниеОповещение = Новый ОписаниеОповещения("ПослеИнициализацииФайлаПОПД", ЭтотОбъект);
		
		Файл = Новый Файл;
		Файл.НачатьИнициализацию(ОписаниеОповещение, КаталогПрограммыПОПД + "\run.cmd");
	
	Иначе
		ПослеПроверкиСуществованияПОПД(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИнициализацииФайлаПОПД(Файл, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещение = Новый ОписаниеОповещения("ПослеПроверкиСуществованияПОПД", ЭтотОбъект);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещение);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПослеПроверкиСуществованияПОПД(Существует, ДополнительныеПараметры = Неопределено) Экспорт 
	
	ФайлПрограммыПОПДОбнаружен = Существует;
	ПослеПроверкиНаличияПрограммНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаФайлов

&НаКлиенте
Процедура ПриИзмененииПерсональныхНастроек()
	
	ПроверятьПрограммойCheckUFA = Ложь;
	ПроверятьПрограммойCheckXML = Ложь;
	ПроверятьПрограммойПОПД = Ложь;
	
	ФайлПрограммыCheckUFAОбнаружен = Ложь;
	ФайлПрограммыCheckXMLОбнаружен = Ложь;
	ФайлПрограммыПОПДОбнаружен = Ложь;
	
	ПриИзмененииПерсональныхНастроекНаСервере();
	
	Если Не ВыполнятьПроверкуНаСервере Тогда
		УстановитьИнфоНадписьНаличиеПрограммНаКлиенте();
		
		Если (ПроверятьПрограммойCheckUFA И ФайлПрограммыCheckUFAОбнаружен) 
			Или (ПроверятьПрограммойCheckXML И ФайлПрограммыCheckXMLОбнаружен) 
			Или (ПроверятьПрограммойПОПД И ФайлПрограммыПОПДОбнаружен) Тогда 
			
			СохранитьФайлыНаКлиенте();
			ИнициализироватьПроверкуФайловВФоне();
		Иначе
			УстановитьСвойстваЭлементовПослеПроверки(ЭтаФорма, 0, 0, 0);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПерсональныхНастроекНаСервере()
	НастройкиПроверочныхПрограмм = ПерсонифицированныйУчет.ПерсональныеНастройкиПрограммПроверкиОтчетности();
	
	ОпределитьПроверочныеПрограммыДляФайлов(НастройкиПроверочныхПрограмм);
	
	Если ПроверятьПрограммойCheckUFA Тогда
		ОпределитьКаталогПрограммыСheckUFA(НастройкиПроверочныхПрограмм);
	КонецЕсли;
	
	Если ПроверятьПрограммойCheckXML Тогда
		ОпределитьКаталогПрограммыСheckXML(НастройкиПроверочныхПрограмм);
	КонецЕсли;
	
	Если ПроверятьПрограммойПОПД Тогда
		ОпределитьКаталогПрограммыПОПД(НастройкиПроверочныхПрограмм);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаФайловПослеВыполненияДлительнойОперацииНаКлиенте(Параметры) Экспорт
	ПроверкаФайловПослеВыполненияДлительнойОперации(ЭтотОбъект);	
	УдалитьФайлыНаКлиенте();
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверкаФайловПослеВыполненияДлительнойОперации(Форма)
	
	РезультатыПроверки = ПолучитьИзВременногоХранилища(Форма.АдресХранилища);
	
	Если ТипЗнч(РезультатыПроверки) <> Тип("Структура") Тогда
		УстановитьСвойстваЭлементовПослеПроверки(Форма, 0, 0, 0);
		Возврат;
	КонецЕсли;
	
	СоответствиеФайловПротоколамПроверкиCheckXML = РезультатыПроверки.ПротоколыCheckXML; 
	СоответствиеФайловПротоколамПроверкиCheckUFA = РезультатыПроверки.ПротоколыCheckUFA; 
	СоответствиеФайловПротоколамПроверкиПОПД = РезультатыПроверки.ПротоколыПОПД; 
	
	КоличествоПротоколовCheckXML = 0;
	КоличествоПротоколовCheckUFA = 0;
	КоличествоПротоколовПОПД = 0;
	
	Для Каждого ОписаниеФайла Из Форма.ОписаниеПроверяемыхФайлов Цикл
		ТекстПротокола = СоответствиеФайловПротоколамПроверкиCheckXML.Получить(ОписаниеФайла.Владелец);
		
		ИмяРеквизитаПротокола = Форма.СоответствиеСсылокРеквизитамПротоколовCheckXML.Получить(ОписаниеФайла.Владелец);
		
		Если ЗначениеЗаполнено(ТекстПротокола)
			И ИмяРеквизитаПротокола <> Неопределено Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ИмяРеквизитаПротокола, ТекстПротокола);
			
			КоличествоПротоколовCheckXML = КоличествоПротоколовCheckXML + 1;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ОписаниеФайла Из Форма.ОписаниеПроверяемыхФайлов Цикл
		ТекстПротокола = СоответствиеФайловПротоколамПроверкиCheckUFA.Получить(ОписаниеФайла.Владелец);
		
		ИмяРеквизитаПротокола = Форма.СоответствиеСсылокРеквизитамПротоколовCheckUFA.Получить(ОписаниеФайла.Владелец);
		
		Если ЗначениеЗаполнено(ТекстПротокола)
			И ИмяРеквизитаПротокола <> Неопределено Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ИмяРеквизитаПротокола, ТекстПротокола);
			
			КоличествоПротоколовCheckUFA = КоличествоПротоколовCheckUFA + 1;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ОписаниеФайла Из Форма.ОписаниеПроверяемыхФайлов Цикл
		ТекстПротокола = СоответствиеФайловПротоколамПроверкиПОПД.Получить(ОписаниеФайла.Владелец);
		
		ИмяРеквизитаПротокола = Форма.СоответствиеСсылокРеквизитамПротоколовПОПД.Получить(ОписаниеФайла.Владелец);
		
		Если ЗначениеЗаполнено(ТекстПротокола)
			И ИмяРеквизитаПротокола <> Неопределено Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ИмяРеквизитаПротокола, ТекстПротокола);
			
			КоличествоПротоколовПОПД = КоличествоПротоколовПОПД + 1;
		КонецЕсли;
	КонецЦикла;
	
	УстановитьСвойстваЭлементовПослеПроверки(Форма, КоличествоПротоколовCheckUFA, КоличествоПротоколовCheckXML, КоличествоПротоколовПОПД);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыПроверкиФайлов(Форма)
	
	СтруктураПараметров = ПерсонифицированныйУчетКлиентСервер.ПараметрыПроверкиФайловСтороннимиПрограммами();
	
	СтруктураПараметров.ПроверятьПрограммойCheckXML = Форма.ПроверятьПрограммойCheckXML;
	СтруктураПараметров.ФайлПрограммыCheckXMLОбнаружен = Форма.ФайлПрограммыCheckXMLОбнаружен;
	СтруктураПараметров.КаталогПрограммыСheckXml = Форма.КаталогПрограммыСheckXml;
	
	СтруктураПараметров.ПроверятьПрограммойCheckUFA = Форма.ПроверятьПрограммойCheckUFA;
	СтруктураПараметров.ФайлПрограммыCheckUFAОбнаружен = Форма.ФайлПрограммыCheckUFAОбнаружен;
	СтруктураПараметров.КаталогПрограммыСheckUFA = Форма.КаталогПрограммыСheckUFA;
	
	СтруктураПараметров.ПроверятьПрограммойПОПД = Форма.ПроверятьПрограммойПОПД;
	СтруктураПараметров.ФайлПрограммыПОПДОбнаружен = Форма.ФайлПрограммыПОПДОбнаружен;
	СтруктураПараметров.КаталогПрограммыПОПД = Форма.КаталогПрограммыПОПД;
	
	СтруктураПараметров.КаталогФайлов = Форма.КаталогФайлов;
	СтруктураПараметров.ОписаниеПроверяемыхФайлов = Форма.ОписаниеПроверяемыхФайлов;
	СтруктураПараметров.ПутиКФайлам = Форма.ПутиКФайлам;

	Возврат СтруктураПараметров;
	
КонецФункции	

&НаКлиенте
Процедура ПроверитьФайлыНаКлиенте()
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	СтруктураПараметров = ПараметрыПроверкиФайлов(ЭтаФорма);
	
	Оповещение = Новый ОписаниеОповещения("ПроверкаФайловПослеВыполненияДлительнойОперацииНаКлиенте", ЭтотОбъект);
	
	ПерсонифицированныйУчетКлиент.ПроверитьФайлыСтороннимиПрограммами(СтруктураПараметров, АдресХранилища, Оповещение);
КонецПроцедуры	

&НаКлиенте
Процедура ИнициализироватьПроверкуФайловВФоне()
	
	Результат = РезультатПроверкиФайловВДлительнойОперации();
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РезультатПроверкиФайловВДлительнойОперации()
	
	СтруктураПараметров = ПараметрыПроверкиФайлов(ЭтаФорма);
	
	НаименованиеЗадания = НСтр("ru = 'Проверка файлов';
								|en = 'Check files'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"ПерсонифицированныйУчет.ПроверитьФайлыСтороннимиПрограммами",
		СтруктураПараметров,
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ПроверкаФайловПослеВыполненияДлительнойОперации(ЭтаФорма);
		
		УдалитьФайлыНаСервере();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовПослеПроверки(Форма, КоличествоПротоколовCheckUFA, КоличествоПротоколовCheckXML, КоличествоПротоколовПОПД)
	Элементы = Форма.Элементы;
	
	Элементы.СтраницыПротоколовCheckUFA.Видимость = КоличествоПротоколовCheckUFA > 0;
	
	Если КоличествоПротоколовCheckUFA > 1 Тогда 
		Элементы.ПротоколыПроверкиCheckUFA.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.ПротоколыПроверкиCheckUFA.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;	
	КонецЕсли;	
	
	Элементы.СтраницыПротоколовCheckXML.Видимость = КоличествоПротоколовCheckXML > 0;
	
	Если КоличествоПротоколовCheckXML > 1 Тогда 
		Элементы.ПротоколыПроверкиCheckXML.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.ПротоколыПроверкиCheckXML.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;	
	КонецЕсли;	
	
	Если КоличествоПротоколовПОПД > 1 Тогда 
		Элементы.ПротоколыПроверкиПОПД.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.ПротоколыПроверкиПОПД.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;	
	КонецЕсли;	
	
	Если ?(КоличествоПротоколовCheckUFA > 0, 1, 0) + ?(КоличествоПротоколовCheckXML > 0, 1, 0) + ?(КоличествоПротоколовПОПД > 0, 1, 0) > 1 Тогда
		Элементы.СтраницыПроверочныхПрограмм.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#Область СохранениеФайлов

&НаСервере
Процедура СохранитьФайлыНаСервере()
	УстановитьПривилегированныйРежим(Истина);
	
	СоответствиеВладельцевПутиКФайлу = Новый Соответствие;
	
	КаталогФайлов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла(""));	
	
	СоздатьКаталог(КаталогФайлов);
	
	Для Каждого ОписаниеФайла Из ОписаниеПроверяемыхФайлов Цикл
		ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ОписаниеФайла.АдресВоВременномХранилище);
		
		Файл = Новый Файл(КаталогФайлов + "\" + ОписаниеФайла.ИмяФайла);
		
		ДвоичныеДанныеФайла.Записать(Файл.ПолноеИмя);
		
		СоответствиеВладельцевПутиКФайлу.Вставить(ОписаниеФайла.Владелец, Файл.ПолноеИмя);
	КонецЦикла;	
	
	ПутиКФайлам = Новый ФиксированноеСоответствие(СоответствиеВладельцевПутиКФайлу);
КонецПроцедуры	

&НаКлиенте
Процедура СохранитьФайлыНаКлиенте()
		
	СоответствиеВладельцевПутиКФайлу = Новый Соответствие;

	#Если Не ВебКлиент Тогда
		КаталогФайлов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла(""));
		ВыбранныеФайлы = Новый Массив;
		ВыбранныеФайлы.Добавить(КаталогФайлов);
		
		ПослеВыбораКаталогаДляСохраненияФайлов(ВыбранныеФайлы);
	#Иначе
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ВыборФайла.МножественныйВыбор = Ложь;
		ВыборФайла.Заголовок = НСтр("ru = 'Укажите каталог, для сохранения файлов комплекта.';
									|en = 'Specify a directory to save the set files.'");
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораКаталогаДляСохраненияФайлов", ЭтотОбъект);
		
		ВыборФайла.Показать(Оповещение);
				
	#КонецЕсли	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораКаталогаДляСохраненияФайлов(ВыбранныеФайлы, ДополнительныеПараметры = Неопределено) Экспорт
	Если ВыбранныеФайлы = Неопределено
		Или ВыбранныеФайлы.Количество() = 0 Тогда
		
		Возврат;
	КонецЕсли;	
	
	ИмяКаталога = ВыбранныеФайлы[0];
	
	КаталогФайлов = ИмяКаталога + Строка(Новый УникальныйИдентификатор);	
	
	Оповещение = Новый ОписаниеОповещения("ПослеСозданияКаталогаДляСохраненияФайлов", ЭтотОбъект);		
	
	НачатьСозданиеКаталога(Оповещение, КаталогФайлов);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПослеСозданияКаталогаДляСохраненияФайлов(ИмяКаталога, ДополнительныеПараметры) Экспорт
	СоответствиеВладельцевПутиКФайлу = Новый Соответствие;
	
	ПолучаемыеФайлы = Новый Массив;
	Для Каждого ОписаниеФайла Из ОписаниеПроверяемыхФайлов Цикл
		ПолучаемыйФайл = Новый ОписаниеПередаваемогоФайла(КаталогФайлов + "\" + ОписаниеФайла.ИмяФайла, ОписаниеФайла.АдресВоВременномХранилище);
		СоответствиеВладельцевПутиКФайлу.Вставить(ОписаниеФайла.Владелец, КаталогФайлов + "\" + ОписаниеФайла.ИмяФайла); 
		ПолучаемыеФайлы.Добавить(ПолучаемыйФайл);
	КонецЦикла;	
	
	ПутиКФайлам = Новый ФиксированноеСоответствие(СоответствиеВладельцевПутиКФайлу);	
	ПолученныеФайлы = Новый Массив;
			                                  
	Если ПолучаемыеФайлы.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеСохраненияФайловНаКлиенте", ЭтотОбъект);
		
		НачатьПолучениеФайлов(Оповещение, ПолучаемыеФайлы, КаталогФайлов, Ложь);
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ПослеСохраненияФайловНаКлиенте(ПолученныеФайлы, ДополнительныеПараметры) Экспорт 
	ПроверитьФайлыНаКлиенте();		
КонецПроцедуры	

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаСервере
Процедура УдалитьФайлыНаСервере()
	Файл = Новый Файл(КаталогФайлов);
	
	Если Файл.Существует() И Файл.ЭтоКаталог() Тогда
		УдалитьФайлы(КаталогФайлов);
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлыНаКлиенте()
	Файл = Новый Файл;
	
	Оповещение = Новый ОписаниеОповещения("ПослеИнициализацииУдаляемогоКаталога", ЭтотОбъект);
	
	Файл.НачатьИнициализацию(Оповещение, КаталогФайлов);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПослеИнициализацииУдаляемогоКаталога(Файл, ДополнительныеПараметры) Экспорт
	Оповещение = Новый ОписаниеОповещения("ПослеПроверкиСуществованияВременногоКаталога", ЭтотОбъект);
	
	Файл.НачатьПроверкуСуществования(Оповещение);
КонецПроцедуры	

&НаКлиенте
Процедура ПослеПроверкиСуществованияВременногоКаталога(Существует, ДополнительныеПараметры) Экспорт 
	Если Существует Тогда
		НачатьУдалениеФайлов(, КаталогФайлов);
	КонецЕсли;		
КонецПроцедуры	


#КонецОбласти

#КонецОбласти
