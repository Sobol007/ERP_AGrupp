
#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМЫ

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Устанавливаем отбор по текущему пользователю и статусам решений.
	СписокСостояний = Новый СписокЗначений;
	СписокСостояний.Добавить(Перечисления.CRM_СтатусыРешений.Утверждено);
	СписокСостояний.Добавить(Перечисления.CRM_СтатусыРешений.Устарело);
	Если CRM_БазаЗнанийСервер.ЕстьПраваАдминистратора() Тогда
		СписокСостояний.Добавить(Перечисления.CRM_СтатусыРешений.НаРассмотрении);
	КонецЕсли;	
	Для Каждого ЭлементОтбораГруппы Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если НЕ (ЭлементОтбораГруппы.Представление = "ОтборРешений") Тогда Продолжить; КонецЕсли;
		Для Каждого ЭлементОтбора Из ЭлементОтбораГруппы.Элементы Цикл
			Если ЭлементОтбора.Представление = "ОтборПоАвтору" Тогда
				ЭлементОтбора.ПравоеЗначение = Пользователи.АвторизованныйПользователь();
			ИначеЕсли ЭлементОтбора.Представление = "ОтборПоСтатусу" Тогда
				ЭлементОтбора.ПравоеЗначение = СписокСостояний;
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;	
	
	РежимВыбора = Параметры.РежимВыбора;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
// Процедура - обработчик события формы "ОбработкаОповещения".
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если (ИмяСобытия = "CRM_РешенияОбновлениеСправочника") И (Параметр = ТекущийВопрос) Тогда
		ЗаполнитьТекстВопросаHTML(Параметр);
	КонецЕсли;	
КонецПроцедуры // ОбработкаОповещения()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
// Процедура - обработчик события "Выбор" табличной части "Список".
//
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если РежимВыбора Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(ВыбраннаяСтрока);
	КонецЕсли;	
КонецПроцедуры // СписокВыбор()

&НаКлиенте
// Процедура - обработчик события "ПриАктивизацииСтроки" табличной части "Список".
//
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработчикСписокПриАктивизацииСтроки", 0.5, Истина);
КонецПроцедуры // СписокПриАктивизацииСтроки()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ОбработатьТекстHTML(Вопрос, ТекстHTML, ИдентификаторФормы)
	
	Кодировка = "utf-8";
	
	Если Не ПустаяСтрока(ТекстHTML) Тогда
		Если СтрЧислоВхождений(ТекстHTML,"<html") = 0 Тогда
			ТекстHTML = "<html>" + ТекстHTML + "</html>"
		КонецЕсли;
			ТаблицаФайлов = Взаимодействия.ПолучитьВложенияПисьмаСНеПустымИД(Вопрос);
		Если ТаблицаФайлов.Количество() Тогда			
			
			ДокументHTML = CRM_Взаимодействия.CRM_ЗаменитьИдентификаторыКартинокНаПутьКФайлам(ТекстHTML, ТаблицаФайлов, Кодировка,,ИдентификаторФормы);
			Возврат Взаимодействия.ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
			
		Иначе
			Возврат ТекстHTML;
		КонецЕсли;
		
	Иначе
		Возврат ТекстHTML;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПустоеОписание()
	Возврат
	"<html>
	|<head>  
	|<META http-equiv=Content-Type content=""text/html; charset=utf-8"">
	|<META content=""MSHTML 6.00.2800.1400"" name=GENERATOR>
	|<body scroll=""auto"">
	|</body>
	|</html>";
КонецФункции

