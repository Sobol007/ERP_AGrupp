///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастроитьПорядокГруппыВсеВнешниеПользователи(Список);
	
	Если Параметры.РежимВыбора Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		// Исключение выбора группы Все внешние пользователи в качестве родителя.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи,
			ВидСравненияКомпоновкиДанных.НеРавно, , Параметры.Свойство("ВыборРодителя"));
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Заголовок = НСтр("ru = 'Подбор групп внешних пользователей';
							|en = 'Select external user groups'");
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок = НСтр("ru = 'Выбор группы внешних пользователей';
							|en = 'Select an external user group'");
		КонецЕсли;
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	СписокПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьПорядокГруппыВсеВнешниеПользователи(Список)
	
	Перем Порядок;
	
	// Порядок.
	Порядок = Список.КомпоновщикНастроек.Настройки.Порядок;
	Порядок.ИдентификаторПользовательскойНастройки = "ОсновнойПорядок";
	
	Порядок.Элементы.Очистить();
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Предопределенный");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриИзмененииНаСервере()
	
	ПользователиСлужебный.ПослеИзмененияПользователяИлиГруппыПользователейВФорме();
	
КонецПроцедуры

#КонецОбласти
