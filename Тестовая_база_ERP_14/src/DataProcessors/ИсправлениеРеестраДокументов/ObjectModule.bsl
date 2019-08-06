#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	
Процедура ОчиститьНесуществующиеСсылкиВРеестреДокументовВФоне(Параметры, АдресРезультата) Экспорт
	
	РезультатВыполнения = Обработки.ИсправлениеРеестраДокументов.ОчиститьНесуществующиеСсылкиВРеестреДокументов();
	
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресРезультата);
	
КонецПроцедуры

Процедура ПереотразитьДокументыВРеестреДокументов(Параметры, АдресРезультата) Экспорт
	
	МетаданныеРегистра    = Метаданные.НайтиПоПолномуИмени("РегистрСведений.РеестрДокументов");
	ТипыРеестраДокументов = МетаданныеРегистра.Измерения.Ссылка.Тип.Типы();
	
	ДокументыКОтражениюВРеестре = Новый Соответствие;
	Для Каждого ТипДокумента Из ТипыРеестраДокументов Цикл
		
		МетаданныеДокумента = Метаданные.НайтиПоТипу(ТипДокумента);
		ДокументыКОтражениюВРеестре.Вставить(МетаданныеДокумента);
		
	КонецЦикла;
	
	Если ДокументыКОтражениюВРеестре.Количество() > 0 Тогда
		РегистрыСведений.РеестрДокументов.ОтразитьДанныеДокументовВРеестре(ДокументыКОтражениюВРеестре);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли