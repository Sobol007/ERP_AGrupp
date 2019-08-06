
////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции общего назначения клиент и сервер (из БСП для Софтфона)
//  
////////////////////////////////////////////////////////////////////////////////
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
//  Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных                 - ЛюбаяСсылка - Ссылка на объект информационной базы, к которому
//                                             это сообщение относится, или ключ записи.
//  Поле                       - Строка - наименование реквизита формы.
//  ПутьКДанным                - Строка - путь к данным (путь к реквизиту формы).
//  Отказ                      - Булево - Выходной параметр. Всегда устанавливается в значение Истина.
//
// 
Процедура сфпСообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных = Неопределено,
		Знач Поле = "",
		Знач ПутьКДанным = "",
		Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	ЭтоОбъект = Ложь;
	
#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
	Если КлючДанных <> Неопределено
	   И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
		ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
		ЭтоОбъект = Найти(ТипЗначенияСтрокой, "Object.") > 0;
	КонецЕсли;
#КонецЕсли
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
		
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

// Возвращает текущего пользователя или текущего внешнего пользователя,
// в зависимости от того, кто выполнил вход в сеанс.
//  Рекомендуется использовать в коде, который поддерживает работу в обоих случаях.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи - пользователь
//    или внешний пользователь.
//
Функция сфпАвторизованныйПользователь() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ТекПользователь = ПараметрыСеанса["ТекущийПользователь"];
	Исключение
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ТекПользователь) Тогда
		Возврат ТекПользователь;
	Иначе
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
#Иначе
	Возврат ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
#КонецЕсли
	
КонецФункции

// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями.
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ.
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//
// Возвращаемое значение:
//  Массив - массив строк.
//
Функция сфпРазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено) Экспорт
	
	Результат = Новый Массив;
	
	// для обеспечения обратной совместимости
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Результат.Добавить(Подстрока);
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Результат.Добавить(Строка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

// Формирует строковое представление телефона.
//
// Параметры:
//    КодСтраны     - Строка - код страны.
//    КодГорода     - Строка - код города.
//    НомерТелефона - Строка - номер телефона.
//    Добавочный    - Строка - добавочный номер.
//    Комментарий   - Строка - комментарий.
//
// Возвращаемое значение - Строка - представление телефона.
//
Функция сфпСформироватьПредставлениеТелефона(КодСтраны, КодГорода, НомерТелефона, Добавочный, Комментарий) Экспорт
	
	Представление = СокрЛП(КодСтраны);
	Если Не ПустаяСтрока(Представление) И Лев(Представление,1)<>"+" Тогда
		Представление = "+" + Представление;
	КонецЕсли;
	
	Если Не ПустаяСтрока(КодГорода) Тогда
		Представление = Представление + ?(ПустаяСтрока(Представление), "", " ") + "(" + СокрЛП(КодГорода) + ")";
	КонецЕсли;
	
	Если Не ПустаяСтрока(НомерТелефона) Тогда
		Представление = Представление + ?(ПустаяСтрока(Представление), "", " ") + СокрЛП(НомерТелефона);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Добавочный) Тогда
		Представление = Представление + ?(ПустаяСтрока(Представление), "", ", ") + "доб. " + СокрЛП(Добавочный);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Комментарий) Тогда
		Представление = Представление + ?(ПустаяСтрока(Представление), "", ", ") + СокрЛП(Комментарий);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Процедура использует пустой обработчик оповещения для случая, когда обработчик обязателен, 
// но фактически он ничего делать не должен.
// Параметры:
//  Результат				 - Строка	 - результат обработки.
//  ДополнительныеПараметры	 - Структура - переданные параметры.
// 
Процедура сфпОбработчикОповещенияБезДействия(Результат, ДополнительныеПараметры) Экспорт
	Возврат;
КонецПроцедуры

// Получает номер версии конфигурации без номера сборки.
//
// Параметры:
//  Версия - Строка - версия конфигурации в формате РР.ПП.ЗЗ.СС,
//                    где СС - номер сборки, который будет удален.
// 
// Возвращаемое значение:
//  Строка - номер версии конфигурации без номера сборки в формате РР.ПП.ЗЗ.
//
Функция ВерсияКонфигурацииБезНомераСборки(Знач Версия) Экспорт
	
	Массив = сфпСтрРазделить(Версия, ".");
	
	Если Массив.Количество() < 3 Тогда
		Возврат Версия;
	КонецЕсли;
	
	Результат = "[Редакция].[Подредакция].[Релиз]";
	Результат = СтрЗаменить(Результат, "[Редакция]",    Массив[0]);
	Результат = СтрЗаменить(Результат, "[Подредакция]", Массив[1]);
	Результат = СтрЗаменить(Результат, "[Релиз]",       Массив[2]);
	
	Возврат Результат;
