#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "АнализРасхожденийПриПоступленииПродукцииВЕТИС_Накладная" Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	ДокументВЕТИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ВходящаяТранспортнаяОперацияВЕТИС КАК ДокументВЕТИС
				|ГДЕ
				|	ДокументВЕТИС.Ссылка В(&МассивСсылок)";
			
			Запрос.УстановитьПараметр("МассивСсылок", Параметры.ПараметрКоманды);
			МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОснование");
			
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("ДокументВЕТИС", МассивСсылок);
			
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "АнализРасхожденийПриПоступленииПродукцииВЕТИС" Тогда
			
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("ДокументВЕТИС", Параметры.ПараметрКоманды);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли