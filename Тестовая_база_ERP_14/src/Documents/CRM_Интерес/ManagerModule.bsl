#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		Если НЕ Параметры.Свойство("Ключ") Тогда
			СтандартнаяОбработка = Ложь;
			Основание = Неопределено;
			Если Параметры.Свойство("Основание", Основание)  Тогда
				Если ТипЗнч(Основание) = Тип("СправочникСсылка.Партнеры") Тогда
					Параметры.Вставить("Партнер", Основание);
				КонецЕсли;
			ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") Тогда	
				Если Параметры.ЗначенияЗаполнения.Свойство("Партнер") Тогда
					Параметры.Вставить("Партнер", Параметры.ЗначенияЗаполнения.Партнер);
				КонецЕсли;
			КонецЕсли;
			Если НЕ CRM_ОбщегоНазначенияПовтИсп.ИспользоватьСтарыйИнтерфейс() Тогда
				ВыбраннаяФорма = "Обработка.CRM_МастерРегистрацииОбращения.Форма.ФормаНовая";
			Иначе	
				ВыбраннаяФорма = "Обработка.CRM_МастерРегистрацииОбращения.Форма.Форма";
			КонецЕсли;
		Иначе
			Если CRM_ОбщегоНазначенияПовтИсп.ИспользоватьСтарыйИнтерфейс() Тогда
				ВыбраннаяФорма = "Документ.CRM_Интерес.Форма.ФормаДокумента";
				СтандартнаяОбработка = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = "Интерес """+ Данные.Тема + """ от " + Формат(Данные.Дата, "ДФ=dd.MM.yyyy")
		+ ?(Данные.ОжидаемаяВыручка <> 0, ", " + Формат(Данные.ОжидаемаяВыручка, "ЧГ=3,0") +" "+ CRM_ОбщегоНазначенияПовтИсп.ПолучитьНаименованиеВалютыУправленческогоУчета(), "");
	
КонецПроцедуры
	
Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Тема");
	Поля.Добавить("ОжидаемаяВыручка");
	Поля.Добавить("Дата");
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Результат = Новый Массив;
	Если ЗначениеЗаполнено(Ссылка.КонтактноеЛицо) Тогда
		Результат.Добавить(Ссылка.КонтактноеЛицо);
	ИначеЕсли ЗначениеЗаполнено(Ссылка.Партнер) Тогда
		Результат.Добавить(Ссылка.Партнер);
	ИначеЕсли ЗначениеЗаполнено(Ссылка.ПотенциальныйКлиент) Тогда
		Результат.Добавить(Ссылка.ПотенциальныйКлиент);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Процедура Модуль_СоздатьЭлементыФормы(Форма) Экспорт
	
	ЭлементРодитель = Форма.Элементы.Найти("ГруппаРеквизитыЛево");
	ЭлементДокументОснование = Форма.Элементы.Найти("ДокументОснование");
	
	НовыйЭлемент = Форма.Элементы.Вставить("Соглашение", Тип("ПолеФормы"), ЭлементРодитель, ЭлементДокументОснование);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.Соглашение";
	НовыйЭлемент.Ширина = 36;
	НовыйЭлемент.РастягиватьПоГоризонтали = Ложь;
	НовыйЭлемент.УстановитьДействие("НачалоВыбора", "Подключаемый_СоглашениеНачалоВыбора");
	
	НовыйЭлемент = Форма.Элементы.Вставить("СделкаСКлиентом", Тип("ПолеФормы"), ЭлементРодитель, ЭлементДокументОснование);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.СделкаСКлиентом";
	НовыйЭлемент.Ширина = 36;
	НовыйЭлемент.РастягиватьПоГоризонтали = Ложь;
	
КонецПроцедуры

Процедура ЗаполнитьНовыеРеквизиты() Экспорт
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда 
	
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	CRM_Интерес.Ссылка КАК Ссылка,
		                      |	CRM_Интерес.Партнер КАК Партнер,
		                      |	CRM_Интерес.Организация КАК Организация
		                      |ИЗ
		                      |	Документ.CRM_Интерес КАК CRM_Интерес
		                      |ГДЕ
		                      |	НЕ CRM_Интерес.ПометкаУдаления
		                      |	И НЕ CRM_Интерес.Завершен
		                      |	И НЕ CRM_Интерес.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
		                      |	И CRM_Интерес.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)");
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
		Договор = CRM_ОбщегоНазначенияСервер.ПолучитьДоговорПартнера(Выборка.Партнер, Выборка.Организация);
			Если ЗначениеЗаполнено(Договор) Тогда
				ИнтересОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ИнтересОбъект.Договор = Договор;
				ИнтересОбъект.Валюта = Договор.ВалютаРасчетов;
				ВалютаРасчетовКурсКратность = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ИнтересОбъект.Дата, Новый Структура("Валюта", Договор.ВалютаРасчетов));
				ИнтересОбъект.Курс      = ?(ВалютаРасчетовКурсКратность.Курс = 0, 1, ВалютаРасчетовКурсКратность.Курс);
				ИнтересОбъект.Кратность = ?(ВалютаРасчетовКурсКратность.Кратность = 0, 1, ВалютаРасчетовКурсКратность.Кратность);
				ИнтересОбъект.ВидСкидкиНаценки = Договор.ВидСкидкиНаценки;
				ИнтересОбъект.ВидЦен = Договор.ВидЦен;
				ИнтересОбъект.Записать();
			КонецЕсли;
		КонецЦикла;
		
	Иначе
	
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	CRM_Интерес.Ссылка КАК Ссылка,
		                      |	CRM_Интерес.Партнер КАК Партнер,
		                      |	CRM_Интерес.Организация КАК Организация,
		                      |	CRM_Интерес.СделкаСКлиентом КАК СделкаСКлиентом,
		                      |	CRM_Интерес.Соглашение КАК Соглашение
		                      |ИЗ
		                      |	Документ.CRM_Интерес КАК CRM_Интерес
		                      |ГДЕ
		                      |	НЕ CRM_Интерес.ПометкаУдаления
		                      |	И НЕ CRM_Интерес.Завершен");
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			МодульCRM_Модуль_МетодыМодулейОбъектовДокументов = ОбщегоНазначения.ОбщийМодуль("CRM_Модуль_МетодыМодулейОбъектовДокументов");
			МодульCRM_Модуль_МетодыМодулейОбъектовДокументов.ЗаполнитьРанееСозданныйИнтерес(Выборка.Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
