///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает описание предопределенных наборов свойств.
//
// Параметры:
//  Наборы - ДеревоЗначений - с колонками:
//     * Имя           - Строка - Имя набора свойств. Формируется из полного имени объекта
//                       метаданных заменой символа "." на "_".
//                       Например, "Документ_ЗаказПокупателя".
//     * Идентификатор - УникальныйИдентификатор - Идентификатор ссылки предопределенного элемента.
//     * Используется  - Неопределено, Булево - Признак того, что набор свойств используется.
//                       Например, можно использовать для скрытия набора по функциональным опциям.
//                       Значение по умолчанию - Неопределено, соответствует значению Истина.
//     * ЭтоГруппа     - Булево - Истина, если набор свойств является группой.
//
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	
	
КонецПроцедуры

// Получает наименования наборов свойств второго уровня на разных языках.
//
// Параметры:
//  Наименования - Соответствие - представление набора на переданном языке:
//     * Ключ     - Строка - Имя набора свойств. Например, "Справочник_Партнеры_Общие".
//     * Значение - Строка - Наименование набора для переданного кода языка.
//  КодЯзыка - Строка - Код языка. Например, "en".
//
// Пример:
//  Наименования["Справочник_Партнеры_Общие"] = НСтр("ru='Общие'; en='General';", КодЯзыка);
//
Процедура ПриПолученииНаименованийНаборовСвойств(Наименования, КодЯзыка) Экспорт
	
	
	
КонецПроцедуры

// Заполняет наборы свойств объекта. Обычно требуется, если наборов более одного.
//
// Параметры:
//  Объект       - ЛюбаяСсылка      - ссылка на объект со свойствами.
//               - УправляемаяФорма - форма объекта, к которому подключены свойства.
//               - ДанныеФормыСтруктура - описание объекта, к которому подключены свойства.
//
//  ТипСсылки    - Тип - тип ссылки владельца свойств.
//
//  НаборыСвойств - ТаблицаЗначений - с колонками:
//                    Набор - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//                    ОбщийНабор - Булево - Истина, если набор свойств содержит свойства,
//                     общие для всех объектов.
//                    // Далее свойства элемента формы типа ГруппаФормы вида обычная группа
//                    // или страница, которая создается, если наборов больше одного без учета
//                    // пустого набора, который описывает свойства группы удаленных реквизитов.
//                    
//                    // Если значение Неопределено, значит, использовать значение по умолчанию.
//                    
//                    // Для любой группы управляемой формы.
//                    Высота                   - Число.
//                    Заголовок                - Строка.
//                    Подсказка                - Строка.
//                    РастягиватьПоВертикали   - Булево.
//                    РастягиватьПоГоризонтали - Булево.
//                    ТолькоПросмотр           - Булево.
//                    ЦветТекстаЗаголовка      - Цвет.
//                    Ширина                   - Число.
//                    ШрифтЗаголовка           - Шрифт.
//                    
//                    // Для обычной группы и страницы.
//                    Группировка              - ГруппировкаПодчиненныхЭлементовФормы.
//                    
//                    // Для обычной группы.
//                    Отображение              - ОтображениеОбычнойГруппы.
//                    
//                    // Для страницы.
//                    Картинка                 - Картинка.
//                    ОтображатьЗаголовок      - Булево.
//
//  СтандартнаяОбработка - Булево - начальное значение Истина. Указывает, получать ли
//                         основной набор, когда НаборыСвойств.Количество() равно нулю.
//
//  КлючНазначения   - Неопределено - (начальное значение) - указывает вычислить
//                      ключ назначения автоматически и добавить к значениям свойств
//                      формы КлючНазначенияИспользования и КлючСохраненияПоложенияОкна,
//                      чтобы изменения формы (настройки, положение и размер) сохранялись
//                      отдельно для разного состава наборов.
//                      Например, для каждого вида номенклатуры - свой состав наборов.
//
//                    - Строка - (не более 32 символа) - использовать указанный ключ
//                      назначения для добавления к значениям свойств формы.
//                      Пустая строка - не изменять свойства ключей формы, т.к. они
//                      устанавливается в форме и уже учитывают различия состава наборов.
//
//                    Добавка имеет формат "КлючНаборовСвойств<КлючНазначения>",
//                    чтобы <КлючНазначения> можно было обновлять без повторной добавки.
//                    При автоматическом вычислении <КлючНазначения> содержит хэш
//                    идентификаторов ссылок упорядоченных наборов свойств.
//
Процедура ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка, КлючНазначения) Экспорт
	
	// +CRM
	CRM_УправлениеСвойствамиПереопределяемый.ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка, КлючНазначения);
	// -CRM
	
	//++ НЕ ГОСИС
	Если ТипСсылки = Тип("СправочникСсылка.Партнеры") Тогда
		
		СписокСвойств = ПолучитьНаборыСвойствДляПартнеров(Объект.Клиент, Объект.Конкурент, Объект.Поставщик, Объект.ПрочиеОтношения);
		
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.Номенклатура") И НЕ Объект.ЭтоГруппа Тогда
		
		СписокСвойств = ПолучитьНаборыСвойствДляНоменклатуры(Объект);
		
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
		
		СписокСвойств = ПолучитьНаборыСвойствДляХарактеристикНоменклатуры(Объект);
		
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.СерииНоменклатуры") Тогда
		
		СписокСвойств = ПолучитьНаборыСвойствДляСерииНоменклатуры(Объект);
		
	//++ НЕ УТ
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		
		СписокСвойств = ПолучитьНаборыСвойствДляОбъектаЭксплуатации(Объект);
		
	//-- НЕ УТ
	//++ НЕ УТКА
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.УзлыОбъектовЭксплуатации") Тогда
		
		СписокСвойств = ПолучитьНаборыСвойствДляУзлаОбъектаЭксплуатации(Объект);
		
	ИначеЕсли ТипСсылки = Тип("ДокументСсылка.ПроизводственнаяОперация2_2") Тогда
		
		СписокСвойств = ПолучитьНаборыСвойствДляПроизводственнойОперации(Объект);
		
	//-- НЕ УТКА
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокСвойств Цикл
		
		СтрокаНабора = НаборыСвойств.Добавить();
		
		СтрокаНабора.Набор 	   = ЭлементСписка.Значение;
		СтрокаНабора.Заголовок = ЭлементСписка.Представление;
		
	КонецЦикла;
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ РАБОТЫ СО СПРАВОЧНИКОМ ПАРТНЕРЫ

// Возвращает список значений, состоящий из наборов свойств справочника "Партнеры".
//
// Параметры:
//  Клиент    			- Тип - булево.
//  Конкурент    		- Тип - булево.
//  Поставщик    		- Тип - булево.
//  ПрочиеОтношения    	- Тип - булево.
//
// ВозвращаемоеЗначение:
//  Наборы - СписокЗначений - Элементы справочника "НаборыДополнительныхРеквизитовИСведений".
//
Функция ПолучитьНаборыСвойствДляПартнеров(Клиент, Конкурент, Поставщик, ПрочиеОтношения) Экспорт
	
	Наборы = Новый СписокЗначений;
	//++ НЕ ГОСИС
	Наборы.Добавить(Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Партнеры_Общие, НСтр("ru = 'Общие для всех партнеров';
																										|en = 'Common for all partners'"));
	
	Если Клиент Тогда
		Наборы.Добавить(Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Партнеры_Клиенты,    НСтр("ru = 'Для клиентов';
																												|en = 'For customers'"));
	КонецЕсли;
	
	Если Конкурент Тогда
		Наборы.Добавить(Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Партнеры_Конкуренты, НСтр("ru = 'Для конкурентов';
																												|en = 'For competitors'"));
	КонецЕсли;
	
	Если Поставщик Тогда
		Наборы.Добавить(Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Партнеры_Поставщики, НСтр("ru = 'Для поставщиков';
																												|en = 'For suppliers'"));
	КонецЕсли;
	
	Если ПрочиеОтношения Тогда
		Наборы.Добавить(Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Партнеры_Прочие,     НСтр("ru = 'Для прочих';
																												|en = 'For other'"));
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат Наборы;
	
КонецФункции // ПолучитьНаборыСвойствДляПартнеров()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ РАБОТЫ СО СПРАВОЧНИКОМ НОМЕНКЛАТУРЫ

Функция ПолучитьНаборыСвойствДляНоменклатуры(Объект)
	
	Наборы = Новый СписокЗначений;
	//++ НЕ ГОСИС
	НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Номенклатура_Общие;
	Наборы.Добавить(НаборСвойств, НСтр("ru = 'Общие свойства';
										|en = 'Common properties'"));
	
	НаборСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВидНоменклатуры, "НаборСвойств");
	Наборы.Добавить(НаборСвойств, НСтр("ru = 'Свойства для вида номенклатуры';
										|en = 'Properties for product kind'"));
	//-- НЕ ГОСИС
	Возврат Наборы;
	
КонецФункции

Функция ПолучитьНаборыСвойствДляХарактеристикНоменклатуры(Объект)
	
	Наборы = Новый СписокЗначений;
	
	//++ НЕ ГОСИС
	
	НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_ХарактеристикиНоменклатуры_Общие;
	Наборы.Добавить(НаборСвойств, НСтр("ru = 'Общие свойства характеристик';
										|en = 'Common characteristic properties'"));
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		
		НаборСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "НаборСвойствХарактеристик");
		Наборы.Добавить(НаборСвойств, НСтр("ru = 'Свойства характеристик для вида номенклатуры';
											|en = 'Characteristic properties for product kind '"));
		
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Владелец);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НаборСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.ВидНоменклатуры, "НаборСвойствХарактеристик");
			Наборы.Добавить(НаборСвойств, НСтр("ru = 'Свойства характеристик для номенклатуры';
												|en = 'Characteristic properties for products '"));
		КонецЕсли;
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат Наборы;
	
КонецФункции // ПолучитьНаборыСвойствДляХарактеристикНоменклатуры()

Функция ПолучитьНаборыСвойствДляСерииНоменклатуры(Объект)
	
	Наборы = Новый СписокЗначений;
	//++ НЕ ГОСИС
	НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_СерииНоменклатуры_Общие;
	Наборы.Добавить(НаборСвойств, НСтр("ru = 'Общие свойства';
										|en = 'Common properties'"));
	
	НаборСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВидНоменклатуры, "НаборСвойствСерий");
	Наборы.Добавить(НаборСвойств, НСтр("ru = 'Свойства для шаблона серий номенклатуры';
										|en = 'Properties for product series template'"));
	//-- НЕ ГОСИС
	Возврат Наборы;
	
КонецФункции // ПолучитьНаборыСвойствДляНоменклатуры()
//++ НЕ ГОСИС
//++ НЕ УТ
 
////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ РАБОТЫ СО СПРАВОЧНИКОМ ОБЪЕКТЫ ЭКСПЛУАТАЦИИ

Функция ПолучитьНаборыСвойствДляОбъектаЭксплуатации(Объект)
	
	Наборы = Новый СписокЗначений;
	
	НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_ОбъектыЭксплуатации_Общие;
	Наборы.Добавить(НаборСвойств, НСтр("ru = 'Общие свойства объектов эксплуатации';
										|en = 'Common facility properties'"));
	//++ НЕ УТКА
	ПолучитьНаборыСвойствКлассаОбъектаЭксплуатации(Объект, Наборы);
	//-- НЕ УТКА
	
	Возврат Наборы;
	
КонецФункции

//++ НЕ УТКА
Функция ПолучитьНаборыСвойствДляУзлаОбъектаЭксплуатации(Объект)
	
	Наборы = Новый СписокЗначений;
	
	НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_УзлыОбъектовЭксплуатации_Общие;
	Наборы.Добавить(НаборСвойств, НСтр("ru = 'Общие свойства узлов';
										|en = 'Node common properties'"));
	ПолучитьНаборыСвойствКлассаОбъектаЭксплуатации(Объект, Наборы);
	
	Возврат Наборы;
	
КонецФункции

Процедура ПолучитьНаборыСвойствКлассаОбъектаЭксплуатации(Объект, Наборы)
	
	НаборыСвойств = Справочники.КлассыОбъектовЭксплуатации.ПолучитьНаборыСвойств(Объект.Класс);
	Наборы.Добавить(НаборыСвойств.ПаспортныеХарактеристики, НСтр("ru = 'Свойства по классификации';
																|en = 'Properties by classification'"));
	
КонецПроцедуры

Функция ПолучитьНаборыСвойствДляПроизводственнойОперации(Объект)
	
	Наборы = Новый СписокЗначений;
	
	НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.Документ_ПроизводственнаяОперация2_2_Общие;
	Наборы.Добавить(НаборСвойств, НСтр("ru = 'Общие свойства';
										|en = 'Common properties'"));
	
	Если НЕ Объект.ВидОперации.Пустая() Тогда
		НаборСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВидОперации, "НаборСвойств");
		Наборы.Добавить(НаборСвойств, НСтр("ru = 'Свойства для вида операции';
											|en = 'Property for operation kind'"));
	КонецЕсли;
	
	Возврат Наборы;
	
КонецФункции
//-- НЕ УТКА
//-- НЕ УТ
//-- НЕ ГОСИС

/////////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления для включения/отключения использования свойств у объектов

Процедура УстановитьИспользованиеСвойств_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура УстановитьИспользованиеСвойств_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыНабора = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
	
//++ НЕ ГОСИС
	
	//Сертификаты номенклатуры
	ПараметрыНабора.Используется = Константы.ИспользоватьСертификатыНоменклатуры.Получить();	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Справочник_СертификатыНоменклатуры", ПараметрыНабора);
	
	//Внутреннее потребление товаров
	ПараметрыНабора.Используется = Константы.ИспользоватьВнутреннееПотребление.Получить();	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ВнутреннееПотреблениеТоваров", ПараметрыНабора);
	
	//Заказ на внутренее потребление
	ПараметрыНабора.Используется = Константы.ИспользоватьЗаказыНаВнутреннееПотребление.Получить();	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ЗаказНаВнутреннееПотребление", ПараметрыНабора);
	
	//Заказ на перемещение
	ПараметрыНабора.Используется = Константы.ИспользоватьЗаказыНаПеремещение.Получить();	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ЗаказНаПеремещение", ПараметрыНабора);
	
	//Заказ на сборку (разборку)
	ПараметрыНабора.Используется = Константы.ИспользоватьЗаказыНаСборку.Получить();	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ЗаказНаСборку", ПараметрыНабора);
	
	//Передача товаров между организациями
	ПараметрыНабора.Используется = Константы.ИспользоватьПередачиТоваровМеждуОрганизациями.Получить();	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ПередачаТоваровМеждуОрганизациями", ПараметрыНабора);
	
	//Расходный ордер на товары
	ПараметрыНабора.Используется = ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриОтгрузке");	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_РасходныйОрдерНаТовары", ПараметрыНабора);
	
	//Расходный ордер на товары
	ПараметрыНабора.Используется = ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриПоступлении");	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ПриходныйОрдерНаТовары", ПараметрыНабора);
	
//++ НЕ УТ

	//Заказ материалов в производство
	ПараметрыНабора.Используется = Константы.ИспользоватьПроизводство.Получить();
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ЗаказМатериаловВПроизводство", ПараметрыНабора);
	
	ПараметрыНабора.Используется = Константы.ИспользоватьУправлениеПроизводством2_2.Получить();
	// Партии производства
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Справочник_ПартииПроизводства", ПараметрыНабора);
	// Производство без заказа
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ПроизводствоБезЗаказа", ПараметрыНабора);
	// Распределение возвратных отходов
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_РаспределениеВозвратныхОтходов", ПараметрыНабора);
	
	//++ Локализация
	//Резервы
	Справочники.Резервы.УстановитьИспользованиеСвойств();
	//Объекты учета резервов предстоящих расходов
	Справочники.ОбъектыУчетаРезервовПредстоящихРасходов.УстановитьИспользованиеСвойств();
	
	ВнеоборотныеАктивыСлужебный.УстановитьПараметрыНабораСвойствВНА22();
	ВнеоборотныеАктивыСлужебный.УстановитьПараметрыНабораСвойствВНА24();
	//-- Локализация
	
//-- НЕ УТ
	
//++ НЕ УТКА
	//Заказ на ремонт
	ПараметрыНабора.Используется = Константы.ИспользоватьУправлениеРемонтами.Получить();	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ЗаказНаРемонт", ПараметрыНабора);
//-- НЕ УТКА
	
//-- НЕ ГОСИС
	
	Параметры.ОбработкаЗавершена = Истина
	
КонецПроцедуры

#КонецОбласти