КонецФункции

// Сравнить две строки версий.
//
// Параметры:
//  СтрокаВерсии1  - Строка - номер версии в формате РР.{П|ПП}.ЗЗ.СС.
//  СтрокаВерсии2  - Строка - второй сравниваемый номер версии.
//
// Возвращаемое значение:
//   Число   - больше 0, если СтрокаВерсии1 > СтрокаВерсии2; 0, если версии равны.
//
Функция СравнитьВерсии(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт
	
	Строка1 = ?(ПустаяСтрока(СтрокаВерсии1), "0.0.0.0", СтрокаВерсии1);
	Строка2 = ?(ПустаяСтрока(СтрокаВерсии2), "0.0.0.0", СтрокаВерсии2);
	Версия1 = сфпСтрРазделить(Строка1, ".");
	Если Версия1.Количество() <> 4 Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
			НСтр("ru='Неправильный формат параметра СтрокаВерсии1: %1';en='Invalid format for parameter СтрокаВерсии1: %1'"), СтрокаВерсии1);
	КонецЕсли;
	Версия2 = сфпСтрРазделить(Строка2, ".");
	Если Версия2.Количество() <> 4 Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
	    	НСтр("ru='Неправильный формат параметра СтрокаВерсии2: %1';en='Invalid format for parameter СтрокаВерсии2: %1'"), СтрокаВерсии2);
	КонецЕсли;
	
	Результат = 0;
	Для Разряд = 0 По 3 Цикл
		Результат = Число(Версия1[Разряд]) - Число(Версия2[Разряд]);
		Если Результат <> 0 Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Сравнить две строки версий.
//
// Параметры:
//  СтрокаВерсии1  - Строка - номер версии в формате РР.{П|ПП}.ЗЗ.
//  СтрокаВерсии2  - Строка - второй сравниваемый номер версии.
//
// Возвращаемое значение:
//   Число   - больше 0, если СтрокаВерсии1 > СтрокаВерсии2; 0, если версии равны.
//
Функция СравнитьВерсииБезНомераСборки(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт
	
	Строка1 = ?(ПустаяСтрока(СтрокаВерсии1), "0.0.0", СтрокаВерсии1);
	Строка2 = ?(ПустаяСтрока(СтрокаВерсии2), "0.0.0", СтрокаВерсии2);
	Версия1 = сфпСтрРазделить(Строка1, ".");
	Если Версия1.Количество() <> 3 Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
			НСтр("ru='Неправильный формат параметра СтрокаВерсии1: %1';en='Invalid format for parameter СтрокаВерсии1: %1'"), СтрокаВерсии1);
	КонецЕсли;
	Версия2 = сфпСтрРазделить(Строка2, ".");
	Если Версия2.Количество() <> 3 Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
	    	НСтр("ru='Неправильный формат параметра СтрокаВерсии2: %1';en='Invalid format for parameter СтрокаВерсии2: %1'"), СтрокаВерсии2);
	КонецЕсли;
	
	Результат = 0;
	Для Разряд = 0 По 2 Цикл
		Результат = Число(Версия1[Разряд]) - Число(Версия2[Разряд]);
		Если Результат <> 0 Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Возвращает значение свойства структуры.
