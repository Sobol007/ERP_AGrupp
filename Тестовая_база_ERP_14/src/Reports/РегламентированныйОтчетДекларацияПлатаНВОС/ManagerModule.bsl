#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
		
	Если НаДату > '20130101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияРПН;
	КонецЕсли;
		
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение №2 к приказу Минприроды России от 09.01.2017 №3.";
	НоваяФорма.РедакцияФормы	  = "от 09.01.2017 № 3.";
	НоваяФорма.ДатаНачалоДействия = '20160101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));

	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2016Кв1" Тогда
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;

		Если ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Свойство("Расчет") Тогда
			Расчет = ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Расчет;
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			
			Для Каждого Страница Из Расчет Цикл
				Данные = Страница.Данные;
				
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.Период = Период;
				Сумма.ОКАТО  = Данные["П010"];
				Сумма.КБК    = "04811201010016000120";
				Сумма.Сумма  = Данные["П151"];
				
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.Период = Период;
				Сумма.ОКАТО  = Данные["П010"];
				Сумма.КБК    = "04811201070016000120";
				Сумма.Сумма  = Данные["П152"];
				
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.Период = Период;
				Сумма.ОКАТО  = Данные["П010"];
				Сумма.КБК    = "04811201030016000120";
				Сумма.Сумма  = Данные["П153"];
				
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.Период = Период;
				Сумма.ОКАТО  = Данные["П010"];
				Сумма.КБК    = "04811201041016000120";
				Сумма.Сумма  = Данные["П154"];
				Попытка
					Если Данные.Свойство("КодКБКОтходы") И ЗначениеЗаполнено(Данные["КодКБКОтходы"]) Тогда 
						Сумма.КБК = Данные["КодКБКОтходы"];
					КонецЕсли;
				Исключение
					Сумма.КБК    = "04811201041016000120";
				КонецПопытки;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТаблицаДанныхРеглОтчета;
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20080601 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151235", '20170109', "3",	"ФормаОтчета2016Кв1");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли