
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЧтениеИзВременногоХранилища();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда 
		Если Модифицированность Тогда
			Отказ = Истина;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("Модифицированность", Модифицированность);
	
	Если Модифицированность Тогда 
		АдресХранилища = ВременноеХранилищеРеквизитов();
		ПараметрыЗакрытия.Вставить("АдресХранилища", АдресХранилища);
	КонецЕсли;	
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, ПараметрыЗакрытия); 
	ОписаниеОповещенияОЗакрытии = Неопределено;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


&НаСервере
Функция ВременноеХранилищеРеквизитов()
	
	МетаданныеОбъекта = РеквизитФормыВЗначение("Объект").Метаданные();
	АдресХранилища = РЭЙ_СлужебныйСервер.ВременноеХранилищеРеквизитов(Объект, МетаданныеОбъекта, УникальныйИдентификатор);
	
	Возврат АдресХранилища;
	
КонецФункции

&НаСервере
Процедура ЧтениеИзВременногоХранилища()
	
	Если Параметры.Свойство("АдресВременногоХранилища")  Тогда 
		
		РЭЙ_СлужебныйСервер.ЗаполнитьСвойстваОбъектаИзВременногоХранилища(Объект, Параметры.АдресВременногоХранилища);
		
	КонецЕсли;	
	
КонецПроцедуры