//
// Параметры:
//   Структура - Структура, ФиксированнаяСтруктура - Объект, из которого необходимо прочитать значение ключа.
//   Ключ - Строка - Имя свойства структуры, для которого необходимо прочитать значение.
//   ЗначениеПоУмолчанию - Произвольный - Необязательный. Возвращается когда в структуре нет значения по указанному
//                                        ключу.
//       Для скорости рекомендуется передавать только быстро вычисляемые значения (например примитивные типы),
//       а инициализацию более тяжелых значений выполнять после проверки полученного значения (только если это
//       требуется).
//
// Возвращаемое значение:
//   Произвольный - Значение свойства структуры. ЗначениеПоУмолчанию если в структуре нет указанного свойства.
//
Функция СвойствоСтруктуры(Структура, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если Структура = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Результат = ЗначениеПоУмолчанию;
	Если Структура.Свойство(Ключ, Результат) Тогда
		Возврат Результат;
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции

// Заменяет в шаблоне строки имена параметров на их значения. Параметры в строке выделяются с двух сторон квадратными
// скобками.
//
// Параметры:
//  ШаблонСтроки - Строка    - строка, в которую необходимо вставить значения.
//  Параметры    - Структура - подставляемые значения параметров, где ключ - имя параметра без спецсимволов,
//                             значение - вставляемое значение.
//
// Возвращаемое значение:
//  Строка - строка со вставленными значениями.
//
// Пример:
//  Значения = Новый Структура("Фамилия,Имя", "Пупкин", "Вася");
//  Результат = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку("Здравствуй, [Имя] [Фамилия].", Значения);
//  - возвращает: "Здравствуй, Вася Пупкин".
//
Функция ВставитьПараметрыВСтроку(Знач ШаблонСтроки, Знач Параметры) Экспорт
	Результат = ШаблонСтроки;
	Для Каждого Параметр Из Параметры Цикл
		Результат = СтрЗаменить(Результат, "[" + Параметр.Ключ + "]", Параметр.Значение);
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Разбирает строку URI на составные части и возвращает в виде структуры.
// На основе RFC 3986.
//
// Параметры:
//  СтрокаURI - Строка - ссылка на ресурс в формате:
//                       <схема>://<логин>:<пароль>@<хост>:<порт>/<путь>?<параметры>#<якорь>.
//
// Возвращаемое значение:
//  Структура - составные части URI согласно формату:
//   * Схема         - Строка - схема из URI.
//   * Логин         - Строка - логин из URI.
//   * Пароль        - Строка - пароль из URI.
//   * ИмяСервера    - Строка - часть <хост>:<порт> из URI.
//   * Хост          - Строка - хост из URI.
//   * Порт          - Строка - порт из URI.
//   * ПутьНаСервере - Строка - часть <путь>?<параметры>#<якорь> из URI.
//
Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = Найти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;
	
	// Строка соединения и путь на сервере.
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = Найти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
	
	// Информация пользователя и имя сервера.
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = Найти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = Найти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = Найти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
		Если Не ТолькоЦифрыВСтроке(Порт) Тогда
			Порт = "";
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(ПустаяСтрока(Порт), Неопределено, Число(Порт)));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

// Проверяет, содержит ли строка только цифры.
//
// Параметры:
//  Значение         - Строка - проверяемая строка.
//  Устаревший       - Булево - устаревший параметр, не используется.
//  ПробелыЗапрещены - Булево - если Ложь, то в строке допустимо наличие пробелов.
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
// Пример:
//  Результат = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке("0123"); // Истина
//  Результат = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке("0123abc"); // Ложь
//  Результат = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке("01 2 3",, Ложь); // Истина
//
Функция ТолькоЦифрыВСтроке(Знач Значение, Знач Устаревший = Истина, Знач ПробелыЗапрещены = Истина) Экспорт
	
	Если ТипЗнч(Значение) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ПробелыЗапрещены Тогда
		Значение = СтрЗаменить(Значение, " ", "");
	КонецЕсли;
		
	Если СтрДлина(Значение) = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка.
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы.
	Возврат СтрДлина(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
			Значение, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", "")) = 0;
	
КонецФункции
		
// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  ШаблонСтроки  - Строка - шаблон строки с параметрами (вхождениями вида "%<номер параметра>", например, "%1 пошел в %2").
//  Параметр1   - Строка - значение подставляемого параметра.
//  Параметр2   - Строка - значение подставляемого параметра.
//  Параметр3   - Строка - значение подставляемого параметра.
//  Параметр4   - Строка - значение подставляемого параметра.
//  Параметр5   - Строка - значение подставляемого параметра.
//  Параметр6   - Строка - значение подставляемого параметра.
//  Параметр7   - Строка - значение подставляемого параметра.
//  Параметр8   - Строка - значение подставляемого параметра.
//  Параметр9   - Строка - значение подставляемого параметра.
//
// Возвращаемое значение:
//  Строка   - текстовая строка с подставленными параметрами.
//
Функция ПодставитьПараметрыВСтроку(Знач ШаблонСтроки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	ЕстьПараметрыСПроцентом = Найти(Параметр1, "%")
		Или Найти(Параметр2, "%")
		Или Найти(Параметр3, "%")
		Или Найти(Параметр4, "%")
		Или Найти(Параметр5, "%")
		Или Найти(Параметр6, "%")
		Или Найти(Параметр7, "%")
		Или Найти(Параметр8, "%")
		Или Найти(Параметр9, "%");
		
	Если ЕстьПараметрыСПроцентом Тогда
		Возврат ПодставитьПараметрыСПроцентом(ШаблонСтроки, Параметр1,
			Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	КонецЕсли;
	
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%1", Параметр1);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%2", Параметр2);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%3", Параметр3);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%4", Параметр4);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%5", Параметр5);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%6", Параметр6);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%7", Параметр7);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%8", Параметр8);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%9", Параметр9);
	Возврат ШаблонСтроки;
	
