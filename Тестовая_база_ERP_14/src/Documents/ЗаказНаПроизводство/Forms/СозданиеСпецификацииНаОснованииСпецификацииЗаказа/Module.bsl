
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоУпаковокПриИзменении(Элемент)
	
	РассчитатьКоличество();
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	РассчитатьКоличество();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСоздатьСпецификацию(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(Новый Структура("НаименованиеСпецификации,Количество,Описание", НаименованиеСпецификации, Количество, Описание));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РесурсныеСпецификации.Наименование КАК Наименование,
	|	Номенклатура.Представление КАК Номенклатура,
	|	Характеристика.Представление КАК Характеристика,
	|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Номенклатура.ИспользоватьУпаковки КАК ИспользоватьУпаковки
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК Характеристика
	|		ПО (Характеристика.Ссылка = &Характеристика)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РесурсныеСпецификации КАК РесурсныеСпецификации
	|		ПО (РесурсныеСпецификации.Ссылка = &Спецификация)
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РесурсныеСпецификацииВыходныеИзделия.Количество,
	|	РесурсныеСпецификацииВыходныеИзделия.КоличествоУпаковок,
	|	РесурсныеСпецификацииВыходныеИзделия.Упаковка
	|ИЗ
	|	Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК РесурсныеСпецификацииВыходныеИзделия
	|ГДЕ
	|	РесурсныеСпецификацииВыходныеИзделия.Ссылка = &Спецификация
	|	И РесурсныеСпецификацииВыходныеИзделия.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Спецификация", Параметры.Спецификация);
	Запрос.УстановитьПараметр("Номенклатура", Параметры.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Параметры.Характеристика);
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаНоменклатура = Результат[0].Выбрать();
	ВыборкаКоличество = Результат[1].Выбрать();
	
	ВыборкаНоменклатура.Следующий();
	ВыборкаКоличество.Следующий();
	
	НаименованиеПродукции = ВыборкаНоменклатура.Номенклатура;
	Если ЗначениеЗаполнено(ВыборкаНоменклатура.Характеристика) Тогда
		НаименованиеПродукции = НаименованиеПродукции + ", " + ВыборкаНоменклатура.Характеристика;
	КонецЕсли; 
	
	Номенклатура = Параметры.Номенклатура;
	
	Если ЗначениеЗаполнено(ВыборкаНоменклатура.Наименование) Тогда
		НаименованиеСпецификации = "" + ВыборкаНоменклатура.Наименование + " " + НСтр("ru = '(копия)';
																						|en = '(copy)'");
	Иначе
		НаименованиеСпецификации = "";
	КонецЕсли;
	
	ЕдиницаИзмерения = ВыборкаНоменклатура.ЕдиницаИзмерения;
	
	Количество = ВыборкаКоличество.Количество;
	КоличествоУпаковок = ВыборкаКоличество.КоличествоУпаковок;
	Упаковка = ВыборкаКоличество.Упаковка;
	
	Справочники.УпаковкиЕдиницыИзмерения.ОтобразитьИнформациюОЕдиницеХранения(Номенклатура, Элементы.Упаковка);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры")
		ИЛИ НЕ ВыборкаНоменклатура.ИспользоватьУпаковки Тогда
		Элементы.СтраницыУпаковкаЕдИзм.ТекущаяСтраница = Элементы.СтраницаЕдИзм;
	Иначе
		Элементы.СтраницыУпаковкаЕдИзм.ТекущаяСтраница = Элементы.СтраницаУпаковка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьКоличество()
	
	Коэффициент = КоэффициентУпаковки(Упаковка, Номенклатура);
	Количество = КоличествоУпаковок * Коэффициент;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоэффициентУпаковки(Упаковка, Номенклатура)
	
	Возврат Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
	
КонецФункции

#КонецОбласти