&НаСервере
// Процедура заполняет поле формы "ТекстВопросаHTML".
//
// Параметры:
//	Вопрос	- СправочникСсылка	- Ссылка на вопрос.
//
Процедура ЗаполнитьТекстВопросаHTML(Вопрос)
	
	Если НЕ ЗначениеЗаполнено(Вопрос) Тогда Возврат; КонецЕсли;
	
	СтрокаПоиска	= "";
	ПозицияНачала	= Найти(Вопрос.ТекстВопросаHTML, "<body>") + 6;
	ТекстНачала		= Лев(Вопрос.ТекстВопросаHTML, ПозицияНачала);
	ПозицияКонца	= Найти(Вопрос.ТекстВопросаHTML, "</body>");
	ТекстКонца		= Сред(Вопрос.ТекстВопросаHTML, ПозицияКонца);
	ВопросТекстВопроса	= Сред(Вопрос.ТекстВопросаHTML, ПозицияНачала, ПозицияКонца - ПозицияНачала - 1);
	ВопросТекстВопроса	= СокрЛП(ВопросТекстВопроса);
	ВопросТекстВопроса	= СтрЗаменить(ВопросТекстВопроса, Символы.ПС, "");
	ВопросТекстВопроса	= СтрЗаменить(ВопросТекстВопроса, "</p><p></p><p>", "</p><p>");
	
	// Добавляем текст вопроса
	ТекстПоляHTML = ТекстНачала + "<p><u><b>" + Нстр("ru='Вопрос: '") + "</b>" 
	+ CRM_БазаЗнанийСервер.бзВыделитьВхожденияСтрокиПоиска(Вопрос.Наименование, СтрокаПоиска) + "</u></p><p><b>"; 
	Если ЗначениеЗаполнено(Вопрос.ОсновнаяКатегория) Тогда
		ТекстПоляHTML	= ТекстПоляHTML + Нстр("ru='Основная категория: '") + "</b>" 
			+ CRM_БазаЗнанийСервер.бзВыделитьВхожденияСтрокиПоиска(Вопрос.ОсновнаяКатегория.Наименование, СтрокаПоиска) + "</p><p><b>";
	Иначе
		ТекстПоляHTML	= ТекстПоляHTML + Нстр("ru='Основная категория: '") + "</b>" + НСтр("ru='[не задана]';en='[not specified]'") + "</p><p><b>";
	КонецЕсли;	
	Если ЗначениеЗаполнено(Вопрос.Проект) Тогда
		ТекстПоляHTML	= ТекстПоляHTML + Нстр("ru='Проект: '") + "</b>" 
			+ CRM_БазаЗнанийСервер.бзВыделитьВхожденияСтрокиПоиска(Вопрос.Проект.Наименование, СтрокаПоиска) + "</p><p><b>"; 
	Иначе
		ТекстПоляHTML	= ТекстПоляHTML + Нстр("ru='Проект: '") + "</b>" + НСтр("ru='[не задан]';en='[not specified]'") + "</p><p><b>"; 
	КонецЕсли;	
	Если ЗначениеЗаполнено(Вопрос.Автор) Тогда
		ТекстПоляHTML	= ТекстПоляHTML + Нстр("ru='Автор: '") + "</b>" 
			+ CRM_БазаЗнанийСервер.бзВыделитьВхожденияСтрокиПоиска(Вопрос.Автор.Наименование, СтрокаПоиска) + "</p>";
	Иначе
		ТекстПоляHTML	= ТекстПоляHTML + Нстр("ru='Автор: '") + "</b>" + НСтр("ru='[не задан]';en='[not specified]'") + "</p>";
	КонецЕсли;	
	ТекстПоляHTML	= ТекстПоляHTML + CRM_БазаЗнанийСервер.бзВыделитьВхожденияСтрокиПоиска(ВопросТекстВопроса, СтрокаПоиска);
	
	Если (Вопрос.СтатусРешения = Перечисления.CRM_СтатусыРешений.Личное) И НЕ (Вопрос.Автор = Пользователи.АвторизованныйПользователь()) Тогда
		ТекстПоляHTML = ТекстПоляHTML + ТекстКонца;
	ИначеЕсли Вопрос.СтатусРешения = Перечисления.CRM_СтатусыРешений.НаРассмотрении Тогда
		ТекстПоляHTML = ТекстПоляHTML + ТекстКонца;
	Иначе
		// Заполняем тексты всех ответов и сортируем их.
		НомерОтвета = 0;
		Для Каждого ТекОтвет Из Вопрос.Ответы Цикл
			НомерОтвета = НомерОтвета + 1;
			
			ПозицияНачала	= Найти(ТекОтвет.ВариантОтветаHTML, "<body>") + 6;
			ПозицияКонца	= Найти(ТекОтвет.ВариантОтветаHTML, "</body>");
			ТекстОтвета		= Сред(ТекОтвет.ВариантОтветаHTML, ПозицияНачала, ПозицияКонца - ПозицияНачала - 1);
			ТекстОтвета		= СокрЛП(ТекстОтвета);
			ТекстОтвета		= СтрЗаменить(ТекстОтвета, Символы.ПС, "");
			ТекстОтвета		= СтрЗаменить(ТекстОтвета, "</p><p></p><p>", "</p><p>");
			
			// Добавляем текст ответа
			ТекстПоляОтветаHTML = "<p></p><p><u><b>" + Нстр("ru='Ответ №:';en='Answer No.:'") + Строка(НомерОтвета) + " ";
			Если ТекОтвет.СтатусОтвета = Перечисления.CRM_СтатусыРешений.Устарело Тогда
				ТекстПоляОтветаHTML = ТекстПоляОтветаHTML + Нстр("ru='(устаревший)';en='(out of date)'") + " ";
			КонецЕсли;
			ТекстПоляОтветаHTML = ТекстПоляОтветаHTML + "</b>" 
			+ CRM_БазаЗнанийСервер.бзВыделитьВхожденияСтрокиПоиска(ТекОтвет.НаименованиеОтвета, СтрокаПоиска) + "</u></p><p><b>"; 
			АвторИзменения = ТекОтвет.АвторИзменения;
			Если ЗначениеЗаполнено(АвторИзменения) Тогда
				ТекстПоляОтветаHTML = ТекстПоляОтветаHTML + НСтр("ru='Автор: '") + "</b>" 
				+ CRM_БазаЗнанийСервер.бзВыделитьВхожденияСтрокиПоиска(АвторИзменения.Наименование, СтрокаПоиска) + "</p>";
			Иначе
				ТекстПоляОтветаHTML = ТекстПоляОтветаHTML + НСтр("ru='Автор: '") + "</b>" + НСтр("ru='[не задан]';en='[not specified]'") + "</p>";
			КонецЕсли;	
			ТекстПоляОтветаHTML = ТекстПоляОтветаHTML + CRM_БазаЗнанийСервер.бзВыделитьВхожденияСтрокиПоиска(ТекстОтвета, СтрокаПоиска);
			ТекстПоляHTML	= ТекстПоляHTML + ТекстПоляОтветаHTML;
		КонецЦикла;
		ТекстПоляHTML = ТекстПоляHTML + ТекстКонца;
	КонецЕсли;
	
	ТекстВопроса = ОбработатьТекстHTML(Вопрос, ТекстПоляHTML, УникальныйИдентификатор);
	
КонецПроцедуры // ЗаполнитьТекстВопросаHTML()

&НаКлиенте
// Процедура - обработчик события "ПриАктивизацииСтроки" табличной части "Список".
//
// Параметры:
//	Нет.
//
Процедура ОбработчикСписокПриАктивизацииСтроки()
	
	Если ТекущийВопрос = Элементы.Список.ТекущаяСтрока Тогда Возврат; КонецЕсли;
	
	ТекущийВопрос = Элементы.Список.ТекущаяСтрока;
	
	Если ТекущийВопрос = Неопределено Тогда 
		ТекстВопроса = СформироватьПустоеОписание();
	Иначе
		ЗаполнитьТекстВопросаHTML(ТекущийВопрос);
	КонецЕсли;
	
КонецПроцедуры // ОбработчикСписокПриАктивизацииСтроки()

#КонецОбласти