КонецФункции

// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
Функция ПодставитьПараметрыСПроцентом(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Результат = "";
	Позиция = Найти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл 
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = Неопределено;
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр = Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр = Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр = Параметр3;
		ИначеЕсли СимволПослеПроцента = "4" Тогда
			ПодставляемыйПараметр = Параметр4;
		ИначеЕсли СимволПослеПроцента = "5" Тогда
			ПодставляемыйПараметр = Параметр5;
		ИначеЕсли СимволПослеПроцента = "6" Тогда
			ПодставляемыйПараметр = Параметр6;
		ИначеЕсли СимволПослеПроцента = "7" Тогда
			ПодставляемыйПараметр = Параметр7
		ИначеЕсли СимволПослеПроцента = "8" Тогда
			ПодставляемыйПараметр = Параметр8;
		ИначеЕсли СимволПослеПроцента = "9" Тогда
			ПодставляемыйПараметр = Параметр9;
		КонецЕсли;
		Если ПодставляемыйПараметр = Неопределено Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		Позиция = Найти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
КонецФункции

// Дополняет структуру значениями из другой структуры.
//
// Параметры:
//   Приемник - Структура - коллекция, в которую будут добавляться новые значения.
//   Источник - Структура - коллекция, из которой будут считываться пары Ключ и Значение для заполнения.
//   Заменять - Булево, Неопределено - Что делать в местах пересечения ключей источника и приемника:
//                                       Истина - Заменять значения приемника (самый быстрый способ),
//                                       Ложь   - Не заменять значения приемника (пропускать),
//                                       Неопределено - Значение по умолчанию. Бросать исключение.
//
Процедура ДополнитьСтруктуру(Приемник, Источник, Заменять = Неопределено) Экспорт
	
	Для Каждого Элемент Из Источник Цикл
		Если Заменять <> Истина И Приемник.Свойство(Элемент.Ключ) Тогда
			Если Заменять = Ложь Тогда
				Продолжить;
			Иначе
				ВызватьИсключение ПодставитьПараметрыВСтроку(НСтр("ru='Пересечение ключей источника и приемника: ""%1"".';en='Intersection of source and receiver keys: ""%1"".'"), Элемент.Ключ);
			КонецЕсли
		КонецЕсли;
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

// Создает полную копию структуры, соответствия, массива, списка или таблицы значений, рекурсивно, 
// с учетом типов дочерних элементов. При этом содержимое значений объектных типов 
// (СправочникОбъект, ДокументОбъект и т.п.) не копируются, а возвращаются ссылки на исходный объект.
//
// Параметры:
//  Источник - Структура, Соответствие, Массив, СписокЗначений, ТаблицаЗначений - объект, который необходимо 
//             скопировать.
//
// Возвращаемое значение:
//  Структура, Соответствие, Массив, СписокЗначений, ТаблицаЗначений - копия объекта, переданного в параметре Источник.
//
Функция СкопироватьРекурсивно(Источник) Экспорт
	
	Перем Приемник;
	
	ТипИсточника = ТипЗнч(Источник);
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ТипИсточника = Тип("ТаблицаЗначений") Тогда
		Возврат Источник.Скопировать();
	КонецЕсли;
#КонецЕсли	
	Если ТипИсточника = Тип("Структура") Тогда
		Приемник = СкопироватьСтруктуру(Источник);
	ИначеЕсли ТипИсточника = Тип("Соответствие") Тогда
		Приемник = СкопироватьСоответствие(Источник);
	ИначеЕсли ТипИсточника = Тип("Массив") Тогда
		Приемник = СкопироватьМассив(Источник);
	ИначеЕсли ТипИсточника = Тип("СписокЗначений") Тогда
		Приемник = СкопироватьСписокЗначений(Источник);
	Иначе
		Приемник = Источник;
	КонецЕсли;
	
	Возврат Приемник;
	
КонецФункции

// Создает копию значения типа Структура, рекурсивно, с учетом типов значений свойств. 
// Если свойства структуры содержат значения объектных типов (СправочникОбъект, ДокументОбъект и т.п.),
// то их содержимое не копируются, а возвращаются ссылки на исходный объект.
//
// Параметры:
//  СтруктураИсточник - Структура - копируемая структура.
// 
// Возвращаемое значение:
//  Структура - копия исходной структуры.
//
Функция СкопироватьСтруктуру(СтруктураИсточник) Экспорт
	
	СтруктураРезультат = Новый Структура;
	
	Для Каждого КлючИЗначение Из СтруктураИсточник Цикл
		СтруктураРезультат.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
	
	Возврат СтруктураРезультат;
	
КонецФункции

// Создает копию значения типа Соответствие, рекурсивно, с учетом типов значений.
// Если значения соответствия содержат значения объектных типов (СправочникОбъект, ДокументОбъект и т.п.),
// то их содержимое не копируются, а возвращаются ссылки на исходный объект.
//
// Параметры:
//  СоответствиеИсточник - Соответствие - соответствие, копию которого необходимо получить.
// 
// Возвращаемое значение:
//  Соответствие - копия исходного соответствия.
//
Функция СкопироватьСоответствие(СоответствиеИсточник) Экспорт
	
	СоответствиеРезультат = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из СоответствиеИсточник Цикл
		СоответствиеРезультат.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
	
	Возврат СоответствиеРезультат;

КонецФункции

// Создает копию значения типа Массив, рекурсивно, с учетом типов значений элементов массива.
// Если элементы массива содержат значения объектных типов (СправочникОбъект, ДокументОбъект и т.п.),
// то их содержимое не копируются, а возвращаются ссылки на исходный объект.
//
// Параметры:
//  МассивИсточник - Массив - массив, копию которого необходимо получить.
// 
// Возвращаемое значение:
//  Массив - копия исходного массива.
//
Функция СкопироватьМассив(МассивИсточник) Экспорт
	
	МассивРезультат = Новый Массив;
	
	Для Каждого Элемент Из МассивИсточник Цикл
		МассивРезультат.Добавить(СкопироватьРекурсивно(Элемент));
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

// Создает копию значения типа СписокЗначений, рекурсивно, с учетом типов его значений.
// Если в списке значений есть значения объектных типов (СправочникОбъект, ДокументОбъект и т.п.),
// то их содержимое не копируются, а возвращаются ссылки на исходный объект.
//
// Параметры:
//  СписокИсточник - СписокЗначений - список значений, копию которого необходимо получить.
// 
// Возвращаемое значение:
//  СписокЗначений - копия исходного списка значений.
//
Функция СкопироватьСписокЗначений(СписокИсточник) Экспорт
	
	СписокРезультат = Новый СписокЗначений;
	
	Для Каждого ЭлементСписка Из СписокИсточник Цикл
		СписокРезультат.Добавить(
			СкопироватьРекурсивно(ЭлементСписка.Значение), 
			ЭлементСписка.Представление, 
			ЭлементСписка.Пометка, 
			ЭлементСписка.Картинка);
	КонецЦикла;
	
	Возврат СписокРезультат;
	
КонецФункции

// Вызывает исключение, если тип значения параметра ИмяПараметра процедуры или функции ИмяПроцедурыИлиФункции
// отличается от ожидаемого.
// Для диагностики типов параметров, передаваемых в процедуры и функции программного интерфейса.
//
// Параметры:
//   ИмяПроцедурыИлиФункции - Строка             - имя процедуры или функции, параметр которой проверяется.
//   ИмяПараметра           - Строка             - имя проверяемого параметра процедуры или функции.
//   ЗначениеПараметра      - Произвольный       - фактическое значение параметра.
//   ОжидаемыеТипы  - ОписаниеТипов, Тип, Массив - тип(ы) параметра процедуры или функции.
//   ОжидаемыеТипыСвойств   - Структура          - если ожидаемый тип - структура, то 
//                                                 в этом параметре можно указать типы ее свойств.
//
Процедура ПроверитьПараметр(Знач ИмяПроцедурыИлиФункции, Знач ИмяПараметра, Знач ЗначениеПараметра, 
	Знач ОжидаемыеТипы, Знач ОжидаемыеТипыСвойств = Неопределено) Экспорт
	
	Контекст = "ОбщегоНазначенияКлиентСервер.ПроверитьПараметр";
	Проверить(ТипЗнч(ИмяПроцедурыИлиФункции) = Тип("Строка"), 
		НСтр("ru='Недопустимо значение параметра ИмяПроцедурыИлиФункции';en='Invalid value of the ИмяПроцедурыИлиФункции parameter'"), Контекст);
	Проверить(ТипЗнч(ИмяПараметра) = Тип("Строка"), 
		НСтр("ru='Недопустимо значение параметра ИмяПараметра';en='Invalid value of the ИмяПараметра parameter'"), Контекст);
		
	ЭтоКорректныйТип = ЗначениеОжидаемогоТипа(ЗначениеПараметра, ОжидаемыеТипы);
	Проверить(ЭтоКорректныйТип <> Неопределено, 
		НСтр("ru='Недопустимо значение параметра ОжидаемыеТипы';en='Invalid value of parameter ОжидаемыеТипы'"), Контекст);
		
	НедопустимыйПараметр = НСтр("ru = 'Недопустимое значение параметра %1 в %2. 
		|Ожидалось: %3; передано значение: %4 (тип %5).'");
	Проверить(ЭтоКорректныйТип, ПодставитьПараметрыВСтроку(НедопустимыйПараметр,
		ИмяПараметра,
		ИмяПроцедурыИлиФункции,
		ПредставлениеТипов(ОжидаемыеТипы), 
		?(ЗначениеПараметра <> Неопределено, ЗначениеПараметра, НСтр("ru='Неопределено';en='It is not defin'")),
		ТипЗнч(ЗначениеПараметра)));
			
	Если ТипЗнч(ЗначениеПараметра) = Тип("Структура") И ОжидаемыеТипыСвойств <> Неопределено Тогда
		
		Проверить(ТипЗнч(ОжидаемыеТипыСвойств) = Тип("Структура"), 
			НСтр("ru='Недопустимо значение параметра ИмяПроцедурыИлиФункции';en='Invalid value of the ИмяПроцедурыИлиФункции parameter'"), Контекст);
			
		НетСвойства = НСтр("ru = 'Недопустимое значение параметра %1 (Структура) в %2. 
			|В структуре ожидалось свойство %3 (тип %4).'");
		НедопустимоеСвойство = НСтр("ru = 'Недопустимое значение свойства %1 в параметре %2 (Структура) в %3. 
			|Ожидалось: %4; передано значение: %5 (тип %6).'");
		Для каждого Свойство Из ОжидаемыеТипыСвойств Цикл
			
			ОжидаемоеИмяСвойства = Свойство.Ключ;
			ОжидаемыйТипСвойства = Свойство.Значение;
			ЗначениеСвойства = Неопределено;
			
			Проверить(ЗначениеПараметра.Свойство(ОжидаемоеИмяСвойства, ЗначениеСвойства), 
				ПодставитьПараметрыВСтроку(НетСвойства, ИмяПараметра, ИмяПроцедурыИлиФункции, ОжидаемоеИмяСвойства, ОжидаемыйТипСвойства));
				
			ЭтоКорректныйТип = ЗначениеОжидаемогоТипа(ЗначениеСвойства, ОжидаемыйТипСвойства);
			Проверить(ЭтоКорректныйТип, ПодставитьПараметрыВСтроку(НедопустимоеСвойство, 
				ОжидаемоеИмяСвойства,
				ИмяПараметра,
				ИмяПроцедурыИлиФункции,
				ПредставлениеТипов(ОжидаемыеТипы), 
				?(ЗначениеСвойства <> Неопределено, ЗначениеСвойства, НСтр("ru='Неопределено';en='It is not defin'")),
				ТипЗнч(ЗначениеСвойства)));
		КонецЦикла;
	КонецЕсли;		
	
КонецПроцедуры

// Вызывает исключение с текстом Сообщение, если Условие не равно Истина.
// Применяется для самодиагностики кода.
//
// Параметры:
//   Условие                - Булево - если не равно Истина, то вызывается исключение.
//   КонтекстПроверки       - Строка - например, имя процедуры или функции, в которой выполняется проверка.
//   Сообщение              - Строка - текст сообщения. Если не задан, то исключение вызывается с сообщением по
//                                     умолчанию.
//
Процедура Проверить(Знач Условие, Знач Сообщение = "", Знач КонтекстПроверки = "") Экспорт
	
	Если Условие <> Истина Тогда
		Если ПустаяСтрока(Сообщение) Тогда
			ТекстИсключения = НСтр("ru='Недопустимая операция';en='Invalid transaction'"); // Assertion failed
		Иначе
			ТекстИсключения = Сообщение;
		КонецЕсли;
		Если Не ПустаяСтрока(КонтекстПроверки) Тогда
			ТекстИсключения = ТекстИсключения + " " + ПодставитьПараметрыВСтроку(НСтр("ru='в %1';en='in %1'"), КонтекстПроверки);
		КонецЕсли;
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗначениеОжидаемогоТипа(Значение, ОжидаемыеТипы)
	ТипЗначения = ТипЗнч(Значение);
	Если ТипЗнч(ОжидаемыеТипы) = Тип("ОписаниеТипов") Тогда
		Возврат ОжидаемыеТипы.Типы().Найти(ТипЗначения) <> Неопределено;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Тип") Тогда
		Возврат ТипЗначения = ОжидаемыеТипы;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Массив") Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированныйМассив") Тогда
		Возврат ОжидаемыеТипы.Найти(ТипЗначения) <> Неопределено;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Соответствие") Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированноеСоответствие") Тогда
		Возврат ОжидаемыеТипы.Получить(ТипЗначения) <> Неопределено;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПредставлениеТипов(ОжидаемыеТипы)
	Если ТипЗнч(ОжидаемыеТипы) = Тип("Массив") Тогда
		Результат = "";
		Индекс = 0;
		Для Каждого Тип Из ОжидаемыеТипы Цикл
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ", ";
			КонецЕсли;
			Результат = Результат + ПредставлениеТипа(Тип);
			Индекс = Индекс + 1;
			Если Индекс > 10 Тогда
				Результат = Результат + ",... "
					+ ПодставитьПараметрыВСтроку(НСтр("ru='(всего %1 типов)'"), ОжидаемыеТипы.Количество());
				Прервать;	
			КонецЕсли;	
		КонецЦикла;
		Возврат Результат;
	Иначе
		Возврат ПредставлениеТипа(ОжидаемыеТипы);
	КонецЕсли;
КонецФункции

Функция ПредставлениеТипа(Тип)
	Если Тип = Неопределено Тогда
		Возврат "Неопределено";
	ИначеЕсли ТипЗнч(Тип) = Тип("ОписаниеТипов") Тогда
		ТипСтрокой = Строка(Тип);
		Возврат ?(СтрДлина(ТипСтрокой) > 150, Лев(ТипСтрокой, 150) + "..." 
			+ ПодставитьПараметрыВСтроку(НСтр("ru='(всего %1 типов)'"), Тип.Типы().Количество()), 
			ТипСтрокой);
	Иначе	
		ТипСтрокой = Строка(Тип);
		Возврат ?(СтрДлина(ТипСтрокой) > 150, Лев(ТипСтрокой, 150) + "...", ТипСтрокой);
	КонецЕсли;	
КонецФункции

// Разделяет переданную строку на массив строк по разделителю.
//
// Параметры:
//  Строка		 - Строка	 - исходная строка.
//  Разделитель	 - Строка	 - значение разделителя.
// 
// Возвращаемое значение:
//  Массив строк - разложенная строка.
// 
Функция сфпСтрРазделить(Строка, Разделитель) Экспорт
	
	Возврат сфпРазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
	
КонецФункции

// Проверяет соответствует ли начало строки переданной подстроке.
//
// Параметры:
//  Строка		 - Строка	 -  строка, где ищем.
//  СтрокаПоиска - Строка	 -  строка, которую ищем.
// 
// Возвращаемое значение:
//  Булево - результат проверки.
// 
Функция сфпСтрНачинаетсяС(Строка, СтрокаПоиска) Экспорт
	
	Возврат (Найти(СокрЛ(Строка), СтрокаПоиска) = 1);
	
КонецФункции

// Проверяет соответствует ли конец строки переданной подстроке.
//
// Параметры:
//  Строка		 - Строка	 -  строка, где ищем.
//  СтрокаПоиска - Строка	 -  строка, которую ищем. 
// 
// Возвращаемое значение:
//  Булево - результат проверки.
// 
Функция сфпСтрЗаканчиваетсяНа(Строка, СтрокаПоиска) Экспорт
	
	Возврат (Прав(Строка, СтрДлина(СтрокаПоиска)) = СтрокаПоиска);
	
КонецФункции

// Удаляет двойные кавычки с начала и конца строки, если они есть.
//
// Параметры:
//  Значение - Строка - входная строка.
//
// Возвращаемое значение:
//  Строка - строка без двойных кавычек.
// 
Функция сфпСократитьДвойныеКавычки(Знач Значение) Экспорт
	
	Пока сфпСтрНачинаетсяС(Значение, """") Цикл
		Значение = Сред(Значение, 2); 
	КонецЦикла; 
	
	Пока сфпСтрЗаканчиваетсяНа(Значение, """") Цикл
		Значение = Лев(Значение, СтрДлина(Значение) - 1);
	КонецЦикла;
	
	Возврат Значение;
	
КонецФункции

Функция ЕстьСимволыВНачалеВКонце(Строка, ПроверяемыеСимволы)
	Для Позиция = 1 По СтрДлина(ПроверяемыеСимволы) Цикл
		Символ = Сред(ПроверяемыеСимволы, Позиция, 1);
		СимволНайден = (Лев(Строка,1) = Символ) Или (Прав(Строка,1) = Символ);
		Если СимволНайден Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Функция СтрокаСодержитТолькоДопустимыеСимволы(Строка, ДопустимыеСимволы)
	МассивСимволов = Новый Массив;
	Для Позиция = 1 По СтрДлина(ДопустимыеСимволы) Цикл
		МассивСимволов.Добавить(Сред(ДопустимыеСимволы,Позиция,1));
	КонецЦикла;
	
	Для Позиция = 1 По СтрДлина(Строка) Цикл
		Если МассивСимволов.Найти(Сред(Строка, Позиция, 1)) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

// Проверяет email адрес на соответствие требованиям стандартов RFC 5321, RFC 5322,
// а также RFC 5335, RFC 5336 и RFC 3696.
// Кроме того, функция ограничивает использование спецсимволов.
// 
// Параметры:
//  Адрес - Строка - проверяемый email.
//  РазрешитьЛокальныеАдреса - Булево - не выдавать ошибку в случае отсутствия зоны домена в адресе.
//
// Возвращаемое значение:
//  Булево - Истина, если ошибок нет.
//
Функция АдресЭлектроннойПочтыСоответствуетТребованиям(Знач Адрес, РазрешитьЛокальныеАдреса = Ложь) Экспорт
	
	// Допустимые символы для email.
	Буквы = "abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя";
	Цифры = "0123456789";
	СпецСимволы = ".@_-:+";
	
	// проверяем символ @
	Если СтрЧислоВхождений(Адрес, "@") <> 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Разрешаем двоеточие только один раз.
	Если СтрЧислоВхождений(Адрес, ":") > 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// проверяем две точки подряд
	Если СтрНайти(Адрес, "..") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Приводим строку адреса к нижнему регистру.
	Адрес = НРег(Адрес);
	
	// Проверяем допустимые символы.
	Если Не СтрокаСодержитТолькоДопустимыеСимволы(Адрес, Буквы + Цифры + СпецСимволы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Разбираем адрес на local-part и domain.
	Позиция = СтрНайти(Адрес,"@");
	ЛокальноеИмя = Лев(Адрес, Позиция - 1);
	Домен = Сред(Адрес, Позиция + 1);
	
	// Проверяем на заполненность и допустимость длины.
	Если ПустаяСтрока(ЛокальноеИмя)
	 	Или ПустаяСтрока(Домен)
		Или СтрДлина(ЛокальноеИмя) > 64
		Или СтрДлина(Домен) > 255 Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	// Проверяем наличие спецсимволов в начале и в конце домена.
	Если ЕстьСимволыВНачалеВКонце(Домен, СпецСимволы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// В домене должна быть минимум одна точка.
	Если Не РазрешитьЛокальныеАдреса И СтрНайти(Домен,".") = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// В домене не должно быть символа подчеркивания.
	Если СтрНайти(Домен,"_") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// В домене не должно быть символа двоеточие.
	Если СтрНайти(Домен,":") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// В домене не должно быть символа "плюс".
	Если СтрНайти(Домен,"+") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Выделяем зону (TLD) из имени домена.
	Зона = Домен;
	Позиция = СтрНайти(Зона,".");
	Пока Позиция > 0 Цикл
		Зона = Сред(Зона, Позиция + 1);
		Позиция = СтрНайти(Зона,".");
	КонецЦикла;
	
	// Проверяем зону домена (минимум 2 символа, только буквы).
	Возврат РазрешитьЛокальныеАдреса Или СтрДлина(Зона) >= 2 И СтрокаСодержитТолькоДопустимыеСимволы(Зона,Буквы);
	
КонецФункции

#КонецОбласти

