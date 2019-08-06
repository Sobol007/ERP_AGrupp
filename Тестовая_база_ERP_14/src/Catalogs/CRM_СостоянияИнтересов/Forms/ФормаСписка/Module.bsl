
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СоздатьСценарий(Команда)
	ОткрытьФорму("Обработка.CRM_НастройкаСценарияПродаж.Форма.Форма", Новый Структура("Сценарий", СоздатьСценарийСервер()), ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СоздатьСценарийСервер()
	НовыйСценарийИнтереса = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйСценарийИнтереса.Наименование = НСтр("ru = 'Новый сценарий'");
	НовыйСценарийИнтереса.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйСценарийИнтереса.Записать();
	Возврат НовыйСценарийИнтереса.Ссылка;
КонецФункции

&НаКлиенте
Процедура СоздатьСостояние(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	Если ЗначениеЗаполнено(ТекущиеДанные.Родитель) Тогда
		ТекРодитель = ТекущиеДанные.Родитель;
	Иначе	
		ТекРодитель = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекРодитель) Тогда
		ПараметрыСтруктура = Новый Структура("ЗначенияЗаполнения", Новый Структура("Родитель", ТекРодитель));
	Иначе
		ПараметрыСтруктура = Новый Структура("ЗначенияЗаполнения", Новый Структура("Родитель"));
	КонецЕсли;
	ОткрытьФорму("Справочник.CRM_СостоянияИнтересов.Форма.ФормаЭлемента", ПараметрыСтруктура, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Родитель) Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Обработка.CRM_НастройкаСценарияПродаж.Форма.Форма", Новый Структура("Сценарий", ВыбраннаяСтрока), ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование И НЕ ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Родитель) Тогда
		Отказ = Истина;
		НовыйСценарий = СкопироватьСценарийСервер(Элементы.Список.ТекущиеДанные.Ссылка);
		ОткрытьФорму("Обработка.CRM_НастройкаСценарияПродаж.Форма.Форма", Новый Структура("Сценарий", НовыйСценарий), ЭтотОбъект);
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = НовыйСценарий;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СкопироватьСценарийСервер(КопируемыйСценарий)
	
	НовыйСценарийИнтереса = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйСценарийИнтереса.Наименование = КопируемыйСценарий.Наименование;
	НовыйСценарийИнтереса.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйСценарийИнтереса.Записать();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_СостоянияИнтересов.Ссылка КАК Ссылка,
	                      |	CRM_СостоянияИнтересов1.Ссылка КАК СсылкаНового,
	                      |	CRM_СостоянияИнтересов.Наименование КАК Наименование,
	                      |	CRM_СостоянияИнтересов1.Наименование КАК НаименованиеНового
	                      |ИЗ
	                      |	Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов1
	                      |		ПО CRM_СостоянияИнтересов.ВидСостояния = CRM_СостоянияИнтересов1.ВидСостояния
	                      |			И (CRM_СостоянияИнтересов1.Родитель = &НовыйСценарий)
	                      |ГДЕ
	                      |	НЕ CRM_СостоянияИнтересов.ПометкаУдаления
	                      |	И CRM_СостоянияИнтересов.Родитель = &КопируемыйСценарий
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	CRM_СостоянияИнтересов.РеквизитДопУпорядочивания");
	Запрос.УстановитьПараметр("КопируемыйСценарий", КопируемыйСценарий);
	Запрос.УстановитьПараметр("НовыйСценарий", НовыйСценарийИнтереса.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.СсылкаНового) Тогда
			Состояние = Выборка.СсылкаНового.ПолучитьОбъект();
			ЗаполнитьЗначенияСвойств(Состояние, Выборка.Ссылка, , "Код, Владелец, Ссылка");
			Состояние.Родитель = НовыйСценарийИнтереса.Ссылка;
			Состояние.Записать();
		Иначе
			НовоеСостояние = Выборка.Ссылка.Скопировать();
			НовоеСостояние.Родитель = НовыйСценарийИнтереса.Ссылка;
			НовоеСостояние.Записать();
		КонецЕсли;
	КонецЦикла;
	Возврат НовыйСценарийИнтереса.Ссылка;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененоСостояниеИнтереса" ИЛИ ИмяСобытия = "ИзмененСценарийИнтереса" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